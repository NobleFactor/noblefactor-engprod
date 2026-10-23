---
title: "noblefactor-ops becomes noblefactor-engprod: GitHub once, then every machine, then the text"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/304
status: active
created: 2026-10-22
updated: 2026-10-22
---

# Plan: noblefactor-ops becomes noblefactor-engprod

## Summary

The repository is renamed on GitHub once, and GitHub's redirects keep every clone, link and `owner/repo#n` reference
resolving, so the rename itself breaks nothing. What then has to follow the name is local to each machine, writ's
registration of the base layer, the deployed links, the Workspace symlink, any open worktree, and Start-Claude's
store, and one script does all of it on each of the four machines. Last comes the text that says the old name, which
redirects cover and which is swept repository by repository. The owner, 2026-10-22: "bump up the priority of the
issue for renaming noblefactor-ops as noblefactor-engprod. we might do that before we go much further. it will be one
less thing to worry about at the end." And: "We'll need the github part. we do that once. we then need a script to
update all upstreams locally on danoble-{mbp-a,ud24-1,wd11-3} and media-server."

## Schedule

Lane 13 of Schedule: issue tracking, iteration 1, NobleFactor/noblefactor-ops#346, added by the owner's amendment of
2026-10-22 and worked before lane 4. Iteration 1 of #303's sweep names it as its first item after the rulings.

## Goals

1. **One GitHub rename**, after which nothing that reads the old name fails.
2. **Every machine converged** by one script run there: the layer re-registered, every deployed link resolving into
   the renamed clone, no link dangling, the store keyed by the new name, and open worktrees still attached.
3. **The text follows**, where it is live: the guides, the instructions, CI, the scripts. History stays as written.

## Current State

| What carries the name | Where | Found 2026-10-22 |
| --- | --- | --- |
| The repository and its remote | GitHub; `origin` on every clone | `git@github.com:NobleFactor/noblefactor-ops.git` |
| writ's base-layer registration | `writ repo list`: root `~/.local/share/devlore/writ/repos/noblefactor-ops`, source the old URL | the project writ narrates is named for the clone's directory |
| The deployed links | 278 on Media-Server, every one resolving into that root | `writ reconcile`, all linked |
| The Workspace symlink | `~/Workspace/NobleFactor/noblefactor-ops` to the root | #366's structure |
| Open worktrees | `noblefactor-ops.303-issue-data-model`, `noblefactor-ops.304-rename-engprod`, each with `.git` pointing into the root | `git worktree list` |
| Start-Claude's store | `~/.local/state/agent-schedule/NobleFactor/noblefactor-ops/<n>` and locks | keyed by the repository's name |
| personal's layer directories | `Home/noblefactor-ops`, `.Unix`, `.Darwin`, `.Linux`: the context project named for the base repository | four directories |
| personal's CI | `.github/workflows/quality-gate.yaml` checks out the base layer by name | one reference, and two in comments |
| Text | noblefactor-ops 95 files, 355 lines, 82 of the files under docs; devlore-cli 106 files, 432 lines; personal 46 files, 382 lines; the owner's CLAUDE.md among them | `git grep` |
| The machines | Media-Server (this one), danoble-ud24-1, danoble-wd11-3 (Windows), Danoble-MBP-A | the first three answered ssh on 2026-10-22; the fourth timed out |

## Requirements

### Requirement 1: the GitHub rename, once

`gh repo rename noblefactor-engprod --repo NobleFactor/noblefactor-ops`, then `gh repo view NobleFactor/noblefactor-engprod`
and a fetch through the old URL to show the redirect holds. The owner runs it or grants the one run.

### Requirement 2: one script per platform, run once on each machine

`scripts/Rename-BaseRepository` in bash and `scripts/Rename-BaseRepository.ps1` in PowerShell, repository tools under
`scripts/` beside the setup scripts, which the process exempts from `Declare-BashScript`. Each reads the base layer's
root from `writ repo list` rather than assuming a path, refuses a dirty root, takes `--dry-run`, and does, in order:

1. Renames the root directory to `noblefactor-engprod`, so writ's project name follows. Verified 2026-10-22 in
   devlore-cli's `cmd/writ/writ/selection.go`: the implicit projects are `common` plus one per configured layer
   repository, "named for the repository: the registration's root directory", so the project is named from the
   directory, not from the registration, and the rename of the directory is what renames the project.
2. `git remote set-url origin git@github.com:NobleFactor/noblefactor-engprod.git`.
3. `git worktree repair` for every worktree of the clone, so their `.git` files point into the renamed root. A
   worktree keeps its old clone name until `git close-branch` takes it, which the structure tolerates for a branch
   already open.
4. `writ repo set base <renamed root>`, which re-points the registration and records what it finds.
5. The Workspace symlink: the new name made, the old removed.
6. Start-Claude's store: the repository's directory renamed, locks included.
7. `writ deploy`, then rule 5's checks: a deployed link resolves into the renamed root, no link dangles, `writ
   reconcile` reports every entry linked. The script exits non-zero if any check fails.

### Requirement 3: personal follows

Its four layer directories renamed with `git mv`, and the CI reference, in one personal pull request. **The window:**
writ matches a context project to the base repository by name, so between personal's merge and the machine's run the
four directories match nothing, and between the clone's rename and personal's merge they would not match either.
The order below closes it to one deploy on each machine: personal merges first, and each machine runs the script,
which pulls personal and deploys, straight after.

### Requirement 4: the text

Live references change; history does not. Live: the guides and the owner's CLAUDE.md, CI, scripts and completions,
the layer's man pages, the PR script template, writ's and star's configuration that name the repository. History: a
plan's or an issue's citation of `NobleFactor/noblefactor-ops#n`, which redirects and records what was true when
written. One pull request per repository, the base layer first.

## Implementation Phases

### Phase 1: the plan and the scripts

- [x] This plan reviewed with the owner, status `approved` -- 2026-10-22, "plan approved. go"
- [x] Both scripts written and proven with `--dry-run` on Media-Server, the bash one on danoble-ud24-1 and the PowerShell
      one on danoble-wd11-3 over ssh -- 2026-10-22; both pass the repository's gates
- [x] Pull request 1, documents and scripts only, opened 2026-10-22 by this worktree's script; the status is `active`
      because Phases 2 to 5 run after the merge, and the scripts reach every machine by writ as each pulls

### Phase 2: personal

- [ ] The four layer directories renamed and the CI reference changed, pull request 2 in personal, merged

### Phase 3: GitHub, once

- [ ] `gh repo rename`, by the owner or under one grant; the redirect shown to hold

### Phase 4: each machine

Each machine gets the scripts by pulling develop into its clone, not by writ: `scripts/` is not deployed. The
corrected sequence is pull, then the script.

- [x] Media-Server, run by the owner, every check passing -- 2026-10-22
- [x] danoble-ud24-1 over ssh; `writ deploy` refused personal's uncommitted inventory and a script tweak, which the
      owner keeps, so the owner finished it with `writ deploy --allow-dirty`; checks passed -- 2026-10-22
- [x] danoble-wd11-3, by the owner from an interactive shell: over ssh every `git` fetch there hangs in Windows
      OpenSSH's `ssh.exe` when its stdin is a pipe with no console, which is how git runs it; a finding of its own.
      Deploy finished with `--allow-dirty`; 71 links, none unlinked -- 2026-10-22
- [x] Danoble-MBP-A, where the clone lives under `~/Workspace/NobleFactor` itself: the script as merged would have
      linked the renamed directory onto itself, so a patched copy ran, and the fix lands in Phase 5's commit; deploy
      finished with `--allow-dirty` against the team layer's work in progress; checks passed -- 2026-10-22
- [x] The open worktrees attached and clean afterwards, lane 3's here and #260's and #320's on Danoble-MBP-A; no
      session stopped -- 2026-10-22

Found on the way and not this plan's: writ narrates `noblefactor-ops (recorded)` after the rename, a remembered
project name no layer carries and no flag forgets; `star gh issues report --schedule` with the old key no longer
matches the repository name writ reports, which Phase 5 fixes in the extension; a stale second clone at
`C:\Users\david-noble\Workspace\NobleFactor\noblefactor-ops` on danoble-wd11-3 and the retired `go-*` scripts on
danoble-ud24-1, named for #367's order.

### Phase 5: the text

- [x] noblefactor-engprod's live references, pull request 3 -- 2026-10-22: the README, NOTICE, the guides, the
      standard, the branch-protection document, the skill, Start-Claude's examples and Test-OnHosts' state directory;
      issue citations and issue links left as written, since they redirect and record what was true. The star
      extension gains `canonical_repo`: the old name reads as the new wherever an owner/repo is parsed, markers,
      lane and beat tables, `--repo` and `--schedule`, so the sessions named by the old key keep working; proven
      against the live repositories through a private copy of the extension
- [ ] devlore-cli's live references, pull request 4
- [ ] personal's live references and the owner's CLAUDE.md, pull request 5
- [ ] Status `complete`; #304 closed

## Migration Path

Phases 2 to 4 are the migration and run in that order on one day, each machine converged before the next so that a
session on it sees one deploy. A session running on a machine during its run sees its deployed links move under it
and nothing else; the five sessions the owner runs are not stopped.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/304-rename-engprod.md` | Create | this plan |
| `scripts/Rename-BaseRepository` | Create | the per-machine script, bash |
| `scripts/Rename-BaseRepository.ps1` | Create | the per-machine script, PowerShell |
| personal: `Home/noblefactor-ops*` | Rename | the context project follows the base repository's name |
| personal: `.github/workflows/quality-gate.yaml` | Modify | checks out the base layer by its new name |
| the live references in three repositories | Modify | Requirement 4 |

## Related Documents

- NobleFactor/noblefactor-ops#304, this issue, under #333 Rollout of Epic #330 Issue tracking
- [development-process.md § The unit of work](../../guides/development-process.md) and #366: the structure the
  symlink and the worktrees follow
- [agent-rules.md](../../guides/agent-rules.md) rule 5: a layer change is finished when the machine is converged
- [docs/plans/chore/303-issue-data-model.md](303-issue-data-model.md), iteration 1, which puts this first

## Open Questions

1. Whether the `Ops:` label prefix and `Epic:Ops:Process` follow the name. Answered by the sweep's rulings of
   2026-10-22: the labels retire with the old scheme, and #142 becomes the triage epic, so neither is renamed here.
2. Whether devlore-cli's 432 lines are swept at all, given that nearly all are citations in plans and issues that
   redirect. Proposed: only its live references, a handful, in pull request 4.
3. Whether the scripts stay after the rename as the general "a layer's repository was renamed" tool, or go. Proposed:
   they stay under `scripts/` until writ grows a verb for it, filed then.
