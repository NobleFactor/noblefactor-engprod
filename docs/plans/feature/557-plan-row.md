---
title: "The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/557
status: active
created: 2026-11-14
updated: 2026-11-15
---

# Plan: The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs

Step 43 of issue tracking, iteration 1 (#346), found while finishing #554 and #555. Every issue ends with a table of its
plan and design documents, and its Plan rows link the issue's committed plans on the default branch
([development-process.md § Plans](../../guides/development-process.md#plans)). Nothing writes those links: an issue is
filed with a placeholder in the row, and no step of the [PR script template](../../guides/pr-script-template.md) fills
it in. This adds `star github plan link` to the GitHub extension. Its one purpose is that every issue traces back to
the plans that serve it: it reads the plans, which are the authority, and brings each issue's Plan rows to what they
say. The template's first-script step calls it, in bash and PowerShell alike, and run over every plan it fills in the
issues already filed. One pull request in this repository, from `feature/557-plan-row`, closes #557.

## Rulings

- 2026-11-14: filed as step 43, to be worked next.
- 2026-11-14, on the three plans that name no issue: noblefactor-engprod's `remove-go-code.md` fixed now, in this
  worktree; devlore-cli's two logged as one issue of their own, NobleFactor/devlore-cli#1228, in Triage: devlore.
- 2026-11-14: approved; then, on the step as first built, about 200 lines of bash and 400 of PowerShell for every first
  script: the step is a `star` command instead. The documents table is a table of metadata values, each row a kind and
  the document it names, and `star` could read it as values through a Markdown provider, logged as
  NobleFactor/devlore-cli#1229. Until that exists the command reads the issue's body by its lines, and its code says so
  in a TODO naming #1229 by its URL.
- 2026-11-15: one command, `star github plan link`, whose sole purpose is that our issues trace back to the plans that
  reference them. The plans are the authority: a plan is reviewed with the owner before the work and changes only
  through a pull request, and it names the issues it serves, the one it is named for in its `issue:` line and each
  other in an `## Issue NNN` heading. An issue has zero or more plans; its Plan rows are built from the plans, and
  never the other way. No second command writes the plans from the issues.
- 2026-11-15: the table stays Markdown in the issue's body. GitHub has no structured place for an issue's documents
  that works in both accounts and links a file: issue fields are NobleFactor's alone and hold no link; an issue's
  Development links name pull requests, not plans; project fields belong to a project's row. The table is a copy the
  command rebuilds and checks, so its format does not make it fragile.
- The process, already: every issue ends with the table; each row links a committed file; links go to the default
  branch; a plan carries an `## Issue NNN` heading for every issue it serves.

## Current State

Read on 2026-11-14, from the 288 plans in noblefactor-engprod, devlore-cli, devlore.noblefactor.com and personal that
name an issue by its URL:

| What the issue's Plan row says | Issues |
| --- | --- |
| A placeholder: "Not yet opened" (56), "_arrives with the branch_" (29), and ten other wordings, some naming the plan's path without a link | 105 |
| Nothing: the issue has no Plan row, and no documents table | 99 |
| A link to a branch other than the default, dead once the branch was removed | 11 |
| A link to the plan on the default branch | 73 |

devlore-cli#373 is named by two plans, `platform-test-matrix.md` and `windows-phase-3e.md`, and links neither. Six plans
in noblefactor-engprod serve two issues each, by their `## Issue NNN` headings. Some issues link a plan that does not
name them: Tasks #376 to #380 link #303's plan, which carries `## Issue 303` alone, and #393 links #384's. Three plans
named no issue, their `issue:` line reading `issues/XX`; one, noblefactor-engprod's `remove-go-code.md`, is fixed here
(Requirement 6). A read-only rehearsal of the fill, run in scratch, found 14 more plans whose `issue:` line is a bare
number or `#N`, and 48 whose line reads `TBD`, `pending`, or nothing, in devlore-cli and devlore.noblefactor.com. Two
issues' tables are not the standard one: devlore-cli#1179's columns are Document and Role, and devlore-cli#935's Plan
row names another repository's plan without a link.

## Requirements

1. **What a plan says.** A plan names the issues it serves: its `issue:` line, read from its frontmatter with `star`'s
   YAML decoder, by the issue's URL, or by a bare number or `#N` in the plan's own repository; and each `## Issue NNN`
   heading, an issue of the plan's own repository. The command checks that each names a real issue, not a pull request,
   `TBD` or `XX`, and that the number in the plan's file name, where it has one, is its `issue:` line's.
2. **What an issue's Plan rows should be.** One row for each plan that serves the issue:
   `| Plan | [<path>](https://github.com/<repository>/blob/<default branch>/<path>) |`, the repository's name now, so a
   link through an old name such as `noblefactor-ops` is the same repository.
3. **`star github plan link [<plan> ...]`,** run in a clone or worktree, for each issue the plans named serve, reads the
   issue's body exactly and, for each of those plans, of the lines that start `| Plan |`, does the first that applies:
   one already links the plan on the default branch, another link text, an anchor or a note after it too: nothing,
   `linked`; one links the plan on another branch: that row replaced, `repointed`; one has no link, whatever its words:
   the first replaced, `replaced`; they link other plans: the row added after the last, `added`; none, under a
   `## Plan and design documents` table: the row first in it, `inserted`; none and no such heading: the heading, a
   blank line, `| Kind | Document |`, `| --- | --- |` and the row at the end, `appended`; the heading with no table
   under it: nothing, `refused`. Every other byte is kept, each line's ending and the last line's. It writes the body
   once and reads it back, failing unless every row is there.

   It reads the body by its lines, with a TODO naming https://github.com/NobleFactor/devlore-cli/issues/1229, the
   Markdown provider that will let it read the table as values.
4. **`--all [<repository> ...]`** does the same for every plan on the default branch of each repository named, or of
   writ's layers, read after a fetch, never from a working tree; and reports, without changing them, the issues' Plan
   rows that no plan serving the issue backs, `unbacked`, for a person to settle by the plan, with an `## Issue NNN`
   heading, or by the row. **`--check`** reads and writes nothing, returning what each would do, so that it verifies the
   tables at any time; `star`'s own `--dry-run` refuses until NobleFactor/devlore-cli#1170 lets a dry run read. Each
   issue's closing pull request is reported too, when it merged none of the plans that serve the issue.
5. **Its result** is one record for each issue and plan: the issue, the plan, the action, the row before and after,
   and the issue's URL, with a `reason` on `refused` and `unbacked`. It exits 0 when every row was right or was written
   and read back, and non-zero otherwise, after every record under `--all`.
6. **`remove-go-code.md`,** whose work landed in #130 on 2026-08-27, which closed no issue: Task #566 filed for it and
   closed as done in #130; the plan moved to `docs/plans/feature/566-remove-go-code.md`, its `issue:` line naming #566,
   its status complete and its boxes ticked from what #130 and #228 did; the README and plans #228 and #229, which cite
   it, citing it there. Committed by the first script, after the plan.
7. **The template's first-script step,** in bash and PowerShell, after the push and beside each step's row, runs
   `star github plan link <plan>` for the worktree's plans and stops unless it exits 0. § A worktree's first script, its
   PowerShell form and rule 13 say so.
8. **The issues already filed,** in the four repositories: after the merge and `writ deploy`, `--all --check` and then
   `--all`, each issue read back, and the `unbacked` rows listed for the owner. Proposed, for the owner's ruling at this
   review:
   - devlore-cli#1179, its table Document and Role: left out of the fill, its one branch link pointed at `develop` by
     hand;
   - devlore-cli#935: its row given the link by hand, its note that it is Phase 4 of noblefactor-engprod's
     `docs/plans/fix/234-prose-is-not-checked-for.md` kept after it;
   - the 48 plans with `TBD`, `pending` or nothing: added to NobleFactor/devlore-cli#1228's scope, by a comment on it.
9. **Found beside the work,** proposed for the owner's ruling at this review: the template's merge step writes its
   message and body files with `mktemp` and `GetTempPath()`, against the rule that a script handed to the owner
   writes nothing to a temporary directory; fixed here, the files in the worktree's scratch directory. The template's
   PowerShell helpers break the PowerShell style guide, `Set-StepRow` flagged by PSScriptAnalyzer and `[int]` where the
   guide asks `[Int32]`: logged as one Task, in Triage: engprod.
10. **The comment that closes #557** lists every issue written, by repository, with what its row said before, and the
    `unbacked` rows.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | A placeholder, in its several wordings; the first of two | The row links the plan; read back |
| 2 | A row already linking the plan: plainly, through an anchor, a note, the `noblefactor-ops` name | Nothing written, `linked` |
| 3 | No documents table: with a last newline, without one, a blank end, an empty body | The table appended; the last line's ending kept |
| 4 | A row linking another plan; the same path in another repository | A second Plan row, `added` |
| 5 | A row linking the plan on another branch, before a placeholder | `repointed`, the placeholder left |
| 6 | The heading with a table and no Plan row; the heading with no table | `inserted`; `refused`, nothing written |
| 7 | `\r\n` bodies | Line endings kept |
| 8 | A plan serving two issues, by its `issue:` line and an `## Issue NNN` heading | Both issues get the row |
| 9 | A plan naming no issue; a bare number; a file name whose number is not its `issue:` line's; a pull request | `refused`, with its reason; the plan's own repository; `refused`; `refused` |
| 10 | The write not read back | Non-zero |
| 11 | `--all`: an issue two plans serve; a row no plan backs; run again | Both rows; `unbacked`, the row kept; nothing written |
| 12 | `--check` | Nothing written; the records `--all` would return |
| 13 | Each behavior taken out in turn | A case fails |
| 14 | `tests/Test-StarGitHub` and `make check` | Pass |
| 15 | Live, after the merge and `writ deploy`: `--all --check` on the four repositories | Matches the rehearsal |
| 16 | Live: `--all`; then `--all --check` | Each issue read back; then nothing left to write |

Cases 1 to 13 are in `tests/Test-StarGitHub`, with GitHub's stand-in answering from fixtures; the bodies and their
expected results are those of the rehearsal's 22 cases, in scratch.

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/557-plan-row` by the worktree's first script, with the template's first-script step;
      reviewed with the owner and approved on 2026-11-14
- [x] `remove-go-code.md` named for Task #566, and its citations (Requirement 6), committed by the first script after
      the plan
- [ ] Amended for `star github plan link`, ruled 2026-11-14 and 2026-11-15; reviewed with the owner

### Phase 2: the command and the template

- [ ] `star github plan link`, `--all` and `--check`; the template's first-script step, both forms, and rule 13; what
      the owner rules on in Requirement 9; cases 1 to 14

### Phase 3: the merge and the issues already filed

- [ ] This pull request merged; `writ deploy`; cases 15 and 16, with what the owner rules in Requirement 8; each issue
      read back and listed on #557, with the `unbacked` rows; step 43 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `extension.yaml` of the GitHub extension | Modify: the command |
| `commands/github-plan-link.star` of the GitHub extension | Create |
| `tests/Test-StarGitHub` | Modify |
| `docs/guides/pr-script-template.md` | Modify |
| `docs/plans/remove-go-code.md`, to `docs/plans/feature/566-remove-go-code.md` | Move and modify |
| `README.md`, `docs/plans/chore/228-star-record-is-three-different.md`, `docs/plans/chore/229-agent-rules-gains-rule-12-a.md` | Modify |
| `docs/plans/feature/557-plan-row.md` | Create |

## Open Questions

- **Requirement 8's three proposals and Requirement 9's two,** for the owner's ruling at this review.
