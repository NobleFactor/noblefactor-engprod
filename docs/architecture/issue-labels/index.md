---
title: "Issue labels — one set, applied to every NobleFactor repository"
---

# Issue labels — one set, applied to every NobleFactor repository

> **Status:** stub, 2026-10-19. The work:
> [NobleFactor/noblefactor-ops#320](https://github.com/NobleFactor/noblefactor-ops/issues/320), a chore under issue
> standards, [NobleFactor/noblefactor-ops#156](https://github.com/NobleFactor/noblefactor-ops/issues/156). The
> [plan](../../plans/chore/320-labels-file.md) holds its phases and the owner's rulings, each quoted with its date.

Every NobleFactor repository carries the same labels, the ones [issue-standards.md](../../issue-standards.md) defines.
A repository gets them from one file this design keeps, [labels.yaml](labels.yaml), which star's `gh labels sync`
applies and `gh labels audit` checks.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. The labels file](1-labels-file.md) | The problem, the file, the star commands that read it, and their open items | [Stub](1-labels-file.status.md) |

## Terms

- **Label:** a GitHub issue label: a name, a color and a description.
- **The organization's labels:** the ones every repository carries: the five kinds, `Epic:Ops:Process`, and the GitHub
  defaults the organization keeps. [labels.yaml](labels.yaml) lists them.
- **An epic's label:** an `Epic:<Name>` label, which only the repository that hosts its epic carries, as
  issue-standards.md has it.
- **A thread label:** a `Thread:<Name>` label, which star's audit expects in every repository it reads, since a
  thread's issues span repositories.
