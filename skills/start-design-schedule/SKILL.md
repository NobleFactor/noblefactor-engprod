---
name: start-design-schedule
description: Set up a design schedule and its Epic-to-enabler-Feature-to-Task hierarchy, reusing existing issues and placing the two standard Tasks correctly.
metadata:
  title: "Start a design schedule"
  owner: "NobleFactor/engprod"
  change_process: "docs/engineering/process.md#prepare-and-review"
---

# Start a design schedule

Use the [design-schedule template](../../docs/templates/design-schedule.md), [enabler-feature convention](../../docs/issue-standards.md#enabler-features), and [design-schedule requirements](../../docs/engineering/work-organization.md#design-schedules). Prepare the Designer's assignment directly, without a plan for writing the design. Drafting does not authorize filing or moving issues.

Replace the following example values before running a command:

- `REPOSITORY`: the `OWNER/REPOSITORY` slug.
- `EPIC_NUMBER` and `FEATURE_NUMBER`: the verified native parent issue numbers.
- `DESIGN_NUMBER`, `ROADMAP_NUMBER`, and `SCHEDULE_NUMBER`: the actual returned issue numbers.
- `AREA`: the applicable issue Area.
- `SUBSYSTEM` and `TASK_TITLE`: the approved subsystem name and Task title.
- `FEATURE_BODY` and `TASK_BODY`: absolute paths to bodies using the account's forms.
- `TARGET_CLONE`: the absolute target-clone path.
- `DELIVERABLE`, `EXIT_CRITERIA`, and `COMPLETION_EVIDENCE`: the Schedule's approved content.
- `SETUP_REASON`: the Owner-approved reason for placing the Tasks.

<a id="1-establish-the-assignment"></a>

## 1. Resolve the Epic and existing work

1. Establish the approved problem, scope, repository, related Epic, Owner, Designer, per-issue Area, and intended document locations.
2. Discover existing work through `schedule report` and `schedule list` and `schedule get`.
3. [Verify the installed tools](../../docs/engineering/agent-operation.md#all-agents-tools-and-status) against the [issue command contract](../../docs/architecture/issue-data-model/10-the-issue-commands.md) and [Schedule command contract](../../docs/architecture/issue-data-model/8-the-schedule-commands.md) contracts.
4. Read supplied Feature, Schedule, and Task keys before reusing them.
5. Confirm the Feature's native Epic parent. Titles alone do not establish identity.

Resolve material unknowns before dependent work. Preserve other workers' assignments; obtain required approval for transfers or reparenting. Keep native relationships within the account.

<a id="2-reuse-or-create-the-schedule-and-tasks"></a>

## 2. Establish the enabler Feature

1. Reuse the verified design enabler Feature or draft a missing one using the account's Feature form. State the future capability it enables and its design, architecture decisions, and roadmap deliverables.
2. If creation is authorized, open the missing Feature under the related Epic:

   ```sh
   star github issue open \
     --type Feature --parent REPOSITORY#EPIC_NUMBER \
     --area AREA --title "SUBSYSTEM design" \
     --body-file "FEATURE_BODY" --directory "TARGET_CLONE"
   ```

3. Verify the returned key, native Type, Epic parent, Area, and body.
4. Once accepted, place the Feature in Backlog with `issue move` `--backlog` and the approved reason when needed.

Enabler describes purpose; the native Type remains Feature. The Feature is not a Schedule Step. Resolve a missing Epic rather than attach Tasks directly to it or create another Epic without authority.

<a id="3-place-and-verify"></a>

## 3. Establish the Schedule and two Tasks

1. Verify the supplied or discovered design Schedule's identity, scope, state, and rows.
2. If it is missing and creation is authorized, open it:

   ```sh
   star github schedule open REPOSITORY "SUBSYSTEM design" \
     --area AREA --deliverable "DELIVERABLE" \
     --exit-criteria "EXIT_CRITERIA" \
     --evidence "COMPLETION_EVIDENCE"
   ```

3. Draft both Task bodies with the account's Task form and the template's content, output links, and completion evidence.
4. Reuse verified Tasks. If creation is authorized, open only missing Tasks under the enabler Feature:

   ```sh
   star github issue open \
     --type Task --parent REPOSITORY#FEATURE_NUMBER \
     --area AREA --title "TASK_TITLE" \
     --body-file "TASK_BODY" --directory "TARGET_CLONE"
   ```

5. Place missing Task rows using the actual returned keys:

   ```sh
   star github issue move \
     REPOSITORY#DESIGN_NUMBER REPOSITORY#ROADMAP_NUMBER \
     --schedule REPOSITORY#SCHEDULE_NUMBER --reason "SETUP_REASON"
   ```

6. Record only genuine approved blocking dependencies. A roadmap may develop alongside the design.

The Schedule has no native parent; it does not replace the Epic → Feature → Task hierarchy.

<a id="4-handoff"></a>

## 4. Verify and hand off

1. Read back the Epic, Feature, both Tasks, and Schedule.
2. Verify native parent links, Types, per-issue Area, document links, Task order, and exactly one Schedule assignment per Task. The accepted Feature stays in Backlog; only Tasks and the Schedule's own row belong in Schedules.
3. Report incomplete metadata, placement, or command refusals.
4. Recover uncertain issue creation through reports and issue reads. Do not repeat `issue open` after a lost response; each invocation creates a new issue.
5. Return the five issue links, expected artifact locations, assignment, and unresolved inputs.

Distinguish drafted content, filed issues, and verified placement. Setup grants no implementation, Git, merge, or cross-session communication authority. Follow the handbook's [design-schedule completion requirements](../../docs/engineering/work-organization.md#design-schedules). Closing a design enabler does not establish delivery of the future subsystem.
