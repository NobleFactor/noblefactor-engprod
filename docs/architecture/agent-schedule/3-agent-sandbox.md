---
title: "3. Shared Claude Session with Private Terminals in Docker SBX"
---

# 3. Shared Claude Session with Private Terminals in Docker SBX

> **Status:** the owner's draft, 2026-10-15; not started. Companion:
> [`3-agent-sandbox.status.md`](3-agent-sandbox.status.md). Work:
> [NobleFactor/noblefactor-ops#305](https://github.com/NobleFactor/noblefactor-ops/issues/305). Feature:
> [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151).
>
> It is as the owner wrote it, its title numbered and its lines wrapped at 120 columns, up to "Implementation
> details to verify"; the sections after that were added the same day: the owner's points the draft does not
> capture, and the open items of Claude's review. [1. Session model](1-session-model.md) is the model it moves into
> a sandbox.

## Purpose

Run one shared Claude background process and multiple private client shells in the same Docker SBX microVM. Preserve the
existing client tmux layout and startup flow, changing process launch and attachment to go through SBX.

Each client sees the same Claude conversation in one pane and has an independent terminal session in another. Clients
can connect locally or remotely.

## Design decisions

- One logical Claude session maps to one SBX sandbox.
- One persistent Claude background process runs inside that sandbox.
- Every client attaches its Claude viewport to that same process using its session socket.
- Every client starts a separate shell inside the same sandbox.
- Each client's existing tmux instance supplies the two-pane layout.
- No tmux server is required inside the sandbox for this design.

The sandbox is shared by all clients of a logical session. A new client does not create a new sandbox or a new Claude
process.

## Architecture

This is a connection diagram, not a process ancestry tree. Attachment arrows cross the microVM boundary through the
configured transport.

```text
 CLIENT A                                  CLIENT B
 local or remote                           local or remote
 ┌──────────────────────┐                  ┌──────────────────────┐
 │ Existing client tmux │                  │ Existing client tmux │
 ├──────────────────────┤                  ├──────────────────────┤
 │ Claude viewport      │──────┐    ┌───────│ Claude viewport      │
 ├──────────────────────┤      │    │       ├──────────────────────┤
 │ Private terminal A   │──┐   │    │   ┌───│ Private terminal B   │
 └──────────────────────┘  │   │    │   │   └──────────────────────┘
                          │   │    │   │
                SBX execution / attachment transport
                          │   │    │   │
 ┌────────────────────────┼───┼────┼───┼──────────────────────────┐
 │ ONE SBX MICROVM        │   │    │   │                          │
 │                        │   ▼    ▼   │                          │
 │                        │  Claude session socket               │
 │                        │          │ │                          │
 │                        │          ▼ │                          │
 │                        │  Shared Claude background process    │
 │                        │            │                          │
 │                        ▼            ▼                          │
 │                  Client A shell   Client B shell              │
 │                                                               │
 │              Shared files, tools, network, Docker daemon       │
 └───────────────────────────────────────────────────────────────┘
```

The Claude viewport uses the existing Claude attachment mechanism. SBX provides the environment and execution path; the
design does not assume SBX itself implements Claude's session protocol.

## Session identity and lookup

The existing program data remains the source of truth for the association between a logical session and its sandbox.
Store or resolve:

| Field | Purpose |
| --- | --- |
| Logical session ID | Stable application identity for the shared conversation |
| Sandbox identifier | Selects the microVM for all launches and attachments |
| Sandbox user and home | Determines the Claude session discovery location and execution identity |
| Claude session identity | Selects the intended conversation when multiple session entries exist |
| Workspace path | Starting directory for Claude and client shells |

Resolve the live Claude socket from the session entries under `~/.Claude/sessions`, using the existing installation's
actual path, format, and attachment protocol. The path is supplied by the current system design and must be verified
during implementation; this document does not assert a universal Claude socket format.

Perform discovery in the sandbox's filesystem and as the intended user. A guest Unix socket path is not automatically a
usable host or remote-client socket address. Prefer running the existing viewport attachment client inside the sandbox
through SBX so it can access the socket directly. If the viewport must remain outside, retain or implement an explicit
transport for its protocol.

Discover the live socket at attachment time. Do not assume a cached socket path remains valid after Claude restarts.

## Startup and attachment flow

### Start the background session

1. Resolve or create the sandbox associated with the logical session.
2. Ensure the sandbox is running.
3. Start the existing Claude background process inside the sandbox through SBX, preserving its current
   background-service launch behavior.
4. Wait for Claude's session entry and socket to become ready.
5. Make the logical session available for client attachment.

Keep Claude lifecycle ownership in the existing background-session machinery. Starting Claude through SBX must preserve
its independence from client terminal connections. Merely backgrounding a host-side `sbx exec` invocation is not a
substitute for verifying that behavior.

Concurrent client startup must not start duplicate Claude processes. Use the existing session creation coordination, or
add a per-session lock if that coordination is missing.

### Attach a client

1. Query existing program data for the logical session's sandbox.
2. Resolve the intended Claude session and its current socket inside that sandbox.
3. Start the existing client tmux layout.
4. In the Claude pane, launch the viewport attachment client through SBX and connect it to the shared Claude socket.
5. In the terminal pane, launch a new interactive shell through SBX with a PTY and the configured workspace directory.

Every client repeats this attachment flow against the same sandbox. Each gets a distinct shell process and shell PTY.
All Claude viewports connect to the same Claude session.

Command shapes below are illustrative, not verified CLI syntax:

```text
Claude pane:   SBX_EXEC(sandbox, existing_viewport_attach(resolved_socket))
Terminal pane: SBX_EXEC_WITH_PTY(sandbox, shell, cwd=workspace)
```

For off-box clients, use the existing remote-access path to the SBX host. Resolve the sandbox and invoke SBX where that
runtime is available. Do not assume a local Unix socket can be opened directly from another machine.

## Shared and private state

| Resource | Scope |
| --- | --- |
| Claude process, conversation, and session socket | Shared across clients |
| Sandbox filesystem and workspace | Shared across clients |
| Network, installed tools, and sandbox Docker daemon | Shared across clients |
| Terminal shell process and PTY | Separate for each client |
| Current directory and shell-local variables | Separate for each client |
| Shell history files | Potentially shared, depending on shell configuration |
| Client tmux layout and connection | Separate for each client |

“Private terminal” means an independent shell session, not a security boundary. Clients in the same sandbox can affect
shared files and resources. Use distinct history files or disable history persistence if history must also remain
separate.

## Lifecycle and failure behavior

| Event | Expected behavior |
| --- | --- |
| Another client attaches | Reuse Claude; start another private shell |
| Client detaches from its still-running tmux | Pane connections and private shell remain active |
| A client's terminal pane closes | Its shell follows normal PTY closure behavior; Claude and other clients continue |
| Client transport is lost | Shared Claude remains running; private shell behavior depends on whether its tmux and exec connection survive |
| Claude restarts | Existing viewport connections fail; rediscover the current socket and reattach |
| Sandbox stops | Claude and all private shells stop |
| Sandbox is removed | Sandbox-local state is removed; mounted workspace data follows the configured storage model |

Private terminal persistence after loss of its owning client tmux or exec connection is outside the initial scope. If
required later, add a persistent PTY service for each client shell.

The shared Claude attachment mechanism must support the intended number of concurrent viewports. Preserve its existing
rules for simultaneous input; do not add a second Claude process to handle another viewer.

## Minimal implementation changes

1. Add or reuse the logical-session-to-sandbox association in program data.
2. Route the existing background Claude launch through SBX.
3. Add Claude session socket discovery in the sandbox.
4. Route the existing Claude viewport attachment through SBX to that socket.
5. Route each client's existing terminal launch through SBX with an interactive PTY.

Keep the existing tmux layout, remote access, and background-session management wherever possible. No generic terminal
socket registry, guest tmux layer, or additional agent service is required.

## Validation before rollout

- Open two clients and confirm their Claude panes show the same conversation and connect to one Claude process.
- Confirm their terminal panes have different shell PIDs and independent working directories.
- Create a file in one terminal and confirm Claude and the other terminal see it.
- Disconnect one client and confirm Claude and the other client's shell continue working.
- Attach from both on-box and off-box paths.
- Restart Claude and confirm attachment resolves its new live socket.
- Attempt simultaneous initial connections and confirm only one background Claude process starts.
- Confirm terminal resize, input, output, and interactive commands work through the SBX PTY path.

## Implementation details to verify

- Exact SBX CLI syntax and PTY behavior for the installed version.
- Exact Claude session directory, entry format, socket protocol, and supported multi-client behavior.
- Background Claude survival when the launch command or its transport exits.
- The sandbox identity and user context used for discovery and attachment.
- Existing recovery behavior when Claude or the sandbox is unavailable.

These checks determine the command-level integration. They do not change the architecture: one sandbox, one shared
Claude conversation, and one private shell per client.

## What the draft does not capture: configuration and worktrees

Added 2026-10-15: the owner's points, in words polished.

**Three kinds of claude configuration.**

1. **Deployed to all devices,** with writ, and under source control.
2. **Machine-specific,** as `projects` is, and not under source control.
3. **Ephemeral,** as sessions are: it lives and dies with an SBX instance.

**A sandbox for this workflow.**

- All main worktrees are read-only: base, team, personal, and others brought into the sandbox. A branch can be
  checked out; content cannot be added, removed or updated.
- All edits are made in secondary worktrees, as they are today, and these worktrees are ephemeral.
- claude's background session sockets must be reachable for this to work. They are ephemeral claude configuration:
  "We don't want to have to find a needle in a haystack."

## Open

Added 2026-10-15, from Claude's review of the draft. What was seen on Danoble-MBP-A is marked so; the rest is not
verified.

1. **No socket discovery.** `claude attach <id>`, run inside the sandbox through SBX, finds its own socket, and the
   agent-schedule store already holds the id: nothing searches for a socket, and nothing reads claude's internals, as
   question 79 of the Start-Claude plan rules. Claude Code 2.1.300 keeps its session entries in `~/.claude/sessions`,
   each with a `messagingSocketPath`, and its background service's sockets under `/tmp/cc-daemon-<uid>/` (seen
   2026-10-15); `~/.local/sessions` does not exist there. A viewer that ends is answered by the next start, and
   `claude attach` starts a stopped background session again under its id (seen 2026-10-14).
2. **The lifecycle table's detach row.** "Client detaches from its still-running tmux: pane connections and private
   shell remain active" does not hold with `destroy-unattached`, which Start-Claude sets on every tmux session it
   opens: a detach ends the tmux session and its shell (the plan's question 77). Recommended: keep
   `destroy-unattached`, and change the row.
3. **Read-only main worktrees against git.** A checkout rewrites a worktree's files and index, and
   `git worktree add`, and every commit made in a secondary worktree, write into the main clone's `.git`. So either
   the main worktrees are held read-only by policy rather than by a read-only mount, or the ephemeral worktrees are
   clones that borrow the main clones' objects without writing to them, as `git clone --shared` makes. Not tested.
4. **Unpushed work.** An ephemeral worktree dies with its sandbox: ending a sandbox pushes its branches first, or
   refuses.
5. **Trust.** claude starts nothing in its background in a folder it does not trust, and says so (seen 2026-10-15).
   A new sandbox trusts nothing, so either each takes one interactive run of claude per workspace, or the
   machine-specific configuration carries the trust in. This decides whether a sandbox can be made with no one there.
6. **Logins.** On macOS, gh and claude keep their logins in the login keychain, which Start-Claude unlocks
   (requirement 19 of its plan). A Linux microVM has none, and how the logins reach the sandbox, Remote Control's
   included, is not stated.
7. **One directory holds all three kinds of configuration.** claude keeps them mixed in `~/.claude` and
   `~/.claude.json`: deployed, as `settings.json`, `CLAUDE.md` and `skills/` are; machine-specific, as
   `.claude.json`'s projects and trust are; ephemeral, as `sessions/`, `jobs/`, `daemon*` and `/tmp/cc-daemon-*`
   are. A sandbox puts them together path by path. Open: which kind transcripts, `projects/`, are, which decides
   whether a conversation outlives its sandbox.
8. **The store.** The agent-schedule store, and its lock, stay on the host, and gain the draft's "Sandbox
   identifier": the entry's one line becomes structured, as the versioned metadata NobleFactor/noblefactor-ops#302
   proposes.
9. **SBX itself.** `sbx` is not installed on Danoble-MBP-A, and `docker` is (seen 2026-10-15). The command shapes are
   the draft's own, unverified, as it says.

## Where it fits

Part of the agent-schedule feature, NobleFactor/noblefactor-ops#151, whose design documents are this one, for agent
sandboxing, and [Start-Claude's](2-command-line.md), for the command line: Start-Claude today, and the agent-schedule
commands to come, NobleFactor/noblefactor-ops#302. The work is NobleFactor/noblefactor-ops#305. The owner,
2026-10-15: "They are all under the agent-schedule feature and include CLI and agent sandboxing elements." This
document moves to noblefactor-ops with Start-Claude, in one pull request.
