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

## 3. Open an issue

```text
star github issue open --type <type> --parent <issue> --area <area> --title <title> --body-file <path> [--priority <priority>] [--severity <severity>] [--assignee <login>] [--unique] [--directory <path>]
star github issue open --template <path> [--set <name>=<value>,...] [--directory <path>]
```

Use the repository named by the clone's origin. `--directory` selects another clone. An Epic has no parent; other hierarchy types require a parent exactly one level above, within the account.

A template has a YAML header followed by its Markdown body. Header keys are type, parent, title, area, priority, severity, assignee and unique. With `--template`, use only `--set` and `--directory` alongside it. Comma-separated substitutions fill `{name}` once; inserted values are not recursively expanded, and shell-style `${name}` remains literal. Quote header placeholders so YAML does not interpret braces as structure. Refuse unfilled or malformed inputs.

Read the account model, parent, metadata options and selected Type's form from its shared `.github` repository. Validate participation, allowed Type, parent level, Area, required body sections and text, and a valid Plan and design documents table outside code blocks. Only Bugs accept an explicit Severity.

Priority defaults to Medium. Bug Severity defaults to Medium; other typed issues have N/A. No assignee is selected unless supplied. Write native organization fields or the corresponding user-account labels, then read back the issue and metadata.

### 3.1 Optional duplicate detection

With `--unique`, inspect the parent's sub-issues for the same title, whether open or closed. A match returns `found` without opening another issue. This rule is parent-and-title matching, not equality of body, attributes or state. It does not reopen a closed match.

Without that option, ordinary issue open creates a new issue. It is distinct from collection open, which can resume an identifiable partially created collection. Record these semantics accurately rather than infer a general retry or content-deduplication guarantee.

<a id="moving-an-issue-move"></a>

## 4. Move work

```text
star github issue move <issue>... (--triage | --backlog | --schedule <schedule> [--after <step>] [--blocked-by <issue>,...] [--assignee <login>] | --scenario <scenario> --beat <beat>) --reason <text>
```

Give exactly one destination. Process issues in input order and permit only destinations allowed by Type. An already-satisfied destination is unchanged unless a valid within-collection change is requested.

Read every source collection once before writing and reread its rows immediately before mutation. Refuse a changed source snapshot, closed issue, another account, collection issue or invalid destination inputs before the affected write.

Leaving a Schedule records its amendment, removes the row and renumbers later open and closed steps. Leaving a Scenario comments on it, writes the finding's departure line and changes its row. Leaving Triage or Backlog removes that row.

Joining a Schedule appends or inserts steps and adds specified same-account blocked-by links without discarding existing dependencies. Cross-team placement requires an accountable receiving-team assignee. Joining a Scenario sets its Beat; joining Triage or Backlog sets Status Open and retains issue Priority. [Schedule](8-the-schedule-commands.md#what-a-move-records-on-a-schedule) and [Scenario](9-the-scenario-commands.md#what-a-move-records-on-a-scenario) contracts define their records and failure boundaries.

<a id="closing-an-issue-close"></a>

## 5. Close work

Give exactly one of an evidence file or a Resolution. Resolution requires a reason; evidence mode forbids a separate reason and requires a nonblank file. Refuse collection issues and an invalid Scenario identity before writing.

For each issue, preserve this write order:

1. Post the evidence file verbatim, adding an Evidence heading when it lacks one, or the runner/date/Resolution/reason comment.
2. Set Resolution when the work was not done.
3. Close the issue as completed.
4. Update its project rows.

Keep Schedule rows and set them Closed. Comment on the Scenario before removing a finding's row. Remove Triage and Backlog rows. An ungrouped row follows its project's kind, without inventing a Scenario to notify.

An already-closed issue is unchanged. Do not close a parent automatically; return its identity when this was its last open child. Returned records identify closed or unchanged issues and rows closed or left.

A PR's closing reference can close an issue outside this command. Its Scenario row still needs the [defined cleanup](9-the-scenario-commands.md#ongoing-cleanup); do not claim that closure alone removed it.

<a id="reopening-an-issue-reopen"></a>

## 6. Reopen work and handle partial results

Read the issue, ancestors and containing Schedules before writing. For a closed issue, reopen it, clear Resolution, post the reason, and set existing managed rows Open while retaining a Schedule row's Worktree. With no managed row, add a Triage row.

Reopen closed parents from Feature to Epic, with comments identifying the triggering issue. A parent without a row receives a Triage row. Reopen closed containing Schedules through their own contract: issue open, reason recorded, own row In progress and matching every-step criteria unticked.

An already-open issue's own rows and Resolution are left unchanged, although its closed parents and Schedules are still considered. Refuse collection issues or an invalid containing Schedule identity.

| Interrupted operation | Retry limit |
| --- | --- |
| Issue open without unique detection | Can create another issue |
| Issue open with unique detection | May find the same parent/title, including a closed issue; it does not finish arbitrary missing metadata |
| Schedule movement | Can resume the supported pending-amendment state |
| Scenario movement | Can repeat a comment after partial recording |
| Close after issue closure | Returns unchanged and leaves unfinished row cleanup |
| Reopen after issue reopening | Can leave the issue's Resolution or rows unfinished |
| Containing Schedule reopen after its issue opens | Can leave its own row or criterion unfinished |

Inspect the known outcome and complete the documented manual repair: close a confirmed duplicate as Duplicate, clear a stale Resolution, set or remove a row, or correct the affected criterion. Do not rerun blindly or claim exactly-once side effects. Automatic recovery beyond those delivered paths is [separate work](https://github.com/NobleFactor/noblefactor-engprod/issues/609).

<a id="significant-design-decisions"></a>
<a id="how-each-command-runs-in-each-account"></a>
<a id="building-it"></a>

## 7. Decisions, representations and components

The [decision companion](10-the-issue-commands.decisions.md) preserves accepted semantics and write order. Organizations use native types and fields; user accounts use type and attribute labels. Both use their account forms and four project kinds.

Command entry files share issue and row handling through `issues.star`, `steps.star` and `ending.star`, with templates for comments. Implementation and qualification records belong to the [Issue verbs plan](../../plans/doc/589-issue-verbs.md), rather than the active architecture.
