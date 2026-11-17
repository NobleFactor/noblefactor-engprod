---
title: "Prose written after the handbook's adoption is one source line per paragraph"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/584
status: approved
created: 2026-11-16
updated: 2026-11-16
documents:
  - kind: Standard
    path: docs/standards/documentation.md
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/570
    text: "Formatting migration"
---

# Prose written after the handbook's adoption is one source line per paragraph

[Up: Plans](../../index.md)

## 1. Role assignments

Owner David Noble. Participant: Claude Code, in the session working [issue tracking, iteration 1 (#346)](https://github.com/NobleFactor/noblefactor-engprod/issues/346), step 56. Reviewer: the owner. Observers: none.

## 2. Summary and promised result

Every paragraph and list item this session wrote or revised after the handbook's adoption on 2026-11-16 occupies one source line, as the documentation standard's [§ 2.1](../../standards/documentation.md#prose-source-layout) requires, its words unchanged. Out of scope: every other legacy document, which is #570's, and merged history: pull request descriptions, commit messages and evidence comments.

## Issue 584

[NobleFactor/noblefactor-engprod#584](https://github.com/NobleFactor/noblefactor-engprod/issues/584), Task, Area Product, under Feature #419. The owner's Codex session found the hard wrapping on 2026-11-16, and the owner approved this fix that day.

## 3. Current state

Read 2026-11-16 from each default branch:

| Repository | Hard-wrapped prose |
| --- | --- |
| noblefactor-engprod | `docs/plans/doc/265-contributing.md` and `docs/plans/doc/507-scenario-commands.md`, whole; one paragraph of section 6; four items of section 8's status page and five of section 9's; one item of #573's plan |
| NobleFactor/devlore-cli | three blocks of the README's Contributing section |
| NobleFactor/devlore-registry | `CLA.md`'s opening paragraph; two blocks of the README's "How to contribute" |
| NobleFactor/docker-homebridge | one README sentence |
| GitHub | the bodies of #581 and #582 |

## 4. Design impact

None: the standard already says it.

## 5. Proposed implementation

`unwrap.py`, in this worktree's scratch directory, joins each hard-wrapped paragraph and list item onto one line, its words unchanged, and leaves frontmatter, fenced code, tables, headings, HTML lines, block quotes and hard line breaks as they are. Given `--only <text>`, it joins only the blocks that contain the text, so a shared document changes in the paragraphs this session wrote and nowhere else. A second run joins nothing.

One script does the rest, one repository at a time, each merged and its branch closed before the next, as #265's did: devlore-cli, devlore-registry and docker-homebridge, each on a branch `doc/584-unwrap-prose` opened by hand and a pull request "Part of NobleFactor/noblefactor-engprod#584"; then #581's and #582's bodies, rewritten in place and read back; then noblefactor-engprod, closing #584.

## 6. Alternatives and challenges

- **Every hard-wrapped document now.** Not taken: #570 owns the inventory and the final pass, and this fixes only what this session wrote after adoption.

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| The listed prose is one line per block | `unwrap.py` with the same `--only` texts joins nothing on each default branch | its output, on #584 | each default branch |
| No word changes | each pull request's diff, with whitespace ignored, is empty | `git diff -w --word-diff`, on #584 | each pull request |
| #581's and #582's bodies are unwrapped | `unwrap.py` joins nothing in either | its output, on #584 | GitHub |

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | yes | four pull requests and two issue bodies | Pending |
| Merge | yes, one repository at a time | each merged | Pending |
| Deployment | no: GitHub shows a default branch's files at once | | Not required |
| Verification | yes | the check, on #584 | Pending |

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [x] This plan, approved by the owner on 2026-11-16 and committed on `doc/584-unwrap-prose`

### 9.2 Phase 2: the other repositories

- [x] NobleFactor/devlore-cli; merged, NobleFactor/devlore-cli#1234
- [x] NobleFactor/devlore-registry; merged, NobleFactor/devlore-registry#103
- [x] NobleFactor/docker-homebridge; merged, NobleFactor/docker-homebridge#21

### 9.3 Phase 3: the issue bodies

- [x] #581's and #582's bodies rewritten and read back, read back on 2026-11-17

### 9.4 Phase 4: noblefactor-engprod

- [ ] The two plans, section 6's paragraph, the status pages' items and #573's plan's item; this plan complete; merged, closing #584

## 10. Files and related assets

- Modify: the files § 3 names; this plan.
- `unwrap.py` and the script's checks in `~/Workspace/NobleFactor/scratch/noblefactor-engprod.584-unwrap-prose/`.

## 11. Dependencies, overlaps and blockers

- `git open-branch` takes only its own repository's issues, so the other repositories' branches are opened by hand, as ruled for #265 on 2026-11-16.
- docker-homebridge's clone has `release/1.0.0-preview.3` checked out; its branch is closed by hand, and the clone left as it is.

## 12. Approval and departures

Approved by the owner on 2026-11-16.

## 13. Completion review

Pending.
