---
title: "Schedule commands"
status: draft
updated: 2026-11-19
---

<a id="8-the-schedule-commands"></a>

# Schedule commands

[Up: Issue data model](index.md)

`star github schedule` reads and manages a Schedule's own issue, option and row. `star github issue move` manages its Tasks and Bugs. A Schedule is identified by its repository-qualified issue key; its team's Schedule project holds the ordered work.

<a id="the-commands"></a>

## 1. Interfaces and shared behavior

| Command | Result or effect |
| --- | --- |
| `report [<repository>...] [--search <query>]` | Flat issue records for broader hierarchy or repository questions |
| `list <account> [--team <team>]` | One record per Schedule option, with identity, project, owner and open/closed step counts |
| `get <schedule>` | Its own row first, then work in Step order |
| `open <repository> <name> ...`, also `create` | Schedule issue, option and own row |
| `close <schedule>` | Close a completed Schedule and post its evidence |
| `reopen <schedule> --reason <text>` | Reopen its issue and restore its active row and completion criterion |

A key is `<owner>/<repository>#<number>`, also the form used by `NFEP_AGENT_SCHEDULE`. Commands have no implicit account or Schedule target. Star's `--filter`, `--jq` and `--output` select, reshape and render flat records; JSON is the default output.

Validate prerequisites before writes and read writes back. Remote failures can still leave partial state; these operations are not atomic transactions. The command-specific recovery limits below apply. Commands refuse `--dry-run` while the required reads cannot run under it.

<a id="reading-list-get-and-report"></a>

## 2. Read work

List reads an account's Schedule projects, optionally restricted to one team. A user account has no team selector, so `--team` is refused there.

Get returns Step, issue key, Type, title, issue state, row Status, Worktree, Iteration and blocked-by keys. Its own row has no Step. Work rows without a Step come last and constitute a classification fault.

Report includes each issue's project membership, Schedule and Step. Use it for questions spanning Features, Epics or repositories; use get for one Schedule.

```text
star github schedule get NobleFactor/noblefactor-engprod#346 --output csv
star github schedule report NobleFactor/devlore-cli --search is:open --filter parent=NobleFactor/devlore-cli#463 --output table
```

<a id="opening-a-schedule-open-and-create"></a>

## 3. Open a Schedule

```text
star github schedule open <repository> <name> --area Product|Engineering --deliverable <text> --exit-criteria <text> --evidence <text> [--priority <priority>] [--assignee <login>]
```

Resolve the participating repository and its owning team's Schedule project, or the user account's equivalent. Read the account's Schedule form and validate its required content and metadata.

Create `Schedule: <name>` with Priority Medium unless supplied, and assign it to the supplied login or command runner. The form owns the body sections; the command adds the Steps link to the filtered By schedule view and an Amendments section.

Create the `<name>` option at the end of the Schedule field, with the issue key as its description and GRAY as its color. Preserve every existing option's ID. Create the issue's own row with that option, Status Open and no Step, positioned after the last collection group.

Refuse unsupported participation, missing project or fields, invalid Area, required content left empty or an occupied name that cannot be matched to the same partially created collection. An already complete issue/option/row combination is refused as already present.

A partial open can resume by finding the open issue with the expected title, then the matching option and own row, and creating missing pieces. That lookup is by repository and title with option-identity checks; it is not full equality of every supplied filing value.

<a id="changing-a-schedule-add-move-and-remove"></a>
<a id="moving-an-issue-issue-move"></a>
<a id="what-a-move-records-on-a-schedule"></a>

## 4. Record work changes

`star github issue move` adds work, reorders it or removes it. Each change writes an amendment naming the date, command runner, change and reason. The command records who performed it, not who authorized it. Owner commitment remains a process requirement.

The amendment is written first with `(in progress)` and settled after the supported move finishes. Pending Schedule amendments support resuming a stopped move; other side effects and recovery limits remain governed by the [issue command contract](10-the-issue-commands.md#moving-an-issue-move).

Adding work appends it or inserts it after `--after`; `--after 0` inserts first. Moving work reorders it, and removing it closes the gap. Renumber affected open and closed steps so the sequence remains consecutive. Multi-issue removals apply in input order.

A destination row receives its Schedule option, Step and Status Open. `--blocked-by` adds the supplied same-account dependency links without dropping existing ones. Cross-team work requires an accountable assignee in the receiving team. Iteration remains available for sprint planning.

Refuse a closed Schedule, a missing Schedule issue identity, an invalid insertion point or prohibited issue/account placement. An issue already on the Schedule needs a valid within-Schedule move rather than a duplicate row.

<a id="closing-a-schedule-close"></a>

## 5. Close a Schedule

Close refuses while any work step is open or an exit-criterion checkbox is unticked. Read criteria from Exit criteria, falling back to Evidence of completion when that section is absent.

Write in this order: set the collection's own row Closed, post its evidence comment, then close its issue as completed. This keeps the issue open until the earlier writes finish.

The evidence groups steps by the merged PR that closed them, in merge order, with each PR's merge date. Then it lists steps closed without a merged PR and their Resolution or GitHub closure reason. Every step appears once. A PR that only mentions an issue is not closure evidence; use GitHub's closing relationship or the commit that closed it.

Keep the Schedule option and closed work rows. Their field value records membership independently of the product parent links. GitHub's [50-option single-select limit](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields/about-single-select-fields) requires a retention design before capacity is exhausted; deleting an option would clear row membership.

A retry after a comment was posted but before closure may post another comment. Readback does not establish exactly-once comment delivery.

<a id="reopening-a-schedule-reopen"></a>

## 6. Reopen a Schedule

Reopen the issue and comment with the runner, date and reason. Set its own row In progress. Untick checked Exit criteria whose text begins `Every step` or `Every other step`. With no matching criterion, reopen normally and report that none was unticked.

The option and past rows remain. Reopening a work issue also reopens each closed Schedule containing it through this contract.

An already-open Schedule returns unchanged. If a prior run stopped after reopening its issue but before updating the row or criteria, this shortcut does not complete those remaining writes. Inspect and repair the incomplete state rather than assume a retry finishes it.

<a id="start-claude"></a>
<a id="how-each-command-runs-in-each-account"></a>

## 7. Hosts and account representations

Start-Claude and Start-Claude.ps1 attach through the Schedule key and create no Schedule. Their refusal names `star github schedule open` when asked to create one.

Organizations use native Schedule Type, issue fields and the owning team's project. User accounts use the `schedule`, `area:` and `priority:` labels and their account project. Both read `.github/ISSUE_TEMPLATE/schedule.yml` from the account's shared repository.

<a id="linking-plans-plan-link"></a>

## 8. Link plans

```text
star github plan link <plan>... [--check]
star github plan link --all [--repository <owner/name>,...] [--check]
```

Named plans are relative to `docs/plans` in the current clone. `--all` reads plans on the selected repositories' default branches, using writ's layers when none are supplied. `--repository` accepts a comma-separated list.

A plan serves its `issue:` and each `## Issue NNN` entry. Its frontmatter `documents:` supplies design links. For every served issue, generate the entire Plan and design documents section from all applicable plans: one Plan row per plan, then its documents.

Recognize that section at heading level 2 or 3. Append it when absent; refuse duplicate headings. Leave issues without a serving plan untouched. Check mode writes nothing and returns the proposed changes, including rows that would be dropped.

Records contain issue identity, serving plans, action, before/after section and dropped rows. Actions are written, unchanged, appended or refused. Under `--all`, finish other issues before reporting collected errors. A failed read or mismatched writeback is an error.

Open-issue links target the default branch. Links for an issue closed by a merged PR target that PR's merge commit. The [plan-link design and evidence](../../plans/feature/557-plan-row.md) defines the complete cases.

<a id="significant-design-decisions"></a>
<a id="building-it"></a>

## 9. Decisions, components and delivery

The [decision companion](8-the-schedule-commands.decisions.md) preserves the accepted choices and their reasons. Shared modules separate collection creation, reading, closure and movement: `making.star`, `collections.star`, `ending.star` and `steps.star`. Command entries and templates expose those operations without a second work model.

Implementation and verification belong to the [Schedule plan](../../plans/doc/439-schedule-commands.md), [Scenario plan](../../plans/doc/507-scenario-commands.md) and [Issue verbs plan](../../plans/doc/589-issue-verbs.md). Automatic completion of additional partial operations is separate work in [Recovery (#609)](https://github.com/NobleFactor/noblefactor-engprod/issues/609).
