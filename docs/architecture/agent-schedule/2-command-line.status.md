---
title: "2. Command line — Status"
---

# 2. Command line — Status

**Document:** [2-command-line.md](2-command-line.md)
**Feature:** [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151)
**Plan:** [259-start-claude-documents-claude.md][plan-259]
**State:** Start-Claude built on macOS and Linux, its man page and completions with it; Start-Claude.ps1 built on
Windows with psmux, David-Noble-at-work/personal#273, 2026-10-19.

## Completion

- [x] Start-Claude: `--schedule`, `--resume`, `--continue`, `--detach`, `--no-remote-control`, `--directory` and
  `--shell-width-percent`, with Start-Claude(1) and its bash and zsh completions.
- [x] Start-Claude.ps1 on psmux: David-Noble-at-work/personal#273. `-Schedule`, `-Resume`, alone or with
  `-Schedule`, `-Continue`, `-Directory`, `-Detach`, `-NoRemoteControl` and `-ShellWidthPercent`; its narration and
  refusals as section 7 of the PowerShell style guide has them. Built on its branch 2026-10-16 to 19, and tested on
  danoble-wd11-3: the store (phase 3), the background session and the psmux session (phase 4), and test plan rows 1
  to 3 and 10 to 12; the rest of its tests are its test scripts', under `tests/`.
- [x] Both scripts return the background session's short id, attached or detached (personal#273's plan, question 11):
  built on personal#273's branch, 2026-10-18; tested on Danoble-MBP-A and danoble-wd11-3, test plan rows 11 and 13.
- [x] `--resume` and `-Resume` take what `claude --resume` takes but its picker: a conversation's id, a background
  session's short id, a name, or a transcript's absolute path (personal#273's plan, question 12), 2026-10-19.
- [ ] The store's directory renamed `agent-schedule`: David-Noble-at-work/personal#278.
- [ ] Start-Claude and Start-Claude.ps1 moved to noblefactor-ops, with these documents and their test scripts: copied
  in NobleFactor/noblefactor-ops#312, where make and CI run the tests on Ubuntu, macOS and Windows, and removed from
  personal in David-Noble-at-work/personal#285.

[plan-259]: https://github.com/David-Noble-at-work/personal/blob/main/docs/plans/chore/259-start-claude-documents-claude.md
