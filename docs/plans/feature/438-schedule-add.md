---
title: "star github schedule add puts issues on a schedule, with their steps, links and amendment, in one act"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/438
status: active
created: 2026-11-12
updated: 2026-11-12
---

# Plan: star github schedule add puts issues on a schedule, with their steps, links and amendment, in one act

Step 28 of issue tracking, iteration 1 (#346). Builds `star github schedule add` to section 8 of the issue data model,
the schedule commands, approved on 2026-11-12 (#439). One pull request from `feature/438-schedule-add`, resolving #438.
Its code for reading a schedule's steps and renumbering them is shared, so that `move` and `remove` (#511) reuse it.

## Rulings

- 2026-11-02: a row added to a schedule gets its step and its blocked-by links when it is added; adding the row and its
  amendment by hand must work before any command does both (section 3, § A committed schedule).
- 2026-11-04: work goes onto a schedule with the schedule's option, the next step or the one given, Status Open and its
  blocked-by links, and loses its row on the project it leaves, in one act. An issue on another team's project is
  assigned to an accountable member of that team (sections 3 and 7).
- 2026-11-11 (#438): `--after <step>` takes a step, not an issue, and every later step moves down one.
- 2026-11-11 and 2026-11-12, section 8 (#439): the syntax; one amendment line, rendered from a template, on every
  schedule, naming the date, who ran the command and its required `--reason` (question 4); closed steps move with the
  open ones (question 5); every write read back, since GitHub promises no stability for the features the model is
  built on (question 3).
- 2026-11-12, on this plan: the organization half's live evidence runs in NobleFactor-sandbox, an organization made
  to last, built from NobleFactor's model with `star github model apply` and kept, for every star github command's
  proof. NobleFactor-test, deleted after #437's proof, can't be restored or its name reused yet. A user account's
  half can't be proven live: David-Noble-at-home, the one user account that could stand in for one, is unavailable
  until the owner restores it. So it will not be proven by any other means, and #438 stays open until it is.

## Current State

Read on 2026-11-12 from develop at `3beea6b`:

| What | Where it stands |
| --- | --- |
| `star github schedule` | One command, `report` (`commands/github-schedule-report.star`) |
| Writing to a project | The sweep adds a row, sets its Status and reads it back (`commands/github-triage-sweep.star`, `_add`); `apply.star` sends a field's options back with their IDs |
| Reading an issue's rows | `records.star`'s `record` gives each issue's `home`: its rows on its account's Backlog, Schedule and Scenario projects, with Schedule and Step. Rows on the closed per-schedule projects, NobleFactor 9 to 22, are not home and are ignored; #438 itself still has one, step 11 of the closed project 12 |
| A repository's team | `scheme.star`'s `team_of`, by the maintain role; the account itself in a user account |
| A file of the extension's own | `model.star`'s `extension_dir()` and `read_text`, as the reference models are read |
| Templates | star's `template` module, `template.render_text(content, data)`, a Go text template (devlore-cli `pkg/op/provider/template`, at the installed build `1ae1da72`). star's Starlark guide doesn't list it |
| Flags | star's extension flags are `bool`, `string`, `int` or `glob`; none repeats |
| Tests | `tests/Test-StarGitHub`, a stand-in `gh` answering each GraphQL operation by name and recording every call; 45 cases |

## Requirements

1. **The command**, as section 8 has it:

   ```
   star github schedule add <schedule> <issue>... [--after <step>] [--blocked-by <issue>[,<issue>...]]
       [--assignee <login>] --reason <text>
   ```

   `--blocked-by` takes a comma-separated list, since no star flag repeats; the design's `[--blocked-by <issue>]...` is
   brought to it.
2. **The steps:** without `--after`, each issue takes the next step, in the order given; with `--after <step>`, they
   take the steps after it, and every later step moves down, closed or open, so the steps stay consecutive whole
   numbers. Each row gets the schedule's option, Status Open and its step, and is placed in step order with
   `updateProjectV2ItemPosition`.
3. **The links:** `--blocked-by` adds blocked-by links to each issue; links it already has are kept.
4. **One home:** the issue's row on its Triage or Backlog project is removed; a scenario's row is removed, and a comment
   on the Scenario issue records the move; a row on another schedule is taken off, the steps after it move up, and that
   Schedule issue gets an amendment too.
5. **Another team's issue** is assigned to `--assignee`, which `add` then requires, and which must be a member of the
   schedule's team.
6. **The amendment:** one line at the end of the Schedule issue's Amendments section, rendered from
   `templates/amendment.md.template`, naming the date, the login `gh` runs as, what was added at which step, the steps
   that moved, and the `--reason`.
7. **One act:** the schedule's rows are read before anything is written and again just before the first write; if they
   differ, `add` stops and writes nothing. A write that fails partway is reported with what was written, and the same
   command run again finishes it. Every write is read back. Built so: the amendment line is written first, ending
   "(in progress)", and settled last, its marker dropped. It is the change's record as planned, so a run that stops
   partway leaves one a reader sees is unfinished, and a run of the same issues finishes it, keeping the steps the
   first run moved among it. Any other issue already on the schedule is refused: most steps were put on schedules by
   hand, before `add`, and no amendment names them. The later rows move from the highest down, which keeps their order
   should a run stop between them.
8. **Refusals,** each writing nothing: an issue that is closed, already on this schedule, of a type other than Task or
   Bug, or of another account; a `--blocked-by` issue of another account; an `--after` step the schedule doesn't have;
   a `<schedule>` that is not an open Schedule issue; no `--reason`; star's `--dry-run`, until devlore-cli#1170 lets a
   dry run read, as the sweep and `apply` refuse it.
9. **Its result:** one flat record for each row it added, moved or took off, so that `--filter`, `--jq` and `--output`
   work on it as on the report's.
10. **Both accounts:** NobleFactor, with issue types, and David-Noble-at-work, with type labels, on Schedule:
    David-Noble-at-work.

## Test Plan

Against the stand-in `gh` in `tests/Test-StarGitHub`, each case reading back the calls it made:

| # | Case | Expect |
| --- | --- | --- |
| 1 | One issue from the Backlog | Next step, the option, Status Open, placed after the last step; its Backlog row gone; the amendment line rendered from the template, with the login and the reason |
| 2 | Two issues, `--after 3` | Steps 4 and 5; every later step down two, a closed one among them; the amendment names the steps that moved |
| 3 | From Triage, and from a scenario | The Triage row removed; the scenario's row removed and the Scenario issue commented on |
| 4 | From another schedule | Taken off there, its later steps up one, an amendment on both Schedule issues |
| 5 | `--blocked-by` | The links added; the issue's own kept |
| 6 | Another team's issue | Refused without `--assignee`, refused for a non-member, assigned with a member |
| 7 | Each refusal of requirement 8 | Refused, naming why, and no write in the calls |
| 8 | The rows changed between the two reads | Stopped, no write |
| 9 | A write that fails partway, then run again | What was written reported; the second run finishes without a second row or a second amendment |
| 10 | David-Noble-at-work | The same as case 1, by type label, on Schedule: David-Noble-at-work |
| 11 | The template | Rendered from fixed data, byte for byte |
| 12 | `make check` | Passes |

Then the evidence #438 asks for, run live: in NobleFactor-sandbox now, and in David-Noble-at-home once the owner
restores it (§ Rulings).

## Implementation Phases

### Phase 1: the plan

- [ ] Written and committed on `feature/438-schedule-add` by the worktree's first script, which opens the branch with
      `git open-branch 438 -T feature`, pushes it, and sets step 28's row In progress with the branch in its Worktree
      column, read back (agent-rules.md, rule 19); reviewed with the owner

### Phase 2: the shared steps

- [x] `commands/steps.star`: a schedule's rows read, the next step and the renumbering worked out, the rows written and
      placed, and the amendment rendered and written; cases 8, 9 and 11, `Test-StarGitHub`'s 53, 54 and 47

### Phase 3: add

- [x] `commands/github-schedule-add.star` and its entry in `extension.yaml`; cases 1 to 7 and 10, `Test-StarGitHub`'s
      46 to 52 and 55; `make check`. The stand-in answers the schedule commands from one world, which their writes
      change, so that every read-back, and a run again after one that stopped, reads what GitHub would

### Phase 4: the live evidence

- [ ] NobleFactor-sandbox made by the owner and built with `star github model apply`; `add` run there, as #438's
      Evidence of completion lists, and the comment written for #438
- [ ] `add` run in David-Noble-at-home, once the owner restores it, and #438 closed then, not before

### Phase 5: documents and merge

- [ ] Sections 3, 7 and 8 and their status pages, the index, issue-standards.md and agent-rules.md brought to `add` as
      built, where they say it will come; NobleFactor-sandbox recorded in section 6 as where star github proofs
      run; the pull request script written, shown and handed over. It leaves #438 open, as the ruling of 2026-11-12
      has it, and links the pull request in step 28's Worktree column

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/feature/438-schedule-add.md` | Create | This plan |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/steps.star` | Create | A schedule's steps: read, renumbered, written, amended; `move` and `remove` reuse it (#511) |
| `.../commands/github-schedule-add.star` | Create | The command |
| `.../templates/amendment.md.template` | Create | The amendment line |
| `.../extension.yaml` | Modify | `github.schedule.add` |
| `tests/Test-StarGitHub` | Modify | The stand-in's new operations, `templates/` in each case's extension, cases 46 on |
| `docs/architecture/issue-data-model/` sections 3, 7 and 8, their status pages, and `index.md` | Modify | `add` as built |
| `docs/issue-standards.md`, `docs/guides/agent-rules.md` | Modify | Where they say `add` will come |

## Related Documents

- [Section 8, The schedule commands](../../architecture/issue-data-model/8-the-schedule-commands.md), § add
- #511, `move` and `remove`, which reuse `steps.star`; #439, the design; #508, the `Closes` line

## Open Questions

None. Ruled 2026-11-12: the live evidence runs in NobleFactor-sandbox, and in David-Noble-at-home once restored
(§ Rulings). The wait on David-Noble-at-work/personal#309 that #438's body names gives way to that one: the user
account's half is proven in David-Noble-at-home, not on personal's schedules.
