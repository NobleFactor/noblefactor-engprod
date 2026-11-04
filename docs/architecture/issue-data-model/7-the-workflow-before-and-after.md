---
title: "7. The workflow, before and after"
---

# 7. The workflow, before and after

Why this design: what a session does today to file an issue, write a schedule and report progress, and what it does
once the model and its tooling are in. The owner, 2026-10-22: "Today, I ask you to create my issues, add them to your
schedule, and report progress. You do that with some guidance, some skills, and some tooling: star gh. How does this
change your workflow?" The plan, the branch, the pull request and the sign-off do not move. Three things do.

The Before columns are the scheme of 2026-10-22, the day of that question, and most of it is already gone: Chore and
its `**Chore:**` marker (ruled 2026-11-02), the `Epic:` labels (removed 2026-11-03), lanes, which are now steps, and
the Next column, deleted from the Schedule template and every schedule on 2026-11-02. The old scheme's last three
pieces retired on 2026-11-03, and the retirement is done in GitHub: the parent markers and schedule footers in issue
bodies, the step and beat tables in issue bodies, and the kind labels `epic`, `feature`, `task` and `bug` in
NobleFactor's repositories. The After comes in two stages, because a working issue tracking system on GitHub comes
first and the tooling follows (ruled 2026-11-02). First come GitHub's own records: issue types (type labels, in a user
account), NobleFactor's issue fields (labels, in a user account), sub-issue links, each team's four projects, Triage,
Backlog, Schedule and Scenario (ruled 2026-11-03), the Schedule project's Schedule, Step and Iteration fields, the
Scenario project's Scenario and Beat fields, and blocked-by links. A session uses them today through `gh` or GitHub's
own pages. The `star` commands the After columns name come second.

Ruled 2026-11-03, threads are now called scenarios: the Thread issue type is Scenario, a user account's `thread` label
is `scenario`, and the Thread template is the Scenario template.

## Filing an issue

| | Before | After |
| --- | --- | --- |
| The kind | a label the session picks and types | in an organization, the issue type (Epic, Feature, Task, Bug, Schedule or Scenario), which GitHub holds to one; in a user account, the label of the same name in lowercase (`epic`, `feature`, `task`, `bug`, `schedule`, `scenario`). Ruled 2026-11-03, issues are classified by type in the hierarchy epic, feature, then task or bug; enforcement is lax, and there are no compliance checks. A Schedule or Scenario issue is filed from its issue form in the account's `.github` repository ([section 6](6-the-asset-and-its-sync.md#one-model-per-account)). Later, one argument to `star github issue`, which, ruled 2026-11-03, is the one path for the issues we file ourselves, because it classifies an issue as it is made |
| The parent | a `**Feature:** #N` or `**Chore:** #N` marker written into the body, the last one in the body winning | the sub-issue link, set in GitHub, to a parent one level up in the issue's own account, since no sub-issue link crosses accounts; later, one argument to the command, which refuses any other parent. Ruled 2026-11-03: a Schedule or Scenario issue has no parent. Epic is at the top of the hierarchy, and Schedule and Scenario are its two peers there. |
| Triage | under the triage epic, NobleFactor/noblefactor-engprod#142 | a row of its team's Triage project (`Triage: engprod`, for example), and in a user account a row of the account's own, `Triage: David-Noble-at-work`; there is no triage epic. Ruled 2026-11-03, a GitHub Actions workflow in each repository adds a new issue to its team's Triage project when the issue is opened or transferred, using `actions/add-to-project`; GitHub's built-in auto-add workflow isn't used. Each repository's `TRIAGE_PROJECT_URL` variable names its team's Triage project, from the team mapping: the team with the maintain role on a repository owns it. A Triage workflow template in each account's `.github` repository offers the workflow ([section 6](6-the-asset-and-its-sync.md#one-model-per-account)); GitHub's documentation describes workflow templates kept in an organization's `.github` repository and says nothing about a user account's; whether GitHub offers David-Noble-at-work/.github's template to personal has not been checked, and David-Noble-at-work/personal#315 copies personal's `triage.yml` from its account's template either way ([section 4](4-storage-and-reach.md#triage)). The team that owns a project is accountable for it, and GitHub's link between the project and its team is the record; a user account's projects are its owner's. In the Triage project every issue is reviewed and a triage decision made: the work is declined, and the issue is closed as completed with Resolution Declined (in a user account, the `resolution:declined` label), or the issue moves to its team's Backlog, Schedule or Scenario project. Each Triage project shows the Area column (in a user account, the `area:` labels in its Labels column) and has a Missing Area view, both made 2026-11-03, and nothing leaves Triage without an Area. Open, to be ruled on #303: how a triage decision is carried out, and how an issue is kept in one project at a time. |
| The epic | an `Epic:<Name>` label the session must know and type | the parent's parent, read, never written; the `Epic:` labels were removed from both accounts 2026-11-03 |
| The attributes | labels typed by name | in NobleFactor, its issue fields Priority, Effort, Target date, Area, Severity and Resolution: Severity on a bug only ([section 2](2-attributes.md#the-attributes)), and Resolution only on a closed issue; Start date isn't used, because an issue's history shows when its work really started. In David-Noble-at-work, which has no issue fields, the `priority:`, `severity:`, `effort:` and `area:` labels (for example `priority:urgent`), one for each option of a single-select field ([section 4](4-storage-and-reach.md#a-user-account)). Priority and Area apply to issues of every type, Schedule and Scenario included. Ruled 2026-11-03, an account's model holds its issue fields, as it holds its issue types and labels: NobleFactor's are Priority, Effort, Target date, Resolution, Area and Severity, and a user account has none. Later, arguments to the command, which checks a label against the labels the account's model holds for the repository the issue is filed in. |
| The area | an `Area:` label typed by name, in devlore-cli only, one of its seven finer areas (architecture, CLI, code quality, error handling, git, meta and testing) | Product or Engineering, and nothing else: in NobleFactor, an option of the Area issue field; in David-Noble-at-work, the label `area:product` or `area:engineering`. A blank Area is an error (ruled 2026-11-03), and at filing it is caught twice: `star github issue` refuses an issue without an Area, and the issue forms in each account's `.github` repository have a required Area dropdown, whose answer the Triage workflow copies into the Area field or label when the issue is opened. [Product and engineering](#product-and-engineering), below, says what each value means. |
| The documents table | written by hand; `grep -q '^## Plan and design documents'` in the filing script, because it was once forgotten ([agent-rules.md](../../guides/agent-rules.md) rule 15) | checked by the command before it writes; until the command is built, by rule 15's grep |
| The evidence of completion | nothing asks for it | every issue states it (ruled 2026-11-02). Open, to be ruled on #303: where an issue states its evidence of completion, and what checks it when the issue is filed. |
| A repository that does not participate | nothing stops the filing; the issue is unplaced in the next report | Ruled 2026-11-03: a repository takes part in the data model when a team has the maintain role on it, in an organization, or when it has the topic issue-model, in a user account. |
| What it costs | a body composed by hand, three labels, a marker, a table and a grep, and a report afterwards to see what went wrong | today, the same body by hand, with the type, the parent and the Area set in GitHub instead of written as labels and markers; later, one command that will not let the session get it wrong |

The permission does not change: filing is a write to GitHub, and it runs as `gh issue create` runs today, by the owner
or under a grant.

### Product and engineering

Area tells engineering work from product work (ruled 2026-11-03). It applies to issues of every type and describes
the issue's own work, so an epic, a feature and the tasks and bugs under them can each have a different Area: a CI bug
fixed during a product feature is engineering. Engineering covers build orchestration, Makefile changes, CI pipelines,
internal agent-workspace scripts and tools, and governance and process work. Release notes come from the closed
product issues in a release, not from the hierarchy, and the product readiness and release management epics hold
both kinds.

The distinctions devlore-cli's seven finer Area labels made (architecture, CLI, code quality, error handling,
git, meta and testing) are carried by the hierarchy instead; the labels were deleted 2026-11-03. Architecture work is a
task or a feature with product value within an epic. A bug isn't filed against the architecture, and an architecture
task is logged to address a bug in a feature.

A blank Area is caught at three points (ruled 2026-11-03): at filing, by `star github issue` and the required Area
dropdown of the issue forms in each account's `.github` repository
([section 6](6-the-asset-and-its-sync.md#one-model-per-account)); at triage, where nothing leaves the Triage project
without an Area; and afterwards, by a scheduled sweep that returns any open issue without an Area to its team's Triage
project.

## Writing a schedule

| | Before | After |
| --- | --- | --- |
| The schedule | a markdown table in an issue body, edited by hand lane by lane | the rows of one schedule in its team's Schedule project (`Schedule: engprod`, for example; in a user account, `Schedule: David-Noble-at-work`), which holds the team's committed tasks and bugs, all of them issues of that account, and is copied from the account's Schedule template (NobleFactor project 7; in David-Noble-at-work, its copy, project 1). There is no longer a project per schedule (ruled 2026-11-03). A single-select Schedule field names the schedule each row belongs to, with one option per schedule, named for its Schedule issue. That issue, of type Schedule (in a user account, labeled `schedule`), is filed from the Schedule issue form in the account's `.github` repository and holds the schedule's deliverable and exit criteria. Step orders the rows within a schedule; the Schedule issue's own row has no step, and the issue keeps its number, so a session's assignment is read as it is today. Steps are worked in step order. GitHub's Iteration field gives each row its sprint, for scrums and sprint review. |
| Adding a step | an edit to the table, and an amendment above it the session must remember to write | the row gets its Schedule option, its step number and its blocked-by links, and its amendment is written, when it is added: by hand in GitHub until `star github schedule add` is built, then by that command in one act |
| A step in progress | "in progress in `<worktree>`" typed into the Next cell | whoever starts the work sets the row's Status to In progress, and the row's Worktree field holds a link to the branch the work is on; the step's own issue records that it merged or closed. There is no Next field. |
| Waits on | a cell of lane numbers | GitHub's blocked-by link between issues of the same account; a step that waits on another account's work is blocked by a stand-in issue in its own account |
| What enforces "no step without its step number, its blocked-by links and its amendment" | memory | `star github schedule add`, once it is built |

The other two projects were ruled on 2026-11-03 as well. A team's Scenario project holds its features: a
single-select Scenario field names the scenario each row belongs to, named for its Scenario issue, which tells the
story, and Beat orders the rows within a scenario. There is no longer a project per scenario. A team's Backlog
project holds accepted work not yet scheduled, ordered by priority. NobleFactor keeps a template for each of the four
kinds: Triage (project 23), Schedule (project 7), Scenario (project 8, the former Thread template) and Backlog
(project 24). David-Noble-at-work, which cannot have templates, keeps copies of them, and a team's projects are copied
from these.

## Reporting progress

| | Before | After |
| --- | --- | --- |
| The commands | `star github schedule report`, `star github schedule audit` | the same |
| What they read | kind labels, epic labels, the markers in bodies, the lane tables | the type (in a user account, its type label, read first and kept), the sub-issue link and the rows of the team's projects. NobleFactor's kind labels, the markers in bodies and the step and beat tables retired from GitHub on 2026-11-03, and the `Epic:` and `Thread:` labels are gone, so nothing reads them |
| What the audit catches | a missing or doubled label, a missing epic, a marker naming the wrong kind | the same, less the markers, which are gone from issue bodies, and a resolution on an open issue: in NobleFactor its Resolution field, which the model records among the organization's issue fields; in David-Noble-at-work a `resolution:` label, the model recording which labels are resolutions. |
| What the report rests on | our text inside GitHub's issues | GitHub's own record of them |

## What goes and what stays

Already gone from both accounts, 2026-11-02 and 2026-11-03: the Chore type and the `chore` label; the triage epics
NobleFactor/noblefactor-engprod#142, NobleFactor/devlore-cli#1188 and David-Noble-at-work/personal#313; the `Epic:`,
`Thread:` and `ClaudeJudgmentError:` labels; and the Next column of every schedule. Ruled 2026-11-03: the `chore/`
branch type is removed from the branch ruleset and `git open-branch`, and the plans already filed under
`docs/plans/chore/` stay where they are. Deleted 2026-11-03: devlore-cli's seven finer Area labels, architecture, CLI,
code quality, error handling, git, meta and testing.

The old scheme's last three pieces retired on 2026-11-03, and the retirement is done in GitHub. The parent markers
and schedule footers came out of 725 issue bodies; 47 issues got the sub-issue parent their marker named, and where
the marker and the link disagreed, the link stands. The step and beat tables in 14 Schedule and Scenario issues gave
way to a line naming the issue's board and option. The kind labels `epic`, `feature`, `task` and `bug` left
NobleFactor's 12 repositories, after 672 issues got the issue type their label named. David-Noble-at-work keeps its
type labels, which are its types.

Closing an issue changes too. Ruled 2026-11-03: there is no `wontfix` or `declined` label, and the reason a closed
issue wasn't done is recorded two ways. In NobleFactor it is the Resolution issue field, a single select with three
options, Declined, Duplicate and Invalid; NobleFactor's repositories have no `resolution:`, `duplicate` or `invalid`
labels. In David-Noble-at-work, which has no issue fields, it is a label named `resolution:<name>`:
`resolution:declined`, and `resolution:duplicate` and `resolution:invalid` in place of the `duplicate` and `invalid`
labels. A resolution goes only on a closed issue. An issue that wasn't done is closed as completed, with its
Resolution, or in a user account its `resolution:` label, saying why; GitHub's not_planned close reason isn't used.

Goes from the guidance: Chore as a kind, with its `**Chore:**` marker; the parent markers such as `**Feature:**`, the
schedule footers, and the step and beat tables in issue bodies; NobleFactor's kind labels; the `Epic:` and `Thread:`
label conventions in [issue-standards.md](../../issue-standards.md), with its `Epic:Ops:Process` hub; and rule 15's
grep, once the create command checks the table. The eight issues proved by marker on 2026-10-21 under
noblefactor-engprod#370 are the last to be proved that way.

Stays: a user account's lowercase type labels, and the `severity:`, `priority:`, `effort:` and `area:` labels,
lowercase (for example `severity:critical`, `priority:urgent`, `area:product`), which David-Noble-at-work uses because
it has no issue fields; its `area:` labels are `area:product` and `area:engineering` only.

Stays, and gets stronger: [agent-rules.md](../../guides/agent-rules.md) rule 3, a question about issues is answered
by the report, because the report reads GitHub's record rather than our text in it. And the process around the
work: an issue, a branch from it, a plan committed on the branch and reviewed, the work, one pull request at a time
that discloses AI and is signed off. Ruled 2026-11-03: each account's pull request template is stored in its `.github`
repository, and on 2026-11-03 neither account had one there
([section 6](6-the-asset-and-its-sync.md#one-model-per-account)).
