---
title: "Align schedule and scenario command consumers"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/581
status: active
created: 2026-11-16
updated: 2026-11-19
documents:
  - kind: "Design: the schedule commands"
    path: docs/architecture/issue-data-model/8-the-schedule-commands.md
    text: "section 8"
  - kind: "Design: the scenario commands"
    path: docs/architecture/issue-data-model/9-the-scenario-commands.md
    text: "section 9"
  - kind: The handbook
    path: docs/engineering/index.md
    text: "docs/engineering/index.md"
  - kind: Related design
    path: docs/architecture/issue-data-model/index.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/551
    text: "Handbook adoption"
---

# Align schedule and scenario command consumers

The schedule-progress skill, data-model index and linked handbook pages still describe commands and collection behavior superseded by Scenario commands (#507) and PR #580. The skill reads about 1,100 issues to answer a question now served by one project.

Deliver a consistent skill and documentation set for the implemented schedule/scenario commands, with observed read-only routing evidence, preserved historical records and explicit dispositions for the handbook's policy questions.

## 1. Roles and authority

Owner: David Noble. Participant: this Codex session, assigned as coder on Handbook adoption (#551). The Owner appoints independent review and compliance auditing; neither delegation nor cross-session communication is authorized by this plan. The priority change is recorded in the conversation and Schedule amendment. The Owner's separate implementation-plan approval is recorded in [Approval and departures](#12-approval-and-departures).

## 2. Scope and promised result

One documentation worktree serves the two issues. Start with the skill/index corrections, then reconcile the handbook inventory. Obtain Owner review of the committed plan before implementation. Preserve existing feature ownership and satisfied dependencies. Do not change the command implementation or GitHub configuration under this plan. The Owner's review direction also covers the work-asset definitions and the full documentation rewrite in section 7.4. The complete inventory and review gates are recorded below.

## Issue 581

Skill/index update (#581), under Skills standard and catalog (#550), is the first priority. Route schedule status and next-work questions through schedule get, scenario views through scenario get, and discovery through the corresponding list commands. Keep the broad report for epic, feature, bug and search questions. Correct the index's retired move command, Scenario retirement, Triage exceptions, closed-item membership, Beat definition and amendment mechanics.

## Issue 582

Handbook command alignment (#582), under Shared documentation (#419), is the second priority. Reconcile the issue's twelve-page inventory against the implemented commands and sections 8 and 9. Separate statements of required behavior from claims about automation that has not been implemented. Resolve affected policy choices before writing an answer into an authoritative document.

## 3. Current state

PR #580 merged on 2026-11-17 at 00:12:21 UTC as b75b29ad6e4391c25bec8837164f3f59acb3abec; Scenario commands (#507) is closed. The native dependencies are satisfied. The Owner requested immediate priority on 2026-11-16 local time. The supported issue move command placed these issues at Steps 2 and 3, before Issue forms (#572), preserving the previous steps' relative order. The Schedule project's current rows remain authoritative.

The installed star runtime reports build 1ae1da72; GitHub's comparison places it on develop's ancestry. The current engprod extension exposes issue move and the schedule/scenario commands. Do not replace another session's installed build. Recheck the installed interfaces and command-delivery revision before live verification.

Concurrent commits and merges by other workers are expected. Open this worktree from a freshly fetched target, inspect its actual baseline, and scope integration to this work. Do not reject another worker's PR merely because it is open, modify another worktree, or rebase.

## 4. Design impact

No new runtime design is proposed. Align consumer documentation with the implemented contracts and approved policy. Preserve incoming anchors and original Owner-response/source evidence. If implementation and approved design disagree, record the precise difference and consult the Owner rather than silently selecting one.

## 5. Proposed implementation

Update the skill's description and examples for schedule get/list and scenario get/list, retaining the assignment lookup, evidence requirements and broad-report use cases. Document the smaller read scope without breach-cost estimates. Review skill-authoring guidance before editing the shared asset and preserve host-consumable metadata.

Correct the data-model index, then inventory every page named by Handbook command alignment. Follow references to discover additional competing instructions. Distinguish the issue command group from the planned issue-open operation (#338), document the Triage exceptions and current collection lifecycles, and retain the boundary between approved behavior and implemented automation.

Use the adopted one-source-line-per-paragraph rule, reconfirmed by the Owner on 2026-11-16. The conflicting 120-column suggestions have been corrected in both issue bodies. Preserve language-specific code/comment formatting and immutable source snapshots.

Carry the previously recorded Handbook consolidation (#420) completion-only bookkeeping into its execution plan and adoption review using the established merge, verification, cleanup and Owner-closure evidence. This records completed work; it creates no new delivery milestone.

## 6. Questions and existing decisions

1. Scenario cleanup is manual until recurring automation is delivered; the Owner approved this interim policy on 2026-11-17, and automation is tracked separately in #593.
2. Should the PR script invoke schedule close after the last open step? Apply existing Owner-approval and completion gates; the desired automation remains subject to its recorded decision.
3. Triage-to-Backlog is a verified current implementation limitation; document the supported interface, with further issue-tooling work coordinated separately by the Owner.
4. Should the Schedule template follow the form's separate Exit criteria and Evidence of completion sections? Consult the existing forms-as-authority ruling and the preserved Issue forms (#572) decisions before treating this as a new policy question.

Bring genuinely unresolved questions to the Owner individually. Answers already established by adopted rules are applied with their source recorded rather than requested again. Question-dependent passages do not prevent independent skill/index work after plan approval.

### 6.1. Dispositions recorded on 2026-11-17

Question 1 was resolved by the Owner on 2026-11-17 in this conversation: manual cleanup is the interim policy, with recurring automation planned separately. Remove closed finding rows manually and verify the result, preserving the Scenario issue's own row, option, open findings and existing origin/closure evidence. [Recurring Scenario cleanup (#593)](https://github.com/NobleFactor/noblefactor-engprod/issues/593) tracks the automation under Issue tooling (#332); its Task type, Product Area, Medium Priority, N/A Severity, native parent and Open engprod Triage row were read back. It is outside this schedule's commitment and does not block these documentation changes.

Question 2 retains the existing Owner completion gate in Engineering process and the PR procedure. This change adds no automatic schedule closure to the PR script. Any later automation must preserve Owner authorization, closed-step and exit-criteria checks; no such automation is claimed here.

Question 3 is answered for this documentation change by inspection of the installed extension and develop at 97d1e12f66fff8fe085f0e3dee3103db480a6b3c: the sources match, and an ordinary issue in Triage is refused by `issue move --backlog` because it is on no Schedule. Explicit Scenario-to-Triage and Scenario-to-Schedule moves already record the origin and remove the old row. The Owner directed this worker to document what is true now and will coordinate further issue-tooling implementation with the parallel worker. This describes a current limitation, not a permanent manual-only policy.

Question 4 is settled by the forms-as-authority ruling preserved in the adoption review's F20 and Issue forms (#572) handoff. The schedule template now distinguishes the account form's Exit criteria and Evidence of completion sections; it does not define a competing issue shape.

## 7. Acceptance and evidence

| Criterion | Evidence |
| --- | --- |
| Schedule status uses the narrow command | In this session, consume the revised skill and answer status with one schedule get call; retain invocation and output |
| Scenario view uses the narrow command | Answer a scenario-view request with one scenario get call and its Beat-ordered output |
| Discovery and broad reporting retain distinct purposes | Verify list help/output; review skill examples for account/team scope and remaining report use cases |
| Index and handbook agree with delivered behavior | Review every issue-table row and perform a second pass against sections 8/9 and implemented help |
| Open questions have explicit dispositions | Owner decisions or existing authoritative rulings linked from the affected issue/plan |
| Documentation is navigable and preserved | Metadata, spelling, local references, stable anchors and original source hashes pass |
| Every inventoried document is covered | The rewrite review records each document's disposition, retained requirements and any relocation |
| Maintained prose meets the adopted writing guidance | A separate Google-based review records and resolves findings across the complete document bodies |
| Architecture meets the adopted content guidance | Each architecture set has explicit arc42 coverage and a reviewed explanation of the system |
| Delivery meets repository gates | Run the actual make check target and required GitHub checks for the rewritten head |
| The change is adopted and verified | Owner review, merge, live skill/reference verification, issue/project updates and cleanup evidence |

### 7.1. Implementation verification — 2026-11-17

After consuming the revised skill, one `star github schedule get NobleFactor/noblefactor-engprod#551` call returned the Schedule issue followed by its fifteen Step rows; one `star github scenario get NobleFactor/noblefactor-engprod#152` returned the Scenario issue and its two findings in Beat order. `star github schedule list NobleFactor --team engprod` also passed. The exact invocations, outputs and timestamps are retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/routing-verification.7tg9jzn_/receipt.json and its sibling output files. These were normal read-only invocations, not dry runs.

The shared skill retains its original top-level title, as required by the repository's documentation standard and frontmatter gate. The corrected document verifier checks that format plus the skill's name and description with the existing /opt/local/bin/python3.12 and installed PyYAML; no dependency installation or shared tool replacement was needed. Native Codex packaging is not qualified by these checks. Its validator rejects the top-level title required here; reconciling the shared format and native host bindings belongs to Skills curation (#560) and Codex consumption (#563).

Read-only document verification covers the 25 named Markdown/skill files, their local references, frontmatter, retained explicit anchors, all 23 preserved source/review files and the unchanged original Owner-assignment appendix. The current receipt records the observed link count and file hashes. The verifier is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-documents.py; its current receipt and complete output are beside it. The implementation includes no runtime code. Spelling passes for the changed files. Historical status companions, source snapshots and Owner quotations remain preserved.

The earlier Owner-run `make check` passed for the plan checkpoint at 340f2cf7a5744460f1afd13b54a0ac16450a7dbd. The Owner-run implementation attempt on 2026-11-17 failed the repository frontmatter gate because this session had unnecessarily moved the skill's title under metadata to satisfy the native Codex validator. The complete failure output is retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.lSkcCZES. The title is restored and the verifier follows the existing repository format. The Owner's retry passed on 2026-11-17 at 22:21:31 UTC: make check exited 0, with 181 Markdown files checked, one exemption and no frontmatter errors; all other repository gates and tests passed. Verification covered the 25 frozen paths, 273 local references and 23 preserved sources. The named-path staging dry run left the index unchanged. The complete result and content hashes are retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.YGz2hbIa/receipt.json. This plan update records that established result. The Owner then ran the local commit/integration script: implementation commit 0e44ce0ef779460306235714d010be7cd95edbeb was merged with develop at 97d1e12f66fff8fe085f0e3dee3103db480a6b3c to produce 146d7c561c3926a3e1af91e8eca35adeedc6f0e6. The four upstream files do not overlap the 25 reviewed documents. The post-integration document checks and make check passed, and the checkout was clean at 2026-11-17T22:48:23.235257+00:00. The complete integration record is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.ju3TZOQA/integration-receipt.json. PR publication, review, target-branch merge and deployed-skill verification remain separate milestones.

The Owner's 2026-11-17 ruling in [Issue filing (#338)](https://github.com/NobleFactor/noblefactor-engprod/issues/338) names the planned command `star github issue open`, with `create` as its synonym. Current prose follows that name while keeping the operation marked as undelivered; captured sources and historical Owner appendices remain unchanged.


### 7.2. Owner review correction — 2026-11-17

The Owner clarified the methodology: designs describe what we want; plans explain how to get there from what exists; schedules order the issues we will carry out. Planning produces issues and a schedule, and each issue references one or more plans. Designs explain the wanted system and its significant design decisions. Transition decisions and migration history belong in plans. All documents must use plain language.

After reviewing the copy in the Issue verbs (#589) worktree, the Owner explicitly directed this session to revise docs/engineering/work-assets.md in its own current worktree. This correction adds the definitions and handoff, states that an issue can use several plans and a plan can cover several issues, removes unnecessary consolidation history and simplifies the prose. Existing storage, linking and approval requirements and incoming anchors are preserved. The Owner subsequently required the full rewrite within this PR; sections 7.4 to 7.7 record that scope and its acceptance checks.

The two local changes are this plan and the work-assets document. Earlier gate results remain evidence for their named revisions. The revised candidate must pass document checks, an Owner-run make check, publication to PR #596, fresh CI and review before merge. The previous merge command is replaced while these corrections are pending.

### 7.3. Design decisions and transition history — 2026-11-18

The Owner clarified that a design decision explains what the system should be and why. Relevant alternatives and tradeoffs belong with that explanation. A transition decision explains how to reach the wanted system from what exists and belongs in a plan. The earlier work-assets correction excluded rulings and rejected approaches too broadly; this review correction makes the distinction explicit.

The initial two-file correction was published at 7a30967d21033c140d8cfd7c3897bb8cf8b59645 after the Owner-run make check passed. Its publication and PR-description readback are recorded in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/finish-review.h7eQzeWM/receipt.json. This clarification changes the work-assets definition and this plan. Read-only document checks passed on 2026-11-18 for all 26 reviewed files and 285 local references, with all 23 preserved source/review files and the original Owner appendix unchanged. The evidence is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/design-decision-clarification-verification.json. An Owner-run make check, publication and review remain required.

The Owner also approved Google writing guidance as the basis of the shared writing-and-review skill and arc42 as the basis of architecture content. [Google writing and review (#599)](https://github.com/NobleFactor/noblefactor-engprod/issues/599) and [arc42 architecture content (#600)](https://github.com/NobleFactor/noblefactor-engprod/issues/600) are open at Steps 4 and 5 of Handbook adoption (#551), after this PR's work. They can be planned independently. Their implementation plans, publication and qualification remain separate work. The approved guidance can inform corrections in this PR without claiming that either new deliverable is complete.

### 7.4. Full rewrite and merge condition — 2026-11-18

The Owner requires all documents in the inventory below to be rewritten or given their explicit record-preservation treatment. PR #596 must not merge until the maintained prose meets Google's writing guidance and each architecture set meets arc42's content requirements. The earlier acceptance and passing checks establish their named revisions only. They do not approve the rewrite or satisfy its merge condition.

The inventory includes every document already changed by this PR, every architecture chapter and status companion in this repository, and the shared documentation standard, design template and navigation pages needed to support the rewrite. Review each document's complete body, not only the lines changed for command alignment. Preserve completed plans and source evidence as records; their history is appropriate to their purpose. No architecture chapter or affected handbook page is deferred to a later publication task.

### 7.5. Writing and architecture review

Use the [Google developer documentation style guide](https://developers.google.com/style), [style highlights](https://developers.google.com/style/highlights), [timeless documentation guidance](https://developers.google.com/style/timeless-documentation) and [documentation best practices](https://google.github.io/styleguide/docguide/best_practices.html). Apply purpose, audience, useful organization, descriptive headings, direct sentences, consistent terminology and removal of unnecessary or duplicated material. Do not turn a keyword scan or a shorter word count into proof of good writing. Keep the adopted US English, numbered sections and one physical source line per prose paragraph.

Use the [arc42 content overview](https://arc42.org/overview/) and [architecture-decision guidance](https://docs.arc42.org/section-9/). Review three architecture sets: agent schedules, the issue data model, and the agentic developer workstation. Each set must explain the applicable concerns in the table below, with links to its detailed chapters. Sections may be combined where that makes the explanation clearer. A genuine omission needs a specific reason; empty headings and repeated boilerplate do not establish coverage.

| Architecture concern | Required explanation |
| --- | --- |
| Introduction and goals | The problem, users, intended result and most important quality goals |
| Constraints | Requirements and limits that shape the system |
| Context and scope | The system boundary, external actors and external systems |
| Solution strategy | The main approach and why it meets the goals |
| Components | Responsibilities, relationships and important interfaces |
| Runtime behavior | Important interactions, normal flows and failure cases |
| Deployment | Where components run, their connections, storage and access boundaries |
| Shared concepts | Rules and mechanisms used across components |
| Design decisions | Significant choices, their reasons, relevant alternatives and consequences |
| Quality requirements | Observable scenarios or criteria for the qualities that matter |
| Risks and technical debt | Material uncertainty and known limitations, clearly distinguished from approved behavior |
| Glossary | Necessary domain terms defined once and used consistently |

Designs describe the wanted system. Significant system choices and their rationale stay in the design. Transition decisions, migration steps, rollout history and raw review exchanges move to plans or their linked evidence. Google's document-lifecycle advice does not replace the local meanings of designs, plans and schedules.

### 7.6. Rewrite method and evidence

1. Commit this plan amendment and review it with the Owner before rewriting the documents.
2. Build a content map for each architecture set and a source map for its requirements. Read the approved designs, applicable plans, issue decisions, implementation, man pages, completions and tests. Distinguish designed behavior from delivered and verified behavior.
3. Rewrite each architecture set as a coherent explanation. Rewrite the remaining maintained documents for their own purposes and audiences. Align the handbook, templates, skill, roadmap and user-facing references with those explanations.
4. Resolve genuine contradictions without inventing requirements. The standalone Claude launcher, proposed assignment commands and five-role workstation have different scopes; explain those scopes and bring substantive unresolved choices to the Owner.
5. Relocate transition material into this plan or the applicable approved plan, retaining source links to the published revision. Preserve exact Owner source material where its wording matters. Replace a migration-only design page with a clear reference to its plan when that is its proper destination.
6. Preserve incoming link targets or update their callers with explicit evidence. Put significant system choices and their reasons in decision companions, and delivery progress and transition history in the applicable plans. Preserve the source material when replacing status companions. Refresh the inventory against the integrated Issue verbs work, then update the documentation verifier to cover it and each relocated source block.
7. Review the rewritten set separately for writing, arc42 content, retained requirements and cross-document consistency. Record the document and passage for each finding and its resolution. The Owner appoints any independent reviewer; this plan does not grant cross-session contact or delegation.
8. Run the repository's actual make check and required GitHub checks for the final head. Present the rewrite, coverage evidence and resolved findings for Owner review. Keep the PR a draft until the required review permits it to become ready.

The writing-and-review skill (#599) and architecture guidance (#600) remain separate publication tasks. This PR applies the approved primary guidance directly. Their later completion cannot substitute for this PR's writing and architecture reviews.

### 7.7. Complete document inventory

The refreshed inventory has 51 documents after bringing in the Issue verbs architecture and its decision companions. Every row receives an explicit disposition in the rewrite review. Rewriting a design means rebuilding its explanation and organization, not retaining a historical overlay under arc42 headings.

| Document | Required work |
| --- | --- |
| [Home/common/.claude/skills/star-github-schedule-progress/SKILL.md](../../../Home/common/.claude/skills/star-github-schedule-progress/SKILL.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [README.md](../../../README.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/architecture/agent-schedule/1-session-model.md](../../architecture/agent-schedule/1-session-model.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/agent-schedule/1-session-model.status.md](../../architecture/agent-schedule/1-session-model.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/agent-schedule/2-command-line.md](../../architecture/agent-schedule/2-command-line.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/agent-schedule/2-command-line.status.md](../../architecture/agent-schedule/2-command-line.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/agent-schedule/2.1-agent-schedule-commands.md](../../architecture/agent-schedule/2.1-agent-schedule-commands.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/agent-schedule/2.1-agent-schedule-commands.status.md](../../architecture/agent-schedule/2.1-agent-schedule-commands.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/agent-schedule/3-agent-sandbox.md](../../architecture/agent-schedule/3-agent-sandbox.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/agent-schedule/3-agent-sandbox.status.md](../../architecture/agent-schedule/3-agent-sandbox.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/agent-schedule/index.md](../../architecture/agent-schedule/index.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/agentic-developer-workstation.md](../../architecture/agentic-developer-workstation.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/1-hierarchy.md](../../architecture/issue-data-model/1-hierarchy.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/1-hierarchy.status.md](../../architecture/issue-data-model/1-hierarchy.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/2-attributes.md](../../architecture/issue-data-model/2-attributes.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/2-attributes.status.md](../../architecture/issue-data-model/2-attributes.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/3-collections.md](../../architecture/issue-data-model/3-collections.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/3-collections.status.md](../../architecture/issue-data-model/3-collections.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/4-storage-and-reach.md](../../architecture/issue-data-model/4-storage-and-reach.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/4-storage-and-reach.status.md](../../architecture/issue-data-model/4-storage-and-reach.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/5-from-todays-scheme.md](../../architecture/issue-data-model/5-from-todays-scheme.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/5-from-todays-scheme.status.md](../../architecture/issue-data-model/5-from-todays-scheme.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/6-the-asset-and-its-sync.md](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/6-the-asset-and-its-sync.status.md](../../architecture/issue-data-model/6-the-asset-and-its-sync.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/7-the-workflow-before-and-after.md](../../architecture/issue-data-model/7-the-workflow-before-and-after.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/7-the-workflow-before-and-after.status.md](../../architecture/issue-data-model/7-the-workflow-before-and-after.status.md) | Preserve decisions in a decision companion and progress in the applicable plan; retain incoming references |
| [docs/architecture/issue-data-model/8-the-schedule-commands.md](../../architecture/issue-data-model/8-the-schedule-commands.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/8-the-schedule-commands.decisions.md](../../architecture/issue-data-model/8-the-schedule-commands.decisions.md) | Review significant system choices, reasons, alternatives and consequences; keep progress in plans |
| [docs/architecture/issue-data-model/9-the-scenario-commands.md](../../architecture/issue-data-model/9-the-scenario-commands.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/architecture/issue-data-model/9-the-scenario-commands.decisions.md](../../architecture/issue-data-model/9-the-scenario-commands.decisions.md) | Review significant system choices, reasons, alternatives and consequences; keep progress in plans |
| [docs/architecture/issue-data-model/10-the-issue-commands.md](../../architecture/issue-data-model/10-the-issue-commands.md) | Review the delivered issue command contract with its architecture set |
| [docs/architecture/issue-data-model/10-the-issue-commands.decisions.md](../../architecture/issue-data-model/10-the-issue-commands.decisions.md) | Review significant system choices and their reasons; preserve the accepted write order |
| [docs/architecture/issue-data-model/index.md](../../architecture/issue-data-model/index.md) | Rewrite as part of its architecture set; review Google writing and arc42 coverage |
| [docs/engineering/agent-operation.md](../../engineering/agent-operation.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/engineering/index.md](../../engineering/index.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/engineering/process.md](../../engineering/process.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/engineering/procedures/pull-request.md](../../engineering/procedures/pull-request.md) | Apply the permanent PR disclosure rule; review Google writing and consistency |
| [docs/engineering/review/adoption-review.md](../../engineering/review/adoption-review.md) | Keep decisions and evidence recoverable; revise maintained explanations and references |
| [docs/engineering/review/open-decisions.md](../../engineering/review/open-decisions.md) | Keep decisions and evidence recoverable; revise maintained explanations and references |
| [docs/engineering/work-assets.md](../../engineering/work-assets.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/engineering/work-organization.md](../../engineering/work-organization.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/github-branch-protection.md](../../github-branch-protection.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/guides/pr-script-template.md](../../guides/pr-script-template.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/index.md](../../index.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/issue-standards.md](../../issue-standards.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/plans/doc/420-consolidate-engineering.md](../../plans/doc/420-consolidate-engineering.md) | Preserve the completed record; update a reference only if relocation requires it |
| [docs/plans/doc/581-schedule-command-consumers.md](../../plans/doc/581-schedule-command-consumers.md) | Maintain the approved approach, transitions, progress and evidence |
| [docs/roadmaps/agentic-developer-workstation.md](../../roadmaps/agentic-developer-workstation.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/standards/documentation.md](../../standards/documentation.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/templates/design.md](../../templates/design.md) | Rewrite for its audience and purpose; review Google writing and consistency |
| [docs/templates/schedule.md](../../templates/schedule.md) | Rewrite for its audience and purpose; review Google writing and consistency |

### 7.8. Integration checkpoint

The Owner ran the integration script on 2026-11-19. The actual make check passed before integration: 189 documents checked, one exemption, no frontmatter errors, and every other gate and test passed. The six disclosure and plan files were committed as 5a8383ddc1ede02f009a76eaaca1a4fa17a64bdf. The merge of Issue verbs revision 643652b617f6c95414fbd8c7ab958ffc4d422494 then stopped with twelve documentation conflicts. Its receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/integration-checkpoint/runs/20261119T081313Z/receipt.json.

The working-file reconciliation combines the delivered command names, Backlog rules, source validation and decision companions with the prior Triage exclusions, Scenario closure and cleanup instructions, link targets, and permanent PR disclosure rule. The inventory now includes section 10 and the three decision companions in place of the deleted section 8 and 9 status pages. Conflict-marker removal does not stage the files or complete the merge.

The Owner staged the reviewed resolutions, passed the integrated make check and committed the merge as 7b6e64520a6047687fddd28aaf8808b6ff4ce707. Publication stopped before any push because develop had advanced to 9bf246b4c074550c03b842bce5111e33ba34800e. The receipt is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/merge-reconciliation/finish-integration/20261119T175544Z/receipt.json. Both passing gates establish their recorded revisions; the next integration requires its own gate. Review the refreshed plan checkpoint before directing the full rewrite.

The two residual review findings, Table validation (#606) and Recovery guidance (#607), were subsequently fixed in PR #610. The integration below brings in those fixes. Automatic recovery is separate work in Task #609. Orphaned links remain within Writ upgrade (NobleFactor/devlore-cli#845).

### 7.9. Squash-merge and closing-reference integration

Develop advanced through [Squash-merge configuration (#605), PR #610](https://github.com/NobleFactor/noblefactor-engprod/pull/610), at 9bf246b4c074550c03b842bce5111e33ba34800e. Its [approved plan](../../plans/feature/605-squash-message.md) records the Owner's merge and closing-reference decisions and the fixes for Table validation (#606) and Recovery guidance (#607).

Integrate this revision into the clean local checkpoint 7b6e64520a6047687fddd28aaf8808b6ff4ce707. Preserve the incoming runtime and tests unchanged. Keep the template's two parts: publication and readiness first, then delivery records after the Owner merges in GitHub. Keep the permanent requirement to name the submitting agent in the PR description. Adopt closing references for issues the PR completes, with reopening if deployment or verification fails. References without a closing keyword remain appropriate for partial delivery.

The Section 10 guidance distinguishes the limits of rerunning open, reopen, close and move. Automatic recovery remains in Task #609. The broader PR-procedure rewrite remains part of Handbook command alignment (#582); this integration does not claim that rewrite is complete or that every remaining policy reference is already reconciled.

Prepared resolutions, the previous script and source comparisons are preserved under /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/merge-reconciliation/advance-610. The Owner-run sync-and-publish mode verifies the exact local and remote revisions, merges the inspected target, applies only these reviewed resolutions, runs make check and commits the integration before publishing. It stops if the target advances again or another worker changes the inspected records. It leaves PR #596 a draft, keeps both issues open, and performs no PR merge, worktree cleanup or canonical-clone maintenance.

The integrated make check passed, and this commit completes the reviewed integration of PR #610. Publication, current-head CI and Owner review remain separate milestones.

## 8. Completion milestones

Preserve the common commandments and five role entry points accepted in PR #601, merged as 967764ae13b015543a2d0667e907b0fd37283875. Integrate the current target through the Owner-run checkpoint script. Review their references when rewriting handbook pages; their publication does not qualify native host loading.


Implementation, Owner review, merge and post-merge verification are required. Confirm that the deployed shared skill resolves to the delivered content before claiming it available in another host. This work does not qualify the later five-role host bindings or implement an auditor service.

## 9. Phases

### 9.1. Preparation

- [x] Identify both recent Triage issues and verify the merged command dependency.
- [x] Record the Owner-approved priority amendment and verify Steps 2 and 3.
- [x] Owner created the worktree and verified the one-file staging dry run; the index stayed unchanged. Receipt: /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/prepare.5mkFWiLR/receipt.json.
- [x] Commit the draft plan as the first checkpoint at 340f2cf7a5744460f1afd13b54a0ac16450a7dbd; the subsequent Owner approval and direction are recorded below.
- [x] Owner approved the committed plan on 2026-11-17 and directed continuation of the work.

### 9.2. Reconciliation

- [x] Update the skill and data-model index; validate the existing repository skill format with Python 3.12/PyYAML and record one-call schedule/scenario routing plus schedule-list evidence in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/routing-verification.7tg9jzn_/receipt.json.
- [x] Reconcile the delivered-command descriptions in the handbook inventory and linked design chapters, including the agent-operation routing conflict and preserved incoming anchors; remaining policy choices are recorded separately below.
- [x] Consult prior decisions and record all four dispositions: manual cleanup pending #593, the existing Owner closure gate, verified issue-move behavior, and forms as body authority.
- [x] Incorporate the established Handbook consolidation (#420) merge, adoption, post-merge verification, Owner closure and cleanup evidence into its plan and adoption review for this implementation commit.

### 9.3. Delivery

- [x] Complete document/link/source checks and the Owner-run make check; record the passing result and unchanged-index staging dry run in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.YGz2hbIa/receipt.json. The Owner-run integration gate also passed at 146d7c561c3926a3e1af91e8eca35adeedc6f0e6.
- [x] Prepare and check the Owner-run publication script, with explicit staging of this verification record, preserved integration evidence, human sign-off and the effective assistance disclosure. The Owner decides publication by reviewing and running that mode.
- [ ] Obtain review and adoption, merge, verify delivered/deployed content, update issues and Schedule rows, and clean up.

### 9.4. Owner review correction

- [x] Revise the work-assets definitions, relationships and prose as explicitly directed by the Owner, preserving existing requirements and anchors.
- [x] Verify and publish the initial two-file correction at 7a30967d21033c140d8cfd7c3897bb8cf8b59645; retain the Owner-run gate and publication evidence cited above.
- [x] Apply the Owner's distinction between design decisions and transition history to work-assets and this plan.
- [x] Verify the clarification's document scope, metadata, links, anchors and preserved evidence; retain the receipt cited in section 7.3.
- [x] Run the Owner's repository gate and publish the clarification at f8d7702f971fb9967a7f3bc39a375cea6d3cff50; its passing publication receipt is recorded above.
- [ ] Obtain Owner review and passing final-head CI for the full rewrite before merge.

### 9.5. Full documentation rewrite

- [x] Record the Owner's full-rewrite scope, primary sources, complete inventory and no-merge condition.
- [x] Commit this full-rewrite plan amendment as the next plan checkpoint.
- [ ] Obtain Owner review of the committed amendment and direction to begin the full rewrite.
- [ ] Map the architecture content, source requirements and incoming references across the inventory.
- [ ] Rewrite all maintained documents in the inventory and update the related status and reference records.
- [ ] Complete and record the writing, arc42, requirement-preservation and consistency reviews; resolve their findings.
- [ ] Pass make check and final-head CI, obtain Owner review, and satisfy the explicit merge gate.

### 9.6. Issue verbs integration

- [x] Owner ran make check and committed the six approved disclosure and plan files at 5a8383ddc1ede02f009a76eaaca1a4fa17a64bdf.
- [x] Reconcile the twelve conflicted working files and refresh the 51-document inventory.
- [x] Stage the reviewed resolutions, pass the integrated gate and commit the pending merge through the Owner-run script.
- [ ] Publish the refreshed plan checkpoint and obtain review and direction before the full rewrite.

### 9.7. Incorporate the later merge

- [x] Inspect PR #610, its approved plan and all ten incoming paths; prepare the three documentation resolutions while preserving the permanent disclosure rule.
- [x] Integrate 9bf246b4c074550c03b842bce5111e33ba34800e, pass make check and commit this checkpoint through the Owner-run script.
- [ ] Publish the refreshed checkpoint, pass current-head CI, and obtain Owner review and direction before the full rewrite.

## 10. Files and related assets

Primary files are Home/common/.claude/skills/star-github-schedule-progress/SKILL.md and docs/architecture/issue-data-model/index.md. The handbook issue lists docs/issue-standards.md, docs/engineering/work-organization.md, docs/engineering/process.md, docs/templates/schedule.md, docs/guides/pr-script-template.md, README.md, docs/github-branch-protection.md, docs/engineering/review/open-decisions.md, the three agent-schedule architecture pages, and the optional workstation roadmap. Inspect exact current content and incoming references before editing.

## 11. Dependencies and overlaps

Preserve the satisfied #507 links. Preserve Skills (#550), Shared documentation (#419), Epic #526 and Schedule #551 ownership. Issue forms (#572) follows this priority work and retains its separate form decisions; do not silently redesign those forms here. Runtime bugs and missing automation are separate findings, not permission to expand into command implementation.

Issue verbs (#589) was delivered in PR #604 at 643652b617f6c95414fbd8c7ab958ffc4d422494 and is integrated locally as 7b6e64520a6047687fddd28aaf8808b6ff4ce707. Squash-merge configuration (#605), Closing references (#608), Table validation (#606) and Recovery guidance (#607) were delivered in PR #610 at 9bf246b4c074550c03b842bce5111e33ba34800e. Integrate that later revision before publication. Preserve its source plan and implementation unchanged; this worker does not take over their deployment or edit the other worker's worktree. The 51-document rewrite inventory is unchanged; the Squash-merge plan is a supporting reference.

## 12. Approval and departures

The Owner approved taking these issues onto the schedule for immediate attention on 2026-11-16. On 2026-11-17, after directing continuation, the Owner approved the committed plan at 340f2cf7a5744460f1afd13b54a0ac16450a7dbd in this conversation: “the plan is approved”. This authorizes implementation of the recorded scope. Git commands remain Owner-run or separately granted by exact command; no commit, push or PR execution authority is inferred from plan approval. The adopted paragraph-formatting and Owner-approval rules continue to apply.

On 2026-11-17, the Owner explicitly asked: “can you revise work-assets.md right now on your current worktree?” This authorizes the review correction described above within the existing worktree. It does not grant agent execution of Git or the PR script. The Owner's earlier reluctant acceptance applies to the earlier reviewed revision; the corrected candidate is presented for fresh review.

On 2026-11-18, the Owner distinguished design decisions from transition history, approved the two adoption tasks, and directed continuation. This authorizes the scoped review correction above. It does not grant agent execution of Git or the PR script, or replace the committed-plan and review requirements for the new tasks.

On 2026-11-18, after publication of f8d7702f971fb9967a7f3bc39a375cea6d3cff50, the Owner required all documents to be rewritten and prohibited merge until they comply with arc42 and Google's standards. PR #596 was returned to draft and its merge gate and Handbook command alignment (#582) were updated. This scope supersedes the earlier deferral of the broader rewrite. The plan amendment must be committed and reviewed before that rewrite begins. Git and PR-script execution remain Owner-run.

The Owner approved the Claude coder's recommended merge order: Issue verbs (#589) merges before PR #596, then this worktree integrates develop and refreshes its inventory from the delivered command definitions. The Owner also approved the document structure: designs describe the wanted system, decision companions explain significant choices and their reasons, and plans hold implementation progress and transition history. These decisions settle those review findings; the integration, inventory refresh and rewrite remain outstanding.

The Owner then directed: "Assisted by goes into PR descriptions. Make that change permanent." This authorizes the scoped disclosure correction in this worktree: the PR description names the submitting agent in `Assisted-by:`, keeps the human sign-off, and passes both trailers to the squash commit. Branch commits carry no trailers. Remove the temporary requirement to name Claude Code regardless of the submitting host. Align the handbook, O05 resolution and script specification. This direction supersedes the retained literal Claude Code instruction for this session; migration and qualification of the personal entrypoint files remain with Claude consumption (#562) and Codex consumption (#563). Git and script execution remain Owner-run.

The disclosure correction is committed locally in the six-file checkpoint and retained in the Issue verbs merge. Its focused validation evidence belongs under /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/permanent-pr-disclosure. Publication, final-head CI and merge remain outstanding.

## 13. Completion review

The initial full-rewrite plan checkpoint was published at cbdc89b9d4eb601b7b5c47eb1202b803a6b45c1c. The Owner approved the merge order and document structure. The six-file disclosure and plan checkpoint is committed at 5a8383ddc1ede02f009a76eaaca1a4fa17a64bdf after its Owner-run make check passed.

The Issue verbs integration is committed locally as 7b6e64520a6047687fddd28aaf8808b6ff4ce707 after its passing gate. The refreshed inventory has 51 documents. Publication stopped because develop advanced through PR #610; the next checkpoint incorporates that revision. The integrated make check passed, and this commit completes that integration. Publication, current-head CI and review of the refreshed plan remain outstanding. The full rewrite has not started. Keep PR #596 a draft and Skill/index update (#581) and Handbook command alignment (#582) open. The Owner merges only after the rewrite's merge condition is satisfied; deployed-content verification, completion approval and cleanup follow.
