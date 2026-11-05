---
title: "docs/issue-standards.md gets a section that defines product and engineering issues and puts test bugs in engineering"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/446
status: draft
created: 2026-11-05
updated: 2026-11-05
---

# Plan: a section of issue-standards.md that says what product and engineering work are, tests in engineering

## Summary

Nothing in the engineering documents says what product work is. What they have is a list of what engineering covers,
written out ten times: in docs/issue-standards.md § The types, in each of seven places in the issue data model, and in
each of the two reference models. Product is described only by the Area field's Product option and the matching label,
as work that ships to users. Tests are on no list, so nothing says which Area a test bug takes. This plan gives
docs/issue-standards.md a section of its own, `## Product and engineering`, that says what product work covers and what
engineering work covers, with tests on the list; that an issue's Area describes its own work, not its parent's; and the
ruling of 2026-11-04 that a bug in a test is an engineering issue. Every other place then says it in one sentence that
points to the new section, in place of the list. One issue, one pull request; the open questions below are ruled
first, since the section states their answers.

## Issue 446

[docs/issue-standards.md gets a section that defines product and engineering issues and puts test bugs in
engineering](https://github.com/NobleFactor/noblefactor-engprod/issues/446). A task under the feature for the GitHub
issue data model ([#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)): one hierarchy, its
attributes, and the collections that order it. Its Area is Engineering. It is step 31 of issue tracking, iteration 1
([#346](https://github.com/NobleFactor/noblefactor-engprod/issues/346)), on Schedule: engprod, and nothing blocks it
(read on 2026-11-05 with `gh issue view 446` and its row's fields).

## Rulings

- 2026-11-03, on the design of the issue data model (#303,
  [comment](https://github.com/NobleFactor/noblefactor-engprod/issues/303#issuecomment-6621241394)): Area tells
  engineering work from product work. It applies to issues of every type and describes the issue's own work, so an
  epic, a feature and the tasks and bugs under them can each have a different Area: a CI bug fixed during a product
  feature is engineering. Epics for product readiness and for release management hold both kinds. Engineering covers
  build orchestration, Makefile changes, CI pipelines, and the internal agent workspace's scripts and tools.
- 2026-11-03, the same day
  ([comment](https://github.com/NobleFactor/noblefactor-engprod/issues/303#issuecomment-6621744269)): Area's two values
  are product and engineering, the options Product and Engineering of NobleFactor's Area issue field, and the labels
  `area:product` and `area:engineering` in a user account.
- 2026-11-03, the same day
  ([comment](https://github.com/NobleFactor/noblefactor-engprod/issues/303#issuecomment-6621845678)): devlore-cli's
  seven finer Area labels (architecture, CLI, code quality, error handling, git, meta and testing) go, and the hierarchy
  carries the distinctions they drew.
- 2026-11-04: a bug in a test is an engineering issue, not a product issue. The ruling is recorded in this task's own
  body, and the Test-ClearClaude bug (#445) was filed with Area Engineering on it.

Two items the documents state are in no recorded ruling: governance and process work as engineering, and that release
notes come from the closed product issues in a release. Both are recorded as rulings of 2026-11-03 only in a ticked
box of the plan of the issue data model's design (#303), at `docs/plans/chore/303-issue-data-model.md:380-386`, and in
the design itself. The first ruling's comment, as first posted, said that governance and process tracking get no
Area, since that work doesn't touch the code, and that a feature's Area says whether it belongs in customer release
notes; the edit made at 2026-11-04T03:25:48Z removed both (read on 2026-11-05 with GitHub's GraphQL `userContentEdits`
for the comment). Open Question 3 asks for them.

## Current State

Read on 2026-11-05 at develop's `5276567`: the documents in this worktree with grep and sed, and GitHub as each item
says.

**The list of what engineering covers** is written out in ten places, as one sentence in two wordings (found by
searching the worktree for the list's words). issue-standards.md and section 2 say "Engineering covers build
orchestration, Makefile changes, CI pipelines, the scripts and tools of the internal agent workspace, and governance and
process work"; the other six places in the issue data model and both reference models say "internal agent-workspace
scripts and tools" instead.

| Place | Where | Wording |
| --- | --- | --- |
| issue-standards.md § The types | `docs/issue-standards.md:92-100`, the paragraph "Area tells engineering work from product work" | the scripts and tools of the internal agent workspace |
| Section 1 § Type | `docs/architecture/issue-data-model/1-hierarchy.md:65-70`, the paragraph "Engineering and product" | internal agent-workspace scripts and tools |
| Section 2 § The attributes | `docs/architecture/issue-data-model/2-attributes.md:99-106` | the scripts and tools of the internal agent workspace |
| Section 3, its opening | `docs/architecture/issue-data-model/3-collections.md:16-23` | internal agent-workspace scripts and tools |
| Section 4 § Where each part lives | `docs/architecture/issue-data-model/4-storage-and-reach.md:543-548` | internal agent-workspace scripts and tools |
| Section 5 § The deltas | `docs/architecture/issue-data-model/5-from-todays-scheme.md:56`, the row on the `Ops:` prefix | internal agent-workspace scripts and tools |
| Section 7 § Product and engineering | `docs/architecture/issue-data-model/7-the-workflow-before-and-after.md:47-52` | internal agent-workspace scripts and tools |
| The index's definition of Area | `docs/architecture/issue-data-model/index.md:252-270`, § Terms | internal agent-workspace scripts and tools |
| The organization's reference model | `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/reference/organization.yaml:70-75`, the comment above `fields:` | internal agent-workspace scripts and tools |
| The user account's reference model | `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/reference/user.yaml:81-87`, the comment above `areas:` | internal agent-workspace scripts and tools |

The two reference models are not among the seven places this task names; this plan's research found them.

**Product** is described only as work that ships to users: by the Area field's Product option, "Work that ships to
users" (read with `gh api orgs/NobleFactor/issue-fields`, and in organization.yaml:138), and by the label
`area:product`, "Area: work that ships to users" (read with `gh label list` in personal and David-Noble-at-work/.github,
and in user.yaml:103). Engineering's option is "Build, CI, tooling and other internal work" (organization.yaml:139),
and its label "Area: build, CI, tooling and other internal work" (user.yaml:107). The twelve issue forms, six in each
account's `.github` repository, ask "Is this issue's own work product or engineering?" and define neither (read with
`gh api` on each repository's `.github/ISSUE_TEMPLATE`).

**What each team and repository is,** read with `gh api orgs/NobleFactor/teams` and each repository's README on
GitHub:

- The team devlore is "DevLore: the devlore product; owns devlore-cli, devlore-registry and devlore.noblefactor.com",
  and the team engprod "Engineering productivity: process and tooling; owns noblefactor-engprod".
- devlore-cli sets up developer machines. Its README says lore's packages live in devlore-registry, whose content is
  served from GitHub today, and that DevLore's installers are served by the DevLore site's develop environment.
- devlore-registry's README calls it the official registry for lore, its knowledge helping users find the packages
  they need; devlore.noblefactor.com's calls it a marketing site for the DevLore suite, with access restricted to
  stakeholders.
- personal is a dotfile and development-environment system, and its one collaborator is its owner (read with `gh api
  repos/David-Noble-at-work/personal/collaborators`).
- The every-open-issue-gets-an-Area task (#452), step 36 on Schedule: engprod, plans to give the open issues of
  noblefactor-engprod and NobleFactor/.github Engineering, as those repositories' work is the tooling and process of
  engineering productivity. It will apply what this plan's questions rule, and nothing links it as blocked by this
  task (Open Question 12).

**Tests** are on no list. `docs/issue-standards.md:102-105` names testing among the seven deleted finer labels and says
the hierarchy carries those distinctions; nothing says which Area a test bug takes.

**That Area describes the issue's own work** is said in each of the ten places, with the CI bug as its example. The
words "not its parent's" are in no document; on GitHub they are only in this task's own body and in #452's, which
credits them to the design.

**Area on collections:** Area applies to Schedule and Scenario issues too (`docs/issue-standards.md:606-607`), though
those issues order work rather than do it, and an epic for product readiness or release management holds both kinds.
Read on 2026-11-05 with GraphQL: the Schedule issue of issue tracking, iteration 1 (#346) has no Area, and neither do
the five open Scenario issues on Scenario: engprod and Scenario: devlore.

**What points at the Area paragraph:** in issue-standards.md, which names its own sections in plain text, line 607 says
Area has two values "(§ The types)", and line 748 points there for the deleted labels. The design documents link
issue-standards.md as `../../issue-standards.md`, and no heading there makes the anchor `#product-and-engineering`
today. Section 7's table row at line 36 sends the reader to its own § Product and engineering to learn what each value
means; that subsection lists only what engineering covers.

**A stale pointer two lines from a place this plan edits:** `docs/architecture/issue-data-model/1-hierarchy.md:62`
points to issue-standards.md § The Ops axis, a section issue-standards.md no longer has (grep finds no such heading).

**History, left as it is:** the design's status files record the rulings with their dates; the plan of the issue data
model's design (#303) writes the list out in a ticked box; and the extension's cached model,
`Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/model.yaml:25`, still describes a feature
as "a capability, for the product or for engineering, its epic or area saying which". `star github model pull` writes
that file from GitHub, and the model-pull task (#426) replaces it, so this plan does not edit it by hand.

## Requirements

### Requirement 1: `## Product and engineering` in docs/issue-standards.md

A section of its own, right after `## The types`, which takes from that section what it says of Area today, and states
the answers to the open questions:

- **Area and its two values,** ruled 2026-11-03: the options Product and Engineering of the Area issue field in
  NobleFactor, and the labels `area:product` and `area:engineering` in a user account. Every issue has one, and a blank
  Area is an error (§ What has no parent).
- **What product work covers:** work that ships to users (Open Questions 1, 4 and 5).
- **What engineering work covers:** build orchestration, Makefile changes, CI pipelines, tests, the scripts and tools
  of the internal agent workspace, and governance and process work (Open Questions 2, 3 and 6).
- **An issue's Area describes its own work, not its parent's:** an epic, a feature and the tasks and bugs under them
  can each differ, and a CI bug fixed during a product feature is engineering.
- **A bug in a test is an engineering issue, not a product issue,** ruled 2026-11-04, as the Test-ClearClaude bug
  (#445) is.
- **Collections and the epics that hold both kinds** take the Area of the deliverable they name (Open Question 7).
- **Epics for product readiness and for release management hold both kinds,** and release notes come from the closed
  product issues in a release, not from the hierarchy (Open Question 3).
- **devlore-cli's seven finer Area labels** were deleted on 2026-11-03, and the hierarchy carries their distinctions:
  the paragraph at lines 102-105, moved here (Open Question 11).

§ The types keeps its level table and its paragraph on features, which say a feature is for the product or for
engineering; that paragraph points to the new section in the document's own form, "(§ Product and engineering)". Lines
607 and 748 point to it too, in place of "(§ The types)".

### Requirement 2: The seven places in the issue data model

Each replaces its list sentence with one sentence that points to the new section, and keeps the rest of its paragraph:
what product work and engineering work each cover, tests among engineering's, is in
`[issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering)`. Section 7's table
row at line 36 then sends the reader there. The status files of the six sections that change, 1, 2, 3, 4, 5 and 7,
each record the change with its date; section 2's, where Area's rulings are recorded, also records the ruling of
2026-11-04. The stale pointer at 1-hierarchy.md:62 points to the new section too (Open Question 9).

### Requirement 3: The reference models

The comments at organization.yaml:74-75 and user.yaml:86-87 replace the list with a pointer in the models' own form, a
bare path in parentheses, with the section's name added: "(docs/issue-standards.md, § Product and engineering)" (Open
Question 8). The Area option's and the labels' descriptions stay as they are (Open Question 10).

### Requirement 4: The gate

`make check`, the gate `ci.yaml` runs, passes before each commit.

## Implementation Phases

### Phase 1: The plan

- [ ] This plan committed and pushed on `doc/446-product-and-engineering` by the worktree's first script,
      `~/Workspace/NobleFactor/noblefactor-engprod.446-product-and-engineering.bash`, which also links the branch in
      #446's Worktree column on Schedule: engprod, sets that row In progress, and links this plan in #446's Plan row,
      each read back; then reviewed with the owner, its open questions ruled, and its status `approved`

### Phase 2: The section (Requirement 1)

- [ ] `## Product and engineering` in docs/issue-standards.md, with the Area paragraphs moved into it from § The types,
      and the paragraph on features and lines 607 and 748 pointing to it; this plan's status `active`; `make check`
      green

### Phase 3: The other places (Requirements 2 and 3), one commit

- [ ] The seven places in the issue data model and section 7's table row, the six sections' status files, the pointer
      at 1-hierarchy.md:62, and the two reference models' comments; `make check` green

### Phase 4: Merge

- [ ] PR script `~/Workspace/NobleFactor/noblefactor-engprod.446-product-and-engineering.bash` written, shown, and
      handed over; the pull request's description names this task (#446) with no closing keyword, so that GitHub
      doesn't close it before its evidence is posted. This box's commit, the pull request's last, sets this plan
      `complete`

After the merge, the same script records it, in this order. It comments on #446, naming the pull request and its
squash commit, linking the new section on `develop`, and naming the seven places in the issue data model, each now
pointing to it: that one comment is both this task's evidence of completion and rule 19's record, and it is read back.
It then closes #446 as completed, and sets its row on Schedule: engprod to Closed, leaving the row's Worktree link as
it is, read back. These follow the merge, so #446 records them, and this plan does not wait on them (rules 12 and 19
of agent-rules.md). The script leaves out the PR script template's schedule step, whose table was retired on
2026-11-03; bringing the template up to date is #450's.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/446-product-and-engineering.md` | Create | This plan |
| `docs/issue-standards.md` | Modify | Requirement 1 |
| `docs/architecture/issue-data-model/1-hierarchy.md`, `2-attributes.md`, `3-collections.md`, `4-storage-and-reach.md`, `5-from-todays-scheme.md`, `7-the-workflow-before-and-after.md` and `index.md` | Modify | Requirement 2 |
| `docs/architecture/issue-data-model/1-hierarchy.status.md`, `2-attributes.status.md`, `3-collections.status.md`, `4-storage-and-reach.status.md`, `5-from-todays-scheme.status.md` and `7-the-workflow-before-and-after.status.md` | Modify | Requirement 2: each records the change, and section 2's the ruling of 2026-11-04 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/reference/organization.yaml` and `user.yaml` | Modify | Requirement 3 |

## Open Questions

Each has a proposal, to be ruled one at a time.

- [ ] 1. **Product work.** Is it the work on what NobleFactor ships to users, today the DevLore product: star, writ and
      lore in devlore-cli, lore's packages and knowledge in devlore-registry, and the DevLore site? The team devlore is
      described as the devlore product, lore reads the registry's content from GitHub, and the site serves DevLore's
      installers as well as marketing it. The ruling's first version spoke of shipping DevLore and other products to
      users. Proposed: yes, its users being the people who install and use DevLore.
- [ ] 2. **Engineering by repository.** Is all the work of noblefactor-engprod and of each account's `.github`
      repository engineering? The team engprod is described as engineering productivity, process and tooling, and the
      every-open-issue-gets-an-Area task (#452) plans the same. Proposed: yes.
- [ ] 3. **The two items in no recorded ruling.** Is governance and process work engineering, and do release notes
      come from the closed product issues in a release? Proposed: yes to both. This task, process work itself, carries
      Area Engineering.
- [ ] 4. **A user account.** What is product work in David-Noble-at-work? Proposed: nothing there ships to users
      today, since personal is its owner's own development environment and the account's `.github` repository holds
      its issue model, so its issues take `area:engineering`, and `area:product` waits for the first thing it ships.
- [ ] 5. **Documentation.** Does a change to documentation take the Area of what it documents? Proposed: yes, so the
      product's user documentation is product work, and this repository's process documents are engineering.
- [ ] 6. **How far tests reach.** Is every issue whose own work is tests engineering, a task that adds tests to a
      product feature as well as a bug in a test? Proposed: yes, since an issue's Area follows its own work; the
      product feature it serves stays product.
- [ ] 7. **Collections and the epics that hold both kinds.** Which Area does a Schedule or Scenario issue take, and an
      epic for product readiness or release management? Proposed: the Area of the deliverable it names, product when
      that ships to users and engineering otherwise, so issue tracking, iteration 1 (#346) is engineering.
- [ ] 8. **The reference models.** Do their comments point to the new section in place of the list, though this task
      does not name them? Proposed: yes, so that the list is written once.
- [ ] 9. **The stale pointer at 1-hierarchy.md:62,** to the retired § The Ops axis. Is it fixed in this pull request,
      pointing to the new section, which says what that axis was for? Proposed: yes, since it sits two lines from a
      place this plan edits (development-process.md § Discovering issues mid-work).
- [ ] 10. **The descriptions.** Do the Area option's and labels' descriptions change, to name tests, for example?
      Proposed: no. Each is one phrase, "other internal work" covers tests, and the section is the definition. A link
      to the section from the issue forms' Area dropdown would change the two `.github` repositories, and would be an
      issue of its own.
- [ ] 11. **Moving.** Do the Area paragraphs move out of § The types into the new section, rather than stay with the
      section added beside them? Proposed: they move, so that issue-standards.md says it once.
- [ ] 12. **The every-open-issue-gets-an-Area task (#452).** Is it blocked by this task, since it applies these
      rulings to every open issue? Proposed: yes, the link added by the next script and read back.
