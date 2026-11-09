---
title: "star reads the issue data model, and keeps every Triage project up to date"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/436
status: complete
created: 2026-11-08
updated: 2026-11-08
---

# Plan: star reads the issue data model, and keeps every Triage project up to date

## Summary

Three tasks and a bug, one worktree and one pull request, steps 15 to 18 of issue tracking, iteration 1 (#346), by the owner's
word of 2026-11-08. The first two repair how star's GitHub extension reads issues, which broke when the old labeling
scheme was retired on 2026-11-03: it takes the hierarchy from the model alone (#376), and places each issue by its type
and sub-issue parent, finding its epic up the parent chain, and returns every issue as one flat record that star's own
flags narrow (#379). The third builds on them: `star github triage sweep`
adds every open issue that breaks a classification rule to its team's Triage project, from a terminal on demand and
every day from a workflow (#436). It only adds; triage fixes the issue by hand.

## The issues

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 14 | Bug | [NobleFactor/devlore-cli#1215](https://github.com/NobleFactor/devlore-cli/issues/1215), star writes an empty list in a command's result as null; blocks #379 and #436, in its own worktree and pull request | Every empty list in a star command's result is `[]`; a test fails if it is ever null again |
| 15 | Task | [#376](https://github.com/NobleFactor/noblefactor-engprod/issues/376), the extension reads the hierarchy from model.yaml | No type name in the extension's code; the report and the audit render as before; a type with no level is refused |
| 16 | Task | [#379](https://github.com/NobleFactor/noblefactor-engprod/issues/379), the report and the audit place an issue by its type and sub-issue parent | An issue's epic is the epic its parent chain reaches, in both accounts; the report returns each issue as one flat record; no fault about kind labels, markers or tiers |
| 17 | Task | [#436](https://github.com/NobleFactor/noblefactor-engprod/issues/436), star keeps every Triage project up to date | The sweep adds each issue that breaks a rule to its team's Triage project, removes none, and works for all three Triage projects |
| 18 | Bug | [#466](https://github.com/NobleFactor/noblefactor-engprod/issues/466), Start-Claude refuses every schedule: it looks for the retired chore label, not the issue type Schedule; fixed here (ruled 2026-11-08) | `--schedule` takes an issue of type Schedule, or one labeled `schedule` in a user account; the completions offer them |

## Rulings

- **One worktree for the three** (2026-11-08), their steps reordered to 14, 15 and 16 so the repair comes before the
  sweep that runs on it; #436 is marked blocked by #379, which is blocked by #376.
- **The filing and sweeping code is star's** (2026-11-07): no new bash or PowerShell script for it.
- **A Triage row sits beside an issue's home** (2026-11-08, recorded on #436): an issue's home is at most one of its
  account's Backlog, Schedule and Scenario projects; the sweep adds a Triage row beside it for a fault and never takes
  an issue off a schedule or a scenario. It removes no row from any project (2026-11-04).
- **The rules the sweep checks** (2026-11-04, from #303's closing, as #436's comments record): no Area; a bug with
  Severity N/A or blank, or another type with a Severity other than N/A; a Resolution on an open issue; two labels of
  one attribute, in David-Noble-at-work; `good first issue` on anything but a task or a bug; no Evidence of completion
  section, except on a Scenario issue; more than one home, or more than one schedule or scenario; an epic or a feature
  on a Backlog, Schedule or Scenario project. A scenario's rows are left alone but for the two structural rules.
- **The step-order check** (2026-11-08): an open step on a schedule that is blocked by an open issue on the same
  schedule with the same or a higher step is a fault. The schedule asks for the work in an order it can't be done in,
  as #436 itself did until that day: step 14, waiting on #376 and #379 at steps 26 and 27. The step gets a Triage row
  beside its schedule row; triage reorders the steps or removes a wrong blocked-by link.
- **The report returns every issue, and star's own flags narrow it** (2026-11-08): the report reads every issue, open
  and closed, and returns each as one flat record. Its `home` is a list and never null: empty with no home, and one
  element in the usual case. star's global `--filter` and `--jq` narrow the result and `--output` renders it, `csv`
  among its kinds; the report binds none of them. Its one selection flag is `--search`, which narrows what is read:
  GitHub's issue-search syntax, passed unchanged and scoped by star to each repository. `--query`, `--root`, `--state`,
  `--by`, `--view`, `--markdown` and `--limit` go, and so do `--epic` and every filter that reads a retired label;
  `--directory` goes too. The repositories the report reads, and the accounts the sweep reads, are positional
  arguments, open-ended lists of what the verb acts on (the CLI architecture, §4); `--repo` and `--account` go.
- **The sweep's result is flat too** (2026-11-08): one record for each issue it added, found in Triage with a fault, or
  found a Triage row, with the same keys every time, so that star's `--filter`, `--jq` and CSV work on it as they do on
  the report's records. The per-account summary and the per-project lists go; a count is `--jq length`.
- **Start-Claude's `--schedule` is fixed here** (2026-11-08): Bug #466, step 18. A schedule is an issue of type
  Schedule, or in a user account one labeled `schedule` (issue-standards.md, Schedules); Start-Claude still looked for
  the `chore` label retired on 2026-11-03. `--schedule new`, which still opens a schedule the old way, waits.
- **The model is the cache the commands read** (2026-11-08): `star github model pull` writes each account's model,
  and the report and the sweep take types, fields and teams from it and from nowhere else. The part of #426 they need
  is done here (Requirement 1).
- **A list is always a list** (2026-11-08): every list in a star command's result is a list, `[]` when empty, and a key
  that holds one value and has none is null. star wrote an empty list as null, which `tests/Test-StarGitHub` found;
  the fix is Bug NobleFactor/devlore-cli#1215, step 14, in its own worktree and pull request, and #379 and #436 are
  blocked by it.
- **The result is the output** (2026-11-08): star's default output is JSON, the expression of a result, changed with
  `--output <kind>`. The sweep reports what it found and did there. A non-zero exit identifies an error, and only an
  error; faults found are a result. No flag turns faults into an exit status.
- **When and where it runs** (2026-11-04, and 2026-11-06): every day, as a scheduled workflow in each account's
  `.github` repository, with the Triage workflow's credentials, and by hand at any time; a run by hand from a terminal
  is the check after each piece of triage work (2026-11-07).

## Current State

| Component | Status | Notes |
| --- | --- | --- |
| Types and levels | Read from `model.yaml` | `scheme.star` derives `KINDS`, `LEVELS` and the leaf and root kinds from the asset: most of #376 is done |
| An issue's epic | Broken | Resolved from the root's `Epic:<Name>` label, retired 2026-11-03: every issue resolves to no epic, and `--epic <Name>` finds nothing |
| The audit's faults | Out of date | About kind labels, `Epic:` labels, parent markers and tiers, the scheme retired 2026-11-03 |
| `model.yaml` | Stale | Pulled 2026-11-03: types, labels and projects; no issue fields and no teams; the Triage projects' Status options as they were then |
| `star github model pull` | Partial | Reads one organization's types, hub labels and projects; records a conflict for each `Collection:` type and writes nothing; reads no fields, no teams and no user account |
| The report's selection | Label filters | `--epic`, `--thread` and `--state` filter inside the command, the first two on retired labels, and its rows nest |
| The labels commands | Out of date | `github labels audit` and `sync` expect the kind labels and `Epic:Ops:Process` in every repository; out of scope here (Open Questions) |
| Tests | None | Nothing tests the extension; the scripts in `tests/` cover the layer's bash and PowerShell |
| The sweep | Missing | No command; Triage rows are added today by the Triage workflow (personal) and by hand |

## Requirements

### Requirement 1: the hierarchy and the attributes from the model (#376, and the part of #426 they need)

No type or field name appears in the extension's code: every rule reads the account's model, which `star github model
pull` writes and the report and the sweep read (2026-11-08: the model is our cache of GitHub's data model, and the
commands get what they need from it). That brings into this worktree the part of #426 these commands need, as
[section 6](../../architecture/issue-data-model/6-the-asset-and-its-sync.md) specifies it:

- **Types.** A type of the hierarchy has the level its description's `Level N:` gives. A collection type, Schedule or
  Scenario, has none: its description begins `Collection:`. `pull` records both, where it records a conflict for a
  collection today and writes nothing; the model's load accepts both, and refuses, by name, a type that has neither a
  level nor a `Collection:` description.
- **Fields.** An organization's issue fields, each with its name, id and type, and a single-select field's options with
  theirs, read from GraphQL's `Organization.issueFields`. A user account has none.
- **Teams.** An organization's teams, each with its name, slug and id, and the repositories it holds the maintain role
  on, which it owns (section 6, `teams`). A team's projects are `<Kind>: <slug>`, as in `Triage: devlore`. A user
  account has none, and its projects are `<Kind>: <account>`.
- **One model per account** (section 6). `pull` takes `--account <login>`, an organization or a user, in place of
  `--org`; with none, star configuration's `github.account`, and then NobleFactor. A user account's types are its type
  labels, those whose descriptions begin `Level N:` or `Collection:`, in the repositories it owns that carry the topic
  `issue-model`; its projects are read as an organization's are. NobleFactor's model stays `model.yaml` beside the
  extension until #431 moves it to NobleFactor/.github; another account's is `model.<account>.yaml` beside it, which
  is `pull`'s default `--asset` for that account. The report and the sweep pick each repository's model by its owner.
- **A user account's attributes** are the labels that stand in for an organization's single-select fields
  (`reference/user.yaml`): `area:product` gives the record's `area` the value `Product`, the reference's name for that
  label, so that one `--filter area=Product` selects in both accounts.
- **The labels record** stays as it is: the labels commands read it, and they are out of scope.

Both models are pulled again, NobleFactor's and David-Noble-at-work's, and their digests verified.

### Requirement 2: placed by type and parent (#379)

An issue's kind is its issue type, or in David-Noble-at-work its type label; its parent is its sub-issue link. Its epic
is the level-0 issue its parent chain reaches, named by that issue's number and title. The fallbacks to kind labels and
parent markers stay only for a user account's type labels. The audit retires: its faults about kind labels, `Epic:`
labels, markers and tiers go, the classification rules are the sweep's, and `star github triage sweep --dry-run` is
the audit.

**What the report returns** (2026-11-08): every issue, as one flat record, which a person or an agent narrows with
star's global flags rather than the report's own.

```text
star github schedule report [<owner>/<repository>...]
    [--search <github-search-expression>]
```

```bash
star github schedule report
star github schedule report NobleFactor/devlore-cli NobleFactor/noblefactor-engprod
star github schedule report --search 'in:comments "lint gate" type:Bug'
star github schedule report --filter type=Bug --filter area=Product --output csv
star github schedule report --filter epic=NobleFactor/noblefactor-engprod#330
```

- **`<owner>/<repository>...`**, positional and open-ended, names the repositories to read; with none named, the
  report reads the repositories of writ's layers. It replaces `--repo`'s comma-separated list.
- **Without `--search`**, the report reads every issue, open and closed, of each repository it is given, through the
  repository's issue list, 100 at a time. That list has no cap. GitHub's search stops at 1,000, and on 2026-11-08 the
  two accounts held 1,112 issues, 597 of them open.
- **`--search <expression>`** narrows what is read, in GitHub's issue-search syntax with GitHub's meaning. star passes
  it unchanged to GraphQL's `search(type: ISSUE_ADVANCED)`, once for each repository, as `(<expression>)
  repo:<repository>`; the user never types the scope. It reaches what the record does not carry: bodies and comments
  (`in:body`, `in:comments`), people (`commenter:`, `mentions:`, `involves:`), linked pull requests (`linked:pr`), and
  when and why an issue closed (`closed:`, `reason:`). A repository whose search matches more than 1,000 issues is an
  error, and the report exits non-zero: it cannot return the whole result, and a list cut off would be a wrong one.
- **star's global flags do the rest.** `--filter field=value` and `--jq` narrow the records returned, and `--output`
  renders them, `csv` for a spreadsheet, as the [CLI architecture, §8][cli-pipeline], lays out. The report binds none
  of them: [§14][cli-conformance], invariant 2, forbids a command to shadow a flag it inherits.
- **Gone:** `--query`, `--root` and `--state`, which `--search` and the global flags replace; the report's `--epic`
  and `--thread`, and `--by thread`, which matched the retired `Epic:<Name>` and `Thread:<Name>` labels; and the
  audit, with its `--unthreaded` and its `--epic`; and `--by`, `--view`, `--markdown`, `--limit` and `--schedule`,
  since rendering is the work of `--output`; and `--directory`, which was `--repo` given as a path, and `--repo`, which
  the positional repositories replace.

[cli-pipeline]: https://github.com/NobleFactor/devlore-cli/blob/develop/docs/architecture/10-command-line-interface.md#8-the-pipeline-two-stages-one-flag-each
[cli-conformance]: https://github.com/NobleFactor/devlore-cli/blob/develop/docs/architecture/10-command-line-interface.md#14-conformance-and-enforcement

**The record.** GraphQL returns each list wrapped in `nodes`, and each issue or project field as a name and value pair,
which neither `--filter` nor a spreadsheet can reach. The report flattens it. Task #436's record, as GitHub held it on
2026-11-08:

```json
{
  "issue": "NobleFactor/noblefactor-engprod#436",
  "repository": "NobleFactor/noblefactor-engprod",
  "type": "Task",
  "title": "star keeps every Triage project up to date, one for each team or user account",
  "url": "https://github.com/NobleFactor/noblefactor-engprod/issues/436",
  "state": "open",
  "state_reason": null,
  "parent": "NobleFactor/noblefactor-engprod#332",
  "feature": "NobleFactor/noblefactor-engprod#332",
  "epic": "NobleFactor/noblefactor-engprod#330",
  "area": "Product",
  "severity": "N/A",
  "priority": null,
  "resolution": null,
  "home": [
    { "project": "Schedule: engprod", "schedule": "issue tracking, iteration 1", "step": 16, "status": "In progress",
      "worktree": "https://github.com/NobleFactor/noblefactor-engprod/tree/feature/436-triage-sweep" }
  ],
  "in_triage": false,
  "sub_issues_total": 0,
  "sub_issues_completed": 0,
  "labels": [],
  "assignees": ["David-Noble-at-work"],
  "blocked_by": ["NobleFactor/noblefactor-engprod#379", "NobleFactor/noblefactor-engprod#452"],
  "projects": [
    { "project": "Schedule: issue tracking, iteration 1", "number": 12, "Status": "Open", "Step": 5 },
    { "project": "Schedule: engprod", "number": 26, "Schedule": "issue tracking, iteration 1", "Step": 16,
      "Status": "In progress",
      "Worktree": "https://github.com/NobleFactor/noblefactor-engprod/tree/feature/436-triage-sweep" }
  ],
  "created_at": "2026-11-03T05:09:00Z",
  "updated_at": "2026-11-08T17:29:11Z",
  "closed_at": null
}
```

Its row on Schedule: issue tracking, iteration 1, the retired per-schedule project, is in `projects` and is not a
home: that project is no team's.

| Keys | What they hold |
| --- | --- |
| `issue`, `repository`, `title`, `url` | Which issue: `issue` is `<owner>/<repository>#<number>`, the form `--filter` matches |
| `type` | Its issue type; in David-Noble-at-work, its type label |
| `state`, `state_reason` | `open` or `closed`, and why it closed |
| `parent`, and a key for each level above the issue's own, its type's name in lower case: `feature`, `epic` | Its place, read up the parent chain to the model's depth; null where there is none |
| A key for each issue field the model names, in lower case with underscores: `area`, `severity`, `priority`, `resolution` | Its attributes; in David-Noble-at-work, read from its attribute labels |
| `home` | Its homes: a list, never null, of its rows on its team's Backlog, Schedule and Scenario projects, each element the project's name and that row's `schedule`, `step`, `status` and `worktree`. One element in the usual case; empty with no home; two or more is a fault the sweep names |
| `in_triage` | Whether its team's Triage project has a row for it |
| `sub_issues_total`, `sub_issues_completed` | Its children, counted |
| `labels`, `assignees`, `blocked_by` | Lists: each a JSON cell in CSV, which `--jq` reaches inside |
| `projects` | Every project row in full, each row's fields by name |
| `created_at`, `updated_at`, `closed_at` | When |

A type or a field in the model whose key would be one of the fixed keys is refused, the name given, as a type with no
level is.

**What GitHub's search can and cannot do**, tested on 2026-11-08. No search narrows by a named parent, so the report
reads the parent chain upward from each issue to fill `feature` and `epic`, and `--filter epic=<issue>` does what
`--root` would have.

| Test | Result |
| --- | --- |
| `parent-issue:NobleFactor/noblefactor-engprod#330`, Epic #330 having five direct children, in every form, in GraphQL's `search` of both types, REST's `search/issues` with `advanced_search=true`, and the issues search on github.com | 0 matches in each; GitHub's documentation lists no parent qualifier |
| `is:sub-issue`, in both of GraphQL's search types | 0 matches |
| `has:parent-issue` and `no:parent-issue` | 112 and 17 open issues: whether an issue has a parent, never which |
| A project's items, `items(query: "parent-issue:NobleFactor/noblefactor-engprod#332")`, on Schedule: engprod | 14 of its 96 rows, each a child of #332; 0 for #330, their grandparent: direct children only, and only rows on that project |
| `(type:Bug OR type:Feature) is:open repo:NobleFactor/noblefactor-engprod` | 34: the 15 bugs and 19 features counted apart, so the parentheses hold |
| The same, without `repo:` | 678,084, all of GitHub: star adds the scope |
| The `parent` field, without the `GraphQL-Features: sub_issues` header | Works: #436, then #332, then #330 |

### Requirement 3: the sweep (#436)

```text
star github triage sweep [<account>...]
```

- **`<account>...`**, positional and open-ended, names the accounts to sweep, `NobleFactor` or `David-Noble-at-work`;
  with none named, the sweep reads both. It replaces `--account`.

- **Reads** every open issue of the account's participating repositories, with its type, parent, Area, Severity,
  Resolution, labels and body, and every row of the account's projects. Teams, projects, fields and options are looked
  up by name as it runs (a team owns a repository it has the maintain role on; a user account's repositories carry the
  topic `issue-model`; each team's projects are named `Triage: <team>`, `Backlog: <team>`, `Schedule: <team>` and
  `Scenario: <team>`), so it does not wait on #426's richer model.
- **Checks** each issue against the rules above, the step-order check among them. An issue's homes are its Backlog,
  Schedule and Scenario rows; its Triage row is not a home.
- **Adds** each issue with a fault, not already in its team's Triage project, as a row of it with Status Open, and
  reads the row back. Under star's global `--dry-run`, which the sweep reads and does not declare, it reads and checks
  and adds nothing.
- **Comments** on each issue it adds, naming each rule the issue broke and the Triage project it went to, so that
  triage knows why it came (ruled 2026-11-04, as #436's comments record). An issue already in Triage gets no second
  comment, and nothing is commented on under `--dry-run`.
- **Never removes** a row from any project.
- **Returns its result** as star's output, JSON by default and another kind through `--output`: one flat record for
  each issue it added (or, under `--dry-run`, would add), each it found in Triage already with a fault, and each other
  row of a Triage project, every key at the top level, as the report's are, so that star's `--filter` and `--jq`
  narrow it and CSV renders it (ruled 2026-11-08). The result is the answer to whether anything needs triage; an agent
  reads it at the end of a batch of changes.
- **Exits non-zero only on an error**, when the sweep could not run: GitHub unreachable, a sign-in refused, a model it
  cannot read. Faults found are a result, not an error, and exit 0.

**The result's shape**, one record of it; the fault is invented for the example. The records come by Triage project,
then by repository and number; a Triage project with nothing on it gives none.

```json
{
  "account": "NobleFactor",
  "project": "Triage: engprod",
  "issue": "NobleFactor/noblefactor-engprod#436",
  "type": "Task",
  "state": "open",
  "title": "star keeps every Triage project up to date, one for each team or user account",
  "url": "https://github.com/NobleFactor/noblefactor-engprod/issues/436",
  "action": "added",
  "status": "Open",
  "rules": "step-order",
  "faults": [
    { "rule": "step-order", "message": "step 17 waits on NobleFactor/noblefactor-engprod#431, at step 18 on the same schedule" }
  ],
  "home": [
    { "project": "Schedule: engprod", "number": 26, "schedule": "issue tracking, iteration 1", "step": 17,
      "status": "In progress", "worktree": "https://github.com/NobleFactor/noblefactor-engprod/tree/feature/436-triage-sweep" }
  ]
}
```

| Key | What it answers |
| --- | --- |
| `account`, `project` | The account swept, and the Triage project the record is about |
| `issue`, `type`, `state`, `title`, `url` | Which issue, as the report names it |
| `action` | `added`: this run sent it to Triage; `would-add`: it would have, under `--dry-run`; `in-triage`: a fault already waiting there, not sent again; `row`: a row of the Triage project with no fault |
| `status` | The Triage row's Status: Open for one this run added |
| `rules` | The faults' rule names, comma-separated, empty when there are none: `no-area`, `severity`, `resolution-open`, `two-labels`, `good-first-issue`, `no-evidence`, `two-homes`, `epic-on-collection`, `step-order` |
| `faults` | Each fault, its rule and the same fault in plain words, for a person; `[]` when there are none |
| `home` | The issue's homes, in the report's form: a list, never null, empty when it has none; the Triage row sits beside them, and no home row is touched |

What a run sent to Triage is `--filter action=added`; a Triage project's whole list, #436's list in each, is
`--filter project="Triage: engprod"`; a count is `--jq length`. `--output table` or `csv` renders the result; the sweep
binds no rendering flag of its own.

### Requirement 4: the daily run (#436)

A workflow in NobleFactor/.github and in David-Noble-at-work/.github, with a `schedule` trigger once a day and a
`workflow_dispatch` trigger beside it, runs the sweep for its account on a GitHub-hosted runner, signing in as the
Triage workflow does: the noblefactor-automation app in NobleFactor, the token in `ADD_TO_PROJECT_PAT` in
David-Noble-at-work. Those files live in other repositories, so they land in their own pull requests after this one
(Open Questions).

## Implementation Phases

### Phase 1: the plan

- [x] This plan committed and pushed on `feature/436-triage-sweep`; the branch linked in the Worktree column of steps
      14, 15 and 16 on Schedule: engprod, each row In progress, read back; reviewed with the owner, status `approved`

### Phase 2: the test, first

- [x] `tests/Test-StarGitHub`: the extension's commands run against a stand-in `gh` first on `PATH`, which answers
      GitHub's queries from fixtures and records every call; failing for each case below before the code changes

### Phase 3: the hierarchy from the model, and placement by type and parent (#376, #379)

- [x] `scheme.star` names no type; the epic is the parent chain's root; the label, marker and tier faults gone
- [x] The report returns every issue as one flat record, with `--search`; the flags that went, and the audit, removed
- [x] `star github model pull` reads collection types, fields, teams and a user account, and writes an account's first
      model; the model's load accepts collection types; `--account` replaces `--org`
- [x] `model.yaml` and `model.David-Noble-at-work.yaml` pulled, their digests verified

### Phase 4: the sweep (#436)

- [x] `commands/github-triage-sweep.star` and its entry in `extension.yaml`; it comments on each issue it adds

### Phase 4a: Start-Claude's `--schedule` (#466)

- [x] `Start-Claude` and `Start-Claude.ps1` read a schedule's issue type through GraphQL and take an issue of type
      Schedule, or in a user account one labeled `schedule`; their completions, man page and help say so; both tests
      take a labeled schedule and refuse an issue labeled `chore`. `--schedule new` waits, as ruled

### Phase 5: proved on the live repositories

- [x] #379's evidence: the report's tree for Epic #330 in NobleFactor and for David-Noble-at-work's Epics #288 and
      #317, each issue under its parent and named with its feature and its epic, read live with this branch's extension
      on 2026-11-09, in a comment on #379
- [x] #436's evidence: for each of the three Triage projects, the sweep's command and output; the list matching the
      project's rows; one issue added for a fault, with its comment, and one closed issue left where it is, in a comment
      on #436. Not a `--dry-run` first: under it star reads nothing until devlore-cli#1170, and the owner ruled on
      2026-11-08 not to wait on it. Before the first run, the faults on this schedule's own issues were cleared, and the
      backlog's evidence headings, written as Done when, Acceptance, Acceptance criteria, Exit criteria or Success
      criteria before the ruling of 2026-11-04, were renamed in 175 issues; the run added 316 issues, 13 to Triage:
      David-Noble-at-work, 285 to Triage: devlore and 18 to Triage: engprod, and a second run added none

### Phase 6: merge

- [x] The pull request script written, shown and handed over; it closes #376, #379, #436 and #466

## Test Plan

| # | What it proves | Level | Fails when |
| --- | --- | --- | --- |
| 1 | A model type with neither a level nor a `Collection:` description is refused, the type named; a collection type loads | unit, stand-in `gh` | the check on levels is removed, or collections are refused |
| 1a | `pull` records collection types without a level, fields with their options, and teams with the repositories they maintain | unit, stand-in `gh` | a record is left out, or a collection is a conflict |
| 1b | `pull --account` for a user account reads its types from its type labels and writes `model.<account>.yaml` | unit, stand-in `gh` | a user account is read as an organization |
| 1c | A record's keys come from the model of its repository's owner: a NobleFactor issue's `area` from its Area field, a David-Noble-at-work issue's from its `area:` label, both `Product` | unit | one model is read for both, or a field's name is written into the code |
| 2 | An issue's epic is its parent chain's level-0 issue, in an organization and in a user account | unit | the epic is read from a label again, or the chain stops early |
| 3 | `star github schedule audit` is gone, refused as an unknown command, and no fault about kind labels, markers or tiers is left in the extension | unit | the audit or an old fault is left in |
| 3a | `--search` reaches GraphQL's search as given, once for each repository, as `(<expression>) repo:<repository>` | unit, the stand-in records the query | the expression is rewritten, or the scope left off |
| 3b | A repository whose search matches more than 1,000 issues is an error: a non-zero exit, the repository named | unit | the list is cut off and returned |
| 3c | Without `--search`, every issue of every repository is read, open and closed, past the first page | unit, a stand-in holding 250 issues | a state filter or a page limit is left in |
| 3d | Every key the model names is at the top level: `--filter area=Product` and `--filter epic=<issue>` select, and `--output csv` puts one value in each such column | unit | a key is nested, or a type's or a field's name is written into the code |
| 3e | `home` is a list and never null: empty for an issue with no home, one element for one, two for two | unit | `home` is null, or an object, or drops a row |
| 3f | `--query`, `--root`, `--state`, `--by`, `--view`, `--markdown`, `--limit`, `--schedule`, `--directory`, `--repo` and `--account` are refused as unknown flags; repositories and accounts named as arguments are the ones read, and none named reads the defaults | unit | a flag that went is still accepted |
| 4 | Each sweep rule catches its fault and passes a clean issue | unit, one case per rule | a rule is removed or inverted |
| 5 | An issue on a schedule with a fault gets a Triage row and keeps its schedule row | unit | the sweep removes or moves a row |
| 5a | An issue the sweep adds gets a comment naming the Triage project and each rule it broke | unit, the stand-in records the comment | the comment is left out, or names no rule |
| 5b | The sweep's result is one flat record per issue, every key on every record, a Triage row with no fault among them; `--filter action=added` and `--output csv` give what the run sent, one row each | unit | the result nests, or a record lacks a key |
| 5c | Start-Claude takes an issue of type Schedule and one labeled `schedule` as schedules, and refuses one labeled `chore` that is not of type Schedule, on both platforms | `tests/Test-StartClaude`, `tests/Test-StartClaude.ps1` | the `chore` check is back, or a user account's label is not read |
| 6 | A scenario's row is checked only against the two structural rules | unit | an attribute rule runs on it |
| 7 | An issue already in Triage is not added again nor commented on; `--dry-run` adds nothing | unit | a mutation is called |
| 1d | An account with no model file yet gets its first from `pull`, which starts from an empty model of it | unit, stand-in `gh` | `pull` refuses a model file that is not there |
| 8 | A step blocked by an open issue at the same or a higher step on its schedule is a fault; one blocked by a closed issue, or by an issue on no schedule or another, is not | unit | the comparison is reversed, or closed blockers count |
| 9 | The three Triage projects, live | Phase 5 | a project's list does not match its rows |

Each unit case is made to fail once, by the change in its last column, before it is trusted. Not covered by a test:
GitHub's scheduler, which the first daily run shows, and the credentials, which are each account's settings.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/436-triage-sweep.md` | Create | This plan |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | #376 and #379 |
| `…/com.noblefactor.ops.GitHub/commands/github-schedule-report.star` | Modify | Placement by type and parent; every issue as one flat record; `--search` |
| `…/com.noblefactor.ops.GitHub/commands/github-schedule-audit.star` | Delete | The audit retires; the sweep's `--dry-run` is the audit |
| `…/com.noblefactor.ops.GitHub/commands/records.star` | Create | Reading every issue, or a search's, and building its flat record: the report's and the sweep's |
| `…/com.noblefactor.ops.GitHub/commands/github-triage-sweep.star` | Create | The sweep |
| `…/com.noblefactor.ops.GitHub/extension.yaml` | Modify | The sweep's command and flags; the report's `--search`; the audit's command, and `--query`, `--root`, `--state`, `--by`, `--view`, `--markdown`, `--limit`, `--schedule`, `--directory`, `--repo` and the label filters, gone; the report's repositories and the sweep's accounts declared as variadic `args`; the old names `gh.issues.report` and `gh.issues.audit` removed with the flags they declared; `--account` for both names of `pull` |
| `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md` | Modify | Its invocations without the flags that go: a schedule's status read from the records' `home` |
| `…/com.noblefactor.ops.GitHub/model.yaml` | Modify | Pulled again, with collection types, fields and teams |
| `…/com.noblefactor.ops.GitHub/model.David-Noble-at-work.yaml` | Create | The user account's model, pulled |
| `…/com.noblefactor.ops.GitHub/commands/model.star`, `github-model-pull.star` | Modify | Collection types, fields, teams, user accounts, `--account` |
| `tests/Test-StarGitHub` | Create | The extension's test, with a stand-in `gh` |
| `Home/common.Unix/.local/bin/Start-Claude`, `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | #466: a schedule by its issue type, read through GraphQL, or a user account's `schedule` label |
| `Home/common.Unix/.local/share/bash-completion/completions/Start-Claude`, `…/zsh/site-functions/_Start-Claude`, `…/man/man1/Start-Claude.1` | Modify | #466: the completions list schedules by type and by label; the man page says what a schedule is |
| `tests/Test-StartClaude`, `tests/Test-StartClaude.ps1` | Modify | #466: the stand-in `gh` answers GraphQL; a labeled schedule taken, a `chore` issue refused |
| `.github/workflows/ci.yaml` | Modify | star installed on the Linux and macOS runners from a pinned devlore release, through `install.sh` with `DEVLORE_VERSION`, so the test runs in CI as the other tools are pinned |
| `docs/issue-standards.md` | Modify | The Triage row beside a home (2026-11-08); the audit's and the report's invocations as they now are |
| `docs/guides/agent-rules.md`, `docs/guides/development-process.md`, `docs/guides/pr-script-template.md`, `README.md` | Modify | Every invocation of the report and the audit they give, brought to the new syntax, and the sweep named where the audit was |

## Related Documents

- [Issue data model, section 1 § Triage](../../architecture/issue-data-model/1-hierarchy.md), section 3, the
  collections, and section 6, the asset and its sync
- [issue-standards.md](../../issue-standards.md)
- #427, the report and the audit reading schedules and scenarios from their projects (step 30): the report's part is
  done here, through `home`, and the audit retires here
- #426, the richer model with issue fields and projects (step 21): the part the report and the sweep need is done here
  (Requirement 1, ruled 2026-11-08); the labels per repository, the templates' views and `push`'s side stay with it
- #439, the design of the schedule commands; what the report selects by is settled here instead (Rulings)

## Open Questions

- [x] **The step-order check.** Proposed on #436 on 2026-11-06; ruled in on 2026-11-08 (Rulings).
- [x] **The exit status.** Ruled on 2026-11-08 (Rulings): the result is the output; a non-zero exit is an error.
- [x] **What `--epic` takes.** Ruled on 2026-11-08 (Rulings): nothing; it goes. The report returns every issue as a
      flat record; `--search` narrows what is read, and star's global `--filter` and `--jq` narrow the result.
- [x] **The report's presentation flags.** Ruled on 2026-11-08 (Rulings): `--by`, `--view`, `--markdown` and `--limit`
      go, and so does `--directory`; the repositories are positional. The star-github-schedule-progress skill, which
      read lane tables through
      `--by schedule --markdown`, changes with them.
- [x] **`--schedule`.** Decided 2026-11-08, following from the presentation ruling: it named the schedule issue whose
      lane table `--by schedule` read, and nothing else; `home` gives each issue's schedule and step from the projects.
      It goes, which brings the report's part of #427 into this plan.
- [x] **The audit, once its faults are the sweep's.** Decided 2026-11-08, following from the rulings: with the label,
      marker and tier faults, `--unthreaded` and `--epic` gone, `star github schedule audit` has nothing left of its
      own. It retires, and `star github triage sweep --dry-run` is the audit.
- [x] **The list of each Triage project.** Decided 2026-11-08: the sweep's result carries it (`triage[].rows`,
      Requirement 3), and the report's `in_triage` key gives the same list through `--filter in_triage=true`.
- [x] **The daily workflow.** Decided 2026-11-08, as the process requires of files in other repositories: #436 closes
      once the command is proven on the three Triage projects; the two workflows land in their own pull requests in
      NobleFactor/.github and David-Noble-at-work/.github, each a task under Feature #332. On the runner, star comes
      from a devlore release through `install.sh`, and the extension from a checkout of noblefactor-engprod.
- [x] **The labels commands**, `github labels audit` and `sync`, still expect the retired kind labels in NobleFactor.
      Decided 2026-11-08: out of scope here, filed as a task in the Backlog once this plan is approved.
