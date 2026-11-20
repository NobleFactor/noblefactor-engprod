---
title: "Pull request procedure"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

# Pull request procedure

[Up: Procedures](index.md)

<a id="1-dedicated-pr-script-standard"></a>

<a id="dedicated-pr-script-standard"></a>

## 1. Dedicated PR scripts

Use the [platform-specific script specification](../../guides/pr-script-template.md). Generated PR scripts are exempt from sourcing Declare-BashScript but retain its required error handling, verification and approval safeguards. Bash uses `set -euo pipefail`; Windows uses the PowerShell form.

Prepare the script for its own worktree, read any existing script before replacement, and hand the reviewed command to the Owner. The Owner runs it unless explicitly granting one agent run. A failed run needs diagnosis and a fresh authority decision before retry.

<a id="review-boundary"></a>

## 2. Review boundary

Review all changes and stage an explicit verified path list. Use safe literal multiline messages, check native exit results, run the actual repository gate and preserve hooks. Local success does not establish CI or readiness for the published revision.

Never rebase. Integrate the target before push. The Owner squash-merges in GitHub; scripts do not automatically delete the branch. Obtain separate [canonical-clone maintenance authority](../agent-operation.md#owner-supervised-agents-authority-and-progression) for cleanup/synchronization that updates it.

Before merge, the PR description states that AI assisted and ends with the accountable human's `Signed-off-by:` and `Assisted-by: <submitting agent>`. Name the actual agent, such as Codex or Claude Code. Preserve these trailers in the landed squash commit and verify its message. Branch commits carry no trailers. Do not add AI co-authorship or promotional footers, or credit every agent consulted in review.

Use current specification examples; preserved source snapshots document earlier behavior and are not alternate scripts.

<a id="3-merge-authorization-and-gates"></a>

<a id="merge-authorization-and-gates"></a>

## 3. Owner review and merge

The script's first part prepares and publishes the candidate, verifies its exact head and waits for required CI. It stops for Owner review and merge in GitHub. It prints no merge command.

An absent check immediately after push does not prove CI is unconfigured. Wait for results on the current head and stop when status cannot be established. Inspect actual check conclusions, required reviews and unresolved conversations rather than infer readiness from `UNSTABLE` or `BLOCKED` alone.

A candidate blocked solely on the Owner's review can be reported ready for that review. Other unmet requirements must remain visible. Do not claim that ready for review means every merge requirement has been satisfied.

The Owner merges after the required reviews, checks and conversations are resolved. Administrative bypass requires separate explicit approval naming the PR and bypassed requirement. Script/integration authority does not include that approval, and this procedure changes no protection setting.

Model-command PRs use this same boundary. Backup, apply and restore may prepare or reuse publication PRs and report their head/check state, then stop for the Owner's review and merge in GitHub. Invoking a command, using --unattended or satisfying CI does not authorize an automatic merge. Observe the Owner's actual merge before reporting a checkpoint as delivered or performing authorized post-merge cleanup.

<a id="4-issue-closure"></a>

<a id="issue-closure"></a>

## 4. Closure and delivery records

Follow [completion and progression](../process.md#completion-and-progression): use closing keywords for issues completed by the PR, ordinary references for partial delivery, and reopen an issue with its reason if deployment or verification fails.

When the Owner requests the script's second part, read actual merged state before bookkeeping. Verify the landed head/message, derive time-open from GitHub timestamps and record each scheduled issue's merge independently of closure. Partial issues remain Open/In progress with the PR linked.

Guard writes against changed records and read them back. Stop and reconcile stale state rather than overwrite it. Record delivery before removing the worktree/script, and move to an existing directory before cleanup. An end-of-PR issue report is printed only when requested and scoped to the served work.

<a id="5-documentation-only-completion-follow-up"></a>

<a id="documentation-only-completion-follow-up"></a>

## 5. Completion-only documentation

Follow the [post-merge documentation policy](../process.md#completion-and-progression). Completion-only records need documentation validation, review and merge authority without creating another delivery milestone. Until the lightweight CI path is implemented, retain existing required checks; a skipped workflow cannot stand in for a required result.
