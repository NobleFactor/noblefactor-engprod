---
title: "Make star github issue close and reopen idempotent, and remove open's --unique flag"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/609
status: complete
created: 2026-11-19
updated: 2026-11-20
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.decisions.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
  - kind: Related work
    url: https://github.com/NobleFactor/devlore-cli/issues/1238
    text: "A GitHub provider for the workflow engine"
  - kind: Related work
    url: https://github.com/NobleFactor/devlore-cli/issues/1239
    text: "Scenario: star github issue open runs as a graph"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/611
    text: "move writes its Scenario comment twice"
---

# Make star github issue close and reopen idempotent, and remove open's --unique flag

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: Codex, which reviewed revision c7dd403 of this plan.
- Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

`star github issue close` and `star github issue reopen` become idempotent. Run either one again, and it ends where one complete run would have ended. It never leaves its work half done, and never does the same work twice.

When the work is done:

- **`close`.** If an issue is closed but its work isn't finished, `close` finishes it. It writes a missing comment, sets the Resolution, and updates the rows: a Schedule row set to Closed, a Scenario row removed after its comment on the Scenario issue, a Triage or Backlog row removed. A row added without a Status is treated the same way. If the issue holds a different Resolution, `close` sets the one asked for, and writes no comment of its own on the change: GitHub's history records it. If nothing is left to do, `close` writes nothing.
- **`reopen`.** If an issue is open but its work isn't finished, `reopen` finishes it. It writes a missing comment, clears the Resolution, sets each Closed row to Open, gives a row without a Status the Status Open, and gives an issue with no row a Triage row. It does the same for each parent it reaches, and finishes each schedule it reopened partway. This also fixes an issue that someone reopened on GitHub's page, which reopens only the issue itself. An issue that was never closed gets the same repairs, but no reopen comment. If nothing is left to do, `reopen` writes nothing.
- **Comments.** Every comment here is a GitHub comment on an issue, and it is about one issue: the one being closed or reopened. A comment on a Scenario issue is about the child it names. Before it writes a comment, a run looks for one from the same command about the same issue. `close` looks back to that issue's last reopening, or its creation, because `close` comments before the issue closes. `reopen` looks back to its last closing. If the run finds one, it writes nothing. So a second run writes no second comment, a later close or reopen gets its own, and one child's comment never stands in for another's.
- **`open`.** Each run of `open` opens a new issue. It checks for no duplicate. The `--unique` flag is removed.
- **The design.** Section 10 and its decisions describe each change in the same commit as the code. D-009's statement that a stopped `close` leaves its rows by hand is superseded.

**What it covers.** A run can stop in three ways, and a second run finishes after each:

- GitHub rejects a write. Nothing was written by that call.
- GitHub accepts a write, but its answer is lost. The second run reads the issue and finds the write.
- The run is killed between two writes.

Two workers changing the same issue at the same moment is not covered: the last write wins.

**Out of scope**

- **`star github issue open` recovering a stopped creation.** The selected future approach is a graph. [Feature NobleFactor/devlore-cli#1238](https://github.com/NobleFactor/devlore-cli/issues/1238) builds it: a GitHub provider for the workflow engine, proved by [Scenario NobleFactor/devlore-cli#1239](https://github.com/NobleFactor/devlore-cli/issues/1239), `star github issue open` running as a graph.
- **`star github issue move`.** Its second run already finishes a move. It can write its Scenario comment twice, which [Bug #611](https://github.com/NobleFactor/noblefactor-engprod/issues/611) fixes.
- **The `close` and `reopen` commands of `star github schedule` and `star github scenario` (#595).** A separate task can make them idempotent. `reopen`'s own path into a schedule is in scope.
- **The closing step of the PR script template.** That step sets each issue's row with its own GraphQL calls. A separate task can replace those calls with `star github issue close`.

## Issue 609

[Task #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609): when `star github issue reopen` stops partway, running it again does nothing. The issue stays open, but its Resolution is still set and its Schedule row still says Closed. `star github issue close` has the same problem in reverse. Bug #607 recorded the problem in section 10, and this task fixes it. Its title and body are rewritten to match this plan when the plan is approved.

<a id="current-state"></a>

## 3. Current state

- **`close`** (`commands/github-issue-close.star`) writes in this order: the comment, the Resolution, the closed state, then the rows (D-009). On an issue that's already closed, it does nothing. A run that stops after the comment leaves an open issue with a close comment, and a second run writes the comment again. A run that stops after the closed state leaves the rows as they were.
- **`reopen`** (`commands/github-issue-reopen.star`) writes the open state, clears the Resolution, writes the comment, then sets the rows. It acts only on an issue, parent, or schedule that is still closed. So a run that stops after the reopening leaves the rest undone, and a schedule it reopened partway is skipped next time, its row and its every-step criterion unfinished.
- **Rows.** A Triage row is added, then given its Status, in two writes (`steps.star`). A run that stops between them leaves a row without a Status.
- **Resolution.** In an organization, the Resolution is an issue field. In a user account, it is a `resolution:` label, and clearing several labels takes several writes.
- **Comments.** `comment` in `steps.star` checks the ID GitHub returns. It doesn't look for a comment already there.
- **Pull requests close issues too.** Since #608, a pull request's `Closes` line closes its issues when it merges, and leaves their rows.
- **`open`** creates the issue in one call. With `--unique`, it first searches the parent's first 100 sub-issues for the same title.
- **The test harness** in `tests/Test-StarGitHub` can make a GitHub call fail once, before it writes, through `fail_on`.

<a id="design-impact"></a>

## 4. Design impact

Section 10 changes in each commit that changes the behavior it describes: the paragraph on runs that stop partway, and the sections on opening, closing, and reopening an issue. Section 10's headings are numbered in the same revision, and their existing anchors are kept.

Section 10's decisions gain two entries:

- **D-013: `close` and `reopen` are idempotent.** It records the rule that every issue command is idempotent, and what this task makes so: `close` and `reopen`, with the comment rule, the Resolution rule, and the states each finishes. It names what the rule doesn't yet cover: a stopped `open`, which #1238 recovers through a graph, and `move`'s Scenario comment, which #611 fixes. It supersedes D-009's consequence that a stopped `close` leaves its rows by hand. D-009 is marked superseded in that part, its reasons and approval kept. D-011, on what `reopen` reopens, gains the states it finishes.
- **D-014: `open` checks for no duplicate.** `--unique` is removed. Recovering a stopped creation is the graph's job, in #1238.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

1. **The comment rule.** Each comment has a subject: the issue being closed or reopened. The issue's own comment, and the comment on a parent or schedule that `reopen` reopens, have that issue as their subject. The comment `close` writes on a Scenario issue has the child it names as its subject. Before it writes a comment, a command reads every comment on the issue it writes on, page by page, and its subject's close and reopen events. For `close`, the window starts at the subject's last reopen event, or at its creation, since `close` writes its comment before the issue closes. For `reopen`, the window starts at the subject's last close event, since `reopen` writes its comment after the issue reopens. The command writes nothing if a comment in the window comes from the same command about the same subject. A comment comes from the same command if it begins with that command's opening words, such as ``Closed by `star github issue close` `` or ``Reopened by `star github issue reopen` ``, or, for `close` with `--evidence`, if it is the evidence comment `close` would write, character for character. A comment on a Scenario issue is about the same subject if it begins with that child's key. Each comment is also of a kind, and only a comment of the same kind counts: `close`'s closing comment and `reopen`'s comment are two kinds. The rule lives in `steps.star`, beside `comment`.
2. **`close` on a closed issue.** `close` reads the issue's rows and Resolution as it does a closing issue's. It writes a missing comment, then makes each change one complete run makes. A row without a Status is changed as its project's kind has it. A correct row is left alone.
3. **Resolution in `close`.** `close` sets the Resolution asked for when the issue doesn't hold it, and writes no comment of its own on the change; GitHub's history records each field and label change. In a user account, it removes every other `resolution:` label whether or not the one asked for needs adding, and keeps the issue's other labels. `--reason` is written in the closing comment, which a close writes once; a later change of Resolution keeps no explanation of its own, unless someone comments by hand.
4. **`reopen` on an open issue.** `reopen` selects its work by what is unfinished, not by whether the issue is closed. For the issue and each parent it reaches: a missing comment written, the Resolution cleared, each `resolution:` label removed, each Closed row set to Open, a row without a Status set to Open, and a Triage row for an issue with no row. Open and In progress rows, and each row's Worktree, are left alone. For each schedule the issue is a step of: if the Schedule issue is open but its row isn't In progress, or its every-step criterion is still ticked, `reopen` finishes what `ending.star` does, leaving other criteria alone. A schedule that has never closed keeps the Status its opening gave it, Open, since its steps haven't started; one that has closed before gets its own row set In progress whatever its Status (H-F03, Codex's review of PR #612). A parent or schedule shared by two issues in one run is handled once. `reopen` chooses its work from the issue's records, not its history. So an open issue that was never closed gets the same repairs, each recorded, but no reopen comment, because its window has no close event to start from. If its records already say open, it is `unchanged`, and nothing is written.
5. **Output records.** An issue that needed nothing is `unchanged`. One that a second run finished is `closed` or `reopened` as before, with `already` set to true. Each row gets its usual record: `row-closed`, `left`, `row-opened`, or `triaged`.
6. **Remove `--unique`.** `open` and `create` refuse the flag and a template header that names `unique`. The flag goes from `github-issue-open.star`, both entries in `extension.yaml`, section 10's usage and example, and tests 136 and 140. Tests, decisions, and history can still name it.
7. **The tests.** The harness gains `fail_after`, which fails a call once after it writes, as a lost answer does. Each test fails without its fix:
   - `close` stopped after its comment, and stopped after the closed state: a second run finishes, with one comment.
   - `close` stopped after its comment's write was accepted and its answer lost: one comment.
   - `close` run again after a complete run, its comment written before the close event: no second comment.
   - Two children of one scenario closed in one run, and again after a stop: each child's comment on the Scenario issue written once, neither standing in for the other.
   - An issue a `Closes` line closed: `close` sets its rows.
   - A row without a Status: `close` and `reopen` each set it.
   - A different Resolution: `close` sets the new one and writes no comment; a repeat writes nothing.
   - `reopen` stopped after the reopening, after clearing one of two `resolution:` labels, after a parent's reopening, and after a schedule's reopening: a second run finishes each, with one comment each.
   - An issue reopened on GitHub's page: `reopen` clears its Resolution and sets its row to Open.
   - An open issue never closed, its records already open, and a closed issue with nothing left: `unchanged`, and no write.
   - An open issue never closed, with no row: `reopen` gives it a Triage row and writes no comment.
   - In a user account, an issue holding the `resolution:` label asked for and another: `close` removes the other, keeps unrelated labels, and a repeat writes nothing. A stop between removing the old label and adding the new one: one retry finishes, and the next run writes nothing.
   - Each command run twice in a row: the second run writes nothing.
   - Each in an organization, where the Resolution is a field, and in a user account, where it is a label.
   - `open --unique`, and a template naming `unique`: refused.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **Run the commands as graphs, with undo.** Not for #609. A graph needs a GitHub provider and saved run state in devlore-cli first. That work, and its prototype, are [Feature NobleFactor/devlore-cli#1238](https://github.com/NobleFactor/devlore-cli/issues/1238) and [Scenario NobleFactor/devlore-cli#1239](https://github.com/NobleFactor/devlore-cli/issues/1239). With that scenario working, much of the star GitHub extension can move to the workflow engine.
- **Make `open` check for duplicates.** Rejected. A model provider will handle duplicates later.
- **Have a second run do nothing.** Rejected. Every command must be idempotent.
- **Have the first run leave a marker for the second run.** Not needed. A closed issue with a row still In progress is wrong, however it got that way, and a second run fixes it either way.
- **Match a comment by its full text.** Rejected. The text holds the date and who ran it, so a second run on another day wouldn't match. Matching loosely across the issue's whole history would mistake two real closes for one. The comment rule looks only within its subject's current close or reopen.
- **Refuse a different Resolution.** Rejected. A run that asks for Duplicate is an explicit request, and anyone can change the Resolution by hand.
- **Comment on every change of Resolution.** Removed on Codex's review of PR #612, because its value doesn't justify its machinery. GitHub's history already records each field and label change; the comment's own value is the `--reason` it carries. Keeping it in step with that history takes a recovery rule that must order comments against field events, and a proof found that GitHub's timeline can list an issue-field change after a comment written later: NobleFactor-sandbox/sandbox#77 and David-Noble-at-work-sandbox/sandbox#63, its output kept in `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.609-rerun-finishes/proof-history`. The proof shows the ordering can differ from the order of writes; it doesn't show that a reliable comment is impossible.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| `close` is idempotent | After each stop in section 5, a second run ends as one complete run does, with one comment. A run with nothing left writes nothing. | Tests that fail without the fix | `tests/Test-StarGitHub`, `make check` |
| `reopen` is idempotent | The same, for the issue, its parents, and its schedules | Tests that fail without the fix | `tests/Test-StarGitHub` |
| Both account kinds | The same results with a Resolution field and with `resolution:` labels | Tests | `tests/Test-StarGitHub` |
| `--unique` is gone | `open` and `create` refuse the flag and the template header, and no usage text offers it | Tests, and a read of the usage text | `tests/Test-StarGitHub`, section 10, `extension.yaml` |
| The design matches | Section 10, D-013, and D-014 describe the behavior, D-013 names its scope, and D-009 is marked superseded in part | A read of the merged files | `docs/architecture/issue-data-model/` |
| The deployed commands work | The deployed `reopen` fixes an issue reopened on GitHub's page, and the deployed `close` fixes an issue a `Closes` line closed, in both sandboxes | Each run's records, each issue read back before and after | NobleFactor-sandbox and David-Noble-at-work-sandbox |

Each deployed result records the source revision, the `star` build, the deployed extension's path and revision, the account, the UTC time, what was expected, and what was found.

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The tests, `make check`, and review | Done. f0f0120: `make check` passed all 725 checks, all four CI jobs passed, and Codex's re-review cleared its three findings. |
| Merge | Yes | The pull request, merged in GitHub, closing #609 | Done. #612 merged on 2026-11-20 at 06:23:23 UTC as 2da34a13440277126901537323f5ac1556f6cee1, closing #609. |
| Deployment | Yes: the commands reach each machine only through `writ deploy` | `writ deploy` | Done. Deployed on 2026-11-20, before 06:40 UTC: the GitHub extension's installed commands link into the layer clone at 2da34a1, and they ran under `star` v0.1.0-dev.20261109005023 (develop), build 1ae1da72, at `~/.local/bin/star`, written 2026-11-08 17:02:46 −08:00. |
| Verification | Yes | The deployed `close` and `reopen`, run in both sandboxes. The `reopen` run is also the first deployed run of `reopen`, which #589's plan transferred to this one. | Done. All 17 checks passed on 2026-11-20, 06:40:00 to 06:41:38 UTC, in both sandboxes, [posted on #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609#issuecomment-7050219556). |

<a id="implementation-phases"></a>

## 9. Implementation phases

Each commit that changes a command's behavior also changes section 10, its decisions, the command's usage text, and this plan's progress.

### 9.1 Phase 1: the plan

- [x] Commit this plan on `feature/609-rerun-finishes`, with #589's and #605's plans marked complete, and review it. #589's verification reads as transferred to this plan, not as passed. Approved 2026-11-19, at 71f40ef, after two reviews by Codex.
- [x] Rewrite #609's title and body to match the approved plan: done 2026-11-19.

### 9.2 Phase 2: the comment rule

- [x] The comment rule in `steps.star`, `fail_after` in the harness, and their tests: `lifecycle`, `current` and `last_at`; the stand-in keeps each issue's history and can lose a write's answer. Tested through `close`, in Phase 3's commit.

### 9.3 Phase 3: `close`

- [x] `close` idempotent, with the Resolution rule and its tests; section 10's § Closing an issue, D-013, and D-009 marked superseded in part. Cases 127 and 175 to 183 pass, with 570 of 570 on 2026-11-19; without the fix, 127 and 175 to 178 and 180 to 183 fail, and 179, whose old behavior was already to write nothing, passes.

### 9.4 Phase 4: `reopen`

- [x] `reopen` idempotent for the issue, its parents, and its schedules, with its tests; section 10's § Reopening an issue and D-011. Cases 132 and 184 to 192 pass, with 594 of 594 on 2026-11-19; without the fix, 132, 184 to 189, 191 and 192 fail, and 190, whose old behavior was already to write nothing on an open issue, passes. D-013 covers `reopen`, and section 8 says a schedule reopened partway is finished.

### 9.5 Phase 5: `open`

- [x] `--unique` removed, with its tests; section 10's § Opening an issue and D-014; section 10's headings numbered, each with an anchor that keeps its old link target. Cases 136 and 140 pass, with 595 of 595 on 2026-11-19; without the change, 140's two checks fail, and 136, whose template no longer names `unique`, passes.

### 9.6 Phase 6: the corrections from Codex's review of PR #612

- [x] `close` without its comment on a change of Resolution or the rule that recovered it, every other `resolution:` label removed whether or not the one asked for needs adding (H-F01, H-F02); cases 180, 181, 183 and 193, each with a run after the retry that writes nothing; section 10, D-013 and #609's body to match. 599 of 599 on 2026-11-20; without the change, 180, 181, 183 and 193 fail.
- [x] H-F03: a schedule that has closed before gets its own row set In progress when `reopen` reaches it, and one that has never closed keeps Open; case 194, with a run after that writes nothing; section 8, D-011, section 10 and D-013 to match. Case 194 runs in this commit's `make check`.

### 9.7 Phase 7: merge, deployment, and verification

- [x] Merge the pull request in GitHub: #612, as 2da34a1.
- [x] Run `writ deploy`.
- [x] In each sandbox, run the deployed `reopen` on an issue reopened on GitHub's page, and the deployed `close` on an issue a `Closes` line closed. Read each issue back, and post the results on #609: [posted](https://github.com/NobleFactor/noblefactor-engprod/issues/609#issuecomment-7050219556).
- [x] Bring the posted results into this plan's completion review.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- In `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/`:
  - `commands/github-issue-close.star`, `commands/github-issue-reopen.star`, and `commands/github-issue-open.star`.
  - `commands/steps.star`, for the comment rule and the rows; `commands/issues.star`, for the Resolution; `commands/ending.star`, for the schedule `reopen` reaches.
  - `extension.yaml`, without `--unique`.
- `tests/Test-StarGitHub`, for `fail_after` and the tests.
- `docs/architecture/issue-data-model/10-the-issue-commands.md` and `10-the-issue-commands.decisions.md`.
- `docs/plans/doc/589-issue-verbs.md` and `docs/plans/feature/605-squash-message.md`, marked complete in this branch's first commit, because all their issues are closed.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- This task is step 12 of Schedule #588. Nothing blocks it.
- [Feature NobleFactor/devlore-cli#1238](https://github.com/NobleFactor/devlore-cli/issues/1238) and [Scenario NobleFactor/devlore-cli#1239](https://github.com/NobleFactor/devlore-cli/issues/1239) are the graph approach this task doesn't take. Neither blocks it. #474, the GitHub extension on the command provider, and #471, reading the model through a graph, overlap #1238.
- [Bug #611](https://github.com/NobleFactor/noblefactor-engprod/issues/611) applies this task's comment rule to `move`, once this task lands.
- #589's plan transferred its last open item to this plan: running `reopen` as deployed. This plan's verification covers it.
- Each command refuses `--dry-run` until NobleFactor/devlore-cli#1170 is done.

<a id="approval-and-departures"></a>

## 12. Approval and departures

Decisions, 2026-11-19, on revisions 2428a08 to c7dd403:

- `close` and every other command are idempotent. An issue that's closed stays closed.
- `open` checks for no duplicate, now or later. A model provider will handle that. Neither `--allow-duplicate` nor `--unique` is kept. Each run of `open` opens a new issue.
- `reopen` clears the Resolution and sets the row to Open on an issue someone reopened on GitHub's page.

Decisions, 2026-11-19, on Codex's review of c7dd403:

- #609 doesn't use a graph. The graph approach is Feature NobleFactor/devlore-cli#1238, with Scenario NobleFactor/devlore-cli#1239 as its prototype.
- A run writes a comment only if there is none from the same command about the same issue in that issue's current close or reopen. Refined the same day: `close` looks back to the issue's last reopening, since its comment comes before the close event, and a comment on a Scenario issue counts only for the child it names. Refined again: a Resolution-change comment is its own kind, so the closing comment never stands in for it; an issue never closed gets repairs but no reopen comment; and D-013 covers `close` and `reopen`, naming what it doesn't yet cover. Refined a third time: `close` sets a new Resolution before its change comment, and compares with the Resolution it last recorded, so a change made by hand is told from a stopped run.
- `close` sets a different Resolution when asked, and comments on the change. Superseded 2026-11-20, below: no comment on a change of Resolution.
- `move`'s repeated Scenario comment is Bug #611, outside this task.

Approved 2026-11-19, at revision 71f40ef.

Codex's review of PR #612 at 17a4096 recommended H-F01 and H-F03, with a never-closed schedule keeping its row Open, and asked for a more precise recovery rule for H-F02.

Decision, 2026-11-20, on that review:

- `close` writes no comment on a change of Resolution, and the rule that recovered one goes (H-F02, option 3). A retry finishes the requested Resolution, labels, issue state and rows, and the next run writes nothing. The closing, reopening and Scenario comments stay. `--reason` is written in the closing comment alone. A proof in NobleFactor-sandbox/sandbox#77 and David-Noble-at-work-sandbox/sandbox#63 found that GitHub can list an issue-field change after a comment written later; label events kept their order. The comment is removed because its value doesn't justify its machinery. H-F01 is part of the same decision: a retry finishes the requested labels.
- A schedule that `reopen` reaches gets its own row set In progress when it has closed before, whatever its Status; one that has never closed keeps the Status its opening gave it, Open (H-F03). Directed 2026-11-20.

Departure, 2026-11-19: Phases 2 and 3 land in one commit, because only a command can exercise the comment rule, and `close` is the first to use it. The stand-in gh keeps each issue's history, its comments, closes and reopens at one clock, as GitHub's timeline does, so the tests can stop a run at any write.

<a id="completion-review"></a>

## 13. Completion review

Every milestone in § 8 is met, and #609 is closed.

- **Implementation and review:** f0f0120, the last commit of #612, passed `make check` and all four CI jobs. Codex's review of #612 found H-F01, H-F02 and H-F03; H-F01 and H-F03 were fixed, H-F02 was resolved by removing the comment on a change of Resolution, and Codex's re-review cleared all three.
- **Merge:** #612 merged on 2026-11-20 at 06:23:23 UTC as 2da34a1, closing #609. Its time from first commit to merge was 11.8 hours.
- **Deployment and verification:** after `writ deploy`, under `star` v0.1.0-dev.20261109005023 (develop), build 1ae1da72, at `~/.local/bin/star`, written 2026-11-08 17:02:46 −08:00, with the GitHub extension's commands linked into the layer clone at 2da34a1, the deployed `reopen` and `close` passed all 17 checks in NobleFactor-sandbox and David-Noble-at-work-sandbox, each on an issue reopened or closed outside `star`, with a second run writing nothing. This was also the first deployed run of `reopen`, which #589's plan transferred here. The results are [posted on #609](https://github.com/NobleFactor/noblefactor-engprod/issues/609#issuecomment-7050219556).
- **Limitation:** neither sandbox's Triage workflow could run, because neither had its token, so the check added each issue's Triage row itself, as the workflow would. #451 restores the tokens, and #613 alerts when one goes missing.
- **Outstanding obligations:** none for #609.
- **How each issue was changed before the deployed command ran:** through GitHub's API, with `gh issue reopen` and `gh issue close --reason completed`, not on the issue's page or by a pull request's `Closes` line as Phase 7 names. `issue reopen` and `issue close` read an issue's state, fields, labels and rows, and the kind and time of each of its comments, closings and reopenings (`lifecycle` in `commands/steps.star`). GitHub records those the same way whichever path made the change. Neither reads what closed an issue: only `star github schedule close` does, through `closing_of` (`commands/ending.star`, line 189). Disposition: accepted as equivalent by David Noble, as Owner, on 2026-11-20, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`, after Codex's review of #615 raised it.
- **Completion approval:** David Noble, as Owner, on 2026-11-20, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`. Its scope: completing #609 by posting its post-merge results on #609 and recording them in this plan through a completion-only pull request.
