---
title: "Agentic developer workstation decisions"
status: draft
created: 2026-11-19
updated: 2026-11-20
---

# Agentic developer workstation decisions

[System design](agentic-developer-workstation.md) · [Roadmap](../roadmaps/agentic-developer-workstation.md)

These records use the [shared decision format](../standards/documentation.md#decision-records). W1–W3 record explicit Owner-approved boundaries from the source plan; W6 records the approved environment-configuration boundary. The overall design remains Draft. W4/W5 are design proposals; D1–D6 remain unresolved. Metadata records approval of a choice separately from its implementation or qualification.

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

The [source plan](../plans/doc/521-workstation-design.md#current-state) records shared placement and preferred PostgreSQL catalog/provenance. The [archive contract](agentic-developer-workstation.md#55-shared-evidence-archive-and-policy) preserves the proposal. Original-artifact layout and spool implementation remain [D4](#d4).

```yaml
id: W5
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
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

Resolve original-artifact placement, catalog/provenance boundaries, retention, authorization, capture acknowledgments and restoration. The local capture-spool storage engine is also undecided.

PostgreSQL remains the preferred shared catalog platform. The Owner deferred the spool implementation choice and expressed a preference for one stack end to end; the [source plan's open questions](../plans/doc/521-workstation-design.md#open-questions) preserve that direction. Evaluate implementation options without presenting a particular local database or queue as selected.

Archive owners (#490/#492/#496), integrated with continuity/checkpoints, establish minimal durability in Wave 1 and the full contract before G3. Demonstrate citation-preserving restore and distinguish recoverable native state from evidence-based reconstruction, including S8's gaps and approval trace.

```yaml
id: D4
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T02:02:55Z'
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

## 12. Configure environment roles under shared policy

Give each environment a versioned role configuration: its Schedule, selected hosts and model settings, workspace and shared resource references. The handbook owns the common requirements. The control plane retains the configuration and one authoritative native-session binding per environment/role, and uses DevLore for lifecycle management.

Keeping host choices in the environment configuration allows different assignments to use suitable models without changing role responsibilities. Treating a host choice as another role identity could create competing conversations. Desired settings and observed model/session state therefore remain distinct. Compatible configuration changes preserve the original session; replacement retains the existing Owner-approval requirement.

Audit requests run on demand or after pre-commit checks and reach the bound auditor. Independence is checked against the actual model families used to build the candidate. The check covers changed and potentially affected assets. External reviews and corrective verification are recorded on the PR introducing the change; reports produced before the PR exists stay outside Git until it is opened.

The Owner chose to record this boundary now rather than defer it, approving the focused design amendment on 2026-11-20. The [approval record](../plans/doc/558-role-entry-points.md#environment-role-configuration-approval) preserves the scope. [Environment configuration](agentic-developer-workstation.md#environment-role-configuration) and [audit flow](agentic-developer-workstation.md#compliance-audit-flow) describe the intended system. Configuration formats and implementation remain delivery-plan work.

```yaml
id: W6
status: accepted
supersedes: []
proposed_by: Codex
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-21T00:35:21.678Z'
recorded_at: '2026-11-21T00:39:47.723106Z'
```
