---
title: "Plan template"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Plan template

[Up: Templates](index.md)

Copy to `docs/plans/<type>/<issue>-<name>.md` after the issue and worktree exist. Replace frontmatter title, retain working-document status, and add issue URL(s), created and updated dates. Commit the plan under applicable approval before implementation; review the committed revision with the owner. This template itself is not an approved implementation plan.

<a id="role-assignments"></a>

## 1. Role assignments

[Role assignments](../engineering/process.md#roles-and-responsibilities): Owner [name]; Participants [names and scopes]; Reviewers [names and review scopes]; Observers [stakeholders or none]. A reference to the schedule’s assignments may supply this record.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

[The behavior, implementation and design the owner will have at the end; scope exclusions.]

## Issue NNN

[Actual issue reference and problem. Repeat a number-only heading for every issue in a shared plan.]

<a id="current-state"></a>

## 3. Current state

[Relevant implementation/design, limitations and evidence.]

<a id="design-impact"></a>

## 4. Design impact

[Explicit impact determination, affected design links or reasons no change is required.]

<a id="proposed-implementation"></a>

## 5. Proposed implementation

[Components, interfaces, algorithms, data/resource changes, file locations, error behavior and relevant rollout/recovery implications.]

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

[Assumptions challenged, alternatives, tradeoffs, disagreements and decisions.]

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| [criterion] | [result] | [check and retained evidence] | [target] |

Apply the [completion and progression rules](../engineering/process.md#completion-and-progression) when recording these milestones; do not represent pending work as completed.

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | [yes/no with rationale] | [revision/review] | Pending |
| Merge | [yes/no with rationale] | [PR/commit] | Pending |
| Deployment | [yes/no with rationale] | [target/artifact] | Pending |
| Verification | [yes/no with rationale] | [acceptance evidence] | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-name"></a>

### 9.1 Phase 1: [name]

- [ ] [Deliverable and verification step.]
- [ ] [Update affected documents in the same commit.]

<a id="files-and-related-assets"></a>

## 10. Files and related assets

[Create/modify/remove paths; linked issue, designs, status companions and user docs.]

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

[Dependency, current state, owner decision, preserved work location.]

<a id="approval-and-departures"></a>

## 12. Approval and departures

[Owner approval of exact plan/design revision; proposed and approved departures with effects.]

<a id="completion-review"></a>

## 13. Completion review

[Link to results/evidence, outstanding obligations and owner decision or unattended-progression authority. Do not imply that a future merge/deployment has happened.]
