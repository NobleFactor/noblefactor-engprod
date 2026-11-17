---
title: "star github issue move reads the schedule or scenario an issue leaves before its first write"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/531
status: approved
created: 2026-11-17
updated: 2026-11-17
documents:
  - kind: Design
    path: docs/architecture/issue-data-model/8-the-schedule-commands.md
  - kind: Design
    path: docs/architecture/issue-data-model/9-the-scenario-commands.md
---

# star github issue move reads the schedule or scenario an issue leaves before its first write

[Up: Plans](../../index.md)

## 1. Role assignments

Owner David Noble. Participant: Claude Code, in the session working [issue tracking, iteration 1 (#346)](https://github.com/NobleFactor/noblefactor-engprod/issues/346), step 55. Reviewer: the owner. Observers: none.

## 2. Summary and promised result

`star github issue move` refuses, with nothing written, when a schedule or scenario an issue leaves can't be read: a source Schedule issue whose own row has no option, or a scenario option that names no Scenario issue. Today it finds the fault only after its first write and stops halfway. The command's syntax doesn't change.

## Issue 531

[NobleFactor/noblefactor-engprod#531](https://github.com/NobleFactor/noblefactor-engprod/issues/531), Task, Area Product, under Feature #332. Rewritten on 2026-11-17 for `issue move`, which replaced `schedule add`; the owner approved the work that day.

## 3. Current state

`--schedule` writes the amendment "(in progress)" in the destination's Schedule issue, then `_take_off` finds and reads the source schedule and `_record_leaving` finds the source Scenario issue. `--triage` writes its schedules' amendments, then `_record_leaving` finds the Scenario issue. `--triage` and `--backlog` off a schedule already resolve the source schedule first, and `--scenario` takes issues only from Triage.

## 4. Design impact

None: section 8 already says the command refuses before it writes anything.

## 5. Proposed implementation

- `steps.star`: `_collection`'s checks move into `_collection_read`, which returns `(collection, fault)`; `_collection` fails on the fault as before, and `read_schedule` returns it.
- `github-issue-move.star`: `_source_schedule` and `_source_scenario` read a source and return its fault; `--schedule`'s refusal pass and `--triage`'s and `--backlog`'s read every source with them, a fault joining the refusals; `_take_off` and `_record_leaving` use what was read and look nothing up.
- `tests/Test-StarGitHub`: cases 119 to 121, each refused with nothing written.

## 6. Alternatives and challenges

- **Catching the fault where it falls.** Starlark has no way to catch a `fail`, so the read has to return the fault.

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| A broken source schedule is refused, nothing written | case 119 passes | `tests/Test-StarGitHub`, on #531 | this branch |
| A broken source scenario is refused, nothing written | cases 120 and 121 pass | `tests/Test-StarGitHub`, on #531 | this branch |
| The cases test the fix | run against the code before it, the three fail | the run's output, on #531 | `develop` before the merge |
| Nothing else changes | the other 392 cases pass | `make check` | this branch |

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | yes | this branch | Done |
| Merge | yes | the pull request, closing #531 | Pending |
| Deployment | yes: writ deploys the extension from this repository | the owner's next `writ deploy` | Pending |
| Verification | yes | the cases, on #531 | Pending |

## 9. Implementation phases

### 9.1 Phase 1: the plan

- [x] This plan, approved by the owner on 2026-11-17

### 9.2 Phase 2: the fix and its cases

- [x] `read_schedule`, `_source_schedule` and `_source_scenario`; the refusal passes read every source; cases 119 to 121 pass, and fail against the code before the fix

### 9.3 Phase 3: merged

- [ ] The pull request merged, closing #531, with the evidence posted

## 10. Files and related assets

- Modify: `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/steps.star` and `github-issue-move.star`; `tests/Test-StarGitHub`.

## 11. Dependencies, overlaps and blockers

- develop's ruleset requires a code owner's approving review; the owner authored the pull request, so its merge bypasses the review only with the owner's explicit approval for it, given by running the script with `--bypass-review` (pull request procedure, § 3).

## 12. Approval and departures

Approved by the owner on 2026-11-17.

## 13. Completion review

Pending.
