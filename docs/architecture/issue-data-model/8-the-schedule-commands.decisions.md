---
title: "8. The schedule commands: design decisions"
---

# 8. The schedule commands: design decisions

Companion to [8. The schedule commands](8-the-schedule-commands.md). It records the significant choices behind the schedule commands and the reasons for them. How the work reached this design is in the plans of [#439](../../plans/doc/439-schedule-commands.md), [#507](../../plans/doc/507-scenario-commands.md) and [#589](../../plans/doc/589-issue-verbs.md).

## 1. Decision index

| ID | Decision | Status | Design section |
| --- | --- | --- | --- |
| [D-001](#d-001) | The commands select and shape results with star's `--filter`, `--jq` and `--output` | Accepted | [The commands](8-the-schedule-commands.md#the-commands) |
| [D-002](#d-002) | A command that writes reads everything first and reads each write back | Accepted | [The commands](8-the-schedule-commands.md#the-commands) |
| [D-003](#d-003) | One command, `star github issue move`, changes a schedule's steps | Accepted | [What a move records](8-the-schedule-commands.md#what-a-move-records-on-a-schedule) |
| [D-004](#d-004) | Each change to a schedule's steps writes one amendment line | Accepted | [What a move records](8-the-schedule-commands.md#what-a-move-records-on-a-schedule) |
| [D-005](#d-005) | Steps stay consecutive, closed steps renumbered with open ones | Accepted | [What a move records](8-the-schedule-commands.md#what-a-move-records-on-a-schedule) |
| [D-006](#d-006) | `close` posts what merged, by pull request | Accepted | [Closing a schedule](8-the-schedule-commands.md#closing-a-schedule-close) |
| [D-007](#d-007) | A closed schedule's option stays | Accepted | [Closing a schedule](8-the-schedule-commands.md#closing-a-schedule-close) |
| [D-008](#d-008) | `reopen` sets the schedule's own row In progress and unticks its every-step criterion | Accepted | [Reopening a schedule](8-the-schedule-commands.md#reopening-a-schedule-reopen) |

## 2. Decision records

<a id="d-001"></a>

### 2.1. D-001: Results are selected and shaped by star's common flags

**Status:** Accepted.

**Context and criteria:** Readers need to narrow, reshape and render results, the same way on every command.

**Decision:** No command has its own flags for selecting, grouping or rendering. star's `--filter`, `--jq` and `--output` do that work, and `get` returns one schedule by its key.

**Reasons:** A group takes no action of its own; a `--where` flag would be a third way to select, beside `--filter` and `--jq`; grouping is `--jq`'s work; and a schedule's key already names its account.

**Alternatives:** A `star github schedule --group-by Schedule --account NobleFactor --team engprod --where …` command, the owner's example of 2026-11-04.

**Consequences:** The rows of all of a team's schedules are a `report` narrowed with `--jq`.

**Design links:** [The commands](8-the-schedule-commands.md#the-commands).

**Approval evidence:** The owner, 2026-11-11, question 2, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings.

**Related decisions:** None.

<a id="d-002"></a>

### 2.2. D-002: A command reads first and reads each write back

**Status:** Accepted.

**Context and criteria:** GitHub promises no stability for the features the model is built on, and a command that stops partway must leave nothing broken.

**Decision:** A command that writes reads everything it needs first, so a fault is a refusal with nothing written, and reads each write back. A run that stops partway is run again to finish.

**Reasons:** A refusal before any write is cheap; a half-made change found afterward is not.

**Alternatives:** Writing as it reads, and repairing by hand.

**Consequences:** Each command does more reads than writes.

**Design links:** [The commands](8-the-schedule-commands.md#the-commands).

**Approval evidence:** The owner, 2026-11-11, question 3, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings; reads before the first write, #531.

**Related decisions:** None.

<a id="d-003"></a>

### 2.3. D-003: One command changes a schedule's steps

**Status:** Accepted.

**Context and criteria:** Adding a step, moving one and taking one off are one act, moving an issue from where it is to somewhere else.

**Decision:** `star github issue move` puts an issue on a schedule, moves it within one, and takes it off. The issue is its one argument, and its destination a flag.

**Reasons:** A reader can tell which key names the schedule and which the issue, and one command moves an issue anywhere, schedules and scenarios alike.

**Alternatives:** `schedule add`, `move` and `remove`, three commands for one act.

**Consequences:** `move` is a command of `star github issue`, not of `star github schedule` ([section 10](10-the-issue-commands.md#moving-an-issue-move)).

**Design links:** [What a move records on a schedule](8-the-schedule-commands.md#what-a-move-records-on-a-schedule).

**Approval evidence:** The owner, 2026-11-15, recorded in [#507's plan](../../plans/doc/507-scenario-commands.md), § Rulings.

**Related decisions:** [D-004](#d-004).

<a id="d-004"></a>

### 2.4. D-004: Each change to a schedule's steps writes one amendment line

**Status:** Accepted.

**Context and criteria:** A schedule's steps change, and a reader needs to see when, by whom and why. Nothing in GitHub marks a schedule committed.

**Decision:** Each change writes one line at the end of the Schedule issue's Amendments section, naming the date, who ran the command, what changed and the `--reason`. The line is written first, marked "(in progress)", and settled last.

**Reasons:** One line per change keeps the record next to the schedule. Writing it first means a run that stops partway leaves a line a reader sees is unfinished, which the same command run again finishes.

**Alternatives:** An amendment only on a committed schedule, which GitHub can't tell apart.

**Consequences:** The command records who ran it, not on whose word, which it can't know.

**Design links:** [What a move records on a schedule](8-the-schedule-commands.md#what-a-move-records-on-a-schedule).

**Approval evidence:** The owner, 2026-11-11, question 4, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings.

**Related decisions:** [D-003](#d-003).

<a id="d-005"></a>

### 2.5. D-005: Steps stay consecutive, closed steps renumbered with open ones

**Status:** Accepted.

**Context and criteria:** Steps are worked in order, and closed steps sit among open ones. On issue tracking, iteration 1, steps 29 (#440) and 35 (#447) were closed between open steps when #482 to #485 went in after step 22.

**Decision:** The steps are consecutive whole numbers, and every later step, closed or open, moves when a step is added, moved or taken off.

**Reasons:** A rule that a closed step keeps its number would refuse almost every `--after`.

**Alternatives:** Closed steps keep their numbers.

**Consequences:** A closed step's number can change after it closes; its amendment lines record each change.

**Design links:** [What a move records on a schedule](8-the-schedule-commands.md#what-a-move-records-on-a-schedule).

**Approval evidence:** The owner, 2026-11-11, question 5, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings.

**Related decisions:** [D-004](#d-004).

<a id="d-006"></a>

### 2.6. D-006: close posts what merged, by pull request

**Status:** Accepted.

**Context and criteria:** Every Schedule issue asks for its evidence of completion, which should show what was delivered and when.

**Decision:** `close` refuses while any step is open or any exit criterion is unticked, then posts one row for each merged pull request, with the date it merged and the steps it closed, then each step no merged pull request closed, with how it closed.

**Reasons:** The pull requests are what merged; listing them in order shows what was delivered and when. A step's pull request is one GitHub records as closing it, or whose commit closed it, so a pull request that only mentions an issue doesn't count.

**Alternatives:** One row per step.

**Consequences:** A step closed by hand, with no `Closes` line, shows no pull request.

**Design links:** [Closing a schedule](8-the-schedule-commands.md#closing-a-schedule-close).

**Approval evidence:** The owner, 2026-11-12, question 6, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings.

**Related decisions:** [D-007](#d-007).

<a id="d-007"></a>

### 2.7. D-007: A closed schedule's option stays

**Status:** Accepted.

**Context and criteria:** A step isn't a sub-issue of its Schedule issue, so its row's Schedule field is the only link between them. Deleting an option blanks every row that held it.

**Decision:** `close` keeps the schedule's option.

**Reasons:** The option records which schedule each closed step belonged to.

**Alternatives:** Deleting the option when the schedule closes.

**Consequences:** GitHub allows at most 50 options in a single-select field, and a team's Schedule field grows by one per schedule; how the record is kept once a field nears 50 is decided then.

**Design links:** [Closing a schedule](8-the-schedule-commands.md#closing-a-schedule-close).

**Approval evidence:** The owner, 2026-11-11, recorded in [#439's plan](../../plans/doc/439-schedule-commands.md), § Rulings.

**Related decisions:** [D-006](#d-006).

<a id="d-008"></a>

### 2.8. D-008: reopen sets the own row In progress and unticks the every-step criterion

**Status:** Accepted.

**Context and criteria:** A schedule is in progress while any of its steps is open, so one closed before a step was reopened or added has to be reopened.

**Decision:** `reopen` reopens the Schedule issue with a comment, sets its own row In progress, and unticks each ticked exit criterion whose text begins "Every step" or "Every other step". `star github issue reopen` does the same for each closed schedule a reopened issue is a step of.

**Reasons:** The schedule then says what it is: in progress, with its every-step criterion unmet.

**Alternatives:** Reopening the issue alone, which leaves its row and criteria saying it's finished.

**Consequences:** A schedule with no such criterion is reopened all the same, and its record says none was unticked.

**Design links:** [Reopening a schedule](8-the-schedule-commands.md#reopening-a-schedule-reopen).

**Approval evidence:** The owner, 2026-11-17 (#595), recorded in [#589's plan](../../plans/doc/589-issue-verbs.md), § 2, Issue 595.

**Related decisions:** [section 10, D-011](10-the-issue-commands.decisions.md#d-011).

---

Adapted from [arc42 architecture decisions](https://docs.arc42.org/section-9/), by Gernot Starke and Peter Hruschka, under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
