---
title: "Agent assignment context"
status: draft
created: 2026-11-21
updated: 2026-11-21
---

# Agent assignment context

[Up: Work templates](index.md)

Use the [shared context contract](../engineering/agents/context.md). Fill this record from the assignment, source revisions, and actual grants. It describes context; it is not executable host configuration or a grant.

## 1. Example: Handbook adoption

This example uses real Schedule #551, Task #558, Feature #460, and the current worktree. Its resource entry identifies a published baseline; read evidence and native model and session details are deliberately unknown. Replace them with observed values for an actual handoff. The example does not establish that a running agent has loaded the current candidate.

```yaml
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
```

## 2. Designer assignment

This filled example uses [Evidence Archive design Schedule #619](https://github.com/NobleFactor/noblefactor-engprod/issues/619), read through `schedule get` and native-parent queries on 2026-11-22 UTC. Epic #490 contains enabler Feature #622; both Tasks have #622 as native parent. Step 1, design Task #623, is In progress on the recorded branch. Step 2, roadmap Task #624, is Open and blocked by #623. The example records an observed assignment, not a grant for this Coder to work on it.

```yaml
role: designer
owner: David Noble
repository: NobleFactor/noblefactor-engprod
scope: Design the Engineering Evidence Archive and supply its planning roadmap.
parent:
  issue: NobleFactor/noblefactor-engprod#622
  type: Feature
  epic: NobleFactor/noblefactor-engprod#490
schedule: NobleFactor/noblefactor-engprod#619
issue: NobleFactor/noblefactor-engprod#623
roadmap_issue: NobleFactor/noblefactor-engprod#624
plan:
  state: not_applicable
  reason: Designer delivers the design, architecture decisions, and roadmap directly.
worktree:
  branch: doc/490-evidence-archive-design
  source: https://github.com/NobleFactor/noblefactor-engprod/tree/doc/490-evidence-archive-design
  local_path: null
  evidence: Branch recorded in the Schedule; no local checkout inspection.
host:
  name: null
  version: null
  evidence: Not established by the Schedule and parent-link reads.
model:
  provider: null
  identifier: null
  family: null
  evidence: No inference from the role or branch name.
session:
  id: null
  name: null
  evidence: Obtain actual native identity from the assigned Designer.
resources:
  - kind: overview
    source: docs/engineering/index.md
    revision: 2653ee5a9662bb1b86b7c24f02c7267459513770
    read_at: null
    state: published_read_evidence_unknown
  - kind: common
    source: docs/engineering/agents/commandments.md
    revision: 2653ee5a9662bb1b86b7c24f02c7267459513770
    read_at: null
    state: published_read_evidence_unknown
  - kind: role
    source: docs/engineering/agents/designer.md
    revision: 2653ee5a9662bb1b86b7c24f02c7267459513770
    read_at: null
    state: published_read_evidence_unknown
  - kind: skill
    source: skills/start-design-schedule/SKILL.md
    revision: 2653ee5a9662bb1b86b7c24f02c7267459513770
    read_at: null
    state: published_read_evidence_unknown
authority:
  assignment: Existing design Schedule and native Task relationships observed.
  changes: No assignment to this Coder to change the archive assets or tracker.
  git: Requires the actual worker's applicable grant.
  acceptance: Independent review, compliance assessment, and Owner approval.
artifacts:
  inputs:
    - source: NobleFactor/noblefactor-engprod#619
      revision: See the read receipt and published Schedule body.
  outputs:
    - docs/architecture/engineering-evidence-archive.md
    - docs/architecture/engineering-evidence-archive.decisions.md
    - docs/roadmaps/engineering-evidence-archive.md
handoff:
  destination: Planner after review and Owner acceptance.
  evidence: Accepted asset revisions, dependencies, increments, and open choices.
```

A missing Schedule or Feature is an assignment gap, not an inapplicable field. The plan field is inapplicable for producing these Designer assets. Unknown native identity and loading evidence remain unknown. This example does not qualify a running host or establish that another agent has read the resources.
