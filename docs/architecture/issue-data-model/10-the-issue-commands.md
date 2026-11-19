---
title: "10. The issue commands"
---

# 10. The issue commands

`star github issue` opens, moves, closes and reopens issues, in an organization and in a user account. It has four verbs, `open`, `move`, `close` and `reopen`, and `create` is another name for `open`. They act on epics, features, tasks and bugs. A Schedule or Scenario issue is the record of its collection, and is opened, closed and reopened by its own group's verbs: `star github schedule` ([section 8](8-the-schedule-commands.md)) and `star github scenario` ([section 9](9-the-scenario-commands.md)). Nothing here makes a project, a field or an option.

## The commands

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `open --type <type> --parent <issue> --area <area> --title <title> --body-file <path> [...]` | Opens an issue in the repository of the clone it runs in, classified as it is made | Issue, with its fields or labels and its parent link |
| `open --template <path> [--set <name>=<value>,...]` | The same, from a template | The same |
| `create ...` | `open`, by another name | The same |
| `move <issue>... (--triage \| --backlog \| --schedule <schedule> \| --scenario <scenario> --beat <beat>) --reason <text>` | Puts issues in Triage, in the Backlog, on a schedule or on a scenario, from wherever each is | Rows, a schedule's amendment, comments, bodies |
| `close <issue>... --evidence <path>` | Closes issues whose work is done, each with its evidence | Comment, issue, rows |
| `close <issue>... --resolution Declined\|Duplicate\|Invalid --reason <text>` | Closes issues whose work was not done, each with its Resolution | Comment, field or label, issue, rows |
| `reopen <issue>... --reason <text>` | Reopens issues, with their closed parents and the closed schedules they are steps of | Comments, issues, fields or labels, rows, a Schedule issue's body |

An `<issue>` is written `<owner>/<repository>#<number>`. Every command names what it acts on, takes star's `--filter`, `--jq` and `--output`, returns one flat record per thing it read or changed, JSON by default, and exits non-zero only on an error. Every command reads all it needs before its first write, so a fault is a refusal with nothing written, and reads every write back. A run that stops partway is run again to finish. `--dry-run` is refused.

## Where an issue lives

Each team, and each user account, has four projects: Triage, Backlog, Schedule and Scenario (section 3). An issue is a row of at most one of them. What its type allows decides where it can be:

| Type | Triage | Backlog | A schedule | A scenario |
| --- | --- | --- | --- | --- |
| Epic, Feature | Yes | Yes | No | No |
| Task, Bug | Yes | Yes | Yes | Yes |
| No type | Yes | No | No | No |
| Schedule, Scenario | No | No | No | No |

A new issue goes to Triage: the Triage workflow gives every issue opened a Triage row, except an item found while walking a scenario, which it puts on that scenario (section 9). An issue with no type stays in Triage until it is classified. A Schedule or Scenario issue's only row is its own, on its Schedule or Scenario project.

### Epics and features

An epic or a feature goes to Triage when it is opened and to the Backlog once it is classified. It stays on the Backlog until it closes, when `close` removes its row. Nothing moves it when its tasks and bugs are pulled onto a schedule or a scenario.

Its state comes from its children. It is in progress when any issue under it is in progress, and it is ready to close when all of them are closed; `close` says so when it closes the last one. `star github schedule report --by feature` and `--by epic` show where each stands. Every Backlog has a Default view of all its rows and an Epics and features view; in NobleFactor, its By priority view shows its tasks and bugs in Priority order.

Other issue trackers do the same: none moves an epic or a feature when its work is pulled into a sprint. The comparison, and the alternative it rules out, are in [D-004](10-the-issue-commands.decisions.md#d-004).

## Opening an issue: open, and create

```
star github issue open --type <type> --parent <issue> --area <area> --title <title> --body-file <path>
    [--priority <priority>] [--severity <severity>] [--assignee <login>] [--unique] [--directory <path>]
star github issue open --template <path> [--set <name>=<value>[,<name>=<value>]...] [--directory <path>]
```

`open` opens its issue in the repository of the clone it runs in, the repository its origin names. `--directory <path>` names another clone, as git's `-C` does. `create` is the same command.

A template is the issue's header and then its body. The header takes the values the flags give: `type`, `parent`, `title`, `area`, `priority`, `severity`, `assignee` and `unique`. With `--template`, no flag but `--set` and `--directory` is given. Each `{name}` in the header or the body is a blank that `--set` fills; a shell's `${name}` is left alone. `--set` takes its pairs comma-separated.

```markdown
---
type: Task
parent: NobleFactor/devlore-cli#1019
title: "Update CI, {month}: the workflows' actions and the golangci-lint pin"
area: Engineering
unique: true
---
### Problem
…
```

`open` does this, in order:

1. **Fills the blanks.** A blank left unfilled is refused.
2. **Reads everything it needs:** the clone's repository, the account's model, the type, the parent and its type, the Area, Priority and Severity options, and the type's issue form, from the account's `.github` repository when it runs.
3. **Checks the issue,** and refuses it, writing nothing, when it has no Area; its type is one the account doesn't have, or is Schedule or Scenario, which `star github schedule open` and `star github scenario open` open; its parent isn't one level up, or it is an Epic with a parent; its body lacks a section its form requires, or its Plan and design documents table; it is given a Severity and isn't a Bug; the directory is no clone; or the repository takes no part in issue tracking.
4. **Looks for a duplicate,** with `unique`: when the parent already has a sub-issue, open or closed, with the same title, `open` opens nothing, names that issue, and exits 0.
5. **Opens the issue** in one call, with its type, its parent, its assignee, and its Area, Priority and Severity. Priority is Medium unless given. A Bug's Severity is Medium unless given, as the Triage workflow starts a bug, and every other type's is N/A. No one is assigned unless `--assignee` names someone.
6. **Reads it all back,** and fails, naming each value that differs from what it asked for.

`open` gives the issue no row: the Triage workflow gives it its Triage row, and `move` places it from there. In David-Noble-at-work, which has no issue types or issue fields, `open` writes the labels that stand in for them: the type's label, `area:`, `priority:` and `severity:`.

Its record is the issue it opened, or found with `unique`: its key, title, type, parent, Area, Priority, Severity and assignee, and whether it was `opened` or `found`.

## Moving an issue: move

```
star github issue move <issue>...
    ( --triage
    | --backlog
    | --schedule <schedule> [--after <step>] [--blocked-by <issue>[,<issue>...]] [--assignee <login>]
    | --scenario <scenario> --beat <beat> )
    --reason <text>
```

`move` puts each issue where it is sent, from wherever it is, in the order given, as far as its type allows (§ Where an issue lives). Exactly one destination is given. `--reason` is written where the move is recorded.

An issue leaves the place it was in the same act:

- **Off a schedule:** its row comes off, every later step moves up one, and one line in the Schedule issue's Amendments section records the change ([section 8](8-the-schedule-commands.md#what-a-move-records-on-a-schedule)).
- **Off a scenario:** a comment on the Scenario issue and a line in the item's body record that it left and where it went, and its row comes off ([section 9](9-the-scenario-commands.md#what-a-move-records-on-a-scenario)).
- **Out of Triage or the Backlog:** its row comes off.

Onto a schedule, it takes the next step, or the steps after `--after`, every later step moving down; `--blocked-by` adds blocked-by links, and an issue from another team's repository is assigned to `--assignee`, a member of the schedule's team. Onto a scenario, it gets the Beat at which it turned up. Into Triage or the Backlog, it gets a row with Status Open, keeping its Priority. An issue already where it is sent is `unchanged`.

`move` reads every place it leaves before its first write, each once however many issues leave it, reads the rows again just before that write, and writes nothing if they changed. It refuses, writing nothing, a Schedule or Scenario issue; a type the destination doesn't take; a closed issue; an issue of another account; and the refusals sections 8 and 9 give for a schedule and a scenario.

## Closing an issue: close

```
star github issue close <issue>... --evidence <path>
star github issue close <issue>... --resolution Declined|Duplicate|Invalid --reason <text>
```

An issue whose work was done closes with its evidence. An issue whose work was not done closes as completed, with its Resolution saying why; GitHub's "not planned" is not used. Exactly one of `--evidence` and `--resolution` is given.

For each issue, in order, `close` writes:

1. **The comment:** the evidence file, word for word, headed `## Evidence: <title>` when it has no heading of its own; or `Closed by \`star github issue close\` on <date>, run by <login>, with Resolution <resolution>: <reason>`.
2. **The Resolution,** with `--resolution`: the Resolution field in NobleFactor, the `resolution:<name>` label in David-Noble-at-work.
3. **The issue,** closed as completed.
4. **Its rows:** a Schedule row is set Closed and kept, since a schedule keeps its closed steps; a Scenario row is removed, after a comment on the Scenario issue that the item closed, since a closed item leaves its scenario; a Triage or Backlog row is removed.

`close` doesn't close a parent. A feature or an epic closes with its own evidence, by `close` run on it. When an issue is its parent's last open child, its record names the parent.

It refuses, writing nothing: neither or both of `--evidence` and `--resolution`; `--resolution` without `--reason`, or with a name its account doesn't have; `--reason` with `--evidence`; an evidence file that is missing or empty; a Schedule or Scenario issue, which `star github schedule close` and `star github scenario close` close; and an item on a scenario whose option names no Scenario issue. An issue already closed is left as it is, and its record is `unchanged`.

Its records: one for each issue, `closed` with its Resolution and the parent whose last open child it was, or `unchanged`; and one for each row, `row-closed` or `left`. An item closed some other way, such as by a pull request's `Closes` line, has its Scenario row removed by a recurring check.

## Reopening an issue: reopen

```
star github issue reopen <issue>... --reason <text>
```

`reopen` reads each issue, its parents up to its epic, and the schedules it is a step of, before its first write. Then, for each issue:

1. **The issue** is reopened, its Resolution cleared or its `resolution:` labels removed, and a comment written: `Reopened by \`star github issue reopen\` on <date>, run by <login>: <reason>`.
2. **Its rows:** a Schedule row is set Open, its Worktree kept, since no one has taken it up again; a Backlog row is set Open. An issue with no row on its team's four projects, as `close` leaves an issue it took off Triage, the Backlog or a scenario, gets a Triage row, since the Triage workflow runs only when an issue is opened.
3. **Each closed parent,** its feature and then its epic, is reopened the same way, its comment naming the issue: `Reopened by … for <issue>: <reason>`. A parent with no row, as `close` leaves a feature or an epic it took off the Backlog, gets a Triage row, as the issue does.
4. **Each closed schedule** it is a step of is reopened as `star github schedule reopen` reopens one (section 8): the Schedule issue reopened with its comment, its own row set In progress, and its exit criterion that every step is closed unticked. A schedule is in progress while any of its steps is open.

An issue already open is not reopened again, and its rows are left as they are; its closed parents and closed schedules are still reopened. An issue with nothing closed about it is `unchanged`, and nothing is written. `reopen` refuses, writing nothing, a Schedule or Scenario issue, which `star github schedule reopen` and `star github scenario reopen` reopen, and a step on a schedule whose option names no Schedule issue.

Its records: one for each issue, parent and schedule reopened, with the Resolution it cleared, the issue it was reopened for, and a schedule's unticked criteria; one for each row, an issue's or a parent's, set Open or added to Triage; or `unchanged`.

## Significant design decisions

The choices this design rests on, each recorded with its reasons, alternatives and consequences in [the design decisions](10-the-issue-commands.decisions.md):

- [D-001](10-the-issue-commands.decisions.md#d-001) and [D-002](10-the-issue-commands.decisions.md#d-002): the verbs, `create` another name for `open`, and the issue verbs acting on epics, features, tasks and bugs.
- [D-003](10-the-issue-commands.decisions.md#d-003) and [D-004](10-the-issue-commands.decisions.md#d-004): where an issue can live, and an epic or a feature staying on the Backlog until it closes.
- [D-005](10-the-issue-commands.decisions.md#d-005) to [D-007](10-the-issue-commands.decisions.md#d-007): where `open` opens an issue, its row left to the Triage workflow, and its defaults.
- [D-008](10-the-issue-commands.decisions.md#d-008) to [D-010](10-the-issue-commands.decisions.md#d-010): how `close` closes work done and not done, in what order, and without its parent.
- [D-011](10-the-issue-commands.decisions.md#d-011): what `reopen` reopens with the issue.
- [D-012](10-the-issue-commands.decisions.md#d-012): every project's first view named Default, and the Backlog's views.

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| An issue's type | GitHub's issue type | the type's label |
| Area, Priority, Severity | issue fields | `area:`, `priority:` and `severity:` labels |
| Resolution | the Resolution field | the `resolution:<name>` label |
| The forms `open` checks | NobleFactor/.github, `.github/ISSUE_TEMPLATE/` | David-Noble-at-work/.github, the same path |
| The projects | the team's Triage, Backlog, Schedule and Scenario | the account's four |

## Building it

Each verb is a file in the GitHub extension's `commands` directory, `github-issue-<verb>.star`, and `create` is another name for `open`, a second manifest entry with `open`'s implementation. The code they share is in `issues.star`, an issue's Resolution, the scenario a row is under and an issue's parents, and in `steps.star`, which reads an issue and its rows and writes them, as `move` does. `ending.star` closes and reopens a schedule, for `star github schedule` and for `reopen`. Each comment is rendered from a template in the extension's `templates` directory.

The tests are `tests/Test-StarGitHub`, which runs each command against a stand-in for `gh` holding a small world of issues and projects. How the work reaches this design, and what of it is built, is in [the plan](../../plans/doc/589-issue-verbs.md).
