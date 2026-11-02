---
title: "7. The workflow, before and after"
---

# 7. The workflow, before and after

Why this epic: what a session does today to file an issue, write a schedule and report progress, and what it does
once the model and its tooling are in. The owner, 2026-10-22: "Today, I ask you to create my issues, add them to your
schedule, and report progress. You do that with some guidance, some skills, and some tooling: star gh. How does this
change your workflow?" The plan, the branch, the pull request and the sign-off do not move. Three things do.

## Filing an issue

| | Before | After |
| --- | --- | --- |
| The kind | a label the session picks and types | the issue type, one argument to `star github schedule create`, set by GitHub |
| The parent | a `**Feature:** #N` or `**Chore:** #N` marker written into the body, the last one in the body winning | the sub-issue link, one argument, set by GitHub, refused unless the parent is one level up |
| The epic | an `Epic:<Name>` label the session must know and type | the parent's parent, read, never written |
| The attributes | labels typed by name | arguments, checked against the asset |
| The documents table | written by hand; `grep -q '^## Plan and design documents'` in the filing script, because it was once forgotten ([agent-rules.md](../../guides/agent-rules.md) rule 15) | checked by the command before it writes |
| A repository that does not participate | nothing stops the filing; the issue is unplaced in the next report | the command refuses before writing, names the repository, and says `push` first ([section 6](6-the-asset-and-its-sync.md) § Participation) |
| What it costs | a body composed by hand, three labels, a marker, a table and a grep, and a report afterwards to see what went wrong | one command that will not let the session get it wrong |

The permission does not change: filing is a write to GitHub, and it runs as `gh issue create` runs today, by the owner
or under a grant.

## Writing a schedule

| | Before | After |
| --- | --- | --- |
| The schedule | a markdown table in an issue body, edited by hand lane by lane | a project; the schedule's own issue is row 0 and keeps its number, so a session's assignment is read as it is today |
| Adding a lane | an edit to the table, and an amendment above it the session must remember to write | `star github schedule add`, which numbers the row and writes the amendment with it in one act |
| A lane in progress | "in progress in `<worktree>`" typed into the Next cell | the row's Next field set |
| Waits on | a cell of lane numbers | GitHub's blocked-by link between the issues |
| What enforces "no lane without an amendment" | memory | the command |

## Reporting progress

| | Before | After |
| --- | --- | --- |
| The commands | `star github schedule report`, `star github schedule audit` | the same |
| What they read | kind labels, epic labels, the markers in bodies, the lane tables | the type, the sub-issue link, the project's rows; labels and markers second while both exist, then not at all |
| What the audit catches | a missing or doubled label, a missing epic, a marker naming the wrong kind | the same, and every refusal above: a session that filed around the command shows up in the next report |
| What the report rests on | our text inside GitHub's issues | GitHub's own record of them |

## What goes and what stays

Goes from the guidance: the marker form, the kind labels, the lane-table conventions in
[issue-standards.md](../../issue-standards.md), and rule 15's grep. The eight issues proved by marker on 2026-10-21
under noblefactor-ops#370 are the last to be proved that way.

Stays, and gets stronger: [agent-rules.md](../../guides/agent-rules.md) rule 3, a question about issues is answered
by the report, because the report reads GitHub's record rather than our text in it. And the process around the
work: an issue, a branch from it, a plan committed on the branch and reviewed, the work, one pull request at a time
that discloses AI and is signed off.
