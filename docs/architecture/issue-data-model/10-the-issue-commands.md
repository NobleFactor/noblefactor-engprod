---
title: "Issue commands"
status: draft
updated: 2026-11-19
---

<a id="10-the-issue-commands"></a>

# Issue commands

[Up: Issue data model](index.md)

`star github issue` opens, moves, closes and reopens Epics, Features, Tasks and Bugs. Schedule and Scenario issues use their own collection commands so their issue, option and own row remain coordinated. The issue commands create no project, field or collection option.

<a id="the-commands"></a>

<a id="1-the-commands"></a>

## 1. Interfaces and result contract

| Command | Effect |
| --- | --- |
| `open --type ... --area ... --title ... --body-file ...` | File a classified issue in the selected clone's repository |
| `open --template <path> [--set ...]` | File from a header/body template |
| `create ...` | Alias for open |
| `move <issue>... <destination> --reason <text>` | Transfer or reorder supported project membership |
| `close <issue>... --evidence <path>` | Close completed work with its evidence |
| `close <issue>... --resolution Declined\|Duplicate\|Invalid --reason <text>` | Close work not done, with its reason |
| `reopen <issue>... --reason <text>` | Reopen work, its closed ancestors and closed containing Schedules |

Issue keys are repository-qualified. Commands return flat records, JSON by default, and share star's output, filter and jq flags. Errors produce nonzero exit status. Duplicate issue arguments, including case or leading-zero variants of the same key, are refused.

Read prerequisites before writes and read the writes back. Those checks do not make remote operations atomic. The recovery limits in section 6 apply; `--dry-run` is refused while required reads cannot run.

<a id="where-an-issue-lives"></a>

<a id="2-where-an-issue-lives"></a>

## 2. Placement

| Type | Triage | Backlog | Schedule | Scenario |
| --- | --- | --- | --- | --- |
| Epic or Feature | Yes | Yes | No | No |
| Task or Bug | Yes | Yes | Yes | Yes |
| Untyped issue | Yes | No | No | No |
| Schedule or Scenario issue | Managed only by its collection group | — | — | — |

Ordinary filing relies on the Triage workflow for its initial row. Scenario intake has its own origin-routing rule. The issue open command itself creates no project row.

<a id="epics-and-features"></a>

### 2.1 Epics and Features

After classification, keep Epics and Features in Backlog until closure. Do not move their rows when child work enters a Schedule or Scenario. Child state indicates progress and identifies when all children are closed; it does not replace their own completion evidence or the [Feature review gates](1-hierarchy.md#4-completion).

Closing an issue reports a parent whose last open child it was, but closes no parent. Default project views show all rows; Backlog also has an Epics and features view and, in the organization representation, a By priority view of executable work.

<a id="opening-an-issue-open-and-create"></a>

<a id="3-opening-an-issue-open-and-create"></a>

## 3. Open an issue

```text
star github issue open --type <type> --parent <issue> --area <area> --title <title> --body-file <path> [--priority <priority>] [--severity <severity>] [--assignee <login>] [--directory <path>]
star github issue open --template <path> [--set <name>=<value>,...] [--directory <path>]
```

Use the repository named by the clone's origin. `--directory` selects another clone. An Epic has no parent; other hierarchy types require a parent exactly one level above, within the account.

A template has a YAML header followed by its Markdown body. Header keys are type, parent, title, area, priority, severity and assignee. With `--template`, use only `--set` and `--directory` alongside it. Comma-separated substitutions fill `{name}` once; inserted values are not recursively expanded, and shell-style `${name}` remains literal. Quote header placeholders so YAML does not interpret braces as structure. Refuse unfilled or malformed inputs.

Read the account model, parent, metadata options and selected Type's form from its shared `.github` repository. Validate participation, allowed Type, parent level, Area, required body sections and text, and a valid Plan and design documents table outside code blocks. Only Bugs accept an explicit Severity.

Priority defaults to Medium. Bug Severity defaults to Medium; other typed issues have N/A. No assignee is selected unless supplied. Write native organization fields or the corresponding user-account labels, then read back the issue and metadata.

<a id="31-optional-duplicate-detection"></a>

### 3.1 Creation and recovery

Each invocation opens a new issue. The open/create commands refuse --unique, and a template header refuses unique. Repeating an issue-open request after its response was lost can therefore create a duplicate; these commands do not compare filings or recover an earlier creation.

The graph-based creation/recovery design is separate work in NobleFactor/devlore-cli#1238. Collection open has its own partial-creation lookup and is not the same operation.

<a id="moving-an-issue-move"></a>

<a id="4-moving-an-issue-move"></a>

## 4. Move work

```text
star github issue move <issue>... (--triage | --backlog | --schedule <schedule> [--after <step>] [--blocked-by <issue>,...] [--assignee <login>] | --scenario <scenario> --beat <beat>) --reason <text>
```

Give exactly one destination. Process issues in input order and permit only destinations allowed by Type. An already-satisfied destination is unchanged unless a valid within-collection change is requested.

Read every source collection once before writing and reread its rows immediately before mutation. Refuse a changed source snapshot, closed issue, another account, collection issue or invalid destination inputs before the affected write.

Leaving a Schedule records its amendment, removes the row and renumbers later open and closed steps. Leaving a Scenario comments on it, writes the finding's departure line and changes its row. Leaving Triage or Backlog removes that row.

Joining a Schedule appends or inserts steps and adds specified same-account blocked-by links without discarding existing dependencies. Cross-team placement requires an accountable receiving-team assignee. Joining a Scenario sets its Beat; joining Triage or Backlog sets Status Open and retains issue Priority. [Schedule](8-the-schedule-commands.md#what-a-move-records-on-a-schedule) and [Scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario) contracts define their records and failure boundaries.

<a id="closing-an-issue-close"></a>

<a id="5-closing-an-issue-close"></a>

## 5. Close work

Give exactly one of an evidence file or a Resolution. Resolution requires a reason; evidence mode forbids a separate reason and requires a nonblank file. Refuse collection issues and an invalid Scenario identity before writing.

Read the issue and relevant histories before writing, then preserve this order:

1. Post the evidence file or closing reason only when no matching comment exists since the issue last reopened, or since creation if it never reopened.
2. Set the requested Resolution if needed. In the user-account representation, remove competing resolution labels while preserving unrelated labels.
3. Close the issue as completed if it is still open.
4. Finish the remaining project-row changes.

Keep Schedule rows and set them Closed. Before removing a Scenario finding's row, comment on its Scenario issue only when the history since this finding last reopened has no matching item-specific closure comment. Another finding's comment does not satisfy that check. Remove Triage and Backlog rows; handle an ungrouped row by its project's kind.

An already-closed issue can still need its comment, Resolution or row work completed. A retry performs those missing writes, including after a PR closing reference closed the issue, and returns unchanged only when nothing remains. Resolution changes do not add a second explanation automatically; GitHub records the field/label change, and an additional reason requires a separate comment.

Close no parent automatically. Return a parent whose last open child was closed by this run. Results distinguish changed and unchanged issues, identify issues already closed before the invocation, and report rows closed or removed.

<a id="reopening-an-issue-reopen"></a>

<a id="6-reopening-an-issue-reopen"></a>

## 6. Reopen work and handle partial results

Read the issue, ancestors, containing Schedules and relevant histories before writing. Reopen a closed issue and finish incomplete reopening work on an already-open one: clear Resolution, restore Closed or missing-Status rows to Open, preserve Open/In progress rows and a Schedule row's Worktree, and add a Triage row when it has no managed row.

Write the reopening reason only when the history since the last closure has no reopening comment. An issue that has never closed gets none. Process parents from Feature to Epic using the same missing-state checks, with comments naming the triggering issue and a Triage row when needed.

For containing Schedules, finish reopening the issue, its reason, its own row and matching every-step criteria. A Schedule that has closed before receives own-row Status In progress regardless of its present Status. A never-closed Schedule keeps the Open Status assigned at creation. Preserve its option and past rows.

Return unchanged only when no work remains. Refuse collection issues and invalid containing-Schedule identities. Reopen results identify each issue/parent/Schedule changed, cleared Resolution, affected criteria, rows restored or added, and whether the issue was already open.

| Interrupted operation | Recovery contract |
| --- | --- |
| Issue open | A repeat creates a new issue; creation recovery remains separate graph work |
| Schedule movement | Resume the supported pending-amendment state |
| Scenario movement | A comment can repeat after partial recording; additional recovery remains separate work |
| Issue close | Complete missing comment, Resolution, closure and row effects |
| Issue reopen | Complete missing reopening effects on the issue and its parents |
| Containing Schedule reopening through issue reopen | Complete its remaining row, criterion and comment effects |
| Standalone Schedule or Scenario reopen | Its already-open shortcut can still leave incomplete effects; inspect its own command contract |

These operations do not provide atomic remote transactions or protection against concurrent workers changing the same issue; the last write can win. Distinguish the supported close/reopen recovery from issue creation and Scenario-move gaps. [Creation recovery](https://github.com/NobleFactor/devlore-cli/issues/1238) and [Scenario-move recovery](https://github.com/NobleFactor/noblefactor-engprod/issues/611) retain their separate scope.

<a id="significant-design-decisions"></a>
<a id="how-each-command-runs-in-each-account"></a>
<a id="building-it"></a>

<a id="7-significant-design-decisions"></a>

<a id="8-how-each-command-runs-in-each-account"></a>

<a id="9-building-it"></a>

## 7. Decisions, representations and components

The [decision companion](10-the-issue-commands.decisions.md) preserves accepted semantics and write order. Organizations use native types and fields; user accounts use type and attribute labels. Both use their account forms and four project kinds.

Command entry files share issue and row handling through `issues.star`, `steps.star` and `ending.star`, with templates for comments. Implementation and qualification records belong to the [Issue verbs plan](../../plans/doc/589-issue-verbs.md), rather than the active architecture.
