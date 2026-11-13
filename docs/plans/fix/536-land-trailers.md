---
title: "star github model apply and backup land their pull requests with the AI disclosure and the trailers"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/536
status: active
created: 2026-11-12
updated: 2026-11-12
---

# Plan: star github model apply and backup land their pull requests with the AI disclosure and the trailers

Step 36 of issue tracking, iteration 1 (#346), put after #448 by `star github schedule add` on the owner's word of
2026-11-12: fix it at once. Found in #448: NobleFactor/.github#12, a backup, landed as `0df5469` with no trailer at all.
`land`, in the extension's `commands/pull.star`, merged with no `--body`, so GitHub wrote its own squash message; and
neither caller's description said AI assisted or carried `Assisted-by:`. One pull request from `fix/536-land-trailers`.

## Requirements

1. Every pull request `backup` and `apply` open says AI assisted and ends with `Signed-off-by:` and
   `Assisted-by: Claude Code` ([pr-script-template.md, rule 2](../../guides/pr-script-template.md#rules)): one helper
   in `pull.star`, `disclose`, ends a description so, and both callers build theirs with it.
2. `land` merges with the description as the squash commit's message, so the commit that lands carries both trailers.
3. Section 6 of the issue data model says so, and its status page records the fix.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `tests/Test-StarGitHub` 11.1: a backup's pull request | Its description ends with the disclosure and both trailers, and `pr merge` is given it as the body |
| 2 | `tests/Test-StarGitHub` 29: the four pull requests `apply` opens | The same, for each |
| 3 | Cases 1 and 2 against the code before the fix | Both fail, and no other case does |
| 4 | `tests/Test-StarGitHub` and `make check` | Pass |
| 5 | The next pull request `apply` or `backup` lands after the merge: #448's `apply` on David-Noble-at-work, for personal | Its commit carries both trailers |

## Implementation Phases

- [x] `disclose` and the merge's body in `pull.star`; `participation.star` and `github-model-backup.star` on
      `disclose`; the two cases; section 6 and its status page. 185 cases pass; against the old code the two new cases
      fail and no other does
- [x] The pull request script: merged, the deployed extension checked, step 36 In progress with the pull request linked
- [ ] #536 closed with its evidence once #448's `apply` on David-Noble-at-work lands personal's workflow, its commit
      carrying both trailers; step 36 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/pull.star` | Modify |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/participation.star` | Modify |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/github-model-backup.star` | Modify |
| `tests/Test-StarGitHub` | Modify |
| `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md` and its status page | Modify |
| `docs/plans/fix/536-land-trailers.md` | Create |
