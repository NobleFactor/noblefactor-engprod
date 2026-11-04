---
title: "5. From today's scheme — Status"
---

# 5. From today's scheme — Status

**Document:** [5-from-todays-scheme.md](5-from-todays-scheme.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Revised 2026-10-22 to the rulings of the two days, with each delta's state. Revised 2026-11-03 to the
rulings of the cutover, 2026-11-02 and 2026-11-03: Chore retired; each account, organization or user, separate, with
its model in its own `.github` repository; a schedule's rows numbered by step, with blocked-by links and no Next
column; the Schedule and Thread types; no triage epics; the `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels
removed; and a working issue tracking system on GitHub first, with the tooling following in issues of its own. The
six stages of the order keep their numbers, and the cutover did most of stages 3 and 4 and part of stage 6 in GitHub
before stage 2. Revised again on 2026-11-03 to the last rulings of that day: the Thread type renamed Scenario, and the
label thread renamed scenario; four projects for each team and for the user account, Triage, Backlog, one Schedule
project and one Scenario project, in place of a project per schedule and a project per thread, copied from
NobleFactor's four templates or David-Noble-at-work's copies of them; the Schedule and Scenario fields, Step, Beat
and GitHub's Iteration field; the triage decision; new issues brought to their team's Triage project by a GitHub
Actions workflow in each repository; each project the charge of the team that owns it; and issues classified by type,
with lax enforcement and no compliance checks. Revised once more on 2026-11-03: Area, product or engineering, tells
engineering work from product work, and a blank Area is caught at filing, at triage and by a scheduled sweep;
devlore-cli's seven finer `Area:` labels deleted; each account's model holding its issue fields; and the old scheme's
last three pieces, the parent markers with the schedule footers, the step and beat tables, and NobleFactor's kind
labels, retired in GitHub that day. Revised on the evening of 2026-11-03 to that day's ruling that an account's file
templates, which are its issue forms, its Triage workflow template and its pull request template, are stored in its
`.github` repository ([section 6](6-the-asset-and-its-sync.md#one-model-per-account)). Revised later that evening to
that day's last rulings, and to the changes made and read back then: Severity is an issue field of the organization
in NobleFactor ([section 2](2-attributes.md#the-attributes)); devlore-cli's `Severity:` and `Priority:` labels moved to
the Severity and Priority fields, 152 values in all, and the eight labels were deleted, so no NobleFactor repository
has a severity or priority label; in a user account a label stands in for each option of a single-select field
([section 4](4-storage-and-reach.md#a-user-account)), and David-Noble-at-work has schedules of its own
([section 4](4-storage-and-reach.md#the-rest-of-the-ruling)); and the script of this design's worktree (#303) took
`chore` out of ruleset 12515090, while `git open-branch` still accepts it. Revised at the end of 2026-11-03:
`git open-branch`'s script names `chore` at lines 100, 110, 168 and 169 (§ The deltas); `TRIAGE_PROJECT_URL` is set in
seven repositories, both `.github` repositories among them ([section 4](4-storage-and-reach.md#triage)); and, read from
GitHub that day, NobleFactor has the type Scenario and no Thread, and personal the label scenario and no thread label.

## Completion

- [x] The task list drawn from the deltas, with the owner -- 2026-10-22, nine tasks: #376 to #380, #361, #363, #338
  and #365; and 2026-11-02: #425 to #428, #436 to #441, and David-Noble-at-work/personal#309.
- [ ] Each stage merged without taking down what a running session reads. The cutover made its subtractive changes in
  GitHub, not by merges: it removed the chore, `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels, renamed Lane to
  Step, deleted the Next column, retired the triage epics and, on 2026-11-03, retired the old scheme's last three
  pieces. The chore label's removal reached Start-Claude (#440).
- [x] The old scheme retired -- 2026-11-03, in GitHub, by the ruling of that day. The parent markers and the schedule
  footers came out of 725 issue bodies, and 47 issues got the sub-issue parent their marker named; where the two
  disagreed, the link stands. The step and beat tables in 14 Schedule and Scenario issues gave way to a line naming the
  issue's project and its option there. The kind labels epic, feature, task and bug left NobleFactor's 12
  repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its type labels,
  which are its types.
