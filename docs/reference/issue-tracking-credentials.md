---
title: "Issue-tracking credentials"
type: Guide
status: Draft
updated: 2026-11-20
---

# Issue-tracking credentials

Every account that issue tracking runs in has one token, which its Triage workflow signs in with: a GitHub App for an organization, a classic personal access token for a user account. `star github model apply` and `restore` refuse an account whose model doesn't identify that token, or whose token isn't where the model says, and write nothing. This guide says what each account needs, how to make it, how to name it to `star`, and how to check and renew it.

The design is [section 4, § 4.1 Credentials](../architecture/issue-data-model/4-storage-and-reach.md#triage), and the work that made the rule is [#451](https://github.com/NobleFactor/noblefactor-engprod/issues/451).

<a id="what-each-account-needs"></a>

## 1. What each account needs

| Account kind | Token | GitHub holds it as | Made by |
| --- | --- | --- | --- |
| Organization | A GitHub App of the organization's own, installed on all its repositories | The organization secrets the Triage workflow template names, `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`, visible to every participating repository | An owner of the organization |
| User account | One classic token with the `repo` and `project` scopes | The repository secret the template names, `ADD_TO_PROJECT_PAT`, on each participating repository | The account itself, signed in as it |

A Triage workflow also uses the `GITHUB_TOKEN` GitHub gives every run. Nobody makes or renews it.

What a token is used for and which permissions it carries change as the work does. The model records neither: it records which token the account has and where its value comes from.

<a id="the-token-record"></a>

## 2. The token record

An account's model names its token in a `token` record:

```yaml
token:
  kind: github-app
  secrets:
    NOBLEFACTOR_AUTOMATION_APP_ID: held
    NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY: held
```

- `kind` is `github-app` for an organization, `classic-token` for a user account.
- `secrets` names each secret the Triage workflow signs in with, and where its value comes from:
  - `env:<NAME>`, an environment variable set for the run;
  - `file:<path>`, a file only its owner can read, mode 600 or stricter;
  - `vault:<vault>/<name>`, a secret in Azure Key Vault, which `star` reads with `az`, signed in;
  - `held`, a secret GitHub already holds everywhere a workflow reads it.
- `star github model get` writes the record from what GitHub holds. For each secret held everywhere, it keeps the source the account's current backup records, or writes `held`. It leaves out a secret GitHub doesn't hold everywhere.
- A reference model names the kind alone. Applying one takes each secret's source from `--token`.

`--token` names a source on the command line, `<SECRET>=env:<NAME>`, `<SECRET>=file:<path>` or `<SECRET>=vault:<vault>/<name>`, comma-separated, and replaces what the record names. A token's value is never taken on the command line. Key Vault names a token's secrets `<account>--<SECRET>`, the secret's underscores made hyphens.

<a id="what-apply-checks"></a>

## 3. What apply checks first

Before its first write, `apply`, and `restore`, check each place a workflow reads each secret:

- in a user account, the repository secret in each participating repository;
- in an organization, the organization secret, which must reach each participating repository, or that repository's own secret of the same name.

They refuse, write nothing, and say how to fix it when:

- the model, or `--token`, names no source for a secret the template signs in with;
- a secret recorded as `held` is missing at any of those places;
- GitHub refuses to list the secrets at a place, because the account `gh` is signed in as can't administer it; this is reported apart from a missing secret;
- a named source can't be read: the variable isn't set, the file is readable by others, `az` isn't signed in, or the vault lacks the secret;
- an organization's app isn't installed on it, when its ID comes from a source `star` can read;
- the record's kind doesn't match the account's.

`star github model diff` reports a secret the record names no source for as a `token` record, `unidentified`, beside the `secret` records for anything missing or unreadable.

<a id="making-a-token-with-star"></a>

## 4. Making a token with star

`star github token make <account> --vault <vault>` makes the account's token where GitHub allows it and stores each value in the vault. It asks nothing at a prompt: a code or a token comes from a source you name, `env:<NAME>` or `file:<path>`, so let your shell do the asking with `read -rs`. Each run says what exists and the next command, and running it again finishes what is left; nothing is ever rolled back or deleted.

**An organization,** in three runs:

1. `star github token make <organization> --vault <vault>` writes the app's manifest, with the permissions of § 5, and opens a page that posts it to GitHub. Confirm there.
2. GitHub then shows the organization's page with `code=` in its address, good for one hour. Put the whole address in a variable and run the next command:

   ```bash
   read -rs CODE && export CODE
   star github token make <organization> --vault <vault> --code env:CODE
   ```

   It checks the address came from the first run, exchanges the code for the app's ID and private key, stores both, and opens the app's install page. Install it on all repositories.
3. `star github token make <organization> --vault <vault>` again finds the app installed and prints the token record to put in the account's model.

If the private key is lost, generate a new one on the app's page and store it with `--from file:<key>.pem`; then delete the lost one there.

**A user account,** in two runs. GitHub offers no way to make a classic token from a script:

1. `star github token make <account> --vault <vault>` opens GitHub's new-token page with the note and the `repo` and `project` scopes filled in. Generate the token there, signed in as the account.
2. Put it in a variable and store it:

   ```bash
   read -rs TOKEN && export TOKEN
   star github token make <account> --vault <vault> --from env:TOKEN
   ```

   It checks the token belongs to the account and has both scopes, reads its expiry, stores it with that expiry, and prints the token record.

A token already in the vault under those names is adopted: checked, and its record printed. `--replace` makes a new one as new versions of the same vault secrets, leaving GitHub's secrets as they are until `apply` runs; revoke the old one only after every workflow works on the new one.

<a id="making-an-organizations-token"></a>

## 5. Making an organization's token by hand

1. Sign in to github.com as an owner of the organization. Click your profile picture, then **Your organizations**, then **Settings** beside the organization, then **Developer settings** and **GitHub Apps** in the left sidebar, then **New GitHub App**.
2. Fill in the form:
   - **GitHub App name:** `<organization>-automation`, in lowercase.
   - **Homepage URL:** `https://github.com/<organization>`.
   - **Webhook:** clear **Active**. Workflows mint tokens from the app; it answers no events.
   - **Repository permissions:** Contents, read and write. Issues, read and write. Pull requests, read and write. Metadata, read-only, which GitHub sets itself.
   - **Organization permissions:** Projects, read and write. Issue fields, read-only.
   - **Where can this GitHub App be installed?** Only on this account.
3. Select **Create GitHub App**, and copy the **App ID** from the page that opens.
4. Under **Private keys**, select **Generate a private key**. A `.pem` file downloads.
5. Select **Install App**, then **Install** beside the organization, with **All repositories**.
6. Name both values to `apply`, the key by its file:

   ```bash
   chmod 600 ~/Downloads/<key>.pem
   read -rs APP_ID && export APP_ID
   star github model apply <model> <organization> \
       --token NOBLEFACTOR_AUTOMATION_APP_ID=env:APP_ID,NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY=file:<path-to-key>
   ```

   `apply` sets both as organization secrets, visible to all repositories. Store the key where you keep secrets, then delete the downloaded file.

These are the permissions NobleFactor's app has. The Triage workflow itself needs only Issues, Projects and Issue fields.

<a id="making-a-user-accounts-token"></a>

## 6. Making a user account's token by hand

1. Sign in to github.com as the account. The token must be made by the account it serves: a classic token acts as the account that made it, and reaches everything that account can.
2. Open `https://github.com/settings/tokens/new`, the page for a classic token.
   - **Note:** `ADD_TO_PROJECT_PAT for <account>'s Triage workflow`.
   - **Expiration:** your choice. Record the date; renewal is due then.
   - **Scopes:** `repo` and `project`.
3. Select **Generate token**, and copy it.
4. Name it to `apply`:

   ```bash
   read -rs TOKEN && export TOKEN
   star github model apply <model> <account> --token ADD_TO_PROJECT_PAT=env:TOKEN
   ```

   `apply` sets it on each participating repository.

GitHub offers no way to make a classic token from a script, so making it is always by hand; `star github token make` opens the page and stores what you make (§ 4).

<a id="checking"></a>

## 7. Checking

List what each account holds, by name. GitHub never shows a secret's value.

```bash
gh secret list --org <organization>
gh secret list --repo <owner>/<repository>
star github model diff <model> <account>
```

A secret can be present and still wrong, so the proof is a Triage run that succeeds:

```bash
gh run list --repo <owner>/<repository> --workflow triage.yml --limit 5
```

<a id="renewing"></a>

## 8. Renewing

- **A GitHub App's private key doesn't expire.** To rotate it, generate a new key on the app's page, name it to `apply` with `--token`, verify every workflow that signs in with it, and only then delete the old key on the app's page.
- **A classic token expires on the date chosen when it was made.** GitHub emails the account a week before. Open the token at `https://github.com/settings/tokens` and select **Regenerate token**, which keeps its note and scopes, then name it to `apply` with `--token`.
- **A `gh` login** is whatever credential stands behind it. Renew one from the browser sign-in with `gh auth refresh -h github.com -s project,admin:org,workflow`, signed in as the account.

<a id="why"></a>

## 9. Why these credentials

- **A workflow's own token can't reach a project.** `GITHUB_TOKEN` reaches only the run's repository. A project belongs to the account, so adding an issue to the Triage project needs a credential of the account.
- **An organization uses a GitHub App.** An app acts as itself, with exactly the permissions its installation grants. A workflow mints a token from the app's ID and private key with `actions/create-github-app-token`, and the token expires within an hour. Set once on the organization, the two secrets serve every repository's workflow.
- **A user account uses a classic token.** A GitHub App can't be granted a user account's projects, and a fine-grained token can't reach them either; only a classic token with the `project` scope can, with `repo` for a private repository. One token serves all the account's participating repositories.
- **The `gh` logins** are what `star` runs as: `repo` for private repositories and their issues, `project` for projects, `admin:org` for an organization's secrets and variables, and `workflow` to land workflow files.

Any NobleFactor workflow that must write beyond its own repository can mint a token the same way, from the same two organization secrets. It gets exactly the app's permissions. A new permission is added on the app's page and then accepted on each installation.
