---
title: "The schedule and scenario commands, designed and then built in one pull request"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/507
status: approved
created: 2026-11-15
updated: 2026-11-15
documents:
  - kind: "Design: the scenario commands"
    path: "docs/architecture/issue-data-model/9-the-scenario-commands.md"
    text: "section 9"
  - kind: "Design: the schedule commands"
    path: "docs/architecture/issue-data-model/8-the-schedule-commands.md"
    text: "section 8"
  - kind: "Design: collections"
    path: "docs/architecture/issue-data-model/3-collections.md"
    text: "section 3"
---

# Plan: The schedule and scenario commands, designed and then built in one pull request

Steps 47 to 51 of issue tracking, iteration 1 (#346). #507 was step 50 until 2026-11-15, when #572, #338 and #504 moved
to #551. `star github` has no scenario commands, and of section 8's schedule commands only `report` and `add` are
built. This plan wrote the scenario commands' design, section 9, which the owner approved on 2026-11-15, and with it
made moving an issue one command, `star github issue move`, for schedules and scenarios alike. It now builds all of
it: `issue move`, `get` and `list`, `new`, and `close` and `retire`, for both kinds of collection and both kinds of
account.

One pull request from `doc/507-scenario-commands`, resolving #507, #509, #510, #511 and #512. Section 8's four build
tasks are widened to scenarios and are steps 48 to 51; nothing goes to Triage (ruled 2026-11-15).

## Issue 507

The design: section 9, with section 8 revised for `star github issue move`, approved on 2026-11-15.

## Issue 511

`star github issue move`, made from `star github schedule add` (#438), which it replaces: onto, within and off a
schedule, and onto, within and off a scenario. Step 48; the others wait on it, since its scenario cases change what is
recorded.

## Issue 510

`get` and `list`, of `star github schedule` and of `star github scenario`, one implementation over both. Step 49.

## Issue 509

`new`, of both groups, one implementation over the two kinds and their forms; and Start-Claude and Start-Claude.ps1
dropping `--schedule new`. Step 50.

## Issue 512

`star github schedule close` and `star github scenario retire`, which share how they close an issue and its row. Step
51.

## Rulings

- 2026-10-21: schedules and scenarios differ in intent and are otherwise the same. A scenario represents a use case; a
  schedule tracks engineering work.
- 2026-11-03: each team has one Scenario project, copied from its account's Scenario template. A single-select Scenario
  field names each row's scenario, one option per scenario, named for its Scenario issue, and a Beat number orders a
  scenario's rows. Each Scenario project has a By scenario view, its view 2.
- 2026-11-04: a scenario describes a feature, a workflow or a real-life situation that needs to be tested. Its Scenario
  issue summarizes an end-user goal and names the features it exercises. Its rows are the tasks and bugs found while
  walking it, each with the Beat at which it turned up. A found item names its scenario in its body, as "Found while
  walking #N", and the Triage workflow adds it to the scenario instead of to Triage. Each item later moves to its team's
  Triage project or onto a schedule, and leaves the scenario; its body and a comment on the Scenario issue record the
  move. An issue is on at most one scenario. A scenario never ends, so its Scenario issue never closes and states no
  evidence of completion.
- 2026-11-11, on #439: the schedule commands are designed first, in section 8, and the scenario commands after them,
  in a design of their own.
- 2026-11-14 (#453): each account's Scenario form asks what the person wants to do, how to walk through it, and the
  features it uses.
- 2026-11-15, on this plan: approved.
- 2026-11-15, on section 9: its eight questions, each recorded there; Beat N is step N of the walk; `add`, `move` and
  `remove`, of both groups, are one command, `star github issue move`, its issue the one positional argument and its
  destination a flag, `--backlog` kept and several issues at once, written into sections 8 and 9; the design approved.
- 2026-11-15: nothing goes to Triage. The build is on this schedule, in the next pull request, this one: section 8's
  four tasks, #509 to #512, widened to scenarios, are steps 48 to 51, and no new issue is filed.

## Current State

Read on 2026-11-15 from GitHub and from develop at `1565afc`:

| What | Where it stands |
| --- | --- |
| `star github schedule` | `report` (#379) and `add` (#438), in `commands/github-schedule-report.star` and `github-schedule-add.star`; the row, option and schedule helpers in `steps.star` |
| `star github scenario` | No commands |
| `star github issue` | No group yet; #338, `issue file`, makes one, in the session that works #551 |
| Making a schedule or a scenario | By hand. Start-Claude's `--schedule new` files a `Schedule:` issue with the retired `chore` label and makes no option and no row |
| Logging a found item | The Triage workflow (#448) puts an issue whose body says "Found while walking #N" on its scenario's project, under its option. It sets no Beat |
| Moving an item on | Onto a schedule: `schedule add` comments on the Scenario issue and deletes the row. To Triage: by hand |
| The scenarios | Six, and a placeholder in each account: NobleFactor/devlore-cli#599, #806, #891, #892 and #893 on Scenario: devlore; #152 and the placeholder #442 on Scenario: engprod; the placeholder David-Noble-at-work/personal#316. Four of devlore's are still titled "Thread:" |
| Their rows | 29 issues: 8 open and 21 closed, still rows. 15 have no Beat. #147 and #179 are rows of two scenarios each, which the ruling of 2026-11-04 forbids |
| The tests | `tests/Test-StarGitHub` runs the extension against a stand-in `gh`; cases 46 to 55 are `schedule add`'s |

## Requirements

1. **The design,** section 9, and section 8 revised, as approved on 2026-11-15.
2. **`star github issue move`,** as section 8, § Moving an issue, and section 9, § Moving an issue onto, within and
   off a scenario, give it: every case of their tables, each refusal, `--reason` written where the move is recorded,
   several issues in the order given, the rows read again before the first write, and a run that stops partway
   finished when run again. `star github schedule add` is retired in the same change: its file becomes `issue move`'s
   by `git mv`, its tests move with it, and each document that tells a reader to run it names `issue move` instead,
   while what was built on 2026-11-12 stays as history.
3. **`get` and `list`** of both groups, as sections 8 and 9, § Reading, give them.
4. **`new`** of both groups, as sections 8 and 9, § Making, give it, each reading its account's form from its `.github`
   repository; and Start-Claude and Start-Claude.ps1, with their man page and completions, refusing `--schedule new`
   with the command to run instead.
5. **`close` and `retire`,** as section 8, § Ending a schedule, and section 9, § Removing a scenario, give them; the
   evidence comment and each body a command writes rendered from templates in the extension's `templates` directory.
6. **Each command in `extension.yaml`,** with its help, and refusing star's `--dry-run`, as every command of the
   extension does until NobleFactor/devlore-cli#1170.
7. **Question 7's findings put right** on GitHub, by the merge script, each change read back.
8. **The issues' bodies** brought to the design: #507's, and #509 to #512's, each widened to scenarios with its new
   title.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `schedule add`'s cases 46 to 55, run as `issue move --schedule` | Pass as before |
| 2 | `issue move --schedule --after` an issue already on the schedule, closed steps among the others; `--after 0` | Moved, the steps between renumbered, one amendment |
| 3 | `issue move --triage` and `--backlog` of steps | Each in its project, `--backlog` keeping its Priority; later steps up one; one amendment |
| 4 | `issue move --scenario --beat` of an issue in Triage, and of one already on the scenario | A row with the Beat, its Triage row gone; the Beat set; the body line written once; a comment on the Scenario issue |
| 5 | `--scenario` with Beat 0, and with a Beat past the walk's last numbered step | Beat 0 taken; the other refused, nothing written |
| 6 | `--scenario` for a closed issue, an epic, another account's, one on another scenario, one on a Backlog or Schedule project | Each refused, nothing written |
| 7 | `issue move --triage` and `--schedule` of an item on a scenario; `--backlog` of one | The comment, the body line and the row moved; for a schedule, the step and amendment; `--backlog` refused |
| 8 | No destination, two destinations, no `--reason` | Refused, nothing written |
| 9 | `get` and `list` of a schedule and a scenario, in an organization and a user account; `list --team` in a user account | The rows and records the design names; `--team` refused |
| 10 | `new` of a schedule and of a scenario, each from its form; a name that is already an option; a missing section; a `--walk` that is not numbered; a run stopped partway, run again | Issue, option and row read back; each refused, nothing written; the run finished without a second issue |
| 11 | `close` with a step open, with an exit criterion unticked, and finished; the comment's template rendered from fixed data | Refused, refused; the comment written, the issue closed, its row Closed, the option kept |
| 12 | `retire` with an open item, and with none | Refused; the comment written, the issue closed as completed with no Resolution, its row Closed, the option kept |
| 13 | Start-Claude and Start-Claude.ps1 given `--schedule new` | Refused, naming `star github schedule new` |
| 14 | `tests/Test-StarGitHub` and `make check` | Pass |
| 15 | Each command run in NobleFactor-sandbox and David-Noble-at-work-sandbox, as section 6 § Where star github's proofs run has it | Each write read back from GitHub |
| 16 | Question 7's findings, after the merge script | Each read back as ruled |

## Implementation Phases

### Phase 1: the plan

- [x] Written and committed on `doc/507-scenario-commands` by the worktree's first script, which opens the branch with
      `git open-branch 507 -T doc`, pushes it, and sets step 47's row In progress with the branch in its Worktree
      column, read back; reviewed with the owner, and approved on 2026-11-15

### Phase 2: the design

- [x] Section 9 drafted, with its status page and its index entry, and named in this plan's `documents:`; #507's
      section written again from the plan; its questions ruled by the owner; `star github issue move` written into
      sections 8 and 9; approved on 2026-11-15

### Phase 3: the issues

- [x] #509 to #512 put on #346 as steps 48 to 51, after #507, by `star github schedule add` on 2026-11-15; #508, #265
      and #531 moved down to 52 to 54
- [ ] #507's body brought to the design, and #509 to #512 widened to scenarios with their new titles; each read back;
      their sections written from this plan by `star github plan link`

### Phase 4: the build

Built by one helper agent and reviewed before anything is committed, as #555 and #557 were. In this order, each with
its tests in `tests/Test-StarGitHub`, `make check` passing before each commit:

- [x] `star github issue move` (#511), from `schedule add`, on 2026-11-15: cases 46 to 55 converted and 86 to 100
      added, 315 test lines passing; `plan link`'s body readers moved to `commands/markdown.star`, which `issue move`
      shares, plan link's cases passing unchanged
- [ ] `get` and `list` of both groups (#510)
- [ ] `new` of both groups, and Start-Claude's `--schedule new` refused (#509)
- [ ] `close` and `retire` (#512)
- [x] The documents that name `schedule add` as a command to run brought to `issue move`, in the commit that retires
      it, as agent rule 12 has it, on 2026-11-15

### Phase 5: the proofs

- [ ] Each command run in NobleFactor-sandbox and David-Noble-at-work-sandbox, each write read back; the runs kept as
      each issue's evidence

### Phase 6: merge

- [ ] The pull request script written, shown and handed over. It puts question 7's findings right, each read back;
      merges, closing #507 and #509 to #512, each with its evidence comment; and sets steps 47 to 51 Closed by the
      template's schedule step

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/507-scenario-commands.md` | Create | This plan |
| `docs/architecture/issue-data-model/9-the-scenario-commands.md` and its status page | Create | The design |
| `docs/architecture/issue-data-model/8-the-schedule-commands.md` and its status page | Modify | `star github issue move`; the build on #346 |
| `docs/architecture/issue-data-model/index.md` | Modify | Sections 8 and 9 listed as they now read |
| The extension's `extension.yaml` | Modify | The commands, `schedule add` retired |
| The extension's `commands/github-schedule-add.star` | Move, by `git mv`, to `github-issue-move.star` | `issue move` |
| The extension's `commands/` | Create | `get`, `list`, `new`, `close` and `retire` of the two groups, and what they share |
| The extension's `templates/` | Create | The bodies `new` writes and the comments `close`, `retire` and `issue move` write |
| `tests/Test-StarGitHub` | Modify | The cases above |
| `Home/common.Unix/.local/bin/Start-Claude`, its man page and completions, and `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | `--schedule new` refused |
| `docs/guides/development-process.md`, `docs/issue-standards.md` and sections 1, 3, 4, 5 and 7 of the issue data model | Modify | `issue move` named where `schedule add` was named as a command to run |

## Related Documents

- [Section 3, Collections](../../architecture/issue-data-model/3-collections.md),
  [section 8, The schedule commands](../../architecture/issue-data-model/8-the-schedule-commands.md) and
  [section 9, The scenario commands](../../architecture/issue-data-model/9-the-scenario-commands.md)
- #448, the Triage workflow's scenario step; #438, `schedule add`; #338, `star github issue file`, whose group
  `issue move` joins

## Open Questions

None. #507's four were answered by the design. #512's, whether `close` archives a schedule's rows, stays as the design
leaves it: `close` archives nothing.
