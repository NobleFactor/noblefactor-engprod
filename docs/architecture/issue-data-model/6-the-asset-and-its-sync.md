---
title: "6. The asset and its sync"
---

# 6. The asset and its sync

Ruled 2026-11-03: the model is a YAML description of an account's data model. GitHub holds the data model itself; the
model file describes it, and each account's model file is stored in that account's `.github` repository (ruled
2026-11-02). Two commands move the model between GitHub and the file. `pull` reads the data model of any account, ours
or not, into a model file. `push` writes a model to an account, and that model becomes the account's data model. The
model is a cache: star queries it instead of asking GitHub the same questions again, and builds sensible queries and
updates from it. On 2026-10-21 the owner held that the model's file should travel with the extension and drive its
behavior, as the definitive configuration, and on 2026-10-22 that star should read GitHub by ETag and offer pull and
push as commands; since 2026-11-02 the file belongs in each account's `.github` repository instead. Whether star reads
GitHub by ETag before every operation or answers from the model until the next pull is decided with #426.

## One model per account

Ruled 2026-11-02. Every GitHub account, an organization or a user, has a data model of its own and a model file of its
own, however many accounts there are ([section 4](4-storage-and-reach.md) § Accounts). Ruled 2026-11-03, what a model
holds:

- **An organization's model** holds its issue types (Epic, Feature, Task, Bug, Schedule and Scenario), its issue
  fields (in NobleFactor, Priority, Effort, Target date, Resolution, Area and Severity), its teams, the labels of each
  of its repositories, and its four project templates, Triage, Backlog, Schedule and Scenario, with their custom
  fields, options and views, among them the Schedule and Scenario fields and Iteration.
- **A user account's model** holds its type labels, lowercase (epic, feature, task, bug, schedule and scenario), the
  labels of each of its repositories, and the projects it keeps in place of templates. It holds no issue fields,
  because a user account has none; a label stands in for each option of a single-select field
  ([section 4](4-storage-and-reach.md#a-user-account)). A user account cannot mark a project as a template, so
  David-Noble-at-work keeps copies of the four templates, named Triage, Backlog, Schedule and Scenario, to copy new
  projects from (ruled 2026-11-03).
- **Neither holds** issues, the projects made from templates, any project's built-in workflows, or an organization's
  default labels. Ruled 2026-11-03: labels are held per repository, and a project's built-in workflows are fixed GitHub
  functions with arguments. Since 2026-11-03 no template or copy, and none of each team's and the user account's four
  projects, has one: GitHub's API can't make one or turn one on, so the projects of a kind match only with none
  ([section 3](3-collections.md#triage-and-the-backlog)). Also ruled 2026-11-03: GitHub's built-in
  auto-add workflow is not used; a new issue reaches its team's Triage project through a GitHub Actions workflow in
  its repository, run when an issue is opened or transferred, using `actions/add-to-project`. GitHub Actions cannot run
  a workflow when a project row changes: `projects_v2_item` is a webhook event for organization webhooks and GitHub
  Apps only.

Ruled 2026-11-03: an account's model holds its issue fields, as it holds its issue types and labels. NobleFactor's
are Priority, Effort, Target date, Resolution, Area and Severity; its Start date field stays unused. A user account has
no issue fields, so its model holds none.

Nothing is shared between models: two accounts may give a type or a label the same name, and neither model reads the
other. `pull`, `push`, the report and the audit each work on one account at a time. The report and the audit pick the
model by the repository's owner. `pull` takes its account from `--account`, which defaults from star configuration,
`github.account`, and that defaults to NobleFactor (ruled 2026-11-03); what `push`'s `--account` defaults to is decided
with #437. The cache keeps a file per account.

Question 17 is settled. Ruled 2026-11-02: each account's model file is stored in that account's `.github` repository,
NobleFactor/.github and David-Noble-at-work/.github. GitHub treats a public repository named `.github` as the account's
own and serves its default community health files and issue templates to every repository of the account; the issue
forms for Schedule and Scenario issues are kept there too, and so is the Triage workflow template (ruled 2026-11-03).
Each repository's Triage workflow, which adds its new issues to its team's Triage project, is made from it. Ruled
2026-11-03: the issue forms in each account's `.github` repository have a required Area dropdown, and the Triage
workflow copies its answer into the Area issue field, or in a user account the `area:` label, when the issue is opened:
personal's adds the `area:` label today, and NobleFactor's will set the Area field once #447 and #448 land. Both
repositories exist. NobleFactor's `model.yaml` beside the extension predates the ruling and moves with #431;
David-Noble-at-work's model file lands with David-Noble-at-work/personal#311.

Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull
request template, are stored in its `.github` repository, and every document that talks about one of them refers to it
there. These are files. The project templates, and David-Noble-at-work's copies of them, are GitHub projects, which the
model describes (§ The asset, under `projects`).

Read from GitHub on 2026-11-03, each `.github` repository holds `README.md`, the six issue forms (bug, epic, feature,
scenario, schedule and task) and the Triage workflow template (`triage.yml` and `triage.properties.json`):

- [NobleFactor/.github](https://github.com/NobleFactor/.github) holds its issue forms in
  [`.github/ISSUE_TEMPLATE`](https://github.com/NobleFactor/.github/tree/HEAD/.github/ISSUE_TEMPLATE) and its Triage
  workflow template in [`workflow-templates`](https://github.com/NobleFactor/.github/tree/HEAD/workflow-templates), and
  also `.github/workflows/quality-gate.yml`.
- [David-Noble-at-work/.github](https://github.com/David-Noble-at-work/.github) holds its issue forms in
  [`.github/ISSUE_TEMPLATE`](https://github.com/David-Noble-at-work/.github/tree/HEAD/.github/ISSUE_TEMPLATE) and its
  Triage workflow template in
  [`workflow-templates`](https://github.com/David-Noble-at-work/.github/tree/HEAD/workflow-templates). Read the same
  day, GitHub's documentation [describes workflow templates kept in an organization's `.github` repository](
  https://docs.github.com/en/actions/how-tos/reuse-automations/create-workflow-templates) and says nothing about a
  user account's. Whether GitHub offers this template to personal has not been checked; either way,
  David-Noble-at-work/personal#315 copies personal's `triage.yml` from it.

Neither holds a pull request template yet, nor `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md` or the account's model
file. The pull request templates are part of #431 for NobleFactor/.github and David-Noble-at-work/personal#311 for
David-Noble-at-work/.github, the issues that bring each account's model file there.

## Reference models, read on demand

Ruled 2026-11-02. Two reference models live beside the extension, one for an organization's account and one for a
user account. Each holds, in its records, what a model needs and nothing of any one account, with no ids and no account
names (noblefactor-engprod#425): the issue types or type labels, those of the hierarchy with their levels and Schedule
and Scenario, whose descriptions begin `Collection:` (ruled 2026-11-03); and the Triage, Backlog, Schedule and Scenario
templates with their custom fields, options and views, and no built-in workflows. The user account's reference model,
`user.yaml`, lists the labels that stand in for NobleFactor's single-select issue fields, the `area:`, `priority:`,
`severity:`, `effort:` and `resolution:` labels; whether a reference model holds a repository's other labels is decided
with #426, how each account's model is read, and #437, `push`. The same day the owner revised where each account's model
lives: not nowhere, as first ruled, but in a file in the account's own public `.github` repository
(§ One model per account).

- **Adopting the model is a deliberate act.** An account takes the model when the owner pushes one to it, a reference
  or a change to it, and never otherwise. `pull` reads the data model of any account, ours or not, whether or not a
  model was ever pushed to it.
- **Each of our accounts keeps its model file in its own `.github` repository.** Neither account's model file had
  landed on 2026-11-03; § One model per account says what each `.github` repository held that day. Ruled 2026-11-03:
  NobleFactor/.github gets a quality-gate check of its own, so it follows the organization's ruleset like every other
  repository. An account that is not ours has no such file; `pull` writes its model wherever `--asset` names.
- **How a change the owner makes in GitHub reaches star** is decided with #426: whether star reads GitHub by ETag
  before every operation or answers from the model until the next pull.
- **What the audit compares an account against,** its model file, its reference or both, is decided with #426 and
  #437.
- **Restoring an account** is pushing its model file as it stood at a commit of the account's `.github` repository
  from before the mistake (§ Recovery). Only what changed in GitHub since the last pull lives only in GitHub.

Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an organization,
or when it has the topic issue-model, in a user account.

## The asset

Superseded 2026-11-02 by § Reference models, read on demand, and restored the same day, when the owner ruled that each
account's model file is kept in the account's `.github` repository. This section describes that file, the asset.

Each account's model file is in that account's `.github` repository: NobleFactor's in NobleFactor/.github,
David-Noble-at-work's in David-Noble-at-work/.github. Writ does not deploy it with the extension, and star finds it by
`--asset` (ruled 2026-11-03), whose default is decided with #426 and #437. NobleFactor's file as pulled on 2026-11-02 is
still `model.yaml` beside `extension.yaml` in `com.noblefactor.ops.GitHub`, and moves with #431. An organization's file
holds these records:

```yaml
version: 1
pulled:
  at: 2026-11-03T07:40:12Z
  account: NobleFactor
  digest: sha256:9b1e…
types:
  - { name: Epic,     id: 914457658, level: 0 }
  - { name: Feature,  id: 344350,    level: 1 }
  - { name: Bug,      id: 344348,    level: 2, unplanned: true }
  - { name: Task,     id: 344346,    level: 2 }
  - { name: Schedule, id: …  }        # no level: its description begins "Collection:"
  - { name: Scenario, id: …  }        # no level: its description begins "Collection:"
fields:                               # the account's issue fields; a user account has none
  - { name: Priority,    id: …, type: … }
  - { name: Effort,      id: …, type: … }
  - { name: Target date, id: …, type: date }
  - name: Resolution                  # set only on a closed issue
    id: …
    type: single-select
    options:
      - { name: Declined, id: … }
      - { name: Duplicate, id: … }
      - { name: Invalid, id: … }
  - name: Area                        # every issue has one: product or engineering work
    id: …
    type: single-select
    options:
      - { name: Product, id: … }
      - { name: Engineering, id: … }
  - name: Severity                    # a bug's harm; every issue of another type has N/A
    id: …
    type: single-select
    options:
      - { name: Critical, id: … }
      - { name: High, id: … }
      - { name: Medium, id: … }
      - { name: Low, id: … }
      - { name: N/A, id: … }          # made by the script of #303's closing pull request
teams:
  - { name: devlore, slug: devlore, id: T_kwDO… }
  - { name: engprod, slug: engprod, id: T_kwDO… }
labels:                               # held per repository, every repository the account owns
  NobleFactor/noblefactor-engprod:
    - { name: good first issue, color: "7057ff", description: "Good for newcomers" }   # on tasks and bugs only
    - { name: …, color: "…", description: "…" }
  NobleFactor/devlore-cli:
    - { name: good first issue, color: "7057ff", description: "Good for newcomers" }
    - { name: …, color: "…", description: "…" }
projects:                             # the account's four project templates
  - name: Triage
    id: PVT_kwDO…
    template: true
    fields: …
  - name: Backlog
    id: PVT_kwDO…
    template: true
    fields: …
  - name: Schedule
    id: PVT_kwDO…
    template: true
    fields:
      - name: Schedule                # one option per schedule, named for its Schedule issue
        id: PVTSSF_lADO…
        type: single-select
      - name: Step
        id: PVTF_lADO…
        type: number
      - name: Iteration
        id: PVTIF_lADO…
        type: iteration
      - name: Status
        id: PVTSSF_lADO…
        type: single-select
        options:
          - { name: Open, id: 1a9e… }
          - { name: In progress, id: 8f2c… }
          - { name: Closed, id: c04b… }
      - name: Worktree
        id: PVTF_lADO…
        type: text
    views:
      - { name: …, layout: table }
  - name: Scenario
    id: PVT_kwDO…
    template: true
    fields:
      - name: Scenario                # one option per scenario, named for its Scenario issue
        id: PVTSSF_lADO…
        type: single-select
      - name: Beat
        id: PVTF_lADO…
        type: number
      - …
```

- **`version`** is the file's own schema. The extension refuses a version it does not know.
- **`pulled`** records where the file last came from: the account it was read from, an organization or a user, as
  `--account` named it, and the time. Not the ETags: those are a cache, below. NobleFactor's file as pulled, and `pull`
  as built, still name the account with the key `org`.
- **`pulled.digest`** is a SHA-256 over the file with that one line excluded, written by `pull`. The extension
  recomputes it on every load. A mismatch means the file was edited by hand since its pull: a read-only operation
  runs anyway and says so in one header line, never failing the extension's load, since star loads every command file
  with the extension and a failure there would take `pull` and `digest`, the commands that repair it, down too (built
  2026-10-24, #377), `push` refuses, and the gate of the repository that holds the file fails a pull request that
  carries a mismatched one. The fix is a `pull`, which rewrites file and digest together, or a deliberate edit
  followed by `star github model digest`, which re-signs it and leaves the edit in the diff for review. A digest, not a
  signature: on 2026-10-22 the owner ruled that the concern is clumsy edits, not security, and git already says who.
  What it does not catch, an edit followed by a re-digest, is the pull request's to catch.
- **`types`** is the account's issue types, or its type labels in a user account. Those of the hierarchy, Epic, Feature,
  Task and Bug, carry their levels. Schedule and Scenario have no level: their descriptions begin `Collection:` (ruled
  2026-11-03). Ruled 2026-11-03: a Schedule issue holds a schedule's deliverable and exit criteria, and the Schedule
  field of its team's Schedule project has an option named for it; a Scenario issue tells a scenario's story, and the
  Scenario field of its team's Scenario project has an option named for it. Ruled 2026-11-04: a Scenario issue
  summarizes an end-user goal instead (below, under `projects`). Read that day, the Scenario type's description is still
  "Collection: describes a scenario, the story its features tell", as are the `scenario` labels' in personal and
  David-Noble-at-work/.github, and #453 will bring all three to the ruling, with the Scenario forms. Issues are
  classified by issue type, in the hierarchy epic, feature, then task or bug; enforcement is lax and there are no
  compliance checks, a ruling superseded in part on 2026-11-04: the sweep (#436) will be the one check, and it will
  block no filing and correct nothing by itself. From the levels the extension will derive the rest of the hierarchy
  (#376): level 0 has no parent, the last level is the one a schedule's steps are drawn from, a parent is one level up,
  and the types of one level are mutually exclusive. Ruled 2026-10-21: a level number is enough to state the hierarchy,
  and the types of each level are mutually exclusive. Nothing in the extension will name a type (#376, filed
  2026-10-22). Two things the levels do not say, so the asset does: the order of the types within a level is the order
  the report renders them in, Bug before Task as the asset lists them; and `unplanned: true` marks the leaf type that is
  found rather than planned, the one Severity attaches to.
- **A type is keyed by its id, never its name,** so that the owner can rename one, as the owner asked on 2026-10-22.
  GitHub's issue type has a name, a description, a color and an enabled flag, and nothing about hierarchy; an issue
  holds its type by id, so a rename made in GitHub reaches every issue at once. `pull` matches the same id under a new
  name, prints it as a rename, and rewrites the asset; the level survives because it hangs on the id. The extension
  reads a type's name only to display it. Level in the type's description, or depth measured from the sub-issue graph,
  were considered; depth was set aside, since it measures what is rather than stating what should be, and the audit
  needs the rule. **The description is the convention, ruled 2026-10-22:** the description of every type of the
  hierarchy begins `Level N:`, so that GitHub's own settings page states the hierarchy and a person has one place to
  look. The owner ruled to rely on the convention: it may be followed wrongly, but there is one place to look to see
  that it was, and pulling the model is the simplest way to look. `pull` reads the level from the description, the asset
  records it, and the audit still reports a type whose description names a level the asset disagrees with. Ruled
  2026-11-04: a hierarchy type whose description names no level is a fault of the model, not of an issue, and `pull` and
  `push` will check it (#426 and #437), as the plan's question 18 has it. What `pull` does with an account whose type
  descriptions lack `Level N:` is decided with #426 and #437. As built (#377), `pull` records a conflict for every type
  whose description does not begin `Level N:`, then exits 1 and writes nothing, so it stops on NobleFactor's Schedule
  and Scenario types, whose descriptions begin `Collection:`. The parent markers in issue bodies named types as text,
  their words being type names, until they were removed on 2026-11-03.

  Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.

  Ruled 2026-11-03: the old scheme's last three pieces retired, and the retirement is done in GitHub. The parent
  markers and schedule footers came out of 725 issue bodies; 47 issues got the sub-issue parent their marker named, and
  where marker and link disagreed, the link stands. The step and beat tables in 14 Schedule and Scenario issues gave way
  to a line naming the issue's board and option. The kind labels epic, feature, task and bug left NobleFactor's 12
  repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its type labels,
  because they are its types.
- **`fields`** is the account's issue fields, held as the model holds its issue types and labels (ruled 2026-11-03).
  NobleFactor's are Priority, Effort, Target date, Resolution, Area and Severity; its Start date field stays unused.
  Ruled 2026-11-03: Severity is an issue field of the organization ([section 2](2-attributes.md#the-attributes)). Ruled
  2026-11-04: Severity applies to bugs only, and every issue of another type has Severity N/A: in NobleFactor, a new
  option N/A of the Severity field, and in a user account a new label, `severity:n/a`, both made by the script of #303's
  closing pull request. A bug has Critical, High, Medium or Low, never N/A. A user account has no issue fields, so its
  model holds none and the account uses labels instead, one for each option of a single-select field
  ([section 4](4-storage-and-reach.md#a-user-account)). Area tells engineering work from product work and has two values
  only: the options Product and Engineering of NobleFactor's Area field, made 2026-11-03, and in a user account the
  labels `area:product` and `area:engineering` (ruled 2026-11-03).
- **`teams`** is the account's teams ([section 4](4-storage-and-reach.md) § Where each part is defined). A user account
  has none. Ruled 2026-11-03: each team, and each user account, has four projects, Triage, Backlog, Schedule and
  Scenario, named `<Kind>: <team>` in an organization, as in `Triage: engprod` and `Scenario: devlore`, and
  `<Kind>: David-Noble-at-work` in the user account. The team that owns a project is accountable for it, and GitHub's
  link between a project and its team is the record; a user account's projects are its owner's. The team with the
  maintain role on a repository owns that repository, and each repository's `TRIAGE_PROJECT_URL` variable names its
  team's Triage project, from that mapping (ruled 2026-11-03).
- **The repositories** are every repository the account owns, each with its labels: `pull` takes the whole model and
  has no `--repo` (ruled 2026-11-03). That supersedes the ruling of 2026-10-22 that a repository was in when a
  schedule, a scenario, a filing or `--repo` named it.
- **`labels`** is the labels of each repository the account owns, read from GitHub in the API's own fields and held per
  repository, with no organization or team tier; an organization's default labels are not in the model (ruled
  2026-11-03). The labels that remain are lowercase, among them a user account's `severity:`, `priority:`, `effort:` and
  `area:`, as in `severity:critical`, `priority:urgent` and `area:engineering`. Issue fields are used wherever an
  account has them: in NobleFactor, its Priority, Effort, Target date, Resolution, Area and Severity fields are used,
  but not Start date; David-Noble-at-work, which has no issue fields, uses the labels (ruled 2026-11-03). devlore-cli's
  seven finer Area labels, architecture, CLI, code quality, error handling, git, meta and testing, were deleted on
  2026-11-03; the hierarchy carries those distinctions. Why a closed issue was not done is recorded two ways. In
  NobleFactor it is the Resolution issue field, a single-select field with the options Declined, Duplicate and Invalid;
  NobleFactor has no `resolution:`, `duplicate` or `invalid` labels. In David-Noble-at-work it is a label named
  `resolution:<name>`: `resolution:declined`, `resolution:duplicate` and `resolution:invalid`, which replaced the
  `duplicate` and `invalid` labels there. There is no `wontfix` or `declined` label. A resolution goes only on a closed
  issue; the model records the Resolution field among an organization's issue fields and the `resolution:` labels among
  a user account's labels, and the sweep (#436) will return an open issue that has one to its team's Triage project. An
  issue that was not done is closed as completed with its Resolution, or in a user account its `resolution:` label,
  saying why, never with GitHub's not-planned reason (ruled 2026-11-03). Ruled 2026-11-04: `good first issue` goes on
  tasks and bugs only, and personal gets the label, made by the script of #303's closing pull request, so that both
  accounts hold it.
- **`projects`** is the account's project templates with their custom fields, options and views
  ([section 3](3-collections.md)). Ruled 2026-11-03: NobleFactor's are Triage (project 23), Schedule (project 7),
  Scenario (project 8, the former Thread template) and Backlog (project 24). David-Noble-at-work cannot mark a project
  as a template, so it keeps copies of them to copy new projects from. A team's projects are copied from these, and are
  not in the model, nor are any project's built-in workflows. Ruled 2026-11-02 and 2026-11-03: a template's description
  says nothing about star, Status is a field on a project row that anyone may set, and a Schedule project has no Next
  column. Ruled 2026-11-03: a team's Schedule project holds its committed tasks and bugs; its single-select Schedule
  field names the schedule each row belongs to, one option per schedule, named for its Schedule issue; Step orders the
  rows within a schedule, and a Schedule issue's own row has no step; GitHub's Iteration field gives each row its
  sprint, for scrums and sprint review; and its Worktree column holds, in each step's row, a link to the branch its work
  is on. A team's Scenario project held its features until the ruling of 2026-11-04 below; its single-select Scenario
  field names the scenario each row belongs to, named for its Scenario issue, and Beat orders the rows within a
  scenario. Each template's and each copy's Schedule or Scenario field has one option, placeholder, which names a
  placeholder issue, so every Schedule and Scenario project and template in both accounts has its field
  ([section 3](3-collections.md#the-schedule-and-scenario-fields)). There is no longer a project per schedule or per
  scenario. A team's Backlog project holds accepted work not yet scheduled, ordered by priority, and its Triage project
  is where every issue is reviewed and a triage decision made. Either the work is declined, and the issue is closed as
  completed with Resolution Declined, or in a user account the `resolution:declined` label; or the issue is moved to the
  team's Backlog, Schedule or Scenario project. Ruled 2026-11-03: a blank Area is an error. Each Triage project has the
  Area field (in a user account, the `area:` labels, in its Labels column) and a view named Missing Area, both made
  2026-11-03, and nothing leaves Triage without an Area; a scheduled sweep will return any open issue without an Area to
  its team's Triage project. Read 2026-11-04, no view shows the Area or Labels column, and the script of #303's closing
  pull request shows it (below).

  Ruled 2026-11-04: a scenario is a high-level description of a feature, a workflow or a real-life situation that needs
  to be tested. Its Scenario issue, its own row in the team's Scenario project, summarizes an end-user goal. It drives
  planning, coverage and team alignment, includes an example for demos and ad-hoc testing that helps find gaps and
  defects no other kind of testing finds, and names in its body the features it exercises. A scenario is structurally
  like a schedule that starts with no tasks or bugs: they are found with time. Someone opens the scenario and walks it,
  logging work items as they go, each a task or a bug and a row of the team's Scenario project under the scenario's
  option, its Beat the point in the walk where it turned up. A logged item names its scenario in its body, as "Found
  while walking #N", and the Triage workflow will add it to the scenario instead of to the team's Triage project (#448).
  Each item later moves to its team's Triage project or straight onto a schedule, and leaves the scenario; the item's
  body and a comment on the Scenario issue record the move. The sweep (#436) will leave a scenario's rows alone but for
  two structural rules: it will return an epic or a feature that is a row of the Scenario project, as it will one on a
  Backlog or Schedule project, and an issue that is a row of a scenario and of another of its account's projects,
  whichever team owns them. Every other rule waits until an item moves out: it gets its type and parent then, and moving
  straight onto a schedule means classifying it first. A scenario never ends: it is kept, updated or removed as the
  product changes, since it has value before, during and after a release. Both accounts' Scenario forms will be brought
  to this in #453.

  Ruled 2026-11-04: accepted tasks and bugs go out of Triage to the Backlog with their Priority or onto a schedule, and
  from the Backlog onto a schedule highest Priority first; a committed schedule takes one only by its owner's amendment,
  recorded in the Schedule issue. Epics and features are never rows of a Backlog, Schedule or Scenario project: once
  classified, one leaves Triage for no project, since the hierarchy holds it. Every move is one act: the issue gets its
  row in the project it goes to, with that project's fields set, and loses its row in the project it leaves. Triage
  removes an issue's Triage row as part of its decision, and the sweep (#436) will remove none: an issue someone closes
  outside triage stays in its Triage project until triage decides its disposition. An issue is a row of at most one of
  its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most one
  schedule or scenario, and the sweep will return an issue that breaks this to its team's Triage project. Ruled the same
  day, superseding in part the ruling of 2026-10-22 that work for another team gets a tracking issue: an issue on
  another team's project is assigned to an accountable member of that team, and the person whose name is on an issue
  moves it to another team the way any move is made, in one act, between its team's Triage project or schedule and the
  other team's: triage to triage, triage to schedule, schedule to triage, or schedule to schedule. Any member of a team
  can see all of the team's issues and do all of its work in its four projects, so the one grant a new participant needs
  is membership in the team, whose roles carry the rest: the maintain role on each repository the team owns, and the
  write role on each of its four projects, which the script of #303's closing pull request sets in place of the Admin
  role ruled for each team's Triage project on 2026-10-22. The write role lets a member edit a project, its fields and
  views included; what stays with an organization owner is a project's settings and access, and keeping every project of
  a kind configured the same way rests on `push` (#437), not on the role. A user account has no teams; there, a new
  participant is a collaborator on each participating repository, personal and David-Noble-at-work/.github, and a writer
  on each of the account's four projects
  ([issue-standards.md § Who can do what](../../issue-standards.md#who-can-do-what)). The same script makes a view named
  By priority, sorted by Priority, in the Backlog template, which the model describes, and in Backlog: engprod and
  Backlog: devlore, since GitHub's API sets a view's sort only when it makes the view; David-Noble-at-work's Backlog has
  no Priority field to sort by. It also sets the views' visible fields, since read 2026-11-04 they show none of these:
  Area in every view of the Triage projects, Priority in the Backlog projects' views and their By priority view, and
  Labels in David-Noble-at-work's Triage and Backlog views.
- **Ids beside names,** for every project, field and single-select option. GitHub holds a row's single-select value
  as the option's id, not its text, as it holds a label and an issue type on an issue by id: rename the option and
  every row shows the new name; delete it and every row holding it goes blank. With the ids in the asset, `pull` can
  tell a rename from a removal and a creation, print it as "renamed Todo to Triage", and list the text consumers to
  fix; without them it can only print a deletion and an addition, which is the ambiguity that makes `push` refuse a
  rename. Whether `push` may one day carry a rename itself, id in hand, is left until the write test has run. Added
  2026-10-22 at the owner's direction.

  An issue field's options have ids too. Settled 2026-11-04: GitHub's GraphQL call `updateIssueField` takes no option
  ids, but its REST call, `PATCH /orgs/{org}/issue-fields/{issue_field_id}`, does, and GitHub's REST documentation warns
  that options sent without an id may be deleted and recreated. The model holds each option's id, so `push` will send
  every option with its id (#437), and the script of #303's closing pull request adds Severity's N/A option through the
  REST call, sending each existing option with its id.

## The cache

Ruled 2026-11-03: the model file is itself a cache, which star queries instead of asking GitHub the same questions
again. This section describes the other cache, the per-machine file `pull` keeps, built in #377. On 2026-10-22 the
owner chose the word cache, which suggests an XDG location. The ETag GitHub returns for each record is kept per
machine, outside any repository, at

```
${XDG_CACHE_HOME:-~/.cache}/devlore/star/gh/model/<account>.yaml
```

one file per account, holding for each record what GitHub gives to detect a change by, and the time it was read. What
else that file holds, and whether star reads GitHub by ETag before every operation or answers from the model until the
next pull, is decided with #426.

```yaml
issue-types: { etag: 'W/"3f9c…"', read: 2026-10-22T09:02:51Z }
teams:       { etag: 'W/"b8d4…"', read: 2026-10-22T09:02:51Z }
labels:
  NobleFactor/noblefactor-engprod: { etag: 'W/"66b6…"', read: 2026-10-22T09:02:51Z }
  NobleFactor/devlore-cli:         { etag: 'W/"0c5a…"', read: 2026-10-22T09:02:51Z }
projects:
  PVT_kwDO…: { updatedAt: 2026-10-22T08:40:16Z, read: 2026-10-22T09:02:51Z }
```

| Asset record | Read from | Change detected by |
| --- | --- | --- |
| `types` | an organization: `GET /orgs/{org}/issue-types`; a user account: its type labels, among its repositories' labels | an organization: one ETag for the list, `updated_at` per type; a user account: as for `labels` |
| `teams` | `GET /orgs/{org}/teams` and each team's repositories; a user account has none | one ETag per list |
| the repositories | every repository the account owns | one ETag for the list |
| `labels` | `GET /repos/{owner}/{repo}/labels`, per repository | one ETag per repository; no per-label time |
| `projects` | GraphQL `projectsV2` with fields, options and views: an organization's four templates, Triage, Backlog, Schedule and Scenario; in a user account, which cannot mark a template, its copies of them. Projects made from templates are not read | `updatedAt` per project; GraphQL takes no ETag, so this read is never 304 and costs one query |

A read that sends the ETag back is answered 304 Not Modified when nothing changed, at no cost against the rate
limit; the cache is what makes a conditional read cheap. It is a cache in the XDG sense: deleting it costs one full
read and loses nothing, and no command depends on its being there. Read on 2026-10-22: the organization's issue types
carry `updated_at`, a repository's label list returns an ETag and no per-label time, and a project carries
`updatedAt`.

What the cache is not: the record of what the asset was pulled from. That record has to travel with the asset, since
a push may run on a machine that never pulled, so the asset keeps `pulled.at` and the stale-push check below compares
GitHub's `updated_at` and `updatedAt` against it where GitHub gives one, and the record's content against the asset
where it does not, which is labels.

## Two verbs, one hub

```
star github model pull [--account <account>] [--asset <path>]
star github model push [--account <account>] [--repo <owner/repo>[,...]] [--delete] [--force] [--asset <path>]
```

Both target one account, an organization or a user; ruled 2026-11-02, the option is `--account`, not `--org`. `pull`
reads the data model of any account, ours or not, and takes the whole model, every repository the account owns; it has
no `--repo` (ruled 2026-11-03). Its `--account` defaults from star configuration, `github.account`, which defaults to
NobleFactor (ruled 2026-11-03). `push` writes a model to an account, and that model becomes the account's data model
(ruled 2026-11-03). What `push` writes, whether it keeps `--repo`, and what its `--account` defaults to are decided with
#437. On 2026-10-22 the owner ruled that pull and push target an organization, NobleFactor by default; the rulings
above replace it. Direction is in the verb, as in `git pull` and `git push`, because one end is always the
asset. rsync and rclone put direction in the argument order instead, and rclone splits "identical" from "add, never
delete" into `sync` and `copy`; here the split falls between the two verbs.

| Verb | From | To | Deletes | Lands as |
| --- | --- | --- | --- | --- |
| `pull` | any account's data model, ours or not: its issue types or type labels, its issue fields, its teams, the labels of every repository it owns, and its project templates with their fields, options and views | the model file `--asset` names | yes, shown first | for our accounts, a rewritten file in the account's `.github` repository, on a branch, reviewed as a pull request; for an account that is not ours, a file wherever `--asset` names it |
| `push` | the model file | the account's data model, which becomes the model pushed; what it writes is decided with #437 | never by default; see Risk | changes in GitHub, reported |

- **`pull`** reads each record conditionally by its ETag, rewrites the asset where a record changed, and prints the
  diff. Exit 0 whether nothing changed or the asset was rewritten, the summary line saying which; exit 1 on a conflict
  it will not resolve, nothing written. Ruled 2026-10-23: a star command exits only 0 or 1. With `--check` it prints
  the diff and writes nothing: a workaround, since star's `--dry-run` skips every read a preview needs
  ([devlore-cli#1170](https://github.com/NobleFactor/devlore-cli/issues/1170)); `pull` refuses `--dry-run` and names
  `--check`, which retires when #1170 lands. A real pull writes only a model file in a git tree off its default branch
  with no uncommitted change to the file, at the path `--asset` names: for our accounts, a worktree of the account's
  `.github` repository. On 2026-10-22 the owner named its first use: once the data model is complete and has been
  changed in GitHub, sync it back to the repository to keep the two consistent.
- **`push`** replaces `star github labels sync`: it writes a model to an account, adding and correcting, never deleting
  unless told to, and `--dry-run` shows the changes. David-Noble-at-work takes part through its own model, pushed to it
  like any other account's. On 2026-10-22 the owner ruled that star offers directed syncs and that personal syncs if it
  is to take part; since 2026-11-02 personal's account has a model of its own.
- **`star github model audit`** replaces `star github labels audit`: drift reported, nothing written. What it compares
  an account against is decided with #426 and #437.
- `--asset` names the model file (ruled 2026-11-03). It no longer defaults to the file beside the extension; its
  default is decided with #426 and #437.
- **Every command that talks to GitHub checks gh's access first,** § Access below.

## Risk

The owner, 2026-10-22: "Push and pull are destructive so we need to think about risk mitigation." What each can
destroy, and what stands in the way:

| Verb | What it can destroy | Mitigation |
| --- | --- | --- |
| `pull` | the asset's last state, and with it any edit made to the file by hand | git. The owner, 2026-10-22: "For pull, I think we can depend on git." It runs only in a clean worktree on a branch and refuses a dirty asset; the previous state is the commit before, the diff is printed, and the pull request is the review |
| `push` of a label | a label removed strips it from every issue carrying it | deletion is off: `push` never deletes without `--delete`, which prints what each deletion strips and how many issues carry it, and `--dry-run` shows it all first. Ruled 2026-10-22: "I think we need to use a flag like --delete." The name is rsync's and rclone's for the same switch; `--force` is kept for the stale-push override below, as in git, so the two risks have two switches and neither implies the other |
| `push` of an issue type | a type removed changes every issue of that type | the same `--delete` gate |
| `push` of a project field | a field removed loses every row's value | the same gate; a field removal names the rows that hold a value. A push changes a template only, since the projects made from it are not in the model; whether those projects follow later changes to their template is decided with #426 and #437. Next's deletion and Lane's rename to Step were made by hand in GitHub, on the Schedule template and on every schedule project that then existed |
| a single-select option changed through the API | GitHub's GraphQL updates a single-select field by taking the whole option list, and an option sent without its existing id is a new option: the old one is deleted and every row that held it goes blank. Run 2026-10-26 (#377): `ProjectV2SingleSelectFieldOptionInput` takes the option's `id`, and an update sending each option with its id renamed Todo to Not run, In Progress to Fails and Done to Passes in place, all six of project 4's rows keeping their value. An issue field's options carry the same risk, settled 2026-11-04: GitHub's GraphQL call `updateIssueField` takes no option ids, and GitHub's REST documentation warns that options sent to its REST call, `PATCH /orgs/{org}/issue-fields/{issue_field_id}`, without an id may be deleted and recreated | `push` will send every option with the id the asset holds, an issue field's through the REST call (#437), and will refuse an option whose id it does not have, so a rename is never sent as a replacement by accident; the test runs before `push` touches a field at all |
| a rename of a type, a label or a field | from the asset's side a rename is indistinguishable from a removal and a creation, so a push would strip the old name from everything and create an empty new one; and every consumer that names the thing by text, the extension's queries and the documents, keeps the old name | `push` refuses a rename. The rename is made in GitHub, which carries it to the issues and rows that hold the thing by id, then `pull` shows the diff so every text consumer is corrected in the same pull request. Ruled 2026-10-22: no one is to be surprised by blocks that come from name changes that did not propagate. |
| a hand edit of the asset | a clumsy edit pushed into GitHub as if it were the pulled record | `pulled.digest`: `push` refuses a mismatched asset, every read says so, and CI fails the pull request; `pull` or `star github model digest` clears it |
| a stale `push` | the asset was pulled, GitHub moved, the push writes over the move | `push` works the way `git push` works: it re-reads each record and refuses when GitHub has moved since `pulled.at`, by `updated_at` on issue types and `updatedAt` on projects, and by content for labels, as git refuses a push that is not a fast-forward of the remote; `pull` first, then `push`. `--force` overrides it, as `git push --force` does, and prints what it is overwriting. Ruled 2026-10-22: "Cite the git case and ensure that we doc that it works the way git push works." |
| the wrong account | a push meant for one account, an organization or a user, lands on another | the account is one per invocation, named by `--account`, printed in the first line, and `--dry-run` shows it |
| an agent running it | a session pushes on its own judgment | the owner runs `push`, as the owner runs every script that writes to GitHub; a session writes the command and hands it over |

Why renames need the rule even though GitHub propagates them: a label, a type, a field and a single-select option are
held by id, so renaming one in GitHub renames it on every issue and row at once; a text, number or date value has no
name to rename, it is the value. What GitHub cannot reach is everything that names it as text, and this model has a
great deal of that: the queries the extension runs, the standard and the plans. Those are the consumers that do not
update, and the diff `pull` prints is the list of them to fix. The parent markers in issue bodies named types as text
until they were removed on 2026-11-03. The `Epic:` and `Thread:` labels named epics and threads, now scenarios, as
text; ruled 2026-11-03, they are removed from both accounts, and sub-issue parent links and project rows replace them.

## Recovery

On 2026-10-22 the owner held that our copy of the model is a backup for disaster recovery, against the mistakes made
along the way. Since 2026-11-02 each of our accounts keeps its model file in its own `.github` repository, and that
repository's history is the account's backup: every state the model has been in since its first pull is a commit, and
`push --force --delete` of the file from a chosen commit restores the account's data model to it, the two switches
being exactly the overrides a restore needs. `--dry-run` first shows what the restore would do.

What it restores, and what it cannot:

| Mistake | Recovered by | Limit |
| --- | --- | --- |
| A type, a label, a field or an option renamed or given the wrong description or color | `push` from the last good commit | none: these are held by id, and the push corrects them in place |
| A label deleted | `push` recreates it | the issues that carried it do not get it back; GitHub stripped it on deletion. The report's last rows say which issues had it |
| A field or an option deleted | `push` recreates it | with a new id, so the asset's id is updated by the next `pull`, and every row's value in that field or option is gone; GitHub cleared it on deletion |
| A template deleted | `push` recreates it from the asset with its fields and options; whether it writes views is decided with #437. No template has had a built-in workflow since 2026-11-03, so there is none to restore (§ One model per account) | with new ids, so the asset's ids are updated by the next `pull` |
| A team's Triage, Backlog, Schedule or Scenario project deleted | made again from its template; it is not in the model, so `push` cannot recreate it | its rows are gone: the issues exist, their membership and their Schedule, Scenario, Step, Beat and Iteration values do not. The blocked-by links between its steps live on the issues and survive. A Schedule or Scenario issue's body holds no step or beat table, only a line naming its board and option |
| The asset itself damaged | git | a commit before the damage, or a `pull` from GitHub if GitHub is right |

The asset backs up the model, not the data the model holds: which issue has which type, which issues are rows of
which project, and each row's values live only in GitHub. A backup of those is a different thing, an export of the
issues and rows, and this design does not provide one; it is named here so that nobody mistakes the asset for it.
Until 2026-11-03 the Schedule and Scenario issues' step and beat tables and the parent markers in issue bodies were
copies of membership and parents outside GitHub's projects and links; since they were removed that day, there is no
such copy. The dependencies between steps are GitHub blocked-by links, which live on the issues rather than in a
project.

Ruled 2026-11-03: the old scheme's last three pieces, the parent markers, the step and beat tables in issue bodies, and
NobleFactor's kind labels, retired that day, and the retirement is done in GitHub (§ The asset, under `types`).

## Access

Ruled 2026-10-26: the extension checks for access, and when the login is stale or access is denied it exits with
specific instructions. Every command that reads or writes GitHub, `pull` and the `star github schedule` and labels
commands, checks gh's access before its first request, and when it cannot go on it fails with what is wrong and the one
thing that fixes it. It never signs in or adds a scope itself: star captures a command's output, so gh's one-time code
would never reach the user, and the sessions that run star must not change credentials. The user signs in and adds a
scope; GitHub issues the token and refuses what it cannot do. Built 2026-10-26 in `commands/access.star` (#377).

| # | Found | The command says |
| --- | --- | --- |
| 1 | gh is not signed in | You are not signed in to github.com with gh on this machine. Sign in: `gh auth login --hostname github.com`, then rerun |
| 2 | GitHub refuses the token, 401 | GitHub refused gh's token for the account; it has expired or been revoked. Renew your login: `gh auth refresh --hostname github.com`, then rerun. A token from `GH_TOKEN` or `GITHUB_TOKEN`: replace it, or unset it to use the gh login |
| 3 | the token lacks a scope the command needs | Your gh login lacks the scope the command needs, naming exactly the missing ones. Add it: `gh auth refresh --hostname github.com --scopes <missing>`, then rerun. `project` includes `read:project`, so the check never asks for both |
| 4 | the login cannot see the account it reads, 403 or 404, every scope held | the login cannot see that account; no command here fixes it: for an organization, an owner of the organization must grant the login access |
| 5 | the rate limit is spent | when it resets, in local time; rerun after that |

`pull` needs `read:project`, and checks the account it reads, an organization or a user; the `star github schedule`
and labels commands need gh's own scopes. The refresh in rows 2 and 3 is interactive, a one-time code approved in a
browser, so it runs in the user's own terminal, not through a session. Under star's `--dry-run` every shell call is
skipped, so nothing can be checked and the check is skipped with it.

## Every operation reads first

Whether star reads GitHub by ETag before every operation or answers from the model until the next pull is decided
with #426. Ruled 2026-11-03, the model is a cache that star queries instead of asking GitHub the same questions again.
What follows is what #378 built. On 2026-10-22 the owner argued for a pull before every operation, optimized by some
form of change detection. So every `star github schedule` operation begins with the conditional read `pull` makes,
three or four requests sent with the cache's ETags and answered 304 when nothing moved, and runs against GitHub's
record. It writes nothing but the cache. The model file is in the account's `.github` repository, not a deployed link
into the layer clone, and a read-only command writes nothing there either; as built, it reads NobleFactor's
`model.yaml` beside the extension, a link into the layer clone, until #431 moves it. When a record is not 304 and the
asset is behind, the operation says so in one line of its header and goes on, the way the audit opened the tree
report until it retired with #436 on 2026-11-08. Built 2026-10-27 (#378): `star github schedule report` and `audit` made
`pull`'s read, sharing its comparison; since #436 the report and `star github triage sweep` make it, for each account
whose repositories they read; the line is the first of a markdown document, where `--silent` cannot hide it, and a warning otherwise; the
comparison ignores comment lines, since `pull`'s header names the command and a rename changes it.

## Examples

Example 2, the owner adds the Worktree field to the Schedule template in GitHub (ruled 2026-11-03). Priority is not
a project field here: in NobleFactor it is an issue field (ruled 2026-11-03).

```
$ star github model pull
[star] issue-types  W/"3f9c…"  unchanged (304)
[star] labels       W/"66b6…"  unchanged (304)
[star] projects     W/"a1d0…"  changed
--- model.yaml (pulled 2026-11-03T07:40:12Z)
+++ GitHub (NobleFactor, 2026-11-03T09:02:51Z)
@@ projects: Schedule @@
-    fields: [Schedule, Step, Iteration, Status]
+    fields: [Schedule, Step, Iteration, Status, Worktree]
[star] model.yaml rewritten; 1 project changed, 0 types, 0 labels
```

`git status` then shows the model file modified on a branch of a git tree of NobleFactor/.github, and the pull request
carries that diff.

Example 1, personal joining NobleFactor's model by a push of labels to it, is retired: since 2026-11-02
David-Noble-at-work has its own model, pushed to it with `--account David-Noble-at-work`. What that push writes is
decided with #437.

## Participation: a user account's repositories

Ruled 2026-11-02: a user account's repositories take part in their own account's model, not in an organization's
(§ One model per account). No project, sub-issue link or blocked-by link crosses accounts; work that waits on another
account uses a stand-in issue in its own account. The design this section held until then, a repository outside the
organization joining NobleFactor's model by labels pushed to it with `--repo` and proving its participation by a digest
of its labels kept in the cache, retired with that ruling.

Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an organization,
or when it has the topic issue-model, in a user account.

| Part of the model | In an organization's repository | In a user account's repository, such as David-Noble-at-work's |
| --- | --- | --- |
| Type | GitHub's issue type: Epic, Feature, Task, Bug, Schedule or Scenario | a lowercase label of the type's name, epic, feature, task, bug, schedule or scenario, from the account's own model; the audit reads it as the type |
| Parent | the sub-issue link, within the account | the sub-issue link, within the account |
| Epic | the parent's parent | the same |
| Priority, Effort, Area, Resolution | the organization's issue fields, in NobleFactor | the `priority:`, `effort:`, `area:` and `resolution:` labels, since the account has no issue fields |
| Severity, every type's: a bug's Critical, High, Medium or Low, and N/A on every issue of another type (ruled 2026-11-04) | the organization's issue field Severity, in NobleFactor (ruled 2026-11-03; [section 2](2-attributes.md#the-attributes)), whose option N/A the script of #303's closing pull request adds | the `severity:` labels, among them `severity:n/a`, which the script of #303's closing pull request makes |
| A row in a Triage, Backlog, Schedule or Scenario project | the team's project, `<Kind>: <team>`, owned by the organization, made from its template and linked to its team | the account's project, `<Kind>: David-Noble-at-work`, copied from the account's own copy of the template |
| What enforces the rules | GitHub, for one type and one parent; enforcement is otherwise lax, with no compliance checks (ruled 2026-11-03), but for the sweep (#436), which will return an issue that breaks a rule to its team's Triage project every day, and will block no filing and correct nothing by itself (ruled 2026-11-04) | nothing in GitHub; enforcement is lax, with no compliance checks (ruled 2026-11-03), but for the sweep (#436), which will return an issue that breaks a rule, such as one with two type labels, to the account's Triage project every day, and will block no filing and correct nothing by itself (ruled 2026-11-04) |

Ruled 2026-11-03: Priority and Area apply to issues of every type, Schedule and Scenario included, and issue fields are
used wherever an account has them. Area describes the issue's own work, so an epic, a feature and the tasks and bugs
under them can each differ: a CI bug fixed during a product feature is engineering (ruled 2026-11-03). Also ruled
2026-11-03: the issues we file ourselves will go through `star github issue` once it is built (#338), the one path that
will classify an issue as it is made, and it will refuse an issue without an Area.

**What a user account's model does not give it**: GitHub's own enforcement of one type per issue and the type picker
in GitHub's interface. Those come only with an organization's issue types; on 2026-10-22 the owner ruled against moving
personal into the organization to get them.

## What this changes in the task list

Ruled 2026-11-02: pull comes first, then push. [Section 5](5-from-todays-scheme.md)'s step 2, tooling that reads both,
begins with `pull`: the owner authors the model in GitHub first, pulls it into each account's model file, and the file
then drives the extension and the pushes. Each repository's labels reach its account's model file, in the account's
`.github` repository, by `pull`, held per repository, with no tiers and no organization default labels; #320's labels
file does not move into the extension's directory.

Ruled 2026-11-02: a working issue tracking system on GitHub comes first, and the tooling follows. #303 keeps only the
design, and its build work is in issues of its own: #425, the reference models; #426, how each account's model is
read; #431 and David-Noble-at-work/personal#311, the model files in NobleFactor/.github and
David-Noble-at-work/.github; and #437, `push`.

Each account's pull request template, which the ruling of 2026-11-03 stores in its `.github` repository, is part of the
same two issues (§ One model per account).
