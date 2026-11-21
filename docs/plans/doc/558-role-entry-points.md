---
title: "Shared context and five specialist roles"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/558
status: active
created: 2026-11-18
updated: 2026-11-20
documents:
  - kind: Design
    path: docs/architecture/agentic-developer-workstation.md
    text: "Agentic developer workstation"
  - kind: Handbook
    path: docs/engineering/index.md
    text: "Engineering handbook"
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/551
    text: "Handbook adoption"
  - kind: Owner-provided source
    path: docs/engineering/review/sources/role-context-2026-11-20/owner-direction.txt
    text: "Owner input, proposal and direction on 2026-11-20"
---

# Shared context and five specialist roles

## 1. Roles and authority

Owner: David Noble. Participant: this Codex session. The Owner appoints reviewers and the compliance auditor. This plan does not authorize cross-session contact, delegation, Git execution by the agent or changes to live host instructions.

## 2. Promised result

Finish the shared context contract and the five specialist roles: designer, planner, coder, reviewer and compliance auditor. Preserve the small common commandments and role entry points, and make their assignment, applicable reading, source/version evidence, authority and handoffs explicit.

Define the existing Compliance auditor's checks, their scope and their triggers. Keep roles independent of host/model preferences. Retain Claude/Codex qualification as this Schedule's runtime scope. Shared-skill publication, additional host qualification, model deployment and the five-native-agent exercise remain separately owned.

## Issue 558

[Shared context and five roles (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558) owns the complete contract and role definitions. This slice completes the contract beyond the entry points delivered in PR #601.

## 3. Current state

The common commandments and five role entry points were accepted and merged in [PR #601](https://github.com/NobleFactor/noblefactor-engprod/pull/601) as 967764ae13b015543a2d0667e907b0fd37283875 on 2026-11-19. Post-merge verification established all eight reviewed source hashes and 58 local references; the worktree, sibling script and branch were removed. The source receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-entry-points/post-merge-verification.02un9gc3/completion-receipt.json.

PR #601's published squash commit omitted the human sign-off and assistance trailers. The finding remains recorded in its PR and issue; published history was not rewritten. That delivery completed the first entry-point slice, while #558 remains open for the broader context contract.

The handbook rewrite in [PR #596](https://github.com/NobleFactor/noblefactor-engprod/pull/596) was accepted at 8aa77e7a513dbc7b68e9bb1a9fe0aa4cf68cc32e and merged as 55dec2b044a2972f1037996c06d887a960d6c8ef on 2026-11-20. Its two issues and Schedule rows are Closed; installed-skill verification and cleanup passed. This checkpoint records its established completion facts in the existing plan.

On 2026-11-20, David Noble supplied Terminal-First Development Roles and its evidence companion, reviewed the proposed completion amendment and directed, “Let's run with that.” This plan records the approved direction and the implementation proposal. The completion-slice implementation is not yet written; review the committed amendment before that work.

## 4. Design impact

The shared contract refines the five persistent specialists in the [workstation design](../../architecture/agentic-developer-workstation.md), while preserving its distinction between role, host, primary conversation and attachment. The new contract is a reference for reading, assignment and handoffs, not a new host service. Distinguish specialist roles from the process's RACI responsibilities: Owner, Reviewer, Participant and Observer. A specialist Reviewer or Compliance auditor is an assignment of work, not a transfer of the Owner's accountability or automatic authority.

Keep enduring requirements, assignment data and host-specific loading distinct. The Owner-approved [environment configuration](../../architecture/agentic-developer-workstation.md#environment-role-configuration) amendment states how role context, host/model choices and one durable role binding fit together. Designs continue to describe the wanted system; this plan retains transition work, progress and approval history. Bring any conflict with the accepted architecture or tooling to the Owner before changing the affected definition.

## 5. Proposed implementation

Preserve the delivered entry points, update the shared contract and policy in their authoritative homes, and keep the required reading small.

### 5.1. Shared context contract

Publish docs/engineering/agents/context.md as the reference contract for the five roles. It identifies the engineering overview, common commandments, role material, applicable skills, assignment information and source/version evidence. Requirements remain in their authoritative handbook sections; the contract links them rather than repeats the handbook. Preserve the 350-word common-page and 200-word role-page budgets.

Define a role independently of the host, model, daemon, primary conversation and attachment. Repository exploration supports the roles that need it. The Designer covers system, API and UI design; the Planner defines the transition route, issues and proposed Schedule; the Coder implements the approved work and updates affected documentation; the Reviewer evaluates correctness and coherence; the Compliance auditor evaluates conformance to approved requirements, process and authority. Documentation responsibility follows the asset and its owning role.

Add docs/templates/agent-context.md as a human-readable assignment example. Use a fenced YAML record with role, owner, repository, scope, parent, schedule, issue, plan, worktree, host, model, session, resources, authority and artifacts. The host records its name and version; model records provider, identifier and family; session records native identity and the exact session name. Resources identify kind, source, revision, read_at and state. Authority references the actual grants and approved exceptions. Artifacts identify input revisions and expected outputs. Explain required values, conditional values and explicit unknowns. This is a documentation format; host configuration and runtime validation remain separately owned.

A design preceding a Schedule records its Epic or Feature in parent.issue and its type in parent.type, and records schedule as not applicable with its reason. A missing assignment is an explicit unknown, distinct from an inapplicable Schedule. Unavailable identity, model or source evidence remains explicitly unknown, with its reason and the affected claim. A host name cannot prove model-family independence. Record the model used for the work or review and material changes of model against the affected artifacts.

Use the existing startup and post-compaction reading requirements. The record distinguishes a published resource from content actually read by a running session. Define how to report changed or unavailable sources and request missing assignment information. Additional automatic refresh or runtime loading behavior is not selected here. Host qualification must establish the actual behavior of the installed versions and working directories.

### 5.2. Compliance assessment

Update the existing compliance-auditing section of Agent operation as the authoritative policy home. The existing Compliance auditor checks work on demand and during a commit after the pre-commit checks pass. The check covers every changed file and every other asset that might be affected by those changes. It checks the applicable approved plan, standards, process and authority; test, lint and CI results provide evidence.

Cover all assets: source code, tests, configuration, designs, plans, schedules, handbook and user documentation, examples, help text, completions and man pages. Start with the changes and follow their effects through dependencies, interfaces, generated outputs and descriptions. Check affected assets outside the diff as well. Apply the adopted Google guidance and relevant arc42 content to affected documents. Cite the applicable adopted requirement rather than treating every suggestion in an external guide as mandatory.

Each finding identifies severity, the applicable requirement and source revision, location, observed evidence, consequence, requested correction, disposition and verification needed. Distinguish a violation, missing evidence and a recommendation. Unmet mandatory requirements block acceptance until corrected or covered by an explicit Owner-approved exception. Missing evidence cannot be recorded as a verified pass. The Owner retains the decision authority and must have the unresolved findings and verification limits.

Keep technical review and compliance audit distinct. Require an agent conducting the compliance audit to use a different model family from the builder, and state that rule directly in Agent operation's compliance-auditing section and repoint auditor.md to that authoritative home rather than depend on Issue #565 or the role page as a separate policy source. Recheck corrections against the changed artifact revision. Earlier approval does not establish review of later edits. Update the existing review-comment template to support these fields and link the role pages to the authoritative policy.

Record David Noble's 2026-11-20 policy decision in the handbook decision log using its established structure and actual attribution. Do not add a required GitHub status check, change branch protection, automate merging or mandate OpenCode as the auditor host.

<a id="521-scope-and-interim-operation-proposed-owner-disposition"></a>

#### 5.2.1. Audit triggers

Use one way to request an audit, either directly on demand or from the commit process. Give the auditor the changed files and their reviewed versions, the diff, the pre-commit results, the assignment and the applicable requirements. The auditor follows the effects into other assets and records what it checked, its findings and any missing evidence.

Proposed commit wiring: run the existing pre-commit checks, then call the auditor locally before the pre-commit hook returns. The audit result must apply to the version being committed; changes after that check require another check. Describe how a failed or unavailable audit is reported and how the existing Owner exception authority applies. Do not silently treat an unavailable check as a pass.

Git's [hook reference](https://git-scm.com/docs/githooks#_pre_commit) supports this ordering within the pre-commit hook. The installed shared hook currently ends by handing control to a repository hook with exec; a call placed after that exec would never run. The hook driver must regain control after successful checks before it can invoke the auditor. Document the trigger contract here and hand off its wiring for a separate issue and approved plan in the repository that owns the hooks. This documentation checkpoint does not install the trigger.

A plan checkpoint checks the plan and the assets it affects. A completion-only follow-up checks its changed records and any affected assets against established results. Their changed content determines the work to inspect; neither requires pretending that future implementation has already been tested.

David Noble's 2026-11-20 clarification resolves the scope and timing question in R05: use the existing auditor, check on demand or after pre-commit checks during a commit, and cover all changed and potentially affected assets. Auditor qualification is not a reason to defer this requirement.

### 5.3. Host and model preferences

Retain Claude/Codex qualification as this Schedule's runtime scope and the existing OpenCode compatibility review. Treat the supplied Antigravity/Gemini and OpenCode recommendations as candidates; they do not enlarge this task into additional host qualification, local inference, Azure deployment or hardware work. Shared definitions must permit an approved host/model choice without rewriting the role.

Keep AGENTS.md and any needed CLAUDE.md small and directed to shared resources. Instruction and skill discovery differ by host; host tasks qualify actual loading and refresh. The source review checked the official Codex, Claude, OpenCode and Antigravity documentation on 2026-11-20. Those sources establish documented capabilities, not comparative performance, installed behavior or a qualified deployment.

Use [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Claude instructions](https://code.claude.com/docs/en/memory), [OpenCode instructions](https://opencode.ai/docs/instructions/) and [OpenCode skills](https://opencode.ai/docs/skills/) as host-loading references. The supplied [Antigravity commands](https://antigravity.google/docs/cli/reference/) and [workspace search](https://antigravity.google/docs/cli/commands/codesearch/) inform candidate activities. Do not convert the supplied Azure model/deployment or data-handling claims into verified requirements.

### 5.4. Completion records

Incorporate the established PR #601 completion record into this plan. Keep its documented squash-trailer finding visible and do not rewrite published history. Incorporate PR #596's established final review, merge, issue/Schedule closure, installed-skill verification and cleanup into its existing plan. These documentation-only records create no further delivery milestone.

### 5.5. Environment configuration design amendment

Update the workstation design and its decision companion with shared policy, per-environment role configuration, one authoritative native-session binding per environment/role, actual-model audit independence and audit routing. External reviews belong on the PR introducing the changes; keep saved copies outside Git. Preserve existing anchors and update the components diagram and affected workflow/quality descriptions. Configuration schemas, host integration and lifecycle implementation remain separate control-plane work.

## 6. Alternatives and limits

Retain five specialist roles rather than turn every activity into a persistent role. Exploration, UI methods and documentation techniques can support the role that owns the asset through shared skills. Keep the Designer's system description distinct from the Planner's transition work, even when one host performs both.

Use shared definitions with small host entry points rather than duplicate the handbook per host. Keep candidate host/model preferences separate from role requirements. Documentation of a capability does not establish comparative performance or actual context loading.

Keep the Reviewer and Compliance auditor distinct. The former evaluates correctness and coherence; the latter evaluates adopted requirements, process and authority. Neither CI nor one assessment substitutes for the other, and the Owner retains acceptance and exception authority.

## 7. Acceptance and evidence

### 7.1. First-delivery evidence

PR #601 contains the six short resources and handbook navigation. Its first reviewed source had 275 common-page words and 139, 149, 141, 150 and 139 words for Designer, Planner, Coder, Reviewer and Compliance auditor, respectively. Counts excluded metadata, link addresses, formatting markers and numeric markers. These are counts for that delivered revision, not a claim about every later edit.

The first delivery's source map and author walkthrough used [devlore-cli dry-run provider work (#1170)](https://github.com/NobleFactor/devlore-cli/issues/1170). The fixture, findings and dispositions are retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-entry-points/resource-review.json. The PR records passing Owner-run make check, final-head CI and Owner acceptance.

The 2026-11-19 verification confirmed all eight reviewed hashes and 58 local references. Cleanup was verified at 01:10:37 UTC. Its receipt is named in section 3. This established source/reference delivery, not native context loading or five-agent execution.

### 7.2. Context-contract acceptance

| Criterion | Observable result | Evidence |
| --- | --- | --- |
| Roles and context are complete | Specialist roles are distinguished from Owner, Reviewer, Participant and Observer RACI responsibilities; all five roles identify purpose, inputs, outputs, authority, escalation, handoffs and reading; common and role pages retain their word budgets | Requirement map and role-by-role substantive review |
| Assignment is explicit | The example covers the overview, common material, role material, skills, assignment, source revisions and read evidence | Filled example against a real scheduled change, including a pre-Schedule design |
| Identity and independence are supported | Host, actual model family, native conversation and exact session name remain distinct; unknowns prevent unsupported claims | Walkthrough with a changed or unknown model |
| Audit covers all affected assets | The audit starts with every changed file and checks every other asset that might be affected, including designs, plans, help, completions and man pages | Impact map, stale-documentation fixture, correction and recheck |
| Audit timing is clear | Requests can be made on demand; the proposed commit trigger runs after successful pre-commit checks and identifies the checked versions and results | Trigger contract and hook-integration handoff; no claim that this checkpoint installs it |
| Evidence and judgment stay distinct | Passing CI does not hide a correctness defect; missing evidence and inapplicable requirements are reported accurately | Reviewer/auditor walkthrough and dispositions |
| Publication differs from loading | Published but unread resources are not claimed as effective session context | Source/revision walkthrough with a changed resource |
| Ownership is preserved | Shared requirements have one authoritative home and downstream tasks retain their scope | Link/requirement review and explicit task handoffs |
| Completion is supported | Final checks, independent review, Owner acceptance, observed merge and source verification are recorded | Published revision, CI, review and delivery records |

Use one real scheduled change as the main fixture, selecting and identifying it in the review record before the walkthrough. Include cases for stale documentation outside a diff, an unknown or inapplicable standard, a correctness defect despite passing checks, a material model change, and published context not shown to be read. These are document walkthroughs; the later five-native-agent exercise remains with #565.

Record source-to-requirement coverage and the author's walkthrough results in docs/engineering/review/role-context-review.md. Record external technical reviews, compliance findings and corrective verification on the PR introducing the changes; keep local copies outside Git. Link the PR from the delivery record instead of committing external review text. Validate links, metadata, YAML, paragraph layout and word budgets, then review whether the documents are complete and understandable. Syntax and formatting checks alone do not establish usability.

## 8. Completion milestones

| Milestone | Required? | Evidence and state |
| --- | --- | --- |
| First entry-point delivery | Yes | Delivered and accepted in PR #601; its 2026-11-19 source/reference verification and cleanup are recorded below |
| Completed shared contract and role refinements | Yes | Pending implementation and substantive review under this amendment |
| Current-head checks and independent review | Yes | Pending; retain the repository's actual checks and separate review/audit findings |
| Owner acceptance and merge | Yes | Pending for this completion slice |
| Published-source and reference verification | Yes | Verify the merged resources and their references before claiming availability |
| Native host loading and daemon qualification | Separate tasks | Owned by #562/#563 and the later exercise; no installed-host proof is claimed here |
| Issue/Schedule records and cleanup | Yes | Record observed results, use closing references only for completed issues and preserve outstanding evidence before removing the worktree |

Apply the established completion-only documentation process to observed post-merge results. No additional delivery milestone is created by recording an already established result.

## 9. Phases

### 9.1. First delivery

- [x] Commit and publish the first plan; David Noble reviewed it and directed implementation on 2026-11-18.
- [x] Publish the six resources and handbook navigation with ownership/change-process metadata, source coverage, word counts and the devlore-cli role read-through.
- [x] Pass the Owner-run repository check and final-head CI, obtain Owner acceptance, and merge PR #601 as 967764ae13b015543a2d0667e907b0fd37283875.
- [x] Verify all eight reviewed source hashes and 58 local references and clean up the worktree, script and branch on 2026-11-19. Preserve the recorded missing-trailer finding.

### 9.2. Completion planning

- [x] Review the supplied Terminal-First Development Roles and evidence notes against the five-role contract and official host documentation.
- [x] Record David Noble's 2026-11-20 direction to proceed, retained runtime scope and clarification of audit scope and timing.
- [x] Apply the Owner-approved workstation design amendment for environment role configuration and audit routing, with decision W6.
- [ ] Commit and publish this amended plan, update its issue/Schedule links and obtain Owner review of the committed revision before implementation.

### 9.3. Shared contract and policy

- [ ] Publish the context contract and structured assignment example, preserving the small common and role entry points.
- [ ] Clarify all five roles and handoffs, including source/model identity, authority and missing-evidence behavior.
- [ ] Publish the approved audit scope, on-demand and commit triggers, finding template support and dated decision in their authoritative homes. Hand off the missing hook wiring for separate planning.

### 9.4. Verification and delivery

- [ ] Complete the source map and five-role walkthroughs, correct findings and verify the documentation checks and word budgets.
- [ ] Publish the implementation, pass required current-head checks, obtain independent technical review and compliance assessment, and resolve findings.
- [ ] Obtain Owner acceptance and merge, verify published sources/references, update issue and Schedule records, and perform authorized cleanup.

## 10. Files and related assets

Modify docs/architecture/agentic-developer-workstation.md, docs/architecture/agentic-developer-workstation.decisions.md, docs/plans/doc/558-role-entry-points.md, docs/engineering/agents/commandments.md, the five existing role pages, docs/engineering/agent-operation.md, docs/engineering/index.md, docs/engineering/work-organization.md, docs/engineering/review/decisions.md, docs/templates/index.md and docs/templates/review-comment.md. Create docs/engineering/agents/context.md, docs/templates/agent-context.md and docs/engineering/review/role-context-review.md. Update docs/plans/doc/581-schedule-command-consumers.md only with established completion evidence.

The preparation checkpoint changes the two existing plan files, the approved workstation design and decision companion, and preserves the exact Owner-provided source, proposal and direction in docs/engineering/review/sources/role-context-2026-11-20/owner-direction.txt. Role-contract implementation follows review of the committed amendment; the focused design update has the explicit approval recorded below. Update phase state and affected documents in the commit that establishes their facts.

## 11. Dependencies and overlaps

Preserve the closed Handbook consolidation (#420) dependency and ownership under Agent roles (#460), Epic #526 and Schedule #551. Shared context (#558) remains open for this completion work. The common entry points from PR #601 and the handbook rewrite from PR #596 are delivered inputs.

Common context (#559), Skills and catalog (#560), Reading sets (#561), Claude consumption (#562), Codex consumption (#563), OpenCode compatibility (#564) and the five-role exercise (#565) retain their agreed scope. Writing-and-review skill (#599) and arc42 adoption (#600) remain separately scheduled. This task defines their context inputs and does not claim their undelivered results.

Record conflicts with the approved methodology or tooling and bring them to the Owner before proceeding with affected work. Keep additional host/model recommendations separate from approved runtime qualification. Do not change another worker's worktree or source.

## 12. Approval and departures

Historical PR #601 authorization, 2026-11-18: the Owner requested the small entry-point deliverable and its focused PR. The first preparation script opened that worktree, committed its plan and opened the draft PR for Owner review.

For that historical PR, invoking its Owner-run script with `--allow-parallel-pr` explicitly authorized the additional PR #601 worktree and its scoped work while PR #596 was still a draft. That exception did not grant agent execution of Git, PR scripts or merge operations and is not an argument to the current preparation script.

On 2026-11-18, the Owner reviewed the committed plan at b323440fbbcbbecdda52243dbd2dbdb95e805b15 in PR #601 and said, “the plan reads well enough. continue”. That approved the recorded first-delivery scope and directed implementation. The [original Owner-run preparation](https://github.com/NobleFactor/noblefactor-engprod/issues/558#issuecomment-6994753396) records the scoped parallel-work authorization. Git, publication and merge execution remain Owner-run.

On 2026-11-20, David Noble supplied the two proposal documents and replied, “Let's run with that,” after the Coder's completion recommendation. The [preserved source](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) contains the exact material, recommendation, Owner reply and the Coder's interpretation, with their native conversation timestamps. The reply is a broad direction to proceed, not two separately recorded answers. The recommended scope retains five roles and Claude/Codex qualification, treats additional host/model assignments as candidates, and strengthens model/context evidence and compliance assessment. The later clarification of audit scope and timing is recorded below and in section 5.2.1.

That broad reply directed work on the draft; the later clarification states the audit requirement. The amended implementation plan must be committed and presented before implementation under the existing process. Git and PR-script execution remain Owner-run; no additional host qualification, automatic merge, branch-protection change or cross-worker communication is authorized.

This worktree also records the already established PR #601 and PR #596 completion results. Their documentation-only records create no new delivery milestone and do not close #558 before this contract is complete.

On 2026-11-20, after the independent review, David Noble stated, “Publication is NOT blocked by anything,” and directed creation of the PR script using the established process and templates. That direction authorized publishing the draft with the then-open R05 question. The later clarification resolves audit scope and timing; implementation, review and merge requirements still apply.

On 2026-11-20, David Noble clarified that the Compliance auditor already exists, checks work on demand or during a commit after the pre-commit checks run, and covers all changed files and all assets that might be affected. He explicitly included designs, plans, documentation, help text, completions and man pages. The exact messages are preserved in the linked Owner source. Section 5.2.1 records the proposed trigger wiring; no live hook change is claimed.

<a id="environment-role-configuration-approval"></a>

On 2026-11-20, David Noble approved the proposed focused design amendment with, “go for it. let's make that change now.” Its scope is shared policy and per-environment role configuration, one durable binding per environment/role, auditor independence and triggers, and review evidence attached to the PR. This approves the design update; configuration formats and control-plane implementation remain separate planning work. He then requested that all worktree changes be committed and pushed through this worktree's Owner-run script. The exact direction is preserved in the linked Owner source.

## 13. Completion review

The first entry-point slice is accepted, merged, source-verified and cleaned up. Its missing squash-trailer finding remains visible in PR #601. The full shared context contract and the 2026-11-20 role/audit refinements remain to be implemented, verified and reviewed under this amendment.

Keep #558 Open/In progress, link its current worktree and present the committed plan for Owner review. Do not treat the first delivery, approval of the proposal, or this planning checkpoint as evidence that the remaining contract, host tasks or five-agent exercise is complete.
