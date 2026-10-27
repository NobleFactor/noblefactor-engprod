---
title: "Issue data model — one hierarchy, its attributes, and the collections that order it"
---

# Issue data model — one hierarchy, its attributes, and the collections that order it

> **Status:** draft, 2026-10-21, for the owner's review; nothing in it is ruled. The work:
> [NobleFactor/noblefactor-ops#303](https://github.com/NobleFactor/noblefactor-ops/issues/303), a chore under issue
> standards, [NobleFactor/noblefactor-ops#156](https://github.com/NobleFactor/noblefactor-ops/issues/156). The
> [plan](../../plans/chore/303-issue-data-model.md) holds the owner's words, each quoted with its date, and the open
> questions.

The owner, 2026-10-21: "the data model goes into the epic around issue tracking. there are two technical sides: the
GitHub data model and the tooling (star gh). and migration must be managed carefully." This design is the first
technical side, the data model. The second, the star github extension that reads and enforces it, gets a design of its own
once this one is ruled. The migration between today's scheme and the model is [section 5](5-from-todays-scheme.md). The
epic, filed 2026-10-21, is [Epic: Issue tracking, #330](https://github.com/NobleFactor/noblefactor-ops/issues/330): this
design is its feature [#331](https://github.com/NobleFactor/noblefactor-ops/issues/331), the tooling is
[#332](https://github.com/NobleFactor/noblefactor-ops/issues/332), and the rollout, which carries the migration and the
rename of noblefactor-ops to noblefactor-engprod, is [#333](https://github.com/NobleFactor/noblefactor-ops/issues/333).

What every NobleFactor issue is, what it carries, and how it is ordered: the model `star github` will read, the audit will
enforce, and [issue-standards.md](../../issue-standards.md) will state once it is ruled. It replaces the scheme that
document states today, where an issue's place is a kind label, an `Epic:<Name>` label and a `**Feature:**` marker, and
threads and schedules are tables in issue bodies.

In one paragraph: an issue has one Type, Epic, then Feature or Chore, then Task or Bug, and one parent one level up,
except an epic. An issue with no Type or no parent is untriaged, and the triage queue is the set of them. Its
attributes, Severity for a bug, Priority and Area, are labels defined once in noblefactor-ops. Threads and schedules
are GitHub projects: a thread orders features and chores to tell a use case, and a schedule orders tasks and bugs in
the order they are worked.

## Sections

| Section | What it holds | Status |
| --- | --- | --- |
| [1. The hierarchy](1-hierarchy.md) | Type and its five values, the three levels, parents, triage, and how long a level lives | [Draft](1-hierarchy.status.md) |
| [2. Attributes](2-attributes.md) | Severity, Priority and Area: what an issue has on its own, outside any collection | [Draft](2-attributes.status.md) |
| [3. Collections](3-collections.md) | Threads, schedules and the Triage project as GitHub projects: who joins which, rows and lanes, the collection's own record, ownership | [Draft](3-collections.status.md) |
| [4. Storage and reach](4-storage-and-reach.md) | Where each part lives in GitHub, what enforces it, and which repositories it reaches | [Draft](4-storage-and-reach.status.md) |
| [5. From today's scheme](5-from-todays-scheme.md) | The deltas the task list is drawn from, and the order that keeps running work running | [Draft](5-from-todays-scheme.status.md) |
| [6. The asset and its sync](6-the-asset-and-its-sync.md) | `model.yaml` beside the extension, `star github model pull` and `push`, the ETag read before every operation | [Ruled](6-the-asset-and-its-sync.status.md) |
| [7. The workflow, before and after](7-the-workflow-before-and-after.md) | Why this epic: filing an issue, writing a schedule and reporting progress, as a session does them today and once the model is in | [Written](7-the-workflow-before-and-after.status.md) |

## Terms

- **Type:** the hierarchy's classifier. Its values are Epic, Feature, Chore, Task and Bug, and a triaged issue has
  exactly one. Whether it is GitHub's own issue type or a label family is open (the plan's question 1).
- **Level:** an issue's depth in the hierarchy: 0 for an epic, 1 for a feature or a chore, 2 for a task or a bug.
- **Parent:** the issue one level up. An epic has none.
- **Untriaged:** an issue with no Type or no parent: not fully classified. The queries find them; the Triage project
  holds those sent for review (ruled 2026-10-21).
- **Attribute:** something an issue has on its own, outside any collection: its severity, its priority, its areas.
- **Collection:** a GitHub project that gathers issues for a purpose: a thread, a schedule, or the Triage project.
- **Triage project:** the one collection any issue may join, of any Type or none, for review.
- **Thread:** a collection of features and chores that tells a use case.
- **Schedule:** a collection of tasks and bugs in the order they are worked.
- **Row, lane:** an issue's place in a collection. A lane is a schedule's row, numbered in the order it is worked.
- **The organization's repositories:** NobleFactor's, which GitHub's organization features reach.
- **personal:** David-Noble-at-work/personal, a user's repository, which they do not reach.
- **The asset:** `model.yaml` beside the star extension: the model as the tooling reads it, pulled from GitHub and
  pushed to repositories ([section 6](6-the-asset-and-its-sync.md)).
