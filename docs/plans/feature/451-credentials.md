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
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/613
    text: "Every process that depends on a token alerts us when the token expires or goes missing, and keeps alerting until it is fixed"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/437
    text: "star github model diff, apply and restore"
---

# Every account identifies its issue-tracking token, and apply refuses an account that doesn't

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: Codex.
- Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Every account that issue tracking runs in identifies its token, and `star github model apply` refuses an account that doesn't, before it writes anything. Which token an account has, what it's used for and which permissions it carries can change over time. That it has one can't. Where GitHub lets `star` make or store a token, `star` does it. Where GitHub doesn't, the refusal and the command's help say exactly what to do.

At the end:

1. **Each model names its account's token.** The two reference models and every account's own model have a `token` record: the token's kind, the GitHub secrets that hold it, and where each secret's value comes from. The record doesn't name the token's uses or permissions.
2. **`apply` and `restore` refuse an account whose token isn't identified,** or whose token can't be found where its record says. They write nothing, name what is missing, and say how to make it. `diff` reports a missing token as a difference.
3. **A secret's value can come from Key Vault,** as `vault:<vault>/<name>`, beside today's `env:` and `file:`.
4. **`star github token make <account>` makes an account's token.** For an organization, it creates a GitHub App from a manifest, which you confirm with a click, and stores the app's ID and key in Key Vault. For a user account, it opens GitHub's new-token page with the note and scopes filled in, takes the token at a prompt that doesn't echo, checks it, and stores it in Key Vault.
5. **The credentials are documented.** Section 4 of the design lists each account's token and how it is made, checked and renewed. A user guide says the same for someone setting up an account, and the help of `apply`, `restore` and `token make` names the guide.
6. **Both sandboxes have their tokens,** set up the same way as the real accounts, each proven by a Triage run that succeeds.

Out of scope: alerting when a token expires or goes missing, which is #613; and replacing production's tokens, which § 6 leaves to a time you choose.

## Issue 451

#451 asks for the credentials issue tracking runs on to be listed in one place, with when and how each is renewed. On 2026-11-20 it widened: both sandboxes' Triage workflows had failed for days, unnoticed, because neither had its token and nothing required one. Its body is rewritten to match this plan when the plan is approved.

<a id="current-state"></a>

## 3. Current state

Read on 2026-11-20:

- **NobleFactor** signs its Triage workflow in with the GitHub App noblefactor-automation, app ID 2791147, through the organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`, set on 2026-02-04 and visible to all repositories. The app is installable only on NobleFactor. Six other workflows sign in with the same key. Key Vault holds no copy: `kv-nf-engprod-prd` is empty.
- **NobleFactor-sandbox** has never had either secret. Its organization holds no secrets and no app. All 77 Triage runs since the workflow landed on 2026-11-12 failed.
- **David-Noble-at-work** signs in with classic tokens in the repository secret `ADD_TO_PROJECT_PAT`, one in personal, set 2026-11-10, and one in .github, set 2026-11-09. Neither repository has a failed Triage run. Key Vault holds .github's, as `kv-david-noble-at-work/dot-github--ADD-TO-PROJECT-PAT`.
- **David-Noble-at-work-sandbox/sandbox** lost its `ADD_TO_PROJECT_PAT` on 2026-11-19, between 06:14:42 and 06:15:17 UTC. Every Triage run since has failed. What removed it isn't known.
- **`apply`** takes the secret names from the Triage workflow template (`_secrets_of` in `commands/participation.star`) and sets each from `--token`. A secret not given becomes a step by hand, and `apply` reports success (`_secrets`). Cases 29b and 30 hold that behavior.
- **`--token`** takes `env:<NAME>` and `file:<path>`. Every other source is refused, `vault:` included (case 34), under decision 15 of #437's plan: `star` calls no other tool for a secret.
- **The models,** `reference/organization.yaml`, `reference/user.yaml` and each account's `model.yaml`, say nothing about tokens.
- **Star's extension format** has one-line help only: devlore-cli's `cmd/star/extension/command.go` has a `Help` field and nothing longer.
- **A draft list of the credentials and a script that sets the sandboxes' tokens** are in `~/Workspace/NobleFactor/scratch/noblefactor-engprod.451-credentials/`: `credentials.md` and `set-sandbox-credentials.bash`.

<a id="design-impact"></a>

## 4. Design impact

- **[Section 4](../../architecture/issue-data-model/4-storage-and-reach.md), § How the Triage workflow signs in:** becomes the list of each account's token, the sandboxes included, with how each is made, checked and renewed, and states the rule: every account identifies its token.
- **[Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md):** the model's `token` record; `apply`, `restore` and `diff` and the refusal; `vault:` sources; `token make`.
- **Status companions** of sections 3, 4 and 6: the row for the credentials the Triage workflow signs in with, in `3-collections.status.md`, and the rows of sections 4 and 6 that name them.
- **Decision 15 of #437's plan changes in part:** `star` may call `az` to read a `vault:` source. The value still goes from its source to `gh secret set` through one shell pipeline and never enters Starlark or a record.
- **User docs:** `docs/guides/issue-tracking-credentials.md`, from the draft, and the help of `apply`, `restore` and `token make`, which names it.

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
- `secrets` names each secret that holds the token and where its value comes from: `vault:<vault>/<name>`, `env:<NAME>`, `file:<path>`, or `held`, a secret GitHub already holds.
- A user account has one token, set on each repository that takes part in triage.
- The reference models carry the record's shape with no sources. Applying one to an account takes the sources from `--token`, as today.
- `get` writes `held` for each secret GitHub has, since GitHub never reveals a secret's value. An account's backed-up model can name a `vault:` source instead.

<a id="the-refusal"></a>

### 5.2 The refusal

Before it writes anything, `apply`, and `restore`, which applies a backup the same way, check three things:

1. The model, or `--token` for a reference model, identifies a token.
2. Its secrets include every secret the account's Triage workflow signs in with.
3. Each source can be read: the vault secret exists and `az` is signed in, the variable is set, the file is readable by its owner alone, or the `held` secret is on GitHub.

If any check fails, the command writes nothing and exits non-zero. Its message names each missing piece and how to supply it: `star github token make <account>`, and the steps by hand for the token's kind from the guide. The step-by-hand record for a secret goes away. `diff` reports a missing or unidentified token as a difference.

<a id="vault-sources"></a>

### 5.3 Vault sources

`vault:<vault>/<name>` is read with `az keyvault secret show --vault-name <vault> --name <name> --query value -o tsv` and piped to `gh secret set` in the same pipeline `env:` and `file:` use, so the value never enters Starlark. A record shows the first 12 hexadecimal digits of its SHA-256, as today. When `az` isn't signed in, the refusal says to run `az login`.

<a id="making-a-token"></a>

### 5.4 Making a token

`star github token make <account> --vault <vault>`:

- **An organization.** `star` writes the app's manifest, its permissions from `templates/automation-app.json` in the extension, and a local page whose form posts it to GitHub's new-app page for the organization, and opens the page. You confirm, and GitHub shows the organization's page with a code in its address. You paste the code, and `star` exchanges it for the app's ID and private key (`POST /app-manifests/{code}/conversions`), stores both in the vault, and opens the app's install page, where you install it on all repositories. Pasting the code spares `star` a local web server, which its runtime doesn't have.
- **A user account.** GitHub offers no way to make a classic token from a script. `star` opens `https://github.com/settings/tokens/new` with the note and the `repo` and `project` scopes filled in. You sign in as the account and generate the token, then paste it at a prompt that doesn't echo. `star` checks that it belongs to the account and has both scopes, reads its expiry from GitHub's answer, and stores it in the vault with its expiry.
- Either way, `star` prints the `token` record to put in the account's model.

The token's permissions and scopes live in the extension's templates, not the model, so they can change as the work does.

<a id="the-sandboxes"></a>

### 5.5 The sandboxes

The sandboxes are fixed first, with the draft script, and each is proven by a Triage run that succeeds. Once §§ 5.1 to 5.4 land, each sandbox's model gets its `token` record and `apply` runs against it, as this work's verification.

<a id="tests"></a>

### 5.6 Tests

New cases in `tests/Test-StarGitHub`:

- `apply` and `restore` refuse a model with no token record, one whose secrets miss one the template names, and one whose source can't be read. Each case writes nothing.
- `apply` sets a secret from `vault:`, and its value appears in no record.
- `get` writes `held`.
- `token make` exchanges a manifest's code, and checks a user token's login and scopes.

Cases 29b, 30 and 34 are rewritten for the refusal and for `vault:`.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **Keep a missing token as a step by hand.** Rejected. That is how both sandboxes ran broken for days.
- **Record a token's uses and permissions in the model.** Rejected. They change as the work does; the guide describes them as they stand.
- **One token per user-account repository,** as personal and .github have today. Rejected in favor of one per account: a classic token reaches everything its account can, so separate tokens isolate nothing. personal's and .github's keep working until their next renewal, which sets one token on both.
- **Install NobleFactor's app on the sandbox.** Rejected. It is installable only on NobleFactor, and a test account never holds a production key.
- **A local web server to catch the manifest's redirect.** Rejected. `star`'s runtime has none, and pasting the code costs one step.
- **Longer help in `star`.** It needs devlore-cli to read a longer help field from an extension. Until it does, the one-line help names the guide.

Questions for you, 4 of them:

1. **Production's tokens in Key Vault.** No copy of NobleFactor's app key exists outside GitHub. Storing one means generating a new key, which reaches the seven workflows that sign in with it. My call: yes, at a time you choose, apart from this work; until then NobleFactor's record says `held`.
2. **One token per user account,** as § 6 proposes. My call: yes.
3. **The command's name, `star github token make`.** My call: yes.
4. **A devlore-cli feature for longer extension help.** My call: file it now, so the guide link is a stopgap, not the answer.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Refusal | `apply` and `restore` on a model with no token, an incomplete one or an unreadable source write nothing, exit non-zero, and name what to do | New cases, and a live run against a sandbox's model with its record removed | Stand-in gh; NobleFactor-sandbox |
| Vault source | A secret set from `vault:`; its value in no record | New case; live `apply` of each sandbox's model | Stand-in gh and az; both sandboxes |
| Making a token | An organization's app made from its manifest and stored; a user token checked and stored | New cases; live `token make` in both sandboxes | Stand-ins; both sandboxes |
| The sandboxes | Each sandbox's Triage run succeeds | A test issue in each, its run and its Triage row | Both sandboxes |
| The documents | Section 4 lists every account's token; the guide and help say how to make each | Review | This branch |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commits of §§ 9.2 to 9.6, reviewed | Pending |
| Merge | Yes | The pull request and the commit it lands | Pending |
| Deployment | Yes, `writ deploy`, for the extension to run | The deployed extension | Pending |
| Verification | Yes, in both sandboxes | § 7's live checks, posted on #451 | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-the-plan"></a>

### 9.1 Phase 1: the plan

- [ ] This plan committed and reviewed with you, then #451's body rewritten to match.

<a id="phase-2-the-sandboxes-tokens"></a>

### 9.2 Phase 2: the sandboxes' tokens

- [ ] NobleFactor-sandbox's app made and its secrets set with `set-sandbox-credentials.bash org`, proven by a Triage run.
- [ ] David-Noble-at-work-sandbox's token made and set with `set-sandbox-credentials.bash user`, proven by a Triage run.

<a id="phase-3-the-record-and-the-refusal"></a>

### 9.3 Phase 3: the record and the refusal

- [ ] The `token` record in both reference models, written by `get`, read by `diff`, `apply` and `restore`; the refusal; its cases; section 6 to match.

<a id="phase-4-vault-sources"></a>

### 9.4 Phase 4: vault sources

- [ ] `vault:` for `--token` and the record; its cases; section 6 and decision 15's change to match.

<a id="phase-5-making-a-token"></a>

### 9.5 Phase 5: making a token

- [ ] `star github token make`, its manifest template, its cases; section 6 to match.

<a id="phase-6-the-documents"></a>

### 9.6 Phase 6: the documents

- [ ] Section 4's list, the status companions, `docs/guides/issue-tracking-credentials.md`, and the commands' help.

<a id="phase-7-merge-deployment-and-verification"></a>

### 9.7 Phase 7: merge, deployment and verification

- [ ] Merged and deployed; § 7's live checks in both sandboxes; the evidence posted on #451.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/`:
  - `commands/participation.star`, `commands/tokens.star`, `commands/github-model-apply.star`, `commands/github-model-restore.star`, `commands/github-model-diff.star`, `commands/github-model-get.star`: the record, the refusal and `vault:`.
  - `commands/github-token-make.star` and `templates/automation-app.json`: new.
  - `reference/organization.yaml` and `reference/user.yaml`: the record.
  - `extension.yaml`: `token make`, and the help.
- `tests/Test-StarGitHub`: the cases.
- `docs/architecture/issue-data-model/4-storage-and-reach.md`, `6-the-asset-and-its-sync.md` and the status companions of sections 3, 4 and 6.
- `docs/guides/issue-tracking-credentials.md`: new.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- **#613**, the alerts, reads the same `token` record to know what each account depends on. It follows this work.
- **Longer help in star** depends on devlore-cli, question 4.
- **Phase 2** waits on you: making the sandbox's app and the sandbox user's token needs you signed in to GitHub as each account's owner.

<a id="approval-and-departures"></a>

## 12. Approval and departures

- This plan is a draft, not yet approved.
- Decision 15 of #437's plan changes in part, as § 4 says: `star` may call `az` to read a `vault:` source.
- The rule this plan carries out: every account identifies its token, and `apply` refuses one that doesn't. Its uses and permissions are free to change. Where `star` can't make a token, the refusal and the help say how. Decided 2026-11-20.

<a id="completion-review"></a>

## 13. Completion review

Pending.
