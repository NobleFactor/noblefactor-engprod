---
title: "The Triage workflow leaves Schedule and Scenario issues out of Triage"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/573
status: draft
created: 2026-11-16
updated: 2026-11-16
documents:
  - kind: "Design: triage"
    path: "docs/architecture/issue-data-model/4-storage-and-reach.md"
    text: "section 4, § Triage"
  - kind: "Design: collections"
    path: "docs/architecture/issue-data-model/3-collections.md"
    text: "section 3"
---

# Plan: The Triage workflow leaves Schedule and Scenario issues out of Triage

Step 48 of issue tracking, iteration 1 (#346). Each participating repository's Triage workflow adds every issue opened
or transferred to its team's Triage project, unless it was found while walking a scenario. A Schedule or Scenario issue
belongs on its Schedule or Scenario project as its collection's own row, and an issue is a row of at most one of its
account's projects (ruled 2026-11-04), so each one lands on two. The owner ruled on 2026-11-16 to fix it at the source,
so that `star github schedule new` and `scenario new` (#509, step 51, blocked by this) neither wait for nor remove a
Triage row.

Four pull requests, one at a time, as #448's were: NobleFactor/.github, David-Noble-at-work/.github, the pull requests
`star github model apply` lands in each account's participating repositories, and last this repository's, from
`feature/573-triage-collections`, which closes #573.

## Rulings

- 2026-11-04: an issue is a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects; a
  Schedule or Scenario issue's own row is on its collection's project.
- 2026-11-10 (#437): `star github model apply` lands each participating repository's workflow from its account's
  template, through a pull request on its default branch.
- 2026-11-16: the Triage workflow leaves a Schedule or Scenario issue out of Triage, fixed at the source; `new` does not
  wait for a Triage row.

## Current State

Read on 2026-11-16:

| What | Where it stands |
| --- | --- |
| Both accounts' `workflow-templates/triage.yml` | Run on an issue opened or transferred. The scenario step puts an item found on a walk in its scenario and sets `placed`; `actions/add-to-project` then adds every other issue to Triage, `if: steps.scenario.outputs.placed != 'true'`; then the Area and Severity steps |
| The copies | NobleFactor's five participating repositories and personal each run their account's template as it stands |
| The case | #572, a Task moved here on 2026-11-15, was put in Triage: engprod by its transfer. Every Schedule or Scenario issue filed from its form goes to Triage the same way |

## Requirements

1. **A step in both templates,** just before the Triage step, that reads the issue's type when it runs, as the Severity
   step does, or in David-Noble-at-work its labels, and sets `collection` when it is Schedule or Scenario, or carries
   the `schedule` or `scenario` label; its log says so.
2. **The Triage step's condition** gains `steps.collection.outputs.collection != 'true'`. The scenario, Area and
   Severity steps are unchanged: Area applies to every type, and a collection's Severity is N/A.
3. **Applied.** `star github model apply` on each account lands its template in each participating repository, and
   `star github model diff` then shows no difference.
4. **The documents** that say the workflow adds every new issue to Triage name the exception.

## Test Plan

Each test issue is filed through GitHub's REST API with the body, type and labels its form gives, and closed afterward
with Resolution Invalid, or `resolution:invalid` in David-Noble-at-work, its rows removed.

| # | Case | Expect |
| --- | --- | --- |
| 1 | shellcheck on each template's run steps | Clean |
| 2 | In noblefactor-engprod, a Schedule issue and a Scenario issue | No Triage row; Area set; Severity N/A; the log says it is a collection |
| 3 | In noblefactor-engprod, a Task | A Triage: engprod row, as before |
| 4 | In personal, an issue labeled `schedule`, and a Task | No Triage row for the first, and its `area:` and `severity:n/a` labels; a Triage: David-Noble-at-work row for the Task |
| 5 | `star github model diff` on both accounts, after `apply` | No difference |

## Implementation Phases

### Phase 1: the plan

- [ ] Committed on `feature/573-triage-collections` by the worktree's first script, which also sets step 48 In
      progress with the branch linked; reviewed with the owner

### Phase 2: NobleFactor's template

- [ ] The step and the condition in NobleFactor/.github's template, on `feature/573-triage-collections`, its worktree
      made by hand as #448's was, since `git open-branch` reads only the clone's own issues; merged; `apply` on
      NobleFactor; `diff` shows no difference

### Phase 3: David-Noble-at-work's template

- [ ] The same in David-Noble-at-work/.github's template; merged; `apply` on David-Noble-at-work lands it in personal;
      `diff` shows no difference

### Phase 4: the evidence

- [ ] The test issues filed, their rows, fields, labels and runs read back, each closed with Resolution Invalid and its
      rows removed

### Phase 5: the documents and the merge

- [ ] The documents name the exception; this repository's pull request merged, closing #573 with the evidence; step 48
      Closed

## Files to Create/Modify

| Repository | File | Action |
| --- | --- | --- |
| NobleFactor/.github | `workflow-templates/triage.yml` | Modify |
| David-Noble-at-work/.github | `workflow-templates/triage.yml` | Modify |
| NobleFactor's five participating repositories, and personal | `.github/workflows/triage.yml` | Landed by `apply` |
| noblefactor-engprod | `docs/plans/feature/573-triage-collections.md` | Create |
| noblefactor-engprod | The documents that say every new issue goes to Triage | Modify |

## Related Documents

- [Section 4, § Triage](../../architecture/issue-data-model/4-storage-and-reach.md#triage) and
  [section 3, Collections](../../architecture/issue-data-model/3-collections.md)
- #448, which added the scenario and Severity steps; #509, `new`, blocked by this; #572, which may change the same
  templates for the form's Area section, in another session

## Open Questions

None.
