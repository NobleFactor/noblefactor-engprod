---
title: "Every start-claude directory becomes agent-schedule, on every platform and every host"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/321
status: complete
created: 2026-10-20
updated: 2026-10-21
---

# Plan: Every start-claude directory becomes agent-schedule, on every platform and every host

## Summary

Half of the last lane of NobleFactor/noblefactor-ops#301. Every directory named `start-claude` becomes `agent-schedule`,
the store on Unix and on Windows and the helpers' directory, and each host's store moves once, its entries with it. The
lane's other half, `--continue` finding a conversation resumed in another clone, is NobleFactor/noblefactor-ops#322.

## Schedule

Lane 13 of NobleFactor/noblefactor-ops#301, moved here from David-Noble-at-work/personal#278 and split the
same day. The owner, 2026-10-20: "Move Personal#278 to noblefactor-ops and let's finish it so that we can get this off
our plate. Your primary mission then shifts to lifecycle management." Then: "We should split it into two issue."

## Goals

1. **One name.** No directory is named `start-claude` on any host, and nothing names one.
2. **Nothing lost.** Every schedule keeps its conversation through the move.

## Current State

| Part | Today |
| --- | --- |
| The store | `${XDG_STATE_HOME:-~/.local/state}/start-claude/<owner>/<repository>/<number>` for Start-Claude, and `start-claude\<owner>\<repository>\<number>.json` under `XDG_STATE_HOME` or `~\.local\state` for Start-Claude.ps1: one entry per schedule, holding the background session's short id |
| The helpers | `Home/common.Darwin/.local/libexec/start-claude/` and `Home/common.Linux/.local/libexec/start-claude/`, `keychain.sh` and `lock-store.sh`, deployed as `~/.local/libexec/start-claude` |
| Gone since David-Noble-at-work/personal#278 was filed | Sync-ClaudeSession and its hook, and the tmux options `@start-claude-schedule` and `@start-claude-session` |
| The names | 9 files of code and tests and 6 design documents name `start-claude`; two plans name it as history |

## Requirements

### Requirement 1: the names

Every `start-claude` directory becomes `agent-schedule`: the store root in Start-Claude and Start-Claude.ps1;
`Home/common.Darwin/.local/libexec/start-claude/` and `Home/common.Linux/.local/libexec/start-claude/`, moved with
`git mv`, and Start-Claude's path to them; the test scripts; Start-Claude(1)'s files, Start-Claude.ps1's help, and the
agent-schedule design. Nothing reads an old name. The plans keep theirs, as history.

Those two directories hold every helper Start-Claude has, `keychain.sh` and `lock-store.sh`. None is in `.local/bin`,
and Start-Claude.ps1 runs no script of ours. Asked where the helpers live, the owner, 2026-10-20: "yes. ALL helpers
should live in libexec under agent-schedule." Then: "I am of course talking about the helpers for Start-Claude, yes?"

### Requirement 2: each host's store moves once

After the merge, each host's store is renamed in place, `start-claude` to `agent-schedule`, and its entries move with
it, so that every schedule keeps its conversation. Asked whether they should, the owner, 2026-10-20: "Yes". `writ
deploy` then puts the helpers under `~/.local/libexec/agent-schedule`, and the emptied `~/.local/libexec/start-claude`
is removed. The pull request's script does this on Danoble-MBP-A and danoble-ud24-1, and writes danoble-wd11-3's as a
script for the owner to run there.

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on its branch as 6c57aa3 on 2026-10-20, then revised with the owner's rulings and committed
  again. Asked whether to proceed on the revision, the owner, the same day: "yes, proceed with #321".

### Phase 2: The names

- [x] Requirement 1: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`, in a script the owner runs. The owner, 2026-10-19: "you must prepare a script for me to run
  in all cases." Done 2026-10-20: the script moved both helpers' directories with `git mv`, and committed the names
  once both gates passed. Its small calls, which the owner accepted the same day ("I accept the small calls you
  made."): lock-store.sh's header names Start-Claude alone, Sync-ClaudeSession being gone; the tests' fake remote,
  example/start-claude-test, keeps its name, since it names a repository, not a directory; and
  2-command-line.status.md ticks the rename and the move to noblefactor-ops in the commit that makes the names.

### Phase 3: The hosts

- [x] Requirement 2, after the merge, 2026-10-21. On Danoble-MBP-A and danoble-ud24-1 a second script finished it: the
  merge script stopped on the two old helper links writ deploy leaves, by design (anthropics/claude-code#103913), and
  the second removed them. danoble-wd11-3 by the owner's run of its PowerShell script, which found no store to move;
  the owner: "it otherwise finished cleanly". Ticked in NobleFactor/noblefactor-ops#322's pull request.

### Phase 4: Closure

- [x] The pull request, closing #321 and NobleFactor/noblefactor-ops#314, which rides it; lane 13 of #301 closes with
  it, and #322 is lane 15. The agent-schedule design's status companions say so, and 2-command-line.status.md's
  item for the move to noblefactor-ops, owed since NobleFactor/noblefactor-ops#313 merged, is ticked, both in the
  commit that makes the names. The owner, 2026-10-20, of #314: "this goes in with the next pr."

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
| `tests/Test-StartClaude` | Modify | the new names; `tests/Test-StartClaude.ps1` names neither directory |
| `docs/architecture/agent-schedule/` | Modify | the store's name, and the status companions |

## Related Documents

- NobleFactor/noblefactor-ops#321, moved from David-Noble-at-work/personal#278; NobleFactor/noblefactor-ops#322, its
  other half; NobleFactor/noblefactor-ops#151
- NobleFactor/noblefactor-ops#301 (schedule), lane 13
- NobleFactor/noblefactor-ops#300, lane 9 of #301: where a script that only other programs run lives
- NobleFactor/noblefactor-ops#314, which rides this pull request: Start-Claude's files take Apache-2.0
- [2. Command line](../../architecture/agent-schedule/2-command-line.md) and
  [1. Session model](../../architecture/agent-schedule/1-session-model.md)

## Open Questions

1. **The store's entries.** Ruled 2026-10-20: they move with the directory (requirement 2).
2. **#301's other open lanes,** 5, 6, 8 and 9. Ruled 2026-10-20: they stay, and #301 closes when they are done. The
   owner: "we obviously can't close #301 until each of these lanes is complete. we have work to do."
3. **`~/.local/state/start-claude-tests` on Danoble-MBP-A,** output left by David-Noble-at-work/personal#273's runs.
   Proposed: the owner deletes it.
4. **Where Start-Claude's helpers live.** Ruled 2026-10-20: in `.local/libexec/agent-schedule/` (requirement 1). What
   a helper is, the owner, the same day: "The criteria is not that a script is used nowhere but in another script. The
   criteria is that it supports a body of code and makes no sense outside the body of code that it serves." Lane 9's
   draft rule, NobleFactor/noblefactor-ops#300, names a helper's directory for the program that runs it, which here
   would be `start-claude`; lane 9 settles the general rule. Proposed: lane 5's startup hook,
   NobleFactor/noblefactor-ops#260, which writes to Start-Claude's store, is the next such helper and lives there too,
   where its issue proposes the base layer beside the star skills.
