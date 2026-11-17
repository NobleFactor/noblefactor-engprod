---
title: "Work organization"
status: draft
created: 2026-10-28
updated: 2026-11-17
---

# Work organization

[Up: Engineering](index.md)

<a id="work-and-identity"></a>

## 1. Work and identity

Issues describe the work; schedules order its execution. [Issue standards](../issue-standards.md) owns classification, parent relationships, account fields and labels, and project membership. Product and engineering work use its common Epic → Feature → Task/Bug hierarchy. An issue's Area describes its own work rather than inheriting its parent's Area.

Use a repository-qualified reference, `owner/repository#number`, wherever a bare number is ambiguous. A Schedule issue records the deliverable and exit criteria; the tasks and bugs committed to that schedule are its steps. The Schedule issue's own project row has no Step. Epics and features retain their ownership relationships rather than becoming executable steps.

A scenario describes an end-user goal to walk through. Its Scenario project records the tasks and bugs found while walking it. Scenario beats and Schedule steps are different records. A discovered issue moves from the scenario to triage or, after classification and Owner approval of any committed-schedule amendment, onto a schedule. Use `star github issue move <issue> --triage --reason <text>` or `--schedule <schedule> --reason <text>` for that move. It writes a comment on the Scenario issue and a `Left #N on <date> for <destination>` line in the item's body, then changes project membership. A closed finding leaves the scenario; until recurring automation (#593) is delivered, remove its row manually and verify the result, following the scenario representation below. Follow the [scenario representation](../issue-standards.md#scenarios); the retired Thread labels and issue-body beat tables are historical.

A schedule may draw tasks and bugs from several features, epics and repositories within its account. Cross-account dependencies use a stand-in issue in the schedule's account, under [Issue placement](../issue-standards.md#placement). A concern shared by two schedules does not permit assigning the same work item to both.

<a id="schedule-commitment"></a>

## 2. Schedule commitment

A schedule states its deliverable as before → after: what exists now and what will exist when the committed work is complete. Its exit criteria describe observable completion evidence.

The team's Schedule project holds the authoritative execution records. Its Schedule field selects the schedule, Step orders the tasks and bugs, Status records progress, and Worktree links the branch holding each step's work. Dependencies are GitHub blocked-by links. Step numbers run from 1..N without gaps; insertions, moves and removals renumber later closed and open steps together. The Schedule issue links the board filtered to its option. It does not maintain a second authoritative step table or a Next column.

Once committed, work follows step order and its dependencies. The Owner may approve additions, splitting, removal, reordering or a changed deliverable as understanding develops. Use `star github issue move` with the required `--reason` carrying the Owner's approval; it records the amendment and its consequences on each affected Schedule issue. Read the resulting rows and amendment before affected execution resumes. These changes are ordinary planning work; discovery of a needed change is a reason to explain and revise the commitment.

Keep records current when work starts, moves, merges or closes. Push the branch before linking it from Worktree. Record a merge on the step's own issue as it lands; if an issue closes without delivery, record why. Apply guarded writes and readback under the [PR procedure](procedures/pull-request.md), and preserve [completion milestones](process.md#completion-and-progression) separately from merge.

The [schedule template](../templates/schedule.md) records the deliverable, ownership, board link, amendments and document links. Read the current rows with `star github schedule get <schedule>`; discover schedules with `star github schedule list <account>`, using `--team <slug>` for one organizational team. The [issue-model representation](../issue-standards.md#schedules) defines its project fields. Templates do not replace those project records.

**Case:** Two schedule rows continued to name an in-progress worktree after closure and merge had removed it, leaving the Owner and sessions with false progress ([recorded case, rule 19](review/sources/agent-rules.txt)).

<a id="changing-scheduled-work"></a>

## 3. Changing scheduled work

Changes in the shape of a job are expected. Engineers may propose schedules, additions, new issues and coordinated transfers. The Owner approves changes to committed scope and order.

Record the proposed change, its effect on the promised outcome and dependencies, and the Owner's approval. Update affected plans and schedule records together. Use `star github schedule new <repository> <name>` to create the Schedule issue, option and own row from the account's form. Use `star github issue move <issue>... --schedule <schedule> --reason <text>` to add or transfer work, with `--after`, `--blocked-by` or a receiving team's `--assignee` when needed; [Issue standards](../issue-standards.md#schedules) records the current scheduling interface and representation.

Before a transfer, identify the source and destination schedules, execution responsibility, worktree, state and affected dependencies. Use `star github issue move --schedule <destination> --reason <text>` to coordinate project membership and record an amendment on each schedule. Keep the affected workers informed through approved conversation boundaries. Do not leave an issue assigned to two schedules or surprise a worker with a changed mission.

<a id="overlap-and-coordination"></a>

## 4. Overlap and coordination

Schedules may affect the same code, features or dependencies. Notify the Owner before either worker changes scope, ownership or order. Identify the overlap, current responsibilities and proposed coordination.

Overlap does not authorize duplicate writes, duplicate work-item membership or cross-worker messages. The Owner approves conversations under [Agent operation](agent-operation.md#owner-supervised-agents-conversations). Any resulting assignment or schedule amendment requires its own approval.

<a id="discoveries-and-blockers"></a>

## 5. Discoveries and blockers

Log discovered work when found and link it from the current plan. State whether it blocks the approved outcome, where it belongs and what decision is needed. New nonblocking work goes to triage or a later schedule unless the Owner approves adding it to the current commitment. Use `star github issue move --triage` or `--schedule`, with `--reason`, for a supported move of an existing issue; the Triage workflow initially places newly filed issues, except Schedule and Scenario issues and findings routed to a scenario.

A blocker prevents proceeding with approved work; severity or annoyance alone does not establish a blocker. Stop affected work, preserve the worktree and unfinished changes, and record state, evidence and the dependency. Propose whether the blocker needs its own worktree or is inseparable from the current work. Consult the Owner before acting on a defect belonging to another worker or PR.

Do not work around an external blocking defect to claim progress. Approval is required before changing the committed schedule, discarding work or taking over another worker's responsibility.

<a id="persistent-assignments"></a>

## 6. Persistent assignments

An Owner-supervised worker receives a schedule as its mission. Its persistent assignment identifies the current issue, plan, repository and worktree. Resumption restores that assignment and its approved state; advancing to another issue does not itself require replacing the conversation.

Role, assignment, native conversation and terminal attachment identify different things. The [workstation architecture](https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/architecture/agentic-developer-workstation.md#41-persistent-specialists) describes the five specialist roles and their persistent conversations. Role definitions and host entrypoints are subsequent work on the handbook-adoption schedule; this handbook does not claim that they have been implemented or qualified.

Apply [Agent operation](agent-operation.md) when restoring context and authority. A new terminal, reconnection or resumed host does not grant a new assignment or additional permission.
