---
title: "Clone retirement"
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Clone retirement

[Up: Procedures](index.md)

Follow the [retirement asset requirements](../work-assets.md#clone-retirement) and applicable Owner authorization. This procedure does not authorize deletion or repair operations.

1. Save what origin lacks outside the clone: uncommitted work, stashes and local commits as patches, and every ref as a bundle. Verify the saved material before proceeding.
2. Transfer live worktrees through repair or controlled reopening against the canonical clone that stays. Preserve unfinished work and record each new association.
3. Check consumers: writ registrations, workspace symlinks and scripts whose working directories name the old clone. Update references under the approved scope.
4. Remove the retired clone only after preservation, transfer and reference checks are complete. Report exactly what was removed, what was saved and where recovery material lives.

Where a step fails, stop and preserve the remaining state. A cleanup objective is not permission to discard unique work.
