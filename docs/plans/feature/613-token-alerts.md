---
title: "Every process that depends on a token alerts us when the token expires or goes missing, until it is fixed"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/613
status: active
created: 2026-11-21
updated: 2026-11-21
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
  - kind: Related work
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/626
    text: "star github commands never check that their login can reach the organization they read"
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

Every repository whose workflows sign in with a token checks that token every day through the same secret its workflows read, and raises an incident in that repository, assigned to the owner, when the token is missing, refused, short of a permission, expired, or close to expiring. The incident repeats every day until a check through the same secret proves the cause is gone, and then it closes. A Triage workflow that fails on its token raises the same incident at once.

At the end:

1. **A credentials check** in each participating repository, `.github/workflows/credentials-check.yml`, landed from the account's `.github` workflow template like the Triage workflow. It runs daily and on demand.
2. **Each check proves its binding.** For an organization, it mints an installation token from the same two organization secrets the Triage workflow reads, and requires the permissions GitHub grants it to include every one the repository's workflows need, writing to projects among them. For a user account, it calls GitHub with the repository's classic token and requires its login to be the account, its scopes to include `repo` and `project`, and its expiry to be outside the warning margin.
3. **One incident per repository and condition,** an issue titled `Token alert: <condition>`, labeled `token-alert`, assigned to David-Noble-at-work. The run's own `GITHUB_TOKEN`, granted `issues: write`, writes it, so it never depends on the credential being checked. While open, it gets a comment each day the condition holds. It closes when the condition's own clearing rule is met.
4. **When a new issue doesn't reach Triage,** the Triage workflow checks the token at once: a bad one raises its own alert, naming the issue; a healthy one raises "New issues aren't reaching Triage", which closes only when a later issue reaches Triage, listing the issues missed earlier, to check.
5. **Expiry and rotation:**
   - a classic token's expiry is the date GitHub reports in `GitHub-Authentication-Token-Expiration`, and it warns 14 days ahead;
   - an app key doesn't expire; it is due for rotation on the date in the organization variable `TOKEN_ROTATION_DUE`, set when the key is made or rotated, and that warns 14 days ahead too.
6. **The check's logic is a script,** `workflow-templates/credentials-check.sh` beside the workflow template, with a suite of its own, `tests/Test-CredentialsCheck`, against a stand-in `gh` and `curl`.

Out of scope:

- `star` commands' own failures to sign in, which already stop with the fix named (section 6, § 8), beyond how #621, §§ 5.6 to 5.8, corrects their diagnosis.
- Workflows outside the participating repositories, which get the check only by taking part.

## Issue 613

#613 requires an alert whenever a token a process depends on expires, disappears, or is refused, repeating until fixed and closing only when the cause clears, checked through the binding that raised it. Its evidence names the sandboxes, which are no longer used (§ 12); § 7 says what replaces them.

## Issue 621

#621: every `star github` command reports a connection failure as a rejected token. `check_access` in `commands/access.star` reads `gh auth status`, and whenever the active login's check fails, it reports "401: bad credentials; it has expired or been revoked" and advises renewing or replacing the token, whatever stopped the check. It reached a user on 2026-11-21, when `star github schedule get` failed because `api.github.com` couldn't be resolved. `_run` appends `; true`, so no exit status survives.

What gh itself says, read on 2026-11-21 with gh 2.104.0 and GitHub unreachable: the active login's block reads "X Failed to log in", then "The token in keyring is invalid.", even though no request reached GitHub. The cause is only on its `- Error:` line, for example `dial tcp 127.0.0.1:9: connect: connection refused`. `gh api rate_limit` fails with the same text. So gh's "invalid" line can't be trusted; its error line can.

<a id="issue-626"></a>

## Issue 626

#626: `check_access` can check that the login reaches the organization a command reads, section 6 § 8's "Account unavailable despite scopes", but none of its 24 callers passes an organization, so the check has never run. A command run against an organization that refuses the login, as one enforcing single sign-on does, gets past the access check and fails on its first real request with GitHub's own error. Found fixing #625's review.

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

- **Section 4, § 4.1:** the credentials check, its incidents and their clearing rules, and `TOKEN_ROTATION_DUE`.
- **`4-storage-and-reach.decisions.md`:** ACCESS-007, accepted: checking each binding where it lives and raising its incident there.
- **The guide:** what an incident means and how each clears.
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

- One open issue per repository and condition, found by its title and the `token-alert` label. Two runs at once can each find none and each open one, so every lookup, and every create, closes all but the oldest open one as its duplicate.
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
| The checks run in the field | Each participating repository's daily check runs and passes | The runs of the first two days after landing | The real accounts |
| A connection failure is never a rejected token (#621) | GitHub not reached is named, gh's line quoted, with no credential advice; only a 401 is a rejected token | `tests/Test-StarGitHub`, cases 222 to 241 | Stand-in `gh` |
| A command reading an organization checks the login can reach it (#626) | Refused, it stops naming who must grant access; a user account makes no organization request | `tests/Test-StarGitHub`, cases 242 to 255 | Stand-in `gh` |
| The deployed command (#621) | With GitHub unreachable, it names no credential fault | Run with `HTTPS_PROXY` at a port nothing listens on, after `writ deploy` | The owner's Mac |

There are no sandbox runs (§ 12). Real credentials are never broken to prove an alert: the conditions are proved against the stand-ins, and the field shows the checks running and passing.

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commits of §§ 9.2 to 9.7, reviewed | Pending |
| Merge | Yes | The pull request and the commit it lands | Pending |
| Deployment | Yes: the templates landed in each participating repository (#613), and `writ deploy` of the extension (#621, #626) | Each repository holding the check; the deployed `access.star` | Pending |
| Verification | Yes, in the field | Two days of passing checks in every participating repository, posted on #613; the deployed command with GitHub unreachable, posted on #621 | Pending |

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

- [ ] Merged; the templates landed in each participating repository; two days of passing checks posted on #613.
- [ ] Deployed with `writ deploy`; the deployed command, run with `HTTPS_PROXY` at a port nothing listens on, names GitHub as unreachable and no credential fault; posted on #621.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `workflow-templates/` in this repository, new: the source of `credentials-check.sh`, `credentials-check.json`, `credentials-check.organization.yml` and `credentials-check.user.yml`, and of each account's Triage template, `triage.organization.yml` and `triage.user.yml`, copied from NobleFactor/.github and David-Noble-at-work/.github with the failure step added. No copy of the Triage template lived here before; § 5.4 lands each in its account's `.github` and each participating repository.
- `tests/Test-CredentialsCheck`: new.
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

<a id="completion-review"></a>

## 13. Completion review

Pending.
