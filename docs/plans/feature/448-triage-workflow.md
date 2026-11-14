---
title: "The Triage workflow sets a new issue's Severity and puts a scenario's findings in the scenario"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/448
status: complete
created: 2026-11-12
updated: 2026-11-13
---

# Plan: The Triage workflow sets a new issue's Severity and puts a scenario's findings in the scenario

Step 35 of issue tracking, iteration 1 (#346). Half of #448 is done: #437's proof on GitHub landed the Triage
workflow in NobleFactor's five participating repositories, and it adds every new issue to its team's Triage project
and copies the form's Area. Two things are left, in both accounts' templates: the Severity a new issue starts with,
which David-Noble-at-work's template already sets and NobleFactor's doesn't, and a scenario's findings, which neither
template routes. `star github model apply` then carries each template to its account's repositories, and the
documents that say the workflow "will" do these things say it does.

Four pull requests, one at a time: NobleFactor/.github, David-Noble-at-work/.github, the pull requests `apply` lands
in the six repositories, and last this repository's, from `feature/448-triage-workflow`, which closes #448.

## Rulings

- 2026-11-04, in #303's closing: severity applies to bugs only. Every issue of another type has Severity N/A, and a
  bug filed from the bug form, which asks no severity, starts at Medium until triage changes it. The workflow sets it
  when an issue is opened, in both accounts.
- 2026-11-04, on #448: an item logged while walking a scenario names it in its body, as "Found while walking #N", and
  the workflow adds it to its team's Scenario project under that scenario's option instead of to Triage. Every other
  new issue goes to Triage as before.
- 2026-11-10 (#437): `star github model apply` lands each participating repository's workflow from its account's
  template, through a pull request on its default branch.
- 2026-11-13, on #448: the 2026-11-04 ruling stands for an issue with no type yet: it gets no Severity and waits for
  triage, which sets it with the type. Both templates had given it N/A, and are brought to the ruling.

## Current State

Read on 2026-11-12:

| What | Where it stands |
| --- | --- |
| NobleFactor's five participating repositories | Each has `.github/workflows/triage.yml`, the template as it stands, and `TRIAGE_PROJECT_URL`: Triage: engprod for noblefactor-engprod and .github, Triage: devlore for devlore-cli, devlore-registry and devlore.noblefactor.com |
| NobleFactor/.github's template | Adds the issue to Triage and sets the Area field from the form. No Severity step, no scenario step |
| David-Noble-at-work/.github's template and personal's workflow | The same file: Triage, the `area:` label, and the `severity:` label, `medium` on an issue with the `bug` label and `n/a` on any other, kept when set. No scenario step |
| The automation App's permissions | Proved: since 2026-11-12 its runs in noblefactor-engprod add Triage rows and set the Area field |
| NobleFactor's forms | Each sets its issue's type: the bug form, Bug |
| The documents | About 50 lines in 20 documents say the workflow will do this (#448) |

## Requirements

1. **Severity, in NobleFactor's template.** A step after the Area step. An issue that has a Severity keeps it.
   Otherwise an issue of type Bug gets Medium, an issue of another type N/A, and an issue with no type yet none: it
   waits for triage, which sets it with the type (ruled 2026-11-04, kept 2026-11-13). The type is read from the issue
   when the step runs. In David-Noble-at-work's template, which set the `severity:` label already, an issue with no
   type label likewise gets none.
2. **A scenario's findings, in both templates.** A step before the Triage step reads the body for "Found while walking
   #N", or "Found while walking owner/repository#N". When it names an open issue of the same account whose own row on
   a project titled "Scenario: …" has a Scenario option, the new issue gets a row on that project with that option,
   and no Triage row. Otherwise it goes to Triage as before, and the run's log says why. The walker sets the Beat.
   NobleFactor's step signs in with the App's token; David-Noble-at-work's with `ADD_TO_PROJECT_PAT`, the only token
   that writes the account's projects.
3. **Applied.** `star github model apply` on each account lands its template in each participating repository, one
   pull request each, and `star github model diff` then shows no difference.
4. **The documents** say what the workflow does, where they said what it will do (#448).

## Test Plan

A form is reachable only from GitHub's web page, so each test issue is filed through GitHub's REST API with the body,
type and labels its form gives. Each is closed afterward with Resolution Invalid, or the `resolution:invalid` label in
David-Noble-at-work, and its rows are removed.

| # | Case | Expect |
| --- | --- | --- |
| 1 | In each of the five repositories, a task from the task form | A row of its team's Triage project, Area from the form, Severity N/A |
| 2 | In noblefactor-engprod, a bug from the bug form | Severity Medium |
| 3 | In noblefactor-engprod, a task found while walking #152, the portable tooling scenario | A row of Scenario: engprod under its option, and no Triage row |
| 4 | In noblefactor-engprod, a task found while walking an issue that is not a scenario | A row of Triage: engprod; the log says why |
| 5 | In personal, a task from the task form, a bug from the bug form, and a task found while walking #316, the placeholder scenario, which has no row of its own: given one under its option for the test, and the row removed after | `severity:n/a`; `severity:medium`; a row of Scenario: David-Noble-at-work under its option |
| 6 | `star github model diff` on both accounts, after `apply` | No difference |
| 7 | shellcheck on each template's run steps | Clean |
| 8 | In noblefactor-engprod, an issue with no type, and in personal, one with no type label, after both templates are brought to the ruling of 2026-11-13 | A Triage row and its Area, and no Severity; the log says it waits for triage |

## Implementation Phases

### Phase 1: the plan

- [x] Committed on `feature/448-triage-workflow` by the worktree's first script, which also sets step 35 In progress
      with the branch linked; reviewed with the owner and approved on 2026-11-12

### Phase 2: NobleFactor's template

- [x] Both steps in NobleFactor/.github's template, on `feature/448-triage-workflow`, its worktree made by hand as
      #447's was, since `git open-branch` reads only the clone's own issues; merged; `apply` on NobleFactor; `diff`
      shows no difference

### Phase 3: David-Noble-at-work's template

- [x] The scenario step in David-Noble-at-work/.github's template, the same way; merged; `apply` on David-Noble-at-work
      lands it in personal; `diff` shows no difference

### Phase 4: the evidence

- [x] The test issues filed, their rows, fields and runs read back, each closed with Resolution Invalid and its rows
      removed

### Phase 5: the documents and the merge

- [x] Both templates' Severity step brought to the ruling of 2026-11-13: an issue with no type yet gets none and
      waits for triage; merged, and `apply` on both accounts, `diff` then finding nothing; test case 8 run and passed
- [x] The documents brought to what the workflow does; this repository's pull request merged, closing #448 with the
      evidence; step 35 Closed

## Files to Create/Modify

| Repository | File | Action |
| --- | --- | --- |
| NobleFactor/.github | `workflow-templates/triage.yml` | Modify |
| David-Noble-at-work/.github | `workflow-templates/triage.yml` | Modify |
| The five, and personal | `.github/workflows/triage.yml` | Landed by `apply` |
| noblefactor-engprod | `docs/plans/feature/448-triage-workflow.md` | Create |
| noblefactor-engprod | `docs/issue-standards.md`, `docs/guides/development-process.md`, the issue data model's sections, index and status pages, and the extension's `reference/organization.yaml` and `reference/user.yaml` | Modify |

## Related Documents

- [Section 4, § Triage](../../architecture/issue-data-model/4-storage-and-reach.md#triage) and
  [issue-standards.md § Scenarios](../../issue-standards.md#scenarios)
- #447, the Area reader; #437, `apply`; #436, the sweep; #504, filing that places an issue without a stray Triage row
