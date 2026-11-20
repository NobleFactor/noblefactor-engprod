---
title: "Engineering documentation"
status: draft
created: 2026-10-28
updated: 2026-11-18
---

# Engineering documentation

[Up: Documentation](../index.md)

<a id="purpose-and-authority"></a>

## 1. Purpose and authority

The authoritative home of organization-wide engineering process, standards and templates is `noblefactor-engprod`. Repository instructions link to shared requirements and state local requirements or approved exceptions. Each shared requirement has one authoritative home.

This draft reorganizes existing requirements and incorporates the owner's recorded decisions. The original eleven questions are resolved in the [decision review](review/open-decisions.md). Remaining reconciliation findings and substantive questions are tracked in the [conflict register](review/conflicts.md). Publication and cutover from existing documents require review; copying a requirement does not resolve a conflict.

<a id="applicability"></a>

## 2. Applicability

- **Everyone:** engineers and agents performing engineering work.
- **All agents:** automated participants, including controllers, workers and sub-agents.
- **Owner-supervised agents:** agents working within the owner's personal workflow. The owner is the person approving missions, outcomes and departures.

Shared process and standards apply to everyone unless a section declares a narrower audience. Agent operation labels its additional duties. A repository variation names the affected requirement, its scope, rationale and approval. It does not silently weaken a shared requirement.

Personal repositories follow the shared workflow and asset requirements by default. The Owner may explicitly direct an exception, recorded with the affected requirement and scope. Their [signing exemption](release-and-recovery.md#versioning-signing-and-publication) does not imply exemption from the rest of the process.

<a id="roles"></a>

## 3. Roles

See [Roles and responsibilities](process.md#roles-and-responsibilities) for the authoritative RACI definitions and expectations.

<a id="reading-path-and-ownership"></a>

## 4. Reading path and ownership

| Document                                                | Owns                                                     |
| ------------------------------------------------------- | -------------------------------------------------------- |
| [Agent entry points](agents/commandments.md) | Common commandments and five specialist roles |
| [Process](process.md)                                   | Workflow transitions and approvals                       |
| [Work organization](work-organization.md)               | Issues, schedules, scope, ordering and dependencies      |
| [Work assets](work-assets.md)                           | Required records, locations, relationships and lifecycle |
| [Agent operation](agent-operation.md)                   | Agent-specific authority, visibility and coordination    |
| [Release and recovery](release-and-recovery.md)         | Additional release and recovery requirements             |
| [Documentation standard](../standards/documentation.md) | Document form, metadata and maintenance                  |
| [Coding standards](../standards/coding/index.md)        | Shared and language-specific code requirements           |
| [Procedures](procedures/index.md)                       | Mechanics for satisfying requirements                    |
| [Templates](../templates/index.md)                      | Structures for recording required information            |

The process says when a step may occur; standards say what must be true; procedures say how to perform it. Templates introduce no policy. Existing incidents remain rationale and regression examples.

Unresolved scope questions do not grant exceptions. Surface them to the owner before affected work. Historical source material is evidence of previous requirements, not permission to choose between conflicting instructions.

<a id="temporary-live-entrypoint-overrides"></a>

## 5. Temporary live-entrypoint overrides

The Owner approved this transition on 2026-11-15. Handbook consolidation (#420) reconciles and publishes the shared requirements, with the temporary overrides below. [Claude consumption (#562)](https://github.com/NobleFactor/noblefactor-engprod/issues/562) and [Codex consumption (#563)](https://github.com/NobleFactor/noblefactor-engprod/issues/563) own migration and qualification of the live host entry documents. Publishing the handbook does not grant new authority to a running session.

At inspection on 2026-11-15, `/Users/david-noble/.claude/CLAUDE.md` and `/Users/david-noble/.Codex/AGENTS.md` both resolved to `/Users/david-noble/.local/share/devlore/writ/repos/personal/Home/common/.claude/CLAUDE.md`. That personal-layer source still contains these explicit instructions:

| Topic | Shared handbook policy | Temporary override in existing live entrypoints |
| --- | --- | --- |
| PR concurrency | [One active PR per worktree](process.md#pull-request-and-integration), allowing independent work in separate worktrees | Existing entrypoints permit one PR in flight for a session and restrict that session's other repository writes during delivery. Other workers' PRs do not block the session; the Owner coordinates their work. Sessions retain this restriction until their approved entrypoint cutover. |

[PR disclosure](procedures/pull-request.md#review-boundary) is permanent policy and applies to sessions using retained personal instructions. Assistance disclosure is not a temporary override.

On 2026-11-16, the Owner withdrew mandatory agent-authored breach reports and breach-cost estimates in favor of [compliance auditing](agent-operation.md#compliance-auditing). That direction supersedes the older reporting instructions immediately, including retained personal instructions that still repeat them. The host tasks carry the file migration; their delivery is not a condition for honoring the Owner's withdrawal.

These are scoped, temporary Owner-directed overrides for the affected personal entrypoints. The shared policies have already been decided. Record any additional live-instruction conflict with the Owner before choosing a definition. Policy approval, an entrypoint edit and successful loading by a session are separate facts.

The host tasks must coordinate changes to their shared source through the personal repository's issue, plan and PR process, replace embedded shared policy with references to authoritative resources, and verify the installed paths and effective instructions. Remove an override only after its host cutover is delivered and verified, or the Owner explicitly disposes of it. Keep the other host's outstanding obligation visible. This observed shared source path is evidence for this transition, rather than a permanent discovery convention.
