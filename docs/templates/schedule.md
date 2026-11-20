---
title: "Schedule template"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

# Schedule template

[Up: Work templates](index.md)

Use this content guide with the account's Schedule issue form. `star github schedule open <repository> <name>` uses that form to create the issue, option and own project row; `create` is the same operation. Supply its required Area, deliverable, exit criteria and evidence values, plus optional Priority and assignee.

The form owns the issue body's labels and order. This guide's numbered headings are navigation, not replacement labels. Preserve literal issue headings such as `## Steps`, `## Amendments` and `## Plan and design documents`. [Issue standards](../issue-standards.md#schedules) owns representation.

<a id="role-assignments"></a>

## 1. Role assignments

[Owner; Participants and scopes; Reviewers and review scopes; Observers or none. Link approved assignments where they supply the record.]

<a id="deliverable"></a>

## 2. Deliverable

Before: [what exists].

After: [what the Owner will have when the committed work is complete].

<a id="exit-criteria"></a>

### 2.1 Exit criteria

[Observable criteria and required milestones, expressed as checkboxes in the form's Exit criteria section.]

<a id="evidence-of-completion"></a>

### 2.2 Evidence of completion

[Evidence to retain and its location. All Steps must be closed and exit criteria satisfied before Owner completion review authorizes `star github schedule close <schedule>` to record evidence and close the Schedule issue.]

<a id="mission-and-ownership"></a>

## 3. Mission and ownership

[Owner, worker assignment, scope/exclusions, approved revision and related Features/Epics/Scenarios.]

<a id="4-schedule"></a>

<a id="ordered-issues"></a>

## 4. Steps

Keep the command-generated `## Steps` section and its filtered-project link. Read the rows with `star github schedule get <owner>/<repository>#<number>`.

The project owns ordered Tasks/Bugs, contiguous Step numbers, Status, Worktree and native blocked-by dependencies. The Schedule issue's own row has no Step. Do not add a competing step table or Next column.

<a id="overlap-and-coordination"></a>

### 4.1 Overlap and coordination

[Identify related schedules, responsibilities and approved conversation references. Use the supported issue-move operation and Owner-approved reason for transfers; it records both schedules' amendments. Verify one-Schedule membership.]

<a id="progression-authority"></a>

## 5. Progression authority

[Record default Owner completion review, or an explicit range for unattended progression with conditions and stop triggers.]

<a id="amendments"></a>

## 6. Amendments

[Under the issue's literal `## Amendments` heading, retain dates, Owner approvals, approved proposal/revision and effects on deliverable, scope, order and dependencies. Apply changes through `star github issue move` with the required `--reason`, then read back rows and amendments.]

<a id="plan-and-design-documents"></a>

## 7. Plan and design documents

[Under the issue's literal `## Plan and design documents` heading, include the required Kind/Document table. Add its plan row with “Not yet opened” until available, and links to every applicable design.]

| Kind | Document |
| --- | --- |
| Schedule plan | Not yet opened |
| Design | [Each applicable design on its committed default branch] |
