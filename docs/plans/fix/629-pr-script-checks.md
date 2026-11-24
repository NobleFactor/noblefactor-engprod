---
title: "A PR script waits out every set of checks before it judges them"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/629
status: complete
created: 2026-11-22
updated: 2026-11-23
documents:
  - kind: Design
    path: docs/guides/pr-script-template.md
  - kind: Schedule
    url: https://github.com/NobleFactor/noblefactor-engprod/issues/588
    text: "Issue tracking, iteration 2"
---

# A PR script waits out every set of checks before it judges them

<a id="role-assignments"></a>

## 1. Role assignments

- Owner: David Noble.
- Participant: the Claude Code session assigned to Schedule #588, as coder.
- Reviewer: Codex.
- Compliance auditor: agy, the Antigravity CLI, of the Gemini model family.

<a id="summary-and-promised-result"></a>

## 2. Summary and promised result

A PR script made from the template runs `gh pr checks --watch` once, reads every check once, and requires each to have passed. `--watch` waits only for the checks it sees when it starts, so a set that starts later, as a pull request's own after its branch's push, is still pending when the script reads it, and the script stops on checks that go on to pass. At the end, both of the template's forms watch again while any check is pending, for up to 30 minutes, and only then require every check to have passed.

Reopened on 2026-11-23: the 30 minutes weren't a limit. One `gh pr checks --watch` has no limit of its own and can run past them, and the next round then starts another (Codex's F04). At the end, both forms read the checks every 30 seconds on a 30-minute clock instead of watching them, and checks still running when it runs out stop the script with a message of their own. Codex's review of #634 then found that the clock bounded neither a slow or stalled read nor the table's own read (R01), and that the table's read could see a pending check the verdict ignored (R02): every read and wait now gets only the time left, and the verdict and the table come from the last read.

<a id="current-state"></a>

## 3. Current state

Read on 2026-11-22 at develop fe18e58: the Bash form's CI gate, under "CI and merge gates", and the PowerShell form's, in the Windows section, each watch once and read once. On 2026-11-22 David-Noble-at-work/personal#338's script stopped with "The observed checks are not all passing" while its three checks had passed and their second runs were still going; all six passed a minute later.

Read on 2026-11-23 at develop d6f7c4c: both forms run up to 60 rounds of `gh pr checks --watch`, each followed by a 30-second wait while a check is pending, and nothing limits one watch. #632's PR script, made from a02ce8b, waited out its second set: its first watch returned with `test-macos` pending, it watched again, and all four checks passed (posted on #629). The template's `updated:` date still reads 2026-11-20 (agy's B12).

<a id="design-impact"></a>

## 4. Design impact

The template is the design: its two CI gates. No other document describes them.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

- **Both forms read the checks every 30 seconds while any is pending, on a 30-minute clock** that starts once the first check is reported: Bash's `SECONDS`, PowerShell's `Get-Date`. Neither runs `gh pr checks --watch`, which has no limit of its own. Each says how many checks are still running whenever that number changes, and prints the checks table once at the end.
- **No read or wait outlasts the clock** (Codex's R01 on #634). Each read of the checks is given only the time left: in Bash, `within` runs it in the background, its output to a temporary file rather than a pipe, checks five times a second whether it has ended, and at the time left stops it with SIGTERM, then SIGKILL two seconds later, since macOS has no `timeout` command and `gh`, a Go program, ignores SIGALRM; plain Bash, from 3.2, macOS's own, up, with no other program (Codex's re-review of #634; your direction, 2026-11-23); in PowerShell, `Invoke-Native` takes a `-Deadline`, waits for the process only until then, and stops it and its children, refusing with `DeadlinePassed`. No wait is longer than the time left. The first wait, up to five minutes for a check to be reported, is bounded the same way.
- **The script judges its last read alone,** and prints the table from it, making no further read it could ignore (Codex's R02 on #634).
- **Checks still running when the clock runs out stop the script** with a message of their own: run it again once they finish.
- The gate after it is unchanged: every check has passed, or the script stops.
- The template's `updated:` date.

As first delivered on 2026-11-22, each form ran up to 60 rounds of `gh pr checks --watch`, each followed by a count of the checks still pending and a 30-second wait; the reopening replaced the rounds.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **A fixed wait before watching.** Not taken: no wait is long enough for every repository's second set, and every pull request would pay it.
- **The read run under perl's `alarm`, by `exec`.** Not taken, though first delivered: a Go program catches SIGALRM and ignores it, so the real `gh` ran on, 30 seconds against a limit of 2, where a shell stand-in had stopped.
- **A separate watchdog process killing a slow read.** Not taken: a watchdog's own `sleep` outlives it, holding the read's output pipe open until it ends. `within` writes the read's output to a file instead, and watches the read itself.
- **A perl supervisor.** Not taken, though delivered in a9f5a72: perl forked the read, timed it with its own `alarm`, and stopped it with SIGTERM, then SIGKILL. It worked, but made perl, which Apple has said future macOS won't include by default, a dependency of every PR script, and a missing perl would have been reported as `gh` failing. Plain Bash does the same.
- **The watch, under a time limit.** Not taken: macOS has no `timeout` command, and stopping a watch run in the background takes more than reading the checks on a clock.
- **Counting the workflows a head should run.** Not taken: a template can't know each repository's workflows, and the reads need nothing of them.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Both forms are sound | The Bash form passes `bash -n` and shellcheck, its placeholders filled; the PowerShell form parses and passes PSScriptAnalyzer | Those checks, on the forms extracted from the template | This worktree |
| The wait is limited | With a check pending throughout, each form stops when its 30 minutes run out, with its own message | Each form's loop, run with a stand-in `gh` that reports a check pending and a stand-in sleep that moves the clock | This worktree |
| No read or wait outlasts the clock, and the last read is judged | With reads slow or stalled, or the clock running out during a wait, each form stops within a second of its limit; the table and the verdict come from the same last read | `tests/Test-PrScriptGate`, both forms, against a stand-in `gh` | macOS and Linux CI, PowerShell 7 |
| A second set is waited out | A PR script made from the template doesn't stop while a check is pending | The next PR script whose pull request has two sets of checks | GitHub |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commits of §§ 9.2, 9.4 and 9.5 | § 9.2's in #630; §§ 9.4's and 9.5's in #634 |
| Merge | Yes | The pull requests and the commits they land | #630, a02ce8b, on 2026-11-22; #634, 3cb8201, on 2026-11-24 (UTC), closing #629 |
| Deployment | No: a guide | None | Not required |
| Verification | Yes | § 7's last row, posted on #629 | The rounds' seen in #632's script on 2026-11-23; the clock's in #634's own script at 34b46e9 the same day, waiting out its checks for 16 minutes, posted on #629; the bounded reads' in #634's script made again at cd4f5f4, the same day, posted on #629 |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-the-plan"></a>

### 9.1 Phase 1: the plan

- [x] This plan approved on 2026-11-22 (§ 12).

<a id="phase-2-the-gates"></a>

### 9.2 Phase 2: the gates

- [x] Both forms' CI gates as § 5 sets out; § 7's first row: the Bash form passes `bash -n` and shellcheck, the PowerShell form parses with no PSScriptAnalyzer findings.

<a id="phase-3-reopened"></a>

### 9.3 Phase 3: reopened

- [x] §§ 2 to 8, § 11 and § 12 updated for the clock and for the audit's findings in this work, on 2026-11-23.

<a id="phase-4-the-clock"></a>

### 9.4 Phase 4: the clock

- [x] Both forms' CI gates as § 5 sets out, and the template's `updated:` date; § 7's first two rows: each form passes its checks, and its loop, with a check pending throughout, stops after 61 reads and 30 minutes with its own message; with a second set passing after three reads, passes; and with a check failing, stops at the gate.

<a id="phase-5-the-reads-bounded"></a>

### 9.5 Phase 5: the reads bounded, and the last read judged

- [x] Codex's R01 and R02 on #634: every read and wait within the clock, in both forms, and the verdict and the table from the last read; `tests/Test-PrScriptGate`, new, for both forms, § 7's third row: 16 cases, all passing; with a read left unbounded in each form and the table read again, 8 fail, the stalled read taking 120 seconds in Bash and 60 in PowerShell against a limit of 5.

- [x] #634's PR script made again from the template at its head, and run, its gate, the bounded reads', waiting out the checks within the clock; posted on #629: at cd4f5f4 it waited out `test-macos` and printed the four checks from its last read, all passing; the readiness check after it then stopped on develop's ruleset, Codex's threads awaiting re-review.

- [x] Codex's re-review of #634, R01: `within` forks the read and stops it with SIGTERM, then SIGKILL, the real `gh` stopped at the limit; the stand-in `gh` ignores SIGALRM as Go does. With a hung connection, the real `gh` ran 30 seconds under the old `within` against a limit of 2, and stopped at 2 under the new, leaving no process; the PowerShell form's `Invoke-Native` stopped it at 2.1. `tests/Test-PrScriptGate`, 16 cases, passes; against the old `within`, its two stalled-read cases fail.

- [x] Perl replaced by plain Bash in `within`, at your direction: the read in the background, its output to a file, stopped at the time left with SIGTERM, then SIGKILL; under bash 3.2 and 5, against the real `gh` hung; `tests/Test-PrScriptGate` needing no perl. Under both bashes the real `gh`, its connection hung, stopped at a limit of 2 seconds, leaving no process; an answering `gh` returned its output; a status passed through. The test runs the Bash form under macOS's bash 3.2 too: 24 cases, all passing; with `within` never stopping a read, its four stalled-read cases fail, 60 seconds each.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `docs/guides/pr-script-template.md`.
- `tests/Test-PrScriptGate`, new.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- PR scripts already made keep the old gate until they are made again; personal#338's and devlore-cli#1241's are among them.
- #632, #613's, was in flight while this work was done; it merged on 2026-11-23 as eb28e48, merged into this branch, and this work's pull request opened after it.

<a id="approval-and-departures"></a>

## 12. Approval and departures

- **Approved, 2026-11-22.** David Noble directed the fix at once, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **Merged without review or audit, 2026-11-22 (agy's B02).** The plan and the change were committed together, minutes apart, and #630 merged with no plan review before the work and no reviewer's or auditor's pass. Codex reviewed it after the merge: F04 is § 5's clock; F05, the issue's plan row, is repaired.
- **Four pull requests in flight at once, 2026-11-22 (agy's B08).** #630 was open beside devlore-cli#1240, devlore-cli#1242 and personal#338, with no exception to one pull request at a time recorded.
- **The schedule row set by hand, 2026-11-22 (agy's B09).** The worktree's first script wasn't run, so #629's row on Schedule #588 had no worktree link; #630's PR script refused to record the merge on it, and the row was set In progress with its link through GitHub's project API.
- **The PR script run by the coder, 2026-11-22 (agy's B10).** #630's script was run by the coder, not the owner, each run at your direction in the session, a one-run exception each time.
- **Closed before its verification, its plan unlinked (agy's B05 and B06).** #629 closed at the merge with § 7's last row not yet seen, and its plan row read Not yet opened. On 2026-11-23 `star github plan link` was run, the pending verification was posted, and the issue reopened.
- **Codex's review of #634, 2026-11-23.** R01: the clock was checked only between reads, so a slow or stalled read, and the table's own read, could outlast it. R02: the table's read could see a newer pending check the verdict then ignored. Both are fixed in #634, § 5, with a test of both forms, worked straight through, as your direction of 2026-11-21, to work each phase straight through, committing and pushing each, has it; in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **Perl replaced, decided 2026-11-23.** Asked about `within`'s use of perl, you directed plain Bash instead: perl would have been a new dependency of every PR script, on a runtime Apple has said future macOS won't include by default, and nothing required it. Decided in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **Codex's re-review of #634, 2026-11-23.** R02 resolved. R01 stands: the real `gh`, a Go program, ignores SIGALRM, so `within`'s `alarm` and `exec` left a hung read running; the shell stand-in, which SIGALRM stops, hid it. Fixed in § 5, worked straight through as before, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.
- **The plan before the work, 2026-11-23 (agy's E03).** 61b0113, this plan's update for the clock, was committed before the fix, b74570b, but not reviewed with you first; you had directed the reopening and the fix. No first script was written for this worktree: 34b46e9's row repair stood in for its row step, and the plan link was run by hand. efb1ad1, the plan for Codex's R01 and R02, came before their fix, e3a33ea, as above.
- **The schedule row repaired, 2026-11-23.** #629's row on Schedule #588 still linked #630, this issue's own pull request, merged on 2026-11-22, its branch gone. The template's guarded update refuses a row linking anything but this branch, reading it as another worktree's; no worktree holds the step, so the row was set In progress, linking `fix/629-pr-script-deadline`, with the template's own `step_row` and `set_row`, the guard allowing only that one link, and read back.
- **Reopened, 2026-11-23,** for Codex's F04, at your direction, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`: § 5's clock.

<a id="completion-review"></a>

## 13. Completion review

Complete 2026-11-24 (UTC): #634, merged as 3cb8201, closed #629, by your merge. `tests/Test-PrScriptGate`, 24 cases, the Bash form under bash 3.2 and 5 and the PowerShell form, passes, and its stalled-read cases fail against the code before each fix. The clock was seen in the field in #634's own PR script, at 34b46e9 and again at cd4f5f4, and the plain-Bash `within` stopped the real `gh`, its connection hung, at its limit under bash 3.2 and 5, as `Invoke-Native` did; posted on #629. Outstanding: a PR script made before 3cb8201 keeps its old gate until it is made again.
