---
title: "The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/557
status: draft
created: 2026-11-14
updated: 2026-11-14
---

# Plan: The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs

Step 43 of issue tracking, iteration 1 (#346), found while finishing #554 and #555. Every issue ends with a table of its
plan and design documents, and its Plan row links the issue's committed plan on the default branch
([development-process.md § Plans](../../guides/development-process.md#plans)). Nothing writes that link: an issue is
filed with a placeholder in the row, and no step of the [PR script template](../../guides/pr-script-template.md) fills
it in. This adds the step to the template, in bash and PowerShell, and fills in the issues whose plans are committed.
One pull request in this repository, from `feature/557-plan-row`, closes #557.

## Rulings

- 2026-11-14: filed as step 43, to be worked next.
- 2026-11-14, on the three plans that name no issue: noblefactor-engprod's `remove-go-code.md` fixed now, in this
  worktree; devlore-cli's two logged as one issue of their own.
- The process, already: every issue ends with the table; each row links a committed file; links go to the default
  branch.

## Current State

Read on 2026-11-14, from the 288 plans in noblefactor-engprod, devlore-cli, devlore.noblefactor.com and personal that
name an issue:

| What the issue's Plan row says | Issues |
| --- | --- |
| A placeholder: "Not yet opened" (56), "_arrives with the branch_" (29), and ten other wordings, some naming the plan's path without a link | 105 |
| Nothing: the issue has no Plan row, and no documents table | 99 |
| A link to a branch other than the default, dead once the branch was removed | 11 |
| A link to the plan on the default branch | 73 |

devlore-cli#373 is named by two plans. Three plans name no issue, their `issue:` line reading `issues/XX`:
noblefactor-engprod's `docs/plans/remove-go-code.md`, and devlore-cli's `docs/plans/uniform-race-detection.md` and
`docs/plans/knowledge-index-preserves-metadata.md`.

## Requirements

1. **The template's first-script step,** bash and PowerShell, after the push and beside the step's row, writes the
   Plan row of each step's issue, its plan named in the script beside its issue:
   - a Plan row with no link in it, whatever it says, becomes the link to the plan on the default branch;
   - a Plan row already linking that plan is left alone;
   - an issue with no documents table gets one, `## Plan and design documents`, with the Plan row;
   - an issue whose Plan row links another plan gets a second Plan row, for this one.

   Each issue is read back. Rule 13 and § A worktree's first script say so.
2. **The issues already filed,** in the four repositories, each named by a plan on its repository's default branch:
   the 105 placeholders and the 11 links to another branch become links to the plan on the default branch, and the 99
   issues without a table get one. Read from the plans and the issues when the step runs, not from the count above.
   An issue two plans name gets a Plan row for each. A row already linking the plan on the default branch is left
   alone, a note after it too.
3. **`remove-go-code.md`,** whose work landed in #130 on 2026-08-27, which closed no issue: Task #566 filed for it and
   closed as done in #130; the plan moved to `docs/plans/feature/566-remove-go-code.md`, its `issue:` line naming #566,
   its status complete and its boxes ticked from what #130 and #228 did; the README and plans #228 and #229, which cite
   it, citing it there. Committed by the first script, after the plan.
4. **Each issue written is read back,** and the comment that closes #557 lists every one, by repository, with what its
   row said before.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | The step, a Plan row with a placeholder | The row links the plan; read back |
| 2 | The step, a Plan row already linking the plan | Nothing written |
| 3 | The step, an issue with no documents table | The table appended, with the Plan row |
| 4 | The step, a Plan row linking another plan | A second Plan row, for this plan |
| 5 | Cases 1 to 4 with the step taken out | Each fails |
| 6 | Cases 1 to 4 in PowerShell | As in bash |
| 7 | The fill, run again after it has run | Nothing written |
| 8 | `make check` | Passes |

Cases 1 to 7 run as #450's did: the template's snippets composed into scripts, with a stand-in `gh` that records every
write, bash run by bash and PowerShell parsed by PowerShell's own parser and run by `pwsh`.

## Implementation Phases

### Phase 1: the plan

- [ ] Committed on `feature/557-plan-row` by the worktree's first script, with the template's first-script step;
      reviewed with the owner
- [ ] `remove-go-code.md` named for Task #566, and its citations (Requirement 3), committed by the first script after
      the plan

### Phase 2: the template's step

- [ ] The bash and PowerShell steps, § A worktree's first script and rule 13; cases 1 to 6 and 8

### Phase 3: the merge and the issues already filed

- [ ] This pull request merged; the issues' Plan rows filled, case 7, each read back and listed on #557; step 43 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `docs/guides/pr-script-template.md` | Modify |
| `docs/plans/remove-go-code.md`, to `docs/plans/feature/566-remove-go-code.md` | Move and modify |
| `README.md`, `docs/plans/chore/228-star-record-is-three-different.md`, `docs/plans/chore/229-agent-rules-gains-rule-12-a.md` | Modify |
| `docs/plans/feature/557-plan-row.md` | Create |

## Open Questions

- **The three plans that name no issue,** ruled 2026-11-14: `remove-go-code.md` fixed here (Requirement 3);
  devlore-cli's `uniform-race-detection.md` and `knowledge-index-preserves-metadata.md` logged as one issue of their
  own.
