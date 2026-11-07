---
title: "Engineering documentation review draft"
status: draft
created: 2026-10-28
updated: 2026-10-28
---

# Engineering documentation review draft

The document structure and the decisions recorded in [the decision record](docs/engineering/review/decisions.md) have been approved in conversation. **The document text is a first draft for review, not adopted policy.** Nothing in this package claims deployed support or changes repository configuration.

Start with [Engineering process](docs/engineering/process.md), then [Work organization](docs/engineering/work-organization.md) and [Work assets](docs/engineering/work-assets.md). The [engineering index](docs/engineering/index.md) describes ownership and applicability.

[Open decisions](docs/engineering/review/open-decisions.md) identifies policy questions still requiring an answer, one at a time. [Requirement migration](docs/engineering/review/requirement-migration.md) maps all 58 inventory groups and all 19 numbered agent rules to draft homes or retained source text. The [source manifest](docs/engineering/review/source-manifest.json) identifies exact source snapshots and hashes.

This package is outside repository checkouts. The engineering-process worktree used for the earlier inventory is no longer present; the current canonical clone was read through its workspace symlink. No git commands, GitHub operations, repository edits, commits, builds or tests were performed for this draft.

Existing Go, PowerShell and issue-classification details are imported for preservation and marked as such. Historical/source snapshots use `.txt` so their old paths, terminology, metadata and commands cannot be mistaken for the new document set. No snapshot is an independently authoritative process document. The content has not been declared fully reconciled merely because it was copied.

Scope is documentation. Compliance implementation, live GitHub configuration, product capability verification and third-party tooling selection remain later discussions.
