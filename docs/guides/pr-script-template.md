---
title: PR Script Template
description: Owner-run Bash and PowerShell script mechanics, from preparation through verified delivery
type: Process
audience: Engineers, agents
status: Approved
created: 2026-03-16
updated: 2026-11-15
---

# PR Script Template

Standard structure for the PR script that the assigned agent generates, named for the worktree it serves and placed beside it: `~/Workspace/<org>/<worktree>.bash` on macOS and Linux and `<worktree>.ps1` on Windows, where `<worktree>` is the directory `git-open-branch` made, `<clone>.<issue>-<name>`. The script for `~/Workspace/NobleFactor/devlore-cli.1119-broker-specification` is `~/Workspace/NobleFactor/devlore-cli.1119-broker-specification.bash`; `ls ~/Workspace/NobleFactor` shows which worktree each script lands; and `git close-branch` removes the two together when the pull request merges. Ruled 2026-10-21 (#366), retiring `go-<repo>` one level above the repository: a script named for the clone outlived every worktree it served, and the bare `go` belonged to whichever repository last used it. Each script is self-contained: stage, commit, push, create PR, verify CI, verify mergeability, squash merge, record its time and its steps, clean up.

A script is read before it is overwritten, whatever it is called: its `cd` says which worktree it serves, and one whose `cd` names another worktree is the wrong file. Only a script that is not there is written from nothing.

On macOS and Linux the script is bash, [the template below](#template). On Windows it is PowerShell, `<worktree>.ps1`, [its own form](#on-windows-powershell). Bash PR scripts are not written on Windows (ruled 2026-09-21). The owner runs the script: the agent writes it, shows it, and hands over one command, which for a PowerShell script is `& '<script>.ps1' -Verbose`, since what it is doing shows only on the verbose stream ([rule 8](#on-windows-powershell) of its form).

---

The [PR procedure](../engineering/procedures/pull-request.md) owns review, merge and completion policy. This specification owns the platform-specific script mechanics. Apply the Owner-approved [temporary live-entrypoint overrides](../engineering/index.md#temporary-live-entrypoint-overrides) when choosing the effective disclosure and execution limits for a particular session.

<a id="the-pre-flight-command-is-discovered-not-remembered"></a>

## 1. The pre-flight command is discovered, not remembered

The example below shows `.github/scripts/shell-lint.sh`, which is what the `personal` repository's workflow invokes. **Do not copy it.** Read `.github/workflows/*` in the repository you are working in and use what it actually runs:

| Repository | CI entry point |
| --- | --- |
| `personal` | `.github/scripts/shell-lint.sh`, with `DECLARE_BASHSCRIPT_DIR` naming a directory that holds `Declare-BashScript` (a deployed `~/.local/bin` locally; CI checks out `noblefactor-engprod`) |
| `devlore-cli` | `make vet-all`, `make lint-all`, `./build/star lint go ./...` |
| `noblefactor-engprod` | `make check`: every gate, then the tests under `tests/`, which is what `ci.yaml` runs since #268 |

Where a repository routes through a build tool, call the target rather than the underlying binary: the target is what CI runs and it carries the flags. Where CI uses a GitHub Action rather than a command — `codespell-project/actions-codespell`, say — run the CLI it wraps with the same arguments the workflow passes it.

Read the workflow each time rather than trusting this table. It went stale during the change that introduced it: `noblefactor-engprod` dropped its Go trees and re-based its gate on documents while this edit was in the working tree, turning a `go build` pre-flight into a command with nothing to build.

A command from a tool this organization builds — `writ`, `star` — is verified against develop and installed before it appears in a script or a message: [agent-rules.md](agent-rules.md), rule 1.

This step exists because a hand-rolled subset of the gate will differ from it eventually. On 2026-08-30 a `personal` PR pre-flighted with `shellcheck` alone and failed CI on `shfmt`, after the issue, branch, commit and PR already existed. The remedy is not a longer checklist; it is to stop maintaining a second copy of the gate.

---

<a id="a-worktrees-first-script"></a>

## 2. A worktree's first script

A worktree's first script opens the branch, commits the plan and pushes it, then records where each of its steps' work is: In progress, its row on its team's Schedule project linking the branch in its Worktree column ([agent-rules.md](agent-rules.md), rule 19). The link waits for the push, since a link to a branch GitHub doesn't have leads nowhere. Like the merge script's schedule step, it finds each row by its issue and the project's title, and the fields and options by name, so no ID is pasted into a script and none goes stale (rule 13). Beside the rows, it links the plans: `star github plan link`, given each of the worktree's plans by its path relative to `docs/plans`, writes the `Plan and design documents` section of every issue they serve from every plan that serves it, and the script stops unless it exits 0 (#557). Its records say what it did to each issue; an issue refused, or a row the section drops, is a finding for the owner, and exits 0.

```bash
# The schedule's helpers (agent-rules.md, rule 19). A step's row is found by its issue and its team's Schedule project,
# by title, and the project's fields and options by name, so no ID is pasted into a script and none goes stale.
repository=<owner>/<repo>
schedule_project="Schedule: <team>"

# step_row prints a step's row on the team's Schedule project, as {project, item, schedule, status, worktree}, or
# nothing when the issue has no row there. fieldValueByName answers null for a field a project lacks, so every project
# the issue is a row of can be read in the one query.
step_row() {
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -F n="$1" -f o="${repository%%/*}" -f r="${repository#*/}" -f query='query($o: String!, $r: String!,
        $n: Int!) { repository(owner: $o, name: $r) { issue(number: $n) { projectItems(first: 20) { nodes { id
        project { id title }
        schedule: fieldValueByName(name: "Schedule") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
        status: fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
        worktree: fieldValueByName(name: "Worktree") { ... on ProjectV2ItemFieldTextValue { text } } } } } } }' |
        jq -c --arg t "${schedule_project}" '.data.repository.issue.projectItems.nodes[] | select(.project.title == $t)
            | {project: .project.id, item: .id, schedule: .schedule.name, status: .status.name, worktree: (.worktree.text // "")}'
}

# set_row sets a row's Status, by the option's name, and its Worktree, the project's fields found by name.
set_row() {
    local project="$1" item="$2" status="$3" link="$4" fields
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    fields="$(gh api graphql -f p="${project}" -f query='query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) {
        nodes { ... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }' |
        jq -c '[.data.node.fields.nodes[] | select(.name == "Status" or .name == "Worktree")] | INDEX(.name)')"
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Status.id' <<<"${fields}")" \
        -f o="$(jq -r --arg s "${status}" '.Status.options[] | select(.name == $s) | .id' <<<"${fields}")" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }' >/dev/null
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Worktree.id' <<<"${fields}")" -f v="${link}" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $v: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {text: $v}}) { projectV2Item { id } } }' >/dev/null
}

# --- The steps: each one's row In progress, its Worktree linking the branch (rule 13; agent-rules.md, rule 19) ---
#
# After the push, since a link to a branch GitHub doesn't have leads nowhere. Guarded on what each row holds (ruled
# 2026-11-13): it must be on a schedule, Open or In progress, and link no other branch; otherwise another worktree holds
# the step, and the script stops, naming it. Each row is read back.
steps=(<issue>)
link="https://github.com/${repository}/tree/<branch>"
for step in "${steps[@]}"; do
    row="$(step_row "${step}")"
    [[ -n "${row}" ]] || {
        echo "#${step} has no row on ${schedule_project}"
        exit 1
    }
    [[ -n "$(jq -r '.schedule // ""' <<<"${row}")" ]] || {
        echo "#${step}'s row on ${schedule_project} names no schedule"
        exit 1
    }
    case "$(jq -r '.status // ""' <<<"${row}")" in
        Open | "In progress") ;;
        *)
            echo "#${step}'s row is $(jq -r '.status // "without a Status"' <<<"${row}"), not Open or In progress"
            exit 1
            ;;
    esac
    held="$(jq -r .worktree <<<"${row}")"
    [[ -z "${held}" || "${held}" == "${link}" ]] || {
        echo "#${step}'s row links ${held}: another worktree holds the step"
        exit 1
    }
    set_row "$(jq -r .project <<<"${row}")" "$(jq -r .item <<<"${row}")" "In progress" "${link}"
    after="$(step_row "${step}")"
    [[ "$(jq -r '"\(.status) \(.worktree)"' <<<"${after}")" == "In progress ${link}" ]] || {
        echo "#${step}'s row reads: $(jq -c 'del(.project, .item)' <<<"${after}")"
        exit 1
    }
    echo "#${step}: $(jq -r '"\(.schedule), \(.status), \(.worktree)"' <<<"${after}")"
done

# --- The plans: each issue they serve links them in its Plan and design documents section (rule 13; #557) ---
#
# After the push, beside the steps' rows. Each plan is named by its path relative to docs/plans, and read from this
# worktree, since it has not merged; the plans on the default branches of writ's layers that serve the same issues are
# read with it. A refused issue or a dropped row is in the records and exits 0; any other exit is an error.
plans=(<type>/<issue>-<name>.md)
star github plan link "${plans[@]}" --silent --jq 'map({issue, action, reason, dropped})' || {
    echo "star github plan link failed: the issues' Plan and design documents sections are not known to be written"
    exit 1
}
```

---

<a id="template"></a>

## 3. Template

```bash
#!/usr/bin/env bash
set -euo pipefail

cd ~/Workspace/<org>/<clone>.<issue>-<name>

repository='<owner>/<repo>'
assisting_agent='<submitting agent>'
# Fill only from the reviewed completion/closure authorization. All other
# issues remain open for their recorded post-merge obligations.
close_steps=()

# Stage specific files (never git add -A or git add .)
git add \
    path/to/file1 \
    path/to/file2

# Nothing left behind: a tracked file still modified after staging is a change this PR silently
# omits. gh prints "Warning: N uncommitted change" and carries on; the script must not.
git diff --quiet || {
    echo "unstaged changes remain; stage them by name or revert them:"
    git status --short
    exit 1
}

# --- Pre-flight: the repository's own gate, not an approximation of it ---
#
# Run what CI runs. Passing here must mean passing there, which is only true if it is literally
# the same command. Placed before the commit so a failure costs nothing -- no branch, no issue,
# no PR to recover.
#
# set -euo pipefail aborts on a non-zero exit. Do not wrap this in an if.
.github/scripts/shell-lint.sh

# Commit
git commit -m "$(
    cat <<'EOF'
<type>(<scope>): <summary>

<body>
EOF
)"

# Pull before the merge: bring the branch current with the target by a merge commit (never a rebase),
# so CI and the merge gate judge it against the target it will land on.
git pull --no-rebase --no-edit origin <target>

# Push branch
git push -u origin <branch>

# The description says AI assisted and ends with the two trailers (rule 2). The sign-off comes from git's
# configuration, never typed. The merge step below writes everything above ## Time into the squash commit.
# The description's form is kept in the account's pull request template, in its .github repository: NobleFactor's
# since #431, David-Noble-at-work's since #441 (rule 2).
description="$(
    cat <<'EOF'
## Summary

- **Change 1** — description
- **Change 2** — description

## Test plan

- [x] Verified item
- [ ] TODO item

Written with AI assistance.
EOF
)"
for issue in "${close_steps[@]}"; do
    description+=$'\n\n'"Closes #${issue}."
done
description+=$'\n\n'"Signed-off-by: $(git config user.name) <$(git config user.email)>"
description+=$'\n'"Assisted-by: ${assisting_agent}"

# Create PR
gh pr create \
    --title "<type>(<scope>): <summary>" \
    --body "${description}"$'\n\n## Time\n\n_Filled by the merge step below._'

# --- CI and merge gates ---
pr_number=$(gh pr view --json number --jq '.number')
qualified_head=$(gh pr view "${pr_number}" --json headRefOid --jq '.headRefOid')

# The default requires observed passing checks. A proven no-CI repository
# needs its reviewed policy reflected here; empty output never proves it.
gh pr checks "${pr_number}" --watch
checks=$(gh pr checks "${pr_number}" --json bucket)
jq -e 'length > 0 and all(.[]; .bucket == "pass")' <<<"${checks}" >/dev/null || {
    echo 'The observed checks are not all passing. Inspect the current head and CI policy.' >&2
    exit 1
}

gate=$(gh pr view "${pr_number}" --json state,headRefOid,mergeStateStatus,reviewDecision)
jq -e --arg head "${qualified_head}" '
    .state == "OPEN" and .headRefOid == $head and .mergeStateStatus == "CLEAN" and
    (.reviewDecision == null or .reviewDecision == "" or .reviewDecision == "APPROVED")
' <<<"${gate}" >/dev/null || {
    echo 'The PR head, merge state or review decision is not ready. Stop for review.' >&2
    exit 1
}

# Refuse an incomplete thread read rather than overlooking another page.
# These literal GraphQL/jq programs bind their own variables.
# shellcheck disable=SC2016
threads=$(gh api graphql -f owner="${repository%%/*}" -f name="${repository#*/}" -F number="${pr_number}" -f query='
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) { pullRequest(number: $number) {
    reviewThreads(first: 100) { pageInfo { hasNextPage } nodes { isResolved } }
  } }
}')
jq -e '
    ((.errors // []) | length) == 0 and .data.repository.pullRequest != null and
    .data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage == false and
    all(.data.repository.pullRequest.reviewThreads.nodes[]; .isResolved == true)
' <<<"${threads}" >/dev/null || {
    echo 'Review threads are unresolved or were not completely read. Stop for review.' >&2
    exit 1
}

# Squash merge -- and nothing else on this line.
#
# Always --squash. Never --delete-branch: it deletes the LOCAL branch first, which fails when a
# linked worktree holds the branch (the normal case under git-open-branch), gh exits non-zero, and
# set -e ends the script here -- after the merge has already landed, before any cleanup has run.
# Deletion belongs to git close-branch below, which deletes the remote first so a failure leaves
# both halves intact.
#
# The squash commit's message is the pull request's title and its description up to ## Time, so the two
# trailers end it and land on the target (rule 2). GitHub's own composition is not used: it is a repository
# setting, and it is made from the branch's commits, which carry no trailer. The message goes through a file,
# and the span step below reuses that file; the one trap removes it.
message_file=$(mktemp)
trap 'rm "${message_file}"' EXIT
gh pr view "${pr_number}" --json body --jq .body | sed '/^## Time$/,$d' >"${message_file}"
gh pr merge "${pr_number}" --squash --match-head-commit "${qualified_head}" \
    --subject "$(gh pr view "${pr_number}" --json title --jq .title) (#${pr_number})" \
    --body-file "${message_file}"

# A merge queue may defer delivery. Record no merge or closure until GitHub
# confirms that the merge actually happened.
delivery=$(gh pr view "${pr_number}" --json state,mergedAt,mergeCommit)
jq -e '.state == "MERGED" and .mergedAt != null and .mergeCommit.oid != null' <<<"${delivery}" >/dev/null || {
    echo 'The PR is not yet merged. Preserve this state and inspect its queue or delivery status.' >&2
    exit 1
}

# --- The span: every pull request records its time (rule 11) ---
#
# Three markers from GitHub's own timestamps, elapsed hours to one decimal, appended to the PR body and
# verified. AFTER the merge, not before: mergedAt does not exist until the merge lands. Carried verbatim
# here until `star github pr span` exists (noblefactor-ops#188); then this block is one call to it.
# These literal GraphQL/jq programs bind their own variables.
# shellcheck disable=SC2016
span=$(gh pr view "${pr_number}" --json createdAt,mergedAt,commits --jq '
  (.commits[0].committedDate) as $opened | .createdAt as $submitted | .mergedAt as $merged |
  def hrs(a; b): (((b | fromdate) - (a | fromdate)) / 3600 * 10 | round) / 10;
  "## Time\n\n| Marker | UTC | Elapsed |\n| --- | --- | --- |\n" +
  "| opened (first commit) | \($opened) | — |\n" +
  "| submitted (PR opened) | \($submitted) | \(hrs($opened; $submitted)) h after opened |\n" +
  "| merged | \($merged) | \(hrs($submitted; $merged)) h after submitted; \(hrs($opened; $merged)) h in all |\n" +
  "\nComputed by the algorithm of noblefactor-ops#188 at merge."')
body=$(gh pr view "${pr_number}" --json body --jq .body | sed '/^## Time$/,$d')
# Through the REST API, not `gh pr edit`: on gh 2.46.0 that command dies on GitHub's Projects (classic)
# deprecation (repository.pullRequest.projectCards) -- personal#221's run stopped after its merge with
# no Time section and no cleanup. The Windows form has always written the body this way.
printf '%s\n%s\n' "${body}" "${span}" >"${message_file}"
gh api -X PATCH "repos/<owner>/<repo>/pulls/${pr_number}" -F "body=@${message_file}" --jq .number >/dev/null
gh pr view "${pr_number}" --json body --jq .body | grep -q '^## Time' || {
    echo "the PR body carries no ## Time section"
    exit 1
}
printf '%s\n' "${span}"

# The schedule's helpers (agent-rules.md, rule 19). A step's row is found by its issue and its team's Schedule project,
# by title, and the project's fields and options by name, so no ID is pasted into a script and none goes stale.
repository=<owner>/<repo>
schedule_project="Schedule: <team>"

# step_row prints a step's row on the team's Schedule project, as {project, item, schedule, status, worktree}, or
# nothing when the issue has no row there. fieldValueByName answers null for a field a project lacks, so every project
# the issue is a row of can be read in the one query.
step_row() {
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -F n="$1" -f o="${repository%%/*}" -f r="${repository#*/}" -f query='query($o: String!, $r: String!,
        $n: Int!) { repository(owner: $o, name: $r) { issue(number: $n) { projectItems(first: 20) { nodes { id
        project { id title }
        schedule: fieldValueByName(name: "Schedule") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
        status: fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
        worktree: fieldValueByName(name: "Worktree") { ... on ProjectV2ItemFieldTextValue { text } } } } } } }' |
        jq -c --arg t "${schedule_project}" '.data.repository.issue.projectItems.nodes[] | select(.project.title == $t)
            | {project: .project.id, item: .id, schedule: .schedule.name, status: .status.name, worktree: (.worktree.text // "")}'
}

# set_row sets a row's Status, by the option's name, and its Worktree, the project's fields found by name.
set_row() {
    local project="$1" item="$2" status="$3" link="$4" fields
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    fields="$(gh api graphql -f p="${project}" -f query='query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) {
        nodes { ... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }' |
        jq -c '[.data.node.fields.nodes[] | select(.name == "Status" or .name == "Worktree")] | INDEX(.name)')"
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Status.id' <<<"${fields}")" \
        -f o="$(jq -r --arg s "${status}" '.Status.options[] | select(.name == $s) | .id' <<<"${fields}")" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }' >/dev/null
    # These literal GraphQL/jq programs bind their own variables.
    # shellcheck disable=SC2016
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Worktree.id' <<<"${fields}")" -f v="${link}" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $v: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {text: $v}}) { projectV2Item { id } } }' >/dev/null
}

# --- The steps: each one's issue records the merge, and its row records delivery (rule 13; agent-rules.md, rule 19) ---
#
# AFTER the merge and its span, since the records name the squash commit. Guarded on what each record holds (ruled
# 2026-11-13): the step's row must link this branch, or this pull request when the script runs again; otherwise the
# step has moved to another worktree, and the script stops. Closure requires the reviewed close_steps authorization: a
# step approved to close is closed by star github issue close, the merge record its evidence, which also sets its
# schedule row Closed; every other step gets the merge record as a comment, once, and stays open for its post-merge
# obligations. Each record is read back. A step that moves to another worktree, or closes without a merge,
# is recorded by this script before git close-branch, its row linking where the work went. Leave the step out only
# when the pull request lands no step.
steps=(<issue>)
link="https://github.com/${repository}/tree/<branch>"
pr_url="https://github.com/${repository}/pull/${pr_number}"
merged=$(gh pr view "${pr_number}" --repo "${repository}" --json mergeCommit,mergedAt --jq '"\(.mergeCommit.oid[0:7]) \(.mergedAt[0:10])"')
for step in "${steps[@]}"; do
    row="$(step_row "${step}")"
    [[ -n "${row}" ]] || {
        echo "#${step} has no row on ${schedule_project}"
        exit 1
    }
    held="$(jq -r .worktree <<<"${row}")"
    [[ "${held}" == "${link}" || "${held}" == "${pr_url}" ]] || {
        echo "#${step}'s row links ${held:-nothing}, not ${link} or ${pr_url}: the step has moved"
        exit 1
    }
    record="Merged in #${pr_number} as \`${merged% *}\` on ${merged#* } (UTC)."
    close_allowed=false
    for approved in "${close_steps[@]}"; do
        [[ "${approved}" != "${step}" ]] || close_allowed=true
    done
    expected_state=OPEN
    expected_status='In progress'
    if [[ "${close_allowed}" == true ]]; then
        # The merge record is the step's evidence: star github issue close posts it, closes the issue as completed and
        # sets its schedule row Closed. Run again, it leaves a closed step as it is.
        evidence="$(mktemp)"
        printf '%s\n' "${record}" >"${evidence}"
        if ! star github issue close "${repository}#${step}" --evidence "${evidence}" --silent --no-pager -o json >/dev/null; then
            rm -f -- "${evidence}"
            echo "#${step} did not close" >&2
            exit 1
        fi
        rm -f -- "${evidence}"
        expected_state=CLOSED
        expected_status=Closed
    else
        if [[ "$(gh issue view "${step}" --repo "${repository}" --json state --jq .state)" != OPEN ]]; then
            echo "#${step} is already closed; inspect its completion disposition before changing its row." >&2
            exit 1
        fi
        gh api "repos/${repository}/issues/${step}/comments" --paginate --jq '.[].body' | grep -qxF -- "${record}" ||
            gh issue comment "${step}" --repo "${repository}" --body "${record}" >/dev/null
    fi
    set_row "$(jq -r .project <<<"${row}")" "$(jq -r .item <<<"${row}")" "${expected_status}" "${pr_url}"
    after="$(step_row "${step}")"
    if ! gh api "repos/${repository}/issues/${step}/comments" --paginate --jq '.[].body' | grep -qxF -- "${record}" ||
        [[ "$(gh issue view "${step}" --repo "${repository}" --json state --jq .state)" != "${expected_state}" ]] ||
        [[ "$(jq -r '"\(.status) \(.worktree)"' <<<"${after}")" != "${expected_status} ${pr_url}" ]]; then
        echo "#${step} does not read back as merged: its row reads $(jq -c 'del(.project, .item)' <<<"${after}")"
        exit 1
    fi
    echo "#${step}: ${expected_state}, its merge recorded, its row $(jq -r '"\(.status), \(.worktree)"' <<<"${after}")"
done

# Clean up (works from both worktrees and regular branches)
git close-branch

# close-branch removed the worktree this script was standing in, and this script with it. Anything that runs
# after it must first step back to the main clone, or it runs from a deleted directory and exits 128; bash
# keeps reading the unlinked file, so nothing below is lost.
cd ~/Workspace/<org>/<clone>

# Pull after the merge, to confirm: git close-branch syncs the main clone -- the layer writ deploys from -- to
# the target itself, and exits 75 when it cannot (#306), so this pull finds it current. Never fetch into the
# target branch here: the main clone has it checked out, and git refuses.
git pull --ff-only origin <target>
git log --oneline -1

# The commit that landed carries both trailers (rule 2), or the script says so and fails.
landed=$(git log --max-count=1 --format=%B)

if ! grep --quiet '^Signed-off-by: ' <<<"${landed}" || ! grep --quiet '^Assisted-by: ' <<<"${landed}"; then
    echo "the squash commit on <target> lacks Signed-off-by or Assisted-by"
    exit 1
fi

git status --short

# --- The end-of-PR report, when one is asked for (rule 9) ---
#
# Not automatic: ruled 2026-09-12 (development-process.md), retiring the standing rule of 2026-09-04.
# When the owner asks for it, scope it to what the pull request served with --filter on its epic, feature or
# schedule (#379, ruled 2026-11-08); --silent, not 2>/dev/null.
# star github schedule report --silent --output table --filter epic=<owner>/<repo>#<n> --jq 'map({issue, type, state, title})'
```

---

<a id="rules"></a>

## 4. Rules

1. **Stage by name.** Never `git add -A` or `git add .`.
2. **Follow the [disclosure requirements](../engineering/procedures/pull-request.md#review-boundary).** The description says AI assisted and ends, before its Time section, with human sign-off and the effective assistance trailer. Populate the submitting agent explicitly, applying any recorded temporary live-entrypoint override. Preserve the two trailers in the squash commit and verify them after delivery. Branch commits carry no trailer. Use the account's maintained PR-body template and retain the prohibition on AI co-authorship and promotional footers.
3. **HEREDOC for messages.** Both commit messages and PR bodies use `cat <<'EOF'` for safe formatting.
4. **Establish CI results.** The examples require observed passing checks for the qualified head. An empty check list never proves CI is unconfigured. A repository with no configured checks, or an approved conditional-check result, needs that verified policy recorded in the plan and reflected in the generated gate. Retain every required check; uncertainty stops the run.
5. **Establish merge readiness.** Check the qualified head, clean merge state, review decision and all review conversations. Pin the merge to that head and use ordinary merge authority. Confirm actual merged state before recording delivery; a queued merge is still outstanding. Administrative bypass requires its separate explicit Owner grant under the PR procedure.
6. **`git close-branch` for cleanup.** Handles both worktree and regular-branch scenarios. It also **removes the worktree the script is standing in**, so nothing after it may assume `cwd` survives: `cd` to the main clone first. Observed as a spurious exit 128 after a successful merge on devlore-cli#811. It **removes the script itself**, `<worktree>.bash` or `.ps1` beside the worktree (#366); bash reads on from the unlinked file and PowerShell parsed the file before running it, so the lines after it still run. Then it **syncs the main clone** to the target branch, whatever it had checked out, prints what it had and the commit it is at now, and exits 75 when the sync cannot happen (#306).
7. **Follow the [worktree integration boundary](../engineering/process.md#pull-request-and-integration).** A worktree serves one active PR. During integration it accepts that PR's review or CI corrections; honor any temporary live-entrypoint restriction still applicable to the session.
8. **Always `--squash`, never `--delete-branch`.** The merge command carries `--squash` and no other deletion flag. `--delete-branch` deletes the local branch first, which fails when a linked worktree holds it, and under `set -e` that aborts the script after the merge and before cleanup. `git close-branch` deletes in the order that survives a failure: remote, then worktree, then local, then the script. Then it syncs the main clone itself (rules 6 and 12).
9. **The epic report ends a pull request when one is asked for.** Table form, all states, scoped to the epic, feature or thread the pull request served, printed last, after cleanup, so the reader sees the state the merge produced. Not automatic: ruled 2026-09-12 in `development-process.md`, which retired the standing rule of 2026-09-04 that every pull request print one.

10. **Nothing left behind.** After `git add` by name, `git diff --quiet` must pass. A modified tracked file the script did not stage is a change the PR silently omits; #161 merged without the rule above for exactly this reason.

11. **Every pull request records its time.** A `## Time` section in the pull request's own body, written by the merge step from GitHub's own timestamps and verified there: `opened` (the branch's first commit), `submitted` (the pull request's creation), `merged`, and the elapsed hours between them to one decimal. Ruled 2026-09-08. One algorithm for every pull request -- a number computed differently each time is noise, and the value is in the series. It measures how long the work was **open**, review gaps and nights included; it is not effort and must not be read as one. Where a coding agent estimates active time from its own session transcript, that estimate goes in the agent's end-of-PR message, labeled an estimate, and never into the pull request as fact.

12. **Pull before and after the merge.** Ruled 2026-09-24. Before the push, the branch takes the target by a merge commit (`git pull --no-rebase`), so what CI passes is what merges. After the merge, `git close-branch` syncs the main clone to the target, the squash commit with it, and exits 75 when it cannot (#306); the script's `git pull --ff-only` then confirms it, finding the clone current. Every script written on 2026-09-24 had to add both pulls by hand; the template owes them.

13. **Record progress as it happens.** First scripts push the plan before linking the branch from its Schedule row, then run plan linking. Merge scripts record the actual PR and squash commit on each step's issue and link its row to the PR. Close only the issues listed in the reviewed closure authorization, after their required evidence is satisfied; otherwise keep the issue Open and the row In progress for post-merge work. Find rows and fields by name, guard current ownership, write each record once and read it back. Inspect plan-link refusal and dropped-row records even when the command exits 0. Cleanup waits until outstanding obligations and evidence have a durable home.

---

<a id="on-windows-powershell"></a>

## 5. On Windows: PowerShell

On Windows the PR script is `<worktree>.ps1`, beside the worktree, PowerShell 7, written to the [PowerShell style guide](powershell-style-guidelines.md), every section of it: shebang, header, help, `#Requires`, `[CmdletBinding()]` and `param()`, the caller's error action noted and `$ErrorActionPreference = 'Stop'` set, the constants, a helpers region, then the main operation inside `try` and `catch`. It does what the bash template does, in the same order. The rules above hold; these are the ones PowerShell changes.

1. **Every native command runs through `Invoke-Native`.** `$ErrorActionPreference = 'Stop'` doesn't cover a native command's exit code, and there is no `set -e`. `Invoke-Native` runs `git`, `gh` and `star` through .NET's `Process`, each argument passed as one and what the program writes read as UTF-8, as the style guide's § 7 asks of a script that reads a native program's output. What the program writes to standard error goes to the verbose stream, and a non-zero exit is a refusal unless the call allows it. Its argument list comes last, so that a long one breaks after a comma.
2. **Errors are the style guide's § 7.** The script notes its caller's error action, sets `Stop`, and runs its work in `try`. The `catch` puts the caller's error action back, reports the error with `$PSCmdlet.WriteError` and exits 1. The `finally` removes the files the run made and returns the caller to the directory they ran it from (§ 8). Each refusal is an error record of the script's own, with an id and a category, made by `ConvertTo-Refusal` and thrown inside the work: never a thrown string, never `$PSCmdlet.ThrowTerminatingError`.
3. **What it is doing goes to the verbose stream; its result is objects.** `Write-Verbose` says what the script is doing, and each step it records and the pull request it merged are output objects. Nothing goes to the host or the information stream, and the script sets no preference but `$ErrorActionPreference`.
4. **Bodies are single-quoted here-strings.** The PR body and the jq program are `@'...'@`, so PowerShell expands nothing in them. The body goes to `gh` through a file, `--body-file`.
5. **The `## Time` section is written through a file,** `gh api -X PATCH repos/<owner>/<repo>/pulls/<n> -F body=@<file>`, as every Windows PR script has done. PowerShell has no `printf ... | --body-file -` idiom worth copying, and a file keeps the body byte-for-byte.
6. **Clean-up runs from the main clone.** `Set-Location` to it before `git close-branch`, because Windows won't delete a directory that is a process's current directory. `git close-branch` also removes this script, which PowerShell parsed in full before running, so the lines after it still run. Then `git pull --ff-only`, which confirms the sync `git close-branch` made of the main clone (rule 12).
7. **No PATH changes.** The script runs from a pwsh whose `git` is `Git\cmd\git.exe`, Git for Windows' launcher, which gives git's children the `sh` and `bash` they need without putting them on PATH. From a pwsh started by Git Bash, `git` resolves to the raw `Git\clangarm64\bin\git.exe`, and an HTTPS push, a credential helper or `git close-branch` exits 128 with no message. The fix is where the script runs, never a PATH line in it.
8. **The owner runs it with `-Verbose`.** The command handed over is `! & 'C:/Users/<you>/Workspace/<org>/<clone>.<n>-<name>.ps1' -Verbose`, the script's full path in single quotes with forward slashes. What the script is doing shows only on the verbose stream (rule 3), so without `-Verbose` a run says nothing until it ends.

```powershell
#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    PR script for <owner>/<repo>, issue #<n>.

.DESCRIPTION
    Opens the pull request for <branch>, waits for CI, checks the merge state,
    squash-merges, records the pull request's time span and the steps it lands, and closes the branch. Every commit is
    made and pushed; there is nothing to stage. What it is doing goes to the verbose stream: run it with -Verbose to see
    it.

.OUTPUTS
    PSCustomObject: each step's recorded issue state and row status; then the pull request merged, its
    number, link and squash commit.

.EXAMPLE
    & 'C:/Users/<you>/Workspace/<org>/<clone>.<n>-<name>.ps1' -Verbose
#>

#Requires -Version 7.0

[CmdletBinding()]
param()

$callerErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

$branch = '<branch>'
$repository = '<owner>/<repo>'
$assistingAgent = '<submitting agent>'
# Populate only from the reviewed completion/closure authorization.
$closeSteps = @()
$worktree = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>',
    '<clone>.<n>-<name>'
$mainClone = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>', '<clone>'
$scheduleProject = 'Schedule: <team>'

# The pull request's body and squash message go to gh through files, made and removed within the run.
$bodyFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'pr-<n>-body.md'
$squashFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'pr-<n>-squash.md'

###########
# Helper functions
###########

# Get-StepRow gets a step's row on the team's Schedule project, found by its issue and the project's title.
#
# fieldValueByName answers null for a field a project lacks, so every project the issue is a row of can be read in the
# one query.
#
# Parameters:
#   - `Issue`: The step's issue number, in $repository.
#
# Returns:
#   - PSCustomObject: the row's `Project`, `Item`, `Schedule`, `Status` and `Worktree`; $null when the issue has no
#     row on $scheduleProject.
function Get-StepRow {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [Int32]
        $Issue
    )

    $owner, $name = $repository -split '/', 2
    $query = @'
query($o: String!, $r: String!, $n: Int!) { repository(owner: $o, name: $r) { issue(number: $n) {
projectItems(first: 20) { nodes { id project { id title }
schedule: fieldValueByName(name: "Schedule") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
status: fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
worktree: fieldValueByName(name: "Worktree") { ... on ProjectV2ItemFieldTextValue { text } } } } } } }
'@
    $answer = Invoke-Native -Name gh -Operation "Reading #$Issue's row" -ArgumentList 'api', 'graphql',
        '-F', "n=$Issue", '-f', "o=$owner", '-f', "r=$name", '-f', "query=$query"
    $node = (ConvertFrom-Json -InputObject $answer.Output).data.repository.issue.projectItems.nodes |
        Where-Object { $_.project.title -eq $scheduleProject } | Select-Object -First 1

    if (-not $node) {
        return $null
    }

    [PSCustomObject]@{
        Project  = $node.project.id
        Item     = $node.id
        Schedule = [String]$node.schedule.name
        Status   = [String]$node.status.name
        Worktree = [String]$node.worktree.text
    }
}

# Set-StepRow sets a row's Status, by the option's name, and its Worktree, the project's fields found by name.
#
# It changes the row on GitHub, so it supports ShouldProcess: with -WhatIf, it says what it would set and sets nothing.
# A project that lacks the field or the option is a refusal, naming it.
#
# Parameters:
#   - `Row`: The row, as Get-StepRow gets it.
#   - `Status`: The name of the Status option to set.
#   - `Link`: The Worktree's text: the branch's link, or the pull request's.
function Set-StepRow {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]
        $Row,

        [Parameter(Mandatory)]
        [String]
        $Status,

        [Parameter(Mandatory)]
        [String]
        $Link
    )

    $target = "$($Row.Item) on $scheduleProject"

    if (-not $PSCmdlet.ShouldProcess($target, "Set its Status to $Status and its Worktree to $Link")) {
        return
    }

    $query = @'
query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) { nodes {
... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }
'@
    $answer = Invoke-Native -Name gh -Operation "Reading the fields of $scheduleProject" -ArgumentList 'api', 'graphql',
        '-f', "p=$($Row.Project)", '-f', "query=$query"
    $fields = (ConvertFrom-Json -InputObject $answer.Output).data.node.fields.nodes
    $statusField = $fields | Where-Object { $_.name -eq 'Status' }
    $worktreeField = $fields | Where-Object { $_.name -eq 'Worktree' }
    $option = $statusField.options | Where-Object { $_.name -eq $Status }

    if (-not $option -or -not $worktreeField) {
        $message = "$scheduleProject has no Status option $Status, or no Worktree field."
        throw (ConvertTo-Refusal -Message $message -Id 'NoScheduleField' -Category ObjectNotFound -Target $Row.Project)
    }

    $setOption = @'
mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p, itemId: $i,
fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }
'@
    $null = Invoke-Native -Name gh -Operation "Setting $target's Status" -ArgumentList 'api', 'graphql',
        '-f', "p=$($Row.Project)", '-f', "i=$($Row.Item)", '-f', "f=$($statusField.id)", '-f', "o=$($option.id)",
        '-f', "query=$setOption"

    $setText = @'
mutation($p: ID!, $i: ID!, $f: ID!, $v: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p, itemId: $i,
fieldId: $f, value: {text: $v}}) { projectV2Item { id } } }
'@
    $null = Invoke-Native -Name gh -Operation "Setting $target's Worktree" -ArgumentList 'api', 'graphql',
        '-f', "p=$($Row.Project)", '-f', "i=$($Row.Item)", '-f', "f=$($worktreeField.id)", '-f', "v=$Link",
        '-f', "query=$setText"
}

# Get-PullRequestBody gets the pull request's description, ending with the two trailers and a Time section to fill.
#
# The description says AI assisted and ends with the trailers (rule 2), the sign-off from git's configuration. Its form
# is kept in the account's pull request template, in its .github repository: NobleFactor's since #431,
# David-Noble-at-work's since #441 (rule 2). The merge step below fills the Time section.
#
# Returns:
#   - String: the description.
function Get-PullRequestBody {
    [CmdletBinding()]
    [OutputType([String])]
    param()

    $name = Invoke-Native -Name git -Operation 'Reading git user.name' -ArgumentList 'config', 'user.name'
    $email = Invoke-Native -Name git -Operation 'Reading git user.email' -ArgumentList 'config', 'user.email'
    $signer = "$($name.Output.Trim()) <$($email.Output.Trim())>"

    $description = @'
## Summary

- **Change 1** -- description

## Test plan

- [x] Verified item

Part of #<n>

Written with AI assistance.
'@

    foreach ($issue in $closeSteps) {
        $description += "`n`nCloses #$issue."
    }

    $trailers = "Signed-off-by: $signer`nAssisted-by: $assistingAgent"
    "$description`n`n$trailers`n`n## Time`n`n_Filled by the merge step below._"
}

# Get-TimeSpanSection gets the pull request's Time section, its three markers from GitHub's own timestamps (rule 11).
#
# Parameters:
#   - `Number`: The pull request's number.
#
# Returns:
#   - String: the section, each marker's time and the hours between them.
function Get-TimeSpanSection {
    [CmdletBinding()]
    [OutputType([String])]
    param(
        [Parameter(Mandatory)]
        [Int32]
        $Number
    )

    $program = @'
(.commits[0].committedDate) as $opened | .createdAt as $submitted | .mergedAt as $merged |
def hrs(a; b): (((b | fromdate) - (a | fromdate)) / 3600 * 10 | round) / 10;
"## Time\n\n| Marker | UTC | Elapsed |\n| --- | --- | --- |\n" +
"| opened (first commit) | \($opened) | \u2014 |\n" +
"| submitted (PR opened) | \($submitted) | \(hrs($opened; $submitted)) h after opened |\n" +
"| merged | \($merged) | \(hrs($submitted; $merged)) h after submitted; \(hrs($opened; $merged)) h in all |\n" +
"\nComputed by the algorithm of noblefactor-ops#188 at merge."
'@

    $answer = Invoke-Native -Name gh -Operation "Reading #$Number's time span" -ArgumentList 'pr', 'view', $Number,
        '--json', 'createdAt,mergedAt,commits', '--jq', $program
    $answer.Output.TrimEnd()
}

# Invoke-Native runs a native program, its output read as UTF-8, and gets what it wrote and how it exited.
#
# The program runs through .NET's Process, each argument passed as one and its standard input closed, so that text
# beyond ASCII survives a Windows console's code page (the style guide's section 7, Native programs). What it writes to
# standard error, and to standard output with Narrate, goes to the verbose stream. A non-zero exit is a refusal naming
# the operation, unless AllowFailure lets the caller read it.
#
# Parameters:
#   - `Name`: The program, as the PATH finds it: git, gh or star.
#   - `Operation`: What the call does, said on the verbose stream and in a refusal.
#   - `AllowFailure`: Gets a non-zero exit, in place of refusing it.
#   - `Narrate`: Says what the program writes to standard output on the verbose stream too.
#   - `ArgumentList`: Its arguments, each one argument.
#
# Returns:
#   - PSCustomObject: `ExitCode`; `Output`, what the program wrote to standard output; `ErrorText`, to standard error.
function Invoke-Native {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter(Mandatory)]
        [String]
        $Operation,

        [Switch]
        $AllowFailure,

        [Switch]
        $Narrate,

        [Parameter(Mandatory)]
        [String[]]
        $ArgumentList
    )

    Write-Verbose $Operation
    $program = (Get-Command -Name $Name -CommandType Application | Select-Object -First 1).Source
    $start = [System.Diagnostics.ProcessStartInfo]::new($program)

    foreach ($argument in $ArgumentList) {
        $start.ArgumentList.Add($argument)
    }

    $start.WorkingDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
    $start.UseShellExecute = $false
    $start.RedirectStandardInput = $true
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $start.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)

    $process = [System.Diagnostics.Process]::Start($start)
    $process.StandardInput.Close()
    $errorRead = $process.StandardError.ReadToEndAsync()
    $output = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $errorText = $errorRead.GetAwaiter().GetResult()
    $said = $errorText

    if ($Narrate) {
        $said = $output + $errorText
    }

    foreach ($line in ($said -split '\r?\n' | Where-Object { $_ })) {
        Write-Verbose "  $line"
    }

    if ($process.ExitCode -ne 0 -and -not $AllowFailure) {
        $message = "$Operation failed: $Name exited $($process.ExitCode). $($errorText.Trim())"
        throw (ConvertTo-Refusal -Message $message -Id 'NativeCommandFailed' -Category InvalidResult -Target $Name)
    }

    [PSCustomObject]@{
        ExitCode  = $process.ExitCode
        Output    = $output
        ErrorText = $errorText
    }
}

# ConvertTo-Refusal makes a refusal of the script's own, an error record with an id and a category, for it to throw.
#
# The script's catch reports it with $PSCmdlet.WriteError, so the caller sees the script's name, the id and the
# category (the style guide's section 7).
#
# Parameters:
#   - `Message`: What was refused and why.
#   - `Id`: The refusal's id.
#   - `Category`: Its category (default: InvalidOperation).
#   - `Target`: What it was refused for (default: none).
#
# Returns:
#   - ErrorRecord: the refusal.
function ConvertTo-Refusal {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.ErrorRecord])]
    param(
        [Parameter(Mandatory)]
        [String]
        $Message,

        [Parameter(Mandatory)]
        [String]
        $Id,

        [System.Management.Automation.ErrorCategory]
        $Category = [System.Management.Automation.ErrorCategory]::InvalidOperation,

        [Object]
        $Target = $null
    )

    [System.Management.Automation.ErrorRecord]::new(
        [System.InvalidOperationException]::new($Message),
        $Id,
        $Category,
        $Target)
}

###########
# Main
###########

try {
    Push-Location -LiteralPath $worktree

    # --- Pre-flight: nothing left behind, then the target merged in and the branch pushed ---

    $unstaged = Invoke-Native -Name git -Operation 'Looking for unstaged changes' -AllowFailure -ArgumentList 'diff',
        '--quiet'
    $staged = Invoke-Native -Name git -Operation 'Looking for staged changes' -AllowFailure -ArgumentList 'diff',
        '--cached', '--quiet'

    if ($unstaged.ExitCode -ne 0 -or $staged.ExitCode -ne 0) {
        $status = Invoke-Native -Name git -Operation 'Reading the worktree status' -ArgumentList 'status', '--short'
        $message = "The worktree is not clean; nothing should be left behind:`n$($status.Output)"
        throw (ConvertTo-Refusal -Message $message -Id 'WorktreeNotClean' -Target $worktree)
    }

    $null = Invoke-Native -Name git -Operation 'Merging <default-branch> into the branch' -Narrate -ArgumentList 'pull',
        '--no-rebase', '--no-edit', 'origin', '<default-branch>'
    $null = Invoke-Native -Name git -Operation "Pushing $branch" -Narrate -ArgumentList 'push', '-u', 'origin', $branch

    # --- Create the PR ---

    Set-Content -LiteralPath $bodyFile -Value (Get-PullRequestBody) -NoNewline
    $null = Invoke-Native -Name gh -Operation 'Opening the pull request' -Narrate -ArgumentList 'pr', 'create',
        '--base', '<default-branch>', '--head', $branch, '--body-file', $bodyFile,
        '--title', '<type>(<scope>): <summary>'
    $opened = Invoke-Native -Name gh -Operation "Reading $branch's pull request" -ArgumentList 'pr', 'view', $branch,
        '--json', 'number', '--jq', '.number'
    $number = [Int32]$opened.Output.Trim()

    # --- CI and merge gates ---

    $qualifiedHead = (Invoke-Native -Name gh -Operation "Reading #$number's qualified head" -ArgumentList 'pr',
            'view', $number, '--json', 'headRefOid', '--jq', '.headRefOid').Output.Trim()
    $null = Invoke-Native -Name gh -Operation "Waiting for #$number's checks" -Narrate -ArgumentList 'pr', 'checks',
        $number, '--watch'
    $answer = Invoke-Native -Name gh -Operation "Reading #$number's check results" -ArgumentList 'pr', 'checks',
        $number, '--json', 'bucket'
    $checks = @(ConvertFrom-Json -InputObject $answer.Output)

    if ($checks.Count -eq 0 -or @($checks | Where-Object { $_.bucket -ne 'pass' }).Count -ne 0) {
        $message = "#$number's observed checks are not all passing; inspect the head and CI policy."
        throw (ConvertTo-Refusal -Message $message -Id 'ChecksNotEstablished' -Category InvalidResult -Target $number)
    }

    $answer = Invoke-Native -Name gh -Operation "Reading #$number's merge readiness" -ArgumentList 'pr', 'view',
        $number, '--json', 'state,headRefOid,mergeStateStatus,reviewDecision'
    $gate = ConvertFrom-Json -InputObject $answer.Output
    $headReady = $gate.state -eq 'OPEN' -and $gate.headRefOid -eq $qualifiedHead
    $reviewReady = $gate.reviewDecision -in @($null, '', 'APPROVED')

    if (-not $headReady -or $gate.mergeStateStatus -ne 'CLEAN' -or -not $reviewReady) {
        $message = "#$number's head, merge state or review decision is not ready."
        throw (ConvertTo-Refusal -Message $message -Id 'NotMergeable' -Category InvalidResult -Target $number)
    }

    $owner, $name = $repository -split '/', 2
    $query = @'
query($owner: String!, $name: String!, $number: Int!) {
  repository(owner: $owner, name: $name) { pullRequest(number: $number) {
    reviewThreads(first: 100) { pageInfo { hasNextPage } nodes { isResolved } }
  } }
}
'@
    $answer = Invoke-Native -Name gh -Operation "Reading #$number's review threads" -ArgumentList 'api', 'graphql',
        '-f', "owner=$owner", '-f', "name=$name", '-F', "number=$number", '-f', "query=$query"
    $review = ConvertFrom-Json -InputObject $answer.Output
    $threads = $review.data.repository.pullRequest.reviewThreads
    $unresolved = @($threads.nodes | Where-Object { -not $_.isResolved })

    if ($review.errors -or -not $threads -or $threads.pageInfo.hasNextPage -ne $false -or $unresolved.Count -ne 0) {
        $message = "#$number's review threads are unresolved or were not completely read."
        throw (ConvertTo-Refusal -Message $message -Id 'ThreadsNotEstablished' -Category InvalidResult -Target $number)
    }

    # --- Squash merge: the message is the title and the description up to ## Time (rule 2) ---

    $title = (Invoke-Native -Name gh -Operation "Reading #$number's title" -ArgumentList 'pr', 'view', $number,
            '--json', 'title', '--jq', '.title').Output.Trim()
    $description = (Invoke-Native -Name gh -Operation "Reading #$number's description" -ArgumentList 'pr', 'view',
            $number, '--json', 'body', '--jq', '.body').Output
    Set-Content -LiteralPath $squashFile -Value ($description -replace '(?s)## Time.*$', '').TrimEnd() -NoNewline
    $null = Invoke-Native -Name gh -Operation "Merging #$number" -Narrate -ArgumentList 'pr', 'merge', $number,
        '--squash', '--match-head-commit', $qualifiedHead, '--subject', "$title (#$number)", '--body-file', $squashFile

    $answer = Invoke-Native -Name gh -Operation "Confirming #$number merged" -ArgumentList 'pr', 'view', $number,
        '--json', 'state,mergedAt,mergeCommit'
    $delivery = ConvertFrom-Json -InputObject $answer.Output

    if ($delivery.state -ne 'MERGED' -or -not $delivery.mergedAt -or -not $delivery.mergeCommit.oid) {
        $message = "#$number is not yet merged; inspect its queue or delivery status before recording completion."
        throw (ConvertTo-Refusal -Message $message -Id 'MergeOutstanding' -Category InvalidResult -Target $number)
    }

    # --- The span (rule 11) ---

    $section = Get-TimeSpanSection -Number $number
    $body = (Invoke-Native -Name gh -Operation "Reading #$number's body" -ArgumentList 'pr', 'view', $number,
            '--json', 'body', '--jq', '.body').Output -replace '(?s)## Time.*$', ''
    Set-Content -LiteralPath $bodyFile -Value ($body.TrimEnd() + "`n`n" + $section) -NoNewline
    $null = Invoke-Native -Name gh -Operation "Writing #$number's Time section" -ArgumentList 'api', '-X', 'PATCH',
        "repos/$repository/pulls/$number", '-F', "body=@$bodyFile"
    $written = (Invoke-Native -Name gh -Operation "Reading #$number's body back" -ArgumentList 'pr', 'view', $number,
            '--json', 'body', '--jq', '.body').Output

    if ($written -notmatch '(?m)^## Time') {
        $message = "#$number's body carries no ## Time section."
        throw (ConvertTo-Refusal -Message $message -Id 'NoTimeSection' -Category InvalidResult -Target $number)
    }

    # --- The steps: each one's issue records the merge, and its row records delivery (rule 13; agent-rules.md, rule 19) ---
    #
    # AFTER the merge and its span, since the records name the squash commit. Guarded on what each record holds (ruled
    # 2026-11-13): the step's row must link this branch, or this pull request when the script runs again; otherwise the
    # step has moved to another worktree, and the script stops. The merge comment is posted once. Closure requires the reviewed closeSteps authorization;
    # other issues remain open for their post-merge obligations. Each record is read back. A step that moves to another worktree, or closes without a merge,
    # is recorded by this script before git close-branch, its row linking where the work went. Left out only when the
    # pull request lands no step.

    $steps = @(<issue>)
    $link = "https://github.com/$repository/tree/<branch>"
    $pullRequest = "https://github.com/$repository/pull/$number"
    $squash = Invoke-Native -Name gh -Operation "Reading #$number's squash commit" -ArgumentList 'pr', 'view', $number,
        '--repo', $repository, '--json', 'mergeCommit,mergedAt', '--jq', '"\(.mergeCommit.oid[0:7]) \(.mergedAt[0:10])"'
    $sha, $day = $squash.Output.Trim() -split ' ', 2

    foreach ($step in $steps) {
        $row = Get-StepRow -Issue $step

        if (-not $row) {
            $message = "#$step has no row on $scheduleProject."
            throw (ConvertTo-Refusal -Message $message -Id 'StepHasNoRow' -Category ObjectNotFound -Target $step)
        }

        if ($row.Worktree -ne $link -and $row.Worktree -ne $pullRequest) {
            $message = "#$step's row links $($row.Worktree), not $link or ${pullRequest}: the step has moved."
            throw (ConvertTo-Refusal -Message $message -Id 'StepMoved' -Target $step)
        }

        $record = "Merged in #$number as ``$sha`` on $day (UTC)."
        $comments = (Invoke-Native -Name gh -Operation "Reading #$step's comments" -ArgumentList 'api',
            "repos/$repository/issues/$step/comments", '--paginate', '--jq', '.[].body').Output -split '\r?\n'

        if ($comments -cnotcontains $record) {
            $null = Invoke-Native -Name gh -Operation "Recording the merge on #$step" -ArgumentList 'issue', 'comment',
                $step, '--repo', $repository, '--body', $record
        }

        $state = (Invoke-Native -Name gh -Operation "Reading #$step's state" -ArgumentList 'issue', 'view', $step,
                '--repo', $repository, '--json', 'state', '--jq', '.state').Output.Trim()

        $expectedState = 'OPEN'
        $expectedStatus = 'In progress'

        if ($step -in $closeSteps) {
            if ($state -ne 'CLOSED') {
                $null = Invoke-Native -Name gh -Operation "Closing #$step" -ArgumentList 'issue', 'close', $step,
                    '--repo', $repository, '--reason', 'completed'
            }

            $expectedState = 'CLOSED'
            $expectedStatus = 'Closed'
        }
        elseif ($state -ne 'OPEN') {
            $message = "#$step is already closed; inspect its completion disposition before changing its row."
            throw (ConvertTo-Refusal -Message $message -Id 'ClosureNotEstablished' -Target $step)
        }

        Set-StepRow -Row $row -Status $expectedStatus -Link $pullRequest
        $after = Get-StepRow -Issue $step
        $comments = (Invoke-Native -Name gh -Operation "Reading #$step's comments back" -ArgumentList 'api',
            "repos/$repository/issues/$step/comments", '--paginate', '--jq', '.[].body').Output -split '\r?\n'
        $state = (Invoke-Native -Name gh -Operation "Reading #$step's state back" -ArgumentList 'issue', 'view', $step,
                '--repo', $repository, '--json', 'state', '--jq', '.state').Output.Trim()
        $issueRecorded = $comments -ccontains $record -and $state -eq $expectedState
        $rowRecorded = $after.Status -eq $expectedStatus -and $after.Worktree -eq $pullRequest

        if (-not $issueRecorded -or -not $rowRecorded) {
            $message = "#$step does not read back as merged: its row reads $($after.Status), $($after.Worktree)."
            throw (ConvertTo-Refusal -Message $message -Id 'StepNotRecorded' -Category InvalidResult -Target $step)
        }

        [PSCustomObject]@{
            Step     = $step
            State    = $state
            Status   = $after.Status
            Worktree = $after.Worktree
        }
    }

    # --- Clean up, from the main clone ---

    Set-Location -LiteralPath $mainClone
    $null = Invoke-Native -Name git -Operation "Closing $branch" -Narrate -ArgumentList 'close-branch', $branch
    $null = Invoke-Native -Name git -Operation 'Confirming the main clone is current' -Narrate -ArgumentList 'pull',
        '--ff-only', 'origin', '<default-branch>'

    # The commit that landed carries both trailers (rule 2), or the script says so and fails.
    $landed = (Invoke-Native -Name git -Operation 'Reading the commit that landed' -ArgumentList 'log', '--max-count=1',
            '--format=%B').Output

    if ($landed -notmatch '(?m)^Signed-off-by: ' -or $landed -notmatch '(?m)^Assisted-by: ') {
        $message = 'The squash commit lacks Signed-off-by or Assisted-by.'
        throw (ConvertTo-Refusal -Message $message -Id 'TrailersMissing' -Category InvalidResult -Target $sha)
    }

    $null = Invoke-Native -Name git -Operation 'Reading the clone status' -Narrate -ArgumentList 'status', '--short'

    [PSCustomObject]@{
        PullRequest = $number
        Link        = $pullRequest
        Commit      = $sha
        Merged      = $day
    }
}
catch {
    $caught = $_
    $ErrorActionPreference = $callerErrorAction
    $PSCmdlet.WriteError($caught)
    exit 1
}
finally {
    Remove-Item -LiteralPath $bodyFile, $squashFile -ErrorAction Ignore
    Pop-Location
}
```

<a id="a-worktrees-first-script-in-powershell"></a>

### 5.1. A worktree's first script, in PowerShell

The same steps as [the bash form's](#a-worktrees-first-script), in a script of its own. Its preamble and helpers region are the merge script's above, less `$mainClone`, which only the merge script's clean-up uses, and less the two files only the merge script makes. Its help says what it does:

```powershell
<#
.SYNOPSIS
    First script for <owner>/<repo>, issue #<n>.

.DESCRIPTION
    Commits <branch>'s plan and pushes the branch,
    then sets each step's row In progress, its Worktree linking the branch, and links the plans in the Plan and design
    documents section of every issue they serve. What it is doing goes to the verbose stream: run it with -Verbose to
    see it.

.OUTPUTS
    PSCustomObject: each step's row, In progress; then each issue star github plan link wrote, with what it did.

.EXAMPLE
    & 'C:/Users/<you>/Workspace/<org>/<clone>.<n>-<name>.ps1' -Verbose
#>
```

Its main operation commits the plan, pushes the branch, and then, after the push, records the steps and links the plans. `star github plan link` refuses nothing by its exit: an issue refused, or a row the section drops, is in its records and exits 0, and any other exit stops the script (#557).

```powershell
###########
# Main
###########

try {
    Push-Location -LiteralPath $worktree

    # --- The plan, committed, and the branch pushed ---

    $null = Invoke-Native -Name git -Operation 'Staging the plan' -ArgumentList 'add', '--',
        'docs/plans/<type>/<issue>-<name>.md'
    $null = Invoke-Native -Name git -Operation 'Committing the plan' -Narrate -ArgumentList 'commit', '--message',
        'docs(plans): the plan for #<issue>'
    $null = Invoke-Native -Name git -Operation "Pushing $branch" -Narrate -ArgumentList 'push', '-u', 'origin', $branch

    # --- The steps: each one's row In progress, its Worktree linking the branch (rule 13; agent-rules.md, rule 19) ---
    #
    # After the push, since a link to a branch GitHub doesn't have leads nowhere. Guarded on what each row holds (ruled
    # 2026-11-13): on a schedule, Open or In progress, and linking no other branch; otherwise another worktree holds the
    # step, and the script stops, naming it. Each row is read back.

    $steps = @(<issue>)
    $link = "https://github.com/$repository/tree/<branch>"

    foreach ($step in $steps) {
        $row = Get-StepRow -Issue $step

        if (-not $row) {
            $message = "#$step has no row on $scheduleProject."
            throw (ConvertTo-Refusal -Message $message -Id 'StepHasNoRow' -Category ObjectNotFound -Target $step)
        }

        if (-not $row.Schedule) {
            $message = "#$step's row on $scheduleProject names no schedule."
            throw (ConvertTo-Refusal -Message $message -Id 'StepOnNoSchedule' -Target $step)
        }

        if ($row.Status -notin @('Open', 'In progress')) {
            $message = "#$step's row is $($row.Status), not Open or In progress."
            throw (ConvertTo-Refusal -Message $message -Id 'StepNotOpen' -Target $step)
        }

        if ($row.Worktree -and $row.Worktree -ne $link) {
            $message = "#$step's row links $($row.Worktree): another worktree holds the step."
            throw (ConvertTo-Refusal -Message $message -Id 'StepHeldElsewhere' -Category ResourceBusy -Target $step)
        }

        Set-StepRow -Row $row -Status 'In progress' -Link $link
        $after = Get-StepRow -Issue $step

        if ($after.Status -ne 'In progress' -or $after.Worktree -ne $link) {
            $message = "#$step's row reads $($after.Status), $($after.Worktree)."
            throw (ConvertTo-Refusal -Message $message -Id 'StepNotRecorded' -Category InvalidResult -Target $step)
        }

        [PSCustomObject]@{
            Step     = $step
            Schedule = $after.Schedule
            Status   = $after.Status
            Worktree = $after.Worktree
        }
    }

    # --- The plans: each issue they serve links them in its Plan and design documents section (rule 13; #557) ---
    #
    # After the push, beside the steps' rows. Each plan is named by its path relative to docs/plans, and read from this
    # worktree, since it has not merged; the plans on the default branches of writ's layers that serve the same issues
    # are read with it.

    $plans = @('<type>/<issue>-<name>.md')
    $arguments = @('github', 'plan', 'link') + $plans + @('--silent', '--jq', 'map({issue, action, reason, dropped})')
    $linked = Invoke-Native -Name star -Operation 'Linking the plans in their issues' -ArgumentList $arguments
    ConvertFrom-Json -InputObject $linked.Output
}
catch {
    $caught = $_
    $ErrorActionPreference = $callerErrorAction
    $PSCmdlet.WriteError($caught)
    exit 1
}
finally {
    Pop-Location
}
```
