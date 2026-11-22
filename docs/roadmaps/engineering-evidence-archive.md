---
title: "Engineering evidence archive roadmap"
type: Roadmap
status: Draft
created: 2026-11-20
updated: 2026-11-21
owner: "NobleFactor/engprod"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/624
---

# Engineering evidence archive roadmap

[System design](../architecture/engineering-evidence-archive.md) · [Significant decisions](../architecture/engineering-evidence-archive.decisions.md) · [Workstation roadmap](agentic-developer-workstation.md)

This draft supplies context for the design review. Roadmap review and acceptance belong to [Task #624](https://github.com/NobleFactor/noblefactor-engprod/issues/624), which follows [the design and decision records (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) on [Schedule: evidence archive design (#619)](https://github.com/NobleFactor/noblefactor-engprod/issues/619).

<a id="outcome-and-boundary"></a>

## 1. Outcome and boundary

Before: available session records and artifacts live in native host stores or private exports, a prototype explores forwarding, and the shared archive's custody, access and recovery contracts are not qualified. After: authorized people and agents can consult exact original evidence during work and before compaction, preserve reviewed checkpoints and decisions, and recover the archive with stable citations and explicit coverage limits.

This roadmap is the Designer's input to planning. It maps intended capabilities, ownership, dependencies, acceptance evidence and open decisions. The planner decomposes implementation work and proposes committed Schedules. No task order, dates, implementation authority or completed deployment is established here. The design and its proposed architecture remain subject to independent review and Owner acceptance.

Owner: David Noble. Designer: Codex. Independent Reviewer: Antigravity in the Engineering Evidence Archive Review conversation. The existing archive Features retain their scope; workstation integration coordinates neighboring runtime/policy contracts. Implementation-repository selection and execution assignments are planning inputs, not new assignments made by this document.

<a id="capabilities-and-ownership"></a>

## 2. Capabilities and ownership

| Feature owner | Required capability | Observable completion evidence | Interface/dependency |
| --- | --- | --- | --- |
| [Capture and import (#491)](https://github.com/NobleFactor/noblefactor-engprod/issues/491) | Native-source inventory, historical import, incremental capture, exact original preservation and explicit coverage | Repeat import and append/truncate/replace captures without silent rewriting or duplication; report missing/truncated data and artifacts | Supplies bounded manifests, source generations/ranges and durable capture to catalog and checkpoint integration |
| [Catalog and provenance (#492)](https://github.com/NobleFactor/noblefactor-engprod/issues/492) | Stable identities, original/derived separation, source/revision associations, custody and reprocessing | Resolve normalized passages to exact original bytes and paired tool results; reprocess and restore without breaking citations; expose conflicting replays | Consumes capture; defines common identities/contracts used by retrieval, reviewed records and recovery |
| [Search and retrieval (#493)](https://github.com/NobleFactor/noblefactor-engprod/issues/493) | Scoped CLI/API, useful full-text/metadata search, exact reads and bounded context | Answer reviewed engineering questions with original reasons/results; enforce scope on results, counts, snippets, artifacts and expansion; show missing coverage | Requires provenance, screened representations and authorization; supplies ordinary consultation and checkpoint review |
| [Checkpoints and compaction (#494)](https://github.com/NobleFactor/noblefactor-engprod/issues/494) | Supported capture/consult/checkpoint integration and resume behavior per native host | Catch an omission using earlier evidence before compaction; resume unfinished work with citations and uncertainty; expose failed/unsupported hooks | Requires capture and retrieval; integrates with the workstation's native-identity and succession contracts |
| [Reviewed traceability (#495)](https://github.com/NobleFactor/noblefactor-engprod/issues/495) | Assertions, observations, conclusions, review/acceptance and supersession; policy rationale and safe private citations | Trace a rule and changed decision to supporting/conflicting originals and approval; keep historical instructions non-authoritative; safely reference private evidence from public documents | Requires catalog/citations and retrieval; integrates with common and role-specific policy consumption |
| [Protection and recovery (#496)](https://github.com/NobleFactor/noblefactor-engprod/issues/496) | Authorization, secrets, transport/storage protection, retention/deletion, backup, restore and operations | Cross-scope and prompt-injection fixtures pass; secret fixtures stay protected across all surfaces; independent restore preserves citations and deletion policy | Constrains every capability from first capture; supplies qualified custody/release and recovery boundaries |

Protection is a prerequisite for the first real capture/retrieval, rather than a final hardening phase. An early usable slice may cover fewer providers or a bounded data set, but must state its coverage and preserve the accepted integrity and access contracts.

<a id="dependencies-and-acceptance-gates"></a>

## 3. Dependencies and acceptance gates

These gates describe capabilities that must be demonstrated. They do not assign Schedule Step numbers or require one implementation issue per row. The planner may arrange parallel work only where the shared contracts and prerequisites permit it.

| Gate | Accepted result | Prerequisites and evidence |
| --- | --- | --- |
| G1 — Exact, durable capture | A bounded authorized source capture survives the qualified local failure and can be retried with stable identity | Approved source/provenance contract, secret/storage policy, synthetic adapter fixtures and actual filesystem/library failure tests |
| G2 — Recoverable shared custody | Replayed transfer preserves exact originals, rejects unexplained conflicts and releases local copies only under the accepted receipt policy | G1; agreed recovery objectives/failure domains; verified base/WAL/key coverage; quarantine and storage-pressure evidence |
| G3 — Useful authorized retrieval | People and agents answer representative questions and expand exact citations during ordinary work and within the documented offline subset | Provenance and screened index contracts; authorization fixtures; code/path/flag query set; latency/resource measurements |
| G4 — Continuity and reviewed reasoning | Supported pre-compaction flows preserve checked checkpoints; current rules and accepted decisions resolve to reviewed original evidence | G1/G3; per-host capability matrix; assertion/observation/review model; denied/pending succession and explicit-gap scenarios |
| G5 — Operable, recoverable archive | A new host restores the agreed recovery point with permissions, original hashes, citations, checkpoints and deletions intact | G2–G4; backup/key recovery and upgrade runbooks; fault/restore measurements; actionable capacity/lag alerts |

The [workstation's G3 evidence integration](agentic-developer-workstation.md#5-delivery-waves-and-gates) consumes the archive's usable retrieval, checkpoints and citation-preserving recovery. Minimal preservation is required with the first workstation proof; later integration cannot excuse earlier evidence loss. Workstation [D4](../architecture/agentic-developer-workstation.decisions.md#d4) and archive acceptance share the same receipt, retention and restore contract.

<a id="planner-inputs-and-owner-choices"></a>

## 4. Planner inputs and Owner choices

The recommendation is embedded SQLite host capture, an archive API, central PostgreSQL original chunks/provenance, and qualified encrypted backup tooling. The [decision records E1–E7](../architecture/engineering-evidence-archive.decisions.md) explain reasons, alternatives and costs. Each remains proposed. [Workstation W6](../architecture/agentic-developer-workstation.decisions.md#w6) removes the former engine-uniformity constraint; neither a shared engine nor a mixed-engine stack is selected by that correction.

| Input to resolve | Who decides or supplies evidence | Effect on implementation planning |
| --- | --- | --- |
| Trusted archive plaintext processing versus client-only encryption | Owner, with security review | Determines whether the recommended server-side indexing/security profile is acceptable |
| Workload, artifact growth, disconnected interval, performance envelope and maintenance budget | Owner defines needs; qualification measures candidates | Establishes capacity, database/artifact placement and realistic acceptance thresholds |
| Recovery-point/time objectives, independent backup destination and key custodian | Owner and operations qualification | Defines backup cadence, custody receipts, safe local release and recovery cost |
| Default access scope, offline grant/revocation window, retention and deletion deadlines | Owner and security/operations review | Determines access, cache, audit and backup-lifecycle behavior |
| Host/provider source and compaction capabilities, reachable local service path | Provider/workstation integration qualification | Limits the first supported slice and identifies unsupported or nonblocking-hook paths |
| Implementation repository, ownership, cross-feature contracts and review responsibilities | Owner and planner | Supplies valid issue parents, assignments, dependencies and committed Schedules |

The design's proposed latency targets and batch/chunk sizes are candidates to evaluate, not accepted service levels. The planner must retain unapproved choices as explicit gates rather than turn a recommendation into an accepted deployment by decomposing it into tasks.

<a id="qualification-and-evidence"></a>

## 5. Qualification and evidence

Use synthetic secrets, contradictory assertions, captured command results with source revisions, missing attachments, partial trailing records and malicious historical instructions. Keep public fixtures free of private transcripts and credentials. A source-format/parser version matrix identifies what was actually tested for each supported native host and export format.

The storage comparison uses the same ingest, retrieval, failure and restore workloads for local PostgreSQL, local SQLite and file-spool candidates, and for feasible central-store alternatives. Measure durable-ack latency, concurrent query behavior, CPU/memory, WAL/database growth, catch-up throughput, backup/restore time, failure handling and operator effort. Fewer services and familiar tools are useful cost inputs; neither is a substitute for the measured result.

Recovery evidence identifies exact software builds, filesystem/device, backup repository, encryption/key recovery procedure, selected recovery boundary and elapsed recovery time. It verifies exact original hashes, authorized citations and context, checkpoints, deletion enforcement, and pending-operation reconciliation on another host. A successful backup command, replica or healthy process alone does not establish this result.

The Owner reviews a representative engineering-question set for retrieval usefulness. Include a rejected alternative and its experiment, an unsupported historical assertion, conflicting and superseded decisions, a rule's source incident, and a checkpoint omission found before compaction. Report provenance accuracy, coverage and failure behavior alongside latency; stored transcript volume and smaller prompts are not the outcome.

<a id="design-production-and-handoff"></a>

## 6. Design production and handoff

Every design runs on a Schedule containing at least two separate issues: one for the design documents and their decision records, and one for the roadmap. The Planner supplies that Schedule, its ordered issues, dependencies, completion criteria and links to implementation plans, and proposes amendments as needed. This is distinct from an implementation Schedule for Features #491–#496. [Feature: Evidence archive design (#622)](https://github.com/NobleFactor/noblefactor-engprod/issues/622) is the enabler under Epic #490. The Owner created [Schedule: evidence archive design (#619)](https://github.com/NobleFactor/noblefactor-engprod/issues/619) with [the design-and-decisions Task (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) first and [the roadmap Task (#624)](https://github.com/NobleFactor/noblefactor-engprod/issues/624) second. The roadmap Task is blocked by the design Task; this draft does not establish its acceptance or completion. The live project owns the actual ordered Task rows. Feature remains the GitHub issue type; enabler describes work that prepares future capabilities. The handbook coder owns the shared terminology, templates and design-Schedule skill. The former prose phases are not a substitute. The Owner's current requirement supersedes the retained pre-schedule design route in workstation D1; the shared methodology owners must reconcile that earlier guidance rather than treat it as permission to proceed without a Schedule.

The design-production exit is a coherent wanted-system design, its reasons/alternatives and accurate decision metadata, this roadmap, updated workstation references, independently reviewed source/security/recovery contracts, and Owner-recorded acceptance or explicit unresolved choices. These documents are the Designer's deliverables to the planner. They are not an execution plan, software implementation, service deployment or proof that a numeric runtime target was achieved.

The independent Reviewer assesses the exact candidate revision against the Epic/Features and documentation standard. Verification includes frontmatter, every ordered YAML decision footer, relative paths/anchors, one-line prose, source attribution and synthetic scenario walkthroughs. New architecture recommendations need their own review; prior approval of the preparation plan does not review these new artifacts. The Owner retains acceptance and publication authority.

<a id="delivery-references"></a>

## 7. Delivery references

[Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) owns the outcome. [Workstation architecture](../architecture/agentic-developer-workstation.md#55-shared-evidence-archive-and-policy), its [decision companion](../architecture/agentic-developer-workstation.decisions.md#d4) and [roadmap](agentic-developer-workstation.md) own the neighboring runtime, continuity and integration contracts. The [existing preparation record](../plans/doc/490-evidence-archive-design.md) preserves the earlier plan review and the Owner's subsequent role/scope correction; it is not a replacement for a committed Schedule or planner-owned implementation plan.

Implementation delivery records must identify what was implemented, merged, deployed and verified separately. Closing the design-production work cannot close the archive Epic or its six implementation Features. The planner carries remaining design decisions, dependencies and acceptance evidence into the implementation commitment and records consequential changes through Owner review.
