---
title: "Engineering process"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Engineering process

[Up: Engineering](index.md)

<a id="work-philosophy"></a>

## 1. Work philosophy

> The shape of a job changes. It always changes. The process and tooling we put in place must support the inevitable churn. We will have succeeded, when we hear from devs that the engineering systems support the work and its evolution.
>
> — David Noble

Changes to scope, design and implementation are expected. Make the proposed change and its consequences easy to understand, review and carry through the affected records. Approval keeps the owner informed and in control; it must not become a reason to conceal discoveries or resist necessary change.

<a id="roles-and-responsibilities"></a>

## 2. Roles and responsibilities

This engineering workflow uses RACI responsibilities under these names:

| Role            | RACI equivalent | Responsibility                                                                             |
| --------------- | --------------- | ------------------------------------------------------------------------------------------ |
| **Owner**       | Accountable     | Owns the outcome and has final decision authority.                                         |
| **Reviewer**    | Consulted       | Challenges proposals, evaluates results, and advises the Owner.                            |
| **Participant** | Responsible     | Performs the work and provides evidence of its quality and completion.                     |
| **Observer** | Informed | Receives relevant updates as a stakeholder affected by the outcome. |

The engineer is the Owner. Agents serve as Observers, Reviewers, or Participants.

Observers are stakeholders who need to be kept informed but are neither performing nor reviewing the work in that role. An agent monitoring Participants and evaluating their work serves as a Reviewer, not an Observer. A work item need not have a separately assigned Observer. The Owner receives updates as the accountable person and does not need a second role to be kept informed.

In the proposed arrangement, the agents at the top support the Owner as Reviewers. Reviewing responsibilities include evaluating Participants’ progress, evidence, risks and adherence to the approved plan, and may be divided among separate Reviewers for design, planning and code. The worker agents are Participants, each assigned a schedule defining its mission.

Participants are expected to exercise engineering judgment and speak their minds. They should question assumptions, identify risks, propose alternatives, and challenge designs, plans, and code—including proposals from the Owner or Reviewers. Their responsibility is to produce high-quality outcomes, not merely execute instructions or create the appearance of progress.

Participants should develop and demonstrate the judgment needed to serve as Reviewers. Review authority is entrusted explicitly; it is not assumed. The Owner retains accountability and final decision authority.

<a id="define-the-promised-outcome"></a>

## 3. Define the promised outcome

Work begins with an issue describing the problem and intended result. Place it within the applicable feature and epic, and within an approved schedule when executing scheduled work. Consult [Work organization](work-organization.md) for definitions, commitments and discoveries.

The owner must be able to understand the design and implementation they will have at the end before implementation starts. A list of activities alone is insufficient.

<a id="prepare-and-review"></a>

## 4. Prepare and review

The sequence is issue → issue-bound branch and worktree → committed plan → Owner review → explicit direction to start implementation. The plan and design assessment must show the behavior, architecture, implementation and verification the Owner will have at the end.

Prepare the [required assets](work-assets.md). Review the committed proposal with the Owner, resolving its questions one at a time. Challenge assumptions, explain alternatives and disagreements, and record the Owner's dated decisions in the plan. Agreement is not a substitute for reasoning. Once the proposal is understood and approved, ask whether to start implementation and wait for the Owner's direction. Approval of a document structure alone does not approve every implementation choice.

Follow [Git authority](agent-operation.md#owner-supervised-agents-authority-and-progression) for the plan commit and later commands; preparing a proposal does not grant command authority.

**Case:** On 2026-09-09, an agent changed design, code and documentation and then revised the plan to match. The review now precedes implementation rather than ratifying a completed change ([recorded case, rule 10](review/sources/agent-rules.txt)).

<a id="implement-the-approved-work"></a>

## 5. Implement the approved work

Implementation starts only after approval of the plan and applicable design changes. Make routine choices within approved behavior, architecture, scope and verification commitments without requesting approval for each choice.

If a finding calls for departure, pause affected work. Explain the discrepancy, proposed change, alternatives and effect on the promised outcome. Obtain owner approval before proceeding with that departure. Update the approved records; do not rewrite them after the fact to make an unauthorized implementation appear planned.

All development occurs in worktrees. Canonical clones are read-only for development. Follow [Coding standards](../standards/coding/index.md). Check changes as made, correct failures, and update affected plans, design/status documents and user documentation in the commit that changes what they describe.

<a id="verify-and-review-results"></a>

## 6. Verify and review results

Evaluate the approved acceptance criteria with evidence identifying the revision or artifact, environment, method, time and result. Report failures and limitations. Build success, tests, merge, deployment and operation on the user's real path establish different things.

Record implementation, merge, deployment and verification separately. The plan specifies required milestones. For deployed-layer changes, verification includes convergence, resolving deployed links, removing authorized obsolete artifacts and exercising the actual deployed command.

**Case:** In personal#181, a scratch-copy test was reported as working while the user's installed command still rejected the option. A dry run also failed to exercise the live removal path ([recorded case, rule 11](review/sources/agent-rules.txt)).

<a id="pull-request-and-integration"></a>

## 7. Pull request and integration

A worktree serves one PR and may cover multiple approved issues. PR readiness means all included issues are implemented, documented, tested and reviewed; it does not claim that future merge or deployment milestones have occurred. CI and lint must pass, and the Owner visually inspects code for compliance with coding standards and style. Code is not finished until it reads clearly and coherently. Participants, Reviewers and the Owner agree on additional testing, whose results are reported in the PR.

One active PR is permitted per worktree. Independent workers may proceed concurrently in their own worktrees. During integration, only review or CI corrections belong in that worktree. Workers must not modify another worker's worktree.

The [PR procedure](procedures/pull-request.md) owns the dedicated script standard, integration safeguards, disclosure and reporting mechanics. Follow it without treating a script as permission to run it.

**Case:** An agent opened another worktree during a PR's CI wait on 2026-09-08. The Owner has since clarified the boundary as one active PR per worktree, allowing independent workers while preventing unrelated work from entering a PR under integration ([original rule 7](review/sources/agent-rules.txt); [O01 resolution](review/open-decisions.md#o01--scope-of-pr-serialization)).

<a id="completion-and-progression"></a>

## 8. Completion and progression

An issue is complete only when all its agreed completion milestones are satisfied and the Owner approves completion or an explicit unattended-progression grant covers the issue. Until then, the plan remains `active` and the GitHub issue stays open. A PR with outstanding post-merge obligations references the issue without an automatic closing keyword.

Record post-merge results immediately on the issue, then incorporate them into the plan through a documentation-only follow-up PR. That follow-up validates documentation-only scope, formatting, metadata and links without rerunning builds, code linting or functional tests. Keep the documentation obligation visible until incorporated. A completion-only documentation follow-up records already established results; it does not create a new delivery milestone requiring another completion follow-up. It still requires the applicable documentation validation, review and merge authorization. If it changes behavior, scope or the approved outcome, it is substantive work rather than completion bookkeeping. This is approved policy; implementation of the lightweight CI path remains deferred and does not authorize bypassing existing checks.

Before advancing to the next issue, obtain the Owner's completion approval unless explicit unattended progression covers a defined schedule portion. Such authorization does not waive other approval requirements. Stop unattended progression on a blocker, a necessary departure from approved commitments or insufficient acceptance evidence; record state and bring the decision to the Owner.

**Case:** devlore-cli#814 merged with an unfinished plan item because closure was deferred to an event no branch commit could record. O03 now separates readiness, delivery milestones and post-merge documentation instead of marking future work complete ([original development process](review/sources/development-process.txt); [O03 resolution](review/open-decisions.md#o03--completion-closure-and-plan-status)).

<a id="preserve-and-clean-up"></a>

## 9. Preserve and clean up

Blocked work is preserved by default. Abandonment or deletion is an explicit decision. After an approved merge or abandonment, promptly remove the worktree and its sibling PR script and close the branch using the supported cleanup procedure. Identify lingering assets when noticed.

Ensure needed post-merge obligations and evidence remain recorded outside any worktree that is removed. Cleanup does not itself demonstrate deployment, verification or completion.

**Case:** A worktree was found seven months after its PR merged; a generic sibling script no longer identified the work it served. Prompt cleanup and issue-named scripts make ownership visible ([recorded case, rule 16](review/sources/agent-rules.txt)).
