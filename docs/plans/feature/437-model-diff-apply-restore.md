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
  star github model apply <model> <account> [--prune] [--token <source>]
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
- **Every attribute, and what drift is** (the owner, 2026-11-10). A backup holds every attribute of each part of the
  model, color among them; `apply` and `restore` write every one GitHub's API can write; `diff` reports any attribute
  that differs. Drift is a value that changed, or one dropped where the model expects it. An attribute may be decided
  empty, `color: null`, and an empty value in GitHub then matches it; so a reference names every attribute, a deliberate
  none written as one, and an attribute left out is an omission a test catches.
- **What `apply` never destroys, and what it carries** (the owner, 2026-11-10). A team, and its ownership of its
  repositories, is never destroyed: `apply` and `restore` delete no team and remove or lower no team's role on a
  repository, even with `--prune`; a team's attributes and roles are written only from the account's own backup, set or
  added. The `.github` repository is added to or updated, by pull request, and none of its own files deleted. Every team
  that maintains a repository gets the same set of projects, one for each template the model holds. The labels a backup
  holds are restored to its account; another account's labels are never carried, since an organization's issue tracking
  runs on its issue fields and its repositories are its own, and a reference names labels for a user account alone.
  `good first issue`, the one label the sweep reads in an organization, is left to GitHub, which gives it to every new
  repository.

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
| The Triage workflow | ⚠️ | Read on 2026-11-10. NobleFactor's template signs in with the noblefactor-automation GitHub App, through the organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`, and names NobleFactor twice in its steps; David-Noble-at-work's signs in with the classic token in `ADD_TO_PROJECT_PAT`. None of NobleFactor's five participating repositories has the workflow yet, each with its `TRIAGE_PROJECT_URL` set (#448, waiting on #447); personal and David-Noble-at-work/.github have it |

What GitHub's API can write, read from its schema on 2026-11-10:

| Part of the model | Create, change, delete | What the API cannot do |
| --- | --- | --- |
| Issue types | `createIssueType`, `updateIssueType`, `deleteIssueType`: name, description, color, enabled | |
| Issue fields | `createIssueField`, `updateIssueField`, `deleteIssueField`: name, description, visibility, options | GraphQL takes no option IDs; the REST call `PATCH /orgs/{org}/issue-fields/{issue_field_id}` does (settled 2026-11-04) |
| Labels | REST, per repository: create, change (renaming with `new_name`), delete | |
| Project fields | `createProjectV2Field`, `updateProjectV2Field` (options with their IDs), `deleteProjectV2Field`; an issue field on a project, `createProjectV2IssueField` | |
| Project views | `createProjectV2View`, `updateProjectV2View`, `deleteProjectV2View`: name, layout, filter, visible fields | A view's grouping and sort: no input takes them |
| Templates and their copies | `createProjectV2`, `markProjectV2AsTemplate`, `copyProjectV2`, `linkProjectV2ToTeam`, `updateProjectV2Collaborators` (a team's role) | |
| A repository's workflow, variable, secret | REST: contents and git data, `actions/variables`, `actions/secrets` | A secret's value is never read back |

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
   whatever the model lacks. Across accounts no label is compared or written: another account's labels belong to its
   repositories (the owner, 2026-11-10).
4. **Views** (an open question on #437). `apply` writes a view's name, layout, filter and visible fields. Its grouping
   and sort cannot be written through GitHub's API, so `diff` reports a difference in them and `apply` lists each as a
   step to take by hand.
5. **Teams,** revised twice on 2026-11-10. `apply` never deletes a team, nor removes or lowers its role on a repository,
   even with `--prune`. From the account's own backup it sets a team's attributes, its description, privacy,
   notification setting and parent, and adds the roles the backup holds, through GitHub's REST calls; never its members,
   who are people, not the model. From another account's model or a reference, it writes no team, and `diff` reports
   none: a team, its roles and a template's links are the account's own. The first draft left teams to an organization
   owner; the first revision, to every attribute, would have made another account's teams in this one and, with
   `--prune`, deleted this one's.
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
12. **A new account joins through `apply`,** revised on 2026-11-10 from what GitHub holds. Beyond the model, an account
    needs its `.github` repository's files, and in each participating repository the Triage workflow, the
    `TRIAGE_PROJECT_URL` variable naming its team's Triage project, and the secrets the workflow signs in with. `apply`
    writes what is missing or different of them, and `diff` reports it:
    - The `.github` repository's files come from the account the model comes from, as its `.github` repository stands: a
      reference's `files_from`, NobleFactor/.github for an organization and David-Noble-at-work/.github for a user
      account, or a backup's own account. Every file but `model.yaml`, the account's own, and
      `.github/workflows/triage.yml`, which the workflow below covers. The source account's name in them becomes the
      target's, as a reference's `{account}` does: NobleFactor's README, CONTRIBUTING, SECURITY and SUPPORT name
      NobleFactor as the account they serve (decided in Phase 8; approved by the owner, 2026-11-10). They land through one pull request, as `backup` lands
      one; the account's own files, those the source lacks, are never deleted. On the account they come from there is
      nothing to compare.
    - Each participating repository's `.github/workflows/triage.yml` is the source's `workflow-templates/triage.yml`,
      landed through a pull request on its default branch.
    - The variable is set directly.
    - The secrets are those the template names. An organization's template signs in with a GitHub App, NobleFactor's
      through the organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`; a
      user account's with a classic token in `ADD_TO_PROJECT_PAT`. One missing, on the repository or, in an organization,
      on the organization, is set from `--token` (decision 15) or named as a step by hand. The first draft assumed
      `ADD_TO_PROJECT_PAT` in every account.
    - The template names its account nowhere (the owner, 2026-11-10): NobleFactor's names NobleFactor twice, so a copy
      in another organization would sign in to NobleFactor and set NobleFactor's Area field. #447's pull request to
      NobleFactor/.github makes both `github.repository_owner` and fixes the Area reader that can hang a run, before
      Phase 10, so that the `apply` there lands NobleFactor's five workflows sound; #448 keeps the Severity step and its
      proof.
13. **The label commands go first,** before any other change on the branch: until they go, `labels sync` puts the
    retired type labels back.
14. **The templates are defined once,** in `reference/templates.yaml`, with their fields, options and views. Each
    reference adds what its kind brings: an organization's, its issue fields, the Area field on Triage and the Priority
    field on Backlog, shown in their views, the Missing Area view's filter on Area and the By priority view; a user
    account's, having no issue fields, the Labels column and the Missing Area view's filter on the area labels. A view a
    kind adds replaces the common view of the same name. `diff` and `apply` build each account's templates from the
    common set and its kind's additions. A field marked `own_options`, Schedule's and Scenario's, holds options that are
    each project's own, and `diff` and `apply` leave them alone. Corrected on 2026-11-10, reading both accounts: the
    first draft had the organization adding to a common set and the user account adding nothing.
15. **A secret comes from where `--token` names, never from its value** (the owner, 2026-11-10). `--token` names each
    secret and its source, `<SECRET>=env:<NAME>` or `<SECRET>=file:<path>`, comma-separated for several; a bare
    `env:<NAME>` or `file:<path>` serves when the template uses one secret, as a user account's does. `env:` is an
    environment variable set for the run; `file:` a file its owner alone can read, mode `600` or stricter, which holds a
    token or an App's private key. A value on the command line, a token's shape or any other source, is refused, since it
    is already in the shell's history, and so is a secret the template does not use, before anything is written; star
    calls no other tool for a secret, Azure's among them. The value goes from its source to `gh secret set` through one
    shell pipeline, carriage returns and the final newline dropped and a key's other lines kept, so it enters neither
    Starlark nor star's records; the record shows the first 12 hexadecimal digits of its SHA-256. In an organization a
    secret is set on the organization, visible to all its repositories, as NobleFactor holds its App's; in a user account
    on each participating repository. Without `--token`, a secret already set, an organization's included, is kept, and
    a missing one is named as a step by hand; with it, the secret is set, replacing one already there. On Windows, where
    a file has no mode, `file:` reads its ACL with `powershell.exe`'s `Get-Acl`, part of Windows, and refuses a file
    anyone but its owner, SYSTEM and Administrators can read (the owner, 2026-11-10: the extension is cross-platform).
    That half is written now and tested once the command provider replaces the shell provider
    (NobleFactor/devlore-cli#1136, and #474), when Test-StarGitHub can run on Windows; until then the test runs on macOS
    and Linux, as it does today. Revised the same day: the first ruling named one token, `ADD_TO_PROJECT_PAT`.
16. **A model on standard input waits on the command provider.** star gives an extension's shell commands no standard
    input: its shell provider sends none, and a missing one closes the child's input at once. Section 6.3 of
    devlore-cli's architecture makes standard input an attribute of the request, `Options.Stdin`, and
    NobleFactor/devlore-cli#1136 builds it. Until then `diff` and `apply` refuse `-` for `<model>`, saying why, and
    `--token` takes no `-`.
17. **`get` records every attribute GitHub exposes,** beyond what Phase 4 added: each template's short description,
    README, public flag, and the teams and repositories linked to it; each type's pinned fields; each team's
    description, privacy, notification setting, parent and its role on every repository. What GitHub's API cannot write,
    a view's grouping and sort, and a type's pinned fields if no call takes them, `apply` lists as a step by hand,
    naming each value. The references name every attribute too, read from the accounts as they stand where they named
    none, but for Epic's and Feature's colors, which stay purple and blue: GitHub's gray is drift.
18. **The branches the tools open take a prefix NobleFactor allows** (the owner, 2026-11-10). `chore/` retired on
    2026-11-03, and NobleFactor's ruleset 12515090 allows only `doc/`, `feature/`, `fix/`, `hotfix/`, `refactor/` and
    `release/`. `backup` opens `doc/model-<date>`, where #426 opened `chore/model-<date>`; `apply` opens
    `doc/issue-model-files` for the `.github` files and `feature/triage-workflow` in each repository, a workflow being a
    capability. Pull request titles keep their `chore:` type. The ruleset let `chore/model-2026-11-10` through on
    NobleFactor/.github#4 with no bypass actor, so GitHub does not enforce it on NobleFactor's plan; that is Bug #475,
    filed in Backlog: engprod with Priority High, outside this plan.

## Requirements

### Requirement 1: get reads any account, and records everything apply writes

- Decisions 1 and 11, with each label's ID and each issue field's and option's database ID, which GitHub's REST calls
  take. `-o yaml` stays the same text every run.

### Requirement 2: the references

- Decision 14: `reference/templates.yaml`, and the two references naming only their kind's additions; the views the
  accounts hold, read on 2026-11-10, written into the common set.

### Requirement 3: diff

- `star github model diff <model> <account>` reads the model, brings a reference to `get`'s form, reads the account's
  model with `get`'s code and its projects of each kind, and returns one record for each difference: what it is (a
  type, a field, an option, a label, a template, a project of a kind, a field or view of one, a `.github` file, a
  repository's workflow, variable or secret), its key, what is wrong (missing, different, renamed, or not in the model), what
  GitHub holds and what the model holds. A difference `apply` cannot make, a view's grouping or sort or a team, says so.
  Nothing is written. It exits 0 whether there are differences or none; an error alone fails it.

### Requirement 4: apply

- `star github model apply <model> <account> [--prune] [--token <sources>]` makes `diff`'s changes, in an order that
  keeps every reference whole: issue types; issue fields and their options; each participating repository's labels; the
  templates, a missing one first made; each project of a kind, a missing one first copied and linked; the `.github`
  repository's files; each participating repository's workflow, variable and secret.
- Renames are made in place, matched by ID on the same account. Option lists are sent with their IDs. Deletions happen
  only with `--prune`, decisions 3 and 7 limiting them, each first listed with how many issues and rows it touches.
- It returns a record of each change made, and of each it could not make, with the step to take by hand. A TODO
  linking NobleFactor/devlore-cli#1219 stands where it will ask, before any deletion and before it starts (#470). It
  refuses star's `--dry-run`, as `get` does, until NobleFactor/devlore-cli#1170: `diff` is the preview.

### Requirement 5: restore

- `star github model restore <account> [<revision>] [--prune] [--token <sources>]` reads `model.yaml` at the revision
  of `<account>/.github`, `main` when none is named, and applies it.

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

- [x] Test-StarGitHub's stand-in `gh` answers the write calls and records them, and serves an organization other than
      NobleFactor; the test plan's cases written, failing against the extension as it is: every new case fails, and the
      existing cases pass, 1a now finding the Schedule template, with the guards that hold either way. The cases fix the
      interface. `diff` returns one record for each difference, `kind`, `path`, `change`, `github`, `model` and
      `by_hand`, its change `missing`, `different`, `renamed` or `extra`; `apply` returns the same with `action`,
      `created`, `changed`, `renamed`, `deleted`, `kept` or `by-hand`, and `touches` on a deletion. A model is a file, a
      reference named by its path. `get` records each label's ID, and each issue field's and option's database ID, which
      GitHub's REST calls take. A new account's `.github` files are every file of the reference account's but
      `model.yaml`. `get` still stops on a type that fits no model; `diff` and `apply` read one as a difference, as they
      must GitHub's three default types in a new organization. A token comes from `--token`, decision 15, added at the
      owner's direction on 2026-11-10 after a first draft read it from Azure Key Vault. `make check` passes but for the
      test

### Phase 4: get reads any account, and records everything apply writes; the references

- [x] Requirements 1 and 2; every case of them passes; `make check` passes, but for the test's cases of `diff`, `apply`
      and `restore`, 27 of the 92, which Phases 5 to 8 build: cases 13 and 14 pass. `get` reads an organization's labels
      from each repository a team maintains, the hub gone, and records each type's enabled flag, a disabled type kept;
      each issue field's description, visibility and database ID; each option's color, description, priority and
      database ID; each label's ID; a project field's issue-field mark and an iteration field's configuration.
      `read_all_projects` reads every open project for `diff` and `apply`, and `read_projects` picks the templates from
      it. Run live on 2026-11-10 from the worktree, both accounts read cleanly: NobleFactor's labels from its five
      maintained repositories, Triage/Area and Backlog/Priority marked as issue fields. `reference/templates.yaml` holds
      the common set, read from both accounts, and each reference names its kind's additions and the account its
      `.github` files come from; their comments that called an account's model a cache written by `pull` are corrected.
      A project option's ID repeats across projects, so a copy matches its template by name, as decision 7 has it.
      Section 6 says where `get` reads labels

### Phase 5: diff

- [x] Requirement 3: `commands/reconcile.star` reads a model file, brings a reference to the form `get` returns, and
      compares it with the account's, read by `get`'s code leniently, a type that fits no model a difference;
      `commands/github-model-diff.star` returns the records. Every `diff` case passes, 74 of the 94 in all, the 20 left
      being `apply`'s and `restore`'s. Run live on 2026-11-10 from the worktree, each account's own model shows no
      difference. Found on the way and fixed, each test first: NobleFactor's Owners team, which maintains no repository,
      was given the four projects, and now a team owns projects only when it maintains a repository; and a reference's
      label with no color, the user reference's `schedule` and `scenario`, was compared as an empty color, a fix the
      owner's ruling on every attribute reversed the same day: `diff` compares every attribute of each kind, a value the
      model lacks counting as none, and an absent value and an empty one as one. Against the references, the accounts
      differ: NobleFactor's Epic, Feature, Schedule and Scenario descriptions, and Epic's and Feature's colors;
      David-Noble-at-work's type labels the same way, and `resolution:invalid`'s color

### Phase 5a: every attribute

- [x] Decision 17 and the revised decision 5, the test first: `get` records every attribute GitHub exposes; a test fails
      on any reference entry that leaves an attribute out; the references name every attribute; `make check` passes, but
      for the 20 cases of `apply` and `restore`: 82 of the 102 pass. `get` now records each template's short
      description, README, public flag and linked teams and repositories; each type's pinned fields; each team's
      description, privacy, notification setting, parent and its role on every repository, in the names GitHub's REST
      calls take. `diff` compares them all, a team's no longer by hand. The check is the extension's: `diff` and `apply`
      refuse a reference entry that leaves an attribute out, naming it, and a template is checked as merged, the common
      set with its kind's additions. The references were completed from the accounts as they stand: every type's enabled
      flag and pinned fields, Schedule's and Scenario's colors, every field's visibility, every option's priority, the
      user reference's two type labels' colors, each template's README, public flag and short description, and
      NobleFactor's Start date field, unused and kept, which Feature pins and which `--prune` would otherwise have
      deleted. A user account's short descriptions name the account, which a reference cannot, so a reference's text
      says `{account}` and is filled for the account it is compared with. Run live, each account's own model shows no
      difference, and its reference shows the drift alone: four types' descriptions and Epic's and Feature's colors in
      NobleFactor; David-Noble-at-work's type labels' descriptions and `resolution:invalid`'s color. By the ruling on
      what `apply` never destroys, `diff` compares an account's own parts, its teams and their roles and its templates'
      links, only against the account's own backup, and its labels against that or a reference; cases 36 and 37, of
      `apply` across accounts and of `--prune`, are written and fail until Phase 6

### Phase 6: apply, account-wide

- [x] Requirement 4's issue types, issue fields, labels and templates: `commands/apply.star` and
      `commands/github-model-apply.star`, with `--prune` and `--token` in the manifest. Issue types and issue fields are
      written through GitHub's REST calls, which take the database IDs `get` records, an issue field's options sent
      whole, each with its ID; GitHub's REST documentation, read on 2026-11-10, has no call that pins a field to a type,
      so pinned fields are a step by hand. Labels go through REST; templates and their parts through GraphQL, each
      mutation's input written as literals so that every value is in the call star narrates. A new GitHub project comes
      with a Status field and a View 1, so a template is made and then brought to the model by the one routine that
      brings any project to its template. Teams are written from the account's own backup alone: attributes set, roles
      added or raised, none deleted, removed or lowered. Two cases written in Phase 3 were corrected before the code:
      case 22 expects an issue type written through REST rather than GraphQL, and case 26's Backlog template gains a
      field the default Status does not cover. The stand-in answers a project just made, with GitHub's defaults, a
      count, and `gh api --input -`, and reports the `admin:org` and `workflow` scopes `apply` needs, which the owner's
      login holds. 94 of the 106 cases pass, the 12 left being Phase 8's; `get` and `diff` read both accounts cleanly
      afterward, and `apply` itself first runs on GitHub in Phase 10, by the owner

### Phase 7: apply, the projects of each kind

- [x] Requirement 4's projects of each kind, built with Phase 6, since the routine is the one templates use: a missing
      project is copied from its template, linked to its team with the team's write role, and brought to the template; a
      drifted one is brought back, its own options left alone, an option renamed on the template renamed on it under its
      old name. Cases 25, 27, 28 and 36 pass

### Phase 8: apply, a new account; and restore

- [x] Requirement 4's `.github` files, workflows, variables and secrets, and Requirement 5; every case passes;
      `make check` passes. Reading GitHub first changed decisions 12 and 15 (the owner, 2026-11-10): an organization's
      workflow signs in with a GitHub App, so the secrets are those the template names, and `--token` names each one.
      `commands/participation.star` reads, compares and writes what an account needs beyond its model;
      `commands/tokens.star` takes `--token`; `commands/pull.star` lands a change through a pull request, `backup`'s
      gate moved there, apply committing through GitHub's git data API so that no clone is touched;
      `commands/github-model-restore.star` is Requirement 5. The test's stand-in answers the git data API, raw contents,
      variables and organization secrets; cases 29 and 30 now bring in a new organization and a new user account, 29b
      and 39 hold `--token` to the template's secrets, and 38 an account's own workflows and variables. 126 of 126 cases
      pass. Read live on 2026-11-10 with the branch's extension, `diff` of each account's own model finds NobleFactor's
      five missing Triage workflows, #448's, and nothing else, and nothing in David-Noble-at-work

### Phase 9: the issues and the documents

- [x] Requirement 7. Section 6's § GitHub is the model states the commands as built, and § Reference models, § Recovery
      and § Access what #437 settled; its status, sections 2 to 5 and their status files, the index,
      `docs/issue-standards.md` and the README follow. #437's body was rewritten to this plan, its three questions
      answered and its evidence of completion Phase 10's; #447 takes the template's owner names, and #448 says `apply`
      lands its five workflows. Reading section 5 turned up decision 18: the tools opened `chore/` branches, which
      NobleFactor's ruleset is meant to refuse and does not, Bug #475. #437 closes with the pull request, Phase 11

### Phase 10: proved on GitHub

- [x] #447's pull request to NobleFactor/.github merged first (decision 12): NobleFactor/.github#5, `db08485`,
      2026-11-10
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
| 18 | `apply` of the reference to a new organization | Its types, fields, templates and teams' projects; its `.github` files by pull request, the source account's name in them its own, `model.yaml` not among them; each repository's workflow by pull request, and its variable; the App's secrets, missing, named as steps by hand |
| 18a | `apply` of another organization's model to an organization with three teams | No team made or deleted, no role changed, no label written; each team that maintains a repository gets one project for each template |
| 18b | `apply --prune` of another organization's model, and of the account's own backup lacking a team and a role | No team deleted, no role removed or lowered |
| 19 | `apply` of the user reference to a new user account, with no `--token` and then `--token env:<NAME>` | First the missing secret named as a step by hand, the rest made; then the secret set on each repository from the variable, its record showing the token's fingerprint and never the token |
| 19c | `apply --token <SECRET>=env:<NAME>,<SECRET>=file:<path>` to an organization | The App's secrets set on the organization; a secret the template does not use, or a bare source where it uses two, refused, nothing written |
| 19a | `apply --token file:<path>` | Refused when others can read the file; at mode `600`, the secret set from it, replacing one already there |
| 19b | `apply --token` with a token's value, or a source but `env:` and `file:` | Refused; nothing written |
| 21a | `diff` of an account's own backup, its `.github` files and workflows as they stand | No file record; a workflow that differs from the template, and a variable naming another team's Triage project, each a record |
| 20 | `apply` under `--dry-run` | Refused, naming NobleFactor/devlore-cli#1170; nothing written |
| 21 | `restore NobleFactor`, and `restore NobleFactor <revision>` | `main`'s `model.yaml`, then the revision's, applied |
| 22 | Every existing case | Passes |

## Files to Create/Modify

Under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/437-model-diff-apply-restore.md` | Create | This plan |
| `commands/reconcile.star` | Create | Bringing a reference to `get`'s form, and the comparison `diff`, `apply` and `restore` share |
| `commands/apply.star` | Create | The writes |
| `commands/participation.star` | Create | Decision 12: the `.github` files, and each participating repository's Triage workflow, variable and secrets, read, compared and written |
| `commands/tokens.star` | Create | Decision 15: `--token` |
| `commands/pull.star` | Create | A change landed through a pull request, `backup`'s and `apply`'s |
| `commands/github-model-diff.star`, `commands/github-model-apply.star`, `commands/github-model-restore.star` | Create | Requirements 3 to 5 |
| `commands/github-model-backup.star` | Modify | Its pull request landed through `commands/pull.star` |
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
- NobleFactor/devlore-cli#1136: the command provider, which replaces the shell provider: standard input as an
  attribute of the request, and the argv and script tiers that run on Windows with no `sh`; devlore-cli's section 6.3

## Open Questions

None. Answered by the owner on 2026-11-10:

- **A new organization to prove on:** a temporary organization, made for Phase 10's proof, purged when the proof passes
  and kept for troubleshooting when it does not. GitHub's API makes no organization, so the owner makes it in GitHub;
  the proof's script deletes it on success.
- **What a new account's `.github` files come from:** the reference account's `.github` repository, as it stands.
