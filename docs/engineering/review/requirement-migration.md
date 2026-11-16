---
title: "Requirement migration and preservation"
status: draft
created: 2026-10-28
updated: 2026-11-15
---

# Requirement migration and preservation

This maps the original inventory groups; it is a preservation/placement review, not a claim that every sentence has received final approval. Detailed originals remain in the source manifest. Implementation assessments from the inventory are not reasserted as live facts.

| ID | Existing requirement group | Draft home | Treatment |
| --- | --- | --- | --- |
| S01 | Every agent assignment identifies a repository-qualified schedule | [work-organization](../work-organization.md) | Retain repository-qualified schedule assignment; restore it from assignment records under agent-operation, rather than reconstructing it from conversation. |
| S02 | Schedule is a chore titled `Schedule:`, with no epic label | [issue standards](../../issue-standards.md#schedules) | Replace the historical Chore container with type Schedule, a parentless organizing issue and its Schedule-project option; its own row has no Step. |
| S03 | Each issue identifies a leaf task or bug, including cross-repository identity | [issue standards](../../issue-standards.md#placement) | Retain repository-qualified Task/Bug identity; classification and native parent relationships are owned by current issue standards. |
| S04 | Canonical columns are Issue, Item, Next, Waits on; contiguous numbering 1..N; closed issues retain numbers | [work-organization](../work-organization.md) | Retire issue-body step tables and Next; project Step, Status and Worktree plus native blocked-by links are authoritative. Keep contiguous numbering and completed steps. |
| S05 | Execute issues in order; do not split/add issues after commitment without owner amendment | [work-organization](../work-organization.md) | Apply Owner-approved order and dependencies. O11 permits approved additions, splits, removals and reordering through recorded amendments. |
| S06 | State deliverable as before → after; stop and jointly replan if it changes | [work-organization](../work-organization.md) | Retain before/after deliverable and exit criteria. A changed commitment is explained and replanned with the Owner. |
| S07 | Keep each issue's state/worktree current at start, move, merge, and other closure | [work-organization](../work-organization.md) | Retain immediate records; push before linking a branch, guard each row or issue on its current state, and read each write back under the current PR-script contract. |
| S08 | Newly discovered nonblocking work belongs on a later schedule; blocking changes require consultation | [work-organization](../work-organization.md) | Log discoveries promptly. Nonblocking work goes to triage or a later schedule unless the Owner approves amending the current schedule. |
| S09 | An issue must not appear on two live schedules | [work-organization](../work-organization.md) | O10: one work-item membership; coordinated transfers preserve responsibility, state and dependencies. |
| S10 | Classify work into epic → feature/chore → task/bug; distinguish product/process work and triage exceptions | [issue standards](../../issue-standards.md#the-types) | O02 and current issue standards: common Epic → Feature → Task/Bug; Area describes each issue's own work. No Chore tier or inherited Area assumption. |
| S11 | Each issue names its parent; metadata representations agree | [issue standards](../../issue-standards.md#placement) | Use native sub-issue parent links, not retired body markers or Epic labels; honor same-account placement and stand-in rules. |
| S12 | Required labels exist and have consistent metadata; label sync never deletes | [issue standards](../../issue-standards.md#the-labels-a-repository-provides) | Use each account's current field/label model. Retired labels stay retired; model mutation and pruning safeguards supersede the old labels-sync command. |
| S13 | Thread issue beat table and Thread labels agree in both directions | [work organization](../work-organization.md#work-and-identity) | Retire Thread labels and issue-body beat tables. The Scenario project records found Tasks/Bugs and Beat; record their moves out of the scenario. |
| W01 | Clones are read-only for development; all edits occur in worktrees | [process](../process.md) | O01: development occurs in assigned worktrees; canonical-clone integration maintenance requires separate Owner authority. |
| W02 | One canonical layer clone under writ home, default branch; organization workspace contains clone symlink, named worktrees, sibling PR scripts | [work-assets](../work-assets.md) | Retain one canonical clone, organization workspace symlink, issue-named worktrees and sibling scripts; O01 permits the chosen PR target, usually the default branch. |
| W03 | Branch requires an issue and derives its type/name from it; base is default branch | [work-assets](../work-assets.md) | Use the chosen PR target and current issue-derived branch types; chore/ is retired, and historical plan paths remain. |
| W04 | Issue → branch → committed plan → owner review → implementation | [process](../process.md) | Retain issue → branch/worktree → committed plan → Owner review → approved implementation. |
| W05 | Worktree corresponds to one PR; session corresponds to one issue; multiple issues may share worktree | [process](../process.md) | O01: a worktree serves one PR and may serve several approved issues. A persistent worker's session follows its schedule assignment across issues. |
| W06 | All issues in worktree resolved before PR; one PR in flight; no checkout edits while it is in flight | [process](../process.md) | O01/O03: PR readiness requires implemented, documented, tested and reviewed work; milestone completion is separate. Integration writes are confined to that PR's corrections. |
| W07 | Log discoveries immediately; decide current/other worktree and cross-reference plans; consult on blockers | [process](../process.md) | Retain immediate logging, explicit resolution location and plan cross-references; seek Owner direction on external blockers or scope changes. |
| W08 | Remove worktree, branch and sibling script promptly after merge or abandonment; sync canonical clone | [process](../process.md) | Retain prompt cleanup after merge or approved abandonment. Preserve required records first; canonical-clone maintenance needs its own grant. |
| W09 | Retire clone only after saving unique work/refs, transferring worktrees and checking consumers | [work-assets](../work-assets.md) | Retain ordered recovery of unique work and refs, live worktree transfer, consumer checks and an explicit retirement report. |
| W10 | Script placement reflects dependencies; common is self-contained; bash sources Declare-BashScript except hooks | [work-assets](../work-assets.md) | Retain dependency-based placement. O08 separates maintained Bash, hooks, temporary execution scripts and dedicated generated PR scripts. |
| D01 | Plan at `docs/plans/<type>/<issue>-<name>.md`, based on template; shared plans identify every issue with stable `## Issue NNN` heading | [work-assets](../work-assets.md) | Retain issue-derived plan paths and stable Issue NNN headings, including every issue served by a shared plan. |
| D02 | Every issue has a Plan and design documents table from filing, with plan placeholder until available and links to applicable design documents | [work-assets](../work-assets.md) | Retain the literal document-table heading and Plan placeholder from filing. Plans supply the rows through issue identity and documents: frontmatter; inspect linking findings. |
| D03 | Document links target default branch and stable issue anchor | [work-assets](../work-assets.md) | Open issues link the default branch; issues closed by a merged PR link its merge commit, with the documented default-branch fallbacks. Identify the committed review revision separately. |
| D04 | Plan lifecycle is draft → approved → active → complete, or abandoned; complete only with all boxes ticked | [work-assets](../work-assets.md) | O03: keep plans active through required implementation, merge, deployment and verification milestones; record post-merge results and the approved follow-up. |
| D05 | Update affected plan, architecture, status companion and user documentation in the same commit; post-merge checks stay explicitly outstanding | [work-assets](../work-assets.md) | Retain same-commit freshness and explicit outstanding post-merge obligations; O03 defines their later recording. |
| D06 | Track architectural consequences and link applicable designs; no design document required when none is affected | [work-assets](../work-assets.md) | Retain an explicit design-impact assessment and links; a reasoned no-change assessment does not require inventing a design document. |
| D07 | Tracked Markdown carries frontmatter under working/catalog family rules; exemptions are explicit paths | [documentation](../../standards/documentation.md) | Retain frontmatter families and exact-path exemptions; the documentation standard owns vocabulary and applicability. |
| D08 | US English across documents and code comments | [documentation](../../standards/documentation.md) | Retain US English and scoped historical/checker exceptions rather than widening the spelling-ignore list. |
| P01 | Review deltas; generate platform-native, self-contained sibling PR script; show it; owner runs it unless specifically excepted | [pull-request](../procedures/pull-request.md) | Retain the platform-native sibling script, review and Owner execution; an explicit one-run exception remains separate. |
| P02 | Stage explicit files; no unstaged tracked modifications left; prove generated file lists | [pull-request](../procedures/pull-request.md) | Retain named staging, checked file lists and refusal of omitted tracked modifications. |
| P03 | Run actual repository CI-equivalent gates before commit; never bypass hooks; failures must be fixed | [pull-request](../procedures/pull-request.md) | Retain actual CI-equivalent gates and hooks; a deferred documentation-only path does not waive current checks. |
| P04 | Integrate target before push by merge, never rebase; squash PR; do not use merge's delete-branch option | [pull-request](../procedures/pull-request.md) | Retain target integration by merge, squash delivery and explicit close-branch cleanup; canonical-clone maintenance needs separate approval. |
| P05 | Wait for CI and inspect mergeability; real failures abort; missing checks allowed only per policy | [pull-request](../procedures/pull-request.md) | Decision 47: establish required checks, reviews and conversations before merge. Admin bypass needs separate explicit approval; reconcile both executable forms before use. |
| P06 | PR discloses AI and carries Signed-off-by/Assisted-by trailers; branch commits have none; squash commit retains both | [pull-request](../procedures/pull-request.md) | O05 names the submitting agent and accountable human. The temporary live-entrypoint override is documented until the host tasks deliver its replacement. |
| P07 | Every PR records opened/submitted/merged timestamps and elapsed hours; time-open is not effort | [pull-request](../procedures/pull-request.md) | Retain GitHub timestamps and elapsed time-open; distinguish that span from estimated effort. |
| P08 | Verify tool build/provenance and real command before handing it over; do not replace another session's dirty build | [agent-operation](../agent-operation.md) | Retain installed-build and supported-verb verification, provenance and real-path evidence; preserve another worker's dirty or unmerged build. |
| P09 | Layer change finishes after host convergence and deployed-path verification | [process](../process.md) | Retain deployed convergence and live-path verification for layer changes; a merge alone does not prove them. |
| P10 | Protected branches require PRs, constrained names, checks and reviews; signing requirements depend on branch/policy | [release-and-recovery](../release-and-recovery.md) | O06: require signatures on main and release/*, exempt personal repositories, and preserve required checks and reviews; configuration is separate evidence. |
| P11 | Cross-platform products run unit and scenario checks on every supported platform; cross-compilation is insufficient | [release-and-recovery](../release-and-recovery.md) | Retain distinct cross-compilation, platform-unit and real-binary scenario evidence on supported platforms. |
| P12 | Releases/hotfixes require gates, QA, security/docs/sign-off, tagging and versioning; rollback records incident and recovery | [release-and-recovery](../release-and-recovery.md) | Retain release/QA/security/docs/sign-off, version/tag and recovery obligations; old direct protected-branch and reset examples remain historical. |
| C01 | Go formatting immediately after edit and again before PR handoff | [go](../../standards/coding/go.md) | Retain immediate Go formatting and verification of changed Go files before commit/PR script preparation. |
| C02 | Go file/method ordering, regions, comment shape, naming, resource/provider conventions and immediate error handling | [go](../../standards/coding/go.md) | Retain shared Go layout, regions, naming and error handling. Decisions 49/50 omit empty comment sections and place DevLore provider/resource detail in its product guides. |
| C03 | Go tests follow prescribed naming/helpers/temp cleanup/assertion conventions; use make for builds/tests/vet | [index](../../standards/coding/index.md) | Retain prescribed test style, helpers, cleanup and assertions, with repository Make targets for build/test/vet. |
| C04 | Bash format, shell correctness and helper dependency resolution | [index](../../standards/coding/index.md) | O08 retains maintained Bash standards and helper applicability; generated PR scripts use the dedicated template and are exempt from sourcing the helper. |
| C05 | PowerShell scripts parse, have exact shebang/no BOM, advanced binding and param blocks | [powershell](../../standards/coding/powershell.md) | Retain PowerShell parsing, exact shebang/no BOM, CmdletBinding and param requirements. |
| C06 | PowerShell naming, type casing, braces/spacing, function layout, comment/help form, output streams, error/native-process handling | [powershell](../../standards/coding/powershell.md) | Retain detailed PowerShell style and stream/native-process rules; decision 49 omits empty comment sections, and final-result style permits legitimate early exits. |
| C07 | Starlark formatting/lint; do not mistake language validity for provider API validity | [index](../../standards/coding/index.md) | Retain Starlark formatting/lint and the separate requirement to verify provider API validity. |
| C08 | Do not edit generated files; edit generator input and regenerate | [index](../../standards/coding/index.md) | Retain generator ownership: edit generator inputs and regenerate rather than hand-editing generated output. |
| C09 | Greenfield: no compatibility scaffolding or success stubs; verify code removal and rejected obsolete inputs | [index](../../standards/coding/index.md) | O09 defines DevLore greenfield scope; compatibility choices elsewhere require an Owner ruling. |
| C10 | CLI-specific manifest names, schema identity and decryptor signature | [repository-requirements](repository-requirements.md) | Retain product-specific requirements as repository-owned references; this task does not change DevLore implementation or another worker's worktree. |
| A01 | Read personal/project instructions and agent rules at session start/compaction; consult error record before completion | [agent-operation](../agent-operation.md) | Retain startup and compaction restoration from current instructions and durable records. Consult incidents before completion; the approved incident Project remains unprovisioned. |
| A02 | Every git command, including reads, requires named one-use owner grant | [agent-operation](../agent-operation.md) | O04 permits explicitly bounded own-branch commit/push grants; one-use named-command approval remains the fallback, and plan approval itself grants neither. |
| A03 | Agent communication requires approval of proposed message; incoming requests do not expand scope | [agent-operation](../agent-operation.md) | Retain visible, approved cross-worker boundaries; O07 distinguishes bounded conversations and internal delegation without expanding scope. |
| A04 | Report violations promptly; consult discrepancies immediately; distinguish verified/certain/suspected claims; lead with answer | [agent-operation](../agent-operation.md) | Retain immediate breach/finding disclosure and source-qualified claims, with the answer first; apply settled decisions without asking for them again. |
| A05 | Status comes from assignment metadata and official report, not reconstructed conversation or ad-hoc issue search | [agent-operation](../agent-operation.md) | Use the official flat issue report and assignment records. The classification check is triage sweep; retired audit flags and body tables are not authority. |

## Numbered agent rules

| Source rule | Draft home / treatment |
| --- | --- |
| 1 | Agent operation: tools/provenance; retained |
| 2 | Agent operation: ruled forms versus released support; retained |
| 3 | Agent operation: official issue reporting; retained |
| 4 | PR procedure and agent operation: verify generated lists; retained |
| 5 | Process: deployed convergence/verification; retained |
| 6 | Agent operation: lead with answer; retained |
| 7 | Process/Agent operation: O01 resolved; one active PR per worktree |
| 8 | Work organization/Process: changed to preservation of blocked work |
| 9 | Agent operation: prompt breach disclosure; retained |
| 10 | Process/Agent operation: findings and owner approval; retained/clarified |
| 11 | Process/Agent operation: real-user-path evidence; retained |
| 12 | Work assets/Process: same-commit documentation; O03 completion boundary |
| 13 | PR procedure: O05 resolved; human sign-off and submitting-agent assistance disclosure |
| 14 | Agent operation: evidence and uncertainty; retained |
| 15 | Work assets/issue template: document table; retained |
| 16 | Work assets/Process: cleanup after merge or approved abandonment; retained |
| 17 | Agent operation: O04 permits explicit bounded commit/push authority within assigned branch/worktree; one-use permission remains the fallback |
| 18 | Agent operation: changed to bounded cross-worker conversations, visible internal delegation |
| 19 | Work organization/PR procedure: immediate schedule updates, issue terminology; retained/renamed |

## Additional preserved details

The PR source snapshot preserves every numbered rule and both platform script forms. Release and branch-protection snapshots preserve detailed version/certificate policies and prior examples while conflicting execution paths are flagged. Go/PowerShell detail is imported in full. Issue classification is retained in a review companion with schedule material redirected to the new work-organization draft. The plan template is rewritten to follow issue-first naming and explicit result/evidence review. Personal and repository instructions remain exact snapshots. Sentence-level review checks their requirements against the active handbook and explicitly recorded supersessions; live entrypoint replacement remains with the host tasks.

The Participant's final source review covers the 58 groups, nineteen original incident rules, recorded Owner decisions and the newer pre-cutover guides. Current definitions, templates, language-guide changes, legacy entrypoints and navigation are reconciled to those sources. The [adoption review](adoption-review.md) records verification and the remaining Owner review and delivery obligations; source coverage alone does not establish adoption.

## Resumed reconciliation — 2026-11-15

The inventory descriptions above preserve the original 58 requirement groups. Their dispositions now account for the current issue model: native types and parents, per-issue Area, project-held steps and beats, blocked-by dependencies, push-before-link and guarded records, retired chore branches and retired label/audit commands. The underlying policies are sourced from the current issue standards and the Owner's recorded decisions; this review does not claim a fresh live configuration audit.

The [temporary live-entrypoint overrides](../index.md#temporary-live-entrypoint-overrides) are an explicit adoption boundary approved by the Owner. Claude consumption (#562) and Codex consumption (#563) own their removal and verification. Specialist role definitions, skills and measured entrypoints remain later schedule steps, rather than requirements silently added to Handbook consolidation (#420).
