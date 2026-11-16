---
title: "Documentation conflict register"
status: draft
created: 2026-10-29
updated: 2026-11-16
---

# Documentation conflict register

Initial findings from local source comparison. This is not an exhaustive review or a replacement for the Owner's decisions. O01–O11 are settled; do not reopen them merely because retained text still needs editing. Preserve original responses and source snapshots.

| ID | Conflict or gap | Evidence | Disposition |
| --- | --- | --- | --- |
| C01 | Old active guides retain the chore tier, per-issue sessions, session-wide PR serialization and final-implementation-commit completion, contradicting the approved replacements | Existing `docs/issue-standards.md`, `docs/guides/development-process.md`, `docs/guides/agent-rules.md`; draft O01–O04 | Apply settled decisions and review successor notices; no new policy decision needed |
| C02 | Work-assets wording always selects the default branch, whereas the Owner's O01 response specifies the clone's chosen PR target, usually the default branch | [Work assets](../work-assets.md), Workspace locations; [O01](open-decisions.md#o01--scope-of-pr-serialization) | Reconcile to chosen PR target using the existing Owner direction; preserve current `develop` target |
| C03 | PR-script source accepts UNSTABLE/BLOCKED, routinely uses admin merge and may treat absent checks as absent CI; related PR-tooling issue #145 identifies gate defects | Original `docs/guides/pr-script-template.md`; retained [PR snapshot](sources/pr-script-template.txt); related #145 | Policy resolved: refuse unresolved required checks, reviews or conversations; separate explicit Owner approval for any admin bypass. Reconcile executable templates before use |
| C04 | Prior issue-classification material still describes chores and schedule issues as chores even though O02 removes the chore tier | [Retained classification](issue-classification.md); [work organization](../work-organization.md) | Reconciled against current Issue standards and Work organization: native types/parents, Schedule project fields and dependencies are authoritative; the retained classification companion is historical |
| C05 | The original plan template teaches subject-based filenames and plan-before-issue ordering | Existing `docs/plans/TEMPLATE.md`; [new template](../../templates/plan.md) | Make the old entry point resolve to the approved issue-first template; do not retain competing instructions |
| C06 | New metadata standard delegates detailed family/type/status rules to a review companion rather than owning them fully | [Documentation standard](../../standards/documentation.md); [metadata detail](documentation-detail.md) | Consolidate authoritative detail in the standard while preserving vocabulary; review companion becomes evidence only |
| C07 | Detailed PowerShell validation says no function ends in return/value, while formatting permits return for early exits; examples include early exits and the PR source has final return/value | [PowerShell standard](../../standards/coding/powershell.md), sections 9/11; PR source | Distinguish final-result style from legitimate early exits; reconcile executable examples with the existing stated rule |
| C08 | Shared Go prose says parameter/return comment sections are always present, while PowerShell borrowing the Go form omits empty sections; some Go provider rules are product-specific | [Go standard](../../standards/coding/go.md), sections 4/5 and appendix; PowerShell section 10 | Resolved in shared guide: omit empty comment sections; remove DevLore resource/provider requirements and link to existing product guides. Product mirror/ownership wording needs separate DevLore reconciliation; extraction retained in devlore-go-extraction.json |
| C09 | Same-commit freshness and post-merge plan updates are reconciled by O03, but completion bookkeeping must not produce an endless sequence of completion-follow-up PRs | [Completion and progression](../process.md#completion-and-progression) | Resolved: completion-only follow-ups record established results without creating another delivery milestone; validation, review and merge authorization still apply |
| C10 | Canonical clones are read-only to agents, while retained PR cleanup/sync procedures mutate canonical-clone state | [Work assets](../work-assets.md); [agent authority](../agent-operation.md); PR source | Resolved: canonical-clone integration maintenance requires explicit Owner authorization separate from own-worktree commit/push authority; development in the clone remains prohibited |
| C11 | Documents lack consistent upward navigation; original review README states obsolete location/progress facts | [Entry point](../../index.md); original package README | Add navigation; retain original package README as historical evidence, not a current operational guide |
| C12 | Source/import manifests describe historical paths and hashes; subsequent edits change document hashes and the original source worktree is gone | [Import record](worktree-import.json); [source manifest](source-manifest.json) | Preserve original identity/hash evidence; add current references separately instead of falsifying import provenance |
| C13 | Related documentation issue #399 specifies additional editorial conventions absent from the baseline inventory | Related #399; [agent publication rule](../agent-operation.md#all-agents-writing-for-publication) | Reconciled through the Owner's publication direction and decisions 52/53/56: numbered sections, paragraph layout and its on-schedule migration are explicit. Documentation standards (#399) retains its separate scope; no completion or adoption of every proposal in that issue is claimed |

## Schedule-format compatibility

Resolved against the current issue model on 2026-11-15: the Schedule project's rows are authoritative, with Step, Status, Worktree and native blocked-by dependencies. The Schedule issue links its filtered board and retains its deliverable, amendments and document table. The schedule template no longer proposes Position/Issue/Next/Waits-on tables. The old escaped-pipe parser concern (#319) is historical evidence, rather than a dependency of the current project-held schedule format. This documentation pass does not claim a parser fix.

## C14 — Personal-repository asset applicability

**Resolved:** Personal repositories follow the shared workflow and asset rules by default. The Owner may explicitly direct exceptions. The signing exemption is separate and does not waive other requirements. The authoritative applicability statement is in the [engineering index](../index.md#applicability). A single exception is not blanket authority to bypass the process.

## Initial review disposition

The Owner concurred with the initial review after clarifying Observer as an informed stakeholder. This pass removes repeated lifecycle and PR-scope policy, links template role fields to the sole definition, makes approval review explicit, adds concise case references, moves clone-retirement mechanics into a procedure and consolidates metadata in its standard. It also fixes work-organization prose, links the existing session model, distinguishes issue hierarchy from branch prefixes, and records anchor/header migrations.

The finding that number-only Issue headings are new is qualified: the original development process already requires them. Existing nonconforming active plans need an anchor-preserving migration; completed history is not silently rewritten. Repeated template assignment fields are retained as records, not duplicate role definitions. The reviewer’s findings file and original source snapshots remain unchanged.

The initial review left C03's executable forms and C13's editorial overlap for reconciliation. The resumed pass has now reconciled both script forms and the Owner-approved editorial rules, including the formatting migration within this schedule. C08's product-guide follow-up remains outside this task; the shared-guide separation, C09 completion bookkeeping, C10 integration authority and C14 applicability retain their recorded resolutions. Current evidence and remaining adoption requirements are in the [adoption review](adoption-review.md).

## Review method

For each finding, name the authoritative decision, affected definitions, templates and incoming references. Apply settled policy rather than asking for repeat approval. Bring a genuine unresolved policy choice to the Owner with the problem, options and recommendation, one at a time. Record disposition and evidence when the change is reviewed; do not call the register complete while source details remain unexamined.

## Navigation

- [Documentation entry point](../../index.md)
- [Engineering index](../index.md)
- [Issue 420 plan](../../plans/doc/420-consolidate-engineering.md)
- [Resolved decisions and Owner responses](open-decisions.md)

## Validation history

At the initial review, metadata, local targets and anchors passed for the 25 reconciled documents. The first repository spelling run reported four spelling errors in the working Owner-response record; spelling was corrected without changing the decisions. Exact pre-edit wording remains in the preserved /tmp package and timestamped backup. The reviewer findings and source snapshots were not edited.

The initial review's subsequent spelling run passed; full repository CI had not then been run. The Reviewer findings and all preserved source snapshots matched the pre-edit backup. For the resumed candidate, the Owner-run validation and make check passed on 2026-11-15. The [current adoption review](adoption-review.md) identifies that evidence and the later document checks without claiming Owner adoption or completion.

## Editorial source layout

The Owner approved one source line per prose paragraph after confirming numbered sections as mandatory. The active draft has been unwrapped without changing fenced code. Historical source snapshots, reviewer findings and Owner-response history were not reformatted. Documentation standards (#399) remains separate work and does not itself commit the remaining migration. On 2026-11-15 the Owner directed [Formatting migration (#570)](https://github.com/NobleFactor/noblefactor-engprod/issues/570) onto Handbook adoption (#551): all maintained documents must conform by schedule completion. New and revised prose conforms during adoption; the comprehensive remainder blocks the closing review (#565), with current Steps held in the Schedule project. The inventory accounts for every maintained document and schedule asset while preserving immutable evidence.

## F16 — Living incident record

The Owner selected an engprod-team-owned GitHub Project associated with noblefactor-engprod, with stable identifiers grouping recurring errors. Issue #317 remains historical/transition evidence. Provisioning, schema, spreadsheet export and duplicate-recognition mechanics remain separate design/implementation work. The Owner's later direction on 2026-11-16 assigns findings to compliance auditing and withdraws mandatory breach reports and cost estimates. Cost accounting is not outstanding implementation work. The destination choice does not claim an operational Project exists. The Reviewer’s findings file remains unchanged.

## C15 — Live entrypoint cutover

Resolved by the Owner on 2026-11-15: Handbook consolidation (#420) documents temporary overrides in the existing personal-layer instructions. Claude consumption (#562) and Codex consumption (#563) own the live entrypoint migration. The shared policies are settled; this decision establishes the cutover boundary. The [handbook transition](../index.md#temporary-live-entrypoint-overrides) identifies the current session-wide PR restriction, literal Claude attribution, scope and removal evidence. The two live host paths currently resolve to the same personal source, so their plans must coordinate that source without duplicate or conflicting delivery. No personal-layer edit or expansion of current session permissions is claimed by this resolution.

## C16 — Approval-sequence question withdrawn

The question raised on 2026-11-15 reopened preserved finding F05, already addressed in the review and covered by the Owner's concurrence. It was withdrawn; the existing explicit-start sequence remains. [The adoption review](adoption-review.md) records the unnecessary question, its correction and current dispositions of F01–F19. F17 is confirmed by the current protection read, F18 is resolved through the Owner-approved on-schedule formatting migration, and F19 is clarified without changing metadata vocabulary.

## C17 — Issue-form authority and handbook drafting guide

The review of Issue forms (#572) found that the generic handbook outline used Acceptance where the classifier requires an unnumbered Evidence of completion heading. The Owner-relayed Claude handoff confirms that the account forms own the per-type body sections. The handbook issue guide now references those forms, preserves its shared assignment/scope/design/link guidance and old anchors, and records the parser-sensitive heading rule. The Owner transferred Issue forms (#572), Issue filing (#338) and Filing enforcement (#504) to this schedule; their feature ownership and settled form rulings are preserved. Runtime dry-run support in NobleFactor/devlore-cli#1170 is an explicit prerequisite for #338, not a silent workaround.

## C18 — PR serialization belongs to the session

On 2026-11-16, the Owner clarified that the one-PR-at-a-time rule applies to this session's work. Other workers' PRs do not block it; the Owner coordinates their work. The publication guard checks only this session's assigned Handbook consolidation (#420) and Issue forms (#572) branches. This clarifies the existing instruction; no exception for an unrelated PR is required.

## C19 — Compliance auditing replaces breach reports and cost estimates

Resolved by the Owner on 2026-11-16 during PR #579 adoption review: compliance auditing replaces mandatory agent-authored breach reports; breach-cost estimates are withdrawn. [Agent operation](../agent-operation.md#compliance-auditing) owns the current requirement. The requirement inventory, retained entrypoint, adoption review and live-instruction transition now identify the supersession. The original Reviewer findings and captured sources remain unchanged as historical evidence. This documentation correction does not implement the auditor or provision its Project.
