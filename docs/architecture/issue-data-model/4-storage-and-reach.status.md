---
title: "4. Storage and reach — Status"
---

# 4. Storage and reach — Status

**Document:** [4-storage-and-reach.md](4-storage-and-reach.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled 2026-10-22: Type and the parent are GitHub's; personal keeps labels synced one way (retired
2026-11-02, when each account got its own model); the sub-issue link crosses repositories and owners, proven by the
write test of that day. The write test's second half, an option updated by id, passed 2026-10-26 under #377, and
blocked-by links cross repositories and owners, 2026-11-01. The plan's question 17, added 2026-11-02, asks whether an
organization's records may point at a personal repository at all. Ruled 2026-11-02: organizations and individual
accounts are separate, each with its own model (§ Accounts in section 4); question 17 settled the same day, and the
model read on demand from two reference models (§ Reference models, read on demand, in section 6). Revised the same
day: each account keeps its model in its own `.github` repository (#431,
David-Noble-at-work/personal#311), which section 6 states with #431.

Ruled 2026-11-09 (#426): GitHub is the model. star reads an account's model from GitHub when a command needs it, and the
file in its `.github` repository is a backup; `get`, `diff`, `apply`, `backup` and `restore`, each naming its account,
replace pull and push. That supersedes the rulings below that the model is a cache and on pull's options, and section 4
says so where it names them ([section 6](6-the-asset-and-its-sync.md#github-is-the-model)). Ruled 2026-11-10 with #437,
which built `diff`, `apply` and `restore`: `apply` writes a repository's labels only from its account's own backup or
a reference, never another account's, and a reference names labels only for a user account (§ Labels).

Brought up to date on 2026-11-03 with the rulings of 2026-11-02 and 2026-11-03. Section 4 now states each of these:

- 2026-11-02: no project, sub-issue link or blocked-by link crosses accounts. Work that waits on another account
  waits on a stand-in issue in its own account.
- 2026-11-02: each account's model is stored in its own `.github` repository. NobleFactor/.github and
  David-Noble-at-work/.github exist, both public. NobleFactor/.github gets a quality-gate check of its own (2026-11-03).
- 2026-11-02: Lane is renamed Step. A schedule's own issue is its first row and has no step. Every other row gets its
  step and its dependencies, as blocked-by links, when it is added.
- 2026-11-02: Chore is retired; the hierarchy is Epic, then Feature, then Task or Bug.
- 2026-11-02 and 2026-11-03: the Schedule, Scenario (formerly Thread), Triage and Backlog templates, NobleFactor
  projects 7, 8, 23 and 24, and David-Noble-at-work's copies of them, its projects 1, 2, 4 and 5.
- 2026-11-03: the three Triage projects, Triage: engprod (project 5), Triage: devlore (project 6) and Triage:
  David-Noble-at-work (David-Noble-at-work project 3), each owned by its team or by the account, with no triage epic.
  #142, NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313 are retired.
- 2026-11-03: the Schedule and Scenario types, and in the user account the labels schedule and scenario, with
  descriptions beginning `Collection:`.
- 2026-11-03: issue types are capitalized and labels lowercase.
- 2026-11-03: the `Epic:`, `Thread:` and `ClaudeJudgmentError:` labels removed from both accounts.
- 2026-11-03: labels held per repository. An organization's default labels and a project's built-in workflows are
  outside the model. The model is a cache that star queries instead of asking GitHub again.
- 2026-11-03: pull takes every repository of the account, names it with `--account`, and has no `--repo`. Its
  `--account` defaults from star configuration, `github.account`, and its model file option is `--asset`.
- 2026-11-03: why a closed issue was not done is the Resolution issue field in NobleFactor and a `resolution:` label
  in David-Noble-at-work; issue fields in NobleFactor, the priority:, severity:, effort: and area: labels in
  David-Noble-at-work.

Ruled 2026-11-03, and revised into section 4 the same day. Section 4 now states each of these too:

- Threads are renamed Scenarios: the issue type Thread is Scenario, the label thread is scenario in a user account,
  and the Thread template is the Scenario template.
- Each team, and each user account, has four projects, Triage, Backlog, one Schedule project and one Scenario
  project, named `<Kind>: <team>` in an organization and `<Kind>: David-Noble-at-work` in the user account. There is
  no longer a project per schedule or per scenario. Both account diagrams show the four projects, the templates or
  copies they come from, and the Schedule and Scenario fields.
- The Schedule project holds committed tasks and bugs: a Schedule field names each row's schedule, Step orders the
  rows within it, a Schedule issue's own row has no step, and GitHub's Iteration field gives each row its sprint.
- The Scenario project holds features: a Scenario field names each row's scenario, and Beat orders the rows within it.
- The Backlog project holds accepted work not yet scheduled, ordered by priority.
- In the Triage project every issue is reviewed and a triage decision made. A declined issue is closed as completed,
  with Resolution Declined or the resolution:declined label. Any other issue moves to the team's Backlog, Schedule or
  Scenario project.
- New issues reach Triage through a GitHub Actions workflow in each repository, run when an issue is opened or
  transferred, using actions/add-to-project, with each repository's `TRIAGE_PROJECT_URL` variable from the team
  mapping. A Triage workflow template in each account's `.github` repository offers it. GitHub's built-in auto-add
  workflow is not used.
- The team that owns a project is accountable for it, and GitHub's link between a project and its team is the record.
  A user account's projects are its owner's.
- Issues are classified by issue type, enforcement is lax, and there are no compliance checks. § What the audit does
  is now § What GitHub does not enforce.
- Issues we file ourselves will go through `star github issue` once it is built (#338).
- NobleFactor keeps the Triage, Backlog, Schedule and Scenario templates, and David-Noble-at-work keeps copies of them.
- GitHub Actions cannot run a workflow when a project row changes: `projects_v2_item` is a webhook event for
  organization webhooks and GitHub Apps only.

The later rulings of 2026-11-03 are in section 4 too. They settled every open question section 4 then had but one, how a
triage decision is carried out and how an issue is kept in one project at a time:

- Area tells engineering work from product work and has two values only: the options Product and Engineering of the
  Area issue field in NobleFactor, made 2026-11-03, and the labels area:product and area:engineering in a user
  account. It goes on issues of every type and describes the issue's own work.
- devlore-cli's seven finer Area labels were deleted on 2026-11-03, and the hierarchy carries those distinctions.
- A blank Area is an error, caught at filing by the required Area dropdown of each issue form in the account's `.github`
  repository and, once it is built, by `star github issue` (#338), at triage by the Area field of NobleFactor's Triage
  projects and the Missing Area view of each Triage project, and afterwards by a scheduled sweep that will return an
  open issue without an Area to its Triage project.
- An account's model holds its issue fields, as it holds its issue types and labels. NobleFactor's are Priority,
  Effort, Target date, Resolution, Area and Severity, and Start date stays unused. A user account has none.
- The old scheme's last three pieces retired on 2026-11-03, and the retirement was done in GitHub: the parent markers
  and schedule footers came out of 725 issue bodies, the step and beat tables in 14 Schedule and Scenario issues gave
  way to a line naming the issue's board and option, and the kind labels epic, feature, task and bug left
  NobleFactor's 12 repositories after 672 issues got their issue types. David-Noble-at-work keeps its type labels.

Ruled 2026-11-03, after those, and stated in section 4 the same day: an account's file templates, which are its issue
forms, its Triage workflow template and its pull request template, are stored in its `.github` repository, and every
document that talks about one of them refers to it there. Both account diagrams show them. Read from GitHub on
2026-11-03:

- Both `.github` repositories hold the six issue forms and the Triage workflow template, and neither holds a pull
  request template yet, which is part of #431 and David-Noble-at-work/personal#311, the issues that bring each account's
  model file there (§ Accounts in section 4).
- The Triage workflow adds no new issue to a Triage project yet. `TRIAGE_PROJECT_URL` is set in seven repositories. It
  names [Triage: engprod](https://github.com/orgs/NobleFactor/projects/5) in NobleFactor/noblefactor-engprod and
  NobleFactor/.github; [Triage: devlore](https://github.com/orgs/NobleFactor/projects/6) in NobleFactor/devlore-cli,
  NobleFactor/devlore-registry and NobleFactor/devlore.noblefactor.com; and [Triage:
  David-Noble-at-work](https://github.com/users/David-Noble-at-work/projects/3) in David-Noble-at-work/personal and
  David-Noble-at-work/.github. Both `.github` repositories take part in triage from 2026-11-03, and both accept issues:
  the engprod team was given the maintain role on NobleFactor/.github that day, and David-Noble-at-work/.github has the
  topic issue-model. personal has had `.github/workflows/triage.yml` since 2026-11-04, merged in
  David-Noble-at-work/personal#320 for David-Noble-at-work/personal#315, step 1 of David-Noble-at-work's schedule issue
  tracking, iteration 1 (David-Noble-at-work/personal#314); the other six don't have it yet. NobleFactor's five
  repositories now wait only on their own `.github/workflows/triage.yml`: the noblefactor-automation app's installation
  on NobleFactor has organization projects read and write, issue fields read, and issues read and write, and nothing has
  used them yet. The first Triage workflow run in a NobleFactor repository will prove them (§ Triage in section 4).
- GitHub's built-in "Auto-add sub-issues to project" workflow was on in Triage: devlore. Whether the ruling on the
  Triage workflow leaves it unused was settled later that day: every project of a kind is configured the same way (ruled
  2026-11-03), and since GitHub's API can't make a built-in workflow or turn one on, every built-in workflow of the
  twenty projects of the four kinds was deleted, this one among them (§ Triage in section 4).
- 60 rows of NobleFactor projects were personal issues, and #428, which takes them out, and
  David-Noble-at-work/personal#309, which gives personal its own records first, are still open (§ What reaches personal
  in section 4).
- Building a schedule for each NobleFactor schedule personal's steps came from is David-Noble-at-work/personal#309,
  which is open and has no plan. The account's first schedule was made later that evening, below (§ The rest of the
  ruling in section 4).

Brought later on the evening of 2026-11-03 to that day's last rulings and to what was made and read back then.
Section 4 now states each of these:

- Ruled 2026-11-03: a user account and an organization have exactly the same data model, apart from what GitHub
  offers organizations only. A user account has no issue fields, so a label stands in for each single-select issue
  field, one per option, named `<field>:<option>` in lowercase: priority:urgent to priority:low, severity:critical to
  severity:low, effort:high to effort:low, area:product and area:engineering, and resolution:declined,
  resolution:duplicate and resolution:invalid. The priority, severity and effort labels were made on 2026-11-03 in
  personal and David-Noble-at-work/.github. A date field has no stand-in, and a project field is no stand-in: the
  Priority project field on Backlog: David-Noble-at-work and on the account's Backlog copy was deleted that day (§ A
  user account in section 4).
- Ruled 2026-11-03: David-Noble-at-work has schedules of its own, as each NobleFactor team does, and personal's steps
  go on them. Made that day and read back: David-Noble-at-work/personal#314, "Schedule: issue tracking, iteration 1";
  a Schedule field on Schedule: David-Noble-at-work, whose first option is named for personal#314; and
  David-Noble-at-work/personal#315, the task that adds personal's Triage workflow, as its step 1. This settles where a
  new personal issue's step goes (§ The rest of the ruling in section 4).
- Ruled 2026-11-03: Severity is an issue field of the organization in NobleFactor, with the values Critical, High,
  Medium and Low, made that day and read back. This settles where severity lives in NobleFactor (§ The attributes in
  section 2).
- GitHub's documentation describes workflow templates kept in an organization's `.github` repository and says nothing
  about a user account's. Whether GitHub offers David-Noble-at-work/.github's Triage workflow template to personal has
  not been checked; either way, personal#315 copies personal's `triage.yml` from it (§ Triage in section 4).
- Ruled 2026-11-03: every project of a kind is configured the same way. Compared field by field, option by option and
  view by view that day, each of the twenty projects, NobleFactor's four templates, its teams' eight projects and
  David-Noble-at-work's four copies and four projects, matches its kind's template, except for the Area and Priority
  columns, issue fields that David-Noble-at-work's Triage and Backlog projects lack (§ A user account in section 4).
- Made 2026-11-03 on the owner's order and read back: the placeholder schedule David-Noble-at-work/personal#319, which
  gives the account's Schedule copy (its project 1) its Schedule field, whose one option, placeholder, names it (§ The
  rest of the ruling in section 4).

Made 2026-11-03 on the owner's order and read back: personal's hierarchy for its issue tracking, the epic
David-Noble-at-work/personal#317 with the feature personal#318 under it, and under the feature the tasks personal#315
(personal's Triage workflow) and personal#311 (David-Noble-at-work/.github holds the account's issue model);
NobleFactor's counterpart is Epic #330, Issue tracking, with its features #331 to #333.

On 2026-11-04, of the Triage workflow (§ Triage in section 4):

- David-Noble-at-work/.github takes part in triage, with its `TRIAGE_PROJECT_URL` set, but has no repository secret,
  read from GitHub that day. So its Triage workflow, when it is added, needs `ADD_TO_PROJECT_PAT` too. No copy of
  personal's token was kept, so that takes a token made for it, or personal's regenerated and stored in both.
- personal's Triage workflow, David-Noble-at-work/personal#315, merged on 2026-11-04 in
  David-Noble-at-work/personal#320, and #315 closed after its live test: the test issue
  David-Noble-at-work/personal#321 became a row of Triage: David-Noble-at-work and got `area:engineering` from
  `github-actions[bot]`, by a run that completed with success, and was closed with `resolution:invalid`. The change
  also fixed the Area reader of David-Noble-at-work/.github's Triage workflow template, which looped forever on an
  issue body ending at the Area heading. NobleFactor/.github's Triage workflow template, already merged, has the same
  reader, and its fix goes through a NobleFactor/.github pull request.

Brought on 2026-11-04 to that day's rulings on #303. Section 4 now states each of these:

- How an issue moves between its team's projects, and who moves it, which settles the question section 4 had left open,
  how a triage decision is carried out and how an issue is kept in one project at a time. Any member of a team can see
  all of the team's issues and do all of its work in its four projects, so membership in the team is the one grant a new
  participant needs: its roles are the maintain role on each repository the team owns and the write role on each of its
  four projects, which the script of #303's closing pull request sets. Adding a person to NobleFactor needs a seat
  first, and its Team plan's one seat is filled. In a user account, a new participant is a collaborator on each
  participating repository, personal and David-Noble-at-work/.github, and a writer on each of the account's four
  projects. An issue is a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever
  team owns them, and is on at most one schedule or scenario, no epic or feature is a row of a Backlog, Schedule or
  Scenario project, and every move is one act. The Backlog's view By priority, sorted by Priority, is made by the script
  of #303's closing pull request in Backlog: engprod, Backlog: devlore and the Backlog template (§ Triage, § A user
  account and § Where each part lives in section 4).
- A scenario's rows are the tasks and bugs logged while walking it, beside its Scenario issue's own, each with its Beat,
  the point in the walk where it turned up, in place of the ruling of 2026-11-03 that they are features. The Triage
  workflow will add an item that names its scenario in its body to that scenario instead of to Triage (#448), and the
  Scenario issue summarizes an end-user goal and names the features its scenario exercises (§ An organization's account,
  § Triage and § Where each part lives in section 4).
- A task has no severity; it has a priority. Severity applies to bugs only: a bug has Critical, High, Medium or Low,
  never N/A, and an issue of every other type has N/A, a new option of NobleFactor's Severity field and the label
  severity:n/a in a user account, colored `cfd3d7`, both made by the script of #303's closing pull request (§ A user
  account and § Where each part lives in section 4).
- `good first issue` goes on tasks and bugs only. personal gets the label from the script of #303's closing pull
  request, so both accounts hold it; read on 2026-11-04, the five participating NobleFactor repositories and
  David-Noble-at-work/.github have it (§ Where each part lives in section 4).
- A form's required Area dropdown and Evidence of completion section hold only in a public repository (GitHub's form
  schema documentation, read 2026-11-04). personal is the one private participating repository since the owner made
  devlore.noblefactor.com public that day, and nothing checks either there at filing until `star github issue` does
  (#338). No view of a Triage project showed the Area field, or in a user account its Labels column, when read that day,
  and the script of #303's closing pull request shows them; and #452 will give every open issue an Area before the sweep
  runs (§ Triage and § Where each part lives in section 4).
- The sweep (#436) will check the attribute rules, and that an issue is in at most one of its account's Triage, Backlog,
  Schedule and Scenario projects, whichever team owns them, and on at most one schedule or scenario, and will return an
  open issue that breaks one to its team's Triage project, with a comment naming the rule. It will also return an epic
  or feature that is a row of a Backlog, Schedule or Scenario project, an issue whose row on a schedule has no step,
  other than a Schedule issue's own, an issue with a sub-issue or blocked-by link into another account, and an issue
  other than a Scenario issue with no Evidence of completion section. It will leave a scenario's rows alone but for two
  of those rules, an epic or a feature that is a row of a Scenario project and an issue that is a row of a scenario and
  of another of the account's projects, whichever team owns it, and every other rule will wait until an item logged
  while walking a scenario moves out. How it will handle an issue that is in a scenario and in another project, without
  taking a scheduled item off its schedule, is #436's to design. It will run every day as a scheduled GitHub Actions
  workflow in each account's `.github` repository. The sweep will block no filing and correct nothing by itself, and
  triage fixes each issue it returns by hand. This supersedes in part the statement of 2026-11-03 that there are no
  compliance checks (§ What GitHub does not enforce in section 4).

Brought on the evening of 2026-11-04 to the owner's last decisions of that day. Section 4 now states each of these:

- A Scenario issue states no evidence of completion: a scenario never ends, so its issue never closes. Every other issue
  states its own, and the sweep's rule on a missing Evidence of completion section will skip Scenario issues. #453 will
  put how to walk it, the example the Scenario issue gives, in place of each Scenario form's Evidence of completion
  section (§ An organization's account, § Where each part lives and § What GitHub does not enforce in section 4).
- The words of the scenario of 2026-11-03, whose Scenario issue told its features' story, give way to the rewritten
  ruling's: its Scenario issue summarizes an end-user goal to test (§ An organization's account in section 4).
- How the sweep (#436) will handle an issue that is in a scenario and in another project, without taking a scheduled
  item off its schedule, is #436's to design, and § What GitHub does not enforce now lists the attribute rules the sweep
  will check apart from the model's other rules (§ Triage and § What GitHub does not enforce in section 4).
- In a user account, a new participant is a collaborator on each participating repository, personal and
  David-Noble-at-work/.github (§ A user account and § Triage in section 4).
- `star github issue` is not built, so issues we file ourselves will go through it once it is (#338). personal's Triage
  workflow adds the Area label today, and NobleFactor's will set the Area field once #447 and #448 land; the counts of
  open issues with an Area were read before #452 and #453 were filed (§ Triage in section 4).

Brought last of all on 2026-11-04 to the owner's two last rulings of that day. Section 4 now states each of these:

- One project at a time holds across the whole account, not only within a team's four projects: an issue is a row of at
  most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and is on at most
  one schedule or scenario, and the sweep (#436) will check the rule across all of the account's projects, with its two
  exceptions for a scenario's rows. An issue on another team's project is assigned to an accountable member of that
  team, and the person whose name is on an issue moves it to another team in one act, between its team's Triage project
  or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or schedule to schedule.
  This supersedes in part the ruling of 2026-10-22 that work for another team gets a tracking issue (§ Triage and § What
  GitHub does not enforce in section 4).
- Triage removes an issue's row from its Triage project as part of its decision, and an issue someone closes outside
  triage stays there until triage decides its disposition. The sweep will remove no Triage row, as #436's comment of
  2026-11-04 records (§ Triage in section 4).
- Work not yet done is stated as work to come: what the sweep (#436), the Triage workflow (#448), #452 and #453 will do;
  the first Triage workflow run in a NobleFactor repository, which will prove the noblefactor-automation app's
  permissions; and what pull and push (#426 and #437) will check and decide (§ An organization's account, § Triage, §
  Where each part lives, § Where each part is defined and § What GitHub does not enforce in section 4).

Revised 2026-11-05 for #446: the paragraph on Area in § Where each part lives points to
[issue-standards.md § Product and engineering](../../issue-standards.md#product-and-engineering), which says what
product work and engineering work each cover, tests among engineering's, and what each may hold, in place of the list
of what engineering covers, and the sentence that product readiness and release management epics hold both kinds of
work is gone, superseded on 2026-11-05.

Built 2026-11-13 in #448: NobleFactor's five participating repositories run the Triage workflow, landed from
NobleFactor/.github's template by `star github model apply` (#437); its first run, on 2026-11-11, set the Area field
and proved the noblefactor-automation app's permissions for projects and issue fields; David-Noble-at-work/.github,
which has run its own with an `ADD_TO_PROJECT_PAT` of its own since 2026-11-09 (#441), was brought to the template on
2026-11-13 (David-Noble-at-work/.github#8); and in both accounts it gives an issue whose body says "Found while walking
#N", where #N is an open scenario of the account, its row on that scenario's Scenario project in place of a Triage row
(§ An organization's account and § Triage in section 4).

## Completion

- [x] The plan's questions 1 and 13 ruled: where Type lives and where the parent link lives -- 2026-10-22
- [x] Where Severity, Priority and Area live -- 2026-11-03: all three are issue fields in NobleFactor, Severity since
      that evening, and labels in David-Noble-at-work (§ The attributes in section 2)
- [x] Ruled on #303: whether the model holds an organization's issue fields -- 2026-11-03: it does, as it holds the
      account's issue types and labels; NobleFactor's are Priority, Effort, Target date, Resolution, Area and Severity
- [x] Ruled on #303: how engineering work is told apart from product work -- 2026-11-03: by Area, Product or
      Engineering in NobleFactor and area:product or area:engineering in a user account, never blank
- [x] A write test: whether a sub-issue link and a blocked-by link cross repositories, and owners -- 2026-10-22 for the
      sub-issue link, 2026-11-01 for the blocked-by link; since 2026-11-02 the model makes no link across accounts
- [x] Section 4 shows the organization account and the user account in a diagram each, with its templates or copies
      and the `.github` repository that stores its model, and describes the user account in detail -- 2026-11-03;
      both diagrams brought to the four projects per team or account, and the Schedule and Scenario fields, the same
      day, and to the file templates each `.github` repository stores, the pull request template among them
- [x] Section 4 names every rule GitHub does not enforce, and says nothing corrects an issue by itself -- 2026-11-03,
      the day it was ruled that there are no compliance checks
- [x] Ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time --
      2026-11-04: every move is one act, an issue is a row of at most one of its account's Triage, Backlog, Schedule and
      Scenario projects, whichever team owns them, and on at most one schedule or scenario, triage removes an issue's
      Triage row as part of its decision, and the sweep (#436) will return to its team's Triage project an issue that
      breaks the rule, the Scenario projects included; how it will handle one in a scenario and in another project,
      without taking a scheduled item off its schedule, is #436's to design
- [x] Ruled on #303: where a new personal issue's step goes while David-Noble-at-work has no schedule -- 2026-11-03:
      on David-Noble-at-work's own schedules; personal#315 is step 1 of personal#314, read back
- [x] Ruled on #303: where severity lives in NobleFactor -- 2026-11-03: in the organization's issue field Severity,
      Critical, High, Medium or Low, made and read back that day
- [x] Ruled on #303: whether Schedule and Scenario issues sit under an epic or outside the hierarchy -- 2026-11-03: no
      parent; Epic is at the top, and Schedule and Scenario are its two peers there
- [x] Ruled on #303: what makes a repository take part -- 2026-11-03: a team's maintain role in an
      organization, the topic issue-model in a user account
- [x] Ruled on #303: what of the old scheme retires now -- 2026-11-03: the parent markers and schedule footers, the
      step and beat tables in issue bodies, and NobleFactor's kind labels, all retired in GitHub the same day
