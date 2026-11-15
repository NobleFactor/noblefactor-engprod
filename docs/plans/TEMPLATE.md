---
title: "Plan Template"
description: "Template for creating new plan documents"
---

# Plan: [Title]

<!--
TEMPLATE INSTRUCTIONS (delete this block when using):
1. Copy this file to a new file named after your plan (e.g., `star-quality-gate.md`)
2. Fill in the frontmatter
3. Create a GitHub issue referencing this plan
4. Update the `issue` field with the issue number
5. Delete this instruction block
-->

**Frontmatter fields**:

```yaml
title: [Plan Title]
issue: https://github.com/NobleFactor/noblefactor-ops/issues/XX
status: draft | approved | active | complete | abandoned
created: YYYY-MM-DD
updated: YYYY-MM-DD
documents:                      # the design documents this plan bears on, for its issues' tables
  - kind: "Design: collections"
    path: docs/architecture/issue-data-model/3-collections.md
  - kind: "Where this is listed"
    url: https://github.com/NobleFactor/noblefactor-engprod/blob/develop/docs/plans/chore/303-issue-data-model.md
    text: "#303's plan"
```

`documents:` names the design documents the plan bears on, each a `kind` and a `path` in this repository or a `url`,
with an optional `text` to show. `star github plan link` writes each issue's `Plan and design documents` section from
its plans: a Plan row for each, then their documents (#557).

## Summary

One paragraph describing what this plan accomplishes.

## Goals

1. **Goal 1**: Description
2. **Goal 2**: Description
3. **Goal 3**: Description

## Current State

Describe what exists today before this plan is implemented.

| Component | Status | Notes |
| --- | --- | --- |
| Feature A | ✅ Working | |
| Feature B | ❌ Missing | |

## Requirements

### Requirement 1

Detailed description of what must be built.

**Configuration**:

```yaml
example:
  config: here
```

**Commands**:

```bash
example command --flag
```

### Requirement 2

Detailed description.

## Implementation Phases

### Phase 1: [Name]

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

**Files**:

- `path/to/file.go` - Create
- `path/to/other.star` - Modify

### Phase 2: [Name]

- [ ] Task 1
- [ ] Task 2

## Migration Path

How existing repos/users migrate to this new approach.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `path/to/new.go` | Create | Description |
| `path/to/existing.go` | Modify | Description |

## Related Documents

The design documents an issue's table should link go in the frontmatter's `documents:`, not only here.

- [Link to related plan](./other-plan.md)
- Issue #XX - Related issue
- ADR-XXX - Related decision

## Open Questions

- [ ] Question 1?
- [ ] Question 2?
