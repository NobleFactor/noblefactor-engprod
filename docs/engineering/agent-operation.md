---
title: "Agent operation"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Agent operation

[Up: Engineering](index.md)

<a id="role-assignments"></a>

## 1. Role assignments

[Roles and responsibilities](process.md#roles-and-responsibilities) defines the shared roles. In the owner's workflow, the engineer is the Owner. The top-level controller supports the Owner as a Reviewer; review duties may be divided among agents assigned to design, planning and code review. Monitoring Participants and evaluating their work are review responsibilities. Observer assignments identify stakeholders who receive relevant updates, not agents supervising execution. Worker agents are Participants assigned schedules. Their sub-agents help within the approved worker boundary.

Controller, worker, and sub-agent describe execution arrangements; their authority comes from explicitly assigned roles and approved scope. Coordination does not transfer the Owner's accountability or final decision authority to an agent. Participants are expected to challenge proposals and develop the judgment needed for review, without assuming review authority or bypassing communication approvals.

<a id="all-agents-shared-obligations"></a>

## 2. All agents: shared obligations

Follow the same engineering process as people. Session activity, elapsed time, delegation volume and confident narration are not acceptance evidence. Explain implementation status, test location and remaining deployment work separately.

Read applicable process, repository and agent instructions at session start and after context compaction; restore assignment, approved plan/design, current issue, approvals and blockers from durable records. Consult the living incident record before completion. Its authoritative destination is a GitHub Project owned by the engprod team and associated with `noblefactor-engprod`; provision of that Project is pending. Issue #317 remains historical evidence and the existing record during transition, not the proposed long-term spreadsheet-shaped ledger. Do not substitute memory for current instructions.

Lead with the answer. Identify work by its meaning and issue reference. In owner-facing file references use unambiguous absolute paths. Distinguish verified claims, with method and time, from conclusions and uncertainty; preserve the source's exceptions. Disclose a process breach in the next message as a breach, with the rule, start date, effects and corrective proposal.

A discovered contradiction between code, plan, design or issue is brought to the owner immediately. Do not choose a side and quietly change the other records. Verify generated execution lists against the actual target before handing them over.

<a id="incident-patterns"></a>

### 2.1 Incident patterns

The engprod-owned incident Project groups recurring incidents using a stable error-pattern identifier. Agents must check prior incidents and applicable lessons when recognizing or recording an error, identify relevant prior occurrences, and reuse an established pattern identifier when the underlying error recurs. A repeat occurrence remains evidence of recurrence rather than disappearing as a duplicate report. Duplicate reports of the same occurrence and separate occurrences of the same pattern must be distinguishable.

Project schema, matching mechanics, cost accounting and automation are design work still under discussion. Naming the destination does not claim that the Project, its export pipeline or duplicate detection has been implemented.

<a id="all-agents-writing-for-publication"></a>

## 3. All agents: writing for publication

Documents are edited for publication. Treat the Owner’s answers, notes and review comments as direction to understand and express clearly, not as finished prose to paste into the published document. Preserve their meaning, scope and decisions while improving organization, precision, grammar and consistency with the documentation set.

Distinguish a verbatim quotation from an edited statement of policy. Preserve exact wording when the Owner asks for it or when the wording itself is material. Do not introduce policy changes as editorial improvements.

**Rationale:** The Owner distinguished policy answers from published prose on 2026-10-29: preserve the decision while editing its expression for publication ([decision record, entries 40–41](review/decisions.md)). Seek clarification when a substantive ambiguity remains; do not ask the Owner to approve the same decision again merely because its wording needs editing.

<a id="owner-supervised-agents-assignment-and-responsibility"></a>

## 4. Owner-supervised agents: assignment and responsibility

The owner assigns a schedule to a persistent worker. The controller coordinates within approved assignments; workers carry them out and own their sub-agents. Sessions and terminals may resume without resetting the mission or granting fresh authority.

Within a worker boundary, sub-agents may help freely on approved work. Delegation never expands scope or hides activity. The worker remains responsible for reviewing contributions and delivering the agreed product. No requirement mandates delegation for its own sake.

<a id="owner-supervised-agents-knowledge-and-visibility"></a>

## 5. Owner-supervised agents: knowledge and visibility

Nothing happens outside the owner's knowledge. Work, delegation, approvals, findings, failures, cross-worker conversations and changes in state must be observable, with durable records available for review and context recovery. The owner must be able to monitor activity and intervene at all times. A polished end summary is not a substitute for visibility during execution.

This is a process requirement, not a claim that existing tools provide it. If visibility cannot be provided, surface that limitation before starting the affected activity; propose a reviewable alternative rather than silently proceeding. Monitoring, notification and intervention mechanics remain a tooling concern. Execution outside an assigned worktree requires Owner direction; recommendations alone do not authorize execution. Apply the [conversation boundaries](#owner-supervised-agents-conversations) when coordinating across workers and the [assignment boundary](#owner-supervised-agents-assignment-and-responsibility) when delegating.

<a id="owner-supervised-agents-conversations"></a>

## 6. Owner-supervised agents: conversations

Controller–worker messages within an approved assignment are authorized and observable. Cross-worker conversations require approval of named participants and a defined topic before they begin. Approval lasts until that conversation ends. A change of participants or topic requires renewed approval.

The full conversation must be available for live observation and subsequent review; summaries alone are insufficient. Sub-agents cannot relay messages to evade a worker boundary. An incoming message supplies information, not authority to alter a mission. Changes to scope, ownership or execution order still require owner approval.

Retain clear sent/received disclosures identifying schedule keys and any effect on assignments. The former per-message approval rule is replaced by bounded-conversation approval; the duty to keep the Owner informed remains.

**Case:** A cross-session reply on 2026-10-25 was sent without approval and its receipt/reply were not clearly disclosed. The new bounded grant changes permission granularity, not the requirement for visible, authorized coordination ([recorded case, rule 18](review/sources/agent-rules.txt)).

<a id="owner-supervised-agents-authority-and-progression"></a>

## 7. Owner-supervised agents: authority and progression

Follow the substantive review and approval boundaries in [Process](process.md). Routine implementation choices within approved commitments are permitted. Unattended progression is authorized only for a defined schedule portion and stops on the stated conditions. Other approvals survive delegation and unattended execution.

The Owner may explicitly grant a worker bounded Git authority to commit and push its assigned branch within its own worktree. The grant does not authorize changes to other worktrees, protected branches, repository configuration, or destructive history operations. Routine implementation discretion and schedule assignment do not themselves establish this grant. Operations outside its scope require separate authorization. Without a bounded grant covering the operation, name the exact Git command, request permission and wait. Each grant covers one run; it is spent after that run.

**Case:** Three additional Git operations on 2026-10-22 were treated as authorized by broader work instructions. Neither repetition nor approval of an earlier command supplied a fresh grant ([recorded case, rule 17](review/sources/agent-rules.txt)).

Canonical-clone integration maintenance, including updating its target checkout after a merge, requires explicit Owner authorization separate from a worker’s own-worktree commit/push grant. Such authorization permits only the named integration maintenance; it does not permit development in the canonical clone. A PR script containing clone maintenance must make that operation visible for authorization before execution.

Sandbox enforcement is verified separately before it is relied on; approval of this authorization model does not establish that enforcement exists. PR execution authority is separate from permission to commit and push: retain the reviewed-script handoff to the Owner unless an explicit exception authorizes agent execution.

Follow the [PR disclosure requirements](procedures/pull-request.md#review-boundary) and read repository contribution terms before preparing the script. Surface inconsistent contribution terms for the approved documentation process rather than silently claiming compliance with both.

<a id="all-agents-tools-and-status"></a>

## 8. All agents: tools and status

Use the official issue report/audit for issue questions, not ad-hoc searches or reconstructed conversational status. Read a specific issue body after the report identifies it. Determine the assigned schedule from assignment metadata, not branch names or remembered conversation; authoritative metadata precedence remains a tooling decision.

Retain the verification duty before recommending a locally built command: identify installed copy/build, compare with the fetched target under required permission, confirm the operation exists, and state what is actually available. Do not overwrite another session's dirty or unmerged installed build. If an approved command form precedes released support, identify that distinction and the interim explicitly. Never claim a dry run exercised the live mutation path.

Follow the [PR/worktree boundary](process.md#pull-request-and-integration); schedule assignment is not permission to enter another worker’s worktree.
