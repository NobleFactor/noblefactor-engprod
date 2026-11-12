---
title: "Agentic Developer Workstation — Roadmap and Epic Decomposition"
type: Roadmap
status: Draft
---

# Agentic Developer Workstation — Roadmap

**Status:** Proposed for owner review. This is a coordination roadmap, not a second issue tracker or an approved procurement plan.

**Design:** [Agentic Developer Workstation RFC](../architecture/agentic-developer-workstation.md)

## Goal

Build an owned, human-directed software-engineering environment in which role-specific agents can be resumed, isolated, and supervised; evidence remains available before compaction and at any time; compliance is improved continuously and verified against the exact committed snapshot; and local open-weight inference can be qualified against real Claude/Codex development tasks.

**Success metric:** time and intervention to an accepted, tested, compliant change, with recorded correctness, recovery, and cost. Do not use model fit or token throughput as substitutes for successful engineering.

## Scope and existing ownership

Do not duplicate work already underway.

| Epic | Scope | Status |
| --- | --- | --- |
| [#456 — Agent-assisted engineering](https://github.com/NobleFactor/noblefactor-engprod/issues/456) | Closing review, agent roles, OpenCode/Claude/Codex hosts, sandbox methodology and review environment | Existing; preserve its issue hierarchy |
| [#490 — Engineering evidence archive](https://github.com/NobleFactor/noblefactor-engprod/issues/490) | PostgreSQL provenance and retrieval, private originals, pre-compaction evidence review, checkpoints, policy traceability | Existing; preserve its six Feature sub-issues |
| **Proposed Epic A — Agentic workstation integration** | Developer experience, durable schedule/session coordination, workspace execution and recovery, continuous compliance feedback, operations | New epic to file after owner reviews the boundaries |
| **Proposed Epic B — Local inference and capacity qualification** | Open-weight model quality, serving APIs, model/cache concurrency, hardware benchmarks, procurement and upgrade path | New epic to file after owner reviews the boundaries |

DevLore's **product** agent subsystem remains a separate architecture. This roadmap is for **Engineering Productivity's developer environment**. It can reuse DevLore functionality, but delivery must not depend on completion of an unrelated product subsystem. DevLore's BYOM product policy is unchanged.

## Proposed large features — Epic A: Agentic workstation integration

| Feature | Outcome / acceptance demonstration | Dependencies |
| --- | --- | --- |
| **A1. Developer control and schedule continuity** | Developer selects, attaches to, pauses, and resumes a schedule from IDE/terminal; role-specific sessions persist or restore from checkpoints without requiring a new conversation for every interaction; GitHub schedule remains authoritative | #456 agent roles/hosts; #490 checkpoint contract |
| **A2. Protected development workspaces and cross-platform execution** | Assigned worktree or isolated clone, mediated Git mutations, recoverable work products, reproducible builds/tests, and separate auditor/reviewer environments; no writes to protected main clones; reboot survival | #456 sandbox methodology |
| **A3. Continuous compliance and exact-snapshot commit gate** | Early review of coherent edit batches, prioritized high-propagation findings, correction tracking, deterministic standards where possible, independent final verdict tied to staged tree and policy version; measured repair time | #456 closing review, common/role policy |
| **A4. Engineering-service operations and recovery** | Provisioning, role credentials, observability, checkpoint restoration, host failure/restart, artifact backups, and auditable operations across the execution host and developer frontend | A1–A3; #490 protected evidence |

**Boundary:** #456 owns the closing-review methodology, role definitions, and generic sandbox/host methodology. A3 owns continuous *development-time* feedback and its integration with the final gate; it does not redefine feature sign-off.

## Proposed large features — Epic B: Local inference and capacity qualification

| Feature | Outcome / acceptance demonstration | Dependencies |
| --- | --- | --- |
| **B1. Open-weight engineering model qualification** | Fixed, representative DevLore tasks run through OpenCode with selected quantized checkpoints; measure correctness, tool calls, rework, compliance, and human intervention versus current hosted baseline | A1 representative harness |
| **B2. Local inference serving and model admission** | Authenticated OpenAI-compatible endpoint; qualified runtime/model pair; model selection, request priority, prompt cache behavior, context budgets, observability, and explicit no-paid-fallback policy | B1 shortlist |
| **B3. Concurrency, context and energy benchmarking** | Cold/warm prefill, generation, TTFT, cache hit/eviction, 1/2/4/8 request loads, coder+auditor contention, end-to-end time and wall power; Apple, custom, Microsoft measured with equivalent tasks | B1, B2 |
| **B4. Hardware procurement, deployment and expansion** | Vendor quotes and electrical/thermal/cooling requirements; validated bill of materials; compare three-year net ownership and incremental upgrade path; acceptance test before purchase sign-off | B3 evidence; approved budget |

**Boundary:** B4 is a purchasing gate, not authorization to buy. A 200K context cap is one scenario, not the primary design criterion. Do not buy additional GPUs to preserve obsolete conversation history.

## Proposed delivery waves

| Wave | Deliverable | Gate |
| --- | --- | --- |
| **0 — Baseline and architecture** | Approve RFC boundaries; capture current Claude/Codex/OpenCode task traces and hardware; identify authoritative schedule, policy, source, evidence and session state | Representative workload and threat model documented |
| **1 — Durable execution** | Integrate persistent role sessions and protected workspaces; early evidence retrieval and checkpoint continuity; deterministic checks | Reboot, compaction, and interrupted-assignment demonstrations |
| **2 — Compliance improvement** | Continuous findings, repair tracking, exact staged-snapshot verdict, independent closing review | Demonstrated reduction in correction/rework burden without weakened gates |
| **3 — Local model qualification** | Same harness on hosted baseline and selected local checkpoints; measured quality, latency and concurrency | Model/engine pair meets agreed engineering-quality threshold |
| **4 — Infrastructure acquisition and operation** | Choose Apple, staged custom, or Microsoft configuration; deploy inference and engineering services; backup, monitor, and rehearse recovery | Purchase only against measured constraints and full installed cost |
| **5 — Scale and refine** | Tune context reuse, role assignment, inference admission, hardware expansion or resale/refresh | Expand only when measured critical-path latency, model fit or concurrency requires it |

Waves may overlap when safe. The roadmap does not imply a rigid design → plan → code sequence within schedules.

## Cross-epic interfaces to resolve

1. **Schedule / agent / session identity:** stable IDs, one authoritative session per logical agent, reconciliation after interruption, independent runtime lifetimes.
2. **Policy:** common policy always applies; specialized role policy adds restrictions. Incident evidence is not current authority.
3. **Workspace:** write leases, snapshots, index/commit locking, protected Git metadata and persistent unintegrated work.
4. **Evidence:** immutable originals, provenance, read-only scoped retrieval, citations in checkpoints and findings, retention and secret screening.
5. **Inference:** model identity, exact quantization, serving version, runtime memory, cache reuse, admission, cancellation and health.
6. **Review:** deterministic checks, model findings, policy version, staged tree hash, expiry/supersession, explicit human override.
7. **Deployment:** separate logical boundaries for frontend, execution/data and inference; physical colocation is a benchmarked option.

## Proposed filing and scheduling procedure

After owner review, file **two new Epics and eight substantial Feature issues** using the canonical `star github issue file` path described in [#338](https://github.com/NobleFactor/noblefactor-engprod/issues/338). Set native issue types, Area, sub-issue parent relationships and Triage: engprod membership, then read back and verify every field. This is a direct acceptance case for [#504](https://github.com/NobleFactor/noblefactor-engprod/issues/504).

Do **not** create partly classified issues via an API that can write the Markdown body but not the native GitHub hierarchy. The tables above are **proposed issue boundaries**, not a claim that the issues have been filed.

Use existing GitHub Schedule projects for ordered work, with separate schedule iterations where needed. Do not turn the roadmap itself into a replacement for schedule ownership.

## Outstanding owner decisions

- Confirm whether Epic A's continuous compliance feature belongs under the new workstation integration epic or the existing #456 closing-review epic. Proposed default: new epic owns early feedback; #456 retains final closing-review methodology.
- Confirm the engineering-quality and responsiveness threshold that counts as competitive with hosted Claude/Codex.
- Confirm execution/data host allocation versus colocation with a custom inference workstation, including whether the MS-A2 proposal remains current.
- Confirm whether the two proposed epics are sufficiently independent for parallel schedules and where to stage the first implementation.
- Review what, if anything, from the private token-consumption record may be published in issue descriptions.
