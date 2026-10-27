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

On a disposable background session, started with `claude --bg` in a scratch directory and removed with `claude rm`
afterwards: `/clear` typed as `type_command` types it, the screen captured after each key and each Enter, and
`claude agents --json --all` captured before and after. Recorded in this plan with claude's version: whether the menu
needs one Enter or two, what the input line shows meanwhile, and whether the same `id` reports a new `sessionId`, and
how soon. The stand-in viewer is made to behave as observed. If the real session does not report a new `sessionId`,
the script's success criterion is put to the owner before anything else changes.

### Requirement 2: Nothing removed before the clear is confirmed

- The memories are moved aside, with the index lines they own, before `/clear` is typed, since a new conversation
  reads the index as it starts; they are put back if the viewer cannot open, `/clear` is not taken, or the new
  conversation is not confirmed. Only once it is confirmed are they removed.
- The job's `tmp/` is emptied before `/clear`, not after, so that nothing the new conversation writes there goes.

### Requirement 3: Every check fails closed

- `conversation_of` validates what `claude agents` answers: JSON, a single background entry for the short id, and a
  `sessionId` that is a UUID. Malformed answers exit 65; a `claude agents` that fails exits 69.
- `--retire`'s last check assigns first and judges both outcomes: a failure to ask exits 69, a listed session 75.
- The script's own viewer is closed by an exit trap, on every path.
- The new conversation's id must be a UUID other than the old one.

### Requirement 4: Reach only this conversation

- A memory is matched on its `originSessionId` metadata field and the whole id, not a substring.
- Only memory folders this run emptied are removed.

### Requirement 5: The prompt history

The old conversation's prompts go, in both modes: after `/clear`, up-arrow in the same directory still offers them,
after the new conversation's (Claude Code's documented recall scopes, as the outside review reported them). Every
claude session on the host appends to `~/.claude/history.jsonl`, and no lock they honor covers it; but no process holds
it open between prompts (`lsof`, 2026-10-27), so each prompt is an open, an append and a close. The rewrite keeps the
old file open, writes a copy without the conversation's lines to a temporary file of its own beside it, renames the
copy into place, and appends whatever reached the old file meanwhile, read through the kept descriptor, until the old
file stops growing. Read and write failures stop it. Lines are matched on their parsed `sessionId`, not their text.
What remains is a window of microseconds: a writer that opened the old path just before the rename, and writes after
the last read.

### Requirement 6: The tests, fortified

Each case below is added to `tests/Test-ClearClaude` and seen to fail against `bbd6425` before its fix, where the case
can fail there:

| Case | Expected |
| --- | --- |
| `--clear`, the viewer cannot open | Exit 69; the memories and every record kept |
| `--clear`, `/clear` never taken | Exit 69; the memories, with their index lines, and every record kept |
| `--clear`, `claude agents` failing at the first lookup, while polling, or answering malformed JSON or a non-UUID id | Exit 69 or 65 as the man page names; nothing removed; no viewer left |
| `--clear` | As before, and the new conversation's files kept: the stand-in writes them |
| `--clear`, the stand-in's command menu as observed | `/clear` submitted with no help |
| A memory that only mentions the id in its body | Kept |
| An unrelated empty memory folder | Kept |
| `--retire`, `claude agents` failing at the last check | Exit 69, not 0 |
| No such directory; not a repository root | Exit 66 |
| A store entry that holds no session id | Exit 65 |
| The prompt history, a line appended while it is rewritten | The old conversation's lines gone, its JSON spaced or compact; the appended line kept; every other line kept byte for byte |
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

- [x] **1. The prompt history.** Ruled 2026-10-27: the old conversation's prompts go in both modes, by the rewrite
      Requirement 5 describes, with a case that appends while it runs.
- [ ] **2. The observation's cost.** Requirement 1 starts one disposable claude conversation and removes it.
