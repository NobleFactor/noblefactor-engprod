---
title: "Incident trial calibration preflight"
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Incident trial calibration preflight

**Later update:** The Owner directed C01 and C02 comparisons; four CLI turns completed. See [two-case analysis](two-case-analysis.md). The following preflight sections describe the earlier state.

## 1. What ran

A deterministic candidate-retrieval check and an in-memory duplicate-delivery fixture ran on two selected incident rows from the saved issue #317 body. No model evaluation request ran. The full proposal and frozen source copy remain in `../proposal/`.

## 2. Preliminary retrieval

| Case | Historical rows supplied | Baseline JSON bytes | Five-candidate JSON bytes | Provisional relevant pattern in shortlist |
| --- | --- | --- | --- | --- |
| C01 | 9 | 3,837 | 2,175 | No |
| C02 | 10 | 4,403 | 2,168 | Yes, rank 1 |

The simple lexical retriever missed the provisional known pattern on C01. The labels are not independently reviewed, and source order within the same day is not independently verified. These are calibration findings, not measures of model accuracy. Byte counts are neither tokens nor dollar costs. Candidate records, provisional labels and the result data are in the adjacent JSON files.

## 3. Duplicate fixture

Three in-memory deliveries representing two occurrences of the same pattern produced two distinct occurrences and one pattern. This tests a small identity example only; it is not evidence that a persistent ledger handles concurrency or conflicting writes.

## 4. Model and budget preflight

The Owner accepted subscription usage in place of a dollar bound and directed continuation after a one-percentage-point weekly stop point was proposed. Session token counters exist, but request attribution and a live weekly-meter read remain unvalidated. Attempts to start the local Codex app server and an ephemeral CLI runner failed with a read-only-filesystem error; this session also disables sandbox network access. No model evaluation calls ran. See `budget-preflight.md` for the probe details.

OpenAI publishes separate API rates and states that API token prices do not represent included subscription usage. Use any API-rate calculation only as an explicitly labeled comparison, not as the user's actual charge. References: https://developers.openai.com/api/docs/models/gpt-6.1-sol and https://learn.chatgpt.com/docs/pricing.

## 5. Remaining work

An Owner-directed unscored diagnostic subsequently ran one CLI turn. Its meter snapshots and raw usage events are in `diagnostic-output/`; request and retry attribution remain limited as described there. The synthetic accounting fixture can be run with `python3 experiments/421-incident-reporting-trial/calibration/accounting_fixture.py`; it does not establish real telemetry semantics, request bounds, persistent storage or concurrency safety. A [16-case sample and reference packet](../sample-review/review.md) is now proposed for Owner review. The specified retriever, reference review and freeze, request usage attribution and hidden-call bounds remain prerequisites for scored calibration. The record of all source rows and the original proposal remain unchanged.
