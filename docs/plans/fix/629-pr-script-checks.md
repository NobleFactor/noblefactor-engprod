---
title: "A PR script waits out every set of checks before it judges them"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/629
status: active
created: 2026-11-22
updated: 2026-11-22
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

<a id="current-state"></a>

## 3. Current state

Read on 2026-11-22 at develop fe18e58: the Bash form's CI gate, under "CI and merge gates", and the PowerShell form's, in the Windows section, each watch once and read once. On 2026-11-22 David-Noble-at-work/personal#338's script stopped with "The observed checks are not all passing" while its three checks had passed and their second runs were still going; all six passed a minute later.

<a id="design-impact"></a>

## 4. Design impact

The template is the design: its two CI gates. No other document describes them.

<a id="proposed-implementation"></a>

## 5. Proposed implementation

- **Bash:** up to 60 rounds of `gh pr checks --watch`, each followed by a count of the checks still pending; none pending ends the rounds, and otherwise the script waits 30 seconds. A failing check ends `--watch` with a non-zero status, which the round doesn't stop on: the gate after the rounds names it.
- **PowerShell:** the same rounds, `--watch` through `Invoke-Native -AllowFailure` for the same reason, each round narrated.
- The gate after the rounds is unchanged: every check has passed, or the script stops.

<a id="alternatives-and-challenges"></a>

## 6. Alternatives and challenges

- **A fixed wait before watching.** Not taken: no wait is long enough for every repository's second set, and every pull request would pay it.
- **Counting the workflows a head should run.** Not taken: a template can't know each repository's workflows, and the rounds need nothing of them.

<a id="acceptance-criteria-and-evidence"></a>

## 7. Acceptance criteria and evidence

| Criterion | Observable result | Evidence/method | Environment/artifact |
| --- | --- | --- | --- |
| Both forms are sound | The Bash form passes `bash -n` and shellcheck, its placeholders filled; the PowerShell form parses and passes PSScriptAnalyzer | Those checks, on the forms extracted from the template | This worktree |
| A second set is waited out | A PR script made from the template doesn't stop while a check is pending | The next PR script whose pull request has two sets of checks | GitHub |

<a id="required-completion-milestones"></a>

## 8. Required completion milestones

| Milestone | Required? | Expected evidence | State/result |
| --- | --- | --- | --- |
| Implementation | Yes | The commit of § 9.2 | Pending |
| Merge | Yes | The pull request and the commit it lands | Pending |
| Deployment | No: a guide | None | Not required |
| Verification | Yes | § 7's second row, posted on #629 | Pending |

<a id="implementation-phases"></a>

## 9. Implementation phases

<a id="phase-1-the-plan"></a>

### 9.1 Phase 1: the plan

- [x] This plan approved on 2026-11-22 (§ 12).

<a id="phase-2-the-gates"></a>

### 9.2 Phase 2: the gates

- [ ] Both forms' CI gates as § 5 sets out; § 7's first row.

<a id="files-and-related-assets"></a>

## 10. Files and related assets

- `docs/guides/pr-script-template.md`.

<a id="dependencies-overlaps-and-blockers"></a>

## 11. Dependencies, overlaps and blockers

- PR scripts already made keep the old gate until they are made again; personal#338's and devlore-cli#1241's are among them.

<a id="approval-and-departures"></a>

## 12. Approval and departures

- **Approved, 2026-11-22.** David Noble directed the fix at once, in the session `NobleFactor/noblefactor-engprod#588 | Schedule: issue tracking, iteration 2 | Coder`.

<a id="completion-review"></a>

## 13. Completion review

Pending.
