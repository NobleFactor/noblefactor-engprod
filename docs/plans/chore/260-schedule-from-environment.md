---
title: "A session reads its schedule and its link from its environment, and keeps the name Start-Claude gives it"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/260
status: active
created: 2026-10-21
updated: 2026-10-22
---

# Plan: A session reads its schedule and its link from its environment, and keeps the name Start-Claude gives it

## Issue 260

Lane 5 of NobleFactor/noblefactor-ops#301, in noblefactor-ops's own pull request. The owner, 2026-10-21: "Yes, its own
noblefactor-ops pull request." Then, of the hook: "Yes, drop the hook."

## Summary

Lane 5 of NobleFactor/noblefactor-ops#301. Start-Claude and Start-Claude.ps1 hand a schedule's background session its
key and its link, `NFEP_AGENT_SCHEDULE` and `NFEP_AGENT_SCHEDULE_URL`, through `claude --bg --settings`
([1. Session model](../../architecture/agent-schedule/1-session-model.md), item 10). `star-gh-assignment` reads the key
from there, and the session's name only when it is absent; and a session asked for the schedule's link gives it from
there too, without searching the conversation, GitHub or memory. Both scripts give the session its name on every
`claude --bg` they run, so that the title holds everywhere. The startup hook this issue first asked for is dropped.

## Goals

1. **The schedule from the environment.** A session started on a schedule names its schedule and its link from its
   environment, at no cost of a search.
2. **The title holds everywhere.** Every session Start-Claude or Start-Claude.ps1 starts, resumes or wakes carries the
   name it gives it, running and stopped.
3. **No hook.** Nothing in a session writes back to the store.

## Current State

| Part | Today |
| --- | --- |
| The variables | Start-Claude and Start-Claude.ps1 pass `NFEP_AGENT_SCHEDULE` and `NFEP_AGENT_SCHEDULE_URL` to the background session through `--settings`, seen reaching a session on 2026-10-15 |
| `star-gh-assignment` | Reads the schedule's key from the last `custom-title` record in the session's transcript, with one grep, and answers with that key alone, or `none` |
| The link | No skill gives it, so a session asked for it searches |
| The name | Both scripts pass `--name` when they start a session, and not when they wake one, with `claude --bg --resume` |
| A startup hook | None: [1. Session model](../../architecture/agent-schedule/1-session-model.md), item 9, "No startup hook" |

What claude does with a name, seen on Danoble-MBP-A on 2026-10-21 with four sessions started for the purpose and then
stopped: `/clear` keeps it, in claude's list and in the new conversation's transcript; a session started with
`--name` keeps it, running and stopped; `--name` names the session `claude --bg --resume` starts; and a session
resumed without it shows the name while it runs, read from its transcript, and none once it stops.

## Requirements

### Requirement 1: the key from the environment

`star-gh-assignment` answers with `$NFEP_AGENT_SCHEDULE` when it is set, and only when it is not, with the key the
session's name begins with, as today; with neither, `none`. Its answer stays the key alone. The owner, 2026-10-05:
"star-gh-assignment reports the schedule issue number. that is all." This is one step of the search path
NobleFactor/noblefactor-ops#308 asks for, whose order the owner has left open: see open question 4.

### Requirement 2: the link from the environment

Asked for the schedule's link, a session answers with `$NFEP_AGENT_SCHEDULE_URL` when it is set, and otherwise with
the link its key makes, `https://github.com/<owner>/<repository>/issues/<number>`, without searching the conversation,
GitHub or memory. `star-gh-assignment` gives it, each answer alone; the owner, 2026-10-21: "I agree. Give the
schedule's link too as you describe." Asked whether a link is made from the key when the variable is absent, the owner,
the same day: "Yes".

### Requirement 3: the title holds everywhere

Start-Claude and Start-Claude.ps1 pass the session's name with `--name` on every `claude --bg` they run: a start, a
resume, and a wake. A case in both test scripts proves the wake passes it. The owner, 2026-10-21: "The titles are a
significant organizational assist for me." Then: "Yes, make the title hold everywhere."

### Requirement 4: acceptance

Row 4 of David-Noble-at-work/personal#259's plan, moved to this issue on 2026-10-14: a session Start-Claude starts on a
schedule, asked "What schedule are you working on?" and then for the schedule's link, answers both from its
environment, with no search. With it, the name: `claude agents --json` lists the session under the name Start-Claude
gave it after it starts, after `/clear`, and after a stop and a `--detach` wake. The owner runs it on Danoble-MBP-A,
from the commands the pull request's script prints.

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on its branch as 4d1ab1a on 2026-10-21, and reviewed with the owner the same day. Given
  its summary, the owner said: "Continue".

### Phase 2: The skill and the name

- [x] Requirements 1 to 3: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`, in a script the owner runs. Done 2026-10-22.

### Phase 3: Acceptance

- [ ] Requirement 4, after the merge and its deploy.

### Phase 4: Closure

- [x] The pull request, closing #260 and with it lane 5 of #301, the agent-schedule design's status companions saying
  so. Each host takes the merge in the script that merges it: Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3. The
  plan stays `active` until phase 3, which follows the deploy.

## Migration Path

None: the skill reads the session's name as it does today wherever the variables are absent, and a session named before
this keeps its name.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/260-schedule-from-environment.md` | Create | this plan |
| `Home/common/.claude/skills/star-gh-assignment/SKILL.md` | Modify | the key and the link from the environment |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | `--name` on the wake |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | `--name` on the wake |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Modify | the wake's case |
| `docs/architecture/agent-schedule/1-session-model.md` and its status companion | Modify | item 10's variables, now read, and the name on every start |

## Related Documents

- NobleFactor/noblefactor-ops#260; NobleFactor/noblefactor-ops#301 (schedule), lane 5
- NobleFactor/noblefactor-ops#308 (bug): `star-gh-assignment`'s search path, of which requirement 1 is one step
- NobleFactor/noblefactor-ops#341 (bug): a `--detach` wake after `/clear` starts an unnamed copy, open question 3
- [1. Session model](../../architecture/agent-schedule/1-session-model.md), items 9 and 10

## Open Questions

1. **Where the link's answer lives.** Ruled 2026-10-21: `star-gh-assignment` gives it too, when asked for it, each
   answer alone, so that one skill's description is in every session's context rather than two, the owner's goal for
   #260 on 2026-10-06: "save money on tokens where we can." The owner: "I agree. Give the schedule's link too as you
   describe."
2. **The link with no variable.** Ruled 2026-10-21: made from the key,
   `https://github.com/<owner>/<repository>/issues/<number>`, since every schedule's link has that form, and GitHub
   redirects the link of an issue that has moved. The owner: "Yes".
3. **A `--detach` wake after `/clear`,** found 2026-10-21. Once a session that went through `/clear` stops, claude lists
   it under its first conversation's id, and `claude --bg --resume` of that id does not wake it: claude starts a copy,
   unnamed, which failed, saying the session "is already running in the background". Both scripts wake that way, and
   their store would keep the stopped session's id. Filed as NobleFactor/noblefactor-ops#341 the same day; proposed
   as a new lane of #301, since the fix wants investigating first, which waits on the owner's amendment.
4. **Requirement 1's order and #308's search path.** NobleFactor/noblefactor-ops#308 names the agent-schedule store,
   read by the session's id, as definitive, with the environment, the transcript and the title as evidence, and leaves
   the order open. The owner, 2026-10-16: "we can leave that unspec'd for now." Requirement 1 reads the environment
   first and the name second, and not the store. Options: (a) the order is interim, and #308's design replaces it;
   (b) it settles the first two steps of #308's path. Not ruled.
