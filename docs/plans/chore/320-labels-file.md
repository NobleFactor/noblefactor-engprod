---
title: "A labels file names every label a NobleFactor repository carries, and one command applies it"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/320
status: draft
created: 2026-10-19
updated: 2026-10-19
---

# Plan: A labels file names every label a NobleFactor repository carries, and one command applies it

## Summary

noblefactor-ops keeps the organization's labels as data, `docs/architecture/issue-labels/labels.yaml`, the live asset
of the issue-labels design, and star's `gh labels audit` and `gh labels sync`, which find and repair a repository's
labels today from a set in code, read that file instead.

## Schedule

A chore under issue standards, NobleFactor/noblefactor-ops#156, filed 2026-10-19. The owner: "Yes, record this as a
Standards chore. We need a machine-readable asset that we can pump into a GitHub repository." Its place on a schedule
is not ruled.

## Goals

1. **One record.** The organization's labels are written down once, as data.
2. **The commands read it.** star's audit and sync take their set from the record, not from code.
3. **Every repository.** Each NobleFactor repository carries the organization's labels.

## Current State

| Part | Today |
| --- | --- |
| The labels | Made by hand, one repository at a time. Before 2026-10-19, eight of the organization's eleven repositories had no `chore` label; of the eight compared that day, four have no `feature`, `task` or `epic` either. |
| A record of them | None. [issue-standards.md](../../issue-standards.md) states the label families, not their names, colors and descriptions. |
| The commands | star's `gh labels audit` and `gh labels sync`, in the base layer's GitHub extension. Their names are code, `REQUIRED_EVERYWHERE` in `scheme.star`; each color and description is the first repository's. |

## Requirements

### Requirement 1: the file

The issue-labels design's [1. The labels file](../../architecture/issue-labels/1-labels-file.md) says what the file
holds and what it leaves to each repository; [labels.yaml](../../architecture/issue-labels/labels.yaml) is the file.

### Requirement 2: star reads the file

star's `gh labels audit` and `gh labels sync` take their set from labels.yaml. The audit says which labels a
repository lacks and which differ from the file; the sync creates the missing and aligns the rest, deletes nothing,
and honors `--dry-run`. Where star reads the file is the design's second open item. Asked on 2026-10-19 whether to
build on these two commands rather than a new one, the owner: "Yes".

### Requirement 3: every repository

`star gh labels sync --repo <owner>/<repository>` runs on each of the organization's repositories, and each carries
the organization's labels.

## Implementation Phases

### Phase 1: The plan and the design

- [ ] This plan, and the issue-labels design's stub with labels.yaml, committed on the branch and reviewed with the
  owner.

### Phase 2: star reads the file

- [ ] Requirement 2.

### Phase 3: Every repository

- [ ] Requirement 3: `star gh labels audit` clean on each repository.

### Phase 4: Closure

- [ ] The pull request, closing #320, the design's status companion saying what is built.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/320-labels-file.md` | Create | this plan |
| `docs/architecture/issue-labels/index.md` | Create | the design's index |
| `docs/architecture/issue-labels/1-labels-file.md` and its status companion | Create | the design |
| `docs/architecture/issue-labels/labels.yaml` | Create | the organization's labels, the design's live asset |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | the set from labels.yaml, not from code |

## Related Documents

- NobleFactor/noblefactor-ops#320; NobleFactor/noblefactor-ops#156, issue standards
- [The issue-labels design](../../architecture/issue-labels/index.md)
- [issue-standards.md](../../issue-standards.md), the label families the file encodes

## Open Questions

The design's four open items: thread labels, where star reads the file, which GitHub defaults stay, and where the
commands run.
