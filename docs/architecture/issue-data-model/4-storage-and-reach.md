---
title: "Issue model storage and access"
status: draft
updated: 2026-11-21
---

<a id="4-storage-and-reach"></a>

# Issue model storage and access

[Up: Issue data model](index.md)

GitHub holds each account's live issue model and work records. The account's public `.github` repository holds shared forms, workflow templates and a versioned model backup. Repository workflows and the `star github` extension use those resources within the account's ownership and access boundaries.

<a id="accounts-organizations-and-individuals"></a>
<a id="what-reaches-personal"></a>
<a id="the-rest-of-the-ruling"></a>

## 1. Account boundaries

Each organization or user account has its own model. Managed project rows, product parent links and blocked-by relationships stay within that account. These are our model boundaries, not a claim that GitHub forbids every cross-account link.

Work waiting on another account uses a stand-in issue in its own account. The stand-in references the external work by URL; local blocked-by relationships point to it. An account does not place another account's private work in its own projects.

An organization's owning team is identified through its Maintain role on a repository. User-account repositories participate through the `issue-model` topic. Participation determines which repositories the commands manage; it does not grant access to them.

<a id="an-organizations-account"></a>
<a id="a-user-account"></a>

## 2. Account representations

| Concern | Organization | User account |
| --- | --- | --- |
| Issue type | Native issue type | One lowercase type label |
| Single-select attributes | Native issue fields | One lowercase label from each attribute family |
| Parent and dependency | Native sub-issue and blocked-by links | The same links |
| Repository ownership | Team Maintain role | Account ownership and collaborator access |
| Project responsibility | Account-owned project linked to its accountable team | Account-owned project |
| Project source | Four organization templates | Corresponding project copies |
| Shared file resources | Public `.github` repository | Public `.github` repository |

Type and attribute rules are in [Hierarchy](1-hierarchy.md) and [Attributes](2-attributes.md). Native issue fields and label attributes are not project-field substitutes. In particular, a row-level Priority would not follow an issue when it moves.

```mermaid
flowchart TB
    account["GitHub account"] --> live["Live types or labels, fields, teams and projects"]
    account --> shared["Public .github repository"]
    shared --> forms["Issue forms and PR template"]
    shared --> template["Triage workflow template"]
    shared --> backup["model.yaml and Git history"]
    team["Owning team or account"] --> repos["Participating repositories"]
    template --> workflow["Repository Triage workflows"]
    repos --> workflow
    workflow --> projects["Managed Triage and Scenario intake"]
    cli["star github commands"] --> live
    cli --> repos
    cli --> projects
```

The diagram shows responsibilities and data access. It does not grant the CLI, a workflow or an agent authority beyond its credentials and approved assignment.

<a id="where-each-part-lives"></a>
<a id="where-each-part-is-defined"></a>

## 3. Authoritative locations

| Information | Authoritative location |
| --- | --- |
| Organization type definitions and issue fields | Organization GitHub settings |
| Type and attribute labels | Each participating repository |
| Issue Type, attributes, assignees, body and state | The issue |
| Product parent and blocked-by dependencies | Native issue relationships |
| Collection membership, Step, Beat, Iteration and Status | Project rows and fields |
| Schedule deliverable, completion criteria and amendments | Schedule issue |
| Scenario goal, walk and Features exercised | Scenario issue |
| Project structure and shared configuration | Account templates, reconciled to their copies |
| Team ownership and grants | GitHub team, repository and project relationships |
| Issue forms | Account `.github/ISSUE_TEMPLATE` directory |
| Triage and credentials check workflow templates | Written and tested in noblefactor-engprod's `workflow-templates/`; published from each account's `.github/workflow-templates` directory |
| PR and community-health templates | Account `.github` repository |
| Installed intake workflow | Each participating repository's `.github/workflows/triage.yml` |
| Installed credentials check | Each participating repository's `.github/workflows/credentials-check.yml` and `.github/credentials-check/` |
| Credential incidents | Issues labeled `token-alert` in the repository whose token failed |
| Intake destination | Repository variable `TRIAGE_PROJECT_URL` |
| Model backup | `model.yaml` in the account's `.github` repository |

Shared issue forms and PR files use GitHub's account fallback where applicable. A repository-local override takes precedence and must not accidentally create a second definition. The Triage workflow is installed explicitly from its account template; the design does not depend on a user-account template appearing in GitHub's template picker.

The `.github` repository participates in the model and follows its repository quality gates. [Model synchronization](6-the-asset-and-its-sync.md) owns reading live state, applying definitions and publishing backups. Commands needing the model read GitHub; the backup is not a runtime cache.

<a id="triage"></a>

## 4. Triage workflow

The workflow runs on issue opening or transfer. It identifies the issue's Type or type label, reads the form's Area and supplies the appropriate initial Severity while preserving an existing value.

The collection command creates a Schedule or Scenario issue's own row. The intake workflow skips those collection issues. A finding that identifies an open Scenario in the same account is routed to that Scenario's project option. Other intake goes to `TRIAGE_PROJECT_URL`. When the Scenario reference cannot be used, route the finding to Triage and record why.

The workflow copies Area into the organization field or the user-account label. A missing Area remains a classification fault; a form alone is not a guarantee on every filing path. An issue typed after opening needs triage to establish the corresponding Severity.

Keep body parsing bounded, handle normal line endings and end-of-body conditions, and impose the workflow's timeout. The shared workflow contract uses a five-minute job limit. Repository project-row changes are not an assumed Actions trigger for this intake path.

### 4.1 Credentials

The organization workflow uses the account's automation GitHub App. NobleFactor supplies `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY` as organization secrets available to the participating repositories. The workflow needs project writes, issue writes and issue-field reads; the configured App may have other responsibilities outside this workflow.

The user-account workflow uses the repository secret `ADD_TO_PROJECT_PAT` for project access. Its configured path uses a classic token with `project` and, for private repositories, `repo`. The workflow's own `GITHUB_TOKEN` has `issues: write` for label updates.

Every account that takes part in triage identifies its token, and `star github model apply` refuses an account that doesn't, before it writes anything ([ACCESS-006](4-storage-and-reach.decisions.md#access-006)). Which token an account has, and what it's used for and permits, can change; that it has one can't. The model's token record ([section 6, § 1.1](6-the-asset-and-its-sync.md#the-asset)) names the token and where each value comes from, and the [credentials guide](../../reference/issue-tracking-credentials.md) says how to make, check and renew each kind.

The inventory, read on 2026-11-20. A classic token's expiry is the date GitHub reports for it; an app key doesn't expire and is rotated. An app key is rotated yearly, and each expiry and rotation is warned of 14 days ahead, as [#613](https://github.com/NobleFactor/noblefactor-engprod/issues/613) settled. NobleFactor-sandbox and David-Noble-at-work-sandbox are no longer used, work being verified in the field; their rows stand until the accounts are deleted.

| Account | Credential | GitHub holds it as | Key Vault | Used by | Expiry or rotation | Warning margin |
| --- | --- | --- | --- | --- | --- | --- |
| NobleFactor | App noblefactor-automation, ID 2791147, and its private key | Organization secrets `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`, visible to all repositories, set 2026-02-04 | None | Each participating repository's Triage workflow; devlore-cli's `release.yaml`, `docs-publish.yaml` and `knowledge-extract.yaml`; devlore-registry's `validate.yaml`, `sync-model-limits.yaml` and `update-indexes.yaml` | Rotation due 2027-02-04 | 14 days |
| NobleFactor-sandbox | Its own app, with NobleFactor's permissions | The same two organization secrets | `kv-nf-engprod-dev`, `NobleFactor-sandbox--<SECRET>` | NobleFactor-sandbox/sandbox's Triage workflow | Not yet made | 14 days |
| David-Noble-at-work | Classic tokens, `repo` and `project` | Repository secret `ADD_TO_PROJECT_PAT` in personal, set 2026-11-10, and in .github, set 2026-11-09 | `kv-david-noble-at-work`, `dot-github--ADD-TO-PROJECT-PAT`, .github's alone | Both repositories' Triage workflows | Not recorded; read on each token's page | 14 days |
| David-Noble-at-work-sandbox | Classic token, `repo` and `project` | Repository secret `ADD_TO_PROJECT_PAT` in David-Noble-at-work-sandbox/sandbox | `kv-nf-engprod-dev`, `David-Noble-at-work-sandbox--ADD-TO-PROJECT-PAT` | David-Noble-at-work-sandbox/sandbox's Triage workflow | Missing since 2026-11-19; not yet made again | 14 days |
| The owner's Mac | `gh` logins as David-Noble-at-work and David-Noble-at-work-sandbox, scopes `repo`, `project`, `admin:org` and `workflow` | `gh`'s keyring | None | `star github` | The credential behind each login renews as it does; refused, it is renewed with `gh auth refresh` | None |

Each participating repository checks its own token every day ([ACCESS-007](4-storage-and-reach.decisions.md#access-007)). Its credentials check proves the token through the same secret its workflows read: an organization's app must mint an installation token holding every permission the check's configuration names, and a user account's classic token must sign in as the account with its scopes, ahead of its expiry. An app key is due for rotation on the organization variable `TOKEN_ROTATION_DUE`. Each condition that holds raises one incident in that repository, an issue titled `Token alert: <condition>`, labeled `token-alert` and assigned to the owner, written with the run's own token so that it never depends on the token being checked. An open incident gets a comment each day its condition holds, and closes only when a check through the same secret passes that condition's own test: a missing, refused or short token when the token signs in with everything it needs, an expiry or rotation warning only when the date is beyond the 14-day margin. A test that didn't run, or failed another way, closes nothing. Only GitHub's refusal is a credential condition: GitHub not reached, a rate limit or a server error raises and closes nothing. Two runs at once that each open the same incident leave the older open and close the other as its duplicate. When a new issue doesn't reach Triage, the Triage workflow checks the token at once and raises its alert, naming the issue, or, the token fine, "New issues aren't reaching Triage", which closes only when a later issue reaches Triage and lists the issues missed earlier, to check. noblefactor-engprod's check raises `no-recent-check` for a watched repository whose check has stopped. The check's source is this repository's `workflow-templates/`.

A token acts with its issuing account's access; its reach can exceed this workflow's needs. Do not treat a repository secret as proof that the token is restricted to that repository. Secret values do not belong in model files or logs. Renewal replaces the GitHub secret; the credential inventory owns renewal procedures and access review.

## 5. Participant access

| Participant | Required access |
| --- | --- |
| Organization team member | Organization and team membership; team Maintain on owned repositories; Write on the team's four projects |
| User-account collaborator | Collaboration on participating repositories and Write on the account's four projects |
| Participant linking parents across repositories | Required issue-management access to both repositories |
| Organization owner | Administration of account-level settings and grants |
| Account administrator configuring model support | Access required for repository settings, workflows and secret installation |

Team membership is the normal grant for work in an organization's owned repositories and projects. Project Write permits edits to fields and views; account administration retains settings and access management. Repository and project permissions remain separate.

Public repository visibility does not grant a participant permission to manage its issues. A cross-team parent link depends on access to both repositories, not merely visibility. Provision any required account membership before granting team work.

[Who can do what](../../issue-standards.md#who-can-do-what) defines the complete role policy. GitHub access permits an operation; the engineering process determines whether the participant is authorized to perform it.

<a id="labels"></a>

## 6. Labels and model scope

Labels are repository resources. The model records participating repositories' labels, not an organization-wide label tier or the defaults copied into newly created repositories. Types are capitalized; type and attribute labels use lowercase.

Model application can reconcile a repository's own backup labels or the label families defined by its account-kind reference. It must not carry another account's repository labels across account boundaries. [Apply](6-the-asset-and-its-sync.md) defines pruning limits and stable identity handling.

<a id="what-github-does-not-enforce"></a>

## 7. Validation boundaries

Native field types and issue relationships provide only part of the model's validation. The shared rules also require correct parent levels, Area, completion evidence except on Scenarios, Severity by Type, Resolution only on closed issues, restricted `good first issue` use, valid collection placement, Step numbers and dependency records.

The user-account label representation additionally needs checks for exactly one Type and no conflicting values in an attribute family. A model type with an invalid `Level N:` or `Collection:` description is a model error, rather than an issue fault.

Filing commands, triage and the sweep have distinct responsibilities. The [hierarchy](1-hierarchy.md#34-validation-and-sweep) and [attribute rules](2-attributes.md#4-validation-and-sweep) define the sweep and its Scenario exceptions. It reports faults and returns affected issues for human decisions; it does not choose a conflicting label or silently repair policy.

## 8. Quality, decisions and delivery references

Account-boundary checks must prevent managed cross-account placement while preserving explicit references to external work. Access failures must identify the failing boundary without changing credentials or hiding partial outcomes. Shared files and workflow copies must agree with their authoritative source.

<a id="the-choice-it-turns-on"></a>

The [decision companion](4-storage-and-reach.decisions.md) explains account boundaries, shared resources and grant ownership. The retained [delivery reference](4-storage-and-reach.status.md) preserves deployment observations and migration records separately from this architecture.
