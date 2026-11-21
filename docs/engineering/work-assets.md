---
title: "Work assets"
status: draft
created: 2026-10-28
updated: 2026-11-20
---

# Work assets

[Up: Engineering handbook](index.md)

<a id="identity-and-relationships"></a>

## 1. Identity and relationships

| Asset | Purpose |
| --- | --- |
| Design | The system we want: behavior, structure, requirements and significant choices |
| Architecture decisions | Significant architectural choices documented as architecture decision records (ADRs), with context, alternatives, reasons, status and consequences |
| Decision record | A significant policy or process choice, its reasons, alternatives, consequences and attribution |
| Roadmap | Useful delivery increments, dependencies and outcomes handed to the planner |
| Plan | How to reach that system from what exists: approach, changes, phases, transitions and verification |
| Schedule | The committed before → after outcome, ordered issues, dependencies, work locations, progress and approved amendments |
| Issue | A defined problem, scope and intended result, with parent, applicable schedule and document links |
| Approval | Who approved which proposal/revision, when, and within what limits |
| Completion review | Promised and delivered results, evidence, remaining work and approval to finish or continue |

Planning produces issues and a schedule that orders them. Each issue links its plans and applicable designs; a plan can cover several issues. [Work organization](work-organization.md#schedule-commitment) defines schedule execution.

Branches/worktrees identify their starting issue. A PR names the issues and approved changes it delivers. Verification records identify what was checked, where and with what result.

Use plain language and define necessary terms. Every word should help the reader understand.

<a id="role-deliverables"></a>

### 1.1. Role deliverables

| Role | Deliverables |
| --- | --- |
| Designer | One or more design documents, [Architecture decisions](../standards/documentation.md#architecture-decisions), and a roadmap |
| Planner | A schedule of ordered issues, dependencies, completion criteria and links to implementation plans; planning advice and proposed amendments throughout the work |
| Coder | The implemented change, appropriate tests, updated affected assets and verification evidence |
| Reviewer | Findings, corrective rechecks and an acceptance recommendation covering designs, architecture decisions, roadmaps, plans, code and affected artifacts, including help, man pages and completions |
| Compliance auditor | An assessment of those assets against applicable adopted requirements, with cited evidence, findings, corrective rechecks and unresolved compliance gaps |

A Designer owes a design, its architecture decisions, and a roadmap, not a plan for writing a design. Work starts from the Owner-approved problem and scope on a [design schedule](work-organization.md#design-schedules). The planner uses the delivered assets to prepare implementation work and remains available as a planning consultant.

<a id="workspace-locations"></a>

## 2. Workspace locations

Use one organization subtree at `~/Workspace/<org>/` for canonical clone entries, issue-named worktrees and sibling PR scripts. A layer clone lives at `~/.local/share/devlore/writ/repos/<clone>`; the workspace entry is its symlink. Keep one canonical clone per layer on the selected PR target, usually the default branch. Development belongs in worktrees.

A worktree is `<clone>.<issue>-<name>`. Its sibling script is `<worktree>.bash` on macOS/Linux or `<worktree>.ps1` on Windows. Read an existing script before replacing it and confirm its target. Permission for one script does not authorize changes to another worker's script.

Branch types are `doc`, `feature`, `fix`, `hotfix`, `refactor` and `release`. Create the issue-bound branch from the selected target using the [open-branch procedure](procedures/worktrees.md) and [maintained manual](../../Home/common/.local/share/man/man1/git-open-branch.1). Its type follows the issue's type, or its type label for a user account; it adds no issue-hierarchy level.

<a id="plans-and-designs"></a>

## 3. Plans and designs

<a id="designs"></a>

### 3.1. Designs

A design describes the system we want: what people can do, how its parts fit together and the rules it must satisfy. Describe the whole intended system clearly.

Explain significant choices, alternatives, tradeoffs and consequences using the [decision-record standard](../standards/documentation.md#decision-records). Keep transition decisions, migration steps and change history in plans. When the wanted system changes, revise its design and the plan for reaching it.

Designs belong under `docs/architecture/` in their owning repository. Leave other approved locations in place until a move is approved.

<a id="plans"></a>

### 3.2. Plans

A plan starts with what exists and explains how to reach the design. Record changes, approach, phases, transition decisions, migration steps, completion checks and results. Link the design rather than repeat its system description.

Record each Owner approval with its date, approved proposal/revision, authorized work and source exchange. Preserve exact words when material. Approval applies only to the named scope.

<a id="33-document-formats-and-links"></a>

<a id="document-formats-and-links"></a>

### 3.3. Formats and links

Plans use `docs/plans/<type>/<issue>-<name>.md`, matching the branch that began the work. Additional issue plans name those issues. A shared plan has stable `## Issue NNN` headings: number only, without a title or `#` prefix. Preserve incoming links and completed historical plans unless an explicit migration authorizes changes.

Every issue ends with `## Plan and design documents` and a two-column Kind/Document table. For work requiring an implementation plan, include a plan row, using “Not yet opened” until that plan exists. For a Designer assignment, the plan row states “Not required: Designer deliverables” and the table links the design, architecture decisions and roadmap. Include all required plans and applicable designs. State design impact in the issue and any applicable implementation plan, including when no separate design is needed. A Designer records the design scope in the design issue without creating a plan for it.

Open issues link committed files on the default branch and stable issue anchors. Issues closed by a merged PR link documents at its merge commit. If the file is absent there, is in another repository, or closure had no such PR, retain a default-branch link and the linking command's explanation. Before merge, provide the committed review revision too.

Plans supply the document table through their `issue:` field and stable issue headings. Their `documents:` entries have `kind` and a repository-relative `path` or `url`, with optional display `text`.

After pushing the first plan, its worktree script runs `star github plan link`. Inspect action, reason and dropped-row records. Report refused issues or dropped rows even if the command exits 0. Preserve the issue's filed table until a plan covers it.

<a id="lifecycle-and-freshness"></a>

## 4. Lifecycle and freshness

The [documentation standard](../standards/documentation.md#document-families-and-metadata) defines statuses. [Completion and progression](process.md#completion-and-progression) defines plan completion, issue closure and post-merge records.

Update affected documents with the commit that changes their facts, including phase boxes, design/status records, removed APIs/paths and user documentation. Mark historical records clearly. Templates show required structure; boxes alone do not establish completion.

<a id="clone-retirement"></a>

## 5. Clone retirement

Before retirement, save recoverable unique work, identify transferred worktrees, check registrations/links and report the saved locations. Follow the [clone-retirement procedure](procedures/clone-retirement.md) before deletion.

<a id="layer-script-locations"></a>

## 6. Layer script locations

Code contributing to or depending on a repository belongs in its named `Home/<repository>[.<selector>]` project. Self-contained code deployed everywhere belongs in `Home/common[.<selector>]`.

The `git-*` commands live beside Declare-BashScript in engprod's common project. Repository-specific projects keep their scripts and source the base helper in place. [Bash standards](../standards/coding/bash.md) defines dependency declarations.
