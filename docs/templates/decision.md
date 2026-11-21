---
title: "Decision record template"
status: draft
created: 2026-11-19
updated: 2026-11-19
---

# Decision record template

[Up: Work templates](index.md)

Use the [decision-record standard](../standards/documentation.md#decision-records). Replace placeholders, keep the existing identifier when revising a record, and use the appropriate heading level within its destination. This example is a proposal, not an approval.

## 1. [Decision headline]

[State the chosen or proposed outcome and its scope.]

**Context and reasons:** [Explain the problem, constraints and criteria that support the choice.]

**Alternatives:** [Describe the options actually considered, their tradeoffs and the reasons for rejecting them. Preserve a source's omissions rather than inventing a comparison.]

**Consequences:** [Describe useful results, costs, risks and limitations.]

**Evidence:** [Link the supporting research, observations and approval record where available. Identify what remains assumed or unknown.]

```yaml
id: "<stable decision identifier>"
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: "<actual person or agent>"
decided_at: null
recorded_at: "<timestamp with UTC offset>"
```
