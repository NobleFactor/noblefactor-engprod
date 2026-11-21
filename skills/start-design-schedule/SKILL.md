---
name: start-design-schedule
description: Prepare or populate a design schedule with the standard design-and-Architecture-decisions Task and roadmap Task, using shared templates and star GitHub commands.
metadata:
  title: "Start a design schedule"
  owner: "NobleFactor/engprod"
  change_process: "docs/engineering/process.md#prepare-and-review"
---

# Start a design schedule

Use the [design-schedule template](../../docs/templates/design-schedule.md) for Task content and [Design schedules](../../docs/engineering/work-organization.md#design-schedules) for requirements. This skill prepares the Designer's assignment; it does not write an implementation plan for producing design assets.

## 1. Establish the assignment

Identify the subsystem, approved problem/scope, target repository and clone, native parent Feature, per-issue Area, Owner, Designer and intended document locations. Accept an existing Schedule key and existing Task keys when supplied. Resolve material unknowns together rather than invent metadata.

Read the [issue](../../docs/architecture/issue-data-model/10-the-issue-commands.md) and [Schedule](../../docs/architecture/issue-data-model/8-the-schedule-commands.md) command contracts. Verify the installed commands before recommending or using them, following [tool verification](../../docs/engineering/agent-operation.md#all-agents-tools-and-status). A drafting request prepares content; GitHub writes require the applicable Owner authorization.

## 2. Reuse or create the Schedule and Tasks

For an existing Schedule, read it with star github schedule get and verify its repository, scope, state and rows. Without a key, use schedule list to find a matching Schedule before proposing creation. Preserve its issue identity when names change.

Read supplied Task keys or use schedule report to locate candidate work before opening issues. Confirm native parent, scope and deliverables; matching titles alone do not establish that two issues are the same. Reuse verified Tasks rather than create duplicates.

For a new Schedule, fill its required form values from the template and use the supported interface:

~~~text
star github schedule open OWNER/REPOSITORY "SUBSYSTEM design" --area AREA --deliverable "DELIVERABLE" --exit-criteria "EXIT CRITERIA" --evidence "COMPLETION EVIDENCE"
~~~

Draft both Task bodies from the selected account's Task form, inserting the template's content and required document table. Include every field the current form requires. A native Task needs a Feature parent, not the Schedule issue. Use issue open for each missing Task, selecting the target clone explicitly:

~~~text
star github issue open --type Task --parent OWNER/REPOSITORY#FEATURE --area AREA --title "TASK TITLE" --body-file /absolute/task-body.md --directory /absolute/target-clone
~~~

Replace every example value before execution. Keep other agents' assignments and existing Schedule membership intact; obtain the required amendment before a transfer.

## 3. Place and verify

Use the actual returned issue keys to add missing rows in the agreed order:

~~~text
star github issue move OWNER/REPOSITORY#DESIGN OWNER/REPOSITORY#ROADMAP --schedule OWNER/REPOSITORY#SCHEDULE --reason "OWNER-APPROVED SETUP REASON"
~~~

Use blocked-by only for an actual approved dependency. Read back the Schedule and both issues, checking native Type/parent, Area, document links, exactly one Schedule assignment, order and returned errors or refusals. Report incomplete metadata or placement.

Do not automatically repeat issue open after a lost response: each invocation creates a new issue. Use the report and issue readback to recover the earlier result; bring unresolved uncertainty to the Owner. Preserve returned keys and completed steps before continuing.

## 4. Handoff

Return the Schedule link, both Task links, expected design/Architecture decisions/roadmap locations, assignment and unresolved inputs. Distinguish drafted content from filed issues and verified placement. The Designer can begin the approved design assignment; this setup grants no implementation, Git, merge or cross-session communication authority.

Follow the template's completion evidence: technical review, compliance assessment, Owner approval and merged deliverables. These records belong on the introducing PR. Setting up the Schedule does not close its Tasks or prove that a host has loaded this skill.
