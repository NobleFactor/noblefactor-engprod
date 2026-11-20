---
title: "Issue model commands and recovery"
status: draft
updated: 2026-11-19
---

<a id="6-the-asset-and-its-sync"></a>

# Issue model commands and recovery

[Up: Issue data model](index.md)

GitHub is the authoritative account model. Commands read it when needed. The account's `.github/model.yaml` is a versioned backup, while extension reference files describe the definitions an account may adopt.

<a id="github-is-the-model"></a>
<a id="the-cache"></a>
<a id="every-operation-reads-first"></a>

## 1. Authority and read behavior

A command reads the model once per account during its invocation. It does not substitute a saved file or response cache for live state. Loading the extension, asking for help, or running a command that needs no model does not read one. A read failure stops the affected operation with its cause.

Each model command requires an explicit account. The extension's general account configuration does not provide an implicit target for these commands. Reports and sweeps read the model for each account whose repositories they inspect.

<a id="the-asset"></a>
<a id="one-model-per-account"></a>

### 1.1 Model record

| Record | Contents |
| --- | --- |
| `version` | Schema version; unsupported versions are refused |
| `account` | Account from which the record was read |
| `types` | Native organization types or user-account type labels, with IDs and classification information |
| `fields` | Organization issue fields and their options; absent from the user-account representation |
| `teams` | Organization teams, attributes and repository relationships |
| `labels` | Label definitions for participating repositories |
| `projects` | Organization templates or user-account template copies, including fields, options, views and shared copy configuration |

The schema version is 1. The record excludes issues, issue-level values, project rows, projects created from templates, built-in project workflows and organization default labels. Those exclusions define the backup's recovery limits.

Read hierarchy levels from type descriptions beginning `Level N:`; `Collection:` identifies a collection type with no hierarchy level. Invalid descriptions are model errors. Levels define the permitted parent relationships, while `unplanned: true` identifies the discovered-work leaf type. Preserve type order within a level for report rendering.

Keep resource IDs beside names. Within the same account, match by ID so a rename preserves identity; between accounts, match definitions by name. Native names are display values and may also have text consumers that need review when renamed.

<a id="two-verbs-one-hub"></a>
<a id="examples"></a>

## 2. Command interfaces

```text
star github model get <account>
star github model diff <model> <account>
star github model apply <model> <account> [--prune] [--token <sources>]
star github model backup <account>
star github model restore <account> [<revision>] [--prune] [--token <sources>]
```

| Command | Result | Writes |
| --- | --- | --- |
| `get` | One record of the live account model | None |
| `diff` | One record per difference between the supplied model and live state | None |
| `apply` | Difference records annotated with the action taken or required | Account configuration and any required publication PRs |
| `backup` | A current checkpoint or a PR awaiting Owner review; delivery only after an observed merge | The account's `.github` repository through a PR |
| `restore` | Apply results for the selected backup revision | The same configuration scope as apply |

A supplied model is a file in the live-record format, an account backup or an extension reference. Star's output options render returned data; `--output yaml` produces the serialized model. There is no separate model `--asset` option or default account.

Use `diff` for a read-only comparison. Model operations refuse `--dry-run` while the host skips the reads they require; the limitation is tracked in [Read operations during dry run](https://github.com/NobleFactor/devlore-cli/issues/1170). Standard-input model support depends on the command provider; do not promise that `-` is supported by the shell-based path.

<a id="reference-models-read-on-demand"></a>

## 3. Reference definitions

The extension provides `reference/organization.yaml`, `reference/user.yaml` and shared `reference/templates.yaml`. References name definitions without account-specific resource IDs. Common templates are defined once; account-kind additions supply issue fields or label columns, filters and views.

References name all compared attributes, including type colors: purple for Epic and blue for Feature. GitHub's default gray is a difference rather than an accepted substitute.

An organization reference supplies its issue fields and corresponding views. A user reference supplies type and attribute label families and the project copies used in place of organization templates. A kind-specific view replaces the common view of the same name.

`files_from` identifies the source account for shared `.github` files. It is not a source for copying another account's live work. Applying a reference is an explicit adoption operation; merely reading an account does not opt it into these definitions.

A template's `copy_short_description` describes projects created from it, with `{owner}` replaced by the team slug or user account. Live reads derive this pattern from same-kind copies; a tie uses the oldest copy, and no copies yield an empty pattern.

## 4. Differences

A difference records its resource kind, path, change, live value, supplied value and any manual step. Change kinds are `missing`, `different`, `renamed` and `extra`. Diff exits successfully whether differences exist or not; a failed read or invalid model is a failure, not an empty difference set.

Compare every attribute, including colors and deliberate empty values. Normalize references into the live-record form before comparison. A reference must specify the required attributes; an intentional absence is `null`, while an omitted required attribute is an error.

Use `by_hand` to identify changes the integration cannot make through its supported API path, including view grouping or sort and pinned type fields. Name the exact value to set. A record containing a manual step is not evidence that the step was performed.

## 5. Reconcile a model

Apply reads live state, creates missing resources, changes differing resources and preserves identity during renames. It does not delete and recreate a resource merely to change its name.

| Scope | Reconciliation contract |
| --- | --- |
| Issue types and fields | Preserve existing IDs; send complete option lists with existing option IDs |
| Repository labels | Use that account's backup labels or its reference label families; never import another account's repository labels |
| Templates | Create missing definitions and reconcile fields, options and supported views |
| Team or user projects | Create required copies and reconcile configuration while retaining their execution data |
| Teams and grants | Use the same account's backup; add or raise grants, never delete teams or remove or lower roles |
| Shared files and repository setup | Publish file changes through PRs and report direct settings, secrets and manual work |

A new empty project can be brought exactly to its definition, including removal of native defaults and built-in workflows, without `--prune`. That rule applies to resources the operation just created, not to pre-existing account data.

Existing projects retain their rows, collection options and iteration identities. Apply keeps iteration IDs when adjusting the configured start day or duration. A new iteration field starts on the configured weekday most recently reached. A renamed template option is matched to its corresponding copy without replacing row values.

Projects copied for teams are named `<Kind>: <team>`, linked to the team and granted team Write access. User projects use `<Kind>: <account>`. Apply reconciles the template README and expanded copy description as well as fields and views.

### 5.1 Deletion boundary

Without `--prune`, retain extra account resources and report them. With it, enumerate deletions and affected issue or row counts before deleting eligible resources. Never delete a project, template or team, or lower or remove team roles, even with pruning.

For reference-based label reconciliation, pruning affects only the label families the reference defines. The organization reference leaves ordinary repository labels, including `good first issue`, to repository configuration.

Deleting a label removes issue assignments; deleting a field or option destroys values. A later restore can recreate definitions but cannot recover those assignments or values. Applying a model is a sequence of remote writes, not an atomic transaction or guaranteed rollback.

### 5.2 Account files and repository configuration

Shared files come from `files_from`, or the backup's own account. Replace source-account wording with the target account, preserve the target's unrelated files, and manage the backup and installed Triage workflow separately. Publish shared-file changes from `doc/issue-model-files`.

Each participating repository receives the source Triage workflow through a PR from `feature/triage-workflow`. Set `TRIAGE_PROJECT_URL` to the owning team's Triage project or the user account's equivalent.

Configure squash merges with `PR_TITLE` and `PR_BODY` so the landed commit retains the PR description and its required trailers. Read back the setting. If repository-admin access is unavailable, identify the required manual step rather than claim configuration succeeded.

Missing workflow secrets are supplied through explicit sources or reported as manual work. Existing secrets remain unchanged without a supplied replacement.

## 6. Back up and publish

Backup reads the live model and compares its deterministic YAML with model.yaml on main in the account's .github repository. Matching content returns current without opening a PR. Otherwise it creates or reuses a doc/model-<date> publication PR and records its progress.

The Owner authorizes repository creation and clone maintenance separately where required. The backup path uses /Users/<user>/Workspace/<account>/.github on macOS, or the corresponding home Workspace path on another platform, and refuses a dirty clone. Configuration-file publication uses GitHub git-data operations without needing a local clone for those writes.

### 6.1 Owner review boundary

All model-command PRs follow the shared [Owner review and merge policy](../../engineering/procedures/pull-request.md#merge-authorization-and-gates). Prepare the change, identify the exact PR head, report its checks and unresolved requirements, then stop for the Owner to review and merge in GitHub. Invoking backup, apply or restore does not authorize an automatic merge. Neither --unattended nor a future prompt supplies merge authority.

Wait for the qualified head's workflow runs to start and finish, then establish the required check results. A run not starting within 60 seconds, a failed check, a changed head or an unreadable requirement leaves the PR unmerged with its cause recorded. An empty check list or a branch-rules 403 does not by itself prove that no checks are required; a no-check path needs verified policy. Reuse the pending PR without treating an earlier head's result as current.

Return the PR identity and the observed review/check state. Report it as awaiting Owner review rather than merged. Apply and restore may already have changed remote configuration before reaching a file-publication PR; stopping at that PR does not roll back those writes. Their authorization and partial outcomes remain distinct from merge approval.

### 6.2 Delivery evidence

After the Owner merges, an authorized follow-up observes the PR's merged state and full merge commit ID, verifies the checkpoint or files at that revision, and confirms the landed message's sign-off and assistance disclosure. It must not substitute the latest target commit when concurrent work advances the branch.

Record delivery and retain pending obligations before authorized branch removal or clone synchronization. Report a merged checkpoint only after observing it. Preserve the candidate and review evidence when the PR is still open or delivery cannot be established.

Descriptions and squash messages follow the [shared disclosure requirements](../../engineering/procedures/pull-request.md#review-boundary), naming the actual submitting agent. Branch commits have no disclosure trailers. Source implementation gaps belong in the [delivery reference](6-the-asset-and-its-sync.status.md), not in this architecture's definition.

The Owner runs mutating commands under the applicable authorization. This design grants no execution, repository administration or credential authority. Prompt support remains separate work under [Model command prompts (#470)](https://github.com/NobleFactor/noblefactor-engprod/issues/470).

<a id="recovery"></a>

## 7. Restore and recovery limits

Restore reads `model.yaml` from the named account's `.github` repository at a commit, tag or branch, using `main` when omitted. Refuse a missing backup, unknown schema or backup naming a different account. Reconcile it through the same rules as apply.

| Lost or damaged state | Restorable part | Limit |
| --- | --- | --- |
| Resource name, description or color | Correct the definition in place by ID | Text consumers may still need correction |
| Deleted label | Recreate its definition | Issue assignments are lost |
| Deleted field or option | Recreate its definition | Row or issue values are lost; IDs may change |
| Deleted template | Recreate its structure | New IDs and manual view work may be required |
| Deleted copied project | Recreate it from its template and ownership mapping | Rows, membership and Schedule, Scenario, Step, Beat and Iteration values are lost |
| Damaged backup file | Recover an earlier Git revision, or back up valid live state | A checkpoint contains only its recorded model |

Blocked-by links live on issues and survive deletion of a project. The model backup does not export issues, their parents, field assignments or project rows. Recovery of that work data requires a separate export or backup design.

Use diff to inspect the selected backup against live state before restoration. Pruning determines whether definitions added after the checkpoint are retained or removed. Record newly allocated IDs in a later backup.

<a id="access"></a>
<a id="participation-a-user-accounts-repositories"></a>

## 8. Access and secret handling

Every GitHub operation checks the active `gh` access before its requests. It does not sign in, refresh credentials or add scopes on the user's behalf.

| Failure | Required explanation |
| --- | --- |
| No login | Identify the host and the login command for the user's terminal |
| Rejected token | Distinguish stored login from `GH_TOKEN` or `GITHUB_TOKEN`; identify renewal or replacement |
| Missing scopes | Name only the missing scopes; `project` includes `read:project` |
| Account unavailable despite scopes | Identify the access boundary and who must grant access |
| Rate limit exhausted | Report the reset time in local time |

The configured scope checks require `read:project` for get and diff, plus `repo` for backup. Apply and restore check `repo`, `project`, `admin:org` and `workflow`. These checks do not replace repository, organization or project permissions.

`--token` names secret sources, never values: `<SECRET>=env:<NAME>` or `<SECRET>=file:<path>`, comma-separated, or a bare source when the workflow uses one secret. Reject literal secret values, unknown secrets and unsupported sources before writes.

A source file must be readable only by its owner, mode 600 or stricter on Unix. Windows uses ACL inspection and requires platform qualification. Secret values pass directly from their source to the GitHub secret operation, outside Starlark records. A receipt contains only the first 12 hexadecimal digits of the value's SHA-256.

<a id="risk"></a>
<a id="where-star-githubs-proofs-run"></a>

## 9. Quality and qualification

| Scenario | Required result |
| --- | --- |
| Rename a type, field or option in the same account | Preserve its ID and existing assignments |
| Apply an unchanged model | Report no configuration differences or unintended writes |
| Apply a reference to a new account | Create the account-kind resources without importing another account's work |
| Compare a reference with omitted required data | Fail with the omitted attribute named |
| Restore a deleted project | Identify the lost row data rather than claim full recovery |
| Lose access during a write sequence | Expose the failure and known partial outcome |
| Finish publication checks | Leave the PR for Owner review; perform no automatic merge |
| Observe delivery while another PR advances the target | Verify this PR's recorded full merge commit, its content and trailers |

Live command proofs use the dedicated organization `NobleFactor-sandbox` and user account `David-Noble-at-work-sandbox`, with their own run-specific issues and collection options. Those environments qualify both account paths without treating production changes as test fixtures. Windows and host-prompt limitations need their own evidence.

Model drift, destructive deletion, text references after renames and partial remote writes remain operational risks. Source observations and completed tests are retained in the delivery records; this design does not establish a new successful deployment.

<a id="what-this-changes-in-the-task-list"></a>

## 10. Decisions and delivery references

The [decision companion](6-the-asset-and-its-sync.decisions.md) explains live authority, backups, identity preservation and reconciliation limits. The retained [delivery reference](6-the-asset-and-its-sync.status.md) links implementation plans and source records.
