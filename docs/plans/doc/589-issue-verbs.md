---
title: "The star github issue verbs, open, move, close and reopen, designed and built in one pull request"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/589
status: active
created: 2026-11-17
updated: 2026-11-19
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/8-the-schedule-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/9-the-scenario-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/1-hierarchy.md
  - kind: Design
    path: docs/architecture/issue-data-model/10-the-issue-commands.decisions.md
  - kind: Design
    path: docs/architecture/issue-data-model/8-the-schedule-commands.decisions.md
  - kind: Design
    path: docs/architecture/issue-data-model/9-the-scenario-commands.decisions.md
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
- [x] The collection groups' `open`, `close` and `reopen`, `new` and `retire` renamed everywhere they stand (#595), with their cases, 141 to 145, built on 2026-11-17: `schedule open` and `scenario open`, each with `create`, `scenario close`, and `schedule reopen` and `scenario reopen`, the last two by the code `issue reopen` uses; Start-Claude, its man page, completions and tests naming `star github schedule open`
- [x] `move` fixed, the sweep's rule narrowed, `reopen`'s rows for epics and features, and each Backlog's view of its epics and features (#597), with their cases, 97, 98, 130 and 146 to 150, built on 2026-11-18: `move` puts an issue where its type allows from wherever it is; the sweep flags an epic or a feature only on a Schedule or Scenario project; a reopened epic or feature goes to Triage; and each Backlog's views are Default, By priority, of tasks and bugs, and Epics and features, which `star github model apply` makes after the merge

### 9.4 Phase 4: the documentation

- [x] The user documentation brought to the commands on 2026-11-18: every page searched for opening, closing, reopening or moving an issue; the README's list of commands, the issue standards' filing rows and the PR script template's closing step changed; each `star github` command's help one plain line of at most 120 characters, its fuller help waiting on NobleFactor/devlore-cli#1237. The handbook is the documenter's (#599, #600)
- [x] Sections 8, 9 and 10 given their design-decisions companions on 2026-11-18, from the documenter's writing-and-review skill and arc42 drafts, each significant choice with its reasons, alternatives, consequences and approval; their status pages removed, what is built being this plan's and the plans of #439 and #507

### 9.5 Phase 5: the proof, the merge, the deployment and the completion

Recorded apart, as the engineering process's § Verify and review results has them: implementation, merge, deployment and verification each establish something different.

- [ ] Each verb proved in both sandboxes, from the branch's committed extension, its run's records kept: after the pull request opens, its findings logged as Bugs (departure 21); smoke tests of every command passed in both sandboxes on 96b39c8, and the full proof's steps 1 to 4 in David-Noble-at-work-sandbox on 24679ef
- [ ] The branch reviewed independently: its implementation, its sources and the proof's evidence
- [ ] The pull request merged by the owner, after the owner's review, referencing #589, #338, #590, #587, #595, #597 and the Bug of departure 14 without a closing keyword, since each has work left after the merge; each issue records the merge, and its row stays In progress, linking the pull request
- [ ] `writ deploy` and `star github model apply` of each account's reference model, each read back
- [ ] Each deployed command run as deployed, on the user's real path
- [ ] Each issue closed with its evidence, on the owner's completion approval

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
8. **The design docs, directed 2026-11-17: they say what the commands do.** The owner found sections 8, 9 and 10 ran on with one ruling after another, and more talk of what changed between iterations than of the design. They were rewritten in plain present-tense language for the commands this pull request builds, each command's syntax, what it does in order, what it refuses and what it returns, and their rulings and history moved to their status pages. The notes this pull request had added to sections 1 to 7, the index and the issue standards, saying each passage was superseded in part, were replaced by the passages themselves, rewritten in place, and each status page given one dated line; rewriting sections 1 to 7 in plain language is Task #598, step 7.
9. **Every project's first view is named Default, decided 2026-11-18.** The owner had the Backlog's View 1 renamed Default with its Epics and features view and its By priority view of tasks and bugs; the rule holds for every project, so the Triage and Scenario templates' View 1 is Default too. Recorded as [D-012 of section 10](../../architecture/issue-data-model/10-the-issue-commands.decisions.md#d-012).
10. **Design decisions in companions, decided 2026-11-18.** The documenter's drafts for Writing and review (#599) and Architecture content (#600) put a design's significant choices in a companion, `<design>.decisions.md`, each with its reasons, alternatives, consequences and approval, and the work of reaching the design in its plan. Sections 8, 9 and 10 took companions, and their status pages, which mixed approvals, history and progress, were removed; their progress is in this plan and the plans of #439 and #507. Sections 1 to 7 keep theirs until Task #598 rewrites them.
11. **The help, decided 2026-11-18.** Each `star github` command's help is one plain line of at most 120 characters, the length of our lines. star shows an extension command's help as its one-line summary and has nowhere for a description, examples, argument descriptions or completions; NobleFactor/devlore-cli#1237, step 25, gives an extension command's entry what star needs to make its man page, its completions and its help.
12. **A reopened parent goes to Triage, found 2026-11-18.** Writing the proof showed that `reopen` reopened a closed feature or epic for an issue under it but gave it no row, so a parent `close` had taken off the Backlog came back on no project. The owner's ruling of 2026-11-17, that a reopened issue with no row gets a Triage row, epics and features too, holds for a parent as for the issue: it now gets one, cases 129 and 132 expect it, and section 10 and [D-011](../../architecture/issue-data-model/10-the-issue-commands.decisions.md#d-011) say so.
13. **The suite's date, fixed 2026-11-18.** `make check` failed 15 cases in a run that began just before midnight UTC: `tests/Test-StarGitHub` took the day once, as the cases expect it, and star took it at each write, a day later from case 98 on. The harness now gives star a stand-in for `date` that answers the day the suite began, as it gives star a stand-in for `gh` and `sleep`, so a run that crosses midnight passes.
14. **Several issues off one schedule, fixed 2026-11-18.** A review of develop's head, #531's merge, found that `move` read each schedule an issue leaves once per row, before its first write, and renumbered and amended it from that read: two issues leaving one schedule in one `--schedule` or `--scenario` run left a gap in its steps and lost the first one's amendment line. `move` now reads each schedule and scenario an issue leaves once, shared by every issue leaving it, and each take-off renumbers from the rows as the one before it left them; those schedules are in the one-act check. The review's refusal faults are fixed with it: an option whose description is no issue's key, a pending schedule that can't be read, and a closed schedule are each refused with nothing written and say why; a scenario's option must name a Scenario issue; and an issue moved within its schedule no longer reads a scenario it doesn't leave. Cases 151 to 157 fail without the fix and pass with it.
15. **From one scenario to another of the same project, fixed 2026-11-19.** The sandbox proof's first run, 20261119T003953Z, stopped at its step 3i: a task moved from one scenario to another of NobleFactor-sandbox's one Scenario project was left on no project. GitHub gives back an issue's one row on a project for any addition, so `move` gave that row the new scenario's option, then deleted it as the old scenario's row. The cases had moved an item only between two teams' projects. The row is now kept, its leaving recorded before it moves, and case 158 moves an item between two scenarios of one project; it fails without the fix and passes with it.
16. **A removed row read back from the issue, fixed 2026-11-19.** Tidying the proof's first run, `close` failed after removing a task's scenario row: it read the deleted row back by its own ID, which GitHub answers with an error, not null, and every row `close` removes, from Triage, the Backlog or a scenario, would fail the same way. The stand-in had answered null. `close` now reads a removal back from the issue's own rows, and the stand-in answers a deleted row's ID with GitHub's error, so the cases that remove a row fail without the fix.
17. **Phase 5 separated, 2026-11-19.** The role entry points of #601 and the process's § Completion and progression put the merge, the deployment, its verification and each issue's completion apart: an issue with work left after the merge is referenced without a closing keyword, and closes on the owner's completion approval. Phase 5 lists them so.
18. **A null answer as gh prints it, fixed 2026-11-19.** Tidying the proof's first run, `close` failed on an issue with no parent: gh prints a null `--jq` result as an empty line, which `parent_of` decoded as JSON. The stand-in had printed `null`. `parent_of`, `issue`, `closing_of` and `read_row` now read an empty line as null, and the stand-in prints a null result as gh does, so a case that closes an issue with no parent fails without the fix. GitHub answers an issue number that names no issue with a `NOT_FOUND` error and exit 1, which every command's reads fail on with a traceback, where they are written to refuse by name; that fault is older than this work and outside it, and is recorded as a Bug of its own rather than fixed here.
19. **The branch's independent review, 2026-11-19.** A review of the branch against develop found eight defects, each now fixed with a case that fails without its fix, 159 to 166: `close` names a parent whose last open children one run closes, reads the Schedule project's Closed option before its first write, and changes a row with no option as its project's kind has it; `reopen` reads the Triage project's Open option before its first write, and sets every row of the four projects Open; `open` compares a parent's key in any case, as GitHub's keys are, and `reopen` plans a parent once in any case; a template's header blank read by YAML as braces is refused, saying to quote it; and `--set` fills each blank once. The stand-in names a repository in any case, as GitHub does. Its two other findings, helpers repeated across files and a project read many times in one run, are cleanup, put to the owner.
20. **The pull request's three decisions, 2026-11-19.** The owner decided, asked: the owner reviews the pull request and completes its merge, so its script stops once CI passes and, run again after the merge, records it; `git close-branch` may sync the main clone, which it does by fetching origin and fast-forwarding it to develop, and the process requires the main clone current; and the PR script template's closing step posts each step's merge record as its evidence comment and sets its row Closed itself, without `star github issue close`, closing the issue only if GitHub has not yet. A step approved to close keeps its closing keyword, so GitHub records the pull request as what closed it, which `star github schedule close` lists. The Bash form had called `star github issue close`, which finds an issue the merge already closed and leaves it as it is; it now does what the PowerShell form does.
21. **The pull request before the full proof, 2026-11-19.** The owner directed that the pull request open now and that what the proof finds be logged as Bugs. Its evidence is the smoke tests of every command in both sandboxes, runs 20261119T024311Z and 20261119T020800Z on the code committed as 96b39c8, and the full proof's steps 1 to 4 in David-Noble-at-work-sandbox, run 20261119T032302Z on 24679ef, which stopped at step 5 on the sandbox token's rate limit. The full proof runs after the pull request opens, and each issue still closes only with its evidence, on the owner's approval.

## 13. Completion review

Pending.
