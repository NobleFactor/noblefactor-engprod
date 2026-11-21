---
title: "Issue standards"
type: Process
status: Approved
updated: 2026-11-21
---

<a id="issue-standards"></a>

# Issue standards

[Up: Engineering documentation](index.md)

Use this standard to classify issues, place work and describe completion. The [engineering process](engineering/process.md) governs execution and approval; the [issue data model](architecture/issue-data-model/index.md) defines the supporting system and command contracts. The account's issue forms define each body's required fields.

GitHub holds the live record: issue Type, attributes, native parent/dependency links and project rows. NobleFactor uses organization issue types and fields. The David-Noble-at-work model uses lowercase type and attribute labels. Each account has its own model and public .github repository for forms, templates and model backups.

The user-account labels are our supported representation. [GitHub documents native issue fields for user-owned repositories](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/managing-issue-fields); its User schema also exposes issueFields and issueTypes. Native adoption, account entitlement, access and support in our commands remain unqualified.

<a id="the-types"></a>

<a id="what-has-no-parent"></a>

## 1. Issue types and parents

| Level | Type | Meaning | Parent |
| --- | --- | --- | --- |
| 0 | Epic | A body of work spanning several Features | None |
| 1 | Feature | A product or engineering body of work decomposed from an Epic | One Epic |
| 2 | Task | Work delivering part of a Feature | One Feature |
| 2 | Bug | Work repairing a Feature | One Feature |
| Collection | Schedule | A committed deliverable, exit criteria and ordered Tasks/Bugs | None |
| Collection | Scenario | A reusable user goal, example walk and Features exercised | None |

Type is capitalized in NobleFactor. The user-account equivalents are epic, feature, task, bug, schedule and scenario labels, with exactly one type label per classified issue. Model descriptions start with `Level N:` for hierarchy types and `Collection:` for collection types.

Task and Bug are mutually exclusive peers. Choose Task to build something the Feature did not have; choose Bug to restore something it was meant to have. Size and difficulty do not distinguish them. Code tidying belongs to the Feature owning the code, as a Task or as a Bug when it repairs a defect. This scheme has no Story type.

Use native sub-issue relationships for parents. Every Feature, Task and Bug has exactly one parent one level above it. Read its Epic by following those links. A parent can be in another repository of the same account. Managed parent links, blocked-by links and project membership stay within the account; work waiting on another account uses a local stand-in issue referencing the external work. These are our model boundaries rather than a claim about every link GitHub permits.

A Task/Bug lacking a parent is unclassified and waits in Triage or its originating Scenario. Do not encode ownership with Epic labels, body parent markers or collection labels.

<a id="what-an-empty-level-means"></a>

### 1.1. Empty levels and completion

| Record | Meaning when empty or unclassified |
| --- | --- |
| Epic with no Features | Ill-defined, or awaiting plan/design and decomposition; report which |
| Feature with no Tasks/Bugs | Awaiting decomposition |
| Task/Bug without a Feature | Unclassified; awaiting triage or Scenario disposition |

Do not render these cases as an unexplained blank. An Epic without Features needs either correction of its Type or a plan/design that supplies its decomposition.

A Feature stays open after its Tasks/Bugs close until an agent has audited compliance, an agent has technically reviewed its deliverables, including code when present and the team lead has signed off. An Epic closes when its Features do. A Scenario remains useful across releases and is retired when the product no longer has that Scenario and its open findings have moved on.

<a id="enabler-features"></a>

### 1.2. Enabler features

An enabler feature delivers knowledge or a technical foundation needed for future capabilities. It can cover research, architecture, infrastructure or compliance. Keep Feature as its GitHub issue Type and its Epic as native parent. Enabler describes purpose; it does not introduce a hierarchy level, type, label or field, or determine Area and Priority.

Name the enabling outcome and the future work it supports. For a design enabler Feature, completion requires the accepted design, Architecture decisions and roadmap, with technical review, compliance assessment, Owner approval and merged deliverables. Its Tasks belong to the design Schedule; the Feature remains in Backlog under the placement rules. Completing the design enabler does not establish delivery of the subsystem's future capabilities.

For design work, use a noun phrase for the Feature, such as Evidence archive design, and action titles for its Tasks, such as Design the Evidence Archive subsystem and Produce the Evidence Archive roadmap. This is our issue-title convention, informed by [Google's heading guidance](https://developers.google.com/style/headings); that guide addresses documentation headings, not GitHub issue classification.

We borrow this vocabulary from [SAFe's enablers](https://framework.scaledagile.com/enablers/), without adopting its other roles, backlog levels or planning practices. [Arc42](https://arc42.org/overview/) guides design contents, not issue types. Research findings, designs, Architecture decisions, roadmaps and plans are deliverable assets; they do not become new issue types.

<a id="product-and-engineering"></a>

## 2. Area and attributes

Area describes an issue's own work, rather than inheriting its parent's Area.

| Area | Meaning |
| --- | --- |
| Product | User-facing capabilities, functional components or other deliverables packaged and released from the repository |
| Engineering | Design artifacts, internal infrastructure, tests, planning and other work outside the deliverables released from that repository |

DevLore releases from devlore-cli, devlore-registry and devlore.noblefactor.com. Engineering materials and tooling released from noblefactor-engprod are products too. Documentation released with a product is Product work; internal planning/design documentation, CI, build orchestration, tests and tools that do not ship are Engineering work. A defect in a test is Engineering; a defect in released release notes is Product. Personal productivity repositories do not normally use `area:product`.

A Product Epic may contain an Engineering Feature, and a Product Feature may contain an Engineering Task/Bug. An Engineering parent contains no Product child. Epics and Features each have one Area. Record an engineering problem discovered during product work under the Feature it supports, with its own Engineering Area.

Every Scenario has Engineering Area. A Schedule's Area follows its deliverables, which can be Product or Engineering. Release notes select closed Product issues in the release, rather than inheriting Area from hierarchy containers.

### 2.1. Attribute values

| Attribute | Meaning | Values |
| --- | --- | --- |
| Area | Nature of this issue's own work | Product, Engineering |
| Priority | When to act | Urgent, High, Medium, Low |
| Severity | Harm if a Bug occurs | Critical, High, Medium, Low; N/A for every other typed issue |
| Effort | Estimated amount of work | High, Medium, Low |
| Target date | Intended target | Date |
| Resolution | Why closed work was not done | Declined, Duplicate, Invalid |

NobleFactor stores these as issue fields. Start date is unused; issue history records when work started. Priority and Area apply to every Type, including Schedule and Scenario. An Area is required before work leaves Triage and is required by the filing command.

In the David-Noble-at-work model, single-select attributes use one lowercase `<field>:<option>` label per value. Families are `priority:`, `severity:`, `effort:`, `area:` and `resolution:`. Examples include `priority:urgent`, `severity:n/a` and `resolution:declined`. All options follow the table, including `severity:critical` through `severity:low` and both Area values. Date fields have no label substitute. A project field is not an issue-attribute substitute because its value does not follow the issue between projects.

### 2.2. Severity

| Severity | Meaning |
| --- | --- |
| Critical | Data loss, corruption or a security failure |
| High | A supported path is broken with no workaround |
| Medium | Broken with a workaround, or a narrow path |
| Low | Cosmetic, or a defect nobody is hitting |
| N/A | The issue is not a Bug |

Every typed issue has one Severity. A Bug has Critical, High, Medium or Low, never N/A; other Types have N/A. An untyped issue waits for triage without a Severity.

The intake workflow preserves an existing Severity. When one is absent, it gives a Bug Medium, another known Type N/A and an untyped issue none. Triage revises Severity to match harm and supplies it when an issue is typed after intake. Medium is a workflow default, not a claim that the GitHub field has a configured default.

<a id="the-labels-a-repository-provides"></a>

### 2.3. Resolution and labels

Close declined, duplicate or invalid work as completed with the corresponding Resolution field/label. Use no Resolution on completed delivered work, an open issue or a normally retired Scenario. GitHub's `not_planned` close reason is not used by this model.

Labels belong to individual repositories; organization default labels are not another model tier. Participating repositories are those with an owning team's Maintain role in NobleFactor, or the issue-model topic in the user account.

User-account repositories provide all six type labels and the attribute families they use. NobleFactor uses native Types/fields instead of type, severity, priority or resolution labels. Neither account uses chore, `Epic:<name>`, `Thread:<name>`, ClaudeJudgmentError:, duplicate, invalid, wontfix or declined as substitutes for the defined model.

Enhancement, documentation, help wanted and question labels classify neither Type nor placement. Good first issue is permitted only on Tasks and Bugs.

<a id="placement"></a>

<a id="three-ways-to-slice-the-work"></a>

## 3. Projects and placement

Each team has four managed projects: Triage, Backlog, Schedule and Scenario. A user account has the same four. Names identify kind and owner, such as Triage: engprod or Schedule: David-Noble-at-work. A Schedule/Scenario is an issue and field option within its team's project, rather than a separate project.

| View of work | Question | Record |
| --- | --- | --- |
| Hierarchy | Which body of work owns it? | Native Epic → Feature → Task/Bug links |
| Scenario | Which user goal is being exercised? | Scenario issue and project option; finding rows ordered by Beat |
| Schedule | What is committed and in what execution order? | Schedule issue and project option; Task/Bug rows ordered by Step |
| Backlog | What is accepted but unscheduled? | Prioritized project inventory |
| Triage | What needs a triage decision? | Team/account Triage queue |

Hierarchy, Scenario and Schedule answer different questions; none replaces the others. Epics and Features are held in Backlog after classification and remain there until closure. Only Tasks/Bugs and the collection's own issue belong to a Schedule or Scenario project.

An issue has at most one home among the account's managed Backlog, Schedule and Scenario projects, and at most one Schedule or Scenario. It may also have a row in its responsible team's Triage project while a fault awaits a triage decision. That temporary row leaves its home and any Schedule commitment intact. Triage resolves the fault and removes its row; an approved move can separately change the home. An issue awaiting initial classification may be in Triage without a home.

Project configuration follows its account templates: four organization templates or equivalent user-account copies. Projects of one kind share configuration, within account capability. Managed templates/copies have no built-in workflows. Triage exposes Area (Labels for a user account) and a Missing Area view. Organization Backlogs expose Priority in a By priority view; user-account views expose Labels. Linking a project to a team does not replace its Write grant.

### 3.1. Intake

New non-collection issues enter their team's Triage project. A finding logged during a Scenario walk enters that Scenario instead. Schedule and Scenario creation commands place the organizing issue directly in its collection project; intake skips those own rows.

Each participating repository installs the account's Triage workflow. It runs on issue opening/transfer and uses `TRIAGE_PROJECT_URL` for normal intake. The account's .github repository owns the workflow template, issue forms and PR template. Do not depend on a user-account template picker to install the workflow. Project-row changes are not assumed to trigger repository Actions.

The workflow copies the form's Area into the issue field/label and initializes Severity. The filing command independently checks required Area/body sections and establishes metadata. A form alone does not establish that every API or private-repository filing path was validated. [Storage and access](architecture/issue-data-model/4-storage-and-reach.md#triage) defines credentials and routing.

<a id="triage-classifies-and-adds-attributes"></a>

### 3.2. Triage decisions

Triage determines Type, parent, Area, Priority and Severity. An accepted issue leaves with valid classification; a Scenario finding must be classified before it enters a Schedule. Decline work with Resolution Declined, or move accepted work to Backlog or an approved Schedule. Accepted Epics/Features go to Backlog.

Remove the Triage row as part of its disposition. `star github issue close` removes Triage and Backlog rows. Closure through GitHub's UI or a PR closing reference can leave a Triage row for triage or the command's documented recovery to resolve. The sweep never removes one.

### 3.3. Movement and team ownership

Use `star github issue move` with a required `--reason`. It adds the destination row/fields and removes the source home. Schedule changes record the approved reason as an amendment on each affected Schedule issue. The supported destination flags are `--triage`, `--backlog`, `--schedule` and `--scenario`; source/destination combinations and refusals are defined by the [issue command contract](architecture/issue-data-model/10-the-issue-commands.md).

Use `--after` to position scheduled work, `--blocked-by` to add dependencies, `--assignee` for the receiving team's accountable member, and `--beat` with a Scenario destination. The delivered `--backlog` operation moves a classified issue from Triage to Backlog, creates its destination row before removing the Triage row, and refuses an untyped issue. Confirm the Type, required parent and attributes before accepting the work; command acceptance alone does not establish full classification.

The accountable assignee moves work between teams and identifies an accountable recipient. Team project access and repository issue access are both required; public visibility alone grants no issue-management authority. Cross-team moves remain within the account.

<a id="scenarios"></a>

## 4. Scenarios

A Scenario describes a Feature, workflow or real situation to test. Open one for an end-user goal. Its issue summarizes what someone wants to do, gives a numbered walk/example for demos or ad-hoc testing, and names the Features exercised. Scenarios support planning, coverage and discovery before, during and after a release.

The issue uses Scenario Type (scenario label in the user account), no parent, Engineering Area and the title `Scenario: <option name>`. Its own row has the matching Scenario option and no Beat. Its body links the filtered project view. The account's Scenario form asks for the goal, walk, Features and plan/design documents; a Scenario has no Evidence of completion section.

Log discovered Tasks/Bugs with `Found while walking #N` in their body. Their Scenario option identifies the originating collection and Beat identifies the walk position: Beat N means step N, and Beat 0 means before the first step. Issue numbers do not define walk order. Scenario membership changes no Priority; triage owns classification and prioritization.

A finding stays in the Scenario until it closes or moves to Triage, Backlog, a Schedule or another Scenario. Record a move in its body and on the Scenario issue, preserve origin and remove the old Scenario home. Classify before scheduling it. A Scenario does not own the product hierarchy and may exercise Features from several Epics/repositories of its own account.

Only two sweep checks apply while findings remain in a Scenario: prohibited Epic/Feature rows and multiple homes. Other classification checks wait until disposition. Keep the Scenario useful as the product changes. Retire it with `star github scenario close` after open findings move on, closing as completed without Resolution and retaining historical records.

<a id="schedules"></a>

<a id="what-a-schedule-commits-to"></a>

<a id="the-deliverable"></a>

## 5. Schedules

A Schedule states a deliverable as before → after and its exit criteria. The issue describes what the Owner will have after the work; ordered Steps describe how it is delivered. Use [Schedule commitment](engineering/work-organization.md#schedule-commitment) and [Changing scheduled work](engineering/work-organization.md#changing-scheduled-work) for execution, dependencies, discoveries and approved amendments.

The Schedule issue has Schedule Type (schedule label in the user account), no parent, Area matching its deliverables, an accountable owner and its matching Schedule option. Its own row has no Step. Its body links the filtered project view; project rows are the authoritative Step list.

Tasks and Bugs from any Feature/Epic or repository of the same account may be Steps. Epics and Features are never Steps. Step numbers are consecutive 1..N, and execution follows Step order. Insertion, movement and removal renumber later closed and open Steps together. Give each row its Step, Status and dependencies on entry; preserve the defined physical row order as well as the logical Step.

Select Backlog work by Priority unless the Owner directs the commitment. Use `issue move --schedule`, with `--after` where needed. Add or change committed work only through the Owner's amendment recorded on the Schedule issue. Explain effects on deliverable, criteria, order and dependencies rather than silently revise the commitment.

Iteration identifies the sprint for scrums/review; it is distinct from Step and Schedule membership. Worktree links the active branch, then the PR; Status records progress. There is no Next column. Keep issue and row progress current as work proceeds.

Read a Schedule with `schedule get` in Step order and a Scenario with `scenario get` in Beat order. Use each collection's list command for account/team discovery; the broad schedule report serves Epic/Feature/Bug and cross-issue questions. Follow the [reporting skill](../Home/common/.claude/skills/star-github-schedule-progress/SKILL.md).

<a id="evidence-of-completion"></a>

## 6. Completion evidence and validation

Every issue except a Scenario states observable evidence in an Evidence of completion section. A Schedule's exit criteria are that evidence. Link applicable plans/designs through the required documents table; forms and the [work-asset standard](engineering/work-assets.md#plans-and-designs) define the body/document relationship. A Scenario supplies its reusable walk instead.

A well-classified issue has one Type, a valid parent when required and the attributes/placement appropriate to that Type. Triage and Scenario discovery admit incomplete classification so a person can decide what the issue represents; those exceptions do not make a missing field valid for scheduled execution.

<a id="what-the-audit-checks"></a>

<a id="well-classified"></a>

<a id="what-the-sweep-is-for"></a>

### 6.1. Sweep checks

The sweep reads open work against the account's live model. It reports faults rather than silently omit unplaced work or choose a repair. Closed issues retain their recorded classification.

| Check | Required condition |
| --- | --- |
| Type and parent | One Type; one same-account parent one level up for Feature/Task/Bug; none for Epic/Schedule/Scenario |
| Account boundary | Managed parent and blocked-by links remain in the account |
| Area | Present |
| Severity | Bug has a harm value; other typed issues have N/A |
| Resolution | Absent on open work |
| User labels | No competing Type labels or values in one attribute family |
| Evidence | Evidence of completion section except on Scenario |
| Collection rows | No Epic/Feature rows in Schedule/Scenario; Steps present on scheduled Task/Bug rows |
| Dependency order | An open prerequisite on the same Schedule precedes the blocked Step |
| First-issue label | Good first issue only on Task/Bug |
| Membership | At most one Backlog/Schedule/Scenario home; a temporary Triage fault row is allowed |

Triage exempts Type/parent validation while classification is pending. A Scenario finding receives only the two structural checks described above. A model type without a valid level/collection description is a model fault; model get stops on it, and diff/apply report the model difference.

The sweep adds a Triage row beside the existing home and comments with the violated rule. It removes no row, blocks no filing and repairs no classification. Triage resolves the fault and removes its row. The automation design calls for a daily account-level run using intake credentials; the command's existence alone does not establish that a scheduled workflow is deployed. Its dry run currently reads nothing and does not prove live behavior.

### 6.2. Supported operations

| Operation | Entry point |
| --- | --- |
| File and classify an issue | `star github issue open`; create is its synonym |
| Change placement | `star github issue move` |
| Close/reopen ordinary issues | `star github issue close / reopen` |
| Create/read/list/close/reopen Schedules | `star github schedule commands` |
| Create/read/list/close/reopen Scenarios | `star github scenario commands` |
| Read/compare/apply a model | `star github model get / diff / apply` |
| Publish/restore backups | `star github model backup / restore` |
| Find classification faults | `star github triage sweep` |

Model commands name the account explicitly. The live GitHub model is authoritative; the .github YAML is a versioned backup, not a command cache. Apply/restore delete definitions only with `--prune` and never delete a team, project or template. A newly created project is brought to its template exactly, removing GitHub's defaults whether or not prune is requested.

Model provisioning includes account files, participating repositories' intake workflows, `TRIAGE_PROJECT_URL` and credentials supplied through `env:` or `file:` source references; never store secret values in model data. Follow [model synchronization](architecture/issue-data-model/6-the-asset-and-its-sync.md) for publication and required implementation alignment. Do not infer broader mutation or merge permission from the command list.

<a id="who-can-do-what"></a>

## 7. Access and authority

Organization participants join the owning team. Its intended grants are Maintain on its repositories and Write on its four projects. User-account participants are collaborators on participating repositories and writers on the four projects. Provision required account membership first; repository visibility, project visibility and mutation rights are separate.

| Action | Required access and limits |
| --- | --- |
| Open an issue | Repository read for public filing; collaborator access where private; configured forms can supply Type/labels |
| Set Type/labels/assignees through issue REST creation/update | Repository Write/push access; these fields can be silently dropped without it |
| Set a parent | Triage on both child and parent repositories through the documented create endpoint; do not infer access from public visibility |
| Set issue field values | Triage through the issue UI; the combined REST issue update requires Write/push access |
| Move rows, set Step/Beat/Worktree/Status, edit project fields/views | Write on each affected project |
| Close/reopen another person's issue | Required issue-management access; the source role matrix distinguishes Triage from Read for one's own issue |
| Edit a body | Repository Write or authorship of that issue |
| Assign an accountable receiving teammate | Issue-management access in addition to both project grants |
| Configure Types/fields or project access/settings | Account administration; normal work grants do not transfer it |
| Create/edit/delete repository labels | Repository Write |

Read back mutations: a successful issue creation can still omit fields. GitHub's [issue REST API](https://docs.github.com/en/rest/issues/issues#create-an-issue), [sub-issue guide](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-sub-issues), [issue-field guide](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/adding-and-managing-issue-fields) and [project-access guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/managing-your-project/managing-access-to-your-projects) define platform permissions; process approval is additional.

The [original role matrix](engineering/review/sources/rewrite-2026-11-19/issue-standards.md.txt) preserves the detailed workflow-by-workflow access readings and uncertainties. It did not establish personal-account parent/dependency minimums, the other repository's dependency permission or every comment permission. Qualify those paths instead of filling gaps by assumption. Project access does not expose a private issue to someone lacking repository read. A project-team link alone supplies Read; grant Write separately for normal team work.

## 8. Source and review references

The [original standard](engineering/review/sources/rewrite-2026-11-19/issue-standards.md.txt) preserves migration history, retired labels, configuration snapshots, issue counts and the complete source permission matrix. The [rewrite review](engineering/review/rewrite-review.md) records review decisions, evidence and remaining tooling gaps.

Use [Google's guidance](https://developers.google.com/style/highlights) for clear published prose. Architecture content and design decisions belong in the [model architecture](architecture/issue-data-model/index.md), with decision companions and delivery references, rather than repeating implementation chronology here.
