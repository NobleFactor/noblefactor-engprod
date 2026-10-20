---
title: "1. The labels file"
---

# 1. The labels file — the organization's labels, as data star's label commands read

> **Status:** stub, 2026-10-19. Companion: [`1-labels-file.status.md`](1-labels-file.status.md). Work:
> [NobleFactor/noblefactor-ops#320](https://github.com/NobleFactor/noblefactor-ops/issues/320). Feature:
> [NobleFactor/noblefactor-ops#156](https://github.com/NobleFactor/noblefactor-ops/issues/156).

## Problem

A NobleFactor repository's labels drift. Before 2026-10-19, eight of the organization's eleven repositories had no
`chore` label, though [issue-standards.md](../../issue-standards.md) makes `chore` the kind of every piece of process
work; of the eight compared that day, four have no `feature`, `task` or `epic` either.

star's `gh labels audit` and `gh labels sync`, in the base layer's GitHub extension, find and repair that drift, but
nothing records the set they enforce. Its names are code, `REQUIRED_EVERYWHERE` in the extension's `scheme.star`, and
each label's color and description are whatever the first repository read carries, so the record is that repository.

## Overview

- **The file:** [labels.yaml](labels.yaml), beside this document, the design's live asset. It has one entry for each
  of the organization's labels, in the GitHub API's own fields, `name`, `color` and `description`.
- **What it holds:** the five kinds issue-standards.md defines, `bug`, `chore`, `epic`, `feature` and `task`;
  `Epic:Ops:Process`, which issue-standards.md says every participating repository provides; and the GitHub defaults
  the organization keeps. An `Epic:<Name>` label stays with the repository that hosts its epic.
- **Its first values:** noblefactor-ops's labels on 2026-10-19, less its `Thread:` labels.
- **The commands:** star's `gh labels audit` and `gh labels sync` take their set from the file, not from code. The
  audit says which labels a repository lacks and which differ from the file; the sync creates the missing and aligns
  the rest, deletes nothing, and with `--dry-run` reports what it would change. `--repo` names any repository, a new
  one included: `star gh labels sync --repo NobleFactor/<repository>`.

## Open

1. **Thread labels.** The audit expects every `Thread:` label in every repository it reads, since a thread's issues
   span repositories; the file does not list them. Proposed: star keeps finding them as it does, and the file holds
   the fixed set.
2. **Where star reads the file.** Proposed: from develop, through GitHub's contents API, so this design's file is the
   one live copy and no deploy has to carry it.
3. **Which GitHub defaults stay.** Proposed: the nine noblefactor-ops has today, and `business`.
4. **Where the commands run.** Proposed: the sync by hand when a repository is made, and the audit in each
   repository's CI.
