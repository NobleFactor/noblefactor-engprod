---
title: "The GitHub issue data model: one hierarchy, its attributes, and the collections that order it"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/303
status: draft
created: 2026-10-21
updated: 2026-10-21
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
carries and how it is ordered. An issue has one Type: Epic, then Feature or Chore, then Task or Bug. It has one parent,
one level up, except an epic; an issue with no Type or no parent is untriaged, and the triage queue is the set of such
issues. Its attributes are labels defined in noblefactor-ops. Threads and schedules are GitHub projects: a thread
orders features and chores to tell a use case, and a schedule orders tasks and bugs in the order they are worked. The
design ends with the deltas from today's scheme, from which the task list is drawn once the owner has ruled, ordered
into pull requests that take nothing in use down.

## Schedule

Lane 3 of Schedule: issue tracking, iteration 1, NobleFactor/noblefactor-ops#346, since 2026-10-21; it waited on lane
1, #358, which merged in #370 that day. Before that, not on a schedule: this plan's session wrote the design and the
owner said another session would do the work (2026-10-20, above).

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

### Phase 2: The review

- [ ] Each open question ruled, quoted with its date.
- [ ] The design revised to the rulings, and its status companions set.

### Phase 3: The task list

- [ ] Requirement 3, with the owner.

### Phase 4: The prototype

- [ ] Requirement 4, once section 3 is ruled far enough to build.

### Phase 5: The standard and closure

- [ ] [issue-standards.md](../../issue-standards.md) states the model, here or where the task list puts it.
- [ ] #303 retitled and its body brought to the model, with the owner's approval.
- [ ] The pull request, documents only.

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
   repository. Proposed: (a), and (c) if personal's tracked work moves. **Ruled 2026-10-22:** "we are building a 3-tier hierarchy modeled with the parent-child relation between issues, so yes. Our hierarchy is based on epics that contain chores and features that contain bugs and tasks. It is a very specific hierarchy based on Issue Type." So Type is
   GitHub's issue type, Epic and Chore added to the organization's Task, Bug and Feature, and the parent is GitHub's
   sub-issue link. Neither reaches a user's repository, and for personal, 32 open issues on 2026-10-22, **ruled
   2026-10-22:** "Star gh offers directed syncs. Person[al] will need to sync if it wants to participate." So (b):
   labels in personal, the organization's types and links the record of truth, and `star gh` syncing one way, from
   the organization's record to personal's labels. Question 1 is closed.
2. **How long a level-1 issue lives.** Today a feature ships and closes, and its epic closes when its features do.
   Gemini's write-up proposes that features and chores stay open for the life of what they deliver, a bug in shipped
   work parented to the original, so that its whole cost can be counted. Options: today's lifecycle, a bug in shipped
   work finding a current parent at triage; or long-lived level 1. Not proposed: it changes what "done" means for a
   feature.
3. **The standing engineering epic.** Every chore needs an epic. Proposed: #142, Epic: Process, renamed for
   engineering, and open for good, as it is today. **Ruled in part, 2026-10-21:** "I do not thin[k] that we need to
   have a home for chores anymore. we can create an epic in any repo and create features and chores with bugs and
   tasks to our heart's content. I think we must either repurpose #142 or close it as <something>." Then: "#142 is
   basically our triage epic. i'm surprised it's not bigger than 90. These are things discovered over the course of a
   month that are bugs, gaps (missing parts of chores/features), and suspicious behaviors/implementation." So no
   standing epic, and no rule that every repository carries `Epic:Ops:Process`. Open: whether #142 is repurposed as
   this repository's own engineering epic or closed as not planned once its 90 open issues (counted 2026-10-21) have
   each found an epic or joined the triage collection of question 4. GitHub's close reasons are completed, not
   planned and duplicate, and no other (gh 2.103.0).
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
   it, by a person or periodically from the queries. Still open: who the team is.
5. **A collection's own record: row 0, or the project's README.** Options: (a) row 0 is the collection's own issue, as
   the owner proposed on 2026-10-20, its body holding the deliverable and the rulings, its assignee the owner, and
   sessions keyed by it as today; it needs an exemption from "every issue must be fit into this hierarchy", as
   schedule and thread issues have from the epic rule today; (b) no row 0: the project's README holds the deliverable
   and the rulings, and sessions are keyed by the project. Proposed: (a). Start-Claude's store and
   star-gh-assignment keep their keys, which section 5 needs.
6. **Lane numbers.** Proposed: row 0 is the collection's own issue (question 5), and lanes 1..N follow it, so that
   today's lane numbers carry over. The tool that adds a row numbers it. GitHub projects have no number that counts by
   itself, so a row added in GitHub's interface has none, and the audit reports it.
7. **A row's status.** GitHub's built-in workflow can mark a row Done when its issue closes, and closed is not done:
   lane 13 of #301 was closed on 2026-10-20 with two hosts not migrated. Proposed: star derives the status, and no
   GitHub workflow sets it.
8. **Adding a row to a committed schedule.** Today no lane is added once a schedule is committed, except by the owner's
   amendment. Proposed: unchanged; one star command adds the row and writes its amendment together.
9. **One issue in two live collections.** The owner, 2026-10-20: "5 give me pause." A project cannot prevent it.
   Proposed: forbidden for schedules, where the audit reports it; allowed for threads, since one feature can serve two
   use cases.
10. **Who joins which collection.** As the stakes say: a thread's rows are features and chores, a schedule's are tasks
    and bugs. Two deltas: today a thread's members are leaves, and the owner's note of 2026-10-20 let a lane be any
    type. Proposed: the stakes.
11. **Severity on a task.** The owner's question. Proposed: none. Severity measures the harm a defect does; a task is
    planned work, and what it has is priority.
12. **How a thread influences priority.** Open.
13. **Parent links across repositories and owners.** GitHub's sub-issue link, or the `**Feature:**` marker. Unverified:
    whether a sub-issue may live in another repository (#176), or in another owner's repository, as personal's do.
    Proposed: a write test before section 4 is ruled. **Ruled 2026-10-22,** with question 1: the parent is the
    sub-issue link. Already in use: 66 of noblefactor-ops's 89 open issues carried one on 2026-10-21, created under the
    owner's account on 2026-10-20 and 2026-10-21, #266 holding 43 under #142. Still unverified: whether the link crosses
    into another repository or another owner's, which the write test settles; until it does, the marker stays as the
    cross-repository form.
15. **The asset and its sync**, added and ruled 2026-10-22: the model travels as `model.yaml` beside the extension and
    drives it; `star gh model pull` rewrites the asset from GitHub's record and `push` brings a repository's labels to
    the asset; every `star gh issues` operation reads the record first, by ETag. The owner: "Use the etag. Offer pull
    and push as star gh commands." Then, of the proposed syntax and file: "That's great. Doc it."
    [Section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md).
14. **GitHub's issue fields NobleFactor already has:** Priority, Effort, Start date and Target date. None reaches
    personal. Proposed: Priority as labels, one record of it; the other three outside the model until a need appears.
