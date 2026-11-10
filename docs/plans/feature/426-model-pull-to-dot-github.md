---
title: "GitHub is the model: star github model get and backup, and the report and the sweep on the live model"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/426
status: active
created: 2026-11-09
updated: 2026-11-10
---

# Plan: GitHub is the model: star github model get and backup, and the report and the sweep on the live model

## Summary

Step 21 of issue tracking, iteration 1 (#346). The owner ruled on 2026-11-09 that an account's data model is what
GitHub holds, enumerated when it is needed; the model file in the account's `.github` repository is a backup of it, a
checkpoint, and nothing reads it but a restore. Five commands follow from that, `get`, `diff`, `apply`, `backup` and
`restore`. This plan builds the reading side, `get` and `backup`, puts the report and the sweep on the live model, and
retires what treated a copy as the model: `pull`, `digest`, the model cache and the checkpoint reading #431 and #441
built. #437 builds the writing side, `diff`, `apply` and `restore`; reading the model's pieces in parallel, through a
graph, is #471.

## The issue

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 21 | Task | [#426](https://github.com/NobleFactor/noblefactor-engprod/issues/426), star github model get and backup, and the report and the sweep on the model GitHub holds | Its evidence of completion, rewritten to this plan in Phase 6 |

## Rulings

Ruled by the owner on 2026-11-09, in this session.

- **GitHub is the only definitive model.** Commands enumerate it when they need it. The `.github` model file is a
  backup, written by `backup`, read by `restore`.
- **Five commands, every one naming its account; no account is a default:**

  ```text
  star github model get <account>
  star github model diff <model> <account>
  star github model apply <model> <account> [--prune]
  star github model backup <account>
  star github model restore <account> [<revision>] [--prune]
  ```

  `get` returns data (`show` would be for people; star's `--output` serves them). `backup` and `restore` pair; `apply`
  takes any model, a reference or another account's, and is how a new account is set up. `<model>` is a file, or `-`.
- **No `--check`, no `--asset`.** A preview is `diff`, or star's own `--dry-run`; the model's file is wherever
  `get`'s output is redirected.
- **Interactive by default; star's global `--unattended` skips every prompt.** No `--force`. **For now, nothing asks**
  (ruled later the same day): an extension cannot ask until devlore's TUI can (NobleFactor/devlore-cli#1219, built by
  NobleFactor/devlore-cli#1221), so each place a question belongs carries a TODO linking NobleFactor/devlore-cli#1219,
  and #470, step 36, tracks the dependency: the issue tracking system is not done until it asks.
- **`apply` reconciles; it never deletes and recreates.** It creates what is missing and changes what differs, and
  deletes what the model lacks only with `--prune`. On the same account it matches by id, so a rename is a rename;
  across accounts, by name.
- **Nothing is deleted without `--prune`** (ruled 2026-11-10). With `--prune`, `apply` and `restore` also delete what
  the model lacks, and first list each deletion and how many issues and rows it touches; once devlore's TUI can ask,
  they ask about each one, and `--unattended --prune` deletes without asking. Without it, `restore` puts back what
  changed or vanished, leaves what was added since the revision, and lists what it left. A deletion is the one change a
  restore cannot undo: GitHub strips a deleted label from every issue that carries it, and blanks every row's value in a
  deleted field or option. The name is `kubectl apply --prune`'s and `git push --prune`'s, the tools that apply a model
  to a remote; it replaces the `--delete` of 2026-10-22, which followed rsync when the verbs were `push` and `pull`.
- **A backup follows our process.** Alignment is complete before its pull request merges. Its branch is
  `chore/model-<date>`, with no issue: the process is documented and the intent clear, and the pull request's comments
  record the steps and outcomes. The clone stays at `~/Workspace/<account>/.github`.
- **Reads in parallel, through a graph.** Building and executing a graph from star, with the flow provider's `gather`,
  is design work of its own, #471; devlore-cli's `cmd/devlore-test` shows how a graph is built and run. Until it
  lands, `get` reads the pieces one at a time.

## Current State

Read on 2026-11-09 from `develop` at `c4a1ea2` and from GitHub.

| Component | Status | Notes |
| --- | --- | --- |
| The report and the sweep | ⚠️ | Run on each account's model as loaded when the extension loads: the `.github` checkpoint since #431 and #441, a copy cached by ETag; `read_first` reads GitHub's record first, only to warn that the copy is behind |
| `star github model pull` | ⚠️ | Writes a model file `--asset` names; refuses without it for our accounts; `--check` previews |
| `star github model digest` | ⚠️ | Re-signs a model file's `digest` line |
| The model cache | ⚠️ | `~/.cache/devlore/star/gh/model/`: each account's checkpoint copy and its ETag, and a record of the ETags of issue types and labels keyed to the model's digest |
| `get`, `backup` | ❌ | |
| Two type labels on one issue | ❌ | The sweep's `two-labels` rule covers the area, priority, severity, effort and resolution families, not type labels |
| Filing and retyping | ❌ | No command files or retypes an issue; #338 builds one |

Measured on 2026-11-09, every piece of the model but project views comes over REST with an ETag: issue types, issue
fields, each participating repository's labels, teams and their repositories, projects and each template's fields;
views come over GraphQL alone. NobleFactor's 16 REST reads took 6.50 s one at a time, cold or warm alike, and 1.08 s
eight at a time; David-Noble-at-work's 8 took 3.01 s and 0.48 s; each account's views took about 0.4 s. A 304 saves the
rate limit, not time, so no response cache is built: the reads are made each time.

## Decisions for review

The rulings settle the commands. These remain.

1. **The model's file is `get`'s record as `-o yaml` renders it,** with no header comment and no digest: git and the
   backup's pull request guard the file, which is what the digest stood in for. Phase 2 checks that star's YAML
   rendering is stable from run to run before this is built on.
2. **The model is read at run time, not when the module loads,** so `--help` and every command that needs no model
   touch no network, and a model that cannot be read stops only the command that needed it.
3. **The sweep's `two-types` rule:** a user-account issue carrying two of the model's type labels is a fault, naming
   both. An organization's issue has one issue type at most, as GitHub allows.
4. **Filing and retyping move to #338,** which builds the one command that files or retypes an issue; #426's "Done
   when" loses the line and #338's gains it, each saying so.

## Requirements

### Requirement 1: get

- `star github model get <account>` reads the account's model from GitHub, piece by piece, and returns it as one
  record: issue types or type labels, issue fields, teams and their repositories, each participating repository's
  labels, and the project templates with their fields, options and views.

### Requirement 2: the report and the sweep on the live model

- `scheme.star` loads no model when it loads; the report and the sweep call `get`'s reading for the accounts they
  touch, once each run.
- Retired: `pull`, `digest`, the model cache, the checkpoint reading of #431 and #441, models beside the extension, and
  `read_first`. `accounts.star` stays: the report's and the sweep's default repositories still come from writ's layers.

### Requirement 3: backup

- `star github model backup <account>`: `get`; if `<account>/.github`'s `model.yaml` on `main` already matches, say so
  and stop. Otherwise create the repository if it is missing, clone or update
  `~/Workspace/<account>/.github`, branch `chore/model-<date>`, write `model.yaml`, commit, push, and open a pull
  request whose description lists the changes and ends with the owner's `Signed-off-by:`; wait for the quality gate;
  merge; remove the branch; leave the clone current. The pull request's comments record each step and its outcome,
  as the ruling has it. It asks nothing: a TODO linking NobleFactor/devlore-cli#1219
  stands where it will ask before it creates the repository and before it merges (#470).

### Requirement 4: two type labels

- The sweep's `two-types` rule (decision 3).

### Requirement 5: the issues and the documents

- #426's "Done when" rewritten to this plan; #437's to `diff`, `apply` and `restore` and the rulings above; #338's
  gains filing and retyping; #471, the parallel reads through a graph.
- Section 6 and its status, section 4, the index, and every document that names `pull`, `digest`, the model cache or the
  checkpoint as the model.

## Implementation Phases

### Phase 1: the plan

- [x] Written, committed on `feature/426-model-pull-to-dot-github`, and reviewed with the owner: approved 2026-11-09

### Phase 2: what star gives an extension

- [x] Recorded here: how an extension prompts and reads `--unattended`; whether `-o yaml` renders a record the same
      every run. Read on 2026-11-09 from devlore-cli's `develop` at `1ae1da72`: an extension's `ctx` carries `args` and
      `dry_run` alone (`cmd/star/extension/command.go`), and the `ui` module offers `error`, `fail`, `note`, `print`,
      `succeed` and `warn`, none of which asks; so an extension can neither prompt nor learn of `--unattended`, and no
      open devlore-cli issue asks for either. star's own `--unattended` takes each prompt's default and asks nothing,
      and `--force` answers yes (`self uninstall`, `cmd/internal/cli/selfinstall.go`). `-o yaml` rendered one record the
      same twice: star turns a dict into a Go map, so keys come out sorted and lists keep their order

### Phase 3: the test, first

- [x] Test-StarGitHub's stand-in `gh` answers the model's pieces as GitHub does; the new cases written, failing against
      the extension as it is:
      34 of the 47 cases fail, every new one among them, and the kept report and sweep cases, which find no model file;
      the 13 that pass are guards that hold either way

### Phase 4: get, and the report and the sweep on the live model

- [x] Requirements 1 and 2; every case passes; `make check` passes, but for Phase 5's: 39 of the 47 cases pass, the 8
      left being backup, two-types and backup among the model's commands, and make check's other gates pass. Two things
      the build found: GitHub's issue types carry no unplanned mark, so an organization's comes from its reference model
      by type name, as a user account's does by label; and a read skipped by star's --dry-run answers empty, so get, the
      report and the sweep refuse --dry-run before they read, a TODO linking NobleFactor/devlore-cli#1170 at the check

### Phase 5: backup, and two type labels

- [x] Requirements 3 and 4; every case passes; `make check` passes: all 47 cases. backup takes the model's text from
      star github model get -o yaml, which it runs, so the file is what get renders byte for byte

### Phase 6: the issues and the documents

- [x] Requirement 5: #426 and #437 rewritten in the task shape, problem, solution, outstanding questions and evidence of
      completion, #426's title with them; #338 gains retyping; #471 filed for the parallel reads, Priority Low on
      Backlog: engprod. Section 6 gains § GitHub is the model, its opening and every section that took a copy for the
      model marked superseded or brought to the ruling; its status, sections 2's and 4's status, sections 4 and 5, the
      index, issue-standards.md and the README follow, and the ruling of 2026-11-10 that nothing is deleted without
      `--prune` is recorded in #437, #426's syntax, section 6 and its status, and issue-standards.md. Found on the way
      and fixed: backup's pull request had no comments, though the ruling has them record each step, because Requirement
      3 had left that out, so backup now comments when the checks finish and after the merge reads back, and case 11.1
      checks it; backup dated its branch by UTC, now by the local date; read_model's docstring ran two paragraphs
      together; and section 6 said an organization's labels are every repository's, where get, as pull did, reads the
      hub's. All 48 cases pass, and make check passes

### Phase 7: proved on GitHub

- [ ] `get` on both accounts; the report and the sweep on both, on the live model; `backup` of both, each through its
      pull request; a test issue in personal carrying two type labels named by the sweep, then closed; a comment on
      #426 shows each

### Phase 8: merge

- [ ] The pull request script written, shown and handed over; it closes #426

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `get NobleFactor` | One record, built from the pieces the stand-in serves: types, fields, teams, labels, templates |
| 2 | `get test-user` | The same for a user account: type labels, labels, project copies; no fields, no teams |
| 3 | `get` with no account | Refused: the account is required |
| 4 | `get NobleFactor -o yaml`, twice | The same text both times |
| 5 | The report and the sweep | Run on the model the stand-in serves; no model file read anywhere |
| 6 | `--help` and the labels commands | No read of the model |
| 7 | `backup NobleFactor`, the checkpoint current | Says so; no branch, no pull request |
| 8 | `backup NobleFactor`, the checkpoint behind, `--unattended` | Branch `chore/model-<date>`, `model.yaml` written, a pull request opened and merged, its comments recording the checks and the merge; read back |
| 9 | A user-account issue with two type labels | The sweep's `two-types` fault, naming both |
| 10 | `pull`, `digest` | Unknown commands |
| 11 | Every existing case, brought to the live model | Passes |

## Files to Create/Modify

Under `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/` unless named from the root:

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/426-model-pull-to-dot-github.md` | Create | This plan |
| `commands/github-model-get.star`, `commands/github-model-backup.star` | Create | Requirements 1 and 3 |
| `commands/model.star` | Modify | The reading `get` and the report and the sweep share; the sync and the cache gone |
| `commands/scheme.star`, `commands/records.star`, `commands/github-schedule-report.star`, `commands/github-triage-sweep.star` | Modify | Requirement 2; the `two-types` rule |
| `commands/github-model-pull.star`, `commands/github-model-digest.star` | Remove | Retired |
| `extension.yaml` | Modify | `get` and `backup`; `pull` and `digest` gone |
| `tests/Test-StarGitHub` | Modify | The test plan |
| `docs/architecture/issue-data-model/`, `docs/issue-standards.md`, `README.md` | Modify | Requirement 5 |

## Related Documents

- [Section 6, the asset and its sync](../../architecture/issue-data-model/6-the-asset-and-its-sync.md)
- [#431's plan](431-dot-github.md) and [#441's plan](441-user-dot-github.md): the checkpoints in each `.github`
- #437: `diff`, `apply` and `restore`
- #338: the command and skill for filing issues of any type
- devlore-cli's `cmd/devlore-test`: building and running a graph from star

## Open Questions

None beyond the decisions for review.
