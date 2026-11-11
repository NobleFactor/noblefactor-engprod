---
title: "noblefactor-engprod's CI tests on Ubuntu 26.04, macOS 26, Windows 11 on arm64 and Windows Server 2025"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/480
status: active
created: 2026-11-11
updated: 2026-11-11
---

# Plan: noblefactor-engprod's CI tests on Ubuntu 26.04, macOS 26, Windows 11 on arm64 and Windows Server 2025

noblefactor-engprod's CI tested on Ubuntu 26.04, macOS 15 and Windows Server 2025. After this work it tests on the
matrix the owner set on 2026-11-11.

## Rulings

- 2026-11-11, the owner: noblefactor-engprod's matrix is Ubuntu 26.04, macOS 26 (arm64), Windows 11 (arm64) and Windows
  11 (amd64). GitHub hosts Windows 11 on arm64 alone, and the owner's Windows machine, danoble-wd11-3, is arm64; so,
  ruled the same day, the amd64 leg runs on GitHub's Windows Server 2025.

## Requirements

### Requirement 1: the matrix

| Job | Runner | Operating system |
| --- | --- | --- |
| `quality-gate` | `ubuntu-26.04` | Ubuntu 26.04, amd64; unchanged |
| `test-macos` | `macos-26` | macOS 26, arm64; was `macos-15` |
| `test-windows (windows-11-arm)` | `windows-11-arm` | Windows 11, arm64; new |
| `test-windows (windows-2025)` | `windows-2025` | Windows Server 2025, amd64; unchanged |

The Windows legs run with `fail-fast: false`. The ruleset requires `quality-gate` alone on `develop`, so no required
check changes.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `ci.yaml` | Parses, each job on its runner |
| 2 | `make check` | Passes |
| 3 | The pull request's CI run | Every job passes, its log reporting `ubuntu-26.04`, `macos-26-arm64`, `windows-11-vs2026-arm64` and `windows-2025-vs2026` |

## Implementation Phases

### Phase 1: the plan and the change

- [x] Requirement 1; test cases 1 and 2 pass, on 2026-11-11. The plan ships with the change, at the owner's direction

### Phase 2: merge

- [ ] The pull request script written, shown and handed over; case 3 read from its run into a comment on #480, which
      the pull request closes

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/480-noblefactor-engprod-s-ci-tests.md` | Create | This plan |
| `.github/workflows/ci.yaml` | Modify | Requirement 1 |
