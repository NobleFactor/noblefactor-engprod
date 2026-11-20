---
title: "Issue hierarchy decisions"
status: draft
updated: 2026-11-19
---

# Issue hierarchy decisions

[Design](1-hierarchy.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-1-hierarchy.md.txt)

## 1. Separate work breakdown from collections

**Status:** Accepted model requirement.

Use Epic → Feature → Task or Bug for product and engineering work. Keep Schedule and Scenario as parentless collection types.

**Reason:** Parent links explain what work belongs together; collection rows explain execution order or a testing walk. A Scenario can exercise several Features without changing their parents.

**Alternative:** Make Schedules or Scenarios parents in the product tree.

**Consequence:** Collection membership and Scenario origin need their own records. A work item's Feature parent remains meaningful after the item changes projects.

## 2. Classify at intake without losing discoveries

**Status:** Accepted model requirement.

Allow unclassified work in Triage and findings in their originating Scenario. Require full classification before committing a finding to a Schedule.

**Reason:** Defects and gaps can be recorded before their correct Feature is known. The team still needs a clear boundary for executable work.

**Alternative:** Require every external report or exploratory finding to arrive fully classified.

**Consequence:** Validation must distinguish the intake exception from completed classification and apply the Scenario sweep exceptions explicitly.

## 3. Keep one managed project membership

**Status:** Accepted model requirement.

An issue belongs to at most one managed project across its account and one Schedule or Scenario. A move transfers membership and records the destination's fields.

**Reason:** The same issue must not appear committed in two places.

**Alternative:** Retain active rows in both discovery and delivery projects.

**Consequence:** Preserve Scenario origin outside active membership. Partial GitHub writes require explicit command failure handling; one user operation is not an atomic API transaction.

## 4. Close Features after independent checks

**Status:** Accepted model requirement.

Finishing child Tasks and Bugs is necessary but insufficient for Feature closure. Require an agent compliance audit, agent code review and team-lead sign-off.

**Reason:** Child closure alone does not establish the Feature's quality or compliance.

**Alternative:** Close a Feature automatically when its last child closes.

**Consequence:** Tooling must not be assumed to enforce the extra gate without evidence. The rewrite's later methodology/tooling scan must check that relationship.

## 5. Preserve conflicting-collection evidence

**Status:** Open implementation choice.

The sweep must detect a Scenario finding that also has another managed project row. Its handling must preserve the evidence and an existing Schedule commitment.

The owning sweep work must define which records are retained or transferred. This rewrite does not choose that recovery policy or claim it is implemented.
