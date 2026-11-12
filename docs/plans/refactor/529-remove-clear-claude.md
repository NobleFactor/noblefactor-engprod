---
title: "Clear-Claude is removed"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/529
status: complete
created: 2026-11-12
updated: 2026-11-12
---

# Plan: Clear-Claude is removed

Step 30 of issue tracking, iteration 1 (#346). Ruled 2026-11-12, on the owner's word: Clear-Claude goes now, the
agentic engineering environment (Epic #514) leaving it little point; Start-Claude stays for a while. One pull request
from `refactor/529-remove-clear-claude`, resolving #529.

## Requirements

1. Clear-Claude's command, man page, bash and zsh completions and `tests/Test-ClearClaude` removed with `git rm`.
2. The agent-schedule design's index, `1-session-model.md`, `2-command-line.md` and their status pages say it was
   removed, and why; `1-session-model.md` keeps its design as history, and says so. `issue-standards.md`'s example of
   #445 reads in the past. #414's draft plan is abandoned.
3. After the merge, writ deploys, and the links left where Clear-Claude was deployed are removed (agent-rules.md,
   rule 5).

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `make check` | Passes, `tests/Test-ClearClaude` gone with the command |
| 2 | After the deploy | `command -v Clear-Claude` finds nothing, and no link is left dangling where it was |

## Implementation Phases

- [x] The plan, the removal and the documents, in one commit, the owner having ordered the removal done at once
- [x] The pull request script: merge, deploy, the dangling links removed, #529 closed with its evidence, step 30 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `Home/common.Unix/.local/bin/Clear-Claude` | Remove |
| `Home/common.Unix/.local/share/man/man1/Clear-Claude.1` | Remove |
| `Home/common.Unix/.local/share/bash-completion/completions/Clear-Claude` | Remove |
| `Home/common.Unix/.local/share/zsh/site-functions/_Clear-Claude` | Remove |
| `tests/Test-ClearClaude` | Remove |
| `docs/architecture/agent-schedule/` index, `1-session-model.md`, `2-command-line.md` and their status pages | Modify |
| `docs/issue-standards.md`, `docs/plans/fix/414-clear-claude-can-remove-a.md` | Modify |
