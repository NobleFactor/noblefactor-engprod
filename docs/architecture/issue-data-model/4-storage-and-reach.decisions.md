---
title: "Issue storage and access decisions"
status: draft
updated: 2026-11-20
---

# Issue storage and access decisions

[Design](4-storage-and-reach.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-4-storage-and-reach.md.txt)

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Keep accounts independent

Each account owns its model and work. Managed project rows, parents and blocked-by links stay within that account. Use a local stand-in for work in another account.

**Alternative:** Mix personal issues into organization projects and parent relationships.

**Reason:** Account ownership, access and private work remain clear even when GitHub permits broader linking.

**Consequence:** A shared definition can be applied to another account without copying its live issues or repository label assignments.

```yaml
id: "ACCESS-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 2. Share files through the account repository

The public `.github` repository owns forms, workflow templates, PR templates and the model backup. Participating repositories run their own installed Triage workflow.

**Reason:** Account defaults and explicit workflow copies give each resource one authoritative source.

**Consequence:** Local overrides and deployed workflow copies need consistency checks. The backup does not become a runtime configuration cache.

```yaml
id: "ACCESS-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 3. Use equivalent account representations

Use native organization issue types and fields. Use lowercase labels and template copies for the user-account model.

**Alternative:** Move personal work into the organization or use project fields as issue attributes.

**Reason:** The workflow should work within each account while retaining issue-level metadata through moves.

**Consequence:** Label exclusivity needs validation; a user-account label does not gain native single-select enforcement.

```yaml
id: "ACCESS-003"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 4. Grant access through responsibility

The responsible team has Maintain on owned repositories and Write on its four projects. User-account participants need repository collaboration and project Write access.

**Reason:** Participants need to classify and move work across the resources for which they are accountable.

**Consequence:** Cross-repository parenting still needs access on both repositories. Project settings and access control remain with the account's administration. Tool access does not waive engineering approval.

```yaml
id: "ACCESS-004"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 5. Route intake explicitly

Repository Actions workflows handle issue intake. Managed projects have no built-in workflows. Collection issues and Scenario findings follow their distinct routing rules.

**Reason:** Shared, inspectable workflow definitions provide consistent intake and credential handling.

**Consequence:** Routing needs repository workflow installation, the destination variable and the correct account credentials. A missing or invalid Scenario destination must remain visible.

```yaml
id: "ACCESS-005"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

<a id="access-006"></a>

## 6. Require every account to identify its issue-tracking token

Every account that takes part in triage identifies the token its Triage workflow signs in with, and `star github model apply`, and `restore`, refuse an account that doesn't, or whose token isn't held where its record says, before they write anything. Which token an account has, and what it's used for and permits, are free to change; that it has one is not. Where `star` can't make the token, its refusal and its help say exactly what to do.

Scope: every organization and user account that apply or restore reaches, the sandboxes included.

**Reason:** Both sandboxes ran for days with no Triage token, every Triage run failing, and nothing reported it: apply set up each account and listed the missing secrets as steps by hand. A refusal before any write makes a missing token impossible to set up past.

**Alternatives:** Listing a missing token as a step by hand was the earlier behavior, and is how the sandboxes broke unnoticed. Recording the token's uses and permissions in the rule was rejected: they change as the work does.

**Consequence:** Applying a reference takes each secret's source from `--token`; applying an account's own model takes it from the model's token record ([MODEL-007](6-the-asset-and-its-sync.decisions.md#model-007)). An account whose token is missing can't be applied until the token is made and named. Alerts for a token that expires or disappears later are [#613](https://github.com/NobleFactor/noblefactor-engprod/issues/613)'s.

Evidence: the Owner's direction on 2026-11-20, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`, recorded in [#451's plan, § 12](../../plans/feature/451-credentials.md#approval-and-departures).

```yaml
id: "ACCESS-006"
status: accepted
supersedes: []
proposed_by: David Noble
approved_by: David Noble
recorded_by: Claude Code
decided_at: "2026-11-20"
recorded_at: "2026-11-21T03:00:00Z"
```
