---
title: "Model command decisions"
status: draft
updated: 2026-11-19
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


## 7. Shared review policy

Model-command publication uses the [shared Owner review boundary](../../engineering/procedures/pull-request.md#merge-authorization-and-gates). [Handbook decision 62](../../engineering/review/decisions.md#decision-62) records the Owner's approval. The model design references that policy; it does not define an automatic-merge exception.
