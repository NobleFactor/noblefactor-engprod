---
title: "Issue hierarchy decisions"
status: draft
updated: 2026-11-20
---

# Issue hierarchy decisions

[Design](1-hierarchy.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-1-hierarchy.md.txt)

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Separate work breakdown from collections

Use Epic → Feature → Task or Bug for product and engineering work. Keep Schedule and Scenario as parentless collection types.

**Reason:** Parent links explain what work belongs together; collection rows explain execution order or a testing walk. A Scenario can exercise several Features without changing their parents.

**Alternative:** Make Schedules or Scenarios parents in the product tree.

**Consequence:** Collection membership and Scenario origin need their own records. A work item's Feature parent remains meaningful after the item changes projects.

```yaml
id: "HIERARCHY-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 2. Classify at intake without losing discoveries

Allow unclassified work in Triage and findings in their originating Scenario. Require full classification before committing a finding to a Schedule.

**Reason:** Defects and gaps can be recorded before their correct Feature is known. The team still needs a clear boundary for executable work.

**Alternative:** Require every external report or exploratory finding to arrive fully classified.

**Consequence:** Validation must distinguish the intake exception from completed classification and apply the Scenario sweep exceptions explicitly.

```yaml
id: "HIERARCHY-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 3. Keep one managed project membership

This earlier rule is superseded by [HIERARCHY-006](#6-allow-triage-beside-one-home).

An issue belongs to at most one managed project across its account and one Schedule or Scenario. A move transfers membership and records the destination's fields.

**Reason:** The same issue must not appear committed in two places.

**Alternative:** Retain active rows in both discovery and delivery projects.

**Consequence:** Preserve Scenario origin outside active membership. Partial GitHub writes require explicit command failure handling; one user operation is not an atomic API transaction.

```yaml
id: "HIERARCHY-003"
status: superseded
supersedes: []
superseded_by: ["HIERARCHY-006"]
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T16:19:16Z"
```

## 4. Close Features after independent checks

Finishing child Tasks and Bugs is necessary but insufficient for Feature closure. Require an agent compliance audit, agent code review and team-lead sign-off.

**Reason:** Child closure alone does not establish the Feature's quality or compliance.

**Alternative:** Close a Feature automatically when its last child closes.

**Consequence:** Tooling must not be assumed to enforce the extra gate without evidence. The rewrite's later methodology/tooling scan must check that relationship.

```yaml
id: "HIERARCHY-004"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 5. Preserve conflicting-collection evidence

The sweep must detect a Scenario finding that also has another Backlog, Schedule or Scenario home. A temporary Triage fault row is allowed by HIERARCHY-006. Its handling must preserve the evidence and an existing Schedule commitment.

The owning sweep work must define which records are retained or transferred. This rewrite does not choose that recovery policy or claim it is implemented.

```yaml
id: "HIERARCHY-005"
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T16:19:16Z"
```

## 6. Allow Triage beside one home

An issue has one home at most among Backlog, Schedule and Scenario, and may also have a temporary Triage row while a fault needs a decision. The [issue standard](../../issue-standards.md#placement) owns the rule.

**Context and reasons:** A fault discovered after scheduling should remain visible to triage without erasing the issue's placement or approved commitment. The sweep can flag it while preserving work already underway.

**Alternative:** Count Triage in the one-project limit and require removing the home when a fault is found. That disrupts the commitment before triage has decided the correction.

**Consequences:** Multiple homes remain invalid. The sweep adds a Triage row and reports the fault without removing rows or choosing the repair. Triage removes its temporary row after deciding the correction. An explicit move changes placement under the issue-command contract. Recovery of conflicting homes remains separately specified.

**Evidence:** David Noble approved this disposition on 2026-11-20 after review finding R01. The [execution plan](../../plans/doc/581-schedule-command-consumers.md#722-approved-review-dispositions) records the approval and implementation scope; the [review register](../../engineering/review/rewrite-review.md#18-approved-dispositions-and-corrections) links the finding.

```yaml
id: "HIERARCHY-006"
status: accepted
supersedes: ["HIERARCHY-003"]
proposed_by: Codex
approved_by: David Noble
recorded_by: Codex
decided_at: "2026-11-20"
recorded_at: "2026-11-20T16:19:16Z"
```
