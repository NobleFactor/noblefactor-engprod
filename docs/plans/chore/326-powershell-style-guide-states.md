---
title: "The PowerShell style guide states three rules: a one-line header title, no final return, correctly cased types"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/326
status: active
created: 2026-10-21
updated: 2026-10-21
---

# Plan: the PowerShell style guide states three rules the owner gave on 2026-10-20

One pull request. The rules are ruled; this writes them down.

## Summary

Writing `Get-CommandOnPersistentPath` for lane 34 of NobleFactor/devlore-cli#949 (#1050), the owner gave three rules
the PowerShell style guide does not state. An agent broke the first the same day (#317). The owner ruled that they
go into the next pull request written.

## Rulings

- 2026-10-20, of a header's title: "you have 120 characters per line and the title line of a function comment MUST be
  no longer than 120."
- 2026-10-20, of `return`: "return is redundant ... the return value is the value of the last statement."
- 2026-10-20, of type names: "I really like using correctly cased type names. so make that change too."
- 2026-10-20: "And they go into the next pr you write."

## Requirements

### Requirement 1: The header's title is one line

Section 10's documentation headers: the first line is the function's name and a present-tense verb phrase, on one
line, no longer than 120 columns, as the Go guide's section 4 says.

### Requirement 2: A function's last statement is its result

Section 9: a function's final value is its last statement, with no `return`; a `return` that leaves early stays. The
rule against a blank line before a short function's final `return` goes, since there is no final `return`.

### Requirement 3: Type names are cased as .NET cases them

Section 5: a type is written as .NET names it, `[String]`, `[Int32]`, `[Switch]`, `[Array]`, `[Environment]`,
`HashSet[String]`, not `[string]` or `[switch]`. The guide's own examples follow it.

### Requirement 4: Section 11 checks them

Section 11's checks verify all three.

### Requirement 5: The scripts that do not follow them yet

Named in the pull request, each its repository's work: noblefactor-ops' and personal's under #324; devlore-cli's
`install.ps1` and `scripts/Test-InstallScript.ps1` in a devlore-cli issue filed with this pull request.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed on `chore/326-powershell-style-guide-states`; the rules ruled 2026-10-20

### Phase 2: The guide (Requirements 1 to 4)

- [ ] Sections 5, 9, 10 and 11, and the guide's examples
- [ ] `Test-Frontmatter.sh`; every line within 120 columns

### Phase 3: Merge (Requirement 5)

- [ ] The devlore-cli issue for its two scripts, filed
- [ ] The gate this repository's CI runs, finished green before the PR script is called ready
- [ ] PR script written, shown, and handed over; the PR resolves #326
- [ ] CI on the pull request; nothing acts on the checks while the script's gate watches them

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/guides/powershell-style-guidelines.md` | Modify | Requirements 1 to 4 |

## Open Questions

None.
