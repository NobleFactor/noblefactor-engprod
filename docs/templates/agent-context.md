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

This example uses real Schedule #551, Task #558, Feature #460, and the current worktree. Existing resources reference merged baseline 55dec2b044a2972f1037996c06d887a960d6c8ef, which remains in the default branch history. That baseline is illustrative, not the current assignment revision or proof of approval. Replace it with the actual accepted source revision at handoff. Newly added resources use null revisions until a durable revision is available. Read evidence and native model and session details are deliberately unknown; neither example establishes what a running agent has loaded.

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
  revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
  approval: Consult the plan and subsequent Owner directions for current scope.
worktree:
  branch: doc/558-role-context
  source: https://github.com/NobleFactor/noblefactor-engprod/tree/doc/558-role-context
  local_path: /Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.558-role-context
  evidence: Recorded assignment location; not proof of effective host loading.
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
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
    read_at: null
    state: published_read_evidence_unknown
  - kind: role
    source: docs/engineering/agents/coder.md
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
    read_at: null
    state: published_read_evidence_unknown
  - kind: skill
    source: null
    revision: null
    read_at: null
    state: Resolve the applicable skill path and revision before claiming it was read.
  - kind: common
    source: docs/engineering/agents/commandments.md
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
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
      revision: null
      purpose: Requirements and evidence of completion.
      evidence: Capture the issue revision or content hash when preparing the actual handoff.
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
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
    read_at: null
    state: published_read_evidence_unknown
  - kind: common
    source: docs/engineering/agents/commandments.md
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
    read_at: null
    state: published_read_evidence_unknown
  - kind: role
    source: docs/engineering/agents/designer.md
    revision: 55dec2b044a2972f1037996c06d887a960d6c8ef
    read_at: null
    state: published_read_evidence_unknown
  - kind: skill
    source: skills/start-design-schedule/SKILL.md
    revision: null
    read_at: null
    state: candidate_revision_required
    evidence: New source in PR 616; record its merged revision before an actual handoff.
authority:
  assignment: Existing design Schedule and native Task relationships observed.
  changes: No assignment to this Coder to change the archive assets or tracker.
  git: Requires the actual worker's applicable grant.
  acceptance: Independent review, compliance assessment, and Owner approval.
artifacts:
  inputs:
    - source: NobleFactor/noblefactor-engprod#619
      revision: null
      purpose: Design assignment and native Task relationships.
      evidence: Observed on 2026-11-22 UTC; read receipt retained outside Git with the author verification.
  outputs:
    - docs/architecture/engineering-evidence-archive.md
    - docs/architecture/engineering-evidence-archive.decisions.md
    - docs/roadmaps/engineering-evidence-archive.md
handoff:
  destination: Planner after review and Owner acceptance.
  evidence: Accepted asset revisions, dependencies, increments, and open choices.
```

The shared worktree and artifact-input mappings have the same shape in both examples. The optional `parent.epic` field records verified ancestry; `roadmap_issue` applies to the Designer's companion Task. The handoff mapping records the receiving role and required evidence. Newly added resources are not assigned intermediate branch revisions that could disappear after squash merge and branch cleanup.

A missing Schedule or Feature is an assignment gap, not an inapplicable field. The plan field is inapplicable for producing these Designer assets. Unknown native identity and loading evidence remain unknown. This example does not qualify a running host or establish that another agent has read the resources.
