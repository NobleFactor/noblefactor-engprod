---
title: "1. Session model — Status"
---

# 1. Session model — Status

**Document:** [1-session-model.md](1-session-model.md)
**Feature:** [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151)
**Plan:** [259-start-claude-documents-claude.md][plan-259]
**State:** Built in phase 33, 07413ae2, 2026-10-15, tested on Danoble-MBP-A before its commit, and deployed there and
on danoble-ud24-1; accepted on the deployed scripts the same day, in phase 34. On Windows, Start-Claude.ps1 on psmux,
David-Noble-at-work/personal#273, 2026-10-19. The schedule's variables read and the title held on a wake,
NobleFactor/noblefactor-ops#260: built in be16108, tested on all three hosts 2026-10-22; its acceptance follows its
deploy.

## Completion

- [x] Every conversation in claude's background, the store keeping its background session's short id.
- [x] A tmux session of its own for each start, named for its schedule's repository and number and its own id, as
  `devlore-cli#916 $34` since 2026-10-16 (personal#273's plan), with `destroy-unattached` on.
- [x] A conversation's id met where claude lists it; one in the foreground refused with 75.
- [x] `--detach` starts or wakes the background session, and opens no tmux session.
- [x] claude's trust refusal passed through with 69; the schedule's variables through `--settings`.
- [x] Sync-ClaudeSession, the startup hook, removed.
- [x] Remote Control on a background session, seen in the Claude app, 2026-10-15.
- [x] Acceptance on the deployed scripts, phase 34: its live runs and CI's three gates passed 2026-10-15.
- [x] On Windows, Start-Claude.ps1 on psmux, with the four differences psmux needs (personal#273's plan, requirement
  4): built on personal#273's branch 2026-10-17 to 19, and tested on danoble-wd11-3, test plan rows 1 to 3 and 10 to
  12; the rest of its tests are its test scripts', under `tests/`.
- [x] The title holds everywhere: a `--detach` wake of a stopped session passes the launch's name, in both scripts,
  and a case in both test scripts proves it (NobleFactor/noblefactor-ops#260, requirement 3).
- [x] The schedule's variables read: `star-gh-assignment` answers with `NFEP_AGENT_SCHEDULE`, and with the session's
  name only when it is unset, and gives the link from `NFEP_AGENT_SCHEDULE_URL` or the key (#260, requirements 1 and
  2).
- [ ] Acceptance on the deployed scripts, #260's requirement 4, after its merge.

[plan-259]: https://github.com/David-Noble-at-work/personal/blob/main/docs/plans/chore/259-start-claude-documents-claude.md
