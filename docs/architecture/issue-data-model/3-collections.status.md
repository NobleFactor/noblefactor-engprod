---
title: "3. Collections — Status"
---

# 3. Collections — Status

**Document:** [3-collections.md](3-collections.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled in part, 2026-10-22: the Triage project is the third collection, one per team; row 0 is the
collection's own issue, typed Epic. Questions 6 to 9 open for iteration 3. Two test projects, made and deleted on
2026-10-20, showed that a NobleFactor project holds personal's issues as rows and can be marked as a template. Built
2026-11-01: Triage: engprod and Triage: devlore, NobleFactor projects 5 and 6, each its team's, its triage epic row 0;
the Schedule and Thread templates, projects 7 and 8; and every open schedule and thread a project, 9 to 22, its own
issue row 0. Question 17 of the plan, added 2026-11-02, puts personal's rows in them in question. Ruled 2026-11-02:
organizations and individual accounts are separate, each with its own model (§ Accounts in section 4); question 17
settled the same day, and the model read on demand from two reference models (§ Reference models, read on demand, in
section 6). Revised the same day: each participating account keeps its model in its own `.github` repository (#431,
David-Noble-at-work/personal#311), which section 6 states with #431.
Ruled 2026-11-02: a schedule's rows are numbered by Step, not Lane, and its own issue's row has none; Lane renamed
Step in GitHub the same day, on the template and the nine schedules (§ The Schedule and Scenario fields).

Ruled 2026-11-02 and 2026-11-03, with the cutover. Chore is retired, so a scenario's rows no longer include chores.
The collection's own issue is typed Schedule or Scenario, not Epic, from 2026-11-03, and labeled schedule or scenario
in a user account. Triage is one project per team and one per user account, each made from the Triage template, with
no epic and no issue of its own. Question 6's open point is answered: every row of a schedule other than its Schedule
issue's own gets its step and its blocked-by links when it is added, and the Schedule issue's row has none. Question 7
is answered: Status is a field on a project row that anyone may set, and none of the twenty projects has a built-in
workflow (below). A schedule has a Worktree column, ruled 2026-11-03. Questions 8 and 9 are open.

Ruled 2026-11-03, and revised into section 3 the same day. Threads are renamed scenarios, and the Thread template is
the Scenario template. Each team, and each user account, has four projects, Triage, Backlog, one Schedule project and
one Scenario project, named "<Kind>: <team>" in an organization and "<Kind>: David-Noble-at-work" in the user
account; there is no longer a project per schedule or per scenario. The Schedule project holds committed tasks and
bugs, with a Schedule field naming each row's schedule, Step ordering the rows within it, and GitHub's Iteration field
giving each row its sprint. The Scenario project holds features, with a Scenario field naming each row's scenario and
Beat ordering the rows within it. The Backlog holds accepted work not yet scheduled, ordered by priority. In the Triage
project every issue is reviewed and is either declined, and closed as completed with Resolution Declined or the
`resolution:declined` label, or moved to the team's Backlog, Schedule or Scenario project. New issues reach Triage
through a GitHub Actions workflow in each repository using `actions/add-to-project`, with each repository's
`TRIAGE_PROJECT_URL` variable naming its team's Triage project. The team that owns a project is accountable for it,
and GitHub's link between them is the record. NobleFactor keeps four templates, Triage (project 23), Schedule
(project 7), Scenario (project 8) and Backlog (project 24), and David-Noble-at-work keeps copies of them. Question 10
is answered: a schedule's rows are tasks and bugs, and a scenario's rows are features.

Ruled 2026-11-03, the same day. An issue's Area, product or engineering, tells engineering work from product work: the
Area issue field in NobleFactor, the area:product and area:engineering labels in a user account. It applies to issues
of every type and describes each issue's own work. devlore-cli's seven finer Area labels are gone, and the hierarchy
carries their distinctions. A blank Area is an error, caught when an issue is filed, in each Triage project's Missing
Area view, and by a scheduled sweep that returns the issue to Triage. An account's model holds its issue fields:
NobleFactor's are Priority, Effort, Target date, Resolution, Area and Severity, with Start date unused, and a user
account has none. The old scheme's last three pieces are retired: the parent markers and schedule footers, the step
and beat tables in issue bodies, and NobleFactor's kind labels.

Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull
request template, are stored in its `.github` repository, and every document that talks about one of them refers to it
there (§ One model per account in section 6).

Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time.

Done in GitHub on 2026-11-02: the Next column deleted from the Schedule template and every schedule; the Triage
template made, NobleFactor project 23, with Triage: engprod and Triage: devlore brought to it; Triage:
David-Noble-at-work made, David-Noble-at-work project 3; and that account's copies of the Schedule and Thread
templates made, its projects 1 and 2. Done in GitHub on 2026-11-03: the account's copy of the Triage template, its
project 4; the Schedule and Thread types in NobleFactor and the schedule and thread labels in David-Noble-at-work,
since renamed Scenario and scenario by the ruling of that day, with the 12 schedule issues and the 5 thread issues
typed; the triage epics #142, NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313 retired, and their 24
open sub-issues made rows of their Triage projects; the `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels removed
from both accounts; and star taken out of the templates' descriptions.

Done in GitHub on 2026-11-03, after those rulings: the parent markers and schedule footers taken out of 725 issue
bodies, with 47 issues given the sub-issue parent their marker named and the link kept where the two disagreed; the
step and beat tables in 14 Schedule and Scenario issues replaced by a line naming the issue's project and its option
there; the kind labels epic, feature, task and bug removed from NobleFactor's 12 repositories, after 672 issues were
given the issue type their label named; the Product and Engineering options of NobleFactor's Area issue field made;
devlore-cli's seven finer Area labels deleted; and NobleFactor's Triage projects given the Area column, and each
Triage project the Missing Area view. David-Noble-at-work keeps its type labels, which are its types.

Read from GitHub on 2026-11-03: NobleFactor/.github and David-Noble-at-work/.github each hold six issue forms, one for
each type, and the Triage workflow template. GitHub's documentation describes workflow templates kept in an
organization's `.github` repository and says nothing about a user account's (§ Triage and the Backlog). The issue data
model design (#303) is a row of Schedule: engprod and of Triage: engprod, one issue in two of its team's projects at
once (§ Triage and the Backlog). Found the same day: #303's row on Schedule: engprod had no Worktree link, and its
branch, `doc/303-model-cutover`, had not yet been pushed. The worktree's script ran on 2026-11-03: it pushed the
branch, which is on GitHub at `60828ac`, and linked it in the row's Worktree column, and the row has read back the
link since (§ The Schedule and Scenario fields).

Ruled 2026-11-03: David-Noble-at-work has schedules of its own, and personal's steps go on them. Its first, issue
tracking, iteration 1 (David-Noble-at-work/personal#314), is the first option of Schedule: David-Noble-at-work's
Schedule field, with David-Noble-at-work/personal#315 as its step 1 (§ Collections belong to one account, and § The
rest of the ruling in section 4).

Done in GitHub on 2026-11-03, on the owner's order: a placeholder scenario in each account, to give the Scenario fields
their first option, since GitHub won't make a single-select project field without one. The Scenario template's
Scenario field has one option, placeholder, naming NobleFactor/noblefactor-engprod#442, and the Scenario fields of
Scenario: David-Noble-at-work and the account's Scenario copy have one, placeholder, naming
David-Noble-at-work/personal#316. Done later the same day, also on the owner's order: a placeholder schedule in each
account, NobleFactor/noblefactor-engprod#443 and David-Noble-at-work/personal#319, open, with no rows and no
deliverable, to give the Schedule template and the account's Schedule copy their Schedule fields, each with one
option, placeholder, naming its issue. So every Schedule and Scenario project, template and copy in both accounts has
its field now, as read from GitHub on 2026-11-03 (§ The Schedule and Scenario fields).
Section 3 was revised the same evening to list each template's fields as GitHub has them, the Backlog template's
(project 24) among them, and each team's and the account's projects by number (§ Four projects per team).

Ruled 2026-11-03: every project of a kind is configured the same way. Done in GitHub the same day, each change read
back: all twenty projects, NobleFactor's four templates, engprod's four projects, devlore's four, David-Noble-at-work's
four copies and its four projects, were compared field by field, option by option and view by view, and each now
matches its kind's template in fields, Status options, iteration settings, views, readme and built-in workflows. The one
difference left is that David-Noble-at-work's Triage and Backlog projects have no Area or Priority column, since those
are issue fields, and its labels stand in for them. To match, the Triage template's readme went onto the three Triage
projects; the Schedule and Scenario templates' Status descriptions went onto David-Noble-at-work's Schedule and
Scenario projects and copies, each option keeping its id; and the account's Backlog, Schedule and Scenario copies got
the description its Triage copy has. Every built-in workflow of the twenty was deleted, since GitHub's API can delete
one but has no call that makes one or turns one on; all were off but Triage: devlore's "Auto-add sub-issues to
project". That settles the question that was open on that workflow: under the ruling that every project of a kind is
configured the same way, it was deleted with the rest. Where section 3 said that a project's built-in workflows are
not part of the model and that the owner switches them by hand, it now says that none of the twenty has one. None of
the twenty links a repository (§ Four projects per team, § Triage and the Backlog).

Compared again on 2026-11-03, with the grouped views made that day (below), the twenty projects of the four kinds
still match their kind's template, as read from GitHub that day: in fields, options, iteration settings, views, readme
and built-in workflows, apart from the Area and Priority columns, which a user account can't have.

From 2026-11-03 both `.github` repositories take part in triage, so § Four projects per team lists NobleFactor/.github
with engprod's repositories and David-Noble-at-work/.github with personal ([section 4](4-storage-and-reach.md#triage)).

Done in GitHub on 2026-11-03. Every Schedule project got a second view, By schedule, and every Scenario project a
second view, By scenario, each its project's view 2, a table grouped by its Schedule or Scenario field with no sort,
the same in all ten (§ Four projects per team). Schedule: engprod's 88 rows were put in the order the rows of every
Schedule and Scenario project are kept in, and read back; Schedule: devlore, Scenario: engprod, Scenario: devlore and
Schedule: David-Noble-at-work were already in it (§ The Schedule and Scenario fields). The line in each of the 15
Schedule and Scenario issues that names its project was changed to link that project's view 2, filtered to the
issue's own option, and each body was read back (§ The collection's own record: a Schedule or Scenario issue).
Section 3 was revised the same day to state the three.

NobleFactor project 4, "Thread: the model follows a rename", made 2026-10-24 as the write test of
NobleFactor/noblefactor-engprod#377, which is closed, was still open on 2026-11-04, with six draft rows and six built-in
workflows, all turned on: the closing of the per-schedule and per-thread projects on 2026-11-03 missed it. Claude
Code's permission check refused the agent the write that closes it, and the owner closed it on 2026-11-04; GitHub's
answer to the write read it back closed.
NobleFactor's closed projects 9 to 22 keep five built-in workflows each, all off.

## Completion

- [ ] The plan's questions 5 to 10 ruled: the collection's own record, step numbers, status, a committed schedule, one
  issue in two collections, who joins which.
- [x] The prototype: a Schedule template in NobleFactor, project 7, and NobleFactor/noblefactor-engprod#301 as a project
  made from it, its lanes as rows, numbered by Step since 2026-11-02 -- 2026-11-01
- [x] Every open schedule and thread a project: schedules 9 to 17, threads 18 to 22 -- 2026-11-01
- [ ] Section 3 states the four projects of a team and of a user account, the four templates and the user account's
  copies, every project of a kind configured the same way, the Schedule, Scenario and Iteration fields, the order the
  rows of every Schedule and Scenario project are kept in and their grouped views, the triage decision, triage without
  an epic, schedules without a Next column, the collection's own issue typed Schedule or Scenario and its link to its
  own rows, the Area that tells engineering from product work and the three points that catch a blank one, the
  account's issue fields, and the old scheme's retirement.
