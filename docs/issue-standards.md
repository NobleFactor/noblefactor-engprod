---
title: "Issue Standards"
type: Process
status: Approved
---

# Issue Standards

Each account has its own data model: NobleFactor, an organization, and David-Noble-at-work, a user
account. Every issue has one **type**, and the types form a hierarchy. In an organization the type is
GitHub's issue type (Epic, Feature, Task, Bug). In a user account it is the lowercase label of the same
name (`epic`, `feature`, `task`, `bug`). The record is GitHub's: issue types, sub-issue links and project
rows. Every issue is reviewed in its team's Triage project, where a triage decision is made (§ What has
no parent). Ruled 2026-11-03: issues are classified by issue type, in the hierarchy epic, feature, then
task or bug; enforcement is lax, and there are no compliance checks. Ruled 2026-11-02: a working issue
tracking system on GitHub comes first, and the tooling follows the record.

This document is to issues what [documentation-standards.md](documentation-standards.md) is to
documents — the schema a person applies when filing. The two are
read alongside [guides/development-process.md](guides/development-process.md), which owns how work
is organized once an issue exists.

**Each account's model** is a YAML description of that account's data model: its issue types (its type
labels, in a user account), its issue fields, the labels of each of its repositories, its teams, and its
project templates with their custom fields, options and views. It leaves out issues and the projects made
from templates. It leaves out a project's built-in workflows, and no template or copy, and none of each
team's and the user account's four projects, has had one since 2026-11-03: GitHub's API can delete a
built-in workflow but has no call that makes one or turns one on, so the only state every project of a
kind can share is none (§ Three ways to slice the work). It leaves
out an organization's default labels, because labels are held per repository. The model is a cache: star
queries it instead of asking GitHub the same questions again, and builds its queries and updates from it.
Ruled 2026-11-03.

Ruled 2026-11-03: an account's model holds its issue fields, as it holds its issue types and labels.
NobleFactor's issue fields are Priority, Effort, Target date, Resolution, Area and Severity; its Start
date field stays unused. A user account has no issue fields, so its model holds none, and labels stand in
for the single-select ones (§ Triage classifies, and adds attributes).

Each account's model is stored in that account's `.github` repository,
[NobleFactor/.github](https://github.com/NobleFactor/.github) or
[David-Noble-at-work/.github](https://github.com/David-Noble-at-work/.github). GitHub treats a public
repository named `.github` as the account's own, and serves its default community health files and issue
templates to every repository of the account. Ruled 2026-11-02. The design is
[architecture/issue-data-model/index.md](architecture/issue-data-model/index.md).

Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull
request template, are stored in its `.github` repository too, and every document that talks about one of them refers to
it there ([section 6](architecture/issue-data-model/6-the-asset-and-its-sync.md#one-model-per-account) of the design).

## The types

Ruled 2026-10-21: chore became a peer of feature, the two mutually exclusive, and the hierarchy became
epic, then chore or feature, then bug or task. Before that day a chore was a tier-three leaf under an
enabler feature of `Epic:Ops:Process`.

Ruled 2026-11-02, replacing that: Chore is retired. The hierarchy is Epic (level 0), then Feature
(level 1), then Task or Bug (level 2), and the chore label is gone from every repository in both
accounts. The record was relabeled the same day: chores became tasks, and chores with tasks and bugs of
their own became features. Ruled 2026-11-03: the `chore/` branch type is removed from the branch ruleset
and from `git open-branch`; the plans already filed under `docs/plans/chore/` stay where they are.

| Level | Type | What it is |
| --- | --- | --- |
| 0 | Epic | A body of work spanning several features |
| 1 | Feature | A body of work, for the product or for engineering; the unit an epic is decomposed into |
| 2 | Task | Work that **implements part of** a feature |
| 2 | Bug | Work that **repairs** a feature |

Type names are capitalized, as GitHub's issue types are. In a user account, which has no issue types,
each type is the lowercase label of the same name: `epic`, `feature`, `task`, `bug`. Ruled 2026-11-03.

**Two more types describe collections.** An issue of type Schedule describes a schedule, and an issue of
type Scenario describes a scenario (§ Three ways to slice the work); in a user account they are the labels
`schedule` and `scenario`. The hierarchy types' descriptions begin "Level N:"; the collection types'
descriptions begin "Collection:". Each has an issue form in its account's `.github` repository. Ruled
2026-11-03. The same day, threads were renamed scenarios: the issue type Thread is now Scenario, the label
`thread` is now `scenario`, the Thread template is the Scenario template, and a thread project is a
scenario.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

**Level 1 is the feature.** A feature is the body of work an epic decomposes into, for the product or for
engineering, with its tasks and bugs under it. A body of process or tooling work is a feature like any
other: it sits under the epic it serves, with its tasks and bugs under it.

**Area tells engineering work from product work.** Ruled 2026-11-03: Area has two values only, product and
engineering. In NobleFactor they are the options Product and Engineering of the Area issue field, made
2026-11-03; in a user account they are the labels `area:product` and `area:engineering`. Area applies to
issues of every type and describes the issue's own work, so an epic, a feature and the tasks and bugs
under them can each have a different Area: a CI bug fixed during a product feature is engineering.
Engineering covers build orchestration, Makefile changes, CI pipelines, the scripts and tools of the
internal agent workspace, and governance and process work. Epics for product readiness and for release
management hold both kinds. Release notes come from the closed product issues in a release, not from the
hierarchy.

Ruled 2026-11-03: devlore-cli's seven finer Area labels (architecture, CLI, code quality, error handling,
git, meta and testing) are gone, deleted that day. The hierarchy carries those distinctions. Architecture
work is a task, or a feature with product value, within an epic. A bug is not filed against the
architecture; an architecture task is filed to address a bug in a feature.

**Level 2 is the leaf**, a Task or a Bug: what a pull request closes, and what a schedule's steps are.
"Step" names a schedule's row (§ Schedules), so a leaf on no schedule is not a step. An epic or a feature
is never a step: a feature closes when its tasks and bugs do, and an epic when its features do.

Task and Bug are peers and **mutually exclusive**. In an organization an issue has one issue type, so it
cannot be both. In a user account an issue can carry both labels, `task` and `bug`, and today the audit
names it. The question that separates them is not difficulty or size: does this build something the
feature did not have, or restore something it was supposed to have already?

Tidying code the product ships is a task under the feature that owns that code, or a bug if the tidying
repairs something. The scheme has no *story*. Where scrum-based writing says story, this scheme says
task.

## Placement

**No issue carries an epic label.** Every Feature, Task and Bug has exactly one parent, one level up,
held as GitHub's sub-issue link, and its epic is read up those links. An epic has no parent. Ruled
2026-11-03: the `Epic:` and `Thread:` labels are removed from both accounts, and sub-issue parent links
and project rows replace them. The `ClaudeJudgmentError:` labels are removed too.

**A parent may sit in another repository of the same account, never in another account.** Features
cross repository boundaries within an account. No project, sub-issue link or blocked-by link crosses
accounts: work that waits on another account's issue is tracked by a stand-in issue in its own account
that names the other issue. Ruled 2026-11-02.

A task or a bug with no parent is not unfiled. It is unclassified, and it waits in its team's Triage
project (§ What has no parent).

**The parent markers are retired.** Under the old scheme a task's or a bug's parent was also written in
its body, as the last `**Feature:** #<number>`, or `**Feature:** owner/repo#<number>` when the parent
lived in another repository of the account, conventionally in the closing metadata line
`**Epic:** #N · **Feature:** #M`, and the report read it from there. The `**Chore:**` marker went with
Chore. Ruled 2026-11-03, and done in GitHub the same day: the parent markers and schedule footers came
out of 725 issue bodies, and 47 issues got the sub-issue parent their marker named. Where a marker and a
sub-issue link disagreed, the link stands.

### What has no parent

**An epic has no parent**, because it is level 0.

**A Schedule or a Scenario issue describes a collection**, not a body of work:

- **A scenario issue** has the issue type Scenario (the label `scenario`, in a user account). It tells the
  story of its scenario, whose features are the rows of its team's Scenario project that carry the
  scenario's option in their Scenario field (§ Scenarios). It carries no `Thread:<Name>` label: those
  labels were removed, and the project's rows replace them.
- **A schedule issue** has the issue type Schedule (the label `schedule`, in a user account). It holds
  its schedule's deliverable and exit criteria. The schedule's tasks and bugs are the rows of its team's
  Schedule project that carry the schedule's option in their Schedule field (§ Schedules). The order of
  execution is the rows' steps, not the issue.

Each is placed by its type, so nothing goes unplaced; the one-epic rule is now the one-parent rule, with
a work item's epic read up its sub-issue links.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

Ruled 2026-09-05, under the label scheme: a thread issue, now a scenario issue, carried no `Epic:` label,
because a scenario has no owner. Before that day a thread issue carried the epic that most owned its
scenario, a fiction the rule imposed.

**Every issue is reviewed in its team's Triage project**, and a triage decision is made there. Not only a
bug: a new issue of any type, or of none, goes into its team's Triage project. The decision either
declines the work or moves the issue to the team's Backlog, Schedule or Scenario project. Declined work
is closed as completed, with Resolution Declined in NobleFactor or the `resolution:declined` label in
David-Noble-at-work (§ The labels a repository provides). That project is the triage queue, and today the
audit exempts an issue while it waits there. Each team owns its Triage project: Triage: engprod
(NobleFactor project 5) and Triage: devlore (NobleFactor project 6). The user account owns its own,
Triage: David-Noble-at-work (David-Noble-at-work project 3). There is no triage epic and no Triage issue
type. The triage epics NobleFactor/noblefactor-engprod#142, NobleFactor/devlore-cli#1188 and
David-Noble-at-work/personal#313 are retired. Ruled 2026-11-03.

**A new issue reaches its team's Triage project through a GitHub Actions workflow** in its repository, run
when an issue is opened or transferred, using `actions/add-to-project`. GitHub's built-in auto-add
workflow is not used. Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project,
from the team mapping: the team with the maintain role on a repository owns it. A Triage workflow template
in each account's `.github` repository offers the workflow. Ruled 2026-11-03. GitHub's documentation
describes workflow templates kept in an organization's `.github` repository and says nothing about a user
account's; whether GitHub offers David-Noble-at-work/.github's template to personal has not been checked,
and either way the task that adds personal's Triage workflow, David-Noble-at-work/personal#315, copies
personal's `triage.yml` from it. How the workflow signs in, with a token from the noblefactor-automation
GitHub App in NobleFactor and a classic personal access token in a user account, is
[section 4](architecture/issue-data-model/4-storage-and-reach.md#triage) of the design.

**The team that owns a project is accountable for it**, and GitHub's link between the project and its
team is the record. A user account's projects are its owner's. Ruled 2026-11-03.

**Issues we file ourselves go through `star github issue`**, the one path that classifies an issue as it
is made. Ruled 2026-11-03.

**A blank Area is an error, caught at three points.** Ruled 2026-11-03. At filing, `star github issue`
refuses an issue without an Area, and the issue forms in each account's `.github` repository have a
required Area dropdown, whose answer the Triage workflow copies into the Area field or label when the
issue is opened. At triage, each Triage project shows the Area column (in a user account, the `area:`
labels in its Labels column) and has a "Missing Area" view, both made 2026-11-03, and nothing leaves
Triage without an Area. Afterwards, a scheduled sweep returns any open issue without an Area to its team's
Triage project.

GitHub Actions cannot run a workflow when a project row changes: `projects_v2_item` is a webhook event for
organization webhooks and GitHub Apps only.

Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project
at a time.

## Three ways to slice the work

The same issues are read three ways, and the three are **peers** — none is above another, and none
is an exception to another. Two more projects hold what is in none of them yet: each team's Triage
project holds the issues awaiting a triage decision, and its Backlog project holds accepted work not yet
scheduled, ordered by priority. No label names a member of any of them.

| | Answers | Where it is held | Its organizing issue |
| --- | --- | --- | --- |
| **Epic** | who **owns** this | the sub-issue links, read up from each work item | the epic, type Epic |
| **Scenario** | what **scenario** this serves | the team's Scenario project, by its Scenario field | an issue of type Scenario |
| **Schedule** | in what **order** we execute | the team's Schedule project, by its Schedule field and steps | an issue of type Schedule |
| **Backlog** | what is **accepted** and not yet scheduled | the team's Backlog project, ordered by priority | none |
| **Triage** | what **awaits** a triage decision | the team's Triage project | none |

**Each team, and each user account, has four projects:** Triage, Backlog, one Schedule project and one
Scenario project. In an organization each is named for its kind and its team, as Triage: engprod, Backlog:
devlore, Schedule: engprod and Scenario: devlore. In the user account each is named for its kind and the
account, as Schedule: David-Noble-at-work. There is no longer a project per schedule or per scenario.
Ruled 2026-11-03.

NobleFactor keeps a project template for each kind: Triage (project 23), Backlog (project 24), Schedule
(project 7) and Scenario (project 8, the former Thread template). A user account cannot mark a project as
a template, so David-Noble-at-work keeps copies of them: Schedule (its project 1), Scenario (its project
2, the former copy named Thread), Triage (its project 4) and Backlog (its project 5). A team's projects
are copied from these. A project template's description says nothing about star. Ruled 2026-11-03.

Ruled 2026-11-03: every project of a kind is configured the same way, and that day each of these templates, copies
and projects was compared with its kind's template and now matches it, as far as a user account allows, with
every built-in workflow among them deleted
([section 3](architecture/issue-data-model/3-collections.md#four-projects-per-team) of the design).

A work item (a feature, a task or a bug) rolls up to exactly one epic through its parent links. A feature
may be a row of its team's Scenario project (§ Scenarios), and a task or a bug a row of its team's
Schedule project (§ Schedules). Today the report renders each slice as `--by epic`, `--by thread` and
`--by schedule`; its thread slice is the scenario slice under its old name.

## Scenarios

**A scenario is a narrative, a use case, and it exists to carry cross-cutting feature development.** Its
beats are the moments of a story a person could tell, and its parts land wherever the machinery lives:
usually several epics, often several repositories. Ruled 2026-11-03: threads are renamed scenarios.

**A team's Scenario project holds its features.** It is made from NobleFactor's Scenario template (project
8), or in David-Noble-at-work copied from its copy of that template (its project 2). A single-select
Scenario field names the scenario each row belongs to: one option per scenario, named for its Scenario
issue, which tells the story. Beat orders the rows within a scenario. A scenario's rows are features.
There is no longer a project per scenario. Ruled 2026-11-03. A scenario is a collection beside the
hierarchy, not a label family and not a level:

| | An epic | A scenario |
| --- | --- | --- |
| Answers | which body of work **owns** this | which scenario this **serves** |
| Its members | its features, then their tasks and bugs | features, as beats |
| Held as | sub-issue links | the team's Scenario project, by its Scenario field |
| Crosses repositories | yes, within its account | yes, within its account, by design |
| Crosses accounts | no | no |
| Closes when | the work ships | the scenario works end to end |

Neither crosses accounts, because no project or link spans two. A feature keeps its type and its parent
and becomes a row of its team's Scenario project, with the scenario's option in its Scenario field. It
gains no label, and nothing about the hierarchy changes.

**When to open one.** The test: *would moving this work into one epic take issues away from the epic
that owns their machinery?* If yes, it is a scenario. The scenario writ origin, in which a deployment says
where it came from, needs a codec fix, a schema addition, a layer registration and a drift report — four
owners, one scenario. Minting an epic for it would have stripped each from the epic that owns it.

**The scenario issue** has the issue type Scenario (the label `scenario`, in a user account) and carries
no `Thread:<Name>` label (§ What has no parent). Its scenario's option in the Scenario field is named for
it, and its account's `.github` repository holds an issue form for it. Its body tells the story. **The
order is the story's; the ownership is the epics'.** Beats are not filed in the order they execute, so
issue numbers do not give the order; Beat does.

Its type tells the scenario issue apart from its members, which share no label with it. Today the report
still finds a scenario issue by its title beginning `Thread:`. Under the old scheme it read the order from a
beat table in the scenario issue's body. Ruled 2026-11-03, and done in GitHub the same day: the step and
beat tables in 14 Schedule and Scenario issues gave way to a line naming the issue's board and option.
Since 2026-11-03 that line links the issue's own rows (§ Schedules).

**What the audit checks.** A scenario's members are the rows of its team's Scenario project with its
option in their Scenario field, so no label has to agree with a table. There are no compliance checks
(§ Well classified), and whether a story is fully told is a judgment. Today `star github schedule audit
--unthreaded` lists open work in no thread as a question rather than a fault; it still reads the removed
`Thread:` labels until the tooling follows.

## Schedules

**A team's Schedule project holds its committed tasks and bugs.** It is made from NobleFactor's Schedule
template (project 7), or in David-Noble-at-work copied from its copy of that template (its project 1). A
single-select Schedule field names the schedule each row belongs to: one option per schedule, named for
its Schedule issue, which holds that schedule's deliverable and exit criteria. Step orders the rows within
a schedule, in the order someone has committed to working them. GitHub's Iteration field gives each row
its sprint, for scrums and sprint review. There is no longer a project per schedule. Ruled 2026-11-03. A
schedule answers *what is being executed, in what order, and what is next* — which neither an epic
(ownership) nor a scenario (story) can express, because both are about what work *is* rather than when
it will be done.

**A Schedule issue's own row has no step.** Every other row gets its step number and its dependencies,
GitHub blocked-by links, when it is added. Ruled 2026-11-02, when "lane" became "step".

Its steps are **leaves**: tasks and bugs, from any epic and any feature, in any repository of the
schedule's own account. They never come from another account, because no project spans two; a step that
waits on another account's issue is blocked by a stand-in issue in its own account. An epic or a feature
as a step is a fault, not a shorthand.

| | An epic | A scenario | A schedule |
| --- | --- | --- | --- |
| Answers | which body of work **owns** this | which scenario this **serves** | in what **order** we execute |
| Its members | its features, then their tasks and bugs | features, as beats (§ Scenarios) | tasks and bugs, as steps |
| Held as | sub-issue links | the team's Scenario project, by its Scenario field | the team's Schedule project, by its Schedule field |
| Its organizing issue | the epic, type Epic | an issue of type Scenario | type Schedule, its own row having no step |

**The schedule issue** has the issue type Schedule (the label `schedule`, in a user account). It is not a
chore. It holds its schedule's deliverable and exit criteria (§ What has no parent), its schedule's
option in the Schedule field is named for it, and its account's `.github` repository holds an issue form
for it. The steps are the rows with that option, with their step numbers. Today the report still finds a
schedule issue by its title beginning `Schedule:`. Under the old scheme it read the steps from a step table
in the schedule issue's body. Ruled 2026-11-03, and done in GitHub the same day: those tables gave way to a
line naming the issue's board and option (§ Scenarios).

On 2026-11-03 that line, `The steps are on [<project>](...), under Schedule "<option>"` or, in a Scenario issue,
`The beats are on ...`, was changed in each of the 15 Schedule and Scenario issues that has it to link its project's
view 2, filtered to the issue's own option: `<project URL>/views/2?filterQuery=schedule%3A%22<option>%22`, with
`scenario%3A` in a Scenario issue. View 2 is "By schedule" or "By scenario", which groups the rows by the Schedule or
Scenario field ([section 3](architecture/issue-data-model/3-collections.md#four-projects-per-team) of the design).
Each body was read back, and the owner opened #346's link and found it good. The 15 are
NobleFactor/noblefactor-engprod#206, #232, #301, #346 and #152; NobleFactor/devlore-cli#887, #894, #916, #949, #1127,
#806, #891, #892 and #893; and David-Noble-at-work/personal#314. The four placeholder issues,
NobleFactor/noblefactor-engprod#442 and #443 and David-Noble-at-work/personal#316 and #319, made only to give a
Schedule or Scenario field its first option
([section 3](architecture/issue-data-model/3-collections.md#the-schedule-and-scenario-fields) of the design), have no
such line. A new Schedule or Scenario issue gets the same line, linked the same way, when its option is made.

**Within a schedule, steps are numbered 1..N with no gaps, a closed step keeps its number, and steps are
worked in step order.** Whoever adds a step gives it its step number and its blocked-by links when it is added. Progress
shows in the project's rows as steps close. A row added to a Schedule or Scenario project has to be placed, when it
is added, in the order the project's rows are kept in
([section 3](architecture/issue-data-model/3-collections.md#the-schedule-and-scenario-fields) of the design).

**Schedules have no Next column.** Ruled 2026-11-02: it was deleted from the Schedule template and from
every schedule project. A step's state shows in its row's Status, a field on a project row that anyone may
set. Ruled 2026-11-03: a Schedule project has a Worktree column, and each step's row holds a link to the
branch its work is on; the step's own issue records that it merged or closed. This replaces the 2026-10-05 ruling
(#257) that a lane in progress named its worktree in its Next column.

### What a schedule commits to

A schedule is a commitment, not a proposal:

- **Steps are worked in step order,** each after the steps its blocked-by links name. One pull request
  may close several steps.
- **No step is split, and none is added, once the schedule is committed.** The owner may amend the
  deliverable; whoever is executing it may not. A step added by the owner's amendment gets its step number
  and its blocked-by links when it is added. Discovering that a step must be split is a planning failure,
  not a discovery — the steps were not understood before they were committed to.
- **Work found along the way does not join a running schedule.** It is filed as a task or a bug and goes
  into its team's Triage project until a triage decision is made. After that it may become a step of a
  later schedule.

### The deliverable

**The schedule's issue, of type Schedule, states its deliverable as before → after** — what the owner has
today, and what they will have when the last step closes — and its exit criteria, which are its evidence
of completion. The steps are how it is delivered; the deliverable is what was promised.

If delivering it turns out to need something outside the steps, **the deliverable has changed**: stop, say
so, and replan together. That is the moment a schedule is allowed to change, and the only one.

### What the audit checks

A schedule's members are the rows of its team's Schedule project with its option in their Schedule
field, and an epic's members are found down its sub-issue links, not by label. There are no compliance
checks (§ Well classified). Under the old scheme `star github schedule report --by schedule` read the
schedule issue's step table and rendered each step's state; that table is gone (§ Schedules). What the
audit compares against is decided with the tooling, #426 and #437.

## What an empty level means

A level with nothing under it is one of two things, and a report that renders it blank says neither —
blank reads as an error whichever cause it has. The states are named:

| Level | With nothing under it, it is |
| --- | --- |
| An epic with no features | **ill-defined**, or **awaiting plan and design** |
| A feature with no tasks or bugs | **awaiting decomposition** |
| A task or a bug with no feature | **unclassified**: it waits in its team's Triage project |

Ruled 2026-09-04: **an epic with no features is not an epic.** Either it should not have the type Epic,
or its plan has not yet produced the features it will decompose into — and until it has, that is its
state, and the report should say so.

## Triage classifies, and adds attributes

An issue of any type, or of none, waits in its team's Triage project until a triage decision declines it
or moves it to its team's Backlog, Schedule or Scenario project (§ What has no parent). An issue moved on
leaves with its type and its parent. Triage also sets and revises its attributes:

| Attribute | Answers | In NobleFactor | In David-Noble-at-work |
| --- | --- | --- | --- |
| severity | what the impact is if this fires | the Severity issue field, Critical, High, Medium or Low | a label, as `severity:critical` |
| priority | when we act on it | the Priority issue field, Urgent, High, Medium or Low | a label, as `priority:urgent` |
| area | whether the issue's own work is product or engineering | the Area issue field, Product or Engineering | a label, `area:product` or `area:engineering` |

Ruled 2026-11-03: issue fields are used wherever an account has them. In NobleFactor, severity, priority
and area are issue fields, and its Priority, Effort, Target date, Resolution, Area and Severity fields
are used; its Start date field is not, because when work really started is in each issue's history.
David-Noble-at-work has no issue fields, so it uses the `priority:`, `severity:`, `effort:` and `area:`
labels, which are lowercase (below). Priority and Area apply to issues of every type, Schedule and
Scenario included. Area has two values only, product and engineering (§ The types), and an issue without
one is an error (§ What has no parent).

Ruled 2026-11-03: Severity is an issue field of the organization, in NobleFactor, with the values Critical, High,
Medium and Low ([section 2](architecture/issue-data-model/2-attributes.md#the-attributes) of the design). This settles
where severity lives in NobleFactor, which had been open. The script of the issue data model design's worktree (#303),
`~/Workspace/NobleFactor/noblefactor-engprod.303-model-cutover.bash`, made the field on 2026-11-03, in its step 3, and
read it back. Its description is "What the impact is if this fires". Its options are Critical (red), "Data loss,
corruption, or a security failure"; High (orange), "A supported path is broken with no workaround"; Medium (yellow),
"Broken with a workaround, or a narrow path"; and Low (green), "Cosmetic, or a defect nobody is hitting". It has no
default value: GitHub's GraphQL schema lets `createIssueField` take an owner, a name, a description, a data type,
options and a visibility, and nothing else, so an issue field can't have a default. On 2026-11-03 the devlore-cli
issues that carried a `Severity:` or `Priority:` label got the matching Severity or Priority value, `Priority:P0` to
`Priority:P3` becoming Urgent, High, Medium and Low, and the labels were then deleted; no NobleFactor repository has
a severity or priority label now
([section 5](architecture/issue-data-model/5-from-todays-scheme.md#the-deltas) of the design).

Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub offers
organizations only ([section 4](architecture/issue-data-model/4-storage-and-reach.md#a-user-account) of the design). A
user account has no issue fields: GitHub's GraphQL schema says `createIssueField` makes a field in an organization,
and its `User` type has no issue fields. So in a user account a label stands in for each single-select issue field,
one label per option, named `<field>:<option>` in lowercase: `priority:urgent`, `priority:high`, `priority:medium` and
`priority:low`; `severity:critical`, `severity:high`, `severity:medium` and `severity:low`; `effort:high`,
`effort:medium` and `effort:low`; `area:product` and `area:engineering`; and `resolution:declined`,
`resolution:duplicate` and `resolution:invalid`. The priority labels follow NobleFactor's Priority options, Urgent,
High, Medium and Low, which are GitHub's own. The priority, severity and effort labels were made on 2026-11-03 in
personal and David-Noble-at-work/.github, each colored and described as its option is; the area and resolution labels
were already there. A date field has no stand-in, since a label can't hold a date: Target date has no counterpart in a
user account, and Start date is unused. A project field is no stand-in either: its value is on the project's row, not
on the issue, so it doesn't go with the issue from project to project. The Priority project field on Backlog:
David-Noble-at-work and on the account's Backlog copy was deleted on 2026-11-03; neither project had rows.

None of them changes what an issue *is*. An issue has one type at a time: triage gives it one when it has
none, and every chore's type changed when Chore was retired.

## Evidence of completion

Ruled 2026-11-02: every issue states its evidence of completion, what will show it is done. For a
Schedule issue that is its exit criteria; for a Scenario issue it is the scenario working end to end.

## Well classified

An issue is well classified when it has:

- **exactly one** type: GitHub's issue type in an organization, or one lowercase type label in a user
  account, and
- **exactly one** parent, one level up, held as a sub-issue link within its own account, unless it is an
  epic, which has none.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

An issue not yet classified belongs in its team's Triage project.

Ruled 2026-11-03: enforcement is lax, and there are no compliance checks. Today the audit still names
anything else as a fault: no type, or two type labels (in a user account only); no parent, or a parent
not one level up; a sub-issue or blocked-by link into another account; a schedule row other than the
schedule's own issue with no step number; an epic or a feature as a step; and a resolution on an open
issue, its Resolution field in NobleFactor or its `resolution:` label in David-Noble-at-work (§ The labels
a repository provides). Exempt from the parent rule: an epic. Exempt from both the type rule and the
parent rule: an issue waiting in its team's Triage project. What the audit compares against is decided
with the tooling, #426 and #437.

Only **open** issues are audited: the rules apply to open work, and a closed issue keeps the
classification it was left with. Closed issues were not skipped in the cutover: the chore label was
removed from every repository in both accounts, closed issues included, and so were the `Epic:` and
`Thread:` labels.

## The labels a repository provides

Labels are held per repository, as that repository's labels in its account's model. An organization's
default labels are not part of the model. Ruled 2026-11-03.

In David-Noble-at-work the types are labels: the six lowercase labels `epic`, `feature`, `task`, `bug`,
`schedule` and `scenario`. A missing type label in a repository that takes part is not a decision not to
use it; it is a repository where that type cannot be filed and nobody noticed. In NobleFactor the types
are GitHub's issue types, which reach every repository of the organization.

Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an organization,
or when it has the topic issue-model, in a user account.

Ruled 2026-11-03, and done in GitHub the same day: the kind labels `epic`, `feature`, `task` and `bug`
left NobleFactor's 12 repositories, after 672 issues got the issue type their label named.
David-Noble-at-work keeps its type labels, which are its types.

No repository carries `chore`, `Epic:Ops:Process`, an `Epic:<Name>` label, a `Thread:<Name>` label or a
`ClaudeJudgmentError:` label; all were removed. No NobleFactor repository carries a kind label, a
severity label or a priority label, and devlore-cli's seven finer Area labels were deleted on 2026-11-03
(§ The types). A repository in David-Noble-at-work carries the `priority:`, `severity:`, `effort:` and
`area:` labels it uses, `area:product` and `area:engineering` among them; NobleFactor uses issue fields
instead (§ Triage classifies, and adds attributes).

**Why a closed issue was not done is its resolution.** In NobleFactor it is the Resolution issue field, a
single-select field with three options: Declined, Duplicate and Invalid. NobleFactor has no `resolution:`
labels, and no `duplicate` or `invalid` labels; they were deleted from its 12 repositories on 2026-11-03.
In David-Noble-at-work, which has no issue fields, it is a label named `resolution:<name>`:
`resolution:declined`, `resolution:duplicate` and `resolution:invalid`, the last two replacing the
`duplicate` and `invalid` labels there. There is no `wontfix` or `declined` label. A resolution goes only
on a closed issue; the model records it, as the Resolution field among an organization's issue fields and
as the `resolution:` labels among a user account's labels, and the audit reports one on an open issue. An
issue that was not done is closed as completed, with its Resolution, or in a user account its
`resolution:` label, saying why; GitHub's `not_planned` close reason is not used. Ruled 2026-11-03.

The model holds an account's issue fields, as it holds its issue types and labels: in NobleFactor,
Priority, Effort, Target date, Resolution, Area and Severity. A user account has none. Ruled 2026-11-03.

**The model's two verbs.** `star github model pull` reads the whole model of any account, ours or not:
every repository the account owns. Pull has no `--repo` option. `--account` names the account and
defaults from star configuration's `github.account`, which defaults to NobleFactor; `--asset` names the
model file. `star github model push` writes a model to an account, and that model becomes the account's
data model. Pull comes first, then push, and their account option is `--account`, not `--org`. Ruled
2026-11-02 and 2026-11-03. What push writes (views, `--repo`, the default of its `--account`) and the
default of `--asset` are decided with the tooling, #426 and #437. Until the tooling follows, the
extension still ships `star github labels audit` and `star github labels sync`, it has no push yet, and
pull still takes `--org`.

GitHub's default labels `enhancement`, `documentation`, `good first issue`, `help wanted` and `question`
are **not types**. They look reasonable at filing time and place nothing. `enhancement` in particular is
the trap: it reads as the natural label for new work and is invisible to the scheme.

## What the audit is for

Today `star github schedule audit` is the classification audit, and `star github schedule report --view
tree` opens with it before any section. That order is the point: a report that renders a tidy hierarchy while
silently omitting the issues it could not place is worse than no report, because it looks complete.
