---
title: "Engineering documentation"
status: draft
created: 2026-10-28
updated: 2026-10-29
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
