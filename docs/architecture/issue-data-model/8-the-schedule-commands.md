---
title: "8. The schedule commands"
---

# 8. The schedule commands

`star github schedule` reads, opens, closes and reopens schedules, in an organization and in a user account. A schedule is three things (section 3): an option of its team's Schedule project's Schedule field, the Schedule issue that option names, and the rows under the option, its steps, numbered in the order they are worked. Putting an issue on a schedule, moving it within one and taking it off is `star github issue move` ([section 10](10-the-issue-commands.md#moving-an-issue-move)); this section says what such a move records on the schedule. Nothing here makes a project: a team's four projects are made with the team. Scenarios have their own commands, in [section 9](9-the-scenario-commands.md).

## The commands

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `report [<repository>...] [--search <query>]` | Every issue as one flat record | Nothing |
| `list <account> [--team <team>]` | Every schedule of an account or a team, one record each | Nothing |
| `get <schedule>` | One schedule's rows in step order, its Schedule issue's own row first | Nothing |
| `open <repository> <name> ...`, or `create` | Opens a schedule: its Schedule issue, its option and its own row | Issue, option, row |
| `close <schedule>` | Closes a finished schedule, with its evidence comment | Row, comment, issue |
| `reopen <schedule> --reason <text>` | Reopens a closed schedule | Issue, comment, row, body |

A `<schedule>` is its Schedule issue's key, `<owner>/<repository>#<number>`, the form a session's `NFEP_AGENT_SCHEDULE` holds. Every command names what it acts on, and none has a default account or schedule.

Every command takes star's `--filter`, `--jq` and `--output`, which select, reshape and render its result, so none has flags of its own for that. Each returns one flat record per thing it read or changed, JSON by default, and exits non-zero only on an error. A command that writes reads everything it needs first, so a fault is a refusal with nothing written, and reads each write back, since GitHub promises no stability for the features the model is built on. A run that stops partway is run again to finish. `--dry-run` is refused until NobleFactor/devlore-cli#1170 lets a dry run read.

For example, one schedule's rows as CSV, and the rows of all of a team's schedules:

```
star github schedule get NobleFactor/noblefactor-engprod#346 --output csv
star github schedule report --jq '[.[] | select(.home[]?.project == "Schedule: engprod")]'
```

## Reading: list, get and report

**`list <account> [--team <team>]`** returns one record for each option of the Schedule field of the account's Schedule projects, or the team's: the option's name, its Schedule issue's key, title, state and assignee, the project, and the count of open and closed steps. In David-Noble-at-work it reads Schedule: David-Noble-at-work, and refuses `--team`, since a user account has no teams.

**`get <schedule>`** returns one record for each row under the schedule's option: the step, the issue's key, type, title and state, the row's Status, Worktree and Iteration, and the keys of the issues that block it. The Schedule issue's own row comes first, with no step. Rows come in step order, then any row with no step, which is an error the sweep returns to Triage.

**`report`** returns every issue of the repositories named as one flat record, whose `home` names its schedule and step. GitHub's issue search has no qualifier for a parent, so `--search` narrows to open issues and `--filter` to a parent's children:

```
star github schedule report NobleFactor/devlore-cli --search is:open --filter parent=NobleFactor/devlore-cli#463 --output table
```

## Opening a schedule: open, and create

```
star github schedule open <repository> <name> --area Product|Engineering --deliverable <text> --exit-criteria <text>
    --evidence <text> [--priority <priority>] [--assignee <login>]
```

`create` is the same command. `open` makes one schedule, in this order, reading each write back:

1. **The team.** The team with the maintain role on `<repository>` owns the schedule, and its project is `Schedule: <team>`. In a user account, the project is `Schedule: <account>`.
2. **The Schedule issue,** titled `Schedule: <name>`, in `<repository>`: in NobleFactor of type Schedule, with the Area and Priority issue fields; in David-Noble-at-work labeled `schedule`, `area:` and `priority:`. Priority is Medium unless given. It is assigned to `--assignee`, or to whoever runs the command, who then owns the schedule. Its body has the sections of the account's Schedule form, in the form's order, then two of its own:

   ```
   ## Deliverable
   ## Exit criteria
   ## Evidence of completion
   ## Plan and design documents
   ## Steps
   The steps are the rows of [Schedule: <team>](<project>/views/2?filterQuery=schedule%3A%22<name>%22) under the
   Schedule option "<name>", worked in step order.
   ## Amendments
   ```

   The Steps line links the project's view 2, filtered to the option.
3. **The option** `<name>`, added last to the project's Schedule field, its description the issue's key and its color GRAY. Every existing option is sent back with its ID, so no row loses its value.
4. **The issue's own row,** with the option, Status Open and no step, placed after the last row that has an option, since a project's rows are kept in its field's order.

`open` refuses, writing nothing, when `<repository>` takes no part (no team maintains it, or, in a user account, it lacks the topic `issue-model`); the team has no Schedule project; the field already has an option named `<name>`; or `--area` or a section of the form is missing. Run again after stopping partway, it finds the open Schedule issue titled `Schedule: <name>`, then the option, then the row, and makes only what is missing.

## What a move records on a schedule

`star github issue move` changes a schedule's steps in one act: the rows, the blocked-by links, and one line at the end of the Schedule issue's Amendments section, which names the date, who ran the command, what changed and the `--reason`:

```
- 2026-11-11, by David-Noble-at-work: step 43 was added, Task NobleFactor/noblefactor-engprod#507, the design of the
  scenario commands. <reason>
```

Every schedule's changes are recorded this way, since nothing in GitHub marks a schedule committed. The command records who ran it, not on whose word, which it can't know.

**The steps stay consecutive whole numbers.** Onto a schedule, an issue takes the next step, or, with `--after <step>`, the step after that one, every later step moving down; `--after 0` makes it the first. Within a schedule, `--after` moves a step to just after another, and the steps between are renumbered. Off a schedule, every later step moves up one. Closed steps are renumbered with open ones, since closed steps sit among open ones and a rule that kept their numbers would refuse almost every `--after`.

**Onto a schedule,** each row gets the schedule's option, Status Open and its step, and is placed in step order. `--blocked-by` adds blocked-by links, keeping those the issue has; it takes a comma-separated list until star's extension flags can repeat (#315). An issue from another team's repository is assigned to `--assignee`, a member of the schedule's team, which the move then requires. Iteration is left for sprint planning. A move onto a schedule refuses, writing nothing, an issue already on it unless `--after` moves it within it; a `--blocked-by` issue of another account; and an `--after` step the schedule doesn't have.

**A run that stops partway.** The amendment line is written first, ending "(in progress)", and settled last, without the marker. A run that stops partway leaves a line a reader sees is unfinished, and the same command run again finds it and finishes the move. The later rows move from the highest down, which keeps their order if a run stops between them.

## Closing a schedule: close

`close <schedule>` refuses while any step is open or any exit criterion's box is unticked. The exit criteria are the boxes of the Schedule issue's Exit criteria section, or of its Evidence of completion section when it has none. Then it sets the schedule's own row Closed, writes the evidence comment every Schedule issue asks for, and closes the Schedule issue as completed, in that order, so a run that stops partway leaves the issue open.

The comment shows what merged and when: one row for each merged pull request, with the date it merged and the steps it closed, in the order they merged, then each step no merged pull request closed, with how it closed. Every step appears once. For example:

> **Evidence of completion**, written by `star github schedule close` on 2026-11-20, run by David-Noble-at-work. All 43 steps of issue tracking, iteration 1 are closed, and its 3 exit criteria are ticked.
>
> **What merged**
>
> | Merged | Pull request | Steps it closed |
> | --- | --- | --- |
> | 2026-10-23 | #386, every open noblefactor-engprod issue typed from its kind label | 3, Task #380 |
> | 2026-11-09 | #467, each account's model, every issue as a record | 15, Task #376; 16, Task #379; 17, Task #436; 18, Bug #466 |
>
> **Closed with no pull request**
>
> | Step | How it closed |
> | --- | --- |
> | 8, Task #361 | Declined, 2026-11-04 |
> | 29, Bug #440 | Duplicate, 2026-11-09 |

- **A step's pull request** is the merged one GitHub records as closing its issue, else the merged one whose commit closed it. A pull request that only mentions an issue doesn't count, since it may not be the issue's work.
- **How a step closed** is its Resolution where it has one, else GitHub's reason.
- **The wording** is a template in the extension's `templates` directory, rendered with star's `template` module.

The option stays. It records which schedule each closed step belonged to: a step is not a sub-issue of its Schedule issue, so its row's Schedule field is the only link between them, and deleting an option blanks every row that held it. GitHub allows at most 50 options in a single-select field, and a team's Schedule field grows by one option per schedule, so how the record is kept once a field nears 50 is decided then.

## Reopening a schedule: reopen

A schedule is in progress while any of its steps is open, so a schedule closed before a step was reopened, or before one was added, is reopened. `reopen <schedule> --reason <text>`, in order:

1. Reopens the Schedule issue, with a comment: `Reopened by \`star github schedule reopen\` on <date>, run by <login>: <reason>`.
2. Sets its own row In progress.
3. Unticks its exit criterion that every step is closed: each ticked box of its Exit criteria section whose text begins "Every step" or "Every other step", as the schedules' boxes say. A schedule with no such box is reopened all the same, and its record says no criterion was unticked.

The option was never removed, so the schedule's past rows are under it still. An open schedule is `unchanged`. `star github issue reopen` reopens each closed schedule a reopened issue is a step of the same way, its comment naming the issue (section 10).

## Start-Claude

Start-Claude and Start-Claude.ps1 start a session on a schedule with `--schedule <owner>/<repository>#<number>`. They make no schedule: asked for one, they refuse and name `star github schedule open`.

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| The Schedule issue's kind | type Schedule | label `schedule` |
| Area and Priority | issue fields | `area:` and `priority:` labels |
| The schedule's team | the team with the maintain role on the repository | none: the account |
| The Schedule project | `Schedule: <team>`, projects 26 (engprod) and 29 (devlore) | `Schedule: David-Noble-at-work`, project 7 |
| The form `open` follows | NobleFactor/.github, `.github/ISSUE_TEMPLATE/schedule.yml` | David-Noble-at-work/.github, the same path |
| `list --team` | narrows to one team | refused |

The two forms differ only in how they set the kind: `type: Schedule` in NobleFactor's, the label `schedule` in David-Noble-at-work's.

## Linking plans: plan link

`star github plan link` writes each issue's Plan and design documents section from the plans that serve it, so that an issue traces back to its plans.

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `plan link <plan>... [--check]` | Writes the section of each issue the plans named serve, from every plan that serves it, each plan a path relative to `docs/plans` in the clone it runs in | The issues' bodies |
| `plan link --all [--repository <owner/name>,...] [--check]` | The same for every issue a plan under `docs/plans` on each repository's default branch serves, writ's layers when none is named | The issues' bodies |

The plans are the authority. A plan names the issues it serves, the one in its `issue:` line and each other in an `## Issue NNN` heading, and the design documents it bears on, in its frontmatter's `documents:`. An issue's section is written from them: a Plan row for each plan that serves it, then each plan's documents. The command finds the section by its heading, `Plan and design documents` at level 2 or 3, and replaces it whole; with no such heading it adds the section, and with two it writes nothing. An issue no plan serves is not touched. `--check` writes nothing, and returns the records the command would.

Each record is an issue: the plans that serve it, what was done (`written`, `unchanged`, `appended` or `refused`), the section before and after, and the rows the new section drops. It exits non-zero only on an error, a plan or an issue it can't read or a write that doesn't read back; under `--all` it does every other issue first, then fails naming each error. A link points by the issue's state: an open issue's to the default branch, and one closed by a merged pull request to that pull request's merge commit. `--repository` takes a comma-separated list until star's extension flags can repeat (#315). Its plan, [557-plan-row.md](../../plans/feature/557-plan-row.md), says what it does in each case.

## Building it

Each verb is a file in the GitHub extension's `commands` directory, `github-schedule-<verb>.star`, and `create` is a second manifest entry with `open`'s implementation until NobleFactor/devlore-cli#1235 lets an extension command name an alias. Each shares its code with the scenario verb of the same name (section 9): `making.star` opens a schedule or a scenario, `collections.star` reads them, and `ending.star` closes and reopens them; `steps.star` reads and writes rows and amendments for them and for `star github issue move`. The comments and the Schedule issue's body are templates in the extension's `templates` directory, and the tests are `tests/Test-StarGitHub`. [The status page](8-the-schedule-commands.status.md) records what is built and every ruling.
