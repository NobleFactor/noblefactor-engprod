---
title: "The GitHub issue data model: one hierarchy, its attributes, and the collections that order it"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/303
status: active
created: 2026-10-21
updated: 2026-11-04
---

# Plan: The GitHub issue data model: one hierarchy, its attributes, and the collections that order it

## Issue 303

A chore under issue standards, NobleFactor/noblefactor-ops#156, filed 2026-10-13 as "The classification scheme makes
schedule a kind beside epic, feature, bug, chore and task, and gains a trends report". Its open questions asked where
the kinds should live, in GitHub's issue types or in labels, and whether a GitHub project should chart the trends. The
owner's discussion on 2026-10-20 and 2026-10-21 answered both, and not as the title has it: a schedule is not a kind
but a GitHub project, and so is a thread. This plan is for the first of the two parts the owner named on 2026-10-21:
"Goal: NobleFactor/noblefactor-ops GitHub Issue data model. This is one of two parts we need to implement: data model
and tooling around the data model (the star gh extension)". The trends report belongs to the second part.

The owner's words, in order:

- 2026-10-20: "I want to map schedules to github projects and get rid of the current scheme for tracking lanes. A lane
  would be represented by a single row in a project of type Schedule. Fields would include: Lane, Repo, Issue,
  Status, ..." Then: "Lanes are arranged sequentially with row 0 representing the schedule issue, so creating a
  schedule means populating an instance of the Schedule project type", and "Creating a Lane appends a row for any
  issue type in our hierarchy: epic, feature, (bug|chore|task). lane numbers are auto-generated and sequential from
  [0..N]".
- 2026-10-20: "I do not want to lose this thinking on schedules." Then: "Except for recording these design notes and
  building the project prototype, another session will be doing the work."
- 2026-10-21: "We are in design. We are not acting or deciding on anything. We are discussing possibilities." Then:
  "Should we be using projects, tags, or something else to represent schedules, severity, and other name/value pairs
  we wish to track? One this is settled: we use tags to classify issues in our hierarchy of epics, features, and
  (bugs|chores|tasks). Every issue must be fit into this hierarchy of issue types."
- 2026-10-21: "use labels/tags for the attributes of an issue. An issue has a place in the issue hierarchy in a repo.
  An issue has a severity. An issue might be on a schedule and schedules are owned by individuals and teams."
- 2026-10-21: "Settle the personal issue. My thinking is that our labels are defined and stored as yaml assets in
  noblefactor-ops."
- 2026-10-21: "I would say epic is NOT a label, but that it is a peer of `feature`, (`bug`|`chore`|`task`). It is a
  value that you assign to `kind`. Schedule and Thread are almost synonymous. They vary in intent, but are otherwise
  the same."
- 2026-10-21, the stakes for this design: "Our hierarchy is represented by a field called (offer alternatives, if this
  seems off to you) Type." "Our Issue Type hierarchy includes these classifiers: Epic, (Chore | Feature), and (Bug |
  Task). Note the mutual exlusivity and not that it has changed." "Projects track Schedules and Threads. Threads track
  (Chore | Feature) work. Schedules track (Bug | Task) work. Threads represent use cases. Schedules track engineering
  work. Threads will ultimately drive Schedules and influence Priority. Severity is a quality of a bug." And a
  question: "what meaning does severity have in the context of a Task?"
- 2026-10-21, of triage: "we need the triage queue. Bugs are unplanned and must be logged without knowledge of where it
  fits into the hierarchy." Then: "It seems we must allow that bugs get filed without any ceremony. they are classified
  by a triage "team"."
- 2026-10-21, of the work: "What we need to do is write up the data model and produce a set of tasks for the work
  ahead. The task list should be based on what we see are the deltas between what we have and what we want. We will
  produce the task list after we have some clarity on the data model. The schedule for this work cannot result in
  downtime for other activities that are underway. We should plan PRs around that constraint." Then: "go ahead, open
  the branch and draft it."
- 2026-10-21, of where it belongs: "the data model goes into the epic around issue tracking. there are two technical
  sides: the GitHub data model and the tooling (star gh). and migration must be managed carefully." None was filed:
  that day `star gh issues report`, all states, found two epics in noblefactor-ops, #61 (closed) and #142, Epic:
  Process, and none about issue tracking in devlore-cli or personal.
- 2026-10-21: "We need the issue tracking epic in NobleFactor/noblefactor-ops. The epic should include the rename of
  noblefactor-ops", to noblefactor-engprod, #304: "I want engprod ... as the new suffix for noblefactor-ops." Filed the
  same day as Epic: Issue tracking, #330, with three features: the data model, #331; the tooling, #332; and the
  rollout, #333, into which #304 moved as a task. #303 moves under #331 once its kind is settled: today a chore carries
  `Epic:Ops:Process`.

The owner also shared a write-up of the data model by Gemini on 2026-10-21, as input rather than a ruling. Where the
design takes an idea from it, the design says so.

## Summary

The [issue data model](../../architecture/issue-data-model/index.md) states what every NobleFactor issue is, what it
carries and how it is ordered. An issue is classified by its issue type, in the hierarchy Epic, then Feature, then Task
or Bug. Each team, and each user account, has four projects: Triage, where every issue is reviewed and a triage
decision made; Backlog, for accepted work not yet scheduled; Schedule, whose Schedule field names the schedule each
committed task and bug belongs to; and Scenario, whose Scenario field names the scenario each feature belongs to. The
design ends with the deltas from today's scheme, from which the task list is drawn once the owner has ruled, ordered
into pull requests that take nothing in use down.

## Schedule

Step 3 of issue tracking, iteration 1 (#346), In progress on Schedule: engprod (NobleFactor project 26). It was lane 3
of that schedule, then NobleFactor/noblefactor-ops#346, from 2026-10-21; it waited on lane 1, #358, which merged in
#370 that day. From 2026-10-22 the lane is the sweep below, whose iterations file their own lanes; the schedule's
amendment for lanes 3 to 6 is the owner's, proposed in this plan's first sweep commit. Before that, not on a schedule:
this plan's session wrote the design and the owner said another session would do the work (2026-10-20, above).

## Goals

1. **One model, written down:** the hierarchy, the attributes, the collections, and where each lives in GitHub.
2. **The deltas from today:** what changes, so that the task list follows from the model rather than from memory.
3. **No downtime:** a way from today's scheme to the model that keeps the work in progress running.

## Current State

| Part | Today |
| --- | --- |
| The scheme | [issue-standards.md](../../issue-standards.md): five kinds as labels, `Epic:<Name>` labels, the `**Feature:**` marker, and threads and schedules as tables in issue bodies |
| The labels file | [labels.yaml](https://github.com/NobleFactor/noblefactor-ops/blob/develop/docs/architecture/issue-labels/labels.yaml), designed under NobleFactor/noblefactor-ops#320 and approved 2026-10-19; on #320's branch, not merged |
| The tooling | `star gh issues report` and `audit` read the labels, the marker and the body tables |
| GitHub's issue types | Task, Bug and Feature, enabled in NobleFactor; none in personal (read with `gh api graphql`, 2026-10-21) |
| GitHub's issue fields | Priority, Effort, Start date and Target date in NobleFactor; none in personal (the same reads) |
| GitHub's links | Parent, sub-issues, blocked-by and blocking exist on every issue (the API's `Issue` type, 2026-10-21); NobleFactor/noblefactor-ops#176 found none in use across 454 issues on 2026-09-05 |
| GitHub projects | None in NobleFactor. Two test projects were made and deleted on 2026-10-20: one held David-Noble-at-work/personal#259 as a row with a custom number field set on it, and one was marked as a template |

## Requirements

### Requirement 1: the design

[docs/architecture/issue-data-model/](../../architecture/issue-data-model/index.md): the hierarchy, the attributes,
the collections, storage and reach, and the deltas from today's scheme, each section with its status companion.

### Requirement 2: the rulings

Each open question below ruled by the owner, quoted with its date, and the design revised to match.

### Requirement 3: the task list

Drawn from the deltas in [section 5](../../architecture/issue-data-model/5-from-todays-scheme.md), covering both parts,
the data model and the star gh extension, and ordered into pull requests that keep running work running.

### Requirement 4: the prototype

A Schedule template in the NobleFactor organization, and schedule NobleFactor/noblefactor-ops#301 as a project made
from it, its lanes as rows. Creating organization projects is outward-facing, so each step waits on the owner's word.

## Implementation Phases

### Phase 1: The plan and the draft

- [x] This plan and the draft design, written 2026-10-21, committed on this branch and taken to develop as a draft by
  their own pull request, which leaves #303 open. The owner, 2026-10-21: "let's do a pr to get the data model draft
  in." Five lines of #322's and #321's plans, which #339 merged still naming lane 13 after the split of #301's lane 13,
  ride it. The owner, the same day: "You own #301; fix the five lines in your PR."

### The sweep, from 2026-10-22

Status `active` from the second pull request, 2026-10-22, which takes the rulings of 2026-10-21 and 2026-10-22,
sections 6 and 7, the first `model.yaml` and iteration 1's progress to develop; the sweep continues past the merge,
iteration by iteration, and this plan closes with iteration 5.


The owner, 2026-10-22, on Phases 2 to 5 as written: "I'm seeing that this will take at least a month to complete in a
waterfall fashion. We will get a complete design and then stumble and redesign again and again. I might rather sweep
broadly and refine the design at deeper levels as we go. The data model is critically important to get right and roll
out correctly. The tool should follow close behind. An important constraint: we can't get in the way of 5 other
session[s] I'm running." Then: "Start the sweep. I'll answer questions just-in-time as we progress."

So the phases below replace Phases 2 to 5. Each iteration rules only what it needs, revises the sections it touches,
builds, and rolls out before the next. The line that protects the running sessions is additive against subtractive:
what the sessions read is the report and the audit through labels, markers and lane tables, Start-Claude keyed by a
schedule's issue number, and the label set. Every iteration ships its additive half when ready; its subtractive half
waits for a switch taken when the affected sessions are between lanes. The tooling of each iteration is its own task
under #332, the rollout under #333, worked as lanes; this plan carries the design, the rulings and the documents.

### Iteration 1: the hierarchy

Epic and Chore added to the organization's issue types, done 2026-10-22; every noblefactor-ops issue typed and linked,
which 66 of 89 already were; labels and markers kept. The tooling: the asset with its types as levels, `pull`, the
read before every operation; the report and the audit reading type and link first, label and marker second.

- [x] Questions 1, 10 and 13 ruled; the hierarchy, storage and asset sections revised -- 2026-10-22
- [x] The five issue types in GitHub with the level convention; `model.yaml`, the first pull -- 2026-10-22
- [x] Questions 3 and 4 ruled: the fate of #142, ruled 2026-10-22, the triage epic and row 0 of the Triage project, with
      question 5 closed by the same ruling, row 0 an Epic; the team ruled the same day, teams triage their own --
      2026-10-22
- [x] The write test, first half: a sub-issue link across repositories and across owners -- 2026-10-22, it crosses both
- [x] The write test, second half: a single-select option updated by id -- 2026-10-26, under #377, on project 4, the
      thread built for it: its options renamed by id, every row keeping its value
- [x] #304, noblefactor-ops renamed noblefactor-engprod, done early: the owner, 2026-10-22, "bump up the priority of
      the issue for renaming noblefactor-ops as noblefactor-engprod. we might do that before we go much further. it
      will be one less thing to worry about at the end." Its own plan and pull request, before the rollout below --
      complete 2026-11-02
- [x] Section 5's deltas and order rewritten to the rulings so far, each delta with its state; the status companions of
      sections 1, 3, 4 and 5 set -- 2026-10-22
- [x] The tasks filed under #332 and #333 -- 2026-10-22, approved that day, nine in the order of their pull requests,
      the waits-on recorded as GitHub blocked-by links and in the lane table:

      | # | Task | Issue | Waits on |
      | --- | --- | --- | --- |
      | 1 | the extension reads the hierarchy from `model.yaml`, nothing in its code naming a type | #376 | — |
      | 2 | `star gh model pull`, the ETag cache, the digest; #320's labels file becomes the asset | #377 | 1 |
      | 3 | every `star gh issues` operation reads the record first and says when the asset is behind | #378 | 2 |
      | 4 | the report and the audit place an issue by type and sub-issue parent first, label and marker second | #379 | 1 |
      | 5 | the audit names the model's faults | #361 | 4 |
      | 6 | every open noblefactor-engprod issue typed and linked from its label and marker, both kept | #380 | 4 |
      | 7 | the reclassification by the owner's rule, from the inventory | #363 | 6 |
      | 8 | `star gh issues create` files with type, parent and attributes, and refuses a non-participating repository | #338 | 4 |
      | 9 | deployed and proved: every open leaf under its parent by link | #365 | 5, 7 |
- [ ] Rolled out: every open noblefactor-ops issue typed and linked, the report placing it by type and link, and the
      sessions running throughout

### Iteration 2: triage and the Triage project

The first collection, purely additive. `push` for personal; the Triage project's rows read by the report.

- [x] Section 3's Triage rows and section 6's `push` built as tasks under #332 -- filed 2026-11-02 as #436 and #437
- [x] The `engprod` team created, with Admin on its Triage project and Triage on its repositories; the devlore
      triage epic filed in devlore-cli; both organization writes on the owner's word -- 2026-11-01: engprod, made
      2026-10-24, holds Admin on Triage: engprod and Maintain, which includes Triage, on noblefactor-engprod; devlore
      holds Admin on Triage: devlore; devlore's triage epic is NobleFactor/devlore-cli#1188
- [x] The two Triage projects made in the organization, Triage: engprod with #142 as row 0 and Triage: devlore with
      the new epic, on the owner's word; #142's 90 issues drained to the epics they serve or left in the queue --
      Triage: engprod, NobleFactor project 5, made 2026-10-26, #142 retitled Epic: engprod triage on 2026-11-01;
      Triage: devlore, project 6, made 2026-11-01, devlore-cli#1188 its row 0, and the 12 open issues of devlore's
      repositories in engprod's queue moved to it; #142's issues left in the queue
- Dropped 2026-11-02: personal pushed and proven participating. #437 must work for David-Noble-at-work, and #425 sets
  the account up from the user reference model, so the two cover it.

### Iteration 3: schedules and threads as projects

The Schedule and Thread templates, #301 as the prototype, lane tables kept as the copy of record until the switch;
rows and lanes read by the report; Start-Claude keyed as before.

- [ ] Questions 5 to 9 ruled; section 3 revised
- [x] The templates and the prototype made, on the owner's word for each organization write -- 2026-11-01, on the
      owner's order to build the whole entity model at once: the Schedule and Thread templates, projects 7 and 8,
      GitHub's default workflows removed; every open schedule and thread a project copied from its template, projects 9
      to 22, its own issue as row 0 and its lanes or beats as rows, from any repository, owned by the team of the
      repository its issue lives in; 75 waits-on made blocked-by links; schedule #346's lanes 3 and 14 to 18 recorded.
      Schedule #171, the four lanes, left out on the owner's word: stale, its lanes epics. Corrected 2026-11-03:
      GitHub's default workflows were off, not removed; the two templates still had five built-in workflows each, and
      they were deleted that day (the cutover, below)
- [x] `star gh schedule add` and the report's row reading built as tasks under #332 -- filed as #438 and #427
- [x] Lane renamed Step on the Schedule template and the nine schedules, and each schedule's first row left without a
      step -- 2026-11-02, in GitHub; the model pulled again, and the reference models and section 3 brought to them,
      on this branch

Built 2026-11-01 for questions 6, 7, 9 and 10, none of them ruled: a Lane field numbering each schedule's rows, row 0
at 0; Status's options Open, In progress and Closed, set from the issue's state and its Next, no GitHub workflow
setting them; six issues lanes of two schedules; and a thread's rows its beats as its table had them, of any type, a
member with no beat unnumbered.

The rulings of 2026-11-01 and 2026-11-02:

- 2026-11-01: the entity model is built now, end to end, by commands the owner runs.
- 2026-11-01: there are two teams, devlore and engprod, each with its own Triage project; a schedule's lanes come from
  any repository.
- 2026-11-01: every schedule is a Schedule project, its issue the project's row 0 and no longer the schedule itself; the
  tooling does not read projects yet.
- 2026-11-02: an organization's projects hold no issue from a person's repository: question 17.
- 2026-11-02: the work aims at a stable release of the product as it does today, done right.
- 2026-11-02: a schedule's rows are numbered by Step, not Lane, and the first row, the schedule's own issue, has no
  step. GitHub numbers the rows of a view by their place in it, so no stored number can match every view.

### Accounts, from 2026-11-02

Organizations and individual accounts are separate, each with its own model (question 17).

- [x] Sections 1, 3, 4 and 6 and the index state the ruling -- 2026-11-02
- [x] Question 17's open points ruled: links within an account, work across two, personal's lanes, where each model
      lives -- 2026-11-02
- [x] The tasks filed -- 2026-11-02: #425, the reference models; #426, each account's model read on demand; #427, the
      report and audit reading schedules and threads from their projects; #428, NobleFactor's records holding nothing of
      personal's; and David-Noble-at-work/personal#309, personal's own records
- [x] Each participating account keeps its model, made from its reference, in its own public `.github` repository, and
      the reference pair ships with the extension -- 2026-11-02, revising question 17's settlement the same day; filed
      as #431 and David-Noble-at-work/personal#311, and #426 brought to it
- [x] The two reference models written beside the extension, `reference/organization.yaml` and `reference/user.yaml`
      -- 2026-11-02, on this branch
- [ ] Question 18 ruled: how an account takes part in the model, and keeps to it
- [ ] The crossings removed, #428: 26 sub-issue links, 58 project rows and 2 blocked-by links
- [ ] personal's own triage epic and Triage project, and a schedule of its own for each NobleFactor schedule its lanes
      came from, personal#309. The rulings of 2026-11-03 have since replaced the triage epic and the five schedule
      projects, and personal#309's body still describes them
- [ ] The reference models and the adoption of an account, #425; each account's model read on demand, #426

### Chore retired, from 2026-11-02

The hierarchy is Epic, then Feature, then Task or Bug: Chore is dropped, as the rewrite of the engineering documents
states (#419, #420). The organization's types, the record and the tooling follow it.

- [x] The organization's types: Chore disabled, and Epic, Feature, Task and Bug described with their levels; personal's
      four kind labels likewise -- 2026-11-02
- [x] noblefactor-engprod's 53 open chores typed Task; personal's 14 open chores labeled task, and #287 a feature with
      #289 to #295 naming it -- 2026-11-02
- [x] `model.yaml` pulled again: the four types and the 19 projects -- 2026-11-02, on this branch
- [x] The report and the audit find a schedule or a thread by its title, whatever its kind, and ask neither for a kind
      label; the words they print for tier two come from the asset -- 2026-11-02, on this branch, verified through a
      private copy of the extension before the record was relabeled: every schedule found, and #346's report unchanged
- [x] The record agrees with the model: every issue labeled chore that is not a schedule labeled task instead, 208 when
      counted, open and closed, in the three repositories; #347 and #348, chores with lanes, labeled feature, and their
      lanes #350 to #354 naming them with Feature markers -- 2026-11-02, by this branch's script before its merge
- [x] The schedule issues' kind ruled; then the Chore type deleted and the chore label retired, with Start-Claude's use
      of it -- 2026-11-03: a schedule's issue is type Schedule. The Chore type was gone by 2026-11-02, and the chore
      label was removed from both accounts that night. Start-Claude's use of it is #440.
- [ ] This design and issue-standards.md stated without Chore, after #420

### The cutover, from 2026-11-02

Decided on 2026-11-02: a working issue tracking system on GitHub comes first, and the tooling follows. #303 keeps the
design. Its build and rollout work moved to issues of their own: #436, #437, #438, #439, #440 and #441, with #365,
#425, #426, #427, #428 and David-Noble-at-work/personal#309. Each ruling is recorded on #303 as a comment of
2026-11-02 or 2026-11-03.

Done in GitHub:

- [x] The Next column deleted from the Schedule template and every schedule -- 2026-11-02
- [x] A Triage template, NobleFactor project 23. Triage: engprod and Triage: devlore brought to it, their Status options
      renamed in place and their Status workflows removed. Triage: David-Noble-at-work, David-Noble-at-work project 3,
      copied from it -- 2026-11-02
- [x] Copies of the Schedule and Thread templates in David-Noble-at-work, projects 1 and 2, since a user account can't
      have templates -- 2026-11-02; and of the Triage template, project 4 -- 2026-11-03
- [x] NobleFactor/.github and David-Noble-at-work/.github created, both public -- 2026-11-02. NobleFactor/.github was
      empty that day: the organization's ruleset requires the quality-gate check, and the repository had no workflow
      that produced it. On 2026-11-03 both held `README.md`, their six issue forms and the Triage workflow template, and
      NobleFactor/.github also held `.github/workflows/quality-gate.yml`
      ([section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md#one-model-per-account))
- [x] The type descriptions made the same in both accounts, within GitHub's 100-character limit for labels -- 2026-11-02
- [x] Names follow GitHub's conventions: issue types capitalized, labels lowercase -- 2026-11-03
- [x] Schedule and Thread issue types in NobleFactor, and `schedule` and `thread` labels in David-Noble-at-work. The 12
      schedule issues and the 5 thread issues typed -- 2026-11-03
- [x] No triage epic and no Triage type. #142, NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313
      retired, and their 24 open sub-issues made rows of their Triage projects -- 2026-11-03
- [x] The `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels removed from both accounts, after the 49 open issues tied
      to an epic or a thread only by a label were placed: under the epic the label named, in the thread's project, or in
      their Triage project -- 2026-11-03. The `Area:`, `Priority:` and `Severity:` labels stayed then; devlore-cli's
      seven `Area:` labels were deleted later that day, by the rulings on area below, and its eight `Severity:` and
      `Priority:` labels that evening, once their issues held the matching field values (below).
- [x] The templates' descriptions say nothing about star -- 2026-11-03

On this branch, `doc/303-model-cutover`, the design brought to the cutover:

- [x] Section 4 shows the organization account and the user account in a diagram each, with its templates and the
      `.github` repository that stores its model, and describes the user account in detail -- 2026-11-03
- [x] Section 6 states what the model holds and what it leaves out, that it's a cache, where it's stored, and what pull
      and push do with it. Workflows and an organization's default labels are left out. -- 2026-11-03
- [x] Section 3 states the four templates, triage without an epic, and schedules without a Next column -- 2026-11-03
- [x] Section 1 states the six types and GitHub's naming conventions -- 2026-11-03
- [x] Sections 5 and 7, the index and the status companions brought to the above -- 2026-11-03
- [x] [issue-standards.md](../../issue-standards.md) states the model as it now stands -- 2026-11-03

The rulings of 2026-11-03 on projects, which override the design above where they differ:

- Threads are renamed scenarios. The Thread issue type is now Scenario, the `thread` label in a user account is now
  `scenario`, the Thread template is the Scenario template, and a thread project is a scenario.
- Each team, and each user account, has four projects: Triage, Backlog, one Schedule project and one Scenario
  project. In an organization they are named for their kind and the team, such as Triage: engprod, Backlog: devlore,
  Schedule: engprod and Scenario: devlore; in the user account they are named for their kind and David-Noble-at-work.
- A team's Schedule project holds its committed tasks and bugs. A single-select Schedule field names the schedule each
  row belongs to, with one option per schedule, named for its Schedule issue, which holds that schedule's deliverable
  and exit criteria. Step orders the rows within a schedule, and a Schedule issue's own row has no step. GitHub's
  Iteration field gives each row its sprint, for scrums and sprint review. Status and Worktree are unchanged. There is
  no longer a project for each schedule.
- A team's Scenario project holds its features. A single-select Scenario field names the scenario each row belongs to,
  named for its Scenario issue, which tells the story. Beat orders the rows within a scenario. There is no longer a
  project for each scenario.
- A team's Backlog project holds accepted work not yet scheduled, ordered by priority.
- The Triage project is where every issue is reviewed and a triage decision made: the work is declined, and the issue
  closed as completed with Resolution Declined in NobleFactor or the `resolution:declined` label in a user account, or
  the issue moves to the team's Backlog, Schedule or Scenario project.
- New issues reach their team's Triage project through a GitHub Actions workflow in each repository, run when an issue
  is opened or transferred, using `actions/add-to-project`; GitHub's built-in auto-add workflow is not used. Each
  repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project, from the team mapping: the team with the
  maintain role on a repository owns it. A Triage workflow template in each account's `.github` repository offers the
  workflow.
- The team that owns a project is accountable for it, and GitHub's link between a project and its team is the record.
  A user account's projects are its owner's.
- Issues are classified by issue type, in the hierarchy epic, feature, then task or bug. Enforcement is lax, and there
  are no compliance checks.
- Issues we file ourselves go through `star github issue`, the one path that classifies an issue as it is made.
- NobleFactor keeps a template for each kind: Triage (project 23), Schedule (project 7), Scenario (project 8, the
  former Thread template) and Backlog (project 24). David-Noble-at-work, which cannot have templates, keeps copies of
  them. A team's projects are copied from these.
- GitHub Actions cannot run a workflow when a project row changes: `projects_v2_item` is a webhook event for
  organization webhooks and GitHub Apps only.

- [x] GitHub brought to the rulings of 2026-11-03 on projects -- 2026-11-03: each team's Backlog, Schedule and
      Scenario projects made and linked to the team; the schedule and thread projects folded into them, every row
      checked, and projects 9 to 22 closed; Thread renamed Scenario; the Backlog template and the user account's
      copies made. The closing missed NobleFactor project 4, "Thread: the model follows a rename", the thread project
      made on 2026-10-24 as #377's write test, closed on 2026-11-04 (below)

The rulings of 2026-11-03 on area, issue fields and the old scheme:

- [x] Area tells engineering work from product work, with two values only: in NobleFactor, the options Product and
      Engineering of the Area issue field; in a user account, the labels `area:product` and `area:engineering`. Area
      applies to issues of every type and describes the issue's own work, so an epic, a feature and the tasks and bugs
      under them can each differ: a CI bug fixed during a product feature is engineering. Release notes come from the
      closed product issues in a release, not from the hierarchy, and product readiness and release management epics
      hold both kinds. Engineering covers build orchestration, Makefile changes, CI pipelines, internal agent-workspace
      scripts and tools, and governance and process work -- 2026-11-03: the Area issue field made in NobleFactor
- [x] devlore-cli's seven finer Area labels, architecture, CLI, code quality, error handling, git, meta and testing,
      deleted. The hierarchy carries those distinctions: architecture work is a task or a feature with product value
      within an epic; a bug isn't filed against the architecture, and an architecture task is logged to address a bug in
      a feature -- 2026-11-03
- [x] A blank Area is an error, caught at filing, at triage and afterwards. At triage, each Triage project shows the
      Area column (in a user account, the `area:` labels in its Labels column) and has a "Missing Area" view, and
      nothing leaves Triage without an Area -- 2026-11-03: the column made in NobleFactor's Triage projects, and the
      view in each Triage project
- [ ] At filing, `star github issue` refuses an issue without an Area
- [ ] At filing, the issue forms in each account's `.github` repository have a required Area dropdown, and the Triage
      workflow copies its answer into the Area field or label when the issue is opened. On 2026-11-03 the six issue
      forms were in both `.github` repositories, each with a required Area dropdown, and none of the seven repositories
      with `TRIAGE_PROJECT_URL` set had the Triage workflow (below)
- [ ] Afterwards, a scheduled sweep returns any open issue without an Area to its team's Triage project
- [x] An account's model holds its issue fields, as it holds its issue types and labels. NobleFactor's are Priority,
      Effort, Target date, Resolution and Area; Start date stays unused. A user account has none -- 2026-11-03: the
      organization's reference model listed the five fields and the user's reference model the two area labels, on
      this branch. Severity joined NobleFactor's fields that evening, and on this branch the organization's reference
      model lists it after Area and the user's the labels that stand in for each single-select field
- [x] The old scheme's last three pieces retired, in GitHub -- 2026-11-03: the parent markers and schedule footers taken
      out of 725 issue bodies, 47 issues given the sub-issue parent their marker named, and the link kept where the two
      disagreed; the step and beat tables in 14 Schedule and Scenario issues replaced by a line naming the issue's board
      and option; and the kind labels epic, feature, task and bug removed from NobleFactor's 12 repositories, after 672
      issues were given the issue type their label named. David-Noble-at-work keeps its type labels, which are its types

The ruling of 2026-11-03 on file templates: an account's issue forms, its Triage workflow template and its pull request
template are stored in its `.github` repository, and every document that talks about one of them refers to it there
([section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md#one-model-per-account)).

- [x] The design, issue-standards.md, development-process.md, agent-rules.md, the PR script template and
      github-branch-protection.md refer to each account's file templates in its `.github` repository -- 2026-11-03, on
      this branch

The rulings of the evening of 2026-11-03, recorded under questions 14 and 17 below: Severity is an issue field of
NobleFactor; a user account has exactly the same data model as an organization, apart from what GitHub offers
organizations only, so in a user account, which has no issue fields, a label stands in for each single-select issue
field; and David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's steps go on
them. This branch's script, `~/Workspace/NobleFactor/noblefactor-engprod.303-model-cutover.bash`, ran the same
evening, and each of its four steps read back: it took `chore` out of ruleset 12515090 (below), pushed this branch and
linked it from #303's row on Schedule: engprod, made the Severity field, and moved devlore-cli's `Severity:` and
`Priority:` labels into the fields. `doc/303-model-cutover` is on GitHub at `60828ac`, and the row has read back the
link since. That fixes the breakage of 2026-11-03 that rule 19 of [agent-rules.md](../../guides/agent-rules.md)
records.

- [x] NobleFactor's Severity issue field, by the ruling under question 14 -- 2026-11-03: made by step 3 of this branch's
      script and read back, with the options Critical, High, Medium and Low and no default value, since GitHub's issue
      fields can't have one ([section 2](../../architecture/issue-data-model/2-attributes.md#the-attributes))
- [x] devlore-cli's `Severity:` and `Priority:` labels moved into NobleFactor's Severity and Priority fields, then
      deleted -- 2026-11-03, by step 4 of this branch's script. The 77 devlore-cli issues that carried a `Severity:`
      label and the 75 that carried a `Priority:` label, open and closed, got the matching field value, each read back,
      152 values in all. `Severity:<X>` became Severity <X>, and `Priority:P0`, `Priority:P1`, `Priority:P2` and
      `Priority:P3` became Priority Urgent, High, Medium and Low. Then the eight labels were deleted. No NobleFactor
      repository has a severity or priority label now: devlore-cli's labels are documentation, enhancement, good first
      issue, help wanted, question and business
- [x] The labels that stand in for a user account's single-select issue fields, by the ruling under question 17 --
      2026-11-03: the `priority:`, `severity:` and `effort:` labels made in personal and David-Noble-at-work/.github,
      one for each option of NobleFactor's Priority, Severity and Effort fields, each colored and described as its
      option is, beside the `area:` and `resolution:` labels already there; and the Priority project field deleted from
      Backlog: David-Noble-at-work and the account's Backlog copy, neither of which had rows
      ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md#a-user-account))
- [x] David-Noble-at-work's first schedule, by the ruling under question 17 -- 2026-11-03, made and read back:
      David-Noble-at-work/personal#314, "Schedule: issue tracking, iteration 1", labeled schedule and area:engineering;
      a Schedule field on Schedule: David-Noble-at-work whose first option, "issue tracking, iteration 1", is named for
      personal#314; and David-Noble-at-work/personal#315, the task that adds personal's Triage workflow, as its step 1
- [x] A Scenario field on NobleFactor's Scenario template (NobleFactor project 8), on Scenario: David-Noble-at-work (its
      project 8) and on the account's Scenario copy (its project 2) -- 2026-11-03, made and read back. GitHub won't
      make a single-select project field without at least one option (GitHub's GraphQL schema,
      `CreateProjectV2FieldInput`), so on the owner's order a placeholder scenario was made in each account to give the
      fields their first option: NobleFactor/noblefactor-engprod#442 and David-Noble-at-work/personal#316. Each is
      titled "Scenario: placeholder", is of type Scenario (the label scenario in personal), has Area Engineering, is
      open, and has no rows and no story. The option is named "placeholder", and its description names the issue
- [x] A Schedule field on the Schedule template (NobleFactor project 7) and on David-Noble-at-work's Schedule copy (its
      project 1) -- 2026-11-03, made on the owner's order and read from GitHub later that evening. Each field's one
      option, placeholder, names a placeholder schedule: NobleFactor/noblefactor-engprod#443 and
      David-Noble-at-work/personal#319. Each is titled "Schedule: placeholder", is of type Schedule (the label schedule
      in personal), has Area Engineering, is open, and has no rows and no deliverable. Schedule: David-Noble-at-work's
      Schedule field came with its first schedule, personal#314 (above). So every Schedule and Scenario project and
      template in both accounts has its field now
- [x] The Triage template's readme on David-Noble-at-work's Triage copy, its project 4 -- 2026-11-03. Later that day
      all twenty projects of the four kinds were compared with their kinds' templates and made to match them, but for
      one difference (below) ([section 3's status](../../architecture/issue-data-model/3-collections.status.md))
- [x] personal's hierarchy for its issue tracking -- 2026-11-03, made on the owner's order and read back: the epic
      David-Noble-at-work/personal#317, "Epic: engprod: the process and tooling David-Noble-at-work's work runs on";
      under it the feature personal#318, "Issue tracking: David-Noble-at-work tracks its issues with NobleFactor's data
      model"; and under the feature the tasks personal#315, personal's Triage workflow, and personal#311,
      David-Noble-at-work/.github holding the account's issue model. NobleFactor's counterpart is Epic #330, Issue
      tracking, with its features #331 to #333

A ruling of 2026-11-03, recorded under question 4 below: every project of a kind is configured the same way.

- [x] Every project of a kind configured the same way -- 2026-11-03: all twenty projects compared field by field,
      option by option and view by view: NobleFactor's four templates, engprod's four projects, devlore's four, and
      David-Noble-at-work's four copies and four projects. Each now matches its kind's template in fields, Status
      options, iteration settings, views, readme and built-in workflows. The one difference left is that
      David-Noble-at-work's Triage and Backlog projects have no Area or Priority column: those are issue fields, which a
      user account can't have, and its labels stand in for them. Made to match that day, and read back: the Triage
      template's readme put on Triage: engprod, Triage: devlore and Triage: David-Noble-at-work; the Schedule and
      Scenario templates' Status descriptions put on David-Noble-at-work's Schedule and Scenario projects and copies,
      each option keeping its id, so no row lost its Status; and David-Noble-at-work's Backlog, Schedule and Scenario
      copies given the description its Triage copy has, "David-Noble-at-work's copy of NobleFactor's `<Kind>` template.
      A user account can't have templates, so a `<Kind>` project is copied from this one."
      ([section 3](../../architecture/issue-data-model/3-collections.md#four-projects-per-team))
- [x] Built-in workflows deleted from all twenty, by the same ruling -- 2026-11-03: GitHub's API can delete a project's
      built-in workflow (`deleteProjectV2Workflow`) but has no call that makes one or turns one on, so the only state
      every project can share is none. Those deleted that day were Triage: engprod's "Auto-add to project" and
      "Auto-add sub-issues to project", Triage: devlore's "Auto-add sub-issues to project", and the five each of the
      Schedule and Scenario templates: Auto-close issue, Item added to project, Item closed, Pull request linked to
      issue and Pull request merged. All were off but devlore's. Read back, none of the twenty has a
      built-in workflow now ([section 3](../../architecture/issue-data-model/3-collections.md#triage-and-the-backlog))
- [x] NobleFactor project 4, "Thread: the model follows a rename", closed -- 2026-11-04: closed by the owner, after
      Claude Code's permission check refused the agent the write; GitHub's answer read it back closed. It was made on
      2026-10-24 as the write test of #377, which is closed, and the closing of the per-schedule and per-thread
      projects on 2026-11-03 missed it; on 2026-11-04 it still had six draft rows and six built-in workflows, all on.
      NobleFactor's closed projects 9 to 22 keep five built-in workflows each, all off

Done in GitHub on 2026-11-03, and read back:

- [x] The rows of every Schedule and Scenario project kept in order, under each option the collection's own issue
      first and then its rows by Step or Beat -- 2026-11-03: Schedule: engprod's 88 rows put in that order, and
      Schedule: devlore, Scenario: engprod, Scenario: devlore and Schedule: David-Noble-at-work already in it
      ([section 3](../../architecture/issue-data-model/3-collections.md#the-schedule-and-scenario-fields))
- [x] A second view, view 2, on each of the ten Schedule and Scenario projects, templates and copies: By schedule or
      By scenario, a table grouped by its Schedule or Scenario field, with no sort -- 2026-11-03: made the same way in
      all ten through GitHub's REST API, which takes `group_by`, where GitHub's GraphQL API can't set a view's grouping
      or sort; the owner tried it and found the tab between Default and By schedule works well
      ([section 3](../../architecture/issue-data-model/3-collections.md#four-projects-per-team))
- [x] Each of the 15 Schedule and Scenario issues links its project's view 2, filtered to its own option, from the
      line that names its project -- 2026-11-03: each body read back, and the owner opened #346's link and found it
      good ([section 3](../../architecture/issue-data-model/3-collections.md) § The collection's own record: a
      Schedule or Scenario issue)

What the rulings of 2026-11-03 still wait on, read from GitHub and from the files named, on 2026-11-03. Seven
repositories have their `TRIAGE_PROJECT_URL` set, both `.github` repositories among them (below), and none of them
has `.github/workflows/triage.yml` yet, so the Triage workflow adds no new issue to a Triage project yet. NobleFactor's
five repositories now wait only on their own `.github/workflows/triage.yml`: the noblefactor-automation GitHub App's
permissions were confirmed on 2026-11-03 (below). David-Noble-at-work/personal has its `ADD_TO_PROJECT_PAT`; its
workflow is David-Noble-at-work/personal#315, step 1 of the account's first schedule (above), and that task's branch
was opened on 2026-11-03 (below).
[Section 4](../../architecture/issue-data-model/4-storage-and-reach.md) § Triage says how the workflow signs in.

- [x] personal's `ADD_TO_PROJECT_PAT`, the repository secret its Triage workflow signs in with: a classic token with
      the repo and project scopes -- 2026-11-03: made and stored
- [x] The noblefactor-automation GitHub App given organization projects read and write, to add a row to a Triage
      project, and issues write, to set the Area field -- 2026-11-03, read from GitHub that evening: its installation on
      NobleFactor has organization projects read and write, issue fields read, and issues read and write, beside
      contents write, metadata read and pull requests write, on all of NobleFactor's repositories. GitHub's list of
      GitHub App permissions puts an organization's projects under the organization permission Projects, its issue
      fields under the organization permission Issue Fields, and an issue's field values under the repository permission
      Issues. Nothing has used the new permissions yet: the first Triage workflow run in a NobleFactor repository proves
      them ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md#triage))
- [x] Both `.github` repositories take part in triage -- 2026-11-03, read from GitHub: both accept issues. The engprod
      team was given the maintain role on NobleFactor/.github that day, and its `TRIAGE_PROJECT_URL` names Triage:
      engprod. David-Noble-at-work/.github has the topic issue-model, and its `TRIAGE_PROJECT_URL` names Triage:
      David-Noble-at-work. So `TRIAGE_PROJECT_URL` is set in seven repositories: noblefactor-engprod,
      NobleFactor/.github, devlore-cli, devlore-registry, devlore.noblefactor.com, personal and
      David-Noble-at-work/.github. None of the seven has `.github/workflows/triage.yml` yet (below)
      ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md#triage))
- [ ] The Triage workflow in NobleFactor/noblefactor-engprod, whose `TRIAGE_PROJECT_URL` names Triage: engprod
      (NobleFactor project 5)
- [ ] The Triage workflow in NobleFactor/.github, whose `TRIAGE_PROJECT_URL` names Triage: engprod
- [ ] The Triage workflow in NobleFactor/devlore-cli, whose `TRIAGE_PROJECT_URL` names Triage: devlore (NobleFactor
      project 6)
- [ ] The Triage workflow in NobleFactor/devlore-registry, whose `TRIAGE_PROJECT_URL` names Triage: devlore
- [ ] The Triage workflow in NobleFactor/devlore.noblefactor.com, whose `TRIAGE_PROJECT_URL` names Triage: devlore
- [x] The Triage workflow in David-Noble-at-work/personal, whose `TRIAGE_PROJECT_URL` names Triage: David-Noble-at-work
      (David-Noble-at-work project 3): David-Noble-at-work/personal#315, which copied personal's `triage.yml` from
      David-Noble-at-work/.github's Triage workflow template
      ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md#triage)) -- 2026-11-04: merged in
      David-Noble-at-work/personal#320 as 496d1b9; the live test's issue, personal#321, became a row of Triage:
      David-Noble-at-work and got `area:engineering` from `github-actions[bot]`, by a run that completed with success,
      and #315 closed. The change also fixed the template's Area reader, which looped forever on an issue body ending at
      the Area heading ([section 4's status](../../architecture/issue-data-model/4-storage-and-reach.status.md))
- [ ] The Area reader of NobleFactor/.github's Triage workflow template fixed the same way, through a
      NobleFactor/.github pull request: the template, already merged, has the same reader
- [ ] The Triage workflow in David-Noble-at-work/.github, whose `TRIAGE_PROJECT_URL` names Triage: David-Noble-at-work.
      Read from GitHub on 2026-11-04, David-Noble-at-work/.github has no repository secret, so its workflow, when it is
      added, needs `ADD_TO_PROJECT_PAT` too. No copy of personal's token was kept, so that takes a token made for it, or
      personal's regenerated and stored in both
- [ ] A pull request template in NobleFactor/.github, part of #431, which brings NobleFactor's model file there
- [ ] A pull request template in David-Noble-at-work/.github, part of David-Noble-at-work/personal#311, which brings
      David-Noble-at-work's model file there
- [x] `chore` out of the branch-name pattern of
      [ruleset 12515090](../../github-branch-protection.md#12515090--restrict-branch-names), by the ruling of 2026-11-03
      that [development-process.md](../../guides/development-process.md) § Plans records -- 2026-11-03, by step 1 of
      this branch's script, which sent only the ruleset's rules and read the ruleset back. Its pattern is now
      `^(doc|feature|fix|hotfix|refactor|release)/.+$`, and the ruleset has no bypass list, so no branch named
      `chore/...` can be pushed. GitHub's 10 `chore/` branches in 8 NobleFactor repositories are as they were, and new
      commits to them would very likely be refused now. Eight are left over from merged pull requests.
      NobleFactor/Import-AudioCdMetadata's `chore/add-codeowners` has a pull request,
      NobleFactor/Import-AudioCdMetadata#1, open since 2026-02-03. noblefactor-engprod's `chore/320-labels-file` has no
      pull request and was last committed on 2026-10-20. On the owner's machine, the worktree for dependency updates,
      #403, is on `chore/403-dependency-update`, which has never been pushed
- [ ] `chore` out of `git open-branch`, by the same ruling: the script, its man page and its bash and zsh completions.
      Read on 2026-11-03, all four still accept it: `Home/common/.local/bin/git-open-branch` at lines 100, 110, 168 and
      169, in its comment, its label map, its check of the type and that check's error message;
      `Home/common/.local/share/man/man1/git-open-branch.1` at lines 81, 93 and 136;
      `Home/common/.local/share/bash-completion/completions/git-open-branch` at line 15; and
      `Home/common/.local/share/zsh/site-functions/_git-open-branch` at line 10
- [ ] The [PR script template](../../guides/pr-script-template.md)'s schedule step and its rule 13 brought up to date.
      Both still record a lane by rewriting its row in a table in the schedule issue's body. Those tables were retired
      on 2026-11-03, so the step would find no row and stop the script. How a pull request's script records its steps
      now waits on the question that rule 19 of [agent-rules.md](../../guides/agent-rules.md) leaves open: what each
      record is guarded on
- [ ] A step in the PR script template for the record a worktree's first script makes: pushing the branch, then
      linking it in the Worktree column of each of its steps' rows. The template has none yet

### Iteration 4: attributes

Severity, Priority and Area in the asset and pushed everywhere; the audit's attribute rules.

- [ ] Questions 11 and 14 ruled, then 2 and 12; section 2 revised
- [x] devlore-cli's attribute labels pulled into the asset's tiers and pushed to every participating repository --
      superseded 2026-11-03: the model holds labels per repository, with no tiers (question 16), and devlore-cli has no
      attribute label left: its seven finer `Area:` labels were deleted, and its `Severity:` and `Priority:` labels
      moved into the Severity and Priority fields.

### Iteration 5: the switch and the retirement

The markers, the kind labels, the lane tables and the `Epic:` labels retired, and the old reading removed from the
tooling, on a date when the sessions are clear. In GitHub, all four retired on 2026-11-03, as recorded under the
cutover above; NobleFactor's kind labels are gone, and David-Noble-at-work keeps its type labels, which are its types.

- [ ] [issue-standards.md](../../issue-standards.md) states the model in full
- [x] #303 retitled and its body brought to the model, with the owner's approval -- 2026-11-02 and 2026-11-03: retitled
      The GitHub issue data model: its design, for organization and user accounts, and rescoped to the design
- [x] The old scheme retired in GitHub -- 2026-11-03, as recorded under the cutover above
- [ ] Status `complete`

### Closing, from 2026-11-04

The owner, 2026-11-04: the data model has no gap that keeps it from going live, and #303 is to be wrapped up now, with
#446 and then #447 after it. Going live is rollout work under #333. Closing takes four steps, in this order.

- [x] **The rulings.** Six questions, all ruled by the owner on 2026-11-04 as proposed here, with Severity N/A added to
  the second, the fifth narrowed to tasks and bugs, and the sweep chosen for the sixth:
  1. How an issue moves between its team's projects, and who moves it: questions 4 and 9, which the owner widened on
     2026-11-04 to who may move an issue and how work in the Backlog reaches a schedule. Any member of a team can see
     all of the team's issues and do all of its work in its four projects: triage, the backlog, scheduling and
     scenarios. So the one grant a new participant needs is membership in the team, whose roles carry the rest: the
     maintain role on each repository the team owns, which engprod and devlore have, and the write role on each of its
     four projects, which the script below sets. A user account has no teams; there, a new participant is a
     collaborator on the repository and a writer on each of the account's four projects. An issue is a row of at most
     one of its team's Triage, Backlog and Schedule projects and is on at most one schedule; a feature can also be a
     row of the Scenario project, in any number of scenarios; the sweep returns an issue that breaks this to its
     team's Triage project (ruling 6). Every move is one act: the issue gets its row in the project it goes to, with
     that project's fields set, and loses its row in the project it leaves. Out of Triage, declined work is closed as
     completed with Resolution Declined, and accepted work goes to the Backlog with its Priority, onto a schedule, or,
     for a feature, to the Scenario project. From the Backlog, work goes onto a schedule highest Priority first, with
     the schedule's option, the next step or the step the schedule's owner gives it, Status Open and its blocked-by
     links. A committed schedule takes it only by its owner's amendment, recorded in the Schedule issue.
     `star github schedule add` (#438) will make this move in one command.
  2. A task has no severity; it has a priority (question 11). Severity applies to bugs only, and every issue of another
     type has Severity N/A: in NobleFactor, a new option N/A of the Severity issue field, and in David-Noble-at-work a
     new label, `severity:n/a`. A bug has Critical, High, Medium or Low, never N/A. An issue with no type yet waits for
     triage. At filing, `star github issue` sets N/A (#338), and the Triage workflow sets it on an issue filed from a
     form. The Triage workflow also gives a bug filed from the bug form, which asks no severity, Severity Medium: the
     owner's default, which GitHub's field can't hold. Triage changes it when the bug's harm is greater or less.
  3. A scenario changes no issue's priority; triage sets each issue's Priority (question 12).
  4. An issue states its evidence of completion in its Evidence of completion section, which every issue form has. At
     filing, the form checks it, and `star github issue` will (#338).
  5. `good first issue` goes on tasks and bugs only. The label tells a newcomer that they can pick the issue up, and
     only a task or a bug is a single piece of work; an epic or a feature is a body of work. This replaces section
     2's Epic, Feature, Task and Bug, with Schedule and Scenario open. personal gets the label, so that both accounts
     hold it; read on 2026-11-04, no issue in a participating repository carries it.
  6. The sweep checks the attribute rules (#436). It returns to its team's Triage project any open issue that breaks
     one, as it returns an issue that isn't fully classified: an issue with no Area; a bug whose Severity is N/A or
     blank, or an issue of another type whose Severity isn't N/A; a Resolution on an open issue; two labels of one
     attribute, such as two `priority:` labels, in David-Noble-at-work, where labels stand in for fields; and
     `good first issue` on an issue that isn't a task or a bug. Nothing blocks a filing and nothing corrects itself:
     triage fixes the issue by hand. The sweep runs every day, as a scheduled GitHub Actions workflow in each account's
     `.github` repository with the credentials the Triage workflow uses, and it comments on each issue it returns,
     naming the rule the issue broke (ruled 2026-11-04). Wherever the design says that the audit reports a fault, the
     sweep returns the issue to Triage instead. #361 closes. The two faults it first named belong to the scheme
     retired on 2026-11-02 and 2026-11-03. Of the four its comment of 2026-10-23 added, the sweep takes a parent not
     one level up, two went with the collection and triage epics, and a hierarchy type whose description names no
     level belongs to pull and push (#426 and #437), as question 18 has it. The attribute fields and labels were made
     in GitHub on 2026-11-03, N/A and personal's
     `good first issue` come with the script below, and keeping them in step belongs to `star github model pull`
     (#426) and `push` (#437).
- [x] **The issues,** filed and read back before the pull request opens -- 2026-11-04, each read back:
  - on issue tracking, iteration 1 (#346), under the rollout feature (#333):
    - step 33, #448, the Triage workflow in noblefactor-engprod, .github, devlore-cli, devlore-registry and
      devlore.noblefactor.com, blocked by #447, with both accounts' Triage workflow templates and personal's workflow
      setting Severity N/A on an issue that isn't a bug and Medium on a bug filed from the bug form;
    - step 34, #449, `chore` out of `git open-branch`, its man page, its bash and zsh completions and its test, and
      the branch type taken from the issue's type, or its type label in a user account (approved 2026-11-04);
    - step 35, #450, the PR script template recording a pull request's steps in the Schedule project, the first
      script's Worktree link among them, which carries the question rule 19 of agent-rules.md leaves open;
  - in Backlog: engprod with Priority Low, under #333: #451, the credentials and permissions issue tracking runs on,
    listed in one place with when and how each is renewed: the noblefactor-automation app's private key, personal's
    `ADD_TO_PROJECT_PAT`, the token David-Noble-at-work/.github will need, each team's roles, and the scopes star
    needs;
  - David-Noble-at-work/personal#311 took David-Noble-at-work/.github's Triage workflow and its token, with #441
    tracking it in NobleFactor, and its two sentences that predated the model were corrected;
    David-Noble-at-work/personal#309 was retitled and its body brought to the model; #426 and #437 gained the
    account's issue fields in their titles and bodies; #338, #436, #303 and #439 got their comments, #303's recording
    the rulings and #439's taking the two questions agent-rules.md left open on #303 (approved 2026-11-04); and #361
    was closed as completed with Resolution Declined, its row on Schedule: engprod Closed.
- [ ] **The pull request,** on `doc/303-data-model-closing`: the rulings recorded in sections 1, 2, 3, 4 and 7, their
  status files, the index and issue-standards.md, in place of the sentences left open to be ruled on #303, rule 19 of
  agent-rules.md and rule 13's note in the PR script template pointing at #450, and agent-rules.md's two questions
  at lines 60 and 88 pointing at #439;
  issue-standards.md without "It is not a chore." and read against the design for anything it lacks; every unchecked
  item of this plan ticked, as done or naming the issue it moved to (below); and this plan's status `complete`. It
  also carries the two items below, which the owner asked for on 2026-11-04 so that #303 closes knowing every
  workflow is supported and what to grant should someone else take part in triage and scheduling.
- [ ] **Who can do what,** a table in issue-standards.md, which the design links to: each workflow, filing, triage,
  the backlog, scheduling and scenarios; what it changes in GitHub, such as an issue's type, parent, fields and
  blocked-by links, and a project's rows and fields; the least role GitHub's documentation gives for each change, with
  the page that says so; and what to grant a new participant in each kind of account.
- [ ] **Every workflow checked,** a table in section 3's status file: the five workflows, what each needs in GitHub,
  its projects, fields, views and roles, and whether GitHub has it, read back on the day. Anything missing is made by
  the script or named with the issue that makes it. Read on 2026-11-04: the Backlog projects have one view and no
  sort, so nothing shows the Backlog ordered by priority, and David-Noble-at-work's Backlog has no Priority field to
  sort by; no NobleFactor repository runs the Triage workflow yet, which waits on #447 and step 33; and 83 open bugs
  have no severity, 77 in NobleFactor and 6 in personal, which is triage's work.
- [ ] **The pull request's script,** run by the owner:
  - gives engprod the write role on Triage: engprod, Backlog: engprod, Schedule: engprod and Scenario: engprod
    (projects 5, 25, 26 and 27), and devlore on its four (6, 28, 29 and 30). GitHub's API sets a team's role on a
    project but cannot read one, so the script checks that each call succeeded;
  - adds a view named By priority, sorted by Priority, to Backlog: engprod, Backlog: devlore and the Backlog template
    (projects 25, 28 and 24), since GitHub's API sets a view's sort only when it makes the view;
  - gives NobleFactor's Severity field its N/A option through GitHub's REST call,
    `PATCH /orgs/NobleFactor/issue-fields/{issue_field_id}`, sending each existing option with its ID. The GraphQL
    call takes no option IDs, and GitHub's REST documentation warns that options sent without one may be deleted and
    recreated. The script reads back that every Severity value is still held;
  - makes the label `severity:n/a` in personal and David-Noble-at-work/.github, and the label `good first issue` in
    personal with the color and description David-Noble-at-work/.github's has;
  - sets N/A on every open issue whose type is not Bug, read on 2026-11-04: 412 in NobleFactor and 36 in
    David-Noble-at-work, among them the 5 tasks and 2 features in devlore-cli that carry a severity from its old
    labels;
  - deletes the Triage rows of the 28 open issues that are also rows of their team's Schedule project, read on
    2026-11-04: 19 of engprod's, #303 among them, and 9 of devlore's;
  - merges the pull request and closes #303, its row on Schedule: engprod set to Closed.

Where the 25 unchecked items go:

| Items | Where |
| --- | --- |
| Question 18 ruled | done: ruled 2026-11-03, and what is left is #426's and #437's |
| Questions 5 to 9 ruled; questions 11, 14, 2 and 12 ruled | the rulings above; 9, 11 and 12 were the ones left |
| This design and issue-standards.md stated without Chore; issue-standards.md states the model in full; status `complete` | the pull request |
| Rolled out: every open issue typed and linked, the report placing it by type and link | #365 |
| The crossings removed | #428 |
| personal's own Triage project and schedules | David-Noble-at-work/personal#309 |
| The reference models; each account's model read on demand | #425 and #426 |
| `star github issue` refuses an issue without an Area | #338 |
| A scheduled sweep returns an issue without an Area to Triage | #436, which also checks the attribute rules (ruling 6) |
| The Area reader of NobleFactor/.github's Triage workflow template | #447 |
| A pull request template in NobleFactor/.github | #431 |
| A pull request template and the Triage workflow in David-Noble-at-work/.github | David-Noble-at-work/personal#311, tracked by #441 |
| The forms' Area reaching the Area field, and the Triage workflow in five NobleFactor repositories | #448, step 33 |
| `chore` out of `git open-branch` | #449, step 34 |
| The PR script template's schedule step and rule 13, and its first-script record | #450, step 35 |

## Migration Path

[Section 5](../../architecture/issue-data-model/5-from-todays-scheme.md): documents first, then tooling that reads
both schemes, then new data beside the old, then migration one repository at a time, then the switch, and the old
scheme retired last.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/303-issue-data-model.md` | Create | this plan |
| `docs/architecture/issue-data-model/` | Create | the design: its index, six sections and their status companions; section 6, the asset and its sync, added 2026-10-22 on the owner's "Doc it" |
| `docs/issue-standards.md` | Modify | states the model, once ruled |
| `docs/guides/development-process.md` | Modify | the rulings of 2026-11-02 and 2026-11-03: types without Chore, the four projects, steps and scenarios, Triage, file templates and the `chore/` branch type |
| `docs/guides/agent-rules.md` | Modify | rules 2 and 3 with the `Epic:` and `Thread:` labels removed, rule 13's pull request template, and rule 19's steps, Worktree column and second breakage |
| `docs/guides/pr-script-template.md` | Modify | the pull request template in the description block and rule 2; rule 13 and the schedule step marked out of date |
| `docs/github-branch-protection.md` | Modify | NobleFactor/.github and its `quality-gate` check; ruleset 12515090 without `chore`, as GitHub has it since 2026-11-03 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/model.yaml` | Modify | the asset, pulled again 2026-11-02 with Chore retired |
| `.../com.noblefactor.ops.GitHub/reference/organization.yaml`, `reference/user.yaml` | Create | the two reference models (#425) |
| `.../com.noblefactor.ops.GitHub/commands/scheme.star`, `github-schedule-report.star`, `extension.yaml` | Modify | schedules and threads found by title; tier two worded from the asset |

## Related Documents

- NobleFactor/noblefactor-ops#156 (feature): issue standards, the scheme and the documents that state it
- NobleFactor/noblefactor-ops#176 (feature): the hierarchy in GitHub's sub-issues and issue types, with "threads and
  schedules stay ours", which this design overturns
- NobleFactor/noblefactor-ops#319 (bug): the report splits a lane table at an escaped pipe; moot for schedules once
  rows replace tables
- NobleFactor/noblefactor-ops#320 (chore): the labels file and the issue-labels design
- NobleFactor/noblefactor-ops#330 (epic): Epic: Issue tracking, with its features #331 (the data model), #332 (the
  tooling) and #333 (the rollout)
- NobleFactor/noblefactor-ops#304 (task, in #333): noblefactor-ops becomes noblefactor-engprod, "the repository of
  NobleFactor Engineering Productivity"
- NobleFactor/noblefactor-ops#142 (epic): Epic: Process, the one epic that never closes
- NobleFactor/noblefactor-ops#301 (schedule): the prototype's subject
- [issue-standards.md](../../issue-standards.md) and [development-process.md](../../guides/development-process.md)
- [Agent schedules](../../architecture/agent-schedule/index.md): sessions are keyed by their schedule's issue

## Open Questions

1. **Type: GitHub's issue type, or a label family.** The owner named the field Type and invited alternatives; the same
   day, labels were settled as the hierarchy's classifier. GitHub's issue type is a field named Type that reaches only
   the organization's repositories. Options: (a) labels everywhere, the family called Kind so that it is not mistaken
   for GitHub's Type, its five names as today's; (b) GitHub's Type in the organization's repositories and labels in
   personal, kept in step by star; (c) GitHub's Type everywhere, personal's tracked work moved into an organization
   repository. Proposed: (a), and (c) if personal's tracked work moves. **Ruled 2026-10-22:** "we are building a
   3-tier hierarchy modeled with the parent-child relation between issues, so yes. Our hierarchy is based on epics
   that contain chores and features that contain bugs and tasks. It is a very specific hierarchy based on Issue Type."
   So Type is GitHub's issue type, Epic and Chore added to the organization's Task, Bug and Feature, and the parent
   is GitHub's sub-issue link. The issue type does not reach a user's repository; the sub-issue link does (question
   13). For personal, 32 open issues on 2026-10-22, **ruled
   2026-10-22:** "Star gh offers directed syncs. Person[al] will need to sync if it wants to participate." So (b):
   labels in personal, the organization's types and links the record of truth, and `star gh` syncing one way, from
   the organization's record to personal's labels. Question 1 is closed. **Ruled 2026-11-02:** Chore is retired, and
   the hierarchy is Epic (level 0), then Feature (level 1), then Task or Bug (level 2). **Ruled 2026-11-03:** the issue
   that describes a schedule project has the type Schedule, and the issue that describes a thread project has the type
   Thread; issue types are capitalized and labels lowercase. **Superseded 2026-11-02** by question 17: each account
   has its own data model and no link crosses accounts, so personal's type labels and sub-issue links are its own, and
   nothing syncs them from the organization's record. **Superseded 2026-11-03:** Thread is renamed Scenario, and a
   Schedule or Scenario issue describes a schedule or a scenario, not a project; each team has one Schedule project and
   one Scenario project.
2. **How long a level-1 issue lives.** Today a feature ships and closes, and its epic closes when its features do.
   Gemini's write-up proposes that features and chores stay open for the life of what they deliver, a bug in shipped
   work parented to the original, so that its whole cost can be counted. Options: today's lifecycle, a bug in shipped
   work finding a current parent at triage; or long-lived level 1. Not proposed: it changes what "done" means for a
   feature. Chore was retired on 2026-11-02, so level 1 is Feature alone.
   **Ruled 2026-11-03:** a feature stays open after its tasks and bugs are done. It closes only after an agent has
   audited it for compliance and an agent has reviewed its code, with the team lead's sign-off. Closed.
3. **The standing engineering epic.** Every chore needs an epic. Proposed: #142, Epic: Process, renamed for
   engineering, and open for good, as it is today. **Ruled in part, 2026-10-21:** "I do not thin[k] that we need to
   have a home for chores anymore. we can create an epic in any repo and create features and chores with bugs and
   tasks to our heart's content. I think we must either repurpose #142 or close it as <something>." Then: "#142 is
   basically our triage epic. i'm surprised it's not bigger than 90. These are things discovered over the course of a
   month that are bugs, gaps (missing parts of chores/features), and suspicious behaviors/implementation." So no
   standing epic, and no rule that every repository carries `Epic:Ops:Process`. GitHub's close reasons are completed,
   not planned and duplicate, and no other (gh 2.103.0). **Ruled 2026-10-22:** "We need a triage epic. it is the
   place to put all new logged issue, pending assignment to a place in our issue hierarchy. It should be added as row
   zero in the schedule that represents the triage project. We can use this to guide the work and--maybe--facilitate
   handoffs." #142 is the triage epic, row 0 of the Triage project, and the parent of every newly logged issue until
   triage places it. Closed.
   **Superseded 2026-11-03:** a Triage project has no triage epic. NobleFactor/noblefactor-engprod#142,
   NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313 are retired, and a new issue of any kind goes into
   its team's Triage project until it is classified. The premise that every chore needs an epic went with Chore,
   retired 2026-11-02. **Ruled 2026-11-03:** an issue that was not done is closed as completed, and why is recorded
   where the account can hold it. In NobleFactor, an organization, it is the Resolution issue field, a single-select
   field with the options Declined, Duplicate and Invalid; NobleFactor's 12 repositories have no `resolution:` labels,
   deleted from them on 2026-11-03, and no `duplicate` or `invalid` labels. In David-Noble-at-work, a user account
   with no issue fields, it is a label: `resolution:declined`, `resolution:duplicate` or `resolution:invalid`, the last
   two replacing the `duplicate` and `invalid` labels there. There is no `wontfix` or `declined` label, and GitHub's
   not planned close reason is not used. A resolution goes only on a closed issue; the model records it, the
   Resolution field among an organization's issue fields and the `resolution:` labels among a user account's labels,
   and the audit reports one on an open issue.
   **Ruled 2026-11-03:** an account's model holds its issue fields, as it holds its issue types and labels, so the
   Resolution field is among NobleFactor's (question 14). Closed.
4. **Triage.** Proposed: untriaged is a state, not a place: an issue with no Type or no parent. Whoever files it does
   nothing more, the audit exempts it from the parent rule and reports its age, and the triage team works the query.
   Open: who the team is, and with what role. GitHub's Triage role exists for the organization's repositories; whether
   it can set types and parents is unverified, and personal has collaborators rather than roles. **Ruled 2026-10-21:**
   "I would say then that we fully classify the issue or not and allow that any issue can be added to the Triage
   project. Issues sent for review by triage are those added to the Triage project. The Triage project is a little
   like a Schedule or a Thread, but it allows any issue type: Epic, (Chore | Feature), (Bug | Task), or no Issue Type.
   We can always search for specific issues based on no:type, no:parent-issue, etc. These issues can be periodically
   added to the Triage project." So: an issue is fully classified or it is not; the triage queue is a third
   collection, the Triage project, whose rows may be of any type or none; what is sent for review is what is added to
   it, by a person or periodically from the queries. **Ruled 2026-10-22, the team:** "Teams triage their issues. I
   happen to be on every team. If devlore-cli logs issues against noblefactor-engprod, they should log a tracking
   issue or retain ownership of the issue on noblefactor-engprod. So keep the issue on your plate or move it and maybe
   track it on another team's triage schedule." The triage team of a repository is the team that owns it, one Triage
   project per team, the owner on every team today. Closed.
   **Ruled 2026-11-03:** every new issue, of any kind, goes into its team's Triage project until it is classified;
   each team owns its Triage project, and a user account owns its own. The three are Triage: engprod (NobleFactor
   project 5), Triage: devlore (NobleFactor project 6) and Triage: David-Noble-at-work (David-Noble-at-work project 3).
   New ones are copied from the Triage template (NobleFactor project 23) or the account's copy (David-Noble-at-work
   project 4). **Ruled 2026-11-03:** new issues reach their team's Triage project through a GitHub Actions workflow
   in each repository, run when an issue is opened or transferred, using `actions/add-to-project`; GitHub's built-in
   auto-add workflow is not used. Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project,
   from the team mapping: the team with the maintain role on a repository owns it. A Triage workflow template in each
   account's `.github` repository offers the workflow. The team that owns a project is accountable for it, and
   GitHub's link between a project and its team is the record; a user account's projects are its owner's. The Triage
   project is where every issue is reviewed and a triage decision made: the work is declined, and the issue closed as
   completed with Resolution Declined in NobleFactor or the `resolution:declined` label in a user account, or the
   issue moves to the team's Backlog, Schedule or Scenario project.
   Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time.
   **Ruled 2026-11-03:** every project of a kind is configured the same way. Read from GitHub's GraphQL schema that
   day, the API can delete a project's built-in workflow, with `deleteProjectV2Workflow`, but has no call that makes
   one or turns one on, so the only state every project can share is none. Every built-in workflow of the twenty
   projects of the four kinds was deleted that day, and none of the twenty has one now (the cutover, above). This
   settles the question about Triage: devlore's "Auto-add sub-issues to project" workflow, which was on. It was
   deleted with the rest ([section 3](../../architecture/issue-data-model/3-collections.md#triage-and-the-backlog)).
5. **A collection's own record: row 0, or the project's README.** Options: (a) row 0 is the collection's own issue, as
   the owner proposed on 2026-10-20, its body holding the deliverable and the rulings, its assignee the owner, and
   sessions keyed by it as today; it needs an exemption from "every issue must be fit into this hierarchy", as
   schedule and thread issues have from the epic rule today; (b) no row 0: the project's README holds the deliverable
   and the rulings, and sessions are keyed by the project. Proposed: (a). Start-Claude's store and
   star-gh-assignment keep their keys, which section 5 needs. **Ruled 2026-10-22:** (a), and row 0 is an Epic, which
   needs no exemption because level 0 has no parent; the owner: "If you accept that a schedule is just a
   sequentially-numbered list of bugs and tasks that must be closed, a good question to ask is where do we keep status
   on the schedule? I might like to fully report my status on the issue at row 0. We work issues in the list starting
   at row 1. We keep our head straight and provide some insight to casual observers/owners/participants/reviewers by
   way of row zero. The question becomes: what is the issue type for row 0." Then, of the recommendation that row 0 be
   an epic, a collection epic told from a hierarchy epic by its being row 0: "I approve your recommendation."
   [Section 3](../../architecture/issue-data-model/3-collections.md) § The collection's own record. Closed.
   **Superseded 2026-11-03:** the collection's own issue is no longer an Epic told apart by its row. Its type is
   Schedule or Scenario, the label `schedule` or `scenario` in a user account, whose description begins "Collection:"
   rather than "Level N:"; Scenario was named Thread until 2026-11-03. A Schedule issue holds its schedule's
   deliverable and exit criteria, a Scenario issue tells its scenario's story, and each type has an issue form in the
   account's `.github` repository. A Schedule issue's own row in its team's Schedule project has no step (ruled
   2026-11-02 and 2026-11-03).
   Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
   Scenario are its two peers there.
6. **Lane numbers, now step numbers.** Proposed, and superseded: row 0 is the collection's own issue (question 5),
   and steps 1..N follow it, so that today's step numbers carry over. The tool that adds a row numbers it. GitHub
   projects have no number that counts by itself, so a row added in GitHub's interface has none, and the audit reports
   it. **Ruled in part 2026-11-02:** the number is Step, steps 1 to N, and the first row, the collection's own issue,
   has none. **Ruled 2026-11-02:** a schedule's own issue is its project's first row and has no step. Every other row
   gets its step number and its dependencies, as GitHub blocked-by links, when it is added, by whoever adds it, in
   GitHub's interface or with star. Steps are worked in step order. Closed.
7. **A row's status.** GitHub's built-in workflow can mark a row Done when its issue closes, and closed is not done:
   step 13 of #301 was closed on 2026-10-20 with two hosts not migrated. Proposed, and superseded: star derives the
   status, and no GitHub workflow sets it. **Ruled 2026-11-02 and 2026-11-03:** Status is a field on a project row,
   and anyone may set it. A project's built-in workflows are not part of the model; they are fixed GitHub functions
   that the owner switches on or off by hand. Every issue states its evidence of completion. Closed.
   **Superseded in part 2026-11-03:** none of the twenty projects of the four kinds has a built-in workflow now, since
   every project of a kind is configured the same way and GitHub's API can't make one (question 4).
8. **Adding a row to a committed schedule.** Today no step is added once a schedule is committed, except by the owner's
   amendment. Proposed: unchanged; one star command adds the row and writes its amendment together. **Ruled
   2026-11-02:** a row added to a committed schedule gets its step number and its blocked-by links when it is added.
   A working issue tracking system on GitHub comes first and tooling follows, so adding the row and its amendment by
   hand in GitHub must work before any star command does both.
9. **One issue in two live collections.** The owner, 2026-10-20: "5 give me pause." A project cannot prevent it.
   Proposed: forbidden for schedules, where the audit reports it; allowed for scenarios, which were named threads until
   2026-11-03, since one feature can serve two use cases.
10. **Who joins which collection.** As the stakes say: a thread's rows are features, and chores until Chore was
    retired on 2026-11-02; a schedule's are tasks and bugs. Two deltas: today a thread's members are leaves, and the
    owner's note of 2026-10-20 let a step be any type.
    **Ruled 2026-11-03:** threads are renamed scenarios, and a scenario's rows are features; a schedule's rows are
    committed tasks and bugs. Closed.
11. **Severity on a task.** The owner's question. Proposed: none. Severity measures the harm a defect does; a task is
    planned work, and what it has is priority.
12. **How a scenario influences priority.** Open.
13. **Parent links across repositories and owners.** GitHub's sub-issue link, or the `**Feature:**` marker. Unverified:
    whether a sub-issue may live in another repository (#176), or in another owner's repository, as personal's do.
    Proposed: a write test before section 4 is ruled. **Ruled 2026-10-22,** with question 1: the parent is the
    sub-issue link. Already in use: 66 of noblefactor-ops's 89 open issues carried one on 2026-10-21, created under the
    owner's account on 2026-10-20 and 2026-10-21, #266 holding 43 under #142. Still unverified: whether the link crosses
    into another repository or another owner's, which the write test settles; until it does, the marker stays as the
    cross-repository form. **Tested 2026-10-22, on the owner's "we need to test that now":** the link crosses both.
    noblefactor-ops#355, a closed duplicate, took NobleFactor/devlore-cli#918 and David-Noble-at-work/personal#157 as
    sub-issues, both read back, both removed; recorded on #355. Closed. **Ruled 2026-11-02** (question 17): no
    sub-issue or blocked-by link crosses accounts, and work that waits on another account uses a stand-in issue in its
    own account. A link across repositories of one account still stands.
    **Ruled 2026-11-03:** the old scheme's last three pieces retire now, and the retirement is done in GitHub. The
    parent markers and schedule footers came out of 725 issue bodies, 47 issues got the sub-issue parent their marker
    named, and the link stands where the two disagreed. The step and beat tables in 14 Schedule and Scenario issues
    gave way to a line naming the issue's board and option. The kind labels epic, feature, task and bug left
    NobleFactor's 12 repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its
    type labels, which are its types. Closed.
14. **GitHub's issue fields NobleFactor already has:** Priority, Effort, Start date and Target date. None reaches
    personal. Proposed: Priority as labels, one record of it; the other three outside the model until a need appears.
    **Ruled 2026-11-03:** issue fields are used wherever an account has them. NobleFactor holds priority, severity
    and area as issue fields and uses its Priority, Effort, Target date and Resolution fields, but not Start date,
    since each issue's history records when work really started. David-Noble-at-work has no issue fields, so it uses
    the `priority:`, `severity:`, `effort:`, `area:` and `resolution:` labels. Priority and area apply to issues of
    every type, Schedule and Scenario included (ruled 2026-11-03).
    **Ruled 2026-11-03:** an account's model holds its issue fields, as it holds its issue types and labels.
    NobleFactor's are Priority, Effort, Target date, Resolution and Area; Start date stays unused. A user account has
    none. Area has two values only, Product and Engineering in NobleFactor's field and `area:product` and
    `area:engineering` in a user account's labels, and a blank Area is an error. Closed.
    **Ruled 2026-11-03:** Severity is an issue field of the organization, in NobleFactor, with the values Critical,
    High, Medium and Low; it was made that day, and NobleFactor's issue fields are now Priority, Effort, Start date,
    Target date, Resolution, Area and Severity
    ([section 2](../../architecture/issue-data-model/2-attributes.md) § The attributes). Closed.
15. **The asset and its sync**, added and ruled 2026-10-22: the model travels as `model.yaml` beside the extension and
    drives it; `star gh model pull` rewrites the asset from GitHub's record and `push` brings a repository's labels to
    the asset; every `star gh issues` operation reads the record first, by ETag. The owner: "Use the etag. Offer pull
    and push as star gh commands." Then, of the proposed syntax and file: "That's great. Doc it."
    [Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md). **Superseded 2026-11-02 and
    2026-11-03:** each account's model file is stored in that account's `.github` repository, NobleFactor/.github and
    David-Noble-at-work/.github. The model is a cache: star queries it instead of asking GitHub the same questions
    again, and builds its queries and updates from it. Pull comes first, then push. Pull reads the whole model of any
    account, ours or not, every repository the account owns, and has no `--repo` option. Its `--account` option names
    the account and defaults from star configuration's `github.account`, which defaults to NobleFactor; `--asset`
    names the model file. Push writes a model to an account, not a repository's labels, and that model becomes the
    account's data model. Whether star reads GitHub by ETag before every operation or answers from the model until the
    next pull is decided with #426 and #437, as are `--asset`'s default and what push writes: views, `--repo` and
    `--account`'s default.
16. **Organization, then teams, then repositories**, added and ruled 2026-10-22: "I would like as much as possible to
    be drawn from the org: NobleFactor by default. We then look to teams, and finally repositories." Types and projects
    are the organization's; ownership and the triage role are a team's; labels are a repository's, so they get the
    precedence in the asset's three tiers. **Superseded 2026-11-03:** labels are held per repository, and an
    organization's default labels are not part of the model, so the model has no organization or team tier of labels
    and no precedence between tiers; it holds the labels of each repository the account owns.
    [Section 4](../../architecture/issue-data-model/4-storage-and-reach.md) § Where each part is defined. A custom
    property marking participating repositories, and a version of the model, were proposed and set aside the same
    day: "Versioning is too complex. ... I don't think we need to worry about who's participating. We ask that
    question when we need to know: when building and reporting on schedules and threads or creating a new issue."
17. **A person's repository and an organization's records**, added 2026-11-02. No organization would let a person put
    issues from a personal repository in its projects, and the model must not need it. On
    2026-11-02, 26 personal issues were sub-issues of NobleFactor issues, 12 of them open; 58 were rows of NobleFactor
    projects, 36 in Triage: engprod and 22 steps of five schedules; and two blocked-by links crossed between them.
    Proposed: nothing in an organization's records points at a personal repository, no project row, sub-issue link or
    blocked-by link; personal keeps its own hierarchy, its types as labels, its own triage epic, and its collections in
    projects its owner's account owns; work that crosses is a tracking issue on each side, naming the other by URL, as
    the owner ruled for teams on 2026-10-22 (question 4). Open: personal's steps on the organization's schedules, each
    a tracking issue in an organization repository or its work moved into one. **Ruled 2026-11-02:** organizations and
    individual accounts are separate; each has its own projects, labels and data model, no project spans two, and every
    account, of however many, has its own `model.yaml`
    ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md) § Accounts). Open: whether sub-issue and
    blocked-by links stay within an account too, proposed yes; how work that touches two accounts is tracked, proposed
    an issue in each naming the other by URL; personal's steps on NobleFactor's schedules; and where each account's
    model file lives. **Settled 2026-11-02:** no link crosses accounts, and work that waits on another account always
    uses a stand-in issue in its own account, so the wait is a blocked-by link inside the account; personal's
    steps move to schedules personal owns, one per NobleFactor schedule they came from; the model is the same in both
    kinds of account, with four deviations from what an individual account lacks, and star tells the two apart by the
    repository's owner; and no account's model is kept in a file: two reference models live beside the extension, and
    each account's model is GitHub's record, read on demand.
    [Section 4](../../architecture/issue-data-model/4-storage-and-reach.md) § Accounts and
    [section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) § Reference models, read on demand.
    **Revised the same day, and ruled 2026-11-03:** each account's model is stored in its own public
    `.github` repository, NobleFactor/.github and David-Noble-at-work/.github, both of which now exist (#431,
    David-Noble-at-work/personal#311). The model is a cache that star queries instead of asking GitHub the same
    questions again. Pull reads the model of any account, ours or not, and a model pushed to an account becomes that
    account's data model. [Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) is revised on
    this branch, under #303. **Ruled 2026-11-03:** a user's account has no issue fields, so priority, severity,
    effort, area and resolution are labels there, a fifth deviation. Personal has no triage epic:
    David-Noble-at-work/personal#313 is retired, and personal's new issues go into Triage: David-Noble-at-work
    (David-Noble-at-work project 3) until they are classified. Closed.
    **Ruled 2026-11-03:** a user account and an organization have exactly the same data model, apart from what GitHub
    offers organizations only; in a user account, which has no issue fields, a label stands in for each single-select
    issue field, one per option, named `<field>:<option>` in lowercase
    ([section 4](../../architecture/issue-data-model/4-storage-and-reach.md) § A user account).
    **Ruled 2026-11-03:** David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's
    steps go on them. The first, David-Noble-at-work/personal#314, Schedule: issue tracking, iteration 1, was made that
    day, with personal#315, the task that adds personal's Triage workflow, as its step 1 (the cutover, above). Closed.
18. **How an account takes part in the model, and keeps to it**, added 2026-11-02. Adopting the model is a deliberate
    push by the owner, made when they choose or never; the code assumes nothing about an account not pushed to; and
    when a change made in GitHub is picked up is decided with #426 and #437. That leaves two questions: whether a
    participating account's change broke something, and whether an account that does not participate complies.
    **Ruled 2026-11-03:** pull reads the data model of any account, ours or not, and push writes a
    model to an account, which becomes that account's data model. What the audit compares an account against, and
    what pull does with an account whose type descriptions lack "Level N:", are decided with #426 and #437.
    Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an
    organization, or when it has the topic issue-model, in a user account.
