---
title: "The hierarchy is epic, then chore or feature, then bug or task: the standard, the parent marker and the tooling say so"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/358
status: complete
created: 2026-10-21
updated: 2026-10-21
---

# Plan: the hierarchy is epic, then chore or feature, then bug or task

## Summary

Ruled 2026-10-21: "chore is now redefined to be a mutually-exclusive peer to feature in our issue hierarchy. The new
hierarchy is epic, (chore|feature), (bug|task)." Then: "I need this done now." Today
[issue-standards.md](../../issue-standards.md) makes chore a tier-three leaf under an enabler feature of
`Epic:Ops:Process`, and the report and the audit in `scheme.star` read only the `**Feature:**` marker, so a lane filed
under a chore renders as "unfiled, no parent feature": devlore-cli#679 does, and so do David-Noble-at-work/personal#289
to #295, which were filed under personal#287 on the ruling. This plan changes the standard, the marker and the
tooling together, in one pull request, and proves it on those eight issues.

## Issue 358

[issue-standards.md states epic, then chore or feature, then bug or task, and the two parent markers](https://github.com/NobleFactor/noblefactor-ops/issues/358):
Requirements 1 and 3, Phases 2 and 4. A task under feature [#331](https://github.com/NobleFactor/noblefactor-ops/issues/331),
the GitHub issue data model, of Epic [#330](https://github.com/NobleFactor/noblefactor-ops/issues/330), Issue tracking.

## Issue 360

[scheme.star reads either parent marker and places lanes under chores as under features](https://github.com/NobleFactor/noblefactor-ops/issues/360):
Requirement 2, Phases 3 and 5. A task under feature [#332](https://github.com/NobleFactor/noblefactor-ops/issues/332), the issue
tooling, of the same epic.

This plan opened as #344's, the chore that held both halves; on 2026-10-21 the epic was found already decomposed into three features and
#344 closed into these two tasks. The branch keeps its name.

## Goals

1. **The standard states the three tiers** and nothing in it contradicts them.
2. **A lane names its parent by the parent's kind**, `**Feature:** #N` or `**Chore:** #N`, and the tooling reads both.
3. **The report places lanes under chores** as it does under features, and the audit names the faults the new shape
   admits.
4. **The eight issues filed on the ruling render under their parents** when the deployed report runs, which is the
   live-path acceptance ([agent-rules](../../guides/agent-rules.md) rules 5 and 11).

## Current State

| Where | Says today |
| --- | --- |
| `docs/issue-standards.md` § The five kinds | five kinds; tiers one, two, three; "Tier three is a lane: a task, a bug, or a chore" |
| § What a chore is, § The process epic | a chore is tier three, on the tooling axis, filed under an enabler feature of `Epic:Ops:Process`; "a chore that names no feature is unfiled" |
| § Placement and the two markers | every tier-three issue names its parent as `**Feature:** #N`; the marker is the last `**Feature:**` in the body |
| § Schedules | the schedule issue is a chore titled `Schedule:` with no epic; lanes are leaves, "tasks, bugs and chores" |
| `scheme.star` `is_child` | task, bug or chore; "peers under a feature" |
| `scheme.star` `parent_feature` | the last `Feature:** [owner/repo]#N` in the body |
| `scheme.star` `epic_rows`, `feature_rows`, `children_of`; `gh-issues-report.star` `_tree_document` | features under the epic, children under features by `parent_feature`, the rest "unfiled, no parent feature" |
| `scheme.star` `faults`, `kind_of`, `is_schedule_issue` | kind and epic counts; a chore titled `Schedule:` is a view and carries no epic |
| `docs/guides/development-process.md` § The unit of work | lanes are "leaf issues, tasks, bugs and chores" |
| [#303](https://github.com/NobleFactor/noblefactor-ops/issues/303) | reworks the same scheme to make schedule a kind; open |

## Requirements

### Requirement 1: `docs/issue-standards.md`

- **§ The five kinds:** the table's Tier column becomes one, two, two, three, three: epic; feature and chore, peers,
  mutually exclusive, both bodies of work an epic decomposes into; task and bug, the lanes, under either. "Tier three
  is a lane" stays, reading "a `task` or a `bug`". A chore is not a lane.
- **§ What a chore is:** the definition stands, "a cleanliness or efficiency task, undertaken to reduce friction by
  improving or correcting a human or machine process", and the test stands, "if the change shipped to a user, would
  they notice?". What changes is its place: a chore is to process what a feature is to the product, a body of work
  under an epic, with its own lanes. The axis table's Leaves column becomes `task`, `bug` for both axes; its tier-two
  column reads "feature: product functionality" and "chore: a body of process or tooling work".
- **§ The process epic:** "a chore files under one of them [enabler features] and carries the `**Feature:**` marker"
  becomes: a chore files directly under an epic and carries `**Epic:** #N`; `Epic:Ops:Process` is the home of a chore
  that serves no other epic, and a chore that serves a product epic carries that epic's label (as devlore-cli#1119,
  #1120 and #1121 do). The enabler features already there stay what they are; a chore beside them is not a child of
  them.
- **§ Placement and the two markers:** every lane names its parent as `**Feature:** #N` **or** `**Chore:** #N`, by the
  parent's kind; the marker is the last of either in the body; a lane with neither is unfiled. A chore or feature
  names its epic by the label alone, as today.
- **§ What an empty level means:** a chore with no lanes is "awaiting decomposition", as a feature is.
- **§ Well classified** and **§ Schedules:** lanes are "tasks and bugs"; a schedule issue stays a chore titled
  `Schedule:` with no epic, the one chore that is a view.
- A dated ruling line at the top of § The five kinds, in the owner's words.

### Requirement 2: `scheme.star` and the two commands

- `is_child`: task or bug. New `is_parent`: feature or chore that is not a view issue.
- `parent_feature` becomes `parent`: the last `(Feature|Chore):** [owner/repo]#N` in the body, returning the key and
  the kind named; a mismatch between the kind named and the parent's actual kind is a fault the audit reports
  ("names #N as a chore; it is a feature").
- `epic_rows`, `feature_rows`, `children_of`, `_tree_document`: iterate parents, features then chores, each with its
  lanes; "unfiled, no parent feature" becomes "unfiled, no parent"; the tree's counts read "N feature(s), M chore(s),
  P task(s), Q bug(s)"; a chore with no lanes reads "awaiting decomposition".
- `faults`: a chore that is not a schedule issue and carries no epic is already a fault (no `Epic:` label); add the
  marker-kind mismatch above; a feature or chore carrying a parent marker is a fault ("tier two names a parent").
- The epic's "awaiting plan and design" placement applies when it has neither features nor chores.
- Every docstring and comment that says "under a feature" says "under a feature or a chore".

### Requirement 3: the neighbors

- `docs/guides/development-process.md`: lanes are "tasks and bugs"; a worktree may still resolve a chore.
- `docs/plans/TEMPLATE.md`: no change; it names no tier.
- [#303](https://github.com/NobleFactor/noblefactor-ops/issues/303) is reconciled by a comment on it citing this
  ruling and #344, because its "schedule becomes a kind" rework sits on the same table; the comment says which rows
  this plan changed so #303 starts from them.

## Implementation Phases

### Phase 1: the plan lands

- [x] Reviewed with the owner, status `approved`, committed alone on `chore/344-issue-hierarchy` -- 2026-10-21
- [x] #344's documents table carries this plan's link on `develop` -- 2026-10-21, with #370's merge

### Phase 2: the standard

- [x] `docs/issue-standards.md` revised per Requirement 1 -- 2026-10-21

### Phase 3: the tooling

- [x] `scheme.star`, `gh-issues-report.star`, `gh-issues-audit.star` revised per Requirement 2 -- 2026-10-21; `gh-issues-audit.star` named no old rule and is unchanged, and `extension.yaml`'s help text names chores
- [x] `make check` passes in the worktree (buildifier over the `.star` files is the check that reads them) -- 2026-10-21: every gate and the tests pass; `shell-lint` fails six scripts this branch does not touch, and fails them on `develop` too, under shfmt v3.13.0

### Phase 4: the neighbors and the pull request

- [x] `development-process.md` per Requirement 3 -- 2026-10-21; the comment on #303 posted by the owner the same evening
- [x] The pull request's description says AI assisted and ends with `Signed-off-by:` and `Assisted-by: Claude Code` -- 2026-10-21, written by `~/Workspace/NobleFactor/noblefactor-ops.344-issue-hierarchy.bash`
- [x] This document's status set to `active` in the last commit of the pull request, with Phase 5 named as the reason
      it is not `complete` -- 2026-10-21: the extension reaches `star` only when writ deploys the merged layer, so Phase 5
      closes after the merge, in a follow-up commit

### Phase 5: after the merge (rule 5: a layer change is finished when the machine is converged)

The extension ships from this layer's `Home/common`, so the change reaches `star` only when writ deploys it. This
phase cannot close inside the pull request, so the plan stays `active` through it and closes in a follow-up commit.

- [x] `writ deploy` on this machine (2026-10-21, build 272e6a98); `readlink -f ~/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star`
      resolves into the layer at the merge
- [x] `star gh issues report --epic Authorization --view table --state open` shows devlore-cli#679 under #520 as a
      chore awaiting decomposition, and `--epic SystemTree` shows personal#289 to #295 under personal#287
- [x] `star gh issues audit` reports no fault on those eight -- 2026-10-21, on the deployed star; 71 faults in all, the 67 chores carrying a `**Feature:**` marker among them, for #363
- [x] Status `complete`; #344 closed, and #358 and #360 closed by the owner after the proof -- 2026-10-21

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/344-issue-hierarchy.md` | Create | This plan |
| `docs/issue-standards.md` | Modify | The three tiers, the two markers, the chore's epic rule |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | `is_child`, `is_parent`, `parent`, the rows, the faults, the wording |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/gh-issues-report.star` | Modify | The tree document's parents and counts |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/gh-issues-audit.star` | Modify | The new faults, if its text names the old rule |
| `docs/guides/development-process.md` | Modify | Lanes are tasks and bugs |

## Related Documents

- [docs/issue-standards.md](../../issue-standards.md), the document this plan changes
- [#303](https://github.com/NobleFactor/noblefactor-ops/issues/303), the schedule-as-a-kind rework on the same table
- [#156](https://github.com/NobleFactor/noblefactor-ops/issues/156), Issue standards: the scheme and the documents
  that state it, the feature this scheme belongs to under the old shape
- devlore-cli#520's first comment, § 4, where the ruling was first applied, and David-Noble-at-work/personal#287,
  the first chore with lanes

## Open Questions

- Whether a chore may carry a `Thread:` label as a feature may. Nothing says no; the plan assumes yes and the
  standard says so only if the owner confirms.
- Whether `**Chore:**` is the marker's word, or the parent marker becomes kind-neutral (`**Parent:** #N`). The plan
  takes the kind-named form, because the audit can then check the kind named against the kind found.
