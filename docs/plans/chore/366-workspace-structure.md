---
title: "Clones, worktrees and pull-request scripts live under ~/Workspace/<org>, the script is named for its worktree, and both go when the pull request merges"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/366
status: active
created: 2026-10-21
updated: 2026-10-21
---

# Plan: the workspace structure, the script's name, and removal

## Summary

Three rulings of 2026-10-21, taken while a pull-request script was found at `~/.local/share/devlore/writ/repos/go-personal`,
a worktree seven months past its merge at `~/Workspace/NobleFactor/devlore-cli.resource-management`, and a second clone
of personal at `~/Workspace/Personal` carrying work origin lacked. The structure: every clone, worktree and script under
`~/Workspace/<GitHub organization>/`, the layer clones symlinked from writ's home. The name: the script is
`<worktree>.bash` or `.ps1` beside its worktree, `go-<clone>` retiring. Removal: worktree and script go when the pull
request merges, and a lingering one is named by whoever notices it. And, from the same day, the order in which a clone
is retired. Two issues, one plan, one pull request: the two commands, their man pages, the three guides, the tests.

## Issue 366

[Clones, worktrees and pull-request scripts live under ~/Workspace/<org>, the script is named for its worktree, and both
go the moment the pull request merges](https://github.com/NobleFactor/noblefactor-ops/issues/366). A chore under
Epic [#142](https://github.com/NobleFactor/noblefactor-ops/issues/142), Process.

## Issue 367

[A clone is retired by saving what origin lacks, bundling every ref, and checking what points at it; rm -rf is the last
step](https://github.com/NobleFactor/noblefactor-ops/issues/367). A chore under the same epic.

## Goals

1. **One place.** `ls ~/Workspace/<org>` is the whole picture of an organization's work in flight: clones, worktrees,
   scripts, and nothing else.
2. **The commands enforce it.** `git-open-branch` places the worktree there from any directory; `git-close-branch`
   removes the worktree's script with the worktree.
3. **The guides state it**, with the removal rule and the retirement order, dated in the owner's words.
4. **Nothing lingers on this machine** when the pull request merges: the duplicate clones are retired behind symlinks by
   #367's order, and the stray scripts are gone.

## Current State

| Where | Says or does today |
| --- | --- |
| `git-open-branch`, line 184 | `worktree="${main_worktree}.${issue}-${name}"`: a sibling of the main worktree, wherever that is; for a layer clone under `~/.local/share/devlore/writ/repos/` that is the wrong place |
| `git-close-branch` | removes the worktree, deletes the branch remote then local, syncs the main worktree to the target; knows nothing of the script |
| `pr-script-template.md` | the script is `go-<repo>`, "one level above the repository it acts on"; a table of three paths; never the bare `go`; the Windows section's `go-<repo>.ps1` |
| `development-process.md` § The unit of work | "`git-open-branch` names each one `<repo>.<issue>-<name>` and a directory listing is therefore the whole picture"; nothing on where, on scripts, on removal, on retiring a clone |
| `agent-rules.md` | rule 5, a layer change is finished when converged; rule 8, a blocked branch is nuked, with "diff anything uncommitted" before deleting; nothing on lingering worktrees or scripts past a merge |
| `~/.claude/CLAUDE.md` (personal) | the PR Process section and its table; personal#297, its own pull request |
| #335, "PR scripts named for their branch" | open; rules the same name |
| Media-Server | `~/Workspace/Personal` retired 2026-10-21 by #367's order; `~/Workspace/NobleFactor/{noblefactor-ops,devlore-cli}` are still second clones with the live worktrees hanging off them; `~/Workspace/NobleFactor/go` is a stray script |
| Tests | `tests/Test-GitCloseBranch` exists; no test for `git-open-branch` |

## Requirements

### Requirement 1: `git-open-branch` places the worktree under the organization

The worktree path becomes `~/Workspace/<org>/<clone>.<issue>-<name>`, where `<org>` is the owner in the origin
URL (`github.com[:/]<org>/<clone>`) and `<clone>` is the repository's name there, so the path is the same whether the
command ran in the layer clone, the Workspace symlink to it, or a worktree. When origin is not on GitHub the command
falls back to today's sibling placement and says so. `~/Workspace` is created when absent. The dry run prints the new
path. The man page's NAMING section and the completion files say the same. A test under `tests/` proves the path from a
clone whose origin is a GitHub URL, both forms, ssh and https.

### Requirement 2: `git-close-branch` removes the script with the worktree

Beside the worktree it removes, a file named `<worktree>.bash` or `<worktree>.ps1` is removed too, and the report names
it. A script that is not there is not an error. The record it prints gains the script's path. `tests/Test-GitCloseBranch`
gains the case.

### Requirement 3: `pr-script-template.md`

The script is `~/Workspace/<org>/<worktree>.bash` on Unix and `.ps1` on Windows, beside the worktree it serves; the
"one level above" rule, the `go-<repo>` name and the three-row table go; the bare-`go` warning becomes the general one,
that a script is read before it is overwritten and its `cd` says which worktree it serves; rule 6 says close-branch removes
the script; the Windows section follows in both the prose and the example's paths.

### Requirement 4: `development-process.md` § The unit of work

Gains, after the worktree paragraph: **the structure** (the three kinds under `~/Workspace/<org>/`, the layer clones
symlinked from writ's home, one clone per layer and never a branch checked out in it); **removal** (worktree and script go
when the pull request merges or the branch is abandoned; one that lingers is a defect named by whoever notices it); and
**retiring a clone** (#367's four steps: save what origin lacks as patches and every ref as a bundle; carry what is live;
check what points at it; then remove, saying what was saved where). Each dated, in the owner's words.

### Requirement 5: `agent-rules.md`

Two things. A new rule, the next number after those in flight, "a worktree and its script go with the merge", with the
breakage of 2026-10-21: the resource-management worktree seven months past its merge, the bare `go`, the script under
writ's repos directory. And rule 8's compliance line extended from "diff anything uncommitted against wherever it came
from" to #367's patches and bundle, with 2026-10-21 as the day a retired clone was found holding sixteen stranded refs.

### Requirement 6: the record and the machine

#335 closes into #366 with a comment. On Media-Server, after the merge and the deploy: the duplicate clones
`~/Workspace/NobleFactor/noblefactor-ops` and `devlore-cli` are retired by #367's order, which means their live
worktrees, including this plan's own, are re-pointed to the layer clones (`git worktree repair` after the main worktree
moves, or closed and reopened), symlinks take the clones' places, and `~/Workspace/NobleFactor/go` is removed.

## Implementation Phases

### Phase 1: the plan lands

- [x] Reviewed with the owner, status `approved`, committed alone on `chore/366-workspace-structure` -- 2026-10-21
- [x] #366's and #367's documents tables carry this plan's link on `develop`

### Phase 2: the commands

- [x] `git-open-branch` places the worktree under `~/Workspace/<org>/`; its man page follows, and the completions
      name no path, so they are unchanged; `tests/Test-GitOpenBranch` proves the path from ssh, https and `ssh://`
      origins, the fallback off GitHub, and the dry run of each (Requirement 1) -- 2026-10-21
- [x] `git-close-branch` removes `<worktree>.bash` and `.ps1` with the worktree, last of the traces; its man page
      follows; `tests/Test-GitCloseBranch` gains four cases, one script, both, none, and the dry run
      (Requirement 2) -- 2026-10-21

### Phase 3: the guides

- [x] `pr-script-template.md` (Requirement 3) -- 2026-10-21
- [x] `development-process.md` (Requirement 4) -- 2026-10-21
- [x] `agent-rules.md`: rule 16, and rule 8's compliance (Requirement 5) -- 2026-10-21

### Phase 4: the pull request

- [x] `make check` passes in the worktree, the whole gate, and `make test` runs the two command tests -- 2026-10-21,
      after `brew install buildifier`, which the starlark gate needs and Media-Server lacked; the script runs it
      again as its pre-flight
- [x] The description says AI assisted and ends with `Signed-off-by:` and `Assisted-by: Claude Code`; the script is
      `~/Workspace/NobleFactor/noblefactor-ops.366-workspace-structure.bash`, the first named by the rule it lands
      -- 2026-10-21
- [x] #335 closed into #366 -- 2026-10-21
- [x] Status `active` in the last commit, with Phase 5 named as the reason -- 2026-10-21

### Phase 5: after the merge (rule 5)

- [ ] `writ deploy`; `readlink -f ~/.local/bin/git-open-branch` resolves into the base layer at the merge
- [ ] The duplicate clones on Media-Server retired by #367's order behind symlinks; the worktrees re-pointed; the bare
      `go` gone; `ls ~/Workspace/NobleFactor ~/Workspace/David-Noble-at-work` shows symlinked clones, live worktrees and
      their scripts, nothing else
- [ ] This worktree removed by `git close-branch`, and the script by its own last line, because the close-branch
      the script runs is the one deployed before this merge, which knows nothing of scripts; the next pull
      request's is the first removal under the rule
- [ ] Status `complete`; #366 and #367 closed

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/366-workspace-structure.md` | Create | This plan |
| `Home/common/.local/bin/git-open-branch` | Modify | The worktree's path under the organization |
| `Home/common/.local/share/man/man1/git-open-branch.1` | Modify | NAMING |
| `Home/common/.local/share/bash-completion/completions/git-open-branch`, `zsh/site-functions/_git-open-branch` | Modify | if they describe the path |
| `Home/common/.local/bin/git-close-branch` | Modify | Removes the script with the worktree |
| `Home/common/.local/share/man/man1/git-close-branch.1` | Modify | Says so |
| `tests/Test-GitOpenBranch` | Create | The path, from ssh and https origins |
| `tests/Test-GitCloseBranch` | Modify | The script's removal |
| `docs/guides/pr-script-template.md` | Modify | Requirement 3 |
| `docs/guides/development-process.md` | Modify | Requirement 4 |
| `docs/guides/agent-rules.md` | Modify | Requirement 5 |

## Related Documents

- [pr-script-template.md](../../guides/pr-script-template.md), [development-process.md](../../guides/development-process.md),
  [agent-rules.md](../../guides/agent-rules.md): the three guides
- [#335](https://github.com/NobleFactor/noblefactor-ops/issues/335), the same name ruled earlier
- [#306](https://github.com/NobleFactor/noblefactor-ops/issues/306) and its plan, where close-branch learned to sync the
  main worktree; this plan's close-branch change sits beside that one
- David-Noble-at-work/personal#297, CLAUDE.md's PR Process section, its own pull request after this one merges

## Open Questions

- **Whether the Windows script name needs `.ps1` and the Unix one `.bash`**, as ruled, or both go by the worktree's
  name with the extension the platform runs; ruled as `.bash` and `.ps1`, so a listing says which shell reads it.
- **The fallback when origin is not GitHub**: today's sibling placement, or refusal. The plan takes the fallback, since
  the command must still work on a clone with no origin.
- **`git worktree repair` versus close-and-reopen** for the two live worktrees when their main clones become symlinks
  (Phase 5). Decided when it is done, and said in the pull request.
