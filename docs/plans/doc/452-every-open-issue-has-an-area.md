---
title: "Every open issue has an Area before the sweep runs"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/452
status: approved
created: 2026-11-06
updated: 2026-11-06
---

# Plan: every open issue has an Area before the sweep runs

## Summary

Almost no open issue had an Area on 2026-11-06: 553 of the 568 open issues in the seven participating repositories had
none. The sweep (NobleFactor/noblefactor-engprod#436) returns an issue without an Area to its team's Triage project, so
its first run would send nearly every open issue back to Triage. This plan gives every open issue its Area, Product or
Engineering, judged one by one by what the issue's own work is, under the definitions of
[issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering). Proposals are made
per repository, reviewed with the owner, and written only once approved, by a script that reads every value back. One
pull request, not merged until the work is done.

## Issue 452

[Every open issue has an Area before the sweep runs](https://github.com/NobleFactor/noblefactor-engprod/issues/452), a
task under the rollout feature (NobleFactor/noblefactor-engprod#333) of issue tracking, Epic #330. It is step 13 of
issue tracking, iteration 1 (NobleFactor/noblefactor-engprod#346) since the renumbering of 2026-11-06, and it blocks the
sweep, #436, step 14.

## Issue 445

[Test-ClearClaude prints "No such file or directory" in passing
cases](https://github.com/NobleFactor/noblefactor-engprod/issues/445), a bug under NobleFactor/noblefactor-engprod#151,
is fixed in this worktree too, by the owner's word of 2026-11-06, after this worktree's gate run that day printed 40 of
those lines. Its lines 271 and 272 put `2>/dev/null` after the
input redirection that fails, so bash reports the missing file before the error output is sent away. Both now put it
first, as its line 411 already did.

## Rulings

**Scope, ruled 2026-11-06:**

- Every issue needs an Area. This plan covers the **open** issues; closed issues follow as work of their own.
- The repositories are the seven that take part: NobleFactor/noblefactor-engprod, NobleFactor/.github,
  NobleFactor/devlore-cli, NobleFactor/devlore-registry and NobleFactor/devlore.noblefactor.com, and
  David-Noble-at-work/personal and David-Noble-at-work/.github, the last included though #452's body named six.
- Each issue is judged one by one, by the definitions ruled 2026-11-05, for noblefactor-engprod and .github as for the
  others: #452's body said their issues would all get Engineering, which the rulings of 2026-11-05 replaced, since
  noblefactor-engprod's tooling, process and standards are products of the engineering productivity team.
- In personal, every issue is Engineering: no `area:product` is expected in a personal repository (ruled 2026-11-05).

**Of the review, ruled 2026-11-06,** each recorded per issue in
[rulings.tsv](452-every-open-issue-has-an-area/rulings.tsv):

- Generated code is engineering: a generator that turns source into published code or schemas keeps the result
  deterministic, where the alternative is code written by hand (NobleFactor/devlore-cli#66, #280).
- Design is engineering (NobleFactor/devlore-cli#91, #287).
- A product feature may hold engineering tasks; where a product feature mixes the two, it is split into tasks of each
  kind (NobleFactor/devlore-cli#91), and a feature whose plan is mostly done has its one gap filed as a task
  (NobleFactor/devlore-cli#339, #340).
- A feature closes only after its tasks and bugs are done, and after an agent's compliance audit and code review with
  the owner's sign-off (issue-standards.md, ruled 2026-11-03). NobleFactor/devlore-cli#339 and #340 were closed without
  that and reopened the same day. Nothing yet brings a finished feature to that review: Epic
  NobleFactor/noblefactor-engprod#456 and its features #457 to #461, filed 2026-11-06, hold the method and what it runs
  on.
- New tasks split from a feature go to Backlog: devlore with Priority Medium, unless the owner says otherwise.
- Nothing goes in a temporary directory, ever; a worktree keeps its working files in its own `scratch/` folder, which
  git ignores. The gate checks only what git tracks, so a worktree's scratch is never checked: `spelling` and
  `starlark` in the Makefile, and `.github/scripts/shell-lint.sh`, take their files from `git ls-files`, as the
  frontmatter and PowerShell checks already did.

## Current State

Read on 2026-11-06 through GitHub's GraphQL API, every open issue of the seven repositories with its type, parent,
labels and Area:

| Repository | Open | No Area |
| --- | --- | --- |
| NobleFactor/noblefactor-engprod | 126 | 116 |
| NobleFactor/.github | 0 | 0 |
| NobleFactor/devlore-cli | 391 | 391 |
| NobleFactor/devlore-registry | 7 | 7 |
| NobleFactor/devlore.noblefactor.com | 2 | 2 |
| David-Noble-at-work/personal | 42 | 37 |
| David-Noble-at-work/.github | 0 | 0 |

None carried both values. Five readers, each given the definitions and told to judge an issue's own work, proposed an
Area for each open issue of noblefactor-engprod and devlore-cli, with a reason and a confidence; the proposals for
devlore-registry, devlore.noblefactor.com and personal were made directly. They are in this plan's directory, one file
per repository, `proposed-<repository>.tsv`: issue, Area, sure or unsure, and the reason.

| Repository | Product | Engineering | Unsure |
| --- | --- | --- | --- |
| NobleFactor/noblefactor-engprod | 100 | 26 | 21 |
| NobleFactor/devlore-cli | 303 | 88 | 52 |
| NobleFactor/devlore-registry | 7 | 0 | 0 |
| NobleFactor/devlore.noblefactor.com | 2 | 0 | 0 |
| David-Noble-at-work/personal | 0 | 42 | 0 |

Checked against the rule that an engineering parent never holds a product child, nine of devlore-cli's proposals put a
product issue under an engineering parent; the open ones are under Open Questions.

## Requirements

### Requirement 1: the review

Each repository's proposals are reviewed with the owner, the unsure ones one at a time, before anything is written.
Each ruling is recorded in `rulings.tsv` as it is made, and the proposal files are corrected to match.

### Requirement 2: the write

A script writes the approved Areas: NobleFactor's Area issue field in its five repositories, through
`setIssueFieldValue`, and the `area:product` or `area:engineering` label in David-Noble-at-work's. It first surveys the
open issues again, since issues close and are filed while the review goes on, and stops on any open issue with no
approved Area. It reads every value back.

### Requirement 3: the evidence

The comment that closes #452 shows, for each of the seven repositories, the count of open issues with no Area, each
zero, read the day it closes.

## Implementation Phases

### Phase 1: the plan and the review's record

- [x] This plan, the rulings so far and the proposals committed and pushed on `doc/452-every-open-issue-has-an-area`
      by the worktree's first script, which also links the branch in #452's Worktree column on Schedule: engprod, sets
      that row In progress, and links this plan in #452's Plan row, each read back; then reviewed with the owner and
      its status `approved`

### Phase 2: the review

- [x] noblefactor-engprod's 21 unsure proposals ruled, on 2026-11-07, recorded in rulings.tsv
- [x] devlore-cli's 52 unsure proposals and its parent conflicts ruled, on 2026-11-06 and 2026-11-07, recorded in
      rulings.tsv
- [x] devlore-registry, devlore.noblefactor.com and personal approved: signed off by the owner on 2026-11-07, all nine
      of devlore-registry's and devlore.noblefactor.com's Product and all 42 of personal's Engineering

### Phase 3: the write

- [ ] The approved Areas written to every open issue of the seven repositories and read back, with the survey that
      shows none left without one

### Phase 4: NobleFactor/noblefactor-engprod#445

- [x] `tests/Test-ClearClaude`'s two reads of the stand-in's files put `2>/dev/null` first, and a run of the test
      prints no `No such file or directory`: run 2026-11-06, its 27 cases passed and printed none

### Phase 5: merge

- [ ] The pull request script written, shown and handed over; the closing comment carries Requirement 3's counts

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/452-every-open-issue-has-an-area.md` | Create | This plan |
| `docs/plans/doc/452-every-open-issue-has-an-area/rulings.tsv` | Create | The owner's rulings, one per issue |
| `docs/plans/doc/452-every-open-issue-has-an-area/proposed-<repository>.tsv` | Create | The proposals, per repository |
| `Makefile` | Modify | `spelling` and `starlark` check only what git tracks, so the worktree's scratch is never checked |
| `.github/scripts/shell-lint.sh` | Modify | The shell gate checks only what git tracks, for the same reason |
| `tests/Test-ClearClaude` | Modify | #445: a passing case prints no error for a stand-in file it never wrote |

## Open Questions

- [x] **The parent conflicts left in devlore-cli,** all resolved. On 2026-11-06: #467, #472 and #847 moved from #466
      to the writ deployment epic #447; #477 moved from #475 to #798, and #485 from #483 to #381; and Feature #340
      became Engineering once its star work moved to Epic #1065's features. On 2026-11-07: #376 moved from #373 to
      Feature #1097, and #439 and #724 to Feature #340; #465 moved from Epic #454 to Epic #453; and #1152 moved from
      Scenario #892, which takes no children, to Feature #463.
- [x] **NobleFactor/devlore-cli#373,** closed as completed on 2026-11-07: CI runs on every platform, and the ruleset
      has required the test legs on all five since 2026-11-01, so its work was done. Its children moved first.
- [ ] **NobleFactor/devlore-cli#83,** the `self` command: possibly done, since `self install` and `self upgrade`
      exist; not yet checked.
- [x] **NobleFactor/noblefactor-engprod#433 and #445** are the same Test-ClearClaude bug. #445, with its Area, its
      parent and its row on Schedule: engprod, is fixed here (Phase 4), and its Severity is Low. #433, filed two days
      earlier with none of them, was closed on 2026-11-06 as completed, with Resolution Duplicate, by the owner's word.
- [ ] **NobleFactor/devlore-cli#285** was closed with no Area.
- [ ] **The engineering documentation draft** NobleFactor/noblefactor-engprod#420 describes was on danoble-ud24-1
      alone. Read on 2026-11-06, its review package was no longer in `/tmp/noblefactor-docs-review-2026-10-28`, and its
      backups, 531 files in `/home/david-noble/Workspace/NobleFactor/.documentation-backups`, are the one copy left;
      they go into #420's own worktree, archived whole, before anything else is done with them.
