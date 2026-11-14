---
title: "Issue data model — one hierarchy, its attributes, and the collections that order it"
---

# Issue data model — one hierarchy, its attributes, and the collections that order it

> **Status:** ruled in part, 2026-10-22 to 2026-11-04; the questions #303 had left open were ruled on 2026-11-04, and
> what is still to be decided, apart from the Backlog's fields, is named with the issue that decides it. The work:
> [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303), a task under
> issue standards, [NobleFactor/noblefactor-engprod#156](https://github.com/NobleFactor/noblefactor-engprod/issues/156);
> it was a chore until the open chores were typed Task on 2026-11-02. #303 keeps only the design. Its build and rollout
> work moved to issues of their own: #365, #425 to #428, #436 to #441, #447 to #453 and
> David-Noble-at-work/personal#309. Ruled 2026-11-02: a working issue tracking system on GitHub comes first, and the
> tooling follows. The [plan](../../plans/chore/303-issue-data-model.md) holds the owner's words, each quoted with its
> date, and the questions, with their rulings.
>
> Ruled on the evening of 2026-11-03, and recorded below: Severity is an issue field of NobleFactor; a user account has
> the same data model as an organization, apart from what GitHub offers organizations only; and David-Noble-at-work has
> schedules of its own, which personal's steps go on. The design worktree's script ran the same evening, and each of its
> four steps read back: ruleset 12515090 no longer allows `chore/` branches, `doc/303-model-cutover` is on GitHub and
> linked from #303's row on Schedule: engprod, NobleFactor has its Severity field, and devlore-cli's `Severity:` and
> `Priority:` labels became field values and were deleted. Read from GitHub that evening, the noblefactor-automation
> app's installation on NobleFactor has organization projects read and write, issue fields read, and issues read and
> write; nothing had used them yet, and the Triage workflow's first run in a NobleFactor repository, on 2026-11-11,
> proved the app's permissions for projects and issue fields ([section 4](4-storage-and-reach.md) § Triage). GitHub
> makes no single-select project field without an option, so
> placeholder issues gave the new Scenario fields, and the Schedule fields of the Schedule template and its copy, their
> first option: the scenarios NobleFactor/noblefactor-engprod#442 and David-Noble-at-work/personal#316, and the
> schedules #443 and personal#319. So every Schedule and Scenario project and template in both accounts has its field
> now ([section 3](3-collections.md) § The Schedule and Scenario fields).
>
> Ruled 2026-11-03, and recorded below: every project of a kind is configured the same way. That day all twenty
> projects were compared field by field, option by option and view by view: NobleFactor's four templates, engprod's
> four projects, devlore's four, and David-Noble-at-work's four copies and four projects. Each now matches its kind's
> template. The one difference left is that David-Noble-at-work's Triage and Backlog projects have no Area or Priority
> column: those are issue fields, which a user account can't have, and its labels stand in for them. None of the twenty
> has a built-in workflow now ([section 3](3-collections.md) § Four projects per team).
>
> On 2026-11-03 every Schedule and Scenario project, template and copy, ten in all, got a second view, By schedule or
> By scenario, grouped by its Schedule or Scenario field and with no sort, so it shows the rows in the order they are
> kept: under each option, the collection's own issue first, then its rows by Step or Beat
> ([section 3](3-collections.md) § Four projects per team and § The Schedule and Scenario fields). Each of the 15
> Schedule and Scenario issues now links that view, filtered to its own option, from the line that names its project
> ([section 3](3-collections.md) § The collection's own record: a Schedule or Scenario issue).
>
> Read 2026-11-03, GitHub and our scripts still lag the design. Neither `.github` repository has a pull request
> template. Both take part in triage from that day, so seven repositories have `TRIAGE_PROJECT_URL` set, and none of the
> seven has the Triage workflow yet ([section 4](4-storage-and-reach.md) § Triage). Read 2026-11-04, personal runs it:
> its first run succeeded at 8:29 a.m. Pacific that day, and David-Noble-at-work/personal#315, which brought it there,
> closed at 8:30. NobleFactor's five participating repositories have run it since 2026-11-11 (#437), after #447, and
> David-Noble-at-work/.github since 2026-11-09 (#441). `git open-branch` still accepts `chore`, in the
> script, its man page and its completions; #449 will take it out and take the branch type from the issue's type, or its
> type label in a user account (approved 2026-11-04). The PR script template still records lanes in schedule tables that
> were retired on 2026-11-03, and has nothing yet for what a worktree's first script records; #450 will bring its rule
> 13 and its schedule step to the Schedule project, where a pull request's script will record its steps, the first
> script's Worktree link among them. The [plan](../../plans/chore/303-issue-data-model.md) tracks each in § The cutover,
> from 2026-11-02, and § Closing, from 2026-11-04.

The owner, 2026-10-21: "the data model goes into the epic around issue tracking. there are two technical sides: the
GitHub data model and the tooling (star gh). and migration must be managed carefully." This design is the first
technical side, the data model. The second, the star github extension that reads and enforces it, gets a design of
its own once this one is ruled. The migration between the old scheme and the model is
[section 5](5-from-todays-scheme.md). The epic, filed 2026-10-21, is
[Epic: Issue tracking, #330](https://github.com/NobleFactor/noblefactor-engprod/issues/330): this
design is its feature [#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331), the tooling is
[#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332), and the rollout, which carries the migration
and the rename of noblefactor-ops to noblefactor-engprod, is
[#333](https://github.com/NobleFactor/noblefactor-engprod/issues/333).

What every issue is, what it carries, and how it is ordered, in any account that takes the model: an organization's,
such as NobleFactor, or a user's, such as David-Noble-at-work. Each account has its own data model of this one design
(ruled 2026-11-02), and pull reads the data model of any account (ruled 2026-11-03). It is the model `star github` will
read and [issue-standards.md](../../issue-standards.md) will state once it is ruled. Enforcement of it is lax, and there
are no compliance checks (ruled 2026-11-03). Ruled 2026-11-04, superseding that in part: enforcement stays lax, and the
sweep (#436) will be the one check, returning an issue that breaks a rule to its team's Triage project every day; it
will block no filing and correct nothing by itself. The model replaces the scheme that document stated, where an issue's
place was a kind label, an `Epic:<Name>` label and a `**Feature:**` marker, and scenarios, then called threads, and
schedules were tables in issue bodies.

Ruled 2026-11-03: the old scheme's last three pieces retired that day, and the retirement is done in GitHub. The parent
markers and schedule footers came out of 725 issue bodies, and 47 issues got the sub-issue parent their marker named;
where a marker and a sub-issue link disagreed, the link stands. The step and beat tables in 14 Schedule and Scenario
issues gave way to a line naming the issue's board and option. The kind labels epic, feature, task and bug left
NobleFactor's 12 repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its
type labels, because they are its types. The `Epic:` and `Thread:` labels left both accounts the same day.

In one paragraph: every issue but a Scenario issue, which never closes, states its evidence of completion (ruled
2026-11-02 and 2026-11-04), in its Evidence of completion section, which the issue form checks at filing in a public
repository (ruled 2026-11-04). Issues are classified by issue type (ruled 2026-11-03). A classified issue has one Type,
Epic, then Feature, then Task or Bug, and one parent one level up, except an epic. Two more types, Schedule and
Scenario, mark the issues that describe a schedule and a scenario; they have no level, and their descriptions begin
"Collection:". Threads were renamed scenarios on 2026-11-03. An issue with no Type, or below level 0 no parent, is
untriaged. Issues we file ourselves will go through `star github issue` once it is built (#338), the one path that will
classify an issue as it is made (ruled 2026-11-03). Its attributes are Severity, Priority and Area, for an issue of any
type, Schedule and Scenario included: a bug's Severity is Critical, High, Medium or Low, and every issue of another type
has Severity N/A (ruled 2026-11-04). In NobleFactor all three are issue fields; David-Noble-at-work has no issue fields,
so there a label stands in for each option, such as `severity:critical`, `priority:urgent` and `area:product`, held per
repository like every label in the account's model. Area tells engineering work from product work, and has two values,
product and engineering: the options Product and Engineering of NobleFactor's Area issue field, and the labels
`area:product` and `area:engineering` in a user account (ruled 2026-11-03). A blank Area is an error, caught when an
issue is filed in a public repository, at triage, and afterward by a scheduled sweep. Each team, and each user account,
has four GitHub projects: Triage, Backlog, Schedule and Scenario (ruled 2026-11-03). Every new issue reaches its team's
Triage project, or its own account's in a user account, through a GitHub Actions workflow in its repository, apart from
a task or a bug logged while walking a scenario, which the workflow adds to the scenario (#448). A triage decision
is made in the Triage project: the work is declined, or the issue moves to the team's Backlog, Schedule or Scenario
project. Every move is one act: the issue gets its row in the project it goes to and loses its row in the one it leaves,
and triage removes an issue's Triage row as part of its decision. An issue is a row of at most one of its account's
Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most one schedule or scenario,
and an epic or a feature is never a row of a Backlog, Schedule or Scenario project: once classified, it leaves Triage
for no project. An issue on another team's project is assigned to an accountable member of that team, and the person
whose name is on an issue moves it to another team in one act, as any move is made (ruled 2026-11-04). The sweep (#436)
will return to its team's Triage project any open issue that isn't fully classified or that breaks an attribute rule,
and, by two structural rules, an epic or a feature that is a row of a Backlog, Schedule or Scenario project and an issue
that is a row of more than one of its account's projects or on more than one schedule or scenario. It will leave a
scenario's rows alone but for those two rules, and every other rule waits until an item logged while walking the
scenario moves out (ruled 2026-11-04). The Backlog project holds accepted work not yet scheduled, ordered by priority,
and work goes from it onto a schedule highest Priority first (ruled 2026-11-04). The Schedule project holds the team's
committed tasks and bugs, and its Schedule field names the schedule each row belongs to. Each schedule is described by
an issue of type Schedule, labeled `schedule` in a user account, which holds its deliverable and exit criteria. Step
orders the rows within a schedule, and a Schedule issue's own row has no step; every other row gets its step number and
its blocked-by links when it is added, and steps are worked in step order. The Scenario project holds the team's
scenarios, and its Scenario field names the scenario each row belongs to. A scenario is a high-level description of a
feature, a workflow or a real-life situation that needs to be tested. Its issue, of type Scenario, labeled `scenario` in
a user account, summarizes an end-user goal and names the features it exercises; its other rows are the tasks and bugs
found by walking it, each until it moves to Triage or onto a schedule, and Beat orders them by the point in the walk
where each turned up (ruled 2026-11-04).

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull
request template, are stored in its `.github` repository, and every document that talks about one of them refers to it
there ([section 6](6-the-asset-and-its-sync.md) § One model per account).

Ruled 2026-11-03: Severity is an issue field of NobleFactor, with the values Critical, High, Medium and Low
([section 2](2-attributes.md) § The attributes).

Ruled 2026-11-04: a task has no severity; it has a priority. Severity applies to bugs only, and every issue of another
type has Severity N/A: in NobleFactor, a new option N/A of the Severity issue field; in a user account, a new label
`severity:n/a`. Both are made by the script of #303's closing pull request. A bug has Critical, High, Medium or Low,
never N/A. An issue with no type yet gets no Severity and waits for triage, which sets N/A when it gives the issue a
type other than Bug, and the sweep (#436) will catch a miss. The Triage workflow sets the Severity when an issue is
opened, and an issue that has one keeps it: a bug, whose form asks no severity, gets Medium, the owner's default, which
GitHub's field can't hold, an issue of another type N/A, and an issue with no type yet none (#448); triage changes a
bug's Severity when its harm is greater or less. An issue typed only after it is opened gets no Severity from the
workflow, and triage gives it one. `star github issue` will set N/A at filing (#338). So every typed issue has exactly
one Severity value ([section 2](2-attributes.md) § The attributes).

Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub offers
organizations only, so in a user account, which has no issue fields, a label stands in for each option of a
single-select field, named `<field>:<option>` in lowercase ([section 4](4-storage-and-reach.md) § A user account).

Ruled 2026-11-03: David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's steps go
on them ([section 4](4-storage-and-reach.md) § The rest of the ruling).

Ruled 2026-11-03: every project of a kind is configured the same way. GitHub's API can delete a project's built-in
workflow but can't make one or turn one on, so the only state every project can share is none. Every built-in workflow
of the twenty projects of the four kinds was deleted that day, Triage: devlore's "Auto-add sub-issues to project", which
was on, among them ([section 3](3-collections.md) § Triage and the Backlog).

Ruled 2026-11-04: any member of a team can see all of the team's issues and do all of its work in its four projects:
triage, the backlog, scheduling and scenarios. So the one grant a new participant needs is membership in the team, whose
roles carry the rest: the maintain role on each repository the team owns, and the write role on each of its four
projects, which the script of #303's closing pull request sets in place of the Admin role ruled for each team's Triage
project on 2026-10-22 ([section 3](3-collections.md#ownership)). The write role lets a member edit a project, its fields
and views included; what stays with an organization owner is a project's settings and access, and keeping every project
of a kind configured the same way rests on push (#437), not on the role. Adding a person to NobleFactor needs a seat
first: its Team plan has one seat, filled. Setting a parent across two teams' repositories needs the triage role on
both. Read 2026-11-04, devlore holds the write role on noblefactor-engprod, so a devlore member can link a devlore issue
to a noblefactor-engprod parent and back; engprod holds no role on devlore's repositories, so an engprod member can't.
An organization owner, who holds the admin role on each of the organization's repositories, can set a parent between any
two. A user account has no teams; there, a new participant is a collaborator on each participating repository, personal
and David-Noble-at-work/.github, and a writer on each of the account's four projects
([issue-standards.md § Who can do what](../../issue-standards.md#who-can-do-what)). An issue is a row of at most one of
its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most one schedule
or scenario. Every move is one act: the issue gets its row in the project it goes to, with that project's fields set,
and loses its row in the project it leaves. Out of Triage, declined work is closed as completed with Resolution
Declined, or in a user account the `resolution:declined` label, and accepted tasks and bugs go to the Backlog with their
Priority or onto a schedule. Triage removes an issue's Triage row as part of its decision: an issue someone closes
outside triage stays in its Triage project until triage decides its disposition. Ruled the same day, superseding in part
the ruling of 2026-10-22 that work for another team gets a tracking issue: an issue on another team's project is
assigned to an accountable member of that team, and the person whose name is on an issue moves it to another team the
way any move is made, in one act, between its team's Triage project or schedule and the other team's: triage to triage,
triage to schedule, schedule to triage, or schedule to schedule. GitHub allows up to 10 assignees on an issue, any
organization member who can read the repository among them (GitHub's documentation, Assigning issues and pull requests
to other GitHub users), and all five of NobleFactor's participating repositories are public. Epics and features are
never rows of a Backlog, Schedule or Scenario project: a new one reaches Triage like every new issue and, once
classified, leaves Triage for no project, since the hierarchy holds it and its tasks and bugs are what reach the Backlog
and the schedules, from which a work item's parent link leads to its feature and its epic. From the Backlog, work goes
onto a schedule highest Priority first, with the schedule's option, the next step or the step the schedule's owner gives
it, Status Open and its blocked-by links. A committed schedule takes it only by its owner's amendment, recorded in the
Schedule issue. `star github schedule add` (#438), built on 2026-11-12, makes that move in one command. The sweep
(#436) will return an
issue in more than one of its account's projects, the Scenario projects among them, or on more than one schedule or
scenario, to its team's Triage project, and will remove no Triage row. The Backlog shows its order in a view named By
priority, sorted by Priority, which the script of #303's closing pull request makes in Backlog: engprod, Backlog:
devlore and the Backlog template; David-Noble-at-work's Backlog has no Priority field to sort by, since a user account
has no issue fields. The same script shows the Priority field in the Backlog projects' views, By priority among them,
since no view shows it today (read 2026-11-04). It removes the five feature rows read that day, four from the Scenario
projects and one from Schedule: devlore; removes the Scenario rows of 15 tasks and bugs that had already moved on,
recording each on its Scenario issue; and deletes the Triage rows of the 30 open issues in NobleFactor's Triage projects
that are also rows of a Schedule project ([section 5](5-from-todays-scheme.md) § The deltas). How the sweep later
handles an issue in a scenario and in another project, without taking a scheduled item off its schedule, is #436's to
design.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. The hierarchy](1-hierarchy.md) | Type and its six values: Epic, Feature, Task and Bug on the three levels, and Schedule and Scenario, which describe collections and have no level; parents, triage, and how long a level lives | [Ruled](1-hierarchy.status.md) |
| [2. Attributes](2-attributes.md) | Severity, Priority and Area: what an issue has on its own, outside any collection; all three are issue fields in NobleFactor and labels in David-Noble-at-work | [Ruled](2-attributes.status.md) |
| [3. Collections](3-collections.md) | The four projects of each team and each user account, Triage, Backlog, Schedule and Scenario, as GitHub projects made from the Triage, Backlog, Schedule and Scenario templates: who joins which, the Schedule and Scenario fields, steps, beats and iterations, a schedule's or scenario's own record, an issue of type Schedule or Scenario (a Triage project has none), ownership | [Ruled in part](3-collections.status.md) |
| [4. Storage and reach](4-storage-and-reach.md) | Where each part lives in GitHub, what enforces it, and which repositories it reaches | [Ruled](4-storage-and-reach.status.md) |
| [5. From today's scheme](5-from-todays-scheme.md) | The deltas the task list is drawn from, and the order that keeps running work running | [Revised](5-from-todays-scheme.status.md) |
| [6. The asset and its sync](6-the-asset-and-its-sync.md) | GitHub is each account's model, read when a command needs it; the YAML file in the account's `.github` repository is its backup. `star github model get`, `diff`, `apply`, `backup` and `restore`, each naming its account (#426, #437) | [Ruled](6-the-asset-and-its-sync.status.md) |
| [7. The workflow, before and after](7-the-workflow-before-and-after.md) | Why this epic: filing an issue, writing a schedule and reporting progress, as a session does them today and once the model is in | [Written](7-the-workflow-before-and-after.status.md) |
| [8. The schedule commands](8-the-schedule-commands.md) | What `star github schedule` does, verb by verb: `report`, `list`, `get`, `new`, `add`, `move`, `remove` and `close`, for an organization and for a user account (#439) | [Ruled](8-the-schedule-commands.status.md) |

## Terms

- **Type:** the hierarchy's classifier. Its values are Epic, Feature, Task and Bug, and Schedule and Scenario,
  capitalized as GitHub names issue types (ruled 2026-11-03), and a triaged issue has exactly one. Scenario was called
  Thread until 2026-11-03. In an organization it is GitHub's own issue type, ruled 2026-10-22. A user account such as
  David-Noble-at-work has no issue types, so each type is a lowercase label of its name, `epic`, `feature`, `task`,
  `bug`, `schedule` or `scenario`, carried by every repository of the account. Enforcement is lax, and there are no
  compliance checks (ruled 2026-11-03). Ruled 2026-11-04, superseding that in part: the sweep (#436) will be the one
  check, and it will return an issue that isn't fully classified, such as one with two type labels in a user account, to
  its team's Triage project, or in a user account to the account's; it will block no filing and correct nothing by
  itself.
- **Level:** an issue's depth in the hierarchy: 0 for an epic, 1 for a feature, 2 for a task or a bug. Schedule and
  Scenario issues have no level: their types' descriptions begin "Collection:", where the others begin "Level N:".
- **Parent:** the issue one level up. An epic has none.
  Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.
- **Untriaged:** an issue with no Type, or below level 0 no parent: not fully classified. Every new issue waits in its
  team's Triage project, or its account's in a user account, until it is classified (ruled 2026-11-03); an item logged
  while walking a scenario waits in the scenario instead, until it moves out (ruled 2026-11-04). The queries find any
  untriaged issue that is in neither, which the sweep (#436) will return to its team's Triage project. The sweep will
  leave a scenario's rows alone but for two structural rules, on an epic or a feature in a scenario and on an issue in a
  scenario and in another of its account's projects (§ Terms, under Scenario; ruled 2026-11-04). Issues we file
  ourselves will go through `star github issue` once it is built, the one path that will classify an issue as it is made
  (ruled 2026-11-03), and it will refuse an issue without an Area (#338; ruled 2026-11-03).
- **Evidence of completion:** what an issue states will show that it is done. Every issue states it (ruled 2026-11-02)
  but a Scenario issue, which states none: a scenario never ends, so its issue never closes and has nothing to evidence
  (ruled 2026-11-04). It goes in the issue's Evidence of completion section, which each of the six issue forms in each
  account's `.github` repository has (ruled 2026-11-04); #453 will put "how to walk it", the example the Scenario issue
  gives, in its place on both accounts' Scenario forms. At filing, the form checks the section in a public repository;
  GitHub enforces a form's required fields only there (GitHub's form schema documentation, read 2026-11-04). In a
  private repository, which today is only personal, nothing checks it at filing until `star github issue` does (#338).
  Afterward, the sweep (#436) will return an issue with no Evidence of completion section, a Scenario issue excepted, to
  its team's Triage project.
- **Attribute:** something an issue has on its own, outside any collection: its severity, its priority, its area.
  All three are issue fields in NobleFactor and labels in David-Noble-at-work (ruled 2026-11-03). Every typed issue
  has exactly one Severity value: a bug's is Critical, High, Medium or Low, and an issue of any other type has N/A.
  The label `good first issue` goes on tasks and bugs only, in both accounts (ruled 2026-11-04).
- **Area:** whether an issue's own work is product work or engineering work, ruled 2026-11-03. It has two values: in
  NobleFactor, the options Product and Engineering of the Area issue field, made 2026-11-03; in a user account, the
  labels `area:product` and `area:engineering`. Area applies to issues of every type, so an epic, a feature and the
  tasks and bugs under them can each differ: a CI bug fixed during a product feature is engineering. What product work
  and engineering work each cover, tests among engineering's, and what each may hold, is in
  [issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering). Release notes come
  from the closed product issues in a release, not from the hierarchy. NobleFactor/devlore-cli's seven
  finer Area labels, architecture, CLI, code quality, error handling, git, meta and testing, were deleted on
  2026-11-03, and the hierarchy carries those distinctions ([section 1](1-hierarchy.md) § Type). A blank Area is an
  error, caught at three points (ruled 2026-11-03). At filing, `star github issue` will refuse an issue without an Area
  (#338), and the issue forms in each account's `.github` repository have a required Area dropdown. The Triage workflow
  copies its answer into the Area field or label when the issue is opened: personal's adds the `area:` label, and
  NobleFactor's sets the Area field (#447, #448). GitHub enforces the dropdown only in a public
  repository, so in a private one, which today is only personal, nothing checks the Area at filing until
  `star github issue` does (ruled 2026-11-04). At triage, each Triage project has the Area field (in a user account, the
  `area:` labels, in its Labels column) and a Missing Area view, both made 2026-11-03, and nothing leaves Triage without
  an Area; read 2026-11-04, no view shows the Area or Labels column, and the script of #303's closing pull request shows
  it in every view of the Triage projects. Afterward, a scheduled sweep will return any open issue without an Area to
  its team's Triage project, once #452 has given every open issue an Area (ruled 2026-11-04).
- **Collection:** a GitHub project that gathers issues for a purpose. Each team, and each user account, has four:
  Triage, Backlog, Schedule and Scenario (ruled 2026-11-03). In an organization each is named `<Kind>: <team>`, such
  as Triage: engprod, Backlog: devlore, Schedule: engprod and Scenario: devlore, and in the user account
  `<Kind>: David-Noble-at-work`. A team's projects are copied from its account's templates, or brought to them.
  NobleFactor keeps a template for each kind: Triage (its project 23), Schedule (its project 7), Scenario (its project
  8, the former Thread template) and Backlog (its project 24). A user account cannot mark a project as a template, so
  David-Noble-at-work keeps copies of them to copy new projects from; its copies of Schedule, Scenario, Triage and
  Backlog are its projects 1, 2, 4 and 5 (ruled 2026-11-03). A schedule is described by an issue of type Schedule and
  a scenario by an issue of type Scenario; a Triage project has no such issue. Status is a field on a project's row,
  and anyone may set it (ruled 2026-11-03). The team that owns a project is accountable for it, and GitHub's link
  between the project and its team is the record. A user account's projects are its owner's (ruled 2026-11-03). Any
  member of a team can see all of the team's issues and do all of its work in its four projects, so the one grant a new
  participant needs is membership in the team (ruled 2026-11-04).
- **Triage project:** the project where every issue of a team, or of a user account, is reviewed and a triage decision
  made (ruled 2026-11-03). Each team owns its Triage project, and a user account owns its own. Every new issue, of any
  Type or none, goes into its team's Triage project until it is classified, apart from a task or a bug logged while
  walking a scenario (below). It has no triage epic and no row 0, and there is no Triage type (ruled 2026-11-03). A
  triage decision declines the work, and the issue is closed as completed, with Resolution Declined in NobleFactor or
  the `resolution:declined` label in a user account, or it moves the issue to the team's Backlog, Schedule or Scenario
  project. New issues reach their team's Triage project through a GitHub Actions workflow in each repository, run when
  an issue is opened or transferred, using `actions/add-to-project`; GitHub's built-in auto-add workflow is not used.
  Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project, from the team mapping: the team with
  the maintain role on a repository owns it. A Triage workflow template in each account's `.github` repository offers
  the workflow (ruled 2026-11-03). GitHub's documentation describes workflow templates kept in an organization's
  `.github` repository and says nothing of a user account's; whether GitHub offers David-Noble-at-work/.github's
  template to personal has not been checked, and David-Noble-at-work/personal#315 copies personal's `triage.yml` from it
  either way ([section 4](4-storage-and-reach.md) § Triage). GitHub Actions cannot run a workflow when a project row
  changes: `projects_v2_item` is a webhook event for organization webhooks and GitHub Apps only. There are three Triage
  projects: Triage: engprod (NobleFactor project 5), Triage: devlore (NobleFactor project 6) and Triage:
  David-Noble-at-work (David-Noble-at-work project 3). Each has the Area field (in a user account, the `area:` labels,
  in its Labels column) and a Missing Area view, both made 2026-11-03, and nothing leaves Triage without an Area; read
  2026-11-04, no view shows the Area or Labels column, and the script of #303's closing pull request shows it. Ruled
  2026-11-04: accepted tasks and bugs go out of Triage to the Backlog with their Priority or onto a schedule, and an
  epic or a feature, once classified, leaves Triage for no project, since the hierarchy holds it. Every move is one act:
  the issue gets its row in the project it goes to, with that project's fields set, and loses its row in the project it
  leaves. Triage removes an issue's Triage row as part of its decision, and the sweep (#436) will remove none: an issue
  someone closes outside triage stays in its Triage project until triage decides its disposition. An issue is a row of
  at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at
  most one schedule or scenario, and the sweep will return one that breaks this to its team's Triage project. An issue
  on another team's project is assigned to an accountable member of that team, and the person whose name is on an issue
  moves it to another team in one act, between its team's Triage project or schedule and the other team's: triage to
  triage, triage to schedule, schedule to triage, or schedule to schedule (ruled 2026-11-04). An item logged while
  walking a scenario goes to the scenario instead of to Triage (§ Terms, under Scenario). Ruled 2026-11-03: a repository
  takes part in the data model when a team has the maintain role on it, in an organization, or when it has the topic
  issue-model, in a user account.
- **Backlog project:** a team's accepted work not yet scheduled, or a user account's, ordered by priority (ruled
  2026-11-03). Work goes from it onto a schedule highest Priority first, and a scenario changes no issue's priority:
  triage sets each issue's Priority (ruled 2026-11-04). It shows its order in a view named By priority, sorted by
  Priority, which the script of #303's closing pull request makes in Backlog: engprod, Backlog: devlore and the Backlog
  template; David-Noble-at-work's Backlog has no Priority field to sort by. Read 2026-11-04, no Backlog view shows
  Priority, or in a user account the Labels column that holds the `priority:` labels, and the same script shows it.
- **Scenario:** a high-level description of a feature, a workflow or a real-life situation that needs to be tested
  (ruled 2026-11-04). Its Scenario issue, of type Scenario, labeled `scenario` in a user account, is its own row in the
  team's Scenario project and summarizes an end-user goal. It drives planning, coverage and team alignment, includes an
  example for demos and ad-hoc testing that helps find gaps and defects no other kind of testing finds, and names in its
  body the features it exercises. A scenario is structurally like a schedule that starts with no tasks or bugs: they are
  found with time. Someone opens the scenario and walks it, logging work items as they go, each a task or a bug and a
  row of the team's Scenario project under the scenario's option, its Beat the point in the walk where it turned up. A
  logged item names its scenario in its body, as "Found while walking #N", and the Triage workflow adds it to the
  scenario instead of to the team's Triage project (#448). Each item later moves to its team's Triage project or
  straight onto a schedule, and leaves the scenario; the item's body and a comment on the Scenario issue record the
  move. The sweep (#436) will leave a scenario's rows alone but for two structural rules: it will return an epic or a
  feature that is a row of the Scenario project, as it will one on a Backlog or Schedule project, and an issue that is a
  row of a scenario and of another of its account's projects, whichever team owns them, so one project at a time holds
  for all four. Every other rule waits until an item moves out: an item gets its type and parent then, and moving
  straight onto a schedule means classifying it first. A scenario never ends: it is kept, updated or removed as the
  product changes, since it has value before, during and after a release. Its Scenario issue never closes, so it states
  no evidence of completion (§ Terms, under Evidence of completion). Both accounts' Scenario forms will be brought to
  this in #453, with the Scenario type's description and the `scenario` labels' in personal and
  David-Noble-at-work/.github, which still read "Collection: describes a scenario, the story its features tell" (read
  2026-11-04). The project's single-select Scenario field names the scenario each row belongs to, with an option named
  for each Scenario issue. There is no project per scenario. Scenarios were called threads until 2026-11-03, and a
  thread had a project of its own (ruled 2026-11-03).
- **Schedule:** a set of tasks and bugs in the order they are worked, described by an issue of type Schedule, labeled
  `schedule` in a user account; that issue holds the schedule's deliverable and exit criteria. The team's Schedule
  project holds its committed tasks and bugs. Its single-select Schedule field names the schedule each row belongs
  to, with one option per schedule, named for its Schedule issue. GitHub's Iteration field gives each row its sprint,
  for scrums and sprint review. There is no project per schedule (ruled 2026-11-03). A schedule has no Next column
  (ruled 2026-11-02). Its Worktree column holds, on each step's row, a link to the branch the step's work is on, and
  the step's own issue records that it merged or closed (ruled 2026-11-03).
- **Row, step, beat:** an issue's place in a collection. Step orders the rows within a schedule, and a Schedule
  issue's own row has no step (ruled 2026-11-03). Every other row of a schedule gets its step number and its
  dependencies, GitHub blocked-by links, when it is added, and steps are worked in step order (ruled 2026-11-02). Step
  was called lane before that day. Beat orders the rows within a scenario (ruled 2026-11-03): a logged item's Beat is
  the point in the walk where it turned up (ruled 2026-11-04). An issue is on at most one schedule or scenario. A row
  comes onto a schedule with the next step or the step the schedule's owner gives it, and a committed schedule takes it
  only by its owner's amendment, recorded in the Schedule issue (ruled 2026-11-04).
- **The organization's repositories:** NobleFactor's, which GitHub's organization features reach.
- **Account:** a GitHub organization's account or a user's. Accounts are separate: each has its own issues, projects,
  labels and data model. No project, sub-issue link or blocked-by link crosses accounts, and work that waits on
  another account uses a stand-in issue in its own account (ruled 2026-11-02). Each account's model is stored in that
  account's `.github` repository, NobleFactor/.github and David-Noble-at-work/.github, and both exist. GitHub treats a
  public repository named `.github` as the account's own and serves its default community health files and issue
  templates to every repository of the account.
- **David-Noble-at-work:** a user account with its own data model, stored in David-Noble-at-work/.github. Its projects
  are its copies of the templates, the Schedule, Scenario, Triage and Backlog copies (its projects 1, 2, 4 and 5), and
  its four projects made from them: Triage: David-Noble-at-work (its project 3), Backlog: David-Noble-at-work,
  Schedule: David-Noble-at-work and Scenario: David-Noble-at-work (ruled 2026-11-03). They are its owner's.
  **personal**, David-Noble-at-work/personal, is one of its repositories.
- **The model, or the asset:** a YAML description of an account's data model: its issue types (type labels, in a user
  account), its issue fields, the labels of each of its repositories, its teams, and its project templates with their
  custom fields, options and views. It leaves out issues, the projects made from templates, the projects' built-in
  workflows and an organization's default labels (ruled 2026-11-03). None of the twenty projects of the four kinds has a
  built-in workflow: GitHub's API can't make one, so projects of a kind match only with none. GitHub is the model (ruled
  2026-11-09, #426): star reads an account's model from GitHub when a command needs it, and the YAML file in the
  account's `.github` repository is a backup of it, written by `star github model backup` and read only by `restore`.
  `star github model get` reads the model of any account, ours or not; `diff`, `apply` and `restore`, built in #437,
  compare a model with an account's, make it the account's, and restore a backup, and `apply` brings a new account in,
  with its `.github` files and each repository's Triage workflow. Each names its account, and no account is a default
  ([section 6](6-the-asset-and-its-sync.md#github-is-the-model)). Two reference models ship with the star extension,
  one for an organization's account and one for a user's, beside the project templates they share. Until
  2026-11-02 the model was a single committed `model.yaml` beside the extension; from #431 and #441 until #426, star
  read each of our accounts' `model.yaml` from its `.github` repository by ETag as the model, a cache it queried instead
  of asking GitHub again, and `pull` and `push` were its two verbs. Ruled 2026-11-03: an account's model holds its issue
  fields, as it holds its issue types and labels. NobleFactor's are Priority, Effort, Target date, Resolution, Area and
  Severity, and its Start date field stays unused. A user account has none.
