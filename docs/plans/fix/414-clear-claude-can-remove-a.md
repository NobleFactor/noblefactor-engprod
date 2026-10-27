---
title: "Clear-Claude removes nothing before the clear is confirmed, fails closed, and reaches only its conversation"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/414
status: draft
created: 2026-10-27
updated: 2026-10-27
---

# Plan: Clear-Claude removes nothing before the clear is confirmed, fails closed, and reaches only its conversation

One pull request, from `fix/414-clear-claude-can-remove-a`, resolving #414, a bug in #413 (`bbd6425`, for #411). Not
on a schedule.

## Summary

An outside review of `bbd6425`, requested by the owner, found that `Clear-Claude`'s first real run could remove a
conversation's memories without clearing it, lose prompts other sessions append to the shared prompt history, report a
failed `--retire` as success, delete memories that only mention the conversation, and empty scratch the new
conversation has written. It also found two behaviors taken on faith: that `/clear`, typed as the script types it, is
submitted past claude's slash-command menu, and that `claude agents --json --all` then reports a new `sessionId` for
the same background session. Each defect was confirmed against the code. This plan observes the two behaviors on a
disposable real session first, fortifies the tests so that each defect has a case that fails against `bbd6425`, and
fixes the script so that those cases pass.

## Rulings

- 2026-10-27, the owner, of the fix's scope: "you should plan on fortifying the tests as well in this bug fix."
- 2026-10-27, of the prompt history: the old conversation's prompts go in both modes, through a rewrite that loses no
  line appended while it runs, with a test case that appends during it. Asked so, the owner: "yes."

## Current State

At `bbd6425`, `Home/common.Unix/.local/bin/Clear-Claude`:

| Where | What |
| --- | --- |
| `:364-370` | `--clear` removes the memories before the viewer opens and `/clear` is typed |
| `:104-128` | `type_command` takes the text leaving the input line as the command's submission |
| `:373-387` | Success waits on `claude agents` reporting another `sessionId`, any non-empty one, for 30 seconds; a failure while polling exits without closing the viewer |
| `:191-200` | `remove_prompts` rewrites `history.jsonl` through a fixed `.new` file and `mv`, matching compact JSON only, with `\|\| true` over read and write failures |
| `:158-180` | Memories matched by the substring `originSessionId: <id>` anywhere in the file; empty memory folders swept in every project |
| `:393-394` | The job's `tmp/` emptied after `/clear` |
| `:420-422` | `--retire`'s last check passes when `claude agents` fails |
| `:46-51` | `conversation_of` gives malformed JSON jq's status, not 65 |

`tests/Test-ClearClaude`'s stand-in viewer has no slash-command menu, and its `/clear` writes the new id itself. Its
twelve cases check none of the failures above.

## Requirements

### Requirement 1: What a real session does, observed first

Observed 2026-10-27, claude 2.1.311, on a disposable background session, `3e246d40`, started with
`claude --bg --name disposable-414` in the devlore-cli clone, with the owner's "approved. run"; its records were removed
by hand afterwards, its two prompt lines by Requirement 5's rewrite, that rewrite's first real use:

- The viewer drew its input line within a second of `claude attach`. `/clear`, sent with `send-keys -l`, showed on the
  input line 0.3 s later with claude's command menu open above it, `/clear` its one entry, highlighted; the same at
  1.3 s.
- One Enter, sent alone 1.3 s after the text, submitted it: the screen then showed `❯ /clear` as a turn and an empty
  input line, and `claude agents --json --all` listed the same `id` with a new `sessionId` 0.6 s after the Enter,
  `state` `done`.
- `claude stop`, then `claude rm`, removed the job folder and the listing and nothing else: both conversations'
  transcripts, the new one's folder, both `/tmp/claude-<uid>` folders and two prompt lines, filed under the old
  conversation, remained. So `--retire` removes those itself, and `/clear` typed into a viewer is recorded as a prompt
  of the conversation it clears.

`/rename <name>`, which Start-Claude types with the same helper, observed the same day on a second disposable
session, `42497548`, with the owner's "test your shit": sent as one argument, `/rename probe-414 renamed` showed on
the input line at 0.3 s with no menu, the argument having closed it; one Enter, alone, submitted it, the screen then
showing "Session renamed to: probe-414 renamed", and `claude agents` listing the new `name` 0.6 s after the Enter, the
`sessionId` unchanged. A first attempt sent the text as three `send-keys -l` arguments, which tmux joins with no
spaces: claude answered "Unknown command: /renameprobe-414renamed". The helpers pass one argument, so they are not
affected; the stand-in and the tests keep it so.

The stand-in viewer is made to behave as observed: a menu line above the input line while a bare `/clear` is typed,
none once a command has an argument, one Enter after a pause submitting, the command written to the prompt history
under the conversation it was typed into, `/rename` changing the listed name and `/clear` the `sessionId`, and the
new conversation's transcript and folder written.

### Requirement 2: Nothing removed before the clear is confirmed

- Before `/clear` is typed, the memories, the index lines they own and the job's `tmp/` entries are moved, not
  removed, into a staging folder of this run's own, `jobs/<short id>/clear-<time>/`, with a manifest naming each
  entry's original path. Moved, since a new conversation reads the index as it starts and would find the scratch.
- Once the new conversation is confirmed, the staging folder goes.
- When the viewer cannot open, or `/clear` is not taken, each staged entry goes back: an entry whose original path
  exists again, written meanwhile by another session or the conversation itself, is left staged and named, never
  overwritten; an index line is put back only where the index no longer has it.
- When `/clear` may have run but the listing then fails, the outcome is unknown: nothing goes back, nothing is removed,
  the staging folder and its manifest are named, and the script exits 75. The owner decides from there.
- The exit trap does this on every failure and on a signal. A staging folder an interrupted run left is named by the
  next run, which does not touch it.

### Requirement 3: Every check fails closed

- `conversation_of` tells four outcomes of `claude agents --json --all` apart: the command failing, 69; output that is
  not JSON, or holds two background entries for the short id, or one whose `sessionId` is missing or not a UUID, 65;
  a valid list with no background entry for the short id, absent; one entry with a UUID, present, with that id.
- `--retire`'s last check assigns first and succeeds on absent alone: present is 75, and the other two outcomes keep
  their statuses.
- The new conversation's id must be a UUID other than the old one.
- The script's own viewer is closed by the exit trap, on every path.

### Requirement 4: Reach only this conversation, inside claude's own tree

- A memory is matched on its `originSessionId` metadata field, in the frontmatter, and the whole id, not a substring.
- Only memory folders this run emptied are removed.
- Every path removed or staged is resolved first, and must lie under the resolved `CLAUDE_CONFIG_DIR` or
  `/tmp/claude-<uid>`: a project entry or job folder that is a symlink out of that tree is skipped and named, never
  followed.

### Requirement 5: The prompt history

The old conversation's prompts go, in both modes: after `/clear`, up-arrow in the same directory still offers them,
after the new conversation's (Claude Code's documented recall scopes, as the outside review reported them). Every
claude session on the host appends to `~/.claude/history.jsonl`, and no lock they honor covers it; but no process holds
it open between prompts (`lsof`, 2026-10-27), so each prompt is an open, an append and a close. The rewrite keeps the
old file open, writes a copy without the conversation's lines to a temporary file of its own beside it, renames the
copy into place, and appends whatever reached the old file meanwhile, read through the kept descriptor, until the old
file stops growing, for two seconds. Read and write failures stop it: before the rename, the file is untouched; after
it, the caught-up lines are saved beside it and named. Lines are matched on their parsed `sessionId`, not their text.
Two Clear-Claude runs are serialized by a lock of Clear-Claude's own beside the file.

What remains, corrected from the first draft's "a window of microseconds": a writer that opened the old path before
the rename and writes after the last read loses its line, and nothing bounds that delay, since nothing synchronizes
claude's writers. In practice a claude session opens, appends and closes in one go, and the catch-up outlasts that by
seconds; but the rewrite is not lossless, and the man page says so. Open question 1 is reopened on it.

### Requirement 6: The tests, fortified

Each case below is added to `tests/Test-ClearClaude` and seen to fail against `bbd6425` before its fix, where the case
can fail there:

| Case | Expected |
| --- | --- |
| `--clear`, the viewer cannot open | Exit 69; the memories, their index lines, the scratch and every record back |
| `--clear`, `/clear` never taken | Exit 69; the same, back |
| `--clear`, `claude agents` failing at the first lookup, or answering malformed JSON, two entries for the id, or a non-UUID id | Exit 69 or 65 as the man page names; nothing removed; no viewer left |
| `--clear`, `/clear` taken, then `claude agents` failing while polling | Exit 75; nothing removed, nothing back; the staging folder named |
| `--clear`, a staged memory's path written again, or its index line changed, by another session meanwhile, and `/clear` not taken | The new file and the changed index kept; the staged entry left staged and named |
| `--clear`, the run killed while polling | The trap puts every staged entry back |
| `--clear` | As before, with the new conversation's transcript and folder kept, and `/clear`'s own prompt line, under the old conversation, gone |
| `--clear`, the stand-in's command menu as observed | `/clear` submitted with no help |
| A memory that only mentions the id in its body | Kept |
| An unrelated empty memory folder | Kept |
| A project entry that is a symlink to a folder outside `CLAUDE_CONFIG_DIR` | Skipped and named; the outside folder untouched |
| `--retire`, `claude agents` failing at the last check | Exit 69, not 0 |
| `--retire`, the session absent from a valid list at the last check | Exit 0 |
| No such directory; not a repository root | Exit 66 |
| A store entry that holds no session id | Exit 65 |
| The prompt history, lines appended by two other sessions while it is rewritten, one by a writer that opened the old file before the rename and appends during the catch-up | The old conversation's lines gone, its JSON spaced or compact; every appended line kept; every other line kept byte for byte |
| The prompt history, a second Clear-Claude run while the first rewrites it | The second waits, then finds its own lines; nothing lost |
| The prompt history, unreadable or unwritable | Stopped, with the file as it was |

## Implementation Phases

### Phase 1: The plan

- [ ] This plan committed on `fix/414-clear-claude-can-remove-a` and reviewed with the owner

### Phase 2: The work, in one commit

- [ ] Requirement 1's observation, recorded here, and the stand-in made to match it
- [ ] Requirement 6's cases, seen to fail against `bbd6425`, where they can
- [ ] Requirements 2 to 5 in `Clear-Claude`, and its man page where it changes: every case passes
- [ ] `make check` passes

### Merge

- [ ] `make check`, finished green as the PR script runs it, read before this box is ticked
- [ ] PR script `~/Workspace/NobleFactor/noblefactor-engprod.414-clear-claude-can-remove-a.bash` written, shown, and
      handed over; the PR resolves #414. This box's commit, the pull request's last, sets this plan `complete`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common.Unix/.local/bin/Clear-Claude` | Modify | Requirements 2 to 5 |
| `Home/common.Unix/.local/share/man/man1/Clear-Claude.1` | Modify | What changes in its behavior and exit statuses |
| `tests/Test-ClearClaude` | Modify | Requirements 1 and 6 |
| `docs/architecture/agent-schedule/1-session-model.md` | Modify | What Requirement 1 observes |

## Open Questions

- [x] **1. The prompt history, reopened.** Ruled 2026-10-27 on the first draft, which called the remaining window
      "microseconds"; the outside review of `d836aaf` showed that nothing bounds it (Requirement 5). Ruled again
      2026-10-27, told that the window takes a claude session stalled between its open and its write for two seconds
      or more: "A", the rewrite goes in as Requirement 5 states it, its window stated in the man page.
- [x] **2. The observation's cost.** Approved and run 2026-10-27: "approved. run". The second, of `/rename <name>`,
      approved and run the same day: "test your shit". Both sessions' records removed by hand afterwards.
- [ ] **3. Start-Claude's completions** list schedules from the shell's directory, not `--directory`'s, so a bare
      number completed for another repository may name another schedule. The outside review found it; it is
      Start-Claude's, not this bug's, and goes to an issue of its own if the owner wants one.
