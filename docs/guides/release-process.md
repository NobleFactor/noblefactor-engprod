---
title: "Development and Release Process \u2014 retained entry point"
type: Reference
status: "Superseded by docs/engineering/release-and-recovery.md"
updated: 2026-11-15
---

# Development and Release Process

[Up: Engineering handbook](../index.md)

The current requirements are in [Release and recovery](../engineering/release-and-recovery.md). This retained entry point preserves earlier links; it does not define a competing process or standard.

The [source captured before cutover](../engineering/review/sources/adoption-2026-11-15/release-process.txt) preserves the prior text, including its examples and incident history. [The handbook transition](../engineering/index.md#temporary-live-entrypoint-overrides) records the Owner-approved temporary overrides in live host instructions.

<a id="section-status"></a>

## 1. Earlier section: Section Status

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="branch-structure"></a>

## 2. Earlier section: Branch Structure

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="workflow-overview"></a>

## 3. Earlier section: Workflow Overview

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="development-phase"></a>

## 4. Earlier section: Development Phase

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="feature-development"></a>

## 5. Earlier section: Feature Development

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="signing-commits"></a>

## 6. Earlier section: Signing Commits

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="testing-phase"></a>

## 7. Earlier section: Testing Phase

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="continuous-integration"></a>

## 8. Earlier section: Continuous Integration

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="pre-release-validation"></a>

## 9. Earlier section: Pre-release Validation

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="staging-phase"></a>

## 10. Earlier section: Staging Phase

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="create-release-branch"></a>

## 11. Earlier section: Create Release Branch

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="release-branch-rules"></a>

## 12. Earlier section: Release Branch Rules

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="quality-gate"></a>

## 13. Earlier section: Quality Gate

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="release-phase"></a>

## 14. Earlier section: Release Phase

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="merge-to-main"></a>

## 15. Earlier section: Merge to Main

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="tag-the-release"></a>

## 16. Earlier section: Tag the Release

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="merge-back-to-develop"></a>

## 17. Earlier section: Merge Back to Develop

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="delete-release-branch"></a>

## 18. Earlier section: Delete Release Branch

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="hotfix-process"></a>

## 19. Earlier section: Hotfix Process

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="1-create-hotfix-branch"></a>

## 20. Earlier section: 1. Create Hotfix Branch

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="2-apply-fix"></a>

## 21. Earlier section: 2. Apply Fix

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="3-test"></a>

## 22. Earlier section: 3. Test

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="4-merge-to-main"></a>

## 23. Earlier section: 4. Merge to Main

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="5-tag-the-hotfix"></a>

## 24. Earlier section: 5. Tag the Hotfix

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="6-merge-to-develop"></a>

## 25. Earlier section: 6. Merge to Develop

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="7-delete-hotfix-branch"></a>

## 26. Earlier section: 7. Delete Hotfix Branch

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="rollback-procedures"></a>

## 27. Earlier section: Rollback Procedures

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="rollback-decision-matrix"></a>

## 28. Earlier section: Rollback Decision Matrix

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="identify-last-known-good-release"></a>

## 29. Earlier section: Identify Last-Known-Good Release

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="option-a-revert-commit-preferred"></a>

## 30. Earlier section: Option A: Revert Commit (Preferred)

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="option-b-reset-to-tag-nuclear-option"></a>

## 31. Earlier section: Option B: Reset to Tag (Nuclear Option)

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="rollback-a-hotfix"></a>

## 32. Earlier section: Rollback a Hotfix

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="post-rollback-checklist"></a>

## 33. Earlier section: Post-Rollback Checklist

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="re-applying-a-rolled-back-release"></a>

## 34. Earlier section: Re-applying a Rolled-Back Release

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="rollback-diagram"></a>

## 35. Earlier section: Rollback Diagram

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="tagging-and-versioning"></a>

## 36. Earlier section: Tagging and Versioning

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="registry-versioning-date-based"></a>

## 37. Earlier section: Registry Versioning (Date-Based)

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="tool-versioning-semver--metadata"></a>

## 38. Earlier section: Tool Versioning (SemVer + Metadata)

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="certificate-usage-by-phase"></a>

## 39. Earlier section: Certificate Usage by Phase

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="common-workflows"></a>

## 40. Earlier section: Common Workflows

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="start-a-new-feature"></a>

## 41. Earlier section: Start a New Feature

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="prepare-a-release"></a>

## 42. Earlier section: Prepare a Release

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="emergency-hotfix"></a>

## 43. Earlier section: Emergency Hotfix

See [Release and recovery](../engineering/release-and-recovery.md#hotfixes-and-recovery).

<a id="releasing-cli-utilities-goreleaser"></a>

## 44. Earlier section: Releasing CLI Utilities (goreleaser)

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="one-time-setup"></a>

## 45. Earlier section: One-Time Setup

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="release-workflow"></a>

## 46. Earlier section: Release Workflow

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="post-release-manual-steps"></a>

## 47. Earlier section: Post-Release Manual Steps

See [Release and recovery](../engineering/release-and-recovery.md#versioning-signing-and-publication).

<a id="testing-locally"></a>

## 48. Earlier section: Testing Locally

See [Release and recovery](../engineering/release-and-recovery.md#readiness).

<a id="configuration-reference"></a>

## 49. Earlier section: Configuration Reference

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).

<a id="references"></a>

## 50. Earlier section: References

See [Release and recovery](../engineering/release-and-recovery.md#relationship-to-the-engineering-process).
