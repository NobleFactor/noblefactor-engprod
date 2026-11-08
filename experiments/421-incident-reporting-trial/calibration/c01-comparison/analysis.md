# C01 comparison analysis

## Observed result

Both fresh evaluator contexts returned `existing`, P003, with P003 as evidence. This matches the Owner's accepted C01 grouping with the unverified-claims pattern. It is one comparison, not an estimate of full-sample accuracy. The Owner accepted the simulated ordering and this grouping; the complete sample, pattern taxonomy and broader reference scoring have not been reviewed or frozen.

The indexed arm ran first and received five candidates from the same nine eligible historical records supplied in full to the baseline. Its deterministic lexical shortlist included P003 at rank 2. Both prompts used the same incident, output contract, model request and configuration. The reference answer was not supplied to either evaluator. The preparer of this retriever had already seen the reference, however, so this is not a blinded index-design process. This simple lexical retriever does not yet implement the planned structured requirement, operation, error-signature and approved-alias index; its result should not be generalized to that proposed design. An earlier preliminary lexical method missed P003; the method used here is different and is recorded in `preparation.json` and `prepare.py`.

## Usage and elapsed time

| Measure | Indexed | Full history |
| --- | ---: | ---: |
| History records presented | 5 | 9 |
| Saved prompt bytes | 2,992 | 5,138 |
| Reported input tokens | 12,825 | 12,486 |
| Reported cached input tokens | 0 | 0 |
| Reported output tokens | 87 | 59 |
| Reported reasoning output tokens | 28 | 0 |
| CLI elapsed seconds | 6.905 | 4.334 |

The indexed prompt file was shorter, but the indexed turn reported 339 more input tokens (about 2.7%) and 28 more output tokens. The captured events do not explain the discrepancy between prompt size and turn input totals. These totals cover the CLI turn, including context beyond the saved prompt; the event stream does not break that context down. Cached input and reasoning output are reported fields and must not be added to input or output again. Both cached-input counts were zero, but this does not establish the state of every cache or explain the input difference.

CLI elapsed time includes startup and other process overhead, not just model inference. The measured lexical ranking calculation took about 0.000234 seconds; it excludes input loading, index preparation, output recording, export and review. Manual review, recording and setup times were not measured. These observations do not establish end-to-end time savings or actual dollar costs. No actual incremental subscription charge or applicable rate for this route was established; the corresponding CSV fields are blank.

## Budget and attribution

The weekly `codex` meter read 3% immediately before and after each arm, with the reset timestamp unchanged at 1793805961. The credit snapshot reported no credits and balance 0 on each read. The 3% baseline and 4% stop point remain in effect for that same window. The meter is coarse and can be affected by other account activity or delayed updates; four unchanged readings do not prove that the turns used no allowance. A request could cross the stop point before the next reading.

The runner requested `gpt-6.1-sol` with low reasoning effort, one CLI invocation per arm, ephemeral sessions, read-only sandboxing and no user config. It used a ChatGPT-authenticated custom provider named OpenAI with HTTP and stream retry settings both set to zero, disabled WebSocket transport and disabled shell and web-search features. The application did not retry. The installed CLI rejected attempts to override retry settings on the built-in `openai` provider, so the explicit custom provider was used consistently for both arms. The [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference) describes these retry settings; the [installed-version provider implementation](https://github.com/openai/codex/blob/rust-v0.165.0/codex-rs/model-provider-info/src/lib.rs) resolves ChatGPT-authenticated providers to the Codex backend when no base URL is configured. This does not independently verify all hidden requests, transport behavior, model actually served, or failed-attempt accounting. The CLI events show one completed turn and no tool items per arm, but do not expose provider request IDs or prove that no other hidden retry occurred.

The output schema and prompt constrain response shape and requested brevity; an enforced output-token ceiling was not established. The full-history prompt did not overflow in this run. These limitations remain relevant to any continuation.

## Evidence

- `preparation.json` records candidate order, scoring method, hashes and the nine eligible IDs. The prompt and schema files contain no hidden reference answer.
- `run-output/` contains raw CLI events, stderr, structured answers, and the before-and-after meter snapshots for each arm. `run.json` records configuration and timing.
- `results.csv` and `usage.csv` are deterministic exports from the saved evidence. Run `python3 experiments/421-incident-reporting-trial/calibration/c01-comparison/export.py` to reproduce them without a model call.
- The 16-case sample manifest describes the earlier preparation snapshot; it is not a live count of runs.
