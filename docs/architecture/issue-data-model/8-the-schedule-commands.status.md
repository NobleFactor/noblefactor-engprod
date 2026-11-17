---
title: "8. The schedule commands — Status"
---

# 8. The schedule commands — Status

**Document:** [8-the-schedule-commands.md](8-the-schedule-commands.md)
**Feature:** [NobleFactor/noblefactor-engprod#332](https://github.com/NobleFactor/noblefactor-engprod/issues/332)
**Work:** [NobleFactor/noblefactor-engprod#439](https://github.com/NobleFactor/noblefactor-engprod/issues/439), the
design; `add` is [#438](https://github.com/NobleFactor/noblefactor-engprod/issues/438), and the scenario commands are
[#507](https://github.com/NobleFactor/noblefactor-engprod/issues/507)
**State:** Drafted 2026-11-11 on `doc/439-schedule-commands`, from the rulings of 2026-11-02 to 2026-11-11 that
sections 3 and 7 record. Ruled 2026-11-11, question 1: the eight verbs, with the report as built answering rule 2's
question and a new schedule titled `Schedule: <name>`. Ruled the same day, question 2: the owner's example of
2026-11-04 becomes `get`, and `--filter`, `--jq` and `--output` do the selecting, reshaping and rendering on every
command. Ruled the same day, question 3: `new`'s syntax and steps, each write read back, since GitHub promises no
stability for the features the model is built on. Ruled the same day, question 4: `add`, `move` and `remove` each
write an amendment line in the Schedule issue, require `--reason`, and name who ran them. Ruled the same day,
question 5: closed steps move with the open ones, and section 3 is brought to it. Ruled the same day, of question 6:
a closed schedule's option stays, since it records which schedule each closed step belonged to. Ruled 2026-11-12,
the rest of question 6: `close` writes an evidence comment of what merged and when, each pull request with the
steps it closed, rendered from a template. Ruled the same day, question 7: Start-Claude and Start-Claude.ps1 drop
`--schedule new` in the pull request that builds `new`. Ruled the same day, question 8: the verbs not yet built are
#509 to #512, in Backlog: engprod with Priority Medium. The owner approved the design on 2026-11-12. Read
from GitHub on 2026-11-11: the Schedule options of Schedule: engprod, the 15 Schedule issues, both accounts' Schedule
forms, and the 17 open issues under NobleFactor/devlore-cli#463, which the report as built lists. Ruled 2026-11-15
(#557): `plan link`, beside the schedule verbs, which writes each issue's `Plan and design documents` section from
the plans. Revised 2026-11-15 (#507): `add`, `move` and `remove` became one command, `star github issue move`,
its issue the one positional argument and its destination a flag, `--backlog` kept and several issues at once; and
#509 to #512, widened to scenarios, became steps 48 to 51 of #346, built in #507's pull request.

## Completion

- [x] Questions 1 to 8 ruled, 2026-11-11 and 2026-11-12
- [x] The design approved by the owner, 2026-11-12 (#439)
- [x] `add` built, with `--after`, on 2026-11-12, and proved that day in NobleFactor-sandbox; a user account's half
  on 2026-11-13, in David-Noble-at-work-sandbox (#438)
- [x] `new` built, and Start-Claude's `--schedule new` retired with it, on 2026-11-16, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run 20261116T221107Z) (#509)
- [x] `get` and `list` built on 2026-11-15, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run 20261116T221107Z) (#510)
- [x] `star github issue move` built from `schedule add`, with moving within a schedule and off one, on 2026-11-15, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run 20261116T221107Z) (#511)
- [x] `close` built on 2026-11-16, and proved that day in NobleFactor-sandbox and David-Noble-at-work-sandbox (run 20261116T221107Z) (#512)
- [x] `plan link` built, with `--all` and `--check`, on 2026-11-15 (#557); every issue brought to its plans by it
  on 2026-11-15, #557's evidence
