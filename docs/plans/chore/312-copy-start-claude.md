---
title: "Start-Claude and Start-Claude.ps1 come to noblefactor-ops, and make and CI run every test"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/312
status: complete
created: 2026-10-19
updated: 2026-10-20
---

# Plan: Start-Claude and Start-Claude.ps1 come to noblefactor-ops, and make and CI run every test

## Summary

noblefactor-ops takes Start-Claude and Start-Claude.ps1 from David-Noble-at-work/personal, with everything that ships or
tests them, and runs every test it holds: from make on this machine, from make on each machine the owner names, and in
CI on Linux, macOS and Windows. David-Noble-at-work/personal#285 then removes personal's copies.

## Schedule

Lane 2 of NobleFactor/noblefactor-ops#301 (schedule), under David-Noble-at-work/personal#260, after lane 10,
David-Noble-at-work/personal#273, merged as David-Noble-at-work/personal#284. Its removal half,
David-Noble-at-work/personal#285, comes next. The owner, 2026-10-19: "At the end of the first issue, I expect that i
will have make targets that run ALL tests on every machine that I name on the make command line. I also expect
integration with CI".

## Goals

1. **One home.** Start-Claude and Start-Claude.ps1, their helpers, man page, completions, design and tests live here,
   and writ deploys them from this repository's layers.
2. **Every test from make, on every machine named.** `make test` runs every test under `tests/` here, and
   `make test HOSTS="..."` runs them on each machine named.
3. **Every test in CI,** on Ubuntu, macOS and Windows.

## Current State

| Part | Today |
| --- | --- |
| Start-Claude, its man page and completions | personal, `Home/noblefactor-ops.Unix` |
| Its helpers, `keychain.sh` and `lock-store.sh` | personal, `Home/noblefactor-ops.Darwin` and `Home/noblefactor-ops.Linux` |
| Start-Claude.ps1 | personal, `Home/common.Windows/.local/bin` |
| The agent-schedule design | personal, `docs/architecture/agent-schedule`, nine documents |
| Their tests | personal, `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1`, run by hand and by personal#284's script |
| This repository's layers | `Home/common` and `Home/common.Windows` |
| This repository's tests | `tests/Test-DeclareBashScript` and `tests/Test-GitCloseBranch`, run by `make test`, which runs every file in `tests/` as a program, and by CI's `quality-gate` job, on `ubuntu-26.04` alone |

## Requirements

### Requirement 1: the copy

Each file lands in the layer that deploys it where personal's did (proposed, question 2):

| From personal | To noblefactor-ops |
| --- | --- |
| `Home/noblefactor-ops.Unix/.local/bin/Start-Claude`; its man page, `.local/share/man/man1/Start-Claude.1`; its completions, `.local/share/bash-completion/completions/Start-Claude` and `.local/share/zsh/site-functions/_Start-Claude` | the same paths under `Home/common.Unix`, a new layer directory |
| `Home/noblefactor-ops.Darwin/.local/libexec/start-claude/keychain.sh` and `lock-store.sh` | `Home/common.Darwin/.local/libexec/start-claude/`, new |
| `Home/noblefactor-ops.Linux/.local/libexec/start-claude/keychain.sh` and `lock-store.sh` | `Home/common.Linux/.local/libexec/start-claude/`, new |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | `Home/common.Windows/.local/bin/Start-Claude.ps1` |
| `docs/architecture/agent-schedule/`, nine documents | `docs/architecture/agent-schedule/` |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | `tests/` |

The scripts keep their content. The test scripts take Declare-BashScript from this repository's
`Home/common/.local/bin`, as its other tests do, and find what they test in its new layers. The design documents'
links to personal's plans become links to them on GitHub.

### Requirement 2: every test from make, on every machine named

- **`make test`** runs every test under `tests/` that this machine's platform runs: on macOS and Linux the bash tests,
  each as a program, as today, through `scripts/Test-Here`; on Windows the PowerShell tests, `tests/*.ps1`, each in a
  pwsh of its own, through `scripts/Test-Here.ps1`.
- **`make test HOSTS="<host> ..."`** runs the same on each host named, through `scripts/Test-OnHosts`.
  A name that is this machine's runs here. Any other host gets a copy of the working tree, in a folder of its own
  under `~/.local/state/noblefactor-ops-tests` that goes once its tests pass, and runs them there, straight to its
  login shell, as the owner runs a test there (ruled 2026-10-13). Whether a host is Windows is asked of it. Every host
  runs; a host that fails fails the target, and the run says which.

```bash
make test
make test HOSTS="Danoble-MBP-A danoble-ud24-1.local danoble-wd11-3.local"
```

### Requirement 3: every test in CI

- **`quality-gate`** keeps its name, which ruleset 12426847 requires, and its `make check` on `ubuntu-26.04`, which now
  runs the moved tests too; tmux joins its tools.
- **A macOS job** installs with Homebrew what the owner's Mac puts first on PATH: bash 5.3, GNU getopt, GNU make, and
  the GNU coreutils, diffutils, findutils, grep, sed and awk; and tmux. Then it runs `make test`.
- **A Windows job** runs the PowerShell tests with pwsh. Test-StartClaude.ps1 stands in a tmux that refuses every
  command where psmux is missing, as on a runner, and its attached case reports itself skipped with no console.

### Requirement 4: the deploy

This pull request merges, then David-Noble-at-work/personal#285's, and only then do the hosts deploy, so that no host
has two layers deploying one file (proposed, question 3).

## Implementation Phases

### Phase 1: The plan

- [x] This document, committed on its branch as 700b4fd, 2026-10-19, by the script that showed it to the owner. The
  owner's order the same day: "execute on the issues at hand; one at a time".

### Phase 2: The copy

- [x] Requirement 1: the files in their layers, and the test scripts' paths. The copies' references to personal's issue
  #273 read personal#273, and the nine design documents carry the frontmatter this repository's gate requires.
- [x] `make check` passes on this Mac, the moved tests among its tests: run by the pull request's script before the
  commit that ticks this box, which it does not make when the gate fails.

### Phase 3: make test, here and on the hosts named

- [x] Requirement 2: the Makefile's `test` target by platform, `scripts/Test-Here`, `scripts/Test-Here.ps1` and
  `scripts/Test-OnHosts`.
- [x] The owner's run: `make test HOSTS="Danoble-MBP-A danoble-ud24-1.local danoble-wd11-3.local"`, by the pull
  request's script before the commit that ticks this box.

### Phase 4: CI

- [x] Requirement 3: the macOS and Windows jobs, and tmux for `quality-gate`.
- [x] CI's jobs pass on the pull request: its script merges only when `quality-gate`, `test-macos` and `test-windows`
  have passed on its head.

### Phase 5: Closure

- [x] The pull request, closing #312, its documents with it: the Makefile's and the workflow's comments, and 2. Command
  line and its status companion, which say where the scripts live.

## Migration Path

David-Noble-at-work/personal#285 removes personal's copies once this merges, and the hosts deploy after it
(requirement 4).

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/312-copy-start-claude.md` | Create | this plan |
| `Home/common.Unix/.local/bin/Start-Claude`, its man page and completions | Create | Start-Claude, from personal |
| `Home/common.Darwin/.local/libexec/start-claude/*.sh` and `Home/common.Linux/.local/libexec/start-claude/*.sh` | Create | its helpers, from personal |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Create | Start-Claude.ps1, from personal |
| `docs/architecture/agent-schedule/` | Create | the design, from personal, with frontmatter |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Create | their tests, from personal |
| `scripts/Test-Here` and `scripts/Test-Here.ps1` | Create | `make test` on macOS and Linux, and on Windows |
| `scripts/Test-OnHosts` | Create | `make test HOSTS=...` |
| `Makefile` | Modify | `test` by platform, and with `HOSTS` |
| `.github/workflows/ci.yaml` | Modify | tmux for `quality-gate`; the macOS and Windows jobs |

## Related Documents

- NobleFactor/noblefactor-ops#312; David-Noble-at-work/personal#285, its removal half; David-Noble-at-work/personal#260
- [The plan for David-Noble-at-work/personal#273][plan-273], question 13: the owner's rulings on the tests
- NobleFactor/noblefactor-ops#301 (schedule), lane 2

[plan-273]: https://github.com/David-Noble-at-work/personal/blob/main/docs/plans/chore/273-start-claude-ps1-on-psmux.md

## Open Questions

1. **The license lines.** The copied files say MIT, as personal's do; this repository's say Apache-2.0. Proposed: they
   keep MIT, as copies. Ruled otherwise 2026-10-19, of NobleFactor/noblefactor-ops#313: "I see you give an MIT license
   to Start-Claude and--I assume--the other artifacts in the pr for noblefactor-ops. Update the license. We use apache
   at noblefactor." NobleFactor/noblefactor-ops#314 relicenses them Apache-2.0.
2. **Three new layer directories,** `Home/common.Unix`, `Home/common.Darwin` and `Home/common.Linux`, where personal has
   `noblefactor-ops.Unix`, `.Darwin` and `.Linux`. Proposed: these, so that each file deploys where it did.
3. **The deploy order.** Proposed: both pull requests merge before any host deploys.

The work followed each proposal, under the owner's order to execute; question 1 was ruled afterward, and questions 2
and 3 are not ruled.
