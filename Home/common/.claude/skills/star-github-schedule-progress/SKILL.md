---
name: star-github-schedule-progress
description: Report schedule or scenario status, identify next scheduled work, discover collections, and answer epic, feature, bug or issue-search questions with star GitHub commands.
title: "star github schedule progress"
---

<a id="answering-a-question-about-issues"></a>

# Report GitHub work status

Follow [Agent operation's tool routing](../../../../../docs/engineering/agent-operation.md#all-agents-tools-and-status). Use collection reads for Schedules/Scenarios and the broad report for questions across issues or repositories. Read an identified issue's full body only after the appropriate star command identifies it.

<a id="the-invocations"></a>

## Choose the command

| Request | Command |
| --- | --- |
| Schedule status, current work or next work | `star github schedule get <schedule>` |
| Scenario or its findings | `star github scenario get <scenario>` |
| Discover Schedules | `star github schedule list <account>` |
| Discover Scenarios | `star github scenario list <account>` |
| Epic, Feature, Bugs, symptoms or issue searches | `star github schedule report` |
| Classification faults | `star github triage sweep`, which requires mutation authority |

Collection keys are `<owner>/<repository>#<number>`. Lists take an account; `--team <slug>` restricts an organization's results and is refused for a user account. [Schedule](../../../../../docs/architecture/issue-data-model/8-the-schedule-commands.md) and [Scenario](../../../../../docs/architecture/issue-data-model/9-the-scenario-commands.md) references own the contracts.

<a id="status"></a>

## Report the assigned schedule

When no collection is named, resolve the assignment through `star-github-schedule-assignment`. Preserve its issue key; branch names, directories and similar titles do not establish an assignment.

Use one `schedule get` call:

```bash
star github schedule get <owner>/<repository>#<number> --silent --output table \
  --jq 'map({step, issue, type, title, state, status, worktree, blocked_by})'
```

For a status request, return the rows in command order without added prose or follow-up lookups. For current-issue status, select the In progress Steps and include Worktree links in that same call:

```text
map(select(.step != null and .status == "In progress") |
  {step, issue, type, title, state, status, worktree, blocked_by})
```

For “what's next,” identify the next open Step, its issue and Worktree in one sentence. Preserve execution order and report blockers rather than silently reorder work. For detail, describe open Steps and their open blockers in order, ending with the command's table.

The Schedule's own row comes first with no Step, followed by numbered Steps and then rows missing a Step. Records include step, issue, type, title, state, status, worktree, iteration and open blocked_by relationships. The same command reads closed Schedules.

## Show a scenario

Use one call for the named Scenario:

```bash
star github scenario get <owner>/<repository>#<number> --silent --output table \
  --jq 'map({beat, issue, type, title, state, status})'
```

Its own row has no Beat, followed by numbered Beats and rows missing a Beat. Beat N is walk step N; Beat 0 precedes the walk. The same command reads retired Scenarios.

<a id="discover-schedules-and-scenarios"></a>

## Discover collections

Name the account and preserve returned project/option names. Use the issue key for later collection reads:

```bash
star github schedule list NobleFactor --team engprod --silent --output table \
  --jq 'map({schedule, issue, title, state, assignee, project, open_steps, closed_steps})'
star github scenario list David-Noble-at-work --silent --output table \
  --jq 'map({scenario, issue, title, state, assignee, project, open_rows, closed_rows})'
```

Either collection supports organizational/team or user-account discovery. List reads applicable projects; get reads the selected collection's team project.

<a id="what-the-report-returns"></a>

## Report across issues

The broad report reads open and closed issues in named repositories, or writ's configured layer repositories when none are named. Its flat records include identity/state, parents/Feature/Epic, native fields, home rows, Triage membership, labels, assignees, dependencies, projects and timestamps. Empty lists are `[]`.

Use filters for recorded fields and GitHub `--search` syntax for body, comments or other search criteria:

```bash
star github schedule report --silent --output table --filter epic=<owner>/<repository>#<number> \
  --jq 'map({issue, type, state, feature, area, title})'
star github schedule report --silent --output table --filter feature=<owner>/<repository>#<number> --filter state=open \
  --jq 'map({issue, type, title, home: [.home[].project]})'
star github schedule report --silent --output table --filter type=Bug --filter state=open \
  --jq 'map({issue, severity, area, title})'
star github schedule report NobleFactor/devlore-cli --silent --output table --search '<words> in:title,body' \
  --jq 'map({issue, type, state, title})'
```

<a id="where-to-run-it"></a>

Commands run from any directory. Name repositories as owner/name when narrower scope is needed. Use `--silent` and a `--jq` projection of required fields; present tables to people and retain JSON for evidence. Preserve returned records rather than reconstruct them through ad-hoc issue lists/searches.

<a id="the-cost"></a>

Output filters do not reduce the report's underlying repository reads. Choose the operation by the question's scope.

<a id="verify-star-first-and-do-not-clobber-it"></a>

## Verify the installed build

Once per verification context, identify the installed copy/build and compare its commit with devlore-cli's develop. Confirm the needed command and inspect available dirty/unknown build metadata; a commit alone does not prove a clean build.

```bash
build="$(star version --silent --no-pager --output value --jq .commit)"
gh api "repos/NobleFactor/devlore-cli/compare/$build...develop" --jq .status
```

[GitHub compares BASE...HEAD](https://docs.github.com/en/rest/commits/commits#compare-two-commits): here the installed commit is BASE and develop is HEAD.

| Comparison status | Meaning |
| --- | --- |
| identical | The commits match |
| ahead | Develop has newer commits; the installed commit is its ancestor |
| behind | Develop is behind the installed commit; do not assume those installed commits are merged |
| diverged or unknown | The comparison does not establish that the installed commit is on develop's ancestry |

A clean ancestor can still lack a needed interface; verify support rather than describe it as current. Treat dirty, unknown, diverged or comparison-status-behind builds as read-only and disclose the limitation. Do not overwrite another session's working build. `star self upgrade` is the release-upgrade path when authorized.

<a id="classification-faults"></a>

## Read and mutation limits

Collection get/list operations write nothing. They refuse `--dry-run` until NobleFactor/devlore-cli#1170 supports reads in that mode; use normal read-only calls.

Triage sweep can add an open misclassified issue to its team's Triage project and requires applicable mutation authority. Its dry run currently reads nothing and cannot establish that a live sweep would pass.
