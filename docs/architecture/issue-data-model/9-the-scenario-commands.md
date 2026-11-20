---
title: "Scenario commands"
status: draft
updated: 2026-11-19
---

<a id="9-the-scenario-commands"></a>

# Scenario commands

[Up: Issue data model](index.md)

`star github scenario` manages a reusable user journey. Its Scenario issue, project option and own row identify it; its other rows are Tasks and Bugs found during the walk. `star github issue move` changes those findings' membership and Beat.

<a id="the-commands"></a>

## 1. Interfaces

| Command | Result or effect |
| --- | --- |
| `list <account> [--team <team>]` | One record per Scenario, with identity, owner, project and finding counts |
| `get <scenario>` | Its own row first, then findings in Beat order |
| `open <repository> <name> ...`, also `create` | Scenario issue, option and own row |
| `close <scenario> --reason <text>` | Retire a Scenario no longer supported by the product |
| `reopen <scenario> --reason <text>` | Restore a closed Scenario |

Use repository-qualified issue keys and star's shared output, filter and jq flags. There is no implicit Scenario target. A user account refuses the team selector. Get returns issue identity, Type, title, state, Beat and row Status, with missing Beats last. Report includes Scenario and Beat for broader queries.

Validate prerequisites and read writes back. Partial remote writes remain possible, and retry behavior depends on the operation. `--dry-run` is refused while required reads cannot run.

<a id="what-two-pieces-already-do"></a>

## 2. Walkthrough and intake

The Scenario issue states the goal, numbered walk and Features exercised. Beat N identifies the Nth walk step; Beat 0 is before the first. Any number of findings may share a Beat. Removing a finding does not renumber others.

The repository intake workflow recognizes `Found while walking #N` or `Found while walking owner/repository#N`. When that identifies an open Scenario in the same account, with its own Scenario-project row and option, intake routes the finding there rather than to Triage. That intake path does not set Beat; a supported move sets it.

A Scenario remains useful before, during and after a release. Closing it retires the journey; it is not completion of a fixed work list and has no Evidence of completion requirement.

<a id="reading-list-and-get"></a>
<a id="opening-a-scenario-open-and-create"></a>

## 3. Open a Scenario

```text
star github scenario open <repository> <name> --area Product|Engineering --wants <text> --walk <text> --features <text> [--priority <priority>] [--assignee <login>]
```

Resolve the participating repository and its owning team's Scenario project, or the user account's project. Follow the account's Scenario form. Require Area and the goal, walk and Feature content. Refuse a walk with no numbered steps.

Create `Scenario: <name>`, with Priority Medium unless supplied and the supplied assignee or command runner. Put the filtered By scenario link before the Plan and design documents section so plan-link generation preserves it.

Create the option at the end of the Scenario field with the issue key as its description, retaining every existing option ID. Create the own row with Status Open and no Beat.

Refuse missing participation or project support, invalid form inputs and a conflicting collection option. A partially created collection can resume through its open issue title and matching option identity. A completed collection is refused as already present; this is distinct from issue-open duplicate detection.

<a id="what-a-move-records-on-a-scenario"></a>

## 4. Move findings

Only Tasks and Bugs join a Scenario. A move records both a comment on the Scenario issue, including its reason, and a line in the finding's body. Its destination row has the Scenario option, Beat and Status Open.

Moving from another Scenario preserves both collections' records before switching the row's option. Moving from a Schedule also records its amendment; moving from Triage or Backlog removes that row. On the same Scenario, a move can update Beat without duplicating membership.

Leaving a Scenario writes the collection comment first, then the body line, then changes the row. The line records the destination and, for a Schedule, its identity and Step. Use `#N` for same-repository origin and a repository-qualified reference otherwise. A failure after posting the comment may produce a duplicate on retry; it must not be described as exactly-once recording.

Refuse closed work, another account, an invalid Scenario identity or a Beat beyond the last numbered walk step. A within-Schedule reorder does not inspect or alter unrelated Scenario rows; invalid multiple membership remains a separate structural fault.

Closing a finding through the issue command comments on the Scenario and removes the finding's row. Its origin and closure evidence remain in the issue records.

<a id="closing-a-scenario-close"></a>

## 5. Retire and reopen

Close requires a reason and refuses while any finding remains open. It sets the own row Closed, posts the reason and closes the Scenario issue as completed without Resolution. Keep the option.

A Scenario served its purpose while supported; Declined, Duplicate and Invalid do not describe retirement. Preserve historical membership rather than delete an option and blank row values.

<a id="reopening-a-scenario-reopen"></a>

Reopen opens the Scenario issue, posts the reason and sets its own row Open. An already-open Scenario is unchanged. If a prior run stopped between those writes, a retry may leave the remaining row or comment work incomplete; follow the documented recovery limits.

<a id="what-the-scenarios-hold-today"></a>
<a id="ongoing-cleanup"></a>

## 6. Maintain finding rows

A closed finding leaves the Scenario. When closure bypasses `star github issue close`, remove its closed finding row and verify removal. Preserve the Scenario's own row and option, open findings, origin and closure evidence.

Recurring cleanup delivery is tracked by [Scenario cleanup (#593)](https://github.com/NobleFactor/noblefactor-engprod/issues/593); this design does not claim that automation is installed.

<a id="how-each-command-runs-in-each-account"></a>

## 7. Account representations

Organizations use the native Scenario Type and Area/Priority fields in the team's `Scenario: <team>` project. User accounts use type and attribute labels in `Scenario: <account>`. Both read `.github/ISSUE_TEMPLATE/scenario.yml` from the account's shared repository.

The project uses Default and By scenario views, with Scenario, Beat and Status fields. Status is Open, In progress or Closed. These are row states, not a substitute for a Scenario execution result.

<a id="significant-design-decisions"></a>
<a id="building-it"></a>

## 8. Decisions and delivery references

The [decision companion](9-the-scenario-commands.decisions.md) explains Beat, independent Scenario operations, movement records and retirement. Shared collection modules supply creation, reading, closure and movement, with templates for issue bodies and comments.

Implementation and qualification are recorded in the [Scenario plan](../../plans/doc/507-scenario-commands.md) and [Issue verbs plan](../../plans/doc/589-issue-verbs.md).
