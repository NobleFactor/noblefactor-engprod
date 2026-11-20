---
title: "Issue storage and access decisions"
status: draft
updated: 2026-11-19
---

# Issue storage and access decisions

[Design](4-storage-and-reach.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-4-storage-and-reach.md.txt)

## 1. Keep accounts independent

**Status:** Accepted model requirement.

Each account owns its model and work. Managed project rows, parents and blocked-by links stay within that account. Use a local stand-in for work in another account.

**Alternative:** Mix personal issues into organization projects and parent relationships.

**Reason:** Account ownership, access and private work remain clear even when GitHub permits broader linking.

**Consequence:** A shared definition can be applied to another account without copying its live issues or repository label assignments.

## 2. Share files through the account repository

**Status:** Accepted model requirement.

The public `.github` repository owns forms, workflow templates, PR templates and the model backup. Participating repositories run their own installed Triage workflow.

**Reason:** Account defaults and explicit workflow copies give each resource one authoritative source.

**Consequence:** Local overrides and deployed workflow copies need consistency checks. The backup does not become a runtime configuration cache.

## 3. Use equivalent account representations

**Status:** Accepted model requirement.

Use native organization issue types and fields. Use lowercase labels and template copies for the user-account model.

**Alternative:** Move personal work into the organization or use project fields as issue attributes.

**Reason:** The workflow should work within each account while retaining issue-level metadata through moves.

**Consequence:** Label exclusivity needs validation; a user-account label does not gain native single-select enforcement.

## 4. Grant access through responsibility

**Status:** Accepted model requirement.

The responsible team has Maintain on owned repositories and Write on its four projects. User-account participants need repository collaboration and project Write access.

**Reason:** Participants need to classify and move work across the resources for which they are accountable.

**Consequence:** Cross-repository parenting still needs access on both repositories. Project settings and access control remain with the account's administration. Tool access does not waive engineering approval.

## 5. Route intake explicitly

**Status:** Accepted model requirement.

Repository Actions workflows handle issue intake. Managed projects have no built-in workflows. Collection issues and Scenario findings follow their distinct routing rules.

**Reason:** Shared, inspectable workflow definitions provide consistent intake and credential handling.

**Consequence:** Routing needs repository workflow installation, the destination variable and the correct account credentials. A missing or invalid Scenario destination must remain visible.
