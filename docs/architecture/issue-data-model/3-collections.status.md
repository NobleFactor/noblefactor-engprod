---
title: "3. Collections — Status"
---

# 3. Collections — Status

**Document:** [3-collections.md](3-collections.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled in part, 2026-10-22 to 2026-11-04: the plan's questions on section 3 were all ruled by 2026-11-04, and
no ruling yet sets the Backlog's own fields (§ Four projects per team). Ruled 2026-10-22: the Triage project is the
third collection, one per team; row 0 is the collection's own issue, typed Epic. Questions 6 to 9 open for iteration 3.
Two test projects, made and deleted on 2026-10-20, showed that a NobleFactor project holds personal's issues as rows and
can be marked as a template. Built 2026-11-01: Triage: engprod and Triage: devlore, NobleFactor projects 5 and 6, each
its team's, its triage epic row 0; the Schedule and Thread templates, projects 7 and 8; and every open schedule and
thread a project, 9 to 22, its own issue row 0. Question 17 of the plan, added 2026-11-02, puts personal's rows in them
in question. Ruled 2026-11-02: organizations and individual accounts are separate, each with its own model (§ Accounts
in section 4); question 17 settled the same day, and the model read on demand from two reference models (§ Reference
models, read on demand, in section 6). Revised the same day: each participating account keeps its model in its own
`.github` repository (#431, David-Noble-at-work/personal#311), which section 6 states with #431. Ruled 2026-11-02: a
schedule's rows are numbered by Step, not Lane, and its own issue's row has none; Lane renamed Step in GitHub the same
day, on the template and the nine schedules (§ The Schedule and Scenario fields). Ruled 2026-11-11 on #439: closed steps
move with the open ones, so a step inserted, moved or taken off renumbers every later step, closed or open, in place of
the rule that a closed step keeps its number (§ The Schedule and Scenario fields; section 8, question 5). Built on
2026-11-12 (#427): the sweep's `no-step` rule returns a task or bug whose row on a Schedule project names a schedule and
has no step; a Schedule issue's own row is left alone. Built on 2026-11-13 (#448): NobleFactor's five participating
repositories run the Triage workflow, and in both accounts it gives an issue whose body says "Found while walking #N",
where #N is an open scenario of the account, its row on that scenario's Scenario project, under the scenario's option,
in place of a Triage row (§ The Schedule and Scenario fields).

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

Ruled 2026-11-04, and stated in section 3 the same day: how an issue moves between its team's projects, and who moves
it, which settles how a triage decision is carried out and how an issue is kept in one project at a time, and with it
the plan's questions 4 and 9. Any member of a team can see all of the team's issues and do all of its work in its four
projects, so membership in the team is the one grant a new participant needs; the team's roles carry the rest: the
maintain role on each repository it owns and the write role on each of its four projects. Adding a person to NobleFactor
needs a seat first, and its Team plan's one seat is filled. In a user account, a new participant is a collaborator on
each participating repository, personal and David-Noble-at-work/.github, and a writer on each of the account's four
projects. An issue is a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever
team owns them, and is on at most one schedule or scenario, and every move is one act: the issue gets its row in the
project it goes to, with that project's fields set, and loses its row in the project it leaves. From the Backlog, work
goes onto a schedule highest Priority first, and a committed schedule takes it only by its owner's amendment, recorded
in the Schedule issue, so § A committed schedule now states the plan's question 8 as ruled on 2026-11-02, with the
owner's amendment restated on 2026-11-04, not as proposed. The sweep (#436) will return to its team's Triage project an
issue in more than one of the account's projects, whichever team owns them, or on more than one schedule or scenario,
and, in place of the audit, an issue whose row has no step. Ruled the same day, on the plan's question 12: a scenario
changes no issue's priority; triage sets each issue's Priority.

Ruled later on 2026-11-04, and stated in section 3 the same day (§ The Schedule and Scenario fields, § Triage and the
Backlog, § Ownership). A scenario is a high-level description of a feature, a workflow or a real-life situation that
needs to be tested; its Scenario issue, its own row in the team's Scenario project, summarizes an end-user goal and
names the features it exercises. Its other rows are the tasks and bugs logged while walking it, each with its Beat, the
point in the walk where it turned up, until it moves to its team's Triage project or onto a schedule and leaves the
scenario. The Triage workflow will add an item that names its scenario in its body to that scenario (#448), and #453
will bring both accounts' Scenario forms to this, with the Scenario type's description and the scenario label's in
personal and David-Noble-at-work/.github, which still read "Collection: describes a scenario, the story its features
tell". Epics and features are never rows of a Backlog, Schedule or Scenario project, so one project at a time holds
across all of the account's projects, the Scenario projects included, and the ruling of 2026-11-03 that a scenario's
rows are features, question 10's answer for scenarios, is replaced. The sweep will leave a scenario's rows alone but for
two structural rules: it will return an epic or a feature that is a row of a Scenario project, as it will return one on
a Backlog or Schedule project, and an issue that is a row of a scenario and of another of the account's projects,
whichever team owns it. Every other rule will wait until an item logged while walking a scenario moves out. Every team
gets the write role on its four projects, in place of the Admin role ruled for each team's Triage project on 2026-10-22.
The write role lets a member edit a project, its fields and views included; what stays with an organization owner is a
project's settings and access, and keeping every project of a kind configured the same way rests on push (#437), not on
the role. GitHub enforces a form's required fields, the Area dropdown among them, only in a public repository, and
personal is the one private participating repository since the owner made devlore.noblefactor.com public that day, so
nothing checks the Area there at filing until `star github issue` does (#338). Every open issue will get an Area in
#452, before the sweep runs. The statement of 2026-11-03 that there are no compliance checks is superseded in part: the
sweep will check the rules every day, and will still block no filing and correct nothing by itself.

Ruled on the evening of 2026-11-04, and stated in section 3 the same day (§ The Schedule and Scenario fields, § Triage
and the Backlog, § The collection's own record: a Schedule or Scenario issue). A Scenario issue states no evidence of
completion: a scenario never ends, so its issue never closes, and #453 will put how to walk it, the example the Scenario
issue gives, in place of each Scenario form's Evidence of completion section. The 14 open tasks and bugs that are rows
of both their team's Schedule project and its Scenario project, and noblefactor-engprod#252, a row of Triage: engprod
and of Scenario: devlore, have each already moved on, so the script of #303's closing pull request removes those 15
Scenario rows, recording each on its Scenario issue. How the sweep (#436) will handle an issue in a scenario and in
another project, without taking a scheduled item off its schedule, is #436's to design. #453 will bring
David-Noble-at-work/.github's scenario label to the ruling with personal's, as its comment of 2026-11-04 records, and in
a user account a new participant is a collaborator on each participating repository, personal and
David-Noble-at-work/.github. Corrected the same day: Triage: engprod was made on 2026-10-26, not 2026-11-01; personal
has had `.github/workflows/triage.yml` since 2026-11-04, while NobleFactor's five participating repositories wait on
#448 for theirs; NobleFactor's Triage workflow will set the Area field once #447 and #448 land; and `star github issue`
is not built, so issues we file ourselves will go through it once it is (#338).

Ruled last of all on 2026-11-04, and stated in section 3 the same day (§ The Schedule and Scenario fields, § Triage and
the Backlog, § Ownership). One project at a time holds across the whole account, not only within a team's four projects:
an issue is a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns
them, and is on at most one schedule or scenario, and the sweep (#436) will check the rule across all of the account's
projects, with its two exceptions for a scenario's rows. An issue on another team's project is assigned to an
accountable member of that team, and the person whose name is on an issue moves it to another team in one act, between
its team's Triage project or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or
schedule to schedule; this supersedes in part the ruling of 2026-10-22 that work for another team gets a tracking issue.
Triage removes an issue's row from its Triage project as part of its decision, and an issue someone closes outside
triage stays there until triage decides its disposition. The sweep will remove no Triage row, as #436's comment of
2026-11-04 records, so the 78 closed issues among Triage: engprod's 178 rows are triage's to decide. Read again at
8:24 p.m. across all of NobleFactor's projects, whichever team owns them, no open issue was in two of them but those
named below, whose extra rows the script of #303's closing pull request removes, and 13 of the 16 open issues of
NobleFactor's repositories that are rows of another team's project had no assignee. Corrected the same day, in section 3
and in the check below: what the sweep (#436), the Triage workflow (#448), `git open-branch` (#449), the PR script
template (#450), #452 and #453 will do is stated as work still to come, not as done.

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
bodies, with 47 issues given the sub-issue parent their marker named and the link kept where the two disagreed; the step
and beat tables in 14 Schedule and Scenario issues replaced by a line naming the issue's project and its option there;
the kind labels epic, feature, task and bug removed from NobleFactor's 12 repositories, after 672 issues were given the
issue type their label named; the Product and Engineering options of NobleFactor's Area issue field made; devlore-cli's
seven finer Area labels deleted; and NobleFactor's Triage projects given the Area field, and each Triage project the
Missing Area view. David-Noble-at-work keeps its type labels, which are its types.

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

Read from GitHub on 2026-11-04, for that day's rulings: 30 open issues in NobleFactor's Triage projects were also rows
of a Schedule project, their own team's or another's, 28 of them rows of both their team's, 19 of engprod's, #303 among
them, and 9 of devlore's, and noblefactor-engprod#250 and David-Noble-at-work/personal#263 rows of Triage: engprod and
Schedule: devlore. Two more, David-Noble-at-work/personal#268 and #275, were rows of Triage: David-Noble-at-work and of
Schedule: devlore; those Schedule: devlore rows are crossings that #428 removes, and the two keep their Triage rows. No
open issue was in two of David-Noble-at-work's own projects. Five features were rows of a Schedule or Scenario project:
noblefactor-engprod#140 and #151 on Scenario: engprod, NobleFactor/devlore-cli#762 and #847 on Scenario: devlore, and
NobleFactor/devlore-cli#1023 on Schedule: devlore. 14 open tasks and bugs were rows of both their team's Schedule
project and its Scenario project, and noblefactor-engprod#252 of Triage: engprod and of Scenario: devlore. Backlog:
engprod, Backlog: devlore and the Backlog template each had one view, View 1, with no sort, and no view of a Triage or
Backlog project showed Area, Priority or Labels. The script of #303's closing pull request, which runs when the pull
request merges, deletes those 30 Triage rows; removes the five feature rows, first commenting on each scenario's
Scenario issue naming the features it exercised; removes the Scenario rows of those 15 tasks and bugs, which have each
already moved on, recording each on its Scenario issue; adds a view named By priority, sorted by Priority, to each of
the three Backlog projects; shows Area in every view of the Triage projects, Priority in the Backlog projects' views and
their By priority view, and Labels in David-Noble-at-work's Triage and Backlog views; and gives each team the write role
on its four projects, in place of the Admin role ruled for each team's Triage project on 2026-10-22 (§ Triage and the
Backlog, § Ownership). Every workflow was checked against GitHub that afternoon (§ Every workflow, checked on
2026-11-04, below).

Revised 2026-11-05 for #446: the opening's paragraph on Area points to
[issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering), which says what
product work and engineering work each cover, tests among engineering's, and what each may hold, in place of the list
of what engineering covers, and the sentence that the epics for product readiness and release management hold both
kinds is gone, superseded on 2026-11-05.

## Every workflow, checked on 2026-11-04

Read from GitHub on 2026-11-04, the five workflows, filing, triage, the backlog, scheduling and scenarios, have in
GitHub what they need, apart from what the script of #303's closing pull request makes when the pull request merges and
what work filed for later makes, each row naming which, and two things that no script step or issue makes yet: a Beat
for 16 of the 20 rows of the two teams' Scenario projects that have none, and an assignee from engprod for the 12 open
devlore-cli issues that are rows of engprod's Schedule or Scenario project and have none (read at 8:24 p.m.). Of the
open tasks and bugs, 15 are rows of a Scenario project and also on a schedule or in a Triage project. The ruling of
2026-11-04 has an item leave its scenario when it moves, and each of the 15 has already moved on, so the script removes
those 15 Scenario rows, recording each on its Scenario issue; 4 of them are among the 20 rows with no Beat (read again
at 6:10 p.m.). How the sweep (#436) will handle an issue in a scenario and in another project, without taking a
scheduled item off its schedule, is #436's to design. The script also shows the fields that no Triage or Backlog view
shows today, removes the five features that are rows of a Schedule or Scenario project, and deletes the Triage rows of
the 30 open issues in NobleFactor's Triage projects that are also on a schedule. In NobleFactor, what to grant someone
new is membership in the team, and so in the organization, which takes a seat of its own; in a user account, it is a
collaborator's role on each participating repository, personal and David-Noble-at-work/.github, and a writer's role on
each of the account's four projects ([issue-standards.md § Who can do what](../../issue-standards.md#who-can-do-what)).

The owner asked for this check on 2026-11-04, so that #303 closes knowing that every workflow is supported and what to
grant should someone else take part in triage and scheduling. Each row was read that afternoon, from 1:35 to 1:55 p.m.
Pacific, read-only, through GitHub's REST and GraphQL APIs, signed in as David-Noble-at-work, an owner of NobleFactor,
and each says what was read; a row read again later that afternoon says when. NobleFactor's projects are Triage: engprod
and Triage: devlore (NobleFactor projects 5 and 6), Backlog: engprod and Backlog: devlore (25 and 28), Schedule: engprod
and Schedule: devlore (26 and 29), and Scenario: engprod and Scenario: devlore (27 and 30), with the Triage, Backlog,
Schedule and Scenario templates (23, 24, 7 and 8). David-Noble-at-work's are Triage: David-Noble-at-work, Backlog:
David-Noble-at-work, Schedule: David-Noble-at-work and Scenario: David-Noble-at-work (its projects 3, 6, 7 and 8), with
its copies of the four templates (its projects 4, 5, 1 and 2). The participating repositories are engprod's
noblefactor-engprod and .github and devlore's devlore-cli, devlore-registry and devlore.noblefactor.com in NobleFactor,
and personal and .github in David-Noble-at-work, the two with the topic issue-model.

| Workflow | What it needs in GitHub | NobleFactor | David-Noble-at-work | What makes it, if missing |
| --- | --- | --- | --- | --- |
| Triage, the backlog, scheduling and scenarios | Every project of a kind configured the same way, with no built-in workflow (ruled 2026-11-03) | The twelve projects' fields and views match their kind's template, as the rows below say. None has a built-in workflow or links a repository, and each has a readme. | The eight projects match their kind's copy, and the copies match NobleFactor's templates, but for the Area and Priority fields, which a user account can't have. None has a built-in workflow or links a repository, and each has a readme. | — |
| Filing | Six issue forms, one for each type, in the account's `.github` repository, which GitHub offers to each of the account's repositories that has no issue templates of its own | NobleFactor/.github holds `bug.yml`, `epic.yml`, `feature.yml`, `scenario.yml`, `schedule.yml` and `task.yml` in `.github/ISSUE_TEMPLATE`, each setting its issue type. None of the other four participating repositories has an `ISSUE_TEMPLATE` folder of its own. NobleFactor/.github is public, which GitHub requires for its defaults to reach the account's repositories, private ones included (GitHub's documentation on default community health files, read 2026-11-04). | David-Noble-at-work/.github holds the same six, each setting its type label instead of a type, and it is public. personal, which is private, has no `ISSUE_TEMPLATE` folder of its own. | — |
| Filing | A required Area dropdown on every form, Product or Engineering (ruled 2026-11-03), which GitHub enforces only in a public repository (GitHub's form schema documentation, read 2026-11-04) | All six forms have it, required, with the options Product and Engineering. The five participating repositories are public: devlore.noblefactor.com, private when this check was read, was public when read again at 3:45 p.m. | All six forms have it, the same. David-Noble-at-work/.github is public, but personal is private, so there the form doesn't stop an issue filed without an Area. | In personal, nothing checks the Area at filing until `star github issue` does (#338). Afterward, the sweep (#436) will return an issue with no Area to its team's Triage project. |
| Filing | A required Evidence of completion section on every form but the Scenario form (ruled 2026-11-04), which GitHub enforces only in a public repository; a Scenario issue states no evidence of completion, since a scenario never ends | All six forms have it, required, asking what a comment on the issue will show before it closes. | All six forms have it, the same, and in personal, which is private, the form doesn't stop an issue filed without it. | `star github issue`, the command that will file issues of any type, will refuse an issue other than a Scenario issue without it at filing (#338), the only check in personal. Afterward, the sweep (#436) will return an issue other than a Scenario issue with no Evidence of completion section to its team's Triage project. #453 will put how to walk it, the example the Scenario issue gives, in place of each Scenario form's Evidence of completion section. |
| Filing | Severity set when an issue is opened from a form: N/A on every type but Bug, and Medium on a bug from the bug form, which asks no severity (ruled 2026-11-04) | The bug form asks no severity. Since 2026-11-12 (#448, NobleFactor/.github#10), NobleFactor/.github's Triage workflow template sets the Severity issue field when an issue is opened, Medium on an issue of type Bug, N/A on an issue of another type, and none on an issue with no type yet, which waits for triage; an issue that has one keeps it. An issue typed only after it is opened gets no Severity from the workflow, and triage gives it one. | Since 2026-11-09 (#441, David-Noble-at-work/.github#1): David-Noble-at-work/.github's Triage workflow template sets it, `severity:medium` on an issue with the bug label, `severity:n/a` on one with another type label, and none on one with no type label, which waits for triage, and an issue that has one keeps it; personal's `triage.yml` (David-Noble-at-work/personal#323) and David-Noble-at-work/.github's own are the template. Its test issue, David-Noble-at-work/.github#2, took `severity:n/a`. The bug form asks no severity. | `star github issue` will set N/A at filing (#338). |
| Filing | The Triage workflow template, `workflow-templates/triage.yml` with `triage.properties.json`, in the account's `.github` repository | NobleFactor/.github has it. It adds an issue, when it is opened or transferred, to the project that `TRIAGE_PROJECT_URL` names, with a token from the noblefactor-automation app, and copies the form's Area into the Area field. Its Area reader looped without end when the Area heading was followed only by blank lines, until #447's fix merged on 2026-11-10 (NobleFactor/.github#5), which also stops a run after 5 minutes and makes the template name its account nowhere. Since 2026-11-12 (#448, NobleFactor/.github#10), it gives an issue found while walking an open scenario of the account its row on that scenario's Scenario project instead, and sets the Severity issue field. | David-Noble-at-work/.github has it. It adds the issue with the token in the secret `ADD_TO_PROJECT_PAT`, copies the form's Area into an `area:` label, and, since 2026-11-09 (#441), sets the Severity a new issue starts with. Since 2026-11-13 (#448), it gives an issue found while walking an open scenario of the account its row on that scenario's Scenario project instead. | — |
| Filing | `.github/workflows/triage.yml` in each participating repository | All five have it, landed from NobleFactor/.github's template by `star github model apply` (#437), and the first run, in noblefactor-engprod on 2026-11-11, set the Area field and proved the noblefactor-automation app's permissions for projects and issue fields. The template carries #448's steps since 2026-11-12 (NobleFactor/.github#10). | personal has it, the template again since David-Noble-at-work/personal#323 on 2026-11-09 and, with #448's steps, since David-Noble-at-work/personal#325 on 2026-11-13; its run on the test issue of David-Noble-at-work/personal#315, at 8:29 a.m. Pacific on 2026-11-04, succeeded. David-Noble-at-work/.github has it since 2026-11-09 (#441), the template again with #448's steps since David-Noble-at-work/.github#8 on 2026-11-13, and an `ADD_TO_PROJECT_PAT` of its own, stored through Key Vault `kv-david-noble-at-work`; its run on its test issue, David-Noble-at-work/.github#2, succeeded. | Made by the Triage workflow in NobleFactor's five participating repositories (#448), step 36 of issue tracking, iteration 1 (#346), which waited on the fix to the Area reader, #447, merged on 2026-11-10. Since #437, `star github model apply` lands each missing one through a pull request, from the account's template; read with `diff` on 2026-11-10, these five were NobleFactor's only differences from its own model. |
| Filing | `TRIAGE_PROJECT_URL` in each participating repository, naming its team's Triage project | It is set in all five: noblefactor-engprod's and .github's to project 5, and devlore-cli's, devlore-registry's and devlore.noblefactor.com's to project 6. | It is set in personal and David-Noble-at-work/.github, each to the account's project 3. | — |
| Filing | The credentials the Triage workflow signs in with | The organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY` are visible to every repository and were last changed on 2026-02-03. The noblefactor-automation app is installed on every repository, with write access to issues and organization projects and read access to issue fields. | personal and David-Noble-at-work/.github each have the repository secret `ADD_TO_PROJECT_PAT`. | The first run of the Triage workflow in a NobleFactor repository, on 2026-11-11, proved the app's permissions for projects and issue fields (#448). The list of the credentials and permissions issue tracking runs on (#451) will say when and how each is renewed. |
| Filing | Issues open to those who file them | noblefactor-engprod, .github, devlore-cli and devlore-registry are public, with issues on and no interaction limits, and the organization sets none. devlore.noblefactor.com was private, open to those with access to it; read again at 3:45 p.m., it is public, with issues on and no interaction limits. | David-Noble-at-work/.github is public, with issues on and no interaction limits. personal is private, and its one collaborator is the account itself. | — |
| Triage | Each team's Triage project, made from the Triage template and linked to its team | Triage: engprod (5) is linked to engprod and has 178 rows, Triage: devlore (6) is linked to devlore and has 28, and the Triage template is project 23. Of Triage: engprod's rows, 78 are closed issues, and 38 are personal's, 15 of them open. | Triage: David-Noble-at-work (3) has 9 rows, all of them personal's and one of them closed, and its copy of the template is its project 4. | Triage removes an issue's Triage row as part of its decision, and an issue someone closes outside triage stays in its Triage project until triage decides its disposition, so the 78 closed issues are triage's to decide (ruled 2026-11-04). The sweep (#436) will remove no Triage row: #436's Done-when no longer has star remove an issue once it is classified or closed, as its comment of 2026-11-04 records. Removing the crossings (#428) will take personal's rows out of NobleFactor's projects. |
| Triage | The Triage project's Status field and Area column, and a view named Missing Area | 5, 6 and 23 each have Status, with Open, In progress and Closed, the Area issue field, and two views, View 1 and Missing Area, filtered `no:area`. Read through GitHub's GraphQL API, neither view lists Area among its visible fields: each shows Title, Assignees, Status, Linked pull requests and Sub-issues progress. | 3 and 4 each have Status and the same two views, with Missing Area filtered `-label:area:product -label:area:engineering`. Neither view lists the Labels column, which holds the `area:` labels, among its visible fields. | Made by the script of #303's closing pull request, which shows Area in every view of the Triage projects and Labels in David-Noble-at-work's Triage views. GitHub's GraphQL call `updateProjectV2View` sets a view's visible fields. |
| Triage | Area on every issue: the Area issue field, Product or Engineering, or in a user account the labels `area:product` and `area:engineering` (ruled 2026-11-03) | The Area field has its two options, Engineering and Product. 9 of the 528 open issues in the five participating repositories have an Area, all of them in noblefactor-engprod. | Both labels are in personal and David-Noble-at-work/.github. 5 of personal's 42 open issues carry one. | Giving every open issue an Area (#452), which the sweep (#436) waits on. Afterward, the sweep will return an open issue without an Area to its team's Triage project, and `star github issue` will refuse to file one (#338). |
| Triage | The six types, which triage gives an issue that has none: Epic, Feature, Task, Bug, Schedule and Scenario | NobleFactor has the six issue types, each enabled, with the hierarchy's four described as levels 0 to 2 and the two collections described as collections, and no Chore. One open issue in a participating repository has no type, noblefactor-engprod#422, and it is a row of no project. | The six type labels are in personal and David-Noble-at-work/.github. 3 of personal's open issues have none, David-Noble-at-work/personal#147, #151 and #251: #147 and #151 are rows of no project, and #251 is step 16 of lint tooling on Schedule: engprod, a crossing that removing the crossings (#428) will take out. | The sweep (#436) will add an issue that isn't fully classified to its team's Triage project. |
| Triage | Resolution Declined, for declined work closed as completed | The Resolution issue field has Declined, Duplicate and Invalid. | `resolution:declined`, `resolution:duplicate` and `resolution:invalid` are in both repositories. | — |
| Triage | Severity: Critical, High, Medium or Low on a bug, and N/A on every other type (ruled 2026-11-04) | The Severity issue field has Critical, High, Medium and Low, and no N/A. | `severity:critical`, `severity:high`, `severity:medium` and `severity:low` are in both repositories, and `severity:n/a` is in neither. | Made by the script of #303's closing pull request, which adds N/A, gray and described "Not applicable: the issue is not a bug", to the field through GitHub's REST call, `PATCH /orgs/NobleFactor/issue-fields/49439297`, sending each existing option with its ID, and makes `severity:n/a`, colored `cfd3d7` and described "Severity: not applicable, the issue is not a bug", in personal and David-Noble-at-work/.github. |
| Triage | Severity N/A on every open issue of a type other than Bug | 414 open issues in the five participating repositories have a type other than Bug, and so do 4 more in NobleFactor/noblefactor, which takes no part. 7 of the 414 carry a severity: 5 tasks and 2 features in devlore-cli. | 33 of personal's open issues have a type label other than bug, and none of them carries a `severity:` label. | Made by the script of #303's closing pull request, which sets N/A on every open issue of a type other than Bug. An issue with no type gets none and waits for triage; when triage gives it a type other than Bug, triage sets its Severity to N/A, and the sweep (#436) will catch a miss (ruled 2026-11-04). |
| Triage | A severity on every open bug | 77 of the 113 open bugs have no Severity: 58 in devlore-cli, 16 in noblefactor-engprod, 2 in devlore-registry and 1 in devlore.noblefactor.com. | None of personal's 6 open bugs has a `severity:` label: David-Noble-at-work/personal#152, #157, #268, #304, #305 and #307. | Triage's work. The sweep (#436) will return a bug whose Severity is N/A or blank. |
| Triage and the backlog | Priority, which triage sets: the Priority issue field, or in a user account the `priority:` labels | The Priority field has Urgent, High, Medium and Low, in that order. 41 of the 528 open issues in the participating repositories have one, 40 of them in devlore-cli. | `priority:urgent`, `priority:high`, `priority:medium` and `priority:low` are in both repositories. None of personal's 42 open issues carries one. | Triage's work. |
| Triage | The account's other attribute fields | The other fields are Effort, with High, Medium and Low, Target date, and Start date, which stays unused. | `effort:high`, `effort:medium` and `effort:low` are in both repositories, since a label stands in only for a single-select field. | — |
| Triage | `good first issue`, on tasks and bugs only (ruled 2026-11-04) | It is in all five participating repositories, colored `7057ff` and described as good for newcomers. No open issue carries it. | It is in David-Noble-at-work/.github, the same, and not in personal. No open issue carries it. | Made by the script of #303's closing pull request, which makes it in personal with David-Noble-at-work/.github's color and description. The sweep (#436) will return an issue that carries it and isn't a task or a bug. |
| Triage | One project at a time, across the account: an issue is a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most one schedule or scenario (ruled 2026-11-04) | 30 open issues in NobleFactor's Triage projects are also rows of a Schedule project, their own team's or another's: 28 of them rows of both their team's, 19 of engprod's, #303 among them, and 9 of devlore's, and noblefactor-engprod#250 and David-Noble-at-work/personal#263 rows of Triage: engprod and Schedule: devlore. 14 open tasks and bugs are rows of both their team's Schedule project and its Scenario project: 4 of engprod's, noblefactor-engprod#144, #145, #190 and #231, and 10 of devlore's, NobleFactor/devlore-cli#780, #812, #819, #831, #840, #842, #852, #853, #881 and #1152; #144, #145, #190 and devlore-cli#1152 are among the 30 too. noblefactor-engprod#252, a task, is a row of Triage: engprod and of Scenario: devlore, and the features noblefactor-engprod#140 and #151 are rows of Triage: engprod and Scenario: engprod. No open issue is on two schedules, or in a Backlog and another project, and, read again at 8:24 p.m. across all of NobleFactor's projects, whichever team owns them, no other open issue is in two of them. | No open issue is in two of the account's projects. Five of personal's open issues that are rows of Triage: David-Noble-at-work are also rows of NobleFactor's projects: David-Noble-at-work/personal#229, #234 and #254 of Triage: engprod, and #268 and #275 of Schedule: devlore. | Made by the script of #303's closing pull request, which deletes the 30 Triage rows and removes the Scenario rows of the features #140 and #151 with the other feature rows (below); David-Noble-at-work/personal#268 and #275 keep their Triage rows. Removing the crossings (#428) will take personal's rows out of NobleFactor's projects, #268's and #275's Schedule: devlore rows among them. The script also removes the Scenario rows of the 14 tasks and bugs and of noblefactor-engprod#252, the 15 items that have already moved on, recording each on its Scenario issue (ruled 2026-11-04). Afterward, the sweep (#436) will return an issue that breaks the rule, across all of the account's projects; how it will handle an issue in a scenario and in another project, without taking a scheduled item off its schedule, is #436's to design. |
| Triage and scheduling | An issue on another team's project assigned to an accountable member of that team, who moves it to another team in one act like any move, between its team's Triage project or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or schedule to schedule (ruled 2026-11-04) | GitHub allows up to 10 assignees on an issue, organization members who can read the repository among them (GitHub's documentation on assigning issues, read 2026-11-04), and the five participating repositories are public. Read at 8:24 p.m., 16 open issues of the five are rows of another team's project: NobleFactor/devlore-cli#721, #838, #886, #932, #938, #964, #990, #994, #997, #998, #999 and #1000 on Schedule: engprod and #802 and #1033 on Scenario: engprod, and noblefactor-engprod#250 on Schedule: devlore and #252 on Scenario: devlore. David-Noble-at-work, a member of both teams, is assigned to NobleFactor/devlore-cli#721 and #838 and to noblefactor-engprod#250, and the other 13 have no assignee. | A user account has no teams. | The script of #303's closing pull request removes #252's Scenario: devlore row, one of the 15 Scenario rows of items that have moved on (above). No script step or issue assigns the other 12 yet. |
| Triage | The sweep's daily workflow in each account's `.github` repository, with the credentials the Triage workflow uses (ruled 2026-11-04) | NobleFactor/.github runs CI, from `quality-gate.yml`, and, since 2026-11-11, the Triage workflow (#437). | David-Noble-at-work/.github runs the Triage workflow, since 2026-11-09 (#441). | The sweep (#436) will make it in both. |
| Triage, the backlog, scheduling and scenarios | Membership in the team, the one grant a new participant needs (ruled 2026-11-04) | engprod, devlore and Owners each have one member, David-Noble-at-work, and no invitation pending. NobleFactor's plan is GitHub Team, with one seat, filled, and GitHub bills each member a seat (GitHub's documentation on per-user pricing, read 2026-11-04). The organization requires two-factor authentication, and its seven issue fields are visible to its members only. | A user account has no teams. | Nothing is missing for today's one participant. A second member takes a second seat. |
| Triage, the backlog, scheduling and scenarios | The team's maintain role on each repository it owns, or in a user account a collaborator's role on each participating repository | engprod has the maintain role on noblefactor-engprod and .github. devlore has it on devlore-cli, devlore-registry and devlore.noblefactor.com, and the write role on noblefactor-engprod. A member's base role on the organization's repositories is none, so a member's role on them comes from the team; the public ones anyone can read and file issues in. Setting a parent across two teams' repositories needs the triage role on both: devlore's write role on noblefactor-engprod lets a devlore member link a devlore issue to a noblefactor-engprod parent and back, and engprod holds no role on devlore's repositories, so an engprod member can't. An organization owner holds the admin role on each of the organization's repositories, and so can set a parent between any two. | personal and David-Noble-at-work/.github each have one collaborator, the account itself, as admin, and no invitation pending. | — |
| Triage, the backlog, scheduling and scenarios | The team's write role on each of its four projects, or in a user account a writer's role on each of the account's four | GitHub links engprod to projects 5, 25, 26 and 27 and devlore to 6, 28, 29 and 30, and lists each team's access to them, but returns no team's role on a project. GraphQL has no field that reads a project's collaborators; only the answer to `updateProjectV2Collaborators` names those it granted, without their roles. The `minPermissionLevel` filter on a team's projects, which GitHub describes as filtering on the user's role, returns the same list at Read, Write and Admin. GitHub's REST documentation for projects, read 2026-11-04, has no call for collaborators: its Projects page lists four GET calls, and its Views page a POST call that makes a view. | The account's projects have no teams, and their collaborators can't be read either. | Made by the script of #303's closing pull request, which gives each team the write role on its four projects, in place of the Admin role ruled for each team's Triage project on 2026-10-22, and checks that each call succeeded. The list of credentials and permissions (#451) will name each team's roles. |
| The backlog | Each team's Backlog project, made from the Backlog template and linked to its team | Backlog: engprod (25) is linked to engprod and holds one row, the list of credentials and permissions (#451), with Priority Low. Backlog: devlore (28) is linked to devlore and holds none, and the Backlog template is project 24. | Backlog: David-Noble-at-work (6) holds no rows, and its copy of the template is its project 5. | — |
| The backlog | A view named By priority, sorted by Priority (ruled 2026-11-04) | 24, 25 and 28 each have one view, View 1, a table with no sort and no grouping. Each has the Priority issue field, which, read through GitHub's GraphQL API, View 1 doesn't list among its visible fields. | 5 and 6 each have one view, View 1, with no sort, and no Priority field to sort by: a user account has no issue fields, and the `priority:` labels stand in. Neither view lists the Labels column among its visible fields. | Made by the script of #303's closing pull request, which makes By priority in 25, 28 and 24 with GitHub's REST call, the one call that sets a view's sort, and shows Priority in it and in View 1. The call also takes the view's visible fields, and without them shows GitHub's defaults. David-Noble-at-work's Backlog gets no such view (ruled 2026-11-04), and the script shows the Labels column in its views. |
| Scheduling | Each team's Schedule project, made from the Schedule template and linked to its team, with one Schedule option per schedule | Schedule: engprod (26) is linked to engprod and has 94 rows and the options of its 4 schedules; Schedule: devlore (29) is linked to devlore and has 145 rows and the options of its 5; and the Schedule template (7) has the placeholder option. 11 rows of each Schedule project are personal's. | Schedule: David-Noble-at-work (7) has 2 rows and one option, issue tracking, iteration 1, and its copy of the template (1) has the placeholder. | Removing the crossings (#428) will take personal's rows out of NobleFactor's projects, and personal's own records (David-Noble-at-work/personal#309) will put its steps on its own schedules. |
| Scheduling | The fields Schedule, Step, Status, Iteration and Worktree, and each row's values | All five are in 7, 26 and 29, Status with Open, In progress and Closed, and Iteration with two-week sprints from 2026-11-02. Every row of 26 and 29 has its Schedule option and its Status, and every row but the Schedule issues' own has its Step. No row has an Iteration. | All five are in 1 and 7, and Schedule: David-Noble-at-work's 2 rows have the same. | — |
| Scheduling | The view By schedule, grouped by the Schedule field | It is view 2 of 7, 26 and 29, with no sort, beside the first view, Default. | It is view 2 of 1 and 7, the same. | — |
| Scheduling | The Schedule issue type and its form | The type Schedule is described as a collection, and `schedule.yml` asks for the deliverable and the exit criteria. | The label schedule is in both repositories, and the same form in David-Noble-at-work/.github. | — |
| Scheduling | Blocked-by links between a step and what it waits on | 21 of Schedule: engprod's 94 rows and 61 of Schedule: devlore's 145 carry a blocked-by link, 16 and 29 of them to an issue still open. Read again at 3:44 p.m., after #436 was made to wait on #452, Schedule: engprod had 96 rows, #452 and #453 among them, which carry none, and 22 carry one, 17 to an issue still open. | Neither of Schedule: David-Noble-at-work's 2 rows carries one. 2 of personal's open issues carry such links, each to a devlore-cli issue. | Removing the crossings (#428) will take out the links that cross accounts. |
| Scheduling | A step's Worktree link, which its worktree's first script makes once the branch is pushed ([rule 19 of agent-rules.md](../../guides/agent-rules.md#19-a-session-keeps-its-steps-current-as-it-goes)) | Every step worked since #427 links its branch while it is open and its pull request once merged, made by each worktree's scripts. | No row has one. | Made by the PR script template's first-script step, in both forms, since 2026-11-13 (#450). |
| Scheduling | The step's issue type, from which `git open-branch` takes its branch type (approved 2026-11-04) | Every NobleFactor issue on 26 and 29 has its type. | Schedule: David-Noble-at-work's rows carry their type labels. | `git open-branch` will take the branch type from the issue's type, or its type label in a user account, and stop offering `chore` (#449). |
| Scheduling and scenarios | A schedule's rows are tasks and bugs, and so are a scenario's, beside their Schedule and Scenario issues, and no epic or feature is a row of a Backlog, Schedule or Scenario project (ruled 2026-11-03 and 2026-11-04) | Five features are rows: NobleFactor/devlore-cli#1023, step 38 on Schedule: devlore; noblefactor-engprod#140 and #151 on Scenario: engprod; and NobleFactor/devlore-cli#762 and #847 on Scenario: devlore. Besides their Scenario issues, Scenario: engprod's 18 rows are 2 features, 15 tasks and 1 bug, and Scenario: devlore's 32 are 2 features, 13 tasks and 17 bugs; 10 of each project's rows, all tasks and bugs, have no Beat. | Schedule: David-Noble-at-work's one step is a task, and Scenario: David-Noble-at-work has no rows. | Made by the script of #303's closing pull request, which removes the five feature rows, first commenting on each scenario's Scenario issue naming the features it exercised. Afterward, the sweep (#436) will return an epic or a feature that is a row of a Backlog, Schedule or Scenario project. With the Scenario rows of the 15 items that have moved on, the script removes 4 of the 20 rows with no Beat: noblefactor-engprod#190 and #231 on Scenario: engprod, and NobleFactor/devlore-cli#1152 and noblefactor-engprod#252 on Scenario: devlore (read again at 6:10 p.m.). No script step or issue gives the other 16 theirs yet. |
| Scenarios | Each team's Scenario project, made from the Scenario template and linked to its team, with one Scenario option per scenario | Scenario: engprod (27) is linked to engprod and has 19 rows and the option of its 1 scenario; Scenario: devlore (30) is linked to devlore and has 36 rows and the options of its 4; and the Scenario template (8) has the placeholder option. | Scenario: David-Noble-at-work (8) has no rows and the placeholder option, and its copy of the template (2) has the same. | — |
| Scenarios | The fields Scenario, Beat and Status, a row's Beat being the point in the scenario's walk where it turned up (ruled 2026-11-04) | All three are in 8, 27 and 30, and every row of 27 and 30 has its Scenario option and its Status. | All three are in 2 and 8. | — |
| Scenarios | The view By scenario, grouped by the Scenario field | It is view 2 of 8, 27 and 30, with no sort, beside the first view, View 1. | It is view 2 of 2 and 8, the same. | — |
| Scenarios | The Scenario issue type and its form | The type Scenario is described "Collection: describes a scenario, the story its features tell", the scenario as it was before the ruling of 2026-11-04 (read again at 4:55 p.m.), and `scenario.yml` asks for the story. | The label scenario is in both repositories, described the same way when read again at 4:55 p.m., and the same form is in David-Noble-at-work/.github. | #453 will bring both accounts' Scenario forms to the ruling of 2026-11-04, asking for the end-user goal, the example for demos and ad-hoc testing, and the features the scenario exercises, and will bring the Scenario type's description, and the scenario label's in personal and David-Noble-at-work/.github, to the ruling with them, keeping the "Collection:" prefix, as its comments of 2026-11-04 record. With #453, each form will put how to walk it, the example the Scenario issue gives, in place of its Evidence of completion section, since a Scenario issue states no evidence of completion. |
| Scenarios | An item found while walking a scenario, which names it in its body as "Found while walking #N", added by the Triage workflow to the team's Scenario project under the scenario's option instead of to its Triage project (ruled 2026-11-04) | All five participating repositories run the Triage workflow. Since 2026-11-12 (NobleFactor/.github#10), NobleFactor/.github's template gives an issue whose body says "Found while walking #N", or "Found while walking owner/repository#N", its row on that scenario's Scenario project under the scenario's option, and no Triage row, when #N is an open scenario of the same account: an issue whose own row on a project titled "Scenario: …" has a Scenario option. Any other issue goes to the project that `TRIAGE_PROJECT_URL` names, and the run's log says why. The walker still sets the Beat by hand. | personal's `triage.yml` and David-Noble-at-work/.github's own, the same file as David-Noble-at-work/.github's template since 2026-11-13 (David-Noble-at-work/.github#7 and #8, David-Noble-at-work/personal#325), do the same in Scenario: David-Noble-at-work, and add every other new issue to Triage: David-Noble-at-work. | Made by the Triage workflow (#448), proved on GitHub on 2026-11-13 by eleven test issues, each closed afterwards as invalid. |

## Completion

- [x] The plan's questions 5 to 10 ruled: the collection's own record, step numbers, status, a committed schedule, one
  issue in two collections, who joins which -- 2026-11-04: question 9 ruled that day, with how an issue moves between
  projects, its own team's and another team's, and question 10's answer for scenarios revised, their rows being the
  tasks and bugs found while walking them; questions 5 to 8 and 10 ruled from 2026-10-22 to 2026-11-03
- [x] The prototype: a Schedule template in NobleFactor, project 7, and NobleFactor/noblefactor-engprod#301 as a project
  made from it, its lanes as rows, numbered by Step since 2026-11-02 -- 2026-11-01
- [x] Every open schedule and thread a project: schedules 9 to 17, threads 18 to 22 -- 2026-11-01
- [x] Section 3 states the four projects of a team and of a user account, the four templates and the user account's
  copies, every project of a kind configured the same way, the Schedule, Scenario and Iteration fields, the order the
  rows of every Schedule and Scenario project are kept in and their grouped views, the triage decision, triage without
  an epic, schedules without a Next column, the collection's own issue typed Schedule or Scenario and its link to its
  own rows, the Area that tells engineering from product work and the three points that catch a blank one, the account's
  issue fields, and the old scheme's retirement -- 2026-11-04: the triage decision and what a scenario is, with its
  Scenario field and Beat, stated in full, and how an issue moves between projects, its own team's and another team's,
  and who moves it
