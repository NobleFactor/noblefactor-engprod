---
title: "Make star github issue close and reopen idempotent, and remove open's --unique flag"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/609
status: draft
created: 2026-11-19
updated: 2026-11-19
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.decisions.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
---

# Make star github issue close and reopen idempotent, and remove open's --unique flag

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: whoever the owner appoints.
- Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Every `star github issue` command is idempotent, as the owner ruled on 2026-11-19. Running a command again never leaves its work half done, and never does the same work twice.

`close` and `reopen` break that rule. If either one stops partway, running it again does nothing, and the work stays half done. This task fixes both commands. It also removes the `--unique` flag from `open`.

When the work is done:

- **`close`.** If an issue is closed but its project rows aren't updated, `close` updates them. It sets the Schedule row to Closed, and removes the Scenario, Triage, or Backlog row. If nothing is left to do, `close` changes nothing. It never writes its comment or the Resolution twice.
- **`reopen`.** If an issue is open but still has a Resolution, or a row set to Closed, `reopen` clears the Resolution and sets the row to Open. This also fixes an issue that someone reopened on GitHub's page, which reopens only the issue itself. If nothing is left to do, `reopen` changes nothing. It never writes its comment twice.
- **`open`.** `open` doesn't check for duplicates. Each run is a new job, and opens a new issue. The `--unique` flag is removed. A model provider will handle duplicates later.
- **Section 10.** Section 10 of the issue data model describes what each command does when you run it again. Its paragraph about cleaning up by hand is removed. Two new decisions, D-013 and D-014, record the choices.
- **Tests.** Tests in `tests/Test-StarGitHub` stop `close` and `reopen` partway, run them again, and check the result. Each test fails without its fix.

**Out of scope**

- **`star github issue move`.** Running `move` a second time completes an unfinished move, so it needs no change.
- **The `close` and `reopen` commands of `star github schedule` and `star github scenario` (#595).** A separate task can make them idempotent.
- **The closing step of the PR script template.** That step sets each issue's row with its own GraphQL calls. A separate task can replace those calls with `star github issue close`.

## Issue 609

[Task #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609): when `star github issue reopen` stops partway, running it again does nothing. The issue stays open, but its Resolution is still set and its Schedule row still says Closed. `star github issue close` has the same problem in reverse. Bug #607 recorded the problem in section 10, and this task fixes it.

<a id="current-state"></a>

## 3. Current state

- **`close`** (`commands/github-issue-close.star`) writes in this order: the comment, the Resolution, the closed state, then the rows, as decision D-009 sets out. On an issue that's already closed, it does nothing. So if a run stops after it closes the issue, the rows stay as they were.
- **Pull requests close issues too.** Since #608, a pull request's `Closes` line closes its issues when the pull request merges. GitHub doesn't update their rows. The PR script does that with its own GraphQL calls.
- **`reopen`** (`commands/github-issue-reopen.star`) writes in this order: the open state, the cleared Resolution, the comment, then the rows. On an issue that's already open, it does nothing to that issue. So if a run stops after it reopens the issue, the rest stays undone. Clicking Reopen on GitHub's page leaves an issue in the same state. A second run already handles the issue's closed parents and schedules, because they're still closed.
- **`open`** (`commands/github-issue-open.star`) creates the issue in one call. With `--unique`, it first searches the parent's first 100 sub-issues for an issue with the same title.
- **The test harness** in `tests/Test-StarGitHub` can make a GitHub call fail once, before it writes, through its `fail_on` setting.

<a id="design-impact"></a>

## 4. Design impact

Section 10 changes in four places: the paragraph on runs that stop partway, and the sections on opening, closing, and reopening an issue.

Section 10's decisions gain two entries:

- **D-013:** every issue command is idempotent. This revises D-009, which left the rows of a stopped `close` to be fixed by hand.
- **D-014:** `open` doesn't check for duplicates, and `--unique` is removed.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

1. **`close` on a closed issue.** `close` reads the issue's rows and makes the changes a full run makes. It sets a Schedule row to Closed, removes a Scenario row after commenting on the Scenario issue, and removes a Triage or Backlog row. It leaves correct rows alone. It writes the comment only if the issue doesn't have it, and the Resolution only if the issue has none.
2. **`reopen` on an open issue.** `reopen` reads the issue's Resolution and rows. It clears the Resolution, and sets each Closed row to Open. It leaves Open and In progress rows alone, because only `close` sets a row to Closed. It does the same for each parent issue it reaches. It writes the comment only if it changes something and the issue doesn't already have that comment.
3. **Output records.** An issue that needed nothing is reported as `unchanged`. An issue that a second run completed is reported as `closed` or `reopened`, with a field that says it was already in that state. Each row gets its usual record: `row-closed`, `left`, or `row-opened`.
4. **Remove `--unique`.** Remove the flag from `github-issue-open.star`, from the template header, from both entries in `extension.yaml`, from section 10, and from tests 136 and 140. `open` refuses a template whose header names `unique`.
5. **Update section 10 and its decisions,** as section 4 of this plan describes.
6. **Add tests.** Each test uses `fail_on` to stop a command partway, and fails without its fix:
   - `close` stops after it closes the issue. A second run sets the rows and writes no second comment.
   - A pull request's `Closes` line closed an issue and left its rows. `close` sets the rows.
   - An issue is closed with nothing left to do. `close` reports `unchanged` and writes nothing.
   - `reopen` stops after it reopens the issue. A second run clears the Resolution, sets the rows to Open, and writes the comment once.
   - An issue was never closed, and its rows are In progress. `reopen` reports `unchanged` and writes nothing.
   - `open --unique` fails as an unknown flag.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **Make `open` check for duplicates.** Rejected. A model provider will handle duplicates later.
- **Have a second run do nothing.** Rejected. Every command must be idempotent.
- **Have the first run leave a marker for the second run.** Not needed. A closed issue with a row still In progress is wrong, however it got that way, and a second run fixes it either way.

**The owner's question, 1 of 1**

- **Question:** someone reopens an issue by clicking Reopen on GitHub's page. The issue is open, but it still has its Resolution, for example Completed, and its Schedule row still says Closed. When you run `star github issue reopen` on that issue, should it clear the Resolution and set the row to Open?
- **Answer:** yes, the owner ruled on 2026-11-19.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| `close` is idempotent | A second run gives the same result as one full run. An issue with nothing left to do is reported as `unchanged`. | Tests that fail without the fix | `tests/Test-StarGitHub`, `make check` |
| `reopen` is idempotent | The same as for `close` | Tests that fail without the fix | `tests/Test-StarGitHub` |
| `--unique` is gone | `open --unique` fails, and no code, manifest, or design text names the flag | A test and a search | `tests/Test-StarGitHub`, the repository |
| The design matches | Section 10, D-013, and D-014 describe the behavior | A read of the merged files | `docs/architecture/issue-data-model/` |
| The deployed commands work | The deployed `reopen` fixes an issue reopened on GitHub's page. The deployed `close` fixes an issue that a `Closes` line closed. | Each run's records, and each issue read back | NobleFactor-sandbox |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The tests, `make check`, and review | Pending |
| Merge | Yes | The pull request, merged by the owner in GitHub, closing #609 | Pending |
| Deployment | Yes: the commands reach each machine only through `writ deploy` | `writ deploy` | Pending |
| Verification | Yes | The deployed `close` and `reopen`, run in NobleFactor-sandbox. This is also the first deployed run of `reopen`, which #589's plan left to this one. | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [ ] Commit this plan on `feature/609-rerun-finishes`, with #589's and #605's plans marked complete, and review it with the owner. The owner answered every question on 2026-11-19.

### 9.2 Phase 2: `close` and `reopen`

- [ ] Make `close` and `reopen` idempotent, writing each comment once, with their tests.

### 9.3 Phase 3: `open`

- [ ] Remove `--unique` from the code, the template header, the manifest, and the tests.

### 9.4 Phase 4: the design

- [ ] Update section 10 to describe a second run of each command, and record D-013 and D-014.

### 9.5 Phase 5: merge, deployment, and verification

- [ ] The owner merges the pull request in GitHub.
- [ ] Run `writ deploy`.
- [ ] In NobleFactor-sandbox, run the deployed `reopen` on an issue reopened on GitHub's page, and the deployed `close` on an issue that a `Closes` line closed. Read each issue back, and post the results on #609.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- In `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/`:
  - `commands/github-issue-close.star`, `commands/github-issue-reopen.star`, and `commands/github-issue-open.star`.
  - `commands/issues.star`, for code the commands share.
  - `extension.yaml`, without `--unique`.
- `tests/Test-StarGitHub`, for the new tests.
- `docs/architecture/issue-data-model/10-the-issue-commands.md` and `10-the-issue-commands.decisions.md`.
- `docs/plans/doc/589-issue-verbs.md` and `docs/plans/feature/605-squash-message.md`, marked complete in this branch's first commit, because all their issues are closed.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- This task is step 12 of Schedule #588. The owner placed it there on 2026-11-19. Nothing blocks it.
- #589's plan has one open item: run each deployed command as deployed. `open`, `move`, and `close` have run that way on NobleFactor, but `reopen` hasn't. This plan's verification covers it.
- Each command refuses `--dry-run` until NobleFactor/devlore-cli#1170 is done.

<a id="approval-and-departures"></a>

## 12. Approval and departures

On 2026-11-19, the owner:

- Placed #609 on Schedule #588 as step 12, so that every issue PR #610 surfaced gets done, and asked for this plan.
- Ruled that `close` and every other command are idempotent: an issue that's closed stays closed.
- Ruled that `open` won't check for duplicates, now or later, because a model provider will handle that. Neither `--allow-duplicate` nor `--unique` is kept.
- Ruled that removing `--unique` keeps `open` idempotent. It always opens a new issue, and two issues with the same title and description happen only if someone makes them on purpose.
- Answered the plan's one remaining question: `reopen` clears the Resolution and sets the row to Open on an issue reopened on GitHub's page.
- Asked for the plan in plain words.

The owner's approval of this plan is pending.

<a id="completion-review"></a>

## 13. Completion review

Pending.
