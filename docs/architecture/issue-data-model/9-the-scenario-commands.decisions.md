---
title: "9. The scenario commands: design decisions"
---

# 9. The scenario commands: design decisions

Companion to [9. The scenario commands](9-the-scenario-commands.md). It records the significant choices behind the scenario commands and the reasons for them. How the work reached this design is in the plans of [#507](../../plans/doc/507-scenario-commands.md) and [#589](../../plans/doc/589-issue-verbs.md).

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

**Status:** Accepted.

**Context and criteria:** A scenario has beats, not steps; its changes are recorded as comments, not amendments; and it is never closed as done.

**Decision:** `star github scenario` is a group beside `star github schedule`, with `list`, `get`, `open`, `create`, `close` and `reopen`. An item moves onto, within and off a scenario by `star github issue move`.

**Reasons:** The two kinds of collection differ in what they hold and how they record a change, and share the words open, close and reopen.

**Alternatives:** Scenario verbs inside `star github schedule`.

**Consequences:** Each scenario verb shares its code with the schedule verb of the same name.

**Design links:** [The commands](9-the-scenario-commands.md#the-commands).

**Approval evidence:** The owner, 2026-11-15, question 1, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings; the verbs synchronized 2026-11-17 (#595), in [#589's plan](../../plans/doc/589-issue-verbs.md).

**Related decisions:** [section 10, D-002](10-the-issue-commands.decisions.md#d-002).

<a id="d-002"></a>

### 2.2. D-002: Beat N is step N of the walk

**Status:** Accepted.

**Context and criteria:** An item found while walking a scenario needs a number that says where in the walk it turned up.

**Decision:** Beat N is the Nth numbered step under the Scenario issue's How to walk through it. Beat 0 is before the first step. `open` refuses a `--walk` that numbers no step, and `move --scenario` refuses a Beat past the last.

**Reasons:** A beat is a place in the walk where any number of items may turn up, or none, so it isn't a row's position, and nothing is renumbered when an item leaves.

**Alternatives:** Renaming the field, or numbering items in order found.

**Consequences:** "Step" is the word for a schedule's row and for the walk's instructions; Beat is the number a found item carries.

**Design links:** [9. The scenario commands](9-the-scenario-commands.md).

**Approval evidence:** The owner, 2026-11-15, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** None.

<a id="d-003"></a>

### 2.3. D-003: A move onto or off a scenario is recorded in two places

**Status:** Accepted.

**Context and criteria:** A scenario has no Amendments section, and an item should say for itself where it was found and where it went.

**Decision:** Each move writes a comment on the Scenario issue, which carries the `--reason`, and a line in the item's body. Off a scenario, the comment comes first, then the body line, then the row moves.

**Reasons:** The order means a run that stops partway leaves a second comment, not a move unrecorded.

**Alternatives:** A comment alone; a body line alone.

**Consequences:** An item's body names its scenario as "Found while walking #N" and records each leaving.

**Design links:** [What a move records on a scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario).

**Approval evidence:** The owner, 2026-11-15, questions 4 and 5, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** [section 10, D-003](10-the-issue-commands.decisions.md#d-003).

<a id="d-004"></a>

### 2.4. D-004: A closed item leaves its scenario

**Status:** Accepted.

**Context and criteria:** A scenario's rows are the work found on its walk that is still to be done.

**Decision:** When an item closes, it leaves its scenario: `star github issue close` comments on the Scenario issue that the item closed, then removes its row. An item closed some other way has its row removed by a recurring check.

**Reasons:** A closed row says nothing about the walk's open work.

**Alternatives:** Keeping closed items as rows, as a schedule keeps its closed steps.

**Consequences:** A reopened item goes to Triage, not back to the scenario ([section 10, D-011](10-the-issue-commands.decisions.md#d-011)).

**Design links:** [What a move records on a scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario).

**Approval evidence:** The owner, 2026-11-15, question 7, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** [D-005](#d-005).

<a id="d-005"></a>

### 2.5. D-005: close closes a scenario as completed, with no Resolution

**Status:** Accepted.

**Context and criteria:** A scenario is kept, updated or removed as the product changes, and is never closed as done. A scenario the product no longer has must be removed, and something must say so.

**Decision:** `close` refuses while any open item is a row of the scenario, then closes the Scenario issue as completed, with no Resolution, and a comment giving the reason. The option stays.

**Reasons:** Nothing was left undone: the scenario served until the product changed, and none of Declined, Duplicate and Invalid applies.

**Alternatives:** Closing with a Resolution; deleting the option.

**Consequences:** `reopen` brings a closed scenario back, its past rows still under its option.

**Design links:** [Closing a scenario](9-the-scenario-commands.md#closing-a-scenario-close).

**Approval evidence:** The owner, 2026-11-15, question 6, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings; renamed from `retire` 2026-11-17 (#595).

**Related decisions:** [D-004](#d-004).

---

Adapted from [arc42 architecture decisions](https://docs.arc42.org/section-9/), by Gernot Starke and Peter Hruschka, under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
