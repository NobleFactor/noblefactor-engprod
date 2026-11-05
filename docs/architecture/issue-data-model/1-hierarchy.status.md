---
title: "1. The hierarchy — Status"
---

# 1. The hierarchy — Status

**Document:** [1-hierarchy.md](1-hierarchy.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled. Ruled 2026-10-22: Type is GitHub's issue type, the parent the sub-issue link, and teams triage their
own; chore a tier-two peer, overturned when Chore was retired on 2026-11-02; #142 the triage epic, overturned on
2026-11-03, when each team began triaging in its own Triage project with no epic. Ruled 2026-11-02: organizations and
user accounts are separate, each with its own model (§ Accounts in section 4); the hierarchy is Epic, then Feature, then
Task or Bug; every issue states its evidence of completion. Ruled 2026-11-03: issue types are capitalized and labels
lowercase, as GitHub names them; the issues that describe a schedule and a scenario have the types Schedule and
Scenario, with no level; threads are renamed scenarios, and the type Thread is Scenario; a Triage project has no triage
epic and there is no Triage type; the `Epic:` and `Thread:` labels are removed from both accounts. Also ruled
2026-11-03: issues are classified by issue type, with lax enforcement and no compliance checks; issues we file ourselves
will go through `star github issue` once it is built (#338); new issues reach their team's Triage project through a
GitHub Actions workflow in each repository, and a triage decision there declines the work or moves the issue to the
team's Backlog, Schedule or Scenario project; the team that owns a project is accountable for it, recorded by GitHub's
link between the project and its team. The six types were made in GitHub, Epic, Feature, Task, Bug, Schedule and Thread
in NobleFactor, and their lowercase labels in David-Noble-at-work; Thread and `thread` were renamed Scenario and
`scenario` on 2026-11-03. Question 2, how long a level lives, ruled 2026-11-03: a feature closes only after an agent's
compliance audit and an agent's code review, with the team lead's sign-off. Also ruled 2026-11-03: Area, with the two
values product and engineering, tells engineering work from product work on issues of every type; devlore-cli's seven
finer Area labels were deleted, and the hierarchy carries their distinctions; a blank Area is an error, caught at
filing, at triage and by a scheduled sweep. The old scheme's parent markers, body tables and NobleFactor's kind labels
retired on 2026-11-03, and the retirement is done in GitHub: 725 issue bodies lost their markers and schedule footers,
47 issues got the sub-issue parent their marker named, and 672 issues got the issue type their kind label named before
the labels left NobleFactor's 12 repositories. David-Noble-at-work keeps its type labels. Ruled 2026-11-03: an account's
file templates, which are its issue forms, its Triage workflow template and its pull request template, are stored in its
`.github` repository, and every document that talks about one of them refers to it there (§ One model per account in
section 6). Read from GitHub the same day, NobleFactor/.github and David-Noble-at-work/.github each hold six issue
forms, one for each type, and the Triage workflow template. Revised on the evening of 2026-11-03: GitHub's documentation
describes workflow templates kept in an organization's `.github` repository and says nothing about a user account's;
whether GitHub offers David-Noble-at-work/.github's template to personal has not been checked, and
David-Noble-at-work/personal#315 copies personal's `triage.yml` from it either way (§ Triage in section 4). Ruled
2026-11-04, the plan's questions 4 and 9, and the section's last open question: any member of a team can see all of the
team's issues and do all of its work in its four projects, so the one grant a new participant needs is membership in the
team, and in a user account, being a collaborator on each participating repository, personal and
David-Noble-at-work/.github, and a writer on each of the account's four projects; every move of an issue from one
project to another is one act, a move to another team's project included, the issue getting its row in the project it
goes to and losing its row in the project it leaves; triage removes an issue's Triage row as part of its decision, an
issue someone closes outside triage stays in its Triage project until triage decides its disposition, and the sweep will
remove no Triage row; epics and features are never rows of a Backlog, Schedule or Scenario project, since the hierarchy
holds them; one project at a time holds across the whole account: an issue is a row of at most one of its account's
Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and on at most one schedule or scenario, and
the sweep (#436) will check this across all of the account's projects, Scenario projects included, returning an issue
that breaks it to its team's Triage project; an issue on another team's project is assigned to an accountable member of
that team, and the person whose name is on an issue moves it to another team in one act, between its team's Triage
project or schedule and the other team's: triage to triage, triage to schedule, schedule to triage, or schedule to
schedule, which supersedes in part the ruling of 2026-10-22 that work for another team gets a tracking issue; and a work
item logged while walking a scenario starts in the scenario rather than in Triage, and gets its type and parent when it
moves out. The sweep will leave a scenario's rows alone but for two structural rules: it will return an epic or a
feature that is a row of a Scenario project, and an issue that is a row of a scenario and of another of the account's
projects. How the sweep will handle an issue that is a row of a scenario and of another project, without taking a
scheduled item off its schedule, is #436's to design. Read the same day, 14 tasks and bugs were rows of both a Schedule
and a Scenario project, and #252 a row of both Triage: engprod and Scenario: devlore; each had already moved on, so the
script of #303's closing pull request removes those 15 Scenario rows, and it deletes the Triage rows of the 30 open
issues in NobleFactor's Triage projects that were also rows of a Schedule project, their own team's or another's; and 78
of Triage: engprod's 178 rows were closed issues, which are triage's to decide. A Scenario issue summarizes an end-user
goal. Every issue but a Scenario issue states its evidence of completion, superseding in part the ruling of 2026-11-02:
a scenario never ends, so its Scenario issue never closes. Read the same day, the Scenario type's description in
NobleFactor, and the `scenario` label's in personal and David-Noble-at-work/.github, still read "Collection: describes a
scenario, the story its features tell", and #453 will bring all three to the ruling, with both accounts' Scenario forms.
Also ruled 2026-11-04: when triage gives an issue that arrived with no type a type other than Bug, it sets the issue's
Severity to N/A, and the sweep will catch a miss; the statement of 2026-11-03 that enforcement is lax and there are no
compliance checks is superseded in part, since the sweep will check the model's rules every day and return an issue that
breaks one to its team's Triage project, though it will block no filing and correct nothing by itself; and the script of
#303's closing pull request shows the Area field in every Triage view. Read the same day: GitHub enforces a form's
required fields only in a public repository, so in personal, the one private repository that takes part, nothing checks
the Area at filing until `star github issue` does (#338); personal's Triage workflow copies a form's Area into its
`area:` label, and NobleFactor's will set the Area field once #447 and #448 land; NobleFactor's Team plan has one seat,
filled; and setting a parent across two teams' repositories needs the triage role on both, which a devlore member has
between devlore's repositories and noblefactor-engprod and an engprod member lacks, while an organization owner has it
on every repository. The document was brought to these rulings on 2026-11-04 (the opening, § Type, § Triage and § How
long a level lives).

## Completion

- [x] The plan's questions 1 to 4 ruled: Type's name and home, how long a level lives, the engineering epic, triage.
  -- 2026-11-03
- [x] How a triage decision is carried out, and how an issue is kept in one project at a time, ruled -- 2026-11-04: any
  member of the team moves an issue, in one act, and triage removes its Triage row as part of its decision; an issue is
  a row of at most one of its account's Triage, Backlog, Schedule and Scenario projects, whichever team owns them, and
  on at most one schedule or scenario, which the sweep (#436) will check across all of the account's projects; and the
  person whose name is on an issue moves it to another team the same way, in one act.
- [x] [issue-standards.md](../../issue-standards.md) states the hierarchy. -- 2026-11-04, in #303's closing pull request
- [ ] Every open issue outside a Triage project has a Type and, if it is not an epic, a parent one level up in its own
  account. A new issue may wait in its team's Triage project with neither, and a work item logged while walking a
  scenario may wait in the scenario (ruled 2026-11-04).
- Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.
