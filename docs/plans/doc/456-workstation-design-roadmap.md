---
title: "Publish the agentic developer workstation draft and delivery roadmap"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/456
status: active
created: 2026-11-11
updated: 2026-11-11
---

# Plan: Publish the agentic developer workstation draft and delivery roadmap

## Summary

Bring the owner's conversation-produced design into noblefactor-engprod as an RFC marked Draft. Add a reviewable roadmap organized around substantial deliverable features and existing epics, rather than a new hierarchy duplicating work already filed. This plan covers documentation publication only, not implementation of the workstation or completion of Epic #456.

The owner requested: "We must get this into noblefactor-engprod as a draft design document. It is a big epic that needs a roadmap and big chunky feature set. We may need more than one epic."

## Goals

1. Preserve the complete system design, including evidence boundaries, diagrams, software responsibilities, hardware alternatives, and acceptance criteria.
2. Reuse Epic #456 for agent-assisted engineering and Epic #490 for evidence. Propose a separate local-inference and workstation-operations epic where ownership is missing.
3. Describe feature-level deliverables, acceptance evidence, interfaces, dependencies, and incremental milestones. Keep small implementation tasks out of the initial decomposition.
4. Publish an unmerged draft pull request. Do not approve the architecture, select hardware, modify existing schedules, or create another set of unclassified issue records.

## Current State

| Component | State | Notes |
| --- | --- | --- |
| System design | On the documentation branch as RFC / Draft, revision 0.2 | Original fourteen sections and four diagrams retained; publication/navigation qualifications added |
| Agent-assisted engineering | Epic #456; Features #457-#461 | Existing ownership reused; proposed scope additions require review |
| Engineering evidence archive | Epic #490; Features #491-#496 | Canonical feature set; #497-#502 were closed as duplicates |
| Integrated roadmap | Draft on the documentation branch | Three peer epics; eleven existing and five proposed features |
| Native issue metadata support in the current connector | Incomplete | No new unclassified epic/feature issues filed; approved additions must use supported tooling |

## Requirements

- The design, roadmap, and navigation remain explicitly Draft.
- Preserve the distinction between owner requirements, supported capabilities, assumptions, and proposals.
- The roadmap is a view across peer epics, not a new epic above other epics and not a committed schedule.
- Reuse #456 and #490. No reparenting, renaming, scope amendment, or scheduling occurs merely because the roadmap proposes it.
- Preserve persistent role sessions and the iterative development method. Retain the private archive's pre-compaction and anytime-reasoning purpose.
- The source's hardware and model claims remain dated research inputs requiring qualification; this publication is not a refreshed market survey or purchase approval.
- No raw transcripts, credentials, private source artifacts, or infrastructure secrets are added.
- Existing approved guides are not rewritten by this change. Any proposed differences are identified for owner review.

## Implementation Phases

### Phase 1: Read and preserve

- [x] Read the supplied complete Markdown design.
- [x] Read existing Epic #456 and its feature scope, Epic #490, repository process guidance, and the plan template.
- [x] Check for an existing workstation design or issue before creating another.
- [x] Open a dedicated documentation branch from develop, leaving existing work and schedules untouched.

### Phase 2: Publish the draft set

- [x] Add the system design under `docs/architecture/agentic-workstation/`.
- [x] Add a roadmap with existing/proposed feature identities, substantial outcomes, acceptance evidence, and dependencies.
- [x] Add a navigation index and explicit decision boundaries.
- [x] Read back the published design and roadmap; check source preservation, frontmatter, anchors and changed-file scope within the limits recorded below.

### Phase 3: Review and adoption

Open a draft pull request after the documentation commits, linked to #456 and #490 without closing either epic. GitHub's pull-request record supplies its actual creation status and URL; no success is inferred before the operation is confirmed.

- [ ] Owner reviews the proposed epic boundaries, additional features, and policy differences.
- [ ] File approved new work through the supported issue-filing path, verifying native type, Area, parent, and Triage placement.
- [ ] Owner separately authorizes merge/adoption and any schedule commitments.

## Validation record

GitHub comparison against develop reported exactly four added Markdown files and no edits to existing files. The system design was reconstructed locally from the original conversation artifact using the explicit publication changes; its computed Git blob SHA matched the published blob `bab00394b6b1970ef10e256cc68e6c088958a5bd`. This verifies preservation apart from those changes, not the truth of each technical claim.

Programmatic checks passed for the system design's RFC/Draft frontmatter, fourteen numbered sections, four Mermaid source blocks, balanced code fences, twenty-nine defined footnotes, table-of-contents anchors, and local links resolving to the recorded repository file scope. The roadmap and navigation were read/reviewed as Markdown. The roadmap maps three peer epics and sixteen features: eleven existing and five proposed.

Full repository CI, codespell, rendered Mermaid diagrams, and external-link availability were not tested in this session. The local environment could not download repository files directly; repository reads/writes and scope verification used the GitHub connector. No runtime or hardware benchmark was run. These limitations remain visible in the draft pull request.

## Migration Path

Publication does not replace the current development environment or change approved process. The design and roadmap become reviewable inputs. After review, feature scope is reconciled with existing issues, approved new work is filed, and a bounded first schedule is committed through the normal owner-controlled process. Earlier conversation artifacts remain available as source material.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/456-workstation-design-roadmap.md` | Create | Publication scope, progress, and review boundary |
| `docs/architecture/agentic-workstation/index.md` | Create | Entry point and status |
| `docs/architecture/agentic-workstation/system-design.md` | Create | Complete system design |
| `docs/architecture/agentic-workstation/roadmap.md` | Create | Peer-epic decomposition and incremental delivery |

## Related Documents

- [System design](../../architecture/agentic-workstation/system-design.md)
- [Roadmap](../../architecture/agentic-workstation/roadmap.md)
- [Documentation standards](../../documentation-standards.md)
- [Development process](../../guides/development-process.md)
- [Epic #456](https://github.com/NobleFactor/noblefactor-engprod/issues/456)
- [Epic #490](https://github.com/NobleFactor/noblefactor-engprod/issues/490)
- [Task #420](https://github.com/NobleFactor/noblefactor-engprod/issues/420): related engineering-document consolidation, not replaced by this publication

## Open Questions

- Which proposed feature additions should be accepted under #456 rather than implemented as tasks under its existing features?
- Should local inference and workstation operations remain one new epic as proposed, or split only when deployment/ownership proves the need?
- What acceptance thresholds and hardware configuration will the owner approve after qualification?

These are design-review questions. They do not block preserving and publishing the draft.
