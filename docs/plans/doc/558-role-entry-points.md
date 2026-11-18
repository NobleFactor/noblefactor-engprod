---
title: "Common commandments and five role entry points"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/558
status: draft
created: 2026-11-18
updated: 2026-11-18
documents:
  - kind: Design
    path: docs/architecture/agentic-developer-workstation.md
    text: "Agentic developer workstation"
  - kind: Handbook
    path: docs/engineering/index.md
    text: "Engineering handbook"
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/551
    text: "Handbook adoption"
---

# Common commandments and five role entry points

## 1. Roles and authority

Owner: David Noble. Participant: this Codex session. The Owner appoints reviewers and the compliance auditor. This plan does not authorize cross-session contact, delegation, Git execution by the agent or changes to live host instructions.

## 2. Promised result

Deliver six shared Markdown resources: common commandments and one entry point each for designer, planner, coder, reviewer and compliance auditor. Each role reads the common page and its role page, then follows relevant handbook links as the work requires.

Keep the common page within 350 words and each role page within 200 words, excluding metadata and link addresses. Preserve applicable repository and host instructions; these documents grant no new authority.

## Issue 558

[Role definitions and context contract (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558) owns this first delivery. Its candidate wording in the issue is input to the work, not the deliverable. The deliverable is versioned files and a reviewable PR.

## 3. Current state

The engineering handbook exists. The six role resources do not. The Owner approved the direction of a short common core and role entry points and requested files and PRs instead of issue-only prose.

PR #596 remains a draft for the documentation rewrite. Its no-merge condition is unchanged. The Owner-run preparation requires an explicit scoped exception for this additional PR and its worktree; it records that authorization without closing or merging #596.

## 4. Design impact

These documents define a small reading path into the existing handbook and the five specialists' responsibilities. They do not implement daemons, change host behavior or replace the handbook. Distinguish specialist roles from the process's Owner, Participant, Reviewer and Observer responsibilities.

## 5. Implementation

Create the six files under `docs/engineering/agents/`: `commandments.md`, `designer.md`, `planner.md`, `coder.md`, `reviewer.md` and `auditor.md`. The auditor page is titled Compliance auditor. Add one navigation entry in the handbook index.

The common page explains the shared obligations and links to their authoritative handbook sections. Each role page states its purpose, required inputs, expected output, handoff, authority boundaries and relevant reading. Avoid repeating common policy in every role.

Keep enduring instructions separate from assignment data. The assignment supplies the repository, role, Owner, schedule, current issue and plan, worktree, host and native conversation identity where applicable. Missing assignment information must remain explicit rather than inferred from a branch name.

Use the source map below to preserve requirements. Follow the existing documentation metadata and paragraph-layout rules. Write in plain language using the approved Google guidance. Arc42 guides architecture content; these role entry points are not architecture documents and do not need twelve sections.

| Shared subject | Authoritative source |
| --- | --- |
| Approved scope and departures | Engineering process, sections 4–5 |
| Issue, worktree and committed-plan sequence | Engineering process, section 4 |
| Designs, plans and schedules | Work assets, sections 1 and 3; the Owner's clarified distinction |
| Schedule identity and progress | Work organization; Agent operation, section 8 |
| Git and PR authority | Agent operation, section 7; live-entrypoint overrides; PR procedure |
| Visibility and coordination | Agent operation, sections 5–6 |
| Verification and honest status | Engineering process, section 6 |
| Writing and source layout | Documentation standard; approved Google guidance |
| Audit independence and evidence | Agent operation, section 2.1; five-role exercise (#565) |
| Completion and preservation | Engineering process, sections 8–9 |

Preserve the auditor-versus-builder model-family requirement. Do not bring back breach-cost estimates or mandatory agent-authored breach reports. Do not turn a role assignment into permission to operate another worker's worktree.

## 6. Alternatives and limits

The full handbook is a reference, not a mandatory startup reading set. A duplicated handbook in each role would drift and waste context. One common page and five short entry points provide the first useful resource set.

Shared skill packaging, complete context curation and measured native startup reading sets remain in Skills curation (#560), Common context (#559) and Reading sets (#561). Claude and Codex loading and daemon/session qualification remain in their host tasks (#562 and #563). This delivery supplies inputs to that work without claiming those tasks complete.

## 7. Acceptance and evidence

| Criterion | Evidence |
| --- | --- |
| Six shareable resources exist | Committed paths and PR links; handbook navigation resolves |
| The common core is slender | Common page at most 350 words; each role page at most 200, with counting rules recorded |
| Responsibilities are usable | Every role can identify its remit, input, output, handoff and approval boundaries |
| Requirements are preserved | Review the common page against the source map and each role against its issue and handbook sources |
| References work | Check local targets, anchors and backlinks |
| Documents read clearly | Separate writing review; no unresolved material ambiguity or contradiction |
| Repository gates pass | Actual make check and final-head GitHub CI |
| Status is accurate | Keep native-loading and daemon claims separate from document validation |

Perform a documented read-through against an existing devlore-cli issue to check that the entry points identify a sensible role-specific next action. This is a content review, not proof that five native agents or daemons were started.

## 8. Completion milestones

Implementation, review, merge, source/reference verification and Owner completion approval are required. Live host installation is not a milestone of this first delivery. Keep #558 open when any of its broader agreed criteria remain outstanding; do not automatically close downstream issues.

## 9. Phases

- [ ] Commit and publish this plan; obtain Owner review and direction before implementation.
- [ ] Write the six resources and handbook navigation entry.
- [ ] Record word counts, source coverage, link checks and a role-by-role content read-through.
- [ ] Run make check, publish the resource commit and inspect final-head CI.
- [ ] Obtain review, merge authorization, post-merge verification and completion approval; clean up through the Owner-run process.

## 10. Files and related assets

The seven implementation paths are the six resources in section 5 and `docs/engineering/index.md`. This plan is `docs/plans/doc/558-role-entry-points.md`. Update it in the commit that completes each phase.

## 11. Dependencies and overlaps

Preserve the closed Handbook consolidation (#420) dependency and ownership under Agent roles (#460), Epic #526 and Schedule #551. Advance this first delivery without declaring #559, #560, #561, #562 or #563 complete. Keep PR #596 and its uncommitted rewrite plan intact.

## 12. Approval and departures

The Owner requested this small deliverable and a focused PR on 2026-11-18. Approval of the issue definition does not establish review of a committed implementation plan. The preparation script opens the worktree, commits this plan and opens a draft PR. It stops for Owner review.

Invoking the Owner-run script with `--allow-parallel-pr` explicitly authorizes this one additional worktree/PR and its scoped repository work while #596 remains a draft. That exception does not grant agent execution of Git, PR scripts or merge operations.

## 13. Completion review

Planning proposal only. The six implementation files have not been written. Record actual delivery and verification here as the work proceeds.
