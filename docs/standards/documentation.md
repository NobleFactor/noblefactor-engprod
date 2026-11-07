---
title: "Documentation standards"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Documentation standards

[Up: Documentation](../index.md)

<a id="form-and-metadata"></a>

## 1. Form and metadata

Every tracked Markdown document carries frontmatter unless a reviewed, explicit exemption applies. Document family is determined by `type`, not by directory. The reference checker is `.github/scripts/Test-Frontmatter.sh`; later tooling changes must not silently redefine the standard.

<a id="document-families-and-metadata"></a>

### 1.1 Document families and metadata

| Family | Discriminator | Required fields | Status vocabulary |
| --- | --- | --- | --- |
| Working | No `type` | `title` | `draft`, `approved`, `active`, `complete`, `abandoned` |
| Catalog | Declares `type` | `title`, `type` | `Draft`, `Proposed`, `Decided`, `Approved`, `Accepted`, `Placeholder`, `Superseded`, `Withdrawn`, `Research Complete` |

Allowed catalog types are `ADR`, `RFC`, `PRD`, `README`, `Overview`, `Pitch`, `Index`, `Demos`, `Strategy`, `Roadmap`, `Reference`, `Guide`, `Demo Script`, `Plan`, `Process`, and `Brief`. The existing `Superseded by <reference>` status form identifies its successor. Legacy vocabulary overlaps are not normalized by this consolidation; identify any actual mismatch with the current checker before publication.

Decision status, working-document progress and delivery milestones describe different facts. [Completion and progression](../engineering/process.md#completion-and-progression) defines the plan-completion transition. An approved design is not evidence of implementation.

Chosen catalog paths may be pinned to their family by the checker’s `CATALOG_PATHS` configuration. Omitting `type` must not silently downgrade such a document. The current empty configuration is implementation state, not permission to omit required metadata from a catalog document.

<a id="exemptions"></a>

### 1.2 Exemptions

List exempt documents individually in `.github/frontmatter-exempt`, using repository-relative tracked paths. Exemptions cover legitimate repository furniture or explicitly retained historical records, not a shortcut around required fields. Each added exemption is a reviewed decision; do not use broad patterns to hide omissions.

<a id="language"></a>

### 1.3 Language

Use US English throughout prose and comments, including domain names under our control. Spelling-ignore entries address checker mistakes, not a preference for another spelling. Historical quotations and documents whose subject requires both spellings need explicit, scoped treatment. Preserve existing reviewed exceptions rather than broadening them implicitly.

**Case:** The US-English rule was enforced in Go but not other prose, allowing drift. The 2026-09-23 ruling brought document and comment checks under the same language requirement ([original standard](../engineering/review/sources/documentation-standards.txt)).

<a id="ownership-and-maintenance"></a>

## 2. Ownership and maintenance

Each requirement has one authoritative home. Cross-reference it rather than restating it in agent prompts, repository instructions and templates. State applicability explicitly. Repository instructions carry local facts and approved variations, naming the shared requirement affected.

The process owns transitions; standards own required asset content and state; procedures own mechanics. Templates introduce no requirements independently. Existing incident histories explain rationale and serve as examples; they must not be necessary to reconstruct current instructions.

Define every new term; use issue or work item for scheduled tasks and bugs, not the retired schedule-item term. Distinguish the schedule issue from the issues it orders. Full historical text is preserved as source evidence without attempting terminology replacement inside quotes or code examples.

<a id="prose-source-layout"></a>

### 2.1 Prose source layout

Each prose paragraph occupies one source line. Do not hard-wrap prose to a column limit; leave visual wrapping to the reader’s editor or renderer. Each prose list item and table cell likewise stays on one source line unless it contains a genuine nested structure or separate block.

Preserve code blocks, tables, nested lists and intentional structural boundaries. Code and documentation comments inside source files follow their language-specific formatting rules; this prose rule does not remove those limits. Historical source records remain unchanged unless an explicitly reviewed migration applies.

<a id="section-numbering"></a>

## 3. Section numbering

Numbered sections are mandatory in published process, plan and design documents. Number sections hierarchically so reviewers can identify a passage precisely. Preserve stable issue headings in shared plans as `## Issue NNN`, without a title or a section-number prefix. These headings identify issues rather than positions in the document.

When adding or changing section numbers, preserve existing incoming link targets through explicit anchors or a reviewed reference migration. Numbering must not silently break links. Templates must demonstrate the required structure rather than leave numbering to each author.

<a id="links-changes-and-history"></a>

## 4. Links, changes and history

Work assets define issue/plan/design link and path requirements. Prefer stable anchors and identities. Update affected documents in the same commit as the facts change, including implementation-status companions and user-facing material. Distinguish proposed, approved, implemented and verified statements.

When replacing a document, record its successor and migrate incoming references. Retain a clear historical designation for source records; do not leave two active definitions. The publication migration and any compatibility changes to tools are later work requiring review.
