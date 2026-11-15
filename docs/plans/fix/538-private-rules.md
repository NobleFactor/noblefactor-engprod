---
title: "star github model apply lands in a private repository of a free user account"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/538
status: complete
created: 2026-11-13
updated: 2026-11-13
---

# Plan: star github model apply lands in a private repository of a free user account

Step 37 of issue tracking, iteration 1 (#346), put after #536 by `star github schedule add` on the owner's word of
2026-11-13: fix it at once. Found in #448: `apply` on David-Noble-at-work opened David-Noble-at-work/personal#325 and
stopped with nothing but "shell: exit status 1". `_required`, in the extension's `commands/pull.star`, reads the base
branch's rules, and GitHub answers a private repository of a free user account with a 403: "Upgrade to GitHub Pro or
make this repository public to enable this feature." One pull request from `fix/538-private-rules`.

## Requirements

1. `_required` reads a 403 on the rules of a private repository as no check required: GitHub's free plan gives such a
   repository neither rulesets nor branch protection, so nothing can be required of it.
2. Any other failure to read the rules stops the command, and its message says what GitHub said, which shell.exec's own
   error does not.
3. Section 6 of the issue data model says so, and its status page records the fix.

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | `tests/Test-StarGitHub` 11.7: a backup to a private repository whose rules GitHub refuses to read | It merges without waiting for a run, its comment saying no check is required |
| 2 | `tests/Test-StarGitHub` 11.8: the same 403 on a public repository | The backup stops, unmerged, its error saying what GitHub said |
| 3 | Cases 1 and 2 against the code before the fix | Both fail, and no other case does |
| 4 | `tests/Test-StarGitHub` and `make check` | Pass |
| 5 | #448's phase 3, run again after the merge | `apply` merges David-Noble-at-work/personal#325, its comment saying no check is required on `main` |

## Implementation Phases

- [x] `_required` in `pull.star`; the stand-in's private and refused modes and cases 11.7 and 11.8; section 6 and its
      status page. 187 cases pass; against the old code the two new cases fail and no other does
- [x] The pull request script: merged, the deployed extension checked, step 37 In progress with the pull request linked
- [x] #538 closed with its evidence once #448's phase 3, run again, has `apply` merge David-Noble-at-work/personal#325;
      step 37 Closed

## Files to Create/Modify

| File | Action |
| --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/pull.star` | Modify |
| `tests/Test-StarGitHub` | Modify |
| `docs/architecture/issue-data-model/6-the-asset-and-its-sync.md` and its status page | Modify |
| `docs/plans/fix/538-private-rules.md` | Create |
