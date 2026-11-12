---
title: "The schedule progress skill checks star's build through GitHub, with no git command"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/389
status: complete
created: 2026-11-11
updated: 2026-11-11
---

# Plan: The schedule progress skill checks star's build through GitHub, with no git command

The `star-github-schedule-progress` skill, `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md`, checks
that the installed star is a build of devlore-cli's `develop` with `git fetch` and `git branch -r --contains`, and rule
17 makes each git command a grant (#389). After this work it asks GitHub through `gh`, which needs no grant.

One pull request from `doc/489-progress-skill`, resolving Bug #389. The branch was opened for Task #489, which named
three faults in the skill: invocations with flags the report no longer takes, the audit, and the lane tables. Reading
the skill on the branch showed none of them there: #379 rewrote it on 2026-11-08, and #489 was filed against a copy of
the skill loaded into the session before that. #489 was closed as not planned on 2026-11-11, and the owner kept the
branch for #389 the same day.

## Current State

Read on 2026-11-11 from develop at `fd9a9c9`:

| What the skill says | What is so |
| --- | --- |
| star is verified with `git fetch` in devlore-cli, then `git branch -r --contains <build>` | Rule 17 makes each git command a grant; `gh api repos/NobleFactor/devlore-cli/compare/<build>...develop` answers the same, and answered `ahead` that day |
| The report runs anywhere: with no repositories named, it reads writ's layers | So: #389's other fault, a `star/config.yaml` the clone did not have, went with #379's rewrite |
| A schedule's steps, an epic's and a feature's issues, bugs, and what covers a symptom: five invocations | Each runs as written; the status one listed #346's steps in step order that day |

## Requirements

### Requirement 1: star's build checked through GitHub (#389)

`star version` gives the build, and `gh api repos/NobleFactor/devlore-cli/compare/<build>...develop` answers `ahead` or
`identical` when the build is on `develop`. A build that is dirty, or one GitHub answers `behind` or `diverged` for, or
does not have, is another session's work in progress: used read-only, never replaced by `make install`.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | The build check, run as the skill writes it, on the installed star | `ahead` or `identical` |
| 2 | `make check` | Passes |

## Implementation Phases

### Phase 1: the plan

- [x] Written and committed on `doc/489-progress-skill` by the worktree's first script, which opened the branch with
      `git open-branch 489 -T doc`, and reviewed with the owner: approved 2026-11-11. Rewritten the same day to #389
      alone, as the owner chose once the skill proved current but for #389's fault

### Phase 2: the skill

- [x] Requirement 1 in the skill's "Verify star first"; the check, run as written on 2026-11-11, answered `ahead`;
      `make check` passes

### Phase 3: merge

- [x] The pull request script written, shown and handed over. It closes #389, comments on it the check's output, and
      runs `git close-branch`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/489-progress-skill.md` | Create | This plan |
| `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md` | Modify | Requirement 1 |

## Related Documents

- [agent-rules.md](../../guides/agent-rules.md), rules 1, 3 and 17
- #379: the rewrite of 2026-11-08 that brought the skill to the report as it is
- #489: closed as not planned, filed against the copy of the skill before #379

## Open Questions

None.
