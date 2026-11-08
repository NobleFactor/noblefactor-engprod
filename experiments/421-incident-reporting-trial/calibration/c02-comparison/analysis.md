# C02 comparison analysis

Both arms returned `existing`, P006, citing P006. This matches the Owner's accepted short-options grouping. The Owner has not determined whether other patterns also apply, so this match is not a complete independent review of all acceptable answers.

The full-history arm ran first with ten eligible records; the indexed arm ran second with five candidates drawn from those same records. The unchanged C01 lexical retriever ranked P006 first. Its author had seen the provisional sample and references, so index preparation was not blinded. The lexical approach is a provisional approximation, not the planned structured requirement, operation, error-signature and approved-alias index. The same-day ordering is an Owner-accepted simulated replay, not established incident chronology.

| Measure | Indexed | Full history |
| --- | ---: | ---: |
| History records supplied | 5 | 10 |
| Saved prompt bytes | 3,484 | 5,702 |
| Reported input tokens | 12,001 | 13,578 |
| Reported cached input tokens | 0 | 0 |
| Reported output tokens | 63 | 58 |
| Reported reasoning output tokens | 0 | 0 |
| CLI elapsed seconds | 4.311 | 4.542 |

The indexed turn reported 1,577 fewer input tokens, about 11.6% of the full-history count, and five more output tokens. Input and output are different usage categories; the event does not establish the cash value of either. Treat cached and reasoning fields as subsets rather than adding them again; the event alone does not establish full billing semantics. CLI time includes startup and other process overhead. Retrieval calculation took approximately 0.000550 seconds; loading, setup, recording, export and manual review time were not measured.

The weekly meter read 3% before and after both turns, with the same reset timestamp, 1793805961. All four snapshots reported `hasCredits: false` and a zero balance. The 3% baseline and 4% stop point remain applicable to that window. The meter is coarse and can reflect other usage or delayed updates, so an unchanged reading does not prove zero consumption.

Both turns requested `gpt-6.1-sol`, low reasoning effort, the same ChatGPT-authenticated custom provider as C01, ephemeral sessions and a read-only sandbox. HTTP and stream retry settings were zero and the application did not retry. Each raw event stream shows one completed turn and no tool items; it does not expose a provider request ID, independently verify the served model, or prove there were no hidden requests or retries. The schema constrains response shape but no hard output-token cap was established. No per-turn actual cash charge is known.

The saved prompts, `preparation.json`, `run-output/`, and deterministic `results.csv` and `usage.csv` provide the evidence. `prepare.py` imports the C01 preparation code without changing its retriever; `run.py` differs from the C01 runner only in the case identifier. The Owner-directed combined assessment is in `../two-case-analysis.md`.
