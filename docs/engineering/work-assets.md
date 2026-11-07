---
title: "Work assets"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Work assets

[Up: Engineering](index.md)

<a id="identity-and-relationships"></a>

## 1. Identity and relationships

Each issue links to its plan and applicable designs. Each plan identifies every issue it serves. A worktree and branch identify their originating issue; a PR identifies the issues and approved changes it delivers. Deployment and verification evidence identify the artifact and environment actually evaluated.

| Asset             | Required content                                                                                                         |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Schedule          | Before/after deliverable, ordered issues, dependencies, current work locations and state, approved amendments            |
| Issue             | Problem, scope, intended outcome, feature/epic relationship, schedule association where applicable, document table       |
| Plan              | Intended implementation, design impact, approved approach, phases, acceptance criteria, required milestones and evidence |
| Design            | Resulting behavior/structure/interfaces, alternatives, tradeoffs and enduring decisions                                  |
| Approval          | Decision, approver, scope and the revision or proposal approved                                                          |
| Completion review | Expected versus observed results, evidence, remaining obligations, owner approval or bounded progression authority       |

Record approval as a dated Owner decision in the plan, identifying the proposal or revision and the scope approved. State the ruling clearly, with its meaning preserved, and retain a link or reference to the original exchange. Quote exact wording when it is material. An approval record is not an implemented authorization mechanism; do not infer a grant from unrelated discussion.

**Case:** On 2026-10-22, permission to begin a task or open a follow-up was treated as permission for additional commits. Approval records must name their scope ([recorded case, rule 17](review/sources/agent-rules.txt)).

<a id="workspace-locations"></a>

## 2. Workspace locations

Use one organization subtree, `~/Workspace/<org>/`. It contains canonical clone entries, issue-named worktrees and their sibling PR scripts. A layer clone lives at `~/.local/share/devlore/writ/repos/<clone>`; its workspace entry is a symlink. Keep one canonical clone per layer on the chosen PR target branch, usually the default branch. Development branches are checked out in worktrees, not canonical clones.

A worktree is `<clone>.<issue>-<name>`. Its PR script is `<worktree>.bash` on macOS/Linux or `<worktree>.ps1` on Windows. Read an existing script before overwriting; ensure its target is this worktree. Authorization for one script never extends to another worker's script.

Branch types remain `chore`, `doc`, `feature`, `fix`, `hotfix`, `refactor`, `release` pending any separately approved change. The branch identifies its issue and is created from the chosen PR target through the supported open-branch procedure. The work-item hierarchy is defined in [Work organization](work-organization.md#work-and-identity); branch prefixes describe Git references and do not reintroduce an issue tier.

<a id="plans-and-designs"></a>

## 3. Plans and designs

Plans live at `docs/plans/<type>/<issue>-<name>.md`, corresponding to the originating branch name. A separately needed plan for an additional issue names that issue. A shared plan carries a stable `## Issue NNN` heading for each issue; use the number alone, with no title or `#` prefix. This is an existing rule, not a new convention introduced by this consolidation. For active plans with title-bearing headings, inventory incoming anchors and preserve or migrate those references before renaming a heading. Leave completed historical plans unchanged unless a specific migration is approved.

Every issue ends with `## Plan and design documents`, a two-column Kind/Document table. It has a plan row from filing, initially “Not yet opened,” and one linked row per applicable design. Add the design-impact determination to the issue and plan, even when no separate design is needed. Document links target committed files on the default branch and stable issue anchors. Before merge, such links may intentionally be pending; provide the review revision separately so approval is possible.

New enduring designs belong under `docs/architecture/` within the owning repository. Existing approved locations remain until individually migrated. This draft proposes no new design filename scheme.

<a id="lifecycle-and-freshness"></a>

## 4. Lifecycle and freshness

The [documentation standard](../standards/documentation.md#document-families-and-metadata) defines document status vocabulary; [Completion and progression](process.md#completion-and-progression) owns plan completion, issue closure and post-merge updates.

Update affected documents in the commit changing the facts they describe: phase boxes, design/status companions, deleted APIs and paths, and user-facing material. Retained history must identify itself as history. The [templates](../templates/index.md) record required information; checked boxes alone do not establish a result.

**Case:** The commit moving six layer files left phase boxes unchanged until a later commit. Update records with the change, not in a cleanup batch ([recorded case, rule 12](review/sources/agent-rules.txt)).

<a id="clone-retirement"></a>

## 5. Clone retirement

Retirement must leave recoverable copies of unique work, a record of transferred live worktrees and verified registrations or references, and a report of what was saved where. Follow the [clone-retirement procedure](procedures/clone-retirement.md) for the ordered operations.

**Case:** A duplicate clone contained sixteen refs absent from origin, including a stash. Deleting the directory first would have lost that work ([recorded case, rule 8](review/sources/agent-rules.txt)).

<a id="layer-script-locations"></a>

## 6. Layer script locations

Code contributing to or depending on a repository stack belongs in its named `Home/<repository>[.<selector>]` project. Unconditionally deployed, self-contained code belongs in `Home/common[.<selector>]`. `git-*` commands live beside Declare-BashScript in engprod's common project. Context projects keep their scripts and source the base helper in place. Dependency declarations follow [Bash standards](../standards/coding/bash.md).
