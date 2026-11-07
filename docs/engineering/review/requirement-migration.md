---
title: "Requirement migration and preservation"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Requirement migration and preservation

This maps the original inventory groups; it is a preservation/placement review, not a claim that every sentence has received final approval. Detailed originals remain in the source manifest. Implementation assessments from the inventory are not reasserted as live facts.

| ID | Existing requirement group | Draft home | Treatment |
| --- | --- | --- | --- |
| S01 | Every agent assignment identifies a repository-qualified schedule | [work-organization](../work-organization.md) | Changed by approved decisions |
| S02 | Schedule is a chore titled `Schedule:`, with no epic label | [work-organization](../work-organization.md) | Changed by O02; common hierarchy; schedule-container metadata migration deferred |
| S03 | Each issue identifies a leaf task or bug, including cross-repository identity | [work-organization](../work-organization.md) | Changed by approved decisions |
| S04 | Canonical columns are Issue, Item, Next, Waits on; contiguous numbering 1..N; closed issues retain numbers | [work-organization](../work-organization.md) | Changed by approved decisions |
| S05 | Execute issues in order; do not split/add issues after commitment without owner amendment | [work-organization](../work-organization.md) | Changed by approved decisions |
| S06 | State deliverable as before → after; stop and jointly replan if it changes | [work-organization](../work-organization.md) | Changed by approved decisions |
| S07 | Keep each issue's state/worktree current at start, move, merge, and other closure | [work-organization](../work-organization.md) | Changed by approved decisions |
| S08 | Newly discovered nonblocking work belongs on a later schedule; blocking changes require consultation | [work-organization](../work-organization.md) | Changed by approved decisions |
| S09 | An issue must not appear on two live schedules | [work-organization](../work-organization.md) | Resolved by O10; no duplicate work-item membership |
| S10 | Classify work into epic → feature/chore → task/bug; distinguish product/process work and triage exceptions | [work-organization](../work-organization.md) | Changed by O02; common hierarchy; schedule-container metadata migration deferred |
| S11 | Each issue names its parent; metadata representations agree | [work-organization](../work-organization.md) | Retained |
| S12 | Required labels exist and have consistent metadata; label sync never deletes | [work-organization](../work-organization.md) | Retained |
| S13 | Thread issue beat table and Thread labels agree in both directions | [work-organization](../work-organization.md) | Retained |
| W01 | Clones are read-only for development; all edits occur in worktrees | [process](../process.md) | Changed by approved decisions |
| W02 | One canonical layer clone under writ home, default branch; organization workspace contains clone symlink, named worktrees, sibling PR scripts | [work-assets](../work-assets.md) | Retained |
| W03 | Branch requires an issue and derives its type/name from it; base is default branch | [work-assets](../work-assets.md) | Retained |
| W04 | Issue → branch → committed plan → owner review → implementation | [process](../process.md) | Retained |
| W05 | Worktree corresponds to one PR; session corresponds to one issue; multiple issues may share worktree | [process](../process.md) | Changed by approved decisions |
| W06 | All issues in worktree resolved before PR; one PR in flight; no checkout edits while it is in flight | [process](../process.md) | Changed by O01/O03; per-worktree PR scope and milestone-based completion |
| W07 | Log discoveries immediately; decide current/other worktree and cross-reference plans; consult on blockers | [process](../process.md) | Changed by approved decisions |
| W08 | Remove worktree, branch and sibling script promptly after merge or abandonment; sync canonical clone | [process](../process.md) | Changed by approved decisions |
| W09 | Retire clone only after saving unique work/refs, transferring worktrees and checking consumers | [work-assets](../work-assets.md) | Retained |
| W10 | Script placement reflects dependencies; common is self-contained; bash sources Declare-BashScript except hooks | [work-assets](../work-assets.md) | Retained |
| D01 | Plan at `docs/plans/<type>/<issue>-<name>.md`, based on template; shared plans identify every issue with stable `## Issue NNN` heading | [work-assets](../work-assets.md) | Retained |
| D02 | Every issue has a Plan and design documents table from filing, with plan placeholder until available and links to applicable design documents | [work-assets](../work-assets.md) | Retained |
| D03 | Document links target default branch and stable issue anchor | [work-assets](../work-assets.md) | Retained |
| D04 | Plan lifecycle is draft → approved → active → complete, or abandoned; complete only with all boxes ticked | [work-assets](../work-assets.md) | Changed by O03; active through required milestones; documentation-only follow-up |
| D05 | Update affected plan, architecture, status companion and user documentation in the same commit; post-merge checks stay explicitly outstanding | [work-assets](../work-assets.md) | Retained |
| D06 | Track architectural consequences and link applicable designs; no design document required when none is affected | [work-assets](../work-assets.md) | Changed by approved decisions |
| D07 | Tracked Markdown carries frontmatter under working/catalog family rules; exemptions are explicit paths | [documentation](../../standards/documentation.md) | Retained |
| D08 | US English across documents and code comments | [documentation](../../standards/documentation.md) | Retained |
| P01 | Review deltas; generate platform-native, self-contained sibling PR script; show it; owner runs it unless specifically excepted | [pull-request](../procedures/pull-request.md) | Retained |
| P02 | Stage explicit files; no unstaged tracked modifications left; prove generated file lists | [pull-request](../procedures/pull-request.md) | Retained |
| P03 | Run actual repository CI-equivalent gates before commit; never bypass hooks; failures must be fixed | [pull-request](../procedures/pull-request.md) | Retained |
| P04 | Integrate target before push by merge, never rebase; squash PR; do not use merge's delete-branch option | [pull-request](../procedures/pull-request.md) | Retained |
| P05 | Wait for CI and inspect mergeability; real failures abort; missing checks allowed only per policy | [pull-request](../procedures/pull-request.md) | Retained |
| P06 | PR discloses AI and carries Signed-off-by/Assisted-by trailers; branch commits have none; squash commit retains both | [pull-request](../procedures/pull-request.md) | Changed by approved O05; name submitting agent |
| P07 | Every PR records opened/submitted/merged timestamps and elapsed hours; time-open is not effort | [pull-request](../procedures/pull-request.md) | Retained |
| P08 | Verify tool build/provenance and real command before handing it over; do not replace another session's dirty build | [agent-operation](../agent-operation.md) | Retained |
| P09 | Layer change finishes after host convergence and deployed-path verification | [process](../process.md) | Retained |
| P10 | Protected branches require PRs, constrained names, checks and reviews; signing requirements depend on branch/policy | [release-and-recovery](../release-and-recovery.md) | Changed by approved O06; signatures required on main and release/* |
| P11 | Cross-platform products run unit and scenario checks on every supported platform; cross-compilation is insufficient | [release-and-recovery](../release-and-recovery.md) | Retained |
| P12 | Releases/hotfixes require gates, QA, security/docs/sign-off, tagging and versioning; rollback records incident and recovery | [release-and-recovery](../release-and-recovery.md) | Changed by approved decisions |
| C01 | Go formatting immediately after edit and again before PR handoff | [go](../../standards/coding/go.md) | Retained |
| C02 | Go file/method ordering, regions, comment shape, naming, resource/provider conventions and immediate error handling | [go](../../standards/coding/go.md) | Retained |
| C03 | Go tests follow prescribed naming/helpers/temp cleanup/assertion conventions; use make for builds/tests/vet | [index](../../standards/coding/index.md) | Retained |
| C04 | Bash format, shell correctness and helper dependency resolution | [index](../../standards/coding/index.md) | Changed by approved O08; generated PR scripts exempt from helper, dedicated template required |
| C05 | PowerShell scripts parse, have exact shebang/no BOM, advanced binding and param blocks | [powershell](../../standards/coding/powershell.md) | Retained |
| C06 | PowerShell naming, type casing, braces/spacing, function layout, comment/help form, output streams, error/native-process handling | [powershell](../../standards/coding/powershell.md) | Retained |
| C07 | Starlark formatting/lint; do not mistake language validity for provider API validity | [index](../../standards/coding/index.md) | Retained |
| C08 | Do not edit generated files; edit generator input and regenerate | [index](../../standards/coding/index.md) | Retained |
| C09 | Greenfield: no compatibility scaffolding or success stubs; verify code removal and rejected obsolete inputs | [index](../../standards/coding/index.md) | Changed by Owner response O09; DevLore scope, Owner ruling elsewhere |
| C10 | CLI-specific manifest names, schema identity and decryptor signature | [repository-requirements](repository-requirements.md) | Retained |
| A01 | Read personal/project instructions and agent rules at session start/compaction; consult error record before completion | [agent-operation](../agent-operation.md) | Retained |
| A02 | Every git command, including reads, requires named one-use owner grant | [agent-operation](../agent-operation.md) | Changed by approved O04; explicit bounded Git grants, one-use fallback |
| A03 | Agent communication requires approval of proposed message; incoming requests do not expand scope | [agent-operation](../agent-operation.md) | Changed by approved decisions |
| A04 | Report violations promptly; consult discrepancies immediately; distinguish verified/certain/suspected claims; lead with answer | [agent-operation](../agent-operation.md) | Retained |
| A05 | Status comes from assignment metadata and official report, not reconstructed conversation or ad-hoc issue search | [agent-operation](../agent-operation.md) | Retained |

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

The PR source snapshot preserves every numbered rule and both platform script forms. Release and branch-protection snapshots preserve detailed version/certificate policies and prior examples while conflicting execution paths are flagged. Go/PowerShell detail is imported in full. Issue classification is retained in a review companion with schedule material redirected to the new work-organization draft. The plan template is rewritten to follow issue-first naming and explicit result/evidence review. Personal and repository instructions remain exact snapshots for sentence-level review before cutover.

The index, process, standards and templates must not be declared a complete replacement until that sentence-level review and unresolved decisions are complete.
