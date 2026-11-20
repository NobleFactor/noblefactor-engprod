---
title: "Start-Claude interface decisions"
status: draft
updated: 2026-11-20
---

# Start-Claude interface decisions

[Design](2-command-line.md) · [Source and delivery references](2-command-line.status.md)

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Separate Schedule creation from session launch

Create a Schedule with `star github schedule open`; use Start-Claude to select and run a conversation. A launcher that also creates GitHub work would mix planning mutations with terminal attachment.

**Consequence:** `--schedule new` is refused. The launcher can create a first conversation for an existing Schedule, but does not create that Schedule.

```yaml
id: "START-CLAUDE-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 2. Expose the native session identity

Both attached and detached forms return the background-session short ID. A terminal view identifier would not support later native discovery or survive loss of that view.

**Consequence:** diagnostics must remain separate from Unix standard output and PowerShell success objects. PowerShell refusals are terminating errors rather than Unix exit codes.

```yaml
id: "START-CLAUDE-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

## 3. Keep equivalent platform meaning

Unix shell options and PowerShell parameters express the same operations using each platform's conventions. Psmux supplies Windows terminal multiplexing.

**Consequence:** implementations must preserve behavior and output meaning without pretending that argument parsing, error streams or terminal hooks are identical. The session model documents the psmux-specific lifecycle requirements.

```yaml
id: "START-CLAUDE-003"
status: accepted
supersedes: []
proposed_by: null
approved_by: null
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```
