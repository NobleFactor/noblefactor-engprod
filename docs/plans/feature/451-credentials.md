---
title: "Every account identifies its issue-tracking token, and apply refuses an account that doesn't"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/451
status: draft
created: 2026-11-20
updated: 2026-11-20
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/4-storage-and-reach.md
  - kind: Design
    path: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md
  - kind: "Design: triage, and the tokens it uses"
    url: https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/architecture/issue-data-model/4-storage-and-reach.md#triage
    text: "section 4, § Triage"
  - kind: "Design: access"
    url: https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/architecture/issue-data-model/6-the-asset-and-its-sync.md#access
    text: "section 6, § Access"
  - kind: Where this is listed
    url: https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/plans/chore/303-issue-data-model.md#closing-from-2026-11-04
    text: "#303's plan, § Closing, from 2026-11-04"
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/613
    text: "Every process that depends on a token alerts us when the token expires or goes missing, and keeps alerting until it is fixed"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/614
    text: "Model publication stops for Owner review and verifies actual merge requirements"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/437
    text: "star github model diff, apply and restore"
---

# Every account identifies its issue-tracking token, and apply refuses an account that doesn't

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: Codex, which reviewed revision c34efdc of this plan.
- Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Every account that issue tracking runs in identifies its token, and `star github model apply` refuses an account that doesn't, before it writes anything. Which token an account has, what it's used for and which permissions it carries can change over time. That it has one can't. Where GitHub lets `star` make or store a token, `star` does it. Where GitHub doesn't, the refusal and the command's help say exactly what to do.

At the end:

1. **Each model names its account's token.** The two reference models and every account's own model have a `token` record: the token's kind, the GitHub secrets that hold it, and where each secret's value comes from. The record doesn't name the token's uses or permissions.
2. **`apply` and `restore` refuse an account whose token isn't identified,** or whose token isn't where its record says at every place a consumer reads it. They check every destination before the first write, write nothing when a check fails, name what is missing, and say how to fix it. `diff` reports a missing token as a difference.
3. **A secret's value can come from Key Vault,** as `vault:<vault>/<name>`, beside today's `env:` and `file:`.
4. **`star github token make <account>` makes an account's token** where GitHub allows it, and says what to do where GitHub doesn't. It asks for nothing at a prompt: each value it needs comes from a source named on its command line. It can be stopped and run again at any step without losing a working credential.
5. **The credentials are inventoried.** Section 4 and a user guide list each credential: its account and kind, where it is held, the processes that use it and the permissions each needs as they stand, its expiry or rotation date, its warning margin, and how it is renewed. The help of `apply`, `restore` and `token make` names the guide.
6. **Both sandboxes have their tokens,** set up the same way as the real accounts, each proven by a Triage run that succeeds.

Out of scope:

- **Reminders and alerts** belong to #613. This work sets each credential's renewal date and warning margin in the inventory, and #613 acts on them.
- **Replacing production's app key** is a separately scheduled rotation (§ 6, question 1).
- **Live runs that would land a pull request** wait for #614 (§ 5.6).

## Issue 451

#451 asks for the credentials issue tracking runs on to be listed in one place, with what each can do, what uses it, when it expires or is next renewed, and how it is renewed and rotated, with a reminder before each is due. On 2026-11-20 it widened: both sandboxes' Triage workflows had failed for days, unnoticed, because neither had its token and nothing required one. The list and its renewal dates stay here; the reminders move to #613. Its body is rewritten to match this plan when the plan is approved.

<a id="current-state"></a>

## 3. Current state

Read on 2026-11-20, at develop 55dec2b:

- **NobleFactor** signs its Triage workflow in with the GitHub App noblefactor-automation, app ID 2791147, through the organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`, set on 2026-02-04 and visible to all repositories. The app is installable only on NobleFactor. Six other workflows sign in with the same key. Key Vault holds no copy: `kv-nf-engprod-prd` is empty.
- **NobleFactor-sandbox** has never had either secret. Its organization holds no secrets and no app. All 77 Triage runs since the workflow landed on 2026-11-12 failed.
- **David-Noble-at-work** signs in with classic tokens in the repository secret `ADD_TO_PROJECT_PAT`, one in personal, set 2026-11-10, and one in .github, set 2026-11-09. Neither repository has a failed Triage run. Key Vault holds .github's, as `kv-david-noble-at-work/dot-github--ADD-TO-PROJECT-PAT`.
- **David-Noble-at-work-sandbox/sandbox** lost its `ADD_TO_PROJECT_PAT` on 2026-11-19, between 06:14:42 and 06:15:17 UTC. Every Triage run since has failed. What removed it isn't known.
- **`apply`** takes the secret names from the Triage workflow template (`_secrets_of` in `commands/participation.star`) and sets each from `--token`. A secret not given becomes a step by hand, and `apply` reports success (`_secrets`). Cases 29b and 30 hold that behavior.
- **`apply` and `restore` land file and workflow changes through `land` in `commands/pull.star`,** which opens a pull request, waits for its checks and merges it itself. #614 changes that path to stop for your review. Variables, squash settings and secrets are written directly, with no pull request.
- **`--token`** takes `env:<NAME>` and `file:<path>`. Every other source is refused, `vault:` included (case 34), under [MODEL-005](../../architecture/issue-data-model/6-the-asset-and-its-sync.decisions.md#model-005), recorded first as decision 15 of #437's plan.
- **An extension's commands get no standard input.** `commands/reconcile.star` refuses a model on standard input until the command provider, NobleFactor/devlore-cli#1136, lands.
- **The models,** `reference/organization.yaml`, `reference/user.yaml` and each account's `model.yaml`, say nothing about tokens.
- **Star's extension format** has one-line help only: devlore-cli's `cmd/star/extension/command.go` has a `Help` field and nothing longer.
- **Since #596, the status companions of sections 3, 4 and 6 are superseded references,** and each section's decisions are in its `.decisions.md` file.
- **A draft inventory and a bootstrap script for the sandboxes** are in `~/Workspace/NobleFactor/scratch/noblefactor-engprod.451-credentials/`: `credentials.md` and `set-sandbox-credentials.bash`.

<a id="design-impact"></a>

## 4. Design impact

- **[Section 4](../../architecture/issue-data-model/4-storage-and-reach.md), § 4.1 Credentials:** becomes the inventory of § 2, item 5, the sandboxes included, and states the rule: every account identifies its token.
- **[Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md), § 1.1 Model record, § 5 Reconcile a model and § 8 Access and secret handling:** the model's `token` record; the preflight and refusal of `apply`, `restore` and `diff`; what `get` and `backup` write; `vault:` sources; `token make`.
- **Decision records:**
  - In [`4-storage-and-reach.decisions.md`](../../architecture/issue-data-model/4-storage-and-reach.decisions.md): every account identifies its token, and `apply` refuses an account that doesn't. Its uses and permissions are free to change. Where `star` can't make a token, the refusal and the help say how.
  - In [`6-the-asset-and-its-sync.decisions.md`](../../architecture/issue-data-model/6-the-asset-and-its-sync.decisions.md), two new records. One gives the model its `token` record and the per-binding meaning of `held`. The other allows `vault:` sources, which amends MODEL-005 in part: `star` may call `az` to read a secret, and the value still goes from its source to `gh secret set` through one shell pipeline and never enters Starlark or a record. MODEL-005 stays as recorded. The new record states the part it changes, its approval and its consequences.
  - Each record stays `proposed` until you approve it.
- **User docs:** `docs/reference/issue-tracking-credentials.md`, from the draft inventory, and the help of `apply`, `restore` and `token make`, which names it. It sits beside `docs/reference/star-github/`, where #592 will generate the commands' reference, and not inside it, so that regenerating that reference can't remove it; since #596, `docs/guides/` holds only retained entry points.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

<a id="the-token-record"></a>

### 5.1 The token record

Each model gains one record:

```yaml
# An organization
token:
  kind: github-app
  secrets:
    NOBLEFACTOR_AUTOMATION_APP_ID: vault:kv-nf-engprod-dev/NobleFactor-sandbox--NOBLEFACTOR-AUTOMATION-APP-ID
    NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY: vault:kv-nf-engprod-dev/NobleFactor-sandbox--NOBLEFACTOR-AUTOMATION-APP-PRIVATE-KEY

# A user account
token:
  kind: classic-token
  secrets:
    ADD_TO_PROJECT_PAT: vault:kv-nf-engprod-dev/David-Noble-at-work-sandbox--ADD-TO-PROJECT-PAT
```

- `kind` is `github-app` or `classic-token`.
- `secrets` names each secret that holds the token and where its value comes from: `vault:<vault>/<name>`, `env:<NAME>`, `file:<path>`, or `held`.
- **A binding** is a place a consumer reads the secret. For an organization, it is the organization secret, which must be visible to every repository that takes part in triage: visibility `all`, or `selected` with each of them selected. For a user account, it is the repository secret in each repository that takes part.
- **`held`** means GitHub holds the secret at every binding. A secret held at some bindings and not others isn't `held`.
- A user account has one token, set at each of its bindings.
- Vault names are `<account>--<NAME>`, the secret's name with its underscores made hyphens, since the token belongs to the account.
- The reference models carry the record's shape with no sources. Applying one to an account takes the sources from `--token`, as today.
- **`get`** reads GitHub, which never reveals a secret's value. For each secret held at every binding, it writes the source the account's current backup records for it, or `held` when the backup records none, and it leaves out a secret that isn't held everywhere. `backup` writes what `get` returns, byte for byte, so a backup never replaces a recorded `vault:` locator with `held`.

<a id="the-refusal"></a>

### 5.2 The preflight and the refusal

Before its first write, `apply`, and `restore`, which applies a backup the same way, check every binding of every secret:

1. The model, or `--token` for a reference model, identifies a token.
2. Its secrets include every secret the account's Triage workflow signs in with.
3. Every binding can be read. A secret listing GitHub refuses, because the signed-in account can't administer the organization or the repository, is reported as unreadable, not as missing.
4. Every source can be read: the vault secret exists and `az` is signed in, the variable is set, the file is readable by its owner alone. For `held`, the secret is present at every binding.
5. For a `github-app` token, the app is installed on the account and an installation token can be minted from the identified secrets. Minting needs the private key's value, which only a shell pipeline may read, so this check lands in Phase 5 with `token make`, which mints the same way; a `held` key can't be checked, since GitHub never reveals it.

If any check fails, the command writes nothing and exits non-zero. Its message names each binding and source that failed, says whether it was missing or unreadable, and says how to fix it: `star github token make <account>`, or the steps by hand for the token's kind from the guide. The step-by-hand record for a secret goes away. `diff` reports a missing, unidentified or unreadable token as a difference.

<a id="vault-sources"></a>

### 5.3 Vault sources

`vault:<vault>/<name>` is read with `az keyvault secret show --vault-name <vault> --name <name> --query value -o tsv` and piped to `gh secret set` in the same pipeline `env:` and `file:` use, so the value never enters Starlark. A record shows the first 12 hexadecimal digits of its SHA-256, as today. When `az` isn't signed in, the preflight refuses and says to run `az login`.

<a id="making-a-token"></a>

### 5.4 Making a token

**Input.** An extension's commands get no standard input until NobleFactor/devlore-cli#1136 lands, so `token make` never prompts. Each value it needs, a manifest's code or a classic token, comes from a source named on its command line, `env:<NAME>` or `file:<path>`, as `--token` takes one. Your shell does the prompting; the guide shows `read -rs CODE && export CODE`. So the command runs the same with or without a terminal, and stopping it before a step writes leaves nothing behind.

**New, adopted or replaced.**

- **New:** the account has no token, at any binding or in the vault. `token make` creates one.
- **Adopted:** a working token is already in the vault under the record's names, as Phase 2's bootstrap leaves the sandboxes. `token make` verifies it, creates nothing, and prints the `token` record.
- **Replaced,** only with `--replace`: `token make` creates the new credential as new versions of the same vault secrets. The working credential is left in place. GitHub's secrets change only when `apply` runs. The old key or token is revoked by hand, only after every consumer is verified on the new one.
- Without `--replace`, `token make` refuses an account whose token works.

**An organization,** in three runs:

1. `star github token make <org> --vault <vault>` writes the app's manifest, with its permissions from `templates/automation-app.json` in the extension, the organization's page on GitHub as its redirect URL, and a random state. It writes a local page whose form posts the manifest to GitHub's new-app page for the organization, opens it, and prints the next command. Nothing exists on GitHub yet.
2. You confirm on GitHub, which creates the app and sends the browser to the redirect URL with `code` and `state` in its address. The code is good for one hour. You put the code in a variable and run `star github token make <org> --vault <vault> --code env:CODE`. `star` checks the state and exchanges the code for the app's ID, slug and private key (`POST /app-manifests/{code}/conversions`). It writes the key first to a file only you can read, under `~/.local/state/star/`, then stores the ID and the key in the vault, checks each by hash, and deletes the file only once both are stored. It then opens the app's install page.
3. You install the app on all repositories, and run `star github token make <org> --vault <vault>` again. It checks that the app is installed and an installation token can be minted, and prints the `token` record.

**Partial results.** `star` deletes nothing on failure, and never rolls back an app, a key or a vault secret. Each run reports what exists and the next command:

- If the conversion succeeds and storing fails, the key stays in its protected file. `star` names the file and the app, and a run with `--from file:<path>` stores it.
- If one value was stored and the other wasn't, the next run stores the missing one.
- If the key is lost, generate a new one on the app's page and store it with `--from`, then delete the lost one there.
- If the installation was canceled, the next run reports that the app isn't installed and gives its install link. Until it is installed, `apply`'s preflight refuses the account.

**A user account,** in two runs. GitHub offers no way to make a classic token from a script.

1. `star github token make <user> --vault <vault>` opens `https://github.com/settings/tokens/new` with the note and the `repo` and `project` scopes filled in, and prints the next command.
2. You generate the token signed in as the account, put it in a variable, and run `star github token make <user> --vault <vault> --from env:TOKEN`. `star` checks that the token belongs to the account and has both scopes, reads its expiry from GitHub's `GitHub-Authentication-Token-Expiration` header, stores it in the vault with that expiry, and prints the `token` record.

The token's permissions and scopes live in the extension's templates, not the model, so they can change as the work does.

<a id="the-sandboxes"></a>

### 5.5 The sandboxes

Phase 2 fixes the sandboxes before the rest of the work, under its own limited authorization (§ 6, question 6). Its scope:

- Create NobleFactor-sandbox's app by hand on GitHub, as the draft inventory describes, with the same permissions as NobleFactor's.
- Make David-Noble-at-work-sandbox's classic token by hand.
- Run `set-sandbox-credentials.bash org` and `set-sandbox-credentials.bash user`. The script stores each value in `kv-nf-engprod-dev` under the names in § 5.1, sets the secrets from the vault, and proves each account with a Triage run on a test issue.
- Close each proof issue with `star github issue close` and the run as its evidence, which also removes its Triage row.

Once §§ 5.1 to 5.4 land, `token make` adopts these credentials (§ 5.4), each sandbox's model gets its `token` record, and `apply` runs against it as this work's verification.

<a id="live-verification-path"></a>

### 5.6 The live verification path

`apply` and `restore` land file and workflow changes through `land`, which merges a pull request itself, and #614 changes that path. So no live run in this work may reach `land`:

- Before each live `apply` or `restore`, `star github model diff` must show no difference in the account's files or workflows. The run stops otherwise.
- The live run's writes are limited to secrets, and to variables and squash settings that are already correct.
- The refusal cases refuse before any write, so they never reach `land`.
- A live run that would land a pull request waits for #614.

<a id="tests"></a>

### 5.7 Tests

New cases in `tests/Test-StarGitHub`, each refusing case proving zero writes:

- **The preflight:**
  - no `token` record;
  - a record missing a secret the template names;
  - a source that can't be read;
  - a secret held in one participating repository and not another;
  - an organization secret whose visibility doesn't reach a participating repository;
  - a secret listing GitHub refuses, reported as unreadable;
  - an app not installed;
  - `restore` from a backup that records `held` for a secret now missing at a binding.
- **Sources:** `apply` sets a secret from `vault:`, and its value appears in no record.
- **`get` and `backup`:** `get` writes `held` only for a secret held at every binding, and `backup` keeps a recorded `vault:` locator.
- **`token make`:**
  - a manifest's code exchanged and both values stored;
  - a state that doesn't match, refused;
  - a conversion followed by a failed store, which keeps the key file and names the next command;
  - a run that stores the one missing value;
  - an existing working credential adopted, and refused without `--replace`;
  - a user token's login and scopes checked;
  - a run with no terminal that completes from its sources.

Cases 29b, 30 and 34 are rewritten for the refusal and for `vault:`.

<a id="the-inventory"></a>

### 5.8 The inventory and renewal

The inventory, in section 4 § 4.1 and the guide, has one entry per credential:

- its account and kind;
- where it is held: each GitHub binding and its vault copy;
- the processes that use it and the permissions each needs, as they stand;
- its expiry date, for a classic token, or its rotation date, for an app key;
- its warning margin;
- how to renew or rotate it.

This work sets the renewal dates and warning margins, and #613's reminders and alerts act on them. The evidence for #451 is a comment linking the merged inventory and showing each credential's next renewal date and warning margin.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **Keep a missing token as a step by hand.** Rejected. That is how both sandboxes ran broken for days.
- **Record a token's uses and permissions in the model.** Rejected. They change as the work does; the inventory records them as they stand.
- **One token per user-account repository,** as personal and .github have today. Rejected in favor of one per account, for operational simplicity. Separate tokens would allow each to be revoked and rotated on its own, though their authority is the same. personal's and .github's keep working until their next renewal, which sets one token on both.
- **Install NobleFactor's app on the sandbox.** Rejected. It is installable only on NobleFactor, and a test account never holds a production key.
- **Prompt for the code and the token inside `star`.** Rejected for now: an extension's commands get no standard input until NobleFactor/devlore-cli#1136. Named sources work with or without a terminal.
- **A local web server to catch the manifest's redirect.** Rejected. `star`'s runtime has none, and the code arrives in the browser's address.
- **Longer help in `star`.** It needs devlore-cli to read a longer help field from an extension. Until it does, the one-line help names the guide.

Questions for you, 6 of them:

1. **Production's app key in Key Vault.** No copy exists outside GitHub, so storing one means generating a new key, which reaches the seven workflows that sign in with it. My call: yes, as a separately scheduled rotation, with the new key verified through every consumer before the old one is revoked. Codex agrees.
2. **One token per user account,** as above. My call: yes. Codex calls it reasonable for operational simplicity.
3. **The command's name, `star github token make`.** My call: yes. Codex has no technical objection.
4. **A devlore-cli feature for longer extension help.** My call: file it now. Codex agrees, and notes that it doesn't solve the input question, which § 5.4 answers.
5. **The app-key rotation interval and the classic-token warning margin,** which the inventory records and #613 enforces. My call: rotate app keys yearly; warn 14 days before a classic token expires.
6. **Phase 2 before the plan is approved,** limited to the scope in § 5.5. My call: yes, since both sandboxes are broken now. Codex agrees it can be authorized separately, once the bootstrap discrepancies it found are fixed, and they are.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Preflight and refusal | `apply` and `restore` write nothing, exit non-zero, and name what is missing or unreadable, and how to fix it, for every condition in § 5.7 | The cases; a live run against a sandbox's model with its record removed | Stand-in gh; NobleFactor-sandbox, by the path in § 5.6 |
| Vault source | A secret set from `vault:`; its value in no record | The case; a live `apply` of each sandbox's model | Stand-in gh and az; both sandboxes, by the path in § 5.6 |
| `get` and `backup` | `held` only where every binding holds the secret; a recorded `vault:` locator kept | The cases | Stand-in gh |
| Making a token | An app made from its manifest and stored; the sandboxes' credentials adopted; a user token checked and stored; each partial result reported with its next command | The cases; live `token make` in both sandboxes | Stand-ins; both sandboxes |
| The sandboxes | Each sandbox's Triage run succeeds, and its proof issue is closed with its evidence | Phase 2's runs, posted on #451 | Both sandboxes |
| The inventory | Every credential listed with the entries of § 5.8, the sandboxes included | Review, and the comment of § 5.8 on #451 | This branch, then develop |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commits of §§ 9.3 to 9.6, reviewed | Pending |
| Merge | Yes | The pull request and the commit it lands | Pending |
| Deployment | Yes, `writ deploy`, for the extension to run | The deployed extension | Pending |
| Verification | Yes, in both sandboxes | § 7's live checks, posted on #451 | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-the-plan"></a>

### 9.1 Phase 1: the plan

- [ ] This plan reviewed by Codex and approved by you, then #451's body rewritten to match.

<a id="phase-2-the-sandboxes-tokens"></a>

### 9.2 Phase 2: the sandboxes' tokens

- [ ] NobleFactor-sandbox's app made and its secrets set with `set-sandbox-credentials.bash org`, proven by a Triage run, and the proof issue closed with its evidence.
- [ ] David-Noble-at-work-sandbox's token made and set with `set-sandbox-credentials.bash user`, proven the same way.

<a id="phase-3-the-record-and-the-refusal"></a>

### 9.3 Phase 3: the record and the preflight

- [x] The `token` record in both reference models; what `get` and `backup` write; the preflight and refusal in `apply`, `restore` and `diff`, checks 1 to 4 of § 5.2; their cases, and every existing case that applies a model to an account whose `.github` holds a Triage template given its token; section 6 and its decision records to match.

<a id="phase-4-vault-sources"></a>

### 9.4 Phase 4: vault sources

- [x] `vault:` for `--token` and the record; its cases; section 6 and the decision record that amends MODEL-005 to match.

<a id="phase-5-making-a-token"></a>

### 9.5 Phase 5: making a token

- [x] `star github token make`, its manifest template, its cases; the preflight's check 5 of § 5.2, as the app's installation; section 6 to match. With the change, the suite passes all 658 checks; without it, 56 fail, every new case from 195 to 221 among them but case 201, which a token held everywhere passes either way.

<a id="phase-6-the-documents"></a>

### 9.6 Phase 6: the inventory and the guide

- [ ] Section 4 § 4.1's inventory and its decision record, `docs/reference/issue-tracking-credentials.md`, and the commands' help.

<a id="phase-7-merge-deployment-and-verification"></a>

### 9.7 Phase 7: merge, deployment and verification

- [ ] Merged and deployed; § 7's live checks in both sandboxes, by the path in § 5.6; the evidence and the inventory comment posted on #451.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/`:
  - `commands/participation.star`, `commands/tokens.star`, `commands/github-model-apply.star`, `commands/github-model-restore.star`, `commands/github-model-diff.star`, `commands/github-model-get.star`, `commands/github-model-backup.star`: the record, the preflight and `vault:`.
  - `commands/github-token-make.star` and `templates/automation-app.json`: new.
  - `reference/organization.yaml` and `reference/user.yaml`: the record.
  - `extension.yaml`: `token make`, and the help.
- `tests/Test-StarGitHub`: the cases.
- `docs/architecture/issue-data-model/4-storage-and-reach.md` and `4-storage-and-reach.decisions.md`.
- `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md` and `6-the-asset-and-its-sync.decisions.md`.
- `docs/reference/issue-tracking-credentials.md`: new.
- Outside the repository, for Phase 2 only: `~/Workspace/NobleFactor/scratch/noblefactor-engprod.451-credentials/set-sandbox-credentials.bash`.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- **#614,** Model publication: live runs that would land a pull request wait for it (§ 5.6).
- **#613,** the alerts: it reads the inventory and the `token` record, and acts on the renewal dates and warning margins this work sets. It follows this work.
- **NobleFactor/devlore-cli#1136,** the command provider: `token make` doesn't need it, since it takes named sources; prompting inside `star` would.
- **Longer help in star** depends on devlore-cli (question 4).
- **Phase 2** waits on you: its own authorization, and you signed in to GitHub as each sandbox's owner.

<a id="approval-and-departures"></a>

## 12. Approval and departures

- This plan is a draft, not yet approved. No implementation is authorized.
- **Codex's review of revision c34efdc, 2026-11-20,** recommended changes before approval. This revision answers its findings:
  1. Live verification never reaches `land` (§ 5.6), and #614 is a dependency.
  2. `token make` takes named sources instead of prompting (§ 5.4).
  3. `held` is defined per binding, the preflight checks every binding before the first write, unreadable is told from missing, and what `get` and `backup` write is set out (§§ 5.1, 5.2 and 5.7).
  4. The inventory keeps #451's renewal dates and warning margins, and the reminders move to #613 (§ 5.8).
  5. New, adopted and replaced credentials, partial results, re-entry and the manifest's redirect are set out, with no automatic rollback (§ 5.4).
  6. The bootstrap script now writes the vault names of § 5.1.
  7. The documentation impact names the decision files, not the superseded status companions, and records the change to MODEL-005 as a new decision (§ 4).
  8. The bootstrap proof closes its issue with `star github issue close` and its evidence (§ 5.5).
- The rule this plan carries out, decided 2026-11-20: every account identifies its token, and `apply` refuses an account that doesn't. Its uses and permissions are free to change. Where `star` can't make a token, the refusal and the help say how.

<a id="completion-review"></a>

## 13. Completion review

Pending.
