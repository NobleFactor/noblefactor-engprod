---
name: star-github-schedule-progress
title: "star github schedule progress"
description: Answer "What is the status of your scheduled work?" and ANY other question about issues, epics, features, scenarios or schedules by running `star github schedule report` — never by ad-hoc `gh issue list`, `gh search`, or prose assembled from `gh issue view`. Triggers on "status", "what's the status", "status on the current issue", "step status", "what is next", "show the schedule", "where do we stand", "what is open", "what covers this", "which bugs", and any request to see a schedule, epic, feature or scenario. `star github triage sweep` finds classification faults.
---

# Answering a question about issues

Ruled 2026-09-07, [agent-rules](../../../../../docs/guides/agent-rules.md) rule 3: what exists, what is open, what
covers a symptom and what a feature holds are answered by our own report, never by an ad-hoc `gh issue list --search`.
The report is `star github schedule report` since #378. The owner ruled it so because it is our tool and we spent
significant resources to write it.

`gh issue view <n>` is for reading one body **after** the report has named it.

## What the report returns

Since #379 (ruled 2026-11-08) the report returns every issue, open and closed, of the repositories it is given, as one
flat record each, JSON by default. star's own `--filter key=value` and `--jq` narrow it, and `--output` renders it:
`table` for a person, `csv` for a spreadsheet. Its one selection of its own is `--search`, GitHub's issue-search syntax,
for what the record does not carry: bodies and comments, people, linked pull requests.

A record's keys: `issue`, `repository`, `type`, `title`, `url`, `state`; `parent` and an ancestor key for each level
above the issue's own (`feature`, `epic`); each issue field (`area`, `severity`, `priority`, `resolution`, and the
rest); `home`, a list of its rows on its team's Backlog, Schedule and Scenario projects, each with that row's
`schedule`, `step`, `status` and `worktree`; `in_triage`; `labels`, `assignees`, `blocked_by`; `projects`; and the
timestamps. A list is always a list, `[]` when it is empty (devlore-cli#1215).

## Status

When the owner asks for status, the answer is the progress of the schedule this session works; when the owner asks for
status on the current issue, it is the step being worked (ruled 2026-10-05).

1. **The assignment.** When no schedule is named, take it from `star-github-schedule-assignment`: the schedule issue,
   `<owner>/<repository>#<number>`.
2. **Status** is that schedule's steps, as the first invocation below prints them, in step order. Nothing more: no
   lookups, no prose. The report is to give exactly what is needed (ruled 2026-10-05).
3. **Status on the current issue** is the steps being worked: the rows whose Status is In progress, each with the
   branch in its Worktree column. The pull request is the record of that work (ruled 2026-10-05).
4. **What's next?** One sentence: the next open step, its issue, and its worktree when it has one.
5. **What's next, in detail**, only when asked: the open steps in order, what each is blocked by, ending with the table
   as the report prints it. The owner wants that detail sometimes, not every time (ruled 2026-10-05).

## Where to run it

Anywhere: with no repositories named, the report reads the repositories of writ's layers, noblefactor-engprod,
devlore-cli and personal on the owner's machines. Name others as arguments, `owner/name` each.

## Verify star first, and do not clobber it

`star` is a tool we build, so rule 1 applies: compare the installed build with devlore-cli's `develop`. GitHub answers
that through `gh`, with no git command to ask a grant for (rule 17, #389):

```bash
build="$(star version --silent --no-pager -o value --jq .commit)"
gh api "repos/NobleFactor/devlore-cli/compare/${build}...develop" --jq .status
```

`ahead` or `identical` places the build on `develop`. **If `star version` says the build is dirty, or GitHub answers
`behind` or `diverged`, or has no such commit, the build belongs to another session's work in progress.** Use it
read-only and say so. Do not `make install`: that replaces `~/.local/bin/star` and the extensions under
`~/.local/share/devlore/star/`, which is someone's working environment. A release is installed with
`star self upgrade`.

## The invocations

A schedule's steps, for status. The schedule is the Schedule option of the schedule issue's own row, so nothing is
read from its title:

```bash
star github schedule report --silent --output table --jq '
  (first(.[] | select(.issue == "<owner>/<repository>#<number>")).home[0].schedule) as $s
  | [.[] | (.home[] | select(.schedule == $s and .step != null)) as $h
     | {step: $h.step, issue, type, state, status: $h.status, title, worktree: $h.worktree}]
  | sort_by(.step)'
```

Everything under an epic, or a feature, and what is open of it:

```bash
star github schedule report --silent --output table --filter epic=<owner>/<repository>#<number> \
  --jq 'map({issue, type, state, feature, area, title})'
star github schedule report --silent --output table --filter feature=<owner>/<repository>#<number> --filter state=open \
  --jq 'map({issue, type, title, home: [.home[].project]})'
```

Which bugs, what covers a symptom:

```bash
star github schedule report --silent --output table --filter type=Bug --filter state=open --jq 'map({issue, severity, area, title})'
star github schedule report NobleFactor/devlore-cli --silent --output table --search '<words> in:title,body' --jq 'map({issue, type, state, title})'
```

**Always `--silent` and a `--jq` that names the keys wanted.** Without the projection every record carries every key,
and reformatting raw records by hand is the behavior rule 3 forbids, obeyed in letter and broken in substance.

Classification faults are the sweep's: `star github triage sweep` adds each open issue that breaks a rule to its
team's Triage project and returns each Triage project's list. Under star's `--dry-run` it adds nothing, and until
devlore-cli#1170 it reads nothing either.

## The cost

Every issue of three repositories, about 1,100 on 2026-11-08, read 50 to a page: a deliberate call, not a per-turn one.
Name the repositories wanted, or `--search` for a few issues, rather than reading the whole board for one answer.
