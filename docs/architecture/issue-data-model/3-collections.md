---
title: "3. Collections"
---

# 3. Collections

The owner, 2026-10-20: "I want to map schedules to github projects and get rid of the current scheme for tracking
lanes. A lane would be represented by a single row in a project of type Schedule." On 2026-10-21: "Schedule and Thread
are almost synonymous. They vary in intent, but are otherwise the same." And: "Projects track Schedules and Threads.
Threads track (Chore | Feature) work. Schedules track (Bug | Task) work. Threads represent use cases. Schedules track
engineering work. Threads will ultimately drive Schedules and influence Priority."

## One mechanism, three intents

| | Thread | Schedule | Triage |
| --- | --- | --- | --- |
| Represents | a use case | engineering work, in the order it is done | what is sent for review |
| Its rows | features and chores, level 1 | tasks and bugs, level 2 | any issue, of any Type or none |
| Ordered by | the story it tells | the order of execution | nothing: a queue, worked and emptied |
| Made from | the organization's Thread template | the organization's Schedule template | one project, standing |

The owner, 2026-10-21, on the third: "The Triage project is a little like a Schedule or a Thread, but it allows any
issue type: Epic, (Chore | Feature), (Bug | Task), or no Issue Type." Its rows are added by a person, or periodically
from the queries that find the untriaged ([section 1](1-hierarchy.md) § Triage); a row leaves when its issue is fully
classified or closed with a reason. It is the one collection with no template and no lane: there is one of it, and
its order is nobody's commitment, and there is one per team: ruled 2026-10-22, "Teams triage their issues", so each
team's Triage project has that team's triage epic as row 0, and a team's queue is what its own repositories log.
**Two Triage projects, one per team**, ruled 2026-10-22 ("sounds good. doc it."), named for the collection's kind
first and the team second, as schedule and thread issues are titled today:

| Team | In GitHub on 2026-10-22 | Triage project | Row 0, the triage epic | Repositories whose issues fill it |
| --- | --- | --- | --- | --- |
| engprod | not yet: the organization's teams are `devlore` and `owners` | Triage: engprod | #142, Epic: Process, retitled as engprod's triage epic | noblefactor-ops, becoming noblefactor-engprod (#304); and personal, which belongs to no team and no organization, so its issues are triaged here |
| devlore | `devlore`, DevLore | Triage: devlore | none yet: one epic to file in devlore-cli | devlore-cli, devlore-registry, devlore.noblefactor.com |

**engprod's row 0 is the triage epic, #142.** The owner, 2026-10-22: "We need a triage epic. it is the place to put all new logged issue, pending assignment to a place in our issue hierarchy. It should be added as row zero in the schedule that represents the triage project. We can use this to guide the work and--maybe--facilitate handoffs." So a newly
logged issue is filed as a sub-issue of #142, pending its place; triage moves it to its real parent; and #142's body
is where the state of triage is reported, as any row 0's is.

- A collection is a GitHub project in the NobleFactor organization, made from one of two organization templates, or
  the standing Triage project. A
  project can be marked as a template, and a NobleFactor project holds personal's issues as rows, with custom fields
  set on them: both seen on 2026-10-20, on two test projects made and then deleted.
- A row is one issue. An issue's place in a collection is a field of its row, never a label on the issue.
- Threads drive schedules: a schedule's tasks and bugs are the children of the features and chores that threads
  order. Today's standard makes a thread's members leaves, and the owner's note of 2026-10-20 let a lane be any type;
  both narrow to the stakes above. The plan's question 10.

## Rows and lanes

- A schedule's lanes are numbered in the order they are worked, by the tool that adds each row. A GitHub project has
  no number that counts by itself, so a row added in GitHub's interface has no lane, and the audit reports it. The
  owner's note of 2026-10-20 numbers from 0, row 0 being the schedule's own issue; lanes 1 to N then carry today's
  lane numbers over unchanged. The plan's questions 5 and 6.
- A closed lane keeps its number, as today.
- One issue in two live schedules: the owner, 2026-10-20, "5 give me pause". A project cannot prevent it. Proposed:
  the audit reports it for schedules; a thread may share a feature with another, since one feature can serve two use
  cases. The plan's question 9.

**A schedule row's fields, proposed:**

| Field | Kind of field | Holds |
| --- | --- | --- |
| Lane | number | the row's place in the order |
| Status | single select | derived by star from the issue and its work, never set by GitHub's workflows. GitHub can mark a row Done when its issue closes, and closed is not done: lane 13 of #301 closed on 2026-10-20 with two hosts not migrated. The plan's question 7 |
| Next | text | what happens next, and in which worktree, as today |
| Repository, Assignees, Linked pull requests, Parent issue | GitHub's own | as GitHub keeps them |

**Waits on** is not a field. GitHub links issues with blocked-by and blocking (the API's `Issue` type, 2026-10-21), and
a lane that waits on another is an issue blocked by another. Whether that link crosses repositories is unverified.

## The collection's own record: row 0, an Epic

Ruled 2026-10-22. The owner: "If you accept that a schedule is just a sequentially-numbered list of bugs and tasks that must be closed, a good question to ask is where do we keep status on the schedule? I might like to fully report my status on the issue at row 0. We work issues in the list starting at row 1. We keep our head straight and provide some insight to casual observers/owners/participants/reviewers by way of row zero. The question becomes: what is the issue type for row 0." And, approving the answer below: "I approve your recommendation."

A schedule's issue holds three things today: its deliverable, its lane table and the owner's amendments. The table
becomes the rows. The deliverable, the rulings and the status need a home that keeps them, and it is **row 0, the
collection's own issue**: its body keeps the deliverable, the amendments and the owner's full status with GitHub's
edit history; its assignee is the collection's owner; the work is the rows from 1 on; and a session stays keyed by
it, which is how Start-Claude's store and star-github-schedule-assignment find a schedule today. The project's README was the
other candidate, and sessions would have had to be keyed by the project instead.

**Row 0 is an Epic.** Three types were weighed:

- A type of its own, Schedule: ruled out on 2026-10-21, when a schedule became a project and not a kind, and the
  hierarchy "a very specific hierarchy based on Issue Type", Epic, then Chore or Feature, then Bug or Task. A fourth,
  level-less type breaks it, and the asset's levels have no place for it.
- Chore, which today's schedule issue is: a chore is level 1 and must have a parent epic, and a schedule has none,
  because its lanes cross epics and a sequence has no owner. Today's standard carries an exemption for exactly this,
  and the audit a special case; both would follow it into the model.
- Epic: level 0, a body of work with an owner and no parent, which is what row 0 is. Its assignee is the owner the
  collection has. It needs no exemption from the parent rule, because level 0 has none. GitHub shows it as the
  top-level thing it is. And it is uniform: a thread's row 0 is an epic too, and the Triage project's row 0 is #142,
  which already is one.

So an epic means two things, and the report tells them apart by one fact, whether the epic is row 0 of a project. A
**hierarchy epic** has features and chores as sub-issues. A **collection epic** has none: its rows are not its
children, since each lane keeps its real parent, and the project is what joins them. The audit reports a collection
epic that acquires sub-issues, and a hierarchy epic that sits in row 0. The plan's questions 5 and 3, closed together.

Either way the schedule is two records, its rulings and its rows, and one ruling can change both: one star command
adds a row and writes its amendment together, and the audit checks that every amendment's lane has its row.

## Ownership

The owner, 2026-10-21: "schedules are owned by individuals and teams". Three GitHub entities are involved and each can
hold one part, ruled 2026-10-22 for a team's Triage project and holding for every collection:

- **The project belongs to the organization.** GitHub has no team-owned project; an organization project has
  collaborators, and a team is one with the Admin, Write or Read role. A team owns a collection by holding Admin on
  its project.
- **Row 0 is assigned to a person.** GitHub assigns issues to user accounts, never to teams, so the one on the hook
  for a collection is a name on its epic: for a team's Triage project, the team's maintainer, GitHub's own name for a
  team's lead. If the maintainer changes, the project's role stays and the assignee moves, one edit.
- **The team holds the Triage role** on the repositories whose issues fill its queue, which lets its members type,
  parent and label without write access to code.

The owner is on every team and the maintainer of each today.

## A committed schedule

Today a committed schedule takes no new lane except by the owner's amendment
([issue-standards.md](../../issue-standards.md) § What a schedule commits to). A project takes a new row from anyone
with write access. Proposed: the rule stands, and a row is added with its amendment. The plan's question 8.
