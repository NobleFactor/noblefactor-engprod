---
title: "5. From today's scheme"
---

# 5. From today's scheme

The owner, 2026-10-21: "The task list should be based on what we see are the deltas between what we have and what we
want. We will produce the task list after we have some clarity on the data model. The schedule for this work cannot
result in downtime for other activities that are underway. We should plan PRs around that constraint." And: "migration
must be managed carefully."

## The deltas

| Today | The model |
| --- | --- |
| Five kinds as labels: epic, feature, task, bug, chore; a chore is a leaf | Type: Epic; then Feature or Chore; then Task or Bug ([section 1](1-hierarchy.md)) |
| Today's enabler features under `Epic:Ops:Process`, and the chores filed under them | Chores, and tasks under them |
| Every issue carries an `Epic:<Name>` label, kept only where its epic is hosted, `Epic:Ops:Process` excepted | No epic label: an issue's epic is read from its parents |
| The `**Feature:** #N` marker, the last one in the body | A parent link ([section 4](4-storage-and-reach.md)) |
| The `Ops:` prefix marks tooling | Chore against feature marks it |
| A bug awaiting triage has no feature and no epic, and the audit exempts it | An issue with no Type or no parent is untriaged; the audit exempts it and reports its age |
| A thread: a `Thread:<Name>` label on each member, a beat table in the thread's issue, members are leaves | A Thread project; its rows are features and chores ([section 3](3-collections.md)) |
| A schedule: a `Schedule:` chore whose body holds a lane table; lanes are leaves numbered 1 to N | A Schedule project; row 0 its own issue, lanes 1 to N its tasks and bugs |
| A lane's Waits on: text in the table | GitHub's blocked-by link |
| A "Schedule: #N, lane N" footer on a lane's issue | Nothing: the row says it |
| `Severity:`, `Priority:` and `Area:` labels in devlore-cli only | Every repository, from the labels file; Severity on bugs only ([section 2](2-attributes.md)) |
| GitHub's default labels, `documentation` to `wontfix`, in every repository | Removed; `duplicate`, `invalid` and `wontfix` become close reasons |
| The report and the audit read labels, markers and body tables | They read the model: the second part, the star github extension |
| [issue-standards.md](../../issue-standards.md) states the old scheme | It states the model |

## What must keep running

Underway on 2026-10-21, and in use by sessions that cannot stop for this work:

- `star github schedule report` and `star github schedule audit`, and the star-github-schedule-progress and star-github-schedule-assignment skills that run
  them;
- the lane tables of the schedules being worked, NobleFactor/noblefactor-ops#301 and NobleFactor/devlore-cli#916;
- the labels in use, every `Epic:` and `Thread:` label among them;
- Start-Claude's sessions, keyed by their schedule's issue.

## The order

Each step is its own pull request or set of them, and none takes away what a running session reads:

1. **Documents.** This design, its plan, and issue-standards.md once the model is ruled. Nothing that runs reads them.
2. **Tooling that reads both.** star github reads the old scheme and the new one, the old by default; the audit reports
   where they disagree.
3. **New data beside the old.** New labels from the labels file; the sync adds and never deletes. Projects made for
   the schedules and threads beside their tables, which stay authoritative.
4. **Migration, one repository at a time.** Each issue given its Type and parent, each schedule's lanes made rows, and
   the audit confirming each repository before the next.
5. **The switch.** star github reads the new scheme by default; the old is still there to fall back on.
6. **The old scheme retired,** last, once no running session reads it: the `Epic:` and `Thread:` labels, the markers,
   the tables and the footers.

The task list is drawn from the deltas above in this order, once the owner has ruled on the plan's open questions.
