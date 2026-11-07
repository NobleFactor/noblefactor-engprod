---
title: "Open decisions for review"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Open decisions for review

O01–O11 have been resolved through the Owner’s written responses and subsequent review. Each resolution is recorded below; original questions and responses are retained as history. Configuration, enforcement and tool selections remain later topics. Resolution of these questions does not by itself establish that all source documents and executable templates have been fully reconciled.

## O01 — Scope of PR serialization

**Resolved:** One active PR per worktree. Independent workers may proceed concurrently in their own worktrees. During integration, only review or CI corrections belong in that worktree. Workers must not modify one another’s worktrees. The earlier question and Owner response below are retained as review history.

The existing rule permits one PR in flight and no writes to any repository while it runs. The intended workflow has parallel isolated workers. Decide whether serialization applies to the whole operation, each worker, each repository or an integration phase. Until resolved, the draft does not grant a new concurrency exception.

[david-noble] This rule applies to git worktrees created to close on work items. We don't want two PRs active against the same worktree. An engineer is not likely to do this on his own, but an agent might do this thinking it will accelerate the process. In my experience it does not. In short, then we have:

- **A single clone** (the primary worktree) on a specific branch. This is usually the default branch. It is always the target branch for each worktree an engineer or agent creates. The clone is read-only to agents.
  
- **Many work trees** (the secondary worktrees) on branches and worktrees named for the work items it will close. These worktrees should be removed as soon as the PR that closes these work items is complete. The worktrees are read/write. Agents working different schedules should stay in their own worktrees. Messing with someone else's worktree is a serious breach of process.

In summary, we create worktrees off the target of a PR. A worktree is the unit of work for a PR. Worktrees are many-to-one with an agent. Worktrees may resolve one or more work items on that agent's schedule. Agents should stay away from one another's worktrees.

## O02 — Process work classification

**Resolved:** Product and engineering work share Epic → Feature → Task/Bug. Distinguish purpose through epic or area. Most engineering-productivity issues belong in NobleFactor/noblefactor-engprod; other repositories can use their own epic, with engprod recommended where appropriate. The former chore tier is superseded; migration of existing issues and schedule-container metadata is deferred. Commit/branch conventions are not changed by this decision. The earlier question and Owner response below are retained as review history.

The approved description emphasizes bugs/tasks shaping features in epics. The current hierarchy also has chores as peers of features, with process tasks and bugs under them; schedule issues themselves are special chores. Decide whether to retain that process-work model. Do not silently recategorize issues.

[david-noble] The distinction between chores and features is a distinction worth discussing. I devised that classification to distinguish process/tooling issues from product issues. In my mind we have three things to worry about when developing software: people, product, and process. Tools support the whole.

In my mind there's a big difference between work items that shape the product, and work items that serve the people, product, and process. Here are the questions I'd like to answer:

- What work brings me closer to shipping? That's the work captured by a feature in our current scheme.
- What work is helping us to move faster by reducing friction while improving quality, and measuring progress? That's the work capture by a chore in our current scheme.

We might do this with a more obvious classification scheme that shows:

- How much are we investing in the way we work? Is that a chore, a feature in an area, a feature in an epic dedicated to engineerring efficiency, or something else?
- How much are we investing in product development? That, I can be clear about. We have epics, feature, and work items (bugs and tasks).

Let's resolve this interactively.

## O03 — Completion, closure and plan status

**Resolved:** PR readiness means all included issues are implemented, documented, tested and reviewed. Issue completion additionally requires agreed merge, deployment and verification milestones. CI, lint and Owner visual code inspection are required; additional testing is negotiated among Participants, Reviewers and the Owner and reported in the PR. A plan remains active until all agreed completion milestones are satisfied, including required post-merge deployment or verification. The final implementation commit records implementation readiness rather than whole-plan completion. The GitHub issue remains open until all agreed completion milestones are satisfied and completion is approved by the Owner or covered by explicit unattended-progression authorization. When post-merge obligations remain, the PR references the issue without automatically closing it. Record post-merge results immediately on the issue, then incorporate them into the plan through a documentation-only follow-up PR. That PR uses lightweight validation of documentation-only scope, document formatting, metadata and links, without builds, code linting or functional tests. Required checks must report a result rather than remain pending. GitHub configuration and tooling implementation are deferred. Earlier discussion below is retained as history.

Separate milestones and issue-specific completion criteria are approved. The old requirement to resolve all issues before opening a PR cannot mean demonstrating that future PRs merge. The old final-commit plan-completion rule also conflicts with post-merge obligations. Decide readiness wording, GitHub closure timing, and where/how post-merge plan updates are committed. Do not equate GitHub auto-close with approved completion by default.

[david-noble] I think that what we must do is remove all conflicts regarding what I think is a well articulated policy. My hunch is that the conflicts evolved over time as my workflow gelled. Briefly, we have two levels of completion criteria:

- `Schedule`
- `Work item`

PRs close one or more work items in a schedule. You need to pass CI. Adhoc testing outside CI is negotiated between participants, reviewers, and the owner. The results are reported in the PR. I am hardcore about compliance with coding standards and matters of style. I will not compromise on those and yet I find that agents want desperately to avoid compliance. You must pass lint and my visual inspection of the code. Agents should know that they are not done until the code reads like a book. See Knuth's book on Literate Programming. See Kernighan and Plauger's book on the Elements of Programming Style. The latter has been my inspiration since the late 70's when I first developed an interest in programming.

Let's resolve this interactively.

## O04 — Git grants and bounded execution

**Resolved:** The Owner may explicitly grant a worker bounded authority to commit and push its assigned branch within its own worktree. The grant excludes changes to other worktrees, protected branches, repository configuration and destructive history operations. Verify sandbox enforcement separately before relying on it. Without such a grant, exact-command one-use approval remains the fallback. PR execution authority remains separate. The earlier question and Owner response below are retained as review history.

Single-use exact-command permission is retained for owner-supervised agents. The controller and unattended workflow may need a different bounded authorization model. No such expansion has been assumed; discuss its necessity and limits explicitly.

[david-noble] We are moving to sbx as a way of protecting ourselves from rogue agents getting careless with git commands. If agents were accountable we would need no such rules. If setting permissions were easier in products like Claude Code we might prefer them to the rules I've put in place.

I am hoping that sbx will give me the confidence I need to know that my agents are committing and pushing often, and that they cannot mess with anything outside their worktrees. I think sbx is the sandbox I need.

Thoughts?

## O05 — Accurate assistance disclosure

**Resolved:** Use `Signed-off-by:` for the accountable human and `Assisted-by: <agent name>` for the agent submitting the PR. Attribution for every agent consulted during review is not required. Earlier discussion and the Owner response below are retained as history.

Contribution terms and templates literally name Claude Code. Decide how to record actual assistance when Codex or several agents contribute, retaining sign-off, disclosure and no false co-authorship. Do not falsely name an assistant to satisfy a literal template.

[david-noble] I say that we credit Codex whenever credit is due. Codex is an engineer's reviewer. You participate by assisting engineer's in design. As owners the enineers are accountable. Agents are not accountable and therefore can only ever be listed assistants. We might change this if there ever comes a day when I can reward or punish an agent for their performance. With adequete regulation, perhaps their owners are the ones who will pay for an agent's mistakes. Until that day arrives we stick with the taglines I use for Claude.

A PR is the unit of work that we credit. We do that for the benefit of people (not machines) that contribute. They should know when an agent is involved. 

We do not credit as a way of promoting an agent's masters. We're not an ad machine for Anthropic, Open AI, or any other business entity. We might keep it simple by saying an agent gets credit for assistance when its the agent that submits a PR. I don't want to haggle over whether say Codex gets credit on the PRs it reviews for Claude.

## O06 — Signing intent

**Resolved:** Working-branch commits may be unsigned. Commits landing on `main` and `release/*` must be signed; `develop` is not included in the required-signing boundary. Personal repositories are exempt from this signing requirement. This precise boundary supersedes the preliminary broader wording about release inclusion. The Owner supplied a GitHub ruleset example with `required_signatures` and branch conditions for `refs/heads/main` and `refs/heads/release/*`. Actual configuration and merge-path verification remain deferred. Earlier discussion and the Owner response below are retained as history.

The release guide requires all commits signed and specifies certificate roles; the protection document describes main-only signing enforcement. Decide normative signing scope separately from later configuration verification.

[david-noble] It's early for this one. We do want to sign the commits on a release. Let's step through the process together and make a call.

## O07 — Visibility and intervention contract

**Resolved:** Execution outside an assigned worktree or collaboration across worker boundaries requires Owner direction. Agents may advise or recommend actions but may not execute them without that direction. Sub-agent delegation within approved work remains permitted. The approved visibility and bounded-conversation requirements remain; monitoring mechanics are a tooling concern. Earlier discussion and the Owner response below are retained as history.

Always-available monitoring, full approved conversations and owner knowledge are approved. Define the documentation-level record/notification expectations for ordinary actions, failures and delegation, and what intervention means for already running work. Tool mechanics follow later. Visibility must not be reduced to an after-the-fact summary.

[david-noble] This, I feel, is a tooling issue more than a process issue. My greatest concerns are:

- Work being done outside a worktree: Execute on orders from an engineer. An agent may advise or recommend actions. An agent may not execute without direction from the owner.

- Work being done through collaboration with another agent: Execute on orders from an engineer. An agent may advise or recommend actions. An agent may not execute without direction from the owner.

Sub-agents are a different matter. An agent may initiate as many sub-agents as it wants. With the right sandbox, I think we'll be fine.

Thoughts?

## O08 — Bash helper applicability

**Resolved:** Maintained Bash tooling follows the Bash standards, whether product tooling or engineering-productivity tooling. Temporary agent execution scripts need not follow maintained-tooling conventions. Generated PR scripts follow the dedicated template and are exempt from sourcing Declare-BashScript. Product-distributed scripts may ship the helper or embed its source, in whole or in part; embedding is encouraged where appropriate, as in devlore-cli’s install.sh. Detailed Bash standards remain separate tracked work. Earlier discussion and the Owner response below are retained as history.

The shared requirement says every Bash command sources Declare-BashScript, except hooks; existing generated PR scripts do not. Decide whether PR scripts are an explicit exception or must adopt the helper. Do not normalize either implementation as policy by copying it.

[david-noble] We have an issue for tracking the work on Bash scripting standards. The standards apply broadly to tooling (product tooling or engineering productivity toooling). I do not care how an agent writes the scripts it needs to do its work.

Most engineering productivity Bash scripts are written when we feel some process pain. They are sometimes written out of necessity, but not often.

Bash scripts that ship with the product are much less common. We have, for example, devlore-cli's `install.sh`. I don't think we have any others. Their use of Declare-BashScript is different. Products can ship `Declare-BashScript`, but they are encouraged to copy the source for Declare-BashScript in whole or in part as devlore-cli's `install.sh` does.

## O09 — Scope of greenfield policy

**Resolved:** The greenfield policy applies to DevLore: devlore-cli, devlore-registry and devlore.noblefactor.com. Do not accommodate superseded development behavior. Other repositories require case-by-case Owner decisions. Agents must not assume compatibility is required; pause affected work when a compatibility question is discovered and obtain an Owner ruling. Earlier discussion and the Owner response below are retained as history.

No-compatibility requirements appear in devlore-cli and the shared Go guide. Determine their scope before presenting them as organization-wide product policy.

[david-noble]

We are working really hard to release a minimally viable product. It is new from the ground up. The greenfield policy applies to that product: DevLore. I do not want contributors to accommodate prior behaviors. DevLore, including devlore-cli, devlore-registry, and devlore.noblefactor.com are the repos to which the greenfield policy applies.

The greenfield policy needs to be considered on a case-by-case basis for any other repos. If an agent discovers a backward compatibility issues, it should inform the owner who should render a decision. An agent should never assume that backward compatibility is a requirement. An agent should pause when it discovers a backward compatibility issue and allow the owner to render a ruling.

## O10 — Duplicate schedule membership

**Resolved:** No two schedules may contain the same work item. Overlap in affected code, features or dependencies is distinct from duplicate work-item membership. Coordinate transfers and keep affected workers informed. Earlier discussion and the Owner response below are retained as history.

The old standard calls unique live membership a future check; the accepted workflow permits overlapping schedules and requires coordination. Decide whether the exact same issue can belong to two live schedules, and how execution responsibility is made unambiguous if it can.

[david-noble] We have an issue tracking spec. You might find and read it. I've got a session dedicated to addressing it. I paused that agent pending the update that this work will bring. In short, it should be true that no two schedules should hold the same work item.

We can discuss this with the agent responsible for issue tracking after these documents are adopted as policy.

## O11 — Changing the shape of work

**Resolved:** Support creating schedules, adding work items, recording discovered issues for triage, and coordinated transfers between schedules. Retain Owner approval for committed schedule changes and the communication boundaries. Update affected records and inform workers so changes to their missions are not surprises. Treat reshaping work as normal, not a planning failure. Tool implementation remains deferred. Earlier discussion and the Owner response below are retained as history.

The owner's philosophy requires changes to work to be easy. Existing wording says discovering a needed split is a planning failure, while new decisions explicitly permit approved splits and amendments. This draft removes the characterization of change as failure, preserves approval boundaries, and makes amendments first-class records. Confirm whether further changes to the review/approval flow are needed to support churn without excessive overhead.

[david-noble] I am hopeful that the new issue tracking system will enable us to easily triage, schedule work, and reschedule work by creating, updating, and removing work items as we go. Our requirements in this area will shape the issue tracking system. What I know is that we must be able to:

- Create a schedule
- Add work items to a schedule.
- Log an issue and submit it to triage.
- Move a work item from one schedule to another in a coordinated fashion.

The latter will require communication between active agents. We do not want an agent to be surprised by changes to its schedule.

## Deferred implementation questions

Which GitHub fields are authoritative; assignment metadata precedence; report schema/headers; required checks and actual protection; read-only enforcement; approval/event storage; adapters and controller/monitor product capabilities. These are not settled by the documentation tree.
