---
title: "9. The scenario commands"
---

# 9. The scenario commands

What `star github scenario` does, verb by verb, for an organization and for a user account, and what moving an issue
onto, within and off a scenario writes. Section 8 designed the schedule commands and left the scenario commands to a
design of their own (#507, ruled 2026-11-11). This section is that design. Each command follows the model as sections
3 and 7 rule it: one Scenario project per team, a Scenario field with one option per scenario, a Scenario issue for
each option, and a Beat number that orders a scenario's rows. Nothing here makes a project; a team's four projects are
made with the team.

A scenario is like a schedule that starts with no tasks or bugs (section 3, § The Schedule and Scenario fields).
Someone walks it and logs what they find, each item a row under the scenario's option with the Beat at which it turned
up, and each item later moves on, to its team's Triage project or onto a schedule. A scenario never ends, so nothing
here closes one as done.

**Ruled 2026-11-15: Beat N is step N of the walk,** the Nth of the numbered steps the Scenario issue gives under How
to walk through it. The field keeps its name. A schedule's step is a row, one issue, numbered consecutively and
worked in order; a beat is a place in the walk, where any number of items may turn up, or none, and nothing is
renumbered when an item leaves. "Step" stays the word for a schedule's row and for the walk's instructions, and
Beat the number a found item carries.

Its eight questions were ruled by the owner on 2026-11-15, each marked with its ruling. Question 2 was revised the same
day, when moving an issue became one command, `star github issue move`, for schedules and scenarios alike.

## What two pieces already do

Two pieces built since the rulings of 2026-11-04 already do part of a scenario's work, and the commands are designed
around them, not over them:

- **The Triage workflow (#448)** reads a new issue's body. When it says "Found while walking #N", or
  "Found while walking owner/repository#N", and #N is an open issue of the account with its own row on a project titled
  `Scenario: ...`, the workflow adds the new issue to that project under #N's option, in place of a Triage row. It sets
  no Beat, and it acts only when an issue is opened.
- **`star github schedule add` (#438)** takes an issue off its scenario when it puts the issue on a schedule: it
  comments on the Scenario issue that the item left, for which schedule and step, then deletes the row. It writes
  nothing in the item's own body. It becomes `star github issue move --schedule` (section 8, § Moving an issue).

## The commands

**Ruled 2026-11-15, question 1:** the scenario commands are a group of their own, `star github scenario`, beside
`star github schedule`. Section 8 already said scenarios get commands of their own. A scenario has beats, not steps;
its changes are recorded as comments, not amendments; and it never closes as finished.

**Ruled 2026-11-15, question 2, as revised the same day:** the group's own verbs are the four that act on a scenario
itself, and an issue moves onto, within and off a scenario by `star github issue move`, the one command that moves an
issue wherever it goes (section 8, § Moving an issue). The owner asked for one command when `add`, `move` and `remove`
were seen to be one act done three ways, and for its destination to be a flag, so a reader can tell which key names
the collection and which the issue. `report` is `star github schedule report` as built, which returns each row's
scenario and Beat.

| Command | Does | Writes to GitHub |
| --- | --- | --- |
| `list <account> [--team <team>]` | Every scenario of an account or a team, one record each | Nothing |
| `get <scenario>` | One scenario's rows in Beat order, its Scenario issue's own row first | Nothing |
| `new <repository> <name>` | Makes a scenario: its Scenario issue, its option and its own row | Issue, option, row |
| `retire <scenario> --reason <text>` | Takes away a scenario the product no longer has | Issue, row, comment |
| `star github issue move <issue>... --scenario <scenario> --beat <beat> --reason <text>` | Puts found items on a scenario at a Beat, or sets the Beat of one already on it | Rows, bodies, comment |
| `star github issue move <issue>... --triage --reason <text>`, from a scenario | Moves items on to their team's Triage project | Rows, bodies, comment |

A `<scenario>` and an `<issue>` are written `<owner>/<repository>#<number>`. A `<beat>` is a step of the walk, a whole
number on the scenario's Beat field. As in section 8, every command names what it acts on, takes star's `--filter`,
`--jq` and `--output`, returns one flat record per thing it read or changed, JSON by default, and exits non-zero only
on an error. Every write is read back, and a run that stops partway is run again to finish (section 8, § Making a
schedule).

## Reading: list and get

**`list <account> [--team <team>]`** returns one record for each option of the Scenario field of the account's
Scenario projects, or the team's: the option's name, its Scenario issue's key, title, state and assignee, the project,
and the count of open and closed rows. In David-Noble-at-work it reads Scenario: David-Noble-at-work, and `--team` is
refused, as section 8's `list` refuses it.

**`get <scenario>`** returns one record for each row under the scenario's option: the Beat, the issue's key, type,
title and state, and the row's Status. The Scenario issue's own row comes first, with no Beat. Rows come in Beat order,
then any row with no Beat.

## Making a scenario: new

**Ruled 2026-11-15, question 3:** the syntax and the steps below, each write read back, as section 8's `new` is.

```
star github scenario new <repository> <name> --area Product|Engineering --wants <text> --walk <text>
    --features <text> [--priority <priority>] [--assignee <login>]
```

`--wants`, `--walk` and `--features` are the three sections of the account's Scenario form since #453: what the person
wants to do, how to walk through it, and the features it uses. `new` makes one scenario, in this order:

1. **The team.** The team with the maintain role on `<repository>` owns the scenario, and its project is
   `Scenario: <team>`. In a user account, the project is `Scenario: <account>`.
2. **The Scenario issue,** titled `Scenario: <name>`, as #152 and the two placeholders are, filed in `<repository>`: in
   NobleFactor of type Scenario, with the Area and Priority issue fields; in David-Noble-at-work labeled `scenario`,
   `area:` and `priority:`. It is assigned to `--assignee`, or to the user running the command, who then owns the
   scenario. Its body has the sections of the account's Scenario form, in the form's order, headed as GitHub heads a
   form's sections, then a line of its own:

   ```
   ### What the person wants to do
   ### How to walk through it
   ### The features it uses
   ### Plan and design documents
   The beats are the rows of [Scenario: <team>](<project>/views/2?filterQuery=scenario%3A%22<name>%22) under the
   Scenario option "<name>", in Beat order.
   ```

   The line links the project's view 2, By scenario, filtered to the option, as section 3 rules for every Scenario
   issue. It goes above the documents section, since `star github plan link` replaces that section to the end of the
   body.
3. **The option** `<name>`, added last to the project's Scenario field, its description the issue's key, as every
   Scenario option's is (read 2026-11-15). Every existing option is sent back with its ID, so no row loses its value.
4. **The issue's own row,** with the option, Status Open and no Beat.

`new` refuses, writing nothing, when `<repository>` takes no part, the team has no Scenario project, the field already
has an option named `<name>`, `--area` or a section of the form is missing, or `--walk` is not a numbered list: Beat
N is step N of the walk, so each step needs its number.

`new` and section 8's `new` differ in the kind, the form, the flags and the line; the rest is one piece of code (§
Building it).

## Moving an issue onto, within and off a scenario: issue move

**Ruled 2026-11-15, questions 4 and 5, as revised the same day:** what was proposed as `add` and `remove` is
`star github issue move` with `--scenario` or with a destination off the scenario, and each move is recorded in both
places the ruling of 2026-11-04 names, the Scenario issue and the item's body. The `--reason` every move requires goes
in the comment on the Scenario issue.

| Where it is | `issue move` with | What it writes |
| --- | --- | --- |
| On no project, or in Triage | `--scenario <scenario> --beat <beat>` | A row under the scenario's option with the Beat and Status Open, its Triage row removed; "Found while walking #N" in its body, when it lacks it; a comment on the Scenario issue |
| On this scenario | `--scenario <scenario> --beat <beat>` | Its Beat set; the body line, when it lacks it; a comment on the Scenario issue |
| On a scenario | `--triage` | A comment on the Scenario issue, a line in its body, the scenario row deleted and its Triage row added |
| On a scenario | `--schedule <schedule>` | The same, with the schedule's row, step and amendment as section 8 gives them |
| On the Backlog | `--scenario <scenario> --beat <beat>` | The same as from Triage, its Backlog row removed (#597, ruled 2026-11-17) |
| On a schedule | `--scenario <scenario> --beat <beat>` | The same, and the schedule's amendment, every later step moving up, as section 8 gives a step taken off (#597) |
| On another scenario | `--scenario <scenario> --beat <beat>` | The other scenario's comment and body line, as for `--triage`, then this one's row, Beat, body line and comment (#597) |
| On a scenario | `--backlog` | A comment on the Scenario issue, a line in its body, the scenario row deleted and its Backlog row added (#597; refused until 2026-11-17, an item found on a walk being classified in Triage first) |

**Onto a scenario.** The Triage workflow puts a new item on its scenario but sets no Beat, and acts only when an issue
is opened; `--scenario` sets the Beat, and takes an issue that is already open. An item the walker filed with "Found
while walking #N", which the workflow placed, gets its Beat this way. Beat 0 is an item found before the walk's first
step, as #806's beat 0, its "hard gate", is. The body line goes above the item's Plan and design documents section,
where `star github plan link` leaves it, so the item names its scenario whichever way it got there.

`--scenario` refuses, writing nothing, an issue that is closed, of a type other than Task or Bug, of another account,
on another scenario, or on a Backlog or Schedule project, which means it has already moved on; and a Beat past the
walk's last step, when the Scenario issue numbers its walk, as every scenario `new` makes does. An issue is on at most
one scenario (ruled 2026-11-04), so taking an item from one scenario to another is two moves, `--triage` and then
`--scenario`. Filing the item is not `issue move`'s: the walker files it from the form, or with
`star github issue file` (#338), with "Found while walking #N" in its body.

**Off a scenario.** The command comments on the Scenario issue first, then writes the item's body line, then moves the
row, so a run that stops partway leaves a second comment, not a move unrecorded, as `schedule add` orders its writes.
For NobleFactor/devlore-cli#844, a row of writ origin, NobleFactor/devlore-cli#806, moved to Triage:

```
- Comment on #806: NobleFactor/devlore-cli#844 left this scenario on 2026-11-15 for Triage: devlore, by
  `star github issue move`, run by David-Noble-at-work: <reason>
- Line in #844's body: Left #806 on 2026-11-15 for Triage: devlore.
```

Moved onto a schedule, the body line names the schedule and the step:
`Left #806 on <date> for <schedule> (<its Schedule issue>), as its step <step>.` The body line names the scenario as
"Found while walking" does: `#N` in its own repository, `owner/repository#N` in another.

## Removing a scenario: retire

**Ruled 2026-11-15, question 6:** removing a scenario gets a command, `retire`, and it closes the Scenario issue as
completed with no Resolution. A scenario is kept, updated or removed as the product changes (ruled 2026-11-04); its
issue never closes as finished, but a scenario the product no longer has is removed, and something has to say so.

`retire <scenario> --reason <text>` refuses while any open item is a row of the scenario: each moves on first. Then it
comments on the Scenario issue with the reason, closes the issue as completed, and sets its own row Closed. The option
stays, as section 8 keeps a closed schedule's: it records which scenario each past row belonged to.

No Resolution says it, since nothing was left undone: the scenario served until the product changed, and its comment
says so. An issue whose work was not done is closed as completed with its Resolution saying why (ruled 2026-11-03), and
NobleFactor's Resolution field offers Declined, Duplicate and Invalid, none of which applies.

## What the scenarios hold today

**Ruled 2026-11-15, question 7:** each finding below is put right once, by this design's pull request script, each
change read back. Read from GitHub on 2026-11-15:

| Finding | What the scenarios hold | Ruled |
| --- | --- | --- |
| Closed rows | 21 of the 29 issues that are rows of a scenario are closed, and still rows | A closed item leaves its scenario: each row removed, one comment on each Scenario issue naming the items, as #303's closing script did for 15 that had moved on |
| Two scenarios | #147 and #179 are rows of two scenarios each, which the ruling of 2026-11-04 forbids. Both are closed | Settled by the row above |
| No Beat | 15 rows have no Beat; 5 of them are open: NobleFactor/devlore-cli#468, #469, #471, #473 and #1033 | The scenario's owner gives each its Beat with `issue move --scenario --beat` once it is built; nothing guesses one |
| Old titles | NobleFactor/devlore-cli#806, #891, #892 and #893 are titled `Thread: ...`; #599 has no prefix | Each retitled `Scenario: <its option's name>` |
| No beats line | #599's body has no line linking view 2 | The line added, as `new` writes it |
| Old bodies | The six scenarios' bodies predate #453's form: five are narratives in beats, and #599 a source spec and its provider mapping; #891, #892 and #893 state an evidence of completion | Left to each scenario's owner, rewritten to the form's three sections when it is next walked |

The two placeholders, NobleFactor/noblefactor-engprod#442 and David-Noble-at-work/personal#316, stay as they are: they
exist to give the Scenario fields their first option (section 3).

## How each command runs in each account

| | NobleFactor | David-Noble-at-work |
| --- | --- | --- |
| The Scenario issue's kind | type Scenario | label `scenario` |
| Area and Priority | issue fields | `area:` and `priority:` labels |
| The scenario's team | the team with the maintain role on the repository | none: the account |
| The Scenario project | `Scenario: <team>`, projects 27 (engprod) and 30 (devlore) | `Scenario: David-Noble-at-work`, project 8 |
| The form `new` follows | NobleFactor/.github, `.github/ISSUE_TEMPLATE/scenario.yml` | David-Noble-at-work/.github, the same path |
| `list --team` | narrows to one team | refused |
| `retire` | closed as completed, with no Resolution | closed as completed, with no `resolution:` label |

Read from GitHub on 2026-11-15: each Scenario project has the views Default, or View 1, and By scenario, view 2, and
the fields Status (Open, In progress, Closed), Beat (a number) and Scenario.

## Building it

**Ruled 2026-11-15, question 8, as revised the same day:** no tasks of their own. Each scenario verb shares its code
with a schedule verb, so section 8's four tasks are widened to scenarios, and the owner put them on issue tracking,
iteration 1 (#346) as steps 48 to 51, after this design, built together in its pull request; nothing goes to Triage:

| Step | Task | Builds, for schedules and scenarios |
| --- | --- | --- |
| 48 | #511 | `star github issue move`, from `schedule add`: onto, within and off a schedule or a scenario |
| 49 | #510 | `get` and `list`, one implementation over Schedule and Scenario projects |
| 50 | #509 | `new`, one implementation over the two kinds and their forms |
| 51 | #512 | `close` and `retire`, which close an issue and set its row Closed the same way |

#511 comes first: it changes what is recorded, and the findings of question 7 with no Beat wait on it.

**The design was approved by the owner on 2026-11-15.**
