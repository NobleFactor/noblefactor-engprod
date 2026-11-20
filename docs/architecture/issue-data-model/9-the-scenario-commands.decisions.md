---
title: "Scenario command decisions"
status: draft
updated: 2026-11-20
---

<a id="9-the-scenario-commands-design-decisions"></a>

# Scenario command decisions

These records explain the [Scenario command design](9-the-scenario-commands.md). Approval evidence links the plans; implementation progress remains in them.

The [decision-record standard](../../standards/documentation.md#decision-records) governs these footers. Unknown attribution and dates remain null; combined approval dates stay in their source evidence. Recording time identifies this revision.

## 1. Decision index

| ID | Decision | Status | Design section |
| --- | --- | --- | --- |
| [D-001](#d-001) | Scenarios have a command group of their own | Accepted | [The commands](9-the-scenario-commands.md#the-commands) |
| [D-002](#d-002) | Beat N is step N of the walk | Accepted | [9. The scenario commands](9-the-scenario-commands.md) |
| [D-003](#d-003) | A move onto or off a scenario is recorded in two places | Accepted | [What a move records](9-the-scenario-commands.md#what-a-move-records-on-a-scenario) |
| [D-004](#d-004) | A closed item leaves its scenario | Accepted | [What a move records](9-the-scenario-commands.md#what-a-move-records-on-a-scenario) |
| [D-005](#d-005) | `close` closes a scenario as completed, with no Resolution | Accepted | [Closing a scenario](9-the-scenario-commands.md#closing-a-scenario-close) |

## 2. Decision records

<a id="d-001"></a>

### 2.1. D-001: Scenarios have a command group of their own

**Context and criteria:** A scenario has beats, not steps; its changes are recorded as comments, not amendments; and it is never closed as done.

**Decision:** `star github scenario` is a group beside `star github schedule`, with `list`, `get`, `open`, `create`, `close` and `reopen`. An item moves onto, within and off a scenario by `star github issue move`.

**Reasons:** The two kinds of collection differ in what they hold and how they record a change, and share the words open, close and reopen.

**Alternatives:** Scenario verbs inside `star github schedule`.

**Consequences:** Each scenario verb shares its code with the schedule verb of the same name.

**Design links:** [The commands](9-the-scenario-commands.md#the-commands).

**Approval evidence:** The owner, 2026-11-15, question 1, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings; the verbs synchronized 2026-11-17 (#595), in [#589's plan](../../plans/doc/589-issue-verbs.md).

**Related decisions:** [section 10, D-002](10-the-issue-commands.decisions.md#d-002).

```yaml
id: "D-001"
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: null
recorded_at: "2026-11-20T15:55:37Z"
```

<a id="d-002"></a>

### 2.2. D-002: Beat N is step N of the walk

**Context and criteria:** An item found while walking a scenario needs a number that says where in the walk it turned up.

**Decision:** Beat N is the Nth numbered step under the Scenario issue's How to walk through it. Beat 0 is before the first step. `open` refuses a `--walk` that numbers no step, and `move --scenario` refuses a Beat past the last.

**Reasons:** A beat is a place in the walk where any number of items may turn up, or none, so it isn't a row's position, and nothing is renumbered when an item leaves.

**Alternatives:** Renaming the field, or numbering items in order found.

**Consequences:** "Step" is the word for a schedule's row and for the walk's instructions; Beat is the number a found item carries.

**Design links:** [9. The scenario commands](9-the-scenario-commands.md).

**Approval evidence:** The owner, 2026-11-15, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

```yaml
id: "D-002"
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: "2026-11-15"
recorded_at: "2026-11-20T15:55:37Z"
```

<a id="d-003"></a>

### 2.3. D-003: A move onto or off a scenario is recorded in two places

**Context and criteria:** A scenario has no Amendments section, and an item should say for itself where it was found and where it went.

**Decision:** Each move writes a comment on the Scenario issue, which carries the `--reason`, and a line in the item's body. Off a scenario, the comment comes first, then the body line, then the row moves.

**Reasons:** The order means a run that stops partway leaves a second comment, not a move unrecorded.

**Alternatives:** A comment alone; a body line alone.

**Consequences:** An item's body names its scenario as "Found while walking #N" and records each leaving.

**Design links:** [What a move records on a scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario).

**Approval evidence:** The owner, 2026-11-15, questions 4 and 5, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** [section 10, D-003](10-the-issue-commands.decisions.md#d-003).

```yaml
id: "D-003"
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: "2026-11-15"
recorded_at: "2026-11-20T15:55:37Z"
```

<a id="d-004"></a>

### 2.4. D-004: A closed item leaves its scenario

**Context and criteria:** A scenario's rows are the work found on its walk that is still to be done.

**Decision:** A closed finding leaves its Scenario. The issue-close command records the closure on the Scenario issue and removes the row. Closure through another path still requires row cleanup; the [operational contract](9-the-scenario-commands.md#ongoing-cleanup) identifies the maintained procedure and separate automation work.

**Reasons:** A closed row says nothing about the walk's open work.

**Alternatives:** Keeping closed items as rows, as a schedule keeps its closed steps.

**Consequences:** A reopened item goes to Triage, not back to the scenario ([section 10, D-011](10-the-issue-commands.decisions.md#d-011)).

**Design links:** [What a move records on a scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario).

**Approval evidence:** The owner, 2026-11-15, question 7, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** [D-005](#d-005).

```yaml
id: "D-004"
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: "2026-11-15"
recorded_at: "2026-11-20T15:55:37Z"
```

<a id="d-005"></a>

### 2.5. D-005: close closes a scenario as completed, with no Resolution

**Context and criteria:** A scenario is kept, updated or removed as the product changes, and is never closed as done. A scenario the product no longer has must be removed, and something must say so.

**Decision:** `close` refuses while any open item is a row of the scenario, then closes the Scenario issue as completed, with no Resolution, and a comment giving the reason. The option stays.

**Reasons:** Nothing was left undone: the scenario served until the product changed, and none of Declined, Duplicate and Invalid applies.

**Alternatives:** Closing with a Resolution; deleting the option.

**Consequences:** `reopen` brings a closed scenario back, its past rows still under its option.

**Design links:** [Closing a scenario](9-the-scenario-commands.md#closing-a-scenario-close).

**Approval evidence:** The owner, 2026-11-15, question 6, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings; the collection interface is recorded in the [Issue verbs plan](../../plans/doc/589-issue-verbs.md).

**Related decisions:** [D-004](#d-004).

```yaml
id: "D-005"
status: accepted
supersedes: []
proposed_by: null
approved_by: David Noble
recorded_by: Codex
decided_at: "2026-11-15"
recorded_at: "2026-11-20T15:55:37Z"
```

---

Adapted from [arc42 architecture decisions](https://docs.arc42.org/section-9/), by Gernot Starke and Peter Hruschka, under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
