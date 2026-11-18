---
title: "The star github issue verbs, open, move, close and reopen, designed and built in one pull request"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/589
status: active
created: 2026-11-17
updated: 2026-11-17
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/8-the-schedule-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/9-the-scenario-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/1-hierarchy.md
---

# The star github issue verbs, open, move, close and reopen, designed and built in one pull request

[Up: Plans](../../index.md)

## 1. Role assignments

Owner David Noble. Participant: Claude Code, in the session working [issue tracking, iteration 2 (#588)](https://github.com/NobleFactor/noblefactor-engprod/issues/588), steps 1 to 6. Reviewer: the owner. Observers: none.

## 2. Summary and promised result

`star github issue` has four verbs, ruled by the owner on 2026-11-17: `open`, with `create` its synonym, `move`, `close` and `reopen`. Section 10 of the issue data model designs them, as sections 8 and 9 design the schedule and scenario commands; `open`, `close` and `reopen` are built and proved in both sandboxes in this pull request, and `move`, as built (#511, #531), is fixed to put an issue where it needs to be, from wherever it is (#597). Out of scope: the filing skill, retyping, and the app's permission to write issue fields (§ 11).

## Issue 589

[NobleFactor/noblefactor-engprod#589](https://github.com/NobleFactor/noblefactor-engprod/issues/589), Task, Area Engineering, under Feature #332: the design.

## Issue 338

[NobleFactor/noblefactor-engprod#338](https://github.com/NobleFactor/noblefactor-engprod/issues/338), Task, Area Product: `star github issue open`, its design so far in its body.

## Issue 590

[NobleFactor/noblefactor-engprod#590](https://github.com/NobleFactor/noblefactor-engprod/issues/590), Task, Area Product: `star github issue close`.

## Issue 587

[NobleFactor/noblefactor-engprod#587](https://github.com/NobleFactor/noblefactor-engprod/issues/587), Task, Area Product: `star github issue reopen`.

## Issue 595

[NobleFactor/noblefactor-engprod#595](https://github.com/NobleFactor/noblefactor-engprod/issues/595), Task, Area Product: the collection groups take the same verbs, `new` renamed `open`, with `create`, `scenario retire` renamed `close`, and `schedule reopen` and `scenario reopen` added; the `issue` verbs refuse Schedule and Scenario issues. Ruled by the owner on 2026-11-17, and put in this pull request.

## Issue 597

[NobleFactor/noblefactor-engprod#597](https://github.com/NobleFactor/noblefactor-engprod/issues/597), Bug, Area Product: `star github issue move` refuses to put an issue where it needs to be. Ruled by the owner on 2026-11-17, and put in this pull request: an epic, a feature, a task or a bug goes to Triage or the Backlog, and a task or a bug to a schedule or a scenario, from wherever it is; an epic or a feature goes from Triage to the Backlog once classified and stays there until it closes; the sweep's rule on epics and features narrows to Schedule and Scenario projects; and each Backlog gets a view of its epics and features.

## 3. Current state

- `star github issue move` is built (#511) and reads every source before its first write (#531). No other `issue` verb exists; issues are opened, closed and reopened by hand or by a script written for one issue, as on 2026-11-17 for #508, #470 and #346.
- The issue standards say issues we file ourselves go through `star github issue` once it is built (#338), which opens an issue classified as it is made.
- The extension's commands share `steps.star` (rows, amendments, comments), `collections.star` and `making.star` (`new`'s form-section rendering), each write read back.
- star has no aliases for an extension's commands; NobleFactor/devlore-cli#1235 adds them.

## 4. Design impact

A new section 10 of the issue data model, `10-the-issue-commands.md`, and its status page; the index's table of sections gains its row. This plan's `documents:` names section 10 in the commit that writes it, since `star github plan link` refuses a document that doesn't exist yet. Section 8's and section 9's mentions of `issue move` point to section 10. The issue standards' sentence that issues we file go through `star github issue` once it is built names `open`.

## 5. Proposed implementation

**Section 10**, verb by verb, as section 9 is written: each verb's syntax, refusals, writes in order and read-backs, and its records, in both accounts.

- `open`: as #338's body gives it, from a template or from flags, as ruled on 2026-11-17 (§ 12): in the repository of the clone it runs in, `--directory` naming another; no `--project` or `--status`; no assignee unless one is given; each section its type's form asks for, read from the account's `.github` repository when it runs, so #572's changes to the forms need no change here; refused without an Area; `--dry-run` refused until NobleFactor/devlore-cli#1170, as the other commands do.
- `create`: the same command, declared as an alias once NobleFactor/devlore-cli#1235 lands, and until then a second manifest entry with the same implementation.
- `move`: as built, fixed by #597 (§ 12, departures 6 and 7): from wherever an issue is, an epic, a feature, a task or a bug to Triage or the Backlog, a task or a bug to a schedule or a scenario, a Schedule or Scenario issue nowhere, each source left as sections 8 and 9 record a move; `star github triage sweep`'s `epic-on-collection` rule narrowed to Schedule and Scenario projects; `reopen` gives a reopened epic or feature with no row a Triage row; each Backlog project, and the Backlog template, a view of its epics and features.
- `close <issue>... ( --evidence <file> | --resolution Declined|Duplicate|Invalid --reason <text> )`: the comment, the Resolution or `resolution:` label, the issue closed as completed, its rows Closed; a closed step stays on its schedule, as merged ones do (section 8, question 5), and an item on a scenario leaves it, its row removed and its leaving recorded, as section 9 rules a closed item does (question 7). An item closed some other way, by a merge's `Closes` line among them, is #593's recurring check.
- `reopen <issue>... --reason <text>`: the issue reopened, its Resolution cleared, its rows Open; each closed parent and each closed schedule or scenario it is on reopened, a schedule's own row In progress and its every-step criterion unticked; an item that left its scenario on closing goes to its team's Triage project, not back to the scenario.

**Code**: `github-issue-open.star`, `github-issue-close.star`, `github-issue-reopen.star`, beside `github-issue-move.star`, their shared reads and writes in `steps.star` and a new `issues.star`; `extension.yaml` entries; templates for each comment.

**Tests**: cases in `tests/Test-StarGitHub` for each verb, its refusals, and each account.

**Documentation**: every page that describes opening, closing or reopening an issue is brought to the verbs, found by a full read of the handbook and the user documentation against section 10, as #582's review read them for the schedule and scenario commands. Known before that read:

- The engineering handbook: `docs/issue-standards.md`, where issues we file go through `open`, triage declines with `close --resolution`, and the closing rules and reopening are stated; `docs/engineering/work-organization.md`, `process.md` and `procedures/pull-request.md`, where work is logged, closed and reopened; `docs/templates/issue.md` and `schedule.md`; `docs/guides/pr-script-template.md`, whose schedule step closes a step with `gh issue close`; and `docs/guides/agent-rules.md`.
- The user documentation: each command's help in `extension.yaml`, which is its reference until #592 generates one; the README's list of the extension's commands; the data model's index and sections 8 and 9; each skill that opens, closes or reopens an issue; and the mentions the search found in `git-open-branch.1`, Start-Claude, `docs/github-branch-protection.md`, `docs/engineering/procedures/clone-retirement.md` and `docs/architecture/agent-schedule/1-session-model.md`, each read for whether it applies.

**Proof**: each verb run live in NobleFactor-sandbox and David-Noble-at-work-sandbox, each write read back through gh, as #507's proof did.

## 6. Alternatives and challenges

- **`file` and `create` instead of `open`.** Ruled `open`, symmetric with `close` and `reopen`, GitHub's own words for an issue's state; `create` is kept as its synonym.
- **`open` built later, after #572.** Not proposed: reading each form's sections when it runs takes #572's changes as they land, so `open` waits on #572 only for its proof's forms, not for its code.

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Section 10 approved | its status page records the owner's approval | the page | this repository |
| Each verb does what section 10 says | its cases pass | `tests/Test-StarGitHub` | this branch |
| Each verb works live | the proof's steps pass in both accounts | the proof's records, on each issue | the two sandboxes |
| `create` runs `open` | `star github issue create --help` is `open`'s | its case | this branch |
| `move` puts an issue where its type allows, from wherever it is | its cases pass, and the sweep's | `tests/Test-StarGitHub` | this branch |

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | yes | this branch | Pending |
| Merge | yes | the pull request, closing #589, #338, #590, #587, #595 and #597 | Pending |
| Deployment | yes: writ deploys the extension's new files | the owner's next `writ deploy` | Pending |
| Verification | yes | the proof, on each issue | Pending |

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [x] This plan committed on `doc/589-issue-verbs` on 2026-11-17 and approved by the owner that day, the questions in § 12 ruled as proposed

### 9.2 Phase 2: the design

- [x] Section 10 and its status page written on 2026-11-17, and approved by the owner that day, the collection groups' verbs synchronized the same day; sections 8 and 9 and the issue standards are pointed to it in Phase 4
- [x] Sections 8, 9 and 10 rewritten on 2026-11-17 to say what the commands do, in plain present-tense language, at the owner's direction; their rulings and history moved to their status pages

### 9.3 Phase 3: the builds

- [x] `close` (#590), with its cases, 122 to 128, built on 2026-11-17 in section 10's order: its comment, its Resolution, the issue closed, then its rows
- [x] `reopen` (#587), with its cases, 129 to 134, built on 2026-11-17 in section 10's order: the issue reopened, its Resolution cleared and its comment, its rows, its closed parents, then its closed schedules, by the code `schedule reopen` will run
- [x] `open` and `create` (#338), with its cases, 135 to 140, built on 2026-11-17 to section 10 as ruled that day: the repository the clone's, `--directory` naming another; everything read before one `createIssue`, its type, parent, assignee and fields, or labels in a user account; no row, the Triage workflow giving it its own; `unique` finding the parent's sub-issue by title; `create` a second manifest entry until NobleFactor/devlore-cli#1235
- [ ] The collection groups' `open`, `close` and `reopen`, `new` and `retire` renamed everywhere they stand (#595), with their cases
- [ ] `move` fixed, the sweep's rule narrowed, `reopen`'s rows for epics and features, and each Backlog's view of its epics and features (#597), with their cases

### 9.4 Phase 4: the documentation

- [ ] The handbook and the user documentation read in full against section 10, and every page that opens, closes or reopens an issue brought to the verbs

### 9.5 Phase 5: the proof and the merge

- [ ] Each verb proved in both sandboxes; the pull request merged, closing #589, #338, #590, #587, #595 and #597, each with its evidence

## 10. Files and related assets

- Create: `docs/architecture/issue-data-model/10-the-issue-commands.md` and its status page; `commands/github-issue-open.star`, `github-issue-close.star`, `github-issue-reopen.star`, `issues.star`; their templates.
- Modify: `extension.yaml`; `steps.star`; `tests/Test-StarGitHub`; the data model's index and sections 8 and 9; the handbook and user documentation pages § 5 names, and any the full read finds.

## 11. Dependencies, overlaps and blockers

- #572, the issue forms' review, in the Codex session's hands: `open` reads the forms when it runs, so only the proof waits on it.
- #581 and #582, in the Codex session's hands on `doc/581-schedule-command-consumers`, bring the same handbook pages and skill to the schedule and scenario commands. This branch brings develop in before it merges, so their changes land first and this pull request's go on top.
- #593, step 5 of iteration 2: closed findings leave their scenario. `close` removes the row of an item it closes; #593's recurring check removes the rest, and is designed there.
- NobleFactor/devlore-cli#1170: `--dry-run` refused until it lands, as for every other command.
- NobleFactor/devlore-cli#1235: `create` as an alias; a second manifest entry until it lands.
- The noblefactor-automation app can read issue fields but not write them, so a workflow running `open` with its token cannot set Area, Priority or Severity until the owner raises the permission: out of scope, recorded on #338.

## 12. Approval and departures

Settled by the documents, each the owner's to change:

- `close` leaves a closed step on its schedule, its row Closed, as merged steps stay (section 8, question 5).
- `reopen` sets a reopened row Open, since no one has taken it up again; it unticks a reopened schedule's every-step criterion, as the owner had #346's unticked on 2026-11-17; an item that left its scenario on closing goes to Triage (section 9, question 7).
- #338's "`star github` is broken today" no longer holds: it was repaired in iteration 1.

Ruled by the owner on 2026-11-17, each as proposed:

1. **Does `close` close a parent when it closes the parent's last open child?** Proposed: no; a feature or an epic closes with its own evidence, by `close` run on it, and `close` says so when it closes a last child.
2. **Priority at `open`:** required, or Medium when not given? Proposed: Medium when not given, as the issues split from features have been.
3. **Retyping an issue:** a verb of its own, `star github issue retype <issue> <type>`, in a later step, or a flag of `open`? Proposed: its own verb, later; this pull request builds the four.
4. **The filing skill:** in #338, or an issue of its own? Proposed: its own issue, on iteration 2, after this one merges.

Approved by the owner on 2026-11-17.

Departures, each ruled by the owner:

1. **`close`'s order, ruled 2026-11-17: section 10's order stands.** `close` was first built, in b68d022, to change an issue's rows first and close it last, and to change the rows of an issue already closed. The owner ruled the approved order kept: the comment, the Resolution, the issue closed, then its rows; an issue already closed is left as it is. The next commit restored it.
2. **A reopened issue with no row, ruled 2026-11-17: it goes to Triage.** Section 10 sent an item that left its scenario to Triage and said nothing of a task or bug `close` took off Triage or Backlog. The owner ruled that every reopened task or bug that has no row on its team's four projects gets a Triage row; an epic or a feature gets none. An issue with no type and no row gets one too, since section 1 has an untriaged issue wait in Triage.
3. **Where `open` opens its issue, ruled 2026-11-17: in the repository of the clone it runs in.** Neither section 10 nor #338 named the repository. The owner ruled that `open` takes it from the clone's origin, as `star github plan link` does, and `--directory <path>` names another clone, as git's `-C` does; `-C` waits on NobleFactor/devlore-cli#1236, filed that day, which lets an extension flag take a short name beside its long one.
4. **`--project` and `--status`, ruled 2026-11-17: dropped.** The Triage workflow gives every issue opened a Triage row, so a row `open` made on a Backlog project would leave the issue on two of its account's projects, which section 1 forbids. The owner ruled that `open` leaves the row to the workflow, and `move` places the issue from Triage.
5. **The assignee, ruled 2026-11-17: no one unless `--assignee` names someone,** so a workflow that opens an issue doesn't assign it to its bot.
6. **`move`, ruled 2026-11-17: it puts an issue where it needs to be, from wherever it is.** `move --backlog` refused an issue in Triage, so an issue `open` opens could not reach the Backlog by command. The owner ruled the old refusals broken: an epic, a feature, a task or a bug goes to Triage or the Backlog, a task or a bug to a schedule or a scenario, and a Schedule or Scenario issue nowhere. Filed as Bug #597, step 6, and put in this pull request.
7. **Epics and features, ruled 2026-11-17: on the Backlog until they close, their state their children's.** In place of the ruling of 2026-11-04 that an epic or a feature, once classified, leaves Triage for no project, it goes from Triage to the Backlog and stays there until it closes; nothing moves it when its tasks and bugs are pulled onto a schedule or a scenario. The owner first proposed that it leave the Backlog when its first task or bug went onto a schedule or a scenario, and asked how other trackers do it: Azure Boards, Jira, Shortcut and Linear move none, only its children, and change its state instead (section 10, § Epics and features, with its sources). The owner chose the simplest thing, with that evidence.
8. **The design docs, directed 2026-11-17: they say what the commands do.** The owner found sections 8, 9 and 10 ran on with one ruling after another, and more talk of what changed between iterations than of the design. They were rewritten in plain present-tense language for the commands this pull request builds, each command's syntax, what it does in order, what it refuses and what it returns, and their rulings and history moved to their status pages.

## 13. Completion review

Pending.
