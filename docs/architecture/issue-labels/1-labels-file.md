---
title: "1. The labels file"
---

# 1. The labels file — the organization's labels, as data one command applies

> **Status:** stub, 2026-10-19. Companion: [`1-labels-file.status.md`](1-labels-file.status.md). Work:
> [NobleFactor/noblefactor-ops#320](https://github.com/NobleFactor/noblefactor-ops/issues/320). Feature:
> [NobleFactor/noblefactor-ops#156](https://github.com/NobleFactor/noblefactor-ops/issues/156).

## Problem

A NobleFactor repository's labels are made by hand, one repository at a time, so they drift. Before 2026-10-19, eight
of the organization's eleven repositories had no `chore` label, though [issue-standards.md](../../issue-standards.md)
makes `chore` the kind of every piece of process work; of the eight compared that day, four have no `feature`, `task`
or `epic` either. Nothing records the set, so a new repository starts with GitHub's defaults and whatever someone
remembers to add.

## Overview

- **The file:** [labels.yaml](labels.yaml), beside this document, the design's live asset. It has one entry for each
  of the organization's labels, in the GitHub API's own fields, `name`, `color` and `description`, so the command hands
  each entry to GitHub unchanged.
- **What it holds:** the five kinds issue-standards.md defines, `bug`, `chore`, `epic`, `feature` and `task`;
  `Epic:Ops:Process`, which issue-standards.md says every participating repository provides; and the GitHub defaults
  the organization keeps. A repository's own `Epic:<Name>` and `Thread:<Name>` labels stay with it.
- **Its first values:** noblefactor-ops's labels on 2026-10-19, less its `Thread:` labels.
- **The command:** applied to a repository, it creates each label in the file that is missing there and corrects one
  whose color or description differs; with `--check` it reports the difference and changes nothing. It removes
  nothing: a label outside the file is the repository's own.

## Open

1. **The command.** Proposed: `scripts/Set-GitHubLabels <owner>/<repository> [--check]`, which runs
   `gh label create --force` for each entry, until star has a command of its own.
2. **Which GitHub defaults stay.** Proposed: the nine noblefactor-ops has today, and `business`.
3. **Where the command runs.** Proposed: by hand when a repository is made, and its `--check` in each repository's
   CI.
