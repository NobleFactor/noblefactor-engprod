---
name: star-github-schedule-progress
description: Answer schedule status and next-work questions, show scenarios, discover schedules or scenarios, and report on epics, features, bugs or issue searches using the star GitHub commands.
title: "star github schedule progress"
---

# Answering a question about issues

Use the star GitHub commands for issue questions, following [Agent operation](../../../../../docs/engineering/agent-operation.md#all-agents-tools-and-status). A schedule or scenario view comes from its collection command; the broad report serves questions across issues and repositories. Read one issue's body with `gh issue view` only after the appropriate star command has identified it.

<a id="the-invocations"></a>

## Choose the command

| Request | Command |
| --- | --- |
| Status, where do we stand, what is next, or show the schedule | `star github schedule get <schedule>` |
| Show the scenario or its findings | `star github scenario get <scenario>` |
| What schedules are there | `star github schedule list <account>` |
| What scenarios are there | `star github scenario list <account>` |
| An epic, feature, bugs, what covers a symptom, or an issue search | `star github schedule report` |
| Classification faults | `star github triage sweep` |

A schedule or scenario key is `<owner>/<repository>#<number>`. A list command takes an account, such as `NobleFactor` or `David-Noble-at-work`; `--team <slug>` narrows an organization's results to a team and is refused for a user account. The collection commands are defined in [section 8](../../../../../docs/architecture/issue-data-model/8-the-schedule-commands.md) and [section 9](../../../../../docs/architecture/issue-data-model/9-the-scenario-commands.md).

## Status

When the Owner asks for status without naming a collection, use the schedule identified by `star-github-schedule-assignment`. Keep its issue key; do not infer an assignment from a branch name, current directory, or similar title.

1. **Status** comes from one `schedule get` call. Return its rows in the order printed, without follow-up lookups or added prose.
2. **Status on the current issue** uses the same call, selecting the In progress steps and showing their Worktree links.
3. **What's next?** Use that result to name the next open step, its issue and its Worktree when present, in one sentence.
4. **What's next, in detail?** Describe the open steps in order and their open blockers, ending with the command's table.

The Schedule issue's own row comes first with no Step, followed by numbered steps and then any rows missing a Step. Records carry `step`, `issue`, `type`, `title`, `state`, `status`, `worktree`, `iteration` and `blocked_by`. The blockers are the open ones. Read a closed schedule with the same command.

```bash
star github schedule get <owner>/<repository>#<number> --silent --output table \
  --jq 'map({step, issue, type, title, state, status, worktree, blocked_by})'
```

For status on the current issue, replace the projection with `map(select(.step != null and .status == "In progress") | {step, issue, type, title, state, status, worktree, blocked_by})` in that one call.

## Show a scenario

Use one `scenario get` call for the named scenario. Its own issue's row comes first with no Beat, followed by numbered rows in Beat order, then rows missing a Beat. Beat N is step N of the walk; Beat 0 is before its first step. Read a retired scenario with the same command.

```bash
star github scenario get <owner>/<repository>#<number> --silent --output table \
  --jq 'map({beat, issue, type, title, state, status})'
```

## Discover schedules and scenarios

Name the account explicitly. Preserve the command's project and option names; the issue key identifies the collection to pass to `get`.

```bash
star github schedule list NobleFactor --team engprod --silent --output table \
  --jq 'map({schedule, issue, title, state, assignee, project, open_steps, closed_steps})'
star github scenario list NobleFactor --team engprod --silent --output table \
  --jq 'map({scenario, issue, title, state, assignee, project, open_rows, closed_rows})'
star github schedule list David-Noble-at-work --silent --output table \
  --jq 'map({schedule, issue, state, project, open_steps, closed_steps})'
star github scenario list David-Noble-at-work --silent --output table \
  --jq 'map({scenario, issue, state, project, open_rows, closed_rows})'
```

## What the report returns

The broad report returns a flat record for every issue, open and closed, in the repositories it reads. Records carry issue identity and state; parent, feature and epic; native issue fields; `home` project rows; `in_triage`; labels, assignees, dependencies, projects and timestamps. A list is `[]` when empty. Its `--search` uses GitHub issue-search syntax for body, comment and other criteria outside those fields.

Keep using it for epic, feature, bug and search questions:

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

## Where to run it

The commands run anywhere. With no repositories named, the broad report reads the repositories in writ's layers on the Owner's machine. Name repositories as `owner/name` arguments when the question has a narrower scope. Collection `get` reads the one team's project; collection `list` reads the account's applicable projects or one named team's.

Always use `--silent` and a `--jq` projection naming the fields needed. Use `--output table` for a person or JSON for retained evidence; present the command's records rather than reconstructing them with ad-hoc issue-list or search queries.

## Verify star first, and do not clobber it

Before relying on a locally built command, identify the installed build and compare it with devlore-cli's `develop`, once for the current verification context:

```bash
build="$(star version --silent --no-pager --output value --jq .commit)"
gh api "repos/NobleFactor/devlore-cli/compare/$build...develop" --jq .status
```

For that base-to-develop comparison, `ahead` or `identical` places the installed build on develop's ancestry. If the build is dirty, unknown, behind or diverged, use it read-only and disclose that limitation. Confirm the needed interface exists. Do not install over another session's working build; the supported release upgrade is `star self upgrade`, when authorized.

The collection `get` and `list` commands write nothing. They refuse `--dry-run` until NobleFactor/devlore-cli#1170 allows dry runs to read; use their normal read-only invocation.

## Classification faults

`star github triage sweep` can add an open issue with a classification fault to its team's Triage project. It is a mutation and requires the applicable authorization. Until NobleFactor/devlore-cli#1170, `--dry-run` reads nothing and cannot prove that a live sweep would pass.

## The cost

A collection `get` reads one project. The broad report reads every issue of its repositories and is appropriate for questions across repositories. Choose the command by the question's scope; output filtering alone does not narrow the report's reads.
