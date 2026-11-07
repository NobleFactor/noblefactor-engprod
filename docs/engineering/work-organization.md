---
title: "Work organization"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Work organization

[Up: Engineering](index.md)

<a id="work-and-identity"></a>

## 1. Work and identity

In a schedule, we resolve bugs and complete tasks that shape features within an epic’s scope in a GitHub repository. The bugs and tasks scheduled for execution are work items; each is tracked as an issue.

Use a repository-qualified reference, `owner/repository#number`, wherever a bare number is ambiguous. A schedule issue is the GitHub issue containing the schedule. It organizes work; it is not one of its own scheduled tasks.

An epic defines a body of work. A feature describes a capability within that scope. Tasks implement parts of it; bugs repair behavior it should already provide. Product and engineering work use the same hierarchy: Epic → Feature → Task/Bug. Distinguish their purpose through the owning epic or area, not a separate chore tier. Most engineering-productivity work is recorded in `NobleFactor/noblefactor-engprod`; other repositories may use their own epic. Recommend an `engprod` epic for engineering-productivity work where appropriate, without requiring that exact name everywhere. Migrate existing chore issues explicitly into this hierarchy, preserving their work and relationships; schedule-container representation remains a separate issue-model decision. Retaining a `chore/` Git branch prefix does not retain Chore as an issue tier. This documentation change does not bulk-reclassify GitHub records. Schedules may draw issues from multiple features, epics and repositories.

A thread describes a scenario whose parts cross features or repositories. It is another view of work, not a unit of execution. Historical issue and thread classification is preserved in [the retained classification text](review/issue-classification.md). Its former chore tier is superseded by O02; GitHub field representation and migration are deferred.

<a id="schedule-commitment"></a>

## 2. Schedule commitment

A schedule states its deliverable as before → after: what exists now and what will exist when its issues are complete. It orders repository-qualified task and bug issues and identifies their dependencies. Positions are numbered 1..N without gaps; completed issues retain their positions so the record of progress remains legible.

Once committed, execute the declared order. Adding, splitting, removing or reordering scheduled work, or changing the deliverable, requires owner approval. A blocking discovery does not waive this requirement. Record the approved amendment and its consequences before affected execution resumes.

Keep the current worktree, state, dependencies, PR and completion evidence current as changes occur. Update the recorded worktree when work moves, record a PR merge when it lands, and state the actual reason when an issue closes without delivery. A closed bug/task is not automatically evidence that the promised result was delivered.

The [schedule template](../templates/schedule.md) proposes the record's shape. Before adopting its proposed Position/Issue header, resolve the compatibility items in the [conflict register](review/conflicts.md#schedule-format-compatibility). Publication of a header does not change a deployed parser.

**Case:** Two schedule rows continued to name an in-progress worktree after closure and merge had removed it, leaving the Owner and sessions with false progress ([recorded case, rule 19](review/sources/agent-rules.txt)).

<a id="changing-scheduled-work"></a>

## 3. Changing scheduled work

The process supports changes in the shape of a job. Engineers must be able to create schedules, add work items, log discovered issues for triage, and move work items between schedules in a coordinated fashion. These are normal operations, not evidence of planning failure.

Changes to a committed schedule require Owner approval. Record the proposed change, its effect on the promised outcome and dependencies, and the approval. Update affected plans and schedule records so they describe the revised work rather than preserving an obsolete commitment.

Before transferring a work item, identify its source and destination schedules, execution responsibility, current worktree and state, and any affected dependencies. Coordinate with the affected workers under the approved communication boundaries and keep them informed as the change occurs. Do not leave the work item assigned to two schedules or surprise a worker with a changed mission. Detailed issue-tracking mechanics remain separate tooling work.

<a id="overlap-and-coordination"></a>

## 4. Overlap and coordination

Schedules can overlap. Discovering overlap requires notifying the owner before either worker changes scope, ownership or execution order. State the shared issue or affected code, current owners, dependency and proposed coordination.

No two schedules may contain the same work item. Schedules may overlap in the code, features or dependencies they affect, but that overlap does not permit duplicate work-item membership. A transfer must be coordinated so responsibility is unambiguous and the affected workers are not surprised.

Overlap does not authorize duplicate writes or cross-worker messages. The Owner approves bounded cross-worker conversations under [Agent operation](agent-operation.md). Any resulting mission change requires its own approval.

<a id="discoveries-and-blockers"></a>

## 5. Discoveries and blockers

Log discovered work when found and link it from the current plan. State whether it blocks the approved outcome, where it should be handled and what decision is required. New nonblocking work belongs on a later schedule unless an amendment is approved.

A blocker prevents proceeding with approved work; severity or annoyance alone does not establish a blocker. Stop affected work, preserve the worktree and unfinished changes, and record state, evidence and the dependency. Propose whether the blocker needs its own worktree or is inseparable from the current work. Consult the owner before acting on a defect in another worker's or PR's scope.

Do not work around an external blocking defect merely to claim progress. Do not change the running schedule, discard work or take over another worker's responsibility without approval.

<a id="persistent-assignments"></a>

## 6. Persistent assignments

An owner-supervised worker receives a schedule as its mission. A persistent session works through that schedule's issues; it is not replaced merely because the next issue begins. Resumption restores the assignment and its current approved state. Terminal lifetime, agent-session lifetime, issue state and work completion are distinct. See the [session model](../architecture/agent-schedule/1-session-model.md) for the existing conversation, background-session and viewer lifecycles; that implementation document does not grant additional process authority.
