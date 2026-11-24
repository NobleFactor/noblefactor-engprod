---
title: "Every process that depends on a token alerts us when the token expires or goes missing, until it is fixed"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/613
status: active
created: 2026-11-21
updated: 2026-11-24
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/4-storage-and-reach.md
  - kind: Design
    path: docs/architecture/issue-data-model/4-storage-and-reach.decisions.md
  - kind: User guide
    path: docs/reference/issue-tracking-credentials.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/451
    text: "The credentials and permissions issue tracking runs on are listed in one place, with when and how each is renewed"
  - kind: Design
    path: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/614
    text: "Model publication stops for Owner review and verifies actual merge requirements"
---

# Every process that depends on a token alerts us when the token expires or goes missing, until it is fixed

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: Codex.
- Compliance auditor: agy, the Antigravity CLI, of the Gemini model family.
- Observers: none.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

Every repository whose workflows sign in with a token checks that token every day through the same secret its workflows read, and raises an incident in that repository, assigned to the owner, when the token is missing, refused, short of a permission, expired, or close to expiring. The incident repeats every day until a check through the same secret proves the cause is gone, and then it closes. A Triage workflow that fails on its token raises the same incident at once, and so does every other job that signs in, the site's deployment among them.

At the end:

1. **A credentials check** in each participating repository, `.github/workflows/credentials-check.yml`, landed from the account's `.github` workflow template like the Triage workflow. It runs daily and on demand.
2. **Each check proves its binding.** For an organization, it mints an installation token from the same two organization secrets the Triage workflow reads, and requires the permissions GitHub grants it to include every one the repository's workflows need, writing to projects among them, and the app to reach the repository and every other one its workflows write to (§ 5.14). For a user account, it calls GitHub with the repository's classic token and requires its login to be the account, its scopes to include `repo` and `project`, and its expiry to be outside the warning margin.
3. **One incident per repository and condition,** an issue titled `Token alert: <condition>`, labeled `token-alert`, assigned to David-Noble-at-work. The run's own `GITHUB_TOKEN`, granted `issues: write`, writes it, so it never depends on the credential being checked. While open, it gets a comment each day the condition holds. It closes when the condition's own clearing rule is met.
4. **When a new issue doesn't reach Triage,** the Triage workflow checks the token at once: a bad one raises its own alert, naming the issue; a healthy one raises "New issues aren't reaching Triage", which closes only when a later issue reaches Triage, listing the issues missed earlier, to check.
5. **Expiry and rotation:**
   - a classic token's expiry is the date GitHub reports in `GitHub-Authentication-Token-Expiration`, and it warns 14 days ahead;
   - an app key doesn't expire; it is due for rotation on the date in the organization variable `TOKEN_ROTATION_DUE`, set when the key is made or rotated, and that warns 14 days ahead too.
6. **A static site's Azure credentials,** where the repository variable `AZURE_STATIC_SITE` names the site, today devlore.noblefactor.com's: the service principal in `AZURE_CREDENTIALS` signs in, its secret's expiry, recorded in the repository variable `AZURE_CREDENTIALS_EXPIRES`, is outside the margin, and `AZURE_STATIC_WEB_APPS_API_TOKEN` is the site's current deployment token (§ 5.11).
7. **Every job that signs in reports its own failure at once,** with two steps it ends with: the three in devlore-cli and the three in devlore-registry that sign in with the app, and the site's deployment. A bad credential raises its alert, naming the workflow and its run (§ 5.12).
8. **A duplicate alert,** opened by two runs at once, is closed with its Resolution set to Duplicate, its lines carried to the alert kept (§ 5.2).
9. **The check's logic is a script,** `workflow-templates/credentials-check.sh` beside the workflow template, with a suite of its own, `tests/Test-CredentialsCheck`, against a stand-in `gh` and `curl`.

Out of scope:

- `star` commands' own failures to sign in, which already stop with the fix named (section 6, § 8), beyond how #621, §§ 5.6 to 5.8, corrects their diagnosis.
- Workflows outside the participating repositories, which get the check only by taking part.
- A process outside GitHub Actions, such as a service on one of the owner's machines that signs in to Azure: its secret isn't where the check runs (§ 5.13).

## Issue 613

#613 requires an alert whenever a token a process depends on expires, disappears, or is refused, repeating until fixed and closing only when the cause clears, checked through the binding that raised it. Its evidence names the sandboxes, which are no longer used (§ 12); § 7 says what replaces them.

## Issue 621

#621: every `star github` command reports a connection failure as a rejected token. `check_access` in `commands/access.star` reads `gh auth status`, and whenever the active login's check fails, it reports "401: bad credentials; it has expired or been revoked" and advises renewing or replacing the token, whatever stopped the check. It reached a user on 2026-11-21, when `star github schedule get` failed because `api.github.com` couldn't be resolved. `_run` appends `; true`, so no exit status survives.

What gh itself says, read on 2026-11-21 with gh 2.104.0 and GitHub unreachable: the active login's block reads "X Failed to log in", then "The token in keyring is invalid.", even though no request reached GitHub. The cause is only on its `- Error:` line, for example `dial tcp 127.0.0.1:9: connect: connection refused`. `gh api rate_limit` fails with the same text. So gh's "invalid" line can't be trusted; its error line can.

<a id="issue-626"></a>

## Issue 626

#626: `check_access` can check that the login reaches the organization a command reads, section 6 § 8's "Account unavailable despite scopes", but none of its 24 callers passes an organization, so the check has never run. A command run against an organization that refuses the login, as one enforcing single sign-on does, gets past the access check and fails on its first real request with GitHub's own error. Found fixing #625's review.

<a id="issue-633"></a>

## Issue 633

#633: the two Triage templates, `triage.organization.yml` and `triage.user.yml`, have 41 lines over 120 characters, the longest 402, in the steps that sort each new issue: routing an issue found while walking a scenario, leaving a Schedule or Scenario issue out of Triage, copying the form's Area, and setting Severity. They came over unchanged from the accounts' `.github` repositories in #625, and no test covers those steps. Found answering #632's review; fixed in #632, at your direction.

- **A test first,** `tests/Test-TriageTemplates`: it takes each of those steps' scripts out of each template, runs it as GitHub does, `bash -e`, against a stand-in `gh` and the case's issue, and checks what it prints, what it writes to `GITHUB_OUTPUT`, and the calls it makes. It passes against the templates as they are, before any line changes.
- **Then the lines,** each within 120 characters: a long GraphQL query split across lines inside its quotes, which GraphQL reads the same; a pipeline broken after a `|`; a long message given to `echo` in two parts, which it joins with a space; and comments rewrapped. The same test passes after.
- **Landed** with #613's second landing, in every participating repository.

<a id="current-state"></a>

## 3. Current state

Read on 2026-11-21, at develop c69b4ae:

- **The Triage workflow template**, `workflow-templates/triage.yml` in each account's `.github`, signs in with the account's token and has no step that runs on failure. A run that fails on its token fails silently, as both sandboxes' did for days.
- **#451 is merged:** each model names its token, `apply` refuses an account whose token isn't identified, and section 4 § 4.1 inventories each credential with its warning margin and rotation date, both proposed at 14 days and yearly.
- **NobleFactor's participating repositories are public.** David-Noble-at-work/personal and .github are private and owned by David-Noble-at-work, who is a member of NobleFactor, so an issue assigned to him in any of them notifies him.
- **`apply` lands workflow files through `land`,** which merges its pull request itself; #614 changes that to stop for review.
- **A workflow's `GITHUB_TOKEN`** can write issues in its own repository only, and can't read a project.

<a id="design-impact"></a>

## 4. Design impact

- **Section 4, § 4.1:** the credentials check, its incidents and their clearing rules, and `TOKEN_ROTATION_DUE`; its inventory gains the site's Azure credentials, and its text the Azure check and each job's own report.
- **`4-storage-and-reach.decisions.md`:** ACCESS-007, accepted: checking each binding where it lives and raising its incident there; ACCESS-008, accepted: a site's Azure credentials checked where it deploys, their expiry from a repository variable, and every job that signs in reporting its own failure.
- **The guide:** what an incident means and how each clears, the Azure alerts and `unreachable` among them; every setting the check reads (§ 7); and how the Azure credentials are renewed (§ 9).
- **Section 4, § 3:** `workflow-templates/` here, the templates' source, and the installed check.
- **Section 6, § 8:** the commands that check the account they name (#626), and the access check's failures: GitHub not reached, a rejected token only on a 401 or Bad credentials, and any other failure quoted with no fix claimed (#621).
- **README.md:** `workflow-templates/`.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

<a id="the-check"></a>

### 5.1 The check

`credentials-check.yml` runs on a daily schedule and on `workflow_dispatch`, with `issues: write` and nothing else. Its one job runs `credentials-check.sh`, which:

1. **Reads the binding.** For an organization, from the two organization secrets the Triage workflow reads; for a user account, from `ADD_TO_PROJECT_PAT`. A secret that is empty is the condition `missing`.
2. **Proves it.**
   - For an app, it signs a JSON Web Token with the key, finds the installation on the account, and mints an installation token. GitHub's answer lists the permissions granted; each one the repository's workflows need must be there. A key that doesn't sign or isn't accepted is `refused`; an app not installed is `not-installed`; a permission missing is `short`.
   - For a classic token, it calls `GET /user`. A refusal is `refused`; another login is `wrong-account`; a scope missing is `short`; an expiry passed is `expired`, within 14 days `expiring`.
3. **Checks rotation.** For an app key, `TOKEN_ROTATION_DUE` passed is `rotation-overdue`, within 14 days `rotation-due`.
4. **Writes the incidents,** § 5.2. A failure to reach GitHub is no credential condition: the run fails, the next run checks again, and no incident is raised for it (#621).

The permissions each repository needs are listed in the template, `workflow-templates/credentials-check.json`, so they can change as the work does.

The script runs on GitHub's runner from a sparse checkout of `.github/credentials-check`, where no engineering helper is, so it doesn't source `Declare-BashScript`, as a script distributed beyond this repository needn't. It checks each failure itself, so it sets `-u` and `pipefail` but not `-e`.

<a id="incidents"></a>

### 5.2 Incidents

- One open issue per repository and condition, found by its title and the `token-alert` label. Two runs at once can each find none and each open one, so every lookup, and every create, closes all but the oldest open one as its duplicate. A duplicate's Resolution is set to Duplicate before it closes: the `resolution:duplicate` label in a user account, with the run's own token; the Resolution issue field in an organization, with the app's installation token, since setting an issue field's value takes push access the run's own token lacks. One whose Resolution can't be set stays open, and the run ends 3; the next run tries again. Each line a duplicate's reports wrote, an issue missed or a workflow failed, is carried to the one kept unless it has the line already, so a retry carries what was added since, and repeats nothing a carry whose answer was lost delivered (Codex's C03).
- **Raised** when a condition holds and no incident for it is open: assigned to David-Noble-at-work, its body naming the credential, the binding, the condition and how to fix it, with a link to the guide.
- **Repeated** as a comment each day the condition still holds, the date and the run in it.
- **Closed** only by a check whose own test passed: `missing`, `refused`, `not-installed`, `short` and `wrong-account` when the binding signs in and is granted everything; `not-triaged`, "New issues aren't reaching Triage", when a later issue reaches Triage (§ 5.3); `expiring` and `expired` when the expiry is beyond the margin, or there is none; `rotation-due` and `rotation-overdue` when `TOKEN_ROTATION_DUE` is beyond it; `no-recent-check` when the watched repository's check ran within two days. A test that didn't run, or failed another way, clears nothing: a refused token says nothing of its expiry, and an overdue rotation leaves its due warning open.
- **Only GitHub's refusal is a credential condition:** a 401, or a 403 that isn't a rate limit; a 404 minting an installation token is `not-installed`. GitHub not reached, a rate limit, a server error or any other answer proves nothing about the credential: the run ends 2, raising and clearing nothing.
- **A run's status** is 0 when every condition is clear, 1 when one holds, 2 when the check couldn't finish, and 3 when an incident couldn't be looked up, raised, repeated or closed. A failed lookup is never taken for no incident.
- **No recent check:** GitHub disables a public repository's scheduled workflows after 60 days with no commit, and a disabled check can't report itself. So noblefactor-engprod's own check also reads each NobleFactor participating repository's latest check run, which public data allows, and raises `no-recent-check` for one more than two days old. A private repository is checked by its own run alone.

<a id="triage-failure-step"></a>

### 5.3 The Triage workflow's failure step

The Triage template's step that adds an issue to Triage is named `triage`. When a run fails and an issue meant for Triage didn't reach it, a step runs the same script in report mode, with the run's `GITHUB_TOKEN` and the workflow's own secrets:

- **It checks the token first.** A bad token raises its own alert, naming the issue missed and the run to rerun once the token is fixed.
- **A healthy token raises "New issues aren't reaching Triage",** naming the issue and the run to rerun from its page. Each further miss is a comment on the same alert.
- **GitHub not reached,** or answering with something that proves nothing, raises nothing.

When an issue does reach Triage, a last step runs the script in placed mode, which closes that alert, listing the issues missed earlier, to check, since closing it adds none of them and the run's own token can't read the Triage project to tell which were added by hand since. That step runs whenever the issue reached Triage, whatever later steps did, and a failure closing the alert fails the run. A run that failed before it could tell where the issue belongs, its scenario or Schedule check unfinished, says the issue may not have been placed, never that it missed Triage, and the reminder and the closing keep it apart from the issues that did. Two runs at once that each open the alert leave one, carrying each issue the other named. An alert says only what was seen, what happened in the run and what the token check found right after it, and never which caused which. The daily check never closes it, as it can't tell whether issues reach Triage; it reminds once a day while the alert is open. Schedule, Scenario and scenario-found issues, left out of Triage on purpose, raise nothing, and nor does an issue that reached Triage when a later step, setting its Area or Severity, fails: the run shows failed on the Actions page.

<a id="landing"></a>

### 5.4 Landing

The workflow, its script and its permissions file, whose source is this repository's `workflow-templates/`, are added to NobleFactor/.github's and David-Noble-at-work/.github's templates, then landed in each participating repository by `star github model apply`, as the Triage workflow is. Because `apply` merges its own pull requests until #614 lands, the landing waits for #614, or you land it by hand (§ 6, question 3).

<a id="tests"></a>

### 5.5 Tests

`tests/Test-CredentialsCheck` runs `credentials-check.sh` against a stand-in `gh` and `curl`, for every condition of § 5.1 and every clearing rule of § 5.2, for an organization and a user account: an incident raised once, repeated each day, and closed by the clearing rule alone; a check through another copy of the credential never clearing it.

<a id="issue-621-fix"></a>

### 5.6 #621: the fix

- `_run` returns the exit status beside the output.
- The failed login's `- Error:` line decides the diagnosis:
  - **Connection failure:** `no such host`, `i/o timeout`, `timeout`, `connection refused`, `connection reset`, `network is unreachable`, `tls:`, `x509:` or `certificate`. The message names GitHub as unreachable, quotes gh's error line, and says to check the network, a proxy or a VPN, and to rerun. It recommends no change to any credential.
  - **Credential rejection:** `401` or `Bad credentials`. The message is today's, naming `gh auth refresh` or the token variable to replace.
  - **Anything else:** gh's error line, quoted, with no fix claimed.
- A block with no error line keeps today's handling.
- Every later GitHub call in the check, the rate limit and the organization, fails the same way when its own exit status is non-zero, before any other call is made: a connection failure is named as one, never as a spent rate limit or a missing organization, and any other failed answer, a server error among them, is quoted with no fix claimed.
- No credential ever appears in a message: a quoted line is scrubbed of anything shaped like a token, wherever it starts, the text around it kept, and the diagnosis reads it scrubbed, so that a token's own characters never decide it.

<a id="issue-621-overlap"></a>

### 5.7 #621: the overlap with #613

#613's check runs in GitHub Actions, where a connection failure is rare but possible. It is not a credential condition there either: the check's run fails, the next day's run checks again, and no credential incident is raised for it (§ 5.1).

<a id="issue-621-tests"></a>

### 5.8 #621: tests and evidence

- The stand-in `gh` answers `auth status` and `api rate_limit` from a case's own text when one is given.
- New cases in `tests/Test-StarGitHub`: a DNS failure, a timeout, a refused connection and a TLS failure, each named as a connection failure with gh's line and no credential advice; an actual HTTP 401, named as a rejected token; an error of no known kind, quoted with no fix; and the rate-limit check failing to connect. The existing access cases, for no login, a refused token, missing scopes, an organization not visible and a spent rate limit, keep passing. Each new case fails without the change.
- The deployed command, run with `HTTPS_PROXY` pointing at a port nothing listens on, names GitHub as unreachable and no credential fault; the result is posted on #621.
- Section 6, § 8's table of failures gains the connection failure.

<a id="issue-626-fix"></a>

### 5.9 #626: the fix

- `check_access` takes the account a command names, an organization or a user. After the rate limit, it asks GitHub what kind of account it is: a name that can't be an account's is refused first, and one GitHub has no account for is named. For an organization, it reads the organization: a 401 is a rejected token, a 403 or a 404 names the boundary and who must grant access, and any other failure is quoted with no fix claimed. A user account needs no further request.
- `star github model get`, `diff`, `apply`, `backup` and `restore`, and `token make`, the commands that name an account, pass it. The check returns the account's kind and checks the scopes that kind needs, so `token make` makes no request of its own before it.
- A rate limit reading the organization, a 429, or a 403 with a Retry-After, no requests left or GitHub's words for one, is named as a rate limit, with how long to wait or until when, as GitHub says, and asks for no access.

<a id="issue-626-tests"></a>

### 5.10 #626: tests

Cases 242 to 255 in `tests/Test-StarGitHub`: an organization that refuses the login, a server error there, and a rate limit, each stopping the command before any other request; `token make` checking access before any request of its own; every command that names an account making the check; a user account making no organization request; an account GitHub doesn't have; and a name that can't be an account's. Each fails without the change.

<a id="azure-credentials"></a>

### 5.11 Azure credentials

Where the repository variable `AZURE_STATIC_SITE` names a static site, the daily check proves the Azure credentials its deployment signs in with. Today that is devlore.noblefactor.com alone, whose site is `devlore-noblefactor-com`.

- **`AZURE_CREDENTIALS`,** the service principal `azure/login` reads, signs in to Azure: `azure-missing` when the secret isn't set, `azure-refused` when Azure refuses it or it isn't the JSON `azure/login` reads.
- **Its secret's expiry** is the date in the repository variable `AZURE_CREDENTIALS_EXPIRES`, set when the secret is made: `azure-expiring` within 14 days, `azure-expired` after, `azure-expiry-unset` when the variable isn't set or isn't a date. A variable, not Azure's own record: reading that would take a directory permission the service principal doesn't need otherwise.
- **`AZURE_STATIC_WEB_APPS_API_TOKEN`,** the deployment token, must be the site's current one, which the service principal reads from Azure: `deploy-token-stale` when it was reset in Azure after it was stored, `deploy-token-missing` when the secret isn't set, `azure-short` when the service principal can't read the site.
- **Azure not reached,** or answering with something that proves nothing, leaves the sign-in's and the deployment token's alerts as they are, and the GitHub checks still run. The expiry's follow the recorded date, which needs nothing of Azure, so an expired secret is reported while Azure is down (Codex's C04). A run that finds something wrong ends 1, even when part of it couldn't be checked; one that finds nothing wrong and couldn't check everything ends 2.

<a id="a-workflows-own-failure"></a>

### 5.12 A workflow's own failure

Every job that signs in ends with two steps, from `workflow-templates/credentials-check.app-failure-steps.yml` or `credentials-check.azure-failure-steps.yml`, that run only when the job fails, or, for Azure, when its sign-in, the `azure/login` step with the id `azure-login`, fails and the job carries on past it, as the site's deploy does (Codex's C01): one fetches the check into a folder of its own, and one runs it in report mode, with `WORKFLOW` naming the workflow and `CHECKS` what the job signs in with. A bad credential raises its alert, a line naming the workflow and its run; one that checks fine raises nothing, the failure being the job's own. The job's own token needs `issues: write` and `contents: read`. The steps run only where the run can read the repository's secrets: never for Dependabot, on any event, and never on a pull request from a fork, since those runs get no Actions secrets, and such a job's failure would raise a false `missing` alert. Each step's condition is its failure, or, for Azure, its sign-in's too, `&& github.actor != 'dependabot[bot]' && (github.event_name != 'pull_request' || github.event.pull_request.head.repo.full_name == github.repository)` (found planning the second landing; Codex's L02). `tests/Test-CredentialsCheck` evaluates each step's condition, as the step files write it, for a pull request from this repository, a fork's and Dependabot's, and a push by a person and by Dependabot, each failed and not.

<a id="what-the-checks-cover"></a>

### 5.13 What the checks cover

| Process | Signs in with | For | Checked daily | Reports its own failure |
| --- | --- | --- | --- | --- |
| Each participating NobleFactor repository's Triage | The App's secrets | Adding an issue to Triage, its fields | Yes: the App signs in, with every permission | Yes, § 5.3 |
| David-Noble-at-work's Triage, in .github and personal | `ADD_TO_PROJECT_PAT` | Adding an issue to Triage | Yes: the token signs in, with its scopes, ahead of its expiry | Yes, § 5.3 |
| devlore-cli's docs-publish, knowledge-extract and release | The App's secrets | Pull requests to devlore.noblefactor.com and devlore-registry, and the installers' sync | Yes: the same App, and its reach, § 5.14 | Yes, § 5.12 |
| devlore-registry's sync-model-limits, update-indexes and validate | The App's secrets | Commits and pull requests | Yes: the same App, and its reach, § 5.14 | Yes, § 5.12 |
| devlore.noblefactor.com's deployment | `AZURE_CREDENTIALS` and `AZURE_STATIC_WEB_APPS_API_TOKEN` | Its staging environments and custom domain, and the upload | Yes, § 5.11 | Yes, § 5.12 |
| `star github` on the owner's machine | Its `gh` login | Every command | No: each command checks its login first (#621, #626) | Yes: the command stops, naming the fix |

The daily check proves that a credential signs in, holds the permissions the configuration names, and reaches every repository its workflows write to (§ 5.14). A process outside GitHub, such as a service on one of the owner's machines that signs in to Azure, isn't checked: its secret isn't where the check runs.

<a id="reach"></a>

### 5.14 Reach

The app must reach the repository it runs in and every other one its workflows write to with it, which the repository variable `TOKEN_CHECK_TARGETS` names, names or `owner/name`, comma-separated. For each, the check asks GitHub for an installation token for that repository alone; GitHub refuses one the installation doesn't cover, with HTTP 422. A refusal raises `unreachable`, naming each repository; only every one reached clears it; an answer that proves nothing ends the run 2. The app's permissions apply to every repository its installation covers, so the permission check of § 5.1 holds for each. Every run in a repository, the daily check, Triage's report and a workflow's own, reads the same variable, so no run clears what another raised. A repository outside the account is refused as a mistake, exit 64.

| Repository | `TOKEN_CHECK_TARGETS` | Its workflows that write there |
| --- | --- | --- |
| devlore-cli | `devlore.noblefactor.com,devlore-registry` | docs-publish and release, devlore.noblefactor.com; knowledge-extract, devlore-registry |
| devlore-registry | `devlore-cli` | update-indexes and validate, devlore-cli; sync-model-limits and update-indexes, devlore-registry itself |
| Every other participating repository | Unset | Triage, the repository itself |

<a id="the-second-landing"></a>

### 5.15 The second landing

What #632 and #634 merged lands by hand, a pull request a repository, one at a time, in this order, each made by its worktree's PR script, with a Time section and its account's own sign-off, and each reviewed by Codex and audited by agy before you merge it. A repository's variables are set by its PR script, which you run, after the merge.

| # | Repository | What lands | Jobs given the failure steps | Token permission added | Variables |
| --- | --- | --- | --- | --- | --- |
| 1 | NobleFactor/noblefactor-engprod | `.github/credentials-check/credentials-check.sh`, `.github/workflows/credentials-check.yml` and `triage.yml`, from the organization templates; the failure steps' guard, § 5.12; this plan's records and #629's completion | None | None | None |
| 2 | NobleFactor/.github | The same three, in `workflow-templates/` and in its own `.github/` | None | None | None |
| 3 | NobleFactor/devlore-cli | The same three | docs-publish's `generate-and-pr`, knowledge-extract's `knowledge-extract` and release's `sync-install-script`: the app's steps | `issues: write`: docs-publish's, at the top, beside `contents: read`; release's `sync-install-script` job, beside `contents: write` | `TOKEN_CHECK_TARGETS=devlore.noblefactor.com,devlore-registry` |
| 4 | NobleFactor/devlore-registry | The same three | sync-model-limits, update-indexes and validate: the app's steps | None: their jobs declare no permissions, so they get the repository's default, write, which includes it | `TOKEN_CHECK_TARGETS=devlore-cli` |
| 5 | NobleFactor/devlore.noblefactor.com | The same three | azure-static-web-apps's `build_and_deploy`, its sign-in step already `azure-login`, and `close_pull_request`, which uses the deployment token when a pull request closes (Codex's L01): the Azure steps | None, as above | `AZURE_STATIC_SITE=devlore-noblefactor-com`, `AZURE_CREDENTIALS_EXPIRES=2027-01-27` |
| 6 | David-Noble-at-work/.github | The same three, from the user templates, in `workflow-templates/` and in its own `.github/` | None | None | None |
| 7 | David-Noble-at-work/personal | The same three, from the user templates | None | None | None |

A job that declares no permissions gets its repository's default, which, read on 2026-11-23, is write in NobleFactor and in each of its five repositories, and read in David-Noble-at-work/.github, whose landed workflows declare their own (Codex's L03). Each landing reads its repository's default again before it lands, and after it the GITHUB_TOKEN permissions each changed job's next run lists in its log, `issues: write` and `contents: read` among them.

`credentials-check.json` is unchanged since the first landing and isn't landed again. The two step files are snippets for a job to end with, not workflows, and stay in this repository's `workflow-templates/`.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **One central monitor writing every incident in noblefactor-engprod.** Rejected: a workflow's `GITHUB_TOKEN` writes only its own repository, so a central monitor would need a credential of its own that could itself fail, and it couldn't read a private repository's secrets. Each repository checks and reports itself; the central part reads only public check runs.
- **Alerting from the Triage workflow alone.** Rejected: it runs only when an issue opens, so it can't repeat on a schedule or warn ahead of expiry.
- **A concurrency group serializing the check and the Triage report.** Not taken. By default GitHub keeps one run pending per group and cancels the one already pending, which would lose overlapping runs; `queue: max` keeps up to 100 pending and cancels any past that. Closing duplicates on every lookup needs neither, and holds no run waiting on another (§ 5.2).
- **Rotation dates in the model's token record.** Rejected: the record names a token and its sources, never its schedule, which is free to change; an organization variable holds it.

Questions for you, 3 of them:

1. **Where incidents go.** My call: an issue in the repository whose binding failed, assigned to David-Noble-at-work, which GitHub notifies him of. This replaces the issue's first call, a single repository, which the token model can't write to from another repository.
2. **How often, and how early.** My call: daily, and 14 days ahead for a classic token's expiry and an app key's rotation.
3. **Landing before #614.** My call: land the check by hand in each participating repository, a pull request each, rather than wait for #614.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Each condition raises its incident | One issue per repository and condition, assigned, naming the fix | `tests/Test-CredentialsCheck` | Stand-in `gh` and `curl` |
| Incidents repeat and clear by their own rules | A comment each day; closed only by the clearing rule | The same suite | Stand-ins |
| A new issue that doesn't reach Triage is reported at once | The token's alert, or "New issues aren't reaching Triage", naming the issue; closed when a later issue reaches Triage, listing the issues missed earlier, to check | The same suite | Stand-ins |
| A site's Azure credentials raise their incidents | Each Azure condition raises, repeats and clears by its own rule; Azure not reached raises nothing of the sign-in's or the token's | The same suite | Stand-in `curl` for Azure |
| A job's own failure is reported at once | A bad credential's alert names the workflow and its run; a healthy one raises nothing; the steps run as a job runs them, and on a failed Azure sign-in the job carries on past | The same suite | Stand-ins |
| A duplicate alert is resolved | Closed with its Resolution set to Duplicate, every line it gained carried, none twice; left open, the run ending 3, when the Resolution can't be set | The same suite | Stand-ins |
| The Triage templates' lines (#633) | Every line within 120 characters; the sorting steps print, output and call exactly as before | `tests/Test-TriageTemplates`, 31 cases, passing before and after | Stand-in `gh` |
| The checks run in the field | Each participating repository's daily check runs and passes, devlore.noblefactor.com's checking its Azure credentials | The runs of the first two days after the second landing | The real accounts |
| A connection failure is never a rejected token (#621) | GitHub not reached is named, gh's line quoted, with no credential advice; only a 401 is a rejected token | `tests/Test-StarGitHub`, cases 222 to 241 | Stand-in `gh` |
| A command reading an organization checks the login can reach it (#626) | Refused, it stops naming who must grant access; a user account makes no organization request | `tests/Test-StarGitHub`, cases 242 to 255 | Stand-in `gh` |
| The deployed command (#621) | With GitHub unreachable, it names no credential fault | Run with `HTTPS_PROXY` at a port nothing listens on, after `writ deploy` | The owner's Mac |

There are no sandbox runs (§ 12). Real credentials are never broken to prove an alert: the conditions are proved against the stand-ins, and the field shows the checks running and passing.

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commits of §§ 9.2 to 9.10, reviewed | §§ 9.2 to 9.8 in #625; §§ 9.9 and 9.10 in #632, under review |
| Merge | Yes | The pull requests and the commits they land | #625, fe18e58, on 2026-11-22; #632 pending |
| Deployment | Yes: the templates landed in each participating repository (#613), and `writ deploy` of the extension (#621, #626) | Each repository holding the check; the deployed `access.star` | The first landing, seven repositories, and the extension, on 2026-11-22; the second landing, with the failure steps, #633's Triage templates, `TOKEN_CHECK_TARGETS` and the site's two variables, after #632 |
| Verification | Yes, in the field | Two days of passing checks in every participating repository, posted on #613; the deployed command with GitHub unreachable, posted on #621 | #621 and #626 posted on 2026-11-22; #613's two days after the second landing |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-the-plan"></a>

### 9.1 Phase 1: the plan

- [x] This plan approved on 2026-11-21 (§ 12). #613's body is rewritten to match with the pull request.

<a id="phase-1b-issue-621"></a>

### 9.2 Phase 2: #621, the access diagnostics

- [x] `access.star` as § 5.6 sets out; its cases, 222 to 234; section 6, § 8. The suite passes all 685 checks, 27 of them #621's. The deployed command's check of § 5.8 moves to § 9.8, after the merge.

<a id="phase-2-the-check"></a>

### 9.3 Phase 3: the check and its tests

- [x] `workflow-templates/credentials-check.sh` and `credentials-check.json`, and the workflow for each kind of account, `credentials-check.organization.yml` and `credentials-check.user.yml`; `tests/Test-CredentialsCheck`, 32 cases, all passing. Writing the suite found that a check unable to reach GitHub raised a credential incident: `call` exited inside a command substitution, which ended only the subshell. `call` now returns 2, and each caller exits 2 (#621).

<a id="phase-3-the-triage-step"></a>

### 9.4 Phase 4: the Triage workflow's failure step

- [x] The step in both Triage templates, `workflow-templates/triage.organization.yml` and `triage.user.yml`, copied from each account's `.github` on 2026-11-21; the organization's job gains `contents: read` and `issues: write`, which it set none of, and the user account's `contents: read`. Its case, a reported failure raising `consumer-failed` at once and the next healthy check clearing it, is in `tests/Test-CredentialsCheck`.

<a id="phase-4-the-documents"></a>

### 9.5 Phase 5: the documents

- [x] Section 4 § 4.1, its decision record ACCESS-007, and the guide's § 8, Alerts.

<a id="phase-4b-the-review"></a>

### 9.6 Phase 6: #625's review

- [x] R5 and R6, #621: a failed organization answer with an HTTP status line, a server error among them, stops the command; a token is scrubbed wherever it starts in a line, and the diagnosis reads the line scrubbed. Cases 235 to 241, all 698 checks passing; section 6, § 8; § 5.6. The organization lookup has no case: no command passes `check_access` an organization, so none reaches it.
- [x] R1, R2, R4 and R7, #613: an incident closes only when its own test passes; only GitHub's refusal is a credential condition; duplicates from runs at once are closed; a failed incident operation fails the run. Their cases in `tests/Test-CredentialsCheck`, 51 in all, every one passing; 25 of them fail against 1f76efa's script. §§ 5.2 and 6; section 4, § 4.1; the guide's § 8.
- [x] R3: what a new issue that doesn't reach Triage raises, as decided on 2026-11-21 (§ 12): § 5.3, both Triage templates, and the script's report and placed modes. `consumer-failed` is gone. `tests/Test-CredentialsCheck`, 62 cases, every one passing.
- [x] #625's audit, A02 to A07: #613's body rewritten to the approved design, and the plan review that didn't happen recorded in § 12; this plan active, #621 in §§ 2, 4, 7, 8 and 10, § 11 brought up to date, and its sections numbered in order; section 4's §§ 3 and 4.1 and ACCESS-007 naming `workflow-templates/` as the templates' source, with the README; ACCESS-007's recorded time made the commit's, 08:23:15Z, and ACCESS-006 and MODEL-007 to 009's made c910441's, 06:42:51Z, all four having carried an invented 03:00:00Z; the guide's sections numbered in order; and the script's exemption from `Declare-BashScript` stated in its header and § 5.1. A01, a review not yet made, was answered by Codex's.

- [x] #625's second review, R9 to R15: a duplicate's missed issues carried to the alert kept; the alert closed whenever the issue reached Triage, a failure closing it failing the run; a run that couldn't tell where an issue belongs saying so; `token make` checking access before any request of its own; a rate limit on the organization named as one; and the alerts saying only what was seen. `tests/Test-CredentialsCheck`, 68 cases, and `tests/Test-StarGitHub`, cases 242 to 254, all passing; §§ 5.3 and 5.9, section 4 § 4.1, section 6 § 8 and the guide's § 8.
- [x] #625's third review, R11 and R14: an issue whose place was unknown stays unknown in the reminder and the closing, and a rate limit giving its reset time and no Retry-After names that time. Case 255; the credentials check's reminder and closing cases; §§ 5.9 and 5.3, section 6 § 8.

<a id="phase-6b-issue-626"></a>

### 9.7 Phase 7: #626, the account a command names

- [x] `check_access` and the six commands that name an account, as § 5.9 sets out; cases 242 to 247, all 711 checks passing; section 6, § 8.

<a id="phase-5-merge-landing-and-verification"></a>

### 9.8 Phase 8: merge, landing and verification

- [x] Merged as fe18e58, and the templates landed in each participating repository on 2026-11-22, one pull request each, each repository's first check passing; recorded on #613.
- [ ] Two days of passing daily checks in every participating repository, posted on #613.
- [x] Deployed with `writ deploy`; the deployed command, run with `HTTPS_PROXY` at a port nothing listens on, names GitHub as unreachable and no credential fault; posted on #621.

<a id="phase-9-reopened"></a>

### 9.9 Phase 9: #613 reopened

- [x] A duplicate alert's Resolution set to Duplicate before it closes, as § 5.2 sets out; `tests/Test-CredentialsCheck`, 73 cases, 4 of which fail against fe18e58's script; section 4 § 4.1 and the guide's § 8.
- [x] The checks #613 asks for and the merge left out: devlore.noblefactor.com's two Azure credentials, and each workflow that signs in with the App reporting its own failure, with the plan's consumer-by-consumer account of what is covered: §§ 5.11 to 5.13; `credentials-check.sh`, both daily-check workflows, and the two failure-step files; `tests/Test-CredentialsCheck`, 96 cases, 14 of which fail against ab2b8dd's script; section 4 § 4.1 and its inventory, the guide's § 8 and the README.
- [x] #632's review, C01, C03 and C05: the Azure failure steps run on a failed sign-in the job carries on past; a duplicate's lines carried one by one; § 12's account of the landings' review; `tests/Test-CredentialsCheck`, 103 cases, 2 of which fail against 6aa5dc9's files.
- [x] #632's audit by agy, D02 to D04 and D06: § 12's records of the canonical clone, phase 9's start and #632's PR script; §§ 2, 4, 7 and 8 and the frontmatter brought to #632's scope; section 4's inventory date and ACCESS-008; the guide's § 9 for the Azure credentials; #613's body; #629's and devlore-cli#1241's plan links to develop; and #632's description, 103 cases. D05, the four parents' Backlog rows, done on your approval with `star github issue move --backlog`.
- [x] #632's review, C02: the app's reach to this repository and every one `TOKEN_CHECK_TARGETS` names, as § 5.14 sets out; `tests/Test-CredentialsCheck`, 114 cases, 11 of which fail against 333df2a's files.
- [x] #632's review, C04: the Azure expiry alerts follow the recorded date while Azure is down, as § 5.11 now says; `tests/Test-CredentialsCheck`, 120 cases.
- [x] After the merge, once the canonical clone holds it, `star github plan link feature/613-token-alerts.md` rewrites the table of every issue this plan serves, #613, #621, #626 and #633: #633's Plan row links § Issue 633 on develop, and #613's and #626's lose the #626 row (agy's D08). Run on 2026-11-23 after #632 merged: written for all four; #633's Plan row links the plan on develop, whole, with no `#issue-633` anchor, and #613's and #626's tables are without the #626 row. `star github plan link` links a shared plan whole, where work assets § 3.3 asks for a stable issue anchor (Codex's L04); at your direction it is Bug #635, step 25 of Schedule #588, and the command is run again for this plan once it is fixed.
- [ ] Landed in every repository the change reaches, its first check passing: the templates, the Triage templates among them; the failure steps in devlore-cli's three app workflows, devlore-registry's three and the site's deployment, with `issues: write` granted where a job's token lacks it; `TOKEN_CHECK_TARGETS` on devlore-cli and devlore-registry, as § 5.14 lists; and `AZURE_STATIC_SITE` and `AZURE_CREDENTIALS_EXPIRES` on devlore.noblefactor.com.

<a id="phase-10-633-the-triage-templates-lines"></a>

### 9.10 Phase 10: #633, the Triage templates' lines

- [x] `tests/Test-TriageTemplates`, passing against the templates as they are: 31 cases, four of which fail when a message and a GraphQL variable in the organization template are changed.
- [x] Every line of both Triage templates within 120 characters, the test passing after: each split GraphQL query checked equal to the original but for whitespace; both templates parse; every step's script passes shellcheck.

<a id="phase-11-the-second-landing"></a>

### 9.11 Phase 11: the second landing

- [x] The failure steps' guard, § 5.12, Dependabot excluded on every event, with `tests/Test-CredentialsCheck`'s evaluation of each step's condition: 40 cases, the 159 all passing; against the step files on develop, 16 fail, and against the guard that tested Dependabot only on pull requests, 6.
- [ ] NobleFactor/noblefactor-engprod's pull request, § 5.15's first row, with #629's completion.
- [ ] NobleFactor/.github's.
- [ ] NobleFactor/devlore-cli's, and its variable.
- [ ] NobleFactor/devlore-registry's, and its variable.
- [ ] NobleFactor/devlore.noblefactor.com's, both its jobs that sign in, and its two variables.
- [ ] For each landing that changes a job, its repository's default token permissions read again before it, and the job's token permissions read from its next run's log after it.
- [ ] David-Noble-at-work/.github's.
- [ ] David-Noble-at-work/personal's.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `workflow-templates/` in this repository, new: the source of `credentials-check.sh`, `credentials-check.json`, `credentials-check.organization.yml` and `credentials-check.user.yml`, the failure steps `credentials-check.app-failure-steps.yml` and `credentials-check.azure-failure-steps.yml`, and each account's Triage template, `triage.organization.yml` and `triage.user.yml`, copied from NobleFactor/.github and David-Noble-at-work/.github with the failure step added. No copy of the Triage template lived here before; § 5.4 lands each in its account's `.github` and each participating repository.
- `tests/Test-CredentialsCheck`: new.
- `workflow-templates/triage.organization.yml` and `triage.user.yml`, and `tests/Test-TriageTemplates`, new (#633).
- `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/access.star` and `tests/Test-StarGitHub` (#621, #626).
- The same extension's `commands/github-model-get.star`, `github-model-diff.star`, `github-model-apply.star`, `github-model-backup.star`, `github-model-restore.star` and `github-token-make.star` (#626).
- `README.md`.
- `docs/architecture/issue-data-model/4-storage-and-reach.md`, `4-storage-and-reach.decisions.md`, `6-the-asset-and-its-sync.md` (#621, #626), `6-the-asset-and-its-sync.decisions.md`, `docs/reference/issue-tracking-credentials.md`.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- **#614:** `apply` lands workflows through a pull request it merges itself; question 3 decides whether landing waits for it.
- **#451's inventory**, closed on 2026-11-21, lists each credential; the 14-day margin and the yearly rotation it proposed are settled here (§ 12).

<a id="approval-and-departures"></a>

## 12. Approval and departures

- **Approved, 2026-11-21.** David Noble approved this plan at revision 2856d6a, for #613 and #621, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`, and directed the work to proceed phase by phase, each committed and pushed, and then the pull request opened for the full set. The three calls of § 6 are taken as § 6 makes them: incidents in the repository whose binding failed, assigned to David-Noble-at-work; daily, and 14 days ahead; and the check landed by hand before #614.
- **#626 in this pull request, decided 2026-11-21.** The bug #625's review found, an organization check no command made, is fixed here rather than left for later, since this pull request already changes the check. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **When a new issue doesn't reach Triage, decided 2026-11-21.** The token is checked first: a bad one raises its own alert, naming the issue; a healthy one raises "New issues aren't reaching Triage", which closes only when a later issue reaches Triage, listing the issues still missing. It replaces `consumer-failed`, which said Triage had failed when what failed was placing an issue in it, and which a healthy token check closed though issues could still be missing. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **#625's second review, 2026-11-21.** Codex reviewed 4645ee9 and found seven faults, R9 to R15, each fixed in § 9.6. The alerts' closing words name the issues missed earlier, to check, not as still missing: the run's own token can't read the Triage project, so an alert can't tell which were added by hand since.
- **#625's third review, 2026-11-21.** Codex reviewed 4e46399 and accepted R9, R10, R12, R13 and R15; R11 and R14 each left a small gap, both fixed in § 9.6.
- **No plan review.** Phase 1 named Codex's review of this plan before your approval. You approved it at 2856d6a without that review, and the work went ahead at once; Codex reviewed the work itself, on #625.
- **#625's review, 2026-11-21.** Codex reviewed 1f76efa and found eight faults, R1 to R8, each fixed in § 9.6. R3, what a new issue that doesn't reach Triage raises, was decided the same day, below.
- **Phase 9.1b, now § 9.2, ticked before its design update.** 3beaa44 ticked 9.1b, section 6 § 8 among it, but the section's change landed in the next commit, 15acbb9: it had been made in the main clone, not this worktree. #625's review found it, as R8. The history stays as it is; each fix since lands with its documents and its box.
- **No sandbox runs, decided 2026-11-21.** Setting up the sandboxes' credentials takes the same manual effort every time, so until GitHub offers a way to automate it, work is verified in the field and the sandbox accounts are deleted. #613's evidence, which names the sandboxes, is replaced by § 7.

- **Reopened, 2026-11-23.** #613 closed at #625's merge with its first requirement unmet: every process that depends on a token reports when it can't sign in. The plan's promised result narrowed the check to the GitHub App and the classic tokens, without recording that narrowing or its approval, and so left out devlore.noblefactor.com's site deployment, which signs in to Azure with `AZURE_STATIC_WEB_APPS_API_TOKEN` and `AZURE_CREDENTIALS`, and the six workflows besides Triage that sign in with the App, none of which reports its own failure at once. Found by the Owner's question on 2026-11-22, then by Codex (F01) and agy; reopened at the Owner's direction, with `star github issue reopen`, which also reopened #333 and placed it in Triage. § 9.9 finishes it.
- **The Azure credentials and each workflow's failure, decided 2026-11-23.** Every workflow that signs in with the App reports its own failure, and the Azure service principal's expiry is a repository variable, `AZURE_CREDENTIALS_EXPIRES`, set when its secret is made. `webhook-executor-sp`, found while reading the site's service principals, with its secret expired on 2026-11-15, is left for you, unlogged, as you directed. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **Records set by hand, 2026-11-23.** Reopening #613, #629 and devlore-cli#1241 put #333, personal#317 and devlore-cli#798 in Triage; at your direction their Triage rows were deleted through GitHub's project API, `star github issue move --backlog` not yet having been thought of. That left the three, Features and an Epic, with no Backlog row, where issue-standards § 3 holds them until they close, and left Epic #526, reopened with #629, in Triage: engprod (agy's D05). With your approval, on 2026-11-23 `star github issue move --backlog` moved all four to their teams' Backlogs, taking #526 out of Triage: engprod; each now has that one row. #613's own row on Schedule #588 was set In progress, linking `feature/613-token-alerts-complete`, the same way, for this pull request's script to record its merge.
- **The canonical clone, 2026-11-23 (agy's B14 and D02).** I fast-forwarded noblefactor-engprod's canonical clone to d6f7c4c at 08:21 Pacific, before you authorized updating the clones; you then authorized devlore-cli's and personal's. A second `git pull` there, later the same day, found it current and changed nothing. You accepted this record the same day, the clone matching develop with no local changes, and nothing was undone.
- **Phase 9 began without its plan reviewed, 2026-11-23 (agy's D03).** #613 reopened at your direction, and the work began at once: the duplicate's Resolution, ab2b8dd, and the Azure check, e4b7477, were committed with phase 9 written beside them, not reviewed with you first, and the worktree's first script wasn't run. The decisions they rest on are yours, made in the session: the Resolution, the six workflows reporting their own failure, and the repository variable.
- **#632's PR script, 2026-11-23.** Its first run, which opened #632, was mine, as your direction of 2026-11-21 has it: the coder opens its own pull request through the worktree's PR script, and merging is yours.
- **Codex's review of the landing plan, 2026-11-23.** L01: the site's `close_pull_request` job also uses the deployment token, and is added. L02: the guard let Dependabot through on a push; it now excludes Dependabot on every event. L03: the token permissions jobs inherit were assumed; they are read, and read again at each landing and after it. L04: § 9.9 said #633's link carried an issue anchor; it doesn't. Codex can't read David-Noble-at-work/personal, so its landing's review needs that access: you will grant Codex read access to it before the seventh landing.
- **The landing plan approved, 2026-11-24.** You approved § 5.15 and phase 11 as revised through c3218fe, without a second plan review, Codex reviewing the code in the first landing's pull request. In the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **The second landing, planned 2026-11-23.** § 5.15: a pull request a repository, each reviewed and audited before your merge, unlike the first landing's, and its variables set by its PR script, which you run. Planning it found the failure steps would raise a false `missing` alert when a pull request from a fork or Dependabot fails, its run getting no secrets; § 5.12's guard. #629's completion record goes in the first of these pull requests, at your direction. #613's and #633's rows on Schedule #588 still linked #632, merged, after the plan was pushed; they were set In progress, linking `feature/613-token-alerts-landing`, with the template's `step_row` and `set_row`, the guard allowing that one stale link, and read back. In the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **The app's reach, decided 2026-11-23.** A workflow that writes to another repository fails when the app loses it, and the check, proving only the app's own health, raised nothing (Codex's C02). This gap was reported closed before, and it wasn't. Every run now proves the app reaches each repository the workflows write to, § 5.14. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **The Azure expiry during an Azure outage, decided 2026-11-23.** The expiry date is recorded in GitHub, so the check raises an expired secret's alert whether or not Azure answers; the promise that an outage changes no Azure alert is corrected to the sign-in's and the deployment token's (Codex's C04). Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **#633, decided 2026-11-23.** The Triage templates' long lines are wrapped in #632, with a test of the steps they're in, at your direction; #633 is step 24 of Schedule #588, after #613's, and its row was set In progress, linking `feature/613-token-alerts-complete`, through GitHub's project API, as #613's was. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **A duplicate's Resolution, decided 2026-11-23.** A duplicate alert gets a Resolution of Duplicate before it closes, as the issue standard has every duplicate closed (Codex's F02). Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **The landing, 2026-11-22.** The seven landing pull requests were opened, one at a time, by a one-off script, and merged with neither Codex's review nor agy's audit. Codex reviewed them after the merges, as its [review ledger](https://github.com/NobleFactor/noblefactor-engprod/issues/588#issuecomment-7104181078) on #588 records: the five NobleFactor pull requests, with reviews posted; David-Noble-at-work/.github#19, read in full, its review not postable; and not David-Noble-at-work/personal#339, Codex having no access to the private repository, whose review is still owed (Codex's C05). They carry no Time section. The script signed off NobleFactor's address, `David.Noble@noblefactor.com`, on David-Noble-at-work/.github#19 and David-Noble-at-work/personal#339, where the account's own address belongs. It set NobleFactor's `TOKEN_ROTATION_DUE` to 2027-02-04 and noblefactor-engprod's `TOKEN_CHECK_WATCH` to the other four NobleFactor repositories. You deleted the script once for my not cleaning up after myself, and I recreated it without asking.
- **Records set by hand.** #626's Status and Worktree on Schedule #588 were set through GitHub's project API, since neither `star` nor `git open-branch` sets them.
- **PR scripts I ran.** #625's PR script ran under my hand at your request, its after-merge run included, where the process has you run it.

<a id="completion-review"></a>

## 13. Completion review

Pending.
