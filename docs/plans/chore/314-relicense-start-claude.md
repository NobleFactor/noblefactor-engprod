---
title: "Start-Claude, Start-Claude.ps1 and their files take Apache-2.0"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/314
status: active
created: 2026-10-20
updated: 2026-10-20
---

# Plan: Start-Claude, Start-Claude.ps1 and their files take Apache-2.0

## Summary

The eleven files NobleFactor/noblefactor-ops#313 copied from David-Noble-at-work/personal take this repository's
license header, Apache-2.0, in place of personal's MIT. After it, no file in noblefactor-ops carries an MIT license
header. The work rides NobleFactor/noblefactor-ops#321's branch and pull request, which edits eight of the eleven.

## Schedule

It follows NobleFactor/noblefactor-ops#312, whose copy brought the MIT headers, and rides the pull request for lane 13
of NobleFactor/noblefactor-ops#301. The owner, 2026-10-20: "We need to update the licenses across the board in
noblefactor-ops. we have an issue for that. we make the change now." Then: "this goes in with the next pr."

## Goals

1. **One license.** Every file in noblefactor-ops says Apache-2.0. The two plans that tell the MIT history,
   NobleFactor/noblefactor-ops#146's and NobleFactor/noblefactor-ops#179's, keep it.

## Current State

| Part | Today |
| --- | --- |
| The repository | `LICENSE` is the Apache License, Version 2.0; the twelve git commands say Apache-2.0 since NobleFactor/noblefactor-ops#146 |
| The eleven | `SPDX-License-Identifier: MIT`; five also grant redistribution under the MIT License, and Start-Claude(1)'s LICENSE section says "MIT License." |

## Requirements

### Requirement 1: the header

Each of the eleven files carries the house header, as `.\"` comments in the man page:

```text
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.
```

The line granting redistribution under the MIT License goes. Start-Claude.ps1's and Test-StartClaude.ps1's headers,
each run together into one comment, become the two lines. Start-Claude(1)'s LICENSE section says "Apache License,
Version 2.0."

### Requirement 2: the ruling, recorded

NobleFactor/noblefactor-ops#312's plan, whose question 1 proposed that the copies keep MIT, records the ruling. The
owner, 2026-10-19: "all licenses for noblefactor repos MUST be Apache."

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on NobleFactor/noblefactor-ops#321's branch by the script that showed it to the owner,
  2026-10-20, under the owner's order the same day: "we make the change now."

### Phase 2: The headers

- [ ] Requirements 1 and 2: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`, in the script that commits NobleFactor/noblefactor-ops#321's names.

### Phase 3: Closure

- [ ] NobleFactor/noblefactor-ops#321's pull request closes this issue as well.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/314-relicense-start-claude.md` | Create | this plan |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | the header |
| `Home/common.Unix/.local/share/man/man1/Start-Claude.1` | Modify | the header, and its LICENSE section |
| `Home/common.Unix/.local/share/bash-completion/completions/Start-Claude` | Modify | the header |
| `Home/common.Unix/.local/share/zsh/site-functions/_Start-Claude` | Modify | the header |
| `keychain.sh` and `lock-store.sh`, in `Home/common.Darwin/.local/libexec/agent-schedule/` and `Home/common.Linux/.local/libexec/agent-schedule/` | Modify | the header |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | the header |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Modify | the header |
| `docs/plans/chore/312-copy-start-claude.md` | Modify | question 1's ruling |

## Related Documents

- NobleFactor/noblefactor-ops#314; NobleFactor/noblefactor-ops#312 and its plan, question 1
- NobleFactor/noblefactor-ops#321, whose branch and pull request carry this
- NobleFactor/noblefactor-ops#146's plan: "The twelve are relicensed Apache-2.0 on arrival"

## Open Questions

None.
