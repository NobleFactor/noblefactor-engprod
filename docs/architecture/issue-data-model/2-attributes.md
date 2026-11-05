---
title: "2. Attributes"
---

# 2. Attributes

The owner, 2026-10-21: "use labels/tags for the attributes of an issue. An issue has a place in the issue hierarchy
in a repo. An issue has a severity. An issue might be on a schedule and schedules are owned by individuals and teams."

Ruled 2026-11-03: issue fields are used wherever an account has them. NobleFactor's issue fields are Priority, Effort,
Start date, Target date, Resolution, Area and Severity, and its Start date field stays unused. David-Noble-at-work has
no issue fields, so it carries its attributes as the labels `priority:`, `severity:`, `effort:`, `area:` and
`resolution:` ([Labels carry no values](#labels-carry-no-values)).

An attribute is something an issue has on its own, outside any collection. Its severity is one; its place on a
schedule is not, since step 13 means nothing outside the schedule that numbers it ([section 3](3-collections.md)).

## The attributes

| Attribute | Applies to | Values | How many an issue may carry |
| --- | --- | --- | --- |
| Severity | every type, Schedule and Scenario included; it measures harm on a bug only | Critical, High, Medium, Low on a bug; N/A on every other type | exactly one, once the issue has a type |
| Priority | every type, Schedule and Scenario included | Urgent, High, Medium, Low | at most one |
| Area | every type, Schedule and Scenario included | product, engineering | exactly one: a blank Area is an error |
| `good first issue` | Task and Bug only | none: present or absent | — |

Ruled 2026-11-03: Priority and Area apply to issues of every type, Schedule and Scenario included. In
David-Noble-at-work, which has no issue types, a type is its lowercase label: `bug`, `schedule`, `scenario`. Also
ruled 2026-11-03: the issue type Thread is renamed Scenario, and in a user account the label `thread` is renamed
`scenario`.

Ruled 2026-11-04: `good first issue` goes on tasks and bugs only. The label tells a newcomer that they can pick the
issue up, and only a task or a bug is a single piece of work; an epic or a feature is a body of work. personal gets the
label, made by the script of #303's closing pull request, so that both accounts hold it.

Severity's values on a bug are the ones NobleFactor/devlore-cli carried on 2026-10-21, `Severity:Critical` to
`Severity:Low`, and every other type's Severity is N/A (ruled 2026-11-04). Priority's are the options of NobleFactor's
Priority field, Urgent, High, Medium and Low, which are GitHub's own, and a user account's priority labels follow
them; devlore-cli carried priority as `Priority:P0` to `Priority:P3`. It also carried seven `Area:` labels of its own,
deleted on 2026-11-03 (below). noblefactor-ops and personal carried none of them (`gh label list`, 2026-10-21).

Ruled 2026-11-03: the labels that remain are lowercase: `priority:urgent` to `priority:low`, `severity:critical` to
`severity:low`, `effort:high` to `effort:low`, `area:product` and `area:engineering`, and `resolution:declined`,
`resolution:duplicate` and `resolution:invalid`. These are the labels David-Noble-at-work carries its attributes in.
Ruled 2026-11-04: `severity:n/a` joins them, carried by every issue of a type other than Bug and made by the script of
#303's closing pull request.

Ruled 2026-11-03: Severity is an issue field of the organization, in NobleFactor, with the values Critical, High,
Medium and Low. The design worktree's script, `~/Workspace/NobleFactor/noblefactor-engprod.303-model-cutover.bash`,
made it on 2026-11-03, in its step 3, and read it back. Its description is "What the impact is if this fires":

| Option | Color | Description |
| --- | --- | --- |
| Critical | red | Data loss, corruption, or a security failure |
| High | orange | A supported path is broken with no workaround |
| Medium | yellow | Broken with a workaround, or a narrow path |
| Low | green | Cosmetic, or a defect nobody is hitting |
| N/A | gray | Not applicable: the issue is not a bug |

The field has no default value. GitHub's GraphQL schema lets `createIssueField` take an owner, a name, a description,
a data type, options and a visibility, and nothing else, so an issue field can't have a default. The same script's
step 4 gave each devlore-cli issue that carried a `Severity:` or `Priority:` label the matching field value, then
deleted those labels, so no NobleFactor repository has a severity or priority label now
([section 5](5-from-todays-scheme.md#the-deltas)).

Ruled 2026-11-04: the field gains a fifth option, N/A, the table's last row, which every issue of a type other than Bug
carries (below). The script of #303's closing pull request adds it, sending each existing option with its ID, through
GitHub's REST call `PATCH /orgs/NobleFactor/issue-fields/{issue_field_id}`. GitHub's GraphQL call `updateIssueField`
takes no option IDs, and GitHub's REST documentation warns that options sent without an ID may be deleted and recreated.
The model holds each option's ID, so push will send every option with its ID (#437).

**Severity is a bug's.** The owner, 2026-10-21: "Severity is a quality of a bug." It measures the harm a defect does,
"what the impact is if this fires", in [issue-standards.md](../../issue-standards.md) § Triage adds attributes. The
owner asked what severity means for a task. Ruled 2026-11-04, the plan's question 11: a task has no severity; it has a
priority. A task is planned work, and nothing has fired. When a task exists to prevent a harm, the harm is a bug's
severity, and the task takes its priority from that bug.

**Every other type has Severity N/A.** Ruled 2026-11-04: Severity applies to bugs only, and every issue of another type
has Severity N/A: in NobleFactor, the new option N/A of the Severity issue field (above), and in a user account, the new
label `severity:n/a`. Both are made by the script of #303's closing pull request. A bug has Critical, High, Medium or
Low, never N/A. An issue that arrives with no type gets no Severity and waits for triage; when triage gives it a type
other than Bug, triage sets its Severity to N/A. The Triage workflow will set N/A on an issue of another type filed from
a form, and will give a bug filed from the bug form, which asks no severity, Severity Medium, the owner's default, which
GitHub's field can't hold (above); triage changes it when the bug's harm is greater or less (#448). `star github issue`
will set N/A at filing (#338). So every typed issue has exactly one Severity value, and the sweep (#436) will catch a
miss: it will return to its team's Triage project a bug whose Severity is N/A or blank, and an issue of another type
whose Severity isn't N/A.

**Priority is when we act.** The owner said on 2026-10-21 that scenarios, then called threads, will in time drive
schedules and influence priority. Ruled 2026-11-04, the plan's question 12: a scenario changes no issue's priority;
triage sets each issue's Priority. Ruled 2026-11-03: a team's Backlog project holds its accepted work that isn't yet
scheduled, ordered by priority. Ruled 2026-11-04: work goes from the Backlog onto a schedule highest Priority first, and
the Backlog shows its order in a view named By priority, sorted by Priority, which the script of #303's closing pull
request makes in Backlog: engprod, Backlog: devlore and the Backlog template. The same script shows the Priority field
in every view of those three, and the Labels field, which holds the `priority:` labels, in David-Noble-at-work's Backlog
views. David-Noble-at-work's Backlog has no Priority field to sort by, since a user account has no issue fields
([section 3](3-collections.md#triage-and-the-backlog)).

**Area tells engineering work from product work.** Ruled 2026-11-03: Area has two values only, product and
engineering. In NobleFactor they are the options Product and Engineering of the Area issue field, made on 2026-11-03;
in a user account they are the labels `area:product` and `area:engineering`. Area applies to issues of every type and
describes the issue's own work, so an epic, a feature and the tasks and bugs under them can each have a different
Area: a CI bug fixed during a product feature is engineering. Engineering covers build orchestration, Makefile
changes, CI pipelines, the scripts and tools of the internal agent workspace, and governance and process work.
Release notes come from the closed product issues in a release, not from the hierarchy, and the epics for product
readiness and release management hold both kinds of work.

Ruled 2026-11-03: devlore-cli's seven finer `Area:` labels, architecture, CLI, code quality, error handling, git, meta
and testing, were deleted that day, and the hierarchy carries those distinctions instead
([section 1](1-hierarchy.md)). Architecture work is a task, or a feature with product value, within an epic. A bug
isn't filed against the architecture; an architecture task is logged to address a bug in a feature.

**A blank Area is an error.** Ruled 2026-11-03: an issue without an Area is caught at three points.

- **At filing.** `star github issue` will refuse an issue without an Area (#338). The issue forms in each account's
  `.github` repository have a required Area dropdown, and when the issue is opened, the repository's Triage workflow
  copies the answer into the Area issue field or the `area:` label: personal's adds the `area:` label today, and
  NobleFactor's will set the Area field once #447 and #448 land ([section 4](4-storage-and-reach.md#triage)). The form
  checks the Area in a public repository; GitHub enforces a form's required fields only there (GitHub's form schema
  documentation, read 2026-11-04). In a private repository that takes part, today only personal, nothing checks it at
  filing until `star github issue` does.
- **At triage.** Each Triage project has the Area field (in a user account, the `area:` labels in its Labels field) and
  a view named Missing Area, both made on 2026-11-03, and the script of #303's closing pull request shows that field in
  every Triage view. No issue leaves Triage without an Area ([section 3](3-collections.md#triage-and-the-backlog)).
- **Afterward.** A scheduled sweep (#436) will return any open issue without an Area to its team's Triage project, or in
  a user account to the account's. #452 will give every open issue an Area before the sweep runs, and #436 waits on it:
  read 2026-11-04, before #452 and #453 were filed, 9 of the 528 open issues in NobleFactor's five participating
  repositories had one, and 5 of personal's 42.

**The sweep will check the attribute rules.** Ruled 2026-11-04: the sweep (#436) will return to its team's Triage
project, or in a user account to the account's, any open issue that breaks one of the rules below, as it will return an
issue that isn't fully classified ([section 1](1-hierarchy.md#triage)):

- an issue with no Area;
- an issue other than a Scenario issue with no Evidence of completion section, since a scenario never ends and its
  Scenario issue states none ([section 1](1-hierarchy.md#how-long-a-level-lives));
- a bug whose Severity is N/A or blank, or an issue of another type whose Severity isn't N/A;
- a Resolution, or in a user account a `resolution:` label, on an open issue;
- two labels of one attribute, such as two `priority:` labels, in a user account;
- `good first issue` on an issue that isn't a task or a bug;
- an epic or a feature that is a row of a Backlog, Schedule or Scenario project ([section 1](1-hierarchy.md#triage));
- an issue that is a row of more than one of its account's Triage, Backlog, Schedule and Scenario projects, whichever
  team owns them, or is on more than one schedule or scenario ([section 3](3-collections.md#triage-and-the-backlog)).

The sweep will leave a scenario's rows alone but for the last two rules, which are structural: it will return an epic or
a feature that is a row of a Scenario project, as it will one on a Backlog or Schedule project, and an issue that is a
row of a scenario and of another of the account's projects, whichever team owns it, so that one project at a time holds
across the whole account ([section 1](1-hierarchy.md#triage)). How it will handle an issue that is a row of a scenario
and of another project, without taking a scheduled item off its schedule, is #436's to design. Every other rule waits
until a work item logged while walking a scenario moves out, to its team's Triage project or onto a schedule, and gets
its type and parent.

The sweep will run every day as a scheduled GitHub Actions workflow in each account's `.github` repository, with the
credentials the Triage workflow uses, and will comment on each issue it returns, naming the rule it broke. It will block
no filing, correct nothing by itself and remove no Triage row: triage fixes each issue it returns by hand, and removes
an issue's Triage row as part of its decision ([section 1](1-hierarchy.md#triage)). It will check the hierarchy's rules
and a schedule's steps as well, and [issue-standards.md § Well classified](../../issue-standards.md#well-classified)
lists every rule it will check.

## Labels carry no values

A GitHub label is a name, present on an issue or absent. `severity:high` writes an attribute and its value into one
name; GitHub sees an opaque name with no relation to `severity:low`, and nothing stops an issue carrying both. In
David-Noble-at-work, GitHub therefore doesn't hold an issue to one label of an attribute: the sweep (#436) will return
an issue that carries two, such as two `priority:` labels, to the account's Triage project.

GitHub's issue fields do carry values: the organization defines a field once, with a type, and each issue holds its
own value, one for a single-select field. NobleFactor holds Priority, Severity and Area in issue fields, and
David-Noble-at-work holds its attributes in labels (ruled 2026-11-03).

Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub offers
organizations only ([section 4](4-storage-and-reach.md#a-user-account)). A user account has no issue fields: GitHub's
GraphQL schema says `createIssueField` makes a field in an organization, and its `User` type has no issue fields. So
in a user account a label stands in for each single-select issue field: one label per option, named `<field>:<option>`
in lowercase.

| Issue field | The labels that stand in for it in a user account |
| --- | --- |
| Priority | `priority:urgent`, `priority:high`, `priority:medium`, `priority:low` |
| Severity | `severity:critical`, `severity:high`, `severity:medium`, `severity:low`, `severity:n/a` |
| Effort | `effort:high`, `effort:medium`, `effort:low` |
| Area | `area:product`, `area:engineering` |
| Resolution | `resolution:declined`, `resolution:duplicate`, `resolution:invalid` |

The priority, severity and effort labels were made on 2026-11-03 in personal and David-Noble-at-work/.github, each
colored and described as its option is; the area and resolution labels were already there. In both, `severity:n/a` is
made by the script of #303's closing pull request, colored `cfd3d7` and described "Severity: not applicable, the issue
is not a bug", as the user account's reference model gives it. A date field has no stand-in, since a label can't hold a
date: Target date has no counterpart in a user account, and Start date is unused. A project field is no stand-in either.
Its value is on the project's row, not on the issue, so it doesn't go with the issue from project to project. The
Priority project field on Backlog: David-Noble-at-work and on the account's Backlog copy was deleted on 2026-11-03;
neither project had rows.

Ruled 2026-11-03: NobleFactor also uses its Effort and Target date issue fields, and its Resolution field, which says
why a closed issue wasn't done ([Why an issue was closed](#why-an-issue-was-closed)). It doesn't use Start date, since
each issue's history records when work on it really started.

Ruled 2026-11-03: an account's model holds its issue fields, as it holds its issue types and labels. NobleFactor's
model holds Priority, Effort, Target date, Resolution, Area and Severity, and Start date stays unused. A user account
has no issue fields, so its model holds none.

The model holds the labels of each of an account's repositories (ruled 2026-11-03), so David-Noble-at-work's model
lists its `priority:`, `severity:`, `effort:`, `area:` and `resolution:` labels under each repository that carries
them.

## Not attributes

- **A step on a schedule, or a beat in a scenario:** a place in a collection, held by the team's Schedule project in
  its Schedule and Step fields, or by its Scenario project in its Scenario and Beat fields
  ([section 3](3-collections.md)).
- **An owner:** a person is an issue's assignee, a GitHub link to a user account. Ruled 2026-11-03: each team, and each
  user account, has four projects: Triage, Backlog, Schedule and Scenario. In an organization, the team that owns a
  project is accountable for it, and GitHub's link between the project and its team is the record. A user account's
  projects are its owner's ([section 3](3-collections.md)). Ruled 2026-11-04: an issue on another team's project is
  assigned to an accountable member of that team, and the person whose name is on an issue moves it to another team in
  one act ([section 1](1-hierarchy.md#triage)).
- **The hierarchy:** Type and parent ([section 1](1-hierarchy.md)).

## Why an issue was closed

Ruled 2026-11-03: the reason a closed issue wasn't done is recorded in an issue field wherever an account has one.
In NobleFactor it is the Resolution issue field, a single-select field with three options: Declined, Duplicate and
Invalid. NobleFactor has no `resolution:` labels, which were deleted from its 12 repositories on 2026-11-03, and no
`duplicate` or `invalid` labels. David-Noble-at-work has no issue fields, so there it is a label named
`resolution:<name>`: `resolution:declined`, `resolution:duplicate` and `resolution:invalid`, the last two replacing
the labels `duplicate` and `invalid` in that account.

There is no `wontfix` or `declined` label. A resolution goes only on a closed issue; the model records it, the
Resolution field among an organization's issue fields and the `resolution:` labels among a user account's labels, and
the sweep (#436) will return an open issue that has one to its team's Triage project. An issue that wasn't done is
closed as completed, with its Resolution, or in a user account its `resolution:` label, saying why; GitHub's
`not_planned` close reason isn't used.

Ruled 2026-11-03: work declined in a Triage project is closed this way, as completed, with Resolution Declined in
NobleFactor or the `resolution:declined` label in David-Noble-at-work.
