---
title: "Engineering evidence archive preparation history"
type: Reference
status: "Superseded by the evidence archive design"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/490
created: 2026-11-20
updated: 2026-11-21
documents:
  - kind: Archive design
    path: docs/architecture/engineering-evidence-archive.md
  - kind: Archive decisions
    path: docs/architecture/engineering-evidence-archive.decisions.md
  - kind: Archive roadmap
    path: docs/roadmaps/engineering-evidence-archive.md
  - kind: Workstation design
    path: docs/architecture/agentic-developer-workstation.md
  - kind: Workstation roadmap
    path: docs/roadmaps/agentic-developer-workstation.md
  - kind: Workstation decisions
    path: docs/architecture/agentic-developer-workstation.decisions.md
  - kind: Issue standard
    path: docs/issue-standards.md
  - kind: Filing convention
    url: https://github.com/NobleFactor/.github/blob/main/.github/ISSUE_TEMPLATE/epic.yml
    text: "Epic issue form"
  - kind: Related incident record
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/317
    text: "Evidence for reviewed policy derivation"
---

# Engineering evidence archive preparation history

This reference preserves the preparation and review history of [PR #618](https://github.com/NobleFactor/noblefactor-engprod/pull/618). The Designer's deliverables are the [subsystem design](../../architecture/engineering-evidence-archive.md), [decision records](../../architecture/engineering-evidence-archive.decisions.md) and [roadmap](../../roadmaps/engineering-evidence-archive.md). This page is not an execution plan or an approval gate on that work.

<a id="role-assignments"></a>
<a id="summary-and-promised-result"></a>
<a id="current-state"></a>

## 1. Preparation and review history

Owner: David Noble. Designer: Codex. Independent Reviewer: Antigravity, Engineering Evidence Archive Review conversation. No Observers are assigned.

The original plan was published at fec570d879cef390af6d1bb537eb7204423a2fb1. Its revised preparation record at 9cb06e6552b667ec71f6cea0789612beb8acffe5 passed CI and [independent re-review](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6002690447). David then clarified that a Designer owes design documents, decision records and a roadmap, and that a Schedule orders their delivery. The earlier plan review does not accept the design.

The actual design set was first published at 842aa30b2bc34d4e27cda1022a4cab69348d510e. The [design review of that head](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6008500367) identified changes to a completed historical plan, missing requirements coverage and distributed-protocol gaps. The [local correction recheck](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6008973627) checked the unpublished corrections. Those corrections were then published at dfb596dde192cdcb6c9cff78473120cd99857a05. The [published-revision review](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6009380436), submitted on 2026-11-22 at 01:29:48 UTC, verified zero open technical defects on that revision and left document scope and format choices to the Owner.

For dfb596dde192cdcb6c9cff78473120cd99857a05, the Owner-run publication script completed make check on Media-Server, validated seven active documents, 19 decision footers and 120 local links/anchors, and verified all four CI checks as successful. Its publication receipt was recorded on 2026-11-22 at 00:36:59 UTC. Diagram rendering and the Reviewer's independent verification of external vendor pages and private investigation inputs remain bounded gaps. This shortened record requires its own document checks and recheck after publication.

## Issue 490

<a id="design-impact"></a>
<a id="proposed-implementation"></a>
<a id="alternatives-and-challenges"></a>
<a id="implementation-phases"></a>
<a id="files-and-related-assets"></a>
<a id="dependencies-overlaps-and-blockers"></a>

## 2. Current deliverables and ownership

[Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) supplies requirements. Its six implementation Features remain provisional. [Evidence archive design (#622)](https://github.com/NobleFactor/noblefactor-engprod/issues/622) is the enabler Feature. [Schedule #619](https://github.com/NobleFactor/noblefactor-engprod/issues/619) orders [design and decision records (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) before [the roadmap (#624)](https://github.com/NobleFactor/noblefactor-engprod/issues/624). The live project owns progress and dependency records; the roadmap draft provides context and does not complete its Task.

The design owns requirements coverage, behavior, significant choices, alternatives, interfaces, data and recovery contracts. The roadmap supplies capabilities, dependencies and observable acceptance evidence to the Planner. The handbook coder owns the shared terminology, templates and design-Schedule skill. There is no Designer-owned implementation plan here.

The Epic's post-merge document table retains the linking tool's canonical Plan label and path-text format for this historical reference. That compatibility label does not make this page an execution plan. The design publisher's merge-link check requires the tool to report the table unchanged, preventing recurring custom-row drops.

The completed workstation plan is preserved byte-for-byte at develop blob a4fcdfe7d6117d1f13beeb77f3eef53cdaeba2d0; it is not part of the final PR delta. Current workstation [D4](../../architecture/agentic-developer-workstation.decisions.md#d4) and [W6](../../architecture/agentic-developer-workstation.decisions.md#w6) record the storage question and the withdrawal of the former uniformity preference. They do not approve a replacement engine.

<a id="approval-and-departures"></a>

## 3. Evidence and approval limits

On 2026-11-21, after the published-revision review above, the Designer asked in the Owner–Designer conversation: "Approve keeping the RFC/Roadmap formats and draft roadmap, and shortening the earlier preparation document to a historical record?" David Noble replied: "yes, i approve." This authorizes retaining the archive design as RFC/Draft, retaining the roadmap as Roadmap/Draft and review context, and replacing the earlier preparation document with this historical reference. The source exchange establishes the date and scope; it supplies no exact approval time. It does not accept the proposed archive architecture, complete either Task or authorize merge.

The private Antigravity draft, prototype, SQL reproductions and earlier conversation transcript were not independently verified by this design review. The recorded draft digest is abc57d5b114233726fbb9faf688726beafb895b3a2c4b608318d7818385029ec. They are investigation inputs, not deployment evidence. The Owner's recording request and role clarification authorize the design work; they do not accept each proposed architecture choice.

The design's open-choice register and individual decision footers retain the actual approval state. Vendor citations were checked live on 2026-11-21; versions remain research baselines requiring deployed qualification. Documentation checks establish neither measured performance nor running security/durability guarantees.

<a id="acceptance-criteria-and-evidence"></a>
<a id="required-completion-milestones"></a>
<a id="completion-review"></a>

## 4. Delivery records

The Owner directed review in order: process the Reviewer's comments and corrective rechecks, then the auditor's comments and corrective rechecks, repeating until the participants agree the work is complete. The [separate compliance audit of 842aa30b](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7071338808) has not yet received that corrective audit round. Technical-review acceptance does not dispose of its findings. The Owner-approved document changes above are the current revision; review-thread resolution and audit acceptance remain outstanding.

Publishing a draft or passing CI does not complete Task #623 or the roadmap. After the reviews, Owner acceptance and an observed merge, record the exact merge revision and results on the served issues, refresh open-issue document links to the default branch and any issue closed by that PR to its merge revision, and preserve the outstanding roadmap and completion-record obligations. The archive Epic and implementation Features remain open until their own completion evidence is accepted.
