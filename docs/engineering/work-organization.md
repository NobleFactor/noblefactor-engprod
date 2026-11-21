---
title: "Work organization"
status: draft
created: 2026-10-28
updated: 2026-11-21
---

# Work organization

[Up: Engineering handbook](index.md)

<a id="work-and-identity"></a>

## 1. Work and identity

Issues describe work; schedules order execution. [Issue standards](../issue-standards.md) owns classification, native parents, account fields/labels and project membership. Product and engineering work share Epic → Feature → Task/Bug. An issue's Area describes its own work rather than inheriting its parent's Area.

Use `owner/repository#number` when a bare number is ambiguous. A Schedule issue records its deliverable and exit criteria. Its Tasks/Bugs occupy ordered Steps; the Schedule's own project row has no Step. Epics and Features keep their ownership relationships.

A Scenario records an end-user goal and walk. Its project contains findings, each associated with its Beat. Beats identify discovery within the walk; Schedule Steps identify execution order.

Move classified findings to Triage or an approved Schedule through `star github issue move`, with the destination and required `--reason`. The command records the move on the Scenario and adds a `Left #N on <date> for <destination>` line to the finding before changing membership. Closing a finding through `star github issue close` records its closure on the Scenario and removes its row. Closure through GitHub or a PR reference leaves that work to be completed: rerun issue close for its supported repair, or remove the closed finding row under the [cleanup procedure](../architecture/issue-data-model/9-the-scenario-commands.md#ongoing-cleanup), then verify the result. Preserve the Scenario's own row and option, open findings, and origin/closure evidence. [Recurring cleanup (#593)](https://github.com/NobleFactor/noblefactor-engprod/issues/593) is separate work.

A Schedule can span Features, Epics and repositories within its account. Use a [stand-in issue](../issue-standards.md#placement) for cross-account dependencies. Shared concerns do not permit putting one work item in two schedules.

<a id="schedule-commitment"></a>

## 2. Schedule commitment

State the deliverable as before → after and define observable exit evidence.

The team's Schedule project owns execution records: Schedule selects the commitment, Step orders Tasks/Bugs, Status records progress, Worktree links the branch, and native blocked-by relationships record dependencies. Steps run from 1..N; insertions, moves and removals renumber open and closed rows together.

The Schedule issue links the project filtered to its option. Do not maintain a competing step table or Next column.

Follow Step order and dependencies. The Owner can approve additions, splits, removals, reordering or a changed deliverable. Use the supported move operation with `--reason` recording that approval; it records amendments and consequences on affected Schedule issues. Read back rows and amendments before resuming affected work.

Update records when work starts, moves, merges or closes. Push before linking Worktree. Record each merge on the step's issue; explain closure without delivery. Follow guarded writes/readback under the [PR procedure](procedures/pull-request.md) and preserve [completion milestones](process.md#completion-and-progression).

The [Schedule template](../templates/schedule.md) records deliverable, assignments, board link, amendments and documents. Use `star github schedule get <schedule>` for current rows and `star github schedule list <account>` for discovery, with `--team <slug>` for one organizational team.

<a id="design-schedules"></a>

### 2.1. Design schedules

Every design runs on an Owner-approved schedule with at least two issues: one for the design and its architecture decisions, and a separate issue for the roadmap. Preserve each issue's native Feature/Epic ownership. These are ordinary work issues, not new issue types.

Group the design work under an [enabler Feature](../issue-standards.md#enabler-features) belonging to the related Epic. Its deliverables are the design, Architecture decisions and roadmap. The [design-schedule template](../templates/design-schedule.md) defines that Feature and the two common Task bodies with their completion evidence. The [Start a design schedule skill](../../skills/start-design-schedule/SKILL.md) applies that template through the existing GitHub commands; the template owns content and the account forms own field labels.

The design schedule identifies the problem, scope, assigned Designer and completion evidence. The Designer produces those assets directly; a plan for writing the design is not a prerequisite. The Planner helps establish the schedule, then uses the accepted design and roadmap to propose implementation issues, their plans and one or more implementation schedules. The Planner remains a consultant as the work evolves.

<a id="changing-scheduled-work"></a>

## 3. Changing scheduled work

Changes in work shape are expected. Engineers propose schedules, issues, additions and coordinated transfers; the Owner approves committed scope/order changes.

Record the proposal, effect on outcomes/dependencies and approval. Update affected plans and project records together. `star github schedule open <repository> <name>` creates the Schedule issue, option and own row from its account form; `create` is an alias. `star github issue move <issue>... --schedule <schedule> --reason <text>` adds or transfers work. Use supported `--after`, `--blocked-by` and receiving-team `--assignee` options when needed.

Before transfer, establish both schedules, responsibility, worktree, state and dependencies. Record an amendment on each affected schedule and inform workers through approved conversation boundaries. Verify that the issue has one destination Schedule and no worker's mission changed without notice. [Issue standards](../issue-standards.md#schedules) owns the interface and representation.

<a id="overlap-and-coordination"></a>

## 4. Overlap and coordination

Before changing scope, ownership or order around overlapping code, Features or dependencies, notify the Owner. Identify current responsibilities and propose coordination.

Overlap grants no duplicate writes, duplicate schedule membership or cross-worker messaging. [Conversation approval](agent-operation.md#owner-supervised-agents-conversations) names participants and topic; resulting assignment or schedule changes retain their own approval boundary.

<a id="discoveries-and-blockers"></a>

## 5. Discoveries and blockers

Log discovered work when found and link it from the relevant design, roadmap or plan. State ownership, whether it blocks the approved result and what decision is needed. Nonblocking work goes to Triage or a later Schedule unless the Owner adds it to the current commitment.

The Triage workflow initially places filed issues, except Schedule/Scenario issues and findings routed to a Scenario. Supported moves use `star github issue move`, the destination and `--reason`.

A blocker prevents approved work from proceeding. Stop affected work, preserve the worktree/unfinished changes and record evidence, state and dependency. Propose whether repair needs its own worktree or is inseparable from this work. Consult the Owner before acting on another worker's defect or PR. Severity or inconvenience alone does not establish a blocker.

Do not evade an external blocking defect to claim progress. Obtain approval before changing the commitment, discarding work or taking over another responsibility.

<a id="persistent-assignments"></a>

## 6. Persistent assignments

An Owner-supervised worker receives a Schedule as its mission. Its assignment identifies the current issue, applicable plan, repository and worktree. Resume that assignment with its approvals and state; advancing issues does not require a new conversation.

Role, assignment, native conversation and terminal view have separate identities. The [shared context contract](agents/context.md) defines resources, assignment and source evidence, and the [role entry points](agents/commandments.md) define specialist work; the [workstation architecture](../architecture/agentic-developer-workstation.md#41-persistent-specialists) describes persistent runtime roles. Role assets, host loading and runtime qualification are separate milestones.

Restore context and authority under [Agent operation](agent-operation.md). A new view, reconnection or resumed host grants no new assignment or permission.
