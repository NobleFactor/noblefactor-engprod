---
title: "Issue model migration reference"
type: Reference
status: "Superseded by docs/plans/chore/303-issue-data-model.md"
updated: 2026-11-19
---

<a id="5-from-todays-scheme"></a>

# Issue model migration reference

[Up: Issue data model](index.md)

The migration belongs in the [issue data model plan](../../plans/chore/303-issue-data-model.md). The [unaltered source](../../engineering/review/sources/rewrite-2026-11-19/issue-data-model-5-from-todays-scheme.md.txt) preserves its transition requirements, compatibility constraints, dated observations, delta table and rollout stages.

<a id="the-line-that-protects-the-running-sessions"></a>
<a id="what-must-keep-running"></a>

## 1. Compatibility and running work

The migration record requires protecting work already underway, including Schedule identity and the commands used by active sessions. These are rollout constraints for the plan, not a second system architecture.

<a id="the-deltas"></a>
<a id="the-order-as-the-stages"></a>

## 2. Architecture and delivery records

Use the [hierarchy](1-hierarchy.md), [attributes](2-attributes.md), [collections](3-collections.md), [storage and access](4-storage-and-reach.md), [model commands](6-the-asset-and-its-sync.md) and [workflow](7-the-workflow-before-and-after.md) for the maintained system description.

The retained [delivery reference](5-from-todays-scheme.status.md) links progress and source evidence. This page preserves incoming references and defines no migration steps or completion claim.
