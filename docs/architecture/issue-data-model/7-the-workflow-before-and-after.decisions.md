---
title: "Issue workflow decisions"
status: draft
updated: 2026-11-20
---

# Issue workflow decisions

[Design](7-the-workflow-before-and-after.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-7-the-workflow-before-and-after.md.txt)

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Use GitHub records for work state

Read Type, native parent and dependency links, and project membership and fields. Use the narrow collection command for a Schedule or Scenario and the broader report for cross-issue questions.

**Reason:** A separate interpretation of body text would create competing work records.

**Consequence:** Assignment lookup and skills must use the same collection and hierarchy semantics. A process observation is separate from progress evidence.

```yaml
id: "WORKFLOW-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 2. Give forms and plans distinct authority

The selected form owns the issue-body requirements. Applicable plan metadata owns the issue's generated Plan and design documents table once plans exist.

**Reason:** Filing needs type-specific information, while implementation links must reflect the actual approved plans.

**Consequence:** Filing validates the form and documents table; plan-link tooling updates the table from its source rather than preserve a competing hand-written list.

```yaml
id: "WORKFLOW-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 3. Coordinate changing work through the Schedule

The Schedule Owner approves its commitment and amendments. The project orders its executable issues; those issues reference their plans.

**Reason:** Design and planning can evolve while a stable Schedule identity coordinates frequent commits and merges.

**Consequence:** A row move needs the corresponding amendment where required. Step renumbering does not change issue identity or dependencies.

```yaml
id: "WORKFLOW-003"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 4. Preserve discovery without duplicate commitment

Keep a finding's Scenario origin after moving it into delivery work, while maintaining one managed project membership.

**Reason:** The testing walk explains why the work exists but is not a second active delivery queue.

**Consequence:** Scenario and issue commands record movement and closure, and classification is required before scheduled execution. See the [collection decisions](3-collections.decisions.md).

```yaml
id: "WORKFLOW-004"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 5. Separate closure from completion evidence

Issue and project status record state. Plans and issue evidence establish the delivered result and required verification under the Owner's completion authority.

**Reason:** Merge or closure alone does not demonstrate deployment or correct behavior.

**Consequence:** Keep post-merge obligations visible and reopen failed delivery as the shared process requires. Command retries must not be described as guaranteed recovery of partial writes.

```yaml
id: "WORKFLOW-005"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```
