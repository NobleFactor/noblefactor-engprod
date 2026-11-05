---
title: "5. From today's scheme — Status"
---

# 5. From today's scheme — Status

**Document:** [5-from-todays-scheme.md](5-from-todays-scheme.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Revised 2026-10-22 to the rulings of the two days, with each delta's state. Revised 2026-11-03 to the rulings
of the cutover, 2026-11-02 and 2026-11-03: Chore retired; each account, organization or user, separate, with its model
in its own `.github` repository; a schedule's rows numbered by step, with blocked-by links and no Next column; the
Schedule and Thread types; no triage epics; the `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels removed; and a
working issue tracking system on GitHub first, with the tooling following in issues of its own. The six stages of the
order keep their numbers, and the cutover did most of stages 3 and 4 and part of stage 6 in GitHub before stage 2.
Revised again on 2026-11-03 to the last rulings of that day: the Thread type renamed Scenario, and the label thread
renamed scenario; four projects for each team and for the user account, Triage, Backlog, one Schedule project and one
Scenario project, in place of a project per schedule and a project per thread, copied from NobleFactor's four templates
or David-Noble-at-work's copies of them; the Schedule and Scenario fields, Step, Beat and GitHub's Iteration field; the
triage decision; new issues brought to their team's Triage project by a GitHub Actions workflow in each repository; each
project the charge of the team that owns it; and issues classified by type, with lax enforcement and no compliance
checks. Revised once more on 2026-11-03: Area, product or engineering, tells engineering work from product work, and a
blank Area is caught at filing, at triage and by a scheduled sweep; devlore-cli's seven finer `Area:` labels deleted;
each account's model holding its issue fields; and the old scheme's last three pieces, the parent markers with the
schedule footers, the step and beat tables, and NobleFactor's kind labels, retired in GitHub that day. Revised on the
evening of 2026-11-03 to that day's ruling that an account's file templates, which are its issue forms, its Triage
workflow template and its pull request template, are stored in its `.github` repository
([section 6](6-the-asset-and-its-sync.md#one-model-per-account)). Revised later that evening to that day's last rulings,
and to the changes made and read back then: Severity is an issue field of the organization in NobleFactor
([section 2](2-attributes.md#the-attributes)); devlore-cli's `Severity:` and `Priority:` labels moved to the Severity
and Priority fields, 152 values in all, and the eight labels were deleted, so no NobleFactor repository has a severity
or priority label; in a user account a label stands in for each option of a single-select field
([section 4](4-storage-and-reach.md#a-user-account)), and David-Noble-at-work has schedules of its own
([section 4](4-storage-and-reach.md#the-rest-of-the-ruling)); and the script of this design's worktree (#303) took
`chore` out of ruleset 12515090, while `git open-branch` still accepts it. Revised at the end of 2026-11-03:
`git open-branch`'s script names `chore` at lines 100, 110, 168 and 169 (§ The deltas); `TRIAGE_PROJECT_URL` is set in
seven repositories, both `.github` repositories among them ([section 4](4-storage-and-reach.md#triage)); and, read from
GitHub that day, NobleFactor has the type Scenario and no Thread, and personal the label scenario and no thread label.
Brought on 2026-11-04 to that day's rulings, which settle the questions #303 had left open, and to the owner's rewrite
of the first later that day and the decisions that followed it, the last of them that one project at a time holds across
the account and that triage removes an issue's Triage row (§ The deltas): an issue is a row of at most one of its
account's projects, whichever team owns them, and on at most one schedule or scenario, and every move between them is
one act; an issue on another team's project is assigned to an accountable member of that team, and the person whose name
is on an issue moves it to another team, superseding in part the ruling of 2026-10-22 that work for another team gets a
tracking issue; triage removes an issue's Triage row as part of its decision, and the sweep (#436) will remove none; an
epic or a feature leaves Triage for no project, and the one grant a new participant needs is membership in the team; a
scenario's rows are its Scenario issue and the tasks and bugs found by walking it; the Backlog shows its order in a By
priority view; Severity applies to bugs only, and every issue of a type other than Bug has Severity N/A, which triage
sets when it gives a type other than Bug to an issue that arrived with none; every issue but a Scenario issue states its
evidence of completion in its Evidence of completion section, which the issue form checks at filing in a public
repository, personal being the one private participating repository, and a Scenario issue, which never closes, states
none; and the sweep will return to its team's Triage project an open issue that breaks an attribute rule or isn't fully
classified, will leave a scenario's rows alone but for two structural rules, on an epic or a feature in a scenario and
on an issue in a scenario and in another of its account's projects, and waits on #452, which will give every open issue
an Area first. The ruling of 2026-11-03 that there are no compliance checks is superseded in part by the sweep, which
will be the one check. What those rulings change in GitHub is made by the script of #303's closing pull request: the
teams' write role on their four projects, in place of the Admin role ruled for each team's Triage project on 2026-10-22;
the By priority views, and the fields the views show; Severity's N/A option and the `severity:n/a` label; N/A on every
open issue of a type other than Bug, 414 in NobleFactor's five participating repositories and 33 in personal, read that
day before #452 and #453 were filed; the five feature rows, removed; the Scenario rows of 15 tasks and bugs that had
already moved on, removed; and the Triage rows of the 30 open issues in NobleFactor's Triage projects that are also rows
of a Schedule project, deleted. Taking `chore` out of `git open-branch` is #449 (approved 2026-11-04). The deltas show
question 18 ruled, as it was on 2026-11-03, doc/303-model-cutover merged in #444, the open noblefactor-engprod issues
that weren't fully classified on 2026-11-04, the 78 closed issues among Triage: engprod's 178 rows that day, which are
triage's to decide, and the Scenario type's description and the `scenario` labels' in personal and
David-Noble-at-work/.github, which #453 will bring to the ruling with the forms. The deltas and the stages also show
what is not built yet: #376, the extension reading the hierarchy from `model.yaml`; #379, the report and the audit
placing an issue by its type and parent first; `star github issue` (#338); and, in NobleFactor, the Triage workflow's
copy of the form's Area, which waits on #447 and #448, while personal's makes it today. A user account's new participant
is a collaborator on each participating repository, personal and David-Noble-at-work/.github.

## Completion

- [x] The task list drawn from the deltas, with the owner -- 2026-10-22, nine tasks: #376 to #380, #361, #363, #338 and
  #365; 2026-11-02: #425 to #428, #436 to #441, and David-Noble-at-work/personal#309; and 2026-11-04: #447 that morning,
  under the plan's § The cutover, and #448 to #453 in #303's closing.
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
