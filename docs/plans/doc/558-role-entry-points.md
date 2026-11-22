---
title: "Shared context and five specialist roles"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/558
status: active
created: 2026-11-18
updated: 2026-11-21
documents:
  - kind: Design
    path: docs/architecture/agentic-developer-workstation.md
    text: "Agentic developer workstation"
  - kind: Handbook
    path: docs/engineering/index.md
    text: "Engineering handbook"
  - kind: Context contract
    path: docs/engineering/agents/context.md
  - kind: Assignment example
    path: docs/templates/agent-context.md
  - kind: Design schedule template
    path: docs/templates/design-schedule.md
  - kind: Starter skill
    path: skills/start-design-schedule/SKILL.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/551
    text: "Handbook adoption"
  - kind: Owner-provided source
    path: docs/engineering/review/sources/role-context-2026-11-20/owner-direction.txt
    text: "Owner input, proposal and direction on 2026-11-20–21"
---

# Shared context and five specialist roles

<a id="1-roles-and-authority"></a>

## 1. Role assignments

Owner: David Noble. Participant: this Codex session. The Owner appoints reviewers and the compliance auditor. This plan does not authorize cross-session contact, delegation, Git execution by the agent or changes to live host instructions.

<a id="2-promised-result"></a>

## 2. Summary and promised result

Finish the shared context contract and the five specialist roles: designer, planner, coder, reviewer, and compliance auditor. Preserve the small common commandments and role entry points, and make their assignment, applicable reading, source and version evidence, authority, and handoffs explicit.

Define the existing Compliance auditor's checks, their scope, and their triggers. Keep roles independent of host and model preferences. Retain Claude and Codex qualification as this Schedule's runtime scope. Shared-skill publication, additional host qualification, model deployment, and the five-native-agent exercise remain separately owned.

## Issue 558

[Shared context and five roles (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558) owns the complete contract and role definitions. This slice completes the contract beyond the entry points delivered in PR #601.

## 3. Current state

David Noble accepted and merged the common commandments and five role entry points in [PR #601](https://github.com/NobleFactor/noblefactor-engprod/pull/601) as 967764ae13b015543a2d0667e907b0fd37283875 on 2026-11-19. Post-merge verification established all eight reviewed source hashes and 58 local references; the Owner-run completion script removed the worktree, sibling script, and branch. The source receipt is `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-entry-points/post-merge-verification.02un9gc3/completion-receipt.json`.

PR #601's published squash commit omitted the human sign-off and assistance trailers. The finding remains recorded in its PR and issue; the Coder left published history intact. That delivery completed the first entry-point slice, while #558 remains open for the broader context contract.

David Noble accepted the handbook rewrite in [PR #596](https://github.com/NobleFactor/noblefactor-engprod/pull/596) at 8aa77e7a513dbc7b68e9bb1a9fe0aa4cf68cc32e and merged it as 55dec2b044a2972f1037996c06d887a960d6c8ef on 2026-11-20. Its two issues and Schedule rows are Closed; installed-skill verification and cleanup passed. This checkpoint records its established completion facts in the existing plan.

On 2026-11-20, David Noble supplied Terminal-First Development Roles and its evidence companion and directed, “Let's run with that,” in response to the Coder's recommendation. That reply directed further work; it does not establish review of a committed amendment. The Coder published the amended plan in draft PR #616 at 20dd6b74f2fdf34bde50a257551e32ae82d24baa. The approved workstation design amendment followed at 0fb17badafebb03f8581252d9a2f2676bfa2818f. The later Owner direction to finish the assigned assets and produce completed issues is recorded in section 12; the completed contract is now included for review and acceptance.

The compliance audit of 0fb17badafebb03f8581252d9a2f2676bfa2818f identified incomplete policy and execution records. David Noble approved including the corrected handbook policy with the design amendment in PR #616 and an Owner-approved one-off audit path on 2026-11-20. These corrections publish the authoritative audit policy with the design, identify follow-up owners, and correct the records. Those earlier policy corrections did not complete the shared context contract or establish acceptance of a later revision.

## 4. Design impact

The shared contract refines the five persistent specialists in the [workstation design](../../architecture/agentic-developer-workstation.md), while preserving its distinction between role, host, primary conversation, and attachment. The new contract is a reference for reading, assignment, and handoffs, not a new host service. Distinguish specialist roles from the process's responsible, accountable, consulted, and informed (RACI) responsibilities: Owner, Reviewer, Participant, and Observer. A specialist Reviewer or Compliance auditor is an assignment of work, not a transfer of the Owner's accountability or automatic authority.

Keep enduring requirements, assignment data, and host-specific loading distinct. The Owner-approved [environment configuration](../../architecture/agentic-developer-workstation.md#environment-role-configuration) amendment states how role context, host and model choices, and one durable role binding fit together. Designs continue to describe the wanted system; this plan retains transition work, progress, and approval history. Bring any conflict with the accepted architecture or tooling to the Owner before changing the affected definition.

## 5. Proposed implementation

Preserve the delivered entry points, update the shared contract and policy in their authoritative homes, and keep the required reading small.

Immediate Owner-directed correction: state each role's deliverables explicitly; require design and roadmap issues on a design schedule; make the Designer deliver the design, its architecture decisions, and roadmap directly. Remove the conflicting requirement for a plan to write those assets. Update affected handbook, role, and workstation references in this PR. This focused correction does not wait for the remaining context schema, host cutovers, or walkthroughs.

### 5.1. Shared context contract

Publish `docs/engineering/agents/context.md` as the reference contract for the five roles. It identifies the engineering overview, common commandments, role material, applicable skills, assignment information, and source and version evidence. Requirements remain in their authoritative handbook sections; the contract links them rather than repeats the handbook. Preserve the 350-word common-page and 200-word role-page budgets.

Define a role independently of the host, model, daemon, primary conversation, and attachment. Repository exploration supports the roles that need it. The Designer covers system, API, and UI design; the Planner defines the transition route, issues, and proposed Schedule; the Coder implements the approved work and updates affected documentation; the Reviewer evaluates correctness and coherence; the Compliance auditor evaluates conformance to approved requirements, process, and authority. Documentation responsibility follows the asset and its owning role.

Add `docs/templates/agent-context.md` as a human-readable assignment example. Use a fenced YAML record with role, owner, repository, scope, parent, schedule, issue, plan, worktree, host, model, session, resources, authority, artifacts, and handoff. A Designer also records `roadmap_issue`; optional `parent.epic` records verified ancestry. Both examples use the same worktree and artifact-input mappings. The host records its name and version; model records provider, identifier, and family; session records native identity and the exact session name. Resources identify kind, source, revision, read_at, and state. Authority references the actual grants and approved exceptions. Artifacts identify input revisions and expected outputs. Explain required values, conditional values, and explicit unknowns. This is a documentation format; host configuration and runtime validation remain separately owned.

A Designer assignment records its approved design Schedule, design and roadmap issues, owning Epic and Feature in parent.issue and parent.type, and expected design, architecture decisions, and roadmap. It records an implementation plan as not applicable for producing those assets. A missing required Schedule is an assignment gap, not an excuse to create a plan for writing a design. Unavailable identity, model, or source evidence remains explicitly unknown, with its reason and the affected claim. A host name cannot prove model-family independence. Record the model used for the work or review and material changes of model against the affected artifacts.

Use the existing startup and post-compaction reading requirements. The record distinguishes a published resource from content actually read by a running session. Define how to report changed or unavailable sources and request missing assignment information. Additional automatic refresh or runtime loading behavior is not selected here. Host qualification must establish the actual behavior of the installed versions and working directories.

### 5.2. Compliance assessment

Update the existing compliance-auditing section of Agent operation as the authoritative policy home. Use Owner-requested audits now to gain experience. Defer the universal blocking gate until the Owner reviews observed accuracy and separately approves activation. A requested audit can follow successful pre-commit checks; that ordering does not require an audit on every commit. Cover every changed file and every other asset that might be affected, using the applicable approved plan, adopted standards, process, and authority.

Cover all assets: source code, tests, configuration, designs, plans, schedules, handbook and user documentation, examples, help text, completions, and man pages. Start with the changes and follow their effects through dependencies, interfaces, generated outputs, and descriptions. Check affected assets outside the diff as well. Apply the adopted Google guidance and relevant arc42 content to affected documents. Cite the applicable adopted requirement rather than treating every suggestion in an external guide as mandatory.

Each finding identifies severity, the applicable requirement and source revision, location, observed evidence, consequence, requested correction, disposition, and verification needed. Distinguish a violation, missing evidence, and a recommendation. Mandatory findings require an applicable adopted rule and direct evidence; recommendations and missing evidence are not proven violations. Existing requirements and approval boundaries remain binding, while model findings do not create a new automatic gate. Missing evidence cannot be recorded as a verified pass. The Owner retains decision authority and receives unresolved findings and verification limits.

Deterministic tools establish mechanical facts such as formatting, spelling, metadata, schemas, and test results within their coverage. The auditor uses their output and focuses judgment on context-dependent obligations, affected assets, and consistency. A model assertion does not replace a mechanical check.

Evaluate on-demand audits before proposing universal blocking. Record confirmed findings, false positives, and independently known missed defects against the reviewed cases; include limitations and how findings were verified. The promotion criterion is observed accuracy with a low false-positive rate. The Owner must approve acceptance criteria and activation; no numerical threshold or automatic promotion is selected here.

Keep technical review and compliance audit distinct. Require an agent conducting the compliance audit to use a different model family from every builder, and state that rule directly in Agent operation's compliance-auditing section and repoint auditor.md to that authoritative home rather than depend on Issue #565 or the role page as a separate policy source. Recheck corrections against the changed artifact revision. Earlier approval does not establish review of later edits. If the assigned auditor helped build the candidate or its independence is unknown, require the Owner's approval for a one-off audit by an eligible third model family independent of every builder. The assignment covers one identified candidate and preserves the assigned auditor's session and role binding. Record its approval, scope, actual auditor and model, and results. An unavailable eligible auditor leaves the request unresolved. Update the existing review-comment template to support these fields and link the role pages to the authoritative policy.

Record David Noble's 2026-11-20 policy decision in the handbook decision log using its established structure and actual attribution. Do not add a required GitHub status check, change branch protection, automate merging, or mandate OpenCode as the auditor host.

<a id="521-scope-and-interim-operation-proposed-owner-disposition"></a>

#### 5.2.1. Audit triggers

Use one request contract for on-demand audits and a future commit trigger. On-demand audits run when the Owner requests them; the universal blocking trigger remains deferred. Give the auditor the changed files and their reviewed versions, the diff, the pre-commit results, the assignment, and the applicable requirements. The auditor follows the effects into other assets and records what it checked, its findings, and any missing evidence.

Future commit wiring, subject to a separate implementation plan and activation approval: run the existing pre-commit checks, then call the auditor locally before the pre-commit hook returns. The audit result must apply to the version being committed; changes after that check require another check. Describe how a failed or unavailable audit is reported and how the existing Owner exception authority applies. Do not silently treat an unavailable check as a pass.

Git's [hook reference](https://git-scm.com/docs/githooks#_pre_commit) supports this ordering within the pre-commit hook. The installed shared hook currently ends by handing control to a repository hook with exec; a call placed after that exec would never run. The hook driver must regain control after successful checks before it can invoke the auditor. Document the trigger contract here. [Continuous compliance and exact-snapshot commit gate (#519)](https://github.com/NobleFactor/noblefactor-engprod/issues/519) owns its implementation; the hook-wiring task linked in section 11 carries the bounded work and requires its own approved plan. This documentation checkpoint does not install or enable the trigger. Its implementation plan must preserve the deferred rollout until accuracy evidence and Owner approval support universal blocking.

A plan checkpoint checks the plan and the assets it affects. A completion-only follow-up checks its changed records and any affected assets against established results. Their changed content determines the work to inspect; neither requires pretending that future implementation has already been tested.

David Noble defined the scope and ordering in this Coder conversation and separately ruled in the Reviewer conversation on 2026-11-20: “Defer the universal blocking gate until later.” He would request audits when useful to gain experience. He then emphasized accuracy and directed that the proposed safeguards enter the plan. The [preserved Owner source](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) records those exact instructions. R05 therefore resolves to on-demand auditing now, adopted-rule evidence, mechanical verification by tools, and accuracy-based Owner approval before universal blocking. The earlier interpretation that auditing must block every change is withdrawn.

### 5.3. Host and model preferences

Retain Claude and Codex qualification as this Schedule's runtime scope and the existing OpenCode compatibility review. Treat the supplied Antigravity with Gemini and OpenCode recommendations as candidates; they do not enlarge this task into additional host qualification, local inference, Azure deployment, or hardware work. Shared definitions must permit an approved host and model choice without rewriting the role.

Keep `AGENTS.md` and any needed `CLAUDE.md` small and directed to shared resources. Instruction and skill discovery differ by host; host tasks qualify actual loading and refresh. The source review checked the official Codex, Claude, OpenCode, and Antigravity documentation on 2026-11-20. Those sources establish documented capabilities, not comparative performance, installed behavior, or a qualified deployment.

Use [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Claude instructions](https://code.claude.com/docs/en/memory), [OpenCode instructions](https://opencode.ai/docs/instructions/), and [OpenCode skills](https://opencode.ai/docs/skills/) as host-loading references. The supplied [Antigravity commands](https://antigravity.google/docs/cli/reference/) and [workspace search](https://antigravity.google/docs/cli/commands/codesearch/) inform candidate activities. Do not convert the supplied Azure model and deployment or data-handling claims into verified requirements.

### 5.4. Completion records

Incorporate the established PR #601 completion record into this plan. Keep its documented squash-trailer finding visible and do not rewrite published history. Incorporate PR #596's established final review, merge, issue and Schedule closure, installed-skill verification, and cleanup into its existing plan. These documentation-only records create no further delivery milestone.

### 5.5. Environment configuration design amendment

Update the workstation design and its decision companion with shared policy, per-environment role configuration, one authoritative native-session binding for each role within an environment, actual-model audit independence, and audit routing. External reviews belong on the PR introducing the changes; keep saved copies outside Git. Preserve existing anchors and update the components diagram and affected workflow and quality descriptions. [Developer control and schedule continuity (#517)](https://github.com/NobleFactor/noblefactor-engprod/issues/517) owns the configuration delivery plan and control-plane implementation. [Agent hosts (#459)](https://github.com/NobleFactor/noblefactor-engprod/issues/459) owns native-host application. These live Features need their own implementation plans; the completed #521 baseline plan is not their delivery plan.

### 5.6. Common design-schedule Tasks and starter skill

Publish `docs/templates/design-schedule.md` as a content guide demonstrating the design and architecture decisions Task and roadmap Task. Account forms retain their field labels. Link the guide from the generic Schedule and issue templates, design-schedule policy, and role entry points. Keep the Designer start rule and evidence requirements consistent.

Publish one host-neutral skill at `skills/start-design-schedule/SKILL.md`. It reads the template, resolves the related Epic, reuses or creates the design enabler Feature, resolves the Schedule and two Tasks, and uses `schedule open`, `issue open`, and `issue move`. It verifies Epic → Feature → Task native links and Task placement before handing the approved assignment to the Designer. It does not create a plan for writing the design, automatically reassign an agent, duplicate uncertain filings, or manufacture dependencies. No new runtime helper or host installation is included.

The new skill uses native name, description, and metadata frontmatter. Include one explicit `.github/frontmatter-exempt` entry for this file and validate it with the native skill validator. This file-specific exception is proposed for Owner review with this PR, not a resolution of #560's broader format and catalog work. Existing skills remain unchanged. Claude and Codex discovery and loading remain with #562/#563; the published source can be read directly by either host.

Validate source links, metadata, word budgets, and the skill schema. Walk the setup using Evidence Archive design Schedule #619 as a read-only fixture, including an existing Schedule, missing Task, reused Tasks, and a lost creation response. Record author verification outside Git; independent review and audit stay on this PR. Do not create or move work on #619 as part of this authoring change.

### 5.7. Enabler-feature vocabulary and Epic hierarchy

Apply the Owner's enabler-feature terminology in PR #616. Keep the native Type Feature, Epic parent, and existing placement rules. Define the vocabulary in the issue standard and reference it from the handbook, hierarchy design, design-schedule template, and starter skill. Feature completion reviews its actual deliverables, including code when present, so a design enabler can complete against design assets without requiring future subsystem implementation.

The starter skill resolves the Epic, reuses or creates the design enabler Feature under it, and creates or reuses the two Tasks under that Feature. It places only the Tasks on the design Schedule, retaining the accepted Feature in Backlog. Preserve permissions, known issue identities, and other workers' assignments; no live hierarchy changes are made as part of authoring this skill.

<a id="6-alternatives-and-limits"></a>

## 6. Alternatives and challenges

Retain five specialist roles rather than turn every activity into a persistent role. Exploration, UI methods, and documentation techniques can support the role that owns the asset through shared skills. Keep the Designer's system description distinct from the Planner's transition work, even when one host performs both.

Use shared definitions with small host entry points rather than duplicate the handbook per host. Keep candidate host and model preferences separate from role requirements. Documentation of a capability does not establish comparative performance or actual context loading.

Keep the Reviewer and Compliance auditor distinct. The former evaluates correctness and coherence; the latter evaluates adopted requirements, process, and authority. Neither CI nor one assessment substitutes for the other, and the Owner retains acceptance and exception authority.

<a id="7-acceptance-and-evidence"></a>

## 7. Acceptance criteria and evidence

### 7.1. First-delivery evidence

PR #601 contains the six short resources and handbook navigation. Its first reviewed source had 275 common-page words and 139, 149, 141, 150, and 139 words for Designer, Planner, Coder, Reviewer, and Compliance auditor, respectively. Counts excluded metadata, link addresses, formatting markers, and numeric markers. These are counts for that delivered revision, not a claim about every later edit.

The first delivery's source map and author walkthrough used [devlore-cli dry-run provider work (#1170)](https://github.com/NobleFactor/devlore-cli/issues/1170). The fixture, findings, and dispositions are retained in `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-entry-points/resource-review.json`. The PR records passing Owner-run `make check`, final-head CI, and Owner acceptance.

The 2026-11-19 verification confirmed all eight reviewed hashes and 58 local references. The Owner-run completion verified cleanup at 01:10:37 UTC. Its receipt is named in section 3. This established source and reference delivery, not native context loading or five-agent execution.

### 7.2. Context-contract acceptance

The completion review evaluates these criteria against revision-specific evidence.

| Criterion | Observable result | Evidence and method | Environment or artifact |
| --- | --- | --- | --- |
| Roles and context are complete | Specialist roles are distinguished from Owner, Reviewer, Participant, and Observer RACI responsibilities; all five roles identify purpose, inputs, outputs, authority, escalation, handoffs, and reading; common and role pages retain their word budgets | Requirement map and role-by-role substantive review | PR #616 assets and the author evidence record |
| Assignment is explicit | The example covers the overview, common material, role material, skills, assignment, source revisions, and read evidence | Filled example against a real scheduled change, including a design schedule with separate design and roadmap issues | PR #616 assets and the author evidence record |
| Identity and independence are supported | Host, actual model family, native conversation, and exact session name remain distinct; unknowns prevent unsupported claims | Walkthrough with a changed or unknown model | PR #616 assets and the author evidence record |
| Mixed-builder audits can proceed independently | An Owner-approved one-off audit uses an eligible third model family while preserving the assigned auditor's session and binding; no eligible auditor leaves the request unresolved | Walkthrough with two builder families, an ineligible bound auditor, request-specific approval, and an unavailable-auditor case | PR #616 assets and the author evidence record |
| Audit covers all affected assets | The audit starts with every changed file and checks every other asset that might be affected, including designs, plans, help, completions, and man pages | Impact map, stale-documentation fixture, correction, and recheck | PR #616 assets and the author evidence record |
| Audit timing is clear | Owner-requested audits operate now; a future commit trigger follows successful pre-commit checks and identifies the exact candidate; universal blocking remains deferred | Trigger contract and rollout handoff, with no installation or activation claim | PR #616 assets and the author evidence record |
| Mandatory findings have evidence | Each finding cites an applicable adopted rule and direct evidence; external suggestions, unknowns, and recommendations remain distinct | Inapplicable-guide and missing-evidence walkthroughs | PR #616 assets and the author evidence record |
| Accuracy controls promotion | Confirmed findings, false positives, and independently known missed defects support an explicit Owner decision on criteria and activation | On-demand audit records and a later activation decision; no automatic promotion | PR #616 assets and the author evidence record |
| Evidence and judgment stay distinct | Deterministic tools establish mechanical facts; the auditor checks context-dependent obligations; passing CI does not hide a correctness defect | Tool output, reviewer and auditor walkthrough, and dispositions | PR #616 assets and the author evidence record |
| Publication differs from loading | Published but unread resources are not claimed as effective session context | Source and revision walkthrough with a changed resource | PR #616 assets and the author evidence record |
| Ownership is preserved | Shared requirements have one authoritative home and downstream tasks retain their scope | Link and requirement review and explicit task handoffs | PR #616 assets and the author evidence record |
| Completion is supported | Final checks, independent review, Owner acceptance, observed merge, and source verification are recorded | Published revision, CI, review, and delivery records | PR #616 assets and the author evidence record |

Use one real scheduled change as the main fixture, selecting and identifying it in the review record before the walkthrough. Include cases for stale documentation outside a diff, an unknown or inapplicable standard, a correctness defect despite passing checks, a material model change, a candidate with several builder model families and an ineligible auditor, and published context not shown to be read. These are document walkthroughs; the later five-native-agent exercise remains with #565.

Record source-to-requirement coverage and the author's walkthrough results in `docs/engineering/review/role-context-review.md`. Record external technical reviews, compliance findings, and corrective verification on the PR introducing the changes; keep local copies outside Git. Link the PR from the delivery record instead of committing external review text. Validate links, metadata, YAML, paragraph layout, and word budgets, then review whether the documents are complete and understandable. Syntax and formatting checks alone do not establish usability.

<a id="8-completion-milestones"></a>

## 8. Required completion milestones

These milestones distinguish implementation, acceptance, and delivery.

| Milestone | Required? | Expected evidence | State and result |
| --- | --- | --- | --- |
| First entry-point delivery | Yes | PR #601 acceptance, exact merge identity, source hashes, and cleanup receipt | Delivered and accepted in PR #601; its 2026-11-19 source and reference verification and cleanup are recorded in section 12 |
| Environment role configuration design | Yes | Architecture sections 5.5 and 6.10, with W6 and W7 and their approvals | Published in PR #616 at 0fb17badafebb03f8581252d9a2f2676bfa2818f; reviewed corrections remain subject to acceptance |
| Authoritative audit policy | Yes | Agent operation, auditor entry point, finding template, and decision 63 | Written in Agent operation with its role and template references and decision 63 in this correction; verification and independent re-review recorded in section 12 |
| Completed shared contract and role refinements | Yes | Context contract, structured assignment, role pages, and author evidence | Contract, assignment example, and author coverage record written; independent review and Owner acceptance pending |
| Current-head checks and independent review | Yes | Published head, named check conclusions, technical review, and compliance assessment | Pending; retain the repository's actual checks and separate review and audit findings |
| Owner acceptance and merge | Yes | Owner approval, observed merge identity, and landed trailers | Pending for this completion slice |
| Published-source and reference verification | Yes | Reviewed Git blob identities and valid references at the exact merge | Verify the merged resources and their references before claiming availability |
| Native host loading and daemon qualification | Separate tasks | Actual Claude and Codex host evidence from their separate qualification tasks | Owned by #562/#563 and the later exercise; no installed-host proof is claimed here |
| Issue and Schedule records and cleanup | Yes | Revision-specific delivery and verification evidence | Record observed results, use closing references only for completed issues, and preserve outstanding evidence before removing the worktree |

Apply the established completion-only documentation process to observed post-merge results. No additional delivery milestone is created by recording an already established result.

<a id="9-phases"></a>

## 9. Implementation phases

### 9.1. First delivery

- [x] Commit and publish the first plan; David Noble reviewed it and directed implementation on 2026-11-18.
- [x] Publish the six resources and handbook navigation with ownership and change-process metadata, source coverage, word counts, and the devlore-cli role read-through.
- [x] Pass the Owner-run repository check and final-head CI, obtain Owner acceptance, and merge PR #601 as 967764ae13b015543a2d0667e907b0fd37283875.
- [x] Verify all eight reviewed source hashes and 58 local references and clean up the worktree, script, and branch on 2026-11-19. Preserve the recorded missing-trailer finding.

### 9.2. Completion planning

- [x] Review the supplied Terminal-First Development Roles and evidence notes against the five-role contract and official host documentation.
- [x] Record David Noble's 2026-11-20 direction to proceed, retained runtime scope, and clarification of audit scope and timing.
- [x] Apply the Owner-approved workstation design amendment for environment role configuration and audit routing, with decision W6.
- [x] Record Owner approval to include the handbook policy in PR #616 and add the one-off independent audit path, preserving the assigned auditor's session and binding, with decision W7.
- [x] Commit and publish this amended plan and update its issue and Schedule links in PR #616 at 20dd6b74f2fdf34bde50a257551e32ae82d24baa, followed by the approved design amendment at 0fb17badafebb03f8581252d9a2f2676bfa2818f.
- [x] Record the Owner's direction to finish the assigned deliverables and produce issues that can close through audit, review, Owner approval, and merge. Final acceptance of the delivered contract remains pending on this PR.

### 9.3. Shared contract and policy

- [x] Write the context contract and structured assignment example, preserving the small common and role entry points.
- [x] Write the Owner-directed role deliverables and Designer start rule into the authoritative handbook and role entry points; align the workstation design and roadmap. Published at 01ddb3c934f3f56793af8703910c94498bd7b328; Schedule bookkeeping stopped on a renamed option and the sibling script is repaired. Independent recheck and Owner acceptance remain pending.
- [x] Complete handoff and context details, including source and model identity, actual authority, changed or unavailable sources, and missing-evidence behavior.
- [x] Write the approved audit scope, on-demand operation, deferred blocking rollout, evidence and accuracy safeguards, independence, finding template support, and decision 63 in their authoritative homes as corrections to PR #616. Published at d9a70c08d73c4fc6dc6268fa3c49feeeecd29949 with passing checks; follow-up reviews and Owner acceptance remain pending.
- [x] File and link hook-wiring Task #617 under #519 for separate planning; preserve its source-owner and approval boundaries.
- [x] Write the Owner-approved common design-schedule Task template and starter skill, update references, and propose the file-specific native-frontmatter exception. Published in PR #616 at dd427dd17c2b9de2fc29b8cb960b819bdfd3324a; independent review and Owner acceptance remain pending.

### 9.4. Verification and delivery

- [x] Correct the two compliance audits' supported documentation, procedure, evidence, and script findings; preserve review text on the PR. The correction was published at dd427dd17c2b9de2fc29b8cb960b819bdfd3324a; the further audit corrections require publication and independent recheck.
- [x] Write the source map and five-role author walkthroughs in `docs/engineering/review/role-context-review.md`. Final documentation checks and independent verification are recorded with the published revision.
- [ ] Publish the implementation, pass required current-head checks, obtain independent technical review and compliance assessment, and resolve findings.
- [ ] Obtain Owner acceptance and merge, verify published sources and references, update issue and Schedule records, and perform authorized cleanup.

## 10. Files and related assets

PR #616 changes the following 47 repository files, combining the role-context work and evidence archive design. The inventory includes the spelling gate, the two line-exact quotation exceptions, and every changed process, standard, template, and source asset.

| Repository file | Purpose |
| --- | --- |
| `.github/codespell-verbatim-lines` | Preserve two exact historical Owner quotations. |
| `.github/frontmatter-exempt` | Declare the native skill frontmatter exception. |
| `Makefile` | Apply the line-exact spelling exceptions while retaining the dictionary checks. |
| `README.md` | Navigation and ownership. |
| `docs/architecture/agentic-developer-workstation.decisions.md` | Architecture, terminology, and architecture decision corrections. |
| `docs/architecture/agentic-developer-workstation.md` | Architecture, terminology, and architecture decision corrections. |
| `docs/architecture/issue-data-model/1-hierarchy.decisions.md` | Architecture, terminology, and architecture decision corrections. |
| `docs/architecture/issue-data-model/1-hierarchy.md` | Architecture, terminology, and architecture decision corrections. |
| `docs/engineering/agent-operation.md` | Authoritative process, assets, and issue requirements. |
| `docs/engineering/agents/auditor.md` | Shared context and role entry points. |
| `docs/engineering/agents/coder.md` | Shared context and role entry points. |
| `docs/engineering/agents/commandments.md` | Shared context and role entry points. |
| `docs/engineering/agents/context.md` | Shared context and role entry points. |
| `docs/engineering/agents/designer.md` | Shared context and role entry points. |
| `docs/engineering/agents/planner.md` | Shared context and role entry points. |
| `docs/engineering/agents/reviewer.md` | Shared context and role entry points. |
| `docs/engineering/index.md` | Navigation and ownership. |
| `docs/engineering/procedures/pull-request.md` | Owner-directed return at CI start, separate verification, and readiness boundaries. |
| `docs/engineering/procedures/index.md` | Publication, worktree, and Designer procedures. |
| `docs/engineering/procedures/worktrees.md` | Publication, worktree, and Designer procedures. |
| `docs/engineering/process.md` | Authoritative process, assets, and issue requirements. |
| `docs/engineering/review/decisions.md` | Policy decisions and author acceptance evidence. |
| `docs/engineering/review/role-context-fixture.json` | Policy decisions and author acceptance evidence. |
| `docs/engineering/review/role-context-review.md` | Policy decisions and author acceptance evidence. |
| `docs/engineering/review/sources/role-context-2026-11-20/owner-direction.txt` | Exact Owner directions and provenance. |
| `docs/engineering/work-assets.md` | Authoritative process, assets, and issue requirements. |
| `docs/engineering/work-organization.md` | Authoritative process, assets, and issue requirements. |
| `docs/guides/pr-script-template.md` | Publication, worktree, and Designer procedures. |
| `docs/index.md` | Navigation and ownership. |
| `docs/issue-standards.md` | Authoritative process, assets, and issue requirements. |
| `docs/plans/doc/558-role-entry-points.md` | Scope, progress, and established completion evidence. |
| `docs/plans/doc/581-schedule-command-consumers.md` | Scope, progress, and established completion evidence. |
| `docs/roadmaps/agentic-developer-workstation.md` | Delivery ownership and qualification evidence. |
| `docs/standards/documentation.md` | Document and terminology requirements. |
| `docs/templates/agent-context.md` | Examples of the shared requirements. |
| `docs/templates/design-schedule.md` | Examples of the shared requirements. |
| `docs/templates/design.md` | Examples of the shared requirements. |
| `docs/templates/index.md` | Examples of the shared requirements. |
| `docs/templates/issue.md` | Examples of the shared requirements. |
| `docs/templates/plan.md` | Examples of the shared requirements. |
| `docs/templates/review-comment.md` | Examples of the shared requirements. |
| `docs/templates/schedule.md` | Examples of the shared requirements. |
| `docs/architecture/engineering-evidence-archive.decisions.md` | Archive choices, reasons, alternatives, and proposal status. |
| `docs/architecture/engineering-evidence-archive.md` | Evidence archive subsystem design and requirements coverage. |
| `docs/plans/doc/490-evidence-archive-design.md` | Historical preparation, approvals, and independent review record. |
| `docs/roadmaps/engineering-evidence-archive.md` | Draft roadmap for context; Task #624 remains separately owned. |
| `skills/start-design-schedule/SKILL.md` | Apply the design-schedule Task and hierarchy pattern. |

The sibling Owner-run script, `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.558-role-context.bash`, remains outside Git. It preserves the prepared candidate and unpublished corrections, merges the two branch histories, stages this explicit set, and verifies the published head. Publication returns control when CI starts; a separate status command records current-head CI results. Review findings remain visible and block acceptance rather than hiding the published candidate. Refresh the published snapshot after integrating an overlapping target change; do not treat an earlier head as the merged source.

The Owner approved carrying the corrected handbook policy with the design amendment in PR #616; section 12 records that scope. Independent review and audit text remain on the introducing PR. Plans record the author's corrections and verification, not copies of those external assessments. Update phase state and affected documents in the commit that establishes their facts.

<a id="11-dependencies-and-overlaps"></a>

## 11. Dependencies, overlaps and blockers

Preserve the closed Handbook consolidation (#420) dependency and ownership under Agent roles (#460), Epic #526, and Schedule #551. Shared context (#558) remains open for this completion work. The common entry points from PR #601 and the handbook rewrite from PR #596 are delivered inputs.

Common context (#559), Skills and catalog (#560), Reading sets (#561), Claude consumption (#562), Codex consumption (#563), OpenCode compatibility (#564), and the five-role exercise (#565) retain their agreed scope. Writing-and-review skill (#599) and arc42 adoption (#600) remain separately scheduled. This task defines their context inputs and does not claim their undelivered results.

[Continuous compliance and exact-snapshot commit gate (#519)](https://github.com/NobleFactor/noblefactor-engprod/issues/519) owns commit-trigger wiring and the exact-candidate check. [Wire compliance audits after pre-commit checks (#617)](https://github.com/NobleFactor/noblefactor-engprod/issues/617) is filed as a native Task child of #519, Priority Medium, Area Product, and no implementation assignee. This plan owns the policy and documents the trigger contract; it does not implement the hook or create a competing compliance service. The task must retain the deferred universal gate and accuracy-based Owner activation rather than imply an immediate blocking rollout. Its rollout wording and current audit-trigger link are corrected through this worktree's Owner-run publication script. The current Task form required a What section, so the filed body includes it alongside Problem and completion evidence. Forms alignment remains with #572.

[Developer control and schedule continuity (#517)](https://github.com/NobleFactor/noblefactor-engprod/issues/517) is the live Feature responsible for planning environment configuration formats, revision handling, and durable role bindings. [Agent hosts (#459)](https://github.com/NobleFactor/noblefactor-engprod/issues/459) supplies the native-host application contract, and #519 supplies audit routing and commit checks. These implementation plans are not yet opened. The completed [workstation baseline plan](521-workstation-design.md) records the earlier architecture delivery, not this future implementation. David Noble retains Owner accountability; assigning implementation and approving its Schedule remain later planning steps.

David Noble directed consolidation of [Evidence Archive design PR #618](https://github.com/NobleFactor/noblefactor-engprod/pull/618) into this PR. Its subsystem work retains design Task #623 and roadmap Task #624 on Schedule #619; this worktree now delivers both the role-context requirements and the archive design. Preserve the 12 unpublished role-context corrections observed during integration. Merge the two branch histories without rebasing, retain the environment-role W6 and one-off-audit W7, rename the archive withdrawal W8, and carry that withdrawal into the moved D4. Close PR #618 as superseded only after verifying the combined publication. Prior independent assessments remain evidence for their exact revisions; the combined head needs technical review and compliance recheck. The roadmap remains a context draft and does not start or complete Task #624.

The existing doc/558-role-context branch uses the tool's doc override for this documentation task, while Task normally selects feature. The original preparation and subsequent publication ran through the Owner's worktree script. No separate policy decision for that override is recorded. Present this scoped branch variation explicitly with the PR for Owner acceptance; do not infer a general permission to override future branch types.

Record conflicts with the approved methodology or tooling and bring them to the Owner before proceeding with affected work. Keep additional host and model recommendations separate from approved runtime qualification. Do not change another worker's worktree or source.

## 12. Approval and departures

Historical PR #601 authorization, 2026-11-18: the Owner requested the small entry-point deliverable and its focused PR. The first preparation script opened that worktree, committed its plan, and opened the draft PR for Owner review.

For that historical PR, invoking its Owner-run script with `--allow-parallel-pr` explicitly authorized the additional PR #601 worktree and its scoped work while PR #596 was still a draft. That exception did not grant agent execution of Git, PR scripts, or merge operations and is not an argument to the current preparation script.

On 2026-11-18, the Owner reviewed the committed plan at b323440fbbcbbecdda52243dbd2dbdb95e805b15 in PR #601 and said, “the plan reads well enough. continue”. That approved the recorded first-delivery scope and directed implementation. The [original Owner-run preparation](https://github.com/NobleFactor/noblefactor-engprod/issues/558#issuecomment-6994753396) records the scoped parallel-work authorization. For that first delivery, Git, publication, and merge execution were Owner-run.

On 2026-11-20, David Noble supplied the two proposal documents and replied, “Let's run with that,” after the Coder's completion recommendation. The [preserved source](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) contains the exact material, recommendation, Owner reply, and the Coder's interpretation, with their native conversation timestamps. The reply is a broad direction to proceed, not two separately recorded answers. The recommended scope retains five roles and Claude and Codex qualification, treats additional host and model assignments as candidates, and strengthens model and context evidence and compliance assessment. The later clarification of audit scope and timing is recorded in section 12 and in section 5.2.1.

That broad reply directed work on the draft; the later clarification states the audit requirement. The amended implementation plan must be committed and presented before implementation under the existing process. Git and PR-script execution require their applicable grants; the approved publication departures for this checkpoint are recorded in section 12. No additional host qualification, automatic merge, branch-protection change, or cross-worker communication is authorized.

This worktree also records the already established PR #601 and PR #596 completion results. Their documentation-only records create no new delivery milestone and do not close #558 before this contract is complete.

On 2026-11-20, after the independent review, David Noble stated, “Publication is NOT blocked by anything,” and directed creation of the PR script using the established process and templates. That direction authorized preparing publication of the draft with the then-open R05 question. At 2026-11-20T23:38:01.878Z, the Owner directed, “I need confirmation immediately commit all changes and push them. DO THAT NOW.” Under that grant, the Coder ran `make check`, committed 20dd6b74f2fdf34bde50a257551e32ae82d24baa with hooks, integrated develop without rebasing, and pushed the branch. At 2026-11-20T23:48:27.927Z, the Owner directed, “I want that goddamm draft pr. NOW!” The Coder then created draft PR #616 through its GitHub connector. These were approved departures from Owner execution, not Owner-run operations. Both directions are preserved in the linked Owner source. Read the later scope and timing clarification with the Reviewer-session ruling to defer universal blocking; implementation, review, and merge requirements still apply.

On 2026-11-20, David Noble clarified that the Compliance auditor already exists, defined on-demand and post-check request timing, and included all changed and potentially affected assets: designs, plans, documentation, help text, completions, and man pages. At 2026-11-20T16:12:43.255-08:00 in the Reviewer session, he explicitly deferred the universal blocking gate and said he would request audits to gain experience. At 16:14:03.361-08:00, he emphasized reliability and accuracy; at 16:15:53.853-08:00, he directed that the proposed rules enter the plan. The linked source preserves those Owner messages from the Reviewer session's native history. This plan applies all four safeguards: deferred universal blocking, adopted-rule evidence, deterministic mechanical checks, and observed accuracy before Owner-approved activation. Section 5.2.1 describes future wiring, not an installed or enabled gate.

<a id="environment-role-configuration-approval"></a>

On 2026-11-20, David Noble approved the proposed focused design amendment with, “go for it. let's make that change now.” Its scope is shared policy and per-environment role configuration, one durable binding for each role within an environment, auditor independence and triggers, and review evidence attached to the PR. This approves the design update; configuration formats and control-plane implementation remain separate planning work. He then requested that all worktree changes be committed and pushed through this worktree's Owner-run script. The Owner ran the second publication through `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.558-role-context.bash` and produced 0fb17badafebb03f8581252d9a2f2676bfa2818f. Its receipt records a run from 2026-11-21T00:43:34.320666Z through 2026-11-21T01:08:33.505234Z at `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-context/pr-runs/20261121T004334.320454Z/receipt.json`. This identifies the recorded executor and results; it does not extend agent execution authority. The exact direction, preceding Owner question, and Coder proposal are preserved in the linked Owner source.

<a id="compliance-policy-and-one-off-audit-approval"></a>

On 2026-11-20T19:40:10.105-08:00, David Noble replied, “Yes, I approve both,” to the Coder's two proposals: include the corrected handbook compliance policy in PR #616, and allow an Owner-approved one-off audit by an eligible third model family while preserving the assigned auditor's session. The [preserved source](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) contains the exact proposal and reply from this conversation. This approves the policy correction and the design path recorded in [W7](../../architecture/agentic-developer-workstation.decisions.md#w7), including their affected references. Each actual one-off assignment still requires the Owner's approval. It does not authorize a universal blocking gate, live hook changes, additional host qualification, agent execution of the PR script, or merging.

<a id="role-deliverables-correction"></a>

On 2026-11-20, David Noble paused delivery to correct confusion about role outputs. He required the Designer to deliver design documents and a roadmap on a schedule with at least separate design and roadmap issues, the Planner to deliver schedules and remain a planning consultant, the Reviewer to review all affected assets, and the Compliance auditor to check them against adopted standards. He then specified: “A Designer owes a design, its decision records, and a roadmap, not a plan for writing a design.” These explicit instructions authorize this focused correction under #558 in PR #616, including the scoped Designer exception to retained host instructions. They do not authorize agent execution of the PR script, live host-file changes, or a broader exemption for other roles. The [Owner source](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) preserves the selected Owner messages and exact revised Designer statement and identifies the complete original direction by native source, timestamp, and hash. David Noble prioritized the role correction first. The Owner subsequently required completed deliverables and issue closure; the existing context-contract scope is now finished in this PR for the required review and acceptance cycle.

On 2026-11-20, David Noble directed immediate adoption of *architecture decisions* as the Designer deliverable name, using architecture decision records (ADRs) for individual records. Apply this editorial correction in PR #616 without filing another issue. His Roadmap question is an inquiry, not a rename approval; retain that name pending a decision. [Decision 65](../../engineering/review/decisions.md#decision-65) and the preserved Owner source identify the scope. Historical quotations retain their original wording.

On 2026-11-20, David Noble proposed the Evidence Archive design and roadmap Tasks as the common pattern for every design schedule. He accepted the Coder's proposal to put their content in a shared template and provide a small skill to apply it, saying, “awesome. let's do that now, if it makes sense. What do you think?” This authorizes this focused template and skill addition in the current worktree and PR. It does not authorize live changes to #619 or claim completion of the remaining skills and catalog or host-qualification tasks. The preserved Owner source contains the proposal and acceptance.

On 2026-11-21, David Noble directed adoption of enabler feature as purpose vocabulary while retaining Type Feature, explicitly required the vocabulary in PR #616, and required the starter skill to place design Tasks correctly in their related Epic hierarchy. Those directions authorize the linked standard, template, and skill corrections in this PR. The preserved Owner source records the scope. No new tracker type, label, field, or broader SAFe workflow is introduced.

At 2026-11-21T04:32:21.996Z, David Noble required issues to close with audited, reviewed, Owner-approved, and merged deliverables. At 08:04:25.941Z, he added, “And I need to see issues closing.” [Source messages 35 and 36](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) preserve the exact directions. The bounded escalated request at 08:14:46.943Z asked to finish these deliverables and completed successfully; its execution record is preserved with that source. This was recorded direction and a bounded execution grant, not a separate review of the committed amendment. Complete #558's existing promised context contract, assignment example, and role definitions in PR #616, rather than publish another partial planning checkpoint. This records direction to finish the existing assignment; it does not claim review approval, merge authority, or native host qualification. The PR closes #558 through the established merge workflow after the required reviews and Owner acceptance.

At 2026-11-22T03:48:21.220Z (2026-11-21 locally), David Noble directed, "then let's get the changes from #618 into #616 NOW!" [Retained message 39](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) identifies the source exchange and preserves the exact text. This authorizes the consolidation described in section 11 and preparation of the Owner-run publication script. It approves neither the archive's proposed architecture choices nor protected-branch merge, review waivers, or unrelated changes. Technical suitability takes priority over preferences; preferences guide otherwise suitable options with balanced tradeoffs.

## 13. Completion review

PR #616 publishes the completed context contract, assignment example, role definitions, enabler vocabulary, design-schedule template, and starter skill at 2653ee5a9662bb1b86b7c24f02c7267459513770. The Owner-run publication completed issue and Schedule bookkeeping, committed and pushed sixteen files in that commit, and verified the exact remote and PR head. The complete PR then contained 32 changed files. The repository's `make check` gate and the native skill validator passed. All four CI jobs passed in [run 44885435060](https://github.com/NobleFactor/noblefactor-engprod/actions/runs/44885435060). The publication receipt is `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-context/pr-runs/20261121T082353.871357Z/receipt.json`.

The earlier PR #601 entry points and PR #596 handbook rewrite are accepted, merged, verified, and cleaned up. Their established evidence remains in sections 3 and 7.1 and the completed rewrite plan. The missing PR #601 squash trailers remain recorded. These results do not establish review or acceptance of the later contract.

The compliance audit posted on 2026-11-22 at 00:06:35Z covers 2653ee5a and confirms the earlier A01–A06 corrections. This follow-up corrects the reported documentation, decision-provenance, stale-record, and acceptance-evidence findings and the full-coverage audit at [PR #616](https://github.com/NobleFactor/noblefactor-engprod/pull/616#pullrequestreview-6009193058). It aligns Designer procedures, arc42 coverage, required plan fields, indexes, and the Bash publication safeguards. The explicit branch variation and proposed source location are presented for Owner acceptance; they are not treated as general permission. The filled design assignment uses verified Schedule #619 and native parent links; the author consistency fixture records impact, correction, and recheck. The skill remains shared source at the path specified in section 5.6; installation and discovery remain separate work. Missing historical model evidence remains an audit limitation, not a request for the Owner to reconstruct sessions. That correction was published as f51a652fd1889277a9ac6cae639903a61142ac77, with 42 changed files in the complete PR. All four CI jobs passed in [run 44977036638](https://github.com/NobleFactor/noblefactor-engprod/actions/runs/44977036638). The [independent technical review of f51a652](https://github.com/NobleFactor/noblefactor-engprod/pull/616#pullrequestreview-6010001974) was posted on 2026-11-22. The subsequent author corrections restore the recovery terminology and unchanged decision timestamps, align the assignment schema and durable example revisions, complete the file inventory, and strengthen publication readiness and no-op behavior. Those corrections require their own checks and independent rechecks; neither the earlier CI run nor the review establishes verification of later edits.

Keep #558 Open or In progress while its delivered assets await technical review, compliance recheck, and Owner acceptance. PR #616 uses `Closes #558`. After observed Owner merge, its finish script records evidence, closes the Schedule row, verifies published sources, and cleans up. Host qualification and the five-agent exercise remain separate issues. Record observed post-merge results through the established completion-only follow-up without creating another delivery milestone.

The consolidation candidate combines role-context head f51a652fd1889277a9ac6cae639903a61142ac77, its 12 preserved unpublished corrections, and archive head 6d912eab4c157ab7e26cc49f9e84c6f06aade9dd. It contains 46 changed repository files. W8 records the withdrawal in both current workstation locations without changing the completed workstation plan. The combined candidate was published at dd427dd17c2b9de2fc29b8cb960b819bdfd3324a, and all four CI checks passed in [run 44986724912](https://github.com/NobleFactor/noblefactor-engprod/actions/runs/44986724912). Its audit identified further reference, provenance, wording, and publication-record corrections. Those corrections add the CI procedure update, bringing the PR to 47 files; they require their own publication, checks, technical review, and compliance recheck.

At 2026-11-22T03:29:25.330Z (2026-11-21 locally), David Noble required the publication script to pause and update him as soon as CI starts. [Retained message 37](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) supplies the exact direction. The revised PR procedure records this change: publication returns after reporting CI state, a separate status command verifies completion and readiness, and no watcher remains running. CI, independent review, and Owner acceptance remain required before merge.
