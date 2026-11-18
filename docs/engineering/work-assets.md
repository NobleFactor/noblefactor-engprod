---
title: "Work assets"
status: draft
created: 2026-10-28
updated: 2026-11-18
---

# Work assets

[Up: Engineering](index.md)

<a id="identity-and-relationships"></a>

## 1. Identity and relationships

| Asset | Purpose and required content |
| --- | --- |
| Design | What we want: how the system works, how its parts fit together, the rules it must meet, and the reasons for significant design choices |
| Plan | How we get there from where we are: the changes, approach, phases, transition decisions, completion checks and results |
| Schedule | What we will deliver, stated as before → after; the issues in order, their dependencies, work locations, progress and approved changes |
| Issue | A defined piece of work: its problem, scope, intended result, parent feature or epic, schedule where applicable, and document links |
| Approval | Who approved what, which proposal or revision they approved, and the limits of that approval |
| Completion review | What was promised, what was delivered, the evidence, remaining work, and the Owner's approval to finish or continue within agreed limits |

Planning produces a set of issues and a schedule that orders them. Each of those issues links to one or more plans and the relevant designs. Each plan names the issues it covers; it may cover several issues. [Work organization](work-organization.md#schedule-commitment) explains how to record and carry out a schedule.

A branch and its worktree identify the issue that started them. A PR names the issues and approved changes it delivers. Verification records say what was tested, where it was tested and what happened.

Write every document in plain language. Use the simplest words that explain the subject accurately. Define technical terms when they are needed. Every word should help the reader understand.

<a id="workspace-locations"></a>

## 2. Workspace locations

Use one organization subtree, `~/Workspace/<org>/`. It contains canonical clone entries, issue-named worktrees and their sibling PR scripts. A layer clone lives at `~/.local/share/devlore/writ/repos/<clone>`; its workspace entry is a symlink. Keep one canonical clone per layer on the chosen PR target branch, usually the default branch. Development branches are checked out in worktrees, not canonical clones.

A worktree is `<clone>.<issue>-<name>`. Its PR script is `<worktree>.bash` on macOS/Linux or `<worktree>.ps1` on Windows. Read an existing script before overwriting it; ensure it names this worktree. Authorization for one script never extends to another worker's script.

Branch types are `doc`, `feature`, `fix`, `hotfix`, `refactor` and `release`. The branch identifies its issue and is created from the chosen PR target through the supported open-branch procedure. Its type follows the issue's type, or its type label in a user account, under the [maintained open-branch manual](../../Home/common/.local/share/man/man1/git-open-branch.1). [Work organization](work-organization.md#work-and-identity) defines the issue hierarchy; a branch type does not add another level to it.

<a id="plans-and-designs"></a>

## 3. Plans and designs

<a id="designs"></a>

### 3.1. Designs

A design describes the system we want. Explain what people can do with it, how its parts fit together and the rules it must meet. Describe the intended system as a whole.

Explain significant design choices and why they meet the system's goals. Include relevant alternatives and tradeoffs when they help the reader understand a choice.

Put transition decisions, migration steps and change history in plans. When the intended system changes, revise the design to describe it clearly and update the plan with the work needed to reach it.

Design files belong under `docs/architecture/` in the repository that owns the design. Leave files in other approved locations until a move is approved.

<a id="plans"></a>

### 3.2. Plans

A plan starts with what exists and explains the changes needed to reach the design. It records the approach to the work, transition decisions, migration steps, phases, completion checks and results. Link to the design instead of repeating its description of the finished system.

Record each Owner approval in the plan with its date, the proposal or revision approved, and the work it authorizes. Keep a link or reference to the original exchange. Quote the Owner's exact words when the wording matters. Approval covers only the work it names.

**Case:** On 2026-10-22, permission to begin a task or open a follow-up was treated as permission for additional commits. Approval records must name their scope ([recorded case, rule 17](review/sources/agent-rules.txt)).

<a id="document-formats-and-links"></a>

### 3.3. Document formats and links

Plans live at `docs/plans/<type>/<issue>-<name>.md`, matching the branch that started the work. A separate plan for an additional issue names that issue. A shared plan carries a stable `## Issue NNN` heading for each issue; use the number alone, with no title or `#` prefix. Keep incoming links working when changing headings in an active plan. Leave completed historical plans unchanged unless a specific migration is approved.

Every issue ends with `## Plan and design documents`, a two-column Kind/Document table. Include a plan row when filing the issue; use “Not yet opened” while no plan is available. Link every plan needed for the work and each applicable design. Explain in the issue and plan whether the work changes a design, including when no separate design is needed.

For an open issue, document links point to committed files on the default branch and stable issue anchors. An issue closed by a merged PR links files at that PR's merge commit. If a file is absent from that commit, belongs to another repository, or the issue closed without such a PR, use the default-branch link and keep the linking command's explanation. Before merge, also provide the committed revision the Owner will review.

Plans are the source for an issue's document table. A plan names its issues through its `issue:` field and stable `## Issue NNN` headings. Its `documents:` metadata lists related documents, each with `kind` and either a repository-relative `path` or a `url`, plus optional display `text`.

The first worktree script runs `star github plan link` after pushing the plan. Check its action, reason and dropped-row records. Report any refused issue or dropped row to the Owner, even when the command exits 0. Until a plan covers an issue, keep the document table it was filed with.

<a id="lifecycle-and-freshness"></a>

## 4. Lifecycle and freshness

The [documentation standard](../standards/documentation.md#document-families-and-metadata) defines document status values. [Completion and progression](process.md#completion-and-progression) explains when plans finish and issues close, and how to record results after merge.

Update affected documents in the commit that changes the facts they describe: phase boxes, design/status companions, deleted APIs and paths, and user-facing material. Mark retained history clearly. The [templates](../templates/index.md) show what to record; checked boxes alone do not establish a result.

**Case:** The commit moving six layer files left phase boxes unchanged until a later commit. Update records with the change, not in a cleanup batch ([recorded case, rule 12](review/sources/agent-rules.txt)).

<a id="clone-retirement"></a>

## 5. Clone retirement

Before retiring a clone, save recoverable copies of unique work, record any transferred worktrees, check their registrations and links, and report what was saved and where. Follow the [clone-retirement procedure](procedures/clone-retirement.md) for the ordered operations.

**Case:** A duplicate clone contained sixteen refs absent from origin, including a stash. Deleting the directory first would have lost that work ([recorded case, rule 8](review/sources/agent-rules.txt)).

<a id="layer-script-locations"></a>

## 6. Layer script locations

Code that contributes to or depends on a repository belongs in its named `Home/<repository>[.<selector>]` project. Self-contained code deployed everywhere belongs in `Home/common[.<selector>]`. The `git-*` commands live beside Declare-BashScript in engprod's common project. Repository-specific projects keep their scripts and source the base helper in place. Follow [Bash standards](../standards/coding/bash.md) when declaring dependencies.
