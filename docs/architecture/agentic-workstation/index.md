---
title: "Agentic Developer Workstation — Design Set"
type: Index
status: Draft
---

# Agentic Developer Workstation

**Status: Draft for owner review.** This is an engprod system design and delivery proposal, not an approved implementation or hardware order.

Build an owned, human-directed development environment in which persistent specialist agents produce correct, tested, compliant changes with less waiting and less repair. The environment includes the human frontend, isolated execution, engineering workflow, private retrievable evidence, local inference, hardware and operation. It is not just an inference engine and need not occupy one computer.

## Read the design

| Document | Purpose |
| --- | --- |
| [System architecture and build-out](system-design.md) | Problem, evidence, requirements, four architecture/sequence/deployment diagrams, software responsibilities, hardware alternatives, failure behavior and qualification |
| [Roadmap and feature boundaries](roadmap.md) | Three peer epics, sixteen substantial feature capabilities, interface ownership, vertical delivery slices, review decisions and filing/scheduling rules |
| [Publication plan](../../plans/doc/456-workstation-design-roadmap.md) | Scope and state of this documentation-only publication |

The system design is revision 0.2 of the conversation-produced draft. The technical claims and source register are dated research inputs, not a new market survey. Exact model/runtime and hardware profiles remain subject to qualification. The roadmap is a new proposal and does not alter approved policies or live GitHub hierarchy.

## Proposed ownership

| Body of work | Tracking | Boundary |
| --- | --- | --- |
| Agent-assisted engineering | Existing [Epic #456](https://github.com/NobleFactor/noblefactor-engprod/issues/456) | Roles, host/session coordination, safe workspaces, early compliance and independent review |
| Engineering evidence archive | Existing [Epic #490](https://github.com/NobleFactor/noblefactor-engprod/issues/490) | Original evidence, PostgreSQL catalog, retrieval, checkpoints, traceability and archive recovery |
| Local inference and workstation operations | Proposed new epic; not filed | Qualified model/hardware profiles, managed serving, repeatable deployment and operational acceptance |

Reuse the eleven existing Features #457-#461 and #491-#496. Propose five additional Features: continuous compliance/snapshot-bound integration under #456, and four capabilities under the new epic. Their issue filing and native classification follow review through the supported workflow. This is not a super-epic and does not create a level above Epic in the issue data model.

## Decisions preserved

The owner retains useful persistent role sessions; documents support iterative collaboration rather than rigid handoffs. Every role follows common policy. Original evidence is retrievable before compaction and available for reasoning at any time. Inference caches are disposable; durable work and evidence are not. Additional GPUs are not justified merely by historical conversation volume.

OpenCode is the target agent host and PostgreSQL the selected evidence catalog/search platform. Agent execution, durable engineering state and model inference are separate logical responsibilities. Apple, custom and Microsoft remain candidates where their qualified workload performance fits; the OS preference is not an exclusion rule.

## Review boundary

Publication neither supersedes the approved [development process](../../guides/development-process.md) nor completes the related [engineering-document consolidation](https://github.com/NobleFactor/noblefactor-engprod/issues/420). The roadmap explicitly identifies differences requiring owner decisions, including session scope, controlled sandbox clones, continuous versus closing review, and the extent of the coordinator.

No raw session archive is included. No new epic/feature issues are created, existing issues reparented, active schedules amended, purchases placed, or runtime software changed by this documentation set.
