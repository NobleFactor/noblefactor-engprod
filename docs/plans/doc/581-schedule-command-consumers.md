---
title: "Align schedule and scenario command consumers"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/581
status: active
created: 2026-11-16
updated: 2026-11-17
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

Owner: David Noble. Participant: this Codex session, assigned Handbook adoption (#551). The Owner appoints independent review and compliance auditing; neither delegation nor cross-session communication is authorized by this plan. The priority change is recorded in the conversation and Schedule amendment. The Owner's separate implementation-plan approval is recorded in [Approval and departures](#12-approval-and-departures).

## 2. Scope and promised result

One documentation worktree serves the two issues. Start with the skill/index corrections, then reconcile the handbook inventory. Obtain Owner review of the committed plan before implementation. Preserve existing feature ownership and satisfied dependencies. Do not change the command implementation or GitHub configuration under this plan.

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
| Delivery meets repository gates | Run the actual make check target and required GitHub checks for the delivered head |
| The change is adopted and verified | Owner review, merge, live skill/reference verification, issue/project updates and cleanup evidence |

### 7.1. Implementation verification — 2026-11-17

After consuming the revised skill, one `star github schedule get NobleFactor/noblefactor-engprod#551` call returned the Schedule issue followed by its fifteen Step rows; one `star github scenario get NobleFactor/noblefactor-engprod#152` returned the Scenario issue and its two findings in Beat order. `star github schedule list NobleFactor --team engprod` also passed. The exact invocations, outputs and timestamps are retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/routing-verification.7tg9jzn_/receipt.json and its sibling output files. These were normal read-only invocations, not dry runs.

The shared skill retains its original top-level title, as required by the repository's documentation standard and frontmatter gate. The corrected document verifier checks that format plus the skill's name and description with the existing /opt/local/bin/python3.12 and installed PyYAML; no dependency installation or shared tool replacement was needed. Native Codex packaging is not qualified by these checks. Its validator rejects the top-level title required here; reconciling the shared format and native host bindings belongs to Skills curation (#560) and Codex consumption (#563).

Read-only document verification covers the 25 named Markdown/skill files, their local references, frontmatter, retained explicit anchors, all 23 preserved source/review files and the unchanged original Owner-assignment appendix. The current receipt records the observed link count and file hashes. The verifier is /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-documents.py; its current receipt and complete output are beside it. The implementation includes no runtime code. Spelling passes for the changed files. Historical status companions, source snapshots and Owner quotations remain preserved.

The earlier Owner-run `make check` passed for the plan checkpoint at 340f2cf7a5744460f1afd13b54a0ac16450a7dbd. The Owner-run implementation attempt on 2026-11-17 failed the repository frontmatter gate because this session had unnecessarily moved the skill's title under metadata to satisfy the native Codex validator. The complete failure output is retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.lSkcCZES. The title is restored and the verifier follows the existing repository format. The Owner's retry passed on 2026-11-17 at 22:21:31 UTC: make check exited 0, with 181 Markdown files checked, one exemption and no frontmatter errors; all other repository gates and tests passed. Verification covered the 25 frozen paths, 273 local references and 23 preserved sources. The named-path staging dry run left the index unchanged. The complete result and content hashes are retained in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.YGz2hbIa/receipt.json. This plan update records that established result. No implementation commit, push, PR, merge or deployment is claimed. Another worker's Issue-move read ordering (#531) landed in PR #586 after this checkpoint; integrate current develop by an Owner-run merge before delivery and recheck any resulting revision.

The Owner's 2026-11-17 ruling in [Issue filing (#338)](https://github.com/NobleFactor/noblefactor-engprod/issues/338) names the planned command `star github issue open`, with `create` as its synonym. Current prose follows that name while keeping the operation marked as undelivered; captured sources and historical Owner appendices remain unchanged.

## 8. Completion milestones

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

- [x] Complete document/link/source checks and the Owner-run make check; record the passing result and unchanged-index staging dry run in /Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.581-schedule-command-consumers/verify-update.YGz2hbIa/receipt.json. Recheck the integrated revision before delivery.
- [ ] Prepare the Owner-run PR script and publish only on explicit authorization.
- [ ] Obtain review and adoption, merge, verify delivered/deployed content, update issues and Schedule rows, and clean up.

## 10. Files and related assets

Primary files are Home/common/.claude/skills/star-github-schedule-progress/SKILL.md and docs/architecture/issue-data-model/index.md. The handbook issue lists docs/issue-standards.md, docs/engineering/work-organization.md, docs/engineering/process.md, docs/templates/schedule.md, docs/guides/pr-script-template.md, README.md, docs/github-branch-protection.md, docs/engineering/review/open-decisions.md, the three agent-schedule architecture pages, and the optional workstation roadmap. Inspect exact current content and incoming references before editing.

## 11. Dependencies and overlaps

Preserve the satisfied #507 links. Preserve Skills (#550), Shared documentation (#419), Epic #526 and Schedule #551 ownership. Issue forms (#572) follows this priority work and retains its separate form decisions; do not silently redesign those forms here. Runtime bugs and missing automation are separate findings, not permission to expand into command implementation.

## 12. Approval and departures

The Owner approved taking these issues onto the schedule for immediate attention on 2026-11-16. On 2026-11-17, after directing continuation, the Owner approved the committed plan at 340f2cf7a5744460f1afd13b54a0ac16450a7dbd in this conversation: “the plan is approved”. This authorizes implementation of the recorded scope. Git commands remain Owner-run or separately granted by exact command; no commit, push or PR execution authority is inferred from plan approval. The adopted paragraph-formatting and Owner-approval rules continue to apply.

## 13. Completion review

The implementation candidate is written; targeted document, spelling and routing checks and the Owner-run full repository gate passed for the verified content. Owner review, integration verification, delivery and post-merge evidence remain outstanding. Keep the issues open and the plan active until their required milestones and Owner completion approval are recorded. Record established post-merge results immediately on the issues and carry completion-only documentation through the approved follow-up procedure.
