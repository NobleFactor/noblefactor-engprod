---
title: "10. The issue commands — Status"
---

# 10. The issue commands — Status

**Document:** [10-the-issue-commands.md](10-the-issue-commands.md)

**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)

**Work:** [NobleFactor/noblefactor-engprod#589](https://github.com/NobleFactor/noblefactor-engprod/issues/589), the design; `open` is [#338](https://github.com/NobleFactor/noblefactor-engprod/issues/338), `close` [#590](https://github.com/NobleFactor/noblefactor-engprod/issues/590) and `reopen` [#587](https://github.com/NobleFactor/noblefactor-engprod/issues/587)

**State:** Designed 2026-11-17 on `doc/589-issue-verbs` and approved by the owner the same day; rewritten that day to say what the commands do, in plain language, at the owner's direction, its rulings kept here.

## Rulings

Each of 2026-11-17, by the owner:

- The verbs are `open`, `move`, `close` and `reopen`, open and closed being GitHub's own words for an issue's state, and `create` is `open`'s synonym, since people who use `gh` reach for it. Until then `open` was planned as `file`.
- As proposed in #589's plan: `close` doesn't close a parent with its last open child; Priority is Medium when `open` isn't given one; retyping an issue is a verb of its own, later; and the skill that opens issues for an agent is an issue of its own.
- The verbs are synchronized across the board (#595): `star github schedule new` and `scenario new` become `open`, with `create`; `scenario retire` becomes `close`; both groups gain `reopen`; and the `issue` verbs refuse Schedule and Scenario issues, naming the group's verb.
- `close` writes its comment, its Resolution, closes the issue, then changes its rows, the order approved; a build that changed the rows first was undone. An issue already closed is left as it is.
- A reopened task or bug with no row goes to Triage. An issue with no type and no row does too, since section 1 has an untriaged issue wait there.
- `open` opens its issue in the repository of the clone it runs in, `--directory` naming another, as git's `-C` does; `-C` waits on NobleFactor/devlore-cli#1236. It takes no `--project` or `--status`, since the Triage workflow gives every issue opened a Triage row and a second row would break the rule of one project at a time. No one is assigned unless `--assignee` names someone.
- `move` puts an issue where it needs to be, from wherever it is, as its type allows (#597): the refusals of `--triage` and `--backlog` off no schedule, of `--scenario` from the Backlog, a schedule or another scenario, and of `--backlog` off a scenario were ruled broken.
- An epic or a feature goes from Triage to the Backlog once classified and stays there until it closes, its state its children's (#597), in place of the ruling of 2026-11-04 that it leaves Triage for no project. The owner first proposed that it leave the Backlog when its first task or bug went onto a schedule or a scenario, asked how other trackers do it, and chose the simplest thing on that evidence (§ Epics and features).

## Completion

- [x] The verbs and the synonym ruled, 2026-11-17
- [x] The four questions of #589's plan ruled, as proposed, 2026-11-17
- [x] The design approved by the owner, 2026-11-17 (#589)
- [x] The collection groups' verbs synchronized, ruled 2026-11-17 (#595)
- [ ] `close` built and proved in NobleFactor-sandbox and David-Noble-at-work-sandbox (#590)
- [ ] `reopen` built and proved in both (#587)
- [ ] `open` and `create` built and proved in both (#338)
- [ ] The collection groups' `open`, `close` and `reopen` built and proved in both (#595)
- [ ] `move` fixed, the sweep's rule narrowed and the Backlog's view of epics and features made, and proved in both (#597)
