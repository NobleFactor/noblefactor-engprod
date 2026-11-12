---
title: "The star github schedule commands, designed before any is built"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/439
status: draft
created: 2026-11-11
updated: 2026-11-11
---

# Plan: The star github schedule commands, designed before any is built

Step 27 of issue tracking, iteration 1 (#346). Ruled 2026-11-02: creating a schedule moves from Start-Claude into
`star github schedule`, and its commands are designed before any of them is built. This plan writes that design: every
`star github schedule` command, what it does and its options, `new` and `add` among them, for an organization and for a
user account. #438 builds `add` next, step 28, to it; #338 and #504, steps 41 and 42, file issues by the same model.

One pull request from `doc/439-schedule-commands`, resolving #439. The design is section 8 of the issue data model,
with its status page, listed in the index.

## Rulings

- 2026-11-02: creating a schedule moves from Start-Claude into `star github schedule`; its commands are designed before
  any is built (#439).
- 2026-11-03: each team has one Schedule project, copied from its account's Schedule template (in a user account, from
  the account's copy). A single-select Schedule field names each row's schedule, one option per schedule, named for its
  Schedule issue. That issue, typed Schedule (labeled `schedule` in a user account), is filed from the account's
  Schedule form and holds the deliverable and the exit criteria; its own row has no step, and steps are worked in step
  order (section 7, § Writing a schedule). There is no project per schedule.
- 2026-11-03: a Schedule issue carries a line linking its project's view 2, filtered to its option, and a new one gets
  that line when its option is made (section 3, § The collection's own record).
- 2026-11-04: work goes onto a schedule from the Backlog, highest Priority first, with the schedule's option, the next
  step or the one the schedule's owner gives, Status Open and its blocked-by links, and loses its Backlog row. A
  committed schedule takes new work only by its owner's amendment, recorded in the Schedule issue (section 7; section 3,
  § A committed schedule).
- 2026-11-04, on #439: the owner's example of the new syntax,
  `star github schedule --group-by Schedule --account NobleFactor --team engprod --where '{ Schedule: { _eq: 346 } }' --output csv`;
  and the question agent-rules.md left here, what lists the open ruling issues under NobleFactor/devlore-cli#463.
- 2026-11-08 (#379): the report returns every issue as one flat record, narrowed by star's `--filter` and `--jq` and
  rendered by `--output`; `--epic`, `--thread`, `--by` and the audit are gone. The sweep checks classification (#436).
- 2026-11-11 (#438): `add --after <step>` takes a step, and every later step moves down one, consecutive whole numbers.

## Current State

Read on 2026-11-11 from develop at `0a9520e`:

| What | Where it stands |
| --- | --- |
| `star github schedule` | One command, `report`. The audit went with #379; the sweep is `star github triage sweep` |
| A new schedule | Start-Claude's `--schedule new` files `Schedule: <title>` with the `chore` label, retired on 2026-11-03, and an empty lane table, retired the same day. It makes no option and no row |
| A step added, moved or inserted | By hand in GitHub: #482 to #485 went in after step 22 on 2026-11-11, fourteen steps renumbered by hand |
| #439's and #438's bodies | Written before 2026-11-03: each speaks of a schedule as a project of its own. The design follows the rulings, and the two bodies are brought to it |
| agent-rules.md, rule 2 | Holds open, for this design, what lists the open ruling issues under devlore-cli#463 |

## Requirements

The design, section 8, states:

1. **Every command** of `star github schedule`, its arguments and options, what it reads and writes, and how it runs
   for NobleFactor and for David-Noble-at-work: `report` as built, `new`, `add` with `--after`, and the others the
   design finds a schedule's life needs, such as moving a step, taking one off and closing a schedule, each proposed for
   the owner to rule.
2. **`new` exactly:** the Schedule issue, its type or label, filed from the account's Schedule form; the option made in
   the team's Schedule field, or the user's; the issue's own row with no step; the line linking view 2 filtered to the
   option; the schedule's owner; and what it refuses.
3. **`add`** brought to one Schedule project a team: the row's option, step, Status and blocked-by links; its Backlog
   row removed; the amendment written in the Schedule issue, and the committed schedule's rule; `--after`.
4. **The new syntax:** how `--account`, `--team`, `--group-by`, `--where` and `--output` of the owner's example relate
   to the report's `--filter`, `--jq` and `--output` (#379), proposed for the owner to rule.
5. **The open question of rule 2:** the command that lists the open ruling issues under devlore-cli#463, run as written.
6. **What Start-Claude keeps:** its `--schedule new` gives way to `new`, or calls it.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | Every project, field, option and issue the design names | Read from GitHub on the day it is written |
| 2 | Every command the design names that exists today | Runs as written |
| 3 | `make check` | Passes |
| 4 | The design | Approved by the owner |

## Implementation Phases

### Phase 1: the plan

- [ ] Written and committed on `doc/439-schedule-commands` by the worktree's first script, which opens the branch with
      `git open-branch 439 -T doc`, pushes it, and sets step 27's row In progress with the branch in its Worktree
      column, read back (agent-rules.md, rule 19); reviewed with the owner

### Phase 2: the design

- [ ] Section 8 drafted, with its status page and its index entry; each question it raises ruled by the owner; approved

### Phase 3: the issues

- [ ] #439's and #438's bodies brought to the design, on the owner's go

### Phase 4: merge

- [ ] The pull request script written, shown and handed over. It closes #439, comments on it with the merged design and
      the owner's approval and its date, and sets step 27's row Closed with the pull request as its Worktree

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/439-schedule-commands.md` | Create | This plan |
| `docs/architecture/issue-data-model/8-the-schedule-commands.md` | Create | The design |
| `docs/architecture/issue-data-model/8-the-schedule-commands.status.md` | Create | Its status |
| `docs/architecture/issue-data-model/index.md` | Modify | Section 8 listed |

## Related Documents

- [Section 3, Collections](../../architecture/issue-data-model/3-collections.md) and
  [section 7, The workflow before and after](../../architecture/issue-data-model/7-the-workflow-before-and-after.md)
- #438, `add`; #338 and #504, filing an issue; #379, the report as built; #436, the sweep

## Open Questions

- Does the design cover scenarios too? The same model holds a Scenario issue, its option and its beats. Proposed:
  schedules alone, with scenarios noted for a design of their own.
