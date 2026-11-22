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

The shortened record was published at eebfa14b55dda7f6f64eefc0f66c04e9c540c346. The [corrective technical recheck](https://github.com/NobleFactor/noblefactor-engprod/pull/618#pullrequestreview-6009759033), submitted on 2026-11-22 at 02:28:13 UTC, verified zero open technical defects and resolved all 14 review threads. For that revision, the Owner-run publication script completed make check on Media-Server, validated seven active documents, 19 decision footers and 120 local links/anchors, and verified all four CI checks as successful. Its receipt was recorded on 2026-11-22 at 01:56:28 UTC. Each later revision receives its own checks and corrective review. Diagram rendering and the Reviewer's independent verification of external vendor pages and private investigation inputs remain bounded gaps.

## Issue 490

<a id="design-impact"></a>
<a id="proposed-implementation"></a>
<a id="alternatives-and-challenges"></a>
<a id="implementation-phases"></a>
<a id="files-and-related-assets"></a>
<a id="dependencies-overlaps-and-blockers"></a>

## 2. Current deliverables and ownership

[Engineering evidence archive (#490)](https://github.com/NobleFactor/noblefactor-engprod/issues/490) supplies requirements. Its six implementation Features remain provisional. [Evidence archive design (#622)](https://github.com/NobleFactor/noblefactor-engprod/issues/622) is the enabler Feature. [Schedule #619](https://github.com/NobleFactor/noblefactor-engprod/issues/619) orders [design and decision records (#623)](https://github.com/NobleFactor/noblefactor-engprod/issues/623) before [the roadmap (#624)](https://github.com/NobleFactor/noblefactor-engprod/issues/624). The live project owns progress and dependency records; the roadmap draft provides context and does not complete its Task.

The design owns requirements coverage, behavior, significant choices, alternatives, interfaces, data and recovery contracts. The roadmap supplies capabilities, dependencies and observable acceptance evidence to the Planner. [Shared context and five specialist roles (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558), delivered through [PR #616](https://github.com/NobleFactor/noblefactor-engprod/pull/616), owns shared terminology, templates and the design-Schedule skill. There is no Designer-owned implementation plan here.

At 2026-11-22T03:48:21.220Z (2026-11-21 locally), David Noble directed, "then let's get the changes from #618 into #616 NOW!" [Retained message 39](../../engineering/review/sources/role-context-2026-11-20/owner-direction.txt) supplies the exact text and source exchange. This approves consolidating both candidates in [PR #616](https://github.com/NobleFactor/noblefactor-engprod/pull/616) with a merge commit. The environment-role W6 and one-off-audit W7 retain their identifiers; the archive withdrawal becomes [W8](../../architecture/agentic-developer-workstation.decisions.md#w8), and its correction follows D4 into the workstation design. All 12 unpublished role-context corrections present at integration preparation are preserved. PR #618 remains the earlier review record and was closed as superseded after the combined publication at dd427dd17c2b9de2fc29b8cb960b819bdfd3324a was verified. The combined revision requires technical review, compliance recheck, and final Owner acceptance; neither earlier candidate's review accepts it.

The Epic's post-merge document table retains the linking tool's canonical Plan label and path-text format for this historical reference. That compatibility label does not make this page an execution plan. The design publisher's merge-link check requires the tool to report the table unchanged, preventing recurring custom-row drops.

The completed workstation plan is preserved byte-for-byte at develop blob a4fcdfe7d6117d1f13beeb77f3eef53cdaeba2d0; it is not part of the final PR delta. Current workstation [D4](../../architecture/agentic-developer-workstation.md#d4) and [W8](../../architecture/agentic-developer-workstation.decisions.md#w8) record the storage question and the withdrawal of the former uniformity preference. They do not approve a replacement engine.

<a id="approval-and-departures"></a>

## 3. Evidence and approval limits

The [retained Owner direction in PR #616, Message 22](https://github.com/NobleFactor/noblefactor-engprod/blob/f51a652fd1889277a9ac6cae639903a61142ac77/docs/engineering/review/sources/role-context-2026-11-20/owner-direction.txt) states: "A Designer owes a design, its decision records, and a roadmap, not a plan for writing a design." Its source exchange is dated 2026-11-20 locally and recorded at 2026-11-21T04:22:39.061Z. For this Designer assignment, that direction replaces the preparation-plan deliverable and gate with the scheduled design, decisions and roadmap. This is the scoped Owner variation from the current [preparation process](../../engineering/process.md#prepare-and-review) and common commandment 2; it changes no Coder implementation requirement. PR #616 delivers the shared handbook change. This reference records the variation independently, so it does not require that unmerged handbook wording to be treated as current authority.

On 2026-11-21, after the published-revision review above, the Designer asked in the Owner–Designer conversation: "Approve keeping the RFC/Roadmap formats and draft roadmap, and shortening the earlier preparation document to a historical record?" David Noble replied: "yes, i approve." This authorizes retaining the archive design as RFC/Draft, retaining the roadmap as Roadmap/Draft and review context, and replacing the earlier preparation document with this historical reference. The source exchange establishes the date and scope; it supplies no exact approval time. It does not accept the proposed archive architecture, complete either Task or authorize merge.

The private Antigravity draft, prototype, SQL reproductions and earlier conversation transcript were not independently verified by this design review. The recorded draft digest is abc57d5b114233726fbb9faf688726beafb895b3a2c4b608318d7818385029ec. They are investigation inputs, not deployment evidence. The Owner's recording request and role clarification authorize the design work; they do not accept each proposed architecture choice.

The design's open-choice register and individual decision footers retain the actual approval state. Vendor citations were checked live on 2026-11-21; versions remain research baselines requiring deployed qualification. Documentation checks establish neither measured performance nor running security/durability guarantees.

Builder Codex uses the OpenAI GPT-6 family, as stated by the builder and supplied in the Owner's audit request. The compliance auditor reports Claude Fable 5.2 from Anthropic's Claude family in the [second audit](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7073035741). Those families differ. The technical Reviewer's host is Antigravity; its actual model family remains unestablished and has not been inferred from the host name or accepted as a waived evidence gap.

<a id="acceptance-criteria-and-evidence"></a>
<a id="required-completion-milestones"></a>
<a id="completion-review"></a>

## 4. Delivery records

The Owner directed review in order: process the Reviewer's comments and corrective rechecks, then the auditor's comments and corrective rechecks, repeating until the participants agree the work is complete. The technical round for the earlier revision is complete on eebfa14b55dda7f6f64eefc0f66c04e9c540c346, with all review threads resolved. The [initial compliance audit](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7071338808) and [second audit](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7073035741) remain the compliance record. The [third audit](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7073723685) requires coordination, a technical recheck, and current publication records. The Owner-directed consolidation above resolves identifier ownership and delivery order; its execution and the combined candidate still require verification. Technical-review acceptance does not dispose of compliance findings. Merge remains on hold for corrective verification, the remaining architecture choices and final acceptance.

The Owner also supplied the [published editorial supplement](https://github.com/NobleFactor/noblefactor-engprod/pull/618#issuecomment-7073220254) assessing the design's arc42 coverage and Google style. The correction adds stakeholder, context, deployment, goal, and risk views; defines terms; and clarifies prose and protocol sequences. The assessment's scores use its author's rubric, not an official certification. The intended technical choices and protocol behavior are retained, but the revised presentation requires a corrective technical review. Its diagrams remain unrendered in this session. The archive's proposed architecture decisions are unchanged.

Publishing a draft or passing CI does not complete Task #623 or the roadmap. After the reviews, Owner acceptance and an observed merge, record the exact merge revision and results on the served issues, refresh open-issue document links to the default branch and any issue closed by that PR to its merge revision, and preserve the outstanding roadmap and completion-record obligations. The archive Epic and implementation Features remain open until their own completion evidence is accepted.
