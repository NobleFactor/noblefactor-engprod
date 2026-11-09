---
title: "David-Noble-at-work/.github holds that account's issue model, its health files and its Triage workflow"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/441
status: active
created: 2026-11-09
updated: 2026-11-09
---

# Plan: David-Noble-at-work/.github holds that account's issue model, its health files and its Triage workflow

## Summary

Step 20 of issue tracking, iteration 1 (#346). #441 stands in on NobleFactor's schedule for
David-Noble-at-work/personal#311, the user account's counterpart of #431, since no link crosses accounts. It does for
David-Noble-at-work/.github what #431 did for NobleFactor/.github. The account's model file moves there from beside the
extension, and star reads it from there. The health files join the issue forms, and the forms ask for the documents
table. personal#311 adds the Triage workflow: David-Noble-at-work/.github gets its own, with a token of its own, and
the account's template gains the Severity step ruled on 2026-11-04. Three pull requests, one at a time:
David-Noble-at-work/.github's first; then personal's, bringing its copy of the workflow to the template; then
noblefactor-engprod's, which closes #441 and personal#311.

## The issue

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 20 | Task | [#441](https://github.com/NobleFactor/noblefactor-engprod/issues/441), David-Noble-at-work/.github holds that account's issue model: NobleFactor's stand-in for [David-Noble-at-work/personal#311](https://github.com/David-Noble-at-work/personal/issues/311) | personal#311 is closed as completed: David-Noble-at-work/.github holds the account's model and star reads it; the health files are in place and personal shows them; the Triage workflow runs there with its own token, and a test issue filed there becomes a row of Triage: David-Noble-at-work |

## Current State

Read on 2026-11-09 from GitHub.

| Component | Status | Notes |
| --- | --- | --- |
| David-Noble-at-work/.github, public | ✅ | Created 2026-11-03; default branch `main`; no pull request yet |
| Six issue forms, each setting its type label, with a required Area | ✅ | |
| The forms' Plan and design documents field | ⚠️ | Optional and empty; the Schedule and Scenario forms have none |
| Triage workflow template | ⚠️ | `workflow-templates/triage.yml`, identical to personal's copy; no Severity step |
| `TRIAGE_PROJECT_URL` | ✅ | Set on David-Noble-at-work/.github and on personal: Triage: David-Noble-at-work |
| The account's model file in David-Noble-at-work/.github | ❌ | `model.David-Noble-at-work.yaml` beside the extension, pulled 2026-11-08 |
| star reads the account's model from there | ❌ | Since #431 star reads the default account's alone from GitHub |
| `CONTRIBUTING.md`, pull request template, `SECURITY.md`, `SUPPORT.md` | ❌ | |
| David-Noble-at-work/.github's own Triage workflow | ❌ | No `.github/workflows/triage.yml`, and no `ADD_TO_PROJECT_PAT` secret; personal has its own |
| A quality gate, and changes by pull request only | ❌ | No workflow and no ruleset |

## Decisions for review

The documents do not settle these. Each is a proposal for the owner to change at review.

1. **The file is `model.yaml` at the root of David-Noble-at-work/.github,** the extension's
   `model.David-Noble-at-work.yaml` as pulled on 2026-11-08, digest intact.
2. **star reads from GitHub the model of each account it works with:** the default account, and the owner of each of
   writ's layer repositories, the repositories the report covers by default. Here that is NobleFactor and
   David-Noble-at-work. Each is read as NobleFactor's is since #431: by ETag, once a process, with a copy kept. No
   configuration names the accounts. A `model.<account>.yaml` beside the extension is read only for an account outside
   that set; one for an account inside it is refused as a second model. `pull` and `digest` refuse without `--asset`
   for the same set, which a small module both `scheme.star` and `model.star` load computes once.
3. **The health files are NobleFactor/.github's, worded for the account:** `CONTRIBUTING.md`, `SECURITY.md`,
   `SUPPORT.md` and `.github/pull_request_template.md`. personal#311 names the first and the last; the other two keep
   the two accounts alike. Private vulnerability reporting is turned on for the account's public repositories.
4. **Each issue form's documents field is required and starts with the table,** as #431 made NobleFactor's; the
   Schedule and Scenario forms gain the field.
5. **The Severity step, ruled 2026-11-04,** joins the account's Triage workflow template: an issue that is not a bug
   gets `severity:n/a`, and one filed from the bug form, which sets the `bug` label, gets `severity:medium`.
   David-Noble-at-work/.github gets `.github/workflows/triage.yml`, the template as it then stands. personal's copy is
   brought to the template in a pull request of personal's own.
6. **David-Noble-at-work/.github's `ADD_TO_PROJECT_PAT` is a new classic token,** with the project scope, made for it,
   and personal's is left as it is. personal#311 left open whether to make a new one or regenerate personal's and store
   it in both; a new one rotates nothing. Making it and storing it are the owner's:
   `gh secret set ADD_TO_PROJECT_PAT --repo David-Noble-at-work/.github`.
7. **David-Noble-at-work/.github gets NobleFactor/.github's quality gate and a ruleset of its own on `main`,**
   requiring a pull request and that check, since personal#311 says the model is changed only by pull request. A user
   account has no organization ruleset to inherit.
8. **The two other worktrees.** David-Noble-at-work/.github's is made by hand, as #431's .github worktree was:
   `~/Workspace/David-Noble-at-work/.github.441-user-dot-github` on `feature/441-user-dot-github`, from a clone at
   `~/Workspace/David-Noble-at-work/.github`. personal's is opened with `git open-branch 311`, its issue being personal's.

## Requirements

### Requirement 1: David-Noble-at-work/.github, in its own pull request

- `model.yaml` at the root, from the extension's `model.David-Noble-at-work.yaml`.
- `CONTRIBUTING.md`, `SECURITY.md` and `SUPPORT.md` at the root; `.github/pull_request_template.md`.
- Each of the six forms: the documents field required, the table its starting value.
- `workflow-templates/triage.yml` with the Severity step; `.github/workflows/triage.yml`, a copy of it.
- `.github/workflows/quality-gate.yml`, NobleFactor/.github's; `README.md` listing what the repository holds.
- After the merge: the ruleset on `main`; private vulnerability reporting on for the account's public repositories;
  each read back.

### Requirement 2: the token and a test issue

- The owner stores `ADD_TO_PROJECT_PAT` in David-Noble-at-work/.github.
- A test issue filed there from the task form becomes a row of Triage: David-Noble-at-work, labeled `area:` and
  `severity:n/a`; it is then closed as not planned.

### Requirement 3: personal's copy of the workflow, in its own pull request

- personal's `.github/workflows/triage.yml` becomes the template, the Severity step with it.

### Requirement 4: star reads every one of its accounts' models from GitHub

- A module computes the accounts: the default account and each writ layer repository's owner.
- `scheme.star` reads each one's model from its `.github` repository (decision 2); `model.star`, `pull` and `digest`
  use the same set.
- `model.David-Noble-at-work.yaml` leaves the extension, with `git rm`.
- Test-StarGitHub: a layer account's model read from GitHub; a model beside the extension for a layer account refused;
  a model beside it for another account still read; `pull` refusing without `--asset` for a layer account.

### Requirement 5: the documents

- Section 6, section 4 and their status: David-Noble-at-work's model file and file templates are its `.github`
  repository's, and how star finds the accounts it reads.
- agent-rules.md rule 13 and the PR script template: David-Noble-at-work's pull request template exists.

## Implementation Phases

### Phase 1: the plan

- [x] Written, committed on `feature/441-user-dot-github`, and reviewed with the owner: approved 2026-11-09

### Phase 2: David-Noble-at-work/.github

- [x] The clone and its worktree (decision 8)
- [x] The files of Requirement 1; the quality gate's check passes locally
- [x] Its pull request script written, shown and handed over; merged; the ruleset and private vulnerability reporting
      read back: David-Noble-at-work/.github#1

### Phase 3: the token and the test issue

- [x] The owner stores `ADD_TO_PROJECT_PAT`; a test issue becomes a Triage row with its labels, then closes: stored 2026-11-09
      through Key Vault `kv-david-noble-at-work`, in `rg-david-noble-at-work`, as `dot-github--ADD-TO-PROJECT-PAT`;
      David-Noble-at-work/.github#2 became a row of Triage: David-Noble-at-work with `area:engineering` and `severity:n/a`,
      its run 42691891250 succeeding, and closed as not planned

### Phase 4: personal's workflow

- [x] Requirement 3, in personal's worktree; its pull request merged: David-Noble-at-work/personal#323

### Phase 5: the test, first

- [x] Test-StarGitHub's new cases written, failing against the extension as it is: 4 of the 51 cases fail, 10.1 twice, 10.2 and 10.4; 10.3 guards what must not change, and passes

### Phase 6: star reads every account's model from GitHub

- [x] Requirement 4; every case passes; `make check` passes: all 51 cases; the account set and the helpers scheme.star and model.star shared by copy now live in commands/accounts.star, which loads nothing

### Phase 7: the documents

- [x] Requirement 5: sections 4 and 6 of the issue data model, section 6's status, both items now ticked, section 3's status table and the index; agent-rules.md rule 13; the PR script template's three notes

### Phase 8: proved on GitHub

- [x] `star github schedule report David-Noble-at-work/personal` and `star github triage sweep` read the account's
      model from David-Noble-at-work/.github; personal's new-issue page offers the six forms with the table and links
      `CONTRIBUTING.md`; a comment on #441 and on personal#311 shows both: the forms
      seen by the owner on personal's chooser page, 2026-11-09;
      https://github.com/NobleFactor/noblefactor-engprod/issues/441#issuecomment-6752288742

### Phase 9: merge

- [ ] The pull request script written, shown and handed over; it closes #441 and personal#311

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | An account that owns a writ layer repository, its model on GitHub | Read from its `.github` repository by ETag, a copy kept |
| 2 | Such an account with a `model.<account>.yaml` beside the extension too | Refused as a second model, both named |
| 3 | An account outside the set, its model beside the extension | Read from beside the extension, as before |
| 4 | `pull --account <layer account>` without `--asset` | Refuses, naming the file to give |
| 5 | Every existing case | Passes unchanged |

## Files to Create/Modify

David-Noble-at-work/.github:

| File | Action | Purpose |
| --- | --- | --- |
| `model.yaml` | Create | The account's model, from the extension |
| `CONTRIBUTING.md`, `SECURITY.md`, `SUPPORT.md` | Create | Decision 3 |
| `.github/pull_request_template.md` | Create | Decision 3 |
| `.github/ISSUE_TEMPLATE/*.yml` | Modify | Decision 4 |
| `workflow-templates/triage.yml` | Modify | Decision 5, the Severity step |
| `.github/workflows/triage.yml` | Create | Decision 5 |
| `.github/workflows/quality-gate.yml` | Create | Decision 7 |
| `README.md` | Modify | What the repository holds |

David-Noble-at-work/personal:

| File | Action | Purpose |
| --- | --- | --- |
| `.github/workflows/triage.yml` | Modify | Decision 5 |

noblefactor-engprod, under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named
from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/441-user-dot-github.md` | Create | This plan |
| `commands/accounts.star` | Create | Decision 2: the accounts star reads from GitHub |
| `commands/scheme.star`, `commands/model.star` | Modify | Decision 2 |
| `model.David-Noble-at-work.yaml` | Remove | Moved to David-Noble-at-work/.github |
| `tests/Test-StarGitHub` | Modify | The test plan |
| `docs/architecture/issue-data-model/4-storage-and-reach.md`, `6-the-asset-and-its-sync.md`, `6-the-asset-and-its-sync.status.md` | Modify | Requirement 5 |
| `docs/guides/agent-rules.md`, `docs/guides/pr-script-template.md` | Modify | Requirement 5 |

## Related Documents

- [#431's plan](431-dot-github.md): NobleFactor/.github, the same for the organization
- [Section 6, the asset and its sync](../../architecture/issue-data-model/6-the-asset-and-its-sync.md)
- [Section 4, storage and reach](../../architecture/issue-data-model/4-storage-and-reach.md)
- David-Noble-at-work/personal#315: personal's Triage workflow, copied from the template
- #426, step 21: pull writes to a branch of the account's `.github` repository
- #448: NobleFactor's Triage workflow sets Severity

## Open Questions

None beyond the decisions for review.
