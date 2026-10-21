---
title: "Start-Claude --continue takes --schedule, and both test scripts prove every way in, with a schedule and without"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/322
status: draft
created: 2026-10-21
updated: 2026-10-21
---

# Plan: Start-Claude --continue takes --schedule, and both test scripts prove every way in, with a schedule and without

## Summary

The second half of lane 13 of NobleFactor/noblefactor-ops#301, the schedule's last lane. `--continue` and `-Continue`
take `--schedule` and `-Schedule`, as `--resume` and `-Resume` do, so that a conversation continued in a clone can be
put on a schedule, and no way in requires one. Both test scripts gain a case for each way in, with a schedule and
without, and the check David-Noble-at-work/personal#259's plan left as its row 2: a conversation resumed in another
clone by `--schedule` with `--directory` is the one `--continue` finds there.

## Schedule

Lane 13 of NobleFactor/noblefactor-ops#301, beside NobleFactor/noblefactor-ops#321, which merged as
NobleFactor/noblefactor-ops#327 on 2026-10-21. The owner, 2026-10-20: "Allow a schedule to be specified. Don't require
one for resume or continue. Confirm that we function with or without a schedule." This pull request also ticks #321's
phase 3, each host's store moved, done on all three hosts on 2026-10-21.

## Goals

1. **A schedule on any way in, and none required.** `--continue` takes `--schedule`, as `--resume` does.
2. **Proved both ways.** Each way in, with a schedule and without, is a case in both test scripts, and so is row 2.

## Current State

| Part | Today |
| --- | --- |
| Start-Claude | One way in: `--schedule`, `--resume` or `--continue`, or `--resume` with `--schedule`; `--continue` with `--schedule` is refused: "Give one of --schedule, --resume and --continue, or --resume with --schedule." |
| Start-Claude.ps1 | Three parameter sets, `-Schedule` with `-Title`, `-Resume` alone or with `-Schedule`, and `-Continue`, so PowerShell refuses `-Continue` with `-Schedule` |
| `--continue` | Takes the conversation claude lists in the startup directory, running or stopped, the latest of several; with none, hands the directory to claude's own `--continue` ([2. Command line](../../architecture/agent-schedule/2-command-line.md)) |
| `--resume` with `--schedule` | Puts the conversation on the schedule; refused when the schedule's entry holds another conversation, and when the conversation is another schedule's |
| The completions | zsh's keeps `--schedule` and `--continue` apart; bash's does not pair options |
| The tests | Cases for `--resume`'s forms and three refusals; none passes a schedule, and none passes `--continue` |

## Requirements

### Requirement 1: `--continue` takes `--schedule`

Start-Claude's check of the ways in lets `--schedule` come with `--continue`, as with `--resume`, and Start-Claude.ps1's
`-Schedule` joins the `Continue` parameter set. Given a schedule, the conversation `--continue` finds, the one claude
lists in the startup directory, joins it as `--resume`'s does: refused when the schedule's entry holds another
conversation, and when the conversation is another schedule's. Given a schedule and no conversation claude lists in
the directory, it refuses (open question 1). Without a schedule, `--continue` is what it is today.

### Requirement 2: every way in, with a schedule and without

A case in `tests/Test-StartClaude` and in `tests/Test-StartClaude.ps1` for each: `--schedule` alone, `--resume` alone,
`--resume` with `--schedule`, `--continue` alone, `--continue` with `--schedule`, and `--continue` with `--schedule`
where claude lists nothing, the refusal. The stand-ins answer as claude and gh answer.

### Requirement 3: row 2's check

A case in both scripts: two clones of one repository; `--schedule` with `--directory` opens the schedule's conversation
in the second; `--continue` there finds that conversation, and not the newest transcript in the second clone's project
folder.

### Requirement 4: the words

Start-Claude(1)'s SYNOPSIS and DESCRIPTION, Start-Claude.ps1's help, the zsh completion, which then keeps only
`--resume` and `--continue` apart, and [2. Command line](../../architecture/agent-schedule/2-command-line.md) and its
status companion say that `--continue` takes `--schedule`.

## Implementation Phases

### Phase 1: The plan

- [ ] This plan, committed on its branch and reviewed with the owner.

### Phase 2: The code and the cases

- [ ] Requirements 1 to 3: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`, in a script the owner runs.

### Phase 3: The words

- [ ] Requirement 4.

### Phase 4: Closure

- [ ] The pull request, closing #322 and with it lane 13 of #301; #321's phase 3 ticked in its plan; each host
  deployed after the merge. #301 then waits on lanes 5, 6, 8 and 9.

## Migration Path

None: the change adds a form, and every form that works today works the same.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/322-continue-takes-schedule.md` | Create | this plan |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | the ways in, and `--continue`'s schedule |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | `-Schedule` in the `Continue` set, and `-Continue`'s schedule |
| `Home/common.Unix/.local/share/man/man1/Start-Claude.1` | Modify | SYNOPSIS and DESCRIPTION |
| `Home/common.Unix/.local/share/zsh/site-functions/_Start-Claude` | Modify | `--schedule` and `--continue` together |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Modify | requirements 2 and 3's cases |
| `docs/architecture/agent-schedule/2-command-line.md` and its status companion | Modify | `--continue`'s forms |
| `docs/plans/chore/321-agent-schedule-store.md` | Modify | its phase 3, ticked |

## Related Documents

- NobleFactor/noblefactor-ops#322; NobleFactor/noblefactor-ops#321, its other half, merged as
  NobleFactor/noblefactor-ops#327
- NobleFactor/noblefactor-ops#301 (schedule), lane 13
- [2. Command line](../../architecture/agent-schedule/2-command-line.md) and
  [1. Session model](../../architecture/agent-schedule/1-session-model.md)

## Open Questions

1. **`--continue` with a schedule, and no conversation claude lists in the directory.** Proposed: it refuses, saying
   so, and starts nothing. Without a schedule it hands the directory to claude's own `--continue`, which picks by
   transcript, and that pick is what David-Noble-at-work/personal#278 found takes the wrong conversation, so none is
   put on a schedule.
2. **`--schedule` alone, which no case covers today.** Proposed: requirement 2 adds its case, since "with a schedule"
   starts there.
