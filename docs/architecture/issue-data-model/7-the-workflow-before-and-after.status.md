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
`doc/303-model-cutover`: GitHub's own records first and the tooling second, Chore retired, steps in place of lanes,
no Next column, and one model per account. Brought on 2026-11-03 to that day's later rulings: threads renamed
scenarios; each team's four projects, Triage, Backlog, one Schedule and one Scenario project; new issues added to
Triage by a GitHub Actions workflow in each repository; and `star github issue` as the one path for filing. Brought
on 2026-11-03 to that day's last rulings: Area tells product work from engineering work, with two values only, and a
blank Area is caught at filing, at triage and afterwards; devlore-cli's seven finer Area labels deleted; an account's
model holds its issue fields; and the old scheme's parent markers, schedule footers, step and beat tables and
NobleFactor's kind labels retired in GitHub. Brought on the evening of 2026-11-03 to the ruling that an account's file
templates, which are its issue forms, its Triage workflow template and its pull request template, are stored in its
`.github` repository. Brought later that evening to that day's last rulings: Severity is an issue field of the
organization in NobleFactor ([section 2](2-attributes.md#the-attributes)); in a user account a label stands in for each
option of a single-select field, the `effort:` labels among them, and the priority labels run from `priority:urgent` to
`priority:low` ([section 4](4-storage-and-reach.md#a-user-account)); and GitHub's documentation describes workflow
templates kept in an organization's `.github` repository and says nothing about a user account's
([section 4](4-storage-and-reach.md#triage)). Brought at the end of 2026-11-03 to what GitHub held then: the boxes for
threads renamed scenarios and for each team's and David-Noble-at-work's four projects are ticked, with what was read
from GitHub that day. On 2026-11-04 the box for the four projects was brought to what GitHub held that day.

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
- [x] Done in GitHub, 2026-11-03: the Area issue field's options Product and Engineering in NobleFactor; the Area
  column in NobleFactor's Triage projects, and a Missing Area view in each Triage project; and devlore-cli's seven
  finer Area labels (architecture, CLI, code quality, error handling, git, meta and testing) deleted.
- [ ] A scheduled sweep that returns any open issue without an Area to its team's Triage project, ruled 2026-11-03.
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
- [ ] The Triage workflow in each repository, ruled 2026-11-03: a GitHub Actions workflow, run when an issue is opened
  or transferred, that adds it to its team's Triage project with `actions/add-to-project`; each repository's
  `TRIAGE_PROJECT_URL` variable, from the team mapping; a Triage workflow template in each account's `.github`
  repository; and, ruled 2026-11-03, the workflow's copying of the answer to an issue form's Area dropdown into the
  Area field or label when the issue is opened. On 2026-11-03 the Triage workflow template, `triage.yml` and
  `triage.properties.json`, was in both `.github` repositories
  ([section 6](6-the-asset-and-its-sync.md#one-model-per-account)); where the workflow itself stands is in
  [section 4's status](4-storage-and-reach.status.md). Open, to be ruled on #303: how a triage decision is carried out,
  and how an issue is kept in one project at a time.
- [x] The Schedule and Scenario issue forms in NobleFactor/.github and David-Noble-at-work/.github, each with a required
  Area dropdown, as every issue form in each account's `.github` repository has (ruled 2026-11-03) -- 2026-11-03: read
  from GitHub, the schedule and scenario forms in both `.github` repositories each have a required Area dropdown, as
  every form there does; both hold the six issue forms in `.github/ISSUE_TEMPLATE`
  ([section 6](6-the-asset-and-its-sync.md#one-model-per-account))
- [ ] `star github issue` files with type (a type label, in a user account), parent and attributes; refuses a parent in
  another account; refuses an issue without an Area (ruled 2026-11-03); and checks the documents table (#338). Open,
  to be ruled on #303: where an issue states its evidence of completion, and what checks it when the issue is filed.
  Ruled 2026-11-03, the plan's question 18: a repository takes part when a team has the maintain role on it, or, in a
  user account, when it has the topic issue-model.
- [ ] `star github schedule add` gives a row its step number and its blocked-by links and writes its amendment, in one
  act (#438).
- [ ] The report and the audit read the type and the link first (#379), and the rows of the team's projects (#427).
- [ ] Retired from the guidance, in [issue-standards.md](../../issue-standards.md) on this branch under #303: Chore
  and its `**Chore:**` marker, and the `Epic:` and `Thread:` label conventions, with the `Epic:Ops:Process` hub; and,
  retired in GitHub on 2026-11-03, the parent markers such as `**Feature:**`, the schedule footers, the step and beat
  tables in issue bodies, and NobleFactor's kind labels `epic`, `feature`, `task` and `bug`. A user account's type
  labels stay.
- [ ] Rule 15's grep retired, once the create command checks the documents table; no issue is named for it yet.
