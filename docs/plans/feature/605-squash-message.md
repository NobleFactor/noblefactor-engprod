---
title: "Each repository squash-merges with the pull request's title and description"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/605
issues:
  - https://github.com/NobleFactor/noblefactor-engprod/issues/608
  - https://github.com/NobleFactor/noblefactor-engprod/issues/606
  - https://github.com/NobleFactor/noblefactor-engprod/issues/607
status: active
created: 2026-11-19
updated: 2026-11-19
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md
  - kind: Guide
    path: docs/guides/pr-script-template.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
---

# Each repository squash-merges with the pull request's title and description

<a id="role-assignments"></a>

## 1. Role assignments

Owner: David Noble. Participant: the Claude Code session assigned to Schedule #588, as coder. Reviewer: whoever the owner appoints, as for PR #604. Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

When the owner merges a pull request in GitHub, the commit that lands ends with the pull request's `Signed-off-by:` and `Assisted-by:` lines, with no script involved. At the end:

- Every repository that takes part in an account's issue model squash-merges with the pull request's title and description.
- `star github model diff` reports a participating repository whose squash-merge setting differs, and `star github model apply` sets it, as they already do for its Triage workflow, its variable and its secrets.
- A pull request's description ends with the two lines, with nothing after them, so they are the last lines of the commit and git reads them as trailers.
- The PR script template stops at a pull request that passes CI and is ready to merge. The owner merges in GitHub. The records after the merge, its time and each step's record, are made when the owner asks, by the script's second part.

- A pull request names each issue it completes with a closing keyword, so GitHub links it, fills the Linked pull requests column and closes the issue at the merge; an issue whose deployment or verification then fails is reopened (Task #608, ruled 2026-11-19).

Out of scope: the rest of the handbook's PR procedure, which Task #582's rewrite owns (see section 11); repositories that take no part in the issue model; and any other repository setting.

## Issue 605

[Task #605](https://github.com/NobleFactor/noblefactor-engprod/issues/605): GitHub's squash merge builds the commit message from the branch's commit list in every repository we checked, so PR #604 landed as 643652b with neither trailer.

## Issue 608

[Task #608](https://github.com/NobleFactor/noblefactor-engprod/issues/608): the Linked pull requests column of every project view stays empty, since our pull requests named their issues without a closing keyword whenever work was left after the merge. The owner ruled on 2026-11-19 that a pull request closes the issues it completes, and reopens one whose deployment or verification fails. The process's § Completion and progression, the PR procedure's § Issue closure and the PR script template say so; the column stays.

## Issue 606

[Bug #606](https://github.com/NobleFactor/noblefactor-engprod/issues/606): `star github issue open` takes a documents table whose delimiter row has fewer cells than its header, which GitHub doesn't render as a table. `has_table` in `commands/markdown.star` compares the two rows' cell counts, and a case of `tests/Test-StarGitHub` refuses a mismatch, failing without the fix.

## Issue 607

[Bug #607](https://github.com/NobleFactor/noblefactor-engprod/issues/607): section 10 says a stopped `open` or `reopen` finishes when run again, and neither does. Section 10 says what a rerun of each command finishes and what is done by hand, as it does for `close` under D-009. Finishing a stopped run is designed apart, in Task #609, left in Triage, as the owner's documenter advised and the owner approved on 2026-11-19.

<a id="current-state"></a>

## 3. Current state

- Each repository has `squash_merge_commit_title: COMMIT_OR_PR_TITLE` and `squash_merge_commit_message: COMMIT_MESSAGES`, read on 2026-11-19 in noblefactor-engprod, devlore-cli, NobleFactor/.github and personal. GitHub's merge dialog fills the message from the commit list, and the branch's commits carry no trailers, as the rules require.
- The PR script template merges with `gh pr merge --squash --subject … --body-file …`, which writes the description into the commit, and then records the merge. The owner doesn't run a script to merge, so none of that happens.
- The template's description ends `Signed-off-by: …`, `Assisted-by: …`, then `## Time` with a placeholder, which the merge step replaced; with the PR body as the message, the placeholder would land after the trailers.
- `participation.star` reads, compares and applies what a participating repository needs beyond the model: its Triage workflow, its `TRIAGE_PROJECT_URL` variable and its secrets. It reads no repository setting.

<a id="design-impact"></a>

## 4. Design impact

Section 6 of the issue data model, § what an account needs beyond its model, gains the setting: a participating repository squash-merges with the pull request's title and description, so that a merge in GitHub carries the description's trailers. It is a design choice with a reason, recorded there with its alternatives (section 6 below); sections 1 to 7 have no decisions companions until Task #598 rewrites them.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

1. **Read.** `participation.star`'s `read` takes each participating repository's `squash_merge_commit_title` and `squash_merge_commit_message` from `GET repos/<repository>`, one call per repository beside the reads it makes of its workflow, variable and secrets.
2. **Compare.** `compare` gives one record for a repository whose setting is not `PR_TITLE` and `PR_BODY`, naming what it has, as a workflow or variable difference is named.
3. **Apply.** `apply` sets the two fields with `PATCH repos/<repository>`, reads them back, and records the change. A repository the token can't change, which needs admin, is a record marked to be done by hand, as a variable whose repository has no Triage project is.
4. **The template.** The description ends with the two lines. The `## Time` section is added after the merge, by the script's second part, appended to the description, where it doesn't touch the commit. The script's first part stops at a passing, mergeable pull request and says so; it prints no merge command. The template says the owner merges in GitHub.
5. **The cases.** `tests/Test-StarGitHub` adds the setting to its fixtures and cases: `get` holds it, `diff` reports a repository whose setting differs and none whose setting matches, and `apply` writes it and reads it back.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **Set each repository by hand.** Quick, but a new repository, or one changed by hand, would drift with nothing to notice. The model already watches each participating repository; the setting belongs with what it watches.
- **Keep the script's merge.** The owner merges in GitHub (ruled 2026-11-19), so a script's merge message is never used.
- **Check trailers after the merge, in CI or a workflow.** It could only report the gap: develop's history is never rewritten.
- **The merge dialog is editable.** Someone can delete the lines before confirming. The setting makes the right message the default; it cannot force it. The evidence merge shows the default works.
- **The first merge with the setting.** If the owner allows, `apply` from this branch sets noblefactor-engprod's setting before this pull request merges, so its own merge in GitHub is the test of the evidence. Otherwise the next pull request after `writ deploy` and `apply` is.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| The model reads and compares the setting | `diff` reports a repository whose setting differs, and none whose setting matches | Cases in `tests/Test-StarGitHub` | `make check` |
| The model sets it | `apply` sets `PR_TITLE` and `PR_BODY` and reads them back | Cases; then `diff` after `apply` shows no difference | Test; NobleFactor and David-Noble-at-work |
| A merge in GitHub carries the trailers | The landed commit ends with `Signed-off-by:` and `Assisted-by:` | `git log -1 --format=%B` of the squash commit | A pull request merged by the owner in GitHub |
| The template matches how the owner merges | It stops before the merge, prints no merge command, and adds the time after | Read of the template | `docs/guides/pr-script-template.md` |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The cases, `make check`, review | Cases 171 to 174 pass, 545 of 545, and those of 171 to 173 fail without their fixes (2026-11-19); `make check` and review pending |
| Merge | Yes | The pull request, merged by the owner in GitHub | Pending |
| Deployment | Yes: the setting reaches each repository only through `apply` | `writ deploy`, then `model apply` for NobleFactor and David-Noble-at-work | Pending |
| Verification | Yes | `diff` showing no difference; a merge in GitHub carrying both trailers | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [x] This plan committed on `feature/605-squash-message` and reviewed with the owner: approved 2026-11-19

### 9.2 Phase 2: the setting and the template

- [x] `participation.star` reads, compares and applies the setting; section 6 says so; the cases pass: 172 to 174, 545 of 545 on 2026-11-19, and 172 and 173 fail without the fix
- [x] The PR script template stops before the merge, ends the description with the trailers, and adds the time after the merge: its first part stops at a mergeable pull request, and run again after the merge, its second part records it
- [x] The process, the PR procedure and the template name each issue a pull request completes with a closing keyword, and reopen one whose deployment or verification fails (#608)
- [x] `has_table` compares the header's and the delimiter's cell counts, with a case (#606): case 171, which fails without the fix
- [x] Section 10 says what a rerun of `open` and `reopen` finishes and what is done by hand (#607)

### 9.3 Phase 3: the merge, the deployment and the verification

- [ ] The pull request merged by the owner in GitHub
- [ ] `writ deploy`, then `model diff` and `apply` for both accounts, each read back
- [ ] A merge in GitHub whose landed commit carries both trailers; the issue closed with its evidence on the owner's approval

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/participation.star`: read, compare and apply the setting.
- `tests/Test-StarGitHub`: the fixtures and cases.
- `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md`: the design.
- `docs/guides/pr-script-template.md`: the template.
- `docs/engineering/process.md` and `docs/engineering/procedures/pull-request.md`: the closing-keyword rule (#608).
- `commands/markdown.star` and `tests/Test-StarGitHub`: the table's cell counts (#606).
- `docs/architecture/issue-data-model/10-the-issue-commands.md`: what a rerun finishes (#607).
- This plan.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- **Task #582's rewrite, PR #596,** owns the handbook's PR procedure, `docs/engineering/procedures/pull-request.md`, and has `docs/guides/pr-script-template.md` in its inventory. The procedure still describes a script that merges. This plan changes the template; the procedure's text is for #596 to bring to the owner's practice, which the owner coordinates.
- **#589's deployment:** `writ deploy` and `model apply` after PR #604 are the same steps this task's deployment takes; one `apply` per account can serve both.
- **Admin rights:** `PATCH repos/<repository>` needs admin on the repository; the owner's token has it.

<a id="approval-and-departures"></a>

## 12. Approval and departures

The owner made #605 the next task on 2026-11-19, and directed work to proceed. The owner approved this plan on 2026-11-19, with #608, #606 and #607 in it, and the work began.

On 2026-11-19 the owner chose that pull requests close the issues they complete, so the Linked pull requests column fills, and directed the fix at once (#608, step 9 of #588, in this worktree). The process and the PR procedure are handbook pages in #596's inventory; the owner directed this change ahead of that rewrite.

On 2026-11-19 the owner put #606 and #607, found by the Codex session's follow-up review of #604, in this worktree as steps 10 and 11, and approved designing automatic recovery apart, in Task #609.

Departure, 2026-11-19: PR #610's first run opened the pull request, then stopped at `gh pr checks --watch`, which GitHub answered with no checks a moment after the pull request opened. The template's first part now waits up to five minutes for the first check, and runs again after a stop: it makes no commit when nothing is staged, and opens no pull request when the branch has one open. Both forms; the fix is in this pull request, since the two-part script is its change.

Departure, 2026-11-19: PR #610's second run passed CI, then stopped at the merge gate, GitHub reporting the pull request blocked with its review required, which is the owner's own step before the merge. The first part now takes a pull request blocked by nothing but the owner's review as ready, and says the owner reviews and merges it; rule 5 says so. Both forms, in this pull request.

<a id="completion-review"></a>

## 13. Completion review

Pending.
