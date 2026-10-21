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

**The name.** The owner named the field Type and invited alternatives. Type is GitHub's own name for its issue-type
field, which NobleFactor already has, with Task, Bug and Feature enabled. If the model's Type is GitHub's, Epic and
Chore are added to it as types of the organization's own. If it is a label family, it is better called Kind, today's
word, so that it is never mistaken for GitHub's Type in the same sidebar. [Section 4](4-storage-and-reach.md) says why
the choice turns on personal. The plan's question 1.

## Parents

- Every issue but an epic has exactly one parent, one level up: a feature or a chore under an epic, a task or a bug
  under a feature or a chore. Nothing skips a level, and a task or a bug is no issue's parent.
- An issue's epic is not a label of its own. The owner, 2026-10-21: "epic is NOT a label, but ... a peer of
  `feature`, (`bug`|`chore`|`task`). It is a value that you assign to `kind`." An issue's epic is read from its
  parents, and the `Epic:<Name>` labels retire.
- Parents cross repositories: features do today, and personal's issues hang under NobleFactor's features. Where the
  link is kept, and whether GitHub's own link can cross, is [section 4](4-storage-and-reach.md).

## Triage

The owner, 2026-10-21: "we need the triage queue. Bugs are unplanned and must be logged without knowledge of where it
fits into the hierarchy." Then: "It seems we must allow that bugs get filed without any ceremony. they are classified
by a triage "team"."

- An issue with no Type, or with no parent, is untriaged. Whoever files it does nothing more.
- The triage queue is the set of untriaged issues: a query, not a place. A standing triage chore was considered and
  set aside, since something would have to attach each new bug to it, which is ceremony done by a machine instead.
- Triage gives an issue its Type and its parent and, for a bug, its severity ([section 2](2-attributes.md)).
- The parent rule binds triaged issues. The audit exempts untriaged ones and reports how long each has waited.
  Today's standard already exempts "a bug awaiting triage"; this keeps that and extends it to an issue filed with no
  Type at all.
- The triage team is open: the plan's question 4.

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
