---
title: "The star github scenario commands, designed before any is built"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/507
status: draft
created: 2026-11-15
updated: 2026-11-15
documents:
  - kind: "Design: the schedule commands"
    path: "docs/architecture/issue-data-model/8-the-schedule-commands.md"
    text: "section 8"
  - kind: "Design: collections"
    path: "docs/architecture/issue-data-model/3-collections.md"
    text: "section 3"
---

# Plan: The star github scenario commands, designed before any is built

Step 50 of issue tracking, iteration 1 (#346). `star github` has no scenario commands: a scenario is made and kept by
hand, but for two pieces built since 2026-11-04, the Triage workflow that puts an item found on a walk in its scenario
(#448) and `star github schedule add`, which takes an item off its scenario when it goes onto a schedule (#438). Section
8 designed the schedule commands and left the scenario commands to a design of their own (#507, ruled 2026-11-11). This
plan writes that design: every command a scenario's life needs, for an organization and for a user account, each
proposed for the owner to rule.

One pull request from `doc/507-scenario-commands`, resolving #507. The design is section 9 of the issue data model, with
its status page, listed in the index.

## Rulings

- 2026-10-21: schedules and scenarios differ in intent and are otherwise the same. A scenario represents a use case; a
  schedule tracks engineering work.
- 2026-11-03: each team has one Scenario project, copied from its account's Scenario template. A single-select Scenario
  field names each row's scenario, one option per scenario, named for its Scenario issue, and a Beat number orders a
  scenario's rows. Each Scenario project has a By scenario view, its view 2.
- 2026-11-04: a scenario describes a feature, a workflow or a real-life situation that needs to be tested. Its Scenario
  issue summarizes an end-user goal and names the features it exercises. Its rows are the tasks and bugs found while
  walking it, each with the Beat at which it turned up. A found item names its scenario in its body, as "Found while
  walking #N", and the Triage workflow adds it to the scenario instead of to Triage. Each item later moves to its team's
  Triage project or onto a schedule, and leaves the scenario; its body and a comment on the Scenario issue record the
  move. An issue is on at most one scenario. A scenario never ends, so its Scenario issue never closes and states no
  evidence of completion.
- 2026-11-11, on #439: the schedule commands are designed first, in section 8, and the scenario commands after them,
  in a design of their own.
- 2026-11-14 (#453): each account's Scenario form asks what the person wants to do, how to walk through it, and the
  features it uses.

## Current State

Read on 2026-11-15 from GitHub and from develop at `1565afc`:

| What | Where it stands |
| --- | --- |
| `star github scenario` | No commands |
| Making a scenario | By hand: the Scenario issue filed from the form, its option added to the team's Scenario field, its own row, and the line linking view 2 filtered to its option |
| Logging a found item | The Triage workflow (#448) puts an issue whose body says "Found while walking #N" on its scenario's project, under its option. It sets no Beat |
| Moving an item on | Onto a schedule: `star github schedule add` comments on the Scenario issue and deletes the row (#438). To Triage: by hand |
| Reading a scenario | `star github schedule report` gives each row's scenario and Beat |
| The scenarios | Six, and a placeholder in each account: NobleFactor/devlore-cli#599, #806, #891, #892 and #893 on Scenario: devlore; #152 and the placeholder #442 on Scenario: engprod; the placeholder David-Noble-at-work/personal#316. Four of devlore's are still titled "Thread:" |
| Their rows | 29 issues: 8 open and 21 closed, which never left. 15 have no Beat. #147 and #179 are rows of two scenarios each, which the ruling of 2026-11-04 forbids |

## Requirements

The design, section 9, states:

1. **Every command** a scenario's life needs, its arguments and options, what it reads and writes, and how it runs for
   NobleFactor and for David-Noble-at-work, in the shape of section 8: at least making a scenario, logging what a walk
   finds, moving an item on, reading a scenario, and whether removing one gets a command.
2. **Where the commands live:** a group of their own, `star github scenario`, or verbs of `star github schedule`.
3. **What they share** with the schedule commands, in what they do and in the extension's code, such as the row and
   option helpers of `steps.star`; and what is left for them now that the Triage workflow logs a found item (#448) and
   `schedule add` moves one onto a schedule (#438).
4. **Making a scenario exactly:** the Scenario issue, its type or label, its body in the sections of the account's
   Scenario form; the option in the team's Scenario field, or the user's; the issue's own row; the line linking view 2
   filtered to the option; and what it refuses.
5. **What the scenarios already hold:** the closed rows, the rows with no Beat, the two issues on two scenarios, and the
   "Thread:" titles, each with what the design does about it.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | Every project, field, option and issue the design names | Read from GitHub on the day it is written |
| 2 | Every command the design names that exists today | Runs as written |
| 3 | `make check` | Passes |
| 4 | The design | Approved by the owner |

## Implementation Phases

### Phase 1: the plan

- [ ] Written and committed on `doc/507-scenario-commands` by the worktree's first script, which opens the branch with
      `git open-branch 507 -T doc`, pushes it, and sets step 50's row In progress with the branch in its Worktree
      column, read back; reviewed with the owner

### Phase 2: the design

- [ ] Section 9 drafted, with its status page and its index entry, and named in this plan's `documents:`, which
      `star github plan link` refuses until the file is in the worktree; #507's section written again from the plan;
      each question the design raises ruled by the owner, one at a time; approved

### Phase 3: the issues

- [ ] #507's body brought to the design; each command the design adds and nothing builds filed as a task under #332,
      in Triage: engprod, as section 8's were filed as #509 to #512; each read back

### Phase 4: merge

- [ ] The pull request script written, shown and handed over. It closes #507, comments on it with the merged design and
      the owner's approval and its date, and sets step 50's row Closed with the pull request as its Worktree

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/507-scenario-commands.md` | Create | This plan |
| `docs/architecture/issue-data-model/9-the-scenario-commands.md` | Create | The design |
| `docs/architecture/issue-data-model/9-the-scenario-commands.status.md` | Create | Its status |
| `docs/architecture/issue-data-model/index.md` | Modify | Section 9 listed |
| `docs/architecture/issue-data-model/8-the-schedule-commands.md` | Modify | Its line on the scenario commands points at section 9 |

## Related Documents

- [Section 3, Collections](../../architecture/issue-data-model/3-collections.md) and
  [section 8, The schedule commands](../../architecture/issue-data-model/8-the-schedule-commands.md)
- #448, the Triage workflow's scenario step; #438, `schedule add`; #338, `star github issue file`, which a command that
  logs a found item may file through

## Open Questions

#507's four questions, as they stand on 2026-11-15:

- **Their own group, or part of `star github schedule`:** for the design to propose and the owner to rule.
- **Whether removing a scenario gets a command:** the same.
- **What is shared with the schedule commands, and what is left after #448:** the same.
- **Whether the design waits on the Scenario forms' rewrite (#453):** no. #453 merged on 2026-11-14, and the forms ask
  for what section 3 rules.
