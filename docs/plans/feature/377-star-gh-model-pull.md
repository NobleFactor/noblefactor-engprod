---
title: "star gh model pull: the organization's types, labels and projects into model.yaml, by ETag, with a digest; #320's labels file becomes the asset"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/377
status: active
created: 2026-10-23
updated: 2026-10-24
---

# Plan: star gh model pull

## Summary

Task 2 of iteration 1 of the issue data model's sweep ([303-issue-data-model.md](../chore/303-issue-data-model.md)).
[Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) designs two commands
that move the model between GitHub and `model.yaml`; this task builds the first, `pull`, and `digest` beside it. The
asset was pulled by hand on 2026-10-22; after this, the command writes it.

## Goals

1. **`star gh model pull`** rewrites the asset from GitHub's record and prints the diff, or with `--check` prints it
   and writes nothing.
2. **Reads are conditional.** A second pull with nothing changed costs a 304 for every record that has an ETag.
3. **A rename in GitHub pulls as a rename:** same id, new name; for a type, the level kept.
4. **`star gh model digest`** re-signs a deliberately hand-edited asset.
5. **#320's labels file becomes the asset's organization tier,** and #320 is amended to say so.

## Current State

- The asset, `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/model.yaml`, holds five
  types with ids and levels, 21 labels as one flat list, the hub repository's, and `projects: []`. Its digest
  verifies.
- The extension reads only `types` from it (#376). Its labels commands read a list in the code,
  `REQUIRED_EVERYWHERE`, not the asset, so restructuring `labels` breaks nothing.
- The extension verifies the digest when `scheme.star` loads, and fails on a mismatch. A command that loads
  `scheme.star` therefore cannot run against a damaged asset, and `pull` and `digest` exist to repair one.
- #320's file, `docs/architecture/issue-labels/labels.yaml` on `chore/320-labels-file`, lists the 15 labels every
  repository carries. The hub has six more of its own.
- Read on 2026-10-23: `gh api -i -H 'If-None-Match: <etag>'` answers `HTTP/2.0 304 Not Modified` for the
  organization's issue types and for a repository's labels, and gh exits 1 on the 304.
- The owner's token has `admin:org`, `repo` and, since 2026-10-23, `read:project`.
- A star command exits 0, or 1 through `fail`. It cannot exit 2 (`cmd/internal/cli/output.go` in devlore-cli).

## Requirements

### Requirement 1: the commands

In `extension.yaml`, beside the issues and labels commands:

```
star gh model pull   [--org <organization>] [--asset <path>] [--check]
star gh model digest [--asset <path>] [--check]
```

`--org` defaults to NobleFactor. `--asset` defaults to the file beside the extension. The two commands are
`commands/gh-model-pull.star` and `commands/gh-model-digest.star`, over a shared `commands/model.star` that does not
load `scheme.star`.

**`--check` previews, as a workaround. Ruled 2026-10-24:** star's global `--dry-run` skips every `shell.exec`, reads
included, so a preview that must read GitHub sees nothing. The owner: "we'll add a --check flag as a workaround.
Ensure that the flag is documented as a workaround in the code and include a link to the issue." `--check` reads,
prints, and writes neither the asset nor the cache; both commands refuse `--dry-run` and name `--check` and
[devlore-cli#1170](https://github.com/NobleFactor/devlore-cli/issues/1170), which makes a dry run run the methods
that declare themselves non-mutating. `--check` retires when it lands.

**A mismatched digest no longer fails the extension's load.** Star loads every command file when an extension loads,
so `scheme.star`'s check on load took `digest` and `pull` down with the rest, the two commands that repair a
hand-edited asset. Found 2026-10-24; `scheme.star` records the mismatch in `MODEL_DIGEST_FAULT` and goes on, as
section 6 says a read-only operation does. Printing it in the report's header is #378's.

### Requirement 2: what `pull` reads

| Record | Read | Change detected by |
| --- | --- | --- |
| types | `GET /orgs/{org}/issue-types` | the list's ETag |
| labels | `GET /repos/{org}/noblefactor-engprod/labels?per_page=100`, the hub | the list's ETag |
| projects | GraphQL `organization.projectsV2` with fields and options | none: always read, once |

- **A type's level** comes from its description's `Level N:` prefix. A type matches the asset's by id: a new name
  for a known id prints `renamed Chore to Chores` and keeps the level.
- **A type whose description names no level is a conflict.** So is a level that disagrees with the asset's. `pull`
  writes nothing and fails, naming the type and the description to fix in GitHub's settings.
- **Labels go to tiers by name.** A hub label whose name is in the asset's organization tier updates there, and
  any other hub label lands in the hub's repository tier. The teams tier is carried through untouched until a team
  owns labels.
- **Projects need `read:project`.** Without the scope, `pull` warns once, keeps the asset's `projects` block as it
  is, and goes on.

### Requirement 3: the cache

`${XDG_CACHE_HOME:-~/.cache}/devlore/star/gh/model/<org>.yaml` holds each record's ETag and read time, and the
digest of the asset the ETags were pulled into. An ETag is sent only when the asset's digest is that one, so a 304
never stands in for content the asset does not hold. Deleting the cache costs one full read.

### Requirement 4: what `pull` writes

- **The asset, in a fixed layout:** the header comment, `version`, `pulled` with `at`, `org` and `digest`, `types` in
  the asset's order with new types last, `labels` in three tiers, `projects`. The layout is written by the command
  as text, not by `yaml.encode`, so that a pull of an unchanged record is byte-identical and its diff is only what
  moved.
- **The diff,** `diff -u` of the old file against the new, then one summary line: types, labels and projects changed,
  renamed, added, removed.
- **Only on a branch, in a clean file.** `pull` resolves the asset's real path, and refuses when its git tree is on
  the default branch or the asset has uncommitted changes. The deployed asset is a link into the layer clone on
  develop, so a real pull names a worktree's asset with `--asset`. `--check` runs anywhere.
- **The cache,** after a real pull, and after a `--check` that finds nothing changed: only when the asset holds what
  the ETags vouch for.

### Requirement 5: `digest`

Recomputes the SHA-256 over the asset with its digest line excluded, the same rule `scheme.star` checks, and
rewrites that one line. It prints the old and the new digest.

### Requirement 6: the first real pull and the labels move

The asset is restructured into tiers: #320's 15 labels as the organization tier, the hub's other six as
`NobleFactor/noblefactor-engprod`'s repository tier. The command's first real pull then replaces the hand pull, and
the asset this pull request carries is the command's output. #320 gets a comment, drafted here and posted under a
grant, saying its file became the asset's organization tier and its design stays for the set's content.

### Requirement 7: section 6 follows the build

[Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) is amended where the build differs:
`pull`'s exit codes, the worktree rule for `--asset`, and the cache's asset digest.

## Implementation Phases

### Phase 1: the plan

- [x] This plan committed on `feature/377-star-gh-model-pull-the`, reviewed with the owner, status `approved`

### Phase 2: the commands

- [x] `commands/model.star` and the two commands in `extension.yaml`; `make check` passes
- [x] The asset restructured into tiers and re-signed by `star gh model digest`

### Phase 3: proof

- [ ] One real pull from the worktree; then `--check` prints no diff
- [ ] A second pull reads 304 for types and labels, by the cache
- [ ] The Thread project's field and option renamed in GitHub and back pull as renames both ways, ids kept
- [ ] The report renders as before against the pulled asset, by the test-without-deploy copy

### Phase 4: the record

- [ ] Section 6 amended; #320's comment posted under a grant
- [ ] The pull request; status `complete` in its last commit

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/model.star` | Create | the sync's reads, merge, render, digest and cache |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/gh-model-pull.star` | Create | `pull` |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/gh-model-digest.star` | Create | `digest` |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | a mismatched digest recorded, not fatal |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/extension.yaml` | Modify | the two commands |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/model.yaml` | Modify | tiers; the command's first pull |
| `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md` | Modify | the build's differences |
| `docs/plans/feature/377-star-gh-model-pull.md` | Create | this plan |

## Related Documents

- [Section 6, the asset and its sync](../../architecture/issue-data-model/6-the-asset-and-its-sync.md)
- #376, the extension reads the asset; #378, every operation reads before it runs, which reuses this read and cache
- #320, the labels file

## Open Questions

1. **Exit codes. Ruled 2026-10-23:** exit 0 whether unchanged or rewritten, with the summary line and `git status`
   saying which, and exit 1 on a conflict with nothing written. Section 6 said 0, 1 and 2, and a star command cannot
   exit 2. No devlore-cli issue for a coded exit.
2. **The `read:project` scope. Settled 2026-10-23:** the owner added it to the token, so the first real pull reads
   projects, among them the Thread project of question 3.
3. **The rename proof. Ruled 2026-10-23:** renames are proven on a Thread project built for the purpose, the
   first use case, its steps draft items: a field and a single-select option renamed in GitHub pull as renames, ids
   kept. The owner: "I want to build the thread project now and document it later. I would like to use the thread
   project to test what you need to test: renames." No issue type is renamed; #377's done-when is amended to match.
