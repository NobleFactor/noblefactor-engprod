# C01 and C02 comparison analysis

Both arms selected the Owner-accepted anchor for each case: P003 for C01 and P006 for C02. That is **2 of 2 proposed recurrences per arm**, not a full-sample accuracy measure. The Owner has not resolved whether other patterns apply to C02, nor approved the full sample or reference taxonomy. Both cases used Owner-accepted simulated ordering; it does not establish what was historically known at the time of either incident.

| Measure across two cases | Indexed | Full history |
| --- | ---: | ---: |
| Visible completed CLI turns | 2 | 2 |
| Anchor matches | 2 of 2 | 2 of 2 |
| Reported input tokens | 24,826 | 26,064 |
| Reported cached input tokens | 0 | 0 |
| Reported output tokens | 150 | 117 |
| Reported reasoning output tokens | 28 | 0 |
| CLI elapsed seconds | 11.216 | 8.876 |

Across these two turns the indexed arm reported 1,238 fewer input tokens, about 4.7% of full-history input, and 33 more output tokens. It had more input tokens on C01 and fewer on C02. CLI elapsed time includes startup and other overhead; retrieval, recording, export and review are not comprehensively measured. These counts and timings cannot establish actual cash savings or an end-to-end cost comparison. The subscription meter showed 3% before and after each turn in the same window, but its rounding, delays and other account activity limit attribution.

The C01 index preparer had seen the proposed reference; C02 reused that same retriever unchanged but the preparer had also seen the provisional sample and references. C01's indexed arm ran first and C02's full-history arm ran first. A simple lexical index returned the accepted anchors in both cases, but it is not the planned structured index. The hidden reference file was not supplied to either evaluator; no tool calls appeared in the captured event streams.

The application invoked the CLI once per arm with HTTP and streaming retry settings at zero. Each event stream shows one completed turn and no tool items, but provider request IDs, hidden retry behavior, the model actually served and failed-attempt usage remain unverified. The requested model and configuration were the same in all four turns. No hard output-token cap or per-turn dollar charge was established. The remaining cases, full scoring, broader telemetry and trial acceptance criteria require further work and review.

Individual evidence and limitations: [C01](c01-comparison/analysis.md) and [C02](c02-comparison/analysis.md). The combined CSVs in `combined/` can be regenerated from the individual exports with `python3 experiments/421-incident-reporting-trial/calibration/combine.py`; no model call is needed.
