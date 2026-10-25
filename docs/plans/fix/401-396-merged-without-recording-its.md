---
title: "#301 records the lanes #396 left stale"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/401
status: draft
created: 2026-10-25
updated: 2026-10-25
---

# Plan: #301 records the lanes #396 left stale

## Issue 401

Lane 20 of NobleFactor/noblefactor-engprod#301, filed 2026-10-25.
[#396](https://github.com/NobleFactor/noblefactor-engprod/pull/396), the pull request for #393, merged without
recording its lanes on #301. The owner: "I would like you to add a new issue to your schedule. it's a bug against the
PR in question." Then: "the clarification here would be that if another PR outside the scope of your current worktree
is blocking your progress, you must fix it." This worktree's scripts make every edit to #301, since the one place the
process gives a script is beside its worktree,
[§ The unit of work](../../guides/development-process.md#the-unit-of-work).

## Summary

#301 still reads lanes 18 and 19 as in progress in `noblefactor-engprod.394-on-danoble-wd11-3-windows`, a worktree
that is gone, and lane 17 as waiting on lane 18. This pull request's script rewrites those three rows to say what is
true, and records the owner's rulings of 2026-10-24 that moved them, as an amendment of that date. Its scripts also
keep this lane current: in progress when the plan is committed, and merged when the pull request lands.

## Goals

1. **#301 says what is true** of lanes 17, 18 and 19.
2. **The rulings that moved them are on record,** dated the day they were made, saying when they were recorded.
3. **This lane is kept current as it moves,** each step recorded by this worktree's scripts.

## Current State

| Lane | #301 says | What is true |
| --- | --- | --- |
| 17, #384 | "next, the owner's acceptance on Danoble-MBP-A, the plan's phase 5"; waits on "the owner's acceptance; on Windows, lane 18" | its plan `active` and its closure ticked by #396; its acceptance on Danoble-MBP-A, and on danoble-wd11-3 once that VM is rebuilt |
| 18, #394 | in progress in `noblefactor-engprod.394-on-danoble-wd11-3-windows` | closed as not planned at 2026-10-24T05:23:03Z, with no change to the code; that worktree is gone |
| 19, #393 | in progress in `noblefactor-engprod.394-on-danoble-wd11-3-windows` | merged in #396 as `f049c5a` at 2026-10-24T18:55:25Z, from a worktree of its own |
| 20, #401 | "its own pull request, worked now" | in progress in `noblefactor-engprod.401-396-merged-without-recording-its` |

Seen on 2026-10-25 with `gh issue view 301`, whose `updatedAt` was 2026-10-25T18:17:21Z, the run that filed #401.

## Requirements

### Requirement 1: lanes 17, 18 and 19

Each row's Next and Waits on read:

| Lane | Next | Waits on |
| --- | --- | --- |
| 17 | noblefactor-engprod, merged as #387, aa274de, 2026-10-23 UTC; deployed on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3, each host's deployed script checked against aa274de on 2026-10-24; its plan set `active`, its closure ticked, by #396 (lane 19); next, the owner's acceptance, the plan's phase 5: on Danoble-MBP-A, and on danoble-wd11-3 once that VM is rebuilt | the owner's acceptance; on Windows, the VM's rebuild |
| 18 | closed as not planned, 2026-10-24 UTC, with no change to the code: Microsoft Defender for Endpoint, left on the VM by its old image, blocks `claude --remote-control`, and both scripts already carry `--no-remote-control` / `-NoRemoteControl`; Remote Control there is checked after the VM's rebuild, in lane 17's acceptance; its worktree closed | — |
| 19 | noblefactor-engprod, merged as #396, f049c5a, 2026-10-24 UTC, alone once lane 18 closed; documents only, so no deploy | — |

Each issue and pull request in them is linked, as the rows around them are.

### Requirement 2: the rulings of 2026-10-24

An amendment dated 2026-10-24, placed before the one of 2026-10-25, its last sentence saying it was recorded late:

> **Amended 2026-10-24 by the owner:** lane 18 closed as not planned, and lane 19 worked alone. Lane 18's refusal is
> Microsoft Defender for Endpoint, left on danoble-wd11-3 by its old image, which blocks `claude --remote-control`;
> both scripts already carry `--no-remote-control` / `-NoRemoteControl`, so nothing in them changes, and the
> 2026-10-23 amendment's `--rc` is withdrawn. The owner, of `--rc`: "why would i want an abbreviation that must be
> internalized by readers instead of a name that everyone understands: remote-control." Of lane 18: "so this is a
> non-issue. we've got what we need to test on Danoble-WD11-3. we just can't test remote-control right now." Then:
> "Yes you may comment and close #394". Lane 19 moved to a worktree of its own,
> `noblefactor-engprod.393-384-s-plan-merged-as-draft-with`; the owner, asked to close lane 18's worktree and open
> it: "Yes". Lane 17's acceptance takes a step on Windows, for Remote Control once the VM is rebuilt; the owner: "add
> the Windows Remote Control check into a step in requirement 5." Recorded 2026-10-25 by #401, since #396 merged
> without it.

On #301 the last quote keeps the owner's spelling of "requirement"; it is corrected here only for the spelling gate.

### Requirement 3: this lane

Lane 20's Next reads "in progress in `noblefactor-engprod.401-396-merged-without-recording-its`" from the run that
commits this plan, and "noblefactor-engprod, merged as #NNN, `<commit>`, `<date>` UTC; records only, so no deploy"
from the pull request's script, once the merge has landed. The run that commits this plan also links it from #401's
plan row, on develop, where the link is dead until the merge and correct after it
([§ Plans](../../guides/development-process.md#plans)).

## Implementation Phases

### Phase 1: The plan

- [ ] This plan, committed on its branch and reviewed with the owner. The same run records lane 20 in progress and
  links this plan from #401.

### Phase 2: The records

- [ ] Requirements 1 and 2, applied to #301 by the pull request's script before its last commit, guarded on #301's
  `updatedAt`.

### Phase 3: Closure

- [ ] The pull request, closing #401. Its last commit ticks this box and sets this plan `complete`. After the merge,
  its script records lane 20 as merged, requirement 3; the plan does not, since the merge is not a state a plan
  records.

## Migration Path

None: the change is to #301's text and to this plan.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/fix/401-396-merged-without-recording-its.md` | Create | this plan |

#301 and #401 are issues, edited by this worktree's scripts.

## Related Documents

- NobleFactor/noblefactor-engprod#401; NobleFactor/noblefactor-engprod#301 (schedule), lane 20
- NobleFactor/noblefactor-engprod#396, which left the lanes stale, and NobleFactor/noblefactor-engprod#393, its issue
- NobleFactor/noblefactor-engprod#394 and NobleFactor/noblefactor-engprod#384, lanes 18 and 17
- [issue-standards.md](../../issue-standards.md) §Schedules: a lane's Next "is kept current as the work moves"
- [§ The unit of work](../../guides/development-process.md#the-unit-of-work), and
  [pr-script-template.md](../../guides/pr-script-template.md), which has no step for a schedule

## Open Questions

1. **Does a pull request record its own lanes as it lands?** [pr-script-template.md](../../guides/pr-script-template.md)
   has no step for a schedule, which is how #396 left #301 stale. Either the template gains one, after the merge, in
   this pull request; or that is an issue of its own; or lanes stay the session's to record by hand. Not yet ruled.
2. **Does the ruling on a blocking pull request go into the process documents?** The owner, 2026-10-25: "if another
   PR outside the scope of your current worktree is blocking your progress, you must fix it." Then: "if work is
   ongoing in another session we can consider having that session unblock you. Of course, you need to engage with me
   before acting." [§ Blocking issues](../../guides/development-process.md#blocking-issues) covers an issue found
   mid-work, not a merged pull request that blocks one, and rule 2 of [agent-rules.md](../../guides/agent-rules.md)
   has rulings lead the guides. Either § Blocking issues gains it in this pull request, or that is an issue of its
   own. Not yet ruled.
