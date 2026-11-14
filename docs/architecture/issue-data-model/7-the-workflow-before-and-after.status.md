---
title: "7. The workflow, before and after — Status"
---

# 7. The workflow, before and after — Status

**Document:** [7-the-workflow-before-and-after.md](7-the-workflow-before-and-after.md)
**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303), the
design; its build and rollout work moved to issues of their own on 2026-11-02
**State:** Written 2026-10-22 as the design's motivation, from the owner's question of that day; it describes the
"after" the other sections rule, and changes as they do. Brought to the rulings of 2026-11-02 and 2026-11-03 on
`doc/303-model-cutover`: GitHub's own records first and the tooling second, Chore retired, steps in place of lanes, no
Next column, and one model per account. Brought on 2026-11-03 to that day's later rulings: threads renamed scenarios;
each team's four projects, Triage, Backlog, one Schedule and one Scenario project; new issues added to Triage by a
GitHub Actions workflow in each repository; and `star github issue` as the one path for filing. Brought on 2026-11-03 to
that day's last rulings: Area tells product work from engineering work, with two values only, and a blank Area is caught
at filing, at triage and afterwards; devlore-cli's seven finer Area labels deleted; an account's model holds its issue
fields; and the old scheme's parent markers, schedule footers, step and beat tables and NobleFactor's kind labels
retired in GitHub. Brought on the evening of 2026-11-03 to the ruling that an account's file templates, which are its
issue forms, its Triage workflow template and its pull request template, are stored in its `.github` repository. Brought
later that evening to that day's last rulings: Severity is an issue field of the organization in NobleFactor
([section 2](2-attributes.md#the-attributes)); in a user account a label stands in for each option of a single-select
field, the `effort:` labels among them, and the priority labels run from `priority:urgent` to `priority:low`
([section 4](4-storage-and-reach.md#a-user-account)); and GitHub's documentation describes workflow templates kept in an
organization's `.github` repository and says nothing about a user account's
([section 4](4-storage-and-reach.md#triage)). Brought at the end of 2026-11-03 to what GitHub held then: the boxes for
threads renamed scenarios and for each team's and David-Noble-at-work's four projects are ticked, with what was read
from GitHub that day. On 2026-11-04 the box for the four projects was brought to what GitHub held that day. Brought on
2026-11-04 to that day's rulings, which settle the questions #303 had left open, and to the owner's rewrite of the first
later that day and the decisions that followed it: how an issue moves between its team's projects and who moves it, and
how work in the Backlog reaches a schedule; one project at a time across the account's projects, whichever team owns
them, with an issue on another team's project assigned to an accountable member of that team, and the person whose name
is on an issue moving it to another team in one act; triage removing an issue's Triage row as part of its decision; an
epic or a feature leaving Triage for no project; a scenario, whose rows are its Scenario issue and the tasks and bugs
found by walking it; Severity N/A on every issue of a type other than Bug, which the Triage workflow (#448) and
`star github issue` (#338) will set, and which triage sets when it gives a type other than Bug to an issue that arrived
with none; every issue but a Scenario issue, which never closes, stating its evidence of completion in the Evidence of
completion section of its issue form, read from GitHub that day in both accounts' `.github` repositories, which the form
checks at filing only in a public repository; `star github issue`, not yet built, which will refuse an issue without an
Area or, a Scenario issue excepted, without that section (#338); a scenario changing no issue's priority; the sweep
(#436) in place of the audit for an issue's faults, leaving a scenario's rows alone but for two structural rules and
superseding in part the ruling of 2026-11-03 that there are no compliance checks; the teams' write role on their four
projects, in place of the Admin role ruled for each team's Triage project on 2026-10-22, and a user account's new
participant a collaborator on each participating repository; the Scenario rows of 15 tasks and bugs that had already
moved on, which the script of #303's closing pull request removes with the five feature rows; and, read that day, no
view showing the Area, Labels or Priority column, which the same script shows. Revised 2026-11-05 for #446: § Product
and engineering points to [issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering),
which says what product work and engineering work each cover, tests among engineering's, and what each may hold, in
place of the list of what engineering covers; the sentence that the product readiness and release management epics
hold both kinds is gone, superseded on 2026-11-05; and the table row on the area sends the reader there to learn what
each value means. Built 2026-11-13 in #448: personal, David-Noble-at-work/.github and NobleFactor's five participating
repositories run the Triage workflow, which sets the Severity when an issue is opened, keeping one already set and
leaving an issue with no type yet to triage, and adds an issue whose body says "Found while walking #N", where #N is an
open scenario of the account, to that scenario instead of to Triage; NobleFactor's has set the Area field since its
first run, on 2026-11-11, and section 7 states each as done.

## Completion

- [x] Done in GitHub, 2026-11-01 to 2026-11-03: the types Epic, Feature, Task, Bug, Schedule and Thread in NobleFactor,
  and the labels `epic`, `feature`, `task`, `bug`, `schedule` and `thread` in David-Noble-at-work; the Schedule, Thread
  and Triage templates, NobleFactor projects 7, 8 and 23, and David-Noble-at-work's copies, its projects 1, 2 and 4;
  the three Triage projects, NobleFactor projects 5 and 6 and David-Noble-at-work project 3; schedules numbered by
  Step, their first rows without one, and no Next column; the triage epics retired; and the `chore`, `Epic:`,
  `Thread:` and `ClaudeJudgmentError:` labels removed from both accounts.
- [x] Done in GitHub, 2026-11-03: the old scheme's last three pieces retired. The parent markers and schedule footers
  came out of 725 issue bodies, 47 issues got the sub-issue parent their marker named, and the link stands where the
  two disagreed; the step and beat tables in 14 Schedule and Scenario issues gave way to a line naming the issue's
  board and option; and the kind labels `epic`, `feature`, `task` and `bug` left NobleFactor's 12 repositories, after
  672 issues got the issue type their label named. David-Noble-at-work keeps its type labels, which are its types.
- [x] Done in GitHub, 2026-11-03: the Area issue field's options Product and Engineering in NobleFactor; the Area field
  in NobleFactor's Triage projects, and a Missing Area view in each Triage project; and devlore-cli's seven finer Area
  labels (architecture, CLI, code quality, error handling, git, meta and testing) deleted. Read 2026-11-04, no view of a
  Triage project shows the Area column; the script of #303's closing pull request shows it.
- [ ] A scheduled sweep that returns any open issue without an Area to its team's Triage project, ruled 2026-11-03, and,
  ruled 2026-11-04, any open issue but a Scenario issue with no Evidence of completion section, and any that breaks an
  attribute rule, that is an epic or a feature with a row in a Backlog, Schedule or Scenario project, or that is in more
  than one of its account's projects or on more than one schedule or scenario, whichever team owns them, leaving a
  scenario's rows alone but for those last two rules: #436, which waits on #452, giving every open issue an Area first.
- [x] Threads renamed scenarios, ruled 2026-11-03: the Thread type renamed Scenario in NobleFactor, the `thread` label
  renamed `scenario` in David-Noble-at-work, and the Thread template, NobleFactor project 8, and its copy in
  David-Noble-at-work renamed Scenario -- 2026-11-03: read from GitHub, NobleFactor's issue types are Epic, Feature,
  Task, Bug, Schedule and Scenario; personal has the label `scenario` and no `thread` label; and NobleFactor project 8
  and David-Noble-at-work project 2 are named Scenario
- [x] Each team's and David-Noble-at-work's four projects, ruled 2026-11-03: `Triage: <team>`, `Backlog: <team>`,
  `Schedule: <team>` and `Scenario: <team>`, and in the user account the same four named for David-Noble-at-work, copied
  from NobleFactor's Triage, Schedule, Scenario and Backlog templates or David-Noble-at-work's copies of them; the
  Backlog template, NobleFactor project 24; the Schedule project's Schedule, Step and Iteration fields and the Scenario
  project's Scenario and Beat fields; and no project per schedule or per scenario -- 2026-11-03: compared field by
  field, option by option and view by view, each of the twenty, NobleFactor's four templates, engprod's four projects,
  devlore's four, and David-Noble-at-work's four copies and four projects, matches its kind's template in fields,
  Status options, iteration settings, views, readme and built-in workflows, except for the Area and Priority columns,
  issue fields that David-Noble-at-work's Triage and Backlog projects lack
  ([section 3](3-collections.md#four-projects-per-team)); every Schedule and Scenario project and template has its field
  ([section 3](3-collections.md#the-schedule-and-scenario-fields)); and the projects per schedule and per thread,
  NobleFactor projects 9 to 22, folded into the teams' Schedule and Scenario projects and closed
  ([the plan](../../plans/chore/303-issue-data-model.md) § The cutover, from 2026-11-02); that closing missed
  NobleFactor project 4, "Thread: the model follows a rename", the thread project made on 2026-10-24 as #377's write
  test, which the owner closed on 2026-11-04 ([section 3's status](3-collections.status.md))
- [x] The Triage workflow in each repository, ruled 2026-11-03: a GitHub Actions workflow, run when an issue is opened
  or transferred, that adds it to its team's Triage project with `actions/add-to-project`; each repository's
  `TRIAGE_PROJECT_URL` variable, from the team mapping; a Triage workflow template in each account's `.github`
  repository; and, ruled 2026-11-03, the workflow's copying of the answer to an issue form's Area dropdown into the Area
  field or label when the issue is opened. On 2026-11-03 the Triage workflow template, `triage.yml` and
  `triage.properties.json`, was in both `.github` repositories
  ([section 6](6-the-asset-and-its-sync.md#one-model-per-account)); where the workflow itself stands is in
  [section 4's status](4-storage-and-reach.status.md). Ruled 2026-11-04: the workflow will set Severity N/A on an issue
  of another type filed from a form, will give a bug filed from the bug form Severity Medium, and will add an item that
  names its scenario in its body, as "Found while walking #N", to the scenario instead of to Triage. #448 made it so in
  both accounts' Triage workflow templates, personal's workflow and David-Noble-at-work/.github's on 2026-11-13
  (David-Noble-at-work/.github#8), and the workflow runs in noblefactor-engprod, .github, devlore-cli, devlore-registry
  and devlore.noblefactor.com, landed by `star github model apply` (#437) after #447. How a triage decision is carried
  out, and how an issue is kept in one project at a time, were ruled the same day (§ Filing an issue, under Triage, in
  section 7). -- 2026-11-13: the workflow runs in NobleFactor's five participating repositories, personal and
  David-Noble-at-work/.github, copies the Area, sets the Severity and adds an item found while walking an open scenario
  to that scenario (#441, #448)
- [x] The Schedule and Scenario issue forms in NobleFactor/.github and David-Noble-at-work/.github, each with a required
  Area dropdown, as every issue form in each account's `.github` repository has (ruled 2026-11-03) -- 2026-11-03: read
  from GitHub, the schedule and scenario forms in both `.github` repositories each have a required Area dropdown, as
  every form there does; both hold the six issue forms in `.github/ISSUE_TEMPLATE`
  ([section 6](6-the-asset-and-its-sync.md#one-model-per-account))
- [ ] `star github issue` (#338), which will file with type (a type label, in a user account), parent and attributes,
  refuse a parent in another account and an issue without an Area (ruled 2026-11-03), and check the documents table.
  Ruled 2026-11-04: every issue but a Scenario issue states its evidence of completion in its Evidence of completion
  section, which the issue form checks at filing in a public repository; in a private one, which today is only personal,
  nothing checks it at filing until `star github issue` does. It will refuse an issue other than a Scenario issue
  without the section, and set Severity N/A at filing on an issue of a type other than Bug. Ruled 2026-11-03, the plan's
  question 18: a repository takes part when a team has the maintain role on it, or, in a user account, when it has the
  topic issue-model.
- [x] `star github schedule add` gives a row its step number and its blocked-by links and writes its amendment, in one
  act (#438): built on 2026-11-12 and proved that day in NobleFactor-sandbox; a user account's half waits on
  David-Noble-at-home.
- [ ] The report and the audit read the type and the link first (#379), and the rows of the team's projects (#427).
- [ ] Retired from the guidance, in [issue-standards.md](../../issue-standards.md) on this branch under #303: Chore
  and its `**Chore:**` marker, and the `Epic:` and `Thread:` label conventions, with the `Epic:Ops:Process` hub; and,
  retired in GitHub on 2026-11-03, the parent markers such as `**Feature:**`, the schedule footers, the step and beat
  tables in issue bodies, and NobleFactor's kind labels `epic`, `feature`, `task` and `bug`. A user account's type
  labels stay.
- [ ] Rule 15's grep retired, once the create command checks the documents table; no issue is named for it yet.
