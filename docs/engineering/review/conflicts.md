---
title: "Documentation conflict register"
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Documentation conflict register

Initial findings from local source comparison. This is not an exhaustive review or a replacement for the Owner's decisions. O01–O11 are settled; do not reopen them merely because retained text still needs editing. Preserve original responses and source snapshots.

| ID | Conflict or gap | Evidence | Disposition |
| --- | --- | --- | --- |
| C01 | Old active guides retain the chore tier, per-issue sessions, global PR serialization and final-implementation-commit completion, contradicting the approved replacements | Existing `docs/issue-standards.md`, `docs/guides/development-process.md`, `docs/guides/agent-rules.md`; draft O01–O04 | Apply settled decisions and review successor notices; no new policy decision needed |
| C02 | Work-assets wording always selects the default branch, whereas the Owner's O01 response specifies the clone's chosen PR target, usually the default branch | [Work assets](../work-assets.md), Workspace locations; [O01](open-decisions.md#o01--scope-of-pr-serialization) | Reconcile to chosen PR target using the existing Owner direction; preserve current `develop` target |
| C03 | PR-script source accepts UNSTABLE/BLOCKED, routinely uses admin merge and may treat absent checks as absent CI; related PR-tooling issue #145 identifies gate defects | Original `docs/guides/pr-script-template.md`; retained [PR snapshot](sources/pr-script-template.txt); related #145 | Policy resolved: refuse unresolved required checks, reviews or conversations; separate explicit Owner approval for any admin bypass. Reconcile executable templates before use |
| C04 | Prior issue-classification material still describes chores and schedule issues as chores even though O02 removes the chore tier | [Retained classification](issue-classification.md); [work organization](../work-organization.md) | Rewrite the active conceptual classification from O02; leave precise GitHub schedule representation deferred and historical text labeled |
| C05 | The original plan template teaches subject-based filenames and plan-before-issue ordering | Existing `docs/plans/TEMPLATE.md`; [new template](../../templates/plan.md) | Make the old entry point resolve to the approved issue-first template; do not retain competing instructions |
| C06 | New metadata standard delegates detailed family/type/status rules to a review companion rather than owning them fully | [Documentation standard](../../standards/documentation.md); [metadata detail](documentation-detail.md) | Consolidate authoritative detail in the standard while preserving vocabulary; review companion becomes evidence only |
| C07 | Detailed PowerShell validation says no function ends in return/value, while formatting permits return for early exits; examples include early exits and the PR source has final return/value | [PowerShell standard](../../standards/coding/powershell.md), sections 9/11; PR source | Distinguish final-result style from legitimate early exits; reconcile executable examples with the existing stated rule |
| C08 | Shared Go prose says parameter/return comment sections are always present, while PowerShell borrowing the Go form omits empty sections; some Go provider rules are product-specific | [Go standard](../../standards/coding/go.md), sections 4/5 and appendix; PowerShell section 10 | Resolved in shared guide: omit empty comment sections; remove DevLore resource/provider requirements and link to existing product guides. Product mirror/ownership wording needs separate DevLore reconciliation; extraction retained in devlore-go-extraction.json |
| C09 | Same-commit freshness and post-merge plan updates are reconciled by O03, but completion bookkeeping must not produce an endless sequence of completion-follow-up PRs | [Completion and progression](../process.md#completion-and-progression) | Resolved: completion-only follow-ups record established results without creating another delivery milestone; validation, review and merge authorization still apply |
| C10 | Canonical clones are read-only to agents, while retained PR cleanup/sync procedures mutate canonical-clone state | [Work assets](../work-assets.md); [agent authority](../agent-operation.md); PR source | Resolved: canonical-clone integration maintenance requires explicit Owner authorization separate from own-worktree commit/push authority; development in the clone remains prohibited |
| C11 | Documents lack consistent upward navigation; original review README states obsolete location/progress facts | [Entry point](../../index.md); original package README | Add navigation; retain original package README as historical evidence, not a current operational guide |
| C12 | Source/import manifests describe historical paths and hashes; subsequent edits change document hashes and the original source worktree is gone | [Import record](worktree-import.json); [source manifest](source-manifest.json) | Preserve original identity/hash evidence; add current references separately instead of falsifying import provenance |
| C13 | Related documentation issue #399 specifies additional editorial conventions absent from the baseline inventory | Related #399; [agent publication rule](../agent-operation.md#all-agents-writing-for-publication) | Verify status/applicability with Owner-provided review and reconcile overlap; do not assume all proposed rules are adopted or take over another issue |

## Schedule-format compatibility

The proposed schedule template changes header names to Position and Issue. Existing tooling consumes the third and fourth columns by position rather than validating their names. The recorded escaped-pipe parsing defect is tracked separately as issue #319. Before adoption, distinguish the human document schema from what the installed report actually accepts. Do not imply that this documentation-only change fixes either parser behavior.

## C14 — Personal-repository asset applicability

**Resolved:** Personal repositories follow the shared workflow and asset rules by default. The Owner may explicitly direct exceptions. The signing exemption is separate and does not waive other requirements. The authoritative applicability statement is in the [engineering index](../index.md#applicability). A single exception is not blanket authority to bypass the process.

## Initial review disposition

The Owner concurred with the initial review after clarifying Observer as an informed stakeholder. This pass removes repeated lifecycle and PR-scope policy, links template role fields to the sole definition, makes approval review explicit, adds concise case references, moves clone-retirement mechanics into a procedure and consolidates metadata in its standard. It also fixes work-organization prose, links the existing session model, distinguishes issue hierarchy from branch prefixes, and records anchor/header migrations.

The finding that number-only Issue headings are new is qualified: the original development process already requires them. Existing nonconforming active plans need an anchor-preserving migration; completed history is not silently rewritten. Repeated template assignment fields are retained as records, not duplicate role definitions. The reviewer’s findings file and original source snapshots remain unchanged.

C13 (related editorial work) still requires reconciliation. C08 shared-guide separation and C09 completion bookkeeping were subsequently resolved as recorded in the table; product-guide reconciliation remains a separate dependency. C10 integration authority was subsequently resolved as recorded above. C03 policy is resolved; executable-template reconciliation remains unfinished. C14 was subsequently resolved by the Owner as recorded above. This pass does not claim their resolution.

## Review method

For each finding, name the authoritative decision, affected definitions, templates and incoming references. Apply settled policy rather than asking for repeat approval. Bring a genuine unresolved policy choice to the Owner with the problem, options and recommendation, one at a time. Record disposition and evidence when the change is reviewed; do not call the register complete while source details remain unexamined.

## Navigation

- [Documentation entry point](../../index.md)
- [Engineering index](../index.md)
- [Issue 420 plan](../../plans/doc/420-consolidate-engineering.md)
- [Resolved decisions and Owner responses](open-decisions.md)

## Validation of this pass

Metadata, local targets and anchors passed for the 25 reconciled documents. The first repository spelling run reported four spelling errors in the working Owner-response record; spelling was corrected without changing the decisions. Exact pre-edit wording remains in the preserved /tmp package and timestamped backup. The reviewer findings and source snapshots were not edited.

The subsequent `make spelling` run passed. Full repository CI has not been run; this pass changed documentation only and does not claim adoption readiness. The reviewer findings and all preserved source snapshots were compared with the pre-edit backup and remain byte-for-byte unchanged.

## Editorial source layout

The Owner approved one source line per prose paragraph after confirming numbered sections as mandatory. The active draft has been unwrapped without changing fenced code. Historical source snapshots, reviewer findings and Owner-response history were not reformatted. Related issue #399 remains separate work; this document records the approved overlap without claiming that issue complete.

## F16 — Living incident record

The Owner selected an engprod-team-owned GitHub Project associated with noblefactor-engprod, with stable identifiers grouping recurring errors. Issue #317 remains historical/transition evidence. Provisioning, schema, spreadsheet export, duplicate-recognition mechanics and cost accounting remain separate design/implementation work. This resolves the destination choice without claiming an operational Project exists. The Reviewer’s findings file remains unchanged.
