---
title: "6. The asset and its sync — Status"
---

# 6. The asset and its sync — Status

**Document:** [6-the-asset-and-its-sync.md](6-the-asset-and-its-sync.md)
**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled 2026-10-22, from the owner's words of 2026-10-21 and 2026-10-22; the syntax and the file's shape were
proposed and accepted that day, and have since been revised. Ruled 2026-11-02 and 2026-11-03: the option is `--account`,
not `--org`, and `pull`'s `--account` defaults from star configuration, `github.account`, which defaults to NobleFactor;
`pull` takes the whole model, every repository the account owns, and has no `--repo`; the model file is named by
`--asset`. The model holds an account's issue types (type labels in a user account), its issue fields, each repository's
labels, its teams, and its four project templates, Triage, Backlog, Schedule and Scenario (copies of them in a user
account), with their custom fields, options and views, among them the Schedule and Scenario fields and Iteration. It
leaves out issues, the projects made from templates, any project's built-in workflows and an organization's default
labels. Ruled 2026-11-03: Thread is renamed Scenario, and each team, and each user account, has one Triage, Backlog,
Schedule and Scenario project, with no project per schedule or per scenario. Ruled 2026-11-12, on #438's plan: an
organization's half of a star github command is proved live in NobleFactor-sandbox, made that day to last and built from
NobleFactor's model by `apply`; ruled 2026-11-13, a user account's half is proved in David-Noble-at-work-sandbox, made
that day to last (§ Where star github's proofs run).

Ruled 2026-11-09 (#426): GitHub is the model. A command reads an account's model from GitHub when it needs it, and the
model file in the account's `.github` repository is a backup, written by `backup` and read only by `restore`. Five
commands, each naming its account, with no default account, no `--asset` and no `--check`: `get`, `diff`, `apply`,
`backup` and `restore` (§ GitHub is the model). That supersedes the rulings above on `pull`'s options and that the model
is a cache. Ruled 2026-11-10: `apply` and `restore` delete nothing of the account's without `--prune`, which replaces
the `--delete` of 2026-10-22. Ruled 2026-11-11: a project `apply` has just made is brought to its template exactly,
GitHub's default Status options, View 1 and built-in workflows deleted without it (§ GitHub is the model).

Ruled 2026-11-10 with #437 (§ GitHub is the model). `diff` compares every attribute, color among them, and a reference
names every attribute. `apply` never deletes a team, a project or a template, nor removes or lowers a team's role, even
with `--prune`; it writes a team only from the account's own backup, and labels only from the account's own backup or a
reference, never another account's. Every team that maintains a repository gets one project of each kind. A new
account joins through `apply`, which gives it its `.github` files and, in each participating repository, the Triage
workflow, its variable and the secrets the workflow signs in with, read from the template: an organization's GitHub
App's, a user account's token. `--token` names where each secret comes from, `env:` or `file:`, never its value.

Ruled 2026-11-03: the model holds the account's issue fields, as it holds its issue types and labels. NobleFactor's are
Priority, Effort, Target date, Resolution, Area and Severity, its Start date field staying unused; a user account has
none. Area has two values, product and engineering, and a blank Area is an error. Also ruled 2026-11-03: the old
scheme's last three pieces retired that day, done in GitHub: the parent markers and schedule footers came out of 725
issue bodies, the step and beat tables of 14 Schedule and Scenario issues gave way to a line naming the issue's board
and option, and the kind labels epic, feature, task and bug left NobleFactor's 12 repositories. David-Noble-at-work
keeps its type labels, which are its types.

Built: `pull`, `digest`, the cache and § Access, 2026-10-24 to 2026-10-26 in #377, `--check` standing in for `--dry-run`
until devlore-cli#1170; the read before every operation, in #378. Built 2026-11-09 in #426: `get`, which reads the teams
among the rest, and `backup`, and the report and the sweep on the model GitHub holds; `pull`, `digest`, the cache and
the read before every operation retired with it. Built 2026-11-10 in #437: `diff`, `apply` and `restore`, a new
account's `.github` files, Triage workflows, variables and secrets through `apply`, and `backup`'s pull-request gate
shared with `apply`; `labels sync` and `labels audit` removed. `model audit` is not among the five commands ruled
2026-11-09. Fixed 2026-11-12 in #536: `backup`'s and `apply`'s pull requests say AI assisted and end with both trailers,
and each is merged with its description as the commit's message, so the commit that lands carries them. Fixed
2026-11-13 in #538: a private repository of a free user account, whose rules GitHub refuses to read with a 403, requires
no check, and any other failure to read the rules says what GitHub said. Built 2026-11-13 in #448: NobleFactor/.github's
Triage workflow template sets the Severity issue field and adds an issue whose body says "Found while walking #N", where
#N is an open scenario of the account, to that scenario instead of to Triage (NobleFactor/.github#10), as
David-Noble-at-work/.github's now does; `apply` landed NobleFactor's in its five participating repositories, where it
has set the Area field since its first run, on 2026-11-11, and carried David-Noble-at-work/.github's to personal and to
David-Noble-at-work/.github's own workflow (David-Noble-at-work/.github#7 and #8, David-Noble-at-work/personal#325).

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
issues. How star reads the model was decided with #426 on 2026-11-09: from GitHub, when a command needs it.

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
in for NobleFactor's issue fields, and what is decided with #437, `apply`, is
whether a reference model holds a repository's other labels (§ Reference models, read on demand, in section 6). Every
Schedule and Scenario template and copy has its field, whose one option names a placeholder issue (§ The asset, under
`projects`, in section 6).

Brought on 2026-11-04 to that day's rulings, which settle the questions #303 had left open, and to the owner's rewrite
of the first later that day and the decisions that followed it. Severity applies to bugs only, and every issue of a type
other than Bug has Severity N/A: the asset's sketch shows the option N/A beside Critical, High, Medium and Low, and
`good first issue`, which goes on tasks and bugs only, among the labels (§ The asset). Severity's N/A option, the
`severity:n/a` label, personal's `good first issue` label, the teams' write role on their four projects, in place of the
Admin role ruled for each team's Triage project on 2026-10-22, the By priority view of the Backlog template and of the
teams' Backlog projects, and the fields the views show are made by the script of #303's closing pull request. The write
role lets a member edit a project, its fields and views included, and keeping every project of a kind configured the
same way rests on `apply` (#437), not on the role. Ruled under `projects`: how an issue moves between projects, to
another team's among them, by the person whose name is on it, and how it is kept in one of its account's projects at a
time, whichever team owns them, with triage removing an issue's Triage row as part of its decision; epics and features,
which are rows of no project once classified; and a scenario, a high-level description of a feature, a workflow or a
real-life situation that needs to be tested, whose rows are its Scenario issue and the tasks and bugs found by walking
it, rows the sweep will leave alone but for two structural rules, on an epic or a feature in a scenario and on an issue
in a scenario and in another of its account's projects. Under `types`, the ruling of 2026-11-03 that a Scenario issue
tells a scenario's story is followed by that of 2026-11-04, that it summarizes an end-user goal, and #453 will bring the
Scenario type's description and the `scenario` labels' in personal and David-Noble-at-work/.github to that ruling. A
hierarchy type whose description names no level is a fault of the model, on which `get` stops (#426) and which `apply`
will check (#437) (§ The asset, under `types`). The sweep (#436) will return an open issue with a resolution to its
team's Triage project, and the ruling of 2026-11-03 that there are no compliance checks is superseded in part by the
sweep, which will be the one check (§ The asset, under `types` and `labels`, and § Participation: a user account's
repositories). § Participation also says that `star github issue`, which will be the one path for the issues we file
ourselves once it is built, will refuse an issue without an Area (#338). Under `projects`, a user account's new
participant is a collaborator on each participating repository, personal and David-Noble-at-work/.github; § One model
per account says that personal's Triage workflow copies a form's Area into an `area:` label today, and that
NobleFactor's will set the Area field once #447 and #448 land. Settled the same day: GitHub's REST call for an issue
field takes each option's id and its GraphQL call takes none, so `apply` will send every option with its id (#437; § The
asset, under Ids beside names, and § Risk).

## Completion

- [ ] Section 6 states what the model holds, the issue fields among it, and what it leaves out, that GitHub is the model
  and the file its backup, where the file is stored, and what the five commands do with it: the four templates per
  account, Triage, Backlog, Schedule and Scenario, with the Schedule and Scenario fields and Iteration. Workflows and an
  organization's default labels are left out. On #303's branch, `doc/303-model-cutover`.
- [x] Each account's model file in its `.github` repository, holding the issue types or type labels, the issue fields
  where the account has them, the teams, each repository's labels, and the four project templates with their fields,
  options and views: #431 for NobleFactor/.github, David-Noble-at-work/personal#311 for David-Noble-at-work/.github.
  Both landed on 2026-11-09: NobleFactor's (#431, NobleFactor/.github#3) and David-Noble-at-work's (#441, standing in
  for David-Noble-at-work/personal#311; David-Noble-at-work/.github#1). Since #426 each is its account's backup, written
  by `backup`; star reads the model from GitHub.
- [x] Each account's file templates in its `.github` repository, ruled 2026-11-03: its issue forms and its Triage
  workflow template, which were there on 2026-11-03, and its pull request template, which is part of #431 for
  NobleFactor/.github and David-Noble-at-work/personal#311 for David-Noble-at-work/.github. Both pull request
  templates landed on 2026-11-09, each with `CONTRIBUTING.md`, `SECURITY.md` and `SUPPORT.md` (#431, #441).
- [x] How each account's model is read: from GitHub, when a command needs it, built in #426 on 2026-11-09. The ETag
  cache under `$XDG_CACHE_HOME/devlore/star/gh/model/` and `star github model digest`, built in #377, retired with it,
  and with them the gate's check of the digest, which no issue had named.
- [x] The model commands: `get` and `backup`, built in #426, `pull` and `digest` retiring with it; `diff`, `apply` and
  `restore`, built in #437 on 2026-11-10; `labels sync` and `labels audit`, which still enforced the label scheme
  retired on 2026-11-03, removed with #437 the same day.
- [ ] The hierarchy derived by the extension from `types`, with no type named in the extension itself: #376.
- [x] Every `star github schedule` operation reads GitHub's record conditionally first and reports when the asset is
  behind. Built in #378; since #426 every command that needs the model reads it from GitHub, and no copy can be behind.
