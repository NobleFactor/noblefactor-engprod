---
title: "Every repository carries its own LICENSE and shows its account's CONTRIBUTING.md"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/265
status: approved
created: 2026-11-16
updated: 2026-11-16
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md
  - kind: Plan
    path: docs/plans/chore/179-relicense-apache-public.md
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

- Every repository of NobleFactor and David-Noble-at-work, forks aside, carries its own LICENSE: Apache 2.0, with a
  NOTICE and an Apache 2.0 SPDX header in every file that states a license, as #179 made noblefactor-engprod's. The
  lore packages alone, in devlore-registry, are MIT.
- No repository carries its own `CONTRIBUTING.md`. GitHub shows each account's, from its `.github` repository, in
  every one: one text per account, the same everywhere. It is not in a clone; LICENSE is.
- No repository asks for a sign-off or an `Assisted-by:` line on each commit.

Out of scope: forks, whose files are their upstreams'.

## Issue 265

[NobleFactor/noblefactor-engprod#265](https://github.com/NobleFactor/noblefactor-engprod/issues/265), Task, Area
Product, under Feature #157 in Epic #526.

- Ruled 2026-10-06: the same `CONTRIBUTING.md` in every repository; attribution on every pull request, not every
  commit; one issue for all the repositories.
- #431 and #441 made each account's `CONTRIBUTING.md` in its `.github` repository on 2026-11-09.
- Ruled 2026-11-16: every repository gets its own license file; no copies of `CONTRIBUTING.md`; personal is Apache
  2.0; in NobleFactor, lore packages alone are MIT.

## 3. Current state

Read 2026-11-16.

- **No LICENSE, 12 repositories.** NobleFactor: `.github` and devlore.noblefactor.com, public; noblefactor, acumen and
  Fixup-MusicLibrary, private. David-Noble-at-work: `.github`, public; azure-cosmos-benchmark-pointreads,
  jetbrains-idea-settings, jetbrains-rider-settings, specifications and azure-database-migration-service, private;
  azure-cosmos-cassandra-test, private and empty.
- **MIT, where it should be Apache 2.0.** personal: 284 files state MIT, its LICENSE, README and SPDX headers.
  docker-homebridge: 18 files. Import-AudioCdMetadata: its LICENSE among 3 files.
- **Their own `CONTRIBUTING.md`, hiding the account's.** devlore-cli's asks for `git commit -s` and `Assisted-by:` on
  each commit, as its README does. devlore-registry's is a contributor license agreement whose section 5 marks every
  commit. docker-homebridge's is a coding guide. personal's says the account's terms in other words.
- **Forks:** NobleFactor/docker-webhook, NobleFactor/roonserver-image and David-Noble-at-work/Tuckr.
- **Other licenses kept.** David-Noble-at-work's six private repositories that already carry one, five MIT and
  capitalone-exercise Apache 2.0, keep it: the MIT rule is NobleFactor's.

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

**LICENSE.** Apache 2.0, noblefactor-engprod's `LICENSE` word for word, and a `NOTICE` in its form naming the
repository: "Copyright 2025-2026 Noble Factor LLC" and "This product includes software developed at Noble Factor LLC
(https://noblefactor.com)."

| Change | Repositories |
| --- | --- |
| `LICENSE` and `NOTICE` added | the 12 § 3 names |
| Relicensed from MIT, as #179 did: `LICENSE` replaced, `NOTICE` added, every SPDX header `Apache-2.0`, every README license statement and MIT redistribution sentence brought to it | personal, docker-homebridge, Import-AudioCdMetadata |
| Kept MIT | devlore-registry, the lore packages |

**The order.** One repository at a time, each merged and its branch closed before the next, all through one
script: NobleFactor/.github; devlore-registry; devlore-cli; devlore.noblefactor.com; docker-homebridge;
Import-AudioCdMetadata; NobleFactor's noblefactor, acumen and Fixup-MusicLibrary; David-Noble-at-work/.github;
personal; David-Noble-at-work's private repositories; noblefactor-engprod last, with this plan, the evidence and
section 6's sentence, closing #265. A repository whose change is only its LICENSE and NOTICE gets its branch and
commit through GitHub's API, with no clone.

**The check.** Read from GitHub at the end and posted on #265: each repository's license, which is Apache-2.0 but
devlore-registry's MIT and the kept ones § 3 names; the `CONTRIBUTING.md` GitHub shows for each, from its community
profile, which is its account's; and a search finding no MIT statement in the relicensed three.

## 6. Alternatives and challenges

- **A copy of `CONTRIBUTING.md` in every repository.** Not taken: a copy only adds the file to clones, which
  contribution terms do not need, and each copy can drift.
- **devlore-registry's agreement off the contributing link.** GitHub's link shows the account's terms, not the
  agreement; the registry's README names `CLA.md` where it asks for contributions.
- **personal's 284 files in one pull request.** The header change is mechanical, one line in each, and #179 did the
  same in one; the pull request lists every file it changes.

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Every repository has its own license, by the rule | GitHub reads Apache-2.0 for each, forks aside, but devlore-registry's MIT and the kept ones | `gh api repos/<repository> --jq .license.spdx_id`, on #265 | GitHub |
| The relicensed three state no MIT | no SPDX header, README or LICENSE in them says MIT | a search, on #265 | each default branch |
| Every repository shows its account's terms | each one's community profile names its account's `CONTRIBUTING.md` | `gh api repos/<repository>/community/profile`, on #265 | GitHub |
| No per-commit rule | no file asks for a sign-off or `Assisted-by:` on a commit | a search, on #265 | GitHub |

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | yes | 17 pull requests and 1 first commit | Pending |
| Merge | yes, one repository at a time | each merged | Pending |
| Deployment | no: GitHub shows a default branch's files at once | | Not required |
| Verification | yes | the check, on #265 | Pending |

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [x] This plan, committed on `doc/265-contributing` on 2026-11-16 and approved by the owner that day

### 9.2 Phase 2: the public repositories, Import-AudioCdMetadata and personal

- [x] NobleFactor/.github, its LICENSE and NOTICE; merged, NobleFactor/.github#22
- [x] devlore-registry, its `CONTRIBUTING.md` removed, `CLA.md` and its README; merged, NobleFactor/devlore-registry#102
- [x] devlore-cli, its `CONTRIBUTING.md` removed and its README; merged, NobleFactor/devlore-cli#1233
- [x] devlore.noblefactor.com, its LICENSE and NOTICE; merged, NobleFactor/devlore.noblefactor.com#545
- [ ] docker-homebridge, relicensed and its guide moved; merged
- [ ] Import-AudioCdMetadata, relicensed; merged
- [ ] NobleFactor's noblefactor, acumen and Fixup-MusicLibrary, their LICENSE and NOTICE; each merged
- [ ] David-Noble-at-work/.github, its LICENSE and NOTICE; merged
- [ ] David-Noble-at-work/personal, relicensed and its `CONTRIBUTING.md` removed; merged

### 9.3 Phase 3: David-Noble-at-work's private repositories

- [ ] azure-cosmos-benchmark-pointreads, jetbrains-idea-settings, jetbrains-rider-settings, specifications and
  azure-database-migration-service; each merged
- [ ] azure-cosmos-cassandra-test, its first commit

### 9.4 Phase 4: noblefactor-engprod and the evidence

- [ ] Section 6's sentence; the check posted on #265; merged, closing #265

## 10. Files and related assets

- Create: `LICENSE` and `NOTICE` in the 12 repositories § 3 names; `NOTICE` in personal, docker-homebridge and
  Import-AudioCdMetadata; devlore-registry's `CLA.md`.
- Replace: `LICENSE` in personal, docker-homebridge and Import-AudioCdMetadata.
- Remove: `CONTRIBUTING.md` in devlore-cli, devlore-registry and personal, with `git rm`.
- Move: docker-homebridge's `CONTRIBUTING.md` to `DEVELOPMENT.md`, with `git mv`.
- Modify: every file in the relicensed three that states MIT; devlore-cli's and devlore-registry's `README.md`; this
  repository's `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md`.

## 11. Dependencies, overlaps and blockers

- `git open-branch` takes only its own repository's issues, so each other repository's branch is opened by hand
  (decision 1).
- acumen, Fixup-MusicLibrary, Import-AudioCdMetadata and David-Noble-at-work's private repositories are cloned under
  `~/Workspace/<owner>/` before their phase.
- personal is writ's layer; its relicensing pull request changes headers only, so a deploy after it changes nothing.

## 12. Approval and departures

Ruled 2026-11-16:

1. **Other repositories' branches are opened by hand,** as `doc/265-contributing` beside each clone; each pull
   request says "Part of NobleFactor/noblefactor-engprod#265".
2. **Every repository gets its own license file.**
3. **No copies of `CONTRIBUTING.md`.**
4. **personal is Apache 2.0, and in NobleFactor only lore packages are MIT.**

Approved by the owner 2026-11-16, with:

5. **David-Noble-at-work's private repositories that already carry a license keep it,** as § 3 says.
6. **One script for the remaining private repositories' licenses,** one repository at a time.
7. **The empty repository's LICENSE is its first commit,** pushed straight to the default branch, signed off and
   disclosing AI in its message, since there is no branch to open a pull request against.
   azure-database-migration-service has a commit, so only azure-cosmos-cassandra-test is empty.

## 13. Completion review

Pending.
