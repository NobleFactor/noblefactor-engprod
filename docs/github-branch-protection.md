---
title: "Branch protection"
description: "Protected branches, required checks and ruleset administration for NobleFactor repositories"
status: draft
updated: 2026-11-19
---

<a id="github-branch-protection-rules"></a>

# Branch protection

[Up: Engineering documentation](index.md)

Protected branches accept reviewed pull requests through squash merges. Required checks must pass. A configured bypass actor has a technical capability, not standing permission to bypass review or checks; any exception requires explicit Owner authorization.

This document states the policy. [Configuration evidence](#6-configuration-evidence) identifies dated observations; read effective rules before making an enforcement claim or proposing a configuration change.

## 1. Scope

<a id="protected-repositories"></a>

### 1.1. Repositories

| Repository | Default branch |
| --- | --- |
| NobleFactor/devlore.noblefactor.com | develop |
| NobleFactor/devlore-cli | develop |
| NobleFactor/devlore-registry | develop |
| NobleFactor/noblefactor | main |
| NobleFactor/noblefactor-engprod | develop |

NobleFactor/.github follows the same baseline and provides account-wide community files, issue forms, the PR template and the Triage workflow template. Its model ownership and publication contract are described in the [issue data model](architecture/issue-data-model/6-the-asset-and-its-sync.md#one-model-per-account). Schedule and Scenario own rows belong in their collection projects; findings from a Scenario walk enter that Scenario's route.

<a id="protected-branches"></a>

### 1.2. Branches and names

Protect the default branch, main, develop and release/*. Working branches use doc/, feature/, fix/, hotfix/, refactor/ or release/ followed by a nonempty name. The recorded branch-name pattern is:

```text
^(doc|feature|fix|hotfix|refactor|release)/.+$
```

Use git open-branch to derive the branch prefix from the issue: Bug becomes fix/, a user-account documentation label becomes doc/, and other issues become feature/. Chore is not an offered branch type. Protected branch names and the conditions targeting working branches must both be respected.

<a id="implementation-three-organization-rulesets"></a>

## 2. Protection rules

Organization rules establish a baseline; repository rules add requirements and cannot weaken it. GitHub can target organization rulesets at selected repositories. Our baseline targets the shared repository set, so its required check must exist throughout that set.

<a id="12426847--protection-for-default-main-develop-and-release"></a>

### 2.1. Protected branch rules

Ruleset 12426847, “Protection for default, main, develop, and release/*,” targets the default branch, refs/heads/main, refs/heads/develop and refs/heads/release/*.

| Rule | Requirement |
| --- | --- |
| deletion | Refuse deletion of protected branches |
| non_fast_forward | Refuse force pushes |
| required_linear_history | Keep protected history linear |
| pull_request | Require a PR, squash merge and one approval; dismiss stale approvals and require code-owner review and approval for unattributed changes |
| code_quality | Apply severity all |
| required_status_checks | Require quality-gate; strict_required_status_checks_policy is false |
| code_scanning | Require CodeQL with alert threshold errors and security alerts all |

The [dated develop read](#6-configuration-evidence) also records last-push approval and resolved review threads in the organization PR rule. These effective requirements compose with repository/classic protection; a lower review count in one layer does not cancel another layer's requirements.

The recorded bypass actors are OrganizationAdmin and Integration 2791147, both in pull_request mode. That mode permits an override when merging a PR; it does not permit direct protected-branch pushes. It also grants no authority to an agent. Follow the [PR review boundary](engineering/procedures/pull-request.md#review-boundary); the Owner reviews and merges, and a check/review exception needs separate approval.

Strict checks are disabled to avoid rerunning an entire platform matrix whenever the base advances. This setting does not waive the process requirement to integrate the target into the working branch through a merge before publication. Never rebase.

<a id="12515090--restrict-branch-names"></a>

### 2.2. Working branch names

Ruleset 12515090, “Restrict branch names,” records the pattern in [section 1.2](#12-branches-and-names) with no bypass actors. Administrators are subject to it. Inspect its actual ref conditions when administering it; do not infer those conditions from the protected-branch list.

<a id="12427647--signed-commits-for-main"></a>

### 2.3. Signed commits

The approved signing policy requires signed commits on NobleFactor main and release branches. Develop does not require signing; personal repositories are exempt. The decisions define the [branch boundary](engineering/review/decisions.md#decision-34) and [personal-repository exemption](engineering/review/decisions.md#decision-35); configuration work is deferred.

The earlier source describes ruleset 12427647, “Signed commits for main,” as targeting only refs/heads/main with no bypass actors. That observation does not demonstrate enforcement on release branches. Verify the effective configuration before reporting that the full signing policy is enforced.

<a id="required-checks"></a>

## 3. Required checks

Every required check must pass. A failing platform or installer leg is not informational when required. Cross-compilation, unit tests, end-to-end scenarios and installer tests establish different facts.

| Tier | Scope | Required checks |
| --- | --- | --- |
| 1: baseline | All repositories in the shared organization baseline | quality-gate |
| 2: platform behavior | Repositories shipping platform binaries | test (<goos>-<goarch>) and scenario (<goos>-<goarch>) for each supported platform |
| 2: installers | Repositories publishing installers | The faux release build and every installer suite on every served platform |

Test checks exercise the package/unit suite. Scenario checks drive the built binaries as an operator would on the target platform. Installer checks run the PR's installer against the PR's build from the run's faux channel (build) release. A successful cross-compile proves compilation; it replaces none of these behavior checks.

<a id="context-naming"></a>

### 3.1. Context names

Use the platform descriptor, matching ALL_PLATFORMS and build/<goos>-<goarch>, rather than a runner label. Examples include:

```text
test (darwin-arm64)      scenario (darwin-arm64)
test (linux-amd64)       scenario (linux-amd64)
test (linux-arm64)       scenario (linux-arm64)
test (windows-amd64)     scenario (windows-amd64)
test (windows-arm64)     scenario (windows-arm64)
```

Set matrix job names explicitly so a runner change or an extra matrix key does not change a required context:

```yaml
jobs:
  test:
    name: test (${{ matrix.platform }})
    strategy:
      matrix:
        include:
          - { platform: windows-arm64, os: windows-11-arm, race: false }
```

A context that never reports can block every merge. Changing a supported platform requires updating both its workflow and the applicable required contexts.

<a id="only-require-checks-that-run-on-pull-requests"></a>

### 3.2. Qualify checks on a pull request

Require checks that actually run on PRs. A green default-branch run does not establish this. Inspect the workflow triggers and a real PR's current head, then read its check runs. Paginate if necessary; an incomplete or empty result does not establish that no checks are required.

```bash
gh pr view <number> --repo NobleFactor/<repo> --json headRefOid --jq .headRefOid
gh api --paginate "repos/NobleFactor/<repo>/commits/<verified-head-oid>/check-runs" --jq '.check_runs[] | .name'
```

Replace the placeholder with the observed full head ID. Do not use a remembered ID or substitute the latest target commit. Push-only publication workflows are not PR checks.

<a id="where-tier-2-lives"></a>

### 3.3. Repository requirements

Declare repository-specific platform and installer checks in a repository ruleset. Require the complete supported matrix; adding a leg without requiring it leaves that leg unable to block merge.

The source records devlore-cli ruleset 21539972, “Cross-platform required checks,” with nineteen contexts: quality-gate, ten test/scenario legs and eight installer contexts. The recorded installer names are:

```text
faux channel (build)
install.ps1 (windows-amd64)
install.ps1 (windows-arm64)
install.sh (darwin-amd64)
install.sh (darwin-arm64)
install.sh (linux-amd64)
install.sh (linux-arm64)
install.sh (darwin-arm64, MacPorts)
```

This is dated configuration evidence, not a freshly read matrix. Discover the current supported platforms, triggers and contexts before changing the ruleset.

An organization's bypass declaration does not automatically apply to a repository ruleset. Inspect every applicable layer. A repository without a bypass still binds administrators; a bypass in either layer is not permission to ignore the Owner's approval boundary.

<a id="managing-rulesets"></a>

## 4. Administration

Read organization rules through repository views when checking what applies. Change organization rules through the organization endpoint; use the repository endpoint for repository rules. Administration and authentication changes require explicit authority.

```bash
# Read effective ruleset summaries and details.
gh api "repos/NobleFactor/<repo>/rulesets" --jq '.[] | {id, name, enforcement, source_type}'
gh api "repos/NobleFactor/<repo>/rulesets/<id>"

# Authorized organization change; the token needs admin:org.
gh auth refresh -h github.com -s admin:org
gh api "orgs/NobleFactor/rulesets/<id>" --method PUT --input ruleset.json

# Authorized repository-specific requirement.
gh api "repos/NobleFactor/<repo>/rulesets" --method POST --input repo-ruleset.json
```

Prepare a reviewed change for the correct scope, preserve unrelated settings, and read the rule back after applying it. Verify that required contexts arrive on an actual PR. A successful API write alone does not establish that the intended workflow can merge.

<a id="rationale"></a>

## 5. Rationale

| Choice | Reason |
| --- | --- |
| Squash merges and linear protected history | Keep the delivered change together and its review traceable |
| Required PR and review | Preserve review and CI evidence for each protected-branch change |
| Baseline quality-gate | Give all baseline repositories a common required check |
| Repository-specific matrices | Require behavior on the platforms each repository serves |
| Platform descriptors in context names | Keep rules stable across runner-image and matrix-detail changes |
| Narrow, explicit exceptions | Keep technical bypass capability separate from permission |

<a id="changelog"></a>

## 6. Configuration evidence

The [source preserved for this rewrite](engineering/review/sources/rewrite-2026-11-19/branch-protection.md.txt) contains the original configuration reads, rule IDs, incidents and change history. Its observations span several dates and are not a fresh configuration read.

The [adoption protection receipt](engineering/review/adoption-protection-2026-11-15.json), verified at 2026-11-16T00:03:35.225742+00:00, records effective develop rules and the classic protection response. It does not verify main/release signing or the current platform matrix. Configuration changes and unresolved enforcement gaps require their own approved work; this documentation rewrite changes no GitHub rules.

See GitHub's [ruleset overview](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) and [available rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets) for the platform's semantics.
