---
title: "PR scripts"
description: "Owner-run Bash and PowerShell script mechanics, from preparation through verified delivery"
type: Process
audience: Engineers, agents
status: Draft
created: 2026-03-16
updated: 2026-11-23
---

<a id="pr-script-template"></a>

# PR scripts

[Up: Engineering documentation](../index.md)

Generate one self-contained script beside the worktree it serves: /Users/<user>/Workspace/<org>/<clone>.<issue>-<name>.bash on macOS/Linux or the corresponding .ps1 path on Windows. Read an existing script and verify its worktree before replacing it. Follow the [PR procedure](../engineering/procedures/pull-request.md) for authority, review, merge, disclosure and completion.

The script has two parts. Before merge it stages named files, commits, integrates the target, pushes, opens/updates the PR, verifies the published head and stops for Owner review and merge in GitHub. When the Owner runs it after merge, it verifies actual delivery, records time and issue progress, then cleans up. It never merges or prints a merge command. Plan approval does not authorize an agent to execute it.

Show the prepared script and give the Owner one command to run it. Bash scripts are not written for Windows. PowerShell handoff includes -Verbose. The [effective entrypoint overrides](../engineering/index.md#temporary-live-entrypoint-overrides) still govern the session's execution limits.

<a id="the-pre-flight-command-is-discovered-not-remembered"></a>

<a id="1-the-pre-flight-command-is-discovered-not-remembered"></a>

## 1. Discover the repository gate

Read the repository's current CI workflows. Use the build-tool target and flags CI invokes; when a workflow uses an Action, run its wrapped CLI with the corresponding arguments. Do not copy a target from another repository or maintain a partial substitute for the gate.

Verify locally built organization tools before putting their commands in the script or handoff. Follow [tool verification](../engineering/agent-operation.md#all-agents-tools-and-status), including build provenance, required interfaces and protection of another worker's installed build. Installation or upgrade requires its own authority.

<a id="a-worktrees-first-script"></a>

<a id="2-a-worktrees-first-script"></a>

## 2. Publish the plan

The first script opens the issue-bound branch/worktree, commits the plan and pushes it. Only after the push, mark its issues In progress and link their Schedule rows' Worktree fields to the branch. Resolve projects, rows, fields and options by name; guard existing ownership rather than replace another worker's link.

Run star github plan link for each plan, using its path relative to docs/plans. It updates each served issue's Plan and design documents section from the plans serving that issue. A nonzero exit stops the script. Also inspect returned records: refused issues and dropped table rows can accompany exit zero and must be shown to the Owner.

The Bash example supplies the guarded row update:

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


<a id="template"></a>

<a id="3-template"></a>

## 3. Bash delivery template

Adapt the placeholders, explicit files, repository gate, issue completion list and permitted operations to the approved plan. The two-part script stops before Owner review/merge, then records an observed merge on the next Owner-run invocation.

```bash
#!/usr/bin/env bash
set -euo pipefail

cd ~/Workspace/<org>/<clone>.<issue>-<name>

repository='<owner>/<repo>'
assisting_agent='<submitting agent>'
# The steps this pull request completes, each named with a closing keyword, which closes it at the merge (ruled
# 2026-11-19); one that fails its deployment or verification afterwards is reopened with star github issue reopen.
# A step the pull request only advances is left out, and stays open.
close_steps=()

# The owner merges in GitHub (ruled 2026-11-19), and this script never merges (#605). It runs in two parts. Until
# the pull request is merged, it commits, pushes, opens the pull request, and stops when it passes its checks and is
# ready to merge. Run again after the owner merges, it finds the pull request merged and records the merge: its time,
# each step's record, the cleanup, and the trailers of the commit that landed.
if [[ "$(gh pr view <branch> --json state --jq .state 2>/dev/null || true)" != MERGED ]]; then
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

    # Commit what is staged. A run again after a stop, its commit made, has nothing staged, and makes none.
    git diff --cached --quiet || git commit -m "$(
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
    # configuration, never typed. The repository squash-merges with the pull request's title and description (#605),
    # so the trailers land in the commit on the target.
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

    # Create PR, unless a run before this one opened it
    if [[ "$(gh pr view <branch> --json state --jq .state 2>/dev/null || true)" != OPEN ]]; then
        gh pr create \
            --title "<type>(<scope>): <summary>" \
            --body "${description}"
    fi

    # --- CI and merge gates ---
    pr_number=$(gh pr view --json number --jq '.number')
    qualified_head=$(gh pr view "${pr_number}" --json headRefOid --jq '.headRefOid')

    # within runs a command for what is left until deadline, in seconds since the script started, and prints what it
    # wrote: it runs in the background, its output to a file rather than a pipe, so that a command stopped holds nothing
    # open, and at the deadline it is sent SIGTERM, then SIGKILL two seconds later, since macOS has no timeout command
    # and gh, a Go program, ignores SIGALRM. It returns the command's status, or 142 when it was stopped or no time was
    # left (#629). Plain Bash, from 3.2, macOS's own.
    within() {
        local out pid read_status=0
        ((SECONDS < deadline)) || return 142
        out="$(mktemp)"
        "$@" >"${out}" &
        pid=$!
        while kill -0 "${pid}" 2>/dev/null && ((SECONDS < deadline)); do
            sleep 0.2
        done
        if kill -0 "${pid}" 2>/dev/null; then
            kill -TERM "${pid}" 2>/dev/null || true
            for _ in 1 2 3 4 5 6 7 8 9 10; do
                kill -0 "${pid}" 2>/dev/null || break
                sleep 0.2
            done
            kill -KILL "${pid}" 2>/dev/null || true
            wait "${pid}" 2>/dev/null || true
            rm -f -- "${out}"
            return 142
        fi
        wait "${pid}" 2>/dev/null || read_status=$?
        cat -- "${out}"
        rm -f -- "${out}"
        return "${read_status}"
    }

    # GitHub registers a pull request's checks a moment after it opens, and gh pr checks fails while it reports none
    # (PR #610's first run), so the script waits up to five minutes for the first, no read or wait outlasting them.
    deadline=$((SECONDS + 300))
    while ((SECONDS < deadline)); do
        reported="$(within gh pr checks "${pr_number}" --json name --jq length 2>/dev/null || true)"
        [[ "${reported:-0}" == 0 ]] || break
        nap=$((deadline - SECONDS))
        ((nap < 10)) || nap=10
        ((nap <= 0)) || sleep "${nap}"
    done

    # The default requires observed passing checks. A proven no-CI repository
    # needs its reviewed policy reflected here; empty output never proves it.
    # A run that starts after the pull request opens, as its own after its branch's push, is pending when the first
    # run's checks pass, and gh pr checks --watch waits only for the checks it sees when it starts, with no limit of
    # its own; so the script reads the checks every 30 seconds while any is pending, for 30 minutes at most, no read or
    # wait outlasting them. It judges the last read alone, and prints the table from it (#629).
    deadline=$((SECONDS + 1800))
    checks='[]'
    pending=1
    said=0
    while ((SECONDS < deadline)); do
        read_status=0
        latest=$(within gh pr checks "${pr_number}" --json name,bucket) || read_status=$?
        ((read_status != 142)) || break
        ((read_status == 0)) || {
            echo "Reading #${pr_number}'s checks failed: gh exited ${read_status}." >&2
            exit 1
        }
        checks=${latest}
        pending=$(jq '[.[] | select(.bucket == "pending")] | length' <<<"${checks}")
        ((pending > 0)) || break
        ((pending == said)) || echo "Checks still running on #${pr_number}: ${pending}."
        said=${pending}
        nap=$((deadline - SECONDS))
        ((nap < 30)) || nap=30
        ((nap <= 0)) || sleep "${nap}"
    done
    jq -r '.[] | "\(.name)\t\(.bucket)"' <<<"${checks}"
    ((pending == 0)) || {
        echo "#${pr_number}'s checks are still running after 30 minutes. Run this script again once they finish." >&2
        exit 1
    }
    jq -e 'length > 0 and all(.[]; .bucket == "pass")' <<<"${checks}" >/dev/null || {
        echo 'The observed checks are not all passing. Inspect the current head and CI policy.' >&2
        exit 1
    }

    # Ready for the owner: open at the head CI passed, in no conflict, and blocked by nothing, or by nothing but the
    # owner's own review, which the owner gives in GitHub before merging (PR #610's second run).
    gate=$(gh pr view "${pr_number}" --json state,headRefOid,mergeable,mergeStateStatus,reviewDecision)
    jq -e --arg head "${qualified_head}" '
        .state == "OPEN" and .headRefOid == $head and .mergeable == "MERGEABLE" and
        ((.mergeStateStatus == "CLEAN" and (.reviewDecision | IN(null, "", "APPROVED")))
            or (.mergeStateStatus == "BLOCKED" and .reviewDecision == "REVIEW_REQUIRED"))
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

    echo "== #${pr_number} is ready: review and merge it in GitHub, then run this script again to record the merge."
    exit 0
fi

# --- Part two: after the owner's merge in GitHub, the records (#605) ---
#
# The repository squash-merges with the pull request's title and description, `star github model apply` having set it,
# so the commit that landed ends with the description's two trailers, which the end of this script checks (rule 2).
# Deletion belongs to git close-branch below, which deletes the remote first so a failure leaves both halves intact.
# The span step writes the body through a file; the one trap removes it.
pr_number=$(gh pr view <branch> --json number --jq .number)
message_file=$(mktemp)
trap 'rm "${message_file}"' EXIT

# A merge queue may defer delivery. Record no merge or closure until GitHub
# confirms that the merge actually happened.
delivery=$(gh pr view "${pr_number}" --json state,mergedAt,mergeCommit)
jq -e '.state == "MERGED" and .mergedAt != null and .mergeCommit.oid != null' <<<"${delivery}" >/dev/null || {
    echo 'The PR is not yet merged. Preserve this state and inspect its queue or delivery status.' >&2
    exit 1
}
merge_commit=$(jq -r '.mergeCommit.oid' <<<"${delivery}")

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
# step has moved to another worktree, and the script stops. Every step gets the merge record as a comment, once.
# A step in close_steps is closed by the pull request's closing keyword at the merge, so GitHub records the pull request
# as what closed it, which star github schedule close lists and the Linked pull requests column shows; the merge record
# is its evidence, and the script sets its row Closed, closing the issue itself only if GitHub has not yet. Every other
# step stays open, its row In progress. Each record is read back. A step that moves to another worktree, or closes
# without a merge, is recorded by this script before git close-branch, its row linking where the work went. Leave the
# step out only when the pull request lands no step.
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
    gh api "repos/${repository}/issues/${step}/comments" --paginate --jq '.[].body' | grep -qxF -- "${record}" ||
        gh issue comment "${step}" --repo "${repository}" --body "${record}" >/dev/null
    state="$(gh issue view "${step}" --repo "${repository}" --json state --jq .state)"
    expected_state=OPEN
    expected_status='In progress'
    if [[ "${close_allowed}" == true ]]; then
        # The closing keyword closed it at the merge; GitHub may take a moment, so it is closed here only if still open.
        [[ "${state}" == CLOSED ]] || gh issue close "${step}" --repo "${repository}" --reason completed >/dev/null
        expected_state=CLOSED
        expected_status=Closed
    elif [[ "${state}" != OPEN ]]; then
        echo "#${step} is already closed; inspect its completion disposition before changing its row." >&2
        exit 1
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
landed=$(git log --max-count=1 --format=%B "${merge_commit}" --)

if ! grep --quiet '^Signed-off-by: ' <<<"${landed}" || ! grep --quiet '^Assisted-by: ' <<<"${landed}"; then
    echo "the squash commit ${merge_commit} lacks Signed-off-by or Assisted-by"
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


<a id="rules"></a>

<a id="4-rules"></a>

## 4. Script requirements

The rule numbers are stable references used by the examples.

1. **Stage named files.** Never use `git add -A` or `git add .`.
2. **Disclose assistance.** Follow the [PR disclosure requirements](../engineering/procedures/pull-request.md#review-boundary). Use the account's maintained PR-body template. End the pre-merge description with human Signed-off-by and Assisted-by naming the submitting agent. The repository squash message uses that title/description, and the second script part verifies the landed trailers against this PR's recorded full mergeCommit.oid. A later commit on the target cannot stand in for that commit; an unreadable recorded commit stops verification. Branch commits have no trailers. Do not add AI co-authorship or promotional footers. Append Time after merge.
3. **Preserve literal messages.** Use single-quoted heredocs for Bash commit messages and PR bodies; provide multiline bodies through files. Do not let shell interpolation change the text.
4. **Verify CI on the published head.** Observe passing required checks for the qualified full head ID. An empty list is not evidence of unconfigured CI. A verified no-check policy or approved conditional result must be recorded in the plan and represented explicitly in the gate. Preserve every required check; stop when evidence is incomplete.
5. **Check readiness, then stop.** Inspect the head, merge state, review decision and all review conversations. A PR waiting solely for the Owner's review can be ready for that review. Stop for the Owner to review and merge in GitHub. A queued merge is outstanding; verify actual merged state before delivery records. Administrative bypass needs a separate explicit Owner grant.
6. **Use git close-branch for cleanup.** It handles worktrees and regular branches, removes the worktree and sibling script, and synchronizes the canonical clone to the target. Move to the canonical clone before invoking it; the worktree's directory will disappear. Exit 75 means clone synchronization failed. Cleanup and canonical-clone maintenance require the applicable authority.
7. **Respect the worktree boundary.** One active PR belongs to a worktree; its integration changes are review/CI corrections for that PR. Apply the [process](../engineering/process.md#pull-request-and-integration) and any effective session override. Another worker's PR does not serialize this session's work.
8. **Keep merge with the Owner.** The first part never merges or prints a merge command. After the Owner merges in GitHub, the second records delivery. Cleanup deletes the remote branch, worktree, local branch and script in that order, then synchronizes the canonical clone.
9. **Provide a report when asked.** Print the requested all-state Epic, Feature or Schedule report as a table after cleanup. Scope it to the work served. Reporting is not an automatic final step.
10. **Leave no tracked changes unstaged.** After named staging, git diff --quiet must pass. Stop when another modified tracked file would be silently omitted.
11. **Record time from GitHub.** After merge, append and read back a Time section in the PR body. Record opened (the branch's first commit), submitted (PR creation), merged and elapsed hours to one decimal. These measure time the work was open, including review gaps and nights, rather than effort. Label an agent's active-time estimate as an estimate in its final message; do not put it in the PR as fact.
12. **Integrate before publication and confirm delivery.** Merge the target into the working branch with git pull --no-rebase before pushing; never rebase. After cleanup synchronizes the canonical clone, git pull --ff-only confirms that synchronization. Do not fetch directly into a checked-out target ref. Expose canonical-clone maintenance for separate approval.
13. **Record progress as it happens.** Push before publishing branch links, then link plans. After observed merge, record the PR and squash commit on each served issue, and link its row to the PR. Closing keywords name only issues this PR completes; GitHub closes them at merge and their rows become Closed. Partial work remains Open/In progress. Reopen an issue with star github issue reopen if deployment or verification subsequently fails. Resolve rows/fields by name, guard ownership, avoid duplicate writes and read records back. Inspect plan-link refusals/dropped rows even at exit zero. Preserve outstanding evidence and obligations outside the worktree before cleanup.

The published PR, observed merge and post-merge verification establish different milestones. Keep unresolved deployment, verification and completion-review work visible rather than treating cleanup as acceptance.

<a id="on-windows-powershell"></a>

<a id="5-on-windows-powershell"></a>

## 5. PowerShell delivery template

Use PowerShell 7 and the [PowerShell style guide](powershell-style-guidelines.md): shebang, header/help, Requires, CmdletBinding/param, saved caller error action, Stop preference, constants, helper region and a main try/catch/finally. Preserve the Bash operation order and the requirements above.

1. **Wrap native programs.** Run git, gh and star through Invoke-Native using .NET Process, distinct arguments and UTF-8 output. Send native stderr to the verbose stream; refuse a nonzero exit unless explicitly allowed. ErrorActionPreference alone does not check native exit codes. Keep ArgumentList last for readable wrapping.
2. **Return structured errors.** Save the caller's error action and set Stop. Catch restores the caller setting, calls $PSCmdlet.WriteError and exits 1. Finally removes run-created temporary files and restores the caller's directory. Create ErrorRecords with ConvertTo-Refusal; do not throw strings or use ThrowTerminatingError.
3. **Separate progress and results.** Use Write-Verbose for activity and objects for issue records and observed PR delivery. Write neither to the host nor the information stream; set no preference other than ErrorActionPreference.
4. **Keep bodies literal.** Use single-quoted here-strings for PR text and jq programs. Pass the body through --body-file.
5. **Patch Time through a file.** Use gh api PATCH with body=@<file> and UTF-8 content. Preserve actual GitHub timestamps and the exact intended body.
6. **Leave the worktree before cleanup.** Set-Location to the canonical clone before git close-branch; Windows cannot remove a process's current directory. PowerShell has parsed the script before its deletion. Confirm the clone synchronization with git pull --ff-only.
7. **Fix the launch environment outside the script.** Do not change PATH. Launch pwsh with Git for Windows' Git/cmd/git.exe launcher available; it supplies the shell environment Git children need. A pwsh launched through Git Bash can resolve raw Git/clangarm64/bin/git.exe and fail with exit 128. Correct that environment rather than hide it in the script.
8. **Hand over an absolute command with -Verbose.** Use & 'C:/Users/<user>/Workspace/<org>/<clone>.<issue>-<name>.ps1' -Verbose. A host requiring a shell-command prefix adds that prefix separately.

```powershell
#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    PR script for <owner>/<repo>, issue #<n>.

.DESCRIPTION
    Opens the pull request for <branch>, waits for CI and checks the merge state, then stops: the owner merges in
    GitHub, and the script never merges (#605). Run again after the merge, it records the pull request's time span and
    the steps it lands, and closes the branch. Every commit is made and pushed; there is nothing to stage. What it is
    doing goes to the verbose stream: run it with -Verbose to see it.

.OUTPUTS
    PSCustomObject: before the merge, the pull request ready to merge, its number and link. After it, each step's
    recorded issue state and row status; then the pull request merged, its number, link and squash commit.

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
# The steps this pull request completes, each closed by its closing keyword at the merge (ruled 2026-11-19).
$closeSteps = @()
$worktree = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>',
    '<clone>.<n>-<name>'
$mainClone = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>', '<clone>'
$scheduleProject = 'Schedule: <team>'

# The pull request's body and squash message go to gh through files, made and removed within the run.
$bodyFile = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath 'pr-<n>-body.md'

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
# David-Noble-at-work's since #441 (rule 2). The repository squash-merges with the title and description (#605), so the
# trailers land on the target; the Time section is appended after the merge.
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
    "$description`n`n$trailers"
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

# Invoke-Native runs a native program, its output read as UTF-8, and gets what it wrote and how it exited. The program
# runs through .NET's Process, each argument passed as one and its standard input closed, so that text beyond ASCII
# survives a Windows console's code page (the style guide's section 7, Native programs). What it writes to standard
# error, and to standard output with Narrate, goes to the verbose stream. A non-zero exit is a refusal naming the
# operation, unless AllowFailure lets the caller read it. Given a Deadline, it waits for the program only until then,
# and then stops it and its children and refuses with DeadlinePassed (#629).
#
# Parameters:
#   - `Name`: The program, as the PATH finds it: git, gh or star.
#   - `Operation`: What the call does, said on the verbose stream and in a refusal.
#   - `AllowFailure`: Gets a non-zero exit, in place of refusing it.
#   - `Narrate`: Says what the program writes to standard output on the verbose stream too.
#   - `Deadline`: When the program must have finished; unset, it may take as long as it takes.
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

        [Nullable[DateTime]]
        $Deadline = $null,

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
    $outputRead = $process.StandardOutput.ReadToEndAsync()
    $errorRead = $process.StandardError.ReadToEndAsync()

    if ($null -ne $Deadline) {
        $left = [Math]::Max(0, [Math]::Ceiling(($Deadline - (Get-Date)).TotalMilliseconds))

        if (-not $process.WaitForExit([Int32]$left)) {
            $process.Kill($true)
            $process.WaitForExit()
            $message = "$Operation ran out of time: $Name was stopped at its deadline."
            throw (ConvertTo-Refusal -Message $message -Id 'DeadlinePassed' -Category OperationTimeout -Target $Name)
        }
    }

    $process.WaitForExit()
    $output = $outputRead.GetAwaiter().GetResult()
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

    # --- Part one: the owner merges in GitHub, and this script never does (#605, ruled 2026-11-19) ---
    #
    # Until the pull request is merged, the script pushes, opens it, and stops when it passes its checks and is ready
    # to merge. Run again after the owner merges, it finds the pull request merged and records the merge.
    $state = Invoke-Native -Name gh -Operation "Reading $branch's pull request state" -AllowFailure -ArgumentList 'pr',
        'view', $branch, '--json', 'state', '--jq', '.state'

    if ($state.ExitCode -ne 0 -or $state.Output.Trim() -ne 'MERGED') {
        # --- Pre-flight: nothing left behind, then the target merged in and the branch pushed ---

        $unstaged = Invoke-Native -Name git -Operation 'Finding unstaged changes' -AllowFailure -ArgumentList 'diff',
            '--quiet'
        $staged = Invoke-Native -Name git -Operation 'Finding staged changes' -AllowFailure -ArgumentList 'diff',
            '--cached', '--quiet'

        if ($unstaged.ExitCode -ne 0 -or $staged.ExitCode -ne 0) {
            $status = Invoke-Native -Name git -Operation 'Reading the worktree status' -ArgumentList 'status', '--short'
            $message = "The worktree is not clean; nothing should be left behind:`n$($status.Output)"
            throw (ConvertTo-Refusal -Message $message -Id 'WorktreeNotClean' -Target $worktree)
        }

        $null = Invoke-Native -Name git -Operation 'Merging in <default-branch>' -Narrate -ArgumentList 'pull',
            '--no-rebase', '--no-edit', 'origin', '<default-branch>'
        $null = Invoke-Native -Name git -Operation "Pushing $branch" -Narrate -ArgumentList 'push', '-u', 'origin',
            $branch

        # --- Create the PR, unless a run before this one opened it ---

        $open = Invoke-Native -Name gh -Operation "Finding $branch's pull request" -AllowFailure -ArgumentList 'pr',
            'view', $branch, '--json', 'state', '--jq', '.state'

        if ($open.ExitCode -ne 0 -or $open.Output.Trim() -ne 'OPEN') {
            Set-Content -LiteralPath $bodyFile -Value (Get-PullRequestBody) -NoNewline
            $null = Invoke-Native -Name gh -Operation 'Opening the pull request' -Narrate -ArgumentList 'pr', 'create',
                '--base', '<default-branch>', '--head', $branch, '--body-file', $bodyFile,
                '--title', '<type>(<scope>): <summary>'
        }
        $opened = Invoke-Native -Name gh -Operation "Reading $branch's pull request" -ArgumentList 'pr', 'view',
            $branch, '--json', 'number', '--jq', '.number'
        $number = [Int32]$opened.Output.Trim()

        # --- CI and merge gates ---

        $qualifiedHead = (Invoke-Native -Name gh -Operation "Reading #$number's qualified head" -ArgumentList 'pr',
                'view', $number, '--json', 'headRefOid', '--jq', '.headRefOid').Output.Trim()

        # GitHub registers a pull request's checks a moment after it opens, and gh pr checks fails while it reports
        # none (PR #610's first run), so the script waits up to five minutes for the first, no read or wait outlasting
        # them.
        $deadline = (Get-Date).AddMinutes(5)

        while ((Get-Date) -lt $deadline) {
            try {
                $reported = Invoke-Native -Name gh -Operation "Finding #$number's checks" -AllowFailure `
                    -Deadline $deadline -ArgumentList 'pr', 'checks', $number, '--json', 'name', '--jq', 'length'
            }
            catch {
                if ($_.FullyQualifiedErrorId -ne 'DeadlinePassed') {
                    throw
                }

                break
            }

            if ($reported.Output.Trim() -notin @('', '0')) {
                break
            }

            Write-Verbose -Message "#$number reports no checks yet."
            $nap = [Math]::Min(10, [Math]::Max(0, [Int32][Math]::Ceiling(($deadline - (Get-Date)).TotalSeconds)))

            if ($nap -gt 0) {
                Start-Sleep -Seconds $nap
            }
        }

        # A run that starts after the pull request opens, as its own after its branch's push, is pending when the
        # first run's checks pass, and gh pr checks --watch waits only for the checks it sees when it starts, with no
        # limit of its own; so the script reads the checks every 30 seconds while any is pending, for 30 minutes at
        # most, no read or wait outlasting them. It judges the last read alone, and shows the table from it (#629).
        $deadline = (Get-Date).AddMinutes(30)
        $checks = @()
        $pending = 1
        $said = 0

        while ((Get-Date) -lt $deadline) {
            try {
                $answer = Invoke-Native -Name gh -Operation "Reading #$number's checks" -Deadline $deadline `
                    -ArgumentList 'pr', 'checks', $number, '--json', 'name,bucket'
            }
            catch {
                if ($_.FullyQualifiedErrorId -ne 'DeadlinePassed') {
                    throw
                }

                break
            }

            $checks = @(ConvertFrom-Json -InputObject $answer.Output)
            $pending = @($checks | Where-Object { $_.bucket -eq 'pending' }).Count

            if ($pending -eq 0) {
                break
            }

            if ($pending -ne $said) {
                Write-Verbose -Message "Checks still running on #${number}: $pending."
                $said = $pending
            }

            $nap = [Math]::Min(30, [Math]::Max(0, [Int32][Math]::Ceiling(($deadline - (Get-Date)).TotalSeconds)))

            if ($nap -gt 0) {
                Start-Sleep -Seconds $nap
            }
        }

        foreach ($check in $checks) {
            Write-Verbose -Message "  $($check.name): $($check.bucket)"
        }

        if ($pending -ne 0) {
            $message = "#$number's checks are still running after 30 minutes; run this again once they finish."
            $refusal = @{ Id = 'ChecksStillRunning'; Category = 'OperationTimeout'; Target = $number }
            throw (ConvertTo-Refusal -Message $message @refusal)
        }

        if ($checks.Count -eq 0 -or @($checks | Where-Object { $_.bucket -ne 'pass' }).Count -ne 0) {
            $message = "#$number's observed checks are not all passing; inspect the head and CI policy."
            $refusal = @{ Id = 'ChecksNotEstablished'; Category = 'InvalidResult'; Target = $number }
            throw (ConvertTo-Refusal -Message $message @refusal)
        }

        $answer = Invoke-Native -Name gh -Operation "Reading #$number's merge readiness" -ArgumentList 'pr', 'view',
            $number, '--json', 'state,headRefOid,mergeable,mergeStateStatus,reviewDecision'
        $gate = ConvertFrom-Json -InputObject $answer.Output
        $headReady = $gate.state -eq 'OPEN' -and $gate.headRefOid -eq $qualifiedHead
        $headReady = $headReady -and $gate.mergeable -eq 'MERGEABLE'
        $clean = $gate.mergeStateStatus -eq 'CLEAN' -and $gate.reviewDecision -in @($null, '', 'APPROVED')
        # Blocked by nothing but the owner's review, which the owner gives in GitHub before merging (PR #610's second
        # run).
        $awaitingOwner = $gate.mergeStateStatus -eq 'BLOCKED' -and $gate.reviewDecision -eq 'REVIEW_REQUIRED'

        if (-not $headReady -or -not ($clean -or $awaitingOwner)) {
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
            $refusal = @{ Id = 'ThreadsNotEstablished'; Category = 'InvalidResult'; Target = $number }
            throw (ConvertTo-Refusal -Message $message @refusal)
        }

        $link = (Invoke-Native -Name gh -Operation "Reading #$number's link" -ArgumentList 'pr', 'view', $number,
                '--json', 'url', '--jq', '.url').Output.Trim()
        Write-Verbose -Message "#$number is ready: review and merge it in GitHub, then run this again to record it."

        [PSCustomObject]@{
            PullRequest = $number
            Link        = $link
            State       = 'Ready to merge'
        }
        return
    }

    # --- Part two: after the owner's merge in GitHub, the records (#605) ---
    #
    # The repository squash-merges with the pull request's title and description, `star github model apply` having set
    # it, so the commit that landed ends with the description's two trailers, which the clean-up below checks (rule 2).

    $opened = Invoke-Native -Name gh -Operation "Reading $branch's pull request" -ArgumentList 'pr', 'view', $branch,
        '--json', 'number', '--jq', '.number'
    $number = [Int32]$opened.Output.Trim()

    $answer = Invoke-Native -Name gh -Operation "Confirming #$number merged" -ArgumentList 'pr', 'view', $number,
        '--json', 'state,mergedAt,mergeCommit'
    $delivery = ConvertFrom-Json -InputObject $answer.Output

    if ($delivery.state -ne 'MERGED' -or -not $delivery.mergedAt -or -not $delivery.mergeCommit.oid) {
        $message = "#$number is not yet merged; inspect its queue or delivery status before recording completion."
        throw (ConvertTo-Refusal -Message $message -Id 'MergeOutstanding' -Category InvalidResult -Target $number)
    }
    $mergeCommit = [String]$delivery.mergeCommit.oid

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
    # step has moved to another worktree, and the script stops. The merge comment is posted once. A step in closeSteps
    # is closed by the pull request's closing keyword at the merge, and here only if GitHub has not yet, its row set
    # Closed; a step the pull request only advances stays open.
    # Each record is read back. A step that moves to another worktree, or closes without a merge, is recorded by this
    # script before git close-branch, its row linking where the work went. Left out only when the pull request lands
    # no step.

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
            '--format=%B', $mergeCommit, '--').Output

    if ($landed -notmatch '(?m)^Signed-off-by: ' -or $landed -notmatch '(?m)^Assisted-by: ') {
        $message = "The squash commit $mergeCommit lacks Signed-off-by or Assisted-by."
        throw (ConvertTo-Refusal -Message $message -Id 'TrailersMissing' -Category InvalidResult -Target $mergeCommit)
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
    Remove-Item -LiteralPath $bodyFile -ErrorAction Ignore
    Pop-Location
}
```


<a id="a-worktrees-first-script-in-powershell"></a>

<a id="51-a-worktrees-first-script-in-powershell"></a>

### 5.1. Publish the plan with PowerShell

Use the delivery example's preamble/helpers, omitting the cleanup-only mainClone and its two delivery-only temporary files. Replace the help with:

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


Replace the main operation with the following. It commits and pushes the plan, records the rows, and links the plans. Inspect refusal and dropped-row records even if plan link exits zero; any nonzero exit stops the run.

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
