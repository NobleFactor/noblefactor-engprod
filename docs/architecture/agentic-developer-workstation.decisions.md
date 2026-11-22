---
title: "Agentic developer workstation architecture decisions"
status: draft
created: 2026-11-19
updated: 2026-11-21
---

<a id="agentic-developer-workstation-decisions"></a>

# Agentic developer workstation architecture decisions

[System design](agentic-developer-workstation.md) · [Roadmap](../roadmaps/agentic-developer-workstation.md)

These architecture decision records (ADRs) use the [shared decision format](../standards/documentation.md#decision-records). W1–W3 record explicit Owner-approved boundaries from the source plan; W6 records the approved environment-configuration boundary; W7 records the approved one-off independent audit path; W8 records the withdrawal of the storage-uniformity preference. The overall design remains Draft. W4/W5 are design proposals; D1–D6 remain unresolved. Metadata records approval of a choice separately from its implementation or qualification.

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

The [source plan's goals and requirements](../plans/doc/521-workstation-design.md#goals) preserve the constraint. The [identity model](agentic-developer-workstation.md#52-identity-authority-and-lifetime) describes the proposed bindings. The design remains Draft; continuity from design to implementation schedules is [D1](#d1).

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

The [source plan](../plans/doc/521-workstation-design.md#current-state) records shared placement and preferred PostgreSQL catalog and provenance. The [archive contract](agentic-developer-workstation.md#55-shared-evidence-archive-and-policy) preserves the proposal. The [archive design](engineering-evidence-archive.md) and its [decision records](engineering-evidence-archive.decisions.md) provide concrete proposals. Original-artifact layout and spool implementation remain [D4](#d4) until accepted.

```yaml
id: W5
status: proposed
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-22T03:53:46Z'
```

<a id="d1"></a>

<a id="6-resolve-the-pre-schedule-runtime"></a>

<a id="6-resolve-continuity-from-design-to-implementation-schedules"></a>

## 6. Resolve continuity from design to implementation schedules

[Open question D1: Continuity between design and implementation schedules](agentic-developer-workstation.md#d1).

<a id="d2"></a>

<a id="7-select-the-editor-backend-and-connection-path"></a>

## 7. Select the editor backend and connection path

[Open question D2: Editor backend and connection path](agentic-developer-workstation.md#d2).

<a id="d3"></a>

<a id="8-qualify-host-behavior-and-identity-enforcement"></a>

## 8. Qualify host behavior and identity enforcement

[Open question D3: Host capabilities and identity enforcement](agentic-developer-workstation.md#d3).

<a id="d4"></a>

<a id="9-resolve-archive-storage-and-recovery-acknowledgments"></a>

## 9. Resolve archive storage and recovery acknowledgments

[Open question D4: Archive storage and recovery acknowledgments](agentic-developer-workstation.md#d4).

<a id="d5"></a>

<a id="10-qualify-placement-and-resource-budgets"></a>

## 10. Qualify placement and resource budgets

[Open question D5: Placement and resource budgets](agentic-developer-workstation.md#d5).

<a id="d6"></a>

<a id="11-define-the-devlore-lifecycle-interface"></a>

## 11. Define the DevLore lifecycle interface

[Open question D6: DevLore lifecycle interface](agentic-developer-workstation.md#d6).

<a id="w6"></a>

## 12. Configure environment roles under shared policy

Give each environment a versioned role configuration: its Schedule, selected hosts and model settings, workspace, and shared resource references. The handbook owns the common requirements. The control plane retains the configuration and one authoritative native-session binding for each role within an environment, and uses DevLore for lifecycle management.

Keeping host choices in the environment configuration allows different assignments to use suitable models without changing role responsibilities. Treating a host choice as another role identity could create competing conversations. Desired settings and observed model and session state therefore remain distinct. Compatible configuration changes preserve the original session; replacement retains the existing Owner-approval requirement.

Audit requests run on demand or through an enabled trigger after successful pre-commit checks and reach the bound auditor. Shared policy governs required requests and activation of blocking checks. Independence is checked against the actual model families used to build the candidate. The check covers changed and potentially affected assets. External reviews and corrective verification are recorded on the PR introducing the change; reports produced before the PR exists stay outside Git until it is opened.

The Owner chose to record this boundary now rather than defer it, approving the focused design amendment on 2026-11-20. The [environment-configuration approval](../plans/doc/558-role-entry-points.md#environment-role-configuration-approval) preserves the scope. [Environment configuration](agentic-developer-workstation.md#environment-role-configuration) and [audit flow](agentic-developer-workstation.md#compliance-audit-flow) describe the intended system. [Developer control (#517)](https://github.com/NobleFactor/noblefactor-engprod/issues/517) owns configuration planning and durable bindings, using [Agent hosts (#459)](https://github.com/NobleFactor/noblefactor-engprod/issues/459) for native-host application. [Continuous compliance (#519)](https://github.com/NobleFactor/noblefactor-engprod/issues/519) owns audit routing, trigger wiring, and the exact-candidate commit check. The [handbook policy](../engineering/agent-operation.md#compliance-auditing) defines the requirements; those open Features require separate implementation plans.

```yaml
id: W6
status: accepted
supersedes: []
proposed_by: Codex
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-20T16:35:21.678-08:00'
recorded_at: "2026-11-22T02:17:54.778689+00:00"
```

<a id="w7"></a>

## 13. Allow an approved one-off audit without replacing the assigned auditor

When the assigned auditor helped build a candidate or its independence is unknown, the Owner can authorize one audit by an eligible third model family independent of every builder. The assignment covers the identified candidate and does not create a second persistent environment and role binding. Preserve the assigned auditor's conversation and binding.

Several model families can contribute to one candidate, leaving its assigned auditor ineligible. A different model in the retained session was considered, but host support and observed model evidence still govern whether that works. Leaving every such request unresolved preserves independence but provides no assessment. The approved one-off path obtains an independent assessment without switching the retained session.

Record the Owner's request-specific approval, candidate and base, original binding reference, actual auditor and model, and result with the audit and introducing PR. If no eligible auditor is available, the audit remains unresolved. This decision does not waive independence, qualify a host, or authorize automatic agent creation.

[Audit flow](agentic-developer-workstation.md#compliance-audit-flow) defines the system interaction. The [handbook policy](../engineering/agent-operation.md#compliance-auditing) owns auditor authority. The [one-off audit approval](../plans/doc/558-role-entry-points.md#compliance-policy-and-one-off-audit-approval) preserves David Noble's acceptance of this proposal. This extends W6's audit routing while retaining its one-binding rule.

```yaml
id: W7
status: accepted
supersedes: []
proposed_by: Codex
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-20T19:40:10.105-08:00'
recorded_at: "2026-11-22T02:17:54.778689+00:00"
```

<a id="w8"></a>

## 14. Evaluate each evidence store by its requirements

The capture/outbox and central archive may use different storage engines. Choose according to integrity, performance, reliability, security and maintenance cost. Storage-engine uniformity has no independent priority in that evaluation. Technical suitability comes first: the Designer must challenge a preference that would compromise requirements and explain the evidence. Owner preferences guide choices among suitable alternatives when their tradeoffs are otherwise balanced.

The Owner explicitly withdrew the earlier preference on 2026-11-20 in the design conversation. This changes only that evaluation constraint. D4's storage, retention, authorization, receipt and recovery decisions remain unresolved; this record approves no engine, deployment or implementation. Retaining the former preference as a requirement would contradict the Owner's correction.

The [completed workstation plan](../plans/doc/521-workstation-design.md#open-questions) preserves the earlier direction as historical evidence. The [moved D4](agentic-developer-workstation.md#d4) and this record govern the current evaluation. During the Owner-directed consolidation into PR #616, this record was renamed from W6 to W8 to preserve the environment-role W6 and one-off-audit W7. This changes only the former preference; it does not supersede the rest of D4's unresolved contract.

```yaml
id: W8
status: accepted
supersedes: []
proposed_by: David Noble
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-20'
recorded_at: '2026-11-22T03:53:46Z'
```
