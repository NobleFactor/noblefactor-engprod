---
title: "Every repository carries its own LICENSE and shows its account's CONTRIBUTING.md"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/265
status: draft
created: 2026-11-16
updated: 2026-11-16
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/431
    text: "NobleFactor/.github: the organization's model, forms and health files"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/441
    text: "David-Noble-at-work/.github: the same for the user account"
---

# Every repository carries its own LICENSE and shows its account's CONTRIBUTING.md

[Up: Plans](../../index.md)

## 1. Role assignments

Owner David Noble. Participant: Claude Code, in the session working
[issue tracking, iteration 1 (#346)](https://github.com/NobleFactor/noblefactor-engprod/issues/346), step 54. Reviewer:
the owner. Observers: none.

## 2. Summary and promised result

- Every repository of NobleFactor and David-Noble-at-work, forks aside, carries its own LICENSE, which GitHub reads.
- No repository carries its own `CONTRIBUTING.md`. GitHub shows each account's, from its `.github` repository, in
  every one: one text per account, the same everywhere.
- No repository asks for a sign-off or an `Assisted-by:` line on each commit.

Out of scope: forks, whose files are their upstreams'.

## Issue 265

[NobleFactor/noblefactor-engprod#265](https://github.com/NobleFactor/noblefactor-engprod/issues/265), Task, Area
Product, under Feature #157 in Epic #526.

- Ruled 2026-10-06: the same `CONTRIBUTING.md` in every repository; attribution on every pull request, not every
  commit; one issue for all the repositories.
- #431 and #441 made each account's `CONTRIBUTING.md` in its `.github` repository on 2026-11-09.
- Ruled 2026-11-16: every repository gets its own license file; no copies of `CONTRIBUTING.md`, since GitHub shows the
  account's in every repository without one.

## 3. Current state

Read 2026-11-16.

- **No LICENSE, 12 repositories.** NobleFactor: `.github` and devlore.noblefactor.com, public; noblefactor, acumen and
  Fixup-MusicLibrary, private. David-Noble-at-work: `.github`, public; azure-cosmos-benchmark-pointreads,
  jetbrains-idea-settings, jetbrains-rider-settings and specifications, private; azure-cosmos-cassandra-test and
  azure-database-migration-service, private and empty.
- **Their own `CONTRIBUTING.md`, hiding the account's.** devlore-cli's asks for `git commit -s` and `Assisted-by:` on
  each commit, as its README does. devlore-registry's is a contributor license agreement whose section 5 marks every
  commit. docker-homebridge's is a coding guide. personal's says the account's terms in other words.
- **Forks:** NobleFactor/docker-webhook, NobleFactor/roonserver-image and David-Noble-at-work/Tuckr.

## 4. Design impact

Section 6 of the issue data model, § One model per account, says each account's `CONTRIBUTING.md` applies to every
repository without its own. One sentence is added: no repository carries its own, and each carries its own LICENSE
(#265).

## 5. Proposed implementation

**CONTRIBUTING.md.** Each repository's own is removed, and what it says that the account's does not moves to another
file:

| Repository | Its `CONTRIBUTING.md` | Its own text goes to |
| --- | --- | --- |
| NobleFactor/devlore-cli | removed | `README.md`: its build, test and lint steps, and the registry pointer; its sign-off sentence says the pull request |
| NobleFactor/devlore-registry | removed | `CLA.md`: the agreement, section 5 on the pull request; `README.md`: the package workflow |
| NobleFactor/docker-homebridge | moved | `DEVELOPMENT.md`, with `git mv` |
| David-Noble-at-work/personal | removed | nothing: the account's says it |

A link to a removed file points to its account's: `https://github.com/<account>/.github/blob/main/CONTRIBUTING.md`.

**LICENSE.** Each of the 12 takes its family's file word for word, the year 2026:

| License | Repositories | As |
| --- | --- | --- |
| Apache 2.0 | NobleFactor/.github, devlore.noblefactor.com | noblefactor-engprod, devlore-cli |
| MIT | NobleFactor's noblefactor, acumen, Fixup-MusicLibrary | Import-AudioCdMetadata |
| MIT | David-Noble-at-work's `.github` and its six private repositories | personal |

**The order.** One repository at a time, each merged and its branch closed before the next: noblefactor-engprod,
with this plan; NobleFactor/.github; devlore-cli; devlore-registry; devlore.noblefactor.com; docker-homebridge;
David-Noble-at-work/.github; personal; then the private repositories' licenses, through one script.

**The check.** Read from GitHub at the end and posted on #265: each repository's license, and the `CONTRIBUTING.md`
GitHub shows for each, from its community profile, which is its account's.

## 6. Alternatives and challenges

- **A copy in every repository.** Not taken: a copy only adds the file to clones, which contribution terms do not
  need, and each copy can drift.
- **devlore-registry's agreement off the contributing link.** GitHub's link shows the account's terms, not the
  agreement; the registry's README names `CLA.md` where it asks for contributions.

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Every repository has its own license | GitHub names a license for each, forks aside; personal's NOASSERTION aside (decision 3) | `gh api repos/<repository> --jq .license.spdx_id`, on #265 | GitHub |
| Every repository shows its account's terms | each one's community profile names its account's `CONTRIBUTING.md` | `gh api repos/<repository>/community/profile`, on #265 | GitHub |
| No per-commit rule | no file asks for a sign-off or `Assisted-by:` on a commit | a search, on #265 | GitHub |

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | yes | 15 pull requests and 2 first commits | Pending |
| Merge | yes, one repository at a time | each merged | Pending |
| Deployment | no: GitHub shows a default branch's files at once | | Not required |
| Verification | yes | the check, on #265 | Pending |

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [ ] This plan, committed on `doc/265-contributing` and reviewed with the owner

### 9.2 Phase 2: noblefactor-engprod

- [ ] Section 6's sentence; merged

### 9.3 Phase 3: the public repositories and personal

- [ ] NobleFactor/.github, its LICENSE; merged
- [ ] devlore-cli, its `CONTRIBUTING.md` removed and its README; merged
- [ ] devlore-registry, its `CONTRIBUTING.md` removed, `CLA.md` and its README; merged
- [ ] devlore.noblefactor.com, its LICENSE; merged
- [ ] docker-homebridge, its guide moved; merged
- [ ] David-Noble-at-work/.github, its LICENSE; merged
- [ ] David-Noble-at-work/personal, its `CONTRIBUTING.md` removed; merged

### 9.4 Phase 4: the private repositories' licenses

- [ ] NobleFactor's three, and David-Noble-at-work's four with a branch; each merged
- [ ] azure-cosmos-cassandra-test and azure-database-migration-service, each its first commit

### 9.5 Phase 5: the evidence

- [ ] The check posted on #265; #265 closed

## 10. Files and related assets

- Create: `LICENSE` in the 12 repositories § 3 names; devlore-registry's `CLA.md`.
- Remove: `CONTRIBUTING.md` in devlore-cli, devlore-registry and personal, with `git rm`.
- Move: docker-homebridge's `CONTRIBUTING.md` to `DEVELOPMENT.md`, with `git mv`.
- Modify: devlore-cli's and devlore-registry's `README.md`; this repository's
  `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md`.

## 11. Dependencies, overlaps and blockers

- `git open-branch` takes only its own repository's issues, so each other repository's branch is opened by hand
  (decision 1).
- acumen, Fixup-MusicLibrary and David-Noble-at-work's private repositories are cloned under `~/Workspace/<owner>/`
  before their phase.

## 12. Approval and departures

Ruled 2026-11-16:

1. **Other repositories' branches are opened by hand,** as `doc/265-contributing` beside each clone; each pull
   request says "Part of NobleFactor/noblefactor-engprod#265".
2. **Every repository gets its own license file.**
3. **No copies of `CONTRIBUTING.md`.**

For review:

4. **Personal's LICENSE stays as it is,** the owner's MIT text, which GitHub reads as NOASSERTION.
5. **The licenses by family,** as § 5.
6. **One script for the private repositories' licenses,** one repository at a time.
7. **The two empty repositories' LICENSE is their first commit,** pushed straight to the default branch, signed off and
   disclosing AI in its message, since there is no branch to open a pull request against.

Not yet approved.

## 13. Completion review

Pending.
