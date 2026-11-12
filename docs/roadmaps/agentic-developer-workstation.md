---
title: "Agentic Developer Workstation — Roadmap and Epic Decomposition"
type: Roadmap
status: Draft
---

# Agentic Developer Workstation — Roadmap

**Revision:** 0.2 — PR #505 review.

**Approval boundary:** The owner approved the roadmap **as a draft** and authorized review and revision of PR #505. It remains a planning baseline for review, not an approved implementation design, spending authorization, schedule amendment, or instruction to merge. The review recommendations below are not additional owner rulings.

**Design:** [Agentic Developer Workstation RFC](../architecture/agentic-developer-workstation.md).

**Record of work:** GitHub issues, native parent relationships, and Schedule projects remain authoritative. This document coordinates several epics; it does not introduce an epic above epics or replace the issue tracker.

## 1. Goal and success criteria

Build an owned, human-directed software-engineering environment in which specialized agents can be resumed, isolated, and supervised; original evidence is available before compaction and for reasoning at any time; compliance problems are corrected early; and local open-weight inference supports the actual development workload.

The primary outcome is **time and human intervention to an accepted, tested, compliant change**. Assess engineering quality before ranking speed. Report the time spent correcting violations separately from the time spent checking for them. Token throughput, memory capacity, and retained-session count are diagnostics, not substitutes for successful engineering.

Maintain persistent role-specific sessions where useful. Compaction and replacement must preserve unfinished work through checkpoints and retrievable evidence. A schedule is a durable human coordination unit, not a requirement for permanently allocated compute.

## 2. Epic structure and ownership

Retain two existing epics and propose two additional epics. Do not duplicate or silently reparent existing work.

| Epic | Owns | Does not own |
| --- | --- | --- |
| [#456 — Agent-assisted engineering](https://github.com/NobleFactor/noblefactor-engprod/issues/456) | Role definitions and authority, agent-host driver contracts, sandbox requirements, closing-review methodology, and associated GitHub enablers | A competing workstation coordinator or a second evidence archive |
| [#490 — Engineering evidence archive](https://github.com/NobleFactor/noblefactor-engprod/issues/490) | Capture, provenance, PostgreSQL catalog, retrieval, evidence-linked checkpoint records, policy traceability, and archive protection/recovery | Live assignment scheduling, source mutations, model admission, or hardware procurement |
| **Proposed Epic A — Agentic workstation integration** | Integrating the developer experience, schedule/session continuity, protected build/test execution, development-time compliance, and whole-system operation | Redefining #456's roles or implementing a second host driver, sandbox manager, or archive |
| **Proposed Epic B — Local inference and capacity qualification** | Local serving capability, model/harness qualification, workload and energy measurement, and hardware/deployment decisions | Replacing source control, role policy, or the development methodology |

The existing archive Features **#491–#496** remain canonical. The duplicate set #497–#502 is not part of this roadmap. Existing issue relationships are not modified by this document.

DevLore's product agent subsystem remains separate. The workstation is Engineering Productivity infrastructure and a customer-zero environment. Reuse product functionality when ready; do not make a completed DevLore agent subsystem a prerequisite. Local inference here does not change the product's BYOM boundary.

### Responsibility at the interfaces

| Boundary | Single owner and integration obligation |
| --- | --- |
| Roles and common policy | #456/#460 and the existing engineering-documentation work define authority. A1 and A3 consume approved versions; they do not rewrite policy. |
| Host lifecycle | #459 and its existing driver-model work own runtime adapters. A1 integrates those adapters with schedule/assignment records. Missing adapter capabilities are addressed there rather than implemented a second time. |
| Workspace isolation | #458 and its existing sandbox work own isolation and reboot-survival requirements. A2 integrates workspace leases, snapshots, target execution, and recovery against that contract. |
| Checkpoints | #490/#494 owns the source-linked checkpoint record and evidence validation. #459 owns provider-specific session operations. A1 coordinates safe boundaries and maintains the authoritative live session binding. |
| Continuous compliance | A3 owns coherent-edit triggers, findings/correction orchestration, and the exact-snapshot commit gate. #456 supplies the applicable audit/review methodology and policy. |
| Feature closure | #456/#457 owns the independent closing review and owner sign-off. A passing pre-commit audit or CI run is not a substitute. |
| Evidence operation | #490/#496 owns archive backup, retention, and access controls. A4 composes these with workspace/control-state recovery; it does not invent another archive lifecycle. |
| Inference operation | B2 owns model admission, serving manifests, and inference health. A4 supplies common host supervision and system-level incident handling. |

**Review recommendation on A3:** retain it in Epic A. It delivers a distinct development-time capability: reducing repair work while integrating verified results into the commit path. Keep closing-review ownership in #456. An approved change to that boundary must update both this roadmap and the affected issue records.

## 3. Substantial features — Epic A: Agentic workstation integration

These are proposed issue boundaries, not filed issues. The feature deliverables should be independently demonstrable; implementation tasks come later.

| Feature | Outcome and exit evidence | Reuses / requires |
| --- | --- | --- |
| **A1. Developer control and schedule continuity** | Select and attach to a schedule from IDE/terminal; submit bounded assignments; resume useful role sessions; replace a session from a source-linked checkpoint; reconcile interrupted operations without repeating uncertain writes. Demonstrate disconnect, process restart, and compaction. | #459 host adapters; #460 roles; #494 checkpoint contract; GitHub's existing schedule record |
| **A2. Protected workspaces and cross-platform execution** | Integrate isolated clones, controlled writers, immutable audit inputs, durable unintegrated work, and identified build/test environments. Demonstrate protected main clones, interrupted builds, reboot survival, and runtime tests on required target architectures. | #458 isolation/durability contract; existing repository tooling and target devices |
| **A3. Continuous compliance and exact-snapshot commit gate** | Review coherent edit batches; prioritize violations whose repair cost grows as work spreads; track findings and corrections; combine deterministic checks with independent model review; bind final approval to the committed snapshot. Demonstrate less repair effort and no silent fail-open path. | #456/#457 methodology; approved policy; A2 snapshots; #490 evidence references |
| **A4. Engineering-service operations and recovery** | Integrate provisioning, least-privilege credentials, telemetry, quotas, supervision, backup, and whole-system restoration. Demonstrate host restart, unavailable inference, archive outage, disk pressure, and restore to another host without losing authoritative identities. | A1/A2 contracts; #496 archive recovery; B2 inference service contract |

A4's first operational slice accompanies the first deployed component. It must not wait for every A1–A3 feature to be finished. Likewise, A1 may start with a small durable checkpoint and evidence implementation rather than the complete archive UI.

## 4. Substantial features — Epic B: Local inference and capacity qualification

| Feature | Outcome and exit evidence | Reuses / requires |
| --- | --- | --- |
| **B1. Open-weight engineering model qualification** | Versioned task corpus and repeatable OpenCode evaluation, including multi-file changes, architecture-sensitive work, debugging, compliance, and recovery. Record accepted outcomes, interventions, rework, tool behavior, and baseline comparability. Identify qualified exact artifacts, not merely model families. | A thin harness using existing tools; approved task data; a minimal B2 endpoint. Full A1/A2 integration is not required to begin. |
| **B2. Local inference serving and admission** | Authenticated compatible endpoint; pinned model/runtime/parser manifest; explicit local-only profile; health, cancellation, bounded queues, priorities, cache isolation, and observability. Demonstrate a working minimal endpoint first, then qualify production serving behavior. | A candidate artifact selected for evaluation, not a completed B1 verdict; platform support verification |
| **B3. Concurrency, context, and energy benchmarking** | Cold/warm prompt handling, generation/reasoning, queueing, cache behavior, mixed coder/auditor load, end-to-end time, and wall energy. Record comparable task, quality, precision, and harness conditions, plus differences that cannot be controlled. | B1 candidate/quality evidence and B2 deployment; synthetic tests supplement actual task traces |
| **B4. Hardware and deployment qualification** | Complete quotes, executable deployment manifests, topology and electrical/thermal validation, ownership-cost scenarios, restore/rollback plan, and accepted configuration. Demonstrate the selected system against its purchase criteria and record residual risks. | B1/B3 evidence; an approved budget; bounded evaluation access or integrator test arrangements |

**Dependency correction:** B1 and B2 are iterative. A minimal B2 slice allows B1 to test candidates; B1 results guide the production B2 configuration. They must not wait for each other to be complete. B3 begins with the first useful measurements. B4 can obtain quotes early but cannot treat an unevaluated configuration as qualified.

**Scope of comparison:** assess Apple, staged custom, and Microsoft against the same engineering-quality requirement. Eliminate configurations by an explicit model/working-set constraint or measured result, not operating-system preference. Qualifying every retail SKU is not a prerequisite to selecting a documented winner for the workload.

B4 is a purchasing gate, not purchase authorization. A 200K context limit is one possible test condition, not the architecture's central requirement. Additional GPUs need a demonstrated capacity, latency, or concurrency purpose, not accumulated transcript volume.

## 5. Delivery waves and gates

Run evidence preservation and local-model feasibility early and in parallel. Do not spend months building the whole workstation before discovering whether the local model meets the central requirement. Conversely, do not delay capture of surviving evidence while waiting for a GPU purchase.

| Wave | Useful increment | Exit evidence / gate |
| --- | --- | --- |
| **0 — Preserve evidence and establish the baseline** | Inventory the current environment; preserve available source records privately; select representative tasks and policies; define model/harness manifests and acceptance metrics. Start a minimal authorized local-inference experiment. | **G0:** source coverage/gaps, private baseline fixtures, critical-policy requirements, and an explicit list of unapproved numerical targets. |
| **1 — Minimal durable workstation** | A1/A2/#459/#494 vertical slice: one schedule, useful role sessions, protected durable workspace, source-linked checkpoint, authenticated model endpoint, and basic operational telemetry. B1 continues independently. | **G1:** reconnect/reboot/compaction demonstrations; work products remain on permanent storage; the same assignment can continue without blind repetition of uncertain writes. |
| **2 — Measured compliance loop and model shortlist** | A3 early findings/correction loop and final gate; B1 quality evaluation and B3 mixed-load measurements. Bring in #456 closing review without redefining its authority. | **G2:** known violations and stale receipts are rejected; repair effort is measured; qualified and rejected model/hardware combinations are explained. |
| **3 — Select and qualify deployment** | Compare modular and consolidated placements; complete B2 operating profile, B4 quotes/topology tests, and the first whole-system restore exercise. | **G3:** owner-approved quality/latency limits, complete incremental cost, and evidence for the exact intended serving pair. Any unproven requirement is recorded, not marked passed. |
| **4 — Deploy and accept** | Install the selected system and pinned software, migrate without destroying the existing workflow, and exercise failure/rollback procedures. | **G4:** end-to-end accepted-change, security, outage, power, and recovery tests pass on the installed configuration. Procurement acceptance and engineering feature closure remain separate decisions. |
| **5 — Scale from evidence** | Add or replace hardware, tune scheduling, or qualify a new model only for a demonstrated need. | **G5:** measured constraint, comparative upgrade evidence, cost/resale assessment, and explicit approval. |

Waves are dependency-oriented increments, not deadlines or a rigid sequence of role interactions. Each Schedule project determines the actual ordered tasks. No existing schedule is amended by this draft.

Evaluation may use existing capacity, an integrator demonstration, a returnable evaluation unit, or separately authorized rental/hosted access. Do not add paid cloud usage or subscriptions implicitly. The target operating profile remains local inference without automatic billable fallback.

## 6. Cross-epic contracts

Keep the contracts small enough to implement without a new general workflow engine.

| Contract | Minimum information and invariant | Owners |
| --- | --- | --- |
| Assignment/session binding | Stable schedule, assignment and agent IDs; host/session ID; binding revision; outcome. One authoritative writable session; replacement fences or stops the previous writer. | A1 with #459 |
| Workspace/snapshot | Repository/base revision; immutable candidate identity; writer authorization; retained artifacts; durable storage location. A receipt must identify the content actually integrated. | A2 with #458 |
| Policy pack | Common and role-specific versions, effective scope, approval, deterministic content identity. Historical instructions cannot override approved policy. | #456/#460; consumed by A1/A3 |
| Evidence/checkpoint | Original locators, durable capture watermark, gaps, unfinished work, decisions/uncertainty, and policy/source versions. Acknowledgment distinguishes local durability from off-host backup. | #490/#494; integrated by A1 |
| Audit result | Request, snapshot/base, policy/check environment, coverage, pass/violation/inconclusive, source-linked findings, and supersession/override record. | A3; methodology from #456 |
| Inference deployment | Exact weights, tokenizer, template, parser, runtime, settings, hardware, authorization and capacity. Caches are restricted disposable state, not authoritative records. | B2; qualified by B1/B3 |
| Recovery manifest | Compatible database and artifact watermarks, configuration versions, protected source/checkpoints, and tested restoration procedure. | A4 with #496 and B2 |

Cross-epic references and dependency links do not replace native parent links. A Feature has one owning Epic. Tasks and Bugs belong to the Feature whose deliverable they implement or repair.

## 7. Approval and issue-filing procedure

The two new Epics and eight Features remain **proposed**, not created by this revision. Their descriptions and acceptance boundaries are now sufficiently concrete for the next filing pass.

Use the canonical filing path covered by [#338](https://github.com/NobleFactor/noblefactor-engprod/issues/338) and validate it against [#504](https://github.com/NobleFactor/noblefactor-engprod/issues/504). Check that the command is actually implemented and available; an issue describing a command is not proof that it can be run.

Filing must set native issue type, appropriate Area, parent/sub-issue relationships, required fields, and Triage: engprod placement, then verify the resulting GitHub record. The new Epics propose reusable engprod capabilities. Classify each Feature's own work: released tooling may be Product; benchmark/design/procurement-only work may be Engineering under the repository's current standard. Do not copy one Area value indiscriminately to the whole hierarchy.

Do not create partial substitutes when the available interface cannot perform these operations. An interrupted successful create must be reconciled, not retried as a new issue. Review current issues first to avoid duplicate features. Reference #456 and #490 as cooperating epics; do not nest them under a new parent Epic.

Draft approval does not approve every technical proposal. The owner still approves implementation design decisions, schedule amendments, use of paid evaluation services, and purchases through their applicable processes. This PR remains a draft and must not auto-close existing features or epics.

## 8. Remaining decisions and evidence to obtain

| Decision | Required evidence / disposition |
| --- | --- |
| Exact model, conversion and engine | B1/B2 qualified manifest; no model family is approved merely by being named in the RFC. |
| Quality and response-time thresholds | Owner agrees the representative task baseline, failure categories, sample size, and numerical limits before procurement comparison is scored. |
| First physical placement | Evaluate execution/test architectures, contention, data durability and total cost. Separate Linux execution is a proposed topology, not an Apple hardware prerequisite. |
| Private data publication | Keep raw traces and detailed consumption records private; public documents carry requirements and approved summaries only. |
| Budget interpretation and quote | Confirm all-in treatment, support, backup, network and electrical work; no purchase is implied by the planning ceiling. |
| Unsupported lifecycle operations | #459/A1 capability matrix must explicitly distinguish guaranteed, best-effort and unsupported compaction/recovery behavior. |

## 9. PR #505 review record

Revision 0.2 records the owner's draft approval without changing `status: Draft`. It resolves the A3 ownership recommendation, removes duplicate implementation ownership, starts model feasibility before the complete platform exists, makes permanent-work storage an explicit gate, distinguishes logical separation from mandatory separate machines, and keeps native issue filing and purchasing outside this revision's authority.

This roadmap is the canonical delivery/dependency outline. The companion RFC describes system contracts and links here rather than maintaining a second conflicting stage plan.
