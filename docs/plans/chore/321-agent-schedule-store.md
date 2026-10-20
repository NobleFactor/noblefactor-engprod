---
title: "Every start-claude directory becomes agent-schedule, and --continue finds a conversation where it runs"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/321
status: draft
created: 2026-10-20
updated: 2026-10-20
---

# Plan: Every start-claude directory becomes agent-schedule, and --continue finds a conversation where it runs

## Summary

The last lane of NobleFactor/noblefactor-ops#301. Every directory named `start-claude` becomes `agent-schedule`, the
store on Unix and on Windows and the helpers' directory, and each host's store moves once. A case in both test scripts
proves what David-Noble-at-work/personal#278 asked of `--continue`: a conversation resumed in another clone is the one
`Start-Claude --continue` finds there.

## Schedule

Lane 13 of NobleFactor/noblefactor-ops#301, its last, moved here from David-Noble-at-work/personal#278. The owner,
2026-10-20: "Move Personal#278 to noblefactor-ops and let's finish it so that we can get this off our plate. Your
primary mission then shifts to lifecycle management."

## Goals

1. **One name.** No directory is named `start-claude` on any host, and nothing names one.
2. **`--continue` meets a conversation where it runs,** and a test says so.

## Current State

| Part | Today |
| --- | --- |
| The store | `${XDG_STATE_HOME:-~/.local/state}/start-claude/<owner>/<repository>/<number>` for Start-Claude, and `start-claude\<owner>\<repository>\<number>.json` under `XDG_STATE_HOME` or `~\.local\state` for Start-Claude.ps1: one entry per schedule, holding the background session's short id |
| The helpers | `Home/common.Darwin/.local/libexec/start-claude/` and `Home/common.Linux/.local/libexec/start-claude/`, `keychain.sh` and `lock-store.sh`, deployed as `~/.local/libexec/start-claude` |
| `--continue` | Takes the conversation claude lists in the startup directory, running or stopped, the latest of several; with none, hands the directory to claude's own `--continue` ([2. Command line](../../architecture/agent-schedule/2-command-line.md)) |
| Gone since #278 was filed | Sync-ClaudeSession and its hook, and the tmux options `@start-claude-schedule` and `@start-claude-session` |
| The names | 9 files of code and tests and 6 design documents name `start-claude`; two plans name it as history |

## Requirements

### Requirement 1: the names

Every `start-claude` directory becomes `agent-schedule`: the store root in Start-Claude and Start-Claude.ps1;
`Home/common.Darwin/.local/libexec/start-claude/` and `Home/common.Linux/.local/libexec/start-claude/`, moved with
`git mv`, and Start-Claude's path to them; the test scripts; Start-Claude(1)'s files, Start-Claude.ps1's help, and the
agent-schedule design. Nothing reads an old name. The plans keep theirs, as history.

### Requirement 2: each host's store moves once

After the merge, each host's store is renamed in place, `start-claude` to `agent-schedule`, its entries kept, and
`writ deploy` puts the helpers under `~/.local/libexec/agent-schedule`; the emptied `~/.local/libexec/start-claude` is
removed. The pull request's script does this on Danoble-MBP-A and danoble-ud24-1, and writes danoble-wd11-3's as a
script for the owner to run there.

### Requirement 3: `--continue` in another clone

David-Noble-at-work/personal#278's check, as a case in both test scripts: a conversation that claude lists in another
clone, where `--schedule` with `--directory` resumed it, is the one `--continue` finds in that clone.

## Implementation Phases

### Phase 1: The plan

- [ ] This plan, committed on its branch and reviewed with the owner.

### Phase 2: The names and the test

- [ ] Requirements 1 and 3: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`.

### Phase 3: The hosts

- [ ] Requirement 2, after the merge.

### Phase 4: Closure

- [ ] The pull request, closing #321 and lane 13 of #301, the agent-schedule design's status companions saying so.

## Migration Path

Requirement 2: each host's store keeps its entries under the new name. Nothing reads the old one.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/321-agent-schedule-store.md` | Create | this plan |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | the store root and the helpers' path |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | the store root and its help |
| `Home/common.Darwin/.local/libexec/start-claude/` and `Home/common.Linux/.local/libexec/start-claude/` | Move | to `agent-schedule/` |
| `Home/common.Unix/.local/share/man/man1/Start-Claude.1` | Modify | its files |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Modify | the new names, and requirement 3's case |
| `docs/architecture/agent-schedule/` | Modify | the store's name, and the status companions |

## Related Documents

- NobleFactor/noblefactor-ops#321, moved from David-Noble-at-work/personal#278; NobleFactor/noblefactor-ops#151
- NobleFactor/noblefactor-ops#301 (schedule), lane 13
- [2. Command line](../../architecture/agent-schedule/2-command-line.md) and
  [1. Session model](../../architecture/agent-schedule/1-session-model.md)

## Open Questions

1. **`--continue` and the store.** David-Noble-at-work/personal#278 asked that `--continue` never take a conversation
   the store does not hold. Since phase 18 of David-Noble-at-work/personal#259 it takes the one claude lists in the
   directory, stored or not, and with none hands the directory to claude's own `--continue`. Proposed: keep that, since
   refusing would leave a conversation claude runs in the directory out of `--continue`'s reach, and the new case pins
   it.
2. **#301's other open lanes,** 5, 6, 8 and 9, which are not Start-Claude's. Proposed: they move to the Process and
   Tools schedule NobleFactor/devlore-cli#916's goal calls for, so that #301 closes with this pull request.
3. **`~/.local/state/start-claude-tests` on Danoble-MBP-A,** output left by David-Noble-at-work/personal#273's runs.
   Proposed: the owner deletes it.
