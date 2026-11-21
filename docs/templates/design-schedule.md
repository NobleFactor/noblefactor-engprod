---
title: "Design schedule template"
status: draft
created: 2026-11-20
updated: 2026-11-21
---

# Design schedule template

[Up: Work templates](index.md)

Use this content guide for the two Tasks in every [design schedule](../engineering/work-organization.md#design-schedules). Replace {subsystem}, scope, ownership and artifact locations with the approved values. The account's Schedule and Task forms own field labels and required sections; this guide supplies their content. The [Start a design schedule skill](../../skills/start-design-schedule/SKILL.md) applies it through the supported commands.

## 1. Schedule outcome

**Name:** {subsystem} design.

**Before:** The problem and scope are understood, but the subsystem's design and route to delivery are not accepted.

**After:** The Owner has accepted design documents, Architecture decisions and a roadmap that give the Planner sufficient input to propose implementation issues and schedules.

Identify the repository, related Epic, design enabler Feature, Owner, Designer, review assignments and expected document locations. Use the [Schedule template](schedule.md) for the remaining schedule fields. Begin design directly from the approved assignment; no plan for writing these assets is required.

### 1.1. Design enabler Feature

**Type:** Feature. **Title:** {subsystem} design. **Native parent:** The related Epic.

**Purpose:** Provide the understanding and decisions needed to define and build the subsystem's future capabilities. Use the [enabler-feature convention](../issue-standards.md#enabler-features); enabler describes purpose, not a new issue type.

**Completion evidence:** The design, Architecture decisions and roadmap are technically reviewed, audited for compliance, approved by the Owner and merged. The Feature's own completion review checks these assets. Closing its Tasks alone does not replace that review.

| Issue Type | Example title | Native parent | Execution |
| --- | --- | --- | --- |
| Feature | Evidence archive design | Related Epic | Retained in Backlog |
| Task | Design the Evidence Archive subsystem and record its Architecture decisions | Evidence archive design Feature | Evidence archive design Schedule |
| Task | Produce the Evidence Archive roadmap | Evidence archive design Feature | Evidence archive design Schedule |

## 2. Design and Architecture decisions Task

**Title:** Design {subsystem} and record its Architecture decisions.

**Problem and scope:** Define the wanted subsystem within the agreed problem and boundaries. Explain components, interfaces, data flows, integrity, security, recovery, quality goals and important interactions. Apply relevant [arc42 content](design.md). Identify assumptions, dependencies and unresolved choices with the evidence needed to resolve them.

**Outputs:** One or more design documents and their [Architecture decisions](../standards/documentation.md#architecture-decisions). Each significant choice has an architecture decision record (ADR) explaining context, alternatives, reasons, status and consequences.

**Evidence of completion:**

- [ ] The documents explain a coherent system and address the agreed scope.
- [ ] Significant choices are supported by ADRs; assumptions and unresolved choices are explicit.
- [ ] The roadmap uses the same boundaries, capabilities and constraints.
- [ ] Technical review and compliance findings, their corrections and rechecks identify the final revision on the introducing PR.
- [ ] The Owner approved the deliverables and the PR merged; the issue links that PR and the delivered documents.

## 3. Roadmap Task

**Title:** Produce the {subsystem} roadmap for planning.

**Problem and scope:** Turn the design into useful delivery increments. Identify capabilities, dependencies, acceptance evidence and unresolved choices that the Planner needs to prepare implementation work.

**Outputs:** A roadmap linked to the design and Architecture decisions. Explain the purpose and observable result of each increment, prerequisites, significant risks and questions requiring a decision. Keep detailed implementation steps in later issue plans.

**Evidence of completion:**

- [ ] Capabilities and increments trace to the design, with dependencies and acceptance evidence.
- [ ] The first useful increment and unresolved choices are clear enough for the Planner to propose work.
- [ ] Technical review and compliance findings, their corrections and rechecks identify the final revision on the introducing PR.
- [ ] The Owner approved the roadmap and the PR merged; the issue links that PR and the delivered document.

## 4. Relationships and handoff

Both Tasks have the design enabler Feature as native parent and join the same design Schedule. The Feature has the related Epic as its native parent and remains in Backlog. They are not native children of the Schedule issue. Record real dependencies; the roadmap may evolve alongside the design. Do not add a blocking relationship merely because the Tasks have an order.

Use the account's required Plan and design documents table. For these Designer deliverables, its plan row says “Not required: Designer deliverables”; include design, Architecture decisions and roadmap links as applicable. Use the [document-link rules](../engineering/work-assets.md#document-formats-and-links) for pending assets and committed review revisions.

One PR can deliver both Tasks, using closing references only for the Tasks it completes. [Completion and progression](../engineering/process.md#completion-and-progression) governs acceptance, closure and evidence. Keep external review and audit text on the PR, outside repository commits.

The completed handoff identifies the accepted asset revisions, capabilities, dependencies, open choices and first useful increment. The Planner prepares implementation issues, plans and schedules and remains available as a planning consultant.
