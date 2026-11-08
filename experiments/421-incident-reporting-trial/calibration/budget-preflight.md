---
title: "Calibration spending and launcher preflight"
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Calibration spending and launcher preflight

**Later update:** Four Owner-directed C01/C02 comparison turns completed with the weekly meter at 3% before and after each. See [two-case analysis](two-case-analysis.md). The sections below preserve the earlier preflight state.

## Owner-directed diagnostic, 2026-10-30 UTC

One unscored Codex CLI turn ran with the weekly meter at 3% before and 3% after, in the same window. Its reported usage was 15,078 input tokens, 12,288 cached input tokens, 0 cache-write input tokens, 5 output tokens and 0 reasoning output tokens. The 3% pre-request reading is the starting observation for the one-percentage-point calibration stop condition. The meter is coarse, other usage can affect it, and a request can cross the stop point before a subsequent read. The diagnostic does not prove provider request counts or internal retry accounting. See `diagnostic-output/README.md` and the adjacent raw event and meter files. No scored evaluation ran.

## Follow-up probe, 2026-10-30 UTC

The sandboxed app-server startup again failed with the user-namespace/read-only-filesystem error. With permission to run the read-only meter probe outside the sandbox, `read_usage.py` initialized the app server and called `account/rateLimits/read` without starting a model turn. Around 02:09 UTC it returned 2% used in a 10,080-minute window, reset timestamp 1793805961, `ordinaryUsageAllowed: true`, and credits `hasCredits: false`, `unlimited: false`, `balance: "0"`. The returned plan type was `prolite`; this is the service's field and differs from the Owner's earlier Pro description. Neither field proves how future purchased credits would be consumed. The reading is a preflight snapshot, not the calibration baseline; reread immediately before and after each request and stop on missing, reset, ambiguous or threshold-crossing readings.

Successful account reads do not establish provider-request counts, absence of hidden retries, or token attribution. No model request was made in this probe. Calibration remains blocked on those checks and the frozen reviewed sample; see `review-notes.md`. The separate synthetic `accounting_fixture.py` checks arithmetic and identity examples but is not a parser for actual Codex telemetry.

## Update: subscription usage as the trial budget

The Owner has accepted using a subscription percentage instead of a dollar bound. The earlier dollar-bound gate below is therefore superseded for the subscription-based trial; API-equivalent estimates remain illustrative rather than a spending limit.

The Owner confirmed a Pro plan and directed continuation after a one-percentage-point calibration stop point was proposed. Use that stop point for calibration, measured as a change in percentage used from the pre-calibration reading. The current session's latest observed Codex rate-limit event at 2026-10-30 01:55:34 UTC reported 2% used for a 10,080-minute (seven-day) window. This is a snapshot, not a measurement of trial consumption. Measure the allowance before and after requests, account for other activity and resets, and stop if the threshold is reached. The displayed meter can be coarse and a request may cross the threshold before it is observed, so this is an observational stop condition, not a guaranteed hard cap. Confirm whether purchased credits could be consumed before executing requests.

The reference-review and usage-attribution prerequisites remain open. No model evaluation request has been made.

## Execution environment probe

On 2026-10-30 UTC, a local `codex app-server` probe failed at startup with `Read-only file system (os error 30)` and a message about access to create user namespaces. A separate `codex exec --json --ephemeral --sandbox read-only` probe failed to initialize its in-process app-server client with the same read-only-filesystem error, before producing JSON events or a model response. No model evaluation was run. This session also has `CODEX_SANDBOX_NETWORK_DISABLED=1`. Running the trial requires an environment where the authenticated Codex CLI can start and reach its service; no sandbox bypass was attempted.

The installed app-server schema exposes `account/rateLimits/read`, including a weekly window and a credits snapshot. This establishes an interface to investigate once the server can start, not that live measurements or credit checks have been validated here.

## 1. Result

**Model calibration has not run.** The original dollar-bound gate has been superseded as described above; execution and reference-review prerequisites remain open.

The local Codex CLI is version 0.165.0 and reports ChatGPT login. Its help exposes JSON event output, a read-only sandbox and an output schema, but no documented maximum-output-token option. A strict configuration probe using `model_max_output_tokens=512` returned a JSON error: `unknown configuration field`. That probe made no model request. The preliminary terminal message saying configuration was validated was incorrect; it only established that the error response was JSON.

The Codex configuration reference also did not document an output-token cap under that name: https://learn.chatgpt.com/docs/config-file/config-reference. A schema restricting response shape is not itself a verified cap on output or reasoning tokens.

## 2. Cost boundary

The model used earlier in this session was `gpt-6.1-sol`. The OpenAI API model page lists a maximum output of 128,000 tokens and standard output pricing of USD 10 per million tokens. At that API rate, output alone at the stated API maximum would be USD 1.28 for one request, before input; four such requests would exceed the plan's proposed USD 1 calibration allowance. This is a conservative API-equivalent illustration, not a prediction of the trial's actual output or a statement of this user's ChatGPT charges. Source: https://developers.openai.com/api/docs/models/gpt-6.1-sol.

The local route is ChatGPT subscription login, not an API-key billing route. OpenAI states that API token prices are separate from subscription usage: https://learn.chatgpt.com/docs/pricing. A local token counter cannot establish actual cash charges or, by itself, enforce a dollar limit. Whether the user's account uses included allowance or purchased credits has not been inspected.

The documented API output maximum is not proof of the exact limit enforced by the installed Codex/ChatGPT route. It demonstrates why treating a short requested answer as a hard dollar bound would be unsound. A credible lower bound would require a verified enforced request cap and applicable billing semantics.

## 3. Sample integrity

Two calibration candidates are prepared in this directory with provisional reference labels. C01 and history rows share a date; C02 spans October 6–7, overlapping history dates. Ordering is not independently established. The approved plan permits documented sequence ordering, but the Owner or an independently assigned reviewer must freeze the reference before model evaluation. No model-result accuracy is claimed from candidate retrieval.

## 4. What is needed to resume

Run from an environment where the authenticated CLI and live usage read work, establish attributable accounting, and obtain independent reference review before treating calibration results as scored evidence. An API key or API spending authorization is not implied by the subscription budget.
