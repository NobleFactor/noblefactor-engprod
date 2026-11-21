---
title: "Documentation standards"
status: draft
created: 2026-10-28
updated: 2026-11-20
---

# Documentation standards

[Up: Documentation](../index.md)

<a id="form-and-metadata"></a>

## 1. Form and metadata

Every tracked Markdown file has frontmatter unless a reviewed explicit exemption applies. A `type` field selects the catalog family; its absence selects working format. Directory location alone does not select the family. [.github/scripts/Test-Frontmatter.sh](../../.github/scripts/Test-Frontmatter.sh) is the reference checker.

<a id="11-document-families-and-metadata"></a>

<a id="document-families-and-metadata"></a>

### 1.1 Document families

| Family | Discriminator | Required fields | Allowed status when supplied |
| --- | --- | --- | --- |
| Working | No `type` | `title` | `draft`, `approved`, `active`, `complete`, `abandoned` |
| Catalog | Declares `type` | `title`, `type` | `Draft`, `Proposed`, `Decided`, `Approved`, `Accepted`, `Placeholder`, `Superseded`, `Withdrawn`, `Research Complete` |

Catalog types are `ADR`, `RFC`, `PRD`, `README`, `Overview`, `Pitch`, `Index`, `Demos`, `Strategy`, `Roadmap`, `Reference`, `Guide`, `Demo Script`, `Plan`, `Process` and `Brief`. `Superseded by <reference>` identifies a successor.

Catalog `Plan` and `Process` are decision-document types. A branch-bound execution plan uses working format without `type`; an approved shared process record can declare `type: Process`. Do not invent a second execution-plan format or silently change the checker's vocabulary.

Decision approval, working-document status and delivery milestones are separate. [Completion](../engineering/process.md#completion-and-progression) defines plan lifecycle; an approved design is not implementation evidence.

A repository can pin catalog paths through `CATALOG_PATHS`. Such documents cannot downgrade their family by omitting `type`. Tool configuration and standard requirements remain distinct.

<a id="exemptions"></a>

### 1.2 Exemptions

List exemptions individually as tracked repository-relative paths in `.github/frontmatter-exempt`. Each needs review and a legitimate reason, such as repository furniture or retained historical evidence. Broad patterns cannot hide missing metadata.

<a id="13-language"></a>

<a id="language"></a>

### 1.3 Language and writing

Use US English in prose/comments, including domain names under our control. Ignore-list entries correct checker mistakes rather than select another spelling. Preserve reviewed scoped exceptions for historical quotations or subjects requiring both spellings.

Use [Google's guidance](https://developers.google.com/style) for clear, direct writing and [arc42](https://arc42.org/overview/) for architecture content. Describe the intended system coherently. Plans own transitions and execution history; decision records explain significant choices. Define necessary terms and omit words that do not aid understanding.

<a id="ownership-and-maintenance"></a>

## 2. Ownership and maintenance

Give each requirement one authoritative home. Prompts, host/repository instructions and templates link to it. State applicability; local variations identify the affected shared requirement, scope and approval.

Process owns transitions, standards own required content/conditions, procedures own mechanics and templates demonstrate structure. Historical cases support review; readers should not need to reconstruct current instructions from them.

Use issue or work item for scheduled Tasks/Bugs, and distinguish those from the Schedule issue. Define new terms. Preserve historical wording inside quotations and original sources.

<a id="prose-source-layout"></a>

### 2.1 Prose source layout

Each prose paragraph occupies one physical source line. Leave visual wrapping to the editor or renderer. Each prose list item and table cell stays on one line unless it contains an actual nested structure or separate block.

Preserve code blocks, tables, nested lists and structural boundaries. Source-language comment/code formatting still applies. Immutable historical evidence stays unchanged unless a reviewed migration authorizes changes.

[Handbook adoption (#551)](https://github.com/NobleFactor/noblefactor-engprod/issues/551) requires all maintained documents to conform before completion, including previously untouched documents and newly delivered context assets. [Formatting migration (#570)](https://github.com/NobleFactor/noblefactor-engprod/issues/570) owns the comprehensive pass; closing review checks its evidence. Preserve immutable historical sources.

<a id="section-numbering"></a>

## 3. Section numbering

Number published process, plan and design sections hierarchically. Shared-plan issue headings stay `## Issue NNN` without a title or numbering prefix. Issue-form bodies retain literal machine-parsed labels, including Evidence of completion and Plan and design documents.

Preserve existing link targets through explicit anchors or reviewed reference migration when headings change. Templates demonstrate the required structure. The form-body and stable-issue-heading exceptions preserve their machine-readable meaning.

<a id="links-changes-and-history"></a>

## 4. Links, changes and history

[Work assets](../engineering/work-assets.md#plans-and-designs) owns plan/design paths and issue links, including default-branch references for open issues and merge-commit references for issues closed by a PR.

Use stable identities and anchors. Update affected plans, status records and user-facing material in the commit that changes their facts. Distinguish proposed, approved, implemented and verified statements.

When replacing a document, name its successor and migrate references while retaining historical designation and evidence. Avoid competing active definitions. [Host cutovers](../engineering/index.md#temporary-live-entrypoint-overrides) require their own approved delivery and loading evidence; a documentation edit cannot claim a tool change.

<a id="decision-records"></a>

### 4.1 Decision records

<a id="architecture-decisions"></a>

Name the Designer's deliverable **Architecture decisions**. Document each significant architectural choice as an **architecture decision record (ADR)**. Expand the abbreviation on first use. The collection explains the choices behind a design; it can be a companion document or linked individual ADRs. The same record format also applies to handbook policy and process decisions, which are not architectural choices.

Apply this format to handbook decisions and architecture decision records. [Arc42](https://docs.arc42.org/section-9/) supplies the decision content; [Google's writing guidance](https://developers.google.com/style) supplies the presentation. Use the [decision template](../templates/decision.md). Templates demonstrate this standard and do not introduce separate requirements.

Lead with a descriptive headline that states the chosen or proposed outcome. Follow it with the decision's scope, context, reasons, considered alternatives and their tradeoffs, consequences, and links to available evidence. Separate observations from assumptions. Identify the reasons for rejecting alternatives when recorded; do not invent alternatives, research or approval evidence to fill a gap. Scale the explanation to the significance of the decision.

End each record with one fenced `yaml` block using the fields below in this order. A file containing several decisions has one footer per decision. These fields describe the individual decision; the document's frontmatter still describes the whole file.

| Field | Content |
| --- | --- |
| `id` | Stable identifier within the decision log or collection; never reuse or renumber it |
| `status` | `proposed`, `accepted`, `rejected`, `deprecated` or `superseded` |
| `supersedes` | List of identifiers or links to decisions wholly replaced by this one; use an empty list when none |
| `superseded_by` | Optional list identifying a whole-record replacement; place it here when applicable |
| `proposed_by` | Actual proposing person or agent, or `null` when not established |
| `approved_by` | Actual approving authority, or `null` until approval is established |
| `recorded_by` | Person or agent writing or revising this record |
| `decided_at` | Quoted approval timestamp with its UTC offset, the known date alone, or `null` when unknown |
| `recorded_at` | Quoted timestamp with UTC offset for this recording or revision |

A question asks for investigation; it does not establish a decision or approval. A proposal remains proposed until the required authority explicitly accepts it. Researching, drafting or formatting a record cannot supply that approval.

Keep approval time distinct from recording time. For new timestamped events, use [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339#section-5.6), including `Z` or a numeric UTC offset. When the source establishes only a date, retain that date; do not invent a time or backdate the recording. Attribute a reformatting pass to its actual recorder without implying that recorder made the original decision.

Preserve the substance and approval evidence of accepted records. Record a changed outcome in a new decision and link its predecessor; describe partial replacement and its scope in the explanation rather than marking the entire earlier decision superseded. Editorial changes preserve meaning and attribution. Keep historical evidence available and stable links working.

The handbook's [decision log](../engineering/review/decisions.md) records handbook choices. Architecture companions record their owning design's choices; plans retain transition work and scoped execution approvals. Link these records instead of creating competing definitions. Current instructions belong in their authoritative handbook pages.

A YAML fence makes the data visible, but recognizing and validating a decision footer requires an explicit reader or check; file-frontmatter validation alone does not validate it. This format does not alter the separate [Codex review-comment convention](../engineering/agent-operation.md#codex-review-comments) or [PR sign-off and assistance disclosure](../engineering/procedures/pull-request.md#review-boundary).
