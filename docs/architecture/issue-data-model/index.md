---
title: "Issue data model — one hierarchy, its attributes, and the collections that order it"
---

# Issue data model — one hierarchy, its attributes, and the collections that order it

> **Status:** ruled in part, 2026-10-22 to 2026-11-03; what is open is in the plan's questions. The work:
> [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303), a task under
> issue standards, [NobleFactor/noblefactor-engprod#156](https://github.com/NobleFactor/noblefactor-engprod/issues/156);
> it was a chore until the open chores were typed Task on 2026-11-02. #303 keeps only the design. Its build and rollout
> work moved to issues of their own: #365, #425 to #428, #436 to #441 and David-Noble-at-work/personal#309. Ruled
> 2026-11-02: a working issue tracking system on GitHub comes first, and the tooling follows. The
> [plan](../../plans/chore/303-issue-data-model.md) holds the owner's words, each quoted with its date, and the open
> questions.
>
> Ruled on the evening of 2026-11-03, and recorded below: Severity is an issue field of NobleFactor; a user account has
> the same data model as an organization, apart from what GitHub offers organizations only; and David-Noble-at-work has
> schedules of its own, which personal's steps go on. The design worktree's script ran the same evening, and each of its
> four steps read back: ruleset 12515090 no longer allows `chore/` branches, `doc/303-model-cutover` is on GitHub and
> linked from #303's row on Schedule: engprod, NobleFactor has its Severity field, and devlore-cli's `Severity:` and
> `Priority:` labels became field values and were deleted. Read from GitHub that evening, the noblefactor-automation
> app's installation on NobleFactor has organization projects read and write, issue fields read, and issues read and
> write; nothing has used them yet, and the first Triage workflow run in a NobleFactor repository proves them
> ([section 4](4-storage-and-reach.md) § Triage). GitHub makes no single-select project field without an option, so
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
> template. Both take part in triage from that day, so seven repositories have `TRIAGE_PROJECT_URL` set, and none of
> the seven has the Triage workflow yet ([section 4](4-storage-and-reach.md) § Triage). `git open-branch` still
> accepts `chore`, in the script, its man page and its completions. The PR script template still records lanes in
> schedule tables that were retired on 2026-11-03, and has nothing yet for what a worktree's first script records. The
> [plan](../../plans/chore/303-issue-data-model.md) tracks each in § The cutover, from 2026-11-02.

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
read and [issue-standards.md](../../issue-standards.md) will state once it is ruled. Enforcement of it is lax, and
there are no compliance checks (ruled 2026-11-03). It replaces the scheme that document stated, where an issue's
place was a kind label, an `Epic:<Name>` label and a `**Feature:**` marker, and scenarios, then called threads, and
schedules were tables in issue bodies.

Ruled 2026-11-03: the old scheme's last three pieces retired that day, and the retirement is done in GitHub. The parent
markers and schedule footers came out of 725 issue bodies, and 47 issues got the sub-issue parent their marker named;
where a marker and a sub-issue link disagreed, the link stands. The step and beat tables in 14 Schedule and Scenario
issues gave way to a line naming the issue's board and option. The kind labels epic, feature, task and bug left
NobleFactor's 12 repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its
type labels, because they are its types. The `Epic:` and `Thread:` labels left both accounts the same day.

In one paragraph: every issue states its evidence of completion (ruled 2026-11-02). Issues are classified by issue
type (ruled 2026-11-03). A classified issue has one Type, Epic, then Feature, then Task or Bug, and one parent one
level up, except an epic. Two more types, Schedule and Scenario, mark the issues that describe a schedule and a
scenario; they have no level, and their descriptions begin "Collection:". Threads were renamed scenarios on
2026-11-03. An issue with no Type, or below level 0 no parent, is untriaged. Issues we file ourselves go through
`star github issue`, the one path that classifies an issue as it is made (ruled 2026-11-03). Its attributes are
Severity for a bug, and Priority and Area for an issue of any type, Schedule and Scenario included. In NobleFactor
all three are issue fields; David-Noble-at-work has no issue fields, so there a label stands in for each option, such
as `severity:critical`, `priority:urgent` and `area:product`, held per repository like every label in the account's
model. Area tells engineering work from product work, and has two values, product and engineering: the options Product
and Engineering of NobleFactor's Area issue field, and the labels `area:product` and `area:engineering` in a user
account (ruled 2026-11-03). A blank Area is an error, caught when an issue is filed, at triage, and afterward by a
scheduled sweep. Each team, and each user account, has four
GitHub projects: Triage, Backlog, Schedule and Scenario (ruled 2026-11-03). Every new issue reaches its team's Triage
project, or its own account's in a user account, through a GitHub Actions workflow in its repository, and a triage
decision is made there: the work is declined, or the issue moves to the team's Backlog, Schedule or Scenario project.
The Backlog project holds accepted work not yet scheduled, ordered by priority. The Schedule project holds the team's
committed tasks and bugs, and its Schedule field names the schedule each row belongs to. Each schedule is described by
an issue of type Schedule, labeled `schedule` in a user account, which holds its deliverable and exit criteria. Step
orders the rows within a schedule, and a Schedule issue's own row has no step; every other row gets its step number and
its blocked-by links when it is added, and steps are worked in step order. The Scenario project holds the team's
features, and its Scenario field names the scenario each row belongs to. Each scenario is told by an issue of type
Scenario, labeled `scenario` in a user account, and Beat orders the rows within it.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull
request template, are stored in its `.github` repository, and every document that talks about one of them refers to it
there ([section 6](6-the-asset-and-its-sync.md) § One model per account).

Ruled 2026-11-03: Severity is an issue field of NobleFactor, with the values Critical, High, Medium and Low
([section 2](2-attributes.md) § The attributes).

Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub offers
organizations only, so in a user account, which has no issue fields, a label stands in for each option of a
single-select field, named `<field>:<option>` in lowercase ([section 4](4-storage-and-reach.md) § A user account).

Ruled 2026-11-03: David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's steps go
on them ([section 4](4-storage-and-reach.md) § The rest of the ruling).

Ruled 2026-11-03: every project of a kind is configured the same way. GitHub's API can delete a project's built-in
workflow but can't make one or turn one on, so the only state every project can share is none. Every built-in workflow
of the twenty projects of the four kinds was deleted that day, Triage: devlore's "Auto-add sub-issues to project", which
was on, among them ([section 3](3-collections.md) § Triage and the Backlog).

Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. The hierarchy](1-hierarchy.md) | Type and its six values: Epic, Feature, Task and Bug on the three levels, and Schedule and Scenario, which describe collections and have no level; parents, triage, and how long a level lives | [Ruled in part](1-hierarchy.status.md) |
| [2. Attributes](2-attributes.md) | Severity, Priority and Area: what an issue has on its own, outside any collection; all three are issue fields in NobleFactor and labels in David-Noble-at-work | [Ruled in part](2-attributes.status.md) |
| [3. Collections](3-collections.md) | The four projects of each team and each user account, Triage, Backlog, Schedule and Scenario, as GitHub projects made from the Triage, Backlog, Schedule and Scenario templates: who joins which, the Schedule and Scenario fields, steps, beats and iterations, a schedule's or scenario's own record, an issue of type Schedule or Scenario (a Triage project has none), ownership | [Ruled in part](3-collections.status.md) |
| [4. Storage and reach](4-storage-and-reach.md) | Where each part lives in GitHub, what enforces it, and which repositories it reaches | [Ruled in part](4-storage-and-reach.status.md) |
| [5. From today's scheme](5-from-todays-scheme.md) | The deltas the task list is drawn from, and the order that keeps running work running | [Revised](5-from-todays-scheme.status.md) |
| [6. The asset and its sync](6-the-asset-and-its-sync.md) | Each account's model, a YAML file stored in the account's `.github` repository; `star github model pull`, which reads a whole account, `--account` defaulting from `github.account` and `--asset` naming the file; then `push`. Whether star reads GitHub by ETag before every operation is decided with #426 and #437 | [Ruled](6-the-asset-and-its-sync.status.md) |
| [7. The workflow, before and after](7-the-workflow-before-and-after.md) | Why this epic: filing an issue, writing a schedule and reporting progress, as a session does them today and once the model is in | [Written](7-the-workflow-before-and-after.status.md) |

## Terms

- **Type:** the hierarchy's classifier. Its values are Epic, Feature, Task and Bug, and Schedule and Scenario,
  capitalized as GitHub names issue types (ruled 2026-11-03), and a triaged issue has exactly one. Scenario was
  called Thread until 2026-11-03. In an organization it is GitHub's own issue type, ruled 2026-10-22. A user account
  such as David-Noble-at-work has no issue types, so each type is a lowercase label of its name, `epic`, `feature`,
  `task`, `bug`, `schedule` or `scenario`, carried by every repository of the account. Enforcement is lax, and there
  are no compliance checks (ruled 2026-11-03).
- **Level:** an issue's depth in the hierarchy: 0 for an epic, 1 for a feature, 2 for a task or a bug. Schedule and
  Scenario issues have no level: their types' descriptions begin "Collection:", where the others begin "Level N:".
- **Parent:** the issue one level up. An epic has none.
  Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.
- **Untriaged:** an issue with no Type, or below level 0 no parent: not fully classified. Every new issue waits in its
  team's Triage project, or its account's in a user account, until it is classified (ruled 2026-11-03), and the
  queries find any untriaged issue that is not in one. Issues we file ourselves go through `star github issue`, the
  one path that classifies an issue as it is made (ruled 2026-11-03). It refuses an issue without an Area (ruled
  2026-11-03).
- **Evidence of completion:** what an issue states will show that it is done. Every issue states it (ruled 2026-11-02).
- **Attribute:** something an issue has on its own, outside any collection: its severity, its priority, its area.
  All three are issue fields in NobleFactor and labels in David-Noble-at-work (ruled 2026-11-03).
- **Area:** whether an issue's own work is product work or engineering work, ruled 2026-11-03. It has two values: in
  NobleFactor, the options Product and Engineering of the Area issue field, made 2026-11-03; in a user account, the
  labels `area:product` and `area:engineering`. Area applies to issues of every type, so an epic, a feature and the
  tasks and bugs under them can each differ: a CI bug fixed during a product feature is engineering. Engineering
  covers build orchestration, Makefile changes, CI pipelines, internal agent-workspace scripts and tools, and
  governance and process work. Release notes come from the closed product issues in a release, not from the
  hierarchy, and product readiness and release management epics hold both kinds. NobleFactor/devlore-cli's seven
  finer Area labels, architecture, CLI, code quality, error handling, git, meta and testing, were deleted on
  2026-11-03, and the hierarchy carries those distinctions ([section 1](1-hierarchy.md) § Type). A blank Area is an
  error, caught at three points (ruled 2026-11-03). At filing, `star github issue` refuses an issue without an Area,
  and the issue forms in each account's `.github` repository have a required Area dropdown, whose answer the Triage
  workflow copies into the Area field or label when the issue is opened. At triage, each Triage project shows the Area
  column (in a user account, the `area:` labels in its Labels column) and has a Missing Area view, both made
  2026-11-03, and nothing leaves Triage without an Area. Afterward, a scheduled sweep returns any open issue without an
  Area to its team's Triage project.
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
  between the project and its team is the record. A user account's projects are its owner's (ruled 2026-11-03).
- **Triage project:** the project where every issue of a team, or of a user account, is reviewed and a triage
  decision made (ruled 2026-11-03). Each team owns its Triage project, and a user account owns its own. Every new
  issue, of any Type or none, goes into its team's Triage project until it is classified. It has no triage epic and no
  row 0, and there is no Triage type (ruled 2026-11-03). A triage decision declines the work, and the issue is closed
  as completed, with Resolution Declined in NobleFactor or the `resolution:declined` label in a user account, or it
  moves the issue to the team's Backlog, Schedule or Scenario project. New issues reach their team's Triage project
  through a GitHub Actions workflow in each repository, run when an issue is opened or transferred, using
  `actions/add-to-project`; GitHub's built-in auto-add workflow is not used. Each repository's `TRIAGE_PROJECT_URL`
  variable names its team's Triage project, from the team mapping: the team with the maintain role on a repository
  owns it. A Triage workflow template in each account's `.github` repository offers the workflow (ruled 2026-11-03).
  GitHub's documentation describes workflow templates kept in an organization's `.github` repository and says nothing
  of a user account's; whether GitHub offers David-Noble-at-work/.github's template to personal has not been checked,
  and David-Noble-at-work/personal#315 copies personal's `triage.yml` from it either way
  ([section 4](4-storage-and-reach.md) § Triage). GitHub Actions cannot run a workflow when a project row changes:
  `projects_v2_item` is a webhook event for organization webhooks and GitHub Apps only. There are three Triage
  projects: Triage: engprod (NobleFactor project 5), Triage: devlore (NobleFactor project 6) and Triage:
  David-Noble-at-work (David-Noble-at-work project 3). Each shows the Area column (in a user account, the `area:`
  labels in its Labels column) and has a Missing Area view, both made 2026-11-03, and nothing leaves Triage without an
  Area.
  Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time.
  Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an
  organization, or when it has the topic issue-model, in a user account.
- **Backlog project:** a team's accepted work not yet scheduled, or a user account's, ordered by priority (ruled
  2026-11-03).
- **Scenario:** a story, told by an issue of type Scenario, labeled `scenario` in a user account, and the features
  that carry it out. The team's Scenario project holds its features. Its single-select Scenario field names the
  scenario each row belongs to, with an option named for each Scenario issue, and Beat orders the rows within a
  scenario. A scenario's rows are features. There is no project per scenario. Scenarios were called threads until
  2026-11-03, and a thread had a project of its own (ruled 2026-11-03).
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
  was called lane before that day. Beat orders the rows within a scenario (ruled 2026-11-03).
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
  workflows and an organization's default labels (ruled 2026-11-03). None of the twenty projects of the four kinds has
  a built-in workflow: GitHub's API can't make one, so projects of a kind match only with none. The model is a cache:
  star queries it instead of asking GitHub the same questions again, and builds sensible queries and updates from it.
  Pull comes first, then push (ruled 2026-11-02). `star github model pull` reads the whole model of any account, ours or
  not, every repository it owns, and has no `--repo` option. Its `--account` defaults from star's `github.account`
  setting, NobleFactor unless set, and `--asset` names the model file (ruled 2026-11-03). `star github model push`
  writes a model to an account, and that model becomes the account's data model. Two reference models ship with the star
  extension, one for an organization's account and one for a user's. Until 2026-11-02 the model was a single committed
  `model.yaml` beside the extension ([section 6](6-the-asset-and-its-sync.md)). Whether star reads GitHub by ETag before
  every operation or answers from the model until the next pull, what push writes, and `--asset`'s default are decided
  with the tooling, #426 and #437. Ruled 2026-11-03: an account's model holds its issue fields, as it holds its issue
  types and labels. NobleFactor's are Priority, Effort, Target date, Resolution, Area and Severity, and its Start date
  field stays unused. A user account has none.
