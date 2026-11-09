---
title: "NobleFactor/.github holds the organization's issue model and its shared health files"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/431
status: active
created: 2026-11-08
updated: 2026-11-08
---

# Plan: NobleFactor/.github holds the organization's issue model and its shared health files

## Summary

Step 19 of issue tracking, iteration 1 (#346). NobleFactor/.github has existed, public, since 2026-11-03, holding the six
issue forms, the Triage workflow template and a quality gate. This plan finishes what #431 asks. NobleFactor's model
file moves there from beside the extension, and star reads it from there by ETag. The pull request template,
`CONTRIBUTING.md`, `SECURITY.md` and `SUPPORT.md` join the forms, and each form asks for the documents table rule 15
requires. It takes two pull requests, one at a time: NobleFactor/.github's first, since star cannot read a file that is
not there yet, then noblefactor-engprod's, which closes #431.

## The issue

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 19 | Task | [#431](https://github.com/NobleFactor/noblefactor-engprod/issues/431), NobleFactor/.github holds the organization's issue model and the shared health files every NobleFactor repository falls back on | NobleFactor/.github holds NobleFactor's model and star reads it from there; a repository without its own health files shows the organization's; section 6 names `.github` as each account's model's home |

## Current State

Read on 2026-11-08 from GitHub: NobleFactor/.github's tree on `main`, each public repository's community profile, and
its private vulnerability reporting setting.

| Component | Status | Notes |
| --- | --- | --- |
| NobleFactor/.github, public | ✅ | Created 2026-11-03; default branch `main`; quality gate: every YAML and JSON file parses |
| Six issue forms, each setting its issue type, with a required Area | ✅ | NobleFactor/.github#1 |
| Triage workflow template | ✅ | `workflow-templates/triage.yml`; #447 and #448 carry its open work |
| The forms' Plan and design documents field | ⚠️ | Optional and empty; rule 15 requires the table |
| NobleFactor's model file in NobleFactor/.github | ❌ | Still `com.noblefactor.ops.GitHub/model.yaml` beside the extension; section 6 says it moves with #431 |
| star reads the model from NobleFactor/.github | ❌ | `scheme.star` loads every `model*.yaml` beside the extension |
| Pull request template, `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md` | ❌ | Section 6, § One model per account, lists them as missing |
| Section 6 names `.github` as each account's model's home | ✅ | Its rulings do; the sentences saying the file "moves with #431" become past tense |
| Private vulnerability reporting | ❌ | Off on all eight public repositories |

Of NobleFactor's repositories, noblefactor-engprod and devlore.noblefactor.com have no `CONTRIBUTING.md` of their own;
devlore-cli, devlore-registry and docker-homebridge do. None has `SECURITY.md` or `SUPPORT.md`, and only
docker-homebridge has a pull request template. The organization's files apply to every repository that lacks its own.

## Decisions for review

The documents do not settle these. Each is a proposal for the owner to change at review.

1. **The file is `model.yaml` at the root of NobleFactor/.github,** exactly as pulled on 2026-11-08, digest intact.
2. **star reads it from GitHub by ETag, and keeps a copy.** `scheme.star` reads
   `repos/<account>/.github/contents/model.yaml` for the default account (`github.account`, NobleFactor), sending the
   copy's ETag. A 304 answers from the copy at
   `${XDG_CACHE_HOME:-$HOME/.cache}/devlore/star/gh/model/<account>.model.yaml`, and a 200 replaces it. When GitHub
   cannot be reached, star answers from the copy and says so; with no copy, it fails and names the repository.
   David-Noble-at-work's model stays beside the extension until #441, step 20, moves it; #441 also says how star finds
   each account.
3. **`pull` and `digest` need `--asset` for an account whose model is in its `.github` repository,** until #426, step
   21, makes a branch of that repository pull's default. Without it they refuse, naming the file to give. When the model
   is behind GitHub, the line `read_first` prints says the same.
4. **Each issue form's documents field is required and starts with the table:** `| Document | Link |`,
   `| --- | --- |`, `| Plan | Not yet opened |`. All six forms get the same change.
5. **`CONTRIBUTING.md` states the organization's terms, under each repository's own license.** It asks for a Developer
   Certificate of Origin sign-off and the AI disclosure on every pull request, not every commit, which the squash
   merge writes into the commit that lands, as #265 and rule 13 say. It keeps devlore-cli's rule that undisclosed AI
   use bans the contributor. #265 stays open: whether every repository also carries its own copy is its question, and
   devlore-cli's per-commit wording is its fix.
6. **The pull request template is the description rule 13 prescribes:** Summary, `Closes #`, Test plan, the AI
   disclosure, and the `Signed-off-by:` and `Assisted-by:` lines to fill in.
7. **`SECURITY.md` sends reports to GitHub's private vulnerability reporting,** the Report a vulnerability button on a
   repository's Security tab. No email address is published. The .github pull request's script turns the setting on
   for the eight public repositories. **`SUPPORT.md`** sends questions and problems to the repository's issues, through
   its forms.
8. **The .github worktree is made by hand.** `git open-branch` reads the issue from the clone's own repository, and
   #431 belongs to noblefactor-engprod. So the clone is `~/Workspace/NobleFactor/.github`; the worktree,
   `~/Workspace/NobleFactor/.github.431-dot-github` on `feature/431-dot-github`, is made with `git worktree add`; and
   its script is `~/Workspace/NobleFactor/.github.431-dot-github.bash`. `git close-branch` removes both.

## Requirements

### Requirement 1: NobleFactor/.github, in its own pull request

- `model.yaml` at the root: the extension's, as pulled.
- `CONTRIBUTING.md`, `SECURITY.md` and `SUPPORT.md` at the root; `.github/pull_request_template.md`.
- Each of `.github/ISSUE_TEMPLATE/{bug,epic,feature,scenario,schedule,task}.yml`: the documents field required, the
  table its starting value.
- `README.md` lists what the repository holds, the model among it.
- The quality gate passes; the pull request's description follows rule 13.
- Private vulnerability reporting on, for the eight public repositories, read back.

### Requirement 2: star reads NobleFactor's model from it

- `scheme.star` reads the default account's model from its `.github` repository (decision 2), and every other account's
  from beside the extension, as it does today.
- `model.star`: `default_asset` names no file beside the extension for an account whose model is in its `.github`
  repository; `read_first` compares GitHub with the model star read; `pull` and `digest` refuse without `--asset` for
  that account (decision 3).
- `model.yaml` leaves the extension, with `git rm`. writ leaves its deployed link pointing at nothing; the `-f` test in
  `scheme.star` already skips it, and the owner removes the link.

### Requirement 3: the documents

- Section 6: NobleFactor's model file is in NobleFactor/.github, moved with #431, and star reads it there by ETag; the
  pull request template, `CONTRIBUTING.md`, `SECURITY.md` and `SUPPORT.md` are there; David-Noble-at-work's come with
  #441.
- Section 4, where it says the file moves.
- agent-rules.md, rule 13: NobleFactor's pull request template exists; David-Noble-at-work's comes with #441.
- Every other document that places NobleFactor's model beside the extension, found with `grep`.

## Implementation Phases

### Phase 1: the plan

- [x] Written, committed on `feature/431-dot-github`, and reviewed with the owner: approved 2026-11-08

### Phase 2: NobleFactor/.github

- [ ] The clone and its worktree (decision 8)
- [ ] The files of Requirement 1; the quality gate's check passes locally
- [ ] Its pull request script written, shown and handed over; merged; private vulnerability reporting read back on

### Phase 3: the test, first

- [ ] Test-StarGitHub's new cases written, failing against the extension as it is

### Phase 4: star reads the model from NobleFactor/.github

- [ ] Requirement 2; every case passes; `make check` passes

### Phase 5: the documents

- [ ] Requirement 3

### Phase 6: proved on GitHub

- [ ] A new issue in noblefactor-engprod offers the six forms, each starting with the table, and links
      `CONTRIBUTING.md`; a new pull request there starts from the template
- [ ] `star github schedule report` reads NobleFactor's model from NobleFactor/.github, with no `model.yaml` in the
      deployed extension; a comment on #431 shows both

### Phase 7: merge

- [ ] The pull request script written, shown and handed over; it closes #431

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | A first read: no copy, and GitHub answers 200 | The model loads; the copy and its ETag are written |
| 2 | GitHub answers 304 | The model loads from the copy; nothing is written |
| 3 | GitHub cannot be reached, and there is a copy | The model loads from the copy, and a note says so |
| 4 | GitHub cannot be reached, and there is no copy | Fails, naming NobleFactor/.github |
| 5 | `star github model pull --account NobleFactor` without `--asset` | Refuses, naming the file to give |
| 6 | David-Noble-at-work's model | Read from beside the extension, as before |
| 7 | Every existing case | Passes unchanged |

## Files to Create/Modify

NobleFactor/.github:

| File | Action | Purpose |
| --- | --- | --- |
| `model.yaml` | Create | NobleFactor's model, from the extension |
| `CONTRIBUTING.md` | Create | Decision 5 |
| `SECURITY.md`, `SUPPORT.md` | Create | Decision 7 |
| `.github/pull_request_template.md` | Create | Decision 6 |
| `.github/ISSUE_TEMPLATE/*.yml` | Modify | Decision 4 |
| `README.md` | Modify | What the repository holds |

noblefactor-engprod, under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named
from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/431-dot-github.md` | Create | This plan |
| `commands/scheme.star` | Modify | Decision 2 |
| `commands/model.star`, `commands/github-model-pull.star`, `commands/github-model-digest.star` | Modify | Decision 3 |
| `extension.yaml` | Modify | The help for pull and digest |
| `model.yaml` | Remove | Moved to NobleFactor/.github |
| `tests/Test-StarGitHub` | Modify | The test plan |
| `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md`, `4-storage-and-reach.md` | Modify | Requirement 3 |
| `docs/guides/agent-rules.md` | Modify | Rule 13's note |

## Related Documents

- [Section 6, the asset and its sync](../../architecture/issue-data-model/6-the-asset-and-its-sync.md)
- [Section 4, storage and reach](../../architecture/issue-data-model/4-storage-and-reach.md)
- #426, step 21: pull writes to a branch of the account's `.github` repository
- #441, step 20: David-Noble-at-work/.github, the same for that account
- #437: push
- #265: every repository's `CONTRIBUTING.md`
- #453, step 35: the Scenario forms' fields
- #447 and #448: the Triage workflow

## Open Questions

None beyond the decisions for review.
