---
title: "The PowerShell style guide says how every function is documented"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/323
status: active
created: 2026-10-20
updated: 2026-10-20
---

# Plan: the PowerShell style guide says how every function is documented

One pull request. Ruled first, written at once: the owner's words below are the design.

## Summary

The PowerShell style guide's section 10 says only that function comments are "required for exported module functions
and recommended for non-obvious private helpers", and gives no form. The base layer's PowerShell documents functions
two ways, and an agent copied the nearer one and was wrong (NobleFactor/noblefactor-ops#317, 2026-10-20). This plan
writes the rule into the guide.

## Rulings

- 2026-10-20: "Use Go-style format for comments, including function documentation headers. Use PowerShell help format
  for the main entry point to a script or any function intended for use by end users (like me)."
- 2026-10-20: "The general rule: if you source a file, it should document the functions using PowerShell help format.
  Otherwise, document functions like you would for Go."

## Requirements

### Requirement 1: Section 10 states the rule

- A script's entry point, and every function of a file that is dot-sourced (a profile, or a library a session loads),
  carries PowerShell comment-based help: `.SYNOPSIS`, `.DESCRIPTION`, a `.PARAMETER` for each parameter, `.EXAMPLE`
  when useful, `.OUTPUTS` when it writes output. A sourced function's help sits immediately above its `function` line.
- Every other function, the helpers of a script that is run, carries a Go-style documentation header immediately above
  its `function` line, in the form of the Go style guide's section 4: its name and a present-tense verb phrase on one
  line, an optional extended description, then `Parameters:` when it takes any and `Returns:` when it writes output,
  each item a backticked name and its description. The Go code writes the sections only when they have an item
  (`NewTerminalFormatter` has Returns alone; `setStyle` has Parameters alone; `renderStep` has neither), and so does
  PowerShell.
- Every other comment takes the Go guide's form: `#` line comments, full sentences, filled to column 120. `<# #>` is for
  help alone.

### Requirement 2: The rest of the guide agrees

Section 1's file layout names the forms; section 11's checks verify them.

### Requirement 3: The scripts that do not follow it yet

The existing scripts are named in the pull request, each its repository's own work: devlore-cli's `install.ps1` and
`scripts/Test-InstallScript.ps1` in lane 34 (#1050), already planned to; this repository's and personal's scripts in
#324.

## Implementation Phases

### Phase 1: The plan

- [x] This plan committed on `chore/323-powershell-style-guide-states`; the rule ruled 2026-10-20, twice

### Phase 2: The guide (Requirements 1 and 2)

- [x] Sections 1, 9, 10 and 11 (section 9's two comment rules move into 10)
- [x] `Test-Frontmatter.sh`, codespell where it runs, and the other documents that cite section 10 read again: only
      plans 216 and 218, which cite the section numbering of their day

### Phase 3: Merge (Requirement 3)

- [x] The issue for the scripts that do not follow the rule yet, filed: #324, under feature #266
- [ ] The gate this repository's CI runs, finished green before the PR script is called ready
- [ ] PR script written, shown, and handed over; the PR resolves #323
- [ ] CI on the pull request; nothing acts on the checks while the script's gate watches them

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/guides/powershell-style-guidelines.md` | Modify | Requirements 1 and 2 |

## Open Questions

None.
