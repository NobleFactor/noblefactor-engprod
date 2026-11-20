---
title: "Design template"
status: draft
created: 2026-10-28
updated: 2026-11-19
---

# Design template

[Up: Work templates](index.md)

Describe the intended system using the [documentation standard](../standards/documentation.md), [Google's writing guidance](https://developers.google.com/style) and [arc42's content model](https://arc42.org/overview/). Cover these concerns across the architecture set; detail chapters can link the overview instead of repeating it.

<a id="2-purpose-and-resulting-system"></a>

<a id="purpose-and-resulting-system"></a>

## 1. Problem and goals

[Explain the problem, users/stakeholders, required capabilities and most important quality goals.]

<a id="1-role-assignments"></a>

<a id="role-assignments"></a>

### 1.1 Role assignments

[Name the Owner, Participants and scopes, Reviewers and review scopes, and Observers or none. Approved schedule assignments can supply this record.]

Use the [shared responsibility definitions](../engineering/process.md#roles-and-responsibilities).

## 2. Constraints

[State binding technical, organizational and resource limits, with their sources.]

<a id="3-context-and-requirements"></a>

<a id="context-and-requirements"></a>

## 3. Context and scope

[Describe people, neighboring systems, external interfaces, ownership and system boundaries.]

## 4. Solution strategy

[Explain the main approach and how it satisfies the goals and constraints.]

<a id="4-structure-and-behavior"></a>

<a id="structure-and-behavior"></a>

## 5. Components and interfaces

[Describe components, responsibilities, state/data ownership and interfaces. Use a diagram when it clarifies the structure.]

## 6. Runtime and development workflow

[Walk important user actions, component interactions, startup/shutdown, approvals and failure/recovery paths. State actors, actions and observable outcomes.]

<a id="6-operational-consequences"></a>

<a id="operational-consequences"></a>

## 7. Deployment

[Map components to execution environments, machines, storage and network boundaries.]

## 8. Shared concepts

[Explain concepts used across components, such as identity, permissions, security, verification, persistence and recovery.]

<a id="5-alternatives-and-tradeoffs"></a>

<a id="7-decision-and-approval"></a>

<a id="alternatives-and-tradeoffs"></a>

<a id="decision-and-approval"></a>

## 9. Significant decisions

[Link significant choices, their criteria, alternatives, consequences and approval evidence. Use the shared decision-record format in a companion when separate records improve navigation.]

[Decision-record standard](../standards/documentation.md#decision-records) · [Decision template](decision.md)

## 10. Quality requirements

[Give observable quality scenarios and agreed acceptance thresholds. State how the system will be evaluated.]

## 11. Risks and open choices

[Identify unresolved decisions, assumptions, risks and relevant technical debt. State owners and required evidence.]

## 12. Glossary

[Define necessary terms. Prefer plain words where a special term adds no value.]

<a id="8-implementation-relationship"></a>

<a id="implementation-relationship"></a>

## 13. Delivery references

[Link the issues, plans and roadmap that deliver the design. Keep implementation steps, transitions, status checklists and change history in those records. The design describes the wanted system.]
