---
name: start-design-schedule
description: Set up a design schedule and its Epic-to-enabler-Feature-to-Task hierarchy, reusing existing issues and placing the two standard Tasks correctly.
metadata:
  title: "Start a design schedule"
  owner: "NobleFactor/engprod"
  change_process: "docs/engineering/process.md#prepare-and-review"
---

# Start a design schedule

Use the [design-schedule template](../../docs/templates/design-schedule.md), [enabler-feature convention](../../docs/issue-standards.md#enabler-features) and [design-schedule requirements](../../docs/engineering/work-organization.md#design-schedules). Prepare the Designer's assignment directly, without a plan for writing the design.

<a id="1-establish-the-assignment"></a>

## 1. Resolve the Epic and existing work

Establish the subsystem, approved problem/scope, target repository/clone, related Epic, Owner, Designer, per-issue Area and intended document locations. Accept existing Feature, Schedule and Task keys. If a Feature is supplied, read its native Epic parent and confirm that it is the intended Epic. Resolve material unknowns together.

Use schedule report to discover hierarchy issues and their native parents. Use schedule list/get for collection discovery and rows. Read the [issue](../../docs/architecture/issue-data-model/10-the-issue-commands.md) and [Schedule](../../docs/architecture/issue-data-model/8-the-schedule-commands.md) contracts, and [verify the installed tools](../../docs/engineering/agent-operation.md#all-agents-tools-and-status). A request to draft prepares content; filing and moving issues require applicable Owner authorization.

Confirm scope and parent links before reusing an issue. Titles alone do not establish identity. Preserve other workers' assignments and obtain the required Owner approval before a transfer or reparenting. Keep native relationships within the account under the issue standard.

<a id="2-reuse-or-create-the-schedule-and-tasks"></a>

## 2. Establish the enabler Feature

Reuse the verified design enabler Feature, or prepare one using the account's Feature form. State what future capability it enables and its deliverables: design, Architecture decisions and roadmap. Its native Type is Feature; enabler describes purpose and does not select an Area or add a type, label or field.

For authorized creation, use the related Epic as parent:

~~~text
star github issue open --type Feature --parent OWNER/REPOSITORY#EPIC --area AREA --title "SUBSYSTEM design" --body-file /absolute/feature-body.md --directory /absolute/target-clone
~~~

Verify its returned key, native Type, Epic parent, Area and body. Once accepted, keep its row in Backlog using issue move with --backlog and the approved reason when needed. The Feature is not a Schedule Step. If the Epic is unresolved, obtain that input rather than attach Tasks directly to an Epic or create another Epic without authority.

<a id="3-place-and-verify"></a>

## 3. Establish the Schedule and two Tasks

Reuse the supplied or discovered design Schedule after checking its identity, scope, state and rows. For authorized creation, fill the Schedule form values from the template:

~~~text
star github schedule open OWNER/REPOSITORY "SUBSYSTEM design" --area AREA --deliverable "DELIVERABLE" --exit-criteria "EXIT CRITERIA" --evidence "COMPLETION EVIDENCE"
~~~

Draft both Task bodies using the account's Task form and the template's content, output links and completion evidence. Reuse verified existing Tasks; open only missing ones. Their native parent is the design enabler Feature:

~~~text
star github issue open --type Task --parent OWNER/REPOSITORY#FEATURE --area AREA --title "TASK TITLE" --body-file /absolute/task-body.md --directory /absolute/target-clone
~~~

Replace all example values before execution. Include each form's required fields. Use the actual returned Task keys to place missing rows on the design Schedule:

~~~text
star github issue move OWNER/REPOSITORY#DESIGN OWNER/REPOSITORY#ROADMAP --schedule OWNER/REPOSITORY#SCHEDULE --reason "OWNER-APPROVED SETUP REASON"
~~~

Use blocked-by only for a genuine approved dependency. A roadmap may develop alongside the design. The Schedule has no native parent; it does not replace the Epic/Feature hierarchy.

<a id="4-handoff"></a>

## 4. Verify and hand off

Read back the Epic, Feature, both Tasks and Schedule. Verify Epic → Feature → Task native links, Type, per-issue Area, document links, exactly one Schedule assignment per Task, order and project placement. The accepted Feature remains in Backlog; only the Tasks and Schedule's own row belong in Schedules. Report incomplete metadata, placement or returned refusals.

Preserve issue keys and completed operations. Do not repeat issue open after a lost response: each invocation creates a new issue. Recover through the report and issue reads; unresolved identity goes to the Owner.

Return links to the Epic, enabler Feature, Schedule and both Tasks, with expected artifact locations, assignment and unresolved inputs. Distinguish drafted content, filed issues and verified placement. Setup grants no implementation, Git, merge or cross-session communication authority.

Follow the template's completion evidence: technical review, compliance assessment, Owner approval and merged deliverables. Feature closure reviews its actual assets, including code when present. Closing the design enabler does not establish delivery of the future subsystem capabilities.
