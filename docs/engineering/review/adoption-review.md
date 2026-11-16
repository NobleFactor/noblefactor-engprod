---
title: "Handbook adoption review"
status: active
created: 2026-11-15
updated: 2026-11-16
---

# Handbook adoption review

The preserved review contains findings F01–F19. This record reconciles them with the current draft, subsequent Owner decisions and the live protection check. The [original findings](../../../ENGINEERING-DOCUMENTATION-REVIEW.findings.md) remain unchanged and match the preserved archive at SHA-256 `480cd66afef0fb149322766a4c817a74c74f459a97dabc40f13d462c62bdf8ef`.

Handbook consolidation (#420) prepares the adoption candidate. Owner review, repository-gate results and the dispositions below remain separate from publication or completion.

## 1. Findings and dispositions

| Finding | Current disposition |
| --- | --- |
| F01 | Authoritative requirement homes are linked from the handbook. Legacy entrypoints preserve anchors and point to those homes. |
| F02 | Dated cases and their source evidence are preserved; the newer pre-cutover guides are captured separately. |
| F03 | RACI defines Observer as informed stakeholder and Reviewer as the evaluation responsibility. |
| F04 | Git authority remains explicit; bounded grants do not arise from assignment or plan approval. |
| F05 | The committed plan is reviewed and explicit direction to start is awaited. This was already settled; the duplicate question on 2026-11-15 was withdrawn. |
| F06 | The approved departures, milestones, readable-code and cleanup distinctions remain. |
| F07 | The prior wording corrections are retained. |
| F08 | Current issue types and branch prefixes replace the retired chore scheme; historical paths remain. |
| F09 | Project rows replace the old issue-body schedule table; its former parser compatibility question is historical. |
| F10 | Persistent assignments link the current workstation architecture without claiming host qualification. |
| F11 | Approval records identify date, scope and revision; the execution-plan and cutover approvals are recorded. |
| F12 | The earlier finding was withdrawn. Stable issue headings and incoming guide anchors are retained. |
| F13 | Clone retirement remains its own procedure under the shared authority boundaries. |
| F14 | Work-assets freshness links the authoritative lifecycle and completion rules. |
| F15 | Shared rules apply to personal repositories by default, with explicit Owner-directed exceptions. |
| F16 | The Owner selected an engprod-owned incident Project; provisioning remains separate. Agent operation identifies the existing transition record and the retained cases. |
| F17 | Still an adoption dependency: the effective organization rules require eligible reviews. Ordinary examples stop on unmet requirements; a PR-specific Owner exception remains a separate possible route. |
| F18 | Resolved by the Owner on 2026-11-15: new and revised prose conforms during adoption; [Formatting migration (#570)](https://github.com/NobleFactor/noblefactor-engprod/issues/570) completes every remaining maintained document within this schedule. It remains under Feature #419 and Epic #526 and blocks the closing review (#565); the Schedule project's rows hold their current Steps. No formatting backlog is deferred beyond schedule completion. |
| F19 | Documentation standards distinguish accepted catalog type values from branch-bound working execution plans, which omit type. The validator's vocabulary is retained. |
| F20 | The review of Issue forms (#572) exposed a competing handbook body outline: its Acceptance heading would fail the classifier's Evidence of completion check. Resolved in the candidate by directing authors to the account forms and retaining shared context/link guidance and old anchors. The Owner-relayed handoff confirms the forms' authority and the approved Task/Bug required fields. |
| F21 | The inherited account contribution guide, read on 2026-11-16, still lists the retired chore branch prefix. The settled branch ruling governs this doc branch. Contribution terms (#265) owns the separate account/repository contribution-document work; no edit in that other workstream is included here. |

## 2. Effective protection dependency

The [live protection read](adoption-protection-2026-11-15.json) records organization review requirements alongside classic branch protection. The organization's one approving review, code-owner and last-push approval requirements remain effective even though the classic rule requires zero approvals. The normal template cannot manufacture eligible reviews. Resolve the adoption PR's review route or obtain its separate, explicit Owner exception before merging.

No protection configuration was changed by this consolidation. The conservative templates require established checks and review readiness; a concrete repository's verified policy must inform their generation.

## 3. Verification completed

The two Bash examples pass syntax, ShellCheck and formatting checks. The PowerShell merge form and composed first-script form pass the parser and the repository's PSScriptAnalyzer settings. Forty-two isolated gate/delivery fixtures cover passing checks, absent and failing results, changed heads, blocked states, required reviews, unresolved or unread threads, query failures and queued delivery. These fixtures perform no live Git or GitHub operations.

The Owner ran the worktree's validation script successfully on 2026-11-15: exit 0 in 166.1722 seconds. It checked 38 documents and 440 local references, preserved source hashes, covered new untracked documentation explicitly, and passed the actual make check gate, including all Test-Here suites. The supplied output reports 172 frontmatter checks with one exemption and no errors, plus five PowerShell files with no findings. The displayed log was truncated; no separate complete log artifact is claimed.

That full-gate result applies to the Owner-tested draft. Subsequent policy and status updates receive document checks; delivery must still satisfy its required gates. Owner adoption and post-merge verification remain outstanding.

## 4. Final source, content and navigation review

The Participant reviewed all 58 inventory groups and the nineteen original incident rules against their current authoritative homes, O01-O11 and the later Owner decisions. The newer pre-cutover guides were checked for requirements added since the original inventory. Go and PowerShell were compared at word level with those sources: changes are the recorded applicability/comment decisions, example substitutions, numbering/anchors and publication formatting. Detailed DevLore provider material remains preserved in the extraction and linked to product-owned guides; the product ownership/mirror follow-up is explicit.

The final pass corrected malformed inline code in Work organization, replaced a circular legacy branch-rules link with the maintained command manual, normalized a Go subsection number while preserving its earlier anchor, and refreshed stale conflict/validation descriptions. Schedule and issue templates retain their machine-parsed headings. Parent navigation and reachability from the handbook entry point are checked separately from local-link existence. Original Reviewer findings and source snapshots remain unchanged.

Final targeted verification passes for 38 documents and 448 local references, 23 active documents reachable from the handbook entry point, 134 retained legacy section anchors, all 58 inventory groups and nineteen original incident rules. Source and original Reviewer hashes remain unchanged. Spelling passes for the final edited documents. This is the Participant's source/content review; it does not substitute for Owner review or an eligible independent GitHub review.

The paragraph-layout scope is resolved through Formatting migration (#570) within this schedule. Temporary live-instruction overrides remain until the host tasks deliver their replacements. Eligible GitHub reviews, Owner adoption, commit/PR authority, merge and post-merge verification remain distinct delivery requirements.

## 5. Recorded process breach

On 2026-11-15, Codex reopened F05 without first reading the preserved review and the Owner's concurrence. The question was withdrawn and the agreed sequence retained. The cost was one unnecessary Owner-facing question and its correction. The current agent instruction now explicitly requires consulting preserved decisions and findings before asking whether a policy is unresolved.

On 2026-11-16, during Handbook consolidation (#420), Codex incorrectly enforced the session's one-PR-at-a-time rule across all NobleFactor and personal repositories. The resulting guard blocked publication on other workers' PRs and led to an unnecessary request for an exception. The Owner clarified that the restriction applies to this session's work and that the Owner coordinates other workers. The cost was one failed publication run, the unnecessary approval exchange and the corrective work. The guard now checks only this session's assigned branches; other workers' PRs do not block it.
