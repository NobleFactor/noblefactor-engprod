---
title: "Schedule template"
status: draft
created: 2026-10-28
updated: 2026-11-15
---

# Schedule template

[Up: Templates](index.md)

Use the account's Schedule issue form from its `.github` repository when filing. This template describes its content; [Issue standards](../issue-standards.md#schedules) owns the representation. Preserve the literal `## Amendments` and `## Plan and design documents` headings required by the scheduling and document-link conventions.

<a id="role-assignments"></a>

## 1. Role assignments

[Role assignments](../engineering/process.md#roles-and-responsibilities): Owner [name]; Participants [names and scopes]; Reviewers [names and review scopes]; Observers [stakeholders or none]. A reference to approved schedule assignments may supply this record.

<a id="deliverable"></a>

## 2. Deliverable

Before: [what exists now].

After: [what the Owner will have when the committed work is complete].

Evidence of completion: [observable exit criteria and required milestones].

<a id="mission-and-ownership"></a>

## 3. Mission and ownership

Owner: [person]. Worker assignment: [identity]. Scope and exclusions: [description]. Approved schedule revision: [reference]. Related features, epics and scenarios: [links].

<a id="ordered-issues"></a>

## 4. Schedule

Use this line with the actual project-view URL and option: `The steps are on [<project name>](<filtered project-view URL>), under Schedule "<option>".`

The team's Schedule project owns the step records. Tasks and bugs have contiguous Step numbers, Status, Worktree and native blocked-by dependencies. The Schedule issue's own row has no Step. Do not reproduce an authoritative step table or a Next column in this issue.

<a id="overlap-and-coordination"></a>

### 4.1. Overlap and coordination

[Other schedules affecting the same code or dependencies, responsibilities and approved conversation references. Record coordinated transfers; an issue belongs to at most one schedule.]

<a id="progression-authority"></a>

## 5. Progression authority

[Default Owner completion review, or an explicit issue range authorized for unattended progression, with conditions and stop triggers.]

## Amendments

[Date, Owner approval, proposal or revision approved, and effect on deliverable, scope, order and dependencies. Apply the approved change to the project rows and read it back through the supported scheduling operation.]

## Plan and design documents

Add a plan row, initially "Not yet opened", and linked rows for applicable designs.

| Kind | Document |
| --- | --- |
| Schedule plan | Not yet opened |
| Design | [Link each applicable design on its committed default branch] |
