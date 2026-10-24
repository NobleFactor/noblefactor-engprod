---
title: "#384's plan reads active, with its closure box ticked for #387"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/393
status: draft
created: 2026-10-24
updated: 2026-10-24
---

# Plan: #384's plan reads active, with its closure box ticked for #387

## Issue 393

Lane 19 of NobleFactor/noblefactor-engprod#301, logged 2026-10-23: the agent's own breach of rule 12, found after #387
merged. The owner: "Yes, fix … (#393) and include it in the next PR." It rode first with #394, lane 18, in that
issue's worktree. #394 closed as not planned on 2026-10-23 with no change to the code, so this worktree carries #393
alone. The owner, asked to close that worktree and open this one: "Yes".

## Summary

[384-waking-a-stopped-session-with.md](384-waking-a-stopped-session-with.md) merged in #387, as `aa274de` on
2026-10-23, reading `status: draft` and with phase 4's box, the pull request's closure, unticked. #387 had closed
#384, and its script had deployed the change on the three hosts.
[§ Documents on every commit](../../guides/development-process.md#documents-on-every-commit) gives the closure box to
a pull request's last commit, and a plan with a box still open at that commit stays `active`. The rule broken is rule
12 of [agent-rules.md](../../guides/agent-rules.md). This pull request sets the plan `active` and ticks phase 4, and
the box says the tick came late and from where. Phase 2's open box, open question 4, stays open and names #388, which
now holds it. Phase 5, the owner's acceptance, stays open.

## Goals

1. **#384's plan says what is true:** it is `active`, and phase 4 is ticked for #387 and `aa274de`.
2. **A late tick reads as late:** the box says when it was ticked and by which issue, so a reader can tell it from a
   box ticked on time.
3. **This plan closes the way #384's should have:** its pull request's last commit ticks its closure box and sets it
   `complete`.

## Current State

| Part of 384-waking-a-stopped-session-with.md | On develop at `aa274de` | What is true |
| --- | --- | --- |
| `status` | `draft` | `active`: the work merged and deployed, and phase 5 waits |
| Phase 4, the closure | unticked | #387 merged as `aa274de` on 2026-10-23 and closed #384 |
| Phase 2, open question 4 | unticked | open, and held by #388, which the box does not name |
| Phase 5, the acceptance | unticked | open: the owner's, on Danoble-MBP-A |

Seen on 2026-10-24 with `gh`: #387 merged at 2026-10-23T22:08:21Z as `aa274de2`, and #384 closed as completed two
seconds later. The deploy is checked in phase 2, before the tick.

## Requirements

### Requirement 1: the status

[384-waking-a-stopped-session-with.md](384-waking-a-stopped-session-with.md) reads `status: active`, and `updated:`
gets the date of the commit that changes it. It stays `active` until its phase 5.

### Requirement 2: phase 4

Phase 4's box is ticked for #387, `aa274de` and 2026-10-23, and for the deploy on Danoble-MBP-A, danoble-ud24-1 and
danoble-wd11-3. The deploy is checked first: each host's deployed script, `Start-Claude` on macOS and Linux and
`Start-Claude.ps1` on Windows, matches the file at `aa274de`. The box says it was ticked late, by #393.

### Requirement 3: phase 2's open box

Phase 2's box for open question 4 stays unticked and names #388, where that check now lives.

## Implementation Phases

### Phase 1: The plan

- [ ] This plan, committed on its branch and reviewed with the owner.

### Phase 2: The fix

- [ ] Requirements 1 to 3, with the deploy checked on the three hosts before phase 4's tick, and `make check`.

### Phase 3: Closure

- [ ] The pull request, closing #393 and with it lane 19 of #301 once recorded. Its last commit ticks this box and
  sets this plan `complete`, since
  [§ Documents on every commit](../../guides/development-process.md#documents-on-every-commit) gives that commit
  both. No deploy follows, because the change is to documents only.

## Migration Path

None: the change is to documents only.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/fix/393-384-s-plan-merged-as-draft-with.md` | Create | this plan |
| `docs/plans/fix/384-waking-a-stopped-session-with.md` | Modify | its status, its phase 4, and phase 2's pointer to #388 |

## Related Documents

- NobleFactor/noblefactor-engprod#393; NobleFactor/noblefactor-engprod#301 (schedule), lane 19
- NobleFactor/noblefactor-engprod#384 and [its plan](384-waking-a-stopped-session-with.md), and
  NobleFactor/noblefactor-engprod#387, which merged them
- NobleFactor/noblefactor-engprod#388: open question 4 of #384's plan
- [§ Documents on every commit](../../guides/development-process.md#documents-on-every-commit), and rule 12 of
  [agent-rules.md](../../guides/agent-rules.md)

## Open Questions

1. **Where does the Windows check of Remote Control go?** #394's closing comment, 2026-10-23, says Remote Control on
   danoble-wd11-3 "will be verified after the VM is rebuilt from a clean image; that verification rides #384's Windows
   acceptance lane". But #384's requirement 5 runs on Danoble-MBP-A only, so there is no such lane. Either
   requirement 5 gains a Windows step after the rebuild, or the check is logged as an issue of its own. Not yet
   ruled.
