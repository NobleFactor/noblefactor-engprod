---
title: "Issue attribute decisions"
status: draft
updated: 2026-11-19
---

# Issue attribute decisions

[Design](2-attributes.md) · [Preserved source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-2-attributes.md.txt)

## 1. Store attributes on issues

**Status:** Accepted model requirement.

Use native issue fields in organizations and per-repository labels for the user-account representation. Collection coordinates stay in project fields.

**Reason:** Priority, Area and Severity must survive a move between projects. Step and Beat have meaning only within their collection.

**Alternative:** Represent all metadata as project fields.

**Consequence:** Model application must preserve native field and option identities. The label fallback needs explicit single-value validation and has no equivalent date value.

## 2. Distinguish harm from ordering

**Status:** Accepted model requirement.

Severity measures Bug impact. Other typed issues have N/A. Priority determines when to act, and triage sets it.

**Reason:** A planned Task has no defect impact of its own. A Scenario can reveal work without changing that work's Priority automatically.

**Alternative:** Use Severity as a general importance score.

**Consequence:** Filing and workflows supply a Bug's Medium default; triage corrects it to match the harm. Untyped intake gets no Severity until classification.

## 3. Classify each issue's own Area

**Status:** Accepted model requirement.

Require Product or Engineering on every issue and assess its own work rather than inherit its parent's Area.

**Reason:** Engineering work, such as a CI fix, can support a Product Feature.

**Consequence:** Filing, triage and the sweep need explicit missing-Area handling. The product/engineering definitions and containment constraints remain authoritative in the issue standard.

## 4. Explain closure explicitly

**Status:** Accepted model requirement.

Use Resolution Declined, Duplicate or Invalid for closed work that was not done, with GitHub's completed state reason.

**Alternative:** Use GitHub's `not_planned` reason or unrelated duplicate, invalid and wontfix labels.

**Reason:** One shared representation supports both account models and distinguishes delivery from non-delivery.

**Consequence:** Open issues must have no Resolution, and normal completion has none. Reopening and validation must maintain that invariant.

## 5. Diagnose without silently repairing policy

**Status:** Accepted sweep requirement.

The sweep reports violations and returns affected work to Triage, with the Scenario exceptions in the design.

**Reason:** Triage owns the disposition and correction. Automation must not silently decide classification or remove a commitment.

**Consequence:** Diagnostic, routing and corrective behavior need separate evidence; documentation of the contract is not implementation evidence.
