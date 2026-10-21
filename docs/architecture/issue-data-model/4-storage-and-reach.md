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
| Type | GitHub's issue type, or a label family | issue type: one value per issue | issue type: no. Labels: yes |
| Parent | GitHub's sub-issue link, or the `**Feature:**` marker in the body | sub-issue: one parent | sub-issue across repositories or owners: unverified. Marker: yes, as text |
| Severity, Priority | GitHub's issue fields, or labels | issue field: its type, and one value | issue field: no. Labels: yes |
| Area, `good first issue` | labels | nothing | yes |
| A thread's or a schedule's rows, lanes and status | a project's rows and fields | the field's type | yes, seen 2026-10-20 |
| Waits on | GitHub's blocked-by link | the link | across repositories: unverified |
| A collection's deliverable and rulings | its own issue's body, or the project's README | nothing | not applicable |

## Labels

A label belongs to one repository; GitHub has no organization label. The labels file, `labels.yaml` in the issue-labels
design (NobleFactor/noblefactor-ops#320, approved 2026-10-19, still on its branch), defines each label once, and
`star gh labels sync` puts it in every repository the scheme covers. The owner, 2026-10-21: "My thinking is that our
labels are defined and stored as yaml assets in noblefactor-ops."

## The choice it turns on

Type, and Severity and Priority with it, can live three ways (the plan's question 1):

- **Labels everywhere.** One mechanism, in every repository, personal included. GitHub enforces nothing; the audit
  enforces one Type, at most one Severity, at most one Priority.
- **GitHub's own fields in the organization's repositories, labels in personal.** GitHub enforces where it reaches,
  and star keeps two records of one fact in step, which is the kind of record that drifts.
- **GitHub's own fields everywhere,** with personal's tracked work moved into an organization repository. Nothing to
  sync and nothing for the audit to enforce, but personal changes.

The parent link is the same choice for edges: GitHub's sub-issue link is enforced and visible in GitHub's own views,
and the marker is text that crosses anything. Which repositories the link can cross is unverified, and a write test
settles it (the plan's question 13).

## What the audit does

GitHub enforces none of the model's rules over labels: one Type, the level a parent sits on, Severity only on a bug, at
most one Severity or Priority, a lane number on every schedule row. The audit checks each and reports what breaks;
a person rules on the report. It does not correct an issue by itself: when an issue carries two Types, which is right
is a judgment, and a tool that picks one hides the fault. The Gemini write-up's loop that corrects the remote state by
itself is therefore not adopted.
