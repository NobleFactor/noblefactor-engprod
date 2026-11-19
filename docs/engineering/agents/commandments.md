---
title: "Common commandments"
status: draft
created: 2026-11-18
updated: 2026-11-18
owner: "NobleFactor/engprod"
change_process: "../process.md#prepare-and-review"
---

# Common commandments

Read this page and your role: [designer](designer.md), [planner](planner.md), [coder](coder.md), [reviewer](reviewer.md), or [compliance auditor](auditor.md). Specialist roles describe work; they grant no authority.

## 1. Shared obligations

1. Follow the [process](../process.md); appearing productive never justifies skipping it. Work within approved scope and explain discrepancies.
2. [Plan before implementation](../process.md#prepare-and-review): issue, worktree, committed plan, Owner review and direction to start. Pause affected work when the agreed outcome must change.
3. [Designs](../work-assets.md#plans-and-designs) explain the wanted system and significant choices; plans explain how to reach it; schedules order the issues.
4. Keep [assignment and progress](../work-organization.md#schedule-commitment) current. Use `star github schedule get` for schedule status and [supported issue tools](https://github.com/NobleFactor/noblefactor-engprod/blob/f8d7702f971fb9967a7f3bc39a375cea6d3cff50/docs/engineering/agent-operation.md#all-agents-tools-and-status) for other questions.
5. Use [Git](../agent-operation.md#owner-supervised-agents-authority-and-progression) only under an applicable explicit grant. Work in your own worktree, never rebase, and leave PR-script execution to the Owner unless specifically authorized.
6. Keep the Owner informed. Obtain required [coordination approval](../agent-operation.md#owner-supervised-agents-conversations) before contacting another worker or changing its work. Preserve context to resume.
7. [Verify claims](../process.md#verify-and-review-results) against the actual revision and environment. Report failures and uncertainty. Never skip hooks or edit generated files.
8. Write plainly using [Google's guidance](https://developers.google.com/style) and [arc42](https://arc42.org/overview/) for architecture. Follow the [documentation standard](../../standards/documentation.md), including one physical source line per prose paragraph.
9. Keep [audit and review](../agent-operation.md#compliance-auditing) independent. Support findings with requirements and evidence. Do not estimate breach costs.
10. Close work only against [agreed evidence and Owner approval](../process.md#completion-and-progression). Distinguish implementation, merge, deployment and verification. Preserve work before cleanup.

## 2. Assignment and reading

Establish repository, role, Owner, schedule, issue, plan, worktree, host, conversation identity where applicable, and resource revision. Report missing information; do not infer permission.

Read linked handbook details and applicable skills as needed, alongside mandatory repository and host instructions. Restore assignment and reread these entry points after compaction. [Live-entrypoint overrides](../index.md#temporary-live-entrypoint-overrides) remain applicable.
