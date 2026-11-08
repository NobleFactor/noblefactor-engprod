# Authorized pilot: execution boundary

**Later update, 2026-11-01 UTC:** A second startup attempt reached the live meter but stopped before either evaluator invocation. A follow-up meter read showed 5% in the approved window, above the 4% stop point. See [budget boundary report](budget-boundary-2026-11-01.md). The earlier startup failure below is preserved as historical evidence.

The Owner authorized two independent runs under the existing weekly stop point. The pilot supplements the original investigation; it does not replace or complete it.

The [behavior checklist](behavior-checklist.md) and [input manifest](frozen-inputs.json) were fixed before the attempt. The manifest hashes the task, lesson, starting fixture, checker, runner and dependencies. The runner prepares both byte-identical fixture copies before either evaluator runs; only the supplied lesson differs between prompts. Model and settings are matched.

At 2026-10-30 19:42:33 UTC the authorized runner stopped on its initial live-meter check. The app server exited before responding. The [attempt receipt](execution-attempts/2026-10-30T194233.272655+0000.json) records zero evaluator invocations. No weekly reading, behavioral result, model usage or per-arm comparison was obtained. This is an execution failure, not a scored task failure or evidence that the lesson helped or failed.

A separate read-only daemon-version probe failed to connect to the local control socket with `Operation not permitted`. Direct CLI delivery to the executing session has not been established. No worker message was sent. The existing executing session previously ran the classification comparisons; handing execution back to it is a required human relay in this arrangement, not zero-cost coordination. Active human time remains unmeasured. The approved pilot can proceed there using the frozen runner and the same meter boundary; no new scope or budget approval is required. A failure before any evaluator invocation does not consume either pilot invocation. Do not automatically replay a run that has evaluator output.

The worktree-root `next-trial-step.md` records the authorization and complete execution/report instruction for that session. On completion, review actual validation decisions and final claims, export observations, and report differences or identical behavior. Syntax repair alone does not establish a benefit.

The original investigation remains open: autonomous recurrence detection, useful retrieval, new/ambiguous patterns, effect on ordinary engineering decisions, persistent recording/idempotence, and full recurring usage and intervention cost have not been established by this unexecuted behavioral pair or the earlier two classification cases.
