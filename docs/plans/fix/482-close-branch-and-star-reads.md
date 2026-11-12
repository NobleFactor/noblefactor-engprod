---
title: "git close-branch deletes only what is verified merged; star reads whole accounts, in any case"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/482
status: active
created: 2026-11-11
updated: 2026-11-11
---

# Plan: git close-branch deletes only what is verified merged; star reads whole accounts, in any case

Steps 23 to 26 of issue tracking, iteration 1 (#346): four bugs a Codex review of develop found on 2026-11-11, fixed
together, test first. `git close-branch` deletes a branch that exists only on origin without checking that it merged,
and deletes a local commit made after a squash merge once origin's branch is gone. The `com.noblefactor.ops.GitHub`
star extension reads each GitHub connection one page deep and never looks for a next one, and fails when an account is
named in another case than GitHub's. After this work `git close-branch` deletes only what GitHub and the target's
history show merged, unless `--force` says otherwise; every read of a model either reads the account whole or stops,
naming what it could not read; and an account is found however it is spelled.

One pull request from `fix/482-close-branch-and-star-reads`, resolving all four.

## Issues

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 23 | Bug | [#482](https://github.com/NobleFactor/noblefactor-engprod/issues/482), git close-branch deletes a remote-only branch without checking that it merged | Its evidence of completion |
| 24 | Bug | [#483](https://github.com/NobleFactor/noblefactor-engprod/issues/483), git close-branch deletes local commits made after a squash merge once origin's branch is gone | Its evidence of completion |
| 25 | Bug | [#484](https://github.com/NobleFactor/noblefactor-engprod/issues/484), star's model reads stop at the first page of each connection | Its evidence of completion |
| 26 | Bug | [#485](https://github.com/NobleFactor/noblefactor-engprod/issues/485), star's report and sweep fail when an account is named in a different case than GitHub's | Its evidence of completion |

## Rulings

- 2026-11-11, the owner: each of the four logged as a bug and scheduled as steps 23 to 26, fixed on one branch, test
  first, once #437's pull request had merged, so that #484's check covers the reads #437 added. #437 merged that day
  as #486.
- Each issue's Solution, as filed: a remote-only branch is deleted only when its pull request is verified merged
  (#482); before forcing, the local tip is compared with the merged pull request's head (#483); each read asks whether
  there is a next page and fails, naming the connection and the account, rather than return a partial model (#484);
  each model is keyed by the account's login and looked up the same way (#485).

## Current State

Read on 2026-11-11 from develop at `32d773e`:

| Where | What |
| --- | --- |
| `git-close-branch`, `survey_branch` | A branch with no local ref returns with no refusal whenever origin has it; `remove_branch` then runs `git push origin --delete`. Neither of `delete_flag`'s two signals, GitHub reporting the pull request merged and the target carrying its squash commit, is asked for |
| `git-close-branch`, `delete_flag` | Once GitHub reports the pull request merged, it compares the local tip with origin's only while `refs/remotes/origin/<branch>` exists; with origin's branch gone it answers `-D` |
| `tests/Test-GitCloseBranch` | Its stand-in `gh` answers every pull request merged, number 1, and nothing else; no case has a remote-only branch or a commit after the squash merge |
| The extension's `commands/model.star` | 16 GraphQL connections read with a fixed `first:` and no `pageInfo`: an account's projects (50); each project's teams (20), repositories (50), fields (50) and views (25), and each view's fields (50), grouping (10), vertical grouping (10) and sort (10); an organization's issue fields (50), issue types (50), teams (100) and each team's repositories (100); a user's repositories (100), and each one's topics (20) and labels (100). And each repository's labels over REST, 100 a page, one page read |
| The extension's `commands/apply.star` | A project just made has its built-in workflows read 50 at a time, one page |
| The extension's `commands/scheme.star` | `models_for` keys each model by the account as the caller spelled it; `model_for` looks one up by a repository's owner as GitHub spells it, and fails, "no model was read for NobleFactor" |
| `tests/Test-StarGitHub` | No fixture has a second page; no case names an account in another case |

## Requirements

### Requirement 1: a remote-only branch is deleted only when it is verified merged (#482)

`survey_branch`, for a branch with no local ref that origin has, asks GitHub for its pull request and requires both of
`delete_flag`'s signals: GitHub reports it `MERGED`, and the target's history carries its squash commit
(`landed_on_target`). The query is shared with `delete_flag` rather than written twice. Otherwise the close is refused,
naming why: no pull request, one that is not merged, one merged whose squash commit the target lacks, or `gh` unable to
answer, since nothing else can vouch for a branch with no local copy. The hint is "Pass --force to override.", and
`--force` deletes it, its cost "the branch exists only on origin, and nothing showed it merged".

### Requirement 2: a commit made after the squash merge is not deleted unasked (#483)

`delete_flag`, once GitHub reports the pull request merged and the target carries its squash commit, reads the pull
request's head, `headRefOid`, and returns 1, "commits exist only locally", when the local branch holds a commit the
head lacks, whether or not origin still has the branch. When the head is not in the local repository, a local tip that
differs from it is refused the same way. The comparison with origin's tip stays. Under `--force` the cost names the
commits made after the pull request's head.

### Requirement 3: no model read returns part of an account (#484)

Each GraphQL connection listed under Current State also selects `pageInfo { hasNextPage }`, and a next page fails the
read, naming the account and the connection, for example "NobleFactor has more than 50 projects, and star reads one
page of them (#484)". `get`, `diff`, `apply`, `backup` and `restore` all read before they write, so each stops before
writing anything. The REST read of a repository's labels fails the same way when its `Link` header names a next page,
and so does `apply`'s read of a new project's built-in workflows.

### Requirement 4: an account is found in any case (#485)

`models_for` keys each model by its account lowercased, and `model_of` looks an account up lowercased, since GitHub's
logins ignore case. `noblefactor/alpha` and `NobleFactor/alpha` both find NobleFactor's model, read once.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `git close-branch` on a remote-only branch whose pull request is merged, its squash commit on the target | Closed: the branch deleted on origin |
| 2 | A remote-only branch whose pull request is open | Refused, naming it; the branch kept on origin; "Pass --force to override." |
| 3 | Case 2 with `--force` | Deleted, its cost named |
| 4 | A remote-only branch with no pull request, and one whose `gh` fails | Each refused; the branch kept |
| 5 | A local commit made after the squash merge, origin's branch gone | Refused, "commits exist only locally"; every trace kept |
| 6 | Case 5 with `--force` | Closed, the cost naming the commit |
| 7 | The local tip at the pull request's head, origin's branch gone | Closed |
| 8 | Every existing case of `tests/Test-GitCloseBranch` | Passes, its stand-in's answers per case: the state, the number and the head |
| 9 | `get`, `diff` and `apply` of an account whose projects have a second page | Each fails, naming the projects and the account; nothing written |
| 10 | A project's fields, and an organization's teams, each with a second page | Each fails, naming the connection |
| 11 | A repository's labels over REST with a next page | Fails, naming the repository's labels |
| 12 | The report and the sweep given `noblefactor/alpha` | NobleFactor's model read once; its issues placed as for `NobleFactor/alpha` |
| 13 | Every existing case of `tests/Test-StarGitHub` | Passes |

Each case that refuses, or names what `--force` costs, fails against develop at `32d773e` before its fix, as each
issue's evidence asks: cases 2 to 6, and 9 to 12. Cases 1 and 7 close a branch, as develop already does, and pass on
both; they hold the fix to closing what it should.

## Implementation Phases

### Phase 1: the plan

- [x] Written and committed on `fix/482-close-branch-and-star-reads` by the worktree's first script, which opens the
      branch with `git open-branch 482 -T fix`, since the kind labels it reads were retired on 2026-11-03, pushes it,
      and links it in the Worktree column of steps 23 to 26, each set In progress and read back (agent-rules.md, rule
      19); reviewed with the owner. Run by the owner on 2026-11-11: the plan at `27e0162`, the four rows In progress
      and linked. The owner set aside rewriting `git close-branch` as a star command and gave the go the same day

### Phase 2: git close-branch, test first (#482, #483)

- [x] Cases 1 to 7, written first, with a stand-in `gh` that answers each case's pull request from a file of its own:
      against develop at `32d773e` the six that refuse or name a cost failed, the branch deleted every time, and cases
      1 and 7 passed. Then Requirements 1 and 2: `pull_request` asks GitHub once for the state, number and head;
      `delete_flag` refuses a local commit the head lacks; `survey_branch` refuses a branch on origin alone that
      nothing shows merged; `git-close-branch.1` says both. 24 of 24 cases pass; `make check` passes

### Phase 3: star, test first (#484, #485)

- [ ] Cases 9 to 12, failing against develop; then Requirements 3 and 4; cases 9 to 13 pass; `make check` passes

### Phase 4: merge

- [ ] The pull request script written, shown and handed over. It opens the pull request, closing #482, #483, #484 and
      #485, waits for CI, merges, comments on each issue with its evidence of completion, sets each row Closed with the
      pull request as its Worktree, and runs `git close-branch`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/fix/482-close-branch-and-star-reads.md` | Create | This plan |
| `Home/common/.local/bin/git-close-branch` | Modify | Requirements 1 and 2 |
| `Home/common/.local/share/man/man1/git-close-branch.1` | Modify | Requirements 1 and 2 |
| `tests/Test-GitCloseBranch` | Modify | Cases 1 to 8 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/model.star` | Modify | Requirement 3 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/apply.star` | Modify | Requirement 3, the built-in workflows' read |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | Requirement 4 |
| `tests/Test-StarGitHub` | Modify | Cases 9 to 13 |

## Related Documents

- [#437's plan](../feature/437-model-diff-apply-restore.md): the reads #484 covers, and the stand-in its cases extend
- [agent-rules.md](../../guides/agent-rules.md), rule 19: the records the worktree's scripts make
- [pr-script-template.md](../../guides/pr-script-template.md): the merge's script

## Open Questions

None. Each issue's Solution settles its fix, and the owner ruled the order on 2026-11-11.
