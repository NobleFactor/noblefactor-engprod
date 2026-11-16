---
title: "Agent Rules \u2014 retained entry point"
type: Reference
status: "Superseded by docs/engineering/agent-operation.md"
updated: 2026-11-16
---

# Agent Rules

[Up: Engineering handbook](../index.md)

The current requirements are in [Agent operation](../engineering/agent-operation.md). This retained entry point preserves earlier links; it does not define a competing process or standard. On 2026-11-16, the Owner replaced mandatory breach reporting with [compliance auditing](../engineering/agent-operation.md#compliance-auditing) and withdrew breach-cost estimates. The retained headings and cases below are history, not a requirement to produce breach reports.

The [source captured before cutover](../engineering/review/sources/adoption-2026-11-15/agent-rules.txt) preserves the prior text, including its examples and incident history. [The handbook transition](../engineering/index.md#temporary-live-entrypoint-overrides) records the Owner-approved temporary overrides in live host instructions.

<a id="1-a-tool-we-build-is-verified-before-its-command-is-handed-over"></a>

## 1. Earlier section: 1. A tool we build is verified before its command is handed over

See [Agent operation](../engineering/agent-operation.md#all-agents-tools-and-status).

<a id="2-rulings-lead-the-guides-and-the-binary"></a>

## 2. Earlier section: 2. Rulings lead the guides and the binary

See [Agent operation](../engineering/agent-operation.md#all-agents-tools-and-status).

<a id="3-a-question-about-issues-is-answered-by-the-report"></a>

## 3. Earlier section: 3. A question about issues is answered by the report

See [Agent operation](../engineering/agent-operation.md#all-agents-tools-and-status).

<a id="4-a-generated-list-is-proven-before-it-is-handed-over"></a>

## 4. Earlier section: 4. A generated list is proven before it is handed over

See [Agent operation](../engineering/procedures/pull-request.md#review-boundary).

<a id="5-a-layer-change-is-finished-when-the-machine-is-converged-not-when-the-pr-merges"></a>

## 5. Earlier section: 5. A layer change is finished when the machine is converged, not when the PR merges

See [Agent operation](../engineering/process.md#verify-and-review-results).

<a id="6-lead-with-the-answer"></a>

## 6. Earlier section: 6. Lead with the answer

See [Agent operation](../engineering/agent-operation.md#all-agents-shared-obligations).

<a id="7-nothing-while-a-pull-request-is-in-flight"></a>

## 7. Earlier section: 7. Nothing while a pull request is in flight

See [Agent operation](../engineering/process.md#pull-request-and-integration).

<a id="8-a-blocked-branch-is-nuked-not-parked"></a>

## 8. Earlier section: 8. A blocked branch is nuked, not parked

See [Agent operation](../engineering/process.md#preserve-and-clean-up).

<a id="9-a-violation-is-disclosed-as-a-violation"></a>

## 9. Earlier section: 9. A violation is disclosed as a violation

The former breach-reporting requirement was withdrawn on 2026-11-16. See [Compliance auditing](../engineering/agent-operation.md#compliance-auditing) for the replacement.

<a id="10-a-finding-is-consulted-the-moment-it-is-found"></a>

## 10. Earlier section: 10. A finding is consulted the moment it is found

See [Agent operation](../engineering/process.md#implement-the-approved-work).

<a id="11-works-means-works-for-the-user"></a>

## 11. Earlier section: 11. "Works" means works for the user

See [Agent operation](../engineering/process.md#verify-and-review-results).

<a id="12-a-document-a-commit-makes-stale-is-corrected-in-that-commit"></a>

## 12. Earlier section: 12. A document a commit makes stale is corrected in that commit

See [Agent operation](../engineering/work-assets.md#lifecycle-and-freshness).

<a id="13-a-pull-request-discloses-ai-the-way-the-contribution-terms-say"></a>

## 13. Earlier section: 13. A pull request discloses AI the way the contribution terms say

See [Agent operation](../engineering/procedures/pull-request.md#review-boundary).

<a id="14-a-claim-says-how-it-is-known"></a>

## 14. Earlier section: 14. A claim says how it is known

See [Agent operation](../engineering/agent-operation.md#all-agents-shared-obligations).

<a id="15-an-issue-is-checked-for-its-documents-table-before-it-is-filed"></a>

## 15. Earlier section: 15. An issue is checked for its documents table before it is filed

See [Agent operation](../engineering/work-assets.md#plans-and-designs).

<a id="16-a-worktree-and-its-script-go-with-the-merge"></a>

## 16. Earlier section: 16. A worktree and its script go with the merge

See [Agent operation](../engineering/process.md#preserve-and-clean-up).

<a id="17-every-git-command-is-asked-for-by-name-and-granted-once"></a>

## 17. Earlier section: 17. Every git command is asked for by name and granted once

See [Agent operation](../engineering/agent-operation.md#owner-supervised-agents-authority-and-progression).

<a id="18-another-agent-is-spoken-to-only-on-the-owners-yes-and-nothing-is-done-outside-the-owners-orders"></a>

## 18. Earlier section: 18. Another agent is spoken to only on the owner's yes, and nothing is done outside the owner's orders

See [Agent operation](../engineering/agent-operation.md#owner-supervised-agents-conversations).

<a id="19-a-session-keeps-its-steps-current-as-it-goes"></a>

## 19. Earlier section: 19. A session keeps its steps current as it goes

See [Agent operation](../engineering/work-organization.md#schedule-commitment).

## 20. Recorded incident: consult preserved decisions first

The authoritative obligation is in [Agent operation: writing for publication](../engineering/agent-operation.md#all-agents-writing-for-publication).

On 2026-11-15, during Handbook consolidation (#420), Codex asked whether plan approval should require separate direction to start before reading preserved finding F05 and the Owner's concurrence. The question reopened a settled decision. It was withdrawn; the agreed sequence remained unchanged. The [preserved review](../../ENGINEERING-DOCUMENTATION-REVIEW.findings.md) and [current disposition](../engineering/review/adoption-review.md) retain the evidence.

## 21. Recorded incident: scope PR serialization to the session

The authoritative transition scope is in [Temporary live-entrypoint overrides](../engineering/index.md#temporary-live-entrypoint-overrides).

On 2026-11-16, during Handbook consolidation (#420), Codex incorrectly enforced the session's one-PR-at-a-time rule across all NobleFactor and personal repositories. The resulting guard blocked publication on other workers' PRs and led to an unnecessary request for an exception. The Owner clarified that the restriction applies to this session's work and that the Owner coordinates other workers. The guard now checks only this session's assigned branches; other workers' PRs do not block it.
