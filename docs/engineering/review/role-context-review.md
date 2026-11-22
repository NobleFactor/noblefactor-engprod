---
title: "Role context coverage and author walkthrough"
status: draft
created: 2026-11-21
updated: 2026-11-21
owner: "NobleFactor/engprod"
change_process: "../process.md#prepare-and-review"
---

# Role context coverage and author walkthrough

[Up: Engineering handbook](../index.md)

This is the author's coverage record for [Shared context and five roles (#558)](https://github.com/NobleFactor/noblefactor-engprod/issues/558), delivered through [PR #616](https://github.com/NobleFactor/noblefactor-engprod/pull/616). It maps the promised assets and records a document walkthrough on 2026-11-21. It is not an independent review, compliance audit, or native-agent test. External findings and corrective rechecks belong on the PR.

## 1. Fixture and method

The main fixture is the actual Coder assignment: Schedule #551, Task #558, Feature #460, and worktree `/Users/david-noble/Workspace/NobleFactor/noblefactor-engprod.558-role-context`. The [assignment example](../../templates/agent-context.md) uses those identities and explicitly marks unobserved model, session, and loading information. The filled Designer example records the observed Evidence Archive design assignment: Epic #490 → enabler Feature #622 → Tasks #623 and #624 on Schedule #619. The read-only collection and native-parent evidence is preserved outside Git in the audit-2653ee5 receipt directory.

For each role, read the common entry point, role page, assignment example, and relevant linked requirements. Trace the expected output and handoff, then apply the cases below to the documented requirements. The results establish coverage and the author's interpretation. They do not establish how another agent will act or what any host has loaded.

## 2. Requirement coverage

This map traces each promised result to its source and delivered evidence.

| Required result | Authoritative source | Delivered asset or evidence |
| --- | --- | --- |
| Five roles, inputs, outputs, authority, and escalation | [Role deliverables](../work-assets.md#role-deliverables) and [process](../process.md) | [Designer](../agents/designer.md), [Planner](../agents/planner.md), [Coder](../agents/coder.md), [Reviewer](../agents/reviewer.md), [Compliance auditor](../agents/auditor.md), with common obligations and Owner escalation |
| Specialist roles distinct from responsible, accountable, consulted, and informed (RACI) responsibilities and runtime identities | [Responsibilities](../process.md#roles-and-responsibilities) and [workstation design](../../architecture/agentic-developer-workstation.md#41-persistent-specialists) | [Context contract](../agents/context.md), section 2; Owner accountability, role, host service, native conversation, and attachment stay distinct |
| Overview, common context, role material, skills, and assignment | [Context contract](../agents/context.md), sections 1–2 | Linked resource categories, small startup reading set, and structured assignment example |
| Actual authority, source revisions, and reading evidence | [Authority](../agent-operation.md#owner-supervised-agents-authority-and-progression) and [shared obligations](../agent-operation.md#all-agents-shared-obligations) | Context contract, sections 3–4; example fields distinguish actual grants, unknowns, and inapplicable values |
| Design assets lead to planning | [Design schedules](../work-organization.md#design-schedules), [enabler features](../../issue-standards.md#enabler-features) | [Two-Task template](../../templates/design-schedule.md) and [starter skill](../../../skills/start-design-schedule/SKILL.md); Epic → Feature → Task ownership |
| Audit scope, independence, evidence, and accuracy | [Compliance auditing](../agent-operation.md#compliance-auditing) | Auditor entry point and [finding template](../../templates/review-comment.md), referring to the shared policy |
| Context handoff and maintenance | [Lifecycle and freshness](../work-assets.md#lifecycle-and-freshness) | Resource source, revision, and reading state, exact session identity, model changes, actual authority, outputs, and unresolved questions |
| Review, approval, merge, and closure | [Completion](../process.md#completion-and-progression) and [PR procedure](../procedures/pull-request.md) | Plan milestones, PR #616, and Owner-run publication and finish script; pending results remain pending |

The common page remains limited to 350 words and each role page to 200 words, excluding metadata, link addresses, and formatting markers. Host-specific loading and discovery remain with #562/#563; the five-native-agent exercise remains with #565.

## 3. Five-role walkthrough

The walkthrough applies each role to the same scheduled change.

| Role looking at #558 | Input and required deliverable | Handoff and boundary |
| --- | --- | --- |
| Designer | Read the accepted workstation design and requirements; supply a coherent design, architecture decisions, and roadmap if a design assignment is needed | Give the Planner actual assets; do not substitute a plan for writing them or assume implementation authority |
| Planner | Read the design, current handbook, dependencies, and acceptance needs; prepare ordered issues and applicable implementation plans | Give the Coder the approved assignment and remain available for schedule changes; do not treat a proposal as a commitment |
| Coder | Implement the approved context contract, assignment example, role refinements, and affected references; supply revision-specific checks | Give reviewers the candidate and evidence; leave PR execution and merge within their actual grants |
| Reviewer | Examine the plan and delivered assets for correctness, coherence, missing cases, and stale references | Report supported findings and recheck corrections on the final candidate; recommend acceptance to the Owner |
| Compliance auditor | Trace every changed and affected asset to applicable adopted requirements and actual authority | Use an eligible model family, cite evidence, and report limits; do not replace technical review or grant acceptance |

The design-start skill resolves the related Epic and enabler Feature before attaching the design and roadmap Tasks to their Schedule. A real filing run is not part of this author walkthrough. The observed Schedule and native-parent reads fill the example without changing Schedule #619 or its issues.

## 4. Cases and author conclusions

These cases show how the written requirements apply.

| Case | Conclusion from the documented requirements |
| --- | --- |
| A command default changes but an untouched man page still lists its old value | Follow the impact outside the diff and include help, completions, man pages, and other descriptions. Correct the affected assets and recheck the candidate; checking changed files alone is incomplete |
| CI passes but a documented recovery path cannot work | Passing checks establish only their covered facts. The Reviewer still investigates correctness and the auditor still checks applicable requirements |
| An external guide suggests a structure that the repository has not adopted | Do not invent a mandatory rule. Identify the adopted requirement and its scope; distinguish recommendations and missing evidence from proven violations |
| The builder changes models or its actual model family is unknown | Record the change against affected work. A CLI name does not prove independence; report the unresolved evidence before claiming an independent audit |
| Codex and Claude built the candidate while Claude is the bound auditor | Seek Owner approval for one identified audit by an eligible third model family, retaining the existing binding. Without an eligible auditor the request remains unresolved |
| New handbook content is published but a running agent has not read it | Record published but unread or unknown state and its consequence. Do not claim effective loading or select a new automatic refresh mechanism |
| A Designer is asked to design the Evidence Archive | Resolve its design Schedule, related Epic, enabler Feature, and two Tasks; deliver design, architecture decisions, and roadmap directly. Mark the implementation-plan field not applicable for those assets |
| Feature or Task issue creation succeeds but its response is lost | Recover identity through reports and reads before proceeding. Do not repeat `issue open` and risk a duplicate, or move another worker's issue |
| Only the design Task has finished | Retain the roadmap Task and enabler Feature until their own evidence and acceptance are met. Setup, a checked box, or a child closure alone does not establish delivery |

These cases are reasoned document walkthroughs, not reproduced runtime defects, executed audits, or independent agent results. The context contract records the required evidence; host qualification must prove actual discovery and use.

### 4.1. Concrete consistency fixture

The author constructed a command-default change from 10 to 30 seconds. Only the modeled command changed in the candidate; seven related assets retained 10. The fixture has separate before, candidate, and corrected versions. These are controlled inputs, not a claim that the repository contains this command or defect.

This impact map identifies every modeled dependency and the required correction.

| Affected asset | Why it is affected | Candidate observation | Correction and recheck |
| --- | --- | --- | --- |
| Command default | Defines the candidate behavior | 30 seconds | Retained at 30 |
| Help | Describes the default | 10 seconds outside the diff | Corrected to 30 |
| Man page | Documents operational behavior | 10 seconds outside the diff | Corrected to 30 |
| Completion resource | Supplies the option's default description | 10 seconds outside the diff | Corrected to 30 |
| Design | Describes the intended default | 10 seconds outside the diff | Corrected to 30 |
| Plan | Names the acceptance value | 10 seconds outside the diff | Corrected to 30 |
| Roadmap | Names evidence for the increment | 10 seconds outside the diff | Corrected to 30 |
| Example configuration | Demonstrates the default | 10 seconds outside the diff | Corrected to 30 |

A direct read comparison found all seven stale values outside the candidate diff. After correcting the seven files, the author repeated the comparison and confirmed that all eight modeled assets agree on 30. The evidence records method, time, stage identities, and SHA-256 hashes for each file. The [versioned consistency fixture](role-context-fixture.json) supplies all before, candidate, and corrected contents and hashes for independent reproduction. The execution fixture and receipt are at `/Users/david-noble/Workspace/NobleFactor/scratch/noblefactor-engprod.558-role-context/audit-2653ee5/consistency-fixture/receipt.json`.

This supplies the agreed impact, fixture, correction, and recheck evidence. It verifies the modeled consistency facts and the author's use of the documented scope. It does not test an independent auditor's discovery or claim a native-agent pass; that remains part of the later host and five-agent qualification.

## 5. Verification and acceptance

The publication script stages only named assets, runs the repository's actual `make check` gate and the native skill validator, integrates develop without rebasing, pushes, and records CI for the exact published head. The PR verification section and external publication receipt record the results that actually ran. A result from an earlier commit does not cover a later correction.

The filled Designer assignment was checked against read-only Schedule rows and native parent links. These observations are scoped to their recorded time; later tracker changes do not change the fixture's provenance. Unknown model and loading evidence remain explicit.

Independent technical review, compliance assessment, correction and recheck, Owner acceptance, merge, and published-source verification remain required. Their evidence belongs on PR #616 and the issue. The plan remains active until its completion milestones are met; this record does not claim those pending results.
