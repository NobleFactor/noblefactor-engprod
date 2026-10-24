---
title: "The report and the audit read type and parent through GraphQL, so a gh too old to know issueType and parent still works"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/395
status: draft
created: 2026-10-24
updated: 2026-10-24
---

# Plan: type and parent through GraphQL

## Summary

#379 (e714e44) added `issueType` and `parent` to the `gh issue list --json` call in the extension's `fetch_issues`.
gh 2.46.0, the build Ubuntu Pro's ESM archive pins, does not know either field and refuses the whole call, so every
report and audit on danoble-ud24-1 failed from the base layer's deploy on 2026-10-22 until gh was upgraded there on
2026-10-23. The fix reads the two fields from GitHub's GraphQL schema, which does not depend on gh's version.

## Goals

1. **The report and the audit run on gh 2.46.0,** proven with that release's own binary.
2. **They render exactly as they do today** on a current gh.

## Current State

- `fetch_issues` in `commands/scheme.star` runs one `gh issue list` per repository with
  `--json number,title,state,labels,body,url,issueType,parent`, and `resolve_all` reads `issueType.name` and
  `parent.url` from each issue.
- `label_space` and `label_inventory` already read through `gh api graphql`.
- Read on 2026-10-24: `gh api graphql --paginate` over a repository's issues, 100 to a page, returns number, type
  and parent for all 650 of devlore-cli's issues in about five seconds.

## Requirements

### Requirement 1: the list call asks only what every gh knows

`fetch_issues` drops `issueType` and `parent` from `--json`, keeping `number,title,state,labels,body,url`.

### Requirement 2: one GraphQL read per repository for type and parent

Beside each list call, one paginated query for the same states:

```
gh api graphql --paginate -f query='query($endCursor: String) { repository(owner: "<owner>", name: "<name>") {
  issues(first: 100, after: $endCursor, states: [<states>]) {
    nodes { number issueType { name } parent { url } } pageInfo { hasNextPage endCursor } } } }'
  --jq '.data.repository.issues.nodes[] | ...'
```

Each issue gets `issueType` and `parent` in the shape `gh issue list` gave them, `{"name": ...}` and `{"url": ...}`,
or none, so `resolve_all` and everything after it is unchanged. The read covers the whole state, not `--limit`'s
newest; the extra issues are ignored.

### Requirement 3: proof

- **On gh 2.46.0:** the release's binary, downloaded into a scratch directory of its own and put first on `PATH`,
  runs `star gh issues report` and `star gh issues audit` against noblefactor-engprod without error.
- **On the current gh:** the report by epic, by schedule for #346, and the audit, rendered before and after through
  the test-without-deploy copy, are identical.

## Implementation Phases

### Phase 1: the plan

- [ ] This plan committed on `fix/395-report-and-the-audit-fail-on-a`, reviewed with the owner, status `approved`

### Phase 2: the fix

- [ ] `fetch_issues` changed; `make check` passes
- [ ] The renders identical before and after on the current gh
- [ ] The report and the audit run on gh 2.46.0

### Phase 3: the pull request

- [ ] The pull request; status `complete` in its last commit

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | `fetch_issues` |
| `docs/plans/fix/395-old-gh-issuetype-parent.md` | Create | this plan |

## Related Documents

- #379, the change that introduced the dependency
- #380's `scripts/Type-And-Link-Issues` asks gh for the same two fields. It is a repository tool run by hand, so it is
  left as it is, and noted here so it is not mistaken for fixed.

## Open Questions

None.
