---
title: "Clear-Claude clears a schedule's conversation and every local record of it, and Start-Claude types a command apart from its Enter"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/411
status: active
created: 2026-10-27
updated: 2026-10-27
---

# Plan: Clear-Claude clears a schedule's conversation and every local record of it, and Start-Claude types a command apart from its Enter

One pull request, from `feature/411-clear-claude-clear-a-schedule-s`, resolving #411 and #412. Not on a schedule.

## Summary

`/clear` gives a schedule no fresh start: the old conversation's transcript, memories, file history, prompt history
and the job's scratch files stay on disk, where the next conversation can read them. `Clear-Claude` clears a
schedule's conversation and removes every local record of it. With `--clear`, the default, the background session and
every connection to it go on, in a new conversation; with `--retire`, the background session goes too (#411).

`Clear-Claude` types `/clear` into a viewer, as `Start-Claude` types `/rename`. `Start-Claude` sends the command and
its Enter in one `send-keys`, and claude takes an Enter that arrives with the text as part of the command, which then
waits on the input line until someone presses return (#412). Both scripts type the text alone and press Enter apart
from it.

## Rulings

The owner, 2026-10-26 unless dated:

- Of the goal: the record of a conversation is to be removed so that a new one starts fresh, with nothing of the old
  one to read, while the schedule and its work are kept.
- Of the connections: "Ideally every session would recover after the removal." Hence `--clear` keeps the background
  session and every viewer.
- Of the forms: "--clear (default) or --retire." Of the name: "Remove is not the right verb"; `Clear-Claude` agreed.
- Of the arguments: `--schedule`, and `--directory` or `-C`, a repository root.
- Of the Enter: "you must be sure to put some time between the /rename or /clear and that Enter you send. Claude
  interprets the newline as part of the command ... I don't want to have to hit return myself." Then: "Update
  Start-Claude with the same Enter command."
- Of the process: the script was first written without one, at the owner's direction, in the base layer's clone. Then:
  "let's go through process to get the noblefactor-engprod updates in." The work moved into this worktree when it
  opened, and the clone's `Start-Claude` went back to develop's. This plan records work that preceded it.
- 2026-10-27, of Windows: "Clear-Claude.ps1 is not in this PR."
- 2026-10-27, of the phases: "There is no phase 2." The work is owed complete, "a complete pair of finely crafted
  scripts on the next commit", and not staged over later phases.

## Current State

At develop when this branch opened:

| Part | Today |
| --- | --- |
| Clearing a conversation | Nothing. `/clear` leaves the transcript and its folder, `memory/`, `file-history/<id>`, `session-env/<id>`, `/tmp/claude-<uid>/*/<id>`, the conversation's lines in `history.jsonl`, and `jobs/<short id>/tmp` |
| Typing a command | `Start-Claude`'s `rename_running` and `open_workspace`: `tmux send-keys -t <pane> "$rename" Enter`. `Start-Claude.ps1:1322` and `:1360`: `send-keys` with `$Rename` and `Enter` in one call |
| The test's viewer | `tests/Test-StartClaude.ps1`'s stand-in `claude attach` reads a whole line, so it accepts an Enter sent with the text, which claude does not |

## Requirements

### Requirement 1: A command, then its Enter (#412)

- `Start-Claude` and `Start-Claude.ps1` type a command into a viewer as literal text, wait until the viewer's input line
  (`❯`) shows it, wait one second more, and press Enter by itself. While the input line still shows the command, Enter
  is pressed again, up to three times in all.
- The test's stand-in viewer takes an Enter that arrives within 50 ms of the text before it as part of the text, as
  claude does, and submits only an Enter that follows a pause.

### Requirement 2: Clear-Claude (#411)

- `Clear-Claude [-C|--directory <directory>] -s|--schedule <schedule> [--clear | --retire]`, beside `Start-Claude`,
  sourcing `Declare-BashScript`, with its man page and its bash and zsh completions.
- `<schedule>` is `<owner>/<repository>#<number>`, or a bare `<number>` in the directory's repository. A schedule with
  no store entry has nothing to remove: exit 0.
- Both modes hold Start-Claude's store lock throughout, and refuse, with 75, to run inside the conversation they act on.
- `--clear`: the conversation's memories first, found by their `originSessionId`, with their index lines; then `/clear`
  typed into a viewer of the script's own, as Requirement 1 types; once claude lists a new conversation for the
  session, the old one's transcript and folder, file history, session environment, temporary output and prompt
  history; and the job folder's `tmp/`. When `/clear` starts no new conversation, nothing else is removed: exit 69.
- `--retire`: every viewer ends first, each a `claude attach <short id>` process where claude runs, so that nothing
  stands in front of it, a tmux pane, ssh, mosh or `sbx exec`, live or dead; then `claude stop` and `claude rm`; the
  records as for `--clear`, the job folder and the store entry; last, a check that claude no longer lists the session,
  which exits 75 when a connection restarted it.

### Requirement 3: The design

- `2-command-line.md` gains `Clear-Claude`'s forms, options and exit statuses.
- `1-session-model.md` gains how a conversation is cleared or retired; that a command is typed into a viewer apart from
  its Enter; and that every viewer is a `claude attach` process where claude runs.

## Testing

Each requirement's test was seen to fail before the code that makes it pass was in place, and the plan, the tests and
the code go in one commit (Rulings, 2026-10-27).

### Requirement 1, in `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1`

One table serves both scripts: `make test` runs `Test-StartClaude` here against `Start-Claude`, and
`make test HOSTS=danoble-wd11-3.local` runs `Test-StartClaude.ps1` on Windows against `Start-Claude.ps1`, through
psmux. Each has its own stand-in viewer, changed alike.

- The stand-in viewer reads key by key. An Enter that arrives within 50 ms of the text before it is part of the text,
  as with claude; only an Enter after a pause submits.
- Against develop's scripts, which send the command and Enter in one `send-keys`, the rename cases fail, the stand-in
  never receiving a submitted `/rename`, and every other case passes. With `type_command`, the rename cases pass.

### Requirement 2, in `tests/Test-ClearClaude`

In `Test-StartClaude`'s form, bash, run by `make test`:

- A stand-in `claude` on `PATH` answers `agents --json --all`, `attach`, `stop` and `rm`. Its viewer draws `❯` and
  applies Requirement 1's Enter rule, and its `/clear` gives the session a new conversation id.
- Each case runs in a scratch `CLAUDE_CONFIG_DIR`, store and tmux server, with ids no real session has, so that
  `pkill` and every removal touch only the test's own files.
- Without `Clear-Claude`, the test fails for want of the command; with it, every case passes.

| Case | Expected |
| --- | --- |
| No `--schedule`; a malformed one; `--clear` with `--retire` | Exit 64 |
| No store entry | Exit 0; nothing touched |
| `--clear` | The memories gone before `/clear` is typed, as the stand-in records; `/clear` submitted with no help; the old conversation's transcript and folder, file history, session environment, `/tmp` folder and prompt lines gone; the job's `tmp/` emptied; the new conversation, other conversations, the store entry and the session kept |
| `--clear`, `/clear` never taken | Exit 69; nothing removed |
| `--retire` | A stand-in viewer in the scratch tmux server ends; `stop` and `rm` called; the records, the job folder and the store entry gone; other conversations kept |
| Run inside the conversation | Exit 75; nothing removed |
| The store's lock held by another | Exit 75 |
| The session restarted during `--retire` | Exit 75 |

### Not covered

A real claude viewer, which the stand-in models; a real `claude rm`; Remote Control; the sandbox; and, on Windows,
`Start-Claude.ps1`'s typing, which runs only with `NFEP_AGENT_SCHEDULE_DETACHED_RENAME` set or a console attached. The
first real run is on a schedule of the owner's choosing.

## Implementation Phases

One phase, and then the merge: the owner, 2026-10-27, "There is no phase 2."

### Phase 1: The plan, the scripts, their tests and the design, in one commit

- [x] Requirement 1 (#412), here: with the new stand-in viewer and develop's `Start-Claude`, `make test` failed 2 of
      `Test-StartClaude`'s 31 cases, the two that type `/rename` (the detached rename and the attached one), each
      "'' was typed into a viewer", and passed the rest; with `type_command`, all 31 passed, and every other test
- [ ] Requirement 1 (#412), on Windows: `Send-ViewerCommand` in `Start-Claude.ps1`, clean under PSScriptAnalyzer.
      `make test HOSTS=danoble-wd11-3.local` passed with it, and passed with develop's too, because it runs no case
      that types: the detached rename runs only with `NFEP_AGENT_SCHEDULE_DETACHED_RENAME` set, and the attached one
      needs a console, which the host's run has none of. Its typing is untested until one of them runs
- [x] Requirement 2 (#411): without `Clear-Claude`, `Test-ClearClaude` failed, exit 1, at staging, for want of the
      command; with it, 6 of its 12 cases failed, on two defects the test found: the functions' `local session_id`
      and `local short_id` clashed with the script's read-only globals, which ended every `--clear` and `--retire` at
      once. With the functions' names changed, all 12 passed. Its man page and completions with it
- [x] Requirement 3: `2-command-line.md`, `1-session-model.md` and `index.md`, with both status companions; and
      Start-Claude(1), which says how a command is typed into a viewer
- [x] Reviewed with the owner, the plan and the work together, as committed in `ba2d28e`: approved 2026-10-27, "1 is
      done."

### Merge

- [x] `make check`, finished green as the PR script runs it, read before this box is ticked
- [x] PR script `~/Workspace/NobleFactor/noblefactor-engprod.411-clear-claude-clear-a-schedule-s.bash` written, shown,
      and handed over; the PR resolves #411 and #412. This box's commit is the pull request's last, and sets this
      plan `active`: it stays so after the merge while the Windows box above is open

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | Requirement 1 |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | Requirement 1 |
| `tests/Test-StartClaude` | Modify | Requirement 1: the stand-in viewer |
| `tests/Test-StartClaude.ps1` | Modify | Requirement 1: the stand-in viewer |
| `Home/common.Unix/.local/share/man/man1/Start-Claude.1` | Modify | Requirement 1 |
| `Home/common.Unix/.local/bin/Clear-Claude` | Create | Requirement 2 |
| `Home/common.Unix/.local/share/man/man1/Clear-Claude.1` | Create | Requirement 2 |
| `Home/common.Unix/.local/share/bash-completion/completions/Clear-Claude` | Create | Requirement 2 |
| `Home/common.Unix/.local/share/zsh/site-functions/_Clear-Claude` | Create | Requirement 2 |
| `tests/Test-ClearClaude` | Create | Requirement 2 |
| `docs/architecture/agent-schedule/2-command-line.md` | Modify | Requirement 3 |
| `docs/architecture/agent-schedule/1-session-model.md` | Modify | Requirement 3 |
| `docs/architecture/agent-schedule/1-session-model.status.md` | Modify | Requirement 3 |
| `docs/architecture/agent-schedule/2-command-line.status.md` | Modify | Requirement 3 |
| `docs/architecture/agent-schedule/index.md` | Modify | Requirement 3 |

## Open Questions

- [x] **`Clear-Claude.ps1`.** Windows has no `Clear-Claude`. Ruled 2026-10-27: not in this pull request.
- [ ] **The sandbox.** Once claude runs in an SBX microVM (`3-agent-sandbox.md`), `Clear-Claude` acts there, through
      `sbx exec`. Which sandbox: a `--sandbox` option, or the store's record of it once `Start-Claude` writes one? Not
      in this pull request; the owner's ruling, for its own issue.
