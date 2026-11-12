---
title: "Test-DeclareBashScript runs its zsh cases only where the system ships zsh, and CI installs none"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/478
status: active
created: 2026-11-11
updated: 2026-11-11
---

# Plan: Test-DeclareBashScript runs its zsh cases only where the system ships zsh, and CI installs none

`tests/Test-DeclareBashScript` ran each Set-Environment case in bash and again in zsh (#294), and required zsh
everywhere, so noblefactor-engprod's `quality-gate` job installed zsh from Ubuntu's archive on every run. On 2026-11-11
the runners could not resolve Ubuntu's archive, and both of that morning's runs failed before `make check`, holding
NobleFactor/noblefactor-engprod#477, which #437's proof waits on. After this work the zsh cases run where the system
ships zsh, macOS, and are noted as not tried on Ubuntu, CI's Linux; CI's Linux job installs no zsh, and the macOS job
keeps running the zsh cases.

## Rulings

- 2026-11-11, the owner: remove the zsh tests on every Linux distribution that does not ship zsh, with the evidence for
  each choice, and do it at once. The distributions are those the tests run on: Ubuntu, CI's Linux (the owner, the same
  day, of a first draft that named eight distributions the tests never run on).

## The evidence, by system

Read on 2026-11-11. The test runs on the two systems CI runs it on, and on this macOS machine.

| System | Ships zsh | Evidence | The zsh cases |
| --- | --- | --- | --- |
| macOS | Yes | zsh is the default login shell since macOS 10.15 ([Apple: Use zsh as the default shell on Mac](https://support.apple.com/en-us/102360)); CI's `macos-15` job runs the cases with no install step | Run |
| Ubuntu | No | Ubuntu 24.04.3's release manifests list every package a default install holds: [desktop](https://releases.ubuntu.com/noble/ubuntu-24.04.3-desktop-amd64.manifest), 1,819 packages, and [server](https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.manifest), 689; neither lists zsh, and both list bash. GitHub's `ubuntu-26.04` runner, CI's Linux, installs `zsh zsh-common` as new packages (run 43060431156, 2026-11-11) | Not tried |

## Requirements

### Requirement 1: the zsh cases on macOS

The test runs the zsh cases, and requires zsh, when `uname -s` is Darwin; elsewhere one note says they were not tried,
the system shipping no zsh.

### Requirement 2: CI installs no zsh

CI's `quality-gate` job, on `ubuntu-26.04`, drops zsh from its `apt-get install`; its comment says why. The
`test-macos` job runs the zsh cases.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `Test-DeclareBashScript` on macOS | The zsh cases run and pass |
| 2 | `make check` | Passes |
| 3 | The pull request's `quality-gate` run on `ubuntu-26.04` | Installs no zsh, notes the zsh cases as not tried, and passes |
| 4 | Its `test-macos` run | The zsh cases pass |

## Implementation Phases

### Phase 1: the plan and the change

- [x] Requirements 1 and 2; test cases 1 and 2 pass, on 2026-11-11. The plan ships with the change, at the owner's
      direction to do it at once

### Phase 2: merge

- [ ] The pull request script written, shown and handed over; cases 3 and 4 read from its runs into a comment on #478,
      which the pull request closes

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/478-test-declarebashscript-runs-its.md` | Create | This plan |
| `tests/Test-DeclareBashScript` | Modify | Requirement 1 |
| `.github/workflows/ci.yaml` | Modify | Requirement 2 |

## Related Documents

- #294: the zsh cases, and Set-Environment serving scripts and prompts
- #437: the proof whose pull request #477 this unblocks
