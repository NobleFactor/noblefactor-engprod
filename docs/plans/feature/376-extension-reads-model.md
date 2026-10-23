---
title: "The star extension reads the hierarchy from model.yaml: types as levels, nothing in its code naming a type"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/376
status: approved
created: 2026-10-22
updated: 2026-10-22
---

# Plan: the star extension reads the hierarchy from model.yaml

## Summary

Task 1 of iteration 1 of the issue data model's sweep
([303-issue-data-model.md](../chore/303-issue-data-model.md)), lane 14 of #346. `scheme.star` names the five kinds in
its code, in `KINDS`, `is_child`, `is_parent`, `kind_of`, the marker regex, `REQUIRED_EVERYWHERE` and `task_row`. After
this, it reads them from `model.yaml` beside the extension: each type's name and level, and derives the rest. The
owner, 2026-10-21: "We've got a hierarchy and a level number might be sufficient. we assume mutual exclusion at each
level in the hierarchy. ... The yaml should travel with the extension and drive its behavior because that, I will
argue, is the definitive configuration." Approved as part of the task list on 2026-10-22.

## Goals

1. **No type name in the extension's code.** Every rule about the hierarchy reads the asset.
2. **The report and the audit render exactly as before** on the live repositories, through a private copy.
3. **A bad asset is refused with its fault named**: a `version` the extension does not know, a digest that does not
   verify, a type with no level.

## Current State

- `model.yaml` exists beside the extension since #373, with `version: 1`, `pulled`, `types` (five, each with `name`,
  `id`, `level`, `color`, `description`), `labels` and `projects`.
- star's command context carries only `args` and `dry_run`; an extension has no path to itself. `scheme.star` already
  reaches writ's layers by `${XDG_DATA_HOME:-$HOME/.local/share}` through `shell.exec`, and the deployed extension is
  `${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/com.noblefactor.ops.GitHub/`.
- `fs.read` and `yaml.decode` are ambient in a command script. star exposes no hash; `sha256sum` or `shasum -a 256`
  does through `shell.exec`.
- The kind labels in GitHub are lower case, `epic`, `feature`; the types in the asset are capitalized, `Epic`,
  `Feature`. The label is the type's name lower-cased, until the switch.

## Requirements

### Requirement 1: `model()` loads the asset once

A function in `scheme.star` that resolves the asset's path as the layers are resolved, reads it, decodes it, checks
`version == 1`, recomputes the digest over the file with its own line excluded and compares it with `pulled.digest`,
and fails with the fault named: unknown version, digest mismatch, a type without a level. It returns the decoded
asset and is called once per run, its result passed where needed.

### Requirement 2: the hierarchy is derived

From `types`: the levels in order; `is_child` is a type on the last level; `is_parent` is a type on a middle level and
not a view issue; `kind_of` picks the one type an issue carries, by level then name; `KINDS` is the types' names
lower-cased; the parent marker regex is built from the parent level's names; `REQUIRED_EVERYWHERE` is `KINDS` plus the
process epic's label; `task_row` prints the leaf type's name. The marker words stay the type names capitalized, as
written in bodies today.

### Requirement 3: nothing else changes

The report, the audit, the labels commands and the schedule and thread views render byte-for-byte as before on the
live repositories, through a private copy of the extension, for `--epic Ops:IssueTracking --view table --state all`,
`--by feature`, `--by schedule --schedule 346` and `audit`.

## Implementation Phases

### Phase 1: the plan

- [x] This plan committed on `feature/376-star-extension-reads-the`, status `approved` with the task list -- 2026-10-22

### Phase 2: the change

- [x] `model()` and the derivations in `scheme.star`; the report's literals replaced; the labels commands named none -- 2026-10-22
- [x] `make check` passes; table, feature, schedule and thread render byte-for-byte as before through a private copy, the audit differs by the order of kinds in one message -- 2026-10-22
- [x] A doctored asset, no level on one type, a doctored digest, and an unknown version, are refused with the fault named -- 2026-10-22

### Phase 3: the pull request

- [ ] The pull request, documents and the extension; status `complete` in its last commit; `writ deploy` after the merge
      and the deployed report rendering #346

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/376-extension-reads-model.md` | Create | this plan |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | `model()`, the derivations |
| `.../commands/gh-issues-report.star` | Modify | the literals it carries |
| `.../commands/gh-labels-audit.star`, `gh-labels-sync.star` | Modify | `REQUIRED_EVERYWHERE` through the asset, if they name it |

## Related Documents

- [6-the-asset-and-its-sync.md](../../architecture/issue-data-model/6-the-asset-and-its-sync.md), the asset's shape
- [1-hierarchy.md](../../architecture/issue-data-model/1-hierarchy.md), the levels

## Findings while doing it

- **Two things the levels do not say.** Which leaf type is the unplanned one, for triage and Severity, and the order
  of types within a level, which is the order the report renders them in. The asset says both: `unplanned: true` on
  Bug, and the types' order within a level, Feature before Chore, Bug before Task. Section 6 records it.
- **What still names a kind in the code is schema, not hierarchy**: the rows' field names `epic` and `feature`,
  the lane spec's `epic` key, and the report's `--by` modes `epic`, `feature`, `thread`, `schedule`. They are the
  output's shape and the command line, and they stay.
- **One render changes by a message**: the audit's "no kind label (…)" lists the kinds in the asset's order,
  epic/feature/chore/bug/task, where it listed epic/feature/task/bug/chore. Every other view, table, feature,
  schedule, thread and the rest of the audit, renders byte-for-byte as before.
- **The refusals** name the fault: version 2 is not 1; the digest does not verify, with the two commands that clear
  it; type Chore has no level. A bad asset stops the extension at load, so every command, not one.

## Open Questions

None. The type-to-label mapping, lower-cased name, is the interim until the switch; the design says so.
