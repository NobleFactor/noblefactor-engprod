---
title: "Engineering documentation"
status: draft
created: 2026-10-29
updated: 2026-11-21
---

<a id="engineering-handbook"></a>

# Engineering documentation

Use the [engineering handbook](engineering/index.md) for NobleFactor's shared process, required work records, agent responsibilities, standards and procedures. Small role entry points guide agents to the detailed material needed for their assignments.

## 1. Workflow and responsibilities

- [Handbook entry](engineering/index.md): authority, audience, reading paths and effective host instructions.
- [Process](engineering/process.md): outcomes, approvals, implementation, integration and completion.
- [Work organization](engineering/work-organization.md): issues, schedules, dependencies and amendments.
- [Work assets](engineering/work-assets.md): designs, plans, approvals, locations, links and freshness.
- [Agent operation](engineering/agent-operation.md): authority, visibility, coordination, context and tools.
- [Release and recovery](engineering/release-and-recovery.md): additional release, signing and recovery obligations.
- [Common commandments and roles](engineering/agents/commandments.md): shared entry and specialist context.

<a id="2-standards-and-procedures"></a>

## 2. Standards, procedures and templates

- [Coding standards](standards/coding/index.md): shared, Bash, Go, PowerShell and Starlark requirements.
- [Documentation standard](standards/documentation.md): writing, metadata, source layout, links and decision records.
- [Issue standards](issue-standards.md): classification and GitHub representation.
- [Design-schedule Tasks](templates/design-schedule.md) and [agent assignment context](templates/agent-context.md): reusable design setup and explicit role assignments.
- [Work templates](templates/index.md): schedules, issues, plans, designs, decisions, completion reviews and review comments.
- [Procedures](engineering/procedures/index.md): mechanics for carrying out the process.

## 3. Designs

- [Issue data model](architecture/issue-data-model/index.md): hierarchy, attributes, collections, storage, workflow and commands.
- [Agent schedules](architecture/agent-schedule/index.md): native sessions, launchers, assignment interfaces and SBX.
- [Developer workstation](architecture/agentic-developer-workstation.md): schedule environments, role sessions and multi-device editor access.
- [Workstation roadmap](roadmaps/agentic-developer-workstation.md): delivery dependencies and planner handoff.

<a id="3-decisions-and-preservation-evidence"></a>

## 4. Decisions and preservation evidence

- [Role-context author coverage](engineering/review/role-context-review.md): requirement mapping, five-role walkthrough, and consistency evidence.
- [Decision log](engineering/review/decisions.md): approved choices and their sources.
- [Review resolutions](engineering/review/open-decisions.md): O01–O11 and original Owner responses.
- [Original findings](../ENGINEERING-DOCUMENTATION-REVIEW.findings.md), [adoption review](engineering/review/adoption-review.md) and [conflict register](engineering/review/conflicts.md).
- [Requirement migration](engineering/review/requirement-migration.md): the 58 inventory groups and nineteen original agent rules.
- [Import identities](engineering/review/worktree-import.json), [resumption evidence](engineering/review/reconciliation-2026-11-15.json) and [original review-package description](../ENGINEERING-DOCUMENTATION-REVIEW.md).

Keep original responses, snapshots and import identities as evidence. Current instructions have their own authoritative handbook homes.

<a id="4-adoption-and-live-entrypoint-transition"></a>

## 5. Adoption and host loading

[Handbook consolidation (#420)](plans/doc/420-consolidate-engineering.md) records adoption and completion. [Handbook adoption (#551)](https://github.com/NobleFactor/noblefactor-engprod/issues/551) owns the remaining role-context, skill, reading, host and formatting qualifications.

The common and role entry points are shared resources; native host loading and runtime behavior need their own evidence. [Effective host overrides](engineering/index.md#temporary-live-entrypoint-overrides) remain until their approved cutovers. Handbook publication alone does not change execution permissions.
