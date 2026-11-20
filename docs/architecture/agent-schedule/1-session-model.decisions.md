---
title: "Claude session lifecycle decisions"
status: draft
updated: 2026-11-19
---

# Claude session lifecycle decisions

[Design](1-session-model.md) · [Source and delivery references](1-session-model.status.md)

## 1. Native session owns the conversation

**Status:** established launcher contract.

Claude's background service owns the persistent session. A terminal runs a native attachment client. Keeping the conversation in the terminal pane would make its lifetime depend on that terminal and impede independent views.

The launcher stores the background-session short ID rather than a tmux ID or conversation UUID. Native conversation clearing can change the UUID while retaining the background-session identity. Native discovery determines whether an existing conversation is backgrounded, foregrounded or inactive.

**Consequence:** background resumption must use the discovered native state. Passing an already-active conversation through a new background launch can produce another conversation. A foreground session is refused rather than silently transferred.

## 2. Each attached start gets a fresh terminal view

**Status:** established launcher contract.

The launcher creates one tmux view per attached start and destroys it when its last client leaves. A persistent shared tmux session is the alternative. Fresh views give each start its own companion shell while several viewers share one conversation.

**Consequence:** detachment can end the companion shell. The user returns by opening another view; the conversation survives independently. Transport loss may delay destruction until the terminal client actually ends.

## 3. Use native discovery and trust checks

**Status:** established launcher contract.

Use native session listing and attachment rather than parse private trust records or maintain a startup synchronization hook. Native Claude owns its session storage and decides whether the workspace is trusted.

**Consequence:** a native discovery or trust failure remains visible. It cannot be converted into evidence that no session exists or permission to create a replacement.

## 4. Carry assignment context explicitly

**Status:** established launcher contract.

Supply Schedule identity through `NFEP_AGENT_SCHEDULE` and `NFEP_AGENT_SCHEDULE_URL` in native launch settings and in the companion shell. Do not depend on the background service inheriting the launcher's environment.

**Consequence:** assignment lookup uses those values before its name fallback. Display names remain useful to people but are not the primary binding.

## 5. Related proposals

The [assignment proposal](2.1-agent-schedule-commands.decisions.md) has an unresolved terminal-reuse policy. The [sandbox proposal](3-agent-sandbox.decisions.md) has unresolved deployment and storage choices. Neither proposal changes the standalone launcher contract by implication.
