---
title: "Engineering handbook"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

<a id="engineering-documentation"></a>

# Engineering handbook

[Up: Documentation](../index.md)

<a id="purpose-and-authority"></a>

## 1. Purpose and authority

NobleFactor's shared engineering process, standards and templates live in `noblefactor-engprod`. Each requirement has one authoritative home. Repository and host instructions link to shared requirements and state local facts or approved exceptions.

The handbook explains the current requirements. Its [decision records](review/decisions.md), [review resolutions](review/open-decisions.md) and [conflict register](review/conflicts.md) preserve approval evidence and unresolved questions. Publishing a draft does not establish adoption or resolve a conflict.

<a id="applicability"></a>

## 2. Applicability

Shared process and standards apply to people and agents unless a section limits its audience:

- Everyone: engineers and agents performing engineering work.
- All agents: controllers, workers and delegated agents.
- Owner-supervised agents: agents working within the Owner's personal workflow.

A repository variation identifies the requirement, affected scope, reason and approval. Personal repositories follow the shared workflow and asset requirements unless the Owner explicitly directs an exception. Their [signing exemption](release-and-recovery.md#versioning-signing-and-publication) applies only to signing.

<a id="3-roles"></a>

<a id="roles"></a>

## 3. Responsibilities and specialist roles

[Process](process.md#roles-and-responsibilities) defines Owner, Reviewer, Participant and Observer responsibilities. The engineer is the Owner and retains final decision authority.

Agents begin with the [common commandments](agents/commandments.md), their assigned specialist role and mandatory repository/host instructions. Follow the linked guidance and applicable skills for the task. A role identifies work and reading; it grants no additional authority.

<a id="4-reading-path-and-ownership"></a>

<a id="reading-path-and-ownership"></a>

## 4. Reading paths and document ownership

| Resource | Owns |
| --- | --- |
| [Agent entry points](agents/commandments.md) | Common context and the designer, planner, coder, reviewer and compliance-auditor entry points |
| [Process](process.md) | Work transitions, approvals and completion |
| [Work organization](work-organization.md) | Issues, schedules, scope, ordering and dependencies |
| [Work assets](work-assets.md) | Designs, plans, approvals, locations, links and lifecycle |
| [Agent operation](agent-operation.md) | Agent authority, visibility, coordination, reading and tool routing |
| [Release and recovery](release-and-recovery.md) | Additional release, signing and recovery requirements |
| [Documentation standard](../standards/documentation.md) | Writing, metadata, source layout, links and decision-record format |
| [Coding standards](../standards/coding/index.md) | Shared and language-specific code requirements |
| [Procedures](procedures/index.md) | Mechanics for satisfying the process |
| [Templates](../templates/index.md) | Structures for recording required information |
| [Review records](review/decisions.md) | Decisions, supporting evidence, supersession and adoption findings |

Process defines when work proceeds; standards define required content and conditions; procedures describe mechanics. Templates demonstrate requirements rather than create policy. Historical evidence supports review without requiring readers to reconstruct their instructions from history.

<a id="5-temporary-live-entrypoint-overrides"></a>

<a id="temporary-live-entrypoint-overrides"></a>

## 5. Effective host instructions

Owner-supervised sessions still using retained personal entrypoints permit one PR in flight for that session and restrict its other repository writes during delivery. Other workers' PRs do not block the session; the Owner coordinates them. This scoped override remains until its approved host cutover is delivered and verified or the Owner explicitly disposes of it.

The shared default remains [one active PR per worktree](process.md#pull-request-and-integration). [PR assistance disclosure](procedures/pull-request.md#review-boundary) and [compliance auditing without breach-cost estimates](agent-operation.md#compliance-auditing) are permanent policy, including for sessions using retained instructions.

[Claude consumption (#562)](https://github.com/NobleFactor/noblefactor-engprod/issues/562) and [Codex consumption (#563)](https://github.com/NobleFactor/noblefactor-engprod/issues/563) own live entrypoint migration and qualification. They coordinate any shared personal-layer source through that repository's issue, plan and PR process, replace duplicated shared policy with references, and verify installed paths and effective instructions. Keep each host's outstanding obligation visible.

Publishing the handbook, editing an entrypoint and loading it in a running session are separate milestones. Publication grants no new execution authority. Bring any additional live-instruction conflict to the Owner before choosing a definition. The [adoption records](review/adoption-review.md) and [rewrite plan](../plans/doc/581-schedule-command-consumers.md#714-core-handbook-rewrite) preserve transition evidence.

## 6. Revisions

Handbook revisions follow the [engineering process](process.md#prepare-and-review). Update the authoritative requirement and its affected references in the same change. Record approved choices using the [decision-record standard](../standards/documentation.md#decision-records); keep transition work and execution approvals in the plan.

Use stable links, preserve superseded evidence and distinguish publication from effective host loading. [Agent operation](agent-operation.md#all-agents-shared-obligations) defines startup and post-compaction reading. Apply approved scope and existing loading requirements when a document changes; do not infer new permissions from its publication.
