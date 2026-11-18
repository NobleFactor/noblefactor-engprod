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
| `open --type <type> --parent <issue> --area <area> --title <title> --body-file <path> [...]` | Opens an issue of any type but Schedule and Scenario, classified as it is made, in the repository of the clone it runs in | Issue, fields or labels, parent link |
| `open --template <path> [--set <name>=<value>]...` | The same, from a template | The same |
| `create ...` | `open`, by its synonym | The same |
| `move <issue>... ( --schedule ... \| --scenario ... \| --triage \| --backlog ) --reason <text>` | Moves issues to Triage, the Backlog, a schedule or a scenario, from wherever each is (sections 8 and 9; #597) | Rows, amendments, comments, bodies |
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
    [--priority <priority>] [--severity <severity>] [--assignee <login>] [--directory <path>]
star github issue open --template <path> [--set <name>=<value>]... [--directory <path>]
```

**Ruled 2026-11-17: the issue opens in the repository of the clone `open` runs in,** its origin's, as `star github plan link` reads its own, and `--directory <path>` names another clone, as git's `-C` does. `-C` itself waits on star letting an extension flag take a short name beside its long one (NobleFactor/devlore-cli#1236).

A template is the issue's header and then its body. Its header takes what the flags give, `type`, `parent`, `title`, `area`, `priority`, `severity` and `assignee`, and `unique`; with `--template`, no flag but `--set` and `--directory` is given:

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

`open` does, in this order:

1. **Fills the blanks.** Each `{name}` in the header or body takes its `--set` value; a blank left unfilled is refused.
2. **Reads what it needs, all before it writes:** the clone and its repository, the account's model, the type, the parent and its type, and the Area, Priority and Severity options; and the type's issue form, from the account's `.github` repository as it stands when the command runs, so a change to the forms (#572) needs no change here.
3. **Refuses, writing nothing,** an issue without an Area; a type the account doesn't have; a Schedule or Scenario, naming `star github schedule open` or `star github scenario open`; a parent at the wrong level for the type (section 1); a body that lacks a section the type's form asks for, or its Plan and design documents table; a `--severity` on any type but Bug, every other type's being N/A; a directory that is no clone, or whose origin isn't on GitHub; and a repository that takes no part in issue tracking.
4. **Skips a duplicate.** With `unique`, it looks through the parent's sub-issues, open and closed, for the same title; one found, it says so, opens nothing, and exits 0.
5. **Opens the issue** with its type, its fields, its assignee and its parent link, in one call. **Ruled 2026-11-17, as proposed:** Priority is Medium when it isn't given, as the issues split from features have been. Severity is N/A on every type but Bug, and a Bug's is Medium unless `--severity` names another, as the Triage workflow starts a bug (section 2). **Ruled 2026-11-17:** no one is assigned unless `--assignee` names someone, so a workflow that opens an issue doesn't assign it to its bot.
6. **Leaves its row to the Triage workflow.** **Ruled 2026-11-17:** `open` takes no `--project` or `--status`. The workflow gives every issue opened its Triage row, as for an issue opened in GitHub, and an issue is a row of at most one of its account's projects (section 1), so a row `open` made on another project would leave the issue on two. `move --schedule` and `move --scenario` take it from Triage; `move --backlog` takes an issue off a schedule, and doesn't yet take one from Triage.
7. **Reads it all back,** and fails, naming the value, when any differs from what was asked.

In David-Noble-at-work, which has no issue fields, `open` writes the labels that stand in for them: the type's label, `area:`, `priority:` and `severity:` (issue standards, § Labels).

Its record is the issue it opened, or found with `unique`: its key, its title, its type, its parent, its Area, Priority and Severity, and whether it was `opened` or `found`.

`create` is `open`, declared as an alias once NobleFactor/devlore-cli#1235 lets an extension command name aliases, and until then a second manifest entry with the same implementation.

**Ruled 2026-11-17, as proposed:** retyping an issue is a verb of its own, `star github issue retype <issue> <type>`, designed and built after this section; and the skill that opens issues for an agent, the other half of #338's original body, is an issue of its own, after this section's pull request.

## Moving an issue: move

`move` is as built (#511): onto, within and off a schedule, as section 8 gives it, and onto and off a scenario, as section 9 gives it. It reads every source it leaves before its first write (#531); it doesn't yet check that a source schedule's issue has its Amendments section, which #594 adds.

**Ruled 2026-11-17: `move` puts an issue where it needs to be, from wherever it is (#597).** As built, `--triage` and `--backlog` took an issue only off a schedule or a scenario, `--scenario` refused one on the Backlog, a schedule or another scenario, `--backlog` refused one on a scenario, and every destination refused an epic or a feature; the owner ruled those barriers broken. What an issue's type allows is all that limits a move:

| Type | Triage | Backlog | A schedule | A scenario |
| --- | --- | --- | --- | --- |
| Epic, Feature | Yes | Yes | No | No |
| Task, Bug | Yes | Yes | Yes | Yes |
| No type | Yes | No | No | No |
| Schedule, Scenario | No | No | No | No |

An issue with no type waits in Triage until it is classified, or on the scenario whose walk found it (section 1). A Schedule or Scenario issue is its collection's own record, its row made by `schedule open` or `scenario open`, and `move` refuses it, naming the group. An issue leaves wherever it was as sections 8 and 9 record a move: a schedule's amendment, every later step moving up; a comment on the Scenario issue and a line in the item's body; a Triage or Backlog row removed. An issue already where it is sent is `unchanged`.

### Epics and features

**Ruled 2026-11-17, in place of the ruling of 2026-11-04 that an epic or a feature, once classified, leaves Triage for no project (section 1):** an epic or a feature goes to Triage when it is opened, like every new issue, and to the Backlog once it is classified, by `move --backlog`. It stays there until it closes, when `close` removes its row. Nothing moves it when its tasks and bugs are pulled onto a schedule or a scenario. Its state is its children's: it is in progress when any issue under it is in progress, and it can close when all of them are closed, which `close` reports when it closes the last; `star github schedule report --by feature` and `--by epic` show where each stands. The Backlog project shows its epics and features in a view of their own, beside the view of its tasks and bugs, as Jira and Azure Boards keep the two levels apart. `star github triage sweep` returns an epic or a feature that is a row of a Schedule or Scenario project, and no longer one on the Backlog (#597).

**The evidence, read 2026-11-17.** The owner asked how other issue trackers treat an epic or a feature as its work is pulled into a sprint. None moves it: only its children move, and its state changes.

| Tracker | Where epics and features live | What goes into a sprint | How their state changes |
| --- | --- | --- | --- |
| Azure Boards | Portfolio backlogs, Features and Epics, apart from the product backlog of stories and bugs | Stories and bugs; features and epics "might take one or more sprints" | Shown on their backlog while Proposed, In Progress or Resolved, and hidden once Completed; rollup columns show the children's progress |
| Jira | An epics panel beside the backlog | Stories, bugs and tasks | Set by hand, or by an automation rule that moves the epic to In Progress when a child moves |
| Shortcut | Its epics list | Stories; its iteration automations handle stories alone | Auto Start Epic when a story starts, and Auto Complete Epic when every story is done |
| Linear | Parent issues | Issues | Optionally, the parent is marked done when every sub-issue is |

Moving an epic or a feature off the Backlog when its first task or bug is pulled, as first proposed, would record its state by moving its row, and every move of a child would have to check its parents both ways, since a child can go back to the Backlog; none of these trackers does that. The simplest thing, which they all do, is to leave it where it is and derive its state.

Sources: [Azure Boards: Use backlogs to manage projects](https://learn.microsoft.com/en-us/azure/devops/boards/backlogs/backlogs-overview), [Azure Boards: Define features and epics](https://learn.microsoft.com/en-us/azure/devops/boards/backlogs/define-features-epics), [Shortcut: Automations](https://www.shortcut.com/help/fields-and-features/automations), [Linear: Parent and sub-issues](https://linear.app/docs/parent-and-sub-issues), and [Atlassian Community: Automation for moving epics to In Progress when any child story is moved](https://community.atlassian.com/t5/Jira-questions/Automation-for-Moving-Epics-to-In-Progress-when-any-of-the-child/qaq-p/2490530).

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
2. **Its rows:** a Schedule row set Open, since no one has taken it up again, its Worktree kept; a Backlog row set Open. An item that left its scenario when it closed goes to its team's Triage project, not back to the scenario, since it moved on when it closed. **Ruled 2026-11-17:** so does every task or bug that has no row on its team's Triage, Backlog, Schedule or Scenario project, as `close` leaves one it took off Triage or Backlog, since the Triage workflow runs when an issue is opened, not when it is reopened. So does an issue with no type and no row, since an untriaged issue waits in Triage (section 1). So does an epic or a feature with no row, since an open one is a row of Triage or the Backlog (§ Epics and features, ruled 2026-11-17).
3. **Each closed parent,** feature and then epic, reopened the same way, its comment naming the issue that reopened it.
4. **Each closed schedule** the issue is a step of reopened, as the owner had #346 reopened on 2026-11-17, by what `star github schedule reopen` does: the Schedule issue reopened with its comment, its own row In progress, and the exit criterion that says every step is closed unticked, found by its words: a ticked box whose text begins "Every step" or "Every other step", as the schedules' boxes have said so far; a schedule with none is reopened all the same, and its record says no criterion was unticked. A schedule is in progress as long as one of its steps is open.

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

#338 (`open` and `create`), #590 (`close`) and #587 (`reopen`) are steps 2 to 4 of issue tracking, iteration 2 (#588), after this design, step 1, and #595, step 5, renames the collection groups' `new` and `retire` and adds their `reopen`; all are built with this design in one pull request. Their shared reads and writes go in `issues.star`, beside `steps.star`, which they share with `move`: an issue's rows, its parent chain, its Resolution, its comments; `schedule reopen`'s code is the one `issue reopen` runs for a step's closed schedule. #593 designs the recurring check for items closed some other way, and #594 adds `move`'s Amendments check. #597, step 6, fixes `move`, narrows the sweep's rule on epics and features, and gives each Backlog its view of them, in the same pull request.

**The design was approved by the owner on 2026-11-17,** and the synchronization of the collection groups' verbs ruled the same day.
