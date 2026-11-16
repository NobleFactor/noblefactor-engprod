---
title: "9. The scenario commands — Status"
---

# 9. The scenario commands — Status

**Document:** [9-the-scenario-commands.md](9-the-scenario-commands.md)
**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)
**Work:** [NobleFactor/noblefactor-engprod#507](https://github.com/NobleFactor/noblefactor-engprod/issues/507), the
design; it follows section 8, the schedule commands, designed in
[#439](https://github.com/NobleFactor/noblefactor-engprod/issues/439)
**State:** Drafted 2026-11-15 on `doc/507-scenario-commands`, from the rulings of 2026-10-21 to 2026-11-14 that
sections 3 and 8 and the issue standard record, and from what GitHub held that day: both accounts' Scenario projects,
their fields, views and options, the eight Scenario issues, and the 29 issues that are rows of a scenario. Its eight
questions are proposed, for the owner to rule one at a time. Ruled 2026-11-15, question 1: the scenario commands
are a group of their own, `star github scenario`. Ruled the same day: Beat keeps its name, and Beat N is step N of
the walk. Ruled the same day, question 2, as revised: the group's own verbs are `list`, `get`, `new`
and `retire`, and an issue moves onto, within and off a scenario by `star github issue move`, as section 8 now has it
for schedules. Ruled the same day, question 3: `new`'s syntax and steps, each
write read back, and `--walk` a numbered list. Ruled the same day, questions 4 to 8, as proposed:
what a move onto and off a scenario writes, Beat 0 before the walk's first step and a Beat past its last refused;
`retire`, closing as completed with no Resolution; and the findings put right once. Ruled the same day, question 8,
as revised: #509 to #512, widened to scenarios, are steps 48 to 51 of #346, built in #507's pull request, and
nothing goes to Triage. The owner approved the design on 2026-11-15.

## Completion

- [x] Questions 1 to 8 ruled, 2026-11-15
- [x] The design approved by the owner, 2026-11-15 (#507)
- [x] The findings of question 7 put right, each read back, on 2026-11-16 by #507's merge script: 23 closed rows, of 21
  issues, taken off five scenarios, a comment on each Scenario issue naming them; #806, #891, #892, #893 and #599 titled
  `Scenario: <its option's name>`; and #599's beats line added
- [x] `get` and `list` built on 2026-11-15, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox
  (run 20261116T221107Z) (#510)
- [x] `new` built on 2026-11-16, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run
  20261116T221107Z) (#509)
- [x] `star github issue move`'s scenario cases built, with the body line when an item moves onto a schedule, on
  2026-11-15, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run 20261116T221107Z) (#511)
- [x] `retire` built on 2026-11-16, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run
  20261116T221107Z) (#512)
