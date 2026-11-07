---
title: "Consolidate engineering documentation"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/420
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Consolidate engineering documentation

## 1. Problem and deliverable

Engineering requirements are distributed across overlapping process guides, standards, templates and agent instructions. The imported review draft incorporates the Owner's decisions but does not yet replace every conflicting definition or provide complete navigation.

Deliver a coherent documentation set on `develop` with one authoritative home per requirement, explicit applicability, consistent templates, navigable entry points and a reviewed transition from the existing documents. Preserve the Owner's comments, source evidence and decisions. This task documents the process; it does not implement the controller, sandbox, compliance tooling or GitHub configuration.

## Issue 420

[Documentation consolidation](https://github.com/NobleFactor/noblefactor-engprod/issues/420) is a Task under [shared engineering process documentation, Feature #419](https://github.com/NobleFactor/noblefactor-engprod/issues/419), within [Process, Epic #142](https://github.com/NobleFactor/noblefactor-engprod/issues/142). No schedule membership has been assigned; this plan does not modify another worker's schedule.

## 2. Roles and authority

- **Owner:** David Noble, accountable for policy, design and adoption decisions.
- **Participant:** Codex, preparing this plan, the documentation and supporting evidence under the Owner's direction.
- **Reviewer:** Claude Code is performing an initial read at the Owner's request. The Owner brings its findings into this review; no direct conversation has been authorized.
- **Observer:** no separate assignment recorded. Keep the Owner informed directly.

The Owner has approved the structure, recorded policy decisions and worktree import. This plan remains draft for its commit/review record. The Owner has explicitly directed review-driven reconciliation to proceed; that direction does not authorize commit, push, publication or policy adoption. No agent communication is authorized by naming a Reviewer here.

## 3. Current state and preservation

- Worktree: `~/Workspace/NobleFactor/noblefactor-engprod.420-consolidate-engineering`.
- Branch: `doc/420-consolidate-engineering`; target: `develop`.
- Import base: `59740c91f0183f2165a70f6aa3b352d1e5d42515`.
- All 42 package files were copied and hash-verified without overwriting existing repository files. The package README is preserved as `ENGINEERING-DOCUMENTATION-REVIEW.md`.
- The original `/tmp` package and verified backups under the organization workspace remain available.
- [Import manifest](../../engineering/review/worktree-import.json) records source/destination identities and content hashes. It is a record of the import, not a promise that subsequent edits retain those hashes.
- [Review decisions](../../engineering/review/open-decisions.md) records the resolutions of O01–O11 and preserves the Owner's responses.
- [Documentation entry point](../../index.md) exists. Consistent parent navigation and cutover of old active documents remain unfinished.

## 4. Design impact and intended implementation

The documentation architecture changes; product runtime architecture does not. Preserve the approved separation among process transitions, work organization, work assets, agent operation, release/recovery, documentation standards, language standards, procedures and templates.

Use `docs/index.md` as the entry point. Define roles once in the engineering process. Put shared policy in the appropriate authoritative document; other documents link to it. Keep historical evidence visibly separate from active instructions. Retain language-standard detail rather than replacing it with a general statement to use a linter.

Reconcile the old document paths through reviewed successor notices or precise retained responsibilities. Do not merely add a new directory while leaving competing active definitions. Preserve incoming links where practical; do not delete historical plans to remove inconvenient old wording.

Treat editorial corrections supported by settled decisions as consolidation work. Present substantive policy gaps to the Owner one at a time before selecting an answer. Record findings in the [conflict register](../../engineering/review/conflicts.md). Comparison with Claude Code's initial read follows when the Owner supplies it.

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
- [ ] Commit the plan under Owner authorization; no commit is claimed. The Owner has directed review-driven reconciliation to proceed in this worktree.

### 6.2. Reconciliation

- [ ] Review source requirements against draft definitions at section/sentence level.
- [ ] Resolve conflicts already answered by recorded decisions without asking for those decisions again.
- [ ] Present substantive gaps to the Owner individually.
- [ ] Incorporate the Owner-provided external review findings.
- [ ] Reconcile detailed issue, language, metadata, release and PR-template responsibilities.
- [ ] Record successor paths and preserve required source/history material.

### 6.3. Navigation and publication quality

- [ ] Complete parent/child and related-document navigation.
- [ ] Apply publication-quality language and stable terminology consistently.
- [ ] Bring templates into agreement with authoritative definitions.
- [ ] Verify the requirement mapping and conflict dispositions.

### 6.4. Validation and adoption

- [ ] Validate the actual changed-document set, including paths and anchors.
- [ ] Run applicable repository gates; record results and limitations.
- [ ] Obtain Owner review of the complete documentation and transition.
- [ ] Prepare the approved PR script and adoption PR; do not auto-close the issue while required post-merge evidence remains.
- [ ] Record merge and verify the adopted documentation entry point.
- [ ] Record completion approval and any documentation-only follow-up obligation.
- [ ] Clean up the worktree/script under the approved procedure after preserving outstanding records.

## 7. Milestones and boundaries

| Milestone | Required | Current state |
| --- | --- | --- |
| Implementation | Yes: reconciled documents, templates, navigation and transition | Draft import only; reconciliation pending |
| Merge | Yes: approved adoption change on `develop` | Not performed |
| Deployment | No separate runtime deployment is proposed; evaluate installed agent-instruction dependencies during cutover | No deployment claimed |
| Verification | Yes: required document checks, Owner review and post-merge entry-point verification | Import hashes and local link targets checked; remaining evidence pending |

The plan remains active once implementation is authorized and until required milestones are satisfied. Post-merge evidence is recorded immediately on the issue and incorporated through the approved documentation-follow-up process. Do not relabel an unfinished obligation complete merely to close the plan.

## 8. Related work and risks

Related issues include documentation standards #399, Bash standards #266/#267, agent conduct #316, PR tooling #157/#145 and issue-model work #331–#333. Their existence is not authority to alter other sessions' work. Reference dependencies and propose coordination through the Owner.

The original draft contains review material with superseded wording. The conflict review must distinguish active policy, retained detail and immutable source snapshots rather than treating every historical sentence as an instruction. Some links name removed source worktrees; replacement requires checking provenance, not guessing a new target.

No direct agent communication, commits, pushes, PR execution, ruleset updates, sandbox claims or repository-wide issue migrations are authorized by this plan's draft status.
