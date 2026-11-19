---
title: "star github issue reopen and open finish a run that stopped partway when run again"
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

# star github issue reopen and open finish a run that stopped partway when run again

<a id="role-assignments"></a>

## 1. Role assignments

Owner: David Noble. Participant: the Claude Code session assigned to Schedule #588, as coder. Reviewer: whoever the owner appoints. Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

At the end, a run of `star github issue reopen` or `star github issue open` that stopped partway is finished by running it again, and section 10 says so:

- `reopen` finishes an open issue whose records still say it is closed: a Resolution, a row whose Status is Closed, or no row on its team's projects. It clears the Resolution, sets each Closed row Open, gives a rowless issue a Triage row, and writes its comment once. It does the same for each parent it reaches.
- `open` looks for the issue before it opens one, by default: an issue with a parent among all the parent's sub-issues, one without a parent among the repository's issues of its type, each by its exact title. One found is read back as an issue just opened is, and nothing is opened. A flag opens one anyway.
- If the owner rules so (question 3), `close` finishes a closed issue whose rows still say it is open, the state a stopped run leaves and the one a pull request's closing keyword leaves after every merge since #608.
- Section 10 says what a rerun of each command finishes, and its paragraph of what is done by hand, which #607 wrote, keeps only what is left. Section 10's decisions record each choice.
- Cases of `tests/Test-StarGitHub` stop each command partway and show a rerun finishing it, each failing without its change.

Out of scope: `move`, whose rerun already finishes its pending amendment; `star github schedule reopen` and `scenario reopen`, whose finishing is the collection groups' (#595); and the PR script template's closing step, which could call `issue close` once `close` finishes, a task of its own.

## Issue 609

[Task #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609): a `reopen` that stops after it reopens an issue, but before it clears the Resolution and sets the rows, records `unchanged` when run again. An `open` without `--unique` that stops after GitHub makes the issue opens a second one when run again. Bug #607 made section 10 say so. The issue's outstanding question: how each command tells a run that stopped from a state someone set by hand.

<a id="current-state"></a>

## 3. Current state

- **`reopen`** (`commands/github-issue-reopen.star`) writes, for a closed issue: the reopening, the Resolution cleared, the comment, then the rows, each read back. For an open issue it plans no Resolution and no row change, so it records `unchanged` unless a parent or a schedule is closed. A run that stops anywhere after the reopening leaves the rest, and a rerun finishes none of it. Its closed parents and schedules are already finished by a rerun, since each is still closed.
- **`open`** (`commands/github-issue-open.star`) writes once: GitHub's `createIssue`, with the type, parent, assignee, and fields or labels. A run that stops after GitHub makes the issue, but before its answer arrives or the read-back, leaves a whole issue, and a rerun opens another. `--unique` prevents that when the issue has a parent, but it reads only the parent's first 100 sub-issues, returns the one found without reading it back, and is off unless asked for.
- **`close`** writes the comment, the Resolution, the closure, then the rows (D-009). A run that stops after the closure leaves its rows, and D-009 lists "changing the rows of an issue already closed" among its rejected alternatives. Since #608, a pull request's closing keyword closes its issues at the merge and leaves their rows the same way, and the PR script template sets them with GraphQL of its own.
- **Section 10**, as #607 corrected it, lists what each rerun finishes and leaves the rest to be done by hand.
- **The stand-in gh** of `tests/Test-StarGitHub` fails an operation once, through the world's `fail_on`, before it writes; `fail_skip` lets calls through first.

<a id="design-impact"></a>

## 4. Design impact

Section 10 changes: its paragraph on runs that stop partway, and its sections on opening, closing and reopening an issue, each saying what a rerun finishes and what it leaves as it is. Section 10's decisions gain D-013, reopen finishes an open issue's closed records; D-014, open looks for the issue before it opens one; and, with question 3, D-015, close finishes a closed issue's open rows, revising D-009's consequence. Each records its reasons, alternatives, consequences and the owner's approval.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

1. **`reopen` finishes an open issue.** For an issue already open, `run` reads what a closed issue's reopening changes: its Resolution, through `clearing_plan`; each row on its team's Triage, Backlog, Schedule or Scenario project whose Status is Closed; and whether it has such a row at all. Each is finished as a closed issue's is, and read back: the Resolution cleared, each Closed row set Open, a rowless issue given a Triage row. A row In progress or Open is left as it is, since only `close` sets Closed. The same holds for each parent the issue reaches. The comment is written when anything is finished, and not when the issue already holds that same comment, so a run that stopped after its comment doesn't write a second. The issue's record is `reopened` when it was closed, `finished` when it was open with something left, and `unchanged` when nothing was.
2. **`open` looks before it opens.** The search `--unique` makes becomes every run's. An issue with a parent is looked for among all the parent's sub-issues, page by page; one with no parent among the repository's issues of its type, through GitHub's search, its title then matched exactly. One found is read back against what was asked, as a new issue is: its title, type, parent, assignee, and fields or labels. When it matches it is `found` and nothing is opened; when it differs, nothing is opened and the run says what differs. `--allow-duplicate` opens one anyway. `--unique` stays accepted, so the scripts that pass it keep working.
3. **`close` finishes a closed issue** (question 3). For an issue already closed, `run` reads its rows and changes each the way it changes a closing issue's: a Schedule row set Closed and kept, a Scenario row removed after its comment on the Scenario issue, a Triage or Backlog row removed. Its comment and Resolution are written only if missing. A closed issue whose rows are already right is `unchanged`.
4. **Section 10 and its decisions,** as section 4 above says.
5. **The cases.** The stand-in gains `fail_after`, which fails an operation once after it writes, as a lost answer does. Then, each failing without its change:
   - `reopen` stopped after the reopening: the rerun clears the Resolution, sets the rows Open and writes the comment once.
   - `reopen` stopped after the comment: the rerun sets the rows and writes no second comment.
   - `reopen` of an open issue never closed, its rows In progress: `unchanged`, nothing written.
   - `open` stopped after `createIssue`: the rerun finds the issue, reads it back, and opens nothing.
   - `open` under a parent with more than 100 sub-issues finds one past the first page; one with no parent is found by its title; one found that differs from what was asked is refused; `--allow-duplicate` opens a second.
   - With question 3, `close` stopped after the closure: the rerun changes the rows; an issue closed by a closing keyword gets its rows changed the same way.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

The issue asks how a command tells a run that stopped from a state someone set by hand. This plan proposes that it needn't. The model has no open issue with a Resolution or a Closed row, and no closed issue on Triage or the Backlog. Whoever left such a state, a stopped run or a person who reopened the issue in GitHub's own page, the finished state is the right one.

- **A marker the run writes first,** a comment or a hidden line in the body, read on a rerun to know the run was its own. Rejected: it adds a write that can itself be lost, and an issue reopened by hand in GitHub, which leaves the same records, should be finished as well.
- **Leaving reruns to be done by hand,** as section 10 says now. The status quo, which #607 recorded so the design would be true.
- **`reopen` setting every row Open,** In progress ones too. Rejected: an open issue's In progress row is right, and only `close` sets a row Closed.
- **`open` looking among open issues only.** It would let an issue be opened again under a title closed before, which `--unique` has refused since #338; this plan keeps that, and `--allow-duplicate` is the way past it.
- **`open`'s search costs** a call or more on every run. Accepted: a duplicate costs more.

Three questions for the owner, 1 of 3 to 3 of 3, each with a recommendation:

1. **Does `reopen` finish an open issue's closed records, whoever left them, without telling a stopped run from a reopening by hand?** Recommended: yes, for the reason above.
2. **Does `open` look for the issue by default, open and closed, by its exact title, with `--allow-duplicate` to open one anyway, and `--unique` kept as a flag that does nothing more?** Recommended: yes.
3. **Does `close` get the same finishing, a closed issue's open rows changed, revising D-009's consequence, in this pull request?** Recommended: yes. Every issue command then finishes on a rerun, section 10's paragraph of what is done by hand goes, and an issue a closing keyword closed, which every merge leaves since #608, can be finished by `star github issue close`.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| `reopen` finishes a stopped run | A rerun clears the Resolution, sets the rows and writes one comment | Cases, each failing without the change | `tests/Test-StarGitHub`, `make check` |
| `reopen` leaves an open issue alone | An open issue never closed is `unchanged`, nothing written | A case | `tests/Test-StarGitHub` |
| `open` opens no duplicate | A rerun after a stop finds the issue and opens nothing | Cases, each failing without the change | `tests/Test-StarGitHub` |
| `close` finishes a stopped run, with question 3 | A rerun changes a closed issue's rows | Cases | `tests/Test-StarGitHub` |
| The design says so | Section 10 and D-013 to D-015 describe each rerun | Read of the merged sections | `docs/architecture/issue-data-model/` |
| Deployed, it finishes a reopening by hand | An issue reopened in GitHub's page, its Resolution and Closed row left, is finished by the deployed `reopen` | The run's records and the issue read back | NobleFactor-sandbox |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The cases, `make check`, review | Pending |
| Merge | Yes | The pull request, merged by the owner in GitHub, closing #609 | Pending |
| Deployment | Yes: the commands reach each machine only through `writ deploy` | `writ deploy` | Pending |
| Verification | Yes | The deployed `reopen` finishing an issue reopened by hand in NobleFactor-sandbox; it is also the first deployed run of `reopen`, which #589's plan left to this one | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [ ] This plan committed on `feature/609-rerun-finishes`, with #589's and #605's plans completed, and reviewed with the owner, questions 1 to 3 answered

### 9.2 Phase 2: `reopen`

- [ ] `reopen` finishes an open issue's closed records and its parents', its comment written once, with its cases

### 9.3 Phase 3: `open`

- [ ] `open` looks for the issue before it opens one, across every page, with or without a parent; the one found read back; `--allow-duplicate`; with its cases

### 9.4 Phase 4: `close`, with question 3

- [ ] `close` finishes a closed issue's open rows, its comment and Resolution written only if missing, with its cases

### 9.5 Phase 5: the design

- [ ] Section 10 says what each rerun finishes; D-013 to D-015 recorded; the commands' help and `extension.yaml` name `--allow-duplicate`

### 9.6 Phase 6: the merge, the deployment and the verification

- [ ] The pull request merged by the owner in GitHub
- [ ] `writ deploy`
- [ ] In NobleFactor-sandbox, an issue reopened in GitHub's page, its Resolution and Closed row left, finished by the deployed `reopen`, read back; its records posted on #609

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/github-issue-reopen.star`, `github-issue-open.star`, and, with question 3, `github-issue-close.star`; `issues.star` for what they share; `extension.yaml` for `--allow-duplicate`.
- `tests/Test-StarGitHub`: `fail_after` and the cases.
- `docs/architecture/issue-data-model/10-the-issue-commands.md` and `10-the-issue-commands.decisions.md`.
- `docs/plans/doc/589-issue-verbs.md` and `docs/plans/feature/605-squash-message.md`, completed in this branch's first commit, since both their issues are closed.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- Step 12 of Schedule #588, put there by the owner on 2026-11-19; nothing blocks it.
- #589's plan left one box open, each deployed command run as deployed: `open`, `move` and `close` have run as deployed on NobleFactor, and `reopen` has not. This plan's verification is that run.
- `--dry-run` stays refused by each command until NobleFactor/devlore-cli#1170.

<a id="approval-and-departures"></a>

## 12. Approval and departures

The owner put #609 on Schedule #588 as step 12, next, on 2026-11-19, so that every issue PR #610 surfaced is done, and directed this plan. It awaits the owner's review and answers to questions 1 to 3 of section 6.

<a id="completion-review"></a>

## 13. Completion review

Pending.
