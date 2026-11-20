---
title: "10. The issue commands: design decisions"
---

# 10. The issue commands: design decisions

Companion to [10. The issue commands](10-the-issue-commands.md). It records the significant choices behind the issue commands and the reasons for them. How the work reached this design is in [the plan](../../plans/doc/589-issue-verbs.md).

## 1. Decision index

| ID | Decision | Status | Design section |
| --- | --- | --- | --- |
| [D-001](#d-001) | The verbs are `open`, `move`, `close` and `reopen`, and `create` is another name for `open` | Accepted | [The commands](10-the-issue-commands.md#the-commands) |
| [D-002](#d-002) | The issue verbs act on epics, features, tasks and bugs; Schedule and Scenario issues belong to their groups | Accepted | [The commands](10-the-issue-commands.md#the-commands) |
| [D-003](#d-003) | An issue goes wherever its type allows, from wherever it is | Accepted | [Where an issue lives](10-the-issue-commands.md#where-an-issue-lives) |
| [D-004](#d-004) | An epic or a feature stays on the Backlog until it closes, its state its children's | Accepted | [Epics and features](10-the-issue-commands.md#epics-and-features) |
| [D-005](#d-005) | `open` opens its issue in the repository of the clone it runs in | Accepted | [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create) |
| [D-006](#d-006) | `open` gives the issue no row; the Triage workflow does | Accepted | [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create) |
| [D-007](#d-007) | `open`'s defaults: Priority Medium, Severity by type, no assignee | Accepted | [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create) |
| [D-008](#d-008) | Work not done closes as completed, with a Resolution | Accepted | [Closing an issue](10-the-issue-commands.md#closing-an-issue-close) |
| [D-009](#d-009) | `close` writes the comment, the Resolution, the closure, then the rows | Accepted; its consequence superseded by D-013 | [Closing an issue](10-the-issue-commands.md#closing-an-issue-close) |
| [D-010](#d-010) | `close` closes no parent | Accepted | [Closing an issue](10-the-issue-commands.md#closing-an-issue-close) |
| [D-011](#d-011) | `reopen` reopens the issue's closed parents and schedules, and gives an issue with no row a Triage row | Accepted | [Reopening an issue](10-the-issue-commands.md#reopening-an-issue-reopen) |
| [D-012](#d-012) | Every project's first view is named Default; the Backlog has an Epics and features view | Accepted | [Epics and features](10-the-issue-commands.md#epics-and-features) |
| [D-013](#d-013) | `close` and `reopen` are idempotent: run again, each ends where one complete run would have ended | Accepted | [Closing an issue](10-the-issue-commands.md#closing-an-issue-close); [Reopening an issue](10-the-issue-commands.md#reopening-an-issue-reopen) |

## 2. Decision records

<a id="d-001"></a>

### 2.1. D-001: The verbs are open, move, close and reopen

**Status:** Accepted.

**Context and criteria:** The commands change an issue's state and place. Their names should be the words a GitHub user already uses for an issue's state, and should pair up.

**Decision:** The verbs are `open`, `move`, `close` and `reopen`. `create` is another name for `open`, the same command.

**Reasons:** Open and closed are GitHub's own words for an issue's state, so `open`, `close` and `reopen` say what they do and pair with each other. People who use `gh` reach for `create`, so it runs `open`.

**Alternatives:** `file` for opening an issue, which pairs with nothing; `create` alone, which doesn't pair with `close`.

**Consequences:** Until star lets an extension command name another name for itself (NobleFactor/devlore-cli#1235), `create` is a second manifest entry with `open`'s implementation, its flags written twice.

**Design links:** [The commands](10-the-issue-commands.md#the-commands).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12.

**Related decisions:** [D-002](#d-002).

<a id="d-002"></a>

### 2.2. D-002: The issue verbs act on epics, features, tasks and bugs

**Status:** Accepted.

**Context and criteria:** A Schedule or Scenario issue is the record of its collection: its row is the collection's own, on its Schedule or Scenario project. One set of words should open, close and reopen every kind of thing.

**Decision:** `star github issue` opens, moves, closes and reopens epics, features, tasks and bugs, and refuses a Schedule or Scenario issue, naming its group's command. `star github schedule` and `star github scenario` each have `open`, with `create`, `close` and `reopen`.

**Reasons:** Opening, closing and reopening a collection changes its option and its own row, which the issue verbs don't touch. The same words across the three groups mean a reader learns them once.

**Alternatives:** Letting `issue` verbs open or close a Schedule or Scenario issue, which would leave its option and own row out of step with it.

**Consequences:** `schedule new` and `scenario new` became `open`, and `scenario retire` became `close`; `reopen` joined both groups.

**Design links:** [The commands](10-the-issue-commands.md#the-commands); [section 8](8-the-schedule-commands.md); [section 9](9-the-scenario-commands.md).

**Approval evidence:** The owner, 2026-11-17 (#595), recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 2, Issue 595.

**Related decisions:** [D-001](#d-001).

<a id="d-003"></a>

### 2.3. D-003: An issue goes wherever its type allows, from wherever it is

**Status:** Accepted.

**Context and criteria:** Work has to reach the place it belongs in one command, whatever project it is on now. Each project holds only the types that make sense there.

**Decision:** `move` puts an epic, a feature, a task or a bug in Triage or the Backlog, and a task or a bug on a schedule or a scenario, from wherever it is; an issue with no type goes only to Triage; a Schedule or Scenario issue goes nowhere. It leaves its old place as that place records a move.

**Reasons:** The only limit on a move is the type of the issue. Schedules and scenarios are lists of work, so they hold tasks and bugs; an issue with no type hasn't been classified, so it waits in Triage.

**Alternatives:** Moving only off a schedule or a scenario, which left an issue opened into Triage no way to reach the Backlog by command.

**Consequences:** Every source records a move it loses: a schedule's amendment, a scenario's comment and body line, or a removed Triage or Backlog row.

**Design links:** [Where an issue lives](10-the-issue-commands.md#where-an-issue-lives); [Moving an issue](10-the-issue-commands.md#moving-an-issue-move).

**Approval evidence:** The owner, 2026-11-17 (#597), recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 6.

**Related decisions:** [D-004](#d-004).

<a id="d-004"></a>

### 2.4. D-004: An epic or a feature stays on the Backlog until it closes

**Status:** Accepted.

**Context and criteria:** An epic or a feature classifies work rather than being worked itself. A reader needs to see every open epic and feature, and its state, without a command having to move it as its children move.

**Decision:** An epic or a feature goes to Triage when it is opened and to the Backlog once it is classified, and stays there until it closes. Its state comes from its children: it is in progress when any issue under it is, and it is ready to close when all of them are closed.

**Reasons:** The trackers we compared, read on 2026-11-17, keep an epic or a feature where it is while its work is pulled into a sprint, and change its state instead:

| Tracker | Where epics and features live | What goes into a sprint | How their state changes |
| --- | --- | --- | --- |
| Azure Boards | Portfolio backlogs, Features and Epics, apart from the product backlog of stories and bugs | Stories and bugs; features and epics "might take one or more sprints" | Shown on their backlog while Proposed, In Progress or Resolved, and hidden once Completed; rollup columns show the children's progress |
| Jira | An epics panel beside the backlog | Stories, bugs and tasks | Set by hand, or by an automation rule that moves the epic to In Progress when a child moves |
| Shortcut | Its epics list | Stories; its iteration automations handle stories alone | Auto Start Epic when a story starts, and Auto Complete Epic when every story is done |
| Linear | Parent issues | Issues | Optionally, the parent is marked done when every sub-issue is |

**Alternatives:** Taking an epic or a feature off the Backlog when its first task or bug is pulled onto a schedule or a scenario. That records its state by moving its row, and every move of a child would have to check its parents in both directions, since a child can go back to the Backlog. None of the trackers does it. Leaving it on no project once classified hides it from every board.

**Consequences:** The Backlog holds epics and features beside tasks and bugs, so it has a view of each kind ([D-012](#d-012)). `star github triage sweep` flags an epic or a feature on a Schedule or Scenario project, not one on the Backlog. A reopened epic or feature, which `close` took off the Backlog, goes to Triage ([D-011](#d-011)).

**Design links:** [Epics and features](10-the-issue-commands.md#epics-and-features).

**Approval evidence:** The owner, 2026-11-17 and 2026-11-18 (#597), recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 7.

**Related decisions:** [D-003](#d-003), [D-011](#d-011), [D-012](#d-012). Sources: [Azure Boards: Use backlogs to manage projects](https://learn.microsoft.com/en-us/azure/devops/boards/backlogs/backlogs-overview), [Azure Boards: Define features and epics](https://learn.microsoft.com/en-us/azure/devops/boards/backlogs/define-features-epics), [Shortcut: Automations](https://www.shortcut.com/help/fields-and-features/automations), [Linear: Parent and sub-issues](https://linear.app/docs/parent-and-sub-issues), and [Atlassian Community: Automation for moving epics to In Progress when any child story is moved](https://community.atlassian.com/t5/Jira-questions/Automation-for-Moving-Epics-to-In-Progress-when-any-of-the-child/qaq-p/2490530).

<a id="d-005"></a>

### 2.5. D-005: open opens its issue in the clone's repository

**Status:** Accepted.

**Context and criteria:** `open` must know which repository to open an issue in, without the person repeating what the clone they're in already says.

**Decision:** `open` opens its issue in the repository its clone's origin names. `--directory <path>` names another clone, as git's `-C` does.

**Reasons:** It matches how git and `star github plan link` find their repository. A workflow runs in a checkout of the repository it files in.

**Alternatives:** A required `--repository` flag; defaulting to the parent's repository, which an epic doesn't have.

**Consequences:** `--directory` has no short name until star lets an extension flag have one (NobleFactor/devlore-cli#1236).

**Design links:** [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 3.

**Related decisions:** None.

<a id="d-006"></a>

### 2.6. D-006: open gives the issue no row

**Status:** Accepted.

**Context and criteria:** An issue is a row of at most one of its account's four projects, and the Triage workflow gives every issue opened a Triage row.

**Decision:** `open` takes no `--project` or `--status`. The Triage workflow gives the issue its row, and `move` places it from there.

**Reasons:** A row `open` made on the Backlog would leave the issue on two projects once the workflow added its Triage row.

**Alternatives:** Making the row in `open`'s one call and having the workflow skip an issue that already has a row.

**Consequences:** An issue opened for the Backlog takes two commands: `open`, then `move --backlog`.

**Design links:** [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 4.

**Related decisions:** [D-003](#d-003).

<a id="d-007"></a>

### 2.7. D-007: open's defaults

**Status:** Accepted.

**Context and criteria:** Every issue needs a Priority and a Severity, and a workflow that opens issues shouldn't assign them to its bot.

**Decision:** Priority is Medium unless given. A Bug's Severity is Medium unless given, as the Triage workflow starts a bug; every other type's Severity is N/A. No one is assigned unless `--assignee` names someone.

**Reasons:** Medium is the Priority the issues split from features have had, and the Severity the Triage workflow gives a new bug. Only a bug has a Severity.

**Alternatives:** A required Priority; assigning whoever runs the command, as `schedule open` does.

**Consequences:** `--severity` is refused on any type but Bug.

**Design links:** [Opening an issue](10-the-issue-commands.md#opening-an-issue-open-and-create).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, question 2 and departure 5.

**Related decisions:** None.

<a id="d-008"></a>

### 2.8. D-008: Work not done closes as completed, with a Resolution

**Status:** Accepted.

**Context and criteria:** A closed issue must say whether its work was done, and if not, why.

**Decision:** An issue whose work was done closes with its evidence. An issue whose work wasn't done closes as completed, with its Resolution, Declined, Duplicate or Invalid, and a comment saying why. GitHub's "not planned" is never used.

**Reasons:** The Resolution says why in one field a report can read, where GitHub's reason can't say which of the three it was.

**Alternatives:** Closing as "not planned".

**Consequences:** In a user account, which has no issue fields, the Resolution is a `resolution:` label.

**Design links:** [Closing an issue](10-the-issue-commands.md#closing-an-issue-close).

**Approval evidence:** The owner, 2026-11-03, recorded in the [issue standards](../../issue-standards.md).

**Related decisions:** [D-009](#d-009).

<a id="d-009"></a>

### 2.9. D-009: close writes the comment, the Resolution, the closure, then the rows

**Status:** Accepted. Its consequence, that a run which stops after closing the issue leaves its rows to be changed by hand, is superseded by [D-013](#d-013).

**Context and criteria:** `close` writes several things, and a reader of the issue should see why it closed before anything else changes.

**Decision:** For each issue, `close` writes the comment, then the Resolution, then closes the issue, then changes its rows. An issue already closed is left as it is.

**Reasons:** The issue's record of why it closed comes first, as the design was approved.

**Alternatives:** Changing the rows first and closing the issue last, so a run that stops partway leaves the issue open, and changing the rows of an issue already closed.

**Consequences:** A run that stops after closing the issue leaves its rows to be changed by hand. Superseded by [D-013](#d-013): `close`, run again, changes them.

**Design links:** [Closing an issue](10-the-issue-commands.md#closing-an-issue-close).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 1.

**Related decisions:** [D-008](#d-008).

<a id="d-010"></a>

### 2.10. D-010: close closes no parent

**Status:** Accepted.

**Context and criteria:** A feature or an epic has its own evidence of completion, which its last child's evidence isn't.

**Decision:** `close` doesn't close a parent when it closes the parent's last open child; its record names the parent.

**Reasons:** A feature or an epic closes with its own evidence, by `close` run on it.

**Alternatives:** Closing the parent with its last child.

**Consequences:** Someone closes each feature and epic deliberately, prompted by the record.

**Design links:** [Closing an issue](10-the-issue-commands.md#closing-an-issue-close).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, question 1.

**Related decisions:** [D-011](#d-011).

<a id="d-011"></a>

### 2.11. D-011: reopen reopens what the issue belongs to

**Status:** Accepted.

**Context and criteria:** A reopened issue is open work, so a closed feature, epic or schedule it belongs to is open again too, and the issue needs a place to be seen.

**Decision:** `reopen` reopens the issue's closed parents, its feature and then its epic, and each closed schedule it is a step of, setting the schedule's own row In progress and unticking its every-step criterion. An issue or a parent it reopens with no row on its team's four projects gets a Triage row. Since [D-013](#d-013), it also finishes a parent or schedule that is open but still holds what a closing left.

**Reasons:** A schedule is in progress while any of its steps is open. The Triage workflow runs only when an issue is opened, so a reopened issue with no row would be on no board.

**Alternatives:** Reopening the issue alone; sending a reopened item back to the scenario it left.

**Consequences:** A reopened epic or feature, whether named or reopened for an issue under it, goes to Triage, not back to the Backlog, for review.

**Design links:** [Reopening an issue](10-the-issue-commands.md#reopening-an-issue-reopen); [section 8, Reopening a schedule](8-the-schedule-commands.md#reopening-a-schedule-reopen).

**Approval evidence:** The owner, 2026-11-17, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 2.

**Related decisions:** [D-004](#d-004), [D-010](#d-010).

<a id="d-012"></a>

### 2.12. D-012: Every project's first view is named Default

**Status:** Accepted.

**Context and criteria:** A project's views should say what each shows, and the Backlog holds both kinds of issue ([D-004](#d-004)).

**Decision:** Every project's first view is named Default and shows every row. Each Backlog also has an Epics and features view. In NobleFactor, the Backlog's By priority view shows its tasks and bugs in Priority order; David-Noble-at-work, which has no Priority field, has no By priority view.

**Reasons:** "Default" says what the view is; "View 1" is only GitHub's name for a new project's first view. Work is taken from the Backlog's tasks and bugs in Priority order.

**Alternatives:** Keeping GitHub's "View 1".

**Consequences:** `star github model apply` renames each project's first view and adds the Epics and features view when it is next run.

**Design links:** [Epics and features](10-the-issue-commands.md#epics-and-features).

**Approval evidence:** The owner, 2026-11-18, recorded in [the plan](../../plans/doc/589-issue-verbs.md), § 12, departure 9.

**Related decisions:** [D-004](#d-004).

<a id="d-013"></a>

### 2.13. D-013: close and reopen are idempotent

**Status:** Accepted.

**Context and criteria:** A run of `close` or `reopen` can stop partway: GitHub refuses a write, GitHub accepts a write whose answer is lost, or the run is killed between two writes. A pull request's `Closes` line also closes an issue, and leaves its rows; clicking Reopen on GitHub's page reopens only the issue itself. Every command is to be idempotent: run again, it never leaves its work half done, and never does the same work twice.

**Decision:** `close`, run on an issue already closed, writes only what one complete run would have written and the earlier run didn't. A comment is written only if the issue's history since it last reopened holds none of its kind; a comment on a Scenario issue counts only for the item it names. The Resolution is set by comparing the one asked for, the one the issue holds, and the one `close` last recorded, and a change of it gets its own comment, written after the change. `reopen` chooses its work from each issue's records, not its history: an issue, parent or schedule that is open but still holds a Resolution, a Closed row, a row without a Status, no row, a ticked every-step criterion, or no reopening's comment since it last closed gets only what is missing; an issue that has never closed gets no comment. An issue with nothing left to do is `unchanged`, and nothing is written.

**Reasons:** The finished state is right however an issue reached a half-finished one, so a second run needn't know who left it. Looking back only to the last reopening keeps one comment for each close, and lets a later close have its own. Comparing with what `close` last recorded tells a change made by hand from a run that stopped.

**Alternatives:** Leaving a stopped run's rows to be changed by hand ([D-009](#d-009)), and a stopped `reopen` recording `unchanged`. A marker each run writes for the next to find. Matching a comment by its full text, which holds the date and who ran it. Refusing a different Resolution, though anyone can change it by hand. Running `close` as a graph that can be undone, which needs a GitHub provider first (NobleFactor/devlore-cli#1238).

**Consequences:** `close` reads each issue's history, and each Scenario issue's, before its first write; `reopen` reads each issue's, each parent's and each schedule's. Two workers changing one issue at the same moment are not covered: the last write wins. The rule doesn't yet cover recovering a stopped `open`, which NobleFactor/devlore-cli#1238 does through a graph, or `move`'s comment on a Scenario issue, which #611 fixes.

**Design links:** [Closing an issue](10-the-issue-commands.md#closing-an-issue-close); [Reopening an issue](10-the-issue-commands.md#reopening-an-issue-reopen).

**Approval evidence:** Approved 2026-11-19 in [the plan for #609](../../plans/feature/609-rerun-finishes.md), § 12, at revision 71f40ef.

**Related decisions:** [D-008](#d-008), [D-009](#d-009), [D-011](#d-011).

---

Adapted from [arc42 architecture decisions](https://docs.arc42.org/section-9/), by Gernot Starke and Peter Hruschka, under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
