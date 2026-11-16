---
title: "Release and recovery"
status: draft
created: 2026-10-28
updated: 2026-11-15
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

### 2.1. Release flow and readiness evidence

The product's release plan names its integration and production branches, the issue-bound release or hotfix worktree, the target revision, release authority and required checks. Preserve release fixes in both the production line and ongoing integration through the approved PR workflow. Release branches accept fixes rather than new features.

| Gate | Evidence before publication |
| --- | --- |
| CI | Applicable repository checks pass for the release revision; identify platform-unit and real-binary scenario results separately. |
| QA | The release checklist and required manual verification are complete. |
| Security | The required security review identifies no unresolved vulnerability that prevents release. |
| Documentation | Applicable README, change log and release notes describe the delivered behavior. |
| Sign-off | The named release authority approves readiness and publication. |

The retained guide's universal Go-build, index-generation and development-certificate examples describe product-specific implementation. Use the actual repository's gate and record applicable artifact/index-signing requirements in the release plan; do not impose a Go build on a documentation repository.

<a id="versioning-signing-and-publication"></a>

## 3. Versioning, signing and publication

Retain date-based registry tags, `release-YYYY-MM-DD[.N]`, with an incremented suffix for hotfixes. Tools use semantic versions with development/pre-release date qualifiers and commit metadata, and signed release tags such as `vX.Y.Z`. Do not normalize schemes silently.

Working-branch commits may be unsigned. Commits landing on `main` and `release/*` must be signed. Personal repositories are exempt from this signing requirement. This signing requirement does not extend to `develop` merely because it feeds release preparation. It supersedes both the prior blanket development-signing requirement and the broader, preliminary wording about all commits included in a release. A signed descendant does not retroactively sign its ancestors. GitHub ruleset configuration, merge-path validation and signing mechanics are separate implementation work; this document does not claim the ruleset is deployed.

Publication evidence identifies release/tag, produced artifacts and checksums, signing results, destination and any manual distribution obligations. Existing goreleaser/package-manager mechanics are retained in the source snapshot for later procedure review; this text does not claim they are the currently deployed implementation.

### 3.1. Version and distribution evidence

Identify the product's approved version and tag scheme before publication. The retained conventions distinguish registry tags `release-YYYY-MM-DD[.N]` from tool semantic versions with development/pre-release qualifiers and commit metadata. The release plan verifies the currently approved product scheme and records any departure rather than normalizing those formats silently.

Record the intended certificate or signing identity, its availability, and verification of the resulting signatures. The earlier development/test-versus-production certificate matrix is retained in the source evidence; its mandatory working-branch commit signing is superseded by O06. This handbook does not claim that certificate procurement or product artifact-signing infrastructure is operational.

The distribution plan names the artifacts and destinations that apply: binaries and archives, checksums, a GitHub release, package indexes and package-manager channels. Record automated and manual obligations separately, including Windows package manifests, Homebrew taps or Linux package repositories where applicable. A configured release tool is not evidence that every distribution step completed. Product documentation owns the current release-tool configuration and commands; the old goreleaser setup examples remain historical source evidence.

<a id="hotfixes-and-recovery"></a>

## 4. Hotfixes and recovery

Critical production defects may require a hotfix or rollback. Record incident, impact, approved choice, target known-good version, recovery plan, verification and any required integration follow-up. Emergency urgency does not silently suspend the shared process.

Prefer a history-preserving reversal through the approved workflow. The prior reset/force-push recovery option is not carried forward as an executable procedure: its conflict with protected-history policy requires an explicit approved exception and a reviewed procedure before use.

After recovery verify actual production stability, regenerate affected indexes, communicate to authorized stakeholders, preserve incident evidence and failed artifacts needed for analysis, and reconcile ongoing development. Retention must not accidentally retain secrets; any exceptional remediation requires separate review.

### 4.1. Recovery priority and verification

Use impact to prioritize the Owner's recovery decision. The retained urgency guidance does not grant authority to bypass approvals or protected-history rules.

| Impact | Recovery priority |
| --- | --- |
| Critical: outage or risk of data loss | Obtain the recovery decision immediately and execute the approved recovery. |
| High: major functionality unavailable | Prioritize rollback within hours. |
| Medium: degraded functionality | Prefer a hotfix; propose rollback if a timely fix is unavailable. |
| Low: minor defects | Prefer fixing forward in the next release. |

A hotfix needs the applicable full CI, manual verification and regression evidence before release. A recovery verifies the known-good target, actual production stability, applicable indexes and signatures, authorized stakeholder communication, incident documentation and preservation of evidence. Reconcile the production and integration lines through approved PRs. Reapplying a reverted release or using a destructive history remedy requires its own reviewed plan and authority.
