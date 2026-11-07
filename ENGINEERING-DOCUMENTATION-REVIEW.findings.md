---
title: "Engineering documentation review: findings"
status: draft
created: 2026-10-29
updated: 2026-10-29
---

# Engineering documentation review: findings

The Reviewer's findings on the draft set on `doc/420-consolidate-engineering`, kept current across passes. Each finding carries a state: **open**, **addressed**, **withdrawn** or **new**, with the pass that set it. Findings are the Reviewer's; decisions are the Owner's. The pass log is at the end.

## 1. The set as a whole

- **F01, addressed, pass 2.** One authoritative home per requirement. The follow-up PR policy now lives in process §8 and is linked from work assets §4 and the PR procedure §5; the PR/worktree boundary is process §7 and linked from agent operation §8; the templates' role sections are one line pointing at the definition, and the Owner has ruled those lines records, not definitions.
- **F02, addressed, pass 2.** Cases restored. Each main rule now carries a dated case: process §§4, 6, 7, 8, 9; work organization §2; work assets §§1, 4, 5; agent operation §§6, 7; the PR procedure §§2, 3; the documentation standard §1.3.
- **F16, new, pass 2.** The living error record has no home after cutover. Every case cites `review/sources/agent-rules.txt`, a frozen snapshot, and agent operation §2 says the judgment-error record's "location remains to be normalized". Today a breach adds a rule to `agent-rules.md` the day it is broken and is logged on #317. The draft says where old cases are kept and not where the next one goes. Decide the living home before cutover: #317 alone, or a cases register in `docs/engineering/review/`, and make the main documents cite it rather than the snapshot.
- **F17, new, pass 2.** The merge gate of decision 47 would have refused yesterday's PR. #418 merged with `reviewDecision: REVIEW_REQUIRED` and zero reviews, by the Owner, through `--admin`: the active ruleset on `develop` requires a review this single-maintainer repository cannot supply, so every PR is BLOCKED and every merge is an admin bypass. The PR procedure §3 now makes that bypass an exception needing separate explicit approval per PR, which turns the exception into the routine. Name the dependency: the ruleset's review requirement changes, or the Owner's own approval counts, before the template is reconciled. Verified 2026-10-29 with `gh pr view 418` and the repository's rulesets.
- **F18, new, pass 2.** One source line per paragraph, documentation standard §2.1, has no stated scope over the existing set. Every active document in the repository is hard-wrapped at 120, the design documents included. Say whether the rule applies to documents touched from now on or to all tracked Markdown, and that an unwrap of an existing document is its own commit, since it is a whole-file diff that hides any real change made with it.

## 2. Engineering process

- **F03, addressed, pass 2.** Observer is an informed stakeholder; monitoring Participants is a Reviewer duty (decision 44).
- **F04, addressed, pass 2.** Git authority is stated in agent operation §7, exact command granted once or a bounded grant, with the 2026-10-22 case, and process §4 links to it.
- **F05, addressed, pass 2.** The review step now says what happens: the committed plan's questions resolved one at a time, the dated decisions recorded, and the explicit "start" awaited.
- **F06, kept.** The departures paragraph, the milestones distinction, "Code is not finished until it reads clearly", and "Cleanup does not itself demonstrate deployment" stand as written.

## 3. Work organization

- **F07, addressed, pass 2.** The two text defects are gone.
- **F08, addressed, pass 2.** The chore tier is retired and the `chore/` branch prefix kept, said in §1 and in work assets §2, with the migration of existing chore issues named.
- **F09, addressed, pass 2.** The schedule header's compatibility is in the conflict register, and the escaped-pipe defect is #319, which I confirmed is that defect.
- **F10, addressed, pass 2.** §6 links the session model.

## 4. Work assets

- **F11, addressed, pass 2.** Approval is a dated Owner decision in the plan, quoted when the wording is material, with the exchange referenced.
- **F12, withdrawn, pass 2.** The number-only `## Issue NNN` heading is an existing rule; the draft now says so and names the anchor-preserving migration for active plans.
- **F13, addressed, pass 2.** Clone retirement is a procedure; §5 keeps the requirement and the case.
- **F14, addressed, pass 2.** The lifecycle paragraph is two sentences and two links.
- **F15, addressed, pass 2.** Personal repositories follow the shared rules by default, with Owner-directed exceptions (index §2, C14, decision 46).
- **F19, new, pass 2.** The documentation standard §1.1 lists `Plan` and `Process` among catalog types, while plans under `docs/plans/` are working documents with no `type`. Say what a catalog `Plan` is, or drop the two names from the list, so a plan author does not add a `type` and change family.

## 5. The rest

Agent operation reads as the arrangement actually run. Release and recovery is right to refuse the old reset path. The standards defer honestly. Section numbering with explicit anchors is heavy on the page but does what decision 52 asks, and the plan template's unnumbered `## Issue NNN` between sections 2 and 3 is the rule, not a defect.

## 6. Before adoption

1. Settle F16, the living case record, and F17, the merge gate's dependency on the ruleset; both are policy that the current repository cannot follow as written.
2. Scope F18 and fix F19; both are editorial.
3. Read the three main documents once more as an agent at session start would, in order, for length. They grew by a third with the cases and anchors; the cases are worth it, the anchors are the cost of decision 52.

## Pass log

| Pass | Read | Moved |
| --- | --- | --- |
| 1 | 2026-10-29 09:30, the 42-file package as imported | F01 to F15 raised |
| 2 | 2026-10-29 10:00, the 27 files changed since pass 1, the new conflict register, clone-retirement procedure and issue 420 plan, and the rest re-read | F01 to F11, F13 to F15 addressed; F12 withdrawn on the Owner's qualification; F16 to F19 raised |
