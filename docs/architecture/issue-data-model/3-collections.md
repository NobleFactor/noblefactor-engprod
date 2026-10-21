---
title: "3. Collections"
---

# 3. Collections

The owner, 2026-10-20: "I want to map schedules to github projects and get rid of the current scheme for tracking
lanes. A lane would be represented by a single row in a project of type Schedule." On 2026-10-21: "Schedule and Thread
are almost synonymous. They vary in intent, but are otherwise the same." And: "Projects track Schedules and Threads.
Threads track (Chore | Feature) work. Schedules track (Bug | Task) work. Threads represent use cases. Schedules track
engineering work. Threads will ultimately drive Schedules and influence Priority."

## One mechanism, two intents

| | Thread | Schedule |
| --- | --- | --- |
| Represents | a use case | engineering work, in the order it is done |
| Its rows | features and chores, level 1 | tasks and bugs, level 2 |
| Ordered by | the story it tells | the order of execution |
| Made from | the organization's Thread template | the organization's Schedule template |

- A collection is a GitHub project in the NobleFactor organization, made from one of two organization templates. A
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

## The collection's own record

A schedule's issue holds three things today: its deliverable, its lane table and the owner's amendments. The table
becomes the rows. The deliverable and the rulings need a home that keeps them, and there are two:

- **Row 0, the collection's own issue,** as the owner proposed on 2026-10-20. Its body keeps the deliverable and the
  rulings with GitHub's edit history, its assignee is the collection's owner, and a session stays keyed by it, which
  is how Start-Claude's store and star-gh-assignment find a schedule today. It needs one exemption: a collection's own
  issue is not work, so "Every issue must be fit into this hierarchy" cannot hold for it, as the epic rule does not
  hold for a schedule's or a thread's issue today.
- **The project's README,** which every GitHub project has. No exemption is needed, but sessions would be keyed by the
  project, and Start-Claude and star-gh-assignment would change their keys.

Proposed: row 0. The plan's question 5. Either way the schedule is two records, its rulings and its rows, and one
ruling can change both: one star command adds a row and writes its amendment together, and the audit checks that every
amendment's lane has its row.

## Ownership

The owner, 2026-10-21: "schedules are owned by individuals and teams". A person owns a collection as the assignee of
its own issue; GitHub's assignees are user accounts, never teams. A team owns one by its role on the project.

## A committed schedule

Today a committed schedule takes no new lane except by the owner's amendment
([issue-standards.md](../../issue-standards.md) § What a schedule commits to). A project takes a new row from anyone
with write access. Proposed: the rule stands, and a row is added with its amendment. The plan's question 8.
