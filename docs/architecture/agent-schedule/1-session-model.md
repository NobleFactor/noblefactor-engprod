---
title: "1. Session model — every conversation in claude's background, a tmux session of its own for each start"
---

# 1. Session model — every conversation in claude's background, a tmux session of its own for each start

> **Status:** built 2026-10-15, in phase 33 of the [plan][plan-259],
> as 07413ae2, and accepted on the deployed scripts the same day, in phase 34; on Windows, on psmux, in
> David-Noble-at-work/personal#273, 2026-10-19. Companion: [`1-session-model.status.md`](1-session-model.status.md).
> Feature:
> [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151).
>
> **Relationship to the neighbors.** [The index](index.md) defines the terms. [2. Command line](2-command-line.md)
> owns Start-Claude's forms, names and store; this section owns how a conversation and its tmux sessions live.
> [3. Agent sandbox](3-agent-sandbox.md) moves this model into a Docker SBX sandbox.

This model replaced claude running in the tmux session's left pane, and the tmux session's id kept in the store
(the plan's questions 76 to 79).

## The model

1. **Every conversation runs in claude's background service** (question 76). None that Start-Claude starts runs in a
   terminal of its own.
2. **Every start opens a new tmux session onto it:** the viewer on the left, the user's shell on the right. No tmux
   session is reused, and the store keeps no tmux id (question 76).
3. **Each tmux session is named for its schedule's repository and number and its own id,** as in
   `devlore-cli#916 $34`, since tmux refuses a second session of one name and never reuses an id while its server
   runs (question 78), and psmux, on Windows, loses a session whose name carries `/` or `|`. One name serves both:
   the owner, 2026-10-16, "I like keeping the tmux session name the same everywhere" (personal#273's plan, question
   1). The id exists once the session does, so the session is made under a name tmux picks and then renamed.
4. **A tmux session ends when its last client goes:** Start-Claude sets `destroy-unattached` on each tmux session it
   opens (question 77). Its panes end with it, and the conversation runs on.
5. **The store keeps the background session's id** (question 78).
6. **A conversation's id, given with `--resume` or held by the store, is met where claude lists it** (question 78):
   - run by a background session: that session is attached, and its id stored;
   - running in the foreground: refused with 75;
   - running nowhere: started with `claude --bg --resume <id>`, which keeps the id, and the id claude prints stored.

   `claude --bg --resume` is never given an id claude already holds as a background session: it starts a copy under
   a new id.
7. **`--detach` starts the background session, or keeps it, and opens no tmux session** (question 78).
8. **Trust is claude's to check** (question 79). In a folder claude does not trust, `claude --bg` starts nothing and
   says what to do (seen 2026-10-15), so Start-Claude passes claude's words through and exits 69, having opened
   nothing. Start-Claude no longer reads claude's trust record.
9. **No startup hook** (question 78). Sync-ClaudeSession retires: the store holds an id claude keeps across `/clear`,
   and no tmux id to forget.
10. **The schedule's variables,** `NFEP_AGENT_SCHEDULE` and `NFEP_AGENT_SCHEDULE_URL`, reach the background session
    through an `env` block in `claude --bg --settings` (question 79; seen reaching a session's startup hook
    2026-10-15), since claude's background service starts a session without the environment of the command that
    starts it (seen 2026-10-14). The tmux session's shell pane gets them too; the viewer has no need of them.
    `star-gh-assignment` reads them (#260, requirements 1 and 2): the schedule's key from `NFEP_AGENT_SCHEDULE`, and
    from the session's name only when it is unset; its link from `NFEP_AGENT_SCHEDULE_URL`, or the link the key makes.
11. **`MOSH_SERVER_NETWORK_TMOUT` is the user's to set,** not Start-Claude's, and Start-Claude(1) names it (question
    77).

## The processes under ssh and under mosh

`├─` and `└─` are parent and child, read with `ps` on 2026-10-15; `──▶` is a connection over a socket. sshd's
processes were read on Danoble-MBP-A (macOS) and on danoble-ud24-1 (Linux), where sshd's listener stands between init
and them. The tmux client's place under ssh is from how Start-Claude attaches, not yet seen live.

```text
Under ssh
launchd (pid 1)
├─ sshd-session: <user> [priv]
│  └─ sshd-session: <user>@<tty>
│     └─ tmux client: tmux attach-session -t <session> ──▶ tmux server
├─ tmux server
│  └─ tmux session: one per start, destroy-unattached on
│     ├─ pane: claude attach <id>, the viewer ──▶ the conversation
│     └─ pane: the user's shell
└─ claude bg-pty-host
   └─ claude bg-spare: the conversation

Under mosh
launchd (pid 1)
├─ mosh-server new … -- Start-Claude …
│  └─ tmux client: tmux attach-session -t <session> ──▶ tmux server
├─ tmux server
│  └─ tmux session: one per start, destroy-unattached on
│     ├─ pane: claude attach <id>, the viewer ──▶ the conversation
│     └─ pane: the user's shell
└─ claude bg-pty-host
   └─ claude bg-spare: the conversation
```

Only the tmux client runs under the connection, so the tmux session outlives it unless `destroy-unattached` ends it.
Under ssh the client goes when sshd closes the terminal: when the connection ends, or when sshd notices it dropped,
which on these hosts, with no `ClientAliveInterval`, can take two hours. Under mosh it goes when mosh-server exits:
when the session's command ends, at Ctrl-^ then a period, when killed, or, with `MOSH_SERVER_NETWORK_TMOUT` set,
that long after its client was last heard from. A client that goes without a word, as when Blink Shell is quit,
leaves mosh-server waiting, the tmux client counted as attached, and the tmux session in place. The conversation is
a tree of its own and runs on in every case.

## A start, step by step

1. **The schedule and its entry.** The schedule comes from `--schedule`, and its entry from the store, read under
   the entry's lock.
2. **What is refused before anything starts:** a start with no terminal and no `--detach`, and, on macOS, a login
   keychain that stays locked. Each refusal says what to do instead.
3. **The background session.** The entry's id is looked up in claude's list, `claude agents --json --all`:
   - a background session of that id, running or stopped, is the schedule's, and `claude attach` restarts a stopped
     one under the same id (seen 2026-10-14); with `--detach`, `claude --bg --resume` of its conversation wakes it
     instead, and is given the launch's name, so that its title holds once it stops again (#260, requirement 3);
   - a conversation's id is met where claude lists it, as item 6 of the model says;
   - with no entry, `claude --bg` starts a new conversation in the startup directory, named for the schedule, with
     Remote Control unless `--no-remote-control` is given, the schedule's variables, and the arguments after `--`,
     which the session keeps. The id it prints is stored, since `--bg` takes no `--session-id`.

   When claude refuses a start, as in a folder it does not trust, its words are passed through, and the start exits
   69 with nothing opened.
4. **With `--detach`,** the start ends here and exits 0.
5. **The tmux session.** A new tmux session, named as item 3 says, with `destroy-unattached` on: the viewer on the
   left, and on the right the shell, which carries the schedule's variables. The terminal is attached to it, or,
   inside tmux, the current client is switched to it, and tmux ends the tmux session the client leaves when
   Start-Claude opened it (seen 2026-10-15). `destroy-unattached` is set once the client is attached: set on a tmux
   session no client has attached, tmux ends it at once (seen 2026-10-15).

## Leaving

- **Leaving the viewer,** with Escape or Ctrl+Z, ends its pane, and the tmux session with it (seen 2026-10-14).
  claude's background session runs on until `claude stop <id>`. `/exit` in a viewer does nothing.
- **Detaching,** with the tmux prefix and then d, leaves the tmux session with no client, so tmux ends it too, and
  whatever runs in its shell pane. No tmux session waits to be come back to: the next start opens a new one.
- **A lost connection** ends the tmux session once its client goes, as the processes above show.

## Moving a foreground conversation into the background

A conversation that runs in the foreground is refused with 75 (item 6). There are two ways to move it, and they
differ:

- **Exit it, then start again.** The start resumes it into the background with `claude --bg --resume <id>`, which
  keeps its id (seen 2026-10-14: "backgrounded · 494d1c62"). The store stays right.
- **`/bg` in claude** moves it to the background under a new id (seen 2026-10-14: `133560b3`), and the old id runs
  nowhere. The store still holds the old one, so the next start resumes the old conversation as a second copy, which
  goes its own way from the one in the background. That follows from the design; it has not been run.

So the refusal says to exit the conversation and start again, and not to `/bg` it (proposed).

## On psmux, on Windows

Start-Claude.ps1 runs this model on psmux, run as `tmux`, its alias (personal#273's plan, requirement 4). Four things
differ from tmux:

- **Names:** psmux can no longer find a session whose name carries `/` or `|`, by name or by id, so the name item 3
  gives serves both.
- **Pane targets carry their session,** as `$35:0.1`, since psmux looks a bare pane id up in another session.
- **Leaving the viewer ends its session through the viewer's own command,** `claude attach <id>; tmux kill-session`,
  since psmux never runs the `pane-died` hook Start-Claude sets on tmux.
- **`destroy-unattached` is set before the attach,** since psmux runs no command chained after `attach-session`, and
  keeps a session so set until a client comes, where tmux would end it at once.

It narrates and refuses as PowerShell does (personal#273's plan, question 6): what it does goes to the verbose stream,
and a refusal is a terminating error whose category follows the status Start-Claude gives the same refusal. With no
console and no `-Detach` it starts nothing, and inside psmux the current client switches to the new session.

## Running in a sandbox

The owner, 2026-10-15: "I am very pleased to say that we will be using Docker's SBX in the future." The design is
[3. Agent sandbox](3-agent-sandbox.md), the owner's draft and its open items, and the work is
NobleFactor/noblefactor-ops#305. What this design keeps there, and what changes:

- **Kept:** the store, keyed by schedule and holding the background session's id, on the host, with its lock; a tmux
  session of its own for each start, on the host, its viewer beside a shell, with `destroy-unattached` on; the
  refusals, claude's trust refusal among them.
- **Changed:** claude's background session runs inside the schedule's sandbox, and each tmux session's two panes
  reach into it through SBX: `claude attach <id>`, which finds claude's socket itself, and a private shell in the
  workspace. The store gains the sandbox's identifier. The main clones are read-only there, and edits are made in
  ephemeral worktrees.
- **Open:** trust, logins and the three kinds of claude configuration in a sandbox, among
  [the draft's open items](3-agent-sandbox.md#open).

## Open

None. The last item, Remote Control on a background session, closed 2026-10-15: the owner saw `24b62a42`, which
the new code had started with `--remote-control`, listed in the Claude app.


[plan-259]: https://github.com/David-Noble-at-work/personal/blob/main/docs/plans/chore/259-start-claude-documents-claude.md
