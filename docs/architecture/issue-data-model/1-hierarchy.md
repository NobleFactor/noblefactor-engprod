---
title: "Issue hierarchy"
status: draft
updated: 2026-11-21
---

<a id="1-the-hierarchy"></a>

# Issue hierarchy

[Up: Issue data model](index.md)

The product hierarchy is Epic → Feature → Task or Bug. It describes what work belongs together. Schedules order execution, and Scenarios describe repeatable user journeys; neither is a level of that hierarchy.

<a id="type"></a>

## 1. Issue types

The hierarchy uses these issue types and parent relationships.

| Type | Meaning | Parent | User-account label |
| --- | --- | --- | --- |
| Epic | A body of work with an accountable owner, divided into Features | None | `epic` |
| Feature | A product capability or enabling outcome delivered through Tasks and Bugs | One Epic | `feature` |
| Task | Planned work that helps deliver a Feature | One Feature | `task` |
| Bug | A defect in a Feature | One Feature | `bug` |
| Schedule | A collection's deliverable, completion criteria and ordered work | None | `schedule` |
| Scenario | A repeatable end-user goal and the walk used to exercise it | None | `scenario` |

A classified issue has exactly one type. An organization uses its native GitHub issue types; the user-account representation uses one lowercase type label. Type descriptions begin with `Level 0:`, `Level 1:` or `Level 2:` for the product hierarchy, and `Collection:` for Schedule and Scenario.

A Feature can be an [enabler feature](../../issue-standards.md#enabler-features), producing knowledge or technical foundations for later capabilities. Its Type and native parent rules are the same as other Features.

A Task describes planned work; a Bug describes a discovered defect. Scheduling a Bug does not turn it into a Task. Area classifies product and engineering work independently of Type; see [Issue attributes](2-attributes.md).

Each account's shared issue forms define the body for each type. A Scenario states the goal, how to walk through it and the Features it exercises. Other issue types state their evidence of completion. [Issue commands](10-the-issue-commands.md) define filing and metadata validation.

<a id="parents"></a>

## 2. Parent relationships

Use GitHub's native parent/sub-issue relationship. A Feature has one Epic parent; a Task or Bug has one Feature parent. Do not skip a level or make a Task or Bug a parent. Read an issue's Epic through its ancestors rather than through a separate label or body marker.

Epics, Schedules and Scenarios have no parent. Schedule membership and a finding's Scenario origin do not replace its Feature parent. A Scenario can exercise several Features without making those Features its children.

Keep parent and blocking relationships within the account. Parent links can cross repositories within that account when the participant has the required access. Work waiting on another account uses a stand-in issue in its own account, with a reference to the external work.

New or untriaged issues can lack a type or parent while awaiting classification. Scenario findings have the separate intake allowance described below. These exceptions do not change the hierarchy for classified work.

<a id="triage"></a>

## 3. Intake and classification

A team owns four managed projects: Triage, Backlog, Schedules and Scenarios. A user account owns the equivalent four projects. Triage is a project, not an issue type or an Epic.

New issues go to the responsible team's Triage project, with three exceptions: a Schedule's own row belongs in Schedules, a Scenario's own row belongs in Scenarios, and work found while walking a Scenario starts in that Scenario.

The repository's Triage workflow routes opened or transferred issues. `TRIAGE_PROJECT_URL` identifies its team's Triage project. The shared workflow template belongs in the account's `.github` repository. Account participation and permission rules are defined in [Storage and access](4-storage-and-reach.md).

`star github issue open` validates and writes the required issue metadata; it creates no project row. The separately executed Triage workflow routes the new issue to Triage, or to its originating Scenario on the Scenario intake path. Command success therefore does not establish placement: verify the row after intake completes. A pending or failed workflow can leave it absent. Check the workflow result, destination and credentials before using the supported recovery or move operation; do not rerun open to repair placement, because each invocation creates a new issue.

### 3.1 Triage decisions

Triage establishes Type, the required parent, Area and the appropriate Severity, and sets Priority. A missing Area is an error. An issue leaves Triage classified, or closes with a recorded reason.

| Decision | Result |
| --- | --- |
| Accept a Task or Bug for later work | Move it to Backlog with its Priority |
| Commit a classified Task or Bug | Move it to an approved Schedule |
| Accept an Epic or Feature | Move it to Backlog, where it remains until closure |
| Decline the work | Close as completed with Resolution Declined |
| Identify a duplicate or invalid report | Close as completed with the corresponding Resolution |

A move creates or updates the destination row and its fields and removes the source row as one user operation. This contract does not make the underlying GitHub calls an atomic transaction. `star github issue move` owns the supported operation and its failure behavior.

Triage removes its row as part of the decision. `star github issue close` removes Triage rows; closure through GitHub's UI or a PR closing reference can leave them behind. Apply the [Triage cleanup rule](../../issue-standards.md#triage-classifies-and-adds-attributes) to any remaining row.

### 3.2 Collection and team boundaries

An issue has at most one Backlog, Schedule or Scenario home across the account, and at most one Schedule or Scenario. A Triage row may also flag a fault while that home remains in place; the [issue standard](../../issue-standards.md#placement) defines the rule. Epics and Features cannot be rows in Schedules or Scenarios; their executable work reaches those collections through Tasks and Bugs.

Backlog work is selected in Priority order. Adding work to a committed Schedule requires its Owner's amendment, recorded in the Schedule issue.

A move to another team transfers project membership and requires an accountable assignee in the receiving team. Within one account, moving the existing issue avoids a duplicate tracking issue. Cross-account work uses the stand-in rule in section 2.

### 3.3 Scenario findings

A Scenario is a repeatable walk through a feature, workflow or real-life situation. Its issue summarizes the end-user goal, provides an example for demonstrations and exploratory testing, and names the Features exercised.

Findings are Tasks or Bugs recorded under the Scenario's option in its team's Scenarios project. Their Beat identifies the numbered walk step, or Beat 0 before the first step. Their bodies retain the origin as `Found while walking #N`.

A finding may await classification in the Scenario. Before it moves into a Schedule, it must have the required Type, parent and attributes. Moving it out preserves the origin and records the move on the Scenario issue; closing it removes its Scenario row. See [Scenario commands](9-the-scenario-commands.md).

### 3.4 Validation and sweep

The validation sweep identifies rule violations, comments with the violated rule and adds the affected issue to the appropriate Triage project while preserving its home. It blocks no filing, silently repairs no issue and removes no row. Triage decides the correction.

For Scenario findings, only two structural checks apply while they remain in the Scenario: prohibited Epic/Feature rows and membership in multiple Backlog/Schedule/Scenario homes or collections. A temporary Triage fault row is allowed. The remaining classification checks apply when findings leave. Handling conflicting Scenario and Schedule rows without silently discarding a commitment remains an explicit sweep design question.

Queries such as `no:type` and `no:parent-issue` help find missed intake, but are not complete classification tests. Root issues legitimately have no parent; user-account types are labels. [Classification rules](../../issue-standards.md#well-classified) define the complete checks.

<a id="how-long-a-level-lives"></a>

## 4. Completion

A Task or Bug closes against its agreed evidence. A Feature remains open after its Tasks and Bugs finish until an agent compliance audit and technical review of its deliverables, including code when present, are complete and the team lead signs off. An Epic closes when its Features ship.

A Scenario describes a reusable walk and has no Evidence of completion section. Keep it useful as the product changes. Retire it with `star github scenario close` when the product no longer supports that Scenario, after its open findings have moved on. Retirement closes its issue as completed without a Resolution.

A Schedule describes a committed outcome and its completion criteria. Its ordered work and closure contract are defined by [Schedule commands](8-the-schedule-commands.md).

<a id="what-the-hierarchy-does-not-hold"></a>

## 5. Related concerns and decisions

[Issue attributes](2-attributes.md) define an issue's own metadata. [Collections](3-collections.md) define placement and order. [Storage and access](4-storage-and-reach.md) define ownership and permissions. The [decision companion](1-hierarchy.decisions.md) explains the hierarchy and completion choices.

Implementation, migration and verification records are linked from the retained [delivery reference](1-hierarchy.status.md). This architecture defines the required model, not evidence that every check or workflow enforces it.
