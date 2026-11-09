---
title: "Issue Standards"
type: Process
status: Approved
---

# Issue Standards

Each account has its own data model: NobleFactor, an organization, and David-Noble-at-work, a user account. Every issue
has one **type**, and the types form a hierarchy. In an organization the type is GitHub's issue type (Epic, Feature,
Task, Bug). In a user account it is the lowercase label of the same name (`epic`, `feature`, `task`, `bug`). The record
is GitHub's: issue types, sub-issue links and project rows. Every issue is reviewed in its team's Triage project, where
a triage decision is made, apart from an item found while walking a scenario that is classified and moved straight onto
a schedule (§ What has no parent). Ruled 2026-11-03: issues are classified by issue type, in the hierarchy epic,
feature, then task or bug; enforcement is lax, and there are no compliance checks. Ruled 2026-11-04, superseding that in
part: enforcement stays lax, and the sweep (#436) will be the one check, returning an issue that breaks a rule to its
team's Triage project (§ Well classified). Ruled 2026-11-02: a working issue tracking system on GitHub comes first, and
the tooling follows the record.

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

Ruled 2026-11-02, replacing that: Chore is retired. The hierarchy is Epic (level 0), then Feature (level 1), then Task
or Bug (level 2), and the chore label is gone from every repository in both accounts. The record was relabeled the same
day: chores became tasks, and chores with tasks and bugs of their own became features. Ruled 2026-11-03: the `chore/`
branch type is removed from the branch ruleset and from `git open-branch`; the plans already filed under
`docs/plans/chore/` stay where they are. The ruleset changed that day, and `git open-branch` still accepts `chore` until
#449 takes it out; approved 2026-11-04, #449 will also have `git open-branch` take the branch type from the issue's
type, or from its type label in a user account
([github-branch-protection.md](github-branch-protection.md#12515090--restrict-branch-names)).

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
engineering (§ Product and engineering), with its tasks and bugs under it. A body of process or tooling work is a
feature like any other: it sits under the epic it serves, with its tasks and bugs under it.

**Level 2 is the leaf**, a Task or a Bug: what a pull request closes, and what a schedule's steps are. "Step" names a
schedule's row (§ Schedules), so a leaf on no schedule is not a step. An epic or a feature is never a step. Ruled
2026-11-03: a feature stays open after its tasks and bugs are done, and closes only after an agent has audited it for
compliance and an agent has reviewed its code, with the team lead's sign-off; an epic closes when its features do
([section 1](architecture/issue-data-model/1-hierarchy.md#how-long-a-level-lives) of the design).

Task and Bug are peers and **mutually exclusive**. In an organization an issue has one issue type, so it cannot be both.
In a user account an issue can carry both labels, `task` and `bug`; it is then not well classified, and the sweep (#436)
will return it to the account's Triage project (§ Well classified). The question that separates them is not difficulty
or size: does this build something the feature did not have, or restore something it was supposed to have already?

Tidying code the product ships is a task under the feature that owns that code, or a bug if the tidying
repairs something. The scheme has no *story*. Where scrum-based writing says story, this scheme says
task.

## Product and engineering

**Area says whether an issue's own work is product or engineering.** Ruled 2026-11-03: Area has two values only,
product and engineering. In NobleFactor they are the options Product and Engineering of the Area issue field, made
2026-11-03; in a user account they are the labels `area:product` and `area:engineering`. Every issue has one, whatever
its type, Schedule and Scenario included, and an issue without one is an error (§ What has no parent). Ruled
2026-11-05, the two values mean:

| Value | Meaning |
| --- | --- |
| Product, `area:product` | Tags issues representing user-facing features, capabilities, or functional components that are packaged and released from this repository. |
| Engineering, `area:engineering` | Tags issues representing durable design artifacts, technical specs, internal infrastructure, testing, and the iterative execution of development plans. |

**A product is any deliverable released from a repository,** typically an open-source product or an internal tool.
Ruled 2026-11-05. Two sets of products release today. DevLore, open source, releases from devlore-cli,
devlore-registry and devlore.noblefactor.com. Engineering materials (policies, process, tooling and standards) and
tooling (star extensions and more) release from noblefactor-engprod, and are internal. Governance and process issues
are products of the engineering productivity team, and documentation that releases with a product is product. A
personal repository exists only for personal productivity, and no `area:product` label is expected in one.

**Engineering is work on things outside the deliverables a repository releases,** the work that doesn't ship. Ruled
2026-11-05. It covers build orchestration, Makefile changes, CI pipelines, tests, tools that don't release with a
product, design work, planning work, and documentation that doesn't release with a product. Ruled 2026-11-04: a bug in
a test is an engineering issue, not a product issue, as the Test-ClearClaude bug (#445) is.

**An issue's Area describes its own work, not its parent's.** Ruled 2026-11-05: an epic is a product epic or an
engineering epic, never both, and a feature is the same. Product work may hold engineering work, and engineering work
never holds product work: a product epic may contain an engineering feature, and an engineering epic contains no
product feature; a product feature may contain an engineering task or bug, and an engineering feature contains no
product task or bug. Engineering epics are permitted, though few if any are wanted. A bug or a task logged on a
schedule to deal with an engineering problem, a CI bug fixed during a product feature for example, is recorded under
the feature it supports, not under the epic, and its Area is engineering. This supersedes the ruling of 2026-11-03
that epics for product readiness and for release management hold both kinds.

**A scenario is engineering, and a schedule is what it delivers.** Ruled 2026-11-05: a scenario represents demo and
test artifacts, so every scenario is engineering. A schedule describes deliverables with exit criteria, and its Area is
the nature of its deliverables: most schedules are product, and some are engineering.

**Release notes come from the closed product issues in a release,** not from the hierarchy. Ruled 2026-11-03. Ruled
2026-11-05: release notes are themselves a product output, though the release manager's work on them is largely
engineering, so a bug in the release notes is a product bug.

Ruled 2026-11-03: devlore-cli's seven finer Area labels (architecture, CLI, code quality, error handling,
git, meta and testing) are gone, deleted that day. The hierarchy carries those distinctions. Architecture
work is a task, or a feature with product value, within an epic. A bug is not filed against the
architecture; an architecture task is filed to address a bug in a feature.

## Placement

**No issue carries an epic label.** Every Feature, Task and Bug has exactly one parent, one level up,
held as GitHub's sub-issue link, and its epic is read up those links. An epic has no parent. Ruled
2026-11-03: the `Epic:` and `Thread:` labels are removed from both accounts, and sub-issue parent links
and project rows replace them. The `ClaudeJudgmentError:` labels are removed too.

**A parent may sit in another repository of the same account, never in another account.** Features
cross repository boundaries within an account. No project, sub-issue link or blocked-by link crosses
accounts: work that waits on another account's issue is tracked by a stand-in issue in its own account
that names the other issue. Ruled 2026-11-02.

A task or a bug with no parent is not unfiled. It is unclassified, and it waits in its team's Triage project, or in the
scenario whose walk found it (§ What has no parent).

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

- **A scenario issue** has the issue type Scenario (the label `scenario`, in a user account). It summarizes an end-user
  goal and names the features its scenario exercises. The tasks and bugs found while walking the scenario are the rows
  of its team's Scenario project that carry the scenario's option in their Scenario field (§ Scenarios). It carries no
  `Thread:<Name>` label: those labels were removed, and the project's rows replace them.
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

**Every issue is reviewed in its team's Triage project**, and a triage decision is made there. Not only a bug: a new
issue of any type, or of none, goes into its team's Triage project. The decision either declines the work or moves the
issue on (below). Declined work is closed as completed, with Resolution Declined in NobleFactor or the
`resolution:declined` label in David-Noble-at-work (§ The labels a repository provides). That project is the triage
queue, and today the audit exempts an issue while it waits there. Each team owns its Triage project: Triage: engprod
(NobleFactor project 5) and Triage: devlore (NobleFactor project 6). The user account owns its own, Triage:
David-Noble-at-work (David-Noble-at-work project 3). There is no triage epic and no Triage issue type. The triage epics
NobleFactor/noblefactor-engprod#142, NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313 are retired.
Ruled 2026-11-03. Ruled 2026-11-04: a task or a bug logged while walking a scenario goes to the scenario instead of to
Triage, and the Triage workflow will add it there (#448; § Scenarios). Ruled the same day: triage removes an issue's
Triage row as part of its decision, and the sweep (#436) removes none: an issue someone closes outside triage stays in
its Triage project until triage decides its disposition. Read on 2026-11-04, 78 of Triage: engprod's 178 rows were
closed issues, and they are triage's to decide.

**A new issue reaches its team's Triage project through a GitHub Actions workflow** in its repository, run when an issue
is opened or transferred, using `actions/add-to-project`. GitHub's built-in auto-add workflow is not used. Each
repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project, from the team mapping: the team with the
maintain role on a repository owns it. A Triage workflow template in each account's `.github` repository offers the
workflow. Ruled 2026-11-03. GitHub's documentation describes workflow templates kept in an organization's `.github`
repository and says nothing about a user account's; whether GitHub offers David-Noble-at-work/.github's template to
personal has not been checked, and either way the task that added personal's Triage workflow on 2026-11-04,
David-Noble-at-work/personal#315, copied personal's `triage.yml` from it. How the workflow signs in, with a token from
the noblefactor-automation GitHub App in NobleFactor and a classic personal access token in a user account, is
[section 4](architecture/issue-data-model/4-storage-and-reach.md#triage) of the design.

**The team that owns a project is accountable for it**, and GitHub's link between the project and its
team is the record. A user account's projects are its owner's. Ruled 2026-11-03.

**Issues we file ourselves will go through `star github issue`** once it is built (#338), the one path that will
classify an issue as it is made. Ruled 2026-11-03.

**A blank Area is an error, caught at three points.** Ruled 2026-11-03. At filing, `star github issue` will refuse an
issue without an Area (#338), and the issue forms in each account's `.github` repository have a required Area dropdown.
The Triage workflow copies its answer into the Area field or label when the issue is opened: personal's adds the `area:`
label today, and NobleFactor's will set the Area field once #447 and #448 land. GitHub enforces a form's required fields
only in a public repository (GitHub's form schema documentation, read 2026-11-04), so in a private one, which today is
only personal, nothing checks the Area at filing until `star github issue` does. At triage, each Triage project has the
Area field (in a user account, the Labels field, which holds the `area:` labels) and a "Missing Area" view, both made
2026-11-03, and nothing leaves Triage without an Area. No view showed the Area or Labels column when read on 2026-11-04,
and the script of #303's closing pull request shows the Area column in every view of NobleFactor's Triage projects, and
the Labels column in David-Noble-at-work's. Afterward, the scheduled sweep (#436) will return any open issue without an
Area to its team's Triage project (§ Well classified). It waits on #452, which will give every open issue an Area first:
read on 2026-11-04, before #452 and #453 were filed, 9 of the 528 open issues in NobleFactor's five participating
repositories had one, and 5 of personal's 42.

GitHub Actions cannot run a workflow when a project row changes: `projects_v2_item` is a webhook event for
organization webhooks and GitHub Apps only.

**Who moves an issue.** Ruled 2026-11-04: any member of a team can see all of the team's issues and do all of its work
in its four projects: triage, the backlog, scheduling and scenarios. So the one grant a new participant needs is
membership in the team, whose roles carry the rest. A user account has no teams; there, a new participant is a
collaborator on each participating repository, personal and David-Noble-at-work/.github, and a writer on each of the
account's four projects. What each workflow changes in GitHub, the least role each change needs and what to grant follow
(§ Who can do what).

**How an issue moves.** Ruled 2026-11-04: an issue is a row of at most one of its account's Triage, Backlog, Schedule
and Scenario projects, whichever team owns them, and is on at most one schedule or scenario. Epics and features are
never rows of a Backlog, Schedule or Scenario project: a new one reaches Triage like every new issue and, once
classified, leaves Triage for no project, since the hierarchy holds it. Its tasks and bugs are what reach the Backlog
and the schedules, from which a work item's parent link leads to its feature and its epic. So the only rows of a
Schedule or Scenario project that are not tasks or bugs are the Schedule and Scenario issues themselves. Every move is
one act: the issue gets its row in the project it goes to, with that project's fields set, and loses its row in the
project it leaves. Out of Triage, declined work is closed as completed with Resolution Declined (the
`resolution:declined` label, in a user account), and accepted tasks and bugs go to the Backlog with their Priority or
onto a schedule. From the Backlog, work goes onto a schedule highest Priority first (§ Schedules). A task or a bug found
while walking a scenario waits in the scenario until it moves to its team's Triage project or straight onto a schedule
(§ Scenarios). The sweep (#436) will return an issue that is a row of more than one of its account's projects, Scenario
included, or is on more than one schedule or scenario, to its team's Triage project (§ Well classified).

**Moving an issue to another team.** Ruled 2026-11-04, superseding in part the ruling of 2026-10-22 that work for
another team gets a tracking issue: an issue on another team's project is assigned to an accountable member of that
team, and the person whose name is on an issue moves it to another team the way any move is made, in one act, between
its team's Triage project or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or
schedule to schedule. GitHub allows up to 10 assignees on an issue, any organization member who can read the repository
among them
([Assigning issues and pull requests to other GitHub users](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/assigning-issues-and-pull-requests-to-other-github-users)),
and all five of NobleFactor's participating repositories are public.

Read on 2026-11-04, 30 open issues in NobleFactor's Triage projects were also rows of a Schedule project, their own
team's or another's: 28 of their own team's, 19 of engprod's, #303 among them, and 9 of devlore's; and
NobleFactor/noblefactor-engprod#250 and David-Noble-at-work/personal#263, rows of Triage: engprod and Schedule: devlore.
The script of #303's closing pull request deletes their 30 Triage rows. Two more, David-Noble-at-work/personal#268 and
#275, are rows of Triage: David-Noble-at-work and of Schedule: devlore; those Schedule: devlore rows are crossings that
#428 will remove, and the two keep their Triage rows. The script also removes the five features that were rows of a
Schedule or Scenario project that day, NobleFactor/noblefactor-engprod#140 and #151 from Scenario: engprod,
NobleFactor/devlore-cli#762 and #847 from Scenario: devlore, and NobleFactor/devlore-cli#1023 from Schedule: devlore,
first commenting on each scenario's Scenario issue naming the features it exercised. And it removes the Scenario rows of
15 tasks and bugs that had already moved on, recording each on its Scenario issue: read the same day, 14 tasks and bugs
were rows of both a Schedule and a Scenario project, and NobleFactor/noblefactor-engprod#252 was a row of Triage:
engprod and of Scenario: devlore.

## Who can do what

Ruled 2026-11-04: any member of a team can see all of the team's issues and do all of its work in its four projects:
triage, the backlog, scheduling and scenarios. So the one grant a new participant in NobleFactor needs is membership in
the team, whose roles carry the rest: the maintain role on each repository the team owns, and the write role on each of
its four projects, which the script of #303's closing pull request sets in place of the Admin role ruled for each team's
Triage project on 2026-10-22 ([section 3](architecture/issue-data-model/3-collections.md#ownership) of the design). An
owner or the team's maintainer adds a member of NobleFactor to the team. Someone who isn't a member yet needs a seat
first, and NobleFactor's Team plan has one, which its one member fills; once a seat is added, an owner invites them, and
they join NobleFactor and the team on accepting
([Adding organization members to a team](https://docs.github.com/en/organizations/organizing-members-into-teams/adding-organization-members-to-a-team)).
A user account has no teams; there, a new participant is a collaborator on each participating repository and a writer on
each of the account's four projects, and the account itself grants both. In David-Noble-at-work that is a collaborator
on personal and on David-Noble-at-work/.github, the account's two repositories with the topic issue-model, and a writer
on Triage: David-Noble-at-work, Backlog: David-Noble-at-work, Schedule: David-Noble-at-work and Scenario:
David-Noble-at-work (its projects 3, 6, 7 and 8).

The table gives, for each change the five workflows make, the least role GitHub's documentation names for it, read on
2026-11-04, and the page that names it. In a team's own repositories and projects, the team's two roles meet every role
the table names for an organization. Setting a parent across two teams' repositories takes the triage role on both:
GitHub's REST page [Create an issue](https://docs.github.com/en/rest/issues/issues#create-an-issue) says so of an
issue's `parent_issue_id`. devlore holds the write role on noblefactor-engprod, so a devlore member can link a devlore
issue to a noblefactor-engprod parent and back; engprod holds no role on devlore's repositories, so an engprod member
can't. An organization owner, who holds the admin role on each of the organization's repositories, can set a parent
between any two.

| Workflow | What it changes in GitHub | Least role, organization | Least role, user account | Source |
| --- | --- | --- | --- | --- |
| Filing | Opens the issue, from one of its account's six issue forms, with `gh issue create`, or later with `star github issue` (#338) | read on the repository, which a public repository gives everyone, and all five that take part are public, devlore.noblefactor.com since 2026-11-04 | a collaborator, on personal, which is private; anyone, on a public repository such as David-Noble-at-work/.github, which gives everyone read | [Creating an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |
| Filing | Sets its type. Each form sets it: NobleFactor's through the form's `type` key, and David-Noble-at-work's as the type label in the form's `labels` key. `gh issue create --type`, and later `star github issue`, set it through GitHub's API | read, through a form, which adds the type itself; write, through GitHub's REST API, which silently drops the type from anyone with less | read, through a form, which adds the label itself; a collaborator, to add the label any other way | [Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms#top-level-syntax); [Create an issue](https://docs.github.com/en/rest/issues/issues#create-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |
| Filing | Sets its parent, the sub-issue link, with `gh issue create --parent`, or later with `star github issue` | triage on the issue's repository and, by GitHub's REST documentation, on its parent's | not stated | [Adding sub-issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues); [Create an issue](https://docs.github.com/en/rest/issues/issues#create-an-issue) |
| Filing | Sets its Area, from the form's Area dropdown, which GitHub requires only in a public repository, and its Severity: N/A on an issue of a type other than Bug, and Medium on a bug filed from the bug form. A form can't set an issue field, so the Triage workflow copies the Area: personal's adds the `area:` label today, and NobleFactor's will set the Area field once #447 and #448 land. Both accounts' Triage workflows will set the Severity (#448), and `star github issue` will set the Area and Severity N/A at filing (#338) | none of the filer's, where the Triage workflow sets them with its own token; triage, or write through GitHub's REST API, where the filer sets them | none of the filer's, where personal's Triage workflow adds the labels; a collaborator, to add them by hand | [Syntax for GitHub's form schema](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema); [Adding and managing issue fields](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-and-managing-issue-fields); [Set issue field values for an issue](https://docs.github.com/en/rest/issues/issue-field-values#set-issue-field-values-for-an-issue); [section 4](architecture/issue-data-model/4-storage-and-reach.md#triage) of the design |
| Filing | Adds the issue's row to its team's Triage project, which the Triage workflow does when the issue is opened or transferred. The workflow will give a task or a bug logged while walking a scenario its row in the Scenario project instead, under the scenario's option (#448) | none of the filer's once #448 puts the workflow in NobleFactor's five participating repositories, none of which has it yet; it adds the row with the noblefactor-automation app's token. Until then the row is added by hand, which takes write on the Triage project, or on the Scenario project for an item found while walking a scenario | none of the filer's in personal, whose workflow adds the row with the classic token in `ADD_TO_PROJECT_PAT`; in David-Noble-at-work/.github, which has no Triage workflow yet (David-Noble-at-work/personal#311), write on the Triage project, to add the row by hand; write on the Scenario project, to give an item found while walking a scenario its row there until #448 | [section 4](architecture/issue-data-model/4-storage-and-reach.md#triage) of the design; [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Triage | Sets or changes the issue's type; in a user account, its type label | write on the repository, since GitHub's REST API silently drops a type change from anyone with less | a collaborator | [Editing an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/editing-an-issue#adding-or-changing-the-issue-type); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |
| Triage | Sets or changes its parent, the sub-issue link | triage on the issue's repository and, by GitHub's REST documentation, on its parent's | not stated | [Adding sub-issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues); [Create an issue](https://docs.github.com/en/rest/issues/issues#create-an-issue) |
| Triage | Sets the Area, Priority and Severity issue fields, and Resolution on declined work; in a user account, the `area:`, `priority:`, `severity:` and `resolution:` labels that stand in for them | triage, on GitHub's issue page; write, through GitHub's REST API | a collaborator | [Adding and managing issue fields](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-and-managing-issue-fields); [Set issue field values for an issue](https://docs.github.com/en/rest/issues/issue-field-values#set-issue-field-values-for-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |
| Triage | Adds or removes a label, such as `good first issue`, which goes on a task or a bug only | triage; write, through the REST calls that open or update an issue, which silently drop labels from anyone with less | a collaborator | [Managing labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels#applying-a-label); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |
| Triage | Closes declined work as completed, removing its Triage row as part of the decision, or reopens an issue | triage, for anyone's issue; read, to close one's own issue or to reopen an issue one closed; write on the Triage project, to remove the row | a collaborator; write on the Triage project, to remove the row | [Closing an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/closing-an-issue); [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization#permissions-for-each-role); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account); [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Triage | Moves accepted work: a task or a bug gets its row in the Backlog or the Schedule project, with that project's fields set, and loses its Triage row; an epic or a feature, once classified, loses its Triage row and goes to no project | write on both projects, or on the Triage project alone for an epic or a feature | write on both projects, or on the Triage project alone for an epic or a feature | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Triage | Moves an issue to another team's Triage project, in one act, by the person whose name is on it: the issue gets its row there and loses its row in the Triage project it leaves, and is assigned to an accountable member of that team | write on both Triage projects; triage on the issue's repository, to assign it, or write through GitHub's REST API | does not arise: a user account has no teams | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [Assigning issues and pull requests to other GitHub users](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/assigning-issues-and-pull-requests-to-other-github-users); [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization#permissions-for-each-role); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue) |
| Triage | The sweep (#436) will return an open issue that breaks a rule to its team's Triage project, and comment on it naming the rule (§ Well classified) | none: it will run every day as a scheduled GitHub Actions workflow in the account's `.github` repository, with the credentials the Triage workflow uses | none, the same way | § Well classified; [section 4](architecture/issue-data-model/4-storage-and-reach.md#triage) of the design |
| The backlog | Holds accepted tasks and bugs: the issue's row in the Backlog project, with its Status, and its Priority, which orders the Backlog in the By priority view that the script of #303's closing pull request makes, with the Priority column shown. David-Noble-at-work's Backlog has no Priority field to sort by; there an issue's `priority:` label holds its priority | write on the Backlog project, for the row; triage, or write through GitHub's REST API, for Priority | write on the Backlog project, for the row; a collaborator, for the label | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects); [Adding and managing issue fields](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-and-managing-issue-fields) |
| Scheduling | Puts work on a schedule, highest Priority first: the issue gets its row in the Schedule project, with the schedule's option in Schedule, the next step or the step the schedule's owner gives it in Step, and Status Open, and loses its row in the project it leaves, the Backlog, Triage or, for an item found while walking a scenario, the Scenario project. `star github schedule add` (#438) will make the move in one command | write on both projects | write on both projects | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Scheduling | Moves a step to another team's schedule, in one act, by the person whose name is on it: the issue gets its row in that team's Schedule project, with that project's fields set, and loses its row in the Schedule project it leaves, and is assigned to an accountable member of that team | write on both Schedule projects; triage on the issue's repository, to assign it, or write through GitHub's REST API | does not arise: a user account has no teams | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [Assigning issues and pull requests to other GitHub users](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/assigning-issues-and-pull-requests-to-other-github-users); [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization#permissions-for-each-role); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue) |
| Scheduling | Adds the step's blocked-by links | triage on the step's repository; on the blocking issue's, not stated | not stated | [Creating issue dependencies](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies) |
| Scheduling | Keeps the step's row current: its Worktree link to the branch its work is on, and its Status as the work moves | write on the Schedule project | write on the Schedule project | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Scheduling | Records the owner's amendment of a committed schedule in its Schedule issue | write on the repository, or being the Schedule issue's author, to edit its body | a collaborator | [Editing an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/editing-an-issue) |
| Scheduling | Opens a schedule: files its Schedule issue from the Schedule form, assigns the issue to the schedule's owner ([section 3](architecture/issue-data-model/3-collections.md#ownership) of the design), adds the schedule's option, named for the issue, to the Schedule field, and gives the issue its own row, with that option and no step | read, to file the issue; triage, to assign it, or write through GitHub's REST API; write on the Schedule project, for the option and the row | as for filing; a collaborator, to assign it; write on the Schedule project | [Creating an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue); [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization#permissions-for-each-role); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue); [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization) |
| Scenarios | Opens a scenario: files its Scenario issue from the Scenario form, assigns the issue to the scenario's owner, adds the scenario's option, named for the issue, to the Scenario field, and gives the issue its own row, with that option | read, to file the issue; triage, to assign it, or write through GitHub's REST API; write on the Scenario project, for the option and the row | as for filing; a collaborator, to assign it; write on the Scenario project | [Creating an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue); [Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/managing-repository-roles/repository-roles-for-an-organization#permissions-for-each-role); [Update an issue](https://docs.github.com/en/rest/issues/issues#update-an-issue); [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization) |
| Scenarios | Walks a scenario and logs each work item found, a task or a bug whose body names its scenario, as "Found while walking #N": the item gets its row in the Scenario project, with the scenario's option in Scenario and, in Beat, the point in the walk where it turned up. The Triage workflow will add the row in place of a Triage row (#448) | read, to file the item; write on the Scenario project, for its Beat, and for its row until #448 | as for filing; write on the Scenario project, for its Beat, and for its row until #448 | [Creating an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue); [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects) |
| Scenarios | Moves an item out of its scenario, to its team's Triage project or straight onto a schedule, which means classifying it first: the item gets its row there, with that project's fields set, and loses its Scenario row, and its body and a comment on the Scenario issue record the move | write on both projects; to classify it first, the roles the Triage rows above name; to edit its body, write on the repository, or being its author; to comment on the Scenario issue, not stated | write on both projects; a collaborator, to classify it, edit its body and comment | [Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization); [the same, for a user account's projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects); [Editing an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/editing-an-issue); [Permission levels for a personal account repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/repository-access-and-collaboration/permission-levels-for-a-personal-account-repository#collaborator-access-for-a-repository-owned-by-a-personal-account) |

A project's row shows only to someone who can read the repository its issue is in, whatever their role on the project
([Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-user-level-projects)).
Where the table says not stated, GitHub's documentation names no role for the change: its pages on sub-issues and issue
dependencies name the triage role, which a repository owned by a personal account doesn't have, and say nothing of the
other repository in a blocked-by link, and its table of an organization's repository roles has no row for commenting on
an issue, only one for editing one's own comments, which read allows. Changing the model is none of the five workflows'
work. Making or changing an issue type or an issue field takes an owner of the organization, and making, editing or
deleting a label takes write on the repository
([Managing issue types in an organization](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-types-in-an-organization),
[Managing issue fields in your organization](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-fields-in-your-organization),
[Managing labels](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels#creating-a-label)).

**Our setup, read from GitHub on 2026-11-04.** NobleFactor has three teams. engprod holds the maintain role on
NobleFactor/noblefactor-engprod and NobleFactor/.github, and is linked to Triage: engprod, Backlog: engprod, Schedule:
engprod and Scenario: engprod (NobleFactor projects 5, 25, 26 and 27). devlore holds the maintain role on
NobleFactor/devlore-cli, NobleFactor/devlore-registry and NobleFactor/devlore.noblefactor.com, which the owner made
public on 2026-11-04, and the write role on NobleFactor/noblefactor-engprod, and is linked to Triage: devlore, Backlog:
devlore, Schedule: devlore and Scenario: devlore (projects 6, 28, 29 and 30). Each is also linked to the closed schedule
and thread projects made before its four: engprod to projects 9 to 12 and 18, and devlore to projects 13 to 17 and 19
to 22. The third team, owners, is secret and holds no repository and no project. Each team's one member is
David-Noble-at-work, its maintainer, who is also NobleFactor's one member and its one owner. NobleFactor has no outside
collaborators, and its base permission on repositories is none, so a new member has no role on any repository, and reads
only the public ones, until a team, or a role on the repository itself, grants one; all five that take part are public.
It is on GitHub's Team plan, with one seat, which its one member fills, and it requires two-factor authentication: a new
member needs a free seat before an owner can invite them, and two-factor authentication before accepting
([Inviting users to join your organization](https://docs.github.com/en/organizations/managing-membership-in-your-organization/inviting-users-to-join-your-organization#about-organization-invitations)).

Linking a project to a team gives the team only the read role on it
([Adding your project to a team](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/adding-your-project-to-a-team)),
so the write role is a grant of its own. GitHub's API can set a team's role on a project, with GraphQL's
[`updateProjectV2Collaborators`](https://docs.github.com/en/graphql/reference/projects#mutation-updateprojectv2collaborators),
but it can't read one. A project's teams and a team's projects come back without their roles, and GitHub's
[REST endpoints for projects](https://docs.github.com/en/rest/projects) have none for collaborators. A team's projects
can be filtered by `minPermissionLevel`, which by its description filters by user role; for an owner, who is an admin of
every project, it gave each team the same projects at READ, WRITE and ADMIN. So the script of #303's closing pull
request, which can't read the roles back, checks that each of its calls succeeded. A project's settings show its
collaborators and their roles on its Manage access page
([Managing access to your projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects#managing-access-for-teams-and-individual-members-of-your-organization)):
the write role lets a collaborator view and edit the project, and the admin role also lets them add collaborators to it.
With the write role, a team's members can edit a project's fields and views too, as opening a schedule or a scenario
needs. What stays with an organization owner is a project's settings and access, and keeping every project of a kind
configured the same way rests on push (#437), not on the role.

In David-Noble-at-work, personal, which is private, and David-Noble-at-work/.github, which is public, have the topic
issue-model, and neither has a collaborator but the account itself. The account's eight projects, its four and its
copies of NobleFactor's four templates, are private, like all 27 of NobleFactor's, and GitHub's API can't read who
collaborates on a user account's project either.

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

Ruled 2026-11-04: the Backlog shows its order in a view named By priority, sorted by Priority, which the script of
#303's closing pull request makes in Backlog: engprod, Backlog: devlore and the Backlog template (NobleFactor projects
25, 28 and 24), and the script shows the Priority column in that view and in their others. Read on 2026-11-04, each of
the three had one view, with no sort and no Priority column, and GitHub's API sets a view's sort only when it makes the
view. David-Noble-at-work's Backlog has no Priority field to sort by: a user account has no issue fields, and there the
script shows the Labels column, which holds the `priority:` labels, in the views of the account's Triage and Backlog
projects.

A work item (a feature, a task or a bug) rolls up to exactly one epic through its parent links. Ruled 2026-11-04: a task
or a bug may be a row of a Backlog project, of a schedule (§ Schedules) or of a scenario (§ Scenarios), and an epic or a
feature is a row of none of them (§ What has no parent). Since #379 (ruled 2026-11-08) the report returns every issue
as one flat record, and star's `--filter` and `--jq` give each slice: an epic's on the record's `epic`, a schedule's
and a scenario's on the rows in its `home`.

## Scenarios

**A scenario is a high-level description of a feature, a workflow or a real-life situation that needs to be tested.**
Ruled 2026-11-04, replacing the model of 2026-11-03, in which a scenario was a narrative whose rows were the features it
carried across epics: its Scenario issue, its own row in the team's Scenario project, summarizes an end-user goal. It
drives planning, coverage and team alignment, includes an example for demos and ad-hoc testing that helps find gaps and
defects no other kind of testing finds, and names in its body the features it exercises. A scenario is structurally like
a schedule that starts with no tasks or bugs: they are found with time. Ruled 2026-11-03: threads are renamed scenarios.

**Walking a scenario.** Ruled 2026-11-04: someone opens the scenario and walks it, logging work items as they go, each a
task or a bug and a row of the team's Scenario project under the scenario's option, its Beat the point in the walk where
it turned up. A logged item names its scenario in its body, as "Found while walking #N", and the Triage workflow will
add it to the scenario instead of to the team's Triage project (#448). Each item later moves to its team's Triage
project or straight onto a schedule, and leaves the scenario; the item's body and a comment on the Scenario issue record
the move. The sweep (#436) will leave a scenario's rows alone but for two structural rules: it will return an epic or a
feature that is a row of a Scenario project, as it will one on a Backlog or Schedule project, and an issue that is a row
of a scenario and of another of its account's projects, whichever team owns them, so that one project at a time holds
across the account (§ Well classified). Every other rule waits until an item moves out: it gets its type and parent
then, and moving straight onto a schedule means classifying it first. A scenario never ends: it is kept, updated or
removed as the product changes, since it has value before, during and after a release.

**A team's Scenario project holds its scenarios**, each its Scenario issue and the tasks and bugs found while walking it
(ruled 2026-11-04, replacing the 2026-11-03 ruling that the project holds features). It is made from NobleFactor's
Scenario template (project 8), or in David-Noble-at-work copied from its copy of that template (its project 2). A
single-select Scenario field names the scenario each row belongs to: one option per scenario, named for its Scenario
issue. Beat orders the rows within a scenario. There is no longer a project per scenario. Ruled 2026-11-03. A scenario
is a collection beside the hierarchy, not a label family and not a level:

| | An epic | A scenario |
| --- | --- | --- |
| Answers | which body of work **owns** this | which scenario this **serves** |
| Its members | its features, then their tasks and bugs | the tasks and bugs found while walking it, until each moves on |
| Held as | sub-issue links | the team's Scenario project, by its Scenario field |
| Crosses repositories | yes, within its account | yes, within its account, by design |
| Crosses accounts | no | no |
| Closes when | the work ships | never: it is kept, updated or removed as the product changes |

Neither crosses accounts, because no project or link spans two. An item found while walking a scenario gains no label
from it, and nothing about the hierarchy changes. Ruled 2026-11-04: a scenario changes no issue's priority; triage sets
each issue's Priority (§ Triage classifies, and adds attributes). Ruled the same day: no epic or feature is a row of a
Scenario project (§ What has no parent), so the script of #303's closing pull request removes the four features that
were rows of one that day, first commenting on each scenario's Scenario issue naming the features it exercised. It also
removes the Scenario rows of the 15 tasks and bugs that had already moved on, onto a schedule or into Triage, recording
each on its Scenario issue (§ What has no parent).

**When to open one.** Ruled 2026-11-04: when there is an end-user goal to test. A scenario is not an epic. This
supersedes the test written for the 2026-11-03 model, when a scenario held features: *would moving this work into one
epic take issues away from the epic that owns their machinery?* If it would, the work was a scenario.

**The scenario issue** has the issue type Scenario (the label `scenario`, in a user account) and carries no
`Thread:<Name>` label (§ What has no parent). Its scenario's option in the Scenario field is named for it, and its
account's `.github` repository holds an issue form for it. Its body summarizes the end-user goal, gives the example and
names the features the scenario exercises; it states no evidence of completion, since a scenario never ends (§ Evidence
of completion). Read on 2026-11-04, each account's Scenario form asks only for the Area, the story and the evidence of
completion. The Scenario type's description, and the `scenario` label's in personal and David-Noble-at-work/.github,
still read "Collection: describes a scenario, the story its features tell", the model of 2026-11-03. #453 will bring the
forms, the type's description and both labels' descriptions to this, and will put "how to walk it", the example, where
each form's Evidence of completion section is, as its comments of 2026-11-04 record. **The order is the walk's; the
ownership is the epics'.** Beat, the point in the walk where an item turned up, gives the order; issue numbers do not.

Its type tells the scenario issue apart from its members, which share no label with it. Today the report
still finds a scenario issue by its title beginning `Thread:`. Under the old scheme it read the order from a
beat table in the scenario issue's body. Ruled 2026-11-03, and done in GitHub the same day: the step and
beat tables in 14 Schedule and Scenario issues gave way to a line naming the issue's board and option.
Since 2026-11-03 that line links the issue's own rows (§ Schedules).

**What the audit checks.** A scenario's members are the rows of its team's Scenario project with its option in their
Scenario field, so no label has to agree with a table. Ruled 2026-11-03, there are no compliance checks; superseded in
part on 2026-11-04, the sweep (#436) will be the one check, and it will leave a scenario's rows alone but for the two
structural rules above, on an epic or a feature in a scenario and on an issue that is also a row of another of its
account's projects (§ Well classified). The audit, and with it `--unthreaded`, which read the removed `Thread:` labels,
retired with #436 on 2026-11-08; the sweep holds a scenario's rows to those two rules.

## Schedules

**A team's Schedule project holds its committed tasks and bugs.** It is made from NobleFactor's Schedule template
(project 7), or in David-Noble-at-work copied from its copy of that template (its project 1). A single-select Schedule
field names the schedule each row belongs to: one option per schedule, named for its Schedule issue, which holds that
schedule's deliverable and exit criteria. Step orders the rows within a schedule, in the order someone has committed to
working them. GitHub's Iteration field gives each row its sprint, for scrums and sprint review. There is no longer a
project per schedule. Ruled 2026-11-03. A schedule answers *what is being executed, in what order, and what is next* —
which neither an epic (ownership) nor a scenario (an end-user goal to test) can express, because both are about what
work *is* rather than when it will be done.

**A Schedule issue's own row has no step.** Every other row gets its step number and its dependencies,
GitHub blocked-by links, when it is added. Ruled 2026-11-02, when "lane" became "step".

Its steps are **leaves**: tasks and bugs, from any epic and any feature, in any repository of the
schedule's own account. They never come from another account, because no project spans two; a step that
waits on another account's issue is blocked by a stand-in issue in its own account. An epic or a feature
as a step is a fault, not a shorthand.

| | An epic | A scenario | A schedule |
| --- | --- | --- | --- |
| Answers | which body of work **owns** this | which scenario this **serves** | in what **order** we execute |
| Its members | its features, then their tasks and bugs | tasks and bugs found while walking it, until each moves on (§ Scenarios) | tasks and bugs, as steps |
| Held as | sub-issue links | the team's Scenario project, by its Scenario field | the team's Schedule project, by its Schedule field |
| Its organizing issue | the epic, type Epic | an issue of type Scenario | type Schedule, its own row having no step |

**The schedule issue** has the issue type Schedule (the label `schedule`, in a user account). It holds its schedule's
deliverable and exit criteria (§ What has no parent), its schedule's option in the Schedule field is named for it, and
its account's `.github` repository holds an issue form for it. The steps are the rows with that option, with their step
numbers. Since #379 (2026-11-08) the report finds a schedule's steps in its records' `home`, by the Schedule option of
their rows, and Start-Claude knows a schedule issue by its type, or in a user account its `schedule` label, never by its
title. Under the old scheme the report read the steps from a step table in the schedule issue's body. Ruled 2026-11-03, and done in GitHub the same day: those
tables gave way to a line naming the issue's board and option (§ Scenarios).

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

**From the Backlog, work goes onto a schedule highest Priority first.** Ruled 2026-11-04: an issue goes onto a schedule
with the schedule's option in its Schedule field, the next step or the step the schedule's owner gives it, Status Open
and its blocked-by links, and it loses its Backlog row in the same act (§ What has no parent). A committed schedule
takes it only by its owner's amendment, recorded in the Schedule issue (§ What a schedule commits to).
`star github schedule add` (#438) will make that move in one command.

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

A schedule's members are the rows of its team's Schedule project with its option in their Schedule field, and an epic's
members are found down its sub-issue links, not by label. Ruled 2026-11-03, there are no compliance checks; superseded
in part on 2026-11-04, the sweep (#436) will be the one check, and it will return an issue that breaks a rule to its
team's Triage project (§ Well classified). Under the old scheme `star github schedule report --by schedule` read the
schedule issue's step table and rendered each step's state; that table is gone (§ Schedules). Since #436 (2026-11-08) a
record's `home` gives each step's schedule, step and Status from its row, and the sweep checks each account against its
own model, the part of #426 it needs having come with it; `push`'s side stays with #426 and #437.

## What an empty level means

A level with nothing under it is one of two things, and a report that renders it blank says neither —
blank reads as an error whichever cause it has. The states are named:

| Level | With nothing under it, it is |
| --- | --- |
| An epic with no features | **ill-defined**, or **awaiting plan and design** |
| A feature with no tasks or bugs | **awaiting decomposition** |
| A task or a bug with no feature | **unclassified**: it waits in its team's Triage project, or in the scenario whose walk found it |

Ruled 2026-09-04: **an epic with no features is not an epic.** Either it should not have the type Epic,
or its plan has not yet produced the features it will decompose into — and until it has, that is its
state, and the report should say so.

## Triage classifies, and adds attributes

An issue of any type, or of none, waits in its team's Triage project until a triage decision declines it or moves it on
(§ What has no parent), but for an item found while walking a scenario, which waits in the scenario until it moves out
(§ Scenarios). An issue moved on leaves with its type and its parent.

Ruled 2026-11-08, recorded on #436: a Triage row sits beside an issue's home. An issue's home is at most one of its
account's Backlog, Schedule and Scenario projects; when the sweep finds a fault, it adds the issue to its team's Triage
project beside that home, and it never takes an issue off a schedule or a scenario, nor removes a row from any project.
Triage fixes the fault, or declines or moves the issue, and removes the Triage row as part of that decision.

Triage also sets and revises its attributes:

| Attribute | Answers | In NobleFactor | In David-Noble-at-work |
| --- | --- | --- | --- |
| severity | what the impact is if this fires | the Severity issue field: Critical, High, Medium or Low on a bug, and N/A on every other type | a label, as `severity:critical`, and `severity:n/a` on every type but `bug` |
| priority | when we act on it | the Priority issue field, Urgent, High, Medium or Low | a label, as `priority:urgent` |
| area | whether the issue's own work is product or engineering | the Area issue field, Product or Engineering | a label, `area:product` or `area:engineering` |

Ruled 2026-11-03: issue fields are used wherever an account has them. In NobleFactor, severity, priority
and area are issue fields, and its Priority, Effort, Target date, Resolution, Area and Severity fields
are used; its Start date field is not, because when work really started is in each issue's history.
David-Noble-at-work has no issue fields, so it uses the `priority:`, `severity:`, `effort:` and `area:`
labels, which are lowercase (below). Priority and Area apply to issues of every type, Schedule and
Scenario included. Area has two values only, product and engineering (§ Product and engineering), and an issue without
one is an error (§ What has no parent).

Ruled 2026-11-03: Severity is an issue field of the organization, in NobleFactor, with the values Critical, High, Medium
and Low ([section 2](architecture/issue-data-model/2-attributes.md#the-attributes) of the design). This settles where
severity lives in NobleFactor, which had been open. The script of the issue data model design's worktree (#303),
`~/Workspace/NobleFactor/noblefactor-engprod.303-model-cutover.bash`, made the field on 2026-11-03, in its step 3, and
read it back. Its description is "What the impact is if this fires". Its options are Critical (red), "Data loss,
corruption, or a security failure"; High (orange), "A supported path is broken with no workaround"; Medium (yellow),
"Broken with a workaround, or a narrow path"; and Low (green), "Cosmetic, or a defect nobody is hitting". Ruled
2026-11-04: Severity gains a fifth option, N/A (gray), "Not applicable: the issue is not a bug", which the script of
#303's closing pull request adds (below). It has no default value: GitHub's GraphQL schema lets `createIssueField` take
an owner, a name, a description, a data type, options and a visibility, and nothing else, so an issue field can't have a
default. On 2026-11-03 the devlore-cli issues that carried a `Severity:` or `Priority:` label got the matching Severity
or Priority value, `Priority:P0` to `Priority:P3` becoming Urgent, High, Medium and Low, and the labels were then
deleted; no NobleFactor repository has a severity or priority label now
([section 5](architecture/issue-data-model/5-from-todays-scheme.md#the-deltas) of the design).

Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub offers
organizations only ([section 4](architecture/issue-data-model/4-storage-and-reach.md#a-user-account) of the design). A
user account has no issue fields: GitHub's GraphQL schema says `createIssueField` makes a field in an organization, and
its `User` type has no issue fields. So in a user account a label stands in for each single-select issue field, one
label per option, named `<field>:<option>` in lowercase: `priority:urgent`, `priority:high`, `priority:medium` and
`priority:low`; `severity:critical`, `severity:high`, `severity:medium` and `severity:low`; `effort:high`,
`effort:medium` and `effort:low`; `area:product` and `area:engineering`; and `resolution:declined`,
`resolution:duplicate` and `resolution:invalid`. The priority labels follow NobleFactor's Priority options, Urgent,
High, Medium and Low, which are GitHub's own. The priority, severity and effort labels were made on 2026-11-03 in
personal and David-Noble-at-work/.github, each colored and described as its option is; the area and resolution labels
were already there. Ruled 2026-11-04: `severity:n/a` joins the severity labels, colored `cfd3d7` and described
"Severity: not applicable, the issue is not a bug", made in both repositories by the script of #303's closing pull
request (below). A date field has no stand-in, since a label can't hold a date: Target date has no counterpart in a user
account, and Start date is unused. A project field is no stand-in either: its value is on the project's row, not on the
issue, so it doesn't go with the issue from project to project. The Priority project field on Backlog:
David-Noble-at-work and on the account's Backlog copy was deleted on 2026-11-03; neither project had rows.

**Severity is a bug's.** Ruled 2026-11-04: a task has no severity; it has a priority. Severity applies to bugs only, and
every issue of another type has Severity N/A: in NobleFactor, a new option N/A of the Severity issue field, and in a
user account, a new label, `severity:n/a`. A bug has Critical, High, Medium or Low, never N/A. An issue with no type yet
gets no Severity and waits for triage; when triage gives it a type other than Bug, triage sets its Severity to N/A, and
the sweep (#436) will catch a miss (§ Well classified). The Triage workflow will set N/A on an issue of another type
filed from a form, and will give a bug filed from the bug form, which asks no severity, Severity Medium, the owner's
default, which GitHub's field can't hold; triage changes it when the bug's harm is greater or less (#448).
`star github issue` will set N/A at filing (#338). So every typed issue has exactly one Severity value.

The N/A option, and the `severity:n/a` label in personal and David-Noble-at-work/.github, are made by the script of
#303's closing pull request. It adds N/A through GitHub's REST call,
`PATCH /orgs/NobleFactor/issue-fields/{issue_field_id}`, sending each existing option with its ID: the GraphQL call
`updateIssueField` takes no option IDs, and GitHub's REST documentation warns that options sent without one may be
deleted and recreated. The model holds each option's ID, so push will send every option with its ID too (#437). The same
script sets N/A on every open issue of a type other than Bug: read on 2026-11-04, before #452 and #453 were filed, 414
in NobleFactor's five participating repositories and 33 in personal, among them 5 tasks and 2 features in devlore-cli
that carry a severity from its old labels. An issue with no type gets none and waits for triage, as #422 and
David-Noble-at-work/personal#147, #151 and #251 did that day. Read the same day, 83 open bugs had no severity, 77 in
NobleFactor and 6 in personal, and giving each its severity is triage's work.

None of the attributes changes what an issue *is*. An issue has one type at a time: triage gives it one when it has
none, and every chore's type changed when Chore was retired.

## Evidence of completion

Ruled 2026-11-02: every issue states its evidence of completion, what will show it is done; for a Schedule issue that is
its exit criteria. Ruled 2026-11-04, superseding what that ruling said of a Scenario issue: every issue but a Scenario
issue states its evidence of completion. A scenario never ends, so its Scenario issue never closes and has nothing to
evidence (§ Scenarios), and #453 will put "how to walk it", the example the Scenario issue gives, where the Evidence of
completion section is on both accounts' Scenario forms.

Ruled 2026-11-04: an issue states its evidence of completion in its Evidence of completion section. Read from GitHub on
2026-11-04, each of the six issue forms in each account's `.github` repository, NobleFactor/.github and
David-Noble-at-work/.github, has that section and requires it, the Scenario form until #453 changes it. At filing, the
form checks it in a public repository; GitHub enforces a form's required fields only there (GitHub's form schema
documentation, read 2026-11-04). In a private repository, which today is only personal, nothing checks it at filing
until `star github issue` does (#338). Afterward, the sweep (#436) will return an issue other than a Scenario issue with
no Evidence of completion section to its team's Triage project (§ Well classified).

## Well classified

An issue is well classified when it has:

- **exactly one** type: GitHub's issue type in an organization, or one lowercase type label in a user
  account, and
- **exactly one** parent, one level up, held as a sub-issue link within its own account, unless it is an
  epic, which has none.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

An issue not yet classified belongs in its team's Triage project, or in the scenario whose walk found it (§ Scenarios).

Ruled 2026-11-03: enforcement is lax, and there are no compliance checks. Ruled 2026-11-04, superseding that in part:
enforcement stays lax, and the sweep (#436) will be the one check. Where the audit named a fault of an issue, the sweep
will return the issue to its team's Triage project instead. It will return any open issue that isn't well classified or
breaks a rule of the model: no type, or two type labels (in a user account only); no parent, or a parent not one level
up; a sub-issue or blocked-by link into another account; no Evidence of completion section, in any issue but a Scenario
issue (§ Evidence of completion); a schedule row other than the schedule's own issue with no step number; and an epic or
a feature that is a row of a Backlog, Schedule or Scenario project. It will check the attribute rules too, and return an
issue with no Area; a bug whose Severity is N/A or blank, or an issue of another type whose Severity isn't N/A; a
resolution on an open issue, its Resolution field in NobleFactor or its `resolution:` label in David-Noble-at-work
(§ The labels a repository provides); two labels of one attribute, such as two `priority:` labels, in a user account;
and `good first issue` on an issue that isn't a task or a bug. And it will return an issue that is a row of more than
one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, or is on more than one
schedule or scenario (§ What has no parent); how it handles one that is in a scenario and in another project, without
taking a scheduled item off its schedule, is #436's to design. It will leave a scenario's rows alone but for two of
these structural rules, on an epic or a feature in a scenario and on an issue that is also a row of another of its
account's projects: every other rule waits until an item found while walking a scenario moves out, when it gets its type
and parent, and moving it straight onto a schedule means classifying it first (§ Scenarios). Exempt from the parent
rule: an epic, and a Schedule or Scenario issue, which have none. Exempt from both the type rule and the parent rule: an
issue waiting in a Triage project. What the audit compares against will be decided with the tooling, #426 and #437.

The sweep will run every day, as a scheduled GitHub Actions workflow in each account's `.github` repository, with the
credentials the Triage workflow uses, and it will comment on each issue it returns, naming the rule the issue broke. The
sweep blocks no filing and corrects nothing by itself: triage fixes each issue it returns by hand. It removes no Triage
row either: triage removes an issue's row as part of its decision, and an issue someone closes outside triage stays in
its Triage project until triage decides its disposition. It waits on #452, which will give every open issue an Area
first (§ What has no parent). A hierarchy type whose description names no level is a fault of the model, not of an
issue, and `star github model pull` and `push` will check it (#426 and #437). #361, which held the audit's faults, was
closed on 2026-11-04 as completed with Resolution Declined.

Only **open** issues are checked: the rules apply to open work, and a closed issue keeps the classification it was left
with. Closed issues were not skipped in the cutover: the chore label was removed from every repository in both accounts,
closed issues included, and so were the `Epic:` and `Thread:` labels.

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
(§ Product and engineering). A repository in David-Noble-at-work carries the `priority:`, `severity:`, `effort:` and
`area:` labels it uses, `area:product` and `area:engineering` among them; NobleFactor uses issue fields
instead (§ Triage classifies, and adds attributes).

**Why a closed issue was not done is its resolution.** In NobleFactor it is the Resolution issue field, a single-select
field with three options: Declined, Duplicate and Invalid. NobleFactor has no `resolution:` labels, and no `duplicate`
or `invalid` labels; they were deleted from its 12 repositories on 2026-11-03. In David-Noble-at-work, which has no
issue fields, it is a label named `resolution:<name>`: `resolution:declined`, `resolution:duplicate` and
`resolution:invalid`, the last two replacing the `duplicate` and `invalid` labels there. There is no `wontfix` or
`declined` label. A resolution goes only on a closed issue; the model records it, as the Resolution field among an
organization's issue fields and as the `resolution:` labels among a user account's labels, and, ruled 2026-11-04, the
sweep (#436) will return an open issue that has one to its team's Triage project (§ Well classified). An issue that was
not done is closed as completed, with its Resolution, or in a user account its `resolution:` label, saying why; GitHub's
`not_planned` close reason is not used. Ruled 2026-11-03.

The model holds an account's issue fields, as it holds its issue types and labels: in NobleFactor,
Priority, Effort, Target date, Resolution, Area and Severity. A user account has none. Ruled 2026-11-03.

**The model's two verbs.** `star github model pull` reads the whole model of any account, ours or not: every repository
the account owns. Pull has no `--repo` option. `--account` names the account and defaults from star configuration's
`github.account`, which defaults to NobleFactor; `--asset` names the model file. `star github model push` will write a
model to an account (#437), and that model will become the account's data model. Pull comes first, then push, and their
account option is `--account`, not `--org`. Ruled 2026-11-02 and 2026-11-03. What push will write (views, `--repo`, the
default of its `--account`) and the default of `--asset` will be decided with the tooling, #426 and #437. Until the
tooling follows, the extension still ships `star github labels audit` and `star github labels sync`, it has no push yet,
and pull still takes `--org`.

GitHub's default labels `enhancement`, `documentation`, `good first issue`, `help wanted` and `question`
are **not types**. They look reasonable at filing time and place nothing. `enhancement` in particular is
the trap: it reads as the natural label for new work and is invisible to the scheme.

**`good first issue` goes on tasks and bugs only.** Ruled 2026-11-04: the label tells a newcomer they can pick the issue
up, and only a task or a bug is a single piece of work; an epic or a feature is a body of work. Read on 2026-11-04,
every NobleFactor repository that takes part carries the label, and so does David-Noble-at-work/.github. personal gets
it, with the color and description David-Noble-at-work/.github's has, from the script of #303's closing pull request, so
that every repository that takes part, in both accounts, holds it. The sweep (#436) will return an issue that carries it
and isn't a task or a bug to its team's Triage project (§ Well classified).

## What the sweep is for

`star github triage sweep` (#436) is the classification check since the audit retired on 2026-11-08. The audit's point
stands: a report that renders a tidy hierarchy while silently omitting the issues it could not place is worse than no
report, because it looks complete. The report now omits nothing, since every issue is a record and one with no type or
no parent says so in its keys, and the sweep sends each open issue that breaks a rule (§ Well classified) to its team's
Triage project, beside its home and never in place of it.
