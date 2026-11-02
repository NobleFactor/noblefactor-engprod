---
title: "agent-rules rule 18: an order to message a session is not the yes; the message is proposed and the owner approves it or not"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/404
status: complete
created: 2026-10-25
updated: 2026-10-25
---

# Plan: rule 18 says an order to message a session is not the owner's yes

## Summary

Rule 18 (#400, merged as #402) says no message goes to another agent session without the owner's yes, on the
recipient named and the message quoted. It does not say that an order to message a session is not that yes; rule 17
closes the same gap for git commands. Ruled 2026-10-25, while ordering a message to the writ lifecycle session: the
agent identifies the need and proposes the message, and the owner approves it or not. One issue, one pull request, one
document.

## Issue 404

[agent-rules rule 18: an order to message a session is not the yes; the message is proposed and the owner approves it
or not](https://github.com/NobleFactor/noblefactor-engprod/issues/404). A chore under Epic
[#142](https://github.com/NobleFactor/noblefactor-engprod/issues/142), Process.

## Rulings

- 2026-10-25: "Inform that session with your findings. echo that message here before you send it."
- 2026-10-25: "is it clear from our agent-rules that you NEVER send a message to another session without running it by
  me first. you should identify the need and propose a message as you've done here. I will approve or not."
- 2026-10-25: "first: send the message. then: clarify the agent-rules."

## Current State

At `e4b81e83`, rule 18's **The rule.** begins: "No message goes to another agent session, a Claude session on this
machine, on another machine or in the cloud, without the owner's yes: the agent names the recipient and quotes the
message, and a yes covers that one message." Its **Compliance.** begins: "A message to another session is sent only
after the owner's yes in the turn before." Neither says what an order to send one is.

## Requirements

### Requirement 1: Rule 18 clarified

- **The rule.** gains, after its first sentence: "An order to message a session is not the yes: the agent names the
  need and proposes the message, its recipient named and its text quoted, and sends it only when the owner approves
  that exact text. The owner approves or not."
- **The breakage.** gains the day it was clarified: 2026-10-25, the owner ordered a message to the writ lifecycle
  session and asked to see it before it went; the rulings above, quoted.
- **Compliance.** gains: "An order to send one is answered with the proposal, not the message."
- The frontmatter's `updated` stays 2026-10-25, the day rule 18 was made.

### Requirement 2: The gate

- `make check`, the gate `ci.yaml` runs, passes.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed on `chore/404-agent-rules-rule-18-an-order-to` and reviewed with the owner

### Phase 2: The rule (Requirements 1 and 2)

- [x] Rule 18 clarified; `make check` finished green, read before this box is ticked: exit 0, frontmatter 104 with 0 errors

### Phase 3: Merge

- [x] PR script `~/Workspace/NobleFactor/noblefactor-engprod.404-agent-rules-rule-18-an-order-to.bash` written, shown,
      and handed over; the PR resolves #404. This box's commit, the pull request's last, sets this plan `complete`

CI on the pull request is the script's gate, not a box here: the script merges only when every check has passed, and
no commit could record it (#199).

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/guides/agent-rules.md` | Modify | Requirement 1 |
| `docs/plans/chore/404-agent-rules-rule-18-an-order-to.md` | Create | This plan |

## Open Questions

None.
