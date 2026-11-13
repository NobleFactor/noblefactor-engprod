---
title: "Plan: Workstation architecture and planner handoff"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/521
status: approved
created: 2026-11-12
updated: 2026-11-12
---

# Plan: Workstation architecture and planner handoff

## Issue 521

Revise the existing Agentic Developer Workstation architecture and roadmap for
[Workstation architecture and delivery plan](https://github.com/NobleFactor/noblefactor-engprod/issues/521),
under [Agentic workstation integration](https://github.com/NobleFactor/noblefactor-engprod/issues/514).
The result is a design for owner review and a roadmap the planner can turn into
implementation tasks and schedule amendments. This task does not implement or deploy the system.

## Summary

Restructure the architecture around the problem, solution, goals, development
workflow, and system architecture. Rewrite the roadmap as a staged handoff to the
planner, with useful increments, dependencies, ownership, acceptance evidence, and
bounded decisions. Incorporate the owner's schedule-centered workflow, five
persistent roles on Claude/Codex/OpenCode, SBX execution, remote editor servers,
shared evidence services, and eventual DevLore lifecycle management.

## Owner Approval

Approved by the owner on 2026-11-12: "I approve the plan. proceed."
The documentation approach is approved. Commit this approved plan before design
edits, then verify that the committed version matches the approved text.
Git commands remain subject to their separate, named authorization requirement.

## Goals

1. Give the developer and planner one consistent description of the intended system.
2. Preserve one logical development environment and one SBX sandbox per schedule,
   across changing steps, frequent commits, and frequent merges.
3. Separate persistent role execution from device connections, editor instances,
   terminal views, assignments, and PR worktrees.
4. Explain access from desktop VS Code and an iPad, including simultaneous editor
   instances inside the same sandbox and views of the same role session.
5. Preserve existing ownership for roles/hosts, evidence, handbook/rules/skills,
   integration, and DevLore lifecycle management.
6. Hand the planner a hosted-model-first route from proof of concept to accepted operation.
7. Describe the transition from unscheduled design to planner-owned schedule
   proposals, including scenario walkthroughs that develop and qualify the methodology.

## Current State

The repository has a draft architecture and roadmap. They emphasize local
inference, hardware qualification, and an OpenCode target workflow more strongly
than the owner's current starting point. The discussion establishes hosted models
on existing hardware first; local inference and hardware acquisition are a
separate future track. No workstation integration is claimed to be qualified.

Known inputs:

- Five roles: designer, planner, coder, auditor, reviewer; each has its own session.
- Three supported host implementations: Claude, Codex, OpenCode; role and host are different identities.
- The owner reports Claude supports multiple simultaneous views; OpenCode has server mode.
- Codex exposes app-server and remote TUI support. Its simultaneous native TUI
  behavior and disconnect/recovery semantics remain qualification work.
- Microsoft Remote Tunnels documents one user/client at a time per server
  instance. Additional independent editor-server instances within the same SBX
  sandbox are the proposed topology for concurrent devices; exact product,
  isolation of server state, routing, and coexistence must be qualified.
- The archive is a shared service outside schedule sandboxes. PostgreSQL is the
  preferred datastore; original-artifact placement is the archive design's decision.
- Available hardware is a Mac mini and a Minisforum system. Any use of the latter
  shares capacity with the owner's centralized logging system; designing that
  logging system is outside scope.
- The current designer has no schedule: design and roadmap are inputs to the
  planner, who creates one or more schedules. The system must account for this
  bootstrap rather than assume every activity already has a schedule.
- The owner proposes a first schedule built around walking scenarios. The
  resulting methodology is an explicit deliverable, with reviewed requirements
  belonging to the engineering handbook/rules/skills work.
- The owner identifies the engprod Scenarios project as
  https://github.com/orgs/NobleFactor/projects/27/views/2. Its live rows have not
  been read: the connector has no Projects interface, the authenticated CLI
  cannot reach api.github.com from this session, and the web fetch failed. Use
  the repository's documented Scenario/Beat model without presenting it as a
  readback of this board; read any supplied Scenario issue links separately.
- Portable tooling (#152), supplied by the owner, is a concrete scenario source.
  Its narrative follows a developer across machines and identifies dependency
  gates across feature owners. Its November 5 comment records removal of Feature
  rows and movement of discovered work to Triage or schedules. Cite the narrative
  and that comment together; the body's older Thread/Ops-label text is historical,
  not the current Scenario/Schedule model or proof of current command availability.

## Requirements

### Architecture

The architecture will contain the following reader-facing sections:

1. Problem: fragmented sessions, device-bound access, lost context and evidence,
   late compliance findings, and iterative schedules crossing short-lived PRs.
2. Goals and scope: human direction, engineering quality, continuity, independent
   review, hosted models initially, existing hardware, and explicit completion criteria.
3. Solution: a schedule-centered development environment with persistent roles,
   attachable editor views, protected durable work, and shared engineering services.
4. Development workflow tour: begin design before scheduling; produce and review
   design/roadmap assets; hand them to a planner; propose issues, their plans, and
   schedules; select/create an authorized execution environment; open roles;
   design/plan/code iteratively; amend steps through the owner;
   audit/review; commit/merge frequently; detach; continue from an iPad; recover; close.
5. System architecture: logical and initial physical placement, identities and
   lifetimes, component ownership, host-driver contracts, evidence and policy
   boundaries, editor/server/view attachment, supervision, and recovery.
6. Decisions and qualification: distinguish owner requirements, design proposals,
   documented external capabilities, and behavior still requiring a live test.

Include diagrams for the whole system and for multi-device attachment. Multiple
editor instances share role bindings and the schedule workspace without creating
extra agents or sandboxes. Preserve the existing `4.1 Persistent specialists` heading
anchor used by the related handbook and entry-point issues. Input coordination and workspace write authority remain
explicit; no new single-controller restriction is adopted as an owner requirement.

Distinguish the unscheduled design context from a committed schedule and its
execution environment. Present the bootstrap placement/binding as an open design
decision; do not silently invent a new GitHub issue type or amend the one-to-one
schedule/sandbox requirement. Address both adopting an existing design environment
into the first schedule and starting separate execution environments when the
planner proposes more than one schedule.

Explain a scenario-led first schedule. Under the current issue model, persistent
Scenario records are separate from Schedule steps; proposed steps are Tasks/Bugs
that walk named scenarios and retain links to their origin and findings. Each
issue has its own implementation plan under the normal process. Walkthroughs may
discover work and refine the design, roadmap, and methodology through owner review.
Do not schedule Scenario issues as steps or create issue/project records in this task.

Use portable tooling (#152) as the concrete example connecting scenario narrative,
cross-feature dependencies, discovered Tasks/Bugs, their plans, schedule ordering,
and retained provenance after a work item leaves the Scenario project. Apply that
pattern to the proposed multi-device and design-to-planning scenarios, without
claiming those proposed scenarios or schedules have already been filed.

Retain relevant protections from the current draft: protected canonical clones,
permanent work products, coordinated writers, immutable review inputs, independent
closing review, exact-snapshot commit checks, unknown-outcome reconciliation, and
source-linked checkpoints. Browser disconnection, host-process failure, sandbox
replacement, and machine failure must have separately stated behavior.

### Roadmap

Describe dependency-oriented increments, not a fixed schedule or implementation
plan. Each increment names the outcome, prerequisites, existing feature owners,
acceptance demonstration, remaining decisions, and artifacts for the planner.

The intended progression is:

1. Review the unscheduled design and roadmap; hand them to the planner with a
   proposed scenario catalog and a first scenario-walkthrough increment.
2. Prove the five roles and all three hosts in one schedule's SBX sandbox, with
   durable work, minimal policy loading, early evidence capture, and basic supervision.
3. Prove desktop/iPad access using independent editor instances and shared role
   sessions, including disconnection while work or approval requests are pending.
4. Integrate scoped archive retrieval, source-linked checkpoints, startup/compaction
   reading sets, and recovery across provider and sandbox failures.
5. Integrate iterative schedule work, short PR cycles, compliance feedback,
   exact-snapshot checks, independent closing review, and verified status updates.
6. Replace lifecycle prototypes with DevLore-managed environments and shared
   services while retaining authoritative identities and durable state.
7. Qualify and accept the complete hosted-model environment on existing hardware,
   including resource contention, restoration, upgrades, and repeated real work.

Basic operations, evidence preservation, and policy loading accompany the first
prototype rather than waiting for their later full integration increments. Mark
parallel work and true dependencies. Local inference and hardware procurement stay
under their existing epic as an optional, separately authorized track, not an exit
condition or prerequisite for this roadmap.

Treat the development methodology as a deliverable alongside the working platform:
scenario walkthroughs expose the procedures, exceptions, role interactions, and
tooling gaps; review turns those findings into authoritative handbook/rules/skills
under #526 and qualified host/review behavior under #456. Completion requires the
owner to accept the documented methodology and evidence of its use, not only a
running sandbox and editor. The planner defines bounded walkthrough issues and
their exit evidence; each issue receives its own plan before its work begins.

### Sources and ownership

Cite the relevant current issues and primary technical documentation. In
particular, preserve Agent-assisted engineering (#456), Engineering evidence
archive (#490), Engineering handbook, agent rules, and skills (#526), Agentic
workstation integration (#514), and their applicable feature responsibilities.
The archive records evidence; reviewed handbook/rules/skills define current policy;
GitHub remains authoritative for schedules, source, PRs, and accepted artifacts.

## Implementation Phases

### Phase 1: Establish the approved documentation work

- [x] Obtain authorization for the named branch-opening operation.
- [x] Open `doc/521-workstation-design` using the existing branch workflow. The owner ran the command after the agent's shell could not reach GitHub.
- [x] Install this proposal as the repository plan, with the proposal-location paragraph removed.
- [x] Review the plan with the owner and record its approved status before work.
- [ ] Commit the approved plan before design edits, with explicit authorization for any agent-run Git commands.
- [ ] Verify that the committed plan matches the owner-approved text before work.

### Phase 2: Revise the architecture

- [ ] Read the complete existing architecture and relevant source records.
- [ ] Rewrite the architecture to meet the requested structure and requirements above.
- [ ] Add the complete system and multi-device attachment diagrams.
- [ ] Reconcile obsolete initial hardware/inference assumptions and preserve relevant engineering requirements.
- [ ] Update revision metadata and distinguish proposed behavior from qualified capability.

### Phase 3: Produce the planner handoff

- [ ] Rewrite the existing roadmap with outcomes, dependencies, owners, and acceptance gates.
- [ ] Make the first implementation increment actionable without implementing it here.
- [ ] Include a host capability matrix and explicit qualification obligations for all three hosts.
- [ ] Include planner responsibilities for task decomposition, native issue links, schedule amendments,
      implementation plans, and owner review; do not create or amend schedules in this task.
- [ ] Explain pre-schedule design, one-to-many roadmap-to-schedule decomposition,
      scenario walkthroughs, and the reviewed development methodology they produce.
- [ ] Define completion of the hosted-model environment separately from optional local inference work.

### Phase 4: Verify and deliver for review

- [ ] Check architecture/roadmap consistency, requirement coverage, ownership, and lifecycle terminology.
- [ ] Run applicable documentation gates and verify relative links, anchors, and diagram syntax.
- [ ] Record verification results and remaining unqualified deployment choices accurately.
- [ ] Present both changed documents to the owner. Leave issue #521 open until its accepted-baseline evidence exists.

Update phase status in the same authorized commit that completes each phase.
No design commit, push, pull request, deployment, purchase, issue mutation, or
schedule amendment is included in the plan-commit authorization.

## Migration Path

Revise the two existing design files in place; do not start a competing architecture
or roadmap. Keep the current working development setup available during later
implementation. Preserve existing epic ownership and link the optional local
inference work instead of carrying a second delivery sequence in the architecture.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.521-workstation-design/docs/plans/doc/521-workstation-design.md` | Create | Approved documentation plan and phase status |
| `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.521-workstation-design/docs/architecture/agentic-developer-workstation.md` | Revise | Problem, goals, solution, workflow, and system architecture |
| `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.521-workstation-design/docs/roadmaps/agentic-developer-workstation.md` | Revise | Dependency-oriented planner handoff through system acceptance |

## Related Documents

- [Development process](https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/guides/development-process.md)
- [Existing architecture](https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/architecture/agentic-developer-workstation.md)
- [Existing roadmap](https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/roadmaps/agentic-developer-workstation.md)
- [Agentic workstation integration (#514)](https://github.com/NobleFactor/noblefactor-engprod/issues/514)
- [Agent-assisted engineering (#456)](https://github.com/NobleFactor/noblefactor-engprod/issues/456)
- [Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490)
- [Engineering handbook, agent rules, and skills (#526)](https://github.com/NobleFactor/noblefactor-engprod/issues/526)
- [Local inference and capacity qualification (#515)](https://github.com/NobleFactor/noblefactor-engprod/issues/515)
- [Engprod Scenarios project, supplied by the owner](https://github.com/orgs/NobleFactor/projects/27/views/2)
- [Issue standards: scenarios](https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/issue-standards.md#scenarios)
- [Portable tooling scenario (#152)](https://github.com/NobleFactor/noblefactor-engprod/issues/152)
- [Portable tooling: November 5 project-membership record](https://github.com/NobleFactor/noblefactor-engprod/issues/152#issuecomment-6661940131)

## Open Questions

- Exact editor-server product and independently configured instances; qualify simultaneous desktop/iPad access.
- Codex native simultaneous views, approval routing, and retained subscriptions; qualify the pinned release.
- Initial physical placement and resource budget; retain the Minisforum's shared logging constraint.
- Final original-artifact storage, capture acknowledgments, and restoration contract under the archive epic.
- DevLore product-side lifecycle integration surface and dependency tasks, to be resolved by the planner with its owner.
- Pre-schedule design environment and its binding/adoption into schedule-based
  execution; resolve the chicken-and-egg lifecycle without silently weakening the
  schedule/sandbox association.
- First scenario-walkthrough schedule: scope, scenario coverage, exit criteria,
  and ownership of the methodology produced; proposed by the planner for owner review.
