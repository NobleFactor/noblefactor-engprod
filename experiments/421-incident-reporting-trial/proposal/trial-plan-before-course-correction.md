---
title: "Incident recurrence and reporting-cost trial"
status: active
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/421
created: 2026-10-29
updated: 2026-10-29
---

# Incident recurrence and reporting-cost trial

## 1. Problem and deliverable

Agents must recognize recurring errors and record incidents and costs without spending more on administration than the information is worth. Repeatedly rereading a long incident record and reconstructing accounting in conversation is a plausible source of unnecessary overhead, but neither the savings from an index nor reliable recurrence recognition has yet been measured.

Deliver a small, reproducible comparison of full-history lookup versus indexed lookup, with Owner-reviewed scoring, measured usage, explicitly qualified monetary estimates and spreadsheet-ready results. The trial informs the design; it does not certify production reliability or prove that agents will avoid repeating errors while doing engineering work.

This work is Task #421 under Agent conduct Feature #316 and Process Epic #142, separate from documentation Task #420. The Owner approved proceeding and created branch feature/421-incident-reporting-trial targeting develop. The original proposal is preserved under experiments/421-incident-reporting-trial/proposal. No live Project, model result or API credential is created by importing the plan. No schedule membership is assigned by this task.

## 2. Roles and approval

- **Owner:** David Noble; approves the sample/reference classifications, budget, execution phase and interpretation of results.
- **Participant:** Codex preparing this proposal. A trial runner is assigned when execution is approved.
- **Reviewer:** an independently assigned reviewer, or the Owner, checks reference labels, scoring and accounting. Do not assign another session or contact it by implication.
- **Observers:** none separately assigned.

The Owner directed execution of this plan, including its bounded calibration and stop conditions. That direction does not authorize undocumented expenditure or changes to live incidents. All trial mutations remain in its own local output directory. The engprod-team-owned GitHub Project associated with noblefactor-engprod is the approved operational destination, but building or populating that Project is outside this trial.

## 3. Evidence available and prerequisites

### 3.1 Historical source

A read-only snapshot of the body of NobleFactor/noblefactor-engprod#317 is retained in `incident-source.json`, retrieved 2026-10-29. It contains 159 dated rows in the incident-report table. The source was last updated at 2026-10-29T02:23:51Z when retrieved. Its 83 issue comments are not included; the snapshot is a candidate source, not a claim to have captured all incident evidence.

Keep the source revision and snapshot hash fixed in the trial manifest. Inspect linked evidence only for selected cases that need it. Mark unavailable or contradictory evidence; do not fill gaps by inference merely to meet the sample quota.

### 3.2 Usage observability

A metadata-only inspection of the current Codex session log found token-count events with `total_token_usage` and `last_token_usage`. Observed counter names include `input_tokens`, `cached_input_tokens`, `cache_write_input_tokens`, `output_tokens`, `reasoning_output_tokens` and `total_tokens`. This establishes local observability, not billing semantics, request isolation or invoice reconciliation.

Before trials, verify attribution to individual trial requests and the relationships between counters. Determine which counters are subsets of others; never add them blindly. In particular, do not charge reasoning tokens twice if already included in output, or cached tokens twice if included in input. Counter reset, context compaction and repeated usage events must not inflate totals.

Claude Code usage extraction is not yet established. A Claude phase is conditional on its own accounting preflight; do not infer its usage from Codex counters or the historical ledger. Keep provider/model configurations separate in the analysis.

## 4. Experimental design

### 4.1 Sample and reference answer

Propose 20 replay events: 16 distinct incident cases and four deterministic retransmissions of earlier events. Among the 16 distinct cases, target eight true recurrences of known patterns, six cases novel relative to their eligible history, and two ambiguous cases for which escalation is the reference action. These are proposed strata, not labels already established in the source.

Select genuine historical cases with adequate evidence. The four retransmissions deliberately simulate duplicate delivery of the same occurrence; do not present them as historical duplicate reports. Separately test two distinct occurrences sharing one pattern, so the system cannot succeed by suppressing all similar incidents.

The Owner or assigned independent reviewer establishes the reference answer and freezes it before evaluation. Store the reference separately from evaluation inputs. Do not let the trial runner see expected matches, category quotas or later incident outcomes. The current conversation has already discussed parts of the source; it is unsuitable as an unbiased evaluation context.

For each case, define the eligible history strictly before its incident time or a documented sequence position. The full-history arm and indexed arm receive exactly that same eligible history. Remove explicit retrospective matching labels from the incident presented to the evaluator while preserving the evidence needed to judge it. Do not index the evaluation case or future evidence as if known beforehand.

If the corpus cannot support these strata honestly, return the proposed sample adjustment to the Owner before running. This is a small stratified diagnostic sample, not an estimate of the natural production frequency of each category.

### 4.2 Two arms

**Full-history baseline:** provide the incident, a fixed classification/reporting prompt and the complete eligible incident history. Do not repeatedly reread live GitHub or allow additional tool browsing. A full-history input that exceeds the configured context limit makes that comparison infeasible; report it rather than silently truncating.

**Indexed lookup:** use deterministic retrieval over the same history to return at most five candidate pattern records. Match by requirement, operation, error signature and approved aliases. No model-generated embeddings or model-based index-building are included in the first trial. Supply the same incident and output contract, plus the candidate records. A true match absent from the shortlist counts as an end-to-end miss, not an excluded case.

Each arm returns a bounded structured result: existing pattern ID, proposed new pattern, or escalation; evidence references; and a brief reason. A reference identifier is a stable key rather than the model's wording of an error. Neither arm may inspect the scoring file, other arm's output, prior trial outputs or hidden reference labels.

Use fresh isolated evaluation contexts and pin model/configuration and response limits within each agent comparison. Alternate or randomize arm order and record cache state and timing. Do not silently disable caching or assume cached and uncached input have identical costs. This compares workflows on the selected configuration, not which vendor is better.

### 4.3 Occurrence identity and reporting

Use separate identifiers for the event/report delivery, actual occurrence and recurring error pattern. Retried delivery of one occurrence must not create another occurrence, report row or cost charge. A new occurrence of an existing pattern must remain a distinct record linked to that pattern.

Both arms use the same deterministic recording and arithmetic layer. The four retransmissions test that layer without another model call. Test recording retries independently of classification accuracy. Do not manufacture a weak baseline that needlessly invokes a model on transport retries merely to increase apparent savings.

### 4.4 Phases and limits

1. Complete source selection, reference review, telemetry/rate validation and reproducible local accounting fixtures before requesting evaluation approval.
2. Run a Codex calibration slice of two distinct cases in both arms, four model responses total. These cases count toward the final sample rather than becoming unreported extra runs.
3. Review calibration accounting and projected total spend. Continue to the remaining 14 distinct cases only within the approved budget and with reliable attribution. Maximum: 32 model responses for the Codex phase; no automatic retries.
4. A Claude Code phase uses the same frozen cases and arms, with its own telemetry preflight and explicit Owner go-ahead. Maximum: 32 additional responses. Preserve separation of agent results.

Limits apply to actual provider requests as well as expected model responses. Hidden preparatory calls, retries, tool loops and index-building model calls must not escape the accounting. If the proposed launcher cannot expose or bound them, stop and revise the method before evaluation.

## 5. Accounting and spreadsheet pipeline

### 5.1 Deterministic calculation

Retain raw usage events and a request-to-case/arm mapping. Deduplicate events by a reliable source identifier before calculating. Use integer token counts and decimal currency arithmetic. Retain failures and partial responses, including their usage, rather than charging only successful decisions.

Compute dollars only from a versioned rate card appropriate to the actual provider, model, access route and usage semantics. Record effective date, source and currency. Separate actual metered usage, calculated variable/API-equivalent cost, known incremental charges and allocated subscription cost. Do not present API list-price equivalents as the actual cash cost of a subscription session.

If a reliable rate or actual charge cannot be established, leave that monetary field blank with a reason; still report measured usage. No exact invoice claim is inferred from local token counts. Exclude costs of causing and correcting the historical incident from reporting overhead, while tracking any actual trial failures and repair separately.

Include retrieval time, model time, validation, recording/export time and manual review time in separate columns. Record one-time sample/index/setup effort separately from per-incident overhead. This plan's preparation is setup work, not an already-measured trial result. Report lookup-only and end-to-end overhead so inexpensive arithmetic does not conceal expensive agent administration.

### 5.2 Outputs

Produce `cases.csv`, `results.csv`, `usage.csv` and `cost-summary.csv`, with explicit IDs and stable columns. Keep the hidden reference in `reference.csv`, separate during evaluation. The trial manifest records source hash, code/prompt versions, configurations, run order, rate cards and any exclusions. Raw logs are local evidence; exports contain only the fields needed for review, not entire private transcripts or credentials.

Open the CSVs as separate spreadsheet tabs. Optionally package them in a workbook through deterministic code after the tables are verified. No model is required to generate, sum, format or export spreadsheet rows. An empty schema is not evidence of results.

## 6. Proposed acceptance criteria and economics

These thresholds are proposed for Owner review, not previously approved policy:

- Four retransmissions create no extra occurrences, reports, model calls or charges; separate occurrences of one pattern are retained.
- No false existing-pattern assignment on the six novel cases; ambiguous cases are escalated rather than forced into a match.
- Correctly recognize at least seven of the eight true recurrences, and do no worse than the baseline in total classification errors. Publish every mismatch and the retrieval-versus-classification breakdown.
- Every attempted model request has attributable usage or a clearly reported instrumentation failure. Accounting fixtures reconcile exactly; duplicate/reordered usage events do not change totals.
- Target at least 50% lower measured variable reporting cost for indexed lookup without reduced quality on this sample. Report input/cache/output counts, actual cash cost where known, end-to-end time and Owner review burden alongside that ratio. If dollars cannot be measured credibly, qualify the economics result rather than substituting token savings as proof of cash savings.
- The approved Owner-visible output is reproducible from frozen evidence without further model calls.

Report counts and denominators, not just percentages. One recurrence miss in eight is substantial. Passing this sample supports a next experiment, not a production reliability claim. Offline recognition does not demonstrate that an agent will obey the lesson in a live coding task; that needs a later prospective test.

Estimate any break-even volume from measured incremental savings and observed setup cost only after the trial. Do not assume positive savings before measurement or assign an invented dollar value to Owner time. Preserve the comparison even if the indexed method loses.

## 7. Proposed budget, stop conditions and approval gates

**Update, 2026-10-30 UTC:** The Owner accepted subscription percentage in place of a dollar bound and directed continuation after a one-percentage-point weekly calibration stop point was proposed. The dollar ceilings and pre-request dollar-bound gate in the following original proposal are superseded for the subscription-based Codex calibration. Record the weekly allowance immediately before and after each request and stop if its percentage used rises by one point from the pre-calibration reading. This is an observed stop point, not a hard cap: a request can cross it before measurement, and other usage and resets can confound attribution. Validate the meter and credit behavior before running. Further phases still require review of the calibration results and budget. The original proposal remains below for history.

Propose a ceiling of USD 10 in approved incremental metered/API-equivalent evaluation cost across both phases, with at most USD 1 of that reserved for the first calibration slice. These are proposal limits, not spending grants or verified platform-level hard caps. Establish the relevant pricing and worst-case input/output bounds before approval; if they do not fit, revise the sample/configuration with the Owner. Do not use historical model prices or quietly change models to force a result.

A local estimate cannot guarantee an invoice cap. Before each request, require enough remaining approved budget for its bounded worst-case cost. Where the access route does not support a credible bound or reliable usage attribution, pause instead of claiming dollar control. Record subscription consumption separately even where incremental cash charge is zero.

Stop on missing telemetry, unexpected model/configuration change, context overflow, reference leakage, duplicate charges, unbounded retries, a required scope change or a projected limit breach. No autonomous reruns. Report current evidence and the corrective proposal to the Owner.

Before execution, obtain Owner approval of the frozen sample/reference process, model configurations, available cost measures, final thresholds, budget, and first phase. Obtain separate approval before the Claude phase. This proposal authorizes none of those operations on its own.

## 8. Decision package

The resulting review should answer: can indexed lookup reliably identify these recurrences; does the recording layer distinguish recurrence from duplicate delivery; is cost accounting reproducible; what does the workflow actually cost; and what further evidence is needed before production use?

The possible outcome is adopt the approach, revise it, or reject it. Record actual limitations and spending in all cases. Subsequent Project schema, provisioning, live reporting commands, preventive checks and spreadsheet refresh automation require separate design/implementation work.

## Issue 421

Execution is authorized by the Owner’s directions to proceed, run the experiment and continue after worktree creation. The Git worktree has been verified. No commit or push has been authorized or performed by this import. Missing instrumentation or an unenforceable spend bound remains a stop condition, not permission to invent measurements.

## 9. Current execution state

The issue-named worktree and plan import are in place. One Owner-directed unscored diagnostic and four CLI comparison turns for C01 and C02 ran. The [two-case analysis](../../../experiments/421-incident-reporting-trial/calibration/two-case-analysis.md) records answers, usage and limitations. The Owner accepted simulated ordering and the C01 and C02 groupings; whether other C02 patterns apply, the remaining [sample and four retransmissions](../../../experiments/421-incident-reporting-trial/sample-review/review.md), and full scoring remain unreviewed. The lexical retriever is a provisional approximation of the specified index. Provider-request attribution, hidden-call bounds and credit behavior remain unverified. The Owner's subscription percentage stop point supersedes the original dollar-bound gate for Codex calibration. See [calibration preflight](../../../experiments/421-incident-reporting-trial/calibration/README.md) and [budget preflight](../../../experiments/421-incident-reporting-trial/calibration/budget-preflight.md).
