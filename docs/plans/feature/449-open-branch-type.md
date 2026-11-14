---
title: "git open-branch stops offering chore and takes the branch type from the issue's type"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/449
status: draft
created: 2026-11-13
updated: 2026-11-13
---

# Plan: git open-branch stops offering chore and takes the branch type from the issue's type

Step 38 of issue tracking, iteration 1 (#346). Two things are wrong with `git open-branch`. It still offers `chore`,
which ruleset 12515090 has refused since 2026-11-03, so a `chore/` branch it opens can't be pushed. And it picks the
branch type from labels that NobleFactor's issues stopped carrying on 2026-11-03, so every NobleFactor issue opens as
`feature/`, bugs included. One pull request from `feature/449-open-branch-type`.

## Rulings

- 2026-11-03: the `chore/` branch type leaves ruleset 12515090 and `git open-branch`; the plans already filed under
  `docs/plans/chore/` stay where they are.
- 2026-11-04: `git open-branch` takes the branch type from the issue's type: in an organization the issue type, and in
  a user account the type label, since there the label is the type.

## Current State

Read on 2026-11-13, at `6f1ebc3`:

| What | Where it stands |
| --- | --- |
| `Home/common/.local/bin/git-open-branch` | Reads the issue's title, state and labels in one `gh issue view`. Maps labels: `bug` to `fix`, `chore` to `chore`, `documentation` to `doc`, anything else to `feature`. Accepts `chore` in `-T` and names it in its error and its comment on the ruleset |
| Its man page and bash and zsh completions | Offer `chore` |
| `tests/Test-GitOpenBranch` | Its stand-in issue 12 is labeled `chore` and expects `chore/12-add-the-thing` |
| `gh` | 2.103.3; `gh issue view --json` offers `issueType` |
| An open bug to prove it on | Bug #531, which has the Bug type and no labels |
| The documents | `development-process.md` § Plans, the issue data model's index and section 5, and `github-branch-protection.md` say `git open-branch` still accepts `chore` |

## Requirements

1. **The type from the issue's type.** The one `gh issue view` also reads the issue type. With no `-T`, a Bug gets
   `fix`; an issue with the `documentation` label gets `doc`; every other issue gets `feature`. In a user account, where
   no issue has a type, the `bug` label stands for it. `-T` still overrides.
2. **No `chore`.** The script refuses `-T chore` before anything is made, and neither its comment, its man page nor its
   completions offer it. The types are doc, feature, fix, hotfix, refactor and release.
3. **The documents** say `git open-branch` takes the type from the issue's type and offers no `chore`, where they say
   it still accepts `chore`.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `tests/Test-GitOpenBranch`: the stand-in issue 12 has the Bug type | `fix/12-add-the-thing`, in each case that names the branch |
| 2 | The stand-in issue in a user account: no type, the `bug` label | `fix/12-add-the-thing` |
| 3 | The stand-in issue with the `documentation` label and no Bug type | `doc/12-add-the-thing` |
| 4 | `-T chore` | Refused, naming the six types, and no branch made |
| 5 | `make check` | Passes |
| 6 | Live, after the merge: `git open-branch 531 --dry-run`, and `git open-branch 531 -T chore --dry-run` | `fix/531-…`; refused |

## Implementation Phases

### Phase 1: the plan

- [ ] Committed on `feature/449-open-branch-type` by the worktree's first script, which also sets step 38 In progress
      with the branch linked; reviewed with the owner

### Phase 2: the work and the merge

- [ ] The script, its man page, its completions, its test and the documents; `make check`; the pull request merged,
      closing #449 with the live cases as its evidence; step 38 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `Home/common/.local/bin/git-open-branch` | Modify |
| `Home/common/.local/share/man/man1/git-open-branch.1` | Modify |
| `Home/common/.local/share/bash-completion/completions/git-open-branch` | Modify |
| `Home/common/.local/share/zsh/site-functions/_git-open-branch` | Modify |
| `tests/Test-GitOpenBranch` | Modify |
| `docs/guides/development-process.md`, `docs/github-branch-protection.md`, `docs/architecture/issue-data-model/index.md` and section 5 | Modify |
| `docs/plans/feature/449-open-branch-type.md` | Create |
