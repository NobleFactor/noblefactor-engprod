---
title: "2. Attributes — Status"
---

# 2. Attributes — Status

**Document:** [2-attributes.md](2-attributes.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled, 2026-11-02 to 2026-11-04; questions 11 and 12 on 2026-11-04. Ruled 2026-11-02: each account has its
own data model. Ruled 2026-11-03: labels are held per repository, and an organization's default labels are not part of
the model; issue types are capitalized and labels lowercase, `severity:`, `priority:` and `area:` among them; Priority
and Area apply to every type, Schedule and Scenario included; a closed issue's reason is NobleFactor's Resolution issue
field and David-Noble-at-work's `resolution:` labels; and issue fields are used wherever an account has them, so
NobleFactor holds Priority and Area in issue fields and David-Noble-at-work its attributes in labels. Also ruled
2026-11-03: threads are renamed scenarios; each team, and each user account, has a Triage, a Backlog, a Schedule and a
Scenario project; the Backlog is ordered by priority; the team that owns a project is accountable for it; and work
declined in triage is closed as completed with its resolution. Also ruled 2026-11-03: Area tells engineering work from
product work, with the two values product and engineering, NobleFactor's Area field options and a user account's
`area:product` and `area:engineering` labels; devlore-cli's seven finer Area labels were deleted and the hierarchy
carries those distinctions; a blank Area is an error caught at filing, at triage and by a scheduled sweep; and an
account's model holds its issue fields, NobleFactor's being Priority, Effort, Target date, Resolution and Area, while a
user account has none. The document was revised to these rulings on 2026-11-03. Also ruled 2026-11-03: Severity is an
issue field of NobleFactor, with the values Critical, High, Medium and Low; and a user account has the same data model
as an organization, apart from what GitHub offers organizations only, so a label stands in for each single-select issue
field, `priority:urgent` to `priority:low` among them. Done in GitHub the same day: the Severity field, made and read
back by the design worktree's script, which also gave devlore-cli's issues the Severity and Priority values their labels
named and deleted those labels; the priority, severity and effort labels, made in personal and
David-Noble-at-work/.github; and the Priority project field, deleted from Backlog: David-Noble-at-work and the account's
Backlog copy. The document was revised to these on the evening of 2026-11-03 (§ The attributes, § Labels carry no
values). Ruled 2026-11-04, the plan's questions 11 and 12: a task has no severity; it has a priority. Severity applies
to bugs only, and every issue of another type has Severity N/A, a new option of NobleFactor's Severity field and a new
label, `severity:n/a`, in a user account, both made by the script of #303's closing pull request; when triage gives an
issue that arrived with no type a type other than Bug, triage sets its Severity to N/A, and the sweep will catch a miss.
A scenario changes no issue's priority; triage sets each issue's Priority. Also ruled 2026-11-04: `good first issue`
goes on tasks and bugs only, and personal gets the label, made by the same script; and the sweep (#436) will check the
attribute rules, returning any open issue that breaks one to its team's Triage project, an issue other than a Scenario
issue with no Evidence of completion section among them, as it will return an issue that isn't fully classified. A
Scenario issue states no evidence of completion, since a scenario never ends. The sweep will also return an epic or a
feature that is a row of a Backlog, Schedule or Scenario project, and an issue in more than one of its account's Triage,
Backlog, Schedule and Scenario projects, whichever team owns them, or on more than one schedule or scenario; it will
leave a scenario's rows alone but for those two rules, which are structural, and every other rule waits until a work
item logged while walking a scenario moves out. How it will handle an issue that is a row of a scenario and of another
project, without taking a scheduled item off its schedule, is #436's to design. Also ruled 2026-11-04: triage removes an
issue's Triage row as part of its decision, and the sweep will remove none; and an issue on another team's project is
assigned to an accountable member of that team. Also settled on 2026-11-04: the N/A option is gray, described "Not
applicable: the issue is not a bug", and the label `severity:n/a` is `cfd3d7`, described "Severity: not applicable, the
issue is not a bug"; the same script shows the Area field in every Triage view and the Priority field in every view of
NobleFactor's Backlog projects; and #452 will give every open issue an Area before the sweep runs, which #436 waits on.
Read the same day: GitHub enforces a form's required fields only in a public repository, so in personal, the one private
repository that takes part, nothing checks the Area at filing until `star github issue` does (#338), and personal's
Triage workflow copies a form's Area into its `area:` label, while NobleFactor's will set the Area field once #447 and
#448 land. The document was brought to these rulings on 2026-11-04 (§ The attributes, § Labels carry no values, § Not
attributes, § Why an issue was closed).

## Completion

- [x] The plan's questions 11 and 12 ruled: severity on a task, how a scenario influences priority -- 2026-11-04: a task
  has no severity, it has a priority, and every issue of a type other than Bug has Severity N/A; a scenario changes no
  issue's priority, and triage sets each issue's Priority.
- [x] The plan's question 14 ruled: GitHub's other issue fields -- 2026-11-03: NobleFactor uses Priority, Effort,
  Target date, Resolution, Area and, since that evening, Severity, and not Start date, and the model holds an
  account's issue fields.
- [x] Where severity lives in NobleFactor ruled -- 2026-11-03: in its Severity issue field, Critical, High, Medium
  and Low, made by the design worktree's script and read back.
- [x] Area's values and how a blank Area is caught -- 2026-11-03: product and engineering, caught at filing, at
  triage and by a scheduled sweep.
- [x] Which types `good first issue` goes on ruled -- 2026-11-04: tasks and bugs only; personal gets the label, made
  by the script of #303's closing pull request, so that both accounts hold it.
- [x] [issue-standards.md](../../issue-standards.md) states the attributes.
  -- 2026-11-04, in #303's closing pull request

Ruled 2026-11-04: the sweep (#436) carries the attribute rules. It will return to its team's Triage project any open
issue that breaks one, comment on the issue naming the rule it broke, and run every day as a scheduled GitHub Actions
workflow in each account's `.github` repository (§ The attributes). #361, which held the audit's faults, was closed on
2026-11-04 as completed with Resolution Declined. The rollout: the attribute fields and labels ruled by 2026-11-03 were
in GitHub that day. The Severity field's N/A option, the `severity:n/a` label and personal's `good first issue` are made
by the script of #303's closing pull request, which also sets N/A on every open issue of a type other than Bug when it
runs; read on 2026-11-04, before #452 and #453 were filed, there were 414 in NobleFactor's five participating
repositories and 33 in personal. An issue with no type gets none and waits for triage, which sets N/A when it gives the
issue a type other than Bug. The Triage workflow will set N/A on an issue of another type filed from a form, and Medium
on a bug filed from the bug form, when the issue is opened (#448). The script of #303's closing pull request also shows
the Area field in every Triage view, the Priority field in every view of NobleFactor's Backlog projects, and the Labels
field in David-Noble-at-work's Triage and Backlog views; read 2026-11-04, no such view showed any of them. #452 will
give every open issue an Area before the sweep runs, and #436 waits on it: read 2026-11-04, before #452 and #453 were
filed, 9 of the 528 open issues in NobleFactor's five participating repositories had one, and 5 of personal's 42.
Keeping the fields and labels in step belongs to `star github model pull` (#426) and `push` (#437). Read on 2026-11-04,
83 open bugs had no severity, 77 in NobleFactor and 6 in personal, and giving each one its severity is triage's work.
