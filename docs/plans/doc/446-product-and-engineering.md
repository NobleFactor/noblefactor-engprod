---
title: "docs/issue-standards.md gets a section that defines product and engineering issues and puts test bugs in engineering"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/446
status: approved
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

- 2026-11-03, in conversation rather than on #303: governance and process issues take an Area, and release notes come
  from the closed product issues in a release.
- 2026-11-05, on this plan's open questions 1 to 12: what a product is, what engineering work is, governance and process
  issues, release notes, personal repositories, documentation, tests, collections and epics, the reference models, the
  stale pointer and the two values' definitions, each recorded under Open Questions below. An epic never holds both
  kinds, superseding the ruling of 2026-11-03 that a product epic can hold an engineering feature and that epics for
  product readiness and for release management hold both kinds.

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

- **The definitions of the two values,** ruled 2026-11-05 and stated in full: `area:product`, "Tags issues representing
  user-facing features, capabilities, or functional components that are packaged and released from this repository.";
  and `area:engineering`, "Tags issues representing durable design artifacts, technical specs, internal infrastructure,
  testing, and the iterative execution of development plans." (Open Question 10).
- **Area and its two values,** ruled 2026-11-03: the options Product and Engineering of the Area issue field in
  NobleFactor, and the labels `area:product` and `area:engineering` in a user account. Every issue has one, and a blank
  Area is an error (§ What has no parent).
- **What a product is:** any deliverable released from a repository, typically an open-source product or an internal
  tool. DevLore, open source, releases from devlore-cli, devlore-registry and devlore.noblefactor.com; the engineering
  materials, policies, process, tooling and standards, and the tooling, star extensions and more, release from
  noblefactor-engprod, and are internal. Both are products. Governance and process issues are products of the
  engineering productivity team, documentation that releases with a product is product, and no `area:product` is
  expected in a personal repository, which exists only for personal productivity (Open Questions 1, 3, 4 and 5).
- **What engineering work covers:** work on things outside the deliverables a repository releases, the work that
  doesn't ship: build orchestration, Makefile changes, CI pipelines, tests, tools that don't release with a product,
  design work, planning work, and documentation that doesn't release with a product (Open Questions 2, 5 and 6).
- **An issue's Area describes its own work, not its parent's:** an epic, a feature and the tasks and bugs under them
  can each differ, and a CI bug fixed during a product feature is engineering.
- **A bug in a test is an engineering issue, not a product issue,** ruled 2026-11-04, as the Test-ClearClaude bug
  (#445) is.
- **Scenarios, schedules and epics:** a scenario represents demo and test artifacts, so every scenario is engineering.
  A schedule describes deliverables with exit criteria, and its Area is the nature of its deliverables: most are
  product, some engineering. An epic never holds both kinds, and one that does is poorly built (Open Question 7).
- **Release notes** come from the closed product issues in a release, not from the hierarchy. They are themselves a
  product output, though the release manager's work on them is largely engineering, so a bug in the release notes is a
  product bug (Open Question 3).
- **devlore-cli's seven finer Area labels** were deleted on 2026-11-03, and the hierarchy carries their distinctions:
  the paragraph at lines 102-105, moved here (Open Question 11).

§ The types keeps its level table and its paragraph on features, which say a feature is for the product or for
engineering; that paragraph points to the new section in the document's own form, "(§ Product and engineering)". Lines
607 and 748 point to it too, in place of "(§ The types)".

### Requirement 2: The seven places in the issue data model

Each replaces its list sentence with one sentence that points to the new section, and keeps the rest of its paragraph
but for the sentence that epics for product readiness and for release management hold both kinds, which goes (Open
Question 7):
what product work and engineering work each cover, tests among engineering's, is in
`[issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering)`. Section 7's table
row at line 36 then sends the reader there. The status files of the six sections that change, 1, 2, 3, 4, 5 and 7,
each record the change with its date; section 2's, where Area's rulings are recorded, also records the ruling of
2026-11-04. The stale pointer at 1-hierarchy.md:62 points to the new section too (Open Question 9).

### Requirement 3: The reference models

The comments at organization.yaml:74-75 and user.yaml:86-87 replace the list with a pointer in the models' own form, a
bare path in parentheses, with the section's name added: "(docs/issue-standards.md, § Product and engineering)" (Open
Question 8).

The Area options' and the `area:` labels' descriptions become the two definitions, cut to fit GitHub's limit of 100
characters for a label's description. The options take the same text, since the model describes each label as its option
is: Product and `area:product`, "User-facing features, capabilities, or functional components released from this
repository" (90 characters); Engineering and `area:engineering`, "Design artifacts, technical specs, internal
infrastructure, testing, and executing development plans" (100). They change in both reference models, and in GitHub by
this pull request's script, read back: NobleFactor's Area field through REST, sending each option with its ID, and the
labels in personal and David-Noble-at-work/.github (Open Question 10).

### Requirement 4: The gate

`make check`, the gate `ci.yaml` runs, passes before each commit.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed and pushed on `doc/446-product-and-engineering` by the worktree's first script,
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

All twelve questions are ruled.

- [x] 1. **What a product is.** Ruled 2026-11-05: any deliverable released from a repository, typically an
      open-source product or an internal tool. Two sets release today, and both are products: DevLore, open source,
      from devlore-cli, devlore-registry and devlore.noblefactor.com; and the engineering materials, policies, process,
      tooling and standards, and the tooling, star extensions and more, that release from noblefactor-engprod, which
      are internal.
- [x] 2. **Is all the work of a repository such as noblefactor-engprod engineering?** No. Ruled 2026-11-05:
      engineering is work on things outside the deliverables a repository releases, the work that doesn't ship;
      noblefactor-engprod's deliverables are products (question 1).
- [x] 3. **Governance and process issues, and release notes.** Ruled 2026-11-05: governance and process issues are
      deliverables of noblefactor-engprod, products of the engineering productivity team. Release notes are product
      outputs, though the release manager's work on them is largely engineering, so a bug in the release notes is a
      product bug.
- [x] 4. **A personal repository.** Ruled 2026-11-05: a personal repository exists only for personal productivity, and
      no `area:product` label is expected in one.
- [x] 5. **Documentation.** Ruled 2026-11-05: documentation that releases with a product is product, and all other
      documentation is engineering. Design work and planning work are engineering, and so is work on the build or on
      tools that don't release with a product.
- [x] 6. **Tests.** Ruled 2026-11-04: test bugs are engineering issues, not product issues, and the section approved
      that day names tests in engineering's list.
- [x] 7. **Scenarios, schedules and epics.** Ruled 2026-11-05: a scenario represents demo and test artifacts, so every
      scenario is `area:engineering`. A schedule describes deliverables with exit criteria, and whether it is product or
      engineering is the nature of its deliverables; most will be product deliverables, and some engineering. An epic
      never contains both kinds; one that does is poorly constructed.
- [x] 8. **The reference models.** Approved 2026-11-05: their comments point to the new section in place of the list.
- [x] 9. **The stale pointer at 1-hierarchy.md:62,** to the retired § The Ops axis. Approved 2026-11-05: fixed in this
      pull request, pointing to the new section.
- [x] 10. **The descriptions.** Ruled 2026-11-05, as GitHub's conventions have it: `area:product` is "Tags issues
      representing user-facing features, capabilities, or functional components that are packaged and released from this
      repository."; `area:engineering` is "Tags issues representing durable design artifacts, technical specs, internal
      infrastructure, testing, and the iterative execution of development plans." A label's description must be 100
      characters or fewer (GitHub's REST reference for labels), so the labels and the Area options carry each cut to fit
      (Requirement 3), and the new section states them in full (Requirement 1).
- [x] 11. **Moving.** Approved 2026-11-05: the Area paragraphs move out of § The types into the new section, a section
      of its own, and the repeated paragraphs link to it instead of restating it.
- [x] 12. **The every-open-issue-gets-an-Area task (#452).** Approved 2026-11-05: it is blocked by this task, and the
      link is added by this worktree's next script and read back.
