---
title: "2. Attributes — Status"
---

# 2. Attributes — Status

**Document:** [2-attributes.md](2-attributes.md)
**Feature:** [NobleFactor/noblefactor-engprod#331](https://github.com/NobleFactor/noblefactor-engprod/issues/331)
**Work:** [NobleFactor/noblefactor-engprod#303](https://github.com/NobleFactor/noblefactor-engprod/issues/303)
**State:** Ruled in part, 2026-11-02 to 2026-11-03; questions 11 and 12 open. Ruled 2026-11-02: each account has its
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
as an organization, apart from what GitHub offers organizations only, so a label stands in for each single-select
issue field, `priority:urgent` to `priority:low` among them. Done in GitHub the same day: the Severity field, made and
read back by the design worktree's script, which also gave devlore-cli's issues the Severity and Priority values their
labels named and deleted those labels; the priority, severity and effort labels, made in personal and
David-Noble-at-work/.github; and the Priority project field, deleted from Backlog: David-Noble-at-work and the
account's Backlog copy. The document was revised to these on the evening of 2026-11-03 (§ The attributes, § Labels
carry no values).

## Completion

- [ ] The plan's questions 11 and 12 ruled: severity on a task, how a scenario influences priority.
- [x] The plan's question 14 ruled: GitHub's other issue fields -- 2026-11-03: NobleFactor uses Priority, Effort,
  Target date, Resolution, Area and, since that evening, Severity, and not Start date, and the model holds an
  account's issue fields.
- [x] Where severity lives in NobleFactor ruled -- 2026-11-03: in its Severity issue field, Critical, High, Medium
  and Low, made by the design worktree's script and read back.
- [x] Area's values and how a blank Area is caught -- 2026-11-03: product and engineering, caught at filing, at
  triage and by a scheduled sweep.
- [ ] [issue-standards.md](../../issue-standards.md) states the attributes.

Open, to be ruled on #303: which issue carries the audit's attribute rules and the rollout of the attribute labels and
fields, now that #303 keeps only the design.
