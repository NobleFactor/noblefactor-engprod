---
title: "Model command delivery references"
type: Reference
status: Draft
updated: 2026-11-20
---

<a id="6-the-asset-and-its-sync--status"></a>

# Model command delivery references

[Architecture](6-the-asset-and-its-sync.md) · [Decision companion](6-the-asset-and-its-sync.decisions.md)

## 1. Preserved delivery evidence

The [original status record](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-6-the-asset-and-its-sync.status.md.txt) retains its dates, completed marks, pending items and earlier observations unchanged. The [original chapter](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-6-the-asset-and-its-sync.md.txt) retains the original requirements, examples and migration history.

[Model reads and backups](../../plans/feature/426-model-pull-to-dot-github.md) and [Model reconciliation](../../plans/feature/437-model-diff-apply-restore.md) own implementation history. [Issue-model migration](../../plans/chore/303-issue-data-model.md) owns the transition. Recorded outcomes establish only their stated revisions and environments.

## 2. Publication implementation gaps

The Owner approved applying the shared review/merge boundary to model-command PRs on 2026-11-19. [Decision 62](../../engineering/review/decisions.md#decision-62) records the choice; the [PR procedure](../../engineering/procedures/pull-request.md#merge-authorization-and-gates) owns the policy.

The source helper [pull.star](../../../Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/pull.star) still calls gh pr merge with squash/admin after its gate. Its disclosure helper still supplies the literal Assisted-by: Claude Code. Those behaviors do not implement the approved human-merge boundary or submitting-agent disclosure policy.

The helper also treats a branch-rules 403 on any private repository as no required checks. That condition alone does not establish the documented free-user/no-rules case or distinguish denied access. The shared policy requires establishing the actual requirements rather than treating an unreadable result as none.

[Backup](../../../Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/github-model-backup.star) assumes the helper has merged, then cleans up, reads main and returns merged. Changing the helper therefore also requires reviewing its callers, pending-PR results, resume behavior and post-merge verification. An isolated change removing one merge call would not complete that work.

This documentation rewrite changes none of those executable paths and claims no new runtime qualification. The helper cannot be treated as a compliant way to publish under the approved policy. [Model publication (#614)](https://github.com/NobleFactor/noblefactor-engprod/issues/614) tracks the required helper/caller alignment. Until its approved plan is delivered, use read-only model inspection and the ordinary Owner-reviewed PR process rather than this incompatible publication path.

<a id="completion"></a>

## 3. Review and follow-up

The [rewrite review](../../engineering/review/rewrite-review.md) tracks M01/M02 and the check-configuration finding, source hashes and proposed corrections. The [active plan](../../plans/doc/581-schedule-command-consumers.md) records the approval and documentation work. Runtime changes and their tests need their own approved scope.

[Model prompts (#470)](https://github.com/NobleFactor/noblefactor-engprod/issues/470), [Trailer delivery (#536)](https://github.com/NobleFactor/noblefactor-engprod/issues/536) and [Private rules (#538)](https://github.com/NobleFactor/noblefactor-engprod/issues/538) are supporting source references, not proof that this revision meets the new boundary.

The source's pending hierarchy-derivation work and Windows/prompt limitations remain in the preserved record. A rewrite of their reference is not completion of those obligations.
