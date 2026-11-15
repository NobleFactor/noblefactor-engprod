---
title: "The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/557
status: active
created: 2026-11-14
updated: 2026-11-15
---

# Plan: The PR script template links each step's plan in its issue's Plan row, and the issues that still say Not yet opened get theirs

Step 43 of issue tracking, iteration 1 (#346), found while finishing #554 and #555. Every issue ends with a table of its
plan and design documents ([development-process.md § Plans](../../guides/development-process.md#plans)). Nothing
writes it: an issue is filed with a placeholder in its Plan row, and no step of the
[PR script template](../../guides/pr-script-template.md) fills it in. This adds `star github plan link` to the GitHub
extension. Its one purpose is that every issue traces back to the plans that serve it: it reads the plans, which are
the authority, and writes the issue's whole `Plan and design documents` section from them, the plans' links and the
design documents the plans name. The template's first-script step calls it, in bash and PowerShell alike, and run over
every plan it brings the issues already filed to the same table. One pull request in this repository, from
`feature/557-plan-row`, closes #557.

## Rulings

- 2026-11-14: filed as step 43, to be worked next.
- 2026-11-14, on the three plans that name no issue: noblefactor-engprod's `remove-go-code.md` fixed now, in this
  worktree; devlore-cli's two logged as one issue of their own, NobleFactor/devlore-cli#1228, in Triage: devlore.
- 2026-11-14: approved; then, on the step as first built, about 200 lines of bash and 400 of PowerShell for every first
  script: the step is a `star` command instead. `star` could read Markdown as values through a Markdown provider,
  logged as NobleFactor/devlore-cli#1229; until that exists the command reads the issue's body by its lines, and its
  code says so in a TODO naming #1229 by its URL.
- 2026-11-15: one command, `star github plan link`, whose sole purpose is that our issues trace back to the plans that
  reference them. The plans are the authority: a plan is reviewed with the owner before the work and changes only
  through a pull request, and it names the issues it serves, the one it is named for in its `issue:` line and each
  other in an `## Issue NNN` heading. An issue has zero or more plans. No command writes a plan from its issues.
- 2026-11-15: the table stays Markdown in the issue's body. GitHub has no structured place for an issue's documents
  that works in both accounts and links a file: issue fields are NobleFactor's alone and hold no link; an issue's
  Development links name pull requests, not plans; project fields belong to a project's row.
- 2026-11-15, on its syntax: `star github plan link <plan>... [--check]`, or `star github plan link --all
  [--repository <owner/name>,...] [--check]`, one or the other; a plan named by its path relative to `docs/plans`, in
  the clone the command runs in. The first live run is `--all --check`, its report reviewed with the owner before `--all`
  writes anything; many inconsistencies are expected.
- 2026-11-15: the command exits non-zero only on an error, as section 8 rules for every command; what it finds is in its
  records.
- 2026-11-15, on Requirement 9: the template's merge step keeps its `mktemp` and `GetTempPath()` files. The rule
  against temporary directories is for work that must outlive the run, which an agent has lost there; a real temporary
  file, made and removed within one run, is not what it forbids. The template's PowerShell helpers are brought to the
  PowerShell style guide here, in this pull request.
- 2026-11-15, replacing the rules for finding and editing Plan rows line by line, which text written by hand in many
  forms would defeat, devlore-cli#1179's table, its columns Document and Role, the first case of it: the command finds
  the issue's `Plan and design documents` section by its heading and replaces the whole section with the table the
  plans give. It reads none of the section's rows. So the plans are the authority for the whole table: a plan names, in
  its frontmatter, the design documents it bears on, and the table is the issue's plans and their documents. An issue
  no plan serves keeps the section it was filed with.
- 2026-11-15: `--repository` takes a comma-separated list, `--repository A,B`, as `--blocked-by` does, since `star`'s
  extension flags cannot repeat. Every flag that takes such a list, `--blocked-by`, `--token` and `--repository`,
  carries a TODO naming Task #315 by its URL, to take the repeated form once they can. Under `--all`, an error on one
  issue does not stop the run: every other issue is still done, and then the command fails with a message naming each
  error and listing every issue's outcome; a following `--all --check` gives the records, since `star` prints no
  records from a command that fails.
- 2026-11-15: a link in an issue's section points by the issue's state: an open issue's, and one closed without a merged
  pull request, to the default branch; one closed by a merged pull request, to that pull request's merge commit, a fixed
  record of what landed (Requirement 2).
- 2026-11-15: the section ends at the next heading at its level or above, or at a thematic break line, `---`, `***` or
  `___` alone, whichever comes first; the break and everything after it are kept. Ten issues end their table with
  `---` and a signature or a word after it, which a section running to the end of the body would delete.
- 2026-11-15: a plan is classified through its issue, by the issue's Area and type, which GitHub holds and triage
  changes; never by its path or its frontmatter, where a copy would go stale. Each record carries its issue's Area and
  type. A plan's directory is its branch's type, as the process says, for finding it, not classifying it; so the check
  that a file's name begins with its issue's number applies only to files directly in a type directory. devlore-cli's
  directories named for subjects, and its `task` directory, which the branch ruleset does not name, are a finding for
  NobleFactor/devlore-cli#1228.
- 2026-11-15: the heading is matched without regard to case, so a heading typed with other capitals is the section and
  gets no second one; only a heading written with `#` counts, not an underlined one.
- 2026-11-15: style is enforced universally. Every style guide and linter that covers a file this pull request changes
  applies to it in full, and the template's PowerShell is brought to the whole of the PowerShell guide, § 7 among it
  (Requirement 9). A style checker is to run against every change within a month.
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

The issue forms write the section as `### Plan and design documents`, a field of the form; issues written through the
API, `## Plan and design documents`. devlore-cli#373 is named by two plans and links neither. Six plans in
noblefactor-engprod serve two issues each, by their `## Issue NNN` headings. Some tables hold rows no plan names: Tasks
#376 to #380 link #303's plan, which carries `## Issue 303` alone; #393 links #384's; devlore-cli#1179's columns are
Document and Role; devlore-cli#935's Plan row names another repository's plan. The plan template, `docs/plans/TEMPLATE.md`,
lists a plan's related documents in prose, in its `## Related Documents` section; no plan names its design documents
where a command can read them. Three plans named no issue, their `issue:` line reading `issues/XX`; one,
noblefactor-engprod's `remove-go-code.md`, is fixed here (Requirement 6). A read-only rehearsal, run in scratch, found
14 more plans whose `issue:` line is a bare number or `#N`, and 48 whose line reads `TBD`, `pending`, or nothing, in
devlore-cli and devlore.noblefactor.com.

## Requirements

1. **What a plan says,** read from its frontmatter with `star`'s YAML decoder, and from its headings:
   - the issues it serves: its `issue:` line, by the issue's URL, or by a bare number or `#N` in the plan's own
     repository; and each `## Issue NNN` heading, an issue of the plan's own repository;
   - the design documents it bears on: `documents:`, a list, each entry a `kind`, such as `Design: collections`, and
     either a `path` in the plan's own repository or a `url` for anything else, with an optional `text` to show in place
     of the path.

   The command checks that each issue named is a real issue, not a pull request, `TBD` or `XX`; that the number in the
   file name of a plan directly in a type directory, `docs/plans/<type>/<issue>-<name>.md`, its type one of the branch
   ruleset's, `doc`, `feature`, `fix`, `hotfix`, `refactor` and `release`, or `chore`, from before it was retired, or
   devlore-cli's `task`, is its `issue:` line's, a file elsewhere under `docs/plans` not checked by its name; and that each document's `path` exists where its link
   points (Requirement 2): for an open issue, on the default branch or, in `<plan>` mode, in the clone's working tree,
   where it lands with the merge as the plan's own link does; for an issue closed by a merged pull request, at that
   pull request's merge commit. A plan that fails a check is `refused`, with its reason, and nothing is written for it.
2. **The section an issue should have,** from every plan that serves it:

   ```markdown
   ## Plan and design documents

   | Kind | Document |
   | --- | --- |
   | Plan | [<plan path>](https://github.com/<repository>/blob/<ref>/<plan path>) |
   | <kind> | [<text or path>](<the document's link>) |
   ```

   One Plan row for each plan, by path; then each plan's documents, in the order it lists them, a document two plans
   name once. Each link's repository is under its name now, so a link through an old name such as `noblefactor-ops` is
   the same repository. The heading keeps the issue's own level, `##` or `###`. Ruled 2026-11-15, `<ref>` follows the
   issue's state, for the Plan rows and the documents' paths alike; a document by `url` keeps its URL:

   | The issue | `<ref>` | Why |
   | --- | --- | --- |
   | Open | the default branch | It follows the plan as the work changes it |
   | Closed by a merged pull request | that pull request's merge commit | A fixed record of what landed, which cannot break |
   | Closed without one: not planned, or by hand | the default branch | There is no commit to fix it to |

   When an issue closes, the next `--all` writes its links at the merge commit, and they do not change after. A path
   not in that merge commit, a file moved after the merge, is linked on the default branch instead, the record saying
   so; it is a finding, not a refusal.
3. **`star github plan link <plan>...`,** run in a clone or worktree, each plan its path relative to `docs/plans`: for
   each issue the plans named serve, it writes that issue's section from every plan that serves it. It reads every plan
   on the default branch of writ's layers and of each `--repository` named, comma-separated, so that a plan of another repository serving
   the same issue is in the table, and takes the plans named from the working tree, since the first script runs it
   before they merge. It finds the section by its heading, `Plan and design documents` at level 2 or 3, running to the
   next heading at that level or above, or to a thematic break line, `---`, `***` or `___` alone outside a table or a
   fenced block, which it keeps with all after it, or to the end of the body:
   - one such heading: the section replaced, `written`, or nothing when it already is the section the plans give,
     `unchanged`;
   - none: the section added at the end of the body, after a blank line, `appended`;
   - two or more: nothing, `refused`.

   Every byte outside the section is kept; the section's lines end as the body's do, `\r\n` or `\n`. It writes the body
   once and reads it back, failing unless the section reads as written. It finds the heading by the body's lines, with a
   TODO naming https://github.com/NobleFactor/devlore-cli/issues/1229, the Markdown provider that will let it read the
   body's sections as values.
4. **`--all [--repository <owner/name>,...]`** does the same for every issue that a plan under `docs/plans` on the default
   branch of each repository named, or of writ's layers, serves, read after a fetch, never from a working tree; plans and
   `--all` together are an error. An issue no plan serves is not touched. **`--check`** reads and writes nothing,
   returning what each would do, so that it verifies every issue's section at any time; `star`'s own `--dry-run` refuses
   until NobleFactor/devlore-cli#1170 lets a dry run read.
5. **Its result** is one record for each issue: the issue, its Area and type, read from GitHub with it, the plans that
   serve it, the action, the section before and after, the rows of the section before that the section after does not hold, `dropped`, and the issue's URL, with a
   `reason` on `refused`. It exits non-zero only on an error: a plan or an issue it cannot read, or a write that does not
   read back. Under `--all` an error on one issue does not stop the run: every other issue is still done, and then the
   command fails with a message naming each error and listing every issue's outcome; a following `--all --check` gives
   the records, since `star` prints no records from a command that fails. `refused` and `dropped` are findings, and it
   exits 0 on them.
6. **`remove-go-code.md`,** whose work landed in #130 on 2026-08-27, which closed no issue: Task #566 filed for it and
   closed as done in #130; the plan moved to `docs/plans/feature/566-remove-go-code.md`, its `issue:` line naming #566,
   its status complete and its boxes ticked from what #130 and #228 did; the README and plans #228 and #229, which cite
   it, citing it there. Committed by the first script, after the plan.
7. **The template's first-script step,** in bash and PowerShell, after the push and beside each step's row, runs
   `star github plan link <plan>...` for the worktree's plans, each relative to `docs/plans`, and stops unless it exits
   0. § A worktree's first script, its PowerShell form and rule 13 say so. The plan template, `docs/plans/TEMPLATE.md`,
   gains `documents:` in its frontmatter, and its `## Related Documents` section says the design documents go there.
8. **The issues already filed,** in the four repositories: after the merge and `writ deploy`, `--all --check`, its
   report reviewed with the owner before `--all` writes anything. Its `dropped` rows say which plans need `documents:`
   entries first, so that no design document an issue links is lost; how the plans in each repository gain them is
   ruled with the report. Ruled 2026-11-15: every file under `docs/plans` with frontmatter is a plan, and one naming no
   issue is `refused`, a finding, as is a file with no frontmatter; read in the rehearsal, 130 plans with no `issue:`
   line, 77 of them for finished work, 129 in devlore-cli, and 58 files with no frontmatter. NobleFactor/devlore-cli#1228's
   scope grows, by a comment on it, to all of them: the plans with no `issue:` line, the files with no frontmatter, the
   48 whose line reads `TBD`, `pending` or nothing, devlore-cli 974's plan naming a pull request, the 74 whose `status:`
   is prose rather than one of the five values, and devlore-cli's subject directories and its `task` directory. The
   refusals shrink as #1228 fixes those plans.
9. **Found beside the work,** ruled 2026-11-15: the template's PowerShell helpers, `Get-StepRow`, `Set-StepRow` and
   the rest of its PowerShell form, brought to the
   [PowerShell style guide](../../guides/powershell-style-guidelines.md) here: `[Int32]` and `[String]` where they say
   `[int]` and `[string]`, a header above each function in place of comments inside it, and nothing PSScriptAnalyzer
   flags with the organization's settings, `Set-StepRow`'s state-changing without `ShouldProcess` among them; the
   composed first and merge scripts parsed and analyzed. The template's merge step keeps its `mktemp` and
   `GetTempPath()` files, which are made and removed within one run. Ruled later on 2026-11-15, the whole of the guide,
   § 7 among it: the script notes its caller's error action, sets `Stop`, and runs its work in `try` and `catch`, the
   `catch` restoring the caller's error action, reporting with `$PSCmdlet.WriteError` and exiting 1; each refusal an
   error record of its own, with an id and a category, not a thrown string; what it is doing on the verbose stream,
   with `Write-Verbose`, a result an output object, nothing on the host or the information stream. Since its progress
   then shows only with `-Verbose`, the template's Windows section hands a PowerShell script over as
   `& '<script>.ps1' -Verbose`. Every style guide and linter that covers a file this pull request changes applies to it
   in full: buildifier for the Starlark, shellcheck and shfmt for the bash, the documentation standards for the
   Markdown, and the PowerShell guide with PSScriptAnalyzer.
10. **The comment that closes #557** lists every issue written, by repository, with its section before, and the
    `dropped` rows.
11. **The design documents:** [development-process.md § Plans](../../guides/development-process.md#plans), the plans the
    authority for an issue's whole section, and a plan naming its design documents in its frontmatter;
    [section 7](../../architecture/issue-data-model/7-the-workflow-before-and-after.md)'s row for the documents table;
    [section 8](../../architecture/issue-data-model/8-the-schedule-commands.md#linking-plans-plan-link)'s section for
    `plan link`; and the plan template. Each status gains a box for the command, left open until it is built.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | An issue with the section at `##`; at `###`, as a form writes it | `written`, the heading's level kept; read back |
| 2 | The section already what the plans give | `unchanged`, nothing written |
| 3 | No section: with a last newline, without one, an empty body | `appended`; every byte before it kept |
| 4 | Two sections | `refused`, nothing written |
| 5 | The section followed by another heading, at its level and below it | The section ends at the heading at its level or above; a lower heading inside it is replaced with it |
| 6 | Rows the plans don't give: a note, devlore-cli#1179's columns, a row for another plan | `written`; each in `dropped` |
| 7 | A plan serving two issues, by its `issue:` line and an `## Issue NNN` heading; an issue two plans serve, one in another repository | Both issues written; both plans' rows in the one table |
| 8 | A plan's `documents:` by `path`, by `url`, with `text`; a document two plans name | Each a row, in order; the shared one once |
| 9 | A plan naming no issue; a bare number; a file name whose number is not its `issue:` line's; a pull request; a `path` not on the default branch | `refused`, with its reason; the plan's own repository; `refused`; `refused`; `refused` |
| 10 | `\r\n` bodies | The section's lines end `\r\n`; every other byte kept |
| 11 | The write not read back; plans and `--all` together; a path outside `docs/plans` | Non-zero; an error, non-zero; `refused`, exit 0 |
| 12 | `--all`, run again; `--all` with one issue that cannot be read | Every issue `unchanged`; every other issue done, then a failure naming the one and listing every outcome |
| 12a | Links by state: an open issue; one closed by a merged pull request; one closed as not planned; a plan moved after its merge; a `documents:` path the same pull request adds, in `<plan>` mode | The default branch; the merge commit; the default branch; the default branch, with its reason; accepted, linked on the default branch |
| 12b | An issue that closes, then `--all` twice | Its links rewritten at the merge commit; then `unchanged` |
| 12c | `--repository A,B`; the TODO naming Task #315 beside each comma-separated flag's split | Both repositories read; the TODOs present |
| 12d | A table, then `---` and a signature; a `---` inside a fenced block or a table | The signature kept, not in `dropped`; the section not ended there |
| 12e | A step-numbered file in a subject directory; a misnumbered file in `feature/` | Accepted; `refused` |
| 12f | A record's Area and type, in an organization and in a user account | The issue field and type; the `area:` and type labels |
| 12g | A heading with other capitals; a setext heading of the same words | The section, written, no second one added; not the section |
| 12h | The template's PowerShell first and merge scripts, composed | No parser error, no analyzer finding; § 7's `try` and `catch`, error records and verbose stream |
| 13 | `--check` | Nothing written; the records `--all` would return |
| 14 | Each behavior taken out in turn | A case fails |
| 15 | `tests/Test-StarGitHub` and `make check` | Pass |
| 16 | Live, after the merge and `writ deploy`: `--all --check` on the four repositories | Every issue's record, its `dropped` rows listed |
| 17 | Live: `--all`; then `--all --check` | Each issue read back; then every issue `unchanged` |

Cases 1 to 14 are in `tests/Test-StarGitHub`, with GitHub's stand-in answering from fixtures; the rehearsal's 22 bodies,
in scratch, are among them.

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/557-plan-row` by the worktree's first script, with the template's first-script step;
      reviewed with the owner and approved on 2026-11-14
- [x] `remove-go-code.md` named for Task #566, and its citations (Requirement 6), committed by the first script after
      the plan
- [x] Amended for `star github plan link`, ruled 2026-11-14 and 2026-11-15; reviewed with the owner on 2026-11-15
- [x] The design documents brought to that design, 2026-11-15
- [x] Amended for the whole section written from the plans, ruled 2026-11-15, with the design documents and the plan
      template; reviewed with the owner and approved on 2026-11-15

### Phase 2: the command and the template

- [ ] `star github plan link`, `--all` and `--check`; the template's first-script step, both forms, and rule 13; the
      template's PowerShell helpers brought to the style guide (Requirement 9); cases 1 to 15

### Phase 3: the merge and the issues already filed

- [ ] This pull request merged; `writ deploy`; case 16, its report reviewed with the owner, and the plans' `documents:`
      entries it calls for, as the owner rules; case 17; each issue read back and listed on #557; step 43 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `extension.yaml` of the GitHub extension | Modify: the command |
| `commands/github-plan-link.star` of the GitHub extension | Create |
| `tests/Test-StarGitHub` | Modify |
| `docs/guides/pr-script-template.md` | Modify |
| `docs/plans/TEMPLATE.md` | Modify: `documents:` |
| `docs/plans/remove-go-code.md`, to `docs/plans/feature/566-remove-go-code.md` | Move and modify |
| `README.md`, `docs/plans/chore/228-star-record-is-three-different.md`, `docs/plans/chore/229-agent-rules-gains-rule-12-a.md` | Modify |
| `docs/guides/development-process.md` | Modify: § Plans |
| `docs/architecture/issue-data-model/7-the-workflow-before-and-after.md` and its status | Modify |
| `docs/architecture/issue-data-model/8-the-schedule-commands.md` and its status | Modify |
| `docs/plans/feature/557-plan-row.md` | Create |

## Open Questions

- **Requirement 9's two proposals,** ruled 2026-11-15: the temporary files stay; the PowerShell style is fixed here.
- **Requirement 8:** how the plans in each repository gain the `documents:` entries the `dropped` rows call for, ruled
  with `--all --check`'s report; and the proposal that the 48 plans naming no issue go to devlore-cli#1228. The proposals
  for devlore-cli#1179 and #935 by hand are withdrawn: the command replaces their sections, and what it drops is listed
  for the owner.
