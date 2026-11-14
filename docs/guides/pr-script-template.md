---
title: PR Script Template
description: The PR script Claude Code writes, in bash on Unix and PowerShell on Windows, from staging to cleanup
type: Process
audience: Engineers, Claude Code
status: Approved
created: 2026-03-16
updated: 2026-11-04
---

# PR Script Template

Standard structure for the PR script that Claude Code generates, named for the worktree it serves and placed beside
it: `~/Workspace/<org>/<worktree>.bash` on macOS and Linux and `<worktree>.ps1` on Windows, where `<worktree>` is
the directory `git-open-branch` made, `<clone>.<issue>-<name>`. The script for
`~/Workspace/NobleFactor/devlore-cli.1119-broker-specification` is
`~/Workspace/NobleFactor/devlore-cli.1119-broker-specification.bash`; `ls ~/Workspace/NobleFactor` shows which
worktree each script lands; and `git close-branch` removes the two together when the pull request merges. Ruled
2026-10-21 (#366), retiring `go-<repo>` one level above the repository: a script named for the clone outlived every
worktree it served, and the bare `go` belonged to whichever repository last used it. Each script is self-contained:
stage, commit, push, create PR, verify CI, verify mergeability, squash merge, record its time and its steps, clean up.

A script is read before it is overwritten, whatever it is called: its `cd` says which worktree it serves, and one
whose `cd` names another worktree is the wrong file. Only a script that is not there is written from nothing.

On macOS and Linux the script is bash, [the template below](#template). On Windows it is PowerShell,
`<worktree>.ps1`, [its own form](#on-windows-powershell). Bash PR scripts are not written on Windows (ruled
2026-09-21). The owner runs the script: the agent writes it, shows it, and hands over one command.

---

## The pre-flight command is discovered, not remembered

The example below shows `.github/scripts/shell-lint.sh`, which is what the `personal` repository's
workflow invokes. **Do not copy it.** Read `.github/workflows/*` in the repository you are working
in and use what it actually runs:

| Repository | CI entry point |
| --- | --- |
| `personal` | `.github/scripts/shell-lint.sh`, with `DECLARE_BASHSCRIPT_DIR` naming a directory that holds `Declare-BashScript` (a deployed `~/.local/bin` locally; CI checks out `noblefactor-engprod`) |
| `devlore-cli` | `make vet-all`, `make lint-all`, `./build/star lint go ./...` |
| `noblefactor-engprod` | `make check`: every gate, then the tests under `tests/`, which is what `ci.yaml` runs since #268 |

Where a repository routes through a build tool, call the target rather than the underlying binary:
the target is what CI runs and it carries the flags. Where CI uses a GitHub Action rather than a
command — `codespell-project/actions-codespell`, say — run the CLI it wraps with the same
arguments the workflow passes it.

Read the workflow each time rather than trusting this table. It went stale during the change that
introduced it: `noblefactor-engprod` dropped its Go trees and re-based its gate on documents while this
edit was in the working tree, turning a `go build` pre-flight into a command with nothing to
build.

A command from a tool this organization builds — `writ`, `star` — is verified against develop and
installed before it appears in a script or a message: [agent-rules.md](agent-rules.md), rule 1.

This step exists because a hand-rolled subset of the gate will differ from it eventually. On
2026-08-30 a `personal` PR pre-flighted with `shellcheck` alone and failed CI on `shfmt`, after the
issue, branch, commit and PR already existed. The remedy is not a longer checklist; it is to stop
maintaining a second copy of the gate.

---

## A worktree's first script

A worktree's first script opens the branch, commits the plan and pushes it, then records where each of its steps' work
is: In progress, its row on its team's Schedule project linking the branch in its Worktree column
([agent-rules.md](agent-rules.md), rule 19). The link waits for the push, since a link to a branch GitHub doesn't have
leads nowhere. Like the merge script's schedule step, it finds each row by its issue and the project's title, and the
fields and options by name, so no ID is pasted into a script and none goes stale (rule 13).

```bash
# The schedule's helpers (agent-rules.md, rule 19). A step's row is found by its issue and its team's Schedule project,
# by title, and the project's fields and options by name, so no ID is pasted into a script and none goes stale.
repository=<owner>/<repo>
schedule_project="Schedule: <team>"

# step_row prints a step's row on the team's Schedule project, as {project, item, schedule, status, worktree}, or
# nothing when the issue has no row there. fieldValueByName answers null for a field a project lacks, so every project
# the issue is a row of can be read in the one query.
step_row() {
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
    fields="$(gh api graphql -f p="${project}" -f query='query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) {
        nodes { ... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }' |
        jq -c '[.data.node.fields.nodes[] | select(.name == "Status" or .name == "Worktree")] | INDEX(.name)')"
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Status.id' <<<"${fields}")" \
        -f o="$(jq -r --arg s "${status}" '.Status.options[] | select(.name == $s) | .id' <<<"${fields}")" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }' >/dev/null
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
```

---

## Template

```bash
#!/usr/bin/env bash
set -euo pipefail

cd ~/Workspace/<org>/<clone>.<issue>-<name>

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
git commit -m "$(cat <<'EOF'
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
description="$(cat <<'EOF'
## Summary

- **Change 1** — description
- **Change 2** — description

## Test plan

- [x] Verified item
- [ ] TODO item

Written with AI assistance.
EOF
)"
description+=$'\n\n'"Signed-off-by: $(git config user.name) <$(git config user.email)>"
description+=$'\n'"Assisted-by: Claude Code"

# Create PR
gh pr create \
  --title "<type>(<scope>): <summary>" \
  --body "${description}"$'\n\n## Time\n\n_Filled by the merge step below._'

# --- CI gate ---
sleep 5
pr_number=$(gh pr view --json number --jq '.number')

if ! gh pr checks "${pr_number}" --watch; then
    check_output=$(gh pr checks "${pr_number}" 2>&1 || true)
    if [[ "${check_output}" == *"no checks reported"* ]]; then
        echo "No CI checks configured, proceeding."
    else
        echo "CI checks failed:"
        echo "${check_output}"
        exit 1
    fi
fi

# --- Merge gate ---
merge_state=$(gh pr view "${pr_number}" --json mergeStateStatus --jq '.mergeStateStatus')
case "${merge_state}" in
    CLEAN|HAS_HOOKS|UNSTABLE|BLOCKED)
        ;; # OK to merge (--admin bypasses BLOCKED)
    DIRTY|BEHIND)
        echo "PR is not mergeable (state: ${merge_state})."
        if [[ "${merge_state}" == "DIRTY" ]]; then
            echo "Merge conflicts detected — resolve before merging."
        fi
        exit 1
        ;;
    *)
        echo "Unknown merge state: ${merge_state} — check PR manually."
        exit 1
        ;;
esac

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
gh pr view "${pr_number}" --json body --jq .body | sed '/^## Time$/,$d' > "${message_file}"
gh pr merge "${pr_number}" --squash --admin \
  --subject "$(gh pr view "${pr_number}" --json title --jq .title) (#${pr_number})" \
  --body-file "${message_file}"

# --- The span: every pull request records its time (rule 11) ---
#
# Three markers from GitHub's own timestamps, elapsed hours to one decimal, appended to the PR body and
# verified. AFTER the merge, not before: mergedAt does not exist until the merge lands. Carried verbatim
# here until `star github pr span` exists (noblefactor-ops#188); then this block is one call to it.
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
printf '%s\n%s\n' "${body}" "${span}" > "${message_file}"
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
    fields="$(gh api graphql -f p="${project}" -f query='query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) {
        nodes { ... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }' |
        jq -c '[.data.node.fields.nodes[] | select(.name == "Status" or .name == "Worktree")] | INDEX(.name)')"
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Status.id' <<<"${fields}")" \
        -f o="$(jq -r --arg s "${status}" '.Status.options[] | select(.name == $s) | .id' <<<"${fields}")" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }' >/dev/null
    gh api graphql -f p="${project}" -f i="${item}" -f f="$(jq -r '.Worktree.id' <<<"${fields}")" -f v="${link}" \
        -f query='mutation($p: ID!, $i: ID!, $f: ID!, $v: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p,
        itemId: $i, fieldId: $f, value: {text: $v}}) { projectV2Item { id } } }' >/dev/null
}

# --- The steps: each one's issue records the merge, and its row closes (rule 13; agent-rules.md, rule 19) ---
#
# AFTER the merge and its span, since the records name the squash commit. Guarded on what each record holds (ruled
# 2026-11-13): the step's row must link this branch, or this pull request when the script runs again; otherwise the
# step has moved to another worktree, and the script stops. The issue's comment is posted once, and the issue closed
# only while it is open. Each record is read back. A step that moves to another worktree, or closes without a merge,
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
    gh api "repos/${repository}/issues/${step}/comments" --paginate --jq '.[].body' | grep -qxF -- "${record}" ||
        gh issue comment "${step}" --repo "${repository}" --body "${record}" >/dev/null
    [[ "$(gh issue view "${step}" --repo "${repository}" --json state --jq .state)" == CLOSED ]] ||
        gh issue close "${step}" --repo "${repository}" --reason completed >/dev/null
    set_row "$(jq -r .project <<<"${row}")" "$(jq -r .item <<<"${row}")" Closed "${pr_url}"
    after="$(step_row "${step}")"
    if ! gh api "repos/${repository}/issues/${step}/comments" --paginate --jq '.[].body' | grep -qxF -- "${record}" ||
        [[ "$(gh issue view "${step}" --repo "${repository}" --json state --jq .state)" != CLOSED ]] ||
        [[ "$(jq -r '"\(.status) \(.worktree)"' <<<"${after}")" != "Closed ${pr_url}" ]]; then
        echo "#${step} does not read back as merged: its row reads $(jq -c 'del(.project, .item)' <<<"${after}")"
        exit 1
    fi
    echo "#${step}: closed, its comment posted, its row $(jq -r '"\(.status), \(.worktree)"' <<<"${after}")"
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

## Rules

1. **Stage by name.** Never `git add -A` or `git add .`.
2. **Every pull request is signed off and discloses AI; AI is never credited.** The description says AI assisted
   and ends with two trailers, `Signed-off-by: <name> <email>` from git's configuration and
   `Assisted-by: Claude Code`, as devlore-cli's and devlore-registry's CONTRIBUTING.md require. The merge step
   writes the description, up to `## Time`, into the squash commit, and the script checks that the commit that
   landed carries both. Commits on the branch carry no trailer. No `Co-Authored-By` line, no Generated-by footer,
   no `Claude-Session:` link. Ruled 2026-10-03 (#254): "I want the prs, not the commits to carry these messages."
   Ruled 2026-11-03: the description's form is to be kept in the account's pull request template, stored in its
   `.github` repository with the account's other file templates
   ([section 6](../architecture/issue-data-model/6-the-asset-and-its-sync.md#one-model-per-account) of the issue data
   model design). Each account's is its `.github` repository's `.github/pull_request_template.md`, since 2026-11-09:
   NobleFactor's with #431, and David-Noble-at-work's with #441, which stands in for David-Noble-at-work/personal#311.
3. **HEREDOC for messages.** Both commit messages and PR bodies use `cat <<'EOF'` for safe formatting.
4. **CI gate is tolerant.** Repos with no required checks proceed; real failures abort.
5. **Merge gate before merge.** Check `mergeStateStatus` to catch conflicts, blocks, or staleness before attempting
   `gh pr merge`.
6. **`git close-branch` for cleanup.** Handles both worktree and regular-branch scenarios.
   It also **removes the worktree the script is standing in**, so nothing after it may assume `cwd`
   survives: `cd` to the main clone first. Observed as a spurious exit 128 after a successful merge
   on devlore-cli#811. It **removes the script itself**, `<worktree>.bash` or `.ps1` beside the worktree
   (#366); bash reads on from the unlinked file and PowerShell parsed the file before running it, so the
   lines after it still run. Then it **syncs the main clone** to the target branch, whatever it had checked
   out, prints what it had and the commit it is at now, and exits 75 when the sync cannot happen (#306).
7. **One PR at a time.** Merge and clean up before starting the next branch.
8. **Always `--squash`, never `--delete-branch`.** The merge command carries `--squash` and no other
   deletion flag. `--delete-branch` deletes the local branch first, which fails when a linked
   worktree holds it, and under `set -e` that aborts the script after the merge and before cleanup.
   `git close-branch` deletes in the order that survives a failure: remote, then worktree, then local,
   then the script. Then it syncs the main clone itself (rules 6 and 12).
9. **The epic report ends a pull request when one is asked for.** Table form, all states, scoped to the
   epic, feature or thread the pull request served, printed last, after cleanup, so the reader sees the
   state the merge produced. Not automatic: ruled 2026-09-12 in `development-process.md`, which retired
   the standing rule of 2026-09-04 that every pull request print one.

10. **Nothing left behind.** After `git add` by name, `git diff --quiet` must pass. A modified tracked
    file the script did not stage is a change the PR silently omits; #161 merged without the rule
    above for exactly this reason.

11. **Every pull request records its time.** A `## Time` section in the pull request's own body, written by
    the merge step from GitHub's own timestamps and verified there: `opened` (the branch's first commit),
    `submitted` (the pull request's creation), `merged`, and the elapsed hours between them to one decimal.
    Ruled 2026-09-08. One algorithm for every pull request -- a number computed differently each time is
    noise, and the value is in the series. It measures how long the work was **open**, review gaps and nights
    included; it is not effort and must not be read as one. Where a coding agent estimates active time from
    its own session transcript, that estimate goes in the agent's end-of-PR message, labeled an estimate, and
    never into the pull request as fact.

12. **Pull before and after the merge.** Ruled 2026-09-24. Before the push, the branch takes the target by
    a merge commit (`git pull --no-rebase`), so what CI passes is what merges. After the merge, `git
    close-branch` syncs the main clone to the target, the squash commit with it, and exits 75 when it cannot
    (#306); the script's `git pull --ff-only` then confirms it, finding the clone current. Every script
    written on 2026-09-24 had to add both pulls by hand; the template owes them.

13. **Every pull request records its steps as it lands.** Ruled 2026-10-25 (#401), and brought to the Schedule
    project on 2026-11-13 (#450). After the merge and its span, the script records each step it lands: a comment on the
    step's issue naming the pull request and its squash commit, the issue closed, and the step's row on its team's
    Schedule project set Closed, its Worktree linking the pull request. A worktree's first script, once its branch is
    pushed, sets each of its steps' rows In progress with the branch's link
    ([§ A worktree's first script](#a-worktrees-first-script)). Each row is found by its issue and the project's title,
    and the fields and options by name, so no ID is pasted in. Ruled 2026-11-13: each record is guarded on what it holds
    just before it is written. The first script writes only to a row that is on a schedule, Open or In progress, and
    links no other branch; the merge script writes only to a row that links its branch, or its pull request when it runs
    again; the comment is posted once, and the issue closed only while it is open. Each record is read back. A merge
    that leaves its steps reading In progress keeps the owner in the dark on progress, and every session that reads the
    schedule with them, this one too once its context is compacted ([agent-rules.md](agent-rules.md), rule 19). #396
    merged that way: its lanes on #301 kept reading "in progress" in a worktree `git close-branch` had removed.

---

## On Windows: PowerShell

On Windows the PR script is `<worktree>.ps1`, beside the worktree, PowerShell 7, written to the
[PowerShell style guide](powershell-style-guidelines.md): shebang, header, help, `#Requires`, `[CmdletBinding()]` and
`param()`, `$ErrorActionPreference = 'Stop'`, a helpers region, then the main operation. It does what the bash
template does, in the same order. The rules above hold; these are the ones PowerShell changes.

1. **Every native command is checked.** `$ErrorActionPreference = 'Stop'` doesn't cover a native command's exit code,
   and there is no `set -e`. `Assert-NativeSuccess` runs right after every `git` and `gh` call.
2. **Bodies are single-quoted here-strings.** The PR body and the jq program are `@'...'@`, so PowerShell expands
   nothing in them. The body goes to `gh` through a file, `--body-file`.
3. **The `## Time` section is written through a file,** `gh api -X PATCH repos/<owner>/<repo>/pulls/<n> -F
   body=@<file>`, as every Windows PR script has done. PowerShell has no `printf ... | --body-file -` idiom worth
   copying, and a file keeps the body byte-for-byte.
4. **Clean-up runs from the main clone.** `Set-Location` to it before `git close-branch`, because Windows won't
   delete a directory that is a process's current directory. `git close-branch` also removes this script, which
   PowerShell parsed in full before running, so the lines after it still run. Then `git pull --ff-only`, which
   confirms the sync `git close-branch` made of the main clone (rule 12).
5. **No PATH changes.** The script runs from a pwsh whose `git` is `Git\cmd\git.exe`, Git for Windows' launcher, which
   gives git's children the `sh` and `bash` they need without putting them on PATH. From a pwsh started by Git Bash,
   `git` resolves to the raw `Git\clangarm64\bin\git.exe`, and an HTTPS push, a credential helper or `git
   close-branch` exits 128 with no message. The fix is where the script runs, never a PATH line in it.
6. **The owner runs it.** `! C:/Users/<you>/Workspace/<org>/<clone>.<n>-<name>.ps1`, with a full path and forward
   slashes.

```powershell
#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    PR script for <owner>/<repo>, issue #<n>.

.DESCRIPTION
    Opens the pull request for <branch>, waits for CI, checks the merge state, squash-merges, records the pull
    request's time span and the steps it lands, and closes the branch. Every commit is made and pushed; there is
    nothing to stage.

.EXAMPLE
    C:/Users/<you>/Workspace/<org>/<clone>.<n>-<name>.ps1
#>

#Requires -Version 7.0

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$branch = '<branch>'
$repository = '<owner>/<repo>'
$worktree = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>', '<clone>.<n>-<name>'
$mainClone = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath '<org>', '<clone>'
$scheduleProject = 'Schedule: <team>'

###########
# Helper functions
###########

function Get-StepRow {
    # A step's row on the team's Schedule project, found by its issue and the project's title, or $null when the issue
    # has no row there. fieldValueByName answers null for a field a project lacks, so every project the issue is a
    # row of can be read in the one query.
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [int]
        $Issue
    )

    $owner, $name = $repository -split '/', 2
    $query = @'
query($o: String!, $r: String!, $n: Int!) { repository(owner: $o, name: $r) { issue(number: $n) { projectItems(first: 20) {
nodes { id project { id title }
schedule: fieldValueByName(name: "Schedule") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
status: fieldValueByName(name: "Status") { ... on ProjectV2ItemFieldSingleSelectValue { name } }
worktree: fieldValueByName(name: "Worktree") { ... on ProjectV2ItemFieldTextValue { text } } } } } } }
'@
    $json = (gh api graphql -F "n=$Issue" -f "o=$owner" -f "r=$name" -f "query=$query") -join "`n"
    Assert-NativeSuccess 'gh api graphql (step row)'
    $node = ($json | ConvertFrom-Json).data.repository.issue.projectItems.nodes |
        Where-Object { $_.project.title -eq $scheduleProject } | Select-Object -First 1

    if (-not $node) {
        return $null
    }

    [pscustomobject]@{
        Project  = $node.project.id
        Item     = $node.id
        Schedule = [string]$node.schedule.name
        Status   = [string]$node.status.name
        Worktree = [string]$node.worktree.text
    }
}

function Set-StepRow {
    # Sets a row's Status, by the option's name, and its Worktree, the project's fields found by name.
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [pscustomobject]
        $Row,

        [Parameter(Mandatory)]
        [string]
        $Status,

        [Parameter(Mandatory)]
        [string]
        $Link
    )

    $query = @'
query($p: ID!) { node(id: $p) { ... on ProjectV2 { fields(first: 50) { nodes {
... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } }
'@
    $fields = ((gh api graphql -f "p=$($Row.Project)" -f "query=$query") -join "`n" | ConvertFrom-Json).data.node.fields.nodes
    Assert-NativeSuccess 'gh api graphql (fields)'
    $statusField = $fields | Where-Object { $_.name -eq 'Status' }
    $worktreeField = $fields | Where-Object { $_.name -eq 'Worktree' }
    $option = $statusField.options | Where-Object { $_.name -eq $Status }

    $setOption = @'
mutation($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p, itemId: $i,
fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }
'@
    gh api graphql -f "p=$($Row.Project)" -f "i=$($Row.Item)" -f "f=$($statusField.id)" -f "o=$($option.id)" -f "query=$setOption" |
        Out-Null
    Assert-NativeSuccess 'gh api graphql (Status)'

    $setText = @'
mutation($p: ID!, $i: ID!, $f: ID!, $v: String!) { updateProjectV2ItemFieldValue(input: {projectId: $p, itemId: $i,
fieldId: $f, value: {text: $v}}) { projectV2Item { id } } }
'@
    gh api graphql -f "p=$($Row.Project)" -f "i=$($Row.Item)" -f "f=$($worktreeField.id)" -f "v=$Link" -f "query=$setText" |
        Out-Null
    Assert-NativeSuccess 'gh api graphql (Worktree)'
}

function Assert-NativeSuccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Operation
    )

    if ($LASTEXITCODE -ne 0) {
        throw "$Operation failed with exit code $LASTEXITCODE."
    }
}

function Get-PullRequestBody {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $name = git config user.name
    Assert-NativeSuccess 'git config user.name'
    $email = git config user.email
    Assert-NativeSuccess 'git config user.email'

    $description = @'
## Summary

- **Change 1** -- description

## Test plan

- [x] Verified item

Resolves #<n>

Written with AI assistance.
'@

    # The description ends with the two trailers (rule 2); the sign-off comes from git's configuration.
    # The description's form is kept in the account's pull request template, in its .github repository: NobleFactor's
    # since #431, David-Noble-at-work's since #441 (rule 2).
    $trailers = "Signed-off-by: $name <$email>`nAssisted-by: Claude Code"
    return "$description`n`n$trailers`n`n## Time`n`n_Filled by the merge step below._"
}

function Get-TimeSpanSection {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [int]
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

    $section = gh pr view $Number --json createdAt,mergedAt,commits --jq $program
    Assert-NativeSuccess 'gh pr view (time span)'
    return ($section -join "`n")
}

###########
# Main
###########

Set-Location $worktree

# --- Pre-flight: nothing left behind, then the repository's own gate where it runs here ---

git diff --quiet
$unstaged = $LASTEXITCODE
git diff --cached --quiet
$staged = $LASTEXITCODE

if ($unstaged -ne 0 -or $staged -ne 0) {
    git status --short
    throw 'The worktree is not clean; nothing should be left behind.'
}

git pull --no-rebase --no-edit origin <default-branch>
Assert-NativeSuccess 'git pull'

git push -u origin $branch
Assert-NativeSuccess 'git push'

# --- Create the PR ---

$bodyFile = Join-Path ([System.IO.Path]::GetTempPath()) 'pr-<n>-body.md'
Set-Content -LiteralPath $bodyFile -Value (Get-PullRequestBody) -NoNewline

gh pr create --base '<default-branch>' --head $branch --body-file $bodyFile --title '<type>(<scope>): <summary>'
Assert-NativeSuccess 'gh pr create'

$number = [int](gh pr view $branch --json number --jq '.number')
Assert-NativeSuccess 'gh pr view'

# --- CI gate ---

Start-Sleep -Seconds 5
gh pr checks $number --watch

if ($LASTEXITCODE -ne 0) {
    $checks = gh pr checks $number 2>&1 | Out-String

    if ($checks -notmatch 'no checks reported') {
        throw "CI checks failed:`n$checks"
    }
}

# --- Merge gate ---

$mergeState = gh pr view $number --json mergeStateStatus --jq '.mergeStateStatus'
Assert-NativeSuccess 'gh pr view (merge state)'

switch ($mergeState) {
    { $_ -in 'CLEAN', 'HAS_HOOKS', 'UNSTABLE', 'BLOCKED' } {
        break
    }
    { $_ -in 'DIRTY', 'BEHIND' } {
        throw "PR is not mergeable (state: $mergeState)."
    }
    default {
        throw "Unknown merge state: $mergeState -- check the PR manually."
    }
}

# --- Squash merge: the message is the title and the description up to ## Time (rule 2) ---

$title = (gh pr view $number --json title --jq '.title') -join "`n"
Assert-NativeSuccess 'gh pr view (title)'
$description = (gh pr view $number --json body --jq '.body') -join "`n"
Assert-NativeSuccess 'gh pr view (description)'
$squashFile = Join-Path ([System.IO.Path]::GetTempPath()) 'pr-<n>-squash.md'
Set-Content -LiteralPath $squashFile -Value ($description -replace '(?s)## Time.*$', '').TrimEnd() -NoNewline
gh pr merge $number --squash --admin --subject "$title (#$number)" --body-file $squashFile
Assert-NativeSuccess 'gh pr merge'

# --- The span (rule 11) ---

$section = Get-TimeSpanSection -Number $number
$body = (gh pr view $number --json body --jq '.body') -join "`n"
Assert-NativeSuccess 'gh pr view (body)'
$body = $body -replace '(?s)## Time.*$', ''
Set-Content -LiteralPath $bodyFile -Value ($body.TrimEnd() + "`n`n" + $section) -NoNewline
gh api -X PATCH "repos/$repository/pulls/$number" -F "body=@$bodyFile" | Out-Null
Assert-NativeSuccess 'gh api (body)'

if (((gh pr view $number --json body --jq '.body') -join "`n") -notmatch '(?m)^## Time') {
    throw 'The PR body carries no ## Time section.'
}

# --- The steps: each one's issue records the merge, and its row closes (rule 13; agent-rules.md, rule 19) ---
#
# AFTER the merge and its span, since the records name the squash commit. Guarded on what each record holds (ruled
# 2026-11-13): the step's row must link this branch, or this pull request when the script runs again; otherwise the
# step has moved to another worktree, and the script stops. The issue's comment is posted once, and the issue closed
# only while it is open. Each record is read back. A step that moves to another worktree, or closes without a merge,
# is recorded by this script before git close-branch, its row linking where the work went. Left out only when the pull
# request lands no step.

$steps = @(<issue>)
$link = "https://github.com/$repository/tree/<branch>"
$pullRequest = "https://github.com/$repository/pull/$number"
$merged = (gh pr view $number --repo $repository --json mergeCommit,mergedAt --jq '"\(.mergeCommit.oid[0:7]) \(.mergedAt[0:10])"') -join ''
Assert-NativeSuccess 'gh pr view (merge commit)'
$sha, $day = $merged -split ' ', 2

foreach ($step in $steps) {
    $row = Get-StepRow -Issue $step

    if (-not $row) {
        throw "#$step has no row on $scheduleProject."
    }

    if ($row.Worktree -ne $link -and $row.Worktree -ne $pullRequest) {
        throw "#$step's row links $($row.Worktree), not $link or ${pullRequest}: the step has moved."
    }

    $record = "Merged in #$number as ``$sha`` on $day (UTC)."
    $comments = gh api "repos/$repository/issues/$step/comments" --paginate --jq '.[].body'
    Assert-NativeSuccess 'gh api (comments)'

    if ($comments -cnotcontains $record) {
        gh issue comment $step --repo $repository --body $record | Out-Null
        Assert-NativeSuccess 'gh issue comment'
    }

    $state = (gh issue view $step --repo $repository --json state --jq '.state') -join ''
    Assert-NativeSuccess 'gh issue view (state)'

    if ($state -ne 'CLOSED') {
        gh issue close $step --repo $repository --reason completed | Out-Null
        Assert-NativeSuccess 'gh issue close'
    }

    Set-StepRow -Row $row -Status 'Closed' -Link $pullRequest
    $after = Get-StepRow -Issue $step
    $comments = gh api "repos/$repository/issues/$step/comments" --paginate --jq '.[].body'
    Assert-NativeSuccess 'gh api (comments, after)'
    $state = (gh issue view $step --repo $repository --json state --jq '.state') -join ''
    Assert-NativeSuccess 'gh issue view (state, after)'

    if ($comments -cnotcontains $record -or $state -ne 'CLOSED' -or $after.Status -ne 'Closed' -or $after.Worktree -ne $pullRequest) {
        throw "#$step does not read back as merged: its row reads $($after.Status), $($after.Worktree)."
    }

    Write-Output "#${step}: closed, its comment posted, its row $($after.Status), $($after.Worktree)"
}

# --- Clean up, from the main clone ---

Set-Location $mainClone
git close-branch $branch
Assert-NativeSuccess 'git close-branch'
git pull --ff-only origin <default-branch>
Assert-NativeSuccess 'git pull'

# The commit that landed carries both trailers (rule 2), or the script says so and fails.
$landed = (git log --max-count=1 --format=%B) -join "`n"
Assert-NativeSuccess 'git log'

if ($landed -notmatch '(?m)^Signed-off-by: ' -or $landed -notmatch '(?m)^Assisted-by: ') {
    throw 'The squash commit lacks Signed-off-by or Assisted-by.'
}

git status --short
```

### A worktree's first script, in PowerShell

The same step as [the bash form's](#a-worktrees-first-script), after the push, with `Get-StepRow` and `Set-StepRow`
from the helpers region above and `$scheduleProject` among the script's variables.

```powershell
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
        throw "#$step has no row on $scheduleProject."
    }

    if (-not $row.Schedule) {
        throw "#$step's row on $scheduleProject names no schedule."
    }

    if ($row.Status -notin @('Open', 'In progress')) {
        throw "#$step's row is $($row.Status), not Open or In progress."
    }

    if ($row.Worktree -and $row.Worktree -ne $link) {
        throw "#$step's row links $($row.Worktree): another worktree holds the step."
    }

    Set-StepRow -Row $row -Status 'In progress' -Link $link
    $after = Get-StepRow -Issue $step

    if ($after.Status -ne 'In progress' -or $after.Worktree -ne $link) {
        throw "#$step's row reads $($after.Status), $($after.Worktree)."
    }

    Write-Output "#${step}: $($after.Schedule), $($after.Status), $($after.Worktree)"
}
```
