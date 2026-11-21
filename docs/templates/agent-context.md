---
title: "Agent assignment context"
status: draft
created: 2026-11-21
updated: 2026-11-21
---

# Agent assignment context

[Up: Work templates](index.md)

Use the [shared context contract](../engineering/agents/context.md). Fill this record from the assignment, source revisions and actual grants. It describes context; it is not executable host configuration or a grant.

## 1. Example: Handbook adoption

This example uses real Schedule #551, Task #558, Feature #460 and the current worktree. Its resource entry identifies a published baseline; read evidence and native model/session details are deliberately unknown. Replace them with observed values for an actual handoff. The example does not establish that a running agent has loaded the current candidate.

~~~yaml
role: coder
owner: David Noble
repository: NobleFactor/noblefactor-engprod
scope: Deliver the shared context contract and five role definitions.
parent:
  issue: NobleFactor/noblefactor-engprod#460
  type: Feature
schedule: NobleFactor/noblefactor-engprod#551
issue: NobleFactor/noblefactor-engprod#558
plan:
  source: docs/plans/doc/558-role-entry-points.md
  revision: 01ddb3c934f3f56793af8703910c94498bd7b328
  approval: Consult the plan and subsequent Owner directions for current scope.
worktree: /Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.558-role-context
host:
  name: Codex
  version: null
  evidence: Not inspected for this example.
model:
  provider: null
  identifier: null
  family: null
  evidence: Unknown; this example establishes no model-family independence.
session:
  id: null
  name: null
  evidence: Obtain the native identity and exact session name from assignment metadata.
resources:
  - kind: overview
    source: docs/engineering/index.md
    revision: 01ddb3c934f3f56793af8703910c94498bd7b328
    read_at: null
    state: published_read_evidence_unknown
  - kind: role
    source: docs/engineering/agents/coder.md
    revision: 01ddb3c934f3f56793af8703910c94498bd7b328
    read_at: null
    state: published_read_evidence_unknown
  - kind: skill
    source: null
    revision: null
    read_at: null
    state: Resolve the applicable skill path and revision before claiming it was read.
  - kind: common
    source: docs/engineering/agents/commandments.md
    revision: 01ddb3c934f3f56793af8703910c94498bd7b328
    read_at: null
    state: published_read_evidence_unknown
authority:
  assignment: Owner-assigned Coder work on Handbook adoption.
  changes: Follow the scope and departures recorded in the plan.
  git: Requires the applicable named grant.
  pr_script: Owner-run unless a specific execution exception is granted.
  merge: Owner approval and execution required.
artifacts:
  inputs:
    - source: NobleFactor/noblefactor-engprod#558
      role: Requirements and evidence of completion.
  outputs:
    - docs/engineering/agents/context.md
    - docs/templates/agent-context.md
    - docs/engineering/review/role-context-review.md
handoff:
  destination: Owner-appointed technical reviewer and Compliance auditor.
  evidence: PR revision, checks, asset coverage and unresolved findings.
~~~

## 2. Designer assignment

For Evidence Archive design Schedule #619, resolve the related Epic and its design enabler Feature, then identify the two Task keys. Record the approved problem/scope and expected design, Architecture decisions and roadmap. The [starter skill](../../skills/start-design-schedule/SKILL.md) establishes those relationships. This example does not assert the Schedule's current contents.

The plan field for producing these Designer assets is:

~~~yaml
plan:
  state: not_applicable
  reason: Designer delivers the design, Architecture decisions and roadmap directly.
~~~

A missing Schedule or Feature is an assignment gap to resolve, not an inapplicable field. For every role, include overview, common material, role material and applicable skills in resources with their source/version evidence. Use null plus a reason for unknowns; record model changes against the affected artifacts.
