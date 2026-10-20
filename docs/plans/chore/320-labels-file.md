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
of the issue-labels design, and one command applies that file to a repository: it creates each label missing there,
corrects one whose color or description differs, and with `--check` reports the difference and changes nothing.

## Schedule

A chore under issue standards, NobleFactor/noblefactor-ops#156, filed 2026-10-19. The owner: "Yes, record this as a
Standards chore. We need a machine-readable asset that we can pump into a GitHub repository." Its place on a schedule
is not ruled.

## Goals

1. **One record.** The organization's labels are written down once, as data.
2. **One command.** It applies the record to a repository, and reports what differs without changing anything.
3. **Every repository.** Each NobleFactor repository carries the organization's labels.

## Current State

| Part | Today |
| --- | --- |
| The labels | Made by hand, one repository at a time. Before 2026-10-19, eight of the organization's eleven repositories had no `chore` label; of the eight compared that day, four have no `feature`, `task` or `epic` either. |
| A record of them | None. [issue-standards.md](../../issue-standards.md) states the label families, not their names, colors and descriptions. |
| A command | None. |

## Requirements

### Requirement 1: the file

The issue-labels design's [1. The labels file](../../architecture/issue-labels/1-labels-file.md) says what the file
holds and what it leaves to each repository; [labels.yaml](../../architecture/issue-labels/labels.yaml) is the file.

### Requirement 2: the command

Applied to a repository, it creates each label in the file that is missing there and corrects one whose color or
description differs; `--check` reports the difference and changes nothing. It removes nothing: a label outside the
file is the repository's own. Its name and form are the design's first open item.

### Requirement 3: every repository

The command runs on each of the organization's repositories, and each carries the organization's labels.

## Implementation Phases

### Phase 1: The plan and the design

- [ ] This plan, and the issue-labels design's stub with labels.yaml, committed on the branch and reviewed with the
  owner.

### Phase 2: The command

- [ ] Requirement 2, its form as the owner rules it.

### Phase 3: Every repository

- [ ] Requirement 3: the command's `--check` clean on each repository.

### Phase 4: Closure

- [ ] The pull request, closing #320, the design's status companion saying what is built.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/320-labels-file.md` | Create | this plan |
| `docs/architecture/issue-labels/index.md` | Create | the design's index |
| `docs/architecture/issue-labels/1-labels-file.md` and its status companion | Create | the design |
| `docs/architecture/issue-labels/labels.yaml` | Create | the organization's labels, the design's live asset |
| the command | Create | applies labels.yaml to a repository; its place is the design's first open item |

## Related Documents

- NobleFactor/noblefactor-ops#320; NobleFactor/noblefactor-ops#156, issue standards
- [The issue-labels design](../../architecture/issue-labels/index.md)
- [issue-standards.md](../../issue-standards.md), the label families the file encodes

## Open Questions

The design's three open items: the command, which GitHub defaults stay, and where the command runs.
