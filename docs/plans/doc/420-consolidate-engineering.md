---
title: "Consolidate engineering documentation"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/420
status: complete
created: 2026-10-29
updated: 2026-11-17
documents:
  - kind: Design
    path: docs/architecture/agentic-developer-workstation.md
  - kind: Handbook
    path: docs/index.md
---

# Consolidate engineering documentation

## 1. Problem and deliverable

Engineering requirements are distributed across overlapping process guides, standards, templates and agent instructions. The imported review draft incorporates the Owner's decisions but does not yet replace every conflicting definition or provide complete navigation.

Deliver a coherent documentation set on `develop` with one authoritative home per requirement, explicit applicability, consistent templates, navigable entry points and a reviewed transition from the existing documents. Preserve the Owner's comments, source evidence and decisions. This task documents the process; it does not implement the controller, sandbox, compliance tooling or GitHub configuration.

## Issue 420

[Documentation consolidation](https://github.com/NobleFactor/noblefactor-engprod/issues/420) is a Task under [shared engineering process documentation, Feature #419](https://github.com/NobleFactor/noblefactor-engprod/issues/419), within [Engineering handbook, agent rules and skills, Epic #526](https://github.com/NobleFactor/noblefactor-engprod/issues/526). It is Step 1 of [Adopt the engineering handbook, Schedule #551](https://github.com/NobleFactor/noblefactor-engprod/issues/551), on [Schedule: engprod](https://github.com/orgs/NobleFactor/projects/26/views/2?filterQuery=schedule%3A%22adopt%20the%20engineering%20handbook%22). The Owner requested this focused schedule on 2026-11-14; subsequent role, skill and entrypoint implementation remains separate work.

## 2. Roles and authority

- **Owner:** David Noble, accountable for policy, design and adoption decisions.
- **Participant:** Codex, preparing this plan, the documentation and supporting evidence under the Owner's direction.
- **Reviewer:** the initial review and Owner responses are preserved in the review material. The Owner appoints the reviewer for the resumed adoption pass; no direct conversation has been authorized.
- **Observer:** no separate assignment recorded. Keep the Owner informed directly.

The Owner has approved the structure, recorded policy decisions and worktree import, and directed Handbook consolidation to resume on 2026-11-14. The prior draft is committed in checkpoint d4960b7430ff717e256d3c2effcdb135ba9d1208. The Owner approved the committed execution plan at 7f9ba188ac6cf7555fee4d6b9fcc0a5ecebf3d64 on 2026-11-15, replying “approved.” after being shown that revision and its proposed reconciliation work. Approval authorizes the planned handbook reconciliation; commit, push, publication and policy adoption retain their separate approval requirements. This approval is recorded from the current Codex conversation. No agent communication is authorized by naming a Reviewer here.

## 3. Current state and preservation

- Worktree: `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.420-consolidate-engineering`.
- Branch: `doc/420-consolidate-engineering`; target: `develop`.
- Import base: `59740c91f0183f2165a70f6aa3b352d1e5d42515`.
- All 42 package files were copied and hash-verified without overwriting existing repository files. The package README is preserved as `ENGINEERING-DOCUMENTATION-REVIEW.md`.
- The resumed pass verified all 13 source snapshots and all 42 imported destinations. The retained review archive contains the original backup matching every import-manifest hash; original Linux locations were not accessed from this Mac. [Resumption evidence](../../engineering/review/reconciliation-2026-11-15.json) records the comparisons. Retain the original archive, source evidence and import manifests.
- [Import manifest](../../engineering/review/worktree-import.json) records source/destination identities and content hashes. It is a record of the import, not a promise that subsequent edits retain those hashes.
- [Review decisions](../../engineering/review/open-decisions.md) records the resolutions of O01–O11 and preserves the Owner's responses.
- [Documentation entry point](../../index.md) exists. The final Participant review verified all 23 active handbook documents are reachable from it, all 134 legacy section anchors are preserved, and current local references resolve. Owner review and adoption remain pending.

## 4. Design impact and intended implementation

The documentation architecture changes; product runtime architecture does not. Preserve the approved separation among process transitions, work organization, work assets, agent operation, release/recovery, documentation standards, language standards, procedures and templates.

Use `docs/index.md` as the entry point. Define roles once in the engineering process. Put shared policy in the appropriate authoritative document; other documents link to it. Keep historical evidence visibly separate from active instructions. Retain language-standard detail rather than replacing it with a general statement to use a linter.

Reconcile the old document paths through reviewed successor notices or precise retained responsibilities. Do not merely add a new directory while leaving competing active definitions. Preserve incoming links where practical; do not delete historical plans to remove inconvenient old wording.

Treat editorial corrections supported by settled decisions as consolidation work. Present substantive policy gaps to the Owner one at a time before selecting an answer. Record findings in the [conflict register](../../engineering/review/conflicts.md). The preserved Reviewer findings are available in the root review record and [current adoption disposition](../../engineering/review/adoption-review.md); consult those records rather than asking the Owner to supply them again.

### 4.1. Resumed reconciliation pass

1. Recheck preserved sources and review evidence; refresh the requirement inventory against current develop, including the current issue hierarchy, Schedule project representation and PR-script records.
2. Use the recorded O01-O11 decisions and conflict-register dispositions as source material. Present any disagreement with current active instructions to the Owner before selecting a policy; distinguish adopted rules, approved draft decisions and deferred tooling.
3. Reconcile one authoritative definition for each shared requirement, align procedures and templates, and record old-path successors while preserving historical evidence and incoming links.
4. Complete navigation, metadata, language and link validation, then present the resulting documentation and transition for Owner adoption.
5. Maintain this step's Schedule row through the prescribed worktree scripts and record merge, verification and completion evidence on the issue.

The adopted handbook will supply inputs for [Agent roles (#460)](https://github.com/NobleFactor/noblefactor-engprod/issues/460), [Skills standard and catalog (#550)](https://github.com/NobleFactor/noblefactor-engprod/issues/550), and [Agent entrypoints (#528)](https://github.com/NobleFactor/noblefactor-engprod/issues/528). This step prepares their authoritative documentation sources; their implementation and any schedule expansion require separate planning and Owner direction.

## 5. Acceptance and evidence

| Criterion | Required evidence |
| --- | --- |
| Preserve the complete review | Verified import manifest, retained original package/backups and Owner-response coverage |
| Account for prior requirements | Reviewed dispositions for 58 inventory groups and 19 original agent rules, with source references |
| Reflect approved policy consistently | O01–O11 mapped to active text and templates; conflict-register dispositions |
| Establish authority and applicability | A requirement has one active definition; local exceptions, historical records and deferred tooling are explicit |
| Support navigation | Entry point plus parent/child and related links; local path and anchor validation |
| Publish readable documents | Owner visual review; metadata, spelling, formatting and link results for the reviewed revision |
| Preserve maintained script behavior | Dedicated PR-template specification reconciled with policy; unresolved gate/admin behavior presented explicitly |
| Complete adoption | Owner approval, PR/check evidence, merge record and post-merge verification of the adopted entry point |

Use actual repository Make targets for required gates. Inspect gate scope: a tracked-file check may not include newly imported, untracked documents. Report that limitation and validate new files explicitly before claiming coverage. Do not stage files solely to make a checker see them without Git authority.

The documentation-only CI path is agreed policy but not implemented by this task. Do not bypass existing CI or claim that the lightweight path is available. Record any implementation dependency for follow-up review.

## 6. Phases

### 6.1. Preservation and preparation

- [x] Create tracking Feature and Task with the approved hierarchy.
- [x] Owner creates the issue-named worktree targeting `develop`.
- [x] Copy and hash-verify the entire draft, preserving originals and existing repository files.
- [x] Create a local documentation entry point.
- [x] Prepare this draft plan and initial conflict register.
- [x] Preserve the original plan in a committed checkpoint: d4960b7430ff717e256d3c2effcdb135ba9d1208, verified by the Owner-approved Git inspection on 2026-11-14. The former unchecked preparation entry was stale.
- [x] Establish the Owner-requested handbook-adoption schedule (#551), with Handbook consolidation (#420) as Step 1.
- [x] Refresh the execution plan for the handbook-adoption schedule, preserving the prior checkpoint and review evidence.
- [x] Obtain Owner review of this plan checkpoint before further handbook reconciliation: approved 2026-11-15, revision 7f9ba188ac6cf7555fee4d6b9fcc0a5ecebf3d64.
- [x] Integrate current develop through the Owner-run script on 2026-11-15, including Plan linking (#557), without changing the bytes of the fifteen local draft files. The successful script output is recorded in this conversation.
- [x] Recheck preservation on 2026-11-15: all 13 source snapshots match their hashes; all 42 imported destinations exist; the retained archive contains a backup matching every import-manifest hash. See [resumption evidence](../../engineering/review/reconciliation-2026-11-15.json).

### 6.2. Reconciliation

- [x] Review source requirements against draft definitions at section/sentence level: all 58 inventory groups, nineteen original agent rules, recorded decisions and newer pre-cutover guides have dispositions; Go/PowerShell word-level comparisons isolate the approved changes.
- [x] Resolve conflicts already answered by recorded decisions: the final pass applies the recorded rulings, corrects stale conflict descriptions and preserves the original review and responses. The duplicate F05 question and its correction remain disclosed.
- [x] Apply the Owner's 2026-11-16 adoption-review direction: compliance auditing replaces mandatory agent-authored breach reports and cost estimates. Update active requirements, current review records, requirement dispositions and the live-instruction transition; preserve original sources.
- [x] Present substantive gaps to the Owner individually: paragraph-layout scope and live-entrypoint cutover are resolved and recorded; effective GitHub review requirements remain explicit delivery prerequisites.
- [x] Resolve the live-entrypoint cutover boundary with the Owner: temporary overrides documented at handbook adoption; live migration assigned to the Claude/Codex host tasks, approved 2026-11-15.
- [x] Recover and incorporate the preserved external review findings F01–F19 without changing the original record; the current disposition retains the protection dependency and records the Owner's paragraph-scope resolution.
- [x] Reconcile detailed issue, language, metadata, release and PR-template responsibilities; required reviews remain an explicit adoption dependency; the Owner resolved paragraph-layout scope through Formatting migration (#570), which completes the remainder within this schedule before its closing review.
- [x] Record the Owner's formatting scope direction on 2026-11-15: new/revised prose conforms during adoption, and Formatting migration (#570), under Feature #419 and Epic #526, belongs to Handbook adoption (#551), whose project row holds its current Step. It covers all maintained documents and schedule assets and blocks the closing review (#565). No formatting backlog remains beyond schedule completion.
- [x] Record successor paths and preserve required source/history material: retained guide entrypoints preserve earlier anchors; eight pre-cutover sources and their hashes are captured under the adoption source manifest.

### 6.3. Navigation and publication quality

- [x] Complete parent/child and related-document navigation: all 23 active documents are reachable from the handbook entry point; 134 legacy section anchors and 448 local references pass verification.
- [x] Apply publication-quality language and stable terminology consistently: correct the final inline-code, circular-link, subsection-number and stale-review defects; preserve immutable historical text.
- [x] Bring templates into agreement with the settled definitions, including plan-derived document tables, explicit closure authorization and conservative merge gates. The subsequent Issue forms (#572) review exposed a competing issue outline; the candidate now delegates body shape to the account forms, preserving shared context guidance and parser-sensitive headings.
- [x] Verify all 58 inventory-group dispositions and preserve the original 19 agent rules; record outstanding adoption decisions in the current review.

### 6.4. Validation and adoption

- [x] Validate the actual changed-document set after the Owner's compliance-auditor review direction: 38 documents, 454 local references, preserved source hashes, all 58 inventory groups, nineteen original rule dispositions, 23 reachable active documents and 134 retained legacy anchors pass with no errors. Spelling passes for the eight revised documents.
- [x] Run applicable repository gates; record results and limitations: the Owner-run validation script exited 0 on 2026-11-15 in 166.1722 seconds, checking 38 documents and 440 local references and passing make check and all Test-Here suites. New untracked documents received explicit additional checks. The displayed output was truncated; the result applies to that tested draft. Later policy/status edits receive document checks, and delivery must still meet its required gates.
- [x] Obtain Owner review and adoption: the Owner merged PR #579 on 2026-11-16.
- [x] Analyze the Owner-run inspection log and verify the filesystem scope: 42 documentation/evidence paths, including the eight pre-cutover snapshots. No runtime code is included.
- [x] Obtain the Owner-run staging dry-run proof before handing over the commit/PR script: 42 named files passed on 2026-11-16 with the index and reviewed content unchanged. The receipt is /Users/david-noble/Workspace/NobleFactor/scratch/handbook-setup/420-staging-receipt.2WLiaxIK.json; the publication script rejects scope, index or content drift.
- [x] Prepare the Owner-run publication script from the successful staging receipt, with an explicit stop for adoption review and a separate guarded merge mode.
- [x] Publish the adoption candidate as PR #579 on 2026-11-16 at 391fdfcac66b91ab3699ecc7a1e9aff0dc7cfc8e; the Owner-run script passed make check and all four GitHub checks passed for that head. The final review head 2be2c9ab8ca59ba5c932910fcbb0adf90bc5d610 passed all four GitHub checks and was adopted by the Owner's merge.
- [x] Record the merge as 0694bf11684baf7952a7df73911bf5cd7d37637f and the successful post-merge entry-point, reference, navigation and source-preservation checks recorded on the issue.
- [x] Record the Owner's requested completion closure on 2026-11-16; incorporate the already established completion evidence in this approved documentation follow-up.
- [x] Record the successful Owner-run cleanup: git close-branch exited 0, removed the branch, worktree and sibling script, and synchronized the canonical clone.

## 7. Milestones and boundaries

| Milestone | Required | Current state |
| --- | --- | --- |
| Implementation | Yes: reconciled documents, templates, navigation and transition | Adopted in PR #579, including the Owner's compliance-auditor policy correction |
| Merge | Yes: approved adoption change on `develop` | Owner merged PR #579 on 2026-11-16 at 23:26:25 UTC as 0694bf11684baf7952a7df73911bf5cd7d37637f |
| Deployment | No separate runtime deployment is proposed; evaluate installed agent-instruction dependencies during cutover | No deployment claimed |
| Verification | Yes: required document checks, Owner review and post-merge entry-point verification | Owner-run make check and all four GitHub checks passed for delivered head 2be2c9ab8ca59ba5c932910fcbb0adf90bc5d610; post-merge verification and cleanup passed, and the Owner requested issue closure on 2026-11-16 |

The plan remains active once implementation is authorized and until required milestones are satisfied. Post-merge evidence is recorded immediately on the issue and incorporated through the approved documentation-follow-up process. Do not relabel an unfinished obligation complete merely to close the plan.

## 8. Related work and risks

Related issues include documentation standards #399, Bash standards #266/#267, agent conduct #316, PR tooling #157/#145 and issue-model work #331–#333. Their existence is not authority to alter other sessions' work. Reference dependencies and propose coordination through the Owner.

The original draft contains review material with superseded wording. The conflict review must distinguish active policy, retained detail and immutable source snapshots rather than treating every historical sentence as an instruction. Some links name removed source worktrees; replacement requires checking provenance, not guessing a new target.

Execution-plan approval does not grant direct agent communication, Git execution, PR execution, ruleset updates, sandbox qualification or repository-wide issue migrations. The existing approval requirements remain in force.

### 8.1. Live entrypoint cutover

On 2026-11-15, the resumed review verified that `/Users/david-noble/.Codex/AGENTS.md` and `/Users/david-noble/.claude/CLAUDE.md` both resolve to `/Users/david-noble/.local/share/devlore/writ/repos/personal/Home/common/.claude/CLAUDE.md`. That file still repeats the former session-wide PR restriction and literal Claude attribution, while O01 and O05 establish the reviewed replacement policies. The Owner approved the cutover timing on 2026-11-15: document temporary live-instruction overrides during handbook adoption, then migrate the live entrypoints in [Claude consumption (#562)](https://github.com/NobleFactor/noblefactor-engprod/issues/562) and [Codex consumption (#563)](https://github.com/NobleFactor/noblefactor-engprod/issues/563). The policies remain settled. This step adopts the handbook with the explicit transition described in [Temporary live-entrypoint overrides](../../engineering/index.md#temporary-live-entrypoint-overrides). Live instruction changes and their qualification belong to the host tasks; handbook adoption alone does not change current session permissions.

### 8.2. Issue-filing handoff

The Owner transferred Issue forms (#572), Issue filing (#338) and Filing enforcement (#504) onto Handbook adoption (#551), after this foundation. Issue forms retains Feature #331 ownership; the filing command and enforcement retain Feature #332 ownership. The inherited issue-forms plan is preserved at d3dc008cdf0e0c1889178cfc8d4da77b47ea5210. Its approved Task/Bug required fields are recorded from the Owner-relayed handoff; Area representation and the remaining form questions stay open. The handbook supplies shared process and references the account forms for body shape. The issue template's conflicting Acceptance outline is corrected before publication. Required dependencies and independent work are recorded in the Schedule issue and native links; no new implementation or Git authority is inferred from the transfers.

### 8.3. Delivery preparation on 2026-11-16

The Owner-run inspection log at /Users/david-noble/Workspace/NobleFactor/scratch/handbook-setup/420-git-inspection.EVgxQ4QU.log supplies the tracked/untracked scope. The delivery verifier checks all 42 paths and their current hashes, the branch and index state, document checks and the actual named-path Git staging dry run. The Owner runs it; the agent has no Git grant. The Owner completed the staging dry run on 2026-11-16; all 42 named files passed and the index and reviewed content were unchanged. Receipt: /Users/david-noble/Workspace/NobleFactor/scratch/handbook-setup/420-staging-receipt.2WLiaxIK.json. The delivery script incorporates that proof, script-preparation bookkeeping and the Owner's session-scope clarification in the implementation commit, publishes the candidate and stops for Owner review. Owner adoption, actual publication/merge and post-merge obligations remain separate; their subsequent evidence belongs on the issue and in the approved documentation follow-up.

The inherited account contribution terms still list the retired chore prefix. Apply the settled branch ruling and the current doc branch; Contribution terms (#265) retains the separate account/repository guide update. The effective develop rules were read again on 2026-11-16: one approving review, code-owner and last-push approval, quality-gate, and the configured quality/scanning requirements. No protection configuration was changed.

On 2026-11-16, the Owner clarified that the one-PR-at-a-time rule applies to this session's work. Other workers' PRs do not block it; the Owner coordinates their work. The publication guard checks only this session's assigned Handbook consolidation (#420) and Issue forms (#572) branches. This clarifies the existing instruction; no exception for an unrelated PR is required.

### 8.4. Owner review: compliance-auditor policy

On 2026-11-16, the Owner withdrew mandatory agent-authored breach reporting and breach-cost computations in favor of a compliance auditor. The active agent-operation requirements, live-instruction transition, requirement dispositions and current review records must reflect that direction. Retain factual review history and immutable source evidence; remove cost estimates from maintained current records. Participants still provide honest status, visible errors/blockers and corrective evidence. The auditor role and its tooling remain scheduled work, not an implemented capability of this documentation PR.

The original adoption candidate is published as PR #579 at 391fdfcac66b91ab3699ecc7a1e9aff0dc7cfc8e. This policy correction is a review amendment on the same branch, using an Owner-run commit/push and fresh checks and review for the new head. At that review checkpoint the issue remained Open and this plan active through adoption and post-merge obligations. Those obligations were subsequently satisfied as recorded in the completion review below.

## 9. Completion review — evidence established on 2026-11-16

The Owner adopted [PR #579](https://github.com/NobleFactor/noblefactor-engprod/pull/579), merging reviewed head 2be2c9ab8ca59ba5c932910fcbb0adf90bc5d610 as 0694bf11684baf7952a7df73911bf5cd7d37637f on 2026-11-16 at 23:26:25 UTC. The [issue's completion record](https://github.com/NobleFactor/noblefactor-engprod/issues/420) preserves the Owner's closure direction, verification and cleanup; the issue closed on 2026-11-16 at 23:37:34 UTC, and its Schedule row is Closed with the PR link.

The established post-merge checks covered 38 documents, 454 local references, 23 reachable active handbook documents, 134 retained legacy anchors, 58 inventory groups and nineteen original rule dispositions. The 42 delivery paths matched the reviewed content and merged result, with Issue standards also incorporating the separately merged Triage exception (#573). All four GitHub checks passed for the delivered head. Original sources and Reviewer evidence were preserved. These are the recorded adoption results, not a claim that later revisions received that same run.

The Owner-run git close-branch completed successfully, removed the branch, worktree and sibling script, and synchronized the canonical clone. There was no separate runtime deployment. Live host-entrypoint migration, role/context assets, issue forms and the remaining formatting migration retain their owning issues on Handbook adoption (#551).

This section incorporates the completion-only documentation obligation retained on the issue and Schedule. It records work already accepted and closed; it creates no additional completion milestone for Handbook consolidation (#420).
