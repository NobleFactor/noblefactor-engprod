---
title: "Project and collection decisions"
status: draft
updated: 2026-11-20
---

# Project and collection decisions

[Design](3-collections.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-3-collections.md.txt)

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Use four project kinds

Each team or user account has Triage, Backlog, Schedule and Scenario projects. A Schedule or Scenario is an option and associated issue within its project.

**Alternative:** Create one project per Schedule or Scenario.

**Reason:** Shared project structure provides consistent views and fields without giving every collection separate configuration.

**Consequence:** Collection identity and membership must be represented explicitly by the issue and option.

```yaml
id: "COLLECTION-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 2. Give each collection its own issue

The Schedule issue owns its outcome, completion criteria, amendments and accountable assignee. The Scenario issue owns its end-user goal and walkthrough.

**Alternative:** Put those records in a project README or use the collection issue as a product parent.

**Reason:** A project serves several collections. A collection needs stable identity and its own reviewable record without changing the product hierarchy.

**Consequence:** The collection issue has no parent or Step/Beat. Its work joins through the collection field rather than sub-issue links.

```yaml
id: "COLLECTION-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 3. Preserve order without confusing identity

Schedule Steps are consecutive, including closed work. Insertion, removal or movement renumbers later steps. Dependencies are issue links, not references to changing Step numbers.

Scenario Beat identifies the walkthrough step that found a gap; several findings can share it.

**Reason:** Execution order changes while issue identity and the discovery point remain meaningful.

**Consequence:** Commands must update order and position consistently. View row numbers are never stable Step or Beat identifiers.

```yaml
id: "COLLECTION-003"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 4. Keep project access distinct from commitment authority

Team members can edit the team's projects, but a committed Schedule takes new work only through its Owner's recorded amendment.

**Reason:** GitHub write access supports routine work; it does not express agreement to change a promised outcome.

**Consequence:** Tooling must preserve both the project-row change and the amendment record. Row status alone does not establish completion.

```yaml
id: "COLLECTION-004"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 5. Keep templates consistent without replacing execution data

Reconcile shared fields, views, README and copy descriptions while retaining each project's rows, collection options and iterations.

**Reason:** Teams need consistent tools without losing their own work.

**Consequence:** Configuration changes preserve resource IDs and report unsupported manual view changes. The [model command design](6-the-asset-and-its-sync.md) owns reconciliation details.

```yaml
id: "COLLECTION-005"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```
