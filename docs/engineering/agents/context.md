---
title: "Shared agent context contract"
status: draft
created: 2026-11-21
updated: 2026-11-21
owner: "NobleFactor/engprod"
change_process: "../process.md#prepare-and-review"
---

# Shared agent context contract

[Up: Agent entry points](commandments.md)

This contract defines the context supplied to Designer, Planner, Coder, Reviewer, and Compliance auditor agents. The [assignment example](../../templates/agent-context.md) shows its fields. Requirements remain in their linked handbook homes; host entry documents select and reference the shared resources.

## 1. Resources every role receives

Each resource supplies part of the assignment context.

| Resource | Purpose and source |
| --- | --- |
| Overview | The [handbook](../index.md), [process](../process.md), [work organization](../work-organization.md), and [asset definitions](../work-assets.md) explain how work moves and what each role delivers |
| Common context | [Common commandments](commandments.md), mandatory repository and host instructions, and the assignment establish shared obligations |
| Role context | The assigned [Designer](designer.md), [Planner](planner.md), [Coder](coder.md), [Reviewer](reviewer.md), or [Compliance auditor](auditor.md) entry point identifies purpose, inputs, outputs, authority, handoff, and relevant reading |
| Applicable skills | Read task-specific procedures when needed, such as [Start a design schedule](../../../skills/start-design-schedule/SKILL.md); record the actual source and revision |
| Assignment | Identify the Owner, role, repository, scope, hierarchy, Schedule, current issue, applicable plan, worktree, and expected artifacts |
| Source evidence | Record resource versions and what was actually supplied or read; publication alone does not establish loading |

Keep startup reading small: common commandments, the assigned role, mandatory repository and host instructions, and assignment. Follow links for the work at hand. Role pages retain their word budgets; this contract does not require reading the entire handbook at startup.

## 2. Identity and assignment

Keep the specialist role distinct from the process's Owner, Reviewer, Participant, and Observer responsibilities. A specialist Reviewer or Compliance auditor does not acquire the Owner's accountability. Role, native host service, primary conversation, and attachment are separate identities; another view does not create another assignment or grant.

Record role, owner, repository, scope, parent, schedule, issue, plan, worktree, host, model, session, resources, authority, and artifacts. The parent records its native issue key and Type. Record the related Epic through that hierarchy. A design assignment identifies its enabler Feature and design Schedule, with design and roadmap Tasks. Its implementation plan is not applicable to producing those assets.

Host records name and observed version. Model records the actual provider, identifier, and family used for the work, including material changes. Session records native identity and the exact originating session name. A host label cannot establish model-family independence.

Use explicit unknowns with reasons and the affected claim. Distinguish a missing required assignment from an inapplicable field. Resolve missing scope, hierarchy, or authority before dependent actions. Apply [audit independence](../agent-operation.md#compliance-auditing) to actual model evidence.

## 3. Resource revisions and reading

For each resource, record `kind`, `source`, `revision`, `read_at`, and `state`. Use a commit or release identity; identify an uncommitted candidate by its content hash. Record time with a UTC offset when known. Mark unavailable resources and unread or unknown loading evidence explicitly.

At startup and after compaction, restore assignment, approvals, and progress and follow the handbook's [reading requirements](../agent-operation.md#all-agents-shared-obligations). Compare the supplied versions with the assignment's records. Report relevant changed or unavailable sources and the work they affect. Record a replacement as read only after reading it.

This contract defines the evidence to retain. Native discovery, refresh, and effective loading are qualified by the host tasks; it does not select an automatic reload mechanism.

## 4. Authority and handoffs

Reference actual grants, approved scope, and exceptions. Assignment does not itself grant Git, PR-script execution, merge, cross-worker communication, or another worker's files. Follow [authority](../agent-operation.md#owner-supervised-agents-authority-and-progression) and [coordination](../agent-operation.md#owner-supervised-agents-conversations).

Identify input artifact revisions, expected outputs, decisions, and unresolved questions at handoff. The Designer supplies design, architecture decisions, and roadmap; the Planner supplies schedules and continuing planning advice; the Coder supplies implementation and affected assets; the Reviewer and Compliance auditor supply their assessments and corrective rechecks. [Role deliverables](../work-assets.md#role-deliverables) owns these definitions.

Label proposed, accepted, implemented, merged, and verified states accurately. Keep external reviews and audits on the introducing PR. Preserve assignment, source identities, and unfinished work for resumption; the later five-agent exercise establishes native operation.
