---
title: "Schedule template"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Schedule template

[Up: Templates](index.md)

<a id="role-assignments"></a>

## 1. Role assignments

[Role assignments](../engineering/process.md#roles-and-responsibilities): Owner [name]; Participants [names and scopes]; Reviewers [names and review scopes]; Observers [stakeholders or none]. A reference to the schedule’s assignments may supply this record.

<a id="deliverable"></a>

## 2. Deliverable

Before: [what the owner has].

After: [what the owner will have when all scheduled issues are complete].

<a id="mission-and-ownership"></a>

## 3. Mission and ownership

Owner: [person]. Worker assignment: [identity]. Scope and exclusions: [description]. Approved schedule revision: [reference].

<a id="ordered-issues"></a>

## 4. Ordered issues

| Position | Issue | Next | Waits on |
| --- | --- | --- | --- |
| 1 | [repository-qualified issue and meaning] | [state; worktree/PR or next action] | [dependency or none] |

The proposed header removes the old terminology. Existing report behavior is not changed by this draft; final schema/compatibility is a later decision.

<a id="overlap-and-coordination"></a>

## 5. Overlap and coordination

[Other schedules affecting the same code/features or dependencies, responsibilities, and approved conversation references. No work item may belong to two schedules; record coordinated transfers explicitly.]

<a id="amendments"></a>

## 6. Amendments

[Proposal, effect on deliverable/order/scope, owner approval and revision.]

<a id="progression-authority"></a>

## 7. Progression authority

[Default owner completion review, or explicit authorized issue range; conditions and stop triggers.]
