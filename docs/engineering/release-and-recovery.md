---
title: "Release and recovery"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Release and recovery

[Up: Engineering](index.md)

<a id="relationship-to-the-engineering-process"></a>

## 1. Relationship to the engineering process

Releases and hotfixes follow the shared issue, plan, worktree, review and verification process. Any exception is explicitly documented and owner-approved. A release does not grant permission for direct protected-branch pushes or development in a canonical clone.

The earlier release guide's in-place checkout examples, `bugfix/` branch names and protected-branch merge/direct-push sequences conflict with the shared process. They remain in a source snapshot for traceability, not as alternative executable procedures.

<a id="readiness"></a>

## 2. Readiness

Before release preparation, establish passing applicable CI, no known critical milestone bugs, updated user documentation and change log, and the defined acceptance evidence. Release readiness includes required QA, security review, documentation, and release sign-off. Release branches accept fixes rather than new features. Preserve release fixes in the ongoing integration line through the approved PR workflow.

Cross-platform products distinguish cross-compilation, unit behavior and real-binary scenarios on each supported platform. Report each result separately. Verification must identify the actual artifact and environment.

<a id="versioning-signing-and-publication"></a>

## 3. Versioning, signing and publication

Retain date-based registry tags, `release-YYYY-MM-DD[.N]`, with an incremented suffix for hotfixes. Tools use semantic versions with development/pre-release date qualifiers and commit metadata, and signed release tags such as `vX.Y.Z`. Do not normalize schemes silently.

Working-branch commits may be unsigned. Commits landing on `main` and `release/*` must be signed. Personal repositories are exempt from this signing requirement. This signing requirement does not extend to `develop` merely because it feeds release preparation. It supersedes both the prior blanket development-signing requirement and the broader, preliminary wording about all commits included in a release. A signed descendant does not retroactively sign its ancestors. GitHub ruleset configuration, merge-path validation and signing mechanics are separate implementation work; this document does not claim the ruleset is deployed.

Publication evidence identifies release/tag, produced artifacts and checksums, signing results, destination and any manual distribution obligations. Existing goreleaser/package-manager mechanics are retained in the source snapshot for later procedure review; this text does not claim they are the currently deployed implementation.

<a id="hotfixes-and-recovery"></a>

## 4. Hotfixes and recovery

Critical production defects may require a hotfix or rollback. Record incident, impact, approved choice, target known-good version, recovery plan, verification and any required integration follow-up. Emergency urgency does not silently suspend the shared process.

Prefer a history-preserving reversal through the approved workflow. The prior reset/force-push recovery option is not carried forward as an executable procedure: its conflict with protected-history policy requires an explicit approved exception and a reviewed procedure before use.

After recovery verify actual production stability, regenerate affected indexes, communicate to authorized stakeholders, preserve incident evidence and failed artifacts needed for analysis, and reconcile ongoing development. Retention must not accidentally retain secrets; any exceptional remediation requires separate review.
