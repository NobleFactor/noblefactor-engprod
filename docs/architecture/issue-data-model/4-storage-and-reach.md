---
title: "4. Storage and reach"
---

# 4. Storage and reach

Where each part of the model lives in GitHub, what enforces it, and which repositories it reaches. Reach is the
deciding question, because the organization's features stop at the organization's repositories and personal is not
one of them.

## What reaches personal

Read with `gh api graphql` on 2026-10-21, read-only:

| | NobleFactor/noblefactor-ops | David-Noble-at-work/personal |
| --- | --- | --- |
| The viewer can see issue fields | yes | no |
| Issue fields | 4: Priority, Effort, Start date, Target date | none |
| Issue types | Task, Bug, Feature | none |
| One issue's field values | read (#301) | a server error (#259) |

The viewer was David-Noble-at-work, who owns personal and is an admin of NobleFactor. A write test, setting
NobleFactor's Priority on personal#259, was not run. What reaches personal from the organization is projects: a
NobleFactor project held personal#259 as a row, with a custom field set on it, on 2026-10-20.

## Where each part lives

| Part | Where it can live | What GitHub enforces | Reaches personal |
| --- | --- | --- | --- |
| Type | GitHub's issue type (ruled 2026-10-22) | one value per issue | no |
| Parent | GitHub's sub-issue link (ruled 2026-10-22); the `**Feature:**` and `**Chore:**` markers until the link is shown to cross | sub-issue: one parent | sub-issue across repositories or owners: unverified. Marker: yes, as text |
| Severity, Priority | GitHub's issue fields, or labels | issue field: its type, and one value | issue field: no. Labels: yes |
| Area, `good first issue` | labels | nothing | yes |
| A thread's or a schedule's rows, lanes and status | a project's rows and fields | the field's type | yes, seen 2026-10-20 |
| Waits on | GitHub's blocked-by link | the link | across repositories: unverified |
| A collection's deliverable and rulings | its own issue's body, or the project's README | nothing | not applicable |

## Where each part is defined

The owner, 2026-10-22: "I would like as much as possible to be drawn from the org: NobleFactor by default. We then
look to teams, and finally repositories." GitHub gives the three levels different powers, so the split follows what
each can hold: the organization defines, a team owns and is granted, a repository carries.

| Part | Defined at | In the asset | Reaches a repository by |
| --- | --- | --- | --- |
| Issue types and their levels | the organization, nowhere else | `types` | GitHub, every organization repository |
| Projects: the Schedule and Thread templates, the Triage project, their fields | the organization | `projects` | rows, any repository including personal |
| Who owns a collection; who triages | a team: project roles for ownership, the Triage repository role for the triage team | `teams` | GitHub's permissions |
| Labels: attributes, `Epic:<Name>`, `Thread:<Name>` | a repository only; GitHub has no organization label, just a default set that seeds a new repository once | `labels`, in three tiers | `push` |
| Issue templates and forms | a repository, or the organization's `.github` repository as the default | not in the asset | GitHub's fallback |

A team on GitHub holds rights, not definitions: it cannot be assigned an issue or own a label, but it can own a
project and hold the Triage role. So "look to teams" is where ownership and access are looked up, and the triage team
of the plan's question 4 is a GitHub team with that role. Labels, having no organization home, get the precedence in
the asset instead: a push to a repository takes the organization's tier, then its teams', then its own; a lower tier
may add and may not redefine a name from above, and the audit reports a repository label that shadows one. Personal,
with no organization and no team, takes the organization tier and its own.

**Nothing records which repositories participate.** An organization custom property, `issue-model`, was proposed on
2026-10-22 to mark participating repositories and to version the model, and set aside the same day: "Versioning is
too complex. If we edit in GitHub, the tooling picks up whatever it picks up from every participating repository. I
don't think we need to worry about who's participating. We ask that question when we need to know: when building and
reporting on schedules and threads or creating a new issue." So a repository is in when something names it: a
schedule's lane or a thread's row that lives there, an issue being filed there, or `--repo`. The tooling reads
whatever those repositories hold, and there is one model, changed for everyone at once through `pull` and `push`.

**Participation is proven when it matters, never declared.** The owner, the same day: "We do want to be able to say,
hey, you aren't participating so I cannot create a task for developing a feature or doing a chore to complete an
epic, and put it on my schedule. Why? Because this repo is not participating. I might save the digest or an etag to
ensure we've got reason to believe that you're really participating and not yanking my chain." So when an issue is
about to be filed in a repository, or one of its issues about to become a row, the tooling reads that repository's
record and compares it with the asset: the labels it must carry, by tier, are there. If they are, it is participating
and the filing or the row goes ahead; if not, the refusal names the repository and says `push` first. How the check is
kept cheap is [section 6](6-the-asset-and-its-sync.md) § Participation.

## Labels

A label belongs to one repository; GitHub has no organization label. The labels file, `labels.yaml` in the issue-labels
design (NobleFactor/noblefactor-ops#320, approved 2026-10-19, still on its branch), defines each label once, and
`star gh labels sync` puts it in every repository the scheme covers. The owner, 2026-10-21: "My thinking is that our
labels are defined and stored as yaml assets in noblefactor-ops."

## The choice it turns on

Ruled 2026-10-22: "we are building a 3-tier hierarchy modeled with the parent-child relation between issues, so yes. Our hierarchy is based on epics that contain chores and features that contain bugs and tasks. It is a very specific hierarchy based on Issue Type." So Type is GitHub's issue type and the parent is GitHub's sub-issue link, both of them
organization features. Neither reaches personal, and for personal the owner ruled the same day: "Star gh offers
directed syncs. Person[al] will need to sync if it wants to participate." So:

- **GitHub's own types and links in the organization's repositories, labels in personal.** The organization's record
  is the truth; `star gh` syncs it one way into personal's labels, as `star gh labels sync` already syncs the label
  set. The audit reads personal's labels as it reads the organization's types, and reports where the sync has not
  run.
- Not taken: moving personal's tracked work into an organization repository.

The sub-issue link is in use within noblefactor-ops since 2026-10-20. Whether it crosses into another repository, or
another owner's, is unverified, and the write test settles it (the plan's question 13); until then the markers remain
the cross-repository form, as the standard states them since #370.

## What the audit does

GitHub enforces none of the model's rules over labels: one Type, the level a parent sits on, Severity only on a bug, at
most one Severity or Priority, a lane number on every schedule row. The audit checks each and reports what breaks;
a person rules on the report. It does not correct an issue by itself: when an issue carries two Types, which is right
is a judgment, and a tool that picks one hides the fault. The Gemini write-up's loop that corrects the remote state by
itself is therefore not adopted.
