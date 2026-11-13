---
title: "Every open issue in its place: typed, and under a parent of the level above"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/365
status: complete
created: 2026-11-12
updated: 2026-11-12
---

# Plan: Every open issue in its place: typed, and under a parent of the level above

Step 32 of issue tracking, iteration 1 (#346), its last exit criterion: the deployed report shows every open issue
under its parent. #365's own check names `--view tree` and `star github schedule audit`, retired by #379 on
2026-11-08, so it is restated to the owner's rules below and to the report as built. One pull request from
`doc/365-every-issue-in-its-place`, resolving #365.

## Rulings

- 2026-11-12, the check, in four rules, over open issues only:
  1. No issue without a type: Epic, Feature, Task, Bug, Schedule or Scenario.
  2. No epic with a parent.
  3. No feature without a parent that is an epic.
  4. No task or bug without a parent that is a feature.
  5. No issue under a closed parent: when an open issue sits under a closed one, the closed parent is reopened, and
     its own parents up the tree. Ruled the same day: this holds until the first release or pre-release; then every
     epic tree is archived with the release's tag, and the release gets a hotfix epic.
- 2026-11-12, on the proposals: #374 goes under #518, at Priority Low, worth diagnosing. #403 goes under #419, and is
  more than a document: a trigger files each round of maintenance tasks for every team's repositories and sends notice
  to each team's owner; devlore-cli#1212 files them for devlore-cli alone today. #403's body is brought to it.
- 2026-11-12: personal#234, the git-crypt cleanup, goes under personal#317.
- 2026-11-12: devlore-cli#671, checks run on real Linux and Windows machines, goes under #518.
- 2026-11-12: every other proposal approved as written, and the five features under closed epics moved, as the
  last table has them.

## Current State

Read on 2026-11-12 from the deployed report, every repository of writ's layers:

| Rule | Open issues that break it |
| --- | --- |
| 1 | 3, all in personal: #147, #151, #251 |
| 2 | none |
| 3 | 5 with no parent: personal#229, #234, #254; devlore-cli#1063, #1147 |
| 4 | 26: 25 with no parent, and #340, under Epic #526 |

Not broken, but worth a word: features #140, #158, #176 and #295 sit under Epic #142, closed, which #526 took over; and
devlore-cli#955 under devlore-cli#740, a closed epic.

## Proposals

Each row is one issue and what is proposed for it, for the owner to rule. Where my confidence is low, the row says so.

### Rule 1: a type, and a feature to sit under

| Issue | What it is | Proposed |
| --- | --- | --- |
| personal#147 | wiki/git-workflow.md describes a workflow the repository does not use | Task, under personal#229, personal tooling to the base's standard |
| personal#151 | tmux's prefix C-b collides with Claude Code's Ctrl+B | Bug, under personal#254, the development environment |
| personal#251 | core.hooksPath is set on every platform but supplied only on Unix | Bug, under personal#254 |

### Rule 3: an epic for each feature

| Issue | What it is | Proposed |
| --- | --- | --- |
| personal#229 | The personal layer's tooling holds to the base's standard | Under personal#317, the process and tooling the work runs on |
| personal#234 | What personal commits is what every machine deploys | Under personal#317 (ruled) |
| personal#254 | The development environment: terminal, tmux and shell | Under personal#317 |
| devlore-cli#1063 | The knowledge extension, `star devlore knowledge` | Under devlore-cli#1065, Star |
| devlore-cli#1147 | Each tool's configuration has one home | Under devlore-cli#441, Unified configuration |

### Rule 4: a feature for each task and bug

| Issue | What it is | Proposed |
| --- | --- | --- |
| personal#152 | Start-Claude's log pane cannot follow a rotated file | Decline: the owner is done with Start-Claude |
| personal#157 | Migrate main to a ruleset | Under personal#229 |
| personal#171 | The Windows PowerShell profile normalizes TERM | Under personal#254 |
| personal#173 | The README and packagers still describe stow and tuckr | Under personal#229 |
| personal#268 | Windows git config lacks core.longpaths | Under personal#254 |
| personal#275 | personal commits Windows Terminal's settings.json | Under personal#254 |
| personal#305 | CLAUDE.md names the clone by its old name, noblefactor-ops | Close as completed: CLAUDE.md names it nowhere (read 2026-11-12) |
| personal#309 | personal keeps its own issue records | Under personal#318, issue tracking for David-Noble-at-work |
| devlore-cli#671 | Run the execution matrix on real machines | Under #518, cross-platform execution (ruled) |
| devlore-cli#674 | The knowledge base publishes provider names, not commands | Under devlore-cli#1063, the knowledge extension |
| devlore-cli#675 | Publish a generated Starlark reference for package authoring | Under devlore-cli#465, user-facing guides |
| devlore-cli#703 | Two comments give opposite extension precedence | Under devlore-cli#1097, the extension runtime |
| devlore-cli#730 | Starlark tuple, list and set collapse to []any | Under devlore-cli#459, provider value types and conversion |
| devlore-cli#785 | Every packages-manifest uses a form the loader cannot parse | Under devlore-cli#72, lore manifest commands |
| devlore-cli#1124 | STATUS.md links a renamed document | Under devlore-cli#1217, architecture documents describe the code as built |
| devlore-cli#1142 | writ remembers a project name no layer carries | Under devlore-cli#463, writ's command surface |
| devlore-cli#1185 | The star reference names star gh issues, now star github schedule | Under devlore-cli#1095, star docs |
| #340 | A session ran unread: the process documents not read until asked | Under #316, agent conduct, in place of Epic #526 |
| #374 | git over ssh hangs in Windows OpenSSH on danoble-wd11-3 | Under #518, Priority Low (ruled) |
| #392 | Lingering worktrees, scripts, strays and test sessions | Under #157, PR tooling |
| #398 | Markdown paragraphs are not wrapped | Under #419, shared engineering documentation |
| #399 | The documentation standards say how a design or plan reads | Under #419 |
| #403 | Dependencies updated on a regular cadence everywhere | Under #419; its body gains the trigger and the notice to team owners (ruled) |
| #409 | Design the commands that empty the triage queue | Under #332, the issue tooling |
| #434 | A session's schedule link names the issue, not the project | Under #332 |
| #487 | model apply makes a second template when run again | Under #332 |

### Rule 5: the features under closed epics

| Issue | What it is | Ruled |
| --- | --- | --- |
| #140 | The epic report becomes a star extension | Under Epic #330, Issue tracking |
| #158 | Process commands relocated to the layer that owns them, and linted | Under Epic #526, the engineering handbook |
| #176 | The ownership hierarchy becomes GitHub's: sub-issues and issue types | Closed as completed: #303 did it, and it has no open work |
| #295 | Test machines: a plan's virtual-machine run through one harness | Under Epic #514, whose #518 owns cross-platform execution |
| devlore-cli#955 | Every program is a devlore program | Under Epic devlore-cli#453, release, distribution and self-install |

Read on 2026-11-12, these five were the only open issues under a closed parent, and every new parent above is open.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | The check, from the deployed report, after the changes | Each of the five rules: none |
| 2 | Every change | Read back from GitHub |

The check, run from any directory:

```
star github schedule report --silent --jq '(map({key: .issue, value: .type}) | from_entries) as $t
  | (map({key: .issue, value: .state}) | from_entries) as $s
  | [.[] | select(.state == "open")]
  | {untyped: [.[] | select(.type == null) | .issue],
     epics_with_parent: [.[] | select(.type == "Epic" and .parent != null) | .issue],
     features_not_under_an_epic: [.[] | select(.type == "Feature" and $t[.parent // ""] != "Epic") | .issue],
     leaves_not_under_a_feature: [.[] | select((.type == "Task" or .type == "Bug") and $t[.parent // ""] != "Feature") | .issue],
     under_a_closed_parent: [.[] | select(.parent != null and $s[.parent] == "closed") | .issue]}'
```

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `doc/365-every-issue-in-its-place`, step 32's row In progress with the branch linked; the proposals
      ruled by the owner, 2026-11-12

### Phase 2: the changes

- [x] Each ruled change made in GitHub by a script, read back; #365's body restated to the five rules and the check.
      Done 2026-11-12: personal's three issues typed, 36 issues moved, none needing a parent reopened; #374 at
      Priority Low; #403 given its ruling; personal#305 and #176 closed as completed, personal#152 declined

### Phase 3: merge

- [x] The check run, 2026-11-12, finding nothing under any rule; its output goes on #365 with the pull request, which
      closes #365 and sets step 32 Closed

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/doc/365-every-issue-in-its-place.md` | Create | This plan |

## Open Questions

None. Ruled 2026-11-12 (§ Rulings).
