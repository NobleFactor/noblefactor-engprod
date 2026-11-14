---
title: "Plan: Workstation architecture and planner handoff"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/521
status: complete
created: 2026-11-12
updated: 2026-11-13
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

On 2026-11-13 the owner clarified the access boundary: developer connections go
through VS Code or another compatible editor that can connect to the environment
and start a shell from a profile. Profiles launch the role views inside SBX;
developer devices do not connect directly to a role's native agent host.
The architecture, diagrams, workflow, and roadmap qualification reflect this
clarification. The common role-view launcher remains independent of the editor.

On 2026-11-13 the owner approved explicit replacement when a role's original
native session cannot be restored, then identified disaster recovery, including
self-inflicted loss, as the scenario that drives it: "doc that and add it as a
scenario." Document restoration before replacement, owner approval, sole
authoritative succession, evidence-based reconstruction, and visible context
gaps. Ordinary disconnect, sleep, process restart, and repairable resume failures
preserve the original session identity. Add the disaster-recovery narrative to
the roadmap's proposed scenario catalog without filing a tracker record.

On 2026-11-13 the owner requested: "Please commit and do a PR. I will review your
documents on github." Publication for review is authorized; merge and acceptance
of the design baseline remain pending that review. The PR script follows the
owner-run process and stops with the pull request open.

During review of the design pull request (#544) on 2026-11-13, the owner explicitly
approved editing this existing branch while that PR remains open.
This is the requested exception to agent rule 7 for these review revisions only.
Show the native host servers owning their assigned sessions, primary agents,
sub-agents, and helper processes. The control plane manages the servers and role
bindings; each native host manages its internal execution.

The owner also requested a full interaction section, starting from editor,
daemon, and role-session startup states. Cover the eight stable combinations,
distinguish editor clients from servers and terminal attachments, and separate
never-created sessions from stopped, unavailable, and unrecoverable sessions.
Include sandbox readiness, startup in progress, concurrent opens, unknown
outcomes, reconnect/detach, pending work and approvals, and recovery. Session
creation is on demand; later views use the same authoritative role binding.
This authorization covers design-document edits, not Git commands or publication.

The owner then requested filling the interaction gaps, rather than leaving them
as suggested additions. Specify concrete actor/action/outcome walkthroughs for
environment/editor preparation, concurrent role startup, attachment/reconnect,
work and approvals, scoped shutdown, failure recovery, and native session controls.
Record the durable operation and binding information each path needs. Add sequence
and lifecycle diagrams and map the paths to bounded roadmap acceptance cases.

The owner then requested publication of these revisions: "Let's push those
changes," and will review them on GitHub. The owner-run workflow commits and
pushes this branch, refreshes the existing PR #544 description and review links,
and waits for the new head's CI. The PR remains open; merge and baseline
acceptance are outside this publication request.

## Goals

1. Give the developer and planner one consistent description of the intended system.
2. Preserve one logical development environment and one SBX sandbox per schedule,
   across changing steps, frequent commits, and frequent merges.
3. Separate persistent role execution from device connections, editor instances,
   terminal views, assignments, and PR worktrees.
4. Explain access through compatible editors and shell/terminal profiles from
   desktop VS Code and an iPad, including simultaneous editor instances inside the
   same sandbox and views of the same role session.
5. Preserve existing ownership for roles/hosts, evidence, handbook/rules/skills,
   integration, and DevLore lifecycle management.
6. Hand the planner a hosted-model-first route from proof of concept to accepted operation.
7. Describe the transition from unscheduled design to planner-owned schedule
   proposals, including scenario walkthroughs that develop and qualify the methodology.

## Current State

At the start of this work, the repository had a draft architecture and roadmap
that emphasized local
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

The disaster-recovery scenario starts with loss of native session state while
the schedule, worktree, and shared evidence survive. Attempt restoration from
native state and available backups first. If restoration is exhausted, require
owner approval and prevent the old session from acting before authorizing a
successor. Preserve the approval, original/successor identities, recovery
evidence, and context gaps. The archive supports reconstruction without
promising a complete native backup or lossless recovery.

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
- [x] Commit the approved plan before design edits. The owner committed it as `934c695` on 2026-11-13.
- [x] Verify that the committed plan matches the owner-approved text before work. Read the commit/tree/blob objects and compared the plan bytes with the working file; they match.

### Phase 2: Revise the architecture

- [x] Read the complete existing architecture and relevant source records.
- [x] Rewrite the architecture to meet the requested structure and requirements above.
- [x] Add the complete system and multi-device attachment diagrams.
- [x] Reconcile obsolete initial hardware/inference assumptions and preserve relevant engineering requirements.
- [x] Update revision metadata and distinguish proposed behavior from qualified capability.
- [x] Document the approved disaster-recovery policy and distinguish it from routine session recovery.

### Phase 3: Produce the planner handoff

- [x] Rewrite the existing roadmap with outcomes, dependencies, owners, and acceptance gates.
- [x] Make the first implementation increment actionable without implementing it here.
- [x] Include a host capability matrix and explicit qualification obligations for all three hosts.
- [x] Include planner responsibilities for task decomposition, native issue links, schedule amendments,
      implementation plans, and owner review; do not create or amend schedules in this task.
- [x] Explain pre-schedule design, one-to-many roadmap-to-schedule decomposition,
      scenario walkthroughs, and the reviewed development methodology they produce.
- [x] Define completion of the hosted-model environment separately from optional local inference work.
- [x] Add a disaster-recovery scenario with owner-approved succession, retained evidence, and acceptance criteria.

### Phase 4: Verify and deliver for review

- [x] Check architecture/roadmap consistency, requirement coverage, ownership, and lifecycle terminology.
- [x] Run applicable documentation gates and verify relative links, anchors, and diagram syntax.
- [x] Record verification results and remaining unqualified deployment choices accurately.
- [x] Present both changed documents to the owner. Leave issue #521 open until its accepted-baseline evidence exists.

### Phase 5: Address owner review of host servers and interactions

- [x] Apply the reviewed component diagram and explain server/session/process ownership.
- [x] Add the interaction state model, eight stable startup combinations, lifecycle walkthroughs, and startup/recovery activity diagram.
- [x] Align the roadmap's host qualification, scenarios, gates, and planner contracts.
- [x] Verify the revised documents and present the review changes to the owner.
- [x] Specify the concrete I1–I7 interaction walkthroughs and durable operation/ownership contracts.
- [x] Add concurrency, reconnect, approval, and host-server lifecycle diagrams.
- [x] Map the detailed interactions to scenario walks and observable acceptance results.
- [x] Verify the completed interaction detail and present it to the owner.
- [x] Finalize the review documents and prepare the owner-run commit/push workflow for PR #544; leave the PR open for review.

Update phase status in the same authorized commit that completes each phase.
No design commit, push, pull request, deployment, purchase, issue mutation, or
schedule amendment is included in the plan-commit authorization.

## Verification and Review Status

The approved plan was committed by the owner as `934c695` before design edits.
The committed plan blob matched the working file when work began on 2026-11-13.

The revised architecture is revision 0.7 and the roadmap revision 0.8. Both remain
`Draft` for owner review. The original draft's relevant workspace, evidence,
review, authorization, and recovery requirements are retained; initial local
inference and hardware qualification are moved to the existing optional track.

Initial publication: the owner ran the PR script, committed the design as
`afaa404`, integrated develop by merge commit `b03b69b`, and opened design PR #544.
The owner-run repository gate succeeded. GitHub reported all four CI checks
successful for `b03b69b01d586e4723b6e626a808526945880e66` on 2026-11-13.
Those results apply to the published head, not the subsequent local review edits.

Completed checks:

- Codespell passed for the architecture, roadmap, and plan using the repository's
  `clear,rare,en-GB_to_en-US` dictionaries and ignore list.
- Frontmatter was checked against the documented catalog/working families.
- Twenty-four relative file/anchor links passed; the externally referenced
  `4.1 Persistent specialists` anchor is retained.
- The ten architecture requirements and six decision IDs are reflected in the
  roadmap's scenarios, ownership, delivery gates, and decision table.
- Eight Mermaid blocks received fence/block-structure checks and syntax review.
  They were not rendered or checked by a Mermaid runtime locally.
- The editor-profile clarification was checked across the workflow, component
  and sequence diagrams, qualification gates, scenarios, and attachment contract.
  Diagram edges do not connect developer devices directly to native role hosts.
- The disaster-recovery refinement was checked across the workflow, identity and
  driver contracts, archive responsibilities, recovery event table, G3 gate, S8
  walkthrough, host matrix, and planner handoff. S6 retains original-session
  recovery; S8 requires restoration attempts, explicit approval, fencing,
  recorded succession, and visible context gaps. The proposed catalog contains
  S1 through S8 without renumbering existing scenarios. The three Mermaid blocks
  are unchanged by this refinement.
- The server/interactions review revision shows each selected host server owning
  its assigned sessions (1:N), with primary agents and optional sub-agents/helper
  processes. The original attachment sequence and roadmap dependency graph are
  unchanged. The new activity diagram's node references and four component
  subgraphs passed structural checks.
- All eight E/D/B startup combinations occur exactly once. The state model
  distinguishes environment readiness, editor backend, client connection, host
  server, durable role binding, execution, and terminal views. S2/S3/S6/S8,
  G1/G2, the host matrix, D2/D3, and planner contracts reflect those distinctions.
- Installed Claude Code 2.1.325 help and current primary host documentation were
  consulted for shared-server capabilities. These are documented foundations,
  not demonstrations of the proposed SBX/editor integration.
- The interaction-gap revision specifies I1–I7 actor/action/outcome paths and
  durable ownership/operation records. Its concurrent-start, reconnect, approval,
  and server-lifecycle diagrams have balanced sequence blocks and valid local
  participant/node references. Approval resolution is distinct from action
  completion, deliberate stop survives stale reconnects, and uncertain effects
  require reconciliation before replay.
- Every I1–I7 walkthrough has a linked roadmap acceptance case under the existing
  scenarios/gates. Markdown table column counts and all eight stable startup
  combinations passed checks. Existing component, attachment, startup-activity,
  and delivery dependency diagrams are retained by this detail revision.
- Current core epic/feature descriptions and primary host/editor/SBX documentation
  were read. No live Scenarios-project row readback is claimed.

The agent checked this review revision with standalone documentation checks.
The owner-run publication workflow runs the full repository gate before its
commit and reruns it if integrating develop changes the candidate. It verifies
the published head and description, waits for that head's CI jobs, and leaves
the PR open. No host, editor topology, iPad workflow, or recovery behavior was
implemented or tested by this documentation change.

The first drafts were published for owner review on GitHub. The owner requested
publication of the completed server/interactions revision through the updated
worktree script. This plan records completed documentation work in the final
review commit; the architecture and roadmap remain Draft during owner review.
Workstation architecture and delivery plan (#521) remains open pending its
accepted-baseline evidence on develop. Publication neither accepts the baseline
nor authorizes a merge, tracker amendments, or deployment.

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
- Local capture-spool storage engine: deferred by the owner, with a preference for one stack end-to-end.
- DevLore product-side lifecycle integration surface and dependency tasks, to be resolved by the planner with its owner.
- Pre-schedule design environment and its binding/adoption into schedule-based
  execution; resolve the chicken-and-egg lifecycle without silently weakening the
  schedule/sandbox association.
- First scenario-walkthrough schedule: scope, scenario coverage, exit criteria,
  and ownership of the methodology produced; proposed by the planner for owner review.
