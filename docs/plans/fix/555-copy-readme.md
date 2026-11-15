---
title: "star github model diff and apply leave a team copy's readme behind its template's"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/555
status: complete
created: 2026-11-14
updated: 2026-11-14
---

# Plan: star github model diff and apply leave a team copy's readme behind its template's

Step 42 of issue tracking, iteration 1 (#346), found while working #554. `diff` and `apply` hold each team's copy of a
template to the template's fields, options and views, but not to its readme or its short description. So when the
Scenario template's readme changed, the copies kept the old one and nothing said so. This fixes both, in the pull
request from `feature/554-scenario-readme` that closes #554 and #555.

## Rulings

- 2026-11-14: fixed in #554's pull request, since it had not opened yet.
- 2026-11-14: the reference names each copy's short description too, so `diff` and `apply` hold it like the readme.
- 2026-11-14, on this plan: approved as written.

## Current State

Read on 2026-11-14:

| What | Where it stands |
| --- | --- |
| `diff`, in `commands/reconcile.star` | A template's short description, readme and public flag are compared; a team copy's fields, options and views alone (`_project`) |
| `apply`, in `commands/apply.star` | `_attributes` writes a template's readme and short description; `_kind_projects` brings a copy's fields and views to its template's, and a copy it makes keeps the template's own short description |
| An account's model, from `get` | Each template's own short description and readme; nothing about what a copy's short description says |
| The copies' short descriptions | Set by hand: "<team>'s Triage project: the team's queue of issues waiting to be classified." ("the account's" in David-Noble-at-work), "<team>'s Backlog project: its accepted work not yet scheduled", "<team>'s Schedule project: its committed tasks and bugs", and "<team>'s Scenario project: its features", from before the ruling of 2026-11-04 |
| The copies' readmes | NobleFactor's two Scenario copies set by hand on 2026-11-14 by #554; Scenario: David-Noble-at-work still has the old one |

## Requirements

1. **A copy's readme** is its template's. `diff` reports a copy whose readme isn't, as `project <name> different`, and
   `apply` sets it.
2. **A copy's short description** is named on each template, in the model and the references, as
   `copy_short_description`, with `{owner}` standing for the team, or the account in a user account:
   - In the references, `organization.yaml` and `user.yaml`, the texts the copies have now, but the Scenario one:
     "{owner}'s Scenario project: its Scenario issues and the tasks and bugs found while walking them".
   - `get` reads it from the account's copies: the text most of a template's copies share, with the owner's name as
     `{owner}`; a tie goes to the oldest copy. A template with no copy records an empty text, as `get` records any
     text GitHub holds none of, so that `apply` and a later `diff` agree. `backup` records it with the rest of the model.
   - `diff` reports a copy whose short description isn't it, with its owner filled in, and `apply` sets it.
3. **A copy `apply` makes** gets its template's readme and its own short description, not the template's.
4. **The extension's files stay where they are:** the fix goes in files that already exist, since `star` reads each
   through a link writ made, and a new one has none until writ deploys.
5. **The documents** that say what a copy is held to,
   [section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) and its status, say it now includes the
   readme and the short description.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `diff`, a copy's readme not its template's | `project <name> different` |
| 2 | `diff`, a copy's short description not its template's `copy_short_description`, owner filled in | `project <name> different` |
| 3 | `apply` on both | The readme and the short description written, and `diff` then finds nothing |
| 4 | `get`, copies agreeing; copies split two to one | `copy_short_description` with `{owner}`; the two's text |
| 5 | `apply` making a missing copy | The copy has its template's readme and its own short description |
| 6 | Cases 1 to 5 with the change taken out | Each fails |
| 7 | `tests/Test-StarGitHub` and `make check` | Pass |
| 8 | Live, after the merge: `diff` of each account's own model, unchanged | David-Noble-at-work: Scenario: David-Noble-at-work, its readme; NobleFactor: nothing |
| 9 | Live: each account's model with the new Scenario `copy_short_description`, applied; `diff` again | Every Scenario copy's short description and readme new; then nothing; `backup` records each model |

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/554-scenario-readme`, with the template's first-script step for #555; reviewed with the
      owner and approved on 2026-11-14

### Phase 2: the fix

- [x] `diff`, `apply` and `get`, the references and the documents; cases 1 to 7

### Phase 3: the merge and the live run

- [x] The pull request merged, closing #554 and #555; cases 8 and 9 run on both accounts with the code merged; #555's
      evidence; step 42 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `commands/reconcile.star`, `commands/apply.star`, `commands/model.star` of the extension | Modify |
| `reference/organization.yaml` and `reference/user.yaml` of the extension | Modify |
| `tests/Test-StarGitHub` | Modify |
| `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md` and its status | Modify |
| `docs/plans/fix/555-copy-readme.md` | Create |

## Open Questions

None.
