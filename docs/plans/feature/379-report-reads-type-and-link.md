---
title: "The report and the audit place an issue by its type and its sub-issue parent first, by label and marker second"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/379
status: approved
created: 2026-10-22
updated: 2026-10-22
---

# Plan: the report and the audit place an issue by its type and its sub-issue parent first

## Summary

Task 4 of iteration 1 of the issue data model's sweep ([303-issue-data-model.md](../chore/303-issue-data-model.md)),
lane 17 of #346, approved with the task list on 2026-10-22. The report and the audit read GitHub's record of an issue
first, its issue type and its sub-issue parent, and today's text second, the kind label and the `**Feature:**` or
`**Chore:**` marker, until the switch retires the text. Where the two records disagree the audit says so. This is
section 5's step 2, tooling that reads both, and the step the sweep most likely stumbles on, so it comes before
anything is migrated.

## Goals

1. **An issue with a type and a parent link and no label or marker renders under its parent in every view.**
2. **An issue with only a label and a marker renders as today.**
3. **A disagreement is an audit fault naming both**: a type against a label, a link against a marker, an epic read up
   the parents against the `Epic:<Name>` label.
4. **Nothing a session reads changes shape**: the same commands, the same tables, the same keys.

## Current State

- `gh issue list --json` returns `issueType` (`{name}`, null where none is set, which is every issue today) and
  `parent` (`{number, url, state, title}`, the URL naming the parent's repository), read 2026-10-22; the two fields
  cost nothing measurable on a 500-issue fetch.
- 66 of noblefactor-engprod's 89 open issues carry a parent link; so do the issues filed since the 21st in all three
  repositories. No issue carries a type.
- `kind_of`, `parent`, `parent_marker` and `epic_tag` read labels and bodies only; every placement and fault rests on
  them.

## Requirements

### Requirement 1: the fetch carries the record

`fetch_issues` asks for `issueType` and `parent` too, and after the fetch resolves every issue once, in one pass over
the set, writing three fields onto it: `kind` (the type's name lower-cased when the type is one of the asset's, else
the one kind label, else `unclassified`); `parent_key` (`owner/repo#N` from the link's URL through `canonical_repo`,
else the last marker, else none); `epic` (the `Epic:<Name>` label of the root the parent chain reaches within the
fetched set, else the issue's own `Epic:<Name>` label, else none). The chain stops at the first issue not in the set,
which is how a report of one repository falls back to the label for a parent held elsewhere.

### Requirement 2: everything reads the resolution

`kind_of`, `parent`, `epic_tag` and what rests on them read the three fields. `is_root`, `is_child`, `is_parent`,
`is_bug` read `kind_of`. The marker and the label stay readable for the audit alone.

### Requirement 3: the audit names the disagreements

Three new faults, each naming both records: "typed Feature, labeled chore"; "linked to owner/repo#N, marker names
owner/repo#M"; "its parents reach Epic:X, labeled Epic:Y". A missing second record is not a fault: an issue with a
link and no marker, or a type and no label, is the model arriving.

### Requirement 4: the renders

Through a private copy against the live repositories: the table, feature, schedule and thread views and the audit
compared before and after. Where a render moves, the move is by a link that disagrees with a marker, and the audit
lists that disagreement; every such case is recorded in this plan as a finding for #380 and #363.

## Implementation Phases

### Phase 1: the plan

- [x] This plan committed on `feature/379-report-and-the-audit-place-an`, status `approved` with the task list -- 2026-10-22

### Phase 2: the change

- [x] The fetch, the resolution pass and the three fields; the readers; the three faults -- 2026-10-22
- [x] `make check` passes; six renders compared, every difference traced to a disagreement the audit names -- 2026-10-22
- [x] A fixture of one issue with a type and a link, its label disagreeing, renders under its parent -- 2026-10-22

### Phase 3: the pull request

- [ ] The pull request, opened by this worktree's script; status `active` until the deploy
- [ ] `writ deploy` on every machine and the deployed report placing by link; then status `complete`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/379-report-reads-type-and-link.md` | Create | this plan |
| `.../commands/scheme.star` | Modify | the fetch, the resolution, the readers, the faults |
| `.../commands/gh-issues-report.star` | Modify | any reader of a label or marker it still holds |

## Related Documents

- [5-from-todays-scheme.md](../../architecture/issue-data-model/5-from-todays-scheme.md), step 2
- [1-hierarchy.md](../../architecture/issue-data-model/1-hierarchy.md), the parent and the epic read up the parents
- #376, which made the kinds the asset's; #380 and #363, which this unblocks

## Findings while doing it

- **#376 left the level tests reading labels.** `is_root`, `is_child`, `is_parent`, `is_bug` and the view issues
  tested the kind labels directly, so an issue typed Task and labeled chore was neither a lane nor a parent and
  vanished from the render. They read `kind_of` now, which is the type first and the label second. Found by this
  plan's fixture; the comparison alone would not have shown it, since no issue carries a type yet.
- **The comparison, before and after, on 2026-10-22.** The schedule and thread views are identical. The table and
  feature views of Epic: Issue tracking and the table of Epic: Process move 25 issues, every one
  by a link that disagrees with today's text, and the audit names each: 17 whose parent chain reaches a
  different epic than their `Epic:<Name>` label (devlore-cli#248, noblefactor-engprod#256, devlore-cli#276, noblefactor-engprod#302, noblefactor-engprod#303, noblefactor-engprod#304, noblefactor-engprod#320, devlore-cli#460, devlore-cli#571, devlore-cli#574, devlore-cli#685, devlore-cli#721, devlore-cli#838, devlore-cli#886, devlore-cli#920, devlore-cli#932, devlore-cli#938), and 8 whose sub-issue link names a
  different parent than their marker (noblefactor-engprod#178, noblefactor-engprod#256, noblefactor-engprod#302, noblefactor-engprod#303, noblefactor-engprod#304, noblefactor-engprod#320, devlore-cli#799, devlore-cli#886). devlore-cli#886 leaves both tables for Epic:
  StarlarkSurface, where its link under devlore-cli#461 puts it. These are the links set on 2026-10-20 and 21
  before the features were reorganized, and they are #380's and #363's to settle; the report now shows the
  record as GitHub holds it and the audit shows where the text disagrees.
- **The fixture**: the scratch issue #355 typed Task and linked under #331, its label chore left, renders as
  "task; feature #331" under #331; type and link reverted after. A closed issue's faults are not computed, so the
  "typed Task, labeled chore" fault shows for open issues only, as every fault does.

## Open Questions

None.
