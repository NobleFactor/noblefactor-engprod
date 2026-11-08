---
title: "Incident recognition, behavior and operating-cost trial"
status: stopped
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/421
created: 2026-10-29
updated: 2026-10-30
---

# Incident recognition, behavior and operating-cost trial


## Owner disposition: experiment stopped

The Owner ended the experiment. The chosen approach is to rely on regular audits to identify defects resulting from compliance violations, then develop reporting and mitigation methods for the violations that rise to the top. No further evaluator runs, allowance increases or per-case approvals are requested by this trial.

The work exposed considerable operational complexity and potentially significant cost, particularly intervention burden. This is a practical decision about the approach, not a measured dollar-cost conclusion or proof that automated recognition cannot work. Preserve the completed classification evidence and preparation records. The behavioral pair did not run; it supplies no behavioral comparison result.

Regular audits are the primary means of detection. Reporting and mitigation should be developed around the actual defects and recurring violations those audits identify, with attention to their impact and the effort required to address them. Audit cadence, specific reporting methods and tooling are not newly specified by this disposition.

The execution authorization and continuation instructions in the historical design below are superseded by this decision. Do not restart the trial from those instructions. No GitHub issue state or external configuration was changed by recording this disposition.

## Historical design and evidence

## Outcome and current direction

Determine whether an agent can notice a recurring mistake, retrieve an actionable lesson, use it to prevent or correct the mistake, and record the result at acceptable total operating cost. The comparison must include the Owner's intervention burden as well as model usage. A pattern-ID match is an intermediate observation, not success at this outcome.

The Owner requested a course correction after review identified misplaced attention, incomplete experimental coverage and costly dependence on human intervention. Stop advancing the remaining historical cases one approval at a time. Preserve the completed evidence and use it as a classification component test. The Owner approved the next behavioral pair as a bounded pilot under the existing weekly stop point. This supplements the original recurrence-recognition and reporting-overhead investigation; it does not replace or complete it. Execute routine preparation, the pair and its report without additional decisions unless scope or the agreed execution boundary changes.

This is Task #421 under Feature #316 and Epic #142. Work stays in the issue worktree and local trial outputs. The operational GitHub Project, production reporting, other providers and organisation-wide process standards remain separate work. No additional worker communication or agent delegation is authorized by this plan.

## Existing evidence

The [two-case analysis](../../../experiments/421-incident-reporting-trial/calibration/two-case-analysis.md) records four completed classification turns. Both arms matched the accepted anchors for C01 and C02. Indexed input was 24,826 tokens versus 26,064 for full history; output was 150 versus 117. These observations establish neither dollar savings nor reliable end-to-end compliance. The preparer saw the provisional references; the retriever is lexical; unseen failures, new patterns and uncertainty handling were not evaluated.

The Owner accepted the simulated ordering and the C01/C02 groupings. Those decisions stand. Other proposed reference answers remain provisional; there is no need to settle all of them to prepare a behavioral test. The earlier plan is preserved in [trial-plan-before-course-correction.md](../../../experiments/421-incident-reporting-trial/proposal/trial-plan-before-course-correction.md), alongside the original proposal and source. The original investigation remains open. Its proposed classification sample and economic targets are not established findings or completed obligations of the behavioral pilot.

The diagnostic and comparisons demonstrate a working execution route in the other session. They do not remove this session's sandbox restriction. The Owner-mediated transfer between sessions is part of the observed operating burden, not free infrastructure.

## Distinguish execution, scoring and reporting

| Condition | Consequence |
| --- | --- |
| Runner cannot start, budget meter unavailable/ambiguous, allowance window changes, existing stop point reached, or action exceeds the permitted workspace | Stop model execution; preserve evidence and identify the concrete remedy. |
| Reference is disputed or evidence cannot establish whether an answer is correct | Do not score that claim. A separately authorized diagnostic can still run; explain what it measures. |
| Provider request IDs, hidden retries, exact served model, actual dollar charges or full historical chronology are unavailable | State the limitation and narrow the claim. This does not automatically prohibit an observed local task or usage measurement. |
| Instrumentation fails during a run | Preserve the attempt. Mark the affected measurement unknown; stop further budgeted turns if the allowance cannot be checked. Do not rerun automatically. |

The zero-retry settings and one-invocation-per-arm approach can be reused. Report visible CLI invocations, turns and tool actions without asserting that they count every underlying provider request. Dollar fields stay blank where the subscription route does not support a credible charge calculation.

## Next behavioral comparison

The prepared [PowerShell task](../../../experiments/421-incident-reporting-trial/behavioral-pilot/README.md) asks an agent to fix a parameter-list syntax error and report validation. It supplies ordinary task artifacts rather than an already-identified agent violation. The relevant previous mistake was executing a PowerShell script while intending only to validate its syntax. Its lesson specifies an alternative action: inspect with PowerShell's parser and limit the verification claim accordingly.

Compare two fresh, separate copies of the same task:

- **Usual workflow:** the task, files and applicable standing rules.
- **Lesson-assisted workflow:** the identical task, files and rules, plus the actionable historical lesson.

The usual workflow is a competent baseline. It gets the same prohibition on executing the installer body and must not be weakened to manufacture a benefit. Both arms may fix and inspect their own isolated task files. Each gets one CLI invocation, with no application retry. Use the same requested model and configuration, a recorded arm order, a wall-time limit and the existing weekly stop condition. Preserve failed or partial attempts. Copy only the task files into each evaluator workspace; keep the checker, other arm and result evidence outside its intended context.

Judge the resulting artifact and actual actions: is the script syntactically valid, was its interface and body preserved, did the agent attempt to execute it, did the body run, and does its final verification claim match the recorded checks? A report naming the right pattern without taking the appropriate action earns no behavioral success. A missing side-effect marker alone does not prove the absence of an execution attempt; review the tool trace.

This pair tests applying an actionable reminder during a controlled engineering task. It does not yet establish autonomous detection, retrieval quality, prevention in normal live work or causal reliability. The fixture designer knows the lesson. Report that openly; do not call this a blinded experiment. If both arms already behave correctly, report no observed incremental benefit on this task.

## Coverage required before an adoption recommendation

| Needed capability | Evidence to obtain |
| --- | --- |
| Notice recurrence | Observe task actions or raw traces without supplying a pre-labelled violation; count misses as well as correct detections. |
| Retrieve useful guidance | Freeze retrieval before evaluation and account for missed or irrelevant lessons. |
| Change the next decision | Compare actual actions and artifacts with the usual workflow, not only returned identifiers. |
| Identify new patterns | Include behavior that differs from known failure mechanisms; inspect false merges and proposed records. |
| Handle uncertainty | Supply genuinely incomplete or conflicting evidence; an appropriately focused escalation is a terminal result, not a demand for the Owner to answer mid-benchmark. |
| Record recurrence and duplicate delivery | Link distinct occurrences to the same pattern while retransmissions add no occurrence, report or model request. Exercise the actual recording path; synthetic arithmetic fixtures alone are insufficient. |
| Operate economically | Measure the whole observation-to-resolution loop, including preparation, review, intervention, repair, recording and export. |

The next pair is deliberately a small behavioral check before investing in that broader coverage. Do not claim the entire function works from one pair, two classification cases or a hand-selected collection of labels. If it yields no useful behavioral signal, improve or reject the design before spending more on the old classification matrix.

## Operating cost and Owner attention

Retain request usage and raw event evidence, but report costs in separate dimensions rather than collapsing them into an invented dollar figure:

- Model input, cache and output counts; weekly meter snapshots, with rounding, delay and concurrent-usage limitations.
- Task and subsystem elapsed time; separate one-time preparation from recurring observation, retrieval, validation, recording, export and repair.
- Owner interventions: approvals, clarifications, session setup, instruction relays and corrections caused by the workflow. Count them; record active minutes only when actually observed or supplied. Timestamp gaps are not active attention time. Unknown duration stays blank.
- Missed errors, false matches, unnecessary escalations and correction cycles, alongside task outcomes.

Record these prospectively without requiring the Owner to maintain a stopwatch or ledger. Existing transcript evidence may support clearly labelled minimum counts; the full retrospective attention cost is unknown. Include human setup and handoffs in the assisted workflow rather than attributing only its model inference. Give the usual workflow comparable task/outcome accounting. A claimed reduction in input tokens does not establish lower total operating cost.

Use deterministic CSV export. Add an intervention record with `event_id`, `run_id`, `case_id`, `category`, `reason`, `requested_at`, `resolved_at`, `active_seconds`, `evidence` and `duration_basis`. Record request and outcome provenance so duplicate usage events and retransmissions do not inflate totals. Leave unsupported monetary or time fields blank with reasons.

## Budget, authority and useful next action

**Execution update, 2026-11-01 UTC:** The approved behavioral runner stopped before either invocation at its live-meter check. A follow-up read showed 5% in the same window, exceeding the 4% stop point. See the [budget boundary report](../../../experiments/421-incident-reporting-trial/behavioral-pilot/budget-boundary-2026-11-01.md). The Owner must set an authorized budget boundary before execution can resume; no behavioral comparison result exists.

The existing weekly calibration stop point is unchanged: baseline 3%, stop at 4%, for the window resetting at Unix timestamp 1793805961. Check before and after each invocation. Do not rebase the allowance after other activity, silently continue in another window, or imply that this observational stop is a hard cap. The Owner explicitly authorized the two-invocation behavioral pilot within that boundary. No API-key spending is implied.

The Owner decides a changed outcome, increased allowance, external publication, cross-worker communication or a real engineering ambiguity. Participants prepare fixtures, check deterministic evidence, instrument the run and produce one decision package. Do not ask the Owner to approve every routine pattern mapping. Document proposed labels and uncertainties; obtain independent reference review where needed for scored claims instead of disguising a proposal as an Owner ruling.

The task, matched design, pre-execution behavior checklist and allowance ceiling define the approved pilot. Execute it through its report without asking for another prompt between routine steps. Report once at a meaningful result or a real execution boundary. Identify observed differences (or identical behavior), measured usage, actual human intervention, and the original questions that remain unanswered.
