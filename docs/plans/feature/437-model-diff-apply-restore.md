---
title: "star github model diff, apply and restore"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/437
status: active
created: 2026-11-10
updated: 2026-11-10
---

# Plan: star github model diff, apply and restore

## Summary

Step 22 of issue tracking, iteration 1 (#346). GitHub is the model (ruled 2026-11-09, #426): `get` reads an account's
model from GitHub and `backup` keeps a copy in the account's `.github` repository. This plan builds the writing side:
`diff` compares any model with an account's, `apply` makes it the account's, and `restore` applies a backup. `apply`
holds every project of a kind to its template, and brings a new account into the model, its teams' projects, its
`.github` repository and its repositories' Triage workflows with it. The label commands, which still enforce the scheme
retired on 2026-11-03, go first. The owner, 2026-11-10: all of it in this pull request.

## Issue 437

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 22 | Task | [#437](https://github.com/NobleFactor/noblefactor-engprod/issues/437), star github model diff, apply and restore | Its evidence of completion, rewritten to this plan in Phase 12 |

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
- **Every project of a kind is configured like its template** (ruled 2026-11-03), and keeping them so rests on this
  issue (section 6; `reference/organization.yaml`).
- **All of it in one pull request** (2026-11-10): the projects of each kind, a new account joining, and the label
  commands retired.

## Current State

Read on 2026-11-10 from `develop` at `1923a24`, from GitHub's GraphQL schema, and from both accounts.

| Component | Status | Notes |
| --- | --- | --- |
| `get`, `backup` | ⚠️ | #426. They work for NobleFactor and David-Noble-at-work alone: `get` reads an organization's labels from `<org>/noblefactor-engprod`, a hub hard-coded since #377, and stops on any read that does not answer 200. The record lacks each type's description, color and enabled flag, each issue field's description and visibility, and each option's color and description |
| `diff`, `apply`, `restore` | ❌ | |
| `star github labels audit`, `labels sync` | ❌ | They require NobleFactor's type names as labels and `Epic:Ops:Process` in every participating repository: the scheme retired on 2026-11-03. Run on 2026-11-10, the audit reports `epic`, `feature`, `task` and `bug` missing in NobleFactor/devlore-cli and NobleFactor/noblefactor-engprod, so `labels sync` would put the retired labels back |
| The templates | ✅ | One set in both accounts, Triage, Backlog, Schedule and Scenario, with the same fields, options and views. NobleFactor's add the Area issue field to Triage, and the Priority issue field and a By priority view to Backlog, which a user account, having no issue fields, cannot |
| The reference models | ⚠️ | Each writes the four templates out, the two identical, listing no views. `reference/organization.yaml` is `get`'s shape without IDs, with more in it: each type's color and description, each field's description, each option's color and description. `reference/user.yaml` names its labels as families, `areas`, `priorities`, `severities`, `efforts` and `resolutions`, rather than per repository |
| The projects made from templates | ⚠️ | Each team's four in NobleFactor, the account's four in David-Noble-at-work; configured by hand on 2026-11-03 and by #303's closing script, nothing keeping them so. Each Schedule project's Schedule field holds one option per schedule, the template a placeholder: Schedule: engprod 4, Schedule: devlore 5 |
| A new account | ❌ | Brought in by hand: #431 and #441 made each `.github` repository's files, and personal#315 and #323 its Triage workflow, variable and secret |

What GitHub's API can write, read from its schema on 2026-11-10:

| Part of the model | Create, change, delete | What the API cannot do |
| --- | --- | --- |
| Issue types | `createIssueType`, `updateIssueType`, `deleteIssueType`: name, description, color, enabled | |
| Issue fields | `createIssueField`, `updateIssueField`, `deleteIssueField`: name, description, visibility, options | GraphQL takes no option IDs; the REST call `PATCH /orgs/{org}/issue-fields/{issue_field_id}` does (settled 2026-11-04) |
| Labels | REST, per repository: create, change (renaming with `new_name`), delete | |
| Project fields | `createProjectV2Field`, `updateProjectV2Field` (options with their IDs), `deleteProjectV2Field`; an issue field on a project, `createProjectV2IssueField` | |
| Project views | `createProjectV2View`, `updateProjectV2View`, `deleteProjectV2View`: name, layout, filter, visible fields | A view's grouping and sort: no input takes them |
| Templates and their copies | `createProjectV2`, `markProjectV2AsTemplate`, `copyProjectV2`, `linkProjectV2ToTeam`, `updateProjectV2Collaborators` (a team's role) | |
| A repository's workflow, variable, secret | REST: contents, `actions/variables`, `actions/secrets` | A secret's value is never read back |

## Decisions for review

The rulings settle the commands and the scope. The owner approved these on 2026-11-10, with the plan.

1. **`get` records everything `apply` writes:** each type's description, color and enabled flag, each issue field's
   description and visibility, each option's color and description, and an iteration field's configuration. A backup
   taken before this, the two of 2026-11-10 among them, restores what it has and leaves the rest as it is, saying so.
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
   permissions, set by an organization owner; the teams an account has decide which of its repositories take part.
6. **A missing template is made:** with its fields and views, marked a template; in a user account the copy, by name.
7. **Every project of a kind is held to its template.** The model holds the templates alone (ruled 2026-11-03); `diff`
   and `apply` read alongside them each team's four projects, `<Kind>: <team>`, or the user account's four,
   `<Kind>: <account>`.
   - A missing one is copied from its template, and in an organization linked to its team with the team's write role
     (ruled 2026-11-04).
   - Each is configured like its template: the same fields, options, colors and descriptions, and the same views, their
     grouping and sort listed as steps by hand.
   - What is the project's own is left alone: its rows and their values, its Schedule or Scenario field's options, one
     per schedule or scenario, and its Iteration field's iterations.
   - A copy's fields and options have IDs of their own, so they match the template's by name; a template option renamed
     by ID is renamed on each copy under its old name, every row keeping its value.
   - No project is ever deleted, even with `--prune`; with it, a field or view a project has and its template lacks is
     removed, after saying how many rows hold a value in it. A project of no kind is outside the model.
8. **`restore` with no revision applies `main`'s backup** (an open question on #437).
9. **`star github labels audit` goes with `labels sync`:** `diff` against a reference reports what the audit did.
10. **One plan and one pull request.**
11. **`get` reads any account.** No hub: an organization's labels are those of each repository a team maintains, as a
    user account's are those of each repository carrying the topic issue-model. NobleFactor's backup then holds the
    labels of every repository its teams maintain, not noblefactor-engprod's alone.
12. **A new account joins through `apply`.** Beyond the model, an account needs its `.github` repository's files and
    each participating repository's Triage workflow, with the `TRIAGE_PROJECT_URL` variable naming its team's Triage
    project and an `ADD_TO_PROJECT_PAT` secret. `apply` writes what is missing of them: the `.github` repository's files
    from the account the reference is kept for, as its `.github` repository stands, NobleFactor/.github for an
    organization and David-Noble-at-work/.github for a user account, through a pull request as `backup` lands one; each
    repository's workflow through a pull request in it; the variable directly. The secret's value comes from the
    account's Key Vault (the owner's conventions: `kv-nf-<team>-<env>`, `kv-david-noble-at-work`, secret
    `<repository>--ADD-TO-PROJECT-PAT`); with none there, `apply` names the secret to set and goes on.
13. **The label commands go first,** before any other change on the branch: until they go, `labels sync` puts the
    retired type labels back.
14. **The templates are defined once,** in `reference/templates.yaml`, with their fields, options and views. The
    organization reference adds only what issue fields bring, the Area field to Triage and the Priority field and the
    By priority view to Backlog; `diff` and `apply` build each account's templates from the common set and its kind's
    additions.

## Requirements

### Requirement 1: get reads any account, and records everything apply writes

- Decisions 1 and 11. `-o yaml` stays the same text every run.

### Requirement 2: the references

- Decision 14: `reference/templates.yaml`, and the two references naming only their kind's additions; the views the
  accounts hold, read on 2026-11-10, written into the common set.

### Requirement 3: diff

- `star github model diff <model> <account>` reads the model, brings a reference to `get`'s form, reads the account's
  model with `get`'s code and its projects of each kind, and returns one record for each difference: what it is (a
  type, a field, an option, a label, a template, a project of a kind, a field or view of one, a `.github` file, a
  repository's workflow or variable), its key, what is wrong (missing, different, renamed, or not in the model), what
  GitHub holds and what the model holds. A difference `apply` cannot make, a view's grouping or sort or a team, says so.
  Nothing is written. It exits 0 whether there are differences or none; an error alone fails it.

### Requirement 4: apply

- `star github model apply <model> <account> [--prune]` makes `diff`'s changes, in an order that keeps every reference
  whole: issue types; issue fields and their options; each participating repository's labels; the templates, a missing
  one first made; each project of a kind, a missing one first copied and linked; the `.github` repository's files; each
  participating repository's workflow, variable and secret.
- Renames are made in place, matched by ID on the same account. Option lists are sent with their IDs. Deletions happen
  only with `--prune`, decisions 3 and 7 limiting them, each first listed with how many issues and rows it touches.
- It returns a record of each change made, and of each it could not make, with the step to take by hand. A TODO
  linking NobleFactor/devlore-cli#1219 stands where it will ask, before any deletion and before it starts (#470). It
  refuses star's `--dry-run`, as `get` does, until NobleFactor/devlore-cli#1170: `diff` is the preview.

### Requirement 5: restore

- `star github model restore <account> [<revision>] [--prune]` reads `model.yaml` at the revision of
  `<account>/.github`, `main` when none is named, and applies it.

### Requirement 6: the label commands retired

- Decision 13: `star github labels sync` and `labels audit` removed, with the code in `scheme.star` only they use.

### Requirement 7: the issues and the documents

- Section 6 and its status, sections 3, 4 and 5, the index, `docs/issue-standards.md` and the README brought to the
  commands as built; #437's evidence of completion rewritten to this plan; #437 closed by the pull request.

## Implementation Phases

### Phase 1: the plan

- [x] Written, committed on `feature/437-model-diff-apply-restore`, and reviewed with the owner: approved 2026-11-10,
      with the two open questions answered

### Phase 2: the label commands retired

- [x] Requirement 6, the test first: `labels sync` and `labels audit` are unknown commands; `make check` passes.
      Case 12 failed first, all four commands answering; then the two command files went with `git rm`, the four
      manifest entries with them, the names before #378 being the label commands alone, and `scheme.star`'s label
      code, `cell`, `resolve_repos`, `_origin_repo` and the `ORIGIN` and `default_account` bindings, which only they
      used. All 60 cases pass

### Phase 3: the test, first

- [ ] Test-StarGitHub's stand-in `gh` answers the write calls and records them, and serves an organization other than
      NobleFactor; the test plan's cases written, failing against the extension as it is

### Phase 4: get reads any account, and records everything apply writes; the references

- [ ] Requirements 1 and 2; every case of them passes; `make check` passes

### Phase 5: diff

- [ ] Requirement 3

### Phase 6: apply, account-wide

- [ ] Requirement 4's issue types, issue fields, labels and templates

### Phase 7: apply, the projects of each kind

- [ ] Requirement 4's projects of each kind

### Phase 8: apply, a new account; and restore

- [ ] Requirement 4's `.github` files, workflows, variables and secrets, and Requirement 5; every case passes;
      `make check` passes

### Phase 9: the issues and the documents

- [ ] Requirement 7

### Phase 10: proved on GitHub

- [ ] For NobleFactor and David-Noble-at-work, on the branch's extension: `diff` of the account's fresh backup, showing
      nothing to change, and of its reference, showing what differs; a team project's field changed by hand and brought
      back; an `apply` of a model changed for the purpose, then `diff` showing nothing left; a label renamed through
      `apply`, the issues that carried it keeping it; `restore` to the revision before, without `--prune` and then with
      it; `backup` afterward. For a new organization: `apply` of the reference, then `diff` showing nothing left, in a
      temporary organization made for the proof, deleted when the proof passes and kept for troubleshooting when it does
      not. A comment on #437 shows each. The owner runs every `apply` and `restore`

### Phase 11: merge

- [ ] The pull request script written, shown and handed over; it closes #437

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `labels sync`, `labels audit` | Unknown commands |
| 2 | `get` of an organization with no `noblefactor-engprod` | Its model, its labels those of each repository a team maintains |
| 3 | `get` | Each type's description, color and enabled flag; each field's description and visibility; each option's color and description |
| 4 | `diff` of the account's own model | No differences, exit 0 |
| 5 | `diff` of a model with a type, a label and an option added, changed and removed | One record each: missing, different, not in the model |
| 6 | `diff` of a model renaming a label and an option, same account | Renamed, by ID |
| 7 | `diff` of another account's model | Matched by name; every ID ignored |
| 8 | `diff` of the user reference | Its families as labels on each participating repository; the common templates |
| 9 | `diff` of a view whose grouping differs | A difference `apply` cannot make, so marked |
| 10 | `diff` with a team project drifted from its template | The project's difference, its schedule options not among them |
| 11 | `apply`, case 5's model | The creates and changes made; the removal not made, listed; the record of each |
| 12 | `apply --prune`, case 5's model | The removal made too, after the count of what it touches |
| 13 | `apply --prune` of a reference | Only labels of the reference's kinds removed; `good first issue` kept |
| 14 | `apply` renaming an option of a template | The option list sent with every ID; the option renamed on each copy, under its old name |
| 15 | `apply` with a template the account lacks | The template made, its fields and views, marked a template |
| 16 | `apply` with a team lacking its Triage project | The project copied from the template, linked to the team, the team's write role on it |
| 17 | `apply` with a team project drifted from its template | Brought back; its rows, schedule options and iterations untouched |
| 18 | `apply` of the reference to a new organization | Its types, fields, templates, teams' projects, labels, `.github` files by pull request, each repository's workflow by pull request, variable and secret |
| 19 | `apply` with no secret in the vault | The secret named as a step by hand; the rest made |
| 20 | `apply` under `--dry-run` | Refused, naming NobleFactor/devlore-cli#1170; nothing written |
| 21 | `restore NobleFactor`, and `restore NobleFactor <revision>` | `main`'s `model.yaml`, then the revision's, applied |
| 22 | Every existing case | Passes |

## Files to Create/Modify

Under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/437-model-diff-apply-restore.md` | Create | This plan |
| `commands/reconcile.star` | Create | Bringing a reference to `get`'s form, the comparison `diff`, `apply` and `restore` share, and the writes |
| `commands/github-model-diff.star`, `commands/github-model-apply.star`, `commands/github-model-restore.star` | Create | Requirements 3 to 5 |
| `commands/model.star` | Modify | Requirement 1 |
| `reference/templates.yaml`, `reference/organization.yaml`, `reference/user.yaml` | Create, modify | Requirement 2 |
| `commands/scheme.star`, `commands/github-labels-audit.star`, `commands/github-labels-sync.star` | Modify, remove | Requirement 6 |
| `extension.yaml` | Modify | The three commands; the label commands gone |
| `tests/Test-StarGitHub` | Modify | The test plan |
| `docs/architecture/issue-data-model/`, `docs/issue-standards.md`, `README.md` | Modify | Requirement 7 |

## Related Documents

- [Section 6, § GitHub is the model](../../architecture/issue-data-model/6-the-asset-and-its-sync.md#github-is-the-model),
  § Risk and § Recovery
- [Section 3, the collections](../../architecture/issue-data-model/3-collections.md): the projects of each kind
- [#426's plan](426-model-pull-to-dot-github.md): `get` and `backup`
- #470: the questions the commands will ask; NobleFactor/devlore-cli#1219, devlore's TUI
- NobleFactor/devlore-cli#1170: star's `--dry-run` reading

## Open Questions

None. Answered by the owner on 2026-11-10:

- **A new organization to prove on:** a temporary organization, made for Phase 10's proof, purged when the proof passes
  and kept for troubleshooting when it does not. GitHub's API makes no organization, so the owner makes it in GitHub;
  the proof's script deletes it on success.
- **What a new account's `.github` files come from:** the reference account's `.github` repository, as it stands.
