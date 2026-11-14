---
title: "The PR script template records a pull request's steps in the Schedule project"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/450
status: complete
created: 2026-11-13
updated: 2026-11-13
---

# Plan: The PR script template records a pull request's steps in the Schedule project

Step 39 of issue tracking, iteration 1 (#346). Rule 13 of the PR script template, and its schedule step in both forms,
bash and PowerShell, record a step by rewriting its row in a table in the schedule issue's body. Those tables were
retired on 2026-11-03, so the step would find no row and stop. Rule 19 of agent-rules.md says what the records are now,
and the scripts written since #427 have made them by hand, each with IDs pasted in. This brings the template to rule
19, adds the step a worktree's first script needs, in both forms, and settles what each record is guarded on. One pull
request from `feature/450-schedule-records`.

## Rulings

- 2026-10-25 (#401): every pull request records its steps as it lands.
- 2026-11-02 and 2026-11-03: a lane is a step; each team has one Schedule project, whose Worktree column holds each
  step's branch, and whose Schedule field names the schedule each row belongs to.
- Rule 19: a worktree's first script pushes its branch, then links it in the Worktree column of each of its steps'
  rows; a pull request's script records on each step's issue that it merged; a step that moves to another worktree, or
  closes without a merge, is recorded by the script of the worktree that held it, before `git close-branch`. Every
  record is read back.
- 2026-11-13, on this plan: each record is guarded on what it holds just before it is written, as proposed under Open
  Questions.

## Current State

Read on 2026-11-13, at `2612213`:

| What | Where it stands |
| --- | --- |
| `pr-script-template.md`, rule 13 and the schedule step, bash and PowerShell | Rewrite a row of the schedule issue's table, guarded on the issue's `updatedAt`; each says it is out of date and waits on #450 |
| A worktree's first script | No step in the template. The scripts since #427 push the branch, then set the row's Status to In progress and its Worktree to the branch's link, by IDs pasted in, and read the two back |
| A pull request's merge | The scripts since #427 close the step's issue by "Closes #N", post a comment on it naming the pull request and its squash commit, and set the row's Status to Closed and its Worktree to the pull request's link, read back |
| `agent-rules.md`, rule 19 | Leaves open what each record is guarded on |
| The documents | Section 3's status page and the issue data model's index say #450 will do this |

## Requirements

1. **Rule 13** says how a pull request's script records its steps as it lands: after the merge and its span, for each
   step, a comment on the step's issue naming the pull request and its squash commit, the issue closed, and the row's
   Status set to Closed and its Worktree to the pull request's link; guarded, and each read back.
2. **The schedule step,** in both forms, does that. It finds each step's row by its issue and its team's Schedule
   project, by title, and the fields and options by name, so no ID is pasted in and none goes stale.
3. **A first-script step,** in both forms: push the branch and read it back, then set each step's row to In progress
   with the branch's link in its Worktree column, guarded, and read back.
4. **The guard,** for the owner to rule (Open Questions), in rule 13, the steps and rule 19.
5. **The documents** that say #450 will do this say what the template does.

## Test Plan

Each step, bash and PowerShell, run against GitHub with every write stubbed by a `gh` on PATH that passes reads
through and prints each write instead of sending it:

| # | Case | Expect |
| --- | --- | --- |
| 1 | The first-script step, for #450's row while it is Open with no link | Its lookups find the row, the fields and the options; the guard passes; the writes it would make are Status In progress and the branch's link |
| 2 | The first-script step, for a step whose Worktree links another branch | Refused, naming the branch that holds it, and nothing written |
| 3 | The schedule step, for a step In progress on this branch | The comment, the close and the row's writes it would make |
| 4 | The schedule step, for a step whose Worktree links another branch | Refused, and nothing written |
| 5 | The PowerShell forms | Parse, and do as the bash forms for cases 1 to 4 |
| 6 | Live: #450's own first script and merge script, written from the new steps | #450's row In progress with its branch, then Closed with its pull request; #450 closed with its comment; each read back |
| 7 | `make check` | Passes |

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/450-schedule-records` by the worktree's first script, written from the new first-script
      step, which sets step 39 In progress with the branch linked; reviewed with the owner, and the guard ruled, on
      2026-11-13

### Phase 2: the template, the rule and the merge

- [x] Rule 13, the schedule step and the first-script step, in both forms; rule 19 closed; the documents; the cases
      above; `make check`; the pull request merged by a script written from the new schedule step, closing #450 with
      its evidence; step 39 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `docs/guides/pr-script-template.md` | Modify: rule 13, the schedule step and a first-script step, bash and PowerShell |
| `docs/guides/agent-rules.md` | Modify: rule 19's open question closed |
| `docs/architecture/issue-data-model/index.md` and `3-collections.status.md` | Modify |
| `docs/plans/feature/450-schedule-records.md` | Create |

## Open Questions

- **What is each record guarded on?** Ruled 2026-11-13, as proposed here. The old step was guarded on the schedule
  issue's `updatedAt`, so an edit made since stopped the script instead of being overwritten. Now each record is one
  field of one row, and a comment and a close on one issue. Proposed: guard each write on what the record holds just
  before it, the value it must replace. The first-script step writes only when the row is on a schedule, its Status is
  Open or In progress, and its Worktree is empty or already this branch; otherwise another worktree holds the step,
  and it stops, naming it. The schedule step writes only when the row's Worktree links this branch or this pull
  request; otherwise the step has moved, and it stops. The comment is posted once, the issue closed only while open.
  Each write is read back.
