---
title: "Every open noblefactor-engprod issue typed from its kind label and linked to its parent from its marker, labels and markers kept"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/380
status: complete
created: 2026-10-22
updated: 2026-10-23
---

# Plan: every open noblefactor-engprod issue typed and linked

## Summary

Task 6 of iteration 1 of the issue data model's sweep ([303-issue-data-model.md](../chore/303-issue-data-model.md)),
lane 18 of #346, approved with the task list on 2026-10-22. Section 5's step 3, new data beside the old: every open
issue in this repository gets GitHub's issue type from its kind label and GitHub's sub-issue parent from its last
`**Feature:**` or `**Chore:**` marker, or from its `Epic:<Name>` label when it is a feature or a chore, by a script
that prints every write under `--dry-run` before making one. Labels and markers stay. Nothing a session reads changes.

## Goals

1. **Every open issue carries a type**, the one its kind label names.
2. **Every open issue below an epic carries a parent link**: a lane to the parent its marker names, a feature or
   chore to the epic its label names.
3. **Nothing already there is changed**: a link that disagrees with the marker is reported, not moved; that is
   #363's decision, not this script's.
4. **You read every write before it happens.**

## Current State

Read 2026-10-22 from `gh issue list`, open issues in noblefactor-engprod:

| | Count |
| --- | --- |
| open issues | 95 |
| with exactly one kind label | 95 |
| with a type | 0 |
| with a parent link | 71 |
| with a marker and no link | 12 |
| with a link that agrees with the marker | 49 |
| with a link that disagrees with the marker | 6, reported by the audit since #383 |

The organization's five types exist with their levels (#304's day). The audit reads type and link first since #383.

## The run

Run once on 2026-10-23 under the owner's grant, after its dry run was read. Read back from GitHub afterwards:

| | Count |
| --- | --- |
| open issues | 97 |
| typed by the run | 95 |
| typed before it, filed so | 2, #384 and #385 |
| with a type that is not their kind label | 0 |
| linked by the run | 17 |
| features and chores left unlinked: no `Epic:<Name>` label, so no epic | 6, #152, #171, #206, #232, #301, #346 |
| links kept that disagree with the marker | 5 |
| chores kept linked under a feature, not their epic | 44 |

The last three rows are #363's to settle. A second dry run afterwards found nothing to write.

## Requirements

### Requirement 1: `scripts/Type-And-Link-Issues`

A repository tool under `scripts/`, bash, exempt from Declare-BashScript as the setup scripts are. It takes `--repo`,
noblefactor-engprod by default, `--dry-run`, and runs over the open issues:

1. Reads the organization's issue types from GitHub, so the label-to-type map is the type's name lower-cased, from
   the record and not from a list in the script.
2. For each issue with no type and exactly one kind label: sets the type. An issue with no kind label or two is
   reported and skipped.
3. For each issue with no parent link: a lane whose last marker names a parent gets that parent, through the old
   repository name's redirect where the marker still says it; a feature or chore gets the epic issue carrying the
   same `Epic:<Name>` label in its repository; an epic gets nothing. Markers on features and chores are not
   read. An issue with a link already is left alone, and reported when the link disagrees with the marker, or for a
   feature or chore, with its epic.
4. Under `--dry-run`, prints each write as `would: type #N Task` or `would: link #N under owner/repo#M` and changes
   nothing; without it, makes each write and prints it, and ends with the counts.

### Requirement 2: the audit after

`star gh issues audit --repo NobleFactor/noblefactor-engprod` after the run reports no open issue without a type and
none below an epic without a parent but the six with no epic label, and the disagreements the dry run reported,
unchanged.

## Implementation Phases

### Phase 1: the plan

- [x] This plan, written on `feature/380-every-open-noblefactor-engprod` and committed with the script after the run, not
  before it: a breach of the process reported to the owner on 2026-10-23

### Phase 2: the script and its dry run

- [x] The script written and lint-clean; its `--dry-run` output read by the owner
- [x] The run, by the owner or under one grant; the audit after reports every open issue typed and linked

### Phase 3: the pull request

- [x] The pull request, the script and this plan; status `complete` in its last commit, the run being done before it

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/380-type-and-link-every-open-issue.md` | Create | this plan |
| `scripts/Type-And-Link-Issues` | Create | the script |

## Related Documents

- [5-from-todays-scheme.md](../../architecture/issue-data-model/5-from-todays-scheme.md), step 3
- #379, the report that reads what this writes; #363, which settles the disagreements; devlore-cli and personal follow
  in their own runs

## Open Questions

None.
