---
title: "NobleFactor/.github's Triage workflow template stops at the end of an issue's body, and names no account"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/447
status: active
created: 2026-11-10
updated: 2026-11-10
---

# Plan: NobleFactor/.github's Triage workflow template stops at the end of an issue's body, and names no account

NobleFactor/.github's Triage workflow template, `workflow-templates/triage.yml`, has three faults. Its Area reader
never finishes on an issue whose Area heading is followed only by blank lines, and nothing stops the run for six hours.
And it names NobleFactor twice, so a copy in any other organization signs in to NobleFactor and sets NobleFactor's
Area field. After this work the reader stops at the end of the body, a run stops after 5 minutes, and the template
names its account nowhere, so that `star github model apply` can give it to any organization (#437).

One pull request to NobleFactor/.github, from `fix/447-area-reader`, resolving #447. It merges before #437's proof on
GitHub, whose `apply` on NobleFactor lands the workflow in NobleFactor's five participating repositories (#448).

## Rulings

- 2026-11-04, in #303's closing: the fix lands before any NobleFactor repository runs the workflow (#448 waits on it).
- 2026-11-10, the owner, in #437: the template names its account nowhere, and #447's pull request makes both names the
  repository's owner, before #437's proof on GitHub.

## Current State

Read on 2026-11-10 from NobleFactor/.github's `main`:

| Where in `workflow-templates/triage.yml` | What |
| --- | --- |
| The job | No `timeout-minutes`: GitHub cancels a run only at its default, 360 minutes |
| The token step | `owner: NobleFactor`: the App's token is for NobleFactor's installation, whatever repository runs it |
| The Area step's reader | `awk '/^### Area[[:space:]]*$/ { getline; while ($0 ~ /^[[:space:]]*$/) getline; print; exit }'`: at the end of its input `getline` returns 0 and leaves `$0` as it was, so a blank last line loops forever; carriage returns are kept |
| The Area step's query | `organization(login: "NobleFactor")`: the Area field is looked up in NobleFactor, whatever repository runs it |

David-Noble-at-work/.github's template has had the fixed reader since 2026-11-04 (commit 1c56311), and
David-Noble-at-work/personal's workflow has `timeout-minutes: 5`. No NobleFactor repository runs the template yet;
NobleFactor/.github has no `.github/workflows/triage.yml` of its own.

## Requirements

### Requirement 1: the reader stops at the end of the body

The reader is David-Noble-at-work/.github's, which strips carriage returns and stops when `getline` finds no more input:

```bash
area=$(printf '%s\n' "$BODY" | tr -d '\r' | awk '/^### Area[[:space:]]*$/ { while ((getline line) > 0) if (line !~ /^[[:space:]]*$/) { print line; exit }; exit }')
```

### Requirement 2: a run stops after 5 minutes

The job takes `timeout-minutes: 5`, as personal's does.

### Requirement 3: the template names no account

- The token step's `owner:` is `${{ github.repository_owner }}`.
- The Area step's query takes the organization as a variable, `query($login: String!) { organization(login: $login)
  ... }`, given `-f login="$GITHUB_REPOSITORY_OWNER"`, which GitHub sets in every run.

The secrets keep their names, `NOBLEFACTOR_AUTOMATION_APP_ID` and `NOBLEFACTOR_AUTOMATION_APP_PRIVATE_KEY`: they are
NobleFactor's organization secrets, and `apply` names them to any organization that uses the template (#437).

## Test Plan

| # | Case | Expect |
| --- | --- | --- |
| 1 | The reader, on a form's body: the Area heading, a blank line, `Engineering` | Prints `Engineering` |
| 2 | The reader, on the Area heading and a blank line at the end of the body | Prints nothing and exits at once |
| 3 | The reader, on the Area heading as the body's last line | Prints nothing and exits at once |
| 4 | The reader, on case 1's body with carriage returns, as GitHub's web form sends it | Prints `Engineering` |
| 5 | The old reader, on case 2's body | Still running after 3 seconds, as #447 found |
| 6 | The template | Parses as YAML; names NobleFactor nowhere; the job has `timeout-minutes: 5` |
| 7 | NobleFactor/.github's quality gate, on the pull request | Passes |

Cases 1 to 5 run the reader as the workflow runs it, `$BODY` set to each body, each under a 3-second limit. The
template's first run in a NobleFactor repository, a test issue filed from a form, is #448's evidence.

## Implementation Phases

### Phase 1: the plan

- [x] Written, committed on #437's branch, `feature/437-model-diff-apply-restore`, and reviewed with the owner:
      approved 2026-11-10

### Phase 2: the fix

- [ ] The worktree made by hand, as #431's was: `git open-branch` reads the issue from the clone's own repository, and
      #447 belongs to noblefactor-engprod. From the clone `~/Workspace/NobleFactor/.github`, the worktree
      `~/Workspace/NobleFactor/.github.447-area-reader` on `fix/447-area-reader`; its script
      `~/Workspace/NobleFactor/.github.447-area-reader.bash`. #447's row on Schedule: engprod set In progress, its
      Worktree column linking the branch
- [ ] Requirements 1 to 3 in `workflow-templates/triage.yml`; test cases 1 to 6 run and pass

### Phase 3: merge

- [ ] The pull request script written, shown and handed over. It opens the pull request, its description closing
      NobleFactor/noblefactor-engprod#447, waits for the quality gate, merges, and comments on #447 with cases 1 to 6's
      output and the merged pull request. `git close-branch` removes the worktree and the script afterward

### Phase 4: the documents

- [ ] On #437's branch: section 3's status, whose rows say the reader loops and the template names NobleFactor, brought
      to the merged fix; this plan's status `complete`

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/fix/447-area-reader.md`, in noblefactor-engprod | Create | This plan |
| `workflow-templates/triage.yml`, in NobleFactor/.github | Modify | Requirements 1 to 3 |
| `docs/architecture/issue-data-model/3-collections.status.md`, in noblefactor-engprod | Modify | Phase 4 |

## Related Documents

- [#437's plan](../feature/437-model-diff-apply-restore.md), decision 12: the template names its account nowhere
- [#431's plan](../feature/431-dot-github.md), decision 8: a `.github` worktree made by hand
- [Section 4, § Triage](../../architecture/issue-data-model/4-storage-and-reach.md#triage): how the workflow signs in
- #448: the workflow in NobleFactor's five participating repositories, which waits on this
