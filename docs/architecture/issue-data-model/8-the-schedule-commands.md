---
title: "8. The schedule commands"
---

# 8. The schedule commands

What `star github schedule` does, verb by verb, for an organization and for a user account. Ruled 2026-11-02: making a
schedule moves from Start-Claude into `star github schedule`, and its commands are designed before any is built
(#439). This section is that design. Each command follows the model as sections 3 and 7 rule it: one Schedule project
per team, a Schedule field with one option per schedule, and a Schedule issue for each option. Nothing here makes a
project; a team's four projects are made with the team. Scenarios get commands of their own, in a design that follows
this one (#507, ruled 2026-11-11).

Its eight questions were ruled by the owner on 2026-11-11 and 2026-11-12, and each is marked with its ruling's date.

## The commands

**Ruled 2026-11-11, question 1:** eight verbs. `report` is built; `add` is #438; the other six are new.

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `report [<repository>...] [--search <query>]` | Every issue as one flat record, as built in #379 | Nothing |
| `list <account> [--team <team>]` | Every schedule of an account or a team, one record each | Nothing |
| `get <schedule>` | One schedule's rows in step order, its Schedule issue's own row first | Nothing |
| `new <repository> <name>` | Makes a schedule: its Schedule issue, its option and its own row | Issue, option, row |
| `add <schedule> <issue>... [--after <step>]` | Puts issues on a schedule as its next steps, or after a step | Rows, links, amendment |
| `move <schedule> <step> --after <step>` | Moves an open step, renumbering the steps between | Rows, amendment |
| `remove <schedule> <step> --to backlog\|triage` | Takes an open step off, and closes the gap | Rows, amendment |
| `close <schedule>` | Closes a finished schedule, with its evidence comment | Issue, row, comment |

A `<schedule>` and an `<issue>` are written `<owner>/<repository>#<number>`, the form a session's
`NFEP_AGENT_SCHEDULE` holds. A `<step>` is a number on the schedule's Step field. Every command names what it acts on;
none has a default account or schedule, as the model commands have none (section 6, ruled 2026-11-09).

Every command takes star's common flags. `--filter` and `--jq` narrow the result, `--output` renders it, and a command
binds none of the three (devlore-cli's `docs/architecture/10-command-line-interface.md`, §4 and §8). Each returns one
flat record per thing it read or changed, JSON by default, and exits non-zero only on an error.

## The syntax of 2026-11-04

On 2026-11-04 the owner gave an example of a command to be able to run:

```
star github schedule --group-by Schedule --account NobleFactor --team engprod --where '{ Schedule: { _eq: 346 } }' --output csv
```

**Ruled 2026-11-11, question 2:** the example becomes `get`, and the read commands take no `--group-by`, `--where`,
`--account` or `--team`. `--filter`, `--jq` and `--output` do that work, the same way on every command, this one
among them.

```
star github schedule get NobleFactor/noblefactor-engprod#346 --output csv
```

- `star github schedule` is a group, and a group takes no action of its own (devlore-cli §3). The verb says what is
  read.
- `--where` would be a third way to select, beside `--filter` and `--jq`, which own the filter stage (devlore-cli §8).
  Selecting one schedule is what `get`'s argument does.
- `--group-by` reshapes, and reshaping is `--jq`'s work: `--jq 'group_by(.schedule)'`. `get` returns one schedule, so
  it has nothing to group.
- The account is a positional argument on every model command (section 6, ruled 2026-11-09). A schedule's key names
  its account already. `list` takes the account as its argument and `--team` to narrow it, since a user account has no
  teams.
- `--output csv` is as the owner wrote it.

The rows of every schedule of a team, grouped, are `list`'s keys handed to `get`, or the report:
`star github schedule report --jq '[.[] | select(.home[]?.project == "Schedule: engprod")]'`.

## Reading: list, get and report

**`list <account> [--team <team>]`** returns one record for each option of the Schedule field of the account's
Schedule projects, or the team's: the option's name, its Schedule issue's key, title, state and assignee, the project,
and the count of open and closed steps. In David-Noble-at-work it reads Schedule: David-Noble-at-work, and `--team` is
refused, since a user account has no teams.

**`get <schedule>`** returns one record for each row under the schedule's option: the step, the issue's key, type,
title and state, the row's Status, Worktree and Iteration, and the keys of the issues that block it. The Schedule
issue's own row comes first, with no step. Rows come in step order, then any row with no step, which is an error the
sweep returns to Triage (#436).

**`report`** stays as built (#379): every issue of the repositories named as one flat record, whose `home` names its
schedule and step.

**Rule 2 of agent-rules.md,** what lists the open ruling issues under NobleFactor/devlore-cli#463 now that the `Epic:`
labels are gone, is answered by the report as built. Run on 2026-11-11, it returned the 17 open issues GitHub lists
under #463, in 26 seconds:

```
star github schedule report NobleFactor/devlore-cli --search is:open --filter parent=NobleFactor/devlore-cli#463 --output table
```

GitHub's issue search has no qualifier for a parent, so `--search` narrows to open issues and `--filter` to #463's.

## Making a schedule: new

**Ruled 2026-11-11, question 3:** the syntax and the steps below, each write read back. The owner weighed the
read-backs most: GitHub promises no stability for the features the model is built on, so a command checks that
GitHub holds what it wrote.

```
star github schedule new <repository> <name> --area Product|Engineering --deliverable <text> --exit-criteria <text>
    --evidence <text> [--priority <priority>] [--assignee <login>]
```

`new` makes one schedule, in this order, reading each write back:

1. **The team.** The team with the maintain role on `<repository>` owns the schedule (`team_of` in the extension's
   `scheme.star`), and its project is `Schedule: <team>`. In a user account, the project is `Schedule: <account>`.
2. **The Schedule issue,** titled `Schedule: <name>`, as all 15 Schedule issues are (read 2026-11-11), filed in
   `<repository>`: in NobleFactor of type Schedule, with the Area and Priority issue fields; in David-Noble-at-work
   labeled `schedule`, `area:` and `priority:`. It is assigned to `--assignee`, or to the user running the command, who
   then owns the schedule (section 3, § Ownership). Its body has the sections of the account's Schedule form, in its
   `.github` repository, in the form's order, then two of its own:

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

   The Steps line links the project's view 2, filtered to the option, as section 3 rules for every Schedule issue.
3. **The option** `<name>`, added last to the project's Schedule field. Its description is the issue's key, as each
   option's is today, and its color GRAY, as theirs is. Every existing option is sent back with its ID, so no row loses
   its value; `star github model apply` adds an option the same way.
4. **The issue's own row,** with the option, Status Open and no step, placed after the last row that has an option
   (section 3: rows are kept in the field's order).

`new` refuses, writing nothing, when:

- `<repository>` takes no part: no team maintains it, or, in a user account, it lacks the topic issue-model;
- the team has no Schedule project;
- the field already has an option named `<name>`;
- `--area` or a section of the form is missing.

**A run that stops partway is run again to finish.** `new` looks first for an open Schedule issue titled
`Schedule: <name>` in `<repository>`, then for the option, then for the row, and makes only what is missing. #487 is
the bug this avoids: a second `apply` after a half-made template made a second project.

## Changing a schedule: add, move and remove

Every change to a schedule's steps is one act. The rows, the blocked-by links and the amendment in the Schedule issue
are written together, so the schedule and its record can't disagree (#438). Before writing, a command reads the
schedule's rows; it reads them again just before its first write, and stops, writing nothing, if they changed. GitHub
has no transaction, so a write that fails partway is reported with what was written, and the same command run again
finishes it.

**Ruled 2026-11-11, question 4: the amendment.** `add`, `move` and `remove` each write one line at the end of the
Schedule issue's Amendments section, on every schedule, committed or not, since nothing in GitHub marks a schedule
committed. Each takes a required `--reason`, and the line names the date, who ran the command and why; the command
can't know whose word it acted on, only who ran it:

```
- 2026-11-11, by David-Noble-at-work: step 43 was added, Task NobleFactor/noblefactor-engprod#507, the design of the
  scenario commands. <reason>
```

### add

`add <schedule> <issue>... [--after <step>] [--blocked-by <issue>[,<issue>...]] [--assignee <login>] --reason <text>`
puts each issue on the schedule, in the order given. Built on 2026-11-12 (#438) and proved that day in
NobleFactor-sandbox ([section 6](6-the-asset-and-its-sync.md#where-star-githubs-proofs-run)); a user account's
half on 2026-11-13, in David-Noble-at-work-sandbox. `--blocked-by` takes a comma-separated list, since no star flag
repeats.

- Without `--after`, each takes the next step. With `--after <step>`, they take the steps after that one, and every
  later step moves down, the steps staying consecutive whole numbers (ruled 2026-11-11, #438).
- Each row gets the schedule's option, Status Open and its step, and is placed in step order.
- `--blocked-by` adds blocked-by links; links the issue already has are kept.
- The issue leaves the project it was on, in one act (ruled 2026-11-04): its Triage or Backlog row is removed; a
  scenario's row is removed, and a comment on the Scenario issue records the move; and a row on another schedule is
  taken off as `remove` does, with an amendment there too.
- An issue from another team's repository is assigned to `--assignee`, a member of the schedule's team, which `add`
  then requires (ruled 2026-11-04).

`add` refuses, writing nothing, an issue that is closed, already on this schedule, of a type other than Task or Bug,
or of another account; a `--blocked-by` issue of another account; and a `--after` step the schedule doesn't have.
Iteration is left for sprint planning to set.

**How a run that stops is finished, as built.** `add` writes its amendment line first, ending "(in progress)", and
settles it last, dropping the marker. The line is the change's record as it was planned, so a run that stops partway
leaves one a reader sees is unfinished, and the same command run again finishes it, keeping the steps the first run
moved among it. Any other issue already on the schedule is refused: most steps went onto their schedules by hand,
before `add`, and no amendment names them, so an issue on the schedule with no amendment is not a sign of a run that
stopped. The later rows move from the highest down, which keeps their order should a run stop between them.

### move

`move <schedule> <step> --after <step> --reason <text>` moves an open step to just after another, and renumbers the
steps between, so they stay consecutive. `--after 0` makes it the first open step.

### remove

`remove <schedule> <step> --to backlog|triage --reason <text>` takes an open step off the schedule. Its issue goes to
its team's Backlog, keeping its Priority, or to its Triage project, and every later step moves up one.

**Ruled 2026-11-11, question 5: closed steps.** `add --after`, `move` and `remove` renumber every later step, closed or
open, so the steps stay consecutive whole numbers, as #438's ruling of 2026-11-11 has it. Section 3 said a closed step
keeps its number, but closed steps already sit among open ones: on issue tracking, iteration 1, steps 29 (#440) and 35
(#447) are closed, between open steps (read 2026-11-11), and both moved down four when #482 to #485 went in after step
22 that day. A rule that no closed step moves would refuse almost every `--after`. So closed steps move with the open
ones, and section 3 says so.

## Ending a schedule: close

**Ruled 2026-11-12, question 6:** `close <schedule>` refuses while a step is open or an exit criterion's box is
unticked. Then it writes the evidence comment every Schedule issue asks for, closes the Schedule issue as completed and
sets its row Closed.

The comment shows what merged and when. Asked what a completed schedule should show, the owner chose the pull requests
over the steps: one row for each merged pull request, with the date it merged and the steps it closed, in the order
they merged. Every step appears once. A step whose issue no merged pull request closed is listed after, with how it
closed. Built on 2026-11-12 from what GitHub then held for issue tracking, iteration 1 (#346), the comment begins:

> **Evidence of completion**, written by `star github schedule close` on 2026-11-20, run by David-Noble-at-work. All 43
> steps of issue tracking, iteration 1 are closed, and its 3 exit criteria are ticked.
>
> **What merged**
>
> | Merged | Pull request | Steps it closed |
> | --- | --- | --- |
> | 2026-10-23 | #386, every open noblefactor-engprod issue typed from its kind label | 3, Task #380 |
> | 2026-11-09 | #467, each account's model, every issue as a record | 15, Task #376; 16, Task #379; 17, Task #436; 18, Bug #466 |
> | 2026-11-09 | NobleFactor/devlore-cli#1216, every empty list in a command's result is [] | 14, Bug NobleFactor/devlore-cli#1215 |
> | 2026-11-12 | #488, git close-branch deletes only what is verified merged | 23, Bug #482; 24, Bug #483; 25, Bug #484; 26, Bug #485 |
>
> **Closed with no pull request**
>
> | Step | How it closed |
> | --- | --- |
> | 8, Task #361 | Declined, 2026-11-04 |
> | 11, Task #303 | Completed, 2026-11-05 |
> | 29, Bug #440 | Duplicate, 2026-11-09 |

Of #346's 28 closed steps that day, 19 fell under 13 pull requests and 9 had none.

- **A step's pull request** is the merged one GitHub records as closing its issue (`closedByPullRequestsReferences`),
  else the merged one whose commit closed it. No other link counts: a pull request that only mentions an issue may not
  be its work. #503 changed a skill and named #379, whose work merged in #467.
- **How a step closed** is its Resolution where it has one, else GitHub's reason. GitHub records #361 to #363, which
  were declined, and #440, a duplicate, as completed; their Resolution says what happened.
- **The comment's wording is a template** in the extension, a Go text template rendered with star's `template`
  module; the command gathers the data, and a test renders the template from fixed data. The devlore Actions extension
  keeps its templates the same way, in its `templates` directory.

Five of #346's steps were finished by merged work but closed by hand, so they show no pull request: #303, whose work
spread over seven, #358, #359, #360 and #446. A pull request whose description says `Closes #N` is linked by GitHub,
and #508 asks the PR script template for that line.

**Ruled 2026-11-11: the option stays.** It is the record of which schedule each closed step belonged to, and that
record is kept. A step is not a sub-issue of its Schedule issue, so its row's Schedule field is the only link between
them, and deleting an option blanks every row that held it. The cost is a cap: GitHub allows at most 50 options in a
project's single-select field (GitHub's documentation, About single select fields, read 2026-11-11), and a team's
Schedule field grows by one option per schedule. Schedule: engprod has 4 (read 2026-11-11). How the record is kept
once a field nears 50 is decided then.

## Start-Claude

Start-Claude's `--schedule new` files `Schedule: <title>` with the `chore` label, retired on 2026-11-03, and a lane
table, retired the same day; it makes no option and no row. Since the ruling of 2026-11-02 moves making a schedule into
star, **ruled 2026-11-12, question 7:** Start-Claude and Start-Claude.ps1 drop `new` when `star github schedule new`
is built, in the same pull request, and refuse it with the command to run instead. Their
`--schedule <owner>/<repository>#<number>` is unchanged.

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| The Schedule issue's kind | type Schedule | label `schedule` |
| Area and Priority | issue fields | `area:` and `priority:` labels |
| The schedule's team | the team with the maintain role on the repository | none: the account |
| The Schedule project | `Schedule: <team>`, projects 26 (engprod) and 29 (devlore) | `Schedule: David-Noble-at-work`, project 7 |
| The form `new` follows | NobleFactor/.github, `.github/ISSUE_TEMPLATE/schedule.yml` | David-Noble-at-work/.github, the same path |
| `list --team` | narrows to one team | refused |

The two forms differ only in how they set the kind: `type: Schedule` in NobleFactor's, the label `schedule` in
David-Noble-at-work's (read 2026-11-11).

## Building it

`add` is #438, step 28 of issue tracking, iteration 1. **Ruled 2026-11-12, question 8:** the other verbs are four
tasks under feature #332, filed that day in Backlog: engprod with Priority Medium, since #346's exit criteria don't
need them:

| Task | Builds | Blocked by |
| --- | --- | --- |
| #509 | `new`, and Start-Claude's `--schedule new` dropped | #439 |
| #510 | `get` and `list` | #439 |
| #511 | `move` and `remove`, which share `add`'s code | #438 |
| #512 | `close` and its evidence comment | #439 |
