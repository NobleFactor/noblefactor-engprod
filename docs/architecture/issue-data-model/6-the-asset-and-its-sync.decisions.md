---
title: "Model command decisions"
status: draft
updated: 2026-11-21
---

# Model command decisions

[Architecture](6-the-asset-and-its-sync.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-6-the-asset-and-its-sync.md.txt)

These records explain the model's significant choices. Accepted requirements and runtime qualification remain separate.


<a id="model-001"></a>

## 1. Read GitHub as the live model

Commands needing an account model read GitHub during the invocation. The YAML file is a backup, not a runtime cache. Reading an account does not adopt our reference definitions; each model command names its target account explicitly.

The source considered an extension-owned definition and cached or checkpoint-based reads. Live reads let the next command see an authorized GitHub change without requiring a separate synchronization step. Read failure must remain visible rather than silently substitute a saved copy.

Evidence: the preserved chapter's GitHub is the model section records the Owner's 2026-11-09 decision and the five-command contract.

```yaml
id: MODEL-001
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-09'
recorded_at: '2026-11-20T04:27:07Z'
```

<a id="model-002"></a>

## 2. Keep a versioned backup in the account repository

Keep each account's model backup in its own public .github repository and use its Git history for recovery. The backup describes configuration rather than exporting issues, issue relationships or project-row values.

The source records alternatives of keeping model files beside the extension or keeping no account file. Per-account Git history provides traceable checkpoints without mixing account ownership. Restoring definitions cannot recover assignments or row data lost by deletion; those require a separate export design.

Evidence: the original One model per account and Recovery sections; shared-resource ownership is also described in the storage/access companion. The file-location decision is dated 2026-11-02 and its live-versus-backup contract 2026-11-09; this record does not infer one approval time for their combined scope.

```yaml
id: MODEL-002
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T04:27:07Z'
```

<a id="model-003"></a>

## 3. Preserve resource identity during reconciliation

Match resources by ID within an account so renames preserve assignments. Match definitions by name across accounts, whose IDs differ. Send complete field/option lists with their existing IDs rather than delete and recreate resources to rename them.

The source contrasts renaming with removal plus creation, which can destroy values and leave text consumers stale. IDs preserve native references; explicit comparison still exposes names used by queries and documentation. Compare every supplied attribute, including color and deliberate null values, and identify unsupported changes as manual steps.

Evidence: the original reconciliation contract and Ids beside names discussion record the Owner's decision and its API rationale.

```yaml
id: MODEL-003
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-10'
recorded_at: '2026-11-20T04:27:07Z'
```

<a id="model-004"></a>

## 4. Require explicit pruning of existing account resources

Retain extra account resources unless prune is requested. Never delete teams, projects or templates, or remove or lower team roles. Eligible deletions must identify the definitions and affected issue/row counts. Defaults in a newly created empty project can be removed to match its template without pruning existing account data.

The alternative of implicit deletion risks losing issue assignments and row values that a model backup cannot restore. Reconciliation is a sequence of remote writes, so failure can leave partial state and does not imply automatic rollback.

Evidence: the original chapter records the deletion boundary on 2026-11-10 and the new-project exception on 2026-11-11. This combined record does not infer a single approval timestamp.

```yaml
id: MODEL-004
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T04:27:07Z'
```

<a id="model-005"></a>

## 5. Pass secret source references instead of secret values

Token arguments identify an environment variable or protected file, never a literal value. Validate known secret names and supported sources before writes. Keep secret values outside Starlark results and model data; pass them directly to the secret-setting operation and record only the limited digest receipt.

Literal command-line values would enter shell history and captured output. Protected sources preserve an explicit delivery path without making model backups a secret store. Supplying a replacement is deliberate; otherwise an existing secret remains unchanged. Windows file-access qualification is still required.

Evidence: the preserved token-source requirements state the Owner's 2026-11-10 decision.

```yaml
id: MODEL-005
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: '2026-11-10'
recorded_at: '2026-11-20T04:27:07Z'
```

<a id="model-006"></a>

## 6. Qualify both supported account paths in dedicated sandboxes

Prove organization and user-account operations in NobleFactor-sandbox and David-Noble-at-work-sandbox, using run-specific issues and collection options. Production work is not the command-test fixture.

Separate accounts exercise their different supported representations and access paths while preserving ongoing engineering work. The source records the organization decision on 2026-11-12 and the user-account decision on 2026-11-13; these dates do not establish that every command or platform is qualified.

Evidence: the original Where star github's proofs run section and its delivery record.

```yaml
id: MODEL-006
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: null
recorded_at: '2026-11-20T04:27:07Z'
```


<a id="model-007"></a>

## 7. Record the account's token in its model, held per binding

The model's `token` record names the account's issue-tracking token: its kind, `github-app` for an organization or `classic-token` for a user account, and for each secret the Triage workflow template signs in with, where its value comes from. A source is `env:<NAME>`, `file:<path>`, or `held`, a secret GitHub holds at every binding. A binding is each place a workflow reads the secret: a user account's repository secret in each participating repository, or an organization's secret, which must reach each participating repository, or that repository's own secret of the same name. The record names no use and no permission.

Scope: the model record, get, backup, diff, apply and restore, in organizations and user accounts.

**Reason:** [ACCESS-006](4-storage-and-reach.decisions.md#access-006) requires every account to identify its token, and the model is where an account's configuration is identified and backed up. GitHub never reveals a secret's value, so get can record only that a secret is held, and where the backup said it comes from. Judging held per binding catches a secret present in one repository and missing in another, and an organization secret that doesn't reach a participating repository; judging it by the secret's presence alone would pass both.

**Alternatives:** Recording uses and permissions was rejected: they change as the work does, and the credentials guide records them as they stand. Recording only the secrets' names was rejected: it would not say where a missing value comes from. Keeping recorded locators in backup alone was rejected: backup writes what get returns, byte for byte, so get keeps them.

**Consequence:** Get reads the account's Triage workflow template, the secret listings of each binding, and its current backup. A backup keeps a recorded locator while GitHub holds the secret everywhere, and drops a secret GitHub doesn't hold everywhere, so restoring that backup is refused until the secret is set again.

Evidence: [#451's plan, § 5.1](../../plans/feature/451-credentials.md#the-token-record), and the cases 195 to 205 in `tests/Test-StarGitHub`.

```yaml
id: MODEL-007
status: proposed
supersedes: []
proposed_by: Claude Code
approved_by: null
recorded_by: Claude Code
decided_at: null
recorded_at: '2026-11-21T06:42:51Z'
```

<a id="model-008"></a>

## 8. Read a secret from Azure Key Vault with az

A secret's source may be `vault:<vault>/<name>`, a secret in Azure Key Vault, beside `env:` and `file:`. `star` reads it with `az keyvault secret show --query value -o tsv`, piped straight to `gh secret set` in the same pipeline the other sources use, so the value never enters Starlark, a record or a call. Before any write, `star` checks that `az` is signed in and that the vault holds the secret; a vault's name must be 3 to 24 letters, digits and hyphens, and a secret's 1 to 127.

Scope: `--token` and the model's token record, for apply and restore.

This amends [MODEL-005](#model-005) in part. MODEL-005 stays as recorded: token arguments name a source, never a value, and values stay outside Starlark and model data. What changes is its exclusion of every other tool: `az` may now read a secret.

**Reason:** NobleFactor keeps its secrets in Key Vault, one vault per team and environment, so a model that records where its token comes from should be able to name the vault secret itself. Without it, each apply needs the value copied into an environment variable or a file first, which is the step the vault exists to remove.

**Alternatives:** Copying each vault secret to a protected file before apply was rejected: it leaves a second copy of the value on disk. Reading the vault through Azure's REST API in Starlark was rejected: the value would enter Starlark.

**Consequence:** Apply and restore depend on `az` and an Azure sign-in when a source names a vault, and refuse, naming `az login`, when there is none. A model's token record can name a vault secret, and a backup keeps that locator ([MODEL-007](#model-007)).

Evidence: [#451's plan, § 5.3](../../plans/feature/451-credentials.md#vault-sources), and the cases 206 to 210 in `tests/Test-StarGitHub`.

```yaml
id: MODEL-008
status: proposed
supersedes: []
proposed_by: Claude Code
approved_by: null
recorded_by: Claude Code
decided_at: null
recorded_at: '2026-11-21T06:42:51Z'
```

<a id="model-009"></a>

## 9. Make a token without prompting, and finish it by running again

`star github token make` takes every value it needs from a source named on its command line, `env:<NAME>` or `file:<path>`, and never prompts. For an organization it creates the app through GitHub's manifest flow: it opens a local page that posts the manifest, you confirm, and you give it the address GitHub sends the browser to, whose state it checks before exchanging the code. It writes the key to a file only you can read before storing anything, and deletes that file only once both values are stored and checked by hash. For a user account it opens the new-token page and stores the token you make, once it has checked the token's login and scopes. Each run reports what exists and the next command. It never rolls back: an app, a key and a vault secret stay, a run again finishes what is left, and a working token already in the vault is adopted. `--replace` makes new values as new versions of the same vault secrets, leaving GitHub's secrets as they are until apply runs.

Scope: the token command, for organizations and user accounts.

**Reason:** An extension's commands get no standard input until [NobleFactor/devlore-cli#1136](https://github.com/NobleFactor/devlore-cli/issues/1136), so a prompt inside `star` can't work; named sources work the same with or without a terminal. A token is made in steps that cross the browser, and any step can stop, so each run must be safe to repeat and must never destroy a working credential. Writing the key to a protected file first means a failed store loses nothing.

**Alternatives:** A local web server to receive the manifest's redirect was rejected: `star`'s runtime has none, and the code arrives in the browser's address. Rolling back an app or a stored value on failure was rejected: a half-made credential is recoverable by running again, while a rollback can destroy the only copy of a key.

**Consequence:** Making an organization's token takes three runs and two clicks; a user account's, two runs and the token page. A lost key is replaced by generating a new one on the app's page and storing it with `--from`.

Evidence: [#451's plan, § 5.4](../../plans/feature/451-credentials.md#making-a-token), and the cases 211 to 220 in `tests/Test-StarGitHub`.

```yaml
id: MODEL-009
status: proposed
supersedes: []
proposed_by: Claude Code
approved_by: null
recorded_by: Claude Code
decided_at: null
recorded_at: '2026-11-21T06:42:51Z'
```

<a id="7-shared-review-policy"></a>

## 10. Shared review policy

Model-command publication uses the [shared Owner review boundary](../../engineering/procedures/pull-request.md#merge-authorization-and-gates). [Handbook decision 62](../../engineering/review/decisions.md#decision-62) records the Owner's approval. The model design references that policy; it does not define an automatic-merge exception.
