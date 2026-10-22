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
