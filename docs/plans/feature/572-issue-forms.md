---
title: "Each issue form asks for the sections the issue standard gives its type"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/572
status: draft
created: 2026-11-15
updated: 2026-11-15
documents:
  - kind: "Design: issue standards"
    path: "docs/issue-standards.md"
  - kind: "Design: the schedule commands"
    path: "docs/architecture/issue-data-model/8-the-schedule-commands.md"
    text: "section 8, § new"
---

# Plan: Each issue form asks for the sections the issue standard gives its type

Step 47 of issue tracking, iteration 1 (#346). Each account's `.github` repository holds six issue forms. The Task and
Bug forms ask for "What" and "What happens", where the shape ruled on 2026-11-06 asks for the problem, the solution if
known, the outstanding questions and the evidence of completion. This brings the forms to the standard, and first puts
in the standard what each type's issue says, which it does not say today. Step 48, #338, builds `star github issue
file`, which checks a body against its type's form, and waits on this.

Three pull requests, one at a time: NobleFactor/.github's forms, then David-Noble-at-work/.github's, each from a branch
named `feature/572-issue-forms`, and last this repository's, from the same branch, which carries this plan and the
standard and closes #572. The issue was NobleFactor/.github#2 until 2026-11-15, when it moved here to be designed and
planned beside the standard, as #431, #448 and #453 were.

## Rulings

- 2026-11-02: every issue states its evidence of completion; for a Schedule issue, that is its exit criteria.
- 2026-11-04: every issue but a Scenario issue states it, in a section headed Evidence of completion.
- 2026-11-06, on NobleFactor/devlore-cli#477: a task or a bug states its problem, the solution if known, its outstanding
  questions and its evidence of completion. Tasks and bugs deliver no feature; features do.
- 2026-11-14, #453: the Scenario form asks what the person wants to do, how to walk through it and the features it uses.
- 2026-11-15: the forms are the one place that says what a type's body holds, and `star github issue file` (#338) reads
  them when it runs. The standard states each type's sections, and the forms follow it.
- 2026-11-15: NobleFactor/.github#2 moves to this repository, as #572, and goes on #346 as step 47, before #338.

## Why the forms and the standard came apart

The 2026-11-06 ruling went into an agent's memory and into an issue, NobleFactor/.github#2, but not into the standard.
`docs/issue-standards.md` names no type's sections. On 2026-11-09 both accounts' forms were rewritten to add the
documents table, by #431 and #441, and kept "What", since nothing they read said otherwise. With each type's sections in
the standard, a change to a form has something to be checked against.

## Current State

Read on 2026-11-15, from NobleFactor/.github and David-Noble-at-work/.github, whose forms match but for the type: the
`type` key in NobleFactor, the type label in David-Noble-at-work. Each form starts with a required Area dropdown,
Product or Engineering. A starred section is required.

| Form | Its sections after the Area |
| --- | --- |
| Task | What\*: "The work, and the feature it delivers"; Evidence of completion\*; Plan and design documents\* |
| Bug | What happens\*: "What goes wrong, how to make it happen, and what should happen instead"; Evidence of completion\*; Plan and design documents\* |
| Feature | What\*: "The capability, and the epic it belongs to"; Evidence of completion\*; Plan and design documents\* |
| Epic | What\*: "The body of work, and who owns it"; Evidence of completion\*; Plan and design documents\* |
| Schedule | Deliverable\*; Exit criteria\*; Evidence of completion\*; Plan and design documents\* |
| Scenario | What the person wants to do\*; How to walk through it\*; The features it uses\*; Plan and design documents\* |

Every form's documents table starts `| Document | Link |`, where development-process.md § Plans gives
`| Kind | Document |`.

## Requirements

1. **The standard.** `docs/issue-standards.md` gets a section, § What an issue says, with a table of each type's
   sections in order, which are required, and the ruling behind each. The forms follow it, and #338 reads the forms.
2. **The Task and Bug forms,** both accounts: the Area, then
   - *Problem*: for a task, "What is wrong or missing, said plainly"; for a bug, "What goes wrong, how to make it
     happen, and what should happen instead";
   - *Solution, if known*: "A summary. Say where it is unproven.";
   - *Outstanding questions*: "What still has to be answered.";
   - *Evidence of completion*: "What will be true when this is done, shown in a comment before it closes. For work
     that changes code, a run that shows it working and a test that fails if it breaks again.";
   - *Plan and design documents*, as now.

   GitHub writes each section as a `### ` heading with the field's label, so a body filed from the form has the
   headings the ruled shape has, `### Problem` through `### Evidence of completion`, as #338's own body does.
3. **The Feature, Epic and Schedule forms,** as ruled in review: see Open Questions 2 to 4.
4. **The Scenario form** keeps its sections, ruled on #453.
5. **Every form's documents table** starts `| Kind | Document |`, with its Plan row "Not yet opened", as
   development-process.md § Plans requires.
6. **The documents** that describe the forms say what they now ask: issue-standards.md's filing table and § Evidence of
   completion, and section 8's Schedule issue body if the Schedule form changes.

Nothing else changes. Issues already filed keep their bodies: a form governs filing, and the sweep checks only the
Evidence of completion section, which every form but the Scenario form keeps.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | Each form, as YAML | Parses, by each `.github` repository's quality gate |
| 2 | Each form read back from GitHub after its merge | Its sections, their descriptions and which are required, as Requirements 2 to 5 give them |
| 3 | Each changed form's new-issue page, opened by the owner from the links in #572's evidence | The form, with no error from GitHub |
| 4 | A test Task issue in each account, filed with the body its form gives | Its sections read back; then closed with Resolution Invalid, or `resolution:invalid` in David-Noble-at-work, as #453's were |
| 5 | `make check` in this repository | Passes |

## Implementation Phases

### Phase 1: the plan

- [ ] Committed on `feature/572-issue-forms` by the worktree's first script, with the template's first-script step;
      reviewed with the owner, and Open Questions ruled

### Phase 2: the standard

- [ ] § What an issue says in `docs/issue-standards.md`, committed on this branch before either form changes, so the
      ruling leads the forms

### Phase 3: the forms

- [ ] NobleFactor/.github's six forms, merged, and read back
- [ ] David-Noble-at-work/.github's six forms, merged, and read back

### Phase 4: the evidence, the documents and the merge

- [ ] The two test issues; the evidence comment on #572 with each form's sections and its new-issue link; the
      documents; this pull request merged, closing #572, by the template's schedule step; step 47 Closed

## Files to Create/Modify

| Repository | File | Action |
| --- | --- | --- |
| NobleFactor/.github | `.github/ISSUE_TEMPLATE/{task,bug,feature,epic,schedule,scenario}.yml` | Modify |
| David-Noble-at-work/.github | `.github/ISSUE_TEMPLATE/{task,bug,feature,epic,schedule,scenario}.yml` | Modify |
| noblefactor-engprod | `docs/issue-standards.md` | Modify |
| noblefactor-engprod | `docs/architecture/issue-data-model/8-the-schedule-commands.md` | Modify, if the Schedule form changes |
| noblefactor-engprod | `docs/plans/feature/572-issue-forms.md` | Create |

## Open Questions

1. **Which Task and Bug sections are required.** Proposed: Problem and Evidence of completion. Solution, if known, and
   Outstanding questions are optional, since the first may not be known and the second may have nothing in it; GitHub
   writes "_No response_" under a section left empty.
2. **The Feature form.** Proposed: rename *What* to *What it delivers*, "The capability, and the epic it belongs to",
   since a feature is what delivers; Evidence of completion and the documents as now.
3. **The Epic form.** Proposed: rename *What* to *What it owns*, "The body of work, who owns it, and the features it
   breaks into"; Evidence of completion, "It closes when its features do: what will show they have", and the documents.
4. **The Schedule form.** It asks for Exit criteria and Evidence of completion, and the standard says they are the same
   thing. Proposed: one section, *Evidence of completion*, described as "The exit criteria: how we'll know it's
   finished", and *Deliverable* described as "What the owner has today, and what they'll have when the last step
   closes", the standard's before and after. Section 8's `schedule new`, not yet built, then drops `--exit-criteria`,
   and the Schedule issues already filed keep the bodies they have.
