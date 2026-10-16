---
title: "git close-branch syncs the main worktree, says so, and fails when it cannot"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/306
status: complete
created: 2026-10-15
updated: 2026-10-16
---

# Plan: git close-branch syncs the main worktree, and says so

## Issue 306

Lane 103 of NobleFactor/devlore-cli#916 (schedule), in its everything-else bucket, its own pull request. Found
2026-10-15, when David-Noble-at-work/personal#282's PR script went by `git close-branch`'s documents. writ's
personal clone, detached for a deployed test, was synced to main by the command, which its man page says never
happens, so the script's own `git fetch origin main:main` was refused. The owner's rulings, the same day:

- What the command does. Asked how it should treat a main worktree that has something other than the target checked
  out: "two things should happen: 1. linked worktree removed and its branch deleted locally and remotely 2. main
  worktree synced to PR target branch".
- How. Offered three changes: the documents describe both things; one printed line when it syncs, naming the main
  worktree, what it had checked out before and the commit it is at now; and a sync that cannot happen fails the run,
  with its own exit status and the reason, since it is half the job. The target stays the repository's default
  branch unless `-t` names another. "I approve your proposal. Let's log the issue and make the change using our
  process."
- Where. Offered a lane on NobleFactor/devlore-cli#916 or no schedule: "A lane on #916."

## Summary

`git close-branch` does two things after a pull request merges. It deletes the branch on GitHub, removes the linked
worktree that has it checked out and deletes the local branch; then it syncs the main worktree to the target branch,
checking the target out there when anything else is, and fast-forwarding it from origin. The second has run since
the base layer shipped the command, silently, and when it cannot be done the run says so in a note and exits 0. This
plan makes the sync print one line, makes a sync that cannot happen fail the run with an exit status of its own,
makes `--dry-run` preview the sync, and brings the command's comments, git-close-branch(1) and
`docs/guides/pr-script-template.md` level with the code. A new test, `tests/Test-GitCloseBranch`, covers both things.

## Goals

1. Both things happen, or the run says which did not and exits non-zero.
2. The sync is never silent: one line says what the main worktree had checked out and where it is now.
3. `--dry-run` previews the sync the run would make.
4. The command's comments, its man page and the PR script template describe the command as it is.

## Current State

Read 2026-10-15 at develop, where the command last changed in 1d075c4d (2026-09-22). Line numbers are those of
`Home/common/.local/bin/git-close-branch`, unless a row names another file.

| What | Today |
| --- | --- |
| Closing a branch | Surveyed first, then removed from origin, then its linked worktree, then the local branch (lines 620-650), as the man page says |
| A main worktree with a closing branch checked out | Switched to the target before anything is removed (lines 584-618); a failed switch fails those branches alone, as the man page says |
| The sync | Lines 652-679, present since c548399a (2026-09-10): a clean main worktree with anything but the target checked out gets the target checked out, then the target is fast-forwarded from `origin/<target>`. Nothing is printed when it works. Uncommitted changes, a failed checkout or a failed fast-forward is a `note`, and the run exits 0 unless a branch failed |
| `--dry-run` | Line 555 prints "leaving '<main worktree>' on '<branch or a detached HEAD>'", where the run would sync it |
| Comments | Line 6's summary; lines 577-582: "an unrelated main worktree is left exactly as it was found" |
| git-close-branch(1) | DESCRIPTION: "switching the main worktree to the target branch only when that worktree holds one of them"; step 3: "An unrelated main worktree is left as found"; no step for the sync; SYNOPSIS lacks `-f`; 75 reads "the target branch could not be pulled", where the code exits 75 when origin cannot be fetched (line 514) |
| `docs/guides/pr-script-template.md` | Its bash comment (lines 209-211), rule 8 (line 258), rule 12 (lines 278-280) and Windows rule 4 (lines 301-302) say close-branch leaves alone a main worktree that did not have the branch checked out; three of them cite #209, which was the `remove_branch` refactor |
| Tests | None for the command: `tests/` holds `Test-DeclareBashScript` alone |
| The hosts | bash 5.3.9 on `danoble-ud24-1`, and 5.3.15 in Git for Windows 2.55.0 on `danoble-wd11-3`, each with the command deployed (read 2026-10-15); the helper needs 5.3 |

## Requirements

### Requirement 1: the sync prints one line

After every selected branch has been closed or refused, the main worktree is synced to the target, as today: the
target is checked out there when the main worktree has another branch or a detached HEAD checked out, and is then
fast-forwarded from `origin/<target>`, which the run's first fetch refreshed. When that works, one line, through the
helper's `success`, names the main worktree, what it had checked out and the commit it is at now (wording proposed):

```text
Synced '/Users/you/Workspace/personal' to main at 5aea91c0, from a detached HEAD at 07413ae2
Synced '/Users/you/Workspace/NobleFactor/noblefactor-ops' to develop at 3c1e2f90, from develop at 1d075c4d
```

### Requirement 2: a sync that cannot happen fails the run

A sync fails in three ways, and each is an `error 0` naming the reason and the fix:

1. The main worktree has another branch or a detached HEAD checked out, and uncommitted changes: no checkout is
   tried, and the fix is to commit or stash them, then `git switch <target>` and `git pull --ff-only`.
2. git refuses the checkout, as it does when an untracked file would be overwritten.
3. git refuses the fast-forward: the local target has commits `origin/<target>` lacks, or uncommitted changes touch
   files the fast-forward changes.

Branches already closed stay closed and are reported, as today. The run then exits 75, the sync's own status
(question 1); when a branch also failed, it exits 65, having reported both (proposed). A fetch of origin that fails,
which stops the run before anything is touched, exits 69 rather than today's 75 (question 1).

### Requirement 3: `--dry-run` previews the sync

The preview's line for the main worktree says what the run would do: "Would sync '<main worktree>' to <target>,
from <what it has checked out>", or, for the first and third failures, which a preview can see without trying,
"Would fail to sync '<main worktree>': <reason>". The second, a checkout git refuses, is known only by trying
(proposed).

### Requirement 4: the command's comments

Line 6's summary, and the comments at lines 547-548, 577-582 and 652-660, say what the code does: the switch before
the close is for a main worktree that has a closing branch checked out, and the sync after it is for every main
worktree.

### Requirement 5: git-close-branch(1)

NAME and DESCRIPTION name both things. Step 3 keeps the switch before the close, without "left as found"; a new step
says how the sync is made, what it prints and how it fails. `--dry-run` says it previews the sync, FAILURE HANDLING
counts a failed sync, and EXIT STATUS gives 75 to a sync that cannot happen and 69 to a fetch of origin that fails,
beside `--merged`'s missing `gh` (question 1). SYNOPSIS gains `-f`, which the command takes. The date is October 2026.

### Requirement 6: the PR script template

Its bash comment before the main clone's pull, rules 6, 8 and 12, and Windows rule 4 say that `git close-branch` syncs
the main clone and fails when it cannot, so a script's pull after it only confirms the sync, and a script never
fetches into the target branch itself. The citations of #209 go, and `updated:` is the day it changes.

### Requirement 7: tests

`tests/Test-GitCloseBranch`, in `Test-DeclareBashScript`'s form, run by `make test`, `make check` and CI. Each case
makes a repository of its own: a bare origin whose default branch carries a squash commit with "(#1)" in its subject,
a clone whose main worktree the case sets up, a linked worktree on the merged branch, and a stand-in `gh` on PATH
that answers MERGED and 1. The cases:

| The main worktree | Expected |
| --- | --- |
| On the target, behind origin | The branch closed, the target fast-forwarded, the line printed, status 0 |
| On another branch, clean | The target checked out and fast-forwarded, the line naming the other branch, status 0 |
| Detached, clean | The same, the line naming the detached HEAD |
| Detached, with uncommitted changes | The branch closed, the sync's failure with its reason and status |
| With an untracked file the target's checkout would overwrite | The branch closed, the sync's failure with its reason and status |
| On the target, with a commit origin lacks | The branch closed, the sync's failure with its reason and status |
| Each of the above, with `--dry-run` | The preview says what the run would do, and nothing changes |

The cases' repositories are made in one `mktemp -d` directory per run, which the test's own cleanup removes, wherever
it runs (question 2). The cleanup is set with the helper's `Set-Traps`, so it runs however the run ends: every case
passed, a case failed, an error stopped the test, or a signal did.

### Requirement 8: every host the command runs on

`tests/Test-GitCloseBranch` passes on this Mac (`make check`), on `danoble-ud24-1` over `ssh bash -s`, and on
`danoble-wd11-3` under Git for Windows' bash, which runs every `git-*` command there. On the two virtual machines it
runs from a copy of the branch's files, made by the owner's script and removed by it afterwards. No virtual machine is
snapshotted (ruled 2026-10-05).

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on the branch and reviewed with the owner, and its open questions ruled. Committed as a
  draft in 0fb5480d; approved 2026-10-15: "The plan is settled. go"

### Phase 2: The tests

- [x] `tests/Test-GitCloseBranch` with every case of requirement 7, run first against today's command: the sync's
  cases fail where today's command is silent or exits 0, and the rest pass. Committed with phase 3, since
  `make check` runs every test, so a test today's command fails cannot be committed alone.

  Run 2026-10-16 on this Mac against 9e0246ce's command, after the owner reviewed the test: "Run the test". All 12
  cases failed, each at its sync and nowhere else: no line printed for a sync that worked, 0 where 75 was wanted,
  and a preview that leaves the main worktree alone. Every check of the branch's close passed, and the trap removed
  the run's directory. The test runs from the clone, naming the branch, as the Windows PR script runs the command,
  since Windows will not delete a directory that is a process's current directory.

### Phase 3: The command

- [x] Requirements 1 to 4 in `git-close-branch`; the tests pass; shfmt with the gate's flags, `bash -n`, shellcheck
  and `make check` are clean.

  Run 2026-10-16 on this Mac, after the owner reviewed the change: "Please run the test script". All 12 cases
  passed, and the trap removed the run's directory. shfmt with the gate's flags, `bash -n` and shellcheck at every
  severity are clean, and `make check` runs in this commit's script. Nine lines over 120 columns, six of them older
  than this change, are wrapped with the same output.

### Phase 4: The documents

- [x] Requirements 5 and 6.

  git-close-branch(1): its NAME, SYNOPSIS with `-f`, DESCRIPTION, step 3 and a new step 7, `-t`, `--dry-run`, FAILURE
  HANDLING, EXIT STATUS's 0, 69 and 75, the `-t` example, and its date, now in the ISO form mandoc parses; mandoc is
  clean at warning level. `docs/guides/pr-script-template.md`: its bash comment, rules 6, 8 and 12, Windows rule 4
  and `updated:`, and its description, shortened to fit 120 columns (the agent's call). Nothing in it, the man page,
  the command, development-process.md or agent-rules.md still says the main clone is left alone, or cites #209.

### Phase 5: Every host

- [x] Requirement 8, on `danoble-ud24-1` and `danoble-wd11-3`.

  Run 2026-10-16 at a7295212 by the agent, on the owner's "Run the phase 5 script to test on our windows and Linux
  boxes", from copies the script made and removed: all 12 cases passed on `danoble-ud24-1`, bash 5.3.9 and git
  2.53.0, and on `danoble-wd11-3`, Git for Windows' bash 5.3.15 and git 2.55.0.windows.3. Neither host kept a copy.
  Each links its `git-close-branch` into writ's clone of the base layer, so each has the change once that clone is
  pulled.

### Phase 6: Acceptance and closure

- [x] The pull request closes #306. Its own script's `git close-branch` is the live check: the line printed, and the
  main clone synced, leaving the script's pull nothing to do.

  Ticked in the pull request's last commit, as the process has it. Its script pulls the base clone before
  `git close-branch`, because this Mac's command is a link into that clone, so the merged command is the one that
  runs; the script then requires its sync line, and checks the deployed copy carries the change. `danoble-ud24-1`'s
  clone of the base layer is pulled by the script; `danoble-wd11-3`'s is the owner's, in an interactive ssh session,
  since a `git fetch` started there without a terminal hangs.

## Files

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/bin/git-close-branch` | Modify | Requirements 1 to 4 |
| `Home/common/.local/share/man/man1/git-close-branch.1` | Modify | Requirement 5 |
| `docs/guides/pr-script-template.md` | Modify | Requirement 6 |
| `tests/Test-GitCloseBranch` | Create | Requirements 7 and 8 |
| `docs/plans/chore/306-close-branch-syncs-main-worktree.md` | Create | This plan |

## Out of Scope

- How the target is chosen: the repository's default branch unless `-t` names another, as the owner's approval has
  it. Every pull request here targets the default branch.
- The switch before the close, for a main worktree that has a closing branch checked out: unchanged.
- `git open-branch`'s own open issues, NobleFactor/noblefactor-ops#200 and #248.

## Open Questions

1. **The sync's exit status. Ruled 2026-10-15, offered 75, which git-close-branch(1) already describes as "the
   target branch could not be pulled", with a failed fetch of origin moving from 75 to 69, beside `--merged`'s
   missing `gh` (1), or the fetch left at 75 and the sync given a status nothing else uses (2): "Yes, 75 for the
   sync, 69 for the fetch."** Requirements 2 and 5 carry it.
2. **How the tests' repositories are removed. Ruled 2026-10-15, offered one `mktemp -d` directory per run, which the
   test's own cleanup removes whenever the test runs, the agent's runs included (1), or the directories left in place
   and printed, for the owner's scripts to remove (2): "The test removes them itself." Then: "One might set a trap to
   ensure they go away no matter what."** Requirement 7 carries both: the cleanup is set with `Set-Traps`.
