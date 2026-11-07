---
title: "Decisions established in review"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Decisions established in review

These decisions are recorded from the owner's approvals in this conversation. Approval of structure and principles does not imply approval of the draft's exact wording or new proposed fields.

1. Explicitly distinguish requirements for everyone, all agents and owner-supervised agents.
2. A persistent worker session is assigned a schedule and works through its issues.
3. Controller–worker communication is authorized within an approved assignment and observable. Sub-agents may help freely within a worker boundary on approved work.
4. Nothing happens outside the owner's knowledge. Activity must be visible and conversations fully available for live monitoring and intervention.
5. Cross-worker conversation approval covers named participants and a topic until the conversation ends; changing either requires renewed approval.
6. Surface schedule overlap before changing scope, ownership or order.
7. Record implementation, merge, deployment and verification as separate milestones; define which the issue requires.
8. Committed schedule changes require owner approval, including changes needed to address blockers.
9. Preserve blocked work and record its state; abandonment/deletion is an explicit decision.
10. Every scheduled issue records design impact, including an explicit no-change determination where applicable.
11. Plans own execution and verification. Designs own enduring architecture and decisions.
12. Releases and hotfixes follow the shared process with explicit approved exceptions.
13. Organization-wide authority resides in noblefactor-engprod; repository instructions link to it and state local requirements or approved exceptions.
14. Before implementation, the owner understands and approves the resulting design and implementation. Agents challenge assumptions and engage with challenges substantively.
15. Departures from approved commitments pause affected work for explanation and approval.
16. Routine implementation choices preserving approved commitments need no separate approval.
17. Plans define observable acceptance criteria and evidence before implementation.
18. The owner approves issue completion before progression unless explicitly authorizing unattended progression for a defined schedule portion.
19. Unattended progression stops on blockers, necessary departures or insufficient acceptance evidence; other approval requirements remain.
20. Preserve existing requirements unless these decisions change them; mark unresolved conflicts for review.
21. Use issue for scheduled work throughout. The former term appears only in preserved historical sources or discussion of migration.
22. The proposed document structure and ownership split are approved, with the issue terminology change.
23. Preserve the owner's work philosophy in the documentation: “The shape of a job changes. It always changes. The process and tooling we put in place must support the churn. We will have failed, if its hard to change the shape of a job.”

24. Use the RACI role names Owner (Accountable), Reviewer (Consulted), Participant (Responsible), and Observer (Informed). The engineer is the Owner. Agents serve as Observers/Reviewers or Participants. Participants speak their minds, challenge proposals and develop the judgment needed for review; review authority is explicitly entrusted.

25. O01 resolved: one active PR per worktree; independent workers may proceed concurrently in their own worktrees. During integration only review/CI corrections belong there. Do not modify another worker’s worktree.
26. O02 resolved: Epic → Feature → Task/Bug applies to product and engineering work. Purpose is distinguished by epic or area. Most engineering-productivity issues are filed in NobleFactor/noblefactor-engprod; other repositories can use their own epic, with engprod recommended where appropriate. Migration and GitHub representation remain deferred.

27. O03 readiness distinction approved: all included issues must be implemented, documented, tested and reviewed for PR readiness. Issue completion additionally requires agreed merge, deployment and verification milestones. CI, lint and Owner visual code inspection are required; additional testing is negotiated and reported in the PR. Plan-status and GitHub-closure decisions remain open.

28. O03 plan lifecycle approved: the plan remains active until all agreed completion milestones are satisfied, including required post-merge deployment or verification. The final implementation commit records implementation readiness rather than prematurely marking the whole plan complete.

29. O03 issue closure approved: keep the issue open until all agreed completion milestones are satisfied and completion is approved by the Owner or covered by explicit unattended-progression authorization. A PR with remaining post-merge obligations references the issue without automatically closing it.

30. O03 post-merge documentation path approved: record results immediately on the issue and incorporate them into the plan through a documentation-only follow-up PR. Use lightweight validation of documentation-only scope, formatting, metadata and links rather than rerunning builds, code linting or functional tests. Required checks must report a result. GitHub configuration remains deferred.

31. O04 resolved: the Owner may explicitly grant bounded Git authority for a worker to commit and push its assigned branch within its own worktree. It excludes other worktrees, protected branches, repository configuration and destructive history operations. Sandbox enforcement must be verified separately before reliance. Exact-command approval remains the fallback without such a grant; PR execution authority is separate.

32. O05 resolved: retain Signed-off-by for the accountable human and use Assisted-by naming the submitting agent. Attribution for every agent consulted during review is not required.

33. O06 development boundary approved: working-branch commits may be unsigned; commits included in a release must be signed. The exact release-signing boundary remains under review.

34. O06 resolved: required signatures apply to commits landing on main and release/*, not develop. Working-branch commits may be unsigned. This precise branch boundary supersedes decision 33’s preliminary broader release-inclusion wording. GitHub configuration remains deferred.

35. O06 applicability clarified: personal repositories are exempt from the main/release signing requirement. This exception does not alter other workflow requirements.

36. O07 resolved: Owner direction is required for execution outside an assigned worktree or collaboration across worker boundaries. Advice/recommendations alone do not authorize execution. Sub-agent delegation within approved work is permitted. Visibility and bounded-conversation approval requirements remain; monitoring mechanics are deferred to tooling.

37. O08 PR-script exemption approved: generated PR scripts need not source Declare-BashScript; the dedicated platform-specific PR template remains their standard. This preserves the existing template-based approach and its safeguards, rather than making script form arbitrary. Other Bash-standard categories remain with the separate standards work.

38. O08 incorporates the Owner’s full written direction: standards cover maintained Bash tooling; temporary execution scripts need not follow maintained-tooling conventions; dedicated PR templates remain required; product scripts may ship or embed helper source. Detailed Bash-standard development remains separately tracked.
39. O09 resolved from the Owner’s written response: DevLore greenfield scope covers devlore-cli, devlore-registry and devlore.noblefactor.com. Elsewhere, agents pause affected work and seek an Owner ruling on compatibility rather than assuming a requirement.
40. Editorial direction: written review responses establish policy intent. Edit them to publication quality while preserving meaning; ask for further decisions only on substantive ambiguity, rather than repeatedly reconfirming the written answers.

41. Agent writing rule approved: documentation is edited for publication; preserve the Owner’s policy intent while improving prose, distinguish quotes from edited policy, and ask only about substantive ambiguity.
42. O10 confirmed: no two schedules may contain the same work item. Distinguish overlapping concerns/dependencies from duplicate membership.

43. O11 approved: create schedules, add work items, log issues for triage and coordinate transfers without surprising affected workers. Retain Owner approval of committed schedule changes and communication boundaries. Changes in work shape are normal; issue-tracking implementation is deferred.

44. Observer definition clarified: an Observer is an informed stakeholder, not the person or agent monitoring Participants. Monitoring and evaluating Participants is a Reviewer responsibility. Participants develop toward Reviewer duties; Observer is not a promotion. A separate Observer assignment is optional, and the Owner receives updates by virtue of accountability. This clarification supersedes earlier wording that assigned reporting or supervisory duties to Observers.

45. The Owner concurred with the remaining initial-review findings, with the earlier qualifications about existing number-only issue headings and template assignment records. Apply settled-policy/editorial reconciliation, preserve the reviewer’s findings, and bring substantive remaining applicability choices to the Owner separately.

46. Personal repositories follow shared workflow and asset requirements by default, with explicitly Owner-directed exceptions. The personal-repository signing exemption remains separate and does not waive those requirements.

47. PR merge gates approved: refuse merge while required checks, reviews or conversations remain unresolved. Administrative bypass requires separate explicit Owner approval; ordinary script/integration authority does not cover it. Replace routine admin bypass in active template guidance and reconcile both executable forms before use.

48. Canonical-clone integration maintenance requires explicit Owner authorization separate from a worker’s own-worktree commit/push grant. Authorized maintenance does not permit development in the clone; PR cleanup/sync must expose and obtain authority for its clone updates.

49. Function-documentation convention approved for Go and PowerShell: omit Parameters and Returns sections when they have no entries. Apply the same conditional-section rule to exported and unexported functions/helpers.

50. DevLore-specific resource/provider conventions belong to DevLore documentation, linked from the shared Go guide rather than imposed organization-wide. Existing product guides already carry the detail; no edits are made to another task’s worktree. Preserve the extraction and flag product mirror/ownership reconciliation separately.

51. Completion-only documentation follow-ups record established results without creating another delivery milestone or requiring recursive completion follow-ups. They still require applicable documentation validation, review and merge authorization. Substantive changes remain ordinary work.

52. Numbered sections are a hard requirement for published process, plan and design documents. Preserve stable Issue NNN headings and existing incoming links when numbering or restructuring documents.

53. Prose layout approved: each paragraph occupies one source line and visual wrapping belongs to the editor or renderer. Preserve code, tables, list structure and language-specific source/comment formatting.

54. Incident-record destination approved: a GitHub Project owned by the engprod team and associated with noblefactor-engprod. Group recurring errors under stable pattern IDs; agents must recognize prior occurrences. The recommended issue-backed Project/export arrangement is accepted in principle; schema, provisioning, cost accounting and automation are not yet implemented. The Owner is asking focused design questions and will signal when that sequence is complete.
