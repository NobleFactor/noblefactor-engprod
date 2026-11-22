---
title: "Worktree procedure"
status: draft
created: 2026-11-15
updated: 2026-11-21
---

# Worktree procedure

[Up: Procedures](index.md)

## 1. Establish the work

Start with a classified issue and its approved schedule assignment where applicable. The issue states the intended result and links its applicable designs. Work assets owns [locations and identities](../work-assets.md#workspace-locations); the canonical clone remains read-only for development.

Prepare the issue-named first script from the [dedicated specification](../../guides/pr-script-template.md#a-worktrees-first-script). It uses the supported [open-branch command](../../../Home/common/.local/share/man/man1/git-open-branch.1) with the issue and chosen PR target, prepares the applicable issue assets, commits and pushes them under the applicable authority, records the Schedule row, and links the applicable documents. For implementation work, the first committed asset is the reviewed issue plan. For a Designer, the [design-start rule](../process.md#prepare-and-review) requires approved scope on a design Schedule and direct delivery of the design, architecture decisions, and roadmap; no plan for writing those assets is required. Read an existing script before replacing it. The Owner reviews and runs the script unless an explicit exception covers one agent run.

<a id="2-review-the-committed-plan"></a>

## 2. Review the applicable proposal

For implementation, show the Owner the exact committed plan revision. For design, present the design, architecture decisions, and roadmap at their committed review revisions. Resolve open questions and record the resulting scope, acceptance evidence and authority before implementation. Current instructions and explicit grants govern the session; neither a worktree nor a plan grants Git authority.

## 3. Implement and verify

Work inside the assigned worktree. Follow approved phases, update affected documents with the changes they describe, and run the repository's required checks. Keep assignment and schedule records current. Surface necessary departures to the Owner and preserve blocked work.

## 4. Deliver the change

Follow the [PR procedure](pull-request.md) and its platform-specific script forms. Integrate the target by merge, preserve required gates, record the PR and squash commit, and distinguish implementation readiness from completion. Leave issues open while required post-merge obligations remain.

## 5. Verify and clean up

Record post-merge results on the issue, obtain the required completion decision and incorporate the established evidence through the approved documentation-follow-up path. Preserve outstanding records before removing their worktree.

Use the supported [close-branch command](../../../Home/common/.local/share/man/man1/git-close-branch.1) after the approved merge or abandonment. Canonical-clone maintenance needs its separate authorization. On Windows, leave the worktree directory before cleanup; after cleanup on every platform, run subsequent commands from a directory that still exists. Verify the cleanup and the actual deployed entrypoints when the change affects a layer.
