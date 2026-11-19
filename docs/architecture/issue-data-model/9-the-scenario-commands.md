---
title: "9. The scenario commands"
---

# 9. The scenario commands

`star github scenario` reads, opens, closes and reopens scenarios, in an organization and in a user account. A scenario is a high-level description of a feature, a workflow or a real-life situation that needs to be tested, which someone walks, logging the tasks and bugs they find. It is three things (section 3): an option of its team's Scenario project's Scenario field, the Scenario issue that option names, and the rows under the option, the items found, each with the Beat at which it turned up. Putting an item on a scenario, setting its Beat and taking it off is `star github issue move` ([section 10](10-the-issue-commands.md#moving-an-issue-move)); this section says what such a move records on the scenario. Nothing here makes a project: a team's four projects are made with the team.

A scenario is like a schedule that starts with no tasks or bugs: they are found with time. It is kept, updated or removed as the product changes, since it has value before, during and after a release, so it is never closed as done. It is closed when the product no longer has it.

**Beat N is step N of the walk,** the Nth of the numbered steps the Scenario issue gives under How to walk through it. Beat 0 is an item found before the walk's first step. A beat is a place in the walk where any number of items may turn up, or none, and nothing is renumbered when an item leaves. "Step" is the word for a schedule's row and for the walk's instructions; Beat is the number a found item carries.

**The Triage workflow puts a found item on its scenario.** When a new issue's body says "Found while walking #N", or "Found while walking owner/repository#N", and #N is an open issue of the account with its own row on a project titled `Scenario: ...`, the workflow adds the issue to that project under #N's option, in place of a Triage row. It sets no Beat, and acts only when an issue is opened; `move --scenario` sets the Beat.

## The commands

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `list <account> [--team <team>]` | Every scenario of an account or a team, one record each | Nothing |
| `get <scenario>` | One scenario's rows in Beat order, its Scenario issue's own row first | Nothing |
| `open <repository> <name> ...`, or `create` | Opens a scenario: its Scenario issue, its option and its own row | Issue, option, row |
| `close <scenario> --reason <text>` | Closes a scenario the product no longer has | Row, comment, issue |
| `reopen <scenario> --reason <text>` | Reopens a closed scenario | Issue, comment, row |

A `<scenario>` is its Scenario issue's key, `<owner>/<repository>#<number>`. A `<beat>` is a whole number on the scenario's Beat field. As in section 8, every command names what it acts on, takes star's `--filter`, `--jq` and `--output`, returns one flat record per thing it read or changed, JSON by default, and exits non-zero only on an error. A command that writes reads everything it needs first, so a fault is a refusal with nothing written, reads each write back, and finishes, run again, what a run that stopped partway started. `--dry-run` is refused. `star github schedule report` returns each row's scenario and Beat.

## Reading: list and get

**`list <account> [--team <team>]`** returns one record for each option of the Scenario field of the account's Scenario projects, or the team's: the option's name, its Scenario issue's key, title, state and assignee, the project, and the count of open and closed rows. In David-Noble-at-work it reads Scenario: David-Noble-at-work, and refuses `--team`.

**`get <scenario>`** returns one record for each row under the scenario's option: the Beat, the issue's key, type, title and state, and the row's Status. The Scenario issue's own row comes first, with no Beat. Rows come in Beat order, then any row with no Beat.

## Opening a scenario: open, and create

```
star github scenario open <repository> <name> --area Product|Engineering --wants <text> --walk <text>
    --features <text> [--priority <priority>] [--assignee <login>]
```

`create` is the same command. `--wants`, `--walk` and `--features` fill the three sections of the account's Scenario form: what the person wants to do, how to walk through it, and the features it uses. `open` makes one scenario, in this order, reading each write back:

1. **The team.** The team with the maintain role on `<repository>` owns the scenario, and its project is `Scenario: <team>`. In a user account, the project is `Scenario: <account>`.
2. **The Scenario issue,** titled `Scenario: <name>`, in `<repository>`: in NobleFactor of type Scenario, with the Area and Priority issue fields; in David-Noble-at-work labeled `scenario`, `area:` and `priority:`. Priority is Medium unless given. It is assigned to `--assignee`, or to whoever runs the command, who then owns the scenario. Its body has the sections of the account's Scenario form, in the form's order, then a line of its own, above the documents section, which `star github plan link` replaces to the end of the body:

   ```
   ### What the person wants to do
   ### How to walk through it
   ### The features it uses
   The beats are the rows of [Scenario: <team>](<project>/views/2?filterQuery=scenario%3A%22<name>%22) under the
   Scenario option "<name>", in Beat order.
   ### Plan and design documents
   ```

   The line links the project's view 2, By scenario, filtered to the option.
3. **The option** `<name>`, added last to the project's Scenario field, its description the issue's key. Every existing option is sent back with its ID, so no row loses its value.
4. **The issue's own row,** with the option, Status Open and no Beat.

`open` refuses, writing nothing, when `<repository>` takes no part; the team has no Scenario project; the field already has an option named `<name>`; `--area` or a section of the form is missing; or `--walk` is not a numbered list, since Beat N is step N of the walk and each step needs its number. Run again after stopping partway, it makes only what is missing, as section 8's `open` does.

## What a move records on a scenario

`star github issue move` records each move onto, within or off a scenario in two places: a comment on the Scenario issue, which carries the move's `--reason`, and a line in the item's own body. Only a task or a bug goes on a scenario.

**Onto a scenario,** with `--scenario <scenario> --beat <beat>`, an item from Triage, the Backlog, a schedule, another scenario or no project gets a row under the scenario's option with the Beat and Status Open, and "Found while walking #N" in its body when it lacks it, above its Plan and design documents section. It leaves where it was as that place records a move: a schedule's amendment (section 8), another scenario's comment and body line, or its Triage or Backlog row removed. An item on another scenario of the same project, as a team's scenarios all are, keeps its one row, which takes the scenario's option and the Beat once both comments and both lines are written. An item already on the scenario has its Beat set. `--scenario` refuses, writing nothing, a closed issue, an issue of another account, and a Beat past the walk's last step when the Scenario issue numbers its walk, as every scenario `open` makes does.

**Off a scenario,** to Triage, the Backlog or a schedule, the command comments on the Scenario issue first, then writes the item's body line, then moves the row, so a run that stops partway leaves a second comment, not a move unrecorded. It refuses, writing nothing, an item on a scenario whose option names no Scenario issue. An item moved within its schedule leaves no scenario, so a scenario it is also a row of is not read. For NobleFactor/devlore-cli#844, an item of writ origin, NobleFactor/devlore-cli#806, moved to Triage:

```
- Comment on #806: NobleFactor/devlore-cli#844 left this scenario on 2026-11-15 for Triage: devlore, by
  `star github issue move`, run by David-Noble-at-work: <reason>
- Line in #844's body: Left #806 on 2026-11-15 for Triage: devlore.
```

Moved onto a schedule, the body line names the schedule and the step: `Left #806 on <date> for <schedule> (<its Schedule issue>), as its step <step>.` The body line names the scenario as "Found while walking" does: `#N` in its own repository, `owner/repository#N` in another.

An item that closes leaves its scenario: `star github issue close` comments on the Scenario issue that the item closed, then removes its row (section 10).

## Closing a scenario: close

`close <scenario> --reason <text>` closes a scenario the product no longer has. It refuses while any open item is a row of the scenario: each moves on first. Then it sets the scenario's own row Closed, comments on the Scenario issue with the reason, and closes the issue as completed, with no Resolution: nothing was left undone, since the scenario served until the product changed, and none of Declined, Duplicate and Invalid applies.

The option stays, as a closed schedule's does: it records which scenario each past row belonged to.

## Reopening a scenario: reopen

`reopen <scenario> --reason <text>` reopens a closed scenario, when the product has it again: it reopens the Scenario issue, comments with the reason, `Reopened by \`star github scenario reopen\` on <date>, run by <login>: <reason>`, and sets the scenario's own row Open. The option was never removed, so the scenario's past rows are under it still. An open scenario is `unchanged`.

## Significant design decisions

The choices this design rests on, each recorded with its reasons, alternatives and consequences in [the design decisions](9-the-scenario-commands.decisions.md):

- [D-001](9-the-scenario-commands.decisions.md#d-001): scenarios with a command group of their own.
- [D-002](9-the-scenario-commands.decisions.md#d-002): Beat N as step N of the walk.
- [D-003](9-the-scenario-commands.decisions.md#d-003) and [D-004](9-the-scenario-commands.decisions.md#d-004): a move recorded in two places, and a closed item leaving its scenario.
- [D-005](9-the-scenario-commands.decisions.md#d-005): a scenario closed as completed, with no Resolution.

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| The Scenario issue's kind | type Scenario | label `scenario` |
| Area and Priority | issue fields | `area:` and `priority:` labels |
| The scenario's team | the team with the maintain role on the repository | none: the account |
| The Scenario project | `Scenario: <team>`, projects 27 (engprod) and 30 (devlore) | `Scenario: David-Noble-at-work`, project 8 |
| The form `open` follows | NobleFactor/.github, `.github/ISSUE_TEMPLATE/scenario.yml` | David-Noble-at-work/.github, the same path |
| `list --team` | narrows to one team | refused |
| `close` | closed as completed, with no Resolution | closed as completed, with no `resolution:` label |

Each Scenario project has the views Default and By scenario, view 2, and the fields Status (Open, In progress, Closed), Beat (a number) and Scenario.

## Building it

Each verb is a file in the GitHub extension's `commands` directory, `github-scenario-<verb>.star`, and `create` is another name for `open`, a second manifest entry with `open`'s implementation. Each shares its code with the schedule verb of the same name (section 8, § Building it). The comments and the Scenario issue's body are templates in the extension's `templates` directory, and the tests are `tests/Test-StarGitHub`. How the work reached this design, and what of it is built, is in the plans of [#507](../../plans/doc/507-scenario-commands.md) and [#589](../../plans/doc/589-issue-verbs.md).
