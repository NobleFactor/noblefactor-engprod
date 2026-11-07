---
title: "Pull request procedure — retained specification"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Pull request procedure — retained specification

[Up: Procedures](index.md)

<a id="dedicated-pr-script-standard"></a>

## 1. Dedicated PR script standard

Generated PR scripts follow the dedicated platform-specific PR template. They are explicitly exempt from sourcing Declare-BashScript. Retain the template-based structure and safeguards; this exemption does not make their form arbitrary or waive error handling, verification or approval requirements. The Bash form uses `set -euo pipefail`; Windows uses its PowerShell form.

<a id="review-boundary"></a>

## 2. Review boundary

The [existing PR script specification](../review/sources/pr-script-template.txt) is preserved verbatim for detailed review: Unix and Windows forms, staging/preflight, CI and merge gates, message/trailer composition, time-open calculation, guarded schedule writes, readback, cleanup and final verification.

Its historical terminology and paths are not new approved definitions. Apply the draft process's issue terminology and approval boundaries. A new executable template is deferred until unresolved questions are answered; this source is not a ready-to-run script.

Retain explicit staging; never stage the whole tree indiscriminately. Verify generated path lists, use safe literal multi-line message construction, check native exit results, and run the repository's actual CI-equivalent entry point. Do not bypass hooks. Check actual CI and mergeability rather than inferring them from a local run.

Retain no rebase, squash merge without automatic delete-branch, target integration before push and canonical-clone sync after cleanup. Obtain the separate [canonical-clone maintenance authorization](../agent-operation.md#owner-supervised-agents-authority-and-progression) before executing cleanup or sync operations that update that clone; a worker’s commit/push grant does not cover them. The PR carries `Signed-off-by:` for the accountable human and `Assisted-by: <agent name>` naming the submitting agent. Attribution for every agent consulted during review is not required. Preserve the disclosure in the squash commit and verify the landed message. Branch commits need not repeat these trailers; retain the prohibition on AI co-authorship and promotional footers.

Record PR time-open from GitHub timestamps, not estimated effort. Record scheduled-issue state when the merge lands, with stale-read protection and readback, before removing the worktree/script. Where a record changed since inspection, stop and reconcile rather than overwrite it.

The owner runs the reviewed script unless explicitly authorizing one agent run. Report a failed run and diagnose before a proposed retry. An end-of-PR issue report is printed only when requested, scoped to the work served.

**Cases:** A post-cleanup command ran from a removed directory and exited 128; a later PR merged without recording its scheduled work. Preserve both the working-directory transition and schedule readback in the executable specification ([original template, rules 6 and 13](../review/sources/pr-script-template.txt)).

<a id="merge-authorization-and-gates"></a>

## 3. Merge authorization and gates

PR scripts must refuse to merge while required checks, reviews or review conversations remain unresolved. Administrative bypass is not part of routine execution. Any bypass requires separate, explicit Owner approval identifying the PR and the requirement being bypassed; approval to run the script or perform ordinary integration is not that grant.

Do not treat `UNSTABLE` or `BLOCKED` as sufficient evidence that a merge may proceed. Inspect the actual check conclusions, required reviews and unresolved conversations. An absent check run immediately after a push is not proof that CI is unconfigured. Wait for the required results for the PR’s current revision; if their status cannot be established, stop rather than merge on an assumption.

The retained source template’s unconditional `--admin` and permissive merge-state cases conflict with this rule. Reconcile both platform templates before generating an executable script; do not copy those cases forward. This documentation decision does not change GitHub protection settings or authorize a bypass.

**Case:** The existing PR-tooling issue #145 records a merge before a run existed for the final revision and identifies `UNSTABLE` and undifferentiated `BLOCKED` handling as defects. The dedicated script approach is retained, but the gate must establish readiness rather than infer it from a coarse state label.

<a id="issue-closure"></a>

## 4. Issue closure

Apply [Completion and progression](../process.md#completion-and-progression). Before creating the PR body, check whether any required milestone remains after merge; if so, use an issue reference rather than an automatic closing keyword. Historical examples containing unconditional closing lines must be reconciled before use.

<a id="documentation-only-completion-follow-up"></a>

## 5. Documentation-only completion follow-up

Use the [post-merge documentation policy](../process.md#completion-and-progression). Until the approved lightweight path is implemented, do not skip existing required checks or claim the exemption is operational. The eventual path must report its required result rather than leave a skipped workflow pending.

