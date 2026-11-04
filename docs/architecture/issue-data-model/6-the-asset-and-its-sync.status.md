---
title: "6. The asset and its sync — Status"
---

# 6. The asset and its sync — Status

**Document:** [6-the-asset-and-its-sync.md](6-the-asset-and-its-sync.md)
**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled 2026-10-22, from the owner's words of 2026-10-21 and 2026-10-22; the syntax and the file's shape were
proposed and accepted that day, and have since been revised. Ruled 2026-11-02 and 2026-11-03: the option is
`--account`, not `--org`, and `pull`'s `--account` defaults from star configuration, `github.account`, which defaults
to NobleFactor; `pull` takes the whole model, every repository the account owns, and has no `--repo`; the model file
is named by `--asset`. The model holds an account's issue types (type labels in a user account), its issue fields,
each repository's labels, its teams, and its four project templates, Triage, Backlog, Schedule and Scenario (copies of
them in a user account), with their custom fields, options and views, among them the Schedule and Scenario fields and
Iteration. It leaves out issues, the projects made from templates, any project's built-in workflows and an
organization's default labels. Ruled 2026-11-03: Thread is renamed Scenario, and each team, and each user account, has
one Triage, Backlog, Schedule and Scenario project, with no project per schedule or per scenario.

Ruled 2026-11-03: the model holds the account's issue fields, as it holds its issue types and labels. NobleFactor's are
Priority, Effort, Target date, Resolution, Area and Severity, its Start date field staying unused; a user account has
none. Area has two values, product and engineering, and a blank Area is an error. Also ruled 2026-11-03: the old
scheme's last three pieces retired that day, done in GitHub: the parent markers and schedule footers came out of 725
issue bodies, the step and beat tables of 14 Schedule and Scenario issues gave way to a line naming the issue's board
and option, and the kind labels epic, feature, task and bug left NobleFactor's 12 repositories. David-Noble-at-work
keeps its type labels, which are its types.

Built: `pull`, `digest`, the cache and § Access, 2026-10-24 to 2026-10-26 in #377, `--check` standing in for
`--dry-run` until devlore-cli#1170; the read before every operation, in #378. Not built: `push` (#437), `model audit`,
and the asset's `teams` record, which `pull` neither reads nor writes, though GitHub has devlore and engprod.

Pulled again 2026-11-02, Chore retired: the four types and projects 4 to 22. Of those, only the Schedule and Thread
templates, projects 7 and 8, belong in the model as ruled 2026-11-03, the Thread template now being the Scenario
template. The pull predates the Triage template (project 23), the Backlog template (project 24), the deletion of Next,
the Schedule, Scenario and Iteration fields, and NobleFactor's Schedule and Scenario types. The two reference models
were written beside the extension the same day.

Ruled 2026-11-02: organizations and individual accounts are separate, each with its own model (§ Accounts in section
4); question 17 settled the same day (§ One model per account, in section 6). Revised the same day: each
account keeps its model file in its own `.github` repository. NobleFactor/.github and David-Noble-at-work/.github both
exist and are public. Ruled 2026-11-03: NobleFactor/.github gets a quality-gate check of its own. Also ruled
2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its pull request
template, are stored in its `.github` repository. Read from GitHub on 2026-11-03: each of the two holds `README.md`, its
six issue forms and its Triage workflow template, and NobleFactor/.github also holds
`.github/workflows/quality-gate.yml`; neither holds its model file or a pull request template yet (§ One model per
account, in section 6). Section 6 states where each model lives on #303's branch, `doc/303-model-cutover`; #431 and
David-Noble-at-work/personal#311 move the files, and each account's pull request template is part of the same two
issues. Whether star reads GitHub by ETag before every operation or answers from the model until the next pull is
decided with #426.

Brought later on the evening of 2026-11-03 to that day's last rulings. Ruled 2026-11-03: Severity is an issue field of
the organization in NobleFactor, and section 6 lists it among NobleFactor's issue fields
([section 2](2-attributes.md#the-attributes)). Also ruled 2026-11-03: a user account and an organization have exactly
the same data model, apart from what GitHub offers organizations only, and in a user account a label stands in for
each option of a single-select field ([section 4](4-storage-and-reach.md#a-user-account)). Read the same day: GitHub's
documentation describes workflow templates kept in an organization's `.github` repository and says nothing about a
user account's, and David-Noble-at-work/personal#315 copies personal's `triage.yml` from David-Noble-at-work/.github's
template (§ One model per account, in section 6).

Brought at the end of 2026-11-03 to that day's last changes. Since 2026-11-03 no template or copy, and none of each
team's and the user account's four projects, has a built-in workflow, because GitHub's API can't make one or turn one
on, so section 6 no longer says the owner switches them on or off by hand
([section 3](3-collections.md#triage-and-the-backlog)). The user account's reference model lists the labels that stand
in for NobleFactor's issue fields, and what is decided with #426, how each account's model is read, and #437, `push`, is
whether a reference model holds a repository's other labels (§ Reference models, read on demand, in section 6). Every
Schedule and Scenario template and copy has its field, whose one option names a placeholder issue (§ The asset, under
`projects`, in section 6).

## Completion

- [ ] Section 6 states what the model holds, the issue fields among it, and what it leaves out, that it is a cache,
  where it is stored, and what `pull` and `push` do with it: the four templates per account, Triage, Backlog, Schedule
  and Scenario, with the Schedule and Scenario fields and Iteration. Workflows and an organization's default labels are
  left out. On #303's branch, `doc/303-model-cutover`.
- [ ] Each account's model file in its `.github` repository, holding the issue types or type labels, the issue fields
  where the account has them, the teams, each repository's labels, and the four project templates with their fields,
  options and views: #431 for NobleFactor/.github, David-Noble-at-work/personal#311 for David-Noble-at-work/.github.
- [ ] Each account's file templates in its `.github` repository, ruled 2026-11-03: its issue forms and its Triage
  workflow template, which were there on 2026-11-03, and its pull request template, which is part of #431 for
  NobleFactor/.github and David-Noble-at-work/personal#311 for David-Noble-at-work/.github.
- [ ] The ETag cache under `$XDG_CACHE_HOME/devlore/star/gh/model/`, and `star github model digest`, built in #377; how
  each account's model is read, #426; the gate checks the digest, which no issue names yet.
- [ ] `star github model pull`, built in #377; `push`, #437; and `audit`, which no issue names yet; `labels sync` and
  `labels audit` retired into them.
- [ ] The extension derives the hierarchy from `types` and names no type itself, #376.
- [x] Every `star github schedule` operation reads GitHub's record conditionally first and reports when the asset is
  behind. Built in #378.
