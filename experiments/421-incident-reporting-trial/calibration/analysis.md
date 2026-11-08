---
title: "Incident trial diagnostic analysis"
status: diagnostic
date: 2026-10-30
---

# Incident trial diagnostic analysis

## Result

The Owner-directed, unscored diagnostic completed one Codex CLI turn. The weekly usage meter showed **3% used before and 3% after**. The request produced a usage event, but the available evidence does not establish how many provider requests the CLI made or whether internal retries occurred. The diagnostic is not a scored calibration case and does not establish classification accuracy or cost savings.

## Meter and budget

| Measurement | Before | After |
| --- | --- | --- |
| Captured at (UTC) | 2026-10-30 02:58:42.972855 | 2026-10-30 02:58:47.817880 |
| Seven-day window used | 3% | 3% |
| Window reset, Unix seconds | 1793805961 | 1793805961 |
| Purchased credits present | No | No |
| Credit balance | 0 | 0 |

The displayed increase was **0 percentage points**. The before reading is the starting observation for the one-percentage-point calibration stop condition: stop if this same window reaches 4%, or if the meter is unavailable, resets, or becomes ambiguous. The meter is rounded and can reflect other activity or delayed updates, so an unchanged reading does not establish zero consumption. The earlier 2% preflight reading was not the calibration baseline.

## Reported token usage

The raw `turn.completed` event reported the following fields for the CLI turn:

| Field | Tokens |
| --- | ---: |
| Input | 15,078 |
| Cached input | 12,288 |
| Cache-write input | 0 |
| Output | 5 |
| Reasoning output | 0 |

These are the fields as reported, not separate quantities to add together. The event does not establish their full billing semantics. It provides no actual incremental dollar charge or invoice amount for the subscription route.

## Execution and limits

The runner requested `gpt-6.1-sol`, used an ephemeral Codex CLI session with a read-only sandbox and a fresh empty working directory, and asked for the single response `OK` without tools. The process exited successfully. The event stream contains one started thread, one started turn, one assistant message and one completed turn; it shows no tool calls. The stream does not independently confirm the model served, expose a provider request identifier, or prove that no internal retry or unreported failed attempt occurred. The raw usage is therefore attributable to the observed CLI turn, while provider-request-level attribution remains unresolved.

The evidence is in [diagnostic-output](diagnostic-output/README.md), including the raw JSONL event stream and before-and-after meter snapshots. The deterministic runner is [run_diagnostic.py](run_diagnostic.py). Scored calibration still requires the frozen and reviewed sample, a consistent pattern-ID representation, and a way to account for provider requests and retries under the trial's stop conditions.
