---
title: "Issue template"
status: draft
created: 2026-10-28
updated: 2026-11-15
---

# Issue template

[Up: Templates](index.md)

Use the selected account form as the issue's body template. This guide supplies shared drafting and record requirements; the forms own their type-specific section labels, order and required fields.

## 1. Select the account and type

Use the forms in [NobleFactor's account repository](https://github.com/NobleFactor/.github/tree/main/.github/ISSUE_TEMPLATE) or [David-Noble-at-work's account repository](https://github.com/David-Noble-at-work/.github/tree/main/.github/ISSUE_TEMPLATE). Follow [Issue standards](../issue-standards.md) for type, parent, Area, attributes and project placement.

[Issue forms (#572)](https://github.com/NobleFactor/noblefactor-engprod/issues/572) records the Owner-approved Task/Bug sections and the remaining form decisions during this migration. The forms and their standard references are reconciled there. Preserve the selected form's heading labels when preparing a body through another supported filing path.

## 2. Supply the shared work context

[Work assets](../engineering/work-assets.md#identity-and-relationships) defines the records an issue and its related assets supply. Include the following information in the appropriate form fields or referenced records.

<a id="role-assignments"></a>
<a id="1-role-assignments"></a>

Record the [role assignments](../engineering/process.md#roles-and-responsibilities): Owner [name], Participants [names and scopes], Reviewers [names and scopes], and Observers [stakeholders or none]. The schedule's assignments may supply that record.

<a id="problem-and-intended-outcome"></a>
<a id="2-problem-and-intended-outcome"></a>

State the problem and the observable outcome or evidence sought, using the selected type's fields.

<a id="scope-and-relationships"></a>
<a id="3-scope-and-relationships"></a>

Identify scope, repository, native feature/epic relationship, schedule assignment where applicable, dependencies and overlaps. Follow the current native field and parent model.

<a id="architecture-and-design-impact"></a>
<a id="4-architecture-and-design-impact"></a>

Record the architecture/design impact and related links, or the reasoned no-change determination, in the issue and its plan under [Plans and designs](../engineering/work-assets.md#plans-and-designs).

<a id="acceptance"></a>
<a id="5-acceptance"></a>

## 3. Record evidence and document links

Use the selected form's Evidence of completion section where its type requires one. Keep machine-parsed issue headings free of section-number prefixes: the classifier recognizes the literal Evidence of completion label. Follow [Completion and progression](../engineering/process.md#completion-and-progression) when recording milestones and Owner acceptance.

<a id="plan-and-design-documents"></a>

Every filed issue carries its Plan and design documents table under [Work assets](../engineering/work-assets.md#plans-and-designs), with a plan placeholder until available and links to applicable designs. Plans subsequently supply the authoritative rows through plan linking. Verify native metadata and project records through the supported filing path as well as checking the Markdown body.
