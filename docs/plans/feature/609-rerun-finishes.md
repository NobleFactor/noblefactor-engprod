---
title: "Running star github issue close or reopen again ends where one whole run would, and open checks for no duplicate"
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

# Running star github issue close or reopen again ends where one whole run would

<a id="role-assignments"></a>

## 1. Role assignments

Owner: David Noble. Participant: the Claude Code session assigned to Schedule #588, as coder. Reviewer: whoever the owner appoints. Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

The owner ruled on 2026-11-19 that close and all our commands are idempotent: run twice, a command ends where one whole run would have, nothing done twice and nothing left undone. If it's closed, it's closed. At the end:

- **`close`**, run on an issue that is already closed, sets whatever one whole run would have and the earlier run didn't: its Schedule row Closed, its Scenario row removed, its Triage or Backlog row removed. An issue already closed with nothing left is `unchanged`, and nothing is written. Its comment and Resolution are written once.
- **`reopen`**, run on an issue that is already open, does the same the other way: it clears a Resolution still set, and sets a row still Closed back to Open. An issue already open with nothing left is `unchanged`. Its comment is written once.
- **`open`** checks for no duplicate, now or later, as the owner ruled on 2026-11-19: a model provider will one day ask and answer that question. `--unique` is removed, from the code, the manifest, section 10 and the cases. Each run of `open` opens a new issue, which is what it is for.
- **Section 10** says what a second run of each command does, and its paragraph of what is done by hand, which #607 wrote, goes. Section 10's decisions record each choice.
- **Cases** of `tests/Test-StarGitHub` stop `close` and `reopen` partway and show a second run ending where one whole run would, each failing without its change.

Out of scope: `move`, whose second run already finishes; `star github schedule` and `scenario`'s own `close` and `reopen` (#595), which apply the same rule in a task of their own if the owner wants it; and the PR script template's closing step, which could call `issue close` once it does this.

## Issue 609

[Task #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609): a `reopen` that stops after it reopens an issue, but before it clears the Resolution and sets the rows, does nothing when run again. An `open` without `--unique` that stops after GitHub makes the issue opens a second one when run again. Bug #607 made section 10 say so.

<a id="current-state"></a>

## 3. Current state

- **`close`** (`commands/github-issue-close.star`) writes the comment, the Resolution, the closure, then the rows (D-009). Run on an issue already closed, it does nothing, so a run that stopped after the closure leaves the rows as they were. Since #608, a pull request's `Closes` line closes its issues at the merge and leaves their rows the same way; the PR script template sets them with GraphQL of its own.
- **`reopen`** (`commands/github-issue-reopen.star`) writes the reopening, the Resolution cleared, the comment, then the rows. Run on an issue already open, it does nothing to the issue, so a run that stopped after the reopening leaves the rest. Clicking Reopen on GitHub's page leaves the same: the issue open, its Resolution and its Closed row as they were. Its closed parents and schedules are already handled by a second run, since each is still closed.
- **`open`** (`commands/github-issue-open.star`) writes once, GitHub's `createIssue`. `--unique` looks through the parent's first 100 sub-issues for the title and opens nothing when it finds it.
- **The stand-in gh** of `tests/Test-StarGitHub` fails an operation once, through the world's `fail_on`, before it writes.

<a id="design-impact"></a>

## 4. Design impact

Section 10 changes: its paragraph on runs that stop partway, and its sections on opening, closing and reopening an issue. Its decisions gain D-013, every issue command is idempotent; and D-014, `open` checks for no duplicate, `--unique` removed, each of its runs opening a new issue. D-013 revises D-009's consequence, that a run which stops after closing the issue leaves its rows by hand.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

1. **`close` on a closed issue.** For an issue already closed, `run` reads its rows as it does a closing issue's, and plans each change one whole run makes: a Schedule row set Closed, a Scenario row removed after its comment on the Scenario issue, a Triage or Backlog row removed. A row already right is left alone. The comment is written only when the issue doesn't already hold it, and the Resolution only when it has none.
2. **`reopen` on an open issue.** For an issue already open, `run` reads its Resolution and its rows, and plans each change one whole run makes: the Resolution cleared, each row whose Status is Closed set Open. A row Open or In progress is left alone, since only `close` sets a row Closed. The same holds for each parent it reaches. The comment is written only when something changes and the issue doesn't already hold it.
3. **Records.** An issue that needed nothing is `unchanged`. One a second run completed is `closed` or `reopened` as before, with a field saying it was already so, and each row its `row-closed`, `left` or `row-opened` record.
4. **`open` without `--unique`.** The flag goes from `github-issue-open.star`, its template header, both entries in `extension.yaml`, section 10, and cases 136 and 140; a template that names `unique` is refused as naming a header it doesn't take.
5. **Section 10 and its decisions,** as section 4 says.
6. **The cases,** each failing without its change, through the stand-in's `fail_on`:
   - `close` stopped after the closure: the second run sets the rows and writes no second comment.
   - `close` of an issue a `Closes` line closed, its rows untouched: the run sets them.
   - `close` of an issue closed with nothing left: `unchanged`, nothing written.
   - `reopen` stopped after the reopening: the second run clears the Resolution, sets the rows Open, and writes the comment once.
   - `reopen` of an issue never closed, its rows In progress: `unchanged`, nothing written.
   - `open --unique` refused as an unknown flag.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **`open` checking for duplicates,** by title or otherwise. Ruled out by the owner, 2026-11-19: a model provider will ask and answer that question.
- **Leaving a second run to do nothing,** as now. Ruled out by the owner's rule that every command is idempotent.
- **A mark the first run writes,** so a second run knows it was its own. Not needed: an issue that is closed but still has a row In progress is wrong however it got that way, so a second run sets it right without asking who left it.

The owner's question, 1 of 1, answered on 2026-11-19:

1. **An issue someone reopened by clicking Reopen on GitHub's page is open, but it still has its Resolution, say Completed, and its Schedule row still says Closed. Should `star github issue reopen`, run on that issue, clear the Resolution and set the row back to Open?** Ruled yes, 2026-11-19: `reopen` clears the Resolution and sets the row back to Open. It's the same as finishing a `reopen` that stopped partway, and the issue ends as a whole run of `reopen` leaves it.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| `close` is idempotent | A second run ends where one whole run would; an issue with nothing left is `unchanged` | Cases, each failing without the change | `tests/Test-StarGitHub`, `make check` |
| `reopen` is idempotent | The same | Cases, each failing without the change | `tests/Test-StarGitHub` |
| `open` has no `--unique` | The flag is refused; nothing in the code, manifest or design names it | A case; a search | `tests/Test-StarGitHub`; the repository |
| The design says so | Section 10, D-013 and D-014 | Read of the merged sections | `docs/architecture/issue-data-model/` |
| Deployed, it works | The deployed `reopen` sets right an issue reopened on GitHub's page; the deployed `close` sets right an issue a `Closes` line closed | Each run's records, each issue read back | NobleFactor-sandbox |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The cases, `make check`, review | Pending |
| Merge | Yes | The pull request, merged by the owner in GitHub, closing #609 | Pending |
| Deployment | Yes: the commands reach each machine only through `writ deploy` | `writ deploy` | Pending |
| Verification | Yes | The deployed `close` and `reopen` in NobleFactor-sandbox; the `reopen` run is also the first deployed run of `reopen`, which #589's plan left to this one | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [ ] This plan committed on `feature/609-rerun-finishes`, with #589's and #605's plans completed, and reviewed with the owner: every question ruled on 2026-11-19

### 9.2 Phase 2: `close` and `reopen`

- [ ] `close` on a closed issue and `reopen` on an open one end where one whole run would, each comment written once, with their cases

### 9.3 Phase 3: `open`

- [ ] `--unique` removed from the code, the template header, the manifest and the cases

### 9.4 Phase 4: the design

- [ ] Section 10 says what a second run of each command does; D-013 and D-014 recorded

### 9.5 Phase 5: the merge, the deployment and the verification

- [ ] The pull request merged by the owner in GitHub
- [ ] `writ deploy`
- [ ] In NobleFactor-sandbox, the deployed `reopen` sets right an issue reopened on GitHub's page, and the deployed `close` an issue a `Closes` line closed, each read back; their records posted on #609

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/github-issue-close.star`, `github-issue-reopen.star` and `github-issue-open.star`; `issues.star` for what they share; `extension.yaml`, `--unique` removed.
- `tests/Test-StarGitHub`: the cases.
- `docs/architecture/issue-data-model/10-the-issue-commands.md` and `10-the-issue-commands.decisions.md`.
- `docs/plans/doc/589-issue-verbs.md` and `docs/plans/feature/605-squash-message.md`, completed in this branch's first commit, since both their issues are closed.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- Step 12 of Schedule #588, put there by the owner on 2026-11-19; nothing blocks it.
- #589's plan left one box open, each deployed command run as deployed: `open`, `move` and `close` have run as deployed on NobleFactor, and `reopen` has not. This plan's verification is that run.
- `--dry-run` stays refused by each command until NobleFactor/devlore-cli#1170.

<a id="approval-and-departures"></a>

## 12. Approval and departures

The owner put #609 on Schedule #588 as step 12, next, on 2026-11-19, so that every issue PR #610 surfaced is done, and directed this plan.

Ruled by the owner on 2026-11-19, on the plan's first draft: close and all our commands are idempotent, and if it's closed, it's closed; `open` checks for no duplicate, now or later, since a model provider will ask and answer that question, and neither `--allow-duplicate` nor `--unique` is kept. On the second draft the owner added that removing `--unique` leaves `open` idempotent: it always opens a new issue, and two with the same title and description come only from someone setting out to make them. The first draft's three questions became the one in section 6, written plainly as the owner asked. On the second draft the owner confirmed `--unique` is removed, and ruled that `reopen`, run on an issue reopened on GitHub's page, clears its Resolution and sets its row back to Open.

<a id="completion-review"></a>

## 13. Completion review

Pending.
