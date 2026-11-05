---
title: "1. The hierarchy"
---

# 1. The hierarchy

Every classified issue, in an organization's account such as NobleFactor or a user's such as David-Noble-at-work, has a
place in its own account's hierarchy, and the hierarchy has the same shape in both: its Type says which level it is on,
and its parent says where on that level it hangs. Ruled 2026-10-21: every issue is fitted into this hierarchy of issue
types. Ruled 2026-11-03: issues are classified by issue type, in the hierarchy epic, feature, then task or bug,
enforcement is lax, and there are no compliance checks. Superseded in part on 2026-11-04: the sweep (#436) will check
the model's rules every day and return an issue that breaks one to its team's Triage project, and it will block no
filing and correct nothing by itself (§ Triage, below). A new issue has no place until triage classifies it. A Schedule
or Scenario issue is on no level, because its type says it describes a collection.

Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
Scenario are its two peers there.

## Type

Ruled 2026-10-21: the hierarchy's classifiers were Epic, then Chore or Feature, then Bug or Task, each pair mutually
exclusive. Ruled 2026-11-02: Chore is retired, and the hierarchy is Epic on level 0, then Feature on level 1, then Task
or Bug on level 2. Ruled 2026-11-03: issue types are capitalized and labels lowercase, as GitHub names them, and the
issue that describes a schedule, its deliverable and exit criteria, has the type Schedule, while the issue that
describes a scenario has the type Scenario. Threads were renamed scenarios that day, and the type Thread became
Scenario. A schedule is the rows of its team's Schedule project whose Schedule field names it, and a scenario the rows
of its team's Scenario project whose Scenario field names it; there is no longer a project per schedule or per scenario
([section 3](3-collections.md)). Ruled 2026-11-04: a Scenario issue summarizes an end-user goal, and a scenario's rows
are its Scenario issue and the tasks and bugs found while walking it, not features (§ Triage, below).

| Level | Type | Label in a user account | What it is |
| --- | --- | --- | --- |
| 0 | Epic | `epic` | A body of work with an owner; the root its levels below roll up to; decomposes into features |
| 1 | Feature | `feature` | A capability; decomposes into tasks and bugs |
| 2 | Task | `task` | Planned work: a step in delivering a feature |
| 2 | Bug | `bug` | Unplanned work: a defect, found rather than planned; repairs a feature |
| None | Schedule | `schedule` | The issue that describes a schedule: its deliverable and exit criteria |
| None | Scenario | `scenario` | The issue that describes a scenario: the end-user goal it summarizes |

Each type's description in GitHub begins with its level, "Level N:". Schedule's and Scenario's begin "Collection:"
instead, so they have no level. Schedule and Scenario each have an issue form in their account's `.github` repository
(ruled 2026-11-03). Read from GitHub on 2026-11-03, NobleFactor/.github and David-Noble-at-work/.github each hold six
issue forms, one for each type in the table above ([section 6](6-the-asset-and-its-sync.md) § One model per account).
Read 2026-11-04, the Scenario type's description in NobleFactor, and the `scenario` label's in personal and
David-Noble-at-work/.github, still read "Collection: describes a scenario, the story its features tell", the scenario as
it was before that day's ruling; #453 will bring all three to the ruling, with both accounts' Scenario forms.

A triaged issue has exactly one Type. A task or a bug, never both: planned work against unplanned, the split drawn by
the write-up by Gemini the owner shared on 2026-10-21. That write-up's other split, product value against engineering
value, was Feature against Chore until Chore was retired on 2026-11-02. Since 2026-11-03 Area draws it, on issues of
every type (§ Engineering and product, below).

**What changed.** The scheme before this model had five kinds on three tiers, and a chore was a leaf beside a task
and a bug, filed under the enabler features of `Epic:Ops:Process` ([issue-standards.md](../../issue-standards.md)
§ The process epic). That was the scheme until Chore was retired on 2026-11-02. That day the open chores became
tasks, #303 among them, or features where they had steps of their own: #347, #348 and David-Noble-at-work/personal#287.
Chore was retired, not moved up a level, so the enabler features, NobleFactor/noblefactor-ops#151 (agent schedules)
and #156 (issue standards) among them, stay features. The `Epic:Ops:Process` label went with the other `Epic:` labels
on 2026-11-03.

**The `Ops:` segment** marked the tooling axis inside the `Epic:` and `Thread:` labels
([issue-standards.md](../../issue-standards.md) § The Ops axis). Those labels were removed from both accounts on
2026-11-03, and Chore is retired, so neither marks the axis now.

**Engineering and product,** ruled 2026-11-03. The attribute Area tells engineering work from product work. It has
two values, product and engineering, and applies to issues of every type. It describes the issue's own work, so an
epic, a feature and the tasks and bugs under them can each differ: a CI bug fixed during a product feature is
engineering. Engineering covers build orchestration, Makefile changes, CI pipelines, internal agent-workspace scripts
and tools, and governance and process work. Release notes come from the closed product issues in a release, not from
the hierarchy, and product readiness and release management epics hold both kinds ([section 2](2-attributes.md)).

On 2026-11-03 NobleFactor/devlore-cli's seven finer Area labels, architecture, CLI, code quality, error handling, git,
meta and testing, were deleted, and the hierarchy carries those distinctions. Architecture work is a task or a feature
with product value within an epic. A bug isn't filed against the architecture: an architecture task is logged to
address a bug in a feature.

**The name, ruled.** The owner named the field Type and invited alternatives; labels were the other candidate. Ruled
2026-10-22: the hierarchy has three tiers, is modeled with GitHub's parent-child relation between issues, and is based
on Issue Type. Type is GitHub's issue-type field. NobleFactor had Task, Bug and Feature enabled; Epic, Schedule and
Scenario are the organization's own types beside them. Chore was added as a type of the organization's own, then
disabled, and was gone by 2026-11-02. In a user account the lowercase labels are the types (see Per account, below).
In NobleFactor the kind labels of the old scheme were scaffolding on the way to types
([section 5](5-from-todays-scheme.md)).

Ruled 2026-11-03: the old scheme's last three pieces retired that day, and the retirement is done in GitHub. The kind
labels epic, feature, task and bug left NobleFactor's 12 repositories, after 672 issues got the issue type their label
named. David-Noble-at-work keeps its type labels, because they are its types. The parent markers such as
`**Feature:**` came out of the issue bodies (§ Parents, below), and the step and beat tables in 14 Schedule and
Scenario issues gave way to a line naming the issue's board and option ([section 3](3-collections.md)).

**Per account,** ruled 2026-11-02. Type belongs to an account: each organization defines its own issue types. A user
account has no issue types, so it carries each type as a label: its issues carry the type's name in lowercase, `epic`,
`feature`, `task`, `bug`, `schedule` or `scenario`, while the type itself is capitalized (ruled 2026-11-03). Every
repository of the account holds these labels ([section 4](4-storage-and-reach.md) § Accounts). A type's or a type
label's level is the "Level N:" its description begins with; Schedule's and Scenario's descriptions begin "Collection:",
so they have no level. GitHub holds an organization's issue to one type, and nothing in GitHub holds a user account's:
enforcement is lax, and there are no compliance checks (ruled 2026-11-03). Superseded in part on 2026-11-04: the sweep
(#436) will return an issue that carries two type labels to the account's Triage project, and it will block no filing
and correct nothing by itself.

## Parents

- Every issue on a level below 0 has exactly one parent, one level up: a feature under an epic, a task or a bug under
  a feature. Nothing skips a level, and a task or a bug is no issue's parent. The parent is GitHub's own parent-child
  relation between issues, the sub-issue link, ruled 2026-10-22. It was already in use that day: 66 of
  noblefactor-ops's 89 open issues carried one, #266 holding 43 under #142.
- The parent markers of the old scheme, such as `**Feature:**`, are retired (ruled 2026-11-03). That day the markers
  and schedule footers came out of 725 issue bodies, and 47 issues got the sub-issue parent their marker named. Where
  a marker and a sub-issue link disagreed, the link stands.
- Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.
- An issue's epic is not a label of its own. Ruled 2026-10-21: epic is a value of an issue's kind, a peer of the
  other kinds, and not a label. An issue's epic is read from its parents. The `Epic:<Name>` labels, and the `Thread:`
  labels with them, were removed from both accounts on 2026-11-03, after the 49 open issues tied to an epic or a
  scenario, then called a thread, only by a label had been placed: under the epic the label named, in the project
  the thread then had, or in their Triage project. Sub-issue parent links and project rows replace them.
- Parents cross repositories only within one account. No sub-issue or blocked-by link crosses accounts, and work that
  waits on another account uses a stand-in issue in its own account (ruled 2026-11-02;
  [section 4](4-storage-and-reach.md) § Accounts). The personal issues that still hang under NobleFactor issues are
  crossings that #428 removes.

## Triage

Ruled 2026-10-21: a triage queue is needed, because bugs are unplanned and are logged without knowing where they fit
in the hierarchy. Bugs are filed without ceremony and classified by a triage team.

Ruled 2026-10-21, the plan's question 4: an issue is fully classified or it is not, and any issue, of any type or
none, can be added to a Triage project. Issues sent for review are those added to it. GitHub's searches, such as
`no:type` and `no:parent-issue`, find issues that can be added to it periodically.

Ruled 2026-11-03: there is no triage epic and no Triage issue type. Each team owns its Triage project, and a user
account owns its own. A new issue of any kind goes into its team's Triage project until it is classified. The Triage
project is where every issue is reviewed and a triage decision made: the work is declined, or the issue moves to the
team's Backlog, Schedule or Scenario project. Superseded in part on 2026-11-04: a work item logged while walking a
scenario goes into the scenario instead; accepted tasks and bugs go to the Backlog or onto a schedule; an issue moves to
another team in one act, between its team's Triage project or schedule and the other team's: triage to triage, triage to
schedule, schedule to triage, or schedule to schedule; and an epic or a feature, once classified, leaves Triage for no
project (below).

- An issue is fully classified or it is not. Fully classified is a Type and, below level 0, a parent one level up. An
  issue with no Type, or below level 0 with no parent, is untriaged, and waits in its team's Triage project, or its
  account's in a user account, or in the scenario whose walk found it, until triage classifies it.
- New issues reach their team's Triage project through a GitHub Actions workflow in each repository, run when an issue
  is opened or transferred, using `actions/add-to-project`; GitHub's built-in auto-add workflow is not used. Today only
  personal runs it: NobleFactor's five participating repositories will once #448 lands, and David-Noble-at-work/.github
  once David-Noble-at-work/personal#311 does. Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage
  project, from the team mapping: the team with the maintain role on a repository owns it. A Triage workflow template in
  each account's `.github` repository offers the workflow (ruled 2026-11-03; [section 6](6-the-asset-and-its-sync.md)
  § One model per account). GitHub's documentation describes workflow templates in an organization's `.github`
  repository and says nothing about a user account's, and whether GitHub offers David-Noble-at-work/.github's template
  to personal has not been checked; either way, David-Noble-at-work/personal#315 copies personal's `triage.yml` from it
  ([section 4](4-storage-and-reach.md#triage)). GitHub Actions cannot run a workflow when a project row changes:
  `projects_v2_item` is a webhook event for organization webhooks and GitHub Apps only.
- Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an
  organization, or when it has the topic issue-model, in a user account.
- Issues we file ourselves will go through `star github issue` once it is built (#338), the one path that will classify
  an issue as it is made (ruled 2026-11-03).
- A blank Area is an error, caught at three points (ruled 2026-11-03). At filing, `star github issue` will refuse an
  issue without an Area (#338), and the issue forms in each account's `.github` repository have a required Area dropdown
  ([section 6](6-the-asset-and-its-sync.md) § One model per account), whose answer the repository's Triage workflow
  copies into the Area field or label when the issue is opened: personal's adds the `area:` label today, and
  NobleFactor's will set the Area field once #447 and #448 land. The form checks the Area in a public repository; GitHub
  enforces a form's required fields only there (GitHub's form schema documentation, read 2026-11-04). In a private
  repository that takes part, today only personal, nothing checks it at filing until `star github issue` does. At
  triage, each Triage project has the Area field (in a user account, the `area:` labels in its Labels field) and a
  Missing Area view, both made 2026-11-03, and the script of #303's closing pull request shows that field in every
  Triage view; nothing leaves Triage without an Area. Afterward, a scheduled sweep (#436) will return any open issue
  without an Area to its team's Triage project, and #452 will give every open issue an Area before the sweep runs.
- The untriaged are first the rows of the Triage projects. GitHub's own queries catch any issue that missed one:
  `no:type` and `no:parent-issue`. A user account has no issue types, so there an issue with no type is one that
  carries none of the type labels `epic`, `feature`, `task`, `bug`, `schedule` and `scenario`. On 2026-10-21,
  `is:open no:parent-issue` found 23 of noblefactor-ops's 89 open issues.
- What is sent for review is what is in a **Triage project**, one of the four projects of each team and each user
  account in [section 3](3-collections.md), beside Backlog, Schedule and Scenario: every new issue but a work item
  logged while walking a scenario (below), until it is classified, and any issue, of any Type or none, that a person
  adds to have it looked at or a query adds. There are three. Triage: engprod (NobleFactor project 5) and Triage:
  devlore (NobleFactor project 6) were both brought to the Triage template, NobleFactor project 23, and Triage:
  David-Noble-at-work (David-Noble-at-work project 3) was copied from it. A new Triage project in David-Noble-at-work is
  copied from that account's copy of the template, its project 4. An issue leaves a Triage project classified, or closed
  with a reason. A triage decision declines the work, and the issue is closed as completed, with Resolution Declined in
  NobleFactor or the `resolution:declined` label in a user account, or it moves the issue to the team's Backlog,
  Schedule or Scenario project (ruled 2026-11-03, and superseded in part on 2026-11-04, below). An issue that wasn't
  done is closed as completed, with its reason saying why: in NobleFactor its Resolution issue field, Declined,
  Duplicate or Invalid, and in David-Noble-at-work a label, `resolution:declined`, `resolution:duplicate` or
  `resolution:invalid`; GitHub's not_planned close reason isn't used (ruled 2026-11-03).
- Ruled 2026-11-04: triage removes an issue's Triage row as part of its decision. An issue someone closes outside triage
  stays in its Triage project until triage decides its disposition. The sweep (#436) will remove no Triage row: #436's
  Done-when no longer has star remove an issue once it is classified or closed, as its comment of 2026-11-04 records.
  Read 2026-11-04, 78 of Triage: engprod's 178 rows were closed issues; they are triage's to decide.
- Ruled 2026-11-04, the plan's questions 4 and 9: every move of an issue from one project to another is one act, a move
  to another team's project included (below). The issue gets its row in the project it goes to, with that project's
  fields set, and loses its row in the project it leaves. Out of Triage, declined work is closed as completed with
  Resolution Declined, and accepted tasks and bugs go to the Backlog with their Priority or onto a schedule. From the
  Backlog, work goes onto a schedule highest Priority first, and onto a committed schedule only by its owner's
  amendment, recorded in the Schedule issue; `star github schedule add` (#438) will make that move in one command
  ([section 3](3-collections.md#triage-and-the-backlog)).
- Ruled 2026-11-04: epics and features are never rows of a Backlog, Schedule or Scenario project. A new one reaches
  Triage like every new issue and, once classified, leaves Triage for no project: the hierarchy holds it, and its tasks
  and bugs are what reach the Backlog and the schedules, from which a work item's parent link leads to its feature and
  its epic. So the only rows of a Schedule or Scenario project that are not tasks or bugs are the Schedule and Scenario
  issues themselves. Read 2026-11-04, five features were rows: #140 and #151 of Scenario: engprod,
  NobleFactor/devlore-cli#762 and #847 of Scenario: devlore, and NobleFactor/devlore-cli#1023 of Schedule: devlore. The
  script of #303's closing pull request removes those rows, first commenting on each scenario's Scenario issue naming
  the features it exercised. The sweep (#436) will return an epic or a feature that is a row of a Backlog, Schedule or
  Scenario project to its team's Triage project.
- Ruled 2026-11-04: one project at a time holds across the whole account. An issue is a row of at most one of its
  account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most one schedule or
  scenario. An issue on another team's project is assigned to an accountable member of that team: GitHub allows up to 10
  assignees on an issue, any organization member who can read the repository among them (GitHub's documentation on
  assigning issues, read 2026-11-04), and all five of NobleFactor's participating repositories are public. The person
  whose name is on an issue moves it to another team the way any move is made, in one act, between its team's Triage
  project or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or schedule to
  schedule. This supersedes in part the ruling of 2026-10-22 that work for another team gets a tracking issue (below).
  The sweep (#436) will check the rule across all of the account's projects, Scenario projects included, and return an
  issue that breaks it to its team's Triage project, or in a user account to the account's
  ([section 2](2-attributes.md#the-attributes)). This rule is one of the two the sweep will apply to a scenario's rows
  (below), and [section 3](3-collections.md#triage-and-the-backlog) gives the moves that keep it. How the sweep will
  handle an issue that is a row of a scenario and of another project, without taking a scheduled item off its schedule,
  is #436's to design. Read 2026-11-04, 14 tasks and bugs were rows of both a Schedule and a Scenario project, and #252
  a row of both Triage: engprod and Scenario: devlore. Each had already moved on, so the script of #303's closing pull
  request removes those 15 Scenario rows, recording each on its Scenario issue. Read the same day, 30 open issues in
  NobleFactor's Triage projects were also rows of a Schedule project, their own team's or another's, and the same script
  deletes their Triage rows. David-Noble-at-work/personal#268 and #275, rows of Triage: David-Noble-at-work and of
  Schedule: devlore, keep their Triage rows: their Schedule: devlore rows are crossings that #428 removes.
- **Scenarios.** Ruled 2026-11-04: a scenario is a high-level description of a feature, a workflow or a real-life
  situation that needs to be tested. Its Scenario issue, its own row in the team's Scenario project, summarizes an
  end-user goal. It drives planning, coverage and team alignment, includes an example for demos and ad-hoc testing that
  helps find gaps and defects no other kind of testing finds, and names in its body the features it exercises. A
  scenario is structurally like a schedule that starts with no tasks or bugs: they are found with time. Someone opens
  the scenario and walks it, logging work items as they go, each a task or a bug and a row of the team's Scenario
  project under the scenario's option, its Beat the point in the walk where it turned up. A logged item names its
  scenario in its body, as "Found while walking #N", and the Triage workflow will add it to the scenario instead of to
  the team's Triage project (#448); every other new issue goes to Triage. Each item later moves to its team's Triage
  project or straight onto a schedule, and leaves the scenario; the item's body and a comment on the Scenario issue
  record the move. The sweep will leave a scenario's rows alone but for two structural rules: it will return an epic or
  a feature that is a row of the Scenario project, as it will one on a Backlog or Schedule project, and an issue that is
  a row of a scenario and of another of the account's projects, whichever team owns it (above). Every other rule waits
  until an item moves out: it gets its type and parent then, and moving straight onto a schedule means classifying it
  first. A scenario never ends: it is kept, updated or removed as the product changes, since it has value before, during
  and after a release. Its Scenario issue never closes, so it states no evidence of completion (§ How long a level
  lives, below). #453 will bring both accounts' Scenario forms to this, and with them the Scenario type's description
  and the `scenario` label's in personal and David-Noble-at-work/.github (§ Type, above).
- Triage gives an issue its Type, its parent and its Area and, for a bug, its severity, and N/A on any other type
  ([section 2](2-attributes.md)). Ruled 2026-11-04: an issue that arrives with no type gets no Severity; when triage
  gives it a type other than Bug, triage sets its Severity to N/A, and the sweep (#436) will catch a miss.
- The parent rule binds classified issues, and untriaged ones are exempt from it. Enforcement is lax, and there are no
  compliance checks (ruled 2026-11-03), superseded in part on 2026-11-04 by the sweep (#436), which will block no filing
  and correct nothing by itself. Today's standard already exempts "a bug awaiting triage"; this keeps that and extends
  it to an issue filed with no Type at all.
- There is no triage epic and no Triage type (ruled 2026-11-03). #142 had been the triage epic since 2026-10-22, the
  parent of every newly logged issue until triage placed it and row 0 of engprod's Triage project. It is retired,
  with NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313, and their 24 open sub-issues became rows of
  their Triage projects. A Triage project has no row 0. A new issue has no parent until triage gives it one, so
  `no:parent-issue` again finds the untriaged, beside the epics, which have no parent.
- **Teams triage their own issues.** Ruled 2026-10-22: teams triage their own issues, and the owner is on every team. A
  team that logs an issue against another team's repository keeps it on its own plate with a tracking issue, or moves it
  to that team and perhaps tracks it there. Ruled 2026-11-03: each team owns its Triage project, with no triage epic and
  no row 0, and a user account owns its own. An issue filed against another team's repository goes into that team's
  Triage project. When that repository is in another account, the finder's tracking issue is a stand-in in its own
  account, with no link across (ruled 2026-11-02). Superseded in part on 2026-11-04: within one account, work for
  another team needs no tracking issue; the person whose name is on it moves it to that team in one act, and it is
  assigned to an accountable member there (above). The owner is on every team today. The plan's question 4, closed.
- **Who answers for a project.** Ruled 2026-11-03: the team that owns a project, its Triage project among them, is
  accountable for it, and GitHub's link between the project and its team is the record. The team with the maintain
  role on a repository owns that repository. A user account's projects are its owner's.
- **Who moves an issue.** Ruled 2026-11-04: any member of a team can see all of the team's issues and do all of its work
  in its four projects: triage, the backlog, scheduling and scenarios. So the one grant a new participant needs is
  membership in the team, whose roles carry the rest: the maintain role on each repository the team owns, and the write
  role on each of its four projects, which the script of #303's closing pull request sets. A user account has no teams;
  there, a new participant is a collaborator on each participating repository, personal and David-Noble-at-work/.github,
  and a writer on each of the account's four projects. Adding a person to NobleFactor needs a seat first: its Team plan
  has one seat, filled (read 2026-11-04). The person whose name is on an issue moves it to another team, where it is
  assigned to an accountable member of that team (above). Setting a parent across two teams' repositories needs the
  triage role on both (GitHub's REST documentation for an issue's `parent_issue_id`, read 2026-11-04). devlore holds the
  write role on noblefactor-engprod, so a devlore member can link a devlore issue to a noblefactor-engprod parent and
  back; engprod holds no role on devlore's repositories, so an engprod member can't. An organization owner holds the
  admin role on each of the organization's repositories, and so can set a parent between any two (read 2026-11-04). The
  full table is [issue-standards.md § Who can do what](../../issue-standards.md#who-can-do-what).

## How long a level lives

Every issue states its evidence of completion (ruled 2026-11-02). Superseded in part on 2026-11-04: every issue but a
Scenario issue states its evidence of completion. A scenario never ends, so its Scenario issue never closes and has
nothing to evidence. On both accounts' Scenario forms, #453 will put how to walk it, the example the Scenario issue
gives, in place of the Evidence of completion section, and the sweep's rule on a missing Evidence of completion section
will skip a Scenario issue ([section 2](2-attributes.md#the-attributes)). An epic closes when its features ship. Its one
exception, `Epic:Ops:Process`, which never closed ([issue-standards.md](../../issue-standards.md) § The process epic),
ended on 2026-11-03, when its label was removed and #142 was retired.

- **Long-lived level 1,** from the Gemini write-up, considered and not taken on 2026-11-03: a feature stays open for
  the life of what it delivers, and a bug found in shipped work is parented to the original, so that a capability's
  whole cost, and its ratio of bugs to tasks, can be counted. That changes what "done" means for a feature, and with
  it what a long-lived feature's evidence of completion is.
- **Ruled 2026-11-03, the plan's question 2:** a feature stays open after its tasks and bugs are done. It closes only
  after an agent has audited it for compliance and an agent has reviewed its code, with the team lead's sign-off.
- **A standing engineering epic,** the plan's question 3, closed. Ruled 2026-10-21: there is no standing epic. #142 was
  the triage epic from 2026-10-22 until it was retired on 2026-11-03. There are no chores left to need an epic, and
  noblefactor-ops became noblefactor-engprod, the repository of NobleFactor Engineering Productivity, with
  NobleFactor/noblefactor-ops#304 on 2026-11-02.

## What the hierarchy does not hold

Order, and the collections that cut across it: the Triage, Backlog, Schedule and Scenario projects, with their
schedules and scenarios, are [section 3](3-collections.md). An issue's attributes are [section 2](2-attributes.md).
