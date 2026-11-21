---
title: "Engineering evidence archive design preparation record"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/490
status: draft
created: 2026-11-20
updated: 2026-11-21
documents:
  - kind: Archive design
    path: docs/architecture/engineering-evidence-archive.md
  - kind: Archive decisions
    path: docs/architecture/engineering-evidence-archive.decisions.md
  - kind: Archive roadmap
    path: docs/roadmaps/engineering-evidence-archive.md
  - kind: Workstation design
    path: docs/architecture/agentic-developer-workstation.md
  - kind: Workstation roadmap
    path: docs/roadmaps/agentic-developer-workstation.md
  - kind: Workstation decisions
    path: docs/architecture/agentic-developer-workstation.decisions.md
  - kind: Issue standard
    path: docs/issue-standards.md
  - kind: Filing convention
    url: https://github.com/NobleFactor/.github/blob/main/.github/ISSUE_TEMPLATE/epic.yml
    text: "Epic issue form"
  - kind: Related incident record
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/317
    text: "Evidence for reviewed policy derivation"
---

# Engineering evidence archive design preparation record

<a id="role-assignments"></a>

## 1. Role assignments

Owner: David Noble. Participant: Codex, acting as the NobleFactor engineering Designer, responsible for the design, decision records and planner handoff. Independent Reviewer: Antigravity, in the Engineering Evidence Archive Review conversation, assigned by the Owner to review this plan and its publication repair. No Observers are assigned.

The Designer's deliverables are the wanted-system design, significant decision records and a roadmap as input to planning. The Owner explicitly clarified that an execution plan is not owed by the Designer. This retained preparation record is not a gate on drafting those deliverables, an implementation commitment or a competing Schedule. [Feature: Evidence archive design (#622)](https://github.com/NobleFactor/noblefactor-engprod/issues/622) owns the design work under Epic #490; [the design and decision records (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) precede [the roadmap (#624)](https://github.com/NobleFactor/noblefactor-engprod/issues/624) on [Schedule #619](https://github.com/NobleFactor/noblefactor-engprod/issues/619). The Epic and its six implementation Features remain open.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Deliver a coherent description of the wanted engineering evidence archive, its significant decisions and alternatives, its development workflow, and a roadmap for the planner. Explain what people and agents can do, how originals remain traceable, and what capture, delivery, retrieval and recovery acknowledgments establish. Keep execution commitments in a separately approved Schedule; implementation planning belongs to the planner.

## Issue 490

[Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) requires private original evidence, incremental and repeatable capture, scoped retrieval with exact citations, source-linked checkpoints, reviewed conclusions and recoverable operations. It distinguishes assertions from captured observations and separates capture, retrieval, reasoning and acceptance. Its capture (#491), catalog (#492), retrieval (#493), checkpoint (#494), decision-trace (#495) and protection (#496) Features retain their existing ownership.

<a id="current-state"></a>

## 3. Current state

The Epic supplies requirements and proposed Feature decomposition. Workstation decisions [W5](../../architecture/agentic-developer-workstation.decisions.md#w5) and [D4](../../architecture/agentic-developer-workstation.decisions.md#d4) leave archive placement, the spool engine, original-artifact layout and recovery acknowledgments for archive review. D4 leaves the spool engine open. The Owner has withdrawn the earlier storage-uniformity preference; evaluate each store against integrity, performance, reliability, security and maintenance needs.

The plan was published at fec570d879cef390af6d1bb537eb7204423a2fb1 in [plan PR #618](https://github.com/NobleFactor/noblefactor-engprod/pull/618). All four CI checks passed for that revision. At 2026-11-21T01:50:27Z, the Epic's document table linked the plan, and its filing history and design-not-yet-opened note were restored outside the generated document section. The later preparation revision 9cb06e6552b667ec71f6cea0789612beb8acffe5 passed all four CI checks and independent re-review. This increment adds the draft design, decision companion and roadmap after the Owner's role correction. The earlier checks and reviews do not verify those new documents.

Antigravity supplied a private design draft and Go prototype outside this repository. The Designer recorded the draft's SHA-256 as abc57d5b114233726fbb9faf688726beafb895b3a2c4b608318d7818385029ec and reported unsafe purge of quarantined records, silent conflicting replays, incomplete capture watermarks and client-controlled workspace labels from source inspection and isolated in-memory SQL reproductions. The independent Reviewer has not verified those private inputs or reproductions. Treat the findings as investigation leads; supply reviewable synthetic examples, source identity and reproduction methods before relying on them as design evidence. They do not establish daemon or deployment behavior.

The current conversation contains research comparing SQLite and PostgreSQL, archive-service delivery, original storage, receipts and backup tooling. David requested documentation of the decisions and an updated design, then directed rereading the Designer entry points. The recording request authorizes preparation of the documentation; individual proposals retain their actual approval evidence.

The [initial review of fec570d](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6002444899) identified preparation-plan omissions. The [final verification of 9cb06e6](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6002690447) confirmed those findings resolved, CI passing and all seven threads resolved. Those reviews apply to preparation, not to the newly added system design and roadmap.

<a id="design-impact"></a>

## 4. Design impact

Create the archive design, its architectural decision companion and its planner roadmap under the owning repository's architecture and roadmap directories. Link them from the existing workstation design and roadmap where their archive contracts are discussed. Preserve existing requirement, decision and scenario identities. New links do not mark workstation D4 resolved or delivery complete.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

Use the current design template's arc42 coverage: problem and goals, constraints, context, strategy, components and interfaces, runtime and development workflow, deployment, shared concepts, significant decisions, quality requirements, risks and open choices, glossary, and delivery references.

Evaluate the researched candidate architecture: a SQLite capture store and outbox outside sandboxes on each workstation; an authenticated archive API; PostgreSQL for central originals, provenance and searchable representations; and encrypted off-machine backups using qualified tooling. Compare it with PostgreSQL on both workstation and archive, an append-only file spool with a PostgreSQL archive, a SQLite-only service, and separate artifact storage. Account for disconnected operation, integrity, performance, recovery, security and maintenance cost. The Owner's later request to reconsider PostgreSQL for both stores broadens the evaluation without selecting a replacement. Database placement remains independent of the client-facing archive interface; neither the spool engine nor the original-artifact store is selected by this plan.

Define original bytes separately from derived representations; stable source and evidence identities; source revisions, parser versions, active-session capture boundaries and explicit gaps; conflicting replay handling; citation resolution; checkpoints; retention and governed deletion; and recovery after source or archive loss. Preserve tool-call/result relationships and exact source ranges. Distinguish native-session restoration from evidence-based context reconstruction.

Define local-durability, archive-durability and backup-recoverability receipts separately. Specify which verified receipt level and retention policy permit local-spool release or eviction, including lost replies and storage pressure. Automatic purge must unconditionally exclude quarantined or unreconciled originals; any removal follows the separately approved deletion process. Advance a capture watermark only across durably preserved contiguous source coverage or an explicitly recorded gap, never from the highest observed turn alone. Define how receipt and watermark state survive a crash, replay and restore.

Define server-enforced caller and scope authorization for ingestion, search results, counts, snippets, exact-source reads, attachments, citation resolution and expanded context. Derive authorized associations from authenticated identity and verified bindings rather than client-supplied workspace labels. Give agents scoped API access rather than unrestricted database credentials or raw archive mounts. Specify revocation and denial behavior without cross-scope metadata disclosure.

Address secrets captured in transcripts and tool output inside the archive. Separate protected originals from secret-screened derived representations; define auditable redaction and governed deletion without retaining prohibited content in audit records. Trace the policy through ordinary retrieval, logs, exports, indexes, attachments, public outputs and the backup lifecycle. Treat retrieved historical instructions as untrusted data that cannot override current policy or grant execution authority; include prompt-injection scenarios.

Define the Feature #495 domain contracts: captured assertions versus captured observations for an identified revision; proposed conclusions versus reviewed, accepted decisions; supporting and conflicting evidence; review identity, rationale and status; and supersession without silent loss of history. Keep capture, retrieval, reasoning and acceptance distinct. Explain how a current common or role-specific policy rule resolves through reviewed rationale to original evidence without treating omission or an old instruction as permission.

Describe the initial human and agent interface and its integration with existing engineering tooling: bounded search and pagination, exact-source reads, surrounding-context expansion, checkpoints, and explicit no-result or incomplete-coverage responses. Define how public engineering documents reference private evidence without exposing raw conversations, sensitive metadata or access credentials. Keep private citation resolution subject to authorization; publication and acceptance follow the existing review process.

Record each significant proposal with reasons, actual alternatives, consequences and linked evidence in the sibling engineering-evidence-archive.decisions.md companion. End each record with the required YAML fields in order. Use proposed status, null approval and null decision time unless a source establishes acceptance. Retain known dates without inventing approval times. Keep the unanswered storage choices, archive trust boundary, workload, retention, recovery objectives, backup destination and key custody, initial interface and measured performance thresholds explicit.

Prepare a planner handoff that states observable outcomes, dependencies and Feature ownership. Present delivery gates rather than a second Schedule or a committed issue order. Include ordinary evidence consultation and pre-compaction continuity, as well as disconnected capture, reconnect, archive recovery and storage-pressure scenarios.

Use synthetic examples and public requirements in tracked documentation. Keep raw transcripts, credentials, private exports and prototype source outside this public repository.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

Copying the Antigravity draft unchanged would preserve its durability and authorization gaps and its earlier document structure. Replacing its inputs with a coherent wanted-system design allows those gaps to be resolved through review. Preserve the private input; do not overwrite it or imply that it was an approved implementation.

Using PostgreSQL for both local capture and central archive requires evaluating workstation service operation, disconnected durability and recovery alongside embedded-engine and file-spool alternatives. Do not assume that either fewer engines or an embedded engine establishes lower total maintenance cost without evidence. Keep original-artifact placement and backup destination/key custody separate from the catalog choice.

Publishing an implementation Schedule now would invent commitments before the design review and planner decomposition. The enabler Feature and design Schedule identify the current documentation work. Publishing database or encryption proposals as accepted would likewise exceed their evidence; preserve the distinction between research, proposal and Owner approval.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence and method | Environment or artifact |
| --- | --- | --- | --- |
| Coherent wanted system | The design explains users, boundaries, ownership, data, interfaces, normal actions and failure behavior | Trace requirements to design sections and walk the archive scenarios | Exact candidate documentation revision |
| Evidence integrity | Original preservation, conflicting replays, durable watermark progression, explicit gaps, distinct receipt levels and safe local release are specified; quarantined or unreconciled originals cannot be automatically purged | Walk interrupted capture, a missing turn, lost-response replay, quarantine, storage pressure, purge and citation-preserving restore scenarios | Design and decision companion |
| Reviewed traceability | Assertions, observations, proposed conclusions and accepted decisions remain distinguishable; conflicts, review status, policy rationale and supersession retain their sources | Trace a current rule and a changed conclusion to exact observations for an identified revision; verify capture, retrieval, reasoning and acceptance remain separate | Design, Feature #495 contract and roadmap |
| Honest decision records | Each record has a stable identifier, reasons, actual alternatives, consequences, evidence and valid ordered YAML metadata | Parse every footer using Ruby Psych.safe_load; compare ordered keys and allowed statuses with the standard, check list and timestamp types, unique IDs and null approval fields on unaccepted proposals; verify approval claims against their sources | Decision companion; frontmatter checks alone do not validate footers |
| Secret handling and authorization | Server-enforced caller/scope binding covers ingestion and every retrieval surface; protected originals, secret-screened representations, redaction/deletion, backups and untrusted instructions have explicit contracts | Walk synthetic secret-bearing and historical prompt-injection fixtures, forged workspace labels and cross-scope requests across content, counts, snippets, attachments, context, logs, exports, public outputs and backups | Design and security scenarios; implementation tests remain future work |
| Security meaning | Archive-host trust, plaintext-processing boundaries, backup key custody and citation disclosure are explicit; transport encryption does not imply client-only end-to-end encryption | Review access/revocation, protected-original processing, backup recovery and safe public-to-private citation scenarios | Design and open-choice register |
| Usable interface | People and agents have a defined first interface with bounded results, pagination, context expansion, exact citations and visible missing coverage | Walk a reviewed engineering question through ordinary retrieval and pre-compaction consultation, including no results, contradictory evidence and denied citation expansion | Design, interface contract and roadmap |
| Storage comparison | The decision evaluates local spool engines, original-artifact placement, recovery and maintenance costs without claiming a selected stack | Compare documented alternatives against explicit workload assumptions, failure scenarios and proposed measurement methods; retain unmeasured results as open questions | Decision companion and open-choice register |
| Useful planner handoff | The roadmap names outcomes, Feature owners, dependencies, qualification evidence and unresolved Owner choices without committing a Schedule | Compare with the existing Epic and workstation roadmap | Archive roadmap |
| Publication quality | Frontmatter, numbered sections, stable links, plain US English and one physical line per prose paragraph conform | Run make check, including .github/scripts/Test-Frontmatter.sh; separately scan for wrapped prose, resolve relative Markdown paths and explicit/heading anchors, check every ordered decision footer, and inspect rendered diagrams where supported | Exact candidate worktree; record commands, validator coverage and results |
| Issue/document consistency | The Epic, enabler Feature, two Tasks and design Schedule link the published drafts; the Epic no longer says the design is not yet opened | Run star github plan link for the retained Epic record after push; inspect refusals and dropped content. Update only the new issues' draft document rows, preserve other narrative, and read every result back | Live Epic #490, Feature #622, Tasks #623/#624, Schedule #619 and exact published documentation revision |
| Honest delivery status | No code, service deployment or production performance is claimed from this documentation change | Review the changed file set, plan milestones and result language | Candidate revision and review record |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State or result |
| --- | --- | --- | --- |
| Documentation implementation | Yes | Coherent design, decisions, roadmap and updated references at an identified revision | Pending |
| Owner review | Yes | Review of the design, unresolved choices and planner handoff, with dated decisions recorded | Pending |
| Merge and completion record | Yes | Owner-approved documentation PR, observed merge revision recorded on the served issues, and the required completion follow-up in this retained record | Pending; design acceptance and delivery remain distinct milestones |
| Service deployment | No | This plan changes documentation only | Outside this plan |
| Runtime qualification | No | Requirements are handed to implementation planning; no runtime result is claimed here | Outside this plan |
| Documentation verification | Yes | Required repository checks, decision metadata checks, link checks and source-layout review | Pending |

<a id="implementation-phases"></a>

## 9. Design deliverables and planning boundary

The Owner requires every design to run on a Planner-supplied Schedule with at least two separate issues: one for design documents and their decision records, and one for the roadmap. The former prose phases do not establish those issues or their order. The live Schedule project owns Step order, dependencies, assignments, completion criteria and progress. The Owner created [Schedule: evidence archive design (#619)](https://github.com/NobleFactor/noblefactor-engprod/issues/619). [Feature: Evidence archive design (#622)](https://github.com/NobleFactor/noblefactor-engprod/issues/622) is its enabler under Epic #490, with [design/decision records (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) first and [the roadmap (#624)](https://github.com/NobleFactor/noblefactor-engprod/issues/624) second. The roadmap Task is blocked by the design Task. This resolves the earlier parent-ownership question within the existing Epic → Feature → Task hierarchy. The Owner-run setup created and read back the native types, parents, Step order and dependency on 2026-11-21. The handbook coder owns the shared terminology, templates and design-Schedule skill. The live project remains authoritative rather than a Markdown step table.

The Designer supplies the [system design](../../architecture/engineering-evidence-archive.md), [significant decisions](../../architecture/engineering-evidence-archive.decisions.md) and [roadmap](../../roadmaps/engineering-evidence-archive.md). The design describes the wanted system; the roadmap gives the planner capabilities, dependencies, observable acceptance gates and open choices. It does not assign implementation issues or create an implementation plan.

Independent review applies to the exact design-document candidate and its requirements, references, decision metadata and approval claims. The Owner decides consequential architecture choices and acceptance. Publishing these drafts does not implement the archive or approve their database, security, performance or recovery proposals.

The Owner-run publication script updates the existing PR, refreshes the served issues' document links and replaces the obsolete Epic design-not-yet-opened note after the draft is published, preserving unrelated narrative. It marks only the current design Task In progress and links its existing branch after push. The roadmap remains Open and blocked; its draft supplies context for the design review. Merge, completion records and cleanup retain their normal authority and verification boundaries.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

All proposed repository-relative paths below are within the assigned worktree.

- Add docs/architecture/engineering-evidence-archive.md as the wanted-system draft.
- Add docs/architecture/engineering-evidence-archive.decisions.md with proposed choices and actual alternatives.
- Add docs/roadmaps/engineering-evidence-archive.md as input to the planner.
- Update docs/architecture/agentic-developer-workstation.md with the archive reference.
- Update docs/roadmaps/agentic-developer-workstation.md with the archive handoff reference.
- Update docs/architecture/agentic-developer-workstation.decisions.md to link the archive evidence from W5/D4 without changing their approval status or treating D4 as resolved.
- Maintain docs/plans/doc/490-evidence-archive-design.md with the same commits that change its facts.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

The archive Features own their respective future implementation. Existing workstation integration work supplies neighboring runtime and lifecycle contracts. Do not change another worker's worktree, Schedule, issue scope or assignments. Bring any discovered overlap to the Owner.

The current draft does not select the local spool engine; central original-artifact placement in PostgreSQL, private content-addressed files/object storage or a combination; backup destination and key custody; archive-host trust; deployment placement; initial human/agent interface; retention and deletion policy; workload/ingest volume and archive growth; recovery-point or recovery-time objectives; or numeric performance and capacity thresholds. Compare these choices against the Owner's integrity, performance, reliability, security and low-maintenance goals. Keep questions visible and obtain Owner decisions before representing them as settled requirements.

<a id="approval-and-departures"></a>

## 12. Approval and departures

David Noble assigned Codex to take over the Engineering evidence archive design, directed research into integrity, performance, reliability, security and maintenance, and requested that the findings and decisions be documented in the updated design. Source: the current Owner conversation, including the messages beginning "research this" and "document these decisions and update the design". These messages establish the requested work; this plan does not infer an approval date, approval of its committed revision or a direction to start Phase 1 from them. The independent Reviewer has not verified that conversation evidence.

On 2026-11-20, the Owner directed removal of the earlier storage-uniformity preference and explicitly clarified that Codex is the Designer and owes a design and roadmap as input to planning. That direction authorizes preparation of those design deliverables and supersedes the former preparation-plan gate on drafting them. It does not approve an unanswered architecture choice, implementation Schedule, agent Git command, PR-script execution exception or deployment.

The earlier preparation findings REV-490-01 through REV-490-05, REV-490-07 and REV-490-09 were independently verified resolved on 9cb06e6. The private-input verification gaps in REV-490-10 remain explicit in Section 3. The new design drafts need review on their own revision; no earlier preparation finding selects their storage architecture or supplies Owner acceptance.

<a id="completion-review"></a>

## 13. Completion review

Pending. Record the reviewed documentation revision, checks, Owner decisions and remaining obligations here as their facts change. After observed merge, record delivery on design Task #623, link it from Feature #622 and Epic #490, and incorporate the required evidence here through the completion-only follow-up process. Publishing the roadmap draft does not complete Task #624 or remove its dependency. The Engineering evidence archive Epic remains open; this documentation increment does not satisfy its implementation milestones.
