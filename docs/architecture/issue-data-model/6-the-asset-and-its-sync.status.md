---
title: "6. The asset and its sync — Status"
---

# 6. The asset and its sync — Status

**Document:** [6-the-asset-and-its-sync.md](6-the-asset-and-its-sync.md)
**Feature:** [NobleFactor/noblefactor-ops#332](https://github.com/NobleFactor/noblefactor-ops/issues/332)
**Work:** [NobleFactor/noblefactor-ops#303](https://github.com/NobleFactor/noblefactor-ops/issues/303)
**State:** Ruled 2026-10-22, from the owner's words of 2026-10-21 and 2026-10-22; the syntax and the file's shape are
proposed and accepted ("That's great. Doc it"), not yet built.

## Completion

- [ ] `model.yaml` beside the extension, with `version`, `pulled` and its digest, `types`, `labels` and `projects`
  with their ids; #320's labels file moved into it.
- [ ] The ETag cache under `$XDG_CACHE_HOME/devlore/star/gh/model/`, and `star gh model digest`; the gate checks the
  digest.
- [ ] `star gh model pull`, `push` and `audit`; `labels sync` and `labels audit` retired into them.
- [ ] The extension derives the hierarchy from `types` and names no type itself.
- [ ] Every `star gh issues` operation reads GitHub's record conditionally first and reports when the asset is behind.
