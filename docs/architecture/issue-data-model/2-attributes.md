---
title: "2. Attributes"
---

# 2. Attributes

The owner, 2026-10-21: "use labels/tags for the attributes of an issue. An issue has a place in the issue hierarchy
in a repo. An issue has a severity. An issue might be on a schedule and schedules are owned by individuals and teams."

An attribute is something an issue has on its own, outside any collection. Its severity is one; its place on a
schedule is not, since lane 13 means nothing outside the schedule that numbers it ([section 3](3-collections.md)).

## The attributes

| Attribute | Applies to | Values | How many an issue may carry |
| --- | --- | --- | --- |
| Severity | Bug only | Critical, High, Medium, Low | at most one |
| Priority | every Type | P0, P1, P2, P3 | at most one |
| Area | every Type | each repository's own | any number |
| `good first issue` | every Type | none: present or absent | — |

The values of Severity and Priority are the ones NobleFactor/devlore-cli carries today, `Severity:Critical` to
`Severity:Low` and `Priority:P0` to `Priority:P3`, with seven `Area:` labels of its own. noblefactor-ops and personal
carry none of them (`gh label list`, 2026-10-21).

**Severity is a bug's.** The owner, 2026-10-21: "Severity is a quality of a bug." It measures the harm a defect does,
"what the impact is if this fires", in [issue-standards.md](../../issue-standards.md) § Triage adds attributes. The
owner asked what severity means for a task. Proposed answer: nothing. A task is planned work, and nothing has fired;
what a task has is priority. When a task exists to prevent a harm, the harm is a bug's severity, and the task takes
its priority from that bug. Severity on any Type but Bug is a fault the audit reports.

**Priority is when we act.** The owner, 2026-10-21: "Threads will ultimately drive Schedules and influence Priority."
How a thread's weight reaches its features' tasks is open: the plan's question 12.

**Area is the part of a repository's system an issue touches,** so its values belong to each repository.

## Labels carry no values

A GitHub label is a name, present on an issue or absent. `Severity:High` writes an attribute and its value into one
name; GitHub sees an opaque name with no relation to `Severity:Low`, and nothing stops an issue carrying both. "At most
one" is therefore the audit's to enforce, not GitHub's.

GitHub's issue fields do carry values: the organization defines a field once, with a type, and each issue holds its
own value, one for a single-select field. They would suit Severity and Priority better than labels do, but they reach
only the organization's repositories ([section 4](4-storage-and-reach.md)).

## Not attributes

- **A lane, or a row in a thread:** a place in a collection, held by the collection ([section 3](3-collections.md)).
- **An owner:** a person is an issue's assignee, a GitHub link to a user account; a team owns a collection by its role
  on the project ([section 3](3-collections.md)).
- **The hierarchy:** Type and parent ([section 1](1-hierarchy.md)).
- **Close reasons:** GitHub closes an issue as completed, not planned, or a duplicate (the API's
  `IssueClosedStateReason`, 2026-10-21). The default labels `duplicate`, `invalid` and `wontfix` say the same thing
  less well.
- **GitHub's other issue fields in NobleFactor,** Effort, Start date and Target date: outside the model until a need
  appears. The plan's question 14.
