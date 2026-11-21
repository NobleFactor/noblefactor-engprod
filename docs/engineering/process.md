---
title: "Engineering process"
status: draft
created: 2026-10-28
updated: 2026-11-20
---

# Engineering process

[Up: Engineering handbook](index.md)

<a id="work-philosophy"></a>

## 1. Work philosophy

> The shape of a job changes. It always changes. The process and tooling we put in place must support the inevitable churn. We will have succeeded, when we hear from devs that the engineering systems support the work and its evolution.
>
> — David Noble

Changes to scope, design and implementation are expected. Explain the change and its consequences so the Owner can review it and the affected records stay current. Approval keeps the Owner informed and in control while allowing the work to evolve.

<a id="roles-and-responsibilities"></a>

## 2. Roles and responsibilities

| Role | RACI responsibility | Work |
| --- | --- | --- |
| Owner | Accountable | Owns the outcome and retains final decision authority |
| Reviewer | Consulted | Challenges proposals and evaluates results, progress, risks and adherence to the plan |
| Participant | Responsible | Performs the work and provides evidence of its quality and completion |
| Observer | Informed | Receives updates as a stakeholder affected by the outcome |

The engineer is the Owner. Agents can be Reviewers, Participants or Observers. Monitoring and evaluating Participants is review work. Observer assignments are optional; the Owner already receives updates through accountability.

Controllers can support the Owner as Reviewers, with design, planning or code review assigned separately. Persistent workers are Participants with schedules. These execution arrangements do not transfer the Owner's authority.

Participants exercise judgment, challenge proposals from the Owner or other agents, identify risks and propose alternatives. They develop review judgment while working; review authority is explicitly assigned.

<a id="define-the-promised-outcome"></a>

## 3. Define the promised outcome

Start with an issue describing the problem and intended result. Place it within the applicable Feature/Epic and an approved Schedule when executing scheduled work. [Work organization](work-organization.md) defines those relationships.

Before implementation, the Owner must understand the design and implementation that will result. State observable outcomes and evidence, not only activities.

<a id="prepare-and-review"></a>

## 4. Prepare and review

For implementation, follow this order: issue → issue-bound branch/worktree → committed plan → Owner review → explicit direction to implement.

A Designer begins from an Owner-approved problem and scope on a [design schedule](work-organization.md#design-schedules), then produces the [design, architecture decisions and roadmap](work-assets.md#role-deliverables) for review. Do not require an implementation plan for writing those assets. Owner review of the design and roadmap precedes planning their implementation. Git, publication and acceptance still require their applicable authority.

For implementation, prepare the [required assets](work-assets.md). Review the committed proposal, resolve the Owner's questions one at a time, explain alternatives and disagreements, and record dated approvals and their scope in the plan. Obtain the Owner's direction to begin after approval. Approval of a structure alone does not approve unspecified implementation choices.

Follow [Git authority](agent-operation.md#owner-supervised-agents-authority-and-progression) for the plan commit and subsequent commands. Planning or reviewing a proposal does not grant command authority.

<a id="5-implement-the-approved-work"></a>

<a id="implement-the-approved-work"></a>

## 5. Implement approved work

Make routine choices within the approved behavior, architecture, scope and verification commitments without seeking approval for each choice.

When a finding requires departure, pause affected work. Explain the discrepancy, alternatives, proposed change and effect on the promised result. Obtain approval and update the records before taking that departure.

Develop in worktrees; canonical clones remain read-only for development. Follow [coding standards](../standards/coding/index.md), check changes as made, correct failures and update affected plans, designs/status records and user documentation in the commit that changes their facts.

<a id="verify-and-review-results"></a>

## 6. Verify and review results

Evaluate the agreed criteria with evidence naming the revision/artifact, environment, method, time and result. Report failures and limits. Build success, tests, merge, deployment and operation on the user's actual path establish different facts.

The plan identifies required implementation, merge, deployment and verification milestones. Deployed-layer verification includes convergence, resolved installed links, authorized obsolete-artifact removal and exercise of the installed command. A scratch-copy test or dry run does not establish live behavior.

<a id="pull-request-and-integration"></a>

## 7. Pull request and integration

One worktree serves one PR and can resolve several approved issues. PR readiness requires implementation, documentation, tests and review for all included work. CI/lint must pass; the Owner visually checks code for clear, coherent implementation and style. Participants, Reviewers and the Owner agree on additional tests and report their results in the PR.

The shared limit is one active PR per worktree. Independent workers can proceed in their own worktrees. During integration, only review/CI corrections belong there. Never change another worker's worktree. Apply any [effective host override](index.md#temporary-live-entrypoint-overrides) for the affected session.

The [PR procedure](procedures/pull-request.md) defines script preparation, integration safeguards, disclosure and reporting. A prepared script does not grant permission to run it.

<a id="completion-and-progression"></a>

## 8. Completion and progression

Completion requires the agreed milestones and Owner approval, or an explicit unattended-progression grant covering the issue. An applicable implementation plan remains `active` until those milestones are met.

A PR uses closing keywords for the issues it completes. GitHub links the PR and closes those issues when the Owner merges it. A PR that only advances an issue references it without a closing keyword. If deployment or verification then fails, reopen the issue with `star github issue reopen` and record the reason.

Record post-merge results immediately on the issue, then incorporate them into the plan through a documentation-only follow-up PR. Validate documentation-only scope, formatting, metadata and links rather than repeat builds, code linting or functional tests. Keep that obligation visible until incorporated. The lightweight CI path remains separately deferred; existing checks still apply.

A completion-only follow-up records established results and creates no further delivery milestone or recursive follow-up. It still requires documentation validation, review and merge authority. Changes to behavior, scope or outcome remain substantive work.

Obtain completion approval before advancing unless an explicit grant permits unattended progression through a defined schedule portion. Other approval boundaries remain in force. Stop on a blocker, a required departure or insufficient evidence; record the state and bring the decision to the Owner.

<a id="preserve-and-clean-up"></a>

## 9. Preserve and clean up

Preserve blocked work and its state. Abandonment or deletion requires an explicit decision.

After approved merge or abandonment, promptly remove the worktree and sibling PR script and close the branch through the supported procedure. Identify lingering assets when found. Keep post-merge obligations and evidence outside a worktree before removing it; cleanup does not establish deployment or completion.
