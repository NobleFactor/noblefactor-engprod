---
title: "The Scenario projects' readme says they hold the scenarios and the tasks and bugs found while walking them"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/554
status: active
created: 2026-11-14
updated: 2026-11-14
---

# Plan: The Scenario projects' readme says they hold the scenarios and the tasks and bugs found while walking them

Step 41 of issue tracking, iteration 1 (#346), found while finishing #453. Every Scenario project's readme still says
the project holds the team's features. Ruled 2026-11-04, it holds the team's Scenario issues and the tasks and bugs
found while walking each one ([section 3](../../architecture/issue-data-model/3-collections.md)). This changes the
readme in the reference model and on all five Scenario projects, and records each account's model. One pull request in
this repository, from `feature/554-scenario-readme`, closes #554 and #555, whose
[plan](../fix/555-copy-readme.md) has `diff` and `apply` hold a team copy's readme and short description to its
template's. The two backups are pull requests that `star` opens and merges itself, after this one merges.

## Rulings

- 2026-11-04, in #303's closing: a Scenario project holds the team's Scenario issues and the tasks and bugs found while
  walking each scenario; a row's Beat is the point in the walk where its task or bug turned up.
- 2026-11-14: filed and worked now, as step 41.
- 2026-11-14, on this plan: approved as written.
- 2026-11-14: #555, found while this plan's script ran, is fixed in this pull request, since it had not opened yet.

## Current State

Read on 2026-11-14:

| What | Where it stands |
| --- | --- |
| The Scenario template in the extension's `reference/templates.yaml` | Its readme says the project holds the team's features, and each option is named for a Scenario issue "which tells the story" |
| NobleFactor's Scenario template and its copies, Scenario: engprod and Scenario: devlore | The same readme, word for word |
| David-Noble-at-work's Scenario project and its copy, Scenario: David-Noble-at-work | The same readme, word for word |
| Each account's model, read by `get`, with the new readme | `diff` finds one difference: `template Scenario different` |
| `apply` and `diff` on a team copy | Neither touches a copy's readme; they hold its fields and views to its template |

## Requirements

1. **The readme,** in the reference and on all five projects:

   > A team's Scenario project holds its Scenario issues, and the tasks and bugs found while walking each one.
   >
   > - The Scenario field names the scenario each row belongs to: one option per scenario, named for its Scenario issue.
   > - Beat is the point in the walk where a task or bug turned up, and it orders the rows within a scenario.
   > - Status is Open, In progress or Closed.

2. **Each account's template** is set by `apply`, from the account's own model with the one readme changed, and only
   while `diff` finds that one difference. `diff` then finds nothing. `backup` records each account's model after the
   merge, in #555's live run, so that the model it records has the copies' short descriptions too.
3. **The three copies:** NobleFactor's two, Scenario: engprod and Scenario: devlore, were set directly on 2026-11-14,
   before #555 was found, and read back. Scenario: David-Noble-at-work is left for `apply` to set after the merge, with
   #555's fix: its live test.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `diff` of each account's model, the readme changed, before `apply` | `template Scenario different`, and nothing else |
| 2 | `diff` after `apply` | Nothing |
| 3 | Each of the five projects' readme, read from GitHub, after #555's live run | The new readme, exactly |
| 4 | `tests/Test-StarGitHub` and `make check`, on the reference as changed | Pass |

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/554-scenario-readme` by the worktree's first script, with the template's first-script
      step; reviewed with the owner and approved on 2026-11-14; amended for #555 the same day

### Phase 2: the readme, in both accounts and the reference

- [ ] Both templates set by `apply`; NobleFactor's two copies set; the reference changed

### Phase 3: the merge

- [ ] This pull request merged, closing #554 and #555; after #555's live run, every Scenario project read back and
      both models recorded by `backup`; #554's evidence, by the template's schedule step; step 41 Closed

## Files to Create/Modify

| Repository | File | Action |
| --- | --- | --- |
| noblefactor-engprod | `reference/templates.yaml` of the extension | Modify |
| noblefactor-engprod | `docs/plans/feature/554-scenario-readme.md` | Create |
| NobleFactor/.github, David-Noble-at-work/.github | `model.yaml` | Landed by `backup` |

## Open Questions

- **A copy's readme,** whether `diff` and `apply` should hold it to its template's: ruled 2026-11-14, yes, with its
  short description, in #555, in this pull request.
