---
title: "Schedule template"
status: draft
created: 2026-10-28
updated: 2026-11-17
---

# Schedule template

[Up: Templates](index.md)

Create a schedule with `star github schedule new <repository> <name>`, supplying the metadata and form-section values required by its help. The command follows the account's Schedule issue form in its `.github` repository, creates the issue, option and own row, and writes the Steps line. Start-Claude's former `--schedule new` is refused. This template describes the content; [Issue standards](../issue-standards.md#schedules) owns the representation. Preserve the literal `## Amendments` and `## Plan and design documents` headings required by the scheduling and document-link conventions.

<a id="role-assignments"></a>

## 1. Role assignments

[Role assignments](../engineering/process.md#roles-and-responsibilities): Owner [name]; Participants [names and scopes]; Reviewers [names and review scopes]; Observers [stakeholders or none]. A reference to approved schedule assignments may supply this record.

<a id="deliverable"></a>

## 2. Deliverable

Before: [what exists now].

After: [what the Owner will have when the committed work is complete].

## Exit criteria

- [ ] [Observable criterion for the promised deliverable.]
- [ ] [Required milestone and its acceptance evidence.]

## Evidence of completion

[Evidence to retain and where it will be recorded. After all steps are closed and exit criteria are ticked, the Owner reviews completion before authorizing `star github schedule close <schedule>` to write the evidence comment and close the Schedule issue.]

<a id="mission-and-ownership"></a>

## 3. Mission and ownership

Owner: [person]. Worker assignment: [identity]. Scope and exclusions: [description]. Approved schedule revision: [reference]. Related features, epics and scenarios: [links].

<a id="ordered-issues"></a>

## 4. Schedule

Keep the `## Steps` line written by `star github schedule new`, which begins `The steps are the rows of …` and links the project's filtered view. Read its rows with `star github schedule get <owner>/<repository>#<number>`.

The team's Schedule project owns the step records. Tasks and bugs have contiguous Step numbers, Status, Worktree and native blocked-by dependencies. The Schedule issue's own row has no Step. Do not reproduce an authoritative step table or a Next column in this issue.

<a id="overlap-and-coordination"></a>

### 4.1. Overlap and coordination

[Other schedules affecting the same code or dependencies, responsibilities and approved conversation references. Use `star github issue move --schedule <destination> --reason <Owner-approved reason>` for coordinated transfers; the command records amendments on both schedules, and an issue belongs to at most one schedule.]

<a id="progression-authority"></a>

## 5. Progression authority

[Default Owner completion review, or an explicit issue range authorized for unattended progression, with conditions and stop triggers.]

## Amendments

[Date, Owner approval, proposal or revision approved, and effect on deliverable, scope, order and dependencies. Apply the approved change through `star github issue move`, whose required `--reason` records the Owner's approval in its amendment, then read the rows and amendment back.]

## Plan and design documents

Add a plan row, initially "Not yet opened", and linked rows for applicable designs.

| Kind | Document |
| --- | --- |
| Schedule plan | Not yet opened |
| Design | [Link each applicable design on its committed default branch] |
