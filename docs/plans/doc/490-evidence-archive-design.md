---
title: "Document the engineering evidence archive architecture and decisions"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/490
status: draft
created: 2026-11-20
updated: 2026-11-20
documents:
  - kind: Workstation design
    path: docs/architecture/agentic-developer-workstation.md
  - kind: Workstation roadmap
    path: docs/roadmaps/agentic-developer-workstation.md
  - kind: Issue standard
    path: docs/issue-standards.md
  - kind: Filing convention
    url: https://github.com/NobleFactor/.github/blob/main/.github/ISSUE_TEMPLATE/epic.yml
    text: "Epic issue form"
  - kind: Related incident record
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/317
    text: "Evidence for reviewed policy derivation"
---

# Document the engineering evidence archive architecture and decisions

<a id="role-assignments"></a>

## 1. Role assignments

Owner: David Noble. Participant: Codex, acting as the NobleFactor engineering Designer, responsible for the design, decision records and planner handoff. Independent review assignments remain for the Owner to establish. No Observers are assigned.

This is design work before an implementation Schedule exists. Engineering evidence archive (#490) identifies the work, as permitted by the Designer guidance and the workstation's pre-schedule design workflow. This plan advances the Epic through documentation; it does not implement or complete the Epic or assign its Features to a Schedule.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Deliver a coherent description of the wanted engineering evidence archive, its significant decisions and alternatives, its development workflow, and a roadmap for the planner. Explain what people and agents can do, how originals remain traceable, and what capture, delivery, retrieval and recovery acknowledgments establish. Keep transition work and execution history in this plan and committed issue order in a future approved Schedule.

## Issue 490

[Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) requires private original evidence, incremental and repeatable capture, scoped retrieval with exact citations, source-linked checkpoints, reviewed conclusions and recoverable operations. Its capture, catalog, retrieval, checkpoint, decision-trace and protection Features retain their existing ownership.

<a id="current-state"></a>

## 3. Current state

The Epic supplies requirements and proposed Feature decomposition. The workstation design leaves D4, original-artifact placement and recovery acknowledgments, for the archive design. The Epic's document table still reports its plan and archive design as not yet opened at the 2026-11-20 inspection.

Antigravity supplied a private design draft and Go prototype outside this repository. The draft's SHA-256 at inspection was abc57d5b114233726fbb9faf688726beafb895b3a2c4b608318d7818385029ec. Source inspection and isolated in-memory SQL reproductions found unsafe purge of quarantined records, silent conflicting replays, incomplete capture watermarks and client-controlled workspace labels. Those experiments do not establish daemon or deployment behavior.

The current conversation contains research comparing SQLite and PostgreSQL, archive-service delivery, original storage, receipts and backup tooling. David requested documentation of the decisions and an updated design, then directed rereading the Designer entry points. The recording request authorizes preparation of the documentation; individual proposals retain their actual approval evidence.

<a id="design-impact"></a>

## 4. Design impact

Create the archive design, its architectural decision companion and its planner roadmap under the owning repository's architecture and roadmap directories. Link them from the existing workstation design and roadmap where their archive contracts are discussed. Preserve existing requirement, decision and scenario identities. New links do not mark workstation D4 resolved or delivery complete.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

Use the current design template's arc42 coverage: problem and goals, constraints, context, strategy, components and interfaces, runtime and development workflow, deployment, shared concepts, significant decisions, quality requirements, risks and open choices, glossary, and delivery references.

Describe the researched candidate architecture: a SQLite capture store and outbox outside sandboxes on each workstation; an authenticated archive API; PostgreSQL for central originals, provenance and searchable representations; and encrypted off-machine backups using qualified tooling. Explain the SQLite-only and separate-artifact-store alternatives, including their operational and recovery tradeoffs. Database placement remains independent of the client-facing archive interface.

Define original bytes separately from derived representations; stable source and evidence identities; capture coverage and explicit gaps; conflicting replay handling; local, archive and backup receipts; protection of quarantined originals; scoped access; citation resolution; checkpoints; retention and governed deletion; and recovery after source or archive loss. Distinguish native-session restoration from evidence-based context reconstruction.

Record each significant proposal with reasons, actual alternatives, consequences and linked evidence. End each record with the required YAML fields in order. Use proposed status, null approval and null decision time unless a source establishes acceptance. Retain known dates without inventing approval times. Keep the unanswered archive trust boundary, workload, retention, recovery objectives and measured performance thresholds explicit.

Prepare a planner handoff that states observable outcomes, dependencies and Feature ownership. Present delivery gates rather than a second Schedule or a committed issue order. Include ordinary evidence consultation and pre-compaction continuity, as well as disconnected capture, reconnect, archive recovery and storage-pressure scenarios.

Use synthetic examples and public requirements in tracked documentation. Keep raw transcripts, credentials, private exports and prototype source outside this public repository.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

Copying the Antigravity draft unchanged would preserve its durability and authorization gaps and its earlier document structure. Replacing its inputs with a coherent wanted-system design allows those gaps to be resolved through review. Preserve the private input; do not overwrite it or imply that it was an approved implementation.

Publishing an implementation Schedule now would invent commitments before the design review and planner decomposition. Keep the work identified by the existing Epic. Publishing database or encryption proposals as accepted would likewise exceed their evidence; preserve the distinction between research, proposal and Owner approval.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence and method | Environment or artifact |
| --- | --- | --- | --- |
| Coherent wanted system | The design explains users, boundaries, ownership, data, interfaces, normal actions and failure behavior | Trace requirements to design sections and walk the archive scenarios | Exact candidate documentation revision |
| Evidence integrity | Original preservation, conflicts, gaps, receipt meanings and release conditions are explicit | Review capture, lost-response replay, quarantine, purge and restore scenarios | Design and decision companion |
| Honest decision records | Each record has a stable identifier, reasons, actual alternatives, consequences, evidence and valid ordered YAML metadata | Parse every decision footer and check approval claims against their source | Decision companion |
| Security meaning | The archive trust question and authorization requirements are explicit; transport encryption is not represented as a settled client-only encryption decision | Review the access, plaintext-processing and backup boundaries | Design and open-choice register |
| Useful planner handoff | The roadmap names outcomes, Feature owners, dependencies, qualification evidence and unresolved Owner choices without committing a Schedule | Compare with the existing Epic and workstation roadmap | Archive roadmap |
| Publication quality | Frontmatter, numbered sections, stable links, plain US English and one physical line per prose paragraph conform | Run the repository gate and targeted documentation checks; inspect rendered diagrams where supported | Candidate worktree |
| Honest delivery status | No code, service deployment or production performance is claimed from this documentation change | Review the changed file set, plan milestones and result language | Candidate revision and review record |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State or result |
| --- | --- | --- | --- |
| Documentation implementation | Yes | Coherent design, decisions, roadmap and updated references at an identified revision | Pending |
| Owner review | Yes | Review of the design, unresolved choices and planner handoff, with dated decisions recorded | Pending |
| Merge | Yes | Owner-approved documentation PR and observed merge revision | Pending |
| Service deployment | No | This plan changes documentation only | Outside this plan |
| Runtime qualification | No | Requirements are handed to implementation planning; no runtime result is claimed here | Outside this plan |
| Documentation verification | Yes | Required repository checks, decision metadata checks, link checks and source-layout review | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

### 9.1 Phase 1: Define the intended archive

- [ ] Write the coherent design using the current template and the Epic's requirements.
- [ ] Explain normal use, pre-compaction consultation, disconnected capture, recovery and governed deletion.
- [ ] Update plan metadata and phase completion in the commit that establishes those facts.

### 9.2 Phase 2: Record decisions and prepare the handoff

- [ ] Record significant choices with alternatives, evidence and accurate approval metadata.
- [ ] Write the development workflow and planner roadmap with observable delivery gates and open choices.
- [ ] Add the created documents to this plan's documents list and update the workstation references.
- [ ] Update phase completion in the commit that completes the work.

### 9.3 Phase 3: Verify and review

- [ ] Run the repository's current required gate and the targeted documentation checks.
- [ ] Review the design with David, resolve consequential choices one at a time and record the scope of any acceptance.
- [ ] Prepare the reviewed delivery script only when requested; leave execution and merge to the Owner.
- [ ] Record actual delivery and any remaining documentation obligation without marking the Epic implemented.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

All proposed repository-relative paths below are within the assigned worktree.

- Create docs/architecture/engineering-evidence-archive.md.
- Create docs/architecture/engineering-evidence-archive/decisions.md.
- Create docs/roadmaps/engineering-evidence-archive.md.
- Update docs/architecture/agentic-developer-workstation.md with the archive reference.
- Update docs/roadmaps/agentic-developer-workstation.md with the archive handoff reference.
- Maintain docs/plans/doc/490-evidence-archive-design.md with the same commits that change its facts.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

The archive Features own their respective future implementation. Existing workstation integration work supplies neighboring runtime and lifecycle contracts. Do not change another worker's worktree, Schedule, issue scope or assignments. Bring any discovered overlap to the Owner.

The current draft does not establish expected ingest volume, archive growth, recovery-point or recovery-time objectives, archive-host trust, deployment placement or numeric acceptance thresholds. Keep those questions visible and obtain Owner decisions before representing them as settled requirements.

<a id="approval-and-departures"></a>

## 12. Approval and departures

On 2026-11-20, David Noble assigned Codex to take over the Engineering evidence archive design, directed research into integrity, performance, reliability, security and maintenance, and requested that the findings and decisions be documented in the updated design. Source: the current Owner conversation, including the messages beginning "research this" and "document these decisions and update the design".

This newly published plan is a proposal for review. No approval of this committed revision or direction to implement it has yet been recorded. No agent Git authority, PR-script execution exception, Schedule amendment, production deployment or approval of an unanswered design choice is established by this plan.

<a id="completion-review"></a>

## 13. Completion review

Pending. Record the reviewed documentation revision, checks, Owner decisions, delivery evidence and remaining obligations here. The Engineering evidence archive Epic remains open; this documentation increment does not satisfy its implementation milestones.
