---
title: "Coding standards"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Coding standards

[Up: Documentation](../../index.md)

<a id="shared-expectations"></a>

## 1. Shared expectations

Applicable to everyone. Implement the approved behavior; do not substitute success stubs, suppress failures or bypass hooks and gates. Fix warnings and errors discovered in the work. Record unrelated issues and coordinate their resolution under the process rather than silently expanding scope.

Do not edit generated files. Change generator input and regenerate through the repository's supported build entry point. Update affected documentation in the same commit. Test after each change with focused checks appropriate to the behavior; the repository's full required gates still apply before PR execution.

Use repository build/test/vet entry points; devlore-cli requires Make rather than direct Go commands. Immediate Go formatting is explicitly exempt from that routing rule.

<a id="language-standards"></a>

## 2. Language standards

- [Bash](bash.md)
- [Go](go.md)
- [PowerShell](powershell.md)
- [Starlark](starlark.md)

Go and PowerShell detailed standards are imported without substantive normalization. Contradictory or surprising requirements must be surfaced, not silently corrected during consolidation. Repository-specific product constraints remain in the owning repository, linked from [the local requirements record](../../engineering/review/repository-requirements.md).

<a id="greenfield-product-policy"></a>

## 3. Greenfield product policy

DevLore is a new product being developed toward its first minimally viable release. Its implementation must not accommodate superseded development behavior through compatibility layers or fallbacks. This policy applies to `devlore-cli`, `devlore-registry`, and `devlore.noblefactor.com`.

For other repositories, compatibility requirements are decided case by case. Agents must not assume backward compatibility is required. On discovering a compatibility question, pause the affected work, explain the issue and its consequences, and obtain the Owner’s decision before proceeding. The Owner determines the applicable requirement.
