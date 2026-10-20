---
title: "Issue labels — one set, applied to every NobleFactor repository"
---

# Issue labels — one set, applied to every NobleFactor repository

> **Status:** stub, 2026-10-19. The work:
> [NobleFactor/noblefactor-ops#320](https://github.com/NobleFactor/noblefactor-ops/issues/320), a chore under issue
> standards, [NobleFactor/noblefactor-ops#156](https://github.com/NobleFactor/noblefactor-ops/issues/156). The
> [plan](../../plans/chore/320-labels-file.md) holds its phases and the owner's rulings, each quoted with its date.

Every NobleFactor repository carries the same labels, the ones [issue-standards.md](../../issue-standards.md) defines.
A repository gets them from one file this design keeps, [labels.yaml](labels.yaml), applied by one command, which also
says where a repository differs from it.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. The labels file](1-labels-file.md) | The problem, the file, the command that applies it, and their open items | [Stub](1-labels-file.status.md) |

## Terms

- **Label:** a GitHub issue label: a name, a color and a description.
- **The organization's labels:** the ones every repository carries: the five kinds, `Epic:Ops:Process`, and the GitHub
  defaults the organization keeps. [labels.yaml](labels.yaml) lists them.
- **A repository's own labels:** an `Epic:<Name>` or `Thread:<Name>` label, which only the repository that hosts its
  epic or thread carries, as issue-standards.md has it.
