---
title: "1. The hierarchy"
---

# 1. The hierarchy

Every NobleFactor issue has a place in one hierarchy: its Type says which level it is on, and its parent says where on
that level it hangs. The owner, 2026-10-21: "Every issue must be fit into this hierarchy of issue types."

## Type

The owner, 2026-10-21: "Our Issue Type hierarchy includes these classifiers: Epic, (Chore | Feature), and (Bug |
Task). Note the mutual exlusivity and not that it has changed."

| Level | Type | What it is |
| --- | --- | --- |
| 0 | Epic | A body of work with an owner; the root every other issue rolls up to |
| 1 | Feature | Product value: what the people who use what we build receive |
| 1 | Chore | Engineering value: what the team that builds it receives, in tooling, process and pipelines |
| 2 | Task | Planned work: a step in delivering a feature or a chore |
| 2 | Bug | Unplanned work: a defect, found rather than planned |

A triaged issue has exactly one Type. The pairs are mutually exclusive: an issue is a feature or a chore, never both,
and a task or a bug, never both. The split between feature and chore, and between task and bug, follows the write-up
by Gemini the owner shared on 2026-10-21: product value against engineering value, planned work against unplanned.

**What changed.** Today's scheme has five kinds on three tiers, and a chore is a leaf beside a task and a bug, filed
under the enabler features of `Epic:Ops:Process` ([issue-standards.md](../../issue-standards.md) § The process epic).
Here a chore is on level 1, a peer of a feature, and the leaves are tasks and bugs. Today's enabler features become
chores, NobleFactor/noblefactor-ops#151 (agent schedules) and #156 (issue standards) among them, and today's chores
become tasks, #303 and #321 among them.

**The `Ops:` prefix** marks the tooling axis today ([issue-standards.md](../../issue-standards.md) § The Ops axis).
Chore against feature now says the same thing, so the prefix has nothing left to mark.

**The name, ruled.** The owner named the field Type and invited alternatives; labels were the other candidate. Ruled
2026-10-22: "we are building a 3-tier hierarchy modeled with the parent-child relation between issues, so yes. Our hierarchy is based on epics that contain chores and features that contain bugs and tasks. It is a very specific hierarchy based on Issue Type." Type is GitHub's issue-type field, which NobleFactor already has with Task, Bug and Feature
enabled; Epic and Chore are added to it as types of the organization's own. The kind labels of today's scheme are
scaffolding on the way there ([section 5](5-from-todays-scheme.md)). What personal does, which GitHub's types do not
reach, is [section 4](4-storage-and-reach.md)'s remaining question.

## Parents

- Every issue but an epic has exactly one parent, one level up: a feature or a chore under an epic, a task or a bug
  under a feature or a chore. Nothing skips a level, and a task or a bug is no issue's parent. The parent is GitHub's
  own parent-child relation between issues, the sub-issue link: ruled 2026-10-22, "a 3-tier hierarchy modeled with the
  parent-child relation between issues". It was already in use that day: 66 of noblefactor-ops's 89 open issues
  carried one, #266 holding 43 under #142.
- An issue's epic is not a label of its own. The owner, 2026-10-21: "epic is NOT a label, but ... a peer of
  `feature`, (`bug`|`chore`|`task`). It is a value that you assign to `kind`." An issue's epic is read from its
  parents, and the `Epic:<Name>` labels retire.
- Parents cross repositories: features do today, and personal's issues hang under NobleFactor's features. Where the
  link is kept, and whether GitHub's own link can cross, is [section 4](4-storage-and-reach.md).

## Triage

The owner, 2026-10-21: "we need the triage queue. Bugs are unplanned and must be logged without knowledge of where it
fits into the hierarchy." Then: "It seems we must allow that bugs get filed without any ceremony. they are classified
by a triage "team"."

The owner, 2026-10-21, ruling the plan's question 4: "we fully classify the issue or not and allow that any issue can
be added to the Triage project. Issues sent for review by triage are those added to the Triage project. The Triage
project is a little like a Schedule or a Thread, but it allows any issue type: Epic, (Chore | Feature), (Bug | Task),
or no Issue Type. We can always search for specific issues based on no:type, no:parent-issue, etc. These issues can be
periodically added to the Triage project."

- An issue is fully classified or it is not. Fully classified is a Type and, for any level but an epic, a parent one
  level up that is not the triage epic. An issue with no Type, or with no parent, or with the triage epic as its
  parent, is untriaged, and whoever files it does nothing more.
- The untriaged are found by query, GitHub's own: `no:type`, `no:parent-issue`, and the audit's reading of both. On
  2026-10-21, `is:open no:parent-issue` found 23 of noblefactor-ops's 89 open issues.
- What is sent for review is what is added to the **Triage project**, the third collection of
  [section 3](3-collections.md): any issue, of any Type or none, added by a person who wants it looked at, or
  periodically from the queries. An issue leaves it classified, or closed with a reason.
- Triage gives an issue its Type and its parent and, for a bug, its severity ([section 2](2-attributes.md)).
- The parent rule binds classified issues. The audit exempts untriaged ones and reports how long each has waited.
  Today's standard already exempts "a bug awaiting triage"; this keeps that and extends it to an issue filed with no
  Type at all.
- One standing epic holds the unplaced: the **triage epic**, #142, which the owner called "basically our triage epic"
  on 2026-10-21 and ruled on 2026-10-22: "We need a triage epic. it is the place to put all new logged issue, pending assignment to a place in our issue hierarchy. It should be added as row zero in the schedule that represents the triage project. We can use this to guide the work and--maybe--facilitate handoffs." A newly logged issue that nobody can yet place is filed as a
  sub-issue of #142 and so is never without a parent; triage re-parents it to the feature or chore it serves, or to
  the epic it serves if it is a feature or chore itself. #142 is row 0 of the Triage project
  ([section 3](3-collections.md)). The 90 issues it held on 2026-10-21 drain the same way, each to its real parent.
  The plan's question 3, closed; the `no:parent-issue` query therefore finds nothing filed by the tooling, and the
  untriaged are the sub-issues of #142.
- **Teams triage their own issues.** Ruled 2026-10-22: "Teams triage their issues. I happen to be on every team. If devlore-cli logs issues against noblefactor-engprod, they should log a tracking issue or retain ownership of the issue on noblefactor-engprod. So keep the issue on your plate or move it and maybe track it on another team's triage schedule." So the triage team of a repository is the team that owns
  it, holding the Triage role there; each team has its own Triage project with its own triage epic as row 0, #142
  being engprod's; and an issue one team finds against another's repository is filed there, under that repository's
  triage epic, the finder keeping a tracking issue of its own or simply letting it go. The owner is on every team
  today, so every triage queue is one person's until a team is more than one. The plan's question 4, closed.

## How long a level lives

Today an epic closes when its features ship, except `Epic:Ops:Process`, which never closes
([issue-standards.md](../../issue-standards.md) § The process epic). Two proposals bear on that.

- **Long-lived level 1,** from the Gemini write-up: a feature or a chore stays open for the life of what it delivers,
  and a bug found in shipped work is parented to the original, so that a capability's whole cost, and its ratio of
  bugs to tasks, can be counted. That changes what "done" means for a feature: the plan's question 2.
- **A standing engineering epic:** every chore needs an epic, and the work of engineering never ends. #142, Epic:
  Process, which never closes today, renamed for engineering; NobleFactor/noblefactor-ops#304 already proposes that
  noblefactor-ops become "the repository of NobleFactor Engineering Productivity". The plan's question 3.

## What the hierarchy does not hold

Order, and the collections that cut across it: threads and schedules are [section 3](3-collections.md). An issue's
attributes are [section 2](2-attributes.md).
