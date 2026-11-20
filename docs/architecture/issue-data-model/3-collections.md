---
title: "Projects and collections"
status: draft
updated: 2026-11-19
---

<a id="3-collections"></a>

# Projects and collections

[Up: Issue data model](index.md)

Each team has four managed projects: Triage, Backlog, Schedule and Scenario. A user account has the same four. The Schedule and Scenario projects each hold several collections, identified by their own issues and project-field options.

<a id="four-projects-per-team"></a>

## 1. Project kinds

| Kind | Holds | Order | Collection fields |
| --- | --- | --- | --- |
| Triage | Issues awaiting a triage decision, of any type or none | No execution commitment | Status |
| Backlog | Accepted, unscheduled Tasks and Bugs; classified Epics and Features until closure | Priority | Status; issue Priority remains authoritative |
| Schedule | Schedule issues and their committed Tasks and Bugs | Step within each Schedule | Schedule, Step, Iteration, Status, Worktree |
| Scenario | Scenario issues and findings recorded while walking them | Beat within each Scenario | Scenario, Beat, Status |

Name projects `<Kind>: <team>` in an organization and `<Kind>: <account>` in a user account. An organization supplies a template for each kind. A user account keeps corresponding project copies from which to create its projects.

Projects of the same kind follow the same template for fields, views, descriptions and README. Account-specific representations supply the Area and Priority issue fields or expose their label equivalents. Collection membership and execution data remain local to the copied project.

Status has the values Open, In progress and Closed. Writers maintain it as row state; closure still requires the issue's agreed evidence.

Managed projects have no built-in project workflows. The repository Triage workflow and explicit commands own routing and state changes; see [Storage and access](4-storage-and-reach.md#triage). Project configuration alone is not evidence that an issue meets its completion criteria.

<a id="the-schedule-and-scenario-fields"></a>

## 2. Membership and order

A project row represents one issue. Schedule and Scenario are single-select fields: one option identifies each collection in the corresponding project. A row's option joins it to that collection; its parent link still identifies its place in the product hierarchy.

An issue belongs to at most one managed project across its account and at most one Schedule or Scenario. Epics and Features may be in Triage or Backlog, but not in Schedule or Scenario projects. The collection's own issue is the only non-Task/Bug row in its collection.

### 2.1 Schedule steps

Number a Schedule's executable rows consecutively from 1. Give each new step its number and native GitHub blocked-by links when adding it. Work in Step order, respecting those dependencies.

The Schedule issue's own row has no Step. An insertion, move or removal renumbers the affected steps, including closed steps, so the sequence remains consecutive. A view's displayed row number is not a Step: filtering or sorting can change that display number.

Iteration records a step's sprint where used. It is separate from the Schedule commitment; the Schedule is not defined by an iteration field.

Worktree links a step to its published branch while work is underway and to its PR when integrated. Publish the branch before recording its URL. The issue and PR records identify merge, closure and completion evidence; the Worktree cell alone does not prove delivery.

Use native blocked-by links for dependencies, not a separate project field containing Step numbers. Dependencies remain meaningful if steps are reordered. Cross-account dependencies use the [stand-in rule](4-storage-and-reach.md#1-account-boundaries).

### 2.2 Scenario beats

A Scenario issue describes an end-user goal, a repeatable walk and the Features exercised. Its other rows are Tasks and Bugs found during that walk. Beat N identifies the Nth numbered step; Beat 0 identifies a finding before the first step. The Scenario issue's own row has no Beat.

Findings retain their origin in the body as `Found while walking #N`. A finding leaves the Scenario when it closes or moves to Triage, Backlog, a Schedule or another Scenario. Preserve the origin and the move record; do not retain a second active project membership.

A Scenario changes no finding's Priority. Triage owns classification and Priority. Scenario findings have the [intake and sweep exceptions](1-hierarchy.md#33-scenario-findings), but must be classified before entering a Schedule.

### 2.3 Physical row order and views

Keep collection groups in their option order, with each collection issue first, then its findings or steps by Beat or Step, then rows missing that number. Rows without a collection option come last. A new row must be placed appropriately.

The Schedule project's By schedule view groups on Schedule and sorts Step ascending. It shows Title, Assignees, Status, Linked pull requests, Step and Worktree, and hides Sub-issues progress. The Scenario project's By scenario view groups on Scenario and exposes Beat. A collection issue links the grouped view filtered to its own option.

Triage views expose Area, with a Missing Area view. Organization Backlogs expose Priority and a By priority view; user-account views expose Labels for their attribute representation. Native Repository, Assignees, Linked pull requests and Parent issue remain available where useful.

The [model synchronization contract](6-the-asset-and-its-sync.md) distinguishes API changes from configuration steps that must be made by hand. A successful command must not conceal unfinished view configuration.

<a id="the-collections-own-record-a-schedule-or-scenario-issue"></a>

## 3. Collection issues

| Record | Owns |
| --- | --- |
| Schedule issue | Deliverable, completion criteria, Owner amendments, status and the link to ordered project rows |
| Scenario issue | End-user goal, walkthrough, Features exercised and the link to its findings |
| Project | Collection options, row membership, order and row fields |
| Native issue links | Product parents and blocked-by dependencies |

A Schedule or Scenario issue has no parent. Its rows are not its sub-issues; they retain their product parents. The issue's assignee is the accountable person. The account's issue forms define its required body.

The Schedule issue is the stable assignment identity used by an agent launcher. Reordering steps changes the work without changing that identity. A project README is shared across collections and does not replace an individual collection issue.

A Scenario is maintained across releases and states no Evidence of completion. Retire it only after open findings move on; closure retains the option as a historical record. Schedule closure uses its deliverable and exit criteria. See [Schedule commands](8-the-schedule-commands.md) and [Scenario commands](9-the-scenario-commands.md).

Templates need an initial single-select option where required by the platform. Placeholder collection issues and options are configuration support, not executable Schedule steps or Scenario findings.

<a id="triage-and-the-backlog"></a>

## 4. Intake and movement

The [hierarchy's triage contract](1-hierarchy.md#3-intake-and-classification) defines classification, intake exceptions and decisions. Triage has no collection issue or ordered work list. Backlog is accepted inventory rather than a commitment to execute.

`star github issue move` transfers an issue and its required destination fields as one user operation. It removes the source membership and records the move. Its [command contract](10-the-issue-commands.md) defines supported destinations, validation, write order and partial-failure handling; the underlying requests are not an atomic transaction.

Triage removes its row as part of its decision. A closed issue left there still needs that disposition. The sweep reports violations and returns affected work for triage; it does not silently classify issues or empty Triage.

<a id="ownership"></a>
<a id="collections-belong-to-one-account"></a>

## 5. Ownership and access

The account owns the project. In an organization, a linked team is accountable for it and has Write access to its four managed projects. The team has Maintain access to its own repositories. The collection issue's assignee is its accountable person.

A user account owns its projects directly. Participants need repository collaboration and project Write access. Moving an issue to another team requires an accountable assignee there. Keep project rows, parent links and blocked-by relationships within the account, using a stand-in for another account's work.

[Storage and access](4-storage-and-reach.md) defines the representations and grants. GitHub's permission to edit a row does not grant authority to amend a committed Schedule.

<a id="a-committed-schedule"></a>

## 6. Schedule commitment

The Schedule Owner approves its outcome and ordered work. Adding a Task or Bug to a committed Schedule requires an amendment recorded in the Schedule issue, with its Step and dependencies. Moving accepted work from Backlog follows Priority order unless the Owner directs the commitment.

A Schedule can grow or shrink through approved amendments. Its issue and project rows remain synchronized while work is delivered through frequent PRs. Completion is established by the agreed evidence, not by a row's Closed status alone.

## 7. Decisions and delivery references

The [decision companion](3-collections.decisions.md) explains the four-project structure, collection identity, order and commitment boundaries. The retained [delivery reference](3-collections.status.md) links implementation and migration records, including the original workflow review.
