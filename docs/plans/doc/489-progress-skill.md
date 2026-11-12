---
title: "The schedule progress skill runs the report as it is, and checks star without git"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/489
status: draft
created: 2026-11-11
updated: 2026-11-11
---

# Plan: The schedule progress skill runs the report as it is, and checks star without git

The `star-github-schedule-progress` skill, `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md`, answers
a question about a schedule. It runs `star github schedule report` with flags the report no longer has, names the audit
the sweep replaced, and reads a schedule as the lane table retired on 2026-11-03 (#489). It also checks star's build
with `git fetch`, which rule 17 makes a grant, and names a `star/config.yaml` the clone does not have (#389). After this
work every invocation the skill names runs as written, star's build is checked through GitHub, and the report reads the
three repositories the skill names.

One pull request from `doc/489-progress-skill`, resolving Task #489 and Bug #389.

## Current State

Read on 2026-11-11 from develop at `fd9a9c9`, each invocation run that day:

| What the skill says | What is so |
| --- | --- |
| `star github schedule report --by schedule --schedule <key> --markdown -o value --silent` | star refuses `--by` as an unknown flag. The report takes repositories, `--search`, and star's global `--filter`, `--jq` and `-o` |
| `--by feature --epic <Name>`, `--by thread --thread <Name>`, `--epic <Name> --view table --state open` | None of these flags exists. `--filter epic=<key>` and `--filter feature=<key>` select an epic's and a feature's issues |
| `star github schedule audit`, and `--unthreaded` | Gone; the sweep, `star github triage sweep`, took its place (#436), and it writes |
| A schedule's lanes are the table in its issue's body, Lane, Item, Next and Waits on | Retired on 2026-11-03: a step is its issue's row on its team's Schedule project, which the report gives as the issue's `home`, with the project, the schedule, the step and the Status |
| star is verified with `git fetch` in devlore-cli, then `git branch -r --contains <build>` | Rule 17 makes each git command a grant; `gh api repos/NobleFactor/devlore-cli/compare/<build>...develop` answers the same (#389) |
| The report runs from the clone, whose `star/config.yaml` names all three repositories | The clone has no `star/`; with no repositories named, the report reads writ's layers' origins (#389) |

## Requirements

### Requirement 1: each invocation runs as written (#489)

The skill names these four, each run on 2026-11-11 as written, with what each prints:

- A schedule's steps, in step order, one line each: the step, its Status, the issue, its type, what blocks it and its
  title. The schedule is found by its own issue's key, `<owner>/<repository>#<number>`, whose `home` row names it.
- An epic's issues, through `--filter epic=<key>`, and a feature's, through `--filter feature=<key>`, every state.
- What covers a symptom, through `--search`, which GitHub's issue search runs once for each repository.

Status is the first one's lines, nothing more. Status on the current issue is its lines whose Status is In progress.
What's next is one sentence: the first step whose Status is Open, the issue it maps to, and its worktree, saying when
what blocks it is still open. Each runs with `--silent --no-pager -o value`, the lines made by `--jq`.

### Requirement 2: star's build checked through GitHub (#389)

`star version` gives the build; `gh api repos/NobleFactor/devlore-cli/compare/<build>...develop` answers `ahead` or
`identical` when the build is on develop. A build that is dirty, or one GitHub does not find on develop, is someone's
work in progress: used read-only, never replaced by `make install`.

### Requirement 3: the repositories named (#389)

Each invocation names the repositories it reads: NobleFactor/noblefactor-engprod, NobleFactor/devlore-cli and
David-Noble-at-work/personal, the three the process works in. It runs from anywhere.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | Each of the four invocations, run as the skill writes it | Its lines, as the skill says |
| 2 | The build check, on the installed star | `ahead` or `identical` |
| 3 | `make check` | Passes |

## Implementation Phases

### Phase 1: the plan

- [ ] Written and committed on `doc/489-progress-skill` by the worktree's first script, which opens the branch with
      `git open-branch 489 -T doc`, since the kind labels it reads were retired on 2026-11-03; reviewed with the owner

### Phase 2: the skill

- [ ] Requirements 1 to 3 in the skill, each invocation run as written; `make check` passes

### Phase 3: merge

- [ ] The pull request script written, shown and handed over. It closes #489 and #389, comments on #489 each
      invocation's output, and runs `git close-branch`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/489-progress-skill.md` | Create | This plan |
| `Home/common/.claude/skills/star-github-schedule-progress/SKILL.md` | Modify | Requirements 1 to 3 |

## Related Documents

- [agent-rules.md](../../guides/agent-rules.md), rules 1, 3 and 17
- #436: the sweep, which took the audit's place
- #426: GitHub is the model, and the steps are its Schedule projects' rows

## Open Questions

None. #489's and #389's Solutions settle the fix.
