---
title: "Agentic developer workstation decisions"
status: draft
created: 2026-11-19
updated: 2026-11-21
---

# Agentic developer workstation decisions

[System design](agentic-developer-workstation.md) · [Roadmap](../roadmaps/agentic-developer-workstation.md)

These records use the [shared decision format](../standards/documentation.md#decision-records). W1–W3 record explicit Owner-approved boundaries from the source plan. W6 records the Owner-approved removal of a storage constraint. The overall design remains Draft. W4/W5 are design proposals; D1–D6 remain unresolved. Metadata records approval of a choice separately from its implementation or qualification.

<a id="w1"></a>

## 1. Reach role sessions through editors

Developer devices connect to an editor backend inside SBX. A shell profile invokes the common guest-side launcher, which resolves the role binding and attaches to the native host.

Direct developer-device connections to agent hosts are outside this access contract. The editor path gives desktop and browser clients the same role entry point while keeping native endpoints private. Additional editor backends support independent connections where product limits require them.

The Owner explicitly set this access boundary on 2026-11-13, recorded in the [source plan's approval record](../plans/doc/521-workstation-design.md#owner-approval). The [host-driver boundary](agentic-developer-workstation.md#53-common-host-driver-contract) and [profile contract](agentic-developer-workstation.md#54-editor-instances-and-attachment-views) retain per-host qualification.

```yaml
id: W1
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-13'
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="w2"></a>

## 2. Let native servers manage their sessions

A selected Claude, Codex or OpenCode server can serve several assigned role sessions. Each session has a primary agent and optional delegated children. The native host owns its execution processes; the control plane owns server lifecycle and role bindings, while editors own attachment clients.

Starting a daemon for every view would tie presentation to execution and duplicate supervision. Reusing a native server keeps its internal process management with its provider. A shared-server fault can affect several roles, so stop/recovery controls must account for every assigned session.

The Owner approved showing this ownership during PR #544 review on 2026-11-13, as recorded in the [source plan](../plans/doc/521-workstation-design.md#owner-approval). [Host-driver qualification](agentic-developer-workstation.md#53-common-host-driver-contract) establishes actual capabilities for a pinned deployment.

```yaml
id: W2
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-13'
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="w3"></a>

## 3. Restore the original session before approving a successor

Routine recovery retains a role's native conversation identity. After a disaster exhausts restoration, an explicitly Owner-approved successor can become authoritative only after the original runtime and binding can no longer authorize actions.

Silently replacing a failed session would discard identity and can duplicate pending work. Restoring retained native state is the first path; evidence-based reconstruction is a separate path with explicit context gaps. Concurrent opens, lost replies and a returning old runtime must preserve one authoritative role.

The Owner approved replacement after exhausted restoration and identified accidental deletion as its driving scenario on 2026-11-13. The [source approval](../plans/doc/521-workstation-design.md#owner-approval), [recovery contract](agentic-developer-workstation.md#disaster-recovery-and-session-succession) and [S8 walkthrough](../roadmaps/agentic-developer-workstation.md#s8--disaster-recovery-after-loss-of-a-native-session) supply scope and acceptance evidence.

```yaml
id: W3
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-13'
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="w4"></a>

## 4. Keep the environment across PR and device lifetimes

Use one durable logical environment and one active SBX sandbox for each committed schedule. Give PR worktrees, assignments, editor connections and terminal views independent shorter lifetimes.

The proposal implements the Owner's schedule-centered continuity requirement. Per-PR or per-device sandboxes would discard useful contexts or create competing writable environments. A replacement runtime restores the same environment binding after the old runtime is reconciled or fenced.

The [source plan's goals and requirements](../plans/doc/521-workstation-design.md#goals) preserve the constraint. The [identity model](agentic-developer-workstation.md#52-identity-authority-and-lifetime) describes the proposed bindings. The design remains Draft; pre-schedule runtime representation is [D1](#d1).

```yaml
id: W4
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="w5"></a>

## 5. Share the evidence archive outside schedule sandboxes

Place capture/retrieval services, provenance/catalog and retained originals outside individual schedule sandboxes. Roles use scoped APIs; a protected local spool retains evidence awaiting delivery.

Keeping the only evidence copy inside a disposable runtime would couple retention and cross-schedule retrieval to that runtime's lifetime. A shared service preserves an independent storage and authorization boundary. Its outage still requires bounded spooling, visible gaps and blocked evidence-dependent transitions.

The [source plan](../plans/doc/521-workstation-design.md#current-state) records shared placement and preferred PostgreSQL catalog/provenance. The [archive contract](agentic-developer-workstation.md#55-shared-evidence-archive-and-policy) preserves the proposal. The [archive design](engineering-evidence-archive.md) and its [decision records](engineering-evidence-archive.decisions.md) provide concrete proposals; original-artifact layout and spool implementation remain [D4](#d4) until accepted.

```yaml
id: W5
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:34:06Z'
```

<a id="d1"></a>

## 6. Resolve the pre-schedule runtime

Design starts under an existing Epic or Feature before a committed schedule exists. The open choice is how to identify its runtime and move into one or several execution environments.

Evaluate adoption of an existing design environment into the first schedule and separate environments when planning produces several schedules. Preserve design/evidence identity without inventing a new issue type, requiring an artificial schedule to begin design, or weakening one active sandbox per committed schedule.

The source design leaves this unresolved. Designer/planner work under Workstation architecture (#521) and Developer control (#517) resolves it through [S1 and Wave 0](../roadmaps/agentic-developer-workstation.md#6-scenario-walkthroughs-and-qualification-obligations).

```yaml
id: D1
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="d2"></a>

## 7. Select the editor backend and connection path

Choose the editor/backend, profile format, transport, client routing and independently configured runtime state for simultaneous desktop/iPad access.

VS Code Remote Tunnels and Coder code-server are candidates. [Microsoft documents one client per server instance](https://code.visualstudio.com/docs/remote/tunnels/#can-multiple-users-or-clients-access-the-same-remote-instance-simultaneously); [code-server documents iPad use](https://coder.com/docs/code-server/ipad) and its [extension differences](https://coder.com/docs/code-server/FAQ). These references do not qualify the proposed topology.

Developer control (#517) and Operations (#520) must demonstrate all eight startup combinations, coexistence/resource budgets, private native endpoints and actual iPad interaction before G2. The [editor contract](agentic-developer-workstation.md#54-editor-instances-and-attachment-views) defines the required behavior.

```yaml
id: D2
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="d3"></a>

## 8. Qualify host behavior and identity enforcement

Resolve the pinned hosts' shared-server role configuration, simultaneous views, history/input/approval behavior, native session controls and failure recovery.

[Claude Remote Control](https://code.claude.com/docs/en/remote-control), [Codex app-server](https://learn.chatgpt.com/docs/app-server) and [OpenCode's background service](https://opencode.ai/docs/cli/#background-service) provide documented foundations. Actual editor-to-session paths, creation discovery, supported hooks and no-view continuity need evidence. Codex's last-subscriber unload behavior requires an explicit continuity strategy.

Agent hosts (#459) with Developer control (#517) owns the [capability matrix](../roadmaps/agentic-developer-workstation.md#host-capability-matrix-the-planner-must-obtain). Report unsupported or inconclusive behavior rather than infer that a common interface has erased provider differences.

```yaml
id: D3
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="d4"></a>

## 9. Resolve archive storage and recovery acknowledgments

The [archive design](engineering-evidence-archive.md) and [roadmap](../roadmaps/engineering-evidence-archive.md) address original-artifact placement, catalog/provenance boundaries, retention, authorization, capture acknowledgments and restoration as proposals. The local capture-spool storage engine is also undecided.

The local spool engine and central storage layout remain open. Evaluate integrity, performance, reliability, security and maintenance for each component. [W6](#w6) removes the earlier storage-uniformity preference; no database or queue is selected by that correction.

Archive owners (#490/#492/#496), integrated with continuity/checkpoints, establish minimal durability in Wave 1 and the full contract before G3. Demonstrate citation-preserving restore and distinguish recoverable native state from evidence-based reconstruction, including S8's gaps and approval trace.

```yaml
id: D4
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-21T22:34:06Z'
```

<a id="d5"></a>

## 10. Qualify placement and resource budgets

Select qualified placement on the existing Mac mini and Minisforum and establish CPU, memory, storage, I/O, quotas, backup destination and acceptance thresholds.

Colocation avoids an initial hardware purchase, but shared load must leave capacity for the Minisforum's centralized logging. Logical service boundaries do not require separate machines. Platform support and actual workloads determine whether each candidate placement is usable.

Protected workspaces (#518) and Operations (#520) own qualification for the first deployment and repeat it at G6. The [deployment view](agentic-developer-workstation.md#57-initial-physical-deployment) preserves the candidates without assuming machine specifications.

```yaml
id: D5
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="d6"></a>

## 11. Define the DevLore lifecycle interface

Identify the reviewed DevLore resource/control-plane interface and the product-side owners/dependencies for environments and shared services.

The final lifecycle implementation belongs to DevLore. Prototypes consume existing host/SBX contracts and must preserve an adoption path rather than become a competing permanent manager. The exact product interface remains open.

The DevLore lifecycle owner with Developer control (#517) and Operations (#520) resolves the interface early. [Wave 5](../roadmaps/agentic-developer-workstation.md#5-delivery-waves-and-gates) owns the adoption work, including retained identity, pending operations, upgrades and recovery/rollback evidence.

```yaml
id: D6
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
```

<a id="w6"></a>

## 12. Evaluate each evidence store by its requirements

The capture/outbox and central archive may use different storage engines. Choose according to integrity, performance, reliability, security and maintenance cost. Storage-engine uniformity has no independent priority in that evaluation.

The Owner explicitly withdrew the earlier preference on 2026-11-20 in the design conversation. This changes only that evaluation constraint. D4's storage, retention, authorization, receipt and recovery decisions remain unresolved; this record approves no engine, deployment or implementation. Retaining the former preference as a requirement would contradict the Owner's correction.

The [completed workstation plan](../plans/doc/521-workstation-design.md#open-questions) preserves the earlier direction as historical evidence. D4 and this record govern the current evaluation. This changes only the former preference; it does not supersede the rest of D4's unresolved contract.

```yaml
id: W6
status: accepted
supersedes: []
proposed_by: David Noble
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-20'
recorded_at: '2026-11-21T22:34:06Z'
```
