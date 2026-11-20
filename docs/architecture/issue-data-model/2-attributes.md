---
title: "Issue attributes"
status: draft
updated: 2026-11-19
---

<a id="2-attributes"></a>

# Issue attributes

[Up: Issue data model](index.md)

Attributes describe an issue independently of the project holding it. They stay with the issue when it moves. Type and parent define its hierarchy; Step and Beat describe positions within collections.

<a id="the-attributes"></a>

## 1. Attribute contract

| Attribute | Applies to | Values | Cardinality |
| --- | --- | --- | --- |
| Severity | Every typed issue; measures harm only for Bugs | Critical, High, Medium or Low for Bugs; N/A otherwise | Exactly one after classification |
| Priority | Every type | Urgent, High, Medium, Low | At most one |
| Area | Every type | Product, Engineering | Exactly one |
| Effort | Every type where recorded | High, Medium, Low | At most one |
| Target date | Organization issue metadata | A date | Optional |
| Resolution | Closed issues whose work was not done | Declined, Duplicate, Invalid | At most one |
| `good first issue` | Task or Bug | Present or absent | Optional label |

Start date is unused; issue history records when work starts. Priority and Area apply to Schedules and Scenarios as well as the product hierarchy. The [hierarchy](1-hierarchy.md) defines Type and parent requirements.

### 1.1 Severity

Severity measures the harm a Bug causes: what the impact is if it occurs. A Task has Priority, not a harm rating. When preventive work addresses a Bug, the Bug records the harm and the Task takes its Priority from that work.

| Severity | Meaning | Display color |
| --- | --- | --- |
| Critical | Data loss, corruption or a security failure | Red |
| High | A supported path is broken with no workaround | Orange |
| Medium | Broken with a workaround, or a narrow path | Yellow |
| Low | Cosmetic, or a defect nobody is hitting | Green |
| N/A | The issue is not a Bug | Gray |

A Bug must not have N/A or a blank Severity. Every other typed issue has N/A. An untyped intake issue has no Severity until classification.

The Triage workflow preserves an existing Severity. On opening, it supplies Medium for a Bug, N/A for another type and no value for an untyped issue. Triage adjusts a Bug's Severity to match its harm and sets Severity when an issue receives its type after opening. Filing through the issue command must establish the corresponding value.

The Medium default belongs to filing and workflow behavior, not to an assumed field default. Preserve field-option identities when applying model changes; [Model resource and synchronization](6-the-asset-and-its-sync.md) owns that contract.

### 1.2 Priority

Priority determines when the team acts. Triage sets it; a Scenario does not automatically change it. Select Backlog work for a Schedule highest Priority first, subject to the Schedule Owner's approved commitment.

Views should expose the authoritative Priority representation. An organization Backlog can sort its issue field directly. The user-account representation uses labels; do not imply that a project Priority field carries the same issue-level value.

### 1.3 Area

Area describes the issue's own work. Product and Engineering are its only values. An issue does not inherit Area from its parent: a CI Bug under a product Feature is Engineering.

[Product and engineering](../../issue-standards.md#product-and-engineering) defines those categories and containment rules. Architecture work is a Task or Feature within the product hierarchy; a defect is filed against the affected Feature. Release notes use closed Product issues in the release rather than infer Area from their ancestors.

A blank Area is an error at filing, during triage and in later validation. Forms ask for it; the repository workflow copies the answer into the issue field or label. `star github issue open` must refuse a missing Area even when the form cannot enforce it. Triage exposes Area and a Missing Area view, and must resolve it before moving an issue out.

### 1.4 Good first issue

Use `good first issue` only on Tasks and Bugs suitable for a newcomer. An Epic or Feature is a body of work, not the single piece of work that this label offers.

<a id="labels-carry-no-values"></a>

## 2. Account representations

Organizations use native issue fields for Priority, Effort, Target date, Resolution, Area and Severity. The user-account representation uses lowercase labels for single-select attributes.

| Field | User-account labels |
| --- | --- |
| Priority | `priority:urgent`, `priority:high`, `priority:medium`, `priority:low` |
| Severity | `severity:critical`, `severity:high`, `severity:medium`, `severity:low`, `severity:n/a` |
| Effort | `effort:high`, `effort:medium`, `effort:low` |
| Area | `area:product`, `area:engineering` |
| Resolution | `resolution:declined`, `resolution:duplicate`, `resolution:invalid` |

A label is an opaque name: GitHub does not infer that `priority:high` and `priority:low` belong to one mutually exclusive field. Validation must enforce at most one label from each family, with the stronger required-value rules for Area and Severity.

Do not maintain duplicate label attributes alongside the organization's issue fields. A project field is also no substitute: its value belongs to one row and does not follow the issue between projects. A date has no label equivalent; Target date therefore has no user-account counterpart.

The account model records organization fields and their option IDs, or the user account's per-repository label definitions. Corresponding labels use the option's meaning, description and color. The `severity:n/a` label uses color `cfd3d7` and description `Severity: not applicable, the issue is not a bug`.

<a id="why-an-issue-was-closed"></a>

## 3. Resolution

Resolution explains why a closed issue's work was not done: Declined, Duplicate or Invalid. Use the native field in an organization and the corresponding `resolution:` label in a user account.

Close such issues with GitHub's completed state reason and the explicit Resolution. Do not use `not_planned` as a substitute. Work completed normally has no Resolution. An open issue must not carry one; reopening must restore that invariant.

Declining an issue during triage follows this same contract. Collection closure and reopening use the command-specific rules in [Schedule commands](8-the-schedule-commands.md), [Scenario commands](9-the-scenario-commands.md) and [Issue commands](10-the-issue-commands.md).

## 4. Validation and sweep

The sweep contract checks open issues for missing Area, missing Evidence of completion except on Scenarios, invalid Severity, Resolution on an open issue, conflicting attribute labels and invalid use of `good first issue`. It also checks classification and collection structure.

Epics and Features are permitted in Backlog and prohibited in Schedules and Scenarios. An issue belongs to at most one managed project across the account and at most one Schedule or Scenario.

While a finding remains in a Scenario, the sweep applies only those two collection-structure rules. The other checks wait until the finding moves out and is classified. The [hierarchy](1-hierarchy.md#34-validation-and-sweep) records the unresolved handling of conflicting Scenario and Schedule memberships.

The sweep runs daily through the account's shared workflow credentials, comments with the violated rule and returns affected issues to Triage. It does not block filing, silently correct issues or remove Triage rows. Triage owns corrective decisions. [Classification rules](../../issue-standards.md#well-classified) list the complete requirements; implementation and rollout evidence belong in the plans.

<a id="not-attributes"></a>

## 5. Related concepts and decisions

Step and Beat are collection coordinates, defined in [Collections](3-collections.md). Type and parent define the [hierarchy](1-hierarchy.md). Assignees identify accountable people; team and project ownership and access belong to [Storage and access](4-storage-and-reach.md).

The [decision companion](2-attributes.decisions.md) explains field ownership, label fallback, Severity and Resolution choices. The retained [delivery reference](2-attributes.status.md) points to implementation and source evidence.
