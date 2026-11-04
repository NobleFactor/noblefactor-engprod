---
title: "1. The hierarchy — Status"
---

# 1. The hierarchy — Status

**Document:** [1-hierarchy.md](1-hierarchy.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled in part. Ruled 2026-10-22: Type is GitHub's issue type, the parent the sub-issue link, and teams
triage their own; chore a tier-two peer, overturned when Chore was retired on 2026-11-02; #142 the triage epic,
overturned on 2026-11-03, when each team began triaging in its own Triage project with no epic. Ruled 2026-11-02:
organizations and user accounts are separate, each with its own model (§ Accounts in section 4); the hierarchy is
Epic, then Feature, then Task or Bug; every issue states its evidence of completion. Ruled 2026-11-03: issue types are
capitalized and labels lowercase, as GitHub names them; the issues that describe a schedule and a scenario have the
types Schedule and Scenario, with no level; threads are renamed scenarios, and the type Thread is Scenario; a Triage
project has no triage epic and there is no Triage type; the `Epic:` and `Thread:` labels are removed from both
accounts. Also ruled 2026-11-03: issues are classified by issue type, with lax enforcement and no compliance checks;
issues we file ourselves go through `star github issue`; new issues reach their team's Triage project through a
GitHub Actions workflow in each repository, and a triage decision there declines the work or moves the issue to the
team's Backlog, Schedule or Scenario project; the team that owns a project is accountable for it, recorded by
GitHub's link between the project and its team. The six types were made in GitHub, Epic, Feature, Task, Bug,
Schedule and Thread in NobleFactor, and their lowercase labels in David-Noble-at-work; Thread and `thread` were renamed
Scenario and `scenario` on 2026-11-03. Question 2, how long a level lives, ruled 2026-11-03: a feature closes only
after an agent's compliance audit and an agent's code review, with the team lead's sign-off. Also ruled 2026-11-03:
Area, with the two values product and engineering, tells engineering work from product work on issues of every type;
devlore-cli's seven finer Area labels were deleted, and the hierarchy carries their distinctions; a blank Area is an
error, caught at filing, at triage and by a scheduled sweep. The old scheme's parent markers, body tables and
NobleFactor's kind labels retired on 2026-11-03, and the retirement is done in GitHub: 725 issue bodies lost their
markers and schedule footers, 47 issues got the sub-issue parent their marker named, and 672 issues got the issue type
their kind label named before the labels left NobleFactor's 12 repositories. David-Noble-at-work keeps its type
labels. Ruled 2026-11-03: an account's file templates, which are its issue forms, its Triage workflow template and its
pull request template, are stored in its `.github` repository, and every document that talks about one of them refers to
it there (§ One model per account in section 6). Read from GitHub the same day, NobleFactor/.github and
David-Noble-at-work/.github each hold six issue forms, one for each type, and the Triage workflow template. Revised on
the evening of 2026-11-03: GitHub's documentation describes workflow templates kept in an organization's `.github`
repository and says nothing about a user account's; whether GitHub offers David-Noble-at-work/.github's template to
personal has not been checked, and David-Noble-at-work/personal#315 copies personal's `triage.yml` from it either way
(§ Triage in section 4).

## Completion

- [x] The plan's questions 1 to 4 ruled: Type's name and home, how long a level lives, the engineering epic, triage.
  -- 2026-11-03
- [ ] [issue-standards.md](../../issue-standards.md) states the hierarchy.
- [ ] Every open issue outside a Triage project has a Type and, if it is not an epic, a parent one level up in its own
  account. A new issue may wait in its team's Triage project with neither.
- Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and
  Scenario are its two peers there.
