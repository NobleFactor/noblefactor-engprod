---
title: "Agent schedules — one conversation for each schedule, opened from anywhere"
---

# Agent schedules — one conversation for each schedule, opened from anywhere

> **Status:** design, 2026-10-15. The agent-schedule feature,
> [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151): its command line and
> its agent sandboxing. The [plan][plan-259],
> David-Noble-at-work/personal#259, holds the requirements, the phases and the owner's rulings, each quoted with its
> date; Start-Claude(1) is the reference for the options, the files and the exit statuses.

An agent schedule is a GitHub issue whose lane table says what to work next, and the Claude Code conversation that
works it. Start-Claude, the feature's command line today, starts that conversation in claude's background, or rejoins
it, and opens a tmux session onto it: the conversation on the left, a shell on the right.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. Session model](1-session-model.md) | Every conversation in claude's background, and a tmux session of its own for each start: the model, the processes under ssh and mosh, a start step by step, and leaving | [Built, 2026-10-15](1-session-model.status.md) |
| [2. Command line](2-command-line.md) | Start-Claude today: its forms, its names, its store, and Windows | [Built on macOS and Linux](2-command-line.status.md) |
| [2.1 The agent-schedule commands](2.1-agent-schedule-commands.md) | Get-, New-, Remove-, Set- and Start-AgentSchedule, with the owner's agent-assignment design | [Sketched](2.1-agent-schedule-commands.status.md) |
| [3. Agent sandbox](3-agent-sandbox.md) | Docker SBX: the owner's draft, the points it does not capture, and its open items | [Draft](3-agent-sandbox.status.md) |

## Terms

- **Background session:** a conversation as claude's background service runs it. It has an id of its own, the one
  `claude --bg` prints and `claude agents` lists, and keeps it across `/clear`, which gives the conversation a new
  one (seen 2026-10-14: `/clear` gave background session `a35d5856` the conversation `17112509`).
- **Conversation:** a Claude Code session, its transcript under `${CLAUDE_CONFIG_DIR:-~/.claude}/projects` and its id.
- **Schedule:** a GitHub issue, `<owner>/<repository>#<number>`, whose lane table says what to work next. One
  conversation works it.
- **Store:** one file per schedule, `${XDG_STATE_HOME:-~/.local/state}/agent-schedule/<owner>/<repository>/<number>`,
  which binds the schedule to its background session.
- **Viewer:** `claude attach <id>`, a client of a background session. Several attach at once (seen 2026-10-14).

## Where these documents go

The owner, 2026-10-15: "We might keep the start-claude design doc in personal and move all of the start-claude go to
noblefactor-ops in one go." Then, asked to choose between that and two pull requests, base and personal: "the
first." So they land here, with David-Noble-at-work/personal#259's pull request, and stay until Start-Claude,
Start-Claude.ps1 and the trees that support them move to noblefactor-ops, Start-Claude to `Home/common.Unix` and
Start-Claude.ps1 to `Home/common.Windows`, in one pull request; they move with them. That puts the agent-schedule
commands' design in noblefactor-ops, which NobleFactor/noblefactor-ops#302 asks for.

Their names follow devlore-cli's `docs/architecture`, each file numbered for the section of the feature it holds, with
a status companion beside it. The owner, 2026-10-15: "Consider renaming to match the devlore-cli docs tree with files
numbered by the section they contain within the feature that they represent." Then: "I like the tree structure. Go
for it."

[plan-259]: https://github.com/David-Noble-at-work/personal/blob/main/docs/plans/chore/259-start-claude-documents-claude.md
