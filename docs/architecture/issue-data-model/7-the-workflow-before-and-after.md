---
title: "Issue tracking workflow"
status: draft
updated: 2026-11-19
---

<a id="7-the-workflow-before-and-after"></a>

# Issue tracking workflow

[Up: Issue data model](index.md)

The workflow turns a reported problem into classified work, an approved commitment and verified delivery. GitHub records the work; the engineering handbook defines authority, review and completion. A Schedule is the common coordination point while its ordered work evolves.

<a id="filing-an-issue"></a>

## 1. File and classify work

Use `star github issue open` for the supported filing path. Supply the selected form's required body, Type, Area and parent where required, with the appropriate Priority, Severity and assignees. The command validates metadata and placement as one filing operation. [Issue commands](10-the-issue-commands.md) define its exact inputs, effects and failure limits.

A failed command may leave some writes applied. Follow its documented failure guidance; rerunning is not proof that the remaining work will finish.

The account's forms own issue-body structure. Once plans serve an issue, plan metadata owns its Plan and design documents table. Generate that table with `star github plan link` and verify it through the supported check form; do not maintain a competing hand-written list.

Routine intake reaches the repository's owning Triage project. A Schedule or Scenario has only its collection row. Findings recorded while walking a Scenario start there and retain their origin. Other users can file through GitHub's forms; triage resolves missing or invalid classification on that path.

Triage accepts work into Backlog, commits classified Tasks and Bugs to an approved Schedule, or closes work with a Resolution. Classified Epics and Features remain in Backlog until closure. The [hierarchy](1-hierarchy.md) and [attributes](2-attributes.md) define those rules.

<a id="product-and-engineering"></a>

### 1.1 Product and engineering

Choose Area for the issue's own work. Engineering work can support a Product Feature without inheriting its Area. [Product and engineering](../../issue-standards.md#product-and-engineering) defines both categories and their containment rules.

<a id="writing-a-schedule"></a>

## 2. Plan and commit a Schedule

Designs explain the wanted system. Plans explain the work needed to reach it. The planner turns that work into issues and one or more Schedules, with each executable issue referencing its applicable plans. Follow [Work assets](../../engineering/work-assets.md#plans-and-designs) and the [engineering process](../../engineering/process.md#prepare-and-review) for the approval sequence.

Open the collection through `star github schedule open`, using the Schedule form for its deliverable and completion criteria. Its project option and own row identify the collection; its own row has no Step.

Use `star github issue move` to place classified Tasks and Bugs on the Schedule. Each receives a Step and its dependencies; adding work to a committed Schedule requires its Owner's recorded amendment. Select accepted Backlog work in Priority order, subject to the approved commitment.

Step numbers remain consecutive, including closed work, when steps are inserted, reordered or moved out. Native blocked-by links identify dependencies independently of those changing numbers. The Iteration field records sprint allocation without defining the Schedule's lifetime.

## 3. Execute and record evidence

Work in the issue's assigned worktree under its approved plan. Mark the row In progress when starting and keep its Worktree link current with a published branch. Plans, code and affected documentation change together.

Commit and merge at the agreed boundaries. The issue records its PRs, delivered result, checks and remaining deployment or verification. A PR that completes an issue uses the required closing reference so GitHub records the linked PR and closure. Follow [Completion and progression](../../engineering/process.md#completion-and-progression) for failed verification and post-merge records.

Closing a row or issue is not, by itself, evidence that the promised result works. Preserve the required evidence and Owner approval before claiming completion.

## 4. Walk a Scenario

Open or retrieve the Scenario through the Scenario commands. Follow its walkthrough and log each gap or defect as a Task or Bug, with its Scenario origin and Beat. Beat N means step N of the walk; Beat 0 means before the first step.

The finding starts in that Scenario. Triage classifies it before it enters delivery work, and `star github issue move` transfers it to the chosen Triage, Backlog, Schedule or Scenario destination while preserving the discovery record. The finding does not stay active in both the discovery and delivery projects.

Closing a finding removes its Scenario row. Keep the Scenario useful across releases, and retire it when its user journey no longer applies, after its open findings move on. A Scenario changes no issue's Priority and states no Evidence of completion.

<a id="reporting-progress"></a>

## 5. Retrieve progress

| Question | Command |
| --- | --- |
| What remains on a Schedule | `star github schedule get <key>` |
| Which Schedules exist | `star github schedule list` with the applicable selector |
| What findings belong to a Scenario | `star github scenario get <key>` |
| Which Scenarios exist | `star github scenario list` with the applicable selector |
| What issues match a broader hierarchy or repository question | `star github schedule report` |

Read the specific issue body after the appropriate collection or report identifies it. Runtime process state and issue progress are different observations; a live agent process does not establish completed work.

The sweep diagnoses classification and collection faults under its [defined contract](1-hierarchy.md#34-validation-and-sweep). It can change project placement, so running it requires the applicable mutation authority.

<a id="what-goes-and-what-stays"></a>

## 6. Decisions and delivery references

The [workflow decision companion](7-the-workflow-before-and-after.decisions.md) links the authority and evidence choices. [Storage and access](4-storage-and-reach.md) defines account resources and permissions. The retained [delivery reference](7-the-workflow-before-and-after.status.md) preserves transition history without making it part of the active workflow.
