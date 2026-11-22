---
title: "Review comment template"
status: draft
created: 2026-11-19
updated: 2026-11-21
---

# Review comment template

[Up: Work templates](index.md)

Use this template for a review finding. Replace placeholders with evidence for the reviewed revision. Compliance findings follow [Compliance auditing](../engineering/agent-operation.md#compliance-auditing).

## 1. Comment body

**[Severity] — [Finding title]**

- **Reviewed revision and scope:** [Candidate, base, and affected assets checked.]
- **Requirement:** [Applicable rule and its source revision; identify a violation, missing evidence, or recommendation.]
- **Location and evidence:** [File, section, or behavior, method, time, and observed result.]
- **Consequence:** [Effect on correctness, compliance, or completion.]
- **Requested correction:** [Specific change needed.]
- **Disposition and verification:** [Open, corrected, verified, or explicit Owner exception, with corrective revision and evidence still needed.]

## 2. Origin record

Codex must finish each posted review comment with the [handbook's review-comment origin block](../engineering/agent-operation.md#codex-review-comments), using its actual originating assignment. Other reviewers may use the same YAML format with their own session, role, and identity. This template does not extend the Codex-specific requirement to other hosts. Remove template instructions before posting.
