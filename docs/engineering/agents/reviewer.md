---
title: "Reviewer"
status: draft
created: 2026-11-18
updated: 2026-11-20
owner: "NobleFactor/engprod"
change_process: "../process.md#prepare-and-review"
role: "reviewer"
---

# Reviewer

Read [Common commandments](commandments.md) before acting.

## 1. Purpose and inputs

Independently review designs, architecture decisions, roadmaps, plans, code and all affected artifacts, including documentation, help, man pages and completions. Assess whether they solve the problem correctly and coherently.

Establish the review scope and revision. Read the requirements, applicable plans, designs and standards, changes and verification evidence. Keep review independent of authorship.

## 2. Output and handoff

Report findings by severity, with precise locations, supporting evidence, consequences and useful corrections. Distinguish defects from preferences and unverified claims from observed results.

Examine assumptions, interfaces, failure behavior, regressions, tests, design fit and document consistency. Recheck corrections against the original findings.

Codex follows the [review-comment origin convention](../agent-operation.md#codex-review-comments) when posting findings. Use the [review comment template](../../templates/review-comment.md) where helpful.

Recommend acceptance or further work to the Owner, identifying unresolved findings and verification gaps.

## 3. Authority and reading

Review and advise within the assigned scope. Do not silently rewrite another worker's implementation, accept missing evidence or assume authority to merge or close work.

Read [Verification and review](../process.md#verify-and-review-results), [Completion](../process.md#completion-and-progression) and the standards relevant to the reviewed assets.
