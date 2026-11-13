---
title: "The sweep returns a step with no step number to Triage, the last of #427"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/427
status: complete
created: 2026-11-12
updated: 2026-11-12
---

# Plan: The sweep returns a step with no step number to Triage, the last of #427

Step 33 of issue tracking, iteration 1 (#346). #427 asked that the report and the audit read schedules and scenarios
from their projects. #379 did that on 2026-11-08: the report returns each issue's rows on its team's Backlog, Schedule
and Scenario projects, with schedule, step, status and worktree, or scenario and beat, and the audit is gone. Its last
requirement was not met: the sweep (#436) catches an issue on two schedules, by its `two-homes` rule, but has no rule
for a step whose row has no step number, though section 3 of the issue data model says it will (ruled 2026-11-04).
Ruled 2026-11-12, on the owner's word: the rule is added to the sweep under #427. One pull request from
`feature/427-sweep-no-step`.

## Requirements

1. The sweep's `no-step` rule: a task or bug whose row on a Schedule project names a schedule and has no step is a
   fault, added to its team's Triage project with a comment naming the rule. A Schedule issue's own row, which has no
   step by rule, is left alone.
2. Section 3 says the sweep returns such a row, and its status page says the rule is built.
3. #427 closes with the report for #346 beside the board's view of it, the report for one scenario, and the rule's
   tests.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | A task on Schedule: engprod under s1 with no step | `no-step` |
| 2 | A Schedule issue whose own row has no step | No fault |
| 3 | `tests/Test-StarGitHub` and `make check` | Pass; the cases that count the fixtures' issues count the two new ones |
| 4 | Live, read from the deployed report on 2026-11-12 | No open task or bug on a schedule has a row with no step |

## Implementation Phases

- [x] The rule, its two fixtures and its case, and the counts brought to the fixtures; section 3 and its status page
- [x] The pull request script: merge, deploy, #427 closed with its evidence, step 33 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/github-triage-sweep.star` | Modify |
| `tests/Test-StarGitHub` | Modify |
| `docs/architecture/issue-data-model/3-collections.md` and its status page | Modify |
| `docs/plans/feature/427-sweep-no-step.md` | Create |
