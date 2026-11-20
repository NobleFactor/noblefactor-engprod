---
title: "Engineering handbook"
status: draft
created: 2026-10-29
updated: 2026-11-15
---

# Engineering handbook

Engineering requirements have accumulated across overlapping guides, templates and agent instructions. This handbook brings their approved requirements together with clear ownership, applicability and navigation.

It provides the shared workflow, work records, agent obligations, standards and procedures that people and agents use to deliver approved work. Handbook consolidation (#420) prepares this adoption candidate; the Owner's review and publication remain outstanding.

## 1. Workflow and responsibilities

- [Engineering index](engineering/index.md): authority, applicability, responsibilities and ownership.
- [Engineering process](engineering/process.md): outcomes, review, implementation, integration and completion.
- [Work organization](engineering/work-organization.md): issues, schedules, dependencies and amendments.
- [Work assets](engineering/work-assets.md): records, locations, relationships and freshness.
- [Agent operation](engineering/agent-operation.md): authority, visibility, coordination and context restoration.
- [Release and recovery](engineering/release-and-recovery.md): additional readiness, signing and recovery obligations.

## 2. Standards and procedures

- [Coding standards](standards/coding/index.md), with shared Bash, Go, PowerShell and Starlark requirements.
- [Documentation standards](standards/documentation.md): metadata, language, structure and maintenance.
- [Issue standards](issue-standards.md): classification and the current GitHub representation.
- [Templates](templates/index.md): schedules, issues, plans, designs and completion reviews.
- [Procedures](engineering/procedures/index.md): the mechanics required by the process.

## 3. Decisions and preservation evidence

- [Resolved decisions and original Owner responses](engineering/review/open-decisions.md): O01–O11 remain settled.
- [Original reviewer findings](../ENGINEERING-DOCUMENTATION-REVIEW.findings.md) and [current adoption review](engineering/review/adoption-review.md): dispositions and outstanding adoption decisions.
- [Decision history](engineering/review/decisions.md) and [conflict register](engineering/review/conflicts.md).
- [Requirement migration](engineering/review/requirement-migration.md): dispositions for 58 inventory groups and the 19 original agent rules.
- [Import manifest](engineering/review/worktree-import.json): original import identities and hashes.
- [Resumption evidence](engineering/review/reconciliation-2026-11-15.json): verified source snapshots and the matching original backup.
- [Original package README](../ENGINEERING-DOCUMENTATION-REVIEW.md): historical evidence of the earlier review package.

Preserve original Owner responses, source snapshots and import identities. They explain the decisions and migration; current requirements belong in the handbook's authoritative documents.

## 4. Adoption and live entrypoint transition

The Owner approved the [Handbook consolidation plan](plans/doc/420-consolidate-engineering.md) at checkpoint 7f9ba18 on 2026-11-15. Reconciliation, publication checks and adoption review are recorded there.

The Owner also approved [temporary live-entrypoint overrides](engineering/index.md#temporary-live-entrypoint-overrides). Claude consumption (#562) and Codex consumption (#563) own replacement and qualification of the live personal-layer instructions. Handbook publication alone does not change a session's execution permissions.

Specialist role definitions, skills, measured reading sets and host qualification are subsequent steps on [Handbook adoption, Schedule #551](https://github.com/NobleFactor/noblefactor-engprod/issues/551). This adoption candidate supplies their shared source material.
