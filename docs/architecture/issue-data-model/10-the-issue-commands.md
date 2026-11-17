---
title: "10. The issue commands"
---

# 10. The issue commands

What `star github issue` does, verb by verb, for an organization and for a user account: opening an issue, moving it, closing it and reopening it. Sections 8 and 9 designed the commands for a schedule and a scenario, and `star github issue move`, which moves an issue between them (#511). This section designs the rest of the group (#589), as the owner ruled on 2026-11-17: the verbs are `open`, `move`, `close` and `reopen`, symmetric, open and closed being GitHub's own words for an issue's state, and `create` is `open`'s synonym, the same command, since people who use `gh` reach for it.

**Ruled 2026-11-17: the words are synchronized across the board.** A schedule and a scenario are opened, closed and reopened by their own groups' verbs: `star github schedule` and `star github scenario` each have `open`, with `create` its synonym, `close` and `reopen`, so `new` became `open` and `star github scenario retire` became `close` (#595). The `issue` verbs open, close and reopen every type but Schedule and Scenario, and refuse those, naming the group's verb; `move` refuses them too, since a collection's own issue is its own row, not a step.

Every verb follows the model sections 1 to 4 rule: an issue's type, its parent, its Area and its other fields, and its rows on its team's Triage, Backlog, Schedule and Scenario projects. Nothing here makes a project, a field or an option.

## The commands

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `open --type <type> --parent <issue> --area <area> --title <title> --body-file <path> [...]` | Opens an issue of any type but Schedule and Scenario, classified as it is made | Issue, fields or labels, parent link, row |
| `open --template <path> [--set <name>=<value>]...` | The same, from a template | The same |
| `create ...` | `open`, by its synonym | The same |
| `move <issue>... ( --schedule ... \| --scenario ... \| --triage \| --backlog ) --reason <text>` | Moves issues onto, within or off a schedule or a scenario (sections 8 and 9) | Rows, amendments, comments, bodies |
| `close <issue>... --evidence <path>` | Closes issues whose work is done, each with its evidence | Comment, issue, rows |
| `close <issue>... --resolution Declined\|Duplicate\|Invalid --reason <text>` | Closes issues whose work was not done, each with its Resolution | Comment, field or label, issue, rows |
| `reopen <issue>... --reason <text>` | Reopens issues, with their closed parents and the closed schedule each is a step of | Comments, issues, fields or labels, rows, a Schedule issue's body |

The collection groups' verbs, the same three:

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `schedule open <repository> <name> ...`, or `create` | Opens a schedule: `new` as section 8 gives it, renamed | Issue, option, row |
| `schedule close <schedule>` | Closes a finished schedule, as section 8 gives it | Row, comment, issue |
| `schedule reopen <schedule> --reason <text>` | Reopens a closed schedule: its issue, its own row In progress, its every-step criterion unticked | Issue, comment, row, body |
| `scenario open <repository> <name> ...`, or `create` | Opens a scenario: `new` as section 9 gives it, renamed | Issue, option, row |
| `scenario close <scenario> --reason <text>` | Closes a scenario the product no longer has: `retire` as section 9 gives it, renamed | Comment, issue, row |
| `scenario reopen <scenario> --reason <text>` | Reopens a closed scenario: its issue and its own row Open | Issue, comment, row |

An `<issue>` is written `<owner>/<repository>#<number>`. As in sections 8 and 9, every command names what it acts on, takes star's `--filter`, `--jq` and `--output`, returns one flat record per thing it read or changed, JSON by default, and exits non-zero only on an error. Every command reads all it needs before its first write, so a fault is a refusal with nothing written (#531), and every write is read back. A run that stops partway is run again to finish. `--dry-run` is refused until NobleFactor/devlore-cli#1170 lets a dry run read, as for every command of the extension.

## Opening an issue: open, and create

`open` is #338's command, renamed from `file` on 2026-11-17. Two ways to call it:

```
star github issue open --type <type> --parent <issue> --area <area> --title <title> --body-file <path>
    [--priority <priority>] [--severity <severity>] [--project <title>] [--status <status>] [--assignee <login>]
star github issue open --template <path> [--set <name>=<value>]...
```

A template is the issue's header and then its body:

```markdown
---
type: Task
parent: NobleFactor/devlore-cli#1019
title: "Update CI, {month}: the workflows' actions and the golangci-lint pin"
area: Engineering
project: "Backlog: devlore"
unique: true
---
### Problem
…
```

`open` does, in this order:

1. **Fills the blanks.** Each `{name}` in the header or body takes its `--set` value; a blank left unfilled is refused.
2. **Reads what it needs, all before it writes:** the repository, the account's model, the type, the parent and its type, the project and its Status option, and the Area, Priority and Severity options; and the type's issue form, from the account's `.github` repository as it stands when the command runs, so a change to the forms (#572) needs no change here.
3. **Refuses, writing nothing,** an issue without an Area; a type the account doesn't have; a Schedule or Scenario, naming `star github schedule open` or `star github scenario open`; a parent at the wrong level for the type (section 1); a body that lacks a section the type's form asks for, or its Plan and design documents table; a project that isn't one of the team's four; and a repository that takes no part in issue tracking.
4. **Skips a duplicate.** With `unique`, it looks through the parent's sub-issues, open and closed, for the same title; one found, it says so, opens nothing, and exits 0.
5. **Opens the issue** with its type, its fields, its assignee and its parent link. **Ruled 2026-11-17, as proposed:** Priority is Medium when it isn't given, as the issues split from features have been. Severity is N/A on every type but Bug.
6. **Gives it its row:** on `--project`, with `--status` or Open; with no project, the Triage workflow gives it its Triage row, as for an issue opened in GitHub. A Task or a Bug is placed on a schedule or a scenario by `move`, not by `open`.
7. **Reads it all back,** and fails, naming the value, when any differs from what was asked.

In David-Noble-at-work, which has no issue fields, `open` writes the labels that stand in for them: the type's label, `area:`, `priority:` and `severity:` (issue standards, § Labels).

`create` is `open`, declared as an alias once NobleFactor/devlore-cli#1235 lets an extension command name aliases, and until then a second manifest entry with the same implementation.

**Ruled 2026-11-17, as proposed:** retyping an issue is a verb of its own, `star github issue retype <issue> <type>`, designed and built after this section; and the skill that opens issues for an agent, the other half of #338's original body, is an issue of its own, after this section's pull request.

## Moving an issue: move

`move` is as built (#511): onto, within and off a schedule, as section 8 gives it, and onto and off a scenario, as section 9 gives it. It reads every source it leaves before its first write (#531); it doesn't yet check that a source schedule's issue has its Amendments section, which #594 adds.

## Closing an issue: close

```
star github issue close <issue>... --evidence <path>
star github issue close <issue>... --resolution Declined|Duplicate|Invalid --reason <text>
```

Exactly one of `--evidence` and `--resolution` is given. An issue whose work was done closes with its evidence; an issue whose work was not done closes as completed with its Resolution saying why, and GitHub's `not_planned` is not used (issue standards, § Resolution, ruled 2026-11-03).

`close` does, for each issue, in this order:

1. **The comment:** the evidence file, word for word, headed `## Evidence: <title>` when it has no heading of its own; or `Closed by \`star github issue close\` on <date>, run by <login>, with Resolution <resolution>: <reason>.`
2. **The Resolution,** with `--resolution`: the Resolution field in NobleFactor, the `resolution:<name>` label in David-Noble-at-work.
3. **The issue closed,** as completed.
4. **Its rows:** on a Schedule project, Status Closed, the row kept, as a merged step's is (section 8, question 5); on a Scenario project, a comment on the Scenario issue that the item closed, then the row removed, as a closed item leaves its scenario (section 9, question 7); on Triage, the row removed, triage's decision made; on Backlog, the row removed, since nothing is left to schedule.

`close` refuses, writing nothing: neither or both of `--evidence` and `--resolution`; `--resolution` without `--reason`, or with a name its account doesn't have; an evidence file that is missing or empty; and a Schedule or Scenario issue, naming `star github schedule close` or `star github scenario close`. An issue already closed is left as it is, its record `unchanged`.

**Ruled 2026-11-17, as proposed:** `close` doesn't close a parent when it closes the parent's last open child. A feature or an epic closes with its own evidence, by `close` run on it; when an issue `close` closes is its parent's last open child, its record says so, with the parent's key.

An item closed some other way, by a merge's `Closes` line among them, doesn't run `close`, so its Scenario row stays until #593's recurring check removes it.

## Reopening an issue: reopen

```
star github issue reopen <issue>... --reason <text>
```

`reopen` reads, before its first write, each issue, its sub-issue parents up to its epic, and the schedule each closed step was on. Then, for each issue:

1. **The issue reopened,** its Resolution cleared or its `resolution:` label removed, and a comment: `Reopened by \`star github issue reopen\` on <date>, run by <login>: <reason>.`
2. **Its rows:** a Schedule row set Open, since no one has taken it up again, its Worktree kept; a Backlog row set Open. An item that left its scenario when it closed goes to its team's Triage project, not back to the scenario, since it moved on when it closed.
3. **Each closed parent,** feature and then epic, reopened the same way, its comment naming the issue that reopened it.
4. **Each closed schedule** the issue is a step of reopened, as the owner had #346 reopened on 2026-11-17, by what `star github schedule reopen` does: the Schedule issue reopened with its comment, its own row In progress, and the exit criterion that says every step is closed unticked, found by its words. A schedule is in progress as long as one of its steps is open.

`reopen` refuses, writing nothing, a Schedule or Scenario issue, naming `star github schedule reopen` or `star github scenario reopen`. An issue already open, with open parents and an open schedule, is left as it is, its record `unchanged`.

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| An issue's type | GitHub's issue type | the type's label |
| Area, Priority, Severity | issue fields | `area:`, `priority:` and `severity:` labels |
| Resolution | the Resolution field | the `resolution:<name>` label |
| The forms `open` checks | NobleFactor/.github, `.github/ISSUE_TEMPLATE/` | David-Noble-at-work/.github, the same path |
| The projects | the team's: Triage, Backlog, Schedule and Scenario | the account's four |

## Building it

#338 (`open` and `create`), #590 (`close`) and #587 (`reopen`) are steps 2 to 4 of issue tracking, iteration 2 (#588), after this design, step 1, and #595, step 5, renames the collection groups' `new` and `retire` and adds their `reopen`; all are built with this design in one pull request. Their shared reads and writes go in `issues.star`, beside `steps.star`, which they share with `move`: an issue's rows, its parent chain, its Resolution, its comments; `schedule reopen`'s code is the one `issue reopen` runs for a step's closed schedule. #593 designs the recurring check for items closed some other way, and #594 adds `move`'s Amendments check.

**The design was approved by the owner on 2026-11-17,** and the synchronization of the collection groups' verbs ruled the same day.
