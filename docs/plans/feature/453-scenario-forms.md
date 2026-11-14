---
title: "Both accounts' Scenario forms ask for the end-user goal, how to walk it and the features it exercises"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/453
status: complete
created: 2026-11-14
updated: 2026-11-14
---

# Plan: Both accounts' Scenario forms ask for the end-user goal, how to walk it and the features it exercises

Step 40 of issue tracking, iteration 1 (#346). The Scenario form in each account's `.github` repository asks for the
story and an evidence of completion, the scenario as it was before the ruling of 2026-11-04. So do the Scenario issue
type's description in NobleFactor and the `scenario` label's in David-Noble-at-work. This brings the forms and the
descriptions to the ruling. Four pull requests, one at a time: NobleFactor/.github, David-Noble-at-work/.github, and
last this repository's, from `feature/453-scenario-forms`, which closes #453; the descriptions are written by
`star github model apply`, and `backup` lands each account's model in its `.github` repository.

## Rulings

- 2026-11-04, in #303's closing: a scenario is a high-level description of a feature, a workflow or a real-life
  situation that needs to be tested. Its Scenario issue summarizes an end-user goal, and includes an example for demos
  and ad-hoc testing; it names the features it exercises. It is kept as long as the product has it.
- 2026-11-04, on #453: a Scenario issue states no evidence of completion, since a scenario never ends, so each form
  asks for how to walk it, the example, where it asked for the evidence of completion.
- 2026-11-04, on #453: the descriptions keep the "Collection:" prefix every collection type's has.
- 2026-11-14, on this plan: approved, with the wording in plain spoken English, not the dense wording proposed;
  Requirements 1 and 2 give the wording used.

## Current State

Read on 2026-11-14:

| What | Where it stands |
| --- | --- |
| NobleFactor/.github's and David-Noble-at-work/.github's `scenario.yml` | The same but for the type, `Scenario`, or the label, `scenario`: "Describes a scenario: the story its features tell", asking for the Area, the story, the evidence of completion and the plan and design documents |
| NobleFactor's Scenario issue type | "Collection: describes a scenario, the story its features tell" |
| The `scenario` label in personal and David-Noble-at-work/.github | The same description |
| The extension's reference models, `organization.yaml` and `user.yaml` | The same description, and comments saying #453 will change it |
| The documents | About ten passages say the descriptions still read so, and that #453 will bring them to the ruling |

## Requirements

1. **The forms,** both: the Area, then three questions, each required, in place of the story and the evidence of
   completion, then the plan and design documents as now:
   - *What the person wants to do*: "Say it the way they would."
   - *How to walk through it*: "The steps, and what you should see. Use it for a demo or a quick test." It takes the
     place of evidence of completion, since a scenario never ends.
   - *The features it uses*: "List each one by its issue."

   The form's own description: "A scenario: what someone wants to do, how to walk through it, and the features it uses".
2. **The descriptions,** the type's and the label's, and the reference models': "Collection: what someone wants to do,
   how to walk through it, and the features it uses", 86 characters.
3. **Each account's model** written by `apply` from its own model, read by `get`, with that one description changed;
   `diff` then finds nothing; `backup` lands the model in the account's `.github` repository.
4. **The documents** that say the descriptions still read the old way, or that #453 will change them, say what they
   read.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | Each form, as YAML | Parses, by the `.github` repository's quality gate |
| 2 | `diff` of each account's model, the description changed, before `apply` | That one difference, and nothing else |
| 3 | `diff` after `apply` | Nothing |
| 4 | A test Scenario issue filed in each account with the body, type and label its form gives | Its sections, read back; then closed with Resolution Invalid, or `resolution:invalid` in David-Noble-at-work |
| 5 | `tests/Test-StarGitHub` and `make check` | Pass |

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/453-scenario-forms` by the worktree's first script, with the template's first-script step;
      reviewed with the owner, the wording ruled, on 2026-11-14

### Phase 2: the forms and the descriptions

- [x] NobleFactor/.github's form, merged; NobleFactor's Scenario type described by `apply`; `backup`
- [x] David-Noble-at-work/.github's form, merged; the `scenario` label described by `apply`; `backup`

### Phase 3: the evidence, the documents and the merge

- [x] The two test Scenario issues; the reference models and the documents; this pull request merged, closing #453 with
      its evidence, by the template's schedule step; step 40 Closed

## Files to Create/Modify

| Repository | File | Action |
| --- | --- | --- |
| NobleFactor/.github | `.github/ISSUE_TEMPLATE/scenario.yml` | Modify |
| David-Noble-at-work/.github | `.github/ISSUE_TEMPLATE/scenario.yml` | Modify |
| NobleFactor/.github, David-Noble-at-work/.github | `model.yaml` | Landed by `backup` |
| noblefactor-engprod | `reference/organization.yaml` and `reference/user.yaml` of the extension | Modify |
| noblefactor-engprod | The documents naming the old description or #453 | Modify |
| noblefactor-engprod | `docs/plans/feature/453-scenario-forms.md` | Create |

## Open Questions

- **The wording,** ruled 2026-11-14: plain spoken English, as Requirements 1 and 2 give it.
