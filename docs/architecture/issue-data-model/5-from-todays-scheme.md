---
title: "5. From today's scheme"
---

# 5. From today's scheme

The owner, 2026-10-21: "The task list should be based on what we see are the deltas between what we have and what we
want. We will produce the task list after we have some clarity on the data model. The schedule for this work cannot
result in downtime for other activities that are underway. We should plan PRs around that constraint." And: "migration
must be managed carefully." On 2026-10-22 the plan's phases became a sweep of five iterations, each ruling what it
needs and shipping before the next; this section is rewritten to the rulings of 2026-10-21 and 2026-10-22 and says
which deltas are already closed.

## The line that protects the running sessions

What the sessions read: `star github schedule report` and `audit`, through the kind labels, the `**Feature:**` and
`**Chore:**` markers and the lane tables; Start-Claude, keyed by a schedule's issue number; and the label set.
Anything added beside those breaks nothing: issue types, sub-issue links, projects, the asset, `pull`, tooling that
reads the new form before the old. What breaks a session is removing a label or a marker, replacing a lane table with
rows, or renaming. So every iteration ships its additive half when it is ready, and its subtractive half waits for
the switch, taken when the affected sessions are between lanes.

## The deltas

| Today | The model | State on 2026-10-22 |
| --- | --- | --- |
| Five kinds as labels: epic, feature, task, bug, chore; a chore is a leaf | GitHub's issue type, five values with a level each, Epic, then Feature or Chore, then Task or Bug ([section 1](1-hierarchy.md)); the kind labels are scaffolding until the switch | **The five types exist in the organization with `Level N:` in their descriptions**, Epic and Chore made 2026-10-22; no issue carries a type yet; the labels still drive the report, and chore is tier two in the standard since #370 |
| Today's enabler features under `Epic:Ops:Process`, and the chores filed under them | Chores, and tasks under them; the 67 chores carrying a `**Feature:**` marker become tasks or move, by the owner's rule of 2026-10-21 | the inventory is drawn; the moves are #363, lane 6 |
| Every issue carries an `Epic:<Name>` label, kept only where its epic is hosted, `Epic:Ops:Process` excepted | No epic label: an issue's epic is read up its parents | the labels stay until the switch |
| The `**Feature:** #N` marker, the last one in the body | GitHub's sub-issue link, one parent one level up, which crosses repositories and owners ([section 4](4-storage-and-reach.md)) | **In use**: 66 of noblefactor-engprod's 89 open issues carried a link on 2026-10-21; crossing proven 2026-10-22; the markers, `**Chore:**` added by #370, stay until the switch |
| `Epic:Ops:Process`, #142, the home of every chore that serves no other epic, never closes | **The triage epic**: the parent of every newly logged issue until triage places it, row 0 of engprod's Triage project ([section 1](1-hierarchy.md) § Triage) | ruled 2026-10-22; its 90 issues drain to the epics they serve or stay as untriaged |
| The `Ops:` prefix marks tooling | Chore against feature marks it; the prefix has nothing left to mark | the labels stay until the switch |
| A bug awaiting triage has no feature and no epic, and the audit exempts it | An issue is fully classified or it is not; the untriaged are the sub-issues of a triage epic, found by query, and the Triage project holds those sent for review | ruled 2026-10-21 and 2026-10-22 |
| A thread: a `Thread:<Name>` label on each member, a beat table in the thread's issue, members are leaves | A Thread project; its rows are features and chores; its row 0 an Epic ([section 3](3-collections.md)) | ruled; iteration 3 |
| A schedule: a `Schedule:` chore whose body holds a lane table; lanes are leaves numbered 1 to N | A Schedule project; row 0 its own issue, typed Epic, holding the deliverable, the amendments and the owner's status; lanes 1 to N its tasks and bugs | row 0 as an Epic ruled 2026-10-22; the rest iteration 3, questions 6 to 9 |
| A lane's Waits on: text in the table | GitHub's blocked-by link | iteration 3 |
| A "Schedule: #N, lane N" footer on a lane's issue | Nothing: the row says it | the switch |
| `Severity:`, `Priority:` and `Area:` labels in devlore-cli only | Every participating repository, from the asset's tiers; Severity on bugs only ([section 2](2-attributes.md)) | iteration 4, questions 11 and 14 |
| GitHub's default labels, `documentation` to `wontfix`, in every repository | Removed; `duplicate`, `invalid` and `wontfix` become close reasons, GitHub's three being completed, not planned and duplicate | iteration 4 |
| The labels file on #320's branch, under `docs/architecture/issue-labels/` | **`model.yaml` beside the star extension**: types with levels and ids, labels in three tiers, projects with fields and option ids, a digest; the ETag cache under `XDG_CACHE_HOME` ([section 6](6-the-asset-and-its-sync.md)) | **The first pull exists**, by hand, 2026-10-22: the five types and the hub's 21 labels; no projects, no tiers, no attributes yet |
| `star github labels sync` and `labels audit`, from the labels file | `star github model pull` from the organization's record, `push` to the organization and to named repositories, `audit`; every `star github schedule` operation reads the record first, by ETag | iteration 1 and 2 tooling, under #332 |
| Participation: writ's layer list says which repositories the report reads | A repository is in when a schedule, a thread, a filing or `--repo` names it, and participation is proven at filing and at adding a row, by its labels against the asset | ruled 2026-10-22 |
| One organization repository and one user repository, personal, treated alike | The organization defines, a team owns, a repository carries; personal keeps labels synced one way from the organization's record, and its parents are real sub-issue links | ruled 2026-10-22 |
| The report and the audit read labels, markers and body tables | They read the type, the link and the rows first; the labels, markers and tables second until the switch, then not at all | iteration 1 tooling, under #332 |
| [issue-standards.md](../../issue-standards.md) states the old scheme, with chore as tier two since #370 | It states the model | each iteration writes what it ships; iteration 5 the whole |

## What must keep running

Underway on 2026-10-22, and in use by sessions that cannot stop for this work:

- `star github schedule report` and `star github schedule audit`, and the star-github-schedule-progress and
  star-github-schedule-assignment skills that run them, from the five schedule sessions on four machines;
- the lane tables of the schedules being worked, noblefactor-engprod#346, noblefactor-engprod#301, devlore-cli#916,
  devlore-cli#949 and devlore-cli#1127;
- the labels in use, every `Epic:` and `Thread:` label among them;
- Start-Claude's sessions, keyed by their schedule's issue, under the old repository name, which the extension reads
  as the new since #372.

## The order, as the iterations

The six steps hold; the sweep's iterations are how they are cut. Each is its own pull requests, and none takes away
what a running session reads before the switch.

| Step | Iteration | What it now contains |
| --- | --- | --- |
| 1. Documents | every iteration, first | this design and its plan, revised to each iteration's rulings; issue-standards.md gains what each iteration ships |
| 2. Tooling that reads both | 1 | the asset read by the extension, its types as levels; `pull` and the read before every operation; the report and audit placing an issue by type and link first, label and marker second; `push` for personal in iteration 2 |
| 3. New data beside the old | 1, 2, 3 | every open noblefactor-engprod issue typed and linked, labels and markers kept (iteration 1); the two Triage projects, the `engprod` team and the devlore triage epic (2); the Schedule and Thread templates and #301 as the prototype, lane tables kept as the copy of record (3) |
| 4. Migration, one repository at a time | 1 and 4 | #363's reclassification, the chores under features re-parented, every leaf under its parent, the audit confirming each repository before the next (1); devlore-cli's attribute labels pulled into the asset and pushed everywhere (4) |
| 5. The switch | 5 | the report and audit read the new form by default, the old still there to fall back on |
| 6. The old scheme retired | 5, last | the kind labels, the `Epic:` and `Thread:` labels, the markers, the lane tables and the footers, one repository at a time, each confirmed by the audit, on a date when the sessions are clear |

The task list is drawn from the deltas above, iteration by iteration, as each iteration's rulings land; iteration 1's
is in [the plan](../../plans/chore/303-issue-data-model.md).
