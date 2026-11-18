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

**Revised 2026-11-17 (#589, #595):** `new` became `open`, with `create` its synonym, and `reopen` joined the verbs, as the owner synchronized the verbs across `star github issue`, `schedule` and `scenario`. Moving an issue is designed in section 10, and this section keeps what a move records on a schedule. The design text was rewritten that day to say what the commands do, in plain language, at the owner's direction; its rulings and history are kept here.

## History

- **The owner's example of 2026-11-04,** `star github schedule --group-by Schedule --account NobleFactor --team engprod --where '{ Schedule: { _eq: 346 } }' --output csv`, became `get` (question 2, 2026-11-11): a group takes no action of its own; `--where` would be a third way to select, beside `--filter` and `--jq`; reshaping is `--jq`'s work; and a schedule's key names its account.
- **Rule 2 of agent-rules.md,** what lists the open ruling issues under NobleFactor/devlore-cli#463 once the `Epic:` labels were gone, was answered by the report as built: run on 2026-11-11, it returned the 17 open issues GitHub lists under #463, in 26 seconds.
- **Closed steps are renumbered (question 5, 2026-11-11).** Section 3 said a closed step keeps its number, but on issue tracking, iteration 1, steps 29 (#440) and 35 (#447) were closed between open steps, and both moved down four when #482 to #485 went in after step 22 that day.
- **The evidence comment (question 6, 2026-11-12)** was built from what GitHub held for issue tracking, iteration 1 (#346): of its 28 closed steps that day, 19 fell under 13 pull requests and 9 had none. Five were finished by merged work but closed by hand, #303, #358, #359, #360 and #446, so they show no pull request; #508 asked the PR script template for a `Closes #N` line.
- **The option stays (2026-11-11):** Schedule: engprod had 4 options when read that day.
- **Start-Claude (question 7, 2026-11-12):** its `--schedule new` filed `Schedule: <title>` with the retired `chore` label and a lane table, and made no option or row. It was retired when `new` was built, on 2026-11-16 (#509).
- **The verbs as built:** `add` (#438) on 2026-11-12, which became `star github issue move` (#511) on 2026-11-15, when `add`, `move` and `remove` were seen to be one act done three ways; `get` and `list` (#510) on 2026-11-15; `new` (#509) and `close` (#512) on 2026-11-16; all four widened to scenarios and built as steps 48 to 51 of #346 in #507's pull request. `plan link` (#557) on 2026-11-15.

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
- [ ] `open` and `create`, renamed from `new`, and `reopen`, built and proved in both sandboxes (#595)
