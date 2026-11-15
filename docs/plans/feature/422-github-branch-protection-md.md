---
title: "github-branch-protection.md records the eight Installers checks as required on devlore-cli's develop"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/422
status: complete
created: 2026-11-01
updated: 2026-11-01
---

# Plan: github-branch-protection.md records the eight Installers checks as required on devlore-cli's develop

The owner ruled on 2026-10-29, on lane 36 of NobleFactor/devlore-cli#949 (devlore-cli#1052), that the Installers
workflow's eight checks become required on devlore-cli's `develop`. The ruleset edit was made on 2026-11-01: ruleset
21539972 now requires nineteen contexts. The branch-protection document is the record of what the rulesets require,
and it still says eleven.

One pull request, from `feature/422-github-branch-protection-md`, resolving #422; the devlore-cli lane closes with
it. Lane 36 of the schedule NobleFactor/devlore-cli#949.

## Rulings

- 2026-10-29, the owner, on devlore-cli#1052: "yes. require all eight. open the docs PR."

## Current State

`docs/github-branch-protection.md` at `59740c9`: the two-tier table names `test` and `scenario` legs alone; "Where
tier 2 lives" says ruleset 21539972 requires eleven contexts; the changelog ends at 2026-08-26. The live ruleset,
read back after the edit on 2026-11-01, requires nineteen: `quality-gate`, the ten platform legs, and the eight
Installers contexts, each confirmed against the check runs on develop at `fd217da6` as the document's own rule asks.

## Requirements

### Requirement 1: The document says what the ruleset requires

- The two-tier table gains an installer row under tier 2: every context of the Installers workflow, for a repository
  that publishes an installer.
- The legend names `install.sh (…)`, `install.ps1 (…)` and `faux channel (build)` beside `test` and `scenario`.
- "Where tier 2 lives" says nineteen, lists the eight by name, records the ruling, the commit they were confirmed
  against and the merge that showed the gap, devlore-cli#1103, and says a new installer platform adds a context.
- The changelog records 2026-11-01.

### Requirement 2: Nothing else changes

The organization rulesets, the context-naming rule and the management commands are untouched; the ruleset edit
itself is not this repository's.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed with the work; the owner directed the work on 2026-11-01, "Run the ruleset script and open
      the branch", the ruling itself given 2026-10-29

### Phase 2: The work, in one commit

- [x] Requirement 1 in the document; `make check` green on this host, 2026-11-01, every gate and every test

### Merge

- [x] `make check`, finished green as the PR script runs it before the commit that carries this plan; a failure there
      stops the script before anything is committed
- [x] PR script `~/Workspace/NobleFactor/noblefactor-engprod.422-github-branch-protection-md.bash` written, shown
      and handed over; the PR resolves #422 and records lane 36 on devlore-cli#949. Its one commit sets this plan
      `complete`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/github-branch-protection.md` | Modify | Requirement 1 |

## Open Questions

None.
