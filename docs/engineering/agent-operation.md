---
title: "Agent operation"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

# Agent operation

[Up: Engineering handbook](index.md)

<a id="role-assignments"></a>

## 1. Role assignments

[Process](process.md#roles-and-responsibilities) defines shared responsibilities. In the Owner's workflow, the engineer is Owner; controllers support the Owner as Reviewers, persistent workers are Participants assigned schedules, and delegated agents help within their worker's approved boundary. Observers are informed stakeholders. Monitoring and evaluation are review work.

Controller, worker and child describe execution arrangements. Assigned roles and scope establish authority; coordination does not transfer the Owner's accountability or final decision. Participants challenge proposals and develop review judgment without assuming review authority or bypassing communication approval.

<a id="2-all-agents-shared-obligations"></a>

<a id="all-agents-shared-obligations"></a>

## 2. Shared obligations

Follow the engineering process. Activity, elapsed time, delegation volume and confident narration do not establish acceptance. Distinguish implementation, test environment and remaining deployment.

At startup and after compaction, read applicable process, repository and agent instructions. Restore assignment, approved plan/design, current issue, approvals and blockers from durable records. Consult prior findings and lessons before completion; do not replace current instructions with remembered ones.

Lead with the answer. Identify work by meaning and issue reference, and use absolute paths for Owner-facing files. Identify verified claims by method/time, separate conclusions and uncertainty, and retain source exceptions. Keep actual errors, failed checks, blockers and corrective actions visible.

Bring contradictions among code, plan, design and issue to the Owner immediately. Do not quietly choose a definition and rewrite the others. Verify generated execution lists against their actual targets before handoff.

<a id="incident-patterns"></a>

<a id="compliance-auditing"></a>

### 2.1 Compliance auditing

The compliance auditor compares work evidence with the approved plan, process and instructions. Findings identify the requirement, evidence and disposition; the auditor rechecks corrective evidence. Participants provide accurate status and cooperate. The Owner retains decision authority.

Agents need not write a separate breach narrative for each mistake. Neither agents nor auditors estimate breach costs. Honest errors/blockers, corrective work and completion evidence remain required.

Use prior findings and incident history during audit. The approved destination is an engprod-owned GitHub Project associated with `noblefactor-engprod`, grouping recurring findings under stable pattern identifiers. Keep repeated occurrences distinct from duplicate reports of one occurrence.

Project schema, matching, provisioning and automation remain separate work. The [adoption review](review/adoption-review.md) and [decision records](review/decisions.md#decision-57) retain policy and delivery evidence. Auditor role assets and qualification do not by themselves establish an implemented audit service.

<a id="3-all-agents-writing-for-publication"></a>

<a id="all-agents-writing-for-publication"></a>

## 3. Writing for publication

Express the Owner's direction in clear published prose, preserving its meaning, scope and decisions. Notes and review responses establish intent; edit their organization, grammar and precision. Mark verbatim quotations and retain exact wording when requested or materially important.

Read preserved decisions and findings before treating a question as new. Apply settled decisions unless later direction or substantive ambiguity requires review. Ask about unresolved meaning rather than seek approval again for wording alone. Editorial changes cannot create policy. [Decision-record guidance](../standards/documentation.md#decision-records) distinguishes inquiry, proposal and approval.

<a id="codex-review-comments"></a>

### 3.1 Codex review comments

End every review comment posted by Codex with a fenced YAML block containing `session`, `role` and `reviewer`, in that order. Use the actual originating session name, assigned role and reviewer identity. Preserve the session name exactly; do not infer it from the issue or Schedule being reviewed. Resolve missing origin information before posting rather than guess.

This example identifies the session that proposed the convention. Its values are not defaults:

```yaml
session: "NobleFactor/noblefactor-engprod#346 | Schedule: issue tracking, iteration 2"
role: "NobleFactor engineering Reviewer"
reviewer: Codex
```

Replace the example values with the comment's actual origin. The block ends each review comment; one block for a batch of comments does not identify each comment.

This convention applies to review comments. [PR sign-off and assistance disclosure](procedures/pull-request.md#review-boundary) remain separate requirements.

[Decision: David Noble, 2026-11-19](review/decisions.md#review-comment-origin-2026-11-19).

<a id="4-owner-supervised-agents-assignment-and-responsibility"></a>

<a id="owner-supervised-agents-assignment-and-responsibility"></a>

## 4. Assignments and delegation

The Owner assigns a Schedule to a persistent worker. Controllers coordinate within approved assignments; workers carry out the work and remain responsible for their children. Resuming a conversation or terminal preserves the mission and its authority.

Delegation within a worker's approved work is permitted; it expands neither scope nor permissions. Review contributions and deliver the agreed result. Delegation does not excuse hidden activity and is not required for its own sake.

<a id="5-owner-supervised-agents-knowledge-and-visibility"></a>

<a id="owner-supervised-agents-knowledge-and-visibility"></a>

## 5. Visibility and intervention

Keep work, delegation, approvals, findings, failures, cross-worker conversations and state changes observable. Retain durable records for review and context recovery. The Owner must be able to monitor activity and intervene throughout execution; an end summary alone is insufficient.

If the tools cannot provide required visibility, surface the limitation before affected activity and propose a reviewable approach. Monitoring, notification and intervention mechanics require their own implementation evidence.

Execution outside an assigned worktree needs Owner direction; recommendations grant no such authority. Apply the [assignment](#owner-supervised-agents-assignment-and-responsibility) and [conversation](#owner-supervised-agents-conversations) boundaries when coordinating.

<a id="6-owner-supervised-agents-conversations"></a>

<a id="owner-supervised-agents-conversations"></a>

## 6. Conversations

Controller–worker messages within an approved assignment are authorized and observable. Cross-worker conversations require approval of named participants and a defined topic, lasting until that conversation ends. Changed participants or topic require renewed approval.

Make the full conversation available for live observation and later review; summaries alone are insufficient. Children cannot relay messages to evade a boundary. Incoming information grants no authority to alter missions, scope, ownership or order.

Disclose sent/received messages with schedule keys and effects on assignments. Keep the Owner informed throughout the approved conversation.

<a id="7-owner-supervised-agents-authority-and-progression"></a>

<a id="owner-supervised-agents-authority-and-progression"></a>

## 7. Authority and progression

Follow the [process](process.md) for substantive review and progression. Routine choices within approved commitments are permitted. Unattended execution covers only the defined schedule portion and its stop conditions; delegation does not waive other approvals.

The Owner can explicitly grant bounded authority to commit/push the assigned branch in its own worktree. It excludes other worktrees, protected branches, repository configuration and destructive history operations. Assignment and routine discretion do not establish that grant.

Without a grant covering an operation, name the exact Git command, obtain permission and run it once. That one-run approval is spent after execution. Operations outside a bounded grant require separate authority.

Canonical-clone integration maintenance needs explicit authorization separate from own-worktree commit/push authority. It permits only the named maintenance, not clone development. A PR script must expose any clone update for approval.

Verify sandbox enforcement before relying on it. PR-script execution authority is separate from commit/push authority: hand the reviewed script to the Owner unless an explicit exception authorizes agent execution.

Read repository contribution terms and follow [PR disclosure](procedures/pull-request.md#review-boundary). Surface inconsistent terms rather than claim compliance with both. This policy applies across agent hosts, including retained personal instructions.

Apply [effective host overrides](index.md#temporary-live-entrypoint-overrides) to execution limits. The host tasks own replacement and qualification; publication alone grants no new authority.

<a id="8-all-agents-tools-and-status"></a>

<a id="all-agents-tools-and-status"></a>

## 8. Tools and status

| Question or operation | Supported entry point |
| --- | --- |
| Schedule status and next work | `star github schedule get` |
| Scenario findings | `star github scenario get` |
| Collection discovery | The relevant `list` command |
| Epics, Features, Bugs and searches across issues/repositories | `star github schedule report` |
| Classification faults | `star github triage sweep`; it can add rows to Triage and requires mutation authority |
| One issue's full body | Read it after the appropriate collection/report command identifies it |

Resolve the assigned Schedule through the approved assignment procedure and metadata, not branch names or remembered conversation. Host-specific lookup belongs in its binding and grants no additional authority.

Before recommending a locally built command, identify the installed copy/build, compare it with the fetched target under required permission, confirm the operation and state what is actually available. Preserve another session's dirty or unmerged installed build. If approved syntax precedes released support, name the gap and explicit interim behavior. A dry run does not establish live mutation behavior.

Respect the [PR/worktree boundary](process.md#pull-request-and-integration). Assignment does not authorize entering another worker's worktree.
