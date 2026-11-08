---
title: "star reads the issue data model, and keeps every Triage project up to date"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/436
status: draft
created: 2026-11-08
updated: 2026-11-08
---

# Plan: star reads the issue data model, and keeps every Triage project up to date

## Summary

Three tasks, one worktree and one pull request, steps 14 to 16 of issue tracking, iteration 1 (#346), by the owner's
word of 2026-11-08. The first two repair how star's GitHub extension reads issues, which broke when the old labeling
scheme was retired on 2026-11-03: it takes the hierarchy from the model alone (#376), and places each issue by its type
and sub-issue parent, finding its epic up the parent chain, and returns every issue as one flat record that star's own
flags narrow (#379). The third builds on them: `star github triage sweep`
adds every open issue that breaks a classification rule to its team's Triage project, from a terminal on demand and
every day from a workflow (#436). It only adds; triage fixes the issue by hand.

## The issues

| Step | Type | Issue | Done when |
| --- | --- | --- | --- |
| 14 | Task | [#376](https://github.com/NobleFactor/noblefactor-engprod/issues/376), the extension reads the hierarchy from model.yaml | No type name in the extension's code; the report and the audit render as before; a type with no level is refused |
| 15 | Task | [#379](https://github.com/NobleFactor/noblefactor-engprod/issues/379), the report and the audit place an issue by its type and sub-issue parent | An issue's epic is the epic its parent chain reaches, in both accounts; the report returns each issue as one flat record; no fault about kind labels, markers or tiers |
| 16 | Task | [#436](https://github.com/NobleFactor/noblefactor-engprod/issues/436), star keeps every Triage project up to date | The sweep adds each issue that breaks a rule to its team's Triage project, removes none, and works for all three Triage projects |

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
| The report's selection | Label filters | `--epic`, `--thread` and `--state` filter inside the command, the first two on retired labels, and its rows nest |
| The labels commands | Out of date | `github labels audit` and `sync` expect the kind labels and `Epic:Ops:Process` in every repository; out of scope here (Open Questions) |
| Tests | None | Nothing tests the extension; the scripts in `tests/` cover the layer's bash and PowerShell |
| The sweep | Missing | No command; Triage rows are added today by the Triage workflow (personal) and by hand |

## Requirements

### Requirement 1: the hierarchy from the model alone (#376)

No type name appears in the extension's code: every rule reads `model.yaml`. A `model.yaml` with a type that has no
level is refused, the type named. `model.yaml` is pulled again (`star github model pull`) so it matches GitHub.

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
- **Never removes** a row from any project.
- **Returns its result** as star's output, JSON by default and another kind through `--output`: for each Triage
  project, the issues added (or, under `--dry-run`, to be added), those already there with a fault, and the project's
  rows, each issue with its faults named. The result is the answer to whether anything needs triage; an agent reads it
  at the end of a batch of changes.
- **Exits non-zero only on an error**, when the sweep could not run: GitHub unreachable, a sign-in refused, a model it
  cannot read. Faults found are a result, not an error, and exit 0.

**The result's shape**, for one account, each list cut to one issue; the faults are invented for the example. Under
`--dry-run` it is the same, with `"dry_run": true` and `added` holding what would be added.

```json
{
  "account": "NobleFactor",
  "read_at": "2026-11-08T17:40:12Z",
  "dry_run": false,
  "summary": { "open_issues": 546, "with_faults": 3, "added": 1, "already_in_triage": 2 },
  "triage": [
    {
      "project": "Triage: engprod",
      "number": 5,
      "added": [
        {
          "issue": "NobleFactor/noblefactor-engprod#436",
          "type": "Task",
          "title": "star keeps every Triage project up to date, one for each team or user account",
          "url": "https://github.com/NobleFactor/noblefactor-engprod/issues/436",
          "home": [
            { "project": "Schedule: engprod", "schedule": "issue tracking, iteration 1", "step": 16,
              "status": "In progress",
              "worktree": "https://github.com/NobleFactor/noblefactor-engprod/tree/feature/436-triage-sweep" }
          ],
          "faults": [
            { "rule": "step-order",
              "message": "step 16 waits on NobleFactor/noblefactor-engprod#379, at step 17 on the same schedule" }
          ]
        }
      ],
      "already_in_triage": [
        {
          "issue": "NobleFactor/noblefactor-engprod#447",
          "type": "Bug",
          "title": "NobleFactor/.github's Triage workflow template never finishes on an issue whose Area…",
          "url": "https://github.com/NobleFactor/noblefactor-engprod/issues/447",
          "home": [],
          "faults": [ { "rule": "severity", "message": "a bug whose Severity is N/A" } ]
        }
      ],
      "rows": [
        { "issue": "NobleFactor/noblefactor-engprod#436", "status": "Open", "faults": ["step-order"] },
        { "issue": "NobleFactor/noblefactor-engprod#447", "status": "Open", "faults": ["severity"] },
        { "issue": "NobleFactor/noblefactor-engprod#252", "status": "Open", "faults": [] }
      ]
    },
    {
      "project": "Triage: devlore",
      "number": 6,
      "added": [],
      "already_in_triage": [],
      "rows": [ { "issue": "NobleFactor/devlore-cli#689", "status": "Open", "faults": [] } ]
    }
  ]
}
```

| Field | What it answers |
| --- | --- |
| `summary` | The quick answer: `added` above zero means something new needs triage |
| `triage[].added` | What this run sent to Triage, and why |
| `triage[].already_in_triage` | Faults already waiting there: not sent again, still visible |
| `triage[].rows` | The project's whole list, each row with its faults' rules, none included: #436's list in each Triage project |
| `home` | The issue's homes, in the report's form: a list, never null, empty when it has none; the Triage row sits beside them, and no home row is touched |
| `faults[].rule` | A fixed name to match on: `no-area`, `severity`, `resolution-open`, `two-labels`, `good-first-issue`, `no-evidence`, `two-homes`, `epic-on-collection`, `step-order` |
| `faults[].message` | The same fault in plain words, for a person |

`--output table`, or `--output markdown`, renders the same result as a table for each Triage project; the sweep binds
no rendering flag of its own.

### Requirement 4: the daily run (#436)

A workflow in NobleFactor/.github and in David-Noble-at-work/.github, with a `schedule` trigger once a day and a
`workflow_dispatch` trigger beside it, runs the sweep for its account on a GitHub-hosted runner, signing in as the
Triage workflow does: the noblefactor-automation app in NobleFactor, the token in `ADD_TO_PROJECT_PAT` in
David-Noble-at-work. Those files live in other repositories, so they land in their own pull requests after this one
(Open Questions).

## Implementation Phases

### Phase 1: the plan

- [ ] This plan committed and pushed on `feature/436-triage-sweep`; the branch linked in the Worktree column of steps
      14, 15 and 16 on Schedule: engprod, each row In progress, read back; reviewed with the owner, status `approved`

### Phase 2: the test, first

- [ ] `tests/Test-StarGitHub`: the extension's commands run against a stand-in `gh` first on `PATH`, which answers
      GitHub's queries from fixtures and records every call; failing for each case below before the code changes

### Phase 3: the hierarchy from the model, and placement by type and parent (#376, #379)

- [ ] `scheme.star` names no type; the epic is the parent chain's root; the label, marker and tier faults gone
- [ ] The report returns every issue as one flat record, with `--search`; the flags that went, and the audit, removed
- [ ] `model.yaml` pulled again and its digest verified

### Phase 4: the sweep (#436)

- [ ] `commands/github-triage-sweep.star` and its entry in `extension.yaml`

### Phase 5: proved on the live repositories

- [ ] #379's evidence: the report's tree for Epic #330 in NobleFactor and for an epic in David-Noble-at-work, each issue
      under its parent and named with its epic, from the deployed extension
- [ ] #436's evidence: for each of the three Triage projects, the sweep's command and output, a `--dry-run` first; the
      list matching the project's rows; one issue added for a fault, and one closed issue left where it is

### Phase 6: merge

- [ ] The pull request script written, shown and handed over; it closes #376, #379 and #436

## Test Plan

| # | What it proves | Level | Fails when |
| --- | --- | --- | --- |
| 1 | A `model.yaml` type with no level is refused, the type named | unit, stand-in `gh` | the check on levels is removed |
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
| 6 | A scenario's row is checked only against the two structural rules | unit | an attribute rule runs on it |
| 7 | An issue already in Triage is not added again; `--dry-run` adds nothing | unit | a mutation is called |
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
| `…/com.noblefactor.ops.GitHub/commands/github-triage-sweep.star` | Create | The sweep |
| `…/com.noblefactor.ops.GitHub/extension.yaml` | Modify | The sweep's command and flags; the report's `--search`; the audit's command, and `--query`, `--root`, `--state`, `--by`, `--view`, `--markdown`, `--limit`, `--schedule`, `--directory`, `--repo` and the label filters, gone; the report's repositories and the sweep's accounts declared as variadic `args` |
| `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md` | Modify | Its invocations without the flags that go: a schedule's status read from the records' `home` |
| `…/com.noblefactor.ops.GitHub/model.yaml` | Modify | Pulled again |
| `tests/Test-StarGitHub` | Create | The extension's test, with a stand-in `gh` |
| `docs/issue-standards.md` | Modify | The Triage row beside a home (2026-11-08) |

## Related Documents

- [Issue data model, section 1 § Triage](../../architecture/issue-data-model/1-hierarchy.md), section 3, the
  collections, and section 6, the asset and its sync
- [issue-standards.md](../../issue-standards.md)
- #427, the report and the audit reading schedules and scenarios from their projects (step 28): the report's part is
  done here, through `home`, and the audit retires here
- #426, the richer model with issue fields and projects, which this does not wait on (step 19)
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
