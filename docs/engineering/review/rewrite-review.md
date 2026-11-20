---
title: "Documentation rewrite review"
status: active
created: 2026-11-19
updated: 2026-11-20
---

# Documentation rewrite review

This record tracks the full rewrite in the [approved plan](../../plans/doc/581-schedule-command-consumers.md#95-full-documentation-rewrite). The input is the 51-document inventory at revision `15bac42fdd60dcadba28111849ae49713a10008a`. A rewritten draft is not a completed content review or implementation evidence.

Current disposition: all 51 inputs have a first-pass rewrite or explicit record-preservation treatment. The nine independent-review findings have locally verified corrections, including the Owner-approved R01/R03/R07 dispositions below. Independent re-review, final content/tooling-gap review and Owner acceptance remain open.

## 1. Method and evidence

Map requirements and references before changing each architecture set. Rewrite maintained explanations using [Google's writing guidance](https://developers.google.com/style/highlights) and the [arc42 content model](https://arc42.org/overview/). Preserve source wording where material, including the Owner's original assignment proposal.

After the first rewrite pass, scan for conflicts between methodology and tooling. Present findings with sources and proposed corrections to the Owner, record decisions, and verify agreed corrections. An unresolved choice in a draft is not permission to make a new policy decision.

The [source manifest](sources/rewrite-2026-11-19/manifest.json) records all 51 input hashes, the existing immutable source hashes and preserved agent-schedule anchors. Exact text snapshots preserve the affected original documents before rewriting or an approved policy addition. The 21 pre-existing files under the review's source directory remain unchanged.

## 2. Architecture content map

Arc42 coverage is assessed across each architecture set. Detail chapters do not need twelve repeated headings. The table maps the complete draft coverage; section 19 records the final content assessment and qualification limits.

| Arc42 concern | Agent schedules | Issue data model destination | Developer workstation destination |
| --- | --- | --- | --- |
| Goals and requirements | [Purpose](../../architecture/agent-schedule/index.md#1-purpose-and-scope) and [assignment criteria](../../architecture/agent-schedule/2.1-agent-schedule-commands.md#6-quality-criteria) | Set overview and workflow | Goals and development workflow |
| Constraints | [Scope and constraints](../../architecture/agent-schedule/3-agent-sandbox.md#1-scope-and-constraints) and native trust boundary | GitHub account capabilities and permission model | Hosted models, SBX, available machines and role boundaries |
| Context | [System context](../../architecture/agent-schedule/index.md#3-context-and-components) | GitHub, repositories, projects, forms and model resources | Developer devices, editors, agent hosts, GitHub and evidence archive |
| Solution strategy | [Native session ownership](../../architecture/agent-schedule/1-session-model.md#1-identity-and-ownership) | One product hierarchy with separate collection membership and origin | Schedule environment with independent role sessions and shared native servers |
| Components | [Launcher components](../../architecture/agent-schedule/1-session-model.md#2-components) and [sandbox placement](../../architecture/agent-schedule/3-agent-sandbox.md#2-components-and-placement) | Model resource, validation and collection/issue commands | Control plane, editor backends, host drivers, storage and archive |
| Runtime | [Start and resume](../../architecture/agent-schedule/1-session-model.md#3-start-and-resume) and [assignment operations](../../architecture/agent-schedule/2.1-agent-schedule-commands.md#2-start-an-assignment) | Filing, moving, scheduling, scenarios, closure and failure contracts | Startup combinations, views, work, approvals, stop, recovery and configuration |
| Deployment | [Platform interfaces](../../architecture/agent-schedule/2-command-line.md#4-platform-interfaces) and [SBX proposal](../../architecture/agent-schedule/3-agent-sandbox.md) | Resource distribution and account-specific placement | SBX guest, shared services and physical placement |
| Shared concepts | [Glossary](../../architecture/agent-schedule/index.md#5-shared-concepts), binding and state ownership | Identity, attributes, membership, Step, Beat and source forms | Identity, lifetimes, durable state, authority and capture |
| Decisions | Four chapter decision companions | Model and command decision companions | Workstation decision companion |
| Quality | [Quality scenarios](../../architecture/agent-schedule/index.md#6-decisions-quality-and-risks) and [SBX qualification](../../architecture/agent-schedule/3-agent-sandbox.md#7-quality-scenarios) | Classification, uniqueness, permissions and command acceptance scenarios | Existing qualification scenarios, with outcomes and limits |
| Risks and debt | [Native-state risks](../../architecture/agent-schedule/1-session-model.md#7-quality-and-risks) and [sandbox choices](../../architecture/agent-schedule/3-agent-sandbox.md#8-risks-and-open-choices) | Platform limits, partial writes and authority boundaries | Unqualified host/editor capabilities, storage and recovery choices |
| Glossary | [Shared concepts](../../architecture/agent-schedule/index.md#5-shared-concepts) | Product hierarchy, issue metadata and collection terminology | Environment, sandbox, host server, role session and attachment view |

## 3. Requirement maps

### 3.1 Agent schedules

| Source content | Maintained destination | Preservation or remaining review |
| --- | --- | --- |
| Schedule identity, background short ID, conversation UUID and per-schedule lock | Session lifecycle sections 1–2 | Original source snapshot and old anchors retained |
| Native discovery, foreground refusal, trust refusal, detached starts and stopped-session wake | Session lifecycle sections 2–4 | Full source comparison remains required |
| Schedule environment, name fallback, rename submission and Windows limits | Session lifecycle sections 4 and 6 | Command details preserved; native runtime not exercised |
| Fresh tmux views, destruction, SSH/mosh and foreground transfer | Session lifecycle sections 1, 5 and 6 | Process observations retained in source; contract separated from observations |
| Forms, selectors, continuation, widths, output and platform parameters | Start-Claude command interface | Manual and implementation consistency review remains required |
| Assignment identity, atomic records, concurrent start and adapter responsibilities | Assignment interface sections 1–4 | Original Owner appendix preserved verbatim |
| Retrieval selectors, equivalent structured output, partial failures and progress ownership | Assignment interface section 3 | Original acceptance list remains in the appendix |
| Assignment naming, binding changes and terminal reuse | Assignment interface section 5 and decision companion | Explicitly unresolved; no new callable commands claimed |
| Guest placement, shared views and separate shells | SBX proposal sections 1–5 | Source snapshots preserve the complete original draft |
| Native discovery, detach, Git metadata, unpushed work, trust, credentials, configuration, store and transport questions | SBX proposal sections 3–8 and decision companion | Choices retain proposed or open status |
| Implementation phases, deployments, acceptance marks, relocations and retired clear behavior | Retained status references, original plans and source snapshots | No delivery checklist or migration narrative remains in the active architecture explanation |
| Significant choices and reasons | Chapter decision companions | Established launcher contracts distinguished from proposals |

### 3.2 Issue hierarchy and attributes

| Source content | Maintained destination | Preservation or remaining review |
| --- | --- | --- |
| Six types, three hierarchy levels, native parent links and account representations | Issue hierarchy sections 1–2 | Original bodies and status records preserved; previous anchors retained |
| Intake exceptions, Triage routing, classification, receiving-team ownership and one-project membership | Issue hierarchy section 3 | Command and workflow consistency review remains pending |
| Scenario origin, Beat, deferred classification and structural sweep exceptions | Issue hierarchy sections 3.3–3.4 | Scenario command reference remains authoritative for its operations |
| Feature audit, code review and lead sign-off; Epic, Schedule and Scenario closure meanings | Issue hierarchy section 4 | Required gates preserved; no claim of automatic enforcement |
| Severity, Priority, Area, Effort, dates and newcomer label | Issue attributes section 1 | Values, applicability, defaults and ownership retained |
| Native fields, label fallback, option identities and project-field boundary | Issue attributes section 2 | Account-specific representations retained |
| Resolution and completed state reason, triage/sweep limits and Scenario exceptions | Issue attributes sections 3–4 | Current command implementation comparison remains pending |
| Significant choices, prior alternatives and reasons | Two model chapter decision companions | Accepted requirements distinguished from the open sweep collision question |
| Ruling chronology, migration counts, snapshots of permissions and rollout checkboxes | Retained delivery references and immutable source snapshots | Active design contains the model, not the migration narrative |

### 3.3 Collections, access and workflow

| Source content | Maintained destination | Preservation or remaining review |
| --- | --- | --- |
| Four projects, fields, status, grouped views, template copies and account boundaries | Collections sections 1–5 | Full source bodies and status records preserved; view-by-view comparison remains pending |
| Consecutive Schedule Steps, closed-step movement, native dependencies, Scenario Beat and collection own rows | Collections sections 2–3 | Collection command references own exact command behavior |
| Commitment amendments, receiving-team responsibility and completion evidence | Collections sections 4–6 and workflow sections 2–3 | No new authority or enforcement is inferred |
| Native account representations, shared files, ownership and participant grants | Storage and access sections 1–3 and 5–7 | Source snapshots distinguish policy from dated live observations |
| Triage routing, App and user credentials, parser limits and bounded execution | Storage and access section 4 | Runtime implementation comparison remains part of the required consistency review |
| Migration compatibility constraints, deltas, stages and running-session observations | Migration plan, retained migration reference and original text | Removed from the active architecture explanation |
| Filing, form and plan authority, scheduling, Scenario findings, progress routing and closure evidence | Issue tracking workflow | Existing command and handbook contracts remain authoritative |
| Live model authority, reconciliation, backup and publication | Model-command chapter | First-pass chapter complete; shared Owner-review policy approved, runtime alignment remains open |

### 3.4 Collection and issue command contracts

| Source content | Maintained destination | Preservation or remaining review |
| --- | --- | --- |
| Schedule reads, opening, movement, closure evidence, reopening and plan links | Schedule command sections 1–9 | Existing command signatures and collection recovery remain distinct from issue-open semantics |
| Scenario goal, walk, Beat, origin routing, move records, retirement and cleanup | Scenario command sections 1–8 | Manual cleanup is explicit; recurring automation is not claimed delivered |
| Issue placement, filing modes, templates, unique matching, defaults, movement and write order | Issue command sections 1–6 | Updated for PR #612: each issue open creates a new issue; unique is refused; collection partial-open behavior remains separate |
| Partial-operation behavior | Each command's failure guidance and issue command recovery table | No blanket retry or exactly-once guarantee; additional recovery remains separate work |
| Accepted decisions, rationale, alternatives and approvals | Three command decision companions | IDs and approval evidence retained; unsupported general retry claims qualified |
| System scope, components, runtime, deployment, decisions, quality, risks and glossary | Model-set overview | arc42 concerns covered at set level rather than repeated in each detail chapter |

## 4. Document dispositions

Every input receives an explicit disposition. Pending means the substantive rewrite or review is still required; a source hash alone does not establish preservation.

| Input document | Disposition |
| --- | --- |
| [Home/common/.claude/skills/star-github-schedule-progress/SKILL.md](../../../Home/common/.claude/skills/star-github-schedule-progress/SKILL.md) | First-pass rewrite recorded; source requirements, examples and incoming headings retained. Final Owner acceptance remains open. |
| [README.md](../../../README.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/architecture/agent-schedule/1-session-model.md](../../../docs/architecture/agent-schedule/1-session-model.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/1-session-model.status.md](../../../docs/architecture/agent-schedule/1-session-model.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/2-command-line.md](../../../docs/architecture/agent-schedule/2-command-line.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/2-command-line.status.md](../../../docs/architecture/agent-schedule/2-command-line.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/2.1-agent-schedule-commands.md](../../../docs/architecture/agent-schedule/2.1-agent-schedule-commands.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/2.1-agent-schedule-commands.status.md](../../../docs/architecture/agent-schedule/2.1-agent-schedule-commands.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/3-agent-sandbox.md](../../../docs/architecture/agent-schedule/3-agent-sandbox.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/3-agent-sandbox.status.md](../../../docs/architecture/agent-schedule/3-agent-sandbox.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/agent-schedule/index.md](../../../docs/architecture/agent-schedule/index.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/agentic-developer-workstation.md](../../../docs/architecture/agentic-developer-workstation.md) | Rewrite for the architecture or planner audience; preserve requirements, scenarios and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/architecture/issue-data-model/1-hierarchy.md](../../../docs/architecture/issue-data-model/1-hierarchy.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/1-hierarchy.status.md](../../../docs/architecture/issue-data-model/1-hierarchy.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/2-attributes.md](../../../docs/architecture/issue-data-model/2-attributes.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/2-attributes.status.md](../../../docs/architecture/issue-data-model/2-attributes.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/3-collections.md](../../../docs/architecture/issue-data-model/3-collections.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/3-collections.status.md](../../../docs/architecture/issue-data-model/3-collections.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/4-storage-and-reach.md](../../../docs/architecture/issue-data-model/4-storage-and-reach.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/4-storage-and-reach.status.md](../../../docs/architecture/issue-data-model/4-storage-and-reach.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/5-from-todays-scheme.md](../../../docs/architecture/issue-data-model/5-from-todays-scheme.md) | Retain migration reference; preserve original text and link its plan. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/5-from-todays-scheme.status.md](../../../docs/architecture/issue-data-model/5-from-todays-scheme.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/6-the-asset-and-its-sync.md](../../../docs/architecture/issue-data-model/6-the-asset-and-its-sync.md) | First-pass rewrite completed with Owner-approved review/merge policy; source evidence and legacy headings preserved. Final Owner acceptance remains open. |
| [docs/architecture/issue-data-model/6-the-asset-and-its-sync.status.md](../../../docs/architecture/issue-data-model/6-the-asset-and-its-sync.status.md) | First-pass rewrite completed with Owner-approved review/merge policy; source evidence and legacy headings preserved. Final Owner acceptance remains open. |
| [docs/architecture/issue-data-model/7-the-workflow-before-and-after.md](../../../docs/architecture/issue-data-model/7-the-workflow-before-and-after.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/7-the-workflow-before-and-after.status.md](../../../docs/architecture/issue-data-model/7-the-workflow-before-and-after.status.md) | Retain reference path; preserve exact status in source evidence; direct decisions and progress to their owners. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/8-the-schedule-commands.md](../../../docs/architecture/issue-data-model/8-the-schedule-commands.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/8-the-schedule-commands.decisions.md](../../../docs/architecture/issue-data-model/8-the-schedule-commands.decisions.md) | Review and revise decision explanation while retaining IDs, accepted choices, rationale and approval evidence. First pass recorded. |
| [docs/architecture/issue-data-model/9-the-scenario-commands.md](../../../docs/architecture/issue-data-model/9-the-scenario-commands.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/9-the-scenario-commands.decisions.md](../../../docs/architecture/issue-data-model/9-the-scenario-commands.decisions.md) | Review and revise decision explanation while retaining IDs, accepted choices, rationale and approval evidence. First pass recorded. |
| [docs/architecture/issue-data-model/10-the-issue-commands.md](../../../docs/architecture/issue-data-model/10-the-issue-commands.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/architecture/issue-data-model/10-the-issue-commands.decisions.md](../../../docs/architecture/issue-data-model/10-the-issue-commands.decisions.md) | Review and revise decision explanation while retaining IDs, accepted choices, rationale and approval evidence. First pass recorded. |
| [docs/architecture/issue-data-model/index.md](../../../docs/architecture/issue-data-model/index.md) | Rewrite architecture explanation and preserve requirements and anchors. Reviewed; source and reference evidence retained. |
| [docs/engineering/agent-operation.md](../../../docs/engineering/agent-operation.md) | Rewrite current guidance for its reader and ownership; preserve requirements, decisions and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/engineering/index.md](../../../docs/engineering/index.md) | Rewrite current guidance for its reader and ownership; preserve requirements, decisions and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/engineering/process.md](../../../docs/engineering/process.md) | Rewrite current guidance for its reader and ownership; preserve requirements, decisions and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/engineering/procedures/pull-request.md](../../../docs/engineering/procedures/pull-request.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/engineering/review/adoption-review.md](../../../docs/engineering/review/adoption-review.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/engineering/review/open-decisions.md](../../../docs/engineering/review/open-decisions.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/engineering/work-assets.md](../../../docs/engineering/work-assets.md) | Rewrite current guidance for its reader and ownership; preserve requirements, decisions and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/engineering/work-organization.md](../../../docs/engineering/work-organization.md) | Rewrite current guidance for its reader and ownership; preserve requirements, decisions and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/github-branch-protection.md](../../../docs/github-branch-protection.md) | First-pass rewrite recorded; source requirements, examples and incoming headings retained. Final Owner acceptance remains open. |
| [docs/guides/pr-script-template.md](../../../docs/guides/pr-script-template.md) | First-pass rewrite recorded; source requirements, examples and incoming headings retained. Final Owner acceptance remains open. |
| [docs/index.md](../../../docs/index.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/issue-standards.md](../../../docs/issue-standards.md) | Rewritten from the reviewed candidate with Owner-approved one-home/Triage policy; anchors and original source preserved. Final Owner acceptance remains open. |
| [docs/plans/doc/420-consolidate-engineering.md](../../../docs/plans/doc/420-consolidate-engineering.md) | Completed record verified byte-for-byte against the inventory; retained unchanged. First-pass disposition recorded. |
| [docs/plans/doc/581-schedule-command-consumers.md](../../../docs/plans/doc/581-schedule-command-consumers.md) | Maintained as the active execution record for scope, approvals, transitions and verification; no history removed. Final acceptance and delivery remain open. |
| [docs/roadmaps/agentic-developer-workstation.md](../../../docs/roadmaps/agentic-developer-workstation.md) | Rewrite for the architecture or planner audience; preserve requirements, scenarios and links. Reviewed against source maps and independent findings; final acceptance remains open. |
| [docs/standards/documentation.md](../../../docs/standards/documentation.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/templates/design.md](../../../docs/templates/design.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |
| [docs/templates/schedule.md](../../../docs/templates/schedule.md) | Rewrite maintained guidance or retain historical evidence with explicit current references. Review completed; final acceptance remains open. |

## 5. Verification and remaining gates

All 51 inputs have explicit dispositions, content/source maps and review evidence. Section 19 records the final author assessment, independent review results and M01–M10 dispositions. Mechanical checks establish metadata, references, source layout and preservation; the recorded content assessments establish the writing and architecture judgments.

R01–R09 are independently verified and all 21 older conversations are resolved. R10 is corrected locally and awaits independent recheck at the published correction head. Required final-head CI and Owner acceptance remain. The scoped non-draft exception in plan section 7.22 applies; it waives no merge or completion requirement.

## 6. Findings encountered during source comparison

The post-rewrite scan is complete for this review scope. The observations below retain their source comparison; section 19.2 records current corrections, follow-ups and safe interim boundaries.

| Finding | Evidence | Disposition |
| --- | --- | --- |
| M01: model publication hardcodes Claude Code assistance | [Disclosure helper](../../../Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/pull.star#L100) returns a literal Assisted-by value | The permanent policy names the submitting agent. Tooling correction is required; no code change is authorized by this documentation plan |
| M02: model publication merges its own PRs | [Publication helper](../../../Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/pull.star#L116) runs a squash merge after its CI gate | Owner approved stopping for his review and merge on 2026-11-19. Policy/chapter aligned and decision 62 recorded; helper/caller implementation alignment remains open |

The remaining comparison must also examine the helper's clone and branch handling, check-gate exceptions and prompt limitations. Recording a candidate is not an approved exception, a completed audit or evidence of a fix.

## 7. Owner-approved review-comment convention

David Noble approved this addition on 2026-11-19. The rule is defined once in [Agent operation](../agent-operation.md#codex-review-comments). Common and reviewer instructions, the review-comment template and the completion-review template reference it. The decision log records the Owner and date.

This is an addition to the approved Handbook command alignment work. The small addition to agent-operation does not count as its full rewrite. The original input is preserved before this change. Publication and native host entrypoint qualification are separate milestones.

The check record for this addition is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/review-comment-origin/verification.json.

## 8. Structured decision records

The Owner approved this addition on 2026-11-19 after requesting research against arc42 and Google. The [documentation standard](../../standards/documentation.md#decision-records) defines the format; the [decision template](../../templates/decision.md) demonstrates it. The [handbook decision log](decisions.md#decision-59) preserves the earlier record bodies and identifiers while adding headlines and structured attribution.

The original standard, design template and pre-format log are retained as source evidence. Unknown approval times remain unknown; recording times identify this formatting pass. The small changes to the standard and design template do not complete their full rewrite.

Verification is recorded under /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/decision-record-format/verification.json. Publication and the full content review remain open.


## 9. Workstation architecture and planner roadmap

The architecture now separates goals, constraints, context, strategy, components, runtime behavior, deployment, shared concepts, decisions, quality, risks and glossary. The roadmap owns delivery sequencing and acceptance. Its prior review/transition narrative is retained in the rewrite plan and exact source snapshot.

Thirty of the original 51 inputs now have a first-pass disposition. The two workstation originals are preserved, all 50 prior heading targets remain, and the eight diagrams retain their structure. The component diagram's lifecycle label names the intended DevLore ownership. These are documentation checks, not a deployed-host or editor demonstration.

| Source concern | Destination | Review boundary |
| --- | --- | --- |
| Problem, human direction and R1–R10 | Architecture sections 1–2 | Requirements retained; no numerical acceptance promises invented |
| External owners and service responsibilities | Architecture sections 3–5 | Existing Epic/Feature ownership retained |
| Schedule environment, five roles, server/session distinction | Architecture sections 4–5 and 8.1 | Shared servers manage native execution; additional views do not create roles |
| Driver creation, history/input/approval capabilities and versions | Architecture section 5.2; roadmap 6.3 | Primary sources support foundations; actual paths remain qualification work |
| Independent editor backends and private guest profiles | Architecture section 5.3 and workflow | All device input/clipboard/reconnect obligations retained |
| Archive placement, PostgreSQL preference, originals, authorization and gaps | Architecture section 5.4 | Spool engine remains open; preference for one stack retained |
| Design before scheduling, planner handoff and iterative role work | Architecture section 6.1; roadmap sections 1 and 7 | No artificial Schedule prerequisite or new issue type |
| Compaction, checkpoints and reading | Architecture 6.1.4 and 8.3 | Supported hooks distinguished from crashes and missing capture |
| State dimensions, durable operations and eight startup combinations | Architecture sections 6.2–6.4 | Unknown outcomes retain identity and require reconciliation |
| I1–I7 and scoped shutdown/recovery/configuration | Architecture sections 6.4–6.9; roadmap 6.2 | Actor/actions/results retained, including refusal paths |
| Private workspaces, immutable review inputs and exact candidate evidence | Architecture section 8.2; A2/A3 | Independent review and closing-review authority retained |
| Native restoration and approved/fenced succession | Architecture 8.4; roadmap S6/S8 | Same-session recovery and evidence reconstruction stay distinct |
| Mac mini/Minisforum placement and shared logging | Architecture section 7; D5 | Existing hardware only, capacity/support unqualified |
| D1–D6 and reasons for significant choices | Decision companion; architecture sections 9/11; roadmap section 8 | Three explicit approvals retained; other choices remain proposed |
| G0–G6, useful increments, Feature dependencies and optional inference | Roadmap sections 2–5 | No dates, new commitments or claims of deployed capability |
| S1–S8, concrete recovery beats and host capability matrix | Roadmap section 6 | Persistent Scenario records distinguished from Schedule steps |
| Runtime bindings, reading/evidence/check receipts and lifecycle | Roadmap section 7 | Contract fields and owners retained |
| Transition history and earlier revision/review statements | Rewrite plan 7.13.1 and completed source plan | Removed from the active system explanation |

The focused check record is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/workstation-rewrite/verification.json. Full requirement-preservation, writing/arc42 and methodology/tooling reviews remain open, as do the repository gate, publication, CI and Owner acceptance.


## 10. Core handbook guidance

Thirty-five of the original 51 inputs now have a first-pass disposition. The index supplies audience, authority, reading paths and revision links; the process owns progression/approval; work organization owns commitments; work assets owns required records; agent operation owns agent duties. Historical cases remain available through preserved source evidence.

| Source requirement | Maintained destination | Preservation or correction |
| --- | --- | --- |
| Everyone/all-agent/Owner-supervised applicability, local exceptions and personal signing scope | Index sections 1–2 | Separate applicability and authority retained |
| Four RACI responsibilities, engineer as Owner, independent review and participant judgment | Process section 2; agent operation section 1 | Observer and Reviewer meanings retained |
| Work philosophy and expected schedule change | Process section 1 | Quotation preserved verbatim |
| Issue, worktree, committed plan, Owner review and explicit start | Process sections 3–5 | Plan approval remains separate from command authority |
| Routine discretion, departures and contemporaneous records | Process section 5 | No approval inferred from activity |
| Evidence identity, installed path, deployment and actual operation | Process section 6; work assets section 4 | Scratch/dry-run versus live behavior distinguished |
| One active PR per worktree and retained personal override | Process section 7; index section 5 | Override kept effective; dated path observation moved to the plan |
| Closing references, reopening failures and post-merge records | Process section 8 | Later Owner rule retained; lightweight CI path not claimed implemented |
| Completion-only follow-ups, progression approval and stop conditions | Process section 8 | No recursive delivery obligation added |
| Blocked work, retirement and cleanup | Process section 9; work assets section 5 | Recovery/evidence obligations retained |
| Design/plan/Schedule distinction, paths, document tables and plan-link results | Work assets sections 1–4 | Stable issue headings, default/merge links and dropped-row reporting retained |
| Layer projects, platform-specific scripts and branch types | Work assets sections 2/6 | No file move or native tool change |
| Schedule/Scenario identities, Beat/Step, one-Schedule membership and field authority | Work organization sections 1–3 | Current supported commands retained |
| Scope amendments, transfer records, cross-account stand-ins and blockers | Work organization sections 3–5 | Owner approval and readback retained |
| Role resources versus host/runtime qualification | Work organization section 6; index section 3 | Shared role assets referenced without claiming qualified native loading |
| Startup/compaction reading, actual errors and contradictions | Agent operation section 2 | Existing refresh boundary retained |
| Compliance auditor, no breach narratives/costs, destination/patterns | Agent operation section 2.1 | Policy retained without treating planned storage as delivered |
| Published prose, original intent and settled decisions | Agent operation section 3 | Inquiry/proposal/approval linked to the decision standard |
| Codex comment provenance and separate PR disclosure | Agent operation section 3.1 | Full rule preserved verbatim |
| Assignments, delegation, visibility and bounded conversations | Agent operation sections 4–6 | Owner oversight and conversation approval retained |
| Bounded Git grant, one-run exact-command fallback and separate clone/PR execution | Agent operation section 7 | Clarified the exact-command grant's one-run limit without shrinking a bounded grant |
| Schedule/Scenario reads, report/sweep, supported commands and installed-build safety | Agent operation section 8; common commandments | Commit-pinned pointer replaced with same-revision relative link |

Candidate M03 for the remaining review: startup/post-compaction reading and assignment resource revision are specified, but notification and adoption of a handbook change by an already-running session have no complete contract. This pass preserves those requirements and does not invent a refresh policy. The Owner's request for research or a question does not supply a policy decision.

The source-preservation and focused-check record is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/core-handbook-rewrite/verification.json. Full writing, requirement-preservation and methodology/tooling review remain open.


## 11. Shared resources and retained evidence

Forty-three of the original 51 inputs now have a first-pass disposition. The README describes actual repository assets and current CI, the documentation index routes readers, and the PR procedure follows the Owner's publish/check → review/merge in GitHub → observed-delivery record.

The documentation standard retains its decision-record section verbatim while clarifying existing metadata rules and source layout. The design template covers arc42 concerns, role assignments and decision/delivery references. The Schedule guide consumes the account form and uses delivered open/create spelling; it preserves project-owned Steps and literal form labels.

The completed adoption record keeps its findings and dated evidence. O01–O11 are an evidence index into exact original responses and current requirements, avoiding competing active summaries. Decisions 60/61 record later explicit approvals from the 2026-11-19 source plan; all earlier record bodies and metadata are unchanged.

| Source concern | Check or disposition |
| --- | --- |
| PR authority, explicit staging, actual checks/head, no rebase, human merge and trailers | Retained in the PR procedure; current source-plan contract used |
| Time-open, guarded post-merge issue records, cleanup and separate clone authority | Retained; no script run or merge claimed |
| Metadata families and optional status | Compared with Test-Frontmatter.sh and existing vocabularies |
| Prose layout, exemptions, type scope, document links and immutable evidence | Retained in the documentation standard |
| Decision-format fields and attribution precision | Canonical section unchanged; later approval dates retained without invented times |
| Arc42 concerns and roles, significant choices and plans | Design template; incoming anchors retained |
| Schedule form, creation flags, Steps, amendments, approval and document table | Guide checked against extension.yaml, github-schedule-open.star and making.star |
| Repository command surface and CI | Compared with extension manifest and workflow source |
| F01–F21 and adoption metrics/hashes/merge/closure | Recorded evidence retained without asserting fresh live checks |
| Original Owner responses and evolving O03/O11 semantics | Exact source preserved; current policy/command links replace stale summaries |

M04 is corrected in maintained guidance: schedule creation still used the retired new spelling in work organization and the Schedule guide. The delivered manifest/implementation expose open and create. Historical plans and original snapshots keep their source wording.

Candidate M05 for the remaining review: the frontmatter checker's opening comment says every document requires type, while its REQUIRED_ALWAYS/REQUIRED_CATALOG logic and the standard make type conditional on catalog family. Runtime behavior is consistent with the standard; the source comment is misleading and remains separate from this documentation-only pass.

The focused receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/handbook-resources-rewrite/verification.json. The remaining eight input dispositions, full content/consistency review, tooling findings, repository gate and publication remain open.


## 12. Reporting skill and Git reference guides

Forty-six of the original 51 inputs now have a first-pass disposition. The reporting skill uses command-selection and task sections, preserves one-call ordering and assignment lookup, and makes the installed BASE-to-develop HEAD comparison explicit. It retains the required title metadata and does not claim native Codex qualification.

The branch guide separates the approved protection/signing policy from dated GitHub observations, preserves baseline and complete platform/installer requirements, and explains organization/repository composition. It corrects the claim that GitHub can only declare organization-wide contexts: this constraint comes from our baseline's shared target set.

The PR-script guide keeps thirteen rule numbers and all eight PowerShell requirements. Its five executable examples are byte-identical to the input. Owner review/merge, actual published-head checks, plan-link records, progress and post-merge evidence remain explicit. Original incidents and chronology are preserved as evidence.

| Finding | Evidence and disposition |
| --- | --- |
| M06: packaging validator rejects title | The skill-creator quick_validate.py reports title as an unexpected frontmatter key. Repository Markdown requires title. Preserve it; native Codex packaging/loader qualification remains with Codex consumption (#563). A packaging-tool failure is not evidence of native-loader failure |
| M07: trailer check can read another worker's merge | Both PR examples use git log --max-count=1 --format=%B without this PR's recorded full mergeCommit.oid after cleanup/sync. Owner approved qualifying that lookup with the full recorded ID on 2026-11-20; both examples are corrected. Opposite target/merge trailer states are verified under the [approved correction](#18-approved-dispositions-and-corrections) |
| Signing scope | Decisions 34/35 require main/release signing and exempt personal repositories; the older main-only source observation is not full enforcement evidence |
| Tool build provenance | BASE is the installed commit; HEAD is develop. A clean ancestor can still lack the required interface. Dirty/unknown/unmerged builds stay read-only and another session's build is preserved |
| Script authority and progress | Human merge, separate execution/clone authority, named staging, guarded row writes, closing versus partial references and retained post-merge obligations remain required |

The skill-creator guidance used is /Users/david-noble/.Codex/skills/.system/skill-creator/SKILL.md; its instruction is to validate the completed skill with scripts/quick_validate.py. That packaging check fails on title and is recorded as a qualification gap. Repository-format, source-preservation, prose, links and spelling checks are separate.

The focused receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/handbook-final-guides/verification.json. Five input dispositions, full content reviews, Owner tooling decisions, the repository gate and publication remain outstanding.


## 13. Issue-standard source map and substantive findings

Forty-seven of the 51 inputs have a first-pass disposition. The completed consolidation plan is unchanged at its inventory hash, 90b4d6c8db2733646b1e8fdf86a8876db1eed73a6ecb3261bd34b3ce1f75669b. The issue-standard candidate is prepared in scratch and remains outside that count until its pending membership clause is settled.

| Source requirements | Candidate section |
| --- | --- |
| Six Types, parent levels, mutual exclusion, native links and account stand-ins | 1 |
| Empty Epic/Feature meanings and Feature audit/code-review/team-lead closure | 1.1 |
| Area meaning, released engineering products, internal work and parent/child direction | 2 |
| Scenario Engineering Area, Schedule deliverable Area and release-note selection | 2 |
| Attribute values, single-select label families, dates and unused Start date | 2.1 |
| Severity harm values, N/A, untyped issues and intake defaults | 2.2 |
| Resolution on closed work, completed close reason and participating repositories | 2.3 |
| Type/attribute label requirements, non-Type labels and good first issue restriction | 2.3 |
| Hierarchy versus collections, four projects, templates and visible fields | 3 |
| Organizing issues versus leaf rows and Epics/Features retained in Backlog | 3 |
| Intake exceptions, shared workflow resources, Area copying and Severity initialization | 3.1 |
| Classification, accepted/declined disposition and Triage-row removal | 3.2 |
| Movement, reason/amendments, placement flags and team accountability | 3.3 |
| Scenario purpose, goal/walk/Features, Beat, findings, origin, movement and retirement | 4 |
| Schedule promise/criteria, own row, consecutive Steps, renumbering and commitment | 5 |
| Iteration, Worktree, Status, dependencies and supported read routes | 5 |
| Completion evidence, document references and Scenario exception | 6 |
| Classification checks, exemptions, sweep effects and deployment limits | 6.1 |
| Issue/collection/model commands, explicit account, pruning and new-project defaults | 6.2 |
| Account backup/files, intake provisioning and secret source references | 6.2 |
| Team/collaborator grants, mutation roles, cross-repository access and uncertainties | 7 |
| Original permission matrix, history and source evidence | 8 and exact snapshot |

### 13.1. M08: Triage and home membership

The standard's placement and classification passages prohibit more than one managed project including Triage, while its Triage section explicitly permits a Triage row beside one home. github-triage-sweep.star checks multiple home rows, returns only the two structural checks for Scenario rows, and adds Triage without removing any existing row.

The earlier first-pass hierarchy/collection prose and a hierarchy decision summary repeat the broader restriction. These drafts need correction after the Owner rules. The issue-standard candidate identifies the unsettled clause rather than creating an implicit decision.

David Noble approved at most one home among Backlog, Schedule and Scenario, with Triage allowed beside that home for a fault awaiting a decision, on 2026-11-20. The [current correction](#18-approved-dispositions-and-corrections) aligns the maintained standard and architecture; the superseded one-project rule remains identified in its decision record.

### 13.2. M09: User-account capability claims

[Managing issue fields](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-fields) describes user-account field management. The [User GraphQL reference](https://docs.github.com/en/graphql/reference/users) lists issueFields and issueTypes. A read-only live schema query confirmed both names.

An account-level query using this session's credential returned null and FORBIDDEN for both connections: David-Noble-at-work does not have permission to retrieve issueType information; the corresponding issueField request was also refused. The first sandboxed schema request failed to connect; the escalated schema read succeeded. No credential, grant, field, type or label was changed.

The model implementation reads organization fields/types through read_organization; its user-account path retains the supported label representation. Documentation should describe that profile without asserting that GitHub's User schema lacks these capabilities. Adoption, entitlement and access qualification are separate questions; a schema field's existence alone proves none of them.

### 13.3. Candidate and next review

The prepared candidate is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/rewrite-first-pass/pending-issue-standard/issue-standards.md. It is checked as a proposed replacement against retained local references, metadata and paragraph/table layout, with all eighteen incoming heading targets preserved. The maintained issue standard remains unchanged.

The four remaining input dispositions are the issue-standard replacement, model publication chapter and its status record, and the final active-plan disposition. Full writing/arc42, requirement and consistency reviews remain open. The focused receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/issue-standard-review/verification.json.


## 14. Model-command publication decision and first pass

Forty-nine of the 51 inputs now have a first-pass disposition. The two remaining inputs are the issue-standard replacement awaiting membership decision M08, and the active plan's final disposition. Full content/consistency reviews remain open.

David Noble approved model-command PRs stopping for his review and merge in GitHub on 2026-11-19. The shared PR procedure is the authoritative policy home; decision 62 records the approval and considered automatic-merge alternative. This resolves the M02 policy choice without claiming implementation alignment.

The model chapter describes live reads, records and references; the five commands; attribute comparison; identity-preserving reconciliation; pruning limits; account files/settings; publication and human review; recovery limits; access/secrets; quality and sandbox qualification. Six structured model decision records preserve established choices and source precision. The delivery reference preserves the original chronology and exposes actual tooling gaps.

| Source concern | Maintained disposition |
| --- | --- |
| Live authority, explicit account, invocation reads and no cache | Chapter 1 |
| Model schema, excluded work data, type levels/order and IDs | Chapter 1.1 |
| Command signatures, results, read-only diff, dry-run/stdin limits | Chapter 2 |
| Account-kind references, colors, common views, files_from and copy descriptions | Chapter 3 |
| All-attribute differences, explicit null, errors and manual steps | Chapter 4 |
| Renames, option IDs, template/project configuration and retained execution data | Chapter 5 |
| Existing-resource pruning versus new-project defaults; never deleting projects/teams/templates | Chapter 5.1 |
| Shared-file/workflow PRs, variable, squash settings and secrets | Chapter 5.2 |
| Deterministic backup comparison, pending PR, head/check proof and Owner merge | Chapter 6 |
| Separate configuration writes, no implied rollback, observed merge/content/trailers and cleanup authority | Chapter 6 |
| Restore targets, scope, irrecoverable assignments/rows and later ID backup | Chapter 7 |
| Authentication failures, scopes, secret source/permissions and limited digest receipt | Chapter 8 |
| Run-specific organization/user sandbox proofs, qualification and operational risks | Chapter 9 |
| Significant choices, exact originals, plans and delivery status | Companion and chapter 10 |

M01 remains an implementation gap: disclose() still supplies a literal Claude Code assistance value. M02's policy is settled, while land() still automatically merges and backup's post-call path assumes merged delivery. The source hashes are recorded; no executable file was changed or model operation run.

Candidate M10: _required() returns an empty list whenever its rules request contains HTTP 403 and the repository is private. It does not establish account kind, plan or the reason for refusal. An unreadable configuration is not evidence of no required checks. The aligned workflow must preserve the verified-policy condition and stop on uncertain requirements, as shared PR policy already requires.

Current source publication is not qualified under the new contract. Separately planned runtime work must cover callers and result/resume behavior, rather than merely remove a merge call. The architecture supplies the target and the delivery reference supplies this implementation limit.

The focused receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/model-publication-rewrite/verification.json. M07 and M08 remain pending; this approval supplies no answer to either.


## 15. Publication for independent review

The Owner directed immediate commit/push of the complete current work on 2026-11-19 and requested an independent code-review prompt. The review candidate includes the [issue-standard proposal](proposals/issue-standard.md); the maintained standard is unchanged and M08 is not resolved by publication.

The published set is a request for substantive review. First-pass coverage remains 49 of 51, and independent/content reviews, M07/M08 decisions and final acceptance remain outstanding. Reusable writing/architecture publication and the broader role contract retain their separate issues; this PR does not claim to complete them.

The two whitespace findings from git diff --check were corrected. The publication run records make check, actual head, push and current-head CI separately; earlier passing checks do not qualify this candidate. No executable model helper or PR example behavior was changed, and no issue is closed by this review checkpoint.

The staged publication candidate passed make check. Maintained changes pass git diff --cached --check; the exact handbook-review-responses.md.txt and pull-request-procedure.md.txt snapshots retain three inherited whitespace findings. Their original hashes remain unchanged. These are preserved evidence under the documentation standard, not newly formatted maintained prose.


## 16. Integrate PR #612

The Owner approved integration after publication of the 128-file candidate at 76a6d91. Target 2da34a13440277126901537323f5ac1556f6cee1 delivers issue close/reopen recovery and removes unique. All incoming executable files, tests and source plans are retained exactly.

The issue-command chapter now distinguishes new creation from supported partial close/reopen recovery, documents history-based comment checks, Resolution reconciliation, row repair and containing-Schedule recovery, and keeps concurrent-writer and separate creation/move limits explicit. The Schedule chapter distinguishes repair through issue reopen from standalone collection shortcuts.

The automatically merged D-013/D-014 records and partial D-009 consequence replacement are retained. Nine upstream numbered heading targets are added alongside the earlier preserved links. The manifest records the incoming revision and thirteen source hashes; original archived sources remain unchanged.

The integrated gate and published review head are recorded separately. This merge does not resolve M07 or M08 or claim all issue/role deliverables complete.

The integrated make check passed, including the issue-recovery regression cases. The remaining Scenario reference to issue-open duplicate detection was corrected. Current metadata, spelling, links and source-preservation checks also pass. Upstream code, tests and source plans remain byte-identical to PR #612.

## 17. Independent review of e3e4002

The [independent review](https://github.com/NobleFactor/noblefactor-engprod/pull/596#pullrequestreview-5989025310) covers e3e40022c49012f59b91a4cdb8993f6bebaf6596, including Recovery in PR #612, and requests changes. It reports one High, six Medium and two Low findings. All four CI checks passed for that reviewed head; they do not qualify subsequent corrections.

| Finding | Disposition |
| --- | --- |
| [R01 High: Triage/home membership](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687508) | Owner approved the Triage fault row beside one home on 2026-11-20. The maintained standard and architecture are aligned; HIERARCHY-006 records the decision |
| [R02 Medium: decision provenance](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687524) | Local correction adds ordered YAML footers to 68 records in twelve companions; locally verified. Existing IDs, substance and approval evidence are retained, with unknown attribution/dates null |
| [R03 Medium: landed-trailer lookup](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687534) | Owner approved the correction on 2026-11-20. Both examples use the full recorded merge commit ID; fixture verification is recorded below |
| [R04 Medium: Triage-to-Backlog move](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687547) | Proposal corrected to match move source and regression cases 146–148; locally verified |
| [R05 Medium: asynchronous placement](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687560) | Hierarchy distinguishes issue metadata writes from the separately executed intake workflow and row verification; locally verified |
| [R06 Medium: User-field capabilities](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687577) | Command decisions and maintained standard describe our supported label profile and preserve original evidence. Native access/adoption/command qualification is not claimed; locally verified |
| [R07 Medium: draft-review gate](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687585) | Owner explicitly approved non-draft review on 2026-11-20; plan section 7.22 records the exception and every remaining merge gate |
| [R08 Low: Scenario cleanup](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687597) | Handbook limits remaining cleanup to closure outside the issue command and links the authoritative procedure; locally verified |
| [R09 Low: duplicate session-model tail](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4639687617) | Duplicate table/wake prose removed; unique exit/Remote Control details already remain in the lifecycle section. Pandoc renders three tables and the expected section flow |

The original source snapshots remain exact. The earlier R06 factual correction was published at bfec2fc; the subsequent Owner-approved membership correction permits replacing the maintained standard with the corrected candidate. Recording accepted source contracts without a known approving person or date does not invent approval evidence. The preserved plans and command companions retain the approval records that are known.

Routine corrections implement the approved rewrite. David Noble explicitly approved the dispositions for R01, R03 and R07 on 2026-11-20, before their dependent changes. Independent re-review and Owner acceptance remain required; no finding is closed by this local draft, and the PR is not ready to merge.

Focused validation passes for these six corrections, including YAML key order, source/body preservation, links, metadata, paragraph/table layout, spelling and whitespace. The rendered session-model page has three tables and all eight main sections in order. The maintained issue-standard replacement and the three Owner dispositions are recorded in section 18. Current-head CI and independent re-review are required after publication.

## 18. Approved dispositions and corrections

On 2026-11-20, David Noble approved the three proposed dispositions individually after their explanations. R01/M08 uses one Backlog, Schedule or Scenario home with a temporary Triage fault row; R03/M07 verifies landed trailers on this PR's full recorded merge commit ID; R07 permits PR #596 to remain non-draft for review. The [plan](../../plans/doc/581-schedule-command-consumers.md#722-approved-review-dispositions) records execution scope and the remaining merge gates.

The [maintained issue standard](../../issue-standards.md) replaces the proposal as the authoritative policy. Hierarchy, attributes, collections, workflow and issue-command context use the same membership meaning. HIERARCHY-006 records the reason and alternative; HIERARCHY-003 is explicitly superseded. Source evidence and established approvals remain preserved.

All 51 inputs now have a first-pass disposition, including the standard and active-plan maintenance. This count describes the rewrite pass; full content reviews, independent re-review, approved tooling-gap handling and Owner acceptance remain required. No issue is closed and no merge is authorized.

The Bash and PowerShell examples retain the full mergeCommit.oid from the confirmed delivery record, use it in git log after cleanup and name it on a trailer failure. The other three executable examples are unchanged. Local regression fixtures check the correct result when the target advances to a commit with the opposite trailer state and when the recorded commit is unavailable. The five examples pass syntax checks after placeholder substitution. Ten fixture checks pass using the exact template fragments, including the earlier behavior as a comparison; source and result hashes are retained in the execution evidence.

PR #596 may remain non-draft under the explicit review exception. It remains blocked from merge until the required findings, reviews, final-head CI and Owner acceptance are satisfied. The exception changes no branch protection or completion requirement.

### 18.1. Verification results

| Recorded PR commit | Later target commit | Corrected Bash and PowerShell result |
| --- | --- | --- |
| Both required trailers | Trailers absent | Accept the recorded commit; the previous lookup incorrectly rejected it |
| Trailers absent | Both required trailers | Refuse the recorded commit; the previous lookup incorrectly accepted it |
| Recorded object unavailable | A readable target tip | Refuse without falling back to the target tip |

Both opposite-state cases were run against corrected and previous fragments in both shells, plus the unavailable-object case in both shells: ten fixture checks. Bash syntax and the PowerShell parser also accept all five filled examples. The installed Bash and pwsh executed the checks locally; native Windows CI and actual post-merge cleanup are separate evidence.

Metadata, spelling, whitespace, paragraph/table layout, 913 local references, 522 old anchors and exact source checks pass. All 148 structured decision records validate, with explicit reciprocal supersession for the membership decision. The maintained standard's rendered placeholders remain visible. The new guide's SHA-256 is c91d5dba141d9e90c231542ead4238d6d0abe6d02bcbef1d750a1afd2b9071ab.

The complete fixture and verification records are under /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/approved-review-dispositions. Earlier checkpoint CI does not qualify the corrected head; required current-head CI, independent re-review and Owner acceptance remain outstanding.

## 19. Final content review and conflict dispositions

The [initial independent review](https://github.com/NobleFactor/noblefactor-engprod/pull/596#pullrequestreview-5989025310) covers the full rewrite at e3e4002. The [re-review](https://github.com/NobleFactor/noblefactor-engprod/pull/596#pullrequestreview-5996175389) covers the corrected material at 9d8f09d and retains the original review for unchanged material. It verifies R01–R09. The final author pass combines those reviews with the full-document source maps and draft reviews above, the command/test contracts and the targeted R10 correction. This assessment is separate from Owner acceptance.

### 19.1. Content assessment

| Inventory group | Inputs | Content reviewed and result |
| --- | --- | --- |
| Agent schedules | 9 | Conversation/view identity, launch/discovery/trust, interface and proposed assignment/SBX boundaries are separated. Owner source and native qualification limits are retained |
| Issue model | 21 | Hierarchy, attributes, placement, access, live definitions, commands and recovery use the delivered contracts. Significant choices have companions; transition/progress records remain with plans or retained references |
| Workstation and roadmap | 2 | Arc42 concerns, editor/host/session ownership, persistent roles, storage/evidence, recovery and planner handoff are explicit. Proposed capability remains qualified |
| Shared guidance, references and skill | 17 | Handbook authority, asset definitions, role reading, command routing, disclosure, document format, templates and Git procedure agree. Source layout, references and retained examples are checked |
| Execution plans | 2 | The accepted consolidation plan remains exact; the active plan owns approvals, history, progress, verification and remaining milestones |

The three architecture sets cover the applicable arc42 concerns through their overviews and linked chapters, as mapped in section 2. They retain reasons and alternatives for design choices without importing rollout narratives into system explanations. Maintained prose uses descriptive headings and direct language; old heading names remain only as stable anchors or explicitly retained evidence. The 51-document disposition table identifies every input.

### 19.2. Methodology and tooling scan

| Finding | Disposition and interim handling |
| --- | --- |
| M01: literal assistance identity | Runtime follow-up [Model publication (#614)](https://github.com/NobleFactor/noblefactor-engprod/issues/614). The current helper is not a compliant publication path; use the approved ordinary PR procedure |
| M02: automatic model-PR merge | Owner policy is settled by decision 62. Task #614 covers helper/callers, pending/retry behavior and post-merge records. Use model get/diff for read-only inspection; do not treat the current helper's automatic merge as authorized |
| M03: adoption of revised context by running agents | The unresolved question is handed off on [Shared context (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558). Existing startup/compaction and source/version requirements remain; no automatic refresh or new loading policy is claimed. Host tasks #562/#563 qualify their supported paths |
| M04: retired creation spelling | Corrected to open/create in maintained guidance; exact historical sources remain unchanged |
| M05: frontmatter-checker comment | Corrected to require title for all nonexempt documents and type for catalog documents. The executable body is byte-identical; separate checker replacement (#231) is not implemented here |
| M06: repository/native skill schema difference | Already recorded concretely in [Skills curation (#560)](https://github.com/NobleFactor/noblefactor-engprod/issues/560); [Codex consumption (#563)](https://github.com/NobleFactor/noblefactor-engprod/issues/563) owns native loading qualification. Repository title metadata is retained; no validator or loader success is invented |
| M07: wrong commit for trailer verification | Owner-approved correction uses the recorded full merge OID in both examples; the independent reviewer replayed all ten checks. The guide hash remains unchanged by R10 |
| M08: conflicting membership rules | Owner-approved one-home/Triage rule is maintained in the issue standard and HIERARCHY-006; the earlier rule is explicitly superseded |
| M09: categorical User capability claims | Corrected to the supported label profile. Native adoption/access remain unqualified; a refused account query proves no platform prohibition |
| M10: private-rules 403 accepted as no checks | Included in Task #614. Unreadable requirements cannot establish a no-check policy; stop that publication path rather than infer permission |

Task #614 was filed through star github issue open under Issue tooling (#332). Readback verifies Task, Product Area, High Priority, N/A Severity, the Feature parent and Triage membership. It is a separate runtime follow-up; this PR implements none of its command changes. The M03 handoff records a question for the existing context contract, not a newly approved refresh mechanism.

### 19.3. Older review conversations

All 21 conversations from the earlier review have correction evidence at the published 9d8f09d head, individual attributed replies and resolved-state readback. The reply origin is the actual native session, Review noblefactor-engprod code, assigned Coder; the reviewer's separate #346 session is not reused. Resolving these conversations does not supply merge approval.

| Conversation | Verified evidence |
| --- | --- |
| [Review on docs/architecture/issue-data-model/1-hierarchy.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831220) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/1-hierarchy.md#3-intake-and-classification) |
| [Review on docs/architecture/issue-data-model/1-hierarchy.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831226) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/1-hierarchy.md#31-triage-decisions) |
| [Review on docs/architecture/issue-data-model/2-attributes.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831228) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/2-attributes.md#13-area) |
| [Review on docs/architecture/issue-data-model/3-collections.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831240) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/3-collections.md#1-project-kinds) |
| [Review on docs/architecture/issue-data-model/4-storage-and-reach.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831249) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/4-storage-and-reach.md#3-authoritative-locations) |
| [Review on docs/architecture/issue-data-model/4-storage-and-reach.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831256) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/4-storage-and-reach.md#2-account-representations) |
| [Review on docs/architecture/issue-data-model/index.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831260) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/9-the-scenario-commands.md#5-retire-and-reopen) |
| [Review on docs/architecture/issue-data-model/9-the-scenario-commands.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831266) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/9-the-scenario-commands.md#8-decisions-and-delivery-references) |
| [Review on docs/architecture/issue-data-model/9-the-scenario-commands.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831274) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/issue-data-model/9-the-scenario-commands.md#6-maintain-finding-rows) |
| [Review on docs/architecture/agent-schedule/2-command-line.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831281) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/agent-schedule/2-command-line.md#1-select-a-conversation) |
| [Review on docs/architecture/agent-schedule/2.1-agent-schedule-commands.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831285) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/architecture/agent-schedule/2.1-agent-schedule-commands.md#2-start-an-assignment) |
| [Review on README.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831292) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/README.md#deployed-layer) |
| [Review on docs/templates/schedule.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831298) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/templates/schedule.md#2-deliverable) |
| [Review on docs/engineering/work-organization.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831301) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/engineering/work-organization.md#3-changing-scheduled-work) |
| [Review on docs/engineering/review/open-decisions.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831306) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/engineering/review/open-decisions.md#o11--changing-the-shape-of-work) |
| [Review on docs/roadmaps/agentic-developer-workstation.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831311) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/roadmaps/agentic-developer-workstation.md#7-planner-handoff-and-cross-epic-contracts) |
| [Review on docs/engineering/agent-operation.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831316) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/engineering/agent-operation.md#all-agents-tools-and-status) |
| [Review on docs/issue-standards.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831319) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/issue-standards.md#62-supported-operations) |
| [Review on docs/plans/doc/581-schedule-command-consumers.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831323) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/plans/doc/581-schedule-command-consumers.md#77-complete-document-inventory) |
| [Review on docs/plans/doc/581-schedule-command-consumers.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831331) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/plans/doc/581-schedule-command-consumers.md#76-rewrite-method-and-evidence) |
| [Review on docs/plans/doc/581-schedule-command-consumers.md](https://github.com/NobleFactor/noblefactor-engprod/pull/596#discussion_r4623831339) | [Published correction](https://github.com/NobleFactor/noblefactor-engprod/blob/9d8f09df1639c45595b4f2a2a5e88d7952fd23a4/docs/engineering/review/rewrite-review.md#181-verification-results) |

### 19.4. R10 and remaining gates

R10 corrects the maintained standard, hierarchy and collections: issue close removes Triage rows; GitHub UI or PR closing references can leave a row for triage disposition or supported recovery. The issue-close row contract and deletion path support this distinction. No cleanup automation or membership rule is changed. R10 remains open for the independent reviewer's recheck after publication.

At the reviewed 9d8f09d head, [all four CI jobs pass](https://github.com/NobleFactor/noblefactor-engprod/actions/runs/44772990693). That evidence does not qualify the new correction head. Current source/anchor/metadata checks, 148 decision records and the unchanged trailer-example hash are verified separately. The checker comment changes no executable behavior.

New durable records use /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/final-review. The meaningful results are also recorded here and in the PR, so reviewers need not read historical random-suffix scratch receipts. Final-head CI, R10 recheck and Owner acceptance remain. Merge, deployed-content verification, issue/Schedule updates and cleanup keep their separate authority and evidence requirements.
