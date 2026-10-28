---
title: "Clear-Claude removes nothing before the clear is confirmed, fails closed, and reaches only its conversation"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/414
status: active
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

## Issue 415: Start-Claude's completions list schedules from the shell's repository

Found by the outside review, open question 3; ruled 2026-10-27, "fix the completion bug now", and "If you need a bug
log it": #415, resolved by this pull request with #414.

- Both completions, `completions/Start-Claude` and `_Start-Claude`, list the open schedules of the repository
  Start-Claude will read a bare number in: the one `-C`/`--directory` names earlier on the line, or else the working
  directory's. A directory that does not exist lists `new` alone.
- Checked 2026-10-27 against a stand-in `gh` that answers by the directory it runs in, 7 in one scratch repository and
  42 in another, from the first: bash completed `new 7` with no `--directory` and `new 42` with `--directory` or `-C`
  naming the second, `new` alone for a directory that is not there; before the fix, `new 7` in every case. The zsh
  completion passes `zsh --no-exec` and reads `--directory` from `_arguments`' `opt_args`; two headless harnesses
  failed to drive zsh's completion, so it is untested until a terminal tries
  `Start-Claude --directory <another clone> --schedule <Tab>`.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed on `fix/414-clear-claude-can-remove-a` and reviewed with the owner: its three questions ruled
      2026-10-27, and the work approved the same day, asked "Shall I start?": "yes"

### Phase 2: The work, in one commit

- [x] Issue 415's fix in both completions, checked as its section says; committed ahead of the rest, as ruled
- [x] Requirement 1's observations, recorded here, and the stand-in made to match them: the command menu, one Enter
      after a pause, the command recorded as a prompt of the old conversation, the new conversation's files written
- [x] Requirement 6's cases, 27 in all, run against `bbd6425`'s `Clear-Claude`: 14 failed, every case that could
      fail there. CI's macOS leg then failed the prompt-history case on pull request #417: the test's late writer
      was started with `setsid`, which macOS lacks, so its line was never written; started without it, in a second
      commit. The same commit makes the stand-in viewer judge an Enter by the input buffer, whether it was already
      waiting behind the key before it, rather than by the clock, after the "written again by another session" case
      failed once under `make check` with the hook not run, and passed three runs in a row with the buffer rule. A
      slower macOS runner then failed the prompt-history case and `Test-StartClaude`'s two typing cases alike, each
      viewer gone before its keys were read: both stand-ins waited two seconds for a key; they wait ten, and
      `Test-StartClaude`'s judges an Enter by the buffer too. The 13 that passed either refuse before anything
      runs, as `bbd6425` did too (usage, the directory, the store entry, no store entry, the listing failing at the
      first lookup, two entries and a non-UUID id, which its regex refused, inside the conversation, the store's
      lock), or found what it already did (a restarted session under `--retire`)
- [x] Requirements 2 to 5 in `Clear-Claude`, and its man page: every case passes. Two defects the new cases found
      on the way, fixed before this commit: the restored index line was appended beside one another session had
      written, and `--retire` left the store entry, since the containment check took it for outside claude's tree,
      where it is Start-Claude's and removed as such
- [x] `make check` passes

### Merge

- [x] `make check`, finished green as the PR script runs it, read before this box is ticked
- [x] PR script `~/Workspace/NobleFactor/noblefactor-engprod.414-clear-claude-can-remove-a.bash` written, shown, and
      handed over; the PR resolves #414 and #415. This box's commit, the pull request's last, sets this plan
      `complete`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common.Unix/.local/bin/Clear-Claude` | Modify | Requirements 2 to 5 |
| `Home/common.Unix/.local/share/man/man1/Clear-Claude.1` | Modify | What changes in its behavior and exit statuses |
| `tests/Test-ClearClaude` | Modify | Requirements 1 and 6 |
| `docs/architecture/agent-schedule/1-session-model.md` | Modify | What Requirement 1 observes |
| `Home/common.Unix/.local/share/bash-completion/completions/Start-Claude` | Modify | Issue 415 |
| `Home/common.Unix/.local/share/zsh/site-functions/_Start-Claude` | Modify | Issue 415 |

## Open Questions

- [x] **1. The prompt history, reopened.** Ruled 2026-10-27 on the first draft, which called the remaining window
      "microseconds"; the outside review of `d836aaf` showed that nothing bounds it (Requirement 5). Ruled again
      2026-10-27, told that the window takes a claude session stalled between its open and its write for two seconds
      or more: "A", the rewrite goes in as Requirement 5 states it, its window stated in the man page.
- [x] **2. The observation's cost.** Approved and run 2026-10-27: "approved. run". The second, of `/rename <name>`,
      approved and run the same day: "test your shit". Both sessions' records removed by hand afterwards.
- [x] **3. Start-Claude's completions** list schedules from the shell's directory, not `--directory`'s. Ruled
      2026-10-27, "fix the completion bug now": #415, fixed here (Issue 415 above).

## Reopened 2026-10-27: nothing of a cleared conversation remains

The first real run, 2026-10-27, against the NobleFactor/devlore-cli#949 session, short id `66865b81`: `/clear` was
taken, the new id published, and the transcript, its folder, the file history, the session environment and the
prompts removed. Left behind: the job's timeline, `jobs/66865b81/timeline.jsonl`, 1,686 lines since 2026-10-19 whose
`detail` field quotes every prompt of every conversation the session has held, kept on purpose (Clear-Claude(1),
NOTES: "the running session keeps it"); and the paste cache, which no version has looked at. Ruled, the owner:
"Clear-Claude is supposed to remove ALL trace of the session's transcript. EVERYTHING. `/clear` is insufficient."
#414 and #415 reopened at the owner's direction; the timeline's lines from before the clear removed by hand the same
day. The requirements below are the owner's, 2026-10-27, numbered as given, each confirmed in turn.

### R1. The store is the authority

The data is the agent-schedule tree under the state directory:
`${XDG_STATE_HOME:-$HOME/.local/state}/agent-schedule/<owner>/<repository>/<number>`, each entry holding the
background session's short id, with `<number>.lock` beside it, the lock Start-Claude shares. `--schedule` names one
entry: `<owner>/<repository>#<number>` names it directly; a bare `<number>` names the entry under the repository of
`--directory`, or of the working directory, read from the clone's `origin` remote. GitHub is asked nothing (D1).

### R2. A missing schedule is refused; nothing to remove is information

Three outcomes, each said in full:

| Found | Outcome | Message |
| --- | --- | --- |
| No entry for the schedule | Error, 66 | `No schedule NobleFactor/devlore-cli#950 under /home/david-noble/.local/state/agent-schedule. Nothing removed.` |
| An entry, no background session listed for its id, and no record of a conversation of it anywhere R4 looks | Information, 0 | `NobleFactor/devlore-cli#949: no background session is listed and no record of a conversation remains. Nothing to remove.` |
| Anything else that stops the run | Its own status, from the man page's table | Which check stopped it, what was already done, and what was not |

Information, not a warning: Clear-Claude promises a state, nothing of the conversation left, and finding that state
already true is success, as `rm -f` treats a missing file. A warning would make the retry after a failed run noisy,
and a retry is how a failed run is finished. The second message is said only after every location in R4 was checked.
When claude lists no session, the conversation to look for is the one `jobs/<short id>/state.json` names in
`resumeSessionId` (D7), which the short id alone cannot give after a `/clear`.

### R3. `/clear` clears what it clears

Unchanged from Requirement 2 above: a viewer of Clear-Claude's own, `/clear` typed as Requirement 1 observed, the
new conversation confirmed by claude's listing showing a new UUID for the same short id, the viewer closed by the
trap. The background session and every other viewer go on. The `/clear` line itself is recorded as a prompt of the
old conversation and leaves with R5. What `/clear` leaves on disk is R4 and R5, touched only after the confirmation.

### R4. Every other record of the conversation goes

Every place claude writes under its home and under `/tmp/claude-<uid>` that `/clear` leaves. The inventory is
measured on a disposable session (Phase 4), not assumed, and the proof is a sweep: after the run, nothing under
`CLAUDE_CONFIG_DIR` or `/tmp/claude-<uid>` names the old conversation's id or holds the text of any prompt typed in
it. The test seeds every row and expects it gone; the live check sweeps, and a file the sweep finds that no row
covers fails it, so a location the harness adds later is caught rather than missed.

| Record | Identified by | f0211f4 | Now |
| --- | --- | --- | --- |
| `projects/<project>/<id>.jsonl` and `<id>/` | the conversation id | removed | removed |
| `file-history/<id>`, `session-env/<id>`, `/tmp/claude-<uid>/<project>/<id>` | the id | removed | removed |
| `projects/<project>/memory/*.md` whose frontmatter `originSessionId` is the id, and their index lines | the id | staged, removed on confirmation | the same |
| `history.jsonl` | `sessionId` on each line | rewritten, not lossless | R5 |
| `jobs/<short id>/timeline.jsonl` | a time on each line, no id, prompts quoted in `detail` | kept | every line dated before the confirmation goes (D4) |
| `jobs/<short id>/state.json` | `resumeSessionId`, `detail` | kept | kept: claude writes the new id and the new conversation's state into it; read for the current id when claude lists nothing (D7) |
| `jobs/<short id>/tmp/` | nothing | staged, removed on confirmation | the same |
| `paste-cache/<hash>.txt` | the old transcript's references, `paste-cache/<hash>` | kept | removed when no remaining transcript references the hash (D5) |
| `daemon/attach-journal/*.json` | an attach gesture: pid, surface, times; no id, no text | kept | measured in Phase 4; removed if one names the id |
| `backups/.claude.json.backup.*` | copies of the global config | kept | measured; its lines removed if one holds the id or a prompt |
| `debug/`, `shell-snapshots/`, `todos/`, `plans/` | measured | kept | measured |

### R5. The prompts go, nobody else's, and none appended meanwhile is lost

`history.jsonl` holds every session's prompts on the host, each line tagged with its conversation id, and up-arrow
and Ctrl+R read it, so until the lines go the cleared prompts are one keystroke away. After the confirmation every
line tagged with the old conversation goes, every other line stays byte for byte, and no line any session appends
during the rewrite is lost. The last clause is met by construction (D6), not by a timer: Requirement 5 above drained
the old file for two quiet seconds, which bounds nothing, as the outside review said and the man page admits.

### Design

- **D1. The store is read, not GitHub.** `Clear-Claude:612-622` asks `gh` for the repository of `--directory` and
  refuses with "GitHub has no repository". The repository is the `origin` remote's, read with git, and the only
  refusal is R2's: no entry. One fewer network call and one fewer way to fail for a schedule that is right there.
- **D2. Three outcomes, three messages,** as R2 tables them. Every refusal names the schedule, the path or command it
  checked, what the run had done and what it had not; the man page's status table gains the rows.
- **D3. The inventory is a table in the script and in Clear-Claude(1),** one function per row, and the sweep is a
  function of its own that both the test and the live run call. "All trace" is then a check, not a hope.
- **D4. The timeline is cut at the confirmation.** Its lines carry a time and no conversation id; every line dated
  before the moment claude's listing showed the new id goes, the rest stays. A status line the new conversation wrote
  in the half-second between the id's publication and the read is lost with them: a `working` line, nothing typed.
  Cut in place, the file's inode kept, since the daemon appends to it.
- **D5. Pastes by reference.** A transcript names each paste it holds as `paste-cache/<hash>` (seen 2026-10-27, four
  in this conversation's). The old transcript is read for its references before it is removed; a referenced file goes
  unless a transcript that remains references the same hash.
- **D6. The prompt history, lossless by holders.** No claude process holds `history.jsonl` open between prompts
  (`/proc/*/fd`, 2026-10-27, and the first plan's `lsof`): each append is an open, a write and a close. So after the
  copy is renamed into place no new opener reaches the old file, and a writer that opened it before the rename holds
  it until its write and close. The catch-up therefore waits until no process on the host holds the old inode open,
  by `/proc/*/fd` on Linux and `lsof` on macOS, then reads the old file to its end once more and appends what it
  finds, filtered. That is every line a pre-rename opener could write. A holder that does not let go in 30 seconds is
  named, the lines read so far are saved beside the file as today, and the run exits 75.
- **D7. The current conversation's id when claude lists nothing** is `resumeSessionId` in `jobs/<short id>/state.json`,
  which claude rewrites at every `/clear`; `--retire` and R2's second outcome read it, where f0211f4 looked for
  transcripts named with the short id, which only the first conversation of a session has.

### Phases, continued

#### Phase 3: The plan, reopened

- [ ] This section committed on `fix/414-clear-claude-can-remove-a` and reviewed with the owner; the open questions
      ruled

#### Phase 4: The inventory, measured

- [ ] With the owner's approval, on a disposable background session: a prompt carrying a paste, a memory written,
      then Clear-Claude at f0211f4; the sweep run before and after; R4's table corrected to what it finds, each
      `measured` row settled, and the record of it written here

#### Phase 5: The tests

Each case added to `tests/Test-ClearClaude`, seen to fail against f0211f4 where it can:

| Case | Expected |
| --- | --- |
| `--schedule` with no entry in the tree; a bare number in a directory whose `origin` has no entry | 66, R2's first message, nothing typed |
| An entry, no session listed, no record anywhere | 0, R2's second message |
| An entry, no session listed, one record left in any R4 row | That record removed, 0 |
| Each failure the run can meet | Its status and a message naming the check, what was done, what was not |
| Every R4 row seeded for the old conversation and for another | The old conversation's gone, the other's kept; the sweep clean |
| A seeded file the inventory does not cover | The sweep fails and names it |
| The timeline: lines before and after the confirmation | The earlier gone, the later kept, the inode unchanged |
| A paste referenced by the old transcript alone; one referenced by another transcript too | The first gone, the second kept |
| The history: a writer that opens before the rename and writes after the old two-second drain would have ended | Its line kept, nothing of the old conversation left |
| The history: a holder that never closes | 75 after 30 seconds, the holder named, the lines saved beside the file |
| `--retire` after a `/clear`, claude listing nothing | The current conversation found through `state.json` and removed |

#### Phase 6: The work

- [ ] `Clear-Claude`: R1 to R5 as the design says; Clear-Claude(1): the inventory, the messages, the statuses, the
      NOTES on the timeline and the history replaced
- [ ] `docs/architecture/agent-schedule/1-session-model.md`: the parts drawn, and "Clearing and retiring a
      conversation" rewritten; `2-command-line.md`: the records named in full
- [ ] Issue 415's last item: the zsh completion tried in a terminal, `Start-Claude --directory <another clone>
      --schedule <Tab>`, and recorded
- [ ] `make check` passes

#### Phase 7: The live run

- [ ] With the owner's approval: a disposable session, then the #949 session; the sweep clean after each; recorded
      here

#### Merge

- [ ] `make check`, finished green as the PR script runs it, read before this box is ticked
- [ ] PR script `~/Workspace/NobleFactor/noblefactor-engprod.414-clear-claude-can-remove-a.bash` written, shown and
      handed over; the PR resolves #414 and #415 again; its last commit sets this plan `complete`

### Files, continued

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common.Unix/.local/bin/Clear-Claude` | Modify | R1 to R5 |
| `Home/common.Unix/.local/share/man/man1/Clear-Claude.1` | Modify | The inventory, the messages, the statuses, the NOTES |
| `tests/Test-ClearClaude` | Modify | Phase 5 |
| `docs/architecture/agent-schedule/1-session-model.md` | Modify | The diagram; the clearing section |
| `docs/architecture/agent-schedule/2-command-line.md` | Modify | The records, in full |

### Open questions, continued

- [ ] **4. D1.** The GitHub lookup of `--directory`'s repository goes, the `origin` remote read instead. Yes?
- [ ] **5. D6's bound.** A holder of the old history file that does not close within 30 seconds: named, lines saved,
      exit 75. Or wait without bound?
- [ ] **6. D4.** The timeline cut at the confirmation, the new conversation's lines kept. Or the file emptied?
