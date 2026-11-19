---
title: "Pull request procedure"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

# Pull request procedure

[Up: Procedures](index.md)

<a id="dedicated-pr-script-standard"></a>

## 1. Dedicated PR script standard

Generated PR scripts follow the dedicated platform-specific PR template. They are explicitly exempt from sourcing Declare-BashScript. Retain the template-based structure and safeguards; this exemption does not make their form arbitrary or waive error handling, verification or approval requirements. The Bash form uses `set -euo pipefail`; Windows uses its PowerShell form.

<a id="review-boundary"></a>

## 2. Review boundary

The [dedicated script specification](../../guides/pr-script-template.md) provides the Bash and PowerShell forms, including the current native-process and plan-link behavior. The [pre-cutover source](../review/sources/adoption-2026-11-15/pr-script-template.txt) preserves its earlier examples as evidence. Use the current forms when generating a script; historical snapshots are not executable alternatives.

Retain explicit staging; never stage the whole tree indiscriminately. Verify generated path lists, use safe literal multi-line message construction, check native exit results, and run the repository's actual CI-equivalent entry point. Do not bypass hooks. Check actual CI and mergeability rather than inferring them from a local run.

Retain no rebase, squash merge without automatic delete-branch, target integration before push and canonical-clone sync after cleanup. Obtain the separate [canonical-clone maintenance authorization](../agent-operation.md#owner-supervised-agents-authority-and-progression) before executing cleanup or sync operations that update that clone; a worker’s commit/push grant does not cover them. The PR description states that AI assisted and carries `Signed-off-by:` for the accountable human and `Assisted-by: <agent name>` naming the submitting agent, such as Codex or Claude Code. This is permanent policy for all agent hosts. Attribution for every agent consulted during review is not required. Preserve these trailers in the squash commit and verify the landed message. Branch commits carry no trailers. Retain the prohibition on AI co-authorship and promotional footers.

Record PR time-open from GitHub timestamps, not estimated effort. Record scheduled-issue state when the merge lands, with stale-read protection and readback, before removing the worktree/script. Where a record changed since inspection, stop and reconcile rather than overwrite it.

The owner runs the reviewed script unless explicitly authorizing one agent run. Report a failed run and diagnose before a proposed retry. An end-of-PR issue report is printed only when requested, scoped to the work served.

**Cases:** A post-cleanup command ran from a removed directory and exited 128; a later PR merged without recording its scheduled work. Preserve both the working-directory transition and schedule readback in the executable specification ([original template, rules 6 and 13](../review/sources/pr-script-template.txt)).

<a id="merge-authorization-and-gates"></a>

## 3. Merge authorization and gates

PR scripts must refuse to merge while required checks, reviews or review conversations remain unresolved. Administrative bypass is not part of routine execution. Any bypass requires separate, explicit Owner approval identifying the PR and the requirement being bypassed; approval to run the script or perform ordinary integration is not that grant.

Do not treat `UNSTABLE` or `BLOCKED` as sufficient evidence that a merge may proceed. Inspect the actual check conclusions, required reviews and unresolved conversations. An absent check run immediately after a push is not proof that CI is unconfigured. Wait for the required results for the PR’s current revision; if their status cannot be established, stop rather than merge on an assumption.

The current platform examples refuse absent or failing observed checks, non-clean merge state, changed heads and unresolved or incompletely read review threads. They pin the ordinary merge to the qualified head and verify actual merged state before bookkeeping. Their conservative check gate must be reconciled with the repository's verified CI policy when generating the concrete script; an empty check list does not justify an exception. This documentation decision does not change GitHub protection settings or authorize a bypass.

**Case:** The existing PR-tooling issue #145 records a merge before a run existed for the final revision and identifies `UNSTABLE` and undifferentiated `BLOCKED` handling as defects. The dedicated script approach is retained, but the gate must establish readiness rather than infer it from a coarse state label.

<a id="issue-closure"></a>

## 4. Issue closure

Apply [Completion and progression](../process.md#completion-and-progression). The PR body names each issue the PR completes with a closing keyword, `Closes #N`, so GitHub links the PR to the issue and closes it when the Owner merges; the issues the PR only advances are named without one, and stay Open with their Schedule rows In progress and linked to the merged PR. A closed issue whose deployment or verification fails after the merge is reopened with `star github issue reopen`, saying why (ruled 2026-11-19). Every merge is recorded independently of closure.

<a id="documentation-only-completion-follow-up"></a>

## 5. Documentation-only completion follow-up

Use the [post-merge documentation policy](../process.md#completion-and-progression). Until the approved lightweight path is implemented, do not skip existing required checks or claim the exemption is operational. The eventual path must report its required result rather than leave a skipped workflow pending.

