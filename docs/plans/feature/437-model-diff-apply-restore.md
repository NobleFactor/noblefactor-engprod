---
title: "star github model diff, apply and restore"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/437
status: draft
created: 2026-11-10
updated: 2026-11-10
---

# Plan: star github model diff, apply and restore

## Summary

Step 22 of issue tracking, iteration 1 (#346). GitHub is the model (ruled 2026-11-09, #426): `get` reads an account's
model from GitHub and `backup` keeps a copy in the account's `.github` repository. This plan builds the writing side:
`diff` compares any model with an account's, `apply` makes it the account's, and `restore` applies a backup. Today an
account's model changes only by hand in GitHub, one setting at a time, and nothing can set up a new account from a
reference model or put an account back the way its backup recorded it.

## Issue 437

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 22 | Task | [#437](https://github.com/NobleFactor/noblefactor-engprod/issues/437), star github model diff, apply and restore | Its evidence of completion |

## Rulings

Ruled by the owner on 2026-11-09 and 2026-11-10, recorded in #437 and section 6's § GitHub is the model.

- **The commands, each naming its account, with no default account:**

  ```text
  star github model diff <model> <account>
  star github model apply <model> <account> [--prune]
  star github model restore <account> [<revision>] [--prune]
  ```

  `<model>` is a file, or `-` for standard input: a reference model, another account's model as `get` printed it, or a
  backup.
- **`apply` reconciles; it never deletes something to create it again.** It creates what is missing and changes what
  differs. On the same account it matches by ID, so a rename is a rename; across accounts the IDs differ, and it matches
  by name.
- **Nothing is deleted without `--prune`.** With it, `apply` and `restore` also delete what the model lacks, and first
  list each deletion and how many issues and rows it touches. Without it, `restore` puts back what changed or vanished,
  leaves what was added since the revision, and lists what it left.
- **Option IDs.** Every project and issue field option is sent with the ID the model holds, an issue field's through
  GitHub's REST call, so a changed option list blanks no issue or row.
- **Asking.** Interactive by default, star's `--unattended` skipping every question, no `--force`. For now nothing asks:
  a TODO linking NobleFactor/devlore-cli#1219 stands where each question belongs, and #470 tracks them.
- **The owner runs `apply` and `restore`.** A session writes the command and hands it over. After either, `backup`
  records the account's new model through its pull request.
- **`star github labels sync` is removed** once `apply` covers labels.

## Current State

Read on 2026-11-10 from `develop` at `1923a24` and from GitHub's GraphQL schema.

| Component | Status | Notes |
| --- | --- | --- |
| `get`, `backup` | ✅ | #426. The record holds each type's name, ID and level; each field's and option's name and ID; each label's name, color and description; each template's fields, options and views |
| `diff`, `apply`, `restore` | ❌ | |
| `star github labels audit`, `labels sync` | ⚠️ | Label-only, from `scheme.star`'s `label_inventory`, `canonical_labels`, `label_faults` and `label_sync` |
| The reference models | ⚠️ | `reference/organization.yaml` is `get`'s shape without IDs, with more in it: each type's color and description, each field's description, each option's color and description. `reference/user.yaml` names its labels as families, `areas`, `priorities`, `severities`, `efforts` and `resolutions`, rather than per repository |

What GitHub's API can write, read from its schema on 2026-11-10:

| Part of the model | Create, change, delete | What the API cannot do |
| --- | --- | --- |
| Issue types | `createIssueType`, `updateIssueType`, `deleteIssueType`: name, description, color, enabled | |
| Issue fields | `createIssueField`, `updateIssueField`, `deleteIssueField`: name, description, visibility, options | GraphQL takes no option IDs; the REST call `PATCH /orgs/{org}/issue-fields/{issue_field_id}` does (settled 2026-11-04) |
| Labels | REST, per repository: create, change (renaming with `new_name`), delete | |
| Project fields | `createProjectV2Field`, `updateProjectV2Field` (options with their IDs), `deleteProjectV2Field` | |
| Project views | `createProjectV2View`, `updateProjectV2View`, `deleteProjectV2View`: name, layout, filter, visible fields | A view's grouping and sort: no input takes them |
| Templates | `createProjectV2`, `copyProjectV2`, `markProjectV2AsTemplate` | |

## Decisions for review

The rulings settle the commands. These remain; each is my recommendation.

1. **`get` records everything `apply` writes.** Today's record lacks each type's description, color and enabled flag,
   each issue field's description and visibility, each option's color and description, and an iteration field's
   configuration. Without them `apply` could not restore what a backup never held. The record grows; each backup taken
   after this carries it; a backup taken before it, the two of 2026-11-10 among them, restores what it has and leaves
   the rest as it is, saying so.
2. **A model comes in either form.** `diff` and `apply` read `get`'s record or a reference model, and bring a reference
   to `get`'s form first: the user reference's label families become labels on each participating repository. A
   reference has no IDs, so against it everything matches by name.
3. **What a reference's labels mean** (an open question on #437). A reference names the labels every participating
   repository must have, and no others. So with a reference, `--prune` removes only labels of the reference's own kinds,
   a type label or an `area:`, `priority:`, `severity:`, `effort:` or `resolution:` label it does not list, and leaves a
   repository's other labels, `good first issue` among them. With a backup or another account's model, `--prune` removes
   whatever the model lacks.
4. **Views** (an open question on #437). `apply` writes a view's name, layout, filter and visible fields. Its grouping
   and sort cannot be written through GitHub's API, so `diff` reports a difference in them and `apply` lists each as a
   step to take by hand.
5. **Teams.** `apply` leaves teams and their repository roles alone; `diff` reports a difference. A team is people and
   permissions, set by an organization owner (section 6, § The asset, under `projects`).
6. **A missing template is made.** `apply` makes a template the account lacks, with its fields and views, and marks it a
   template; in a user account it makes the copy, by name. § Recovery counts on it.
7. **The projects made from templates stay out of it.** Section 6 and the organization reference say that keeping
   every project of a kind configured like its template rests on #437. That is a second job, over projects the model
   does not hold; I would file it as a task of its own, after this one.
8. **`restore` with no revision applies `main`'s backup** (an open question on #437).
9. **`star github labels audit` goes with `labels sync`:** `diff` against a reference reports what the audit did.
10. **One plan and one pull request,** as #426 was: `diff`, `apply` and `restore` share one comparison, and `restore` is
    `apply` of a file.

## Requirements

### Requirement 1: get records everything apply writes

- Decision 1's attributes in `get`'s record, read in the queries it already makes. `-o yaml` stays the same text every
  run.

### Requirement 2: diff

- `star github model diff <model> <account>` reads the model, brings a reference to `get`'s form, reads the account's
  model with `get`'s code, and returns one record for each difference: what it is (a type, a field, an option, a label,
  a template, a field of one, a view), its key, what is wrong (missing, different, renamed, or not in the model), what
  GitHub holds and what the model holds. A difference `apply` cannot make, a view's grouping or sort or a team, says
  so. Nothing is written. It exits 0 whether there are differences or none; an error alone fails it.

### Requirement 3: apply

- `star github model apply <model> <account> [--prune]` makes `diff`'s changes, in an order that keeps every reference
  whole: issue types, then issue fields and their options, then each participating repository's labels, then each
  template's fields, options and views, a missing template first made.
- Renames are made in place, matched by ID on the same account. Option lists are sent with their IDs. Deletions happen
  only with `--prune`, decision 3 limiting them against a reference, each first listed with how many issues and rows
  it touches.
- It returns a record of each change made, and of each it could not make, with the step to take by hand. A TODO
  linking NobleFactor/devlore-cli#1219 stands where it will ask, before any deletion and before it starts (#470). It
  refuses star's `--dry-run`, as `get` does, until NobleFactor/devlore-cli#1170: `diff` is the preview.

### Requirement 4: restore

- `star github model restore <account> [<revision>] [--prune]` reads `model.yaml` at the revision of
  `<account>/.github`, `main` when none is named, and applies it.

### Requirement 5: the label commands retired

- `star github labels sync` and `labels audit` removed, with the code in `scheme.star` only they use; `diff` and `apply`
  replace them.

### Requirement 6: the issues and the documents

- Section 6 and its status, sections 4 and 5, the index, `docs/issue-standards.md` and the README brought to the
  commands as built; #437 closed by the pull request; decision 7's task filed.

## Implementation Phases

### Phase 1: the plan

- [ ] Written, committed on `feature/437-model-diff-apply-restore`, and reviewed with the owner

### Phase 2: the test, first

- [ ] Test-StarGitHub's stand-in `gh` answers the write calls and records them; the test plan's cases written, failing
      against the extension as it is

### Phase 3: get records everything apply writes

- [ ] Requirement 1; every case of it passes; `make check` passes

### Phase 4: diff

- [ ] Requirement 2

### Phase 5: apply, and restore

- [ ] Requirements 3 and 4; every case passes; `make check` passes

### Phase 6: the label commands retired

- [ ] Requirement 5

### Phase 7: the issues and the documents

- [ ] Requirement 6

### Phase 8: proved on GitHub

- [ ] For NobleFactor and David-Noble-at-work, on the branch's extension: `diff` of the account's fresh backup, showing
      nothing to change, and of its reference, showing what differs; an `apply` of a model changed for the purpose,
      then `diff` showing nothing left; a label renamed through `apply`, the issues that carried it keeping it;
      `restore` to the revision before, without `--prune` and then with it; `backup` afterward; a comment on #437 shows
      each. The owner runs every `apply` and `restore`

### Phase 9: merge

- [ ] The pull request script written, shown and handed over; it closes #437

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `get` | Each type's description, color and enabled flag; each field's description and visibility; each option's color and description |
| 2 | `diff` of the account's own model | No differences, exit 0 |
| 3 | `diff` of a model with a type, a label and an option added, changed and removed | One record each: missing, different, not in the model |
| 4 | `diff` of a model renaming a label and an option, same account | Renamed, by ID |
| 5 | `diff` of another account's model | Matched by name; every ID ignored |
| 6 | `diff` of the user reference | Its families as labels on each participating repository |
| 7 | `diff` of a view whose grouping differs | A difference `apply` cannot make, so marked |
| 8 | `apply`, case 3's model | The creates and changes made; the removal not made, listed; the record of each |
| 9 | `apply --prune`, case 3's model | The removal made too, after the count of what it touches |
| 10 | `apply --prune` of a reference | Only labels of the reference's kinds removed; `good first issue` kept |
| 11 | `apply` renaming an option | The option list sent with every ID |
| 12 | `apply` of a model with a template the account lacks | The template made, its fields and views, marked a template |
| 13 | `apply` under `--dry-run` | Refused, naming NobleFactor/devlore-cli#1170; nothing written |
| 14 | `restore NobleFactor`, and `restore NobleFactor <revision>` | `main`'s `model.yaml`, then the revision's, applied |
| 15 | `labels sync`, `labels audit` | Unknown commands |
| 16 | Every existing case | Passes |

## Files to Create/Modify

Under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/437-model-diff-apply-restore.md` | Create | This plan |
| `commands/reconcile.star` | Create | Bringing a reference to `get`'s form, the comparison `diff`, `apply` and `restore` share, and the writes |
| `commands/github-model-diff.star`, `commands/github-model-apply.star`, `commands/github-model-restore.star` | Create | Requirements 2 to 4 |
| `commands/model.star` | Modify | Requirement 1 |
| `commands/scheme.star`, `commands/github-labels-audit.star`, `commands/github-labels-sync.star` | Modify, remove | Requirement 5 |
| `extension.yaml` | Modify | The three commands; the label commands gone |
| `tests/Test-StarGitHub` | Modify | The test plan |
| `docs/architecture/issue-data-model/`, `docs/issue-standards.md`, `README.md` | Modify | Requirement 6 |

## Related Documents

- [Section 6, § GitHub is the model](../../architecture/issue-data-model/6-the-asset-and-its-sync.md#github-is-the-model),
  § Risk and § Recovery
- [#426's plan](426-model-pull-to-dot-github.md): `get` and `backup`
- #470: the questions the commands will ask; NobleFactor/devlore-cli#1219, devlore's TUI
- NobleFactor/devlore-cli#1170: star's `--dry-run` reading

## Open Questions

The decisions for review.
