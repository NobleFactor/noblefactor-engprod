---
title: "3. Collections"
---

# 3. Collections

Ruled 2026-10-20: schedules map to GitHub projects, which replace the lane tables, and a lane becomes one row of a
schedule. Ruled 2026-10-21: schedules and scenarios, then called threads, differ in intent and are otherwise the same.
A scenario represents a use case and tracks features; a schedule tracks engineering work, its tasks and bugs; and
scenarios will in time drive schedules and influence priority. Ruled 2026-11-03: threads are renamed scenarios. The
issue type Thread is now Scenario, the label thread in a user account is now scenario, and the Thread template is the
Scenario template.

Ruled 2026-11-03: an issue's Area tells engineering work from product work. Area has two values, product and
engineering: in NobleFactor, the options Product and Engineering of the Area issue field, made 2026-11-03; in a user
account, the labels area:product and area:engineering. Area applies to issues of every type and describes the issue's
own work, so an epic, a feature and the tasks and bugs under them can each have a different Area: a CI bug fixed
during a product feature is engineering. Engineering covers build orchestration, Makefile changes, CI pipelines,
internal agent-workspace scripts and tools, and governance and process work. Release notes come from the closed
product issues in a release, not from the hierarchy, and the epics for product readiness and release management hold
both kinds. A blank Area is an error, caught at filing, at triage and afterwards (§ Triage and the Backlog).

Ruled 2026-11-03: devlore-cli's seven finer Area labels, architecture, CLI, code quality, error handling, git, meta and
testing, were deleted that day, and the hierarchy carries the distinctions they drew. Architecture work is a task or a
feature with product value within an epic. A bug is not filed against the architecture; an architecture task is
logged to address a bug in a feature.

## Four projects per team

Ruled 2026-11-03: each team, and each user account, has four projects: Triage, Backlog, one Schedule project and one
Scenario project. There is no longer a project per schedule or per scenario. Each is named for its kind first and its
team or account second: Triage: engprod, Backlog: devlore, Schedule: engprod and Scenario: devlore in an
organization, and Triage: David-Noble-at-work and its three siblings in the user account.

| | Triage | Backlog | Schedule | Scenario |
| --- | --- | --- | --- | --- |
| Holds | every issue, of any kind, until a triage decision is made | accepted work not yet scheduled | the team's committed tasks and bugs, and its Schedule issues | the team's features |
| Ordered by | nothing | priority | Step, within each schedule | Beat, within each scenario |
| Its fields | Status | not ruled | Schedule, Step, Iteration, Status and Worktree | Scenario, Beat and Status |
| Made from, in NobleFactor | the Triage template, project 23 | the Backlog template, project 24 | the Schedule template, project 7 | the Scenario template, project 8, formerly the Thread template |
| Made from, in David-Noble-at-work | its copy of the Triage template, project 4 | its copy of the Backlog template, project 5 | its copy of the Schedule template, project 1 | its copy of the Scenario template, project 2 |

A user account cannot mark a project as a template, so David-Noble-at-work keeps copies of NobleFactor's four
templates, and a new project there is copied from its copy (ruled 2026-11-03). A team's projects are copied from its
account's templates.

The projects that exist today, read from GitHub on 2026-11-03: each team's and the user account's, and the templates
and copies they are made from, by their number in their account. NobleFactor's templates and David-Noble-at-work's
copies are named for their kind alone, such as Backlog.

| Projects | Triage | Backlog | Schedule | Scenario | Repositories whose issues fill its Triage project |
| --- | --- | --- | --- | --- | --- |
| NobleFactor's templates | 23 | 24 | 7 | 8 | — |
| engprod's, in NobleFactor | 5 | 25 | 26 | 27 | noblefactor-engprod, .github |
| devlore's, in NobleFactor | 6 | 28 | 29 | 30 | devlore-cli, devlore-registry, devlore.noblefactor.com |
| David-Noble-at-work's copies of the templates | 4 | 5 | 1 | 2 | — |
| David-Noble-at-work's own | 3 | 6 | 7 | 8 | personal, .github |

Both `.github` repositories take part in triage from 2026-11-03, so the table lists seven repositories, and none of
them has `.github/workflows/triage.yml` yet ([section 4](4-storage-and-reach.md#triage)).

Triage: engprod and Triage: devlore were made on 2026-11-01, before the Triage template, and were brought to it on
2026-11-02. Triage: David-Noble-at-work was made on 2026-11-02, and the account's copy named Triage, its project 4, on
2026-11-03. Every open schedule and thread became a project of its own on 2026-11-01, NobleFactor projects 9 to 22;
they predate the ruling of 2026-11-03 that gives each team one Schedule project and one Scenario project. They were
closed on 2026-11-03, but that closing missed NobleFactor project 4, "Thread: the model follows a rename", a thread
project made on 2026-10-24 as a write test, which the owner closed on 2026-11-04
([this section's status](3-collections.status.md)).

- A collection is a project of one account, organization or user, made from one of that account's templates. Two
  test projects, made and deleted on 2026-10-20, showed that a project can be marked as a template and that GitHub
  lets a NobleFactor project hold personal's issues as rows. The model forbids the second (ruled 2026-11-02,
  § Collections belong to one account).
- A row is one issue. An issue's place in a collection is a field of its row, never a label on the issue.
- Issues are classified by issue type, in the hierarchy epic, feature, then task or bug. Enforcement is lax, and there
  are no compliance checks (ruled 2026-11-03). Issues we file ourselves go through `star github issue`, the one path
  that classifies an issue as it is made (ruled 2026-11-03).
- Who joins which project, the plan's question 10, is answered by the rulings of 2026-11-03: a schedule's rows are
  tasks and bugs, and a scenario's rows are features. Chore was retired on 2026-11-02, so Feature is the only level-1
  type. Both deltas from earlier practice are settled by the same rulings: the owner's note of 2026-10-20 let a
  schedule's row be any type, and the standard before the cutover made a thread's members leaves.

**The templates' fields.** A project made from a template has the template's fields. Each template's fields, their
options and the template's views are part of an account's model ([section 6](6-the-asset-and-its-sync.md); ruled
2026-11-03). Read from GitHub on 2026-11-03, the Triage template (NobleFactor project 23), the Backlog template
(project 24), the Schedule template (project 7) and the Scenario template (project 8) have these fields:

| Template | Field | Kind of field | Holds |
| --- | --- | --- | --- |
| Triage | Status | single select | the row's status, below |
| Triage | Area | an issue field | the issue's Area, held on the issue, not on the row |
| Backlog | Status | single select | the row's status, below |
| Backlog | Priority | an issue field | the issue's Priority, held on the issue, not on the row |
| Schedule | Status | single select | the row's status, below |
| Schedule | Step | number | the row's place in the order of its schedule's work; blank on a Schedule issue's own row |
| Schedule | Worktree | text | a link to the branch the step's work is on |
| Schedule | Iteration | GitHub's iteration field | the row's sprint, for scrums and sprint review |
| Schedule | Schedule | single select | the schedule the row belongs to: one option per schedule, named for its Schedule issue |
| Scenario | Status | single select | the row's status, below |
| Scenario | Beat | number | the row's place in the story its scenario tells |
| Scenario | Scenario | single select | the scenario the row belongs to: one option per scenario, named for its Scenario issue |
| every template | Repository, Assignees, Linked pull requests, Parent issue | GitHub's own | as GitHub keeps them |

In a user account's projects, the Labels column shows the `area:` and `priority:` labels where NobleFactor's show the
Area and Priority issue fields. Each template's Schedule or Scenario field has one option, a placeholder (§ The
Schedule and Scenario fields, below).

**The grouped views.** On 2026-11-03 every Schedule project got a second view, By schedule, and every Scenario
project a second view, By scenario, configured the same way in all ten, as read from GitHub that day: the Schedule and
Scenario templates (NobleFactor projects 7 and 8), engprod's Schedule and Scenario projects (26 and 27), devlore's (29
and 30), David-Noble-at-work's copies (its projects 1 and 2) and its own (its projects 7 and 8). Each is a table
grouped by the Schedule or Scenario field, with no sort, showing Title, Assignees, Status, Linked pull requests,
Sub-issues progress, and Step and Worktree in a Schedule project or Beat in a Scenario project. It is each project's
view 2; the view each had before, Default in a Schedule project and View 1 in a Scenario project, is unchanged.
GitHub's REST API made them, with `POST .../projectsV2/<number>/views`, which takes `group_by`. GitHub's GraphQL API
can set a view's name, layout, filter and visible fields, but not its grouping or its sort. The owner tried the views
and found that moving between the Default and By schedule tabs works well. In each of the 15 Schedule and Scenario
issues that have one, the line that names its project links this view (§ The collection's own record: a Schedule or
Scenario issue).

**Every project of a kind is configured the same way** (ruled 2026-11-03). That day all twenty projects were compared,
field by field, option by option and view by view: NobleFactor's four templates, engprod's four projects, devlore's
four, David-Noble-at-work's four copies and its four projects. Each now matches its kind's template in fields, Status
options, iteration settings, views, readme and built-in workflows. The one difference left is the one above:
David-Noble-at-work's Triage and Backlog projects have no Area or Priority column, since those are issue fields, which
a user account can't have, and its labels stand in for them ([section 2](2-attributes.md#labels-carry-no-values)); its
Triage projects' Missing Area view filters on the two area labels. None of the twenty links a repository. Compared
again on 2026-11-03, after the grouped views above were made, each still matches its kind's template
([this section's status](3-collections.status.md)).

Four changes made them match that day, each read back. The Triage template's readme went onto Triage: engprod,
Triage: devlore and Triage: David-Noble-at-work. The Schedule and Scenario templates' Status descriptions went onto
David-Noble-at-work's Schedule and Scenario projects and its Schedule and Scenario copies; each option kept its id, so
no row lost its Status. David-Noble-at-work's Backlog, Schedule and Scenario copies got the description its Triage copy
has, each naming its own kind: the Backlog copy's reads "David-Noble-at-work's copy of NobleFactor's Backlog template. A
user account can't have templates, so a Backlog project is copied from this one." Last, every built-in workflow the
twenty had was deleted, so none of them has one now (§ Triage and the Backlog).

## The Schedule and Scenario fields

Ruled 2026-11-03: a team's Schedule project holds every schedule the team has, and its Schedule field says which
schedule each row belongs to. The field has one option per schedule, named for that schedule's Schedule issue, which
holds the schedule's deliverable and exit criteria. Likewise a team's Scenario project holds every scenario the team
has, and its Scenario field has one option per scenario, named for that scenario's Scenario issue, which tells the
story.

GitHub won't make a single-select project field without at least one option (GitHub's GraphQL schema,
`CreateProjectV2FieldInput`). So a project's Schedule field comes with its first schedule, and its Scenario field with
its first scenario. On 2026-11-03, on the owner's order, a placeholder scenario was made in each account to give the
Scenario fields their first option: NobleFactor/noblefactor-engprod#442 for NobleFactor's Scenario template
(NobleFactor project 8), and David-Noble-at-work/personal#316 for Scenario: David-Noble-at-work (its project 8) and the
account's Scenario copy (its project 2). Each is titled "Scenario: placeholder", is of type Scenario (the label
scenario in personal), has Area Engineering, is open, and has no rows and no story. The option is named placeholder,
and its description names the issue. Later the same day, also on the owner's order, a placeholder schedule was made in
each account to give the Schedule template (NobleFactor project 7) and the account's Schedule copy (its project 1)
their Schedule fields: NobleFactor/noblefactor-engprod#443 and David-Noble-at-work/personal#319. Each is titled
"Schedule: placeholder", is of type Schedule (the label schedule in personal), has Area Engineering, is open, and has
no rows and no deliverable. Each field's one option, placeholder, names its issue. Schedule: David-Noble-at-work's
Schedule field came with its first schedule, David-Noble-at-work/personal#314 (§ Collections belong to one account).
So every Schedule and Scenario project, template and copy in both accounts has its field now (read from GitHub on
2026-11-03).

Ruled 2026-11-03: a feature stays open after its tasks and bugs are done. It closes only after an agent has audited it
for compliance and an agent has reviewed its code, with the team lead's sign-off.

- A schedule's work is numbered in steps, and steps are worked in step order within the schedule. Ruled 2026-11-02:
  every row of a schedule, other than the Schedule issue's own, gets its step number and its dependencies, GitHub
  blocked-by links, when it is added. A GitHub project has no number that counts by itself, so whoever adds a row
  sets its step; a working issue tracking system on GitHub comes first and tooling follows (ruled 2026-11-02). The
  audit reports a row with no step. The Lane field, numbered from the lane tables on 2026-11-01, was renamed Step on
  2026-11-02, so steps 1 to N are the old lane numbers. The plan's question 6.
- A Schedule issue's own row has no step (ruled 2026-11-02 and 2026-11-03): it tracks the schedule, with its exit
  criteria, and is not a step of its work.
- Beat orders a scenario's rows, its features, in the story the scenario tells (ruled 2026-11-03).
- GitHub's Iteration field gives each row of a Schedule project its sprint, for scrums and sprint review (ruled
  2026-11-03).
- A row is known by its issue and its step, never by the number a page shows: GitHub numbers the rows of a view by
  their place in that view, so the number changes with the view's filter and sort.
- The rows of every Schedule and Scenario project are kept in order: for each option of the Schedule or Scenario
  field, in the field's own order, the collection's own issue first, then its rows by Step or Beat, then any of its
  rows with neither; rows with no option come last. A view with no sort shows rows in that order, which GitHub's API
  sets with `updateProjectV2ItemPosition`. GitHub's GraphQL API can't set a view's sort or grouping; its REST API sets
  both only when it makes a view, and has no call that changes a view afterward (GitHub's REST documentation for
  project views, read 2026-11-04). The grouped views below were made with no sort. On 2026-11-03 Schedule: engprod's
  88 rows were put in that order and read back; read the same day, Schedule: devlore (145 rows), Scenario: engprod
  (19), Scenario: devlore (36) and Schedule: David-Noble-at-work (2) were already in it. A row added later has to be
  placed in order when it is added.
- A closed step keeps its number, as today.
- One issue in two live collections, the plan's question 9. The owner had doubts about it on 2026-10-20. A project
  holds an issue as one row, and a single-select field holds one value, so within a team's Schedule or Scenario
  project a row belongs to one schedule or one scenario. How an issue is kept in one project at a time is open, in
  § Triage and the Backlog.
- Schedules have no Next column. It was deleted from the Schedule template and every schedule on 2026-11-02.
  The `model.yaml` beside the extension predates the cutover and still shows it.
- A schedule's Worktree column was ruled 2026-11-03. Each step's row links the branch its work is on, and the step's
  own issue records that the work merged or closed. The column holds a link to the branch on GitHub, so the branch is
  pushed before its row links it: a link to a branch GitHub does not have leads nowhere. Found 2026-11-03: the row of
  the issue data model design (#303) on Schedule: engprod had no Worktree link, though its worktree, on the branch
  `doc/303-model-cutover`, had been open since that day, and the branch had not yet been pushed. The worktree's script,
  `~/Workspace/NobleFactor/noblefactor-engprod.303-model-cutover.bash`, ran on 2026-11-03, and each of its four steps
  read back. It pushed the branch, which is on GitHub at `60828ac`, and linked it in the row's Worktree column, and the
  row has read back the link since. Rule 19 of [agent-rules.md](../../guides/agent-rules.md) records this as the
  rule's second breakage, with its fix.
- Status is a field on a project row, and anyone may set it (ruled 2026-11-03). None of the twenty projects of
  § Four projects per team has a built-in workflow, such as the one that can mark a row Done when its issue closes:
  GitHub's API can't make one, so every project of a kind matches only with none (§ Triage and the Backlog). Closed is
  not done: every issue states its evidence of completion (ruled 2026-11-02), and an issue is done when that evidence
  is met. Step 13 of #301 closed on 2026-10-20 with two hosts not migrated. The plan's question 7 is settled by the
  ruling of 2026-11-03, not by its proposal.

**Waits on** is not a field. GitHub links issues with blocked-by and blocking (the API's `Issue` type, 2026-10-21), and
a step that waits on another is an issue blocked by another. The link crosses repositories and owners: 75 such links
were made on 2026-11-01 ([section 4](4-storage-and-reach.md) § Where each part lives). The model keeps it within one
account (ruled 2026-11-02). A step may wait on an issue in any repository of its own account; a step that waits on
another account's work is blocked by a stand-in issue in its own account.

## Triage and the Backlog

Ruled 2026-10-21: the Triage project takes an issue of any type, or of none. Ruled 2026-10-22: teams triage their own
issues, so there is one Triage project per team, and a team's queue is what its own repositories log. A user account
has no teams and owns its own Triage project (ruled 2026-11-02 and 2026-11-03). A Triage project has no order field,
and its order is nobody's commitment. It has no issue of its own: there is no triage epic and no Triage issue type.

**How a new issue arrives.** Ruled 2026-11-03: a GitHub Actions workflow in each repository adds a new issue to its
team's Triage project when the issue is opened or transferred, using `actions/add-to-project`. GitHub's built-in
auto-add workflow is not used. Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project, taken
from the team mapping: the team with the maintain role on a repository owns it. A Triage workflow template in each
account's `.github` repository offers the workflow ([section 6](6-the-asset-and-its-sync.md) § One model per account).
GitHub's documentation describes workflow templates in an organization's `.github` repository and says nothing about a
user account's, and whether GitHub offers David-Noble-at-work/.github's template to personal has not been checked;
either way, David-Noble-at-work/personal#315 copies personal's `triage.yml` from it. How the workflow signs in, with a
token from the noblefactor-automation GitHub App in NobleFactor and a classic personal access token in a user account,
is in [section 4](4-storage-and-reach.md) § Triage.

Every project of a kind is configured the same way (ruled 2026-11-03; § Four projects per team), and GitHub's GraphQL
API can delete a project's built-in workflow, with `deleteProjectV2Workflow`, but has no call that makes one or turns
one on, so the only state every project can share is none. Every built-in workflow the twenty projects had was deleted
on 2026-11-03: Triage: engprod's "Auto-add to project" and "Auto-add sub-issues to project", Triage: devlore's
"Auto-add sub-issues to project", and the five each of the Schedule and Scenario templates, "Auto-close issue",
"Item added to project", "Item closed", "Pull request linked to issue" and "Pull request merged". All were off but
devlore's. Read back through GitHub's GraphQL API (`ProjectV2.workflows`) the same day, none of the twenty has a
built-in workflow now. That settles a question that was open: whether "Auto-add sub-issues to project", on in Triage:
devlore until then, was one of the built-in workflows the ruling of 2026-11-03 on the Triage workflow leaves unused.
Under the ruling that every project of a kind is configured the same way, it was deleted with the rest.

Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an organization,
or when it has the topic issue-model, in a user account.

**The triage decision.** Ruled 2026-11-03: every issue is reviewed in the Triage project, and a triage decision is
made. Either the work is declined, and the issue is closed as completed with its Resolution issue field set to
Declined in NobleFactor, or with the `resolution:declined` label in a user account; or the issue moves to its team's
Backlog, Schedule or Scenario project. The Backlog holds accepted work not yet scheduled, ordered by priority. The
Schedule project takes committed tasks and bugs, each with its schedule and its step. The Scenario project takes
features, each with its scenario and its beat.

**A blank Area is an error.** Ruled 2026-11-03: an issue without an Area is caught at three points. At filing,
`star github issue` refuses an issue without an Area, and the issue forms in each account's `.github` repository
([section 6](6-the-asset-and-its-sync.md) § One model per account) have a required Area dropdown, whose answer the
Triage workflow copies into the Area field or label when the issue is opened. At triage, each Triage project shows the
Area column (in a user account, the `area:` labels in its Labels column) and has a view named Missing Area, both made
2026-11-03, and nothing leaves Triage without an Area. Afterwards, a scheduled sweep returns any open issue without an
Area to its team's Triage project.

Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time.

Read from GitHub on 2026-11-03: the issue data model design (#303) is a row of Schedule: engprod and also of Triage:
engprod, where its Status is Open. It is one issue in two of its team's projects at once, which is the case the open
question on keeping an issue in one project at a time is about.

GitHub Actions cannot run a workflow when a project row changes. `projects_v2_item` is a webhook event for
organization webhooks and GitHub Apps only, so no repository workflow runs when a row's field changes or a row is
added to or removed from a project.

Like every issue, an issue in the Backlog carries Priority: an issue field in NobleFactor, the priority: label in
David-Noble-at-work (ruled 2026-11-03).

Ruled 2026-11-03: an account's model holds its issue fields, as it holds its issue types and labels. NobleFactor's
issue fields are Priority, Effort, Start date, Target date, Resolution, Area and Severity; its Start date field stays
unused. A user account has no issue fields, and a label stands in for each single-select one
([section 2](2-attributes.md#labels-carry-no-values)).

**There is no triage epic.** Ruled 2026-10-22, and superseded on 2026-11-03: a triage epic, #142, was to be the first
row of engprod's Triage project, and each newly logged issue was to be filed as its sub-issue until triage found the
issue's place. Ruled 2026-11-03: the triage epics #142, NobleFactor/devlore-cli#1188 and
David-Noble-at-work/personal#313 are retired, and their 24 open sub-issues are rows of their Triage projects. A new
issue becomes a row of its team's Triage project, not a sub-issue of an epic.

## The collection's own record: a Schedule or Scenario issue

Ruled 2026-10-22: a schedule's status is kept on its own issue, and its work is its rows. The
schedule's own issue lets owners, participants, reviewers and casual observers see where the schedule stands.

Before the cutover a schedule's issue held three things: its deliverable, its table of steps and the owner's
amendments. Its steps became project rows on 2026-11-01.

Ruled 2026-11-03: the old scheme's last three pieces are retired, and the retirement is done in GitHub. The parent
markers such as **Feature:** and the schedule footers came out of 725 issue bodies, and 47 issues got the sub-issue
parent their marker named; where a marker and an issue's sub-issue link disagreed, the link stands. The step and beat
tables in 14 Schedule and Scenario issues gave way to a line naming the issue's project and its option there. The kind
labels epic, feature, task and bug left NobleFactor's 12 repositories, after 672 issues got the issue type their label
named. David-Noble-at-work keeps its type labels, which are its types.

On 2026-11-03 the line in each of the 15 Schedule and Scenario issues that names its project,
`The steps are on [<project>](...), under Schedule "<option>"` or `The beats are on ...`, was changed to link that
project's view 2 (§ Four projects per team), filtered to the issue's own option:
`<project URL>/views/2?filterQuery=schedule%3A%22<option>%22`, with `scenario%3A` in a Scenario issue. Each body was
read back, and the owner opened #346's link and found it good. The 15 are NobleFactor/noblefactor-engprod#206, #232,
#301, #346 and #152; NobleFactor/devlore-cli#887, #894, #916, #949, #1127, #806, #891, #892 and #893; and
David-Noble-at-work/personal#314. The four placeholder issues (§ The Schedule and Scenario fields) have no such line.
A new Schedule or Scenario issue gets the same line, linked the same way, when its option is made.

The deliverable, the rulings and the status need a home that keeps them, and it is **the collection's own issue**: its
body keeps the deliverable and the exit criteria, which are its evidence of completion (ruled 2026-11-02), along with
the amendments and the owner's full status, under GitHub's edit history; its assignee is the collection's owner; the
work is the steps, from 1 on; and a session stays keyed by it, which is how Start-Claude's store and
star-github-schedule-assignment find a schedule today. The project's README was the other candidate, and sessions
would have had to be keyed by the project instead.

**The collection's own issue is typed Schedule or Scenario.** Ruled 2026-11-03: the issue that describes a schedule,
with its deliverable and exit criteria, has the issue type Schedule, and the issue that describes a scenario, which
tells its story, has the type Scenario. In a user account they carry the labels schedule and scenario. The two types'
descriptions begin "Collection:", where the hierarchy's types begin "Level N:". Each has an issue form in its account's
`.github` repository: read from GitHub on 2026-11-03, NobleFactor/.github and David-Noble-at-work/.github each hold six
issue forms, one for each type ([section 6](6-the-asset-and-its-sync.md) § One model per account). NobleFactor/.github
gets a quality-gate check of its own, so that it follows the organization's ruleset like every other repository (ruled
2026-11-03), and it holds `.github/workflows/quality-gate.yml`. Like every issue, a Schedule or Scenario issue carries
Priority and Area: issue fields in NobleFactor, the priority: and area: labels in David-Noble-at-work (ruled
2026-11-03). A Triage project has no issue of its own.

On 2026-10-22 the collection's own issue was ruled an Epic, and the ruling of 2026-11-03 supersedes it. The Schedule
type was ruled out then because the hierarchy had no level for it, and it is now the ruling. Chore, the other type
weighed, was retired on 2026-11-02. The Triage project's own issue was to be the triage epic #142, which is retired.

So an epic means one thing: level 0, with features as its sub-issues. The rows of a schedule or a scenario are not
sub-issues of its Schedule or Scenario issue: each row keeps its own parent, and the project's Schedule or Scenario
field is what joins them. The plan's questions 5 and 3, answered again by the rulings of 2026-11-03.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

The schedule is two records, its rulings on its own issue and its rows in its team's Schedule project, and one ruling
can change both. How the two are kept together when a row is added to a committed schedule is the plan's question 8,
below. A working issue tracking system on GitHub comes first, and tooling follows (ruled 2026-11-02), so
`star gh schedule add`, filed as #438, comes later.

## Ownership

Ruled 2026-10-21: schedules are owned by individuals and by teams. Three GitHub entities are involved and each can
hold one part, ruled 2026-10-22 for a team's Triage project and holding for every project of an organization:

- **The project belongs to its account, and its team answers for it.** GitHub has no team-owned project; an
  organization project has collaborators, and a team is one with the Admin, Write or Read role. A team holds Admin on
  its Triage project (ruled 2026-10-22). Ruled 2026-11-03: the team that owns a project is accountable for it, and
  GitHub's link between the project and its team is the record. A user account has no teams, and its projects are
  its owner's, Triage: David-Noble-at-work among them.
- **A Schedule or Scenario issue is assigned to a person.** GitHub assigns issues to user accounts, never to teams, so
  the one on the hook for a schedule or a scenario is the assignee of its Schedule or Scenario issue; in a user
  account, that is the account itself. If the owner changes, the project's role stays and the assignee moves, one
  edit.
- **The team holds the maintain role on the repositories it owns** (ruled 2026-11-03), and those repositories' new
  issues fill its Triage project. GitHub's maintain role includes everything the triage role allows, so the team's
  members can type, parent and label issues there. This holds in an organization; a user account has no teams.

The owner is on every team and the maintainer of each today.

## Collections belong to one account

Ruled 2026-11-02 ([section 4](4-storage-and-reach.md) § Accounts). Each account, organization or user, has its own
data model. A collection is a project of one account, and its rows are issues of that account's repositories only. No
project, sub-issue link or blocked-by link crosses accounts; work that waits on another account uses a stand-in issue
in its own account. An organization's projects hold no issue from an individual's repository, and an individual
account keeps its own four projects, Triage: David-Noble-at-work (David-Noble-at-work project 3) among them. Built
2026-11-01, before the ruling, NobleFactor's projects hold personal's issues as rows. Two issues take them out:
personal's steps move to schedules in Schedule: David-Noble-at-work, one for each NobleFactor schedule they came from
(David-Noble-at-work/personal#309), and NobleFactor's records keep nothing of personal's (noblefactor-engprod#428).
Ruled 2026-11-03: David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's steps go
on them. Its first schedule, issue tracking, iteration 1 (David-Noble-at-work/personal#314), is the first option of
the Schedule field on Schedule: David-Noble-at-work (its project 7), and David-Noble-at-work/personal#315, the task
that adds personal's Triage workflow, is its step 1 ([section 4](4-storage-and-reach.md#the-rest-of-the-ruling)).
Scenario: David-Noble-at-work's Scenario field has only the placeholder option (§ The Schedule and Scenario fields).

## A committed schedule

Today a committed schedule takes no new step except by the owner's amendment
([issue-standards.md](../../issue-standards.md) § What a schedule commits to). A project takes a new row from anyone
with write access. Proposed: the rule stands, and a row is added with its amendment. The plan's question 8.
