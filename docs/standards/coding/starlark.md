---
title: "Starlark standards"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Starlark standards

[Up: Coding standards](index.md)

Use the repository's formatter and static checks. Retain the current one-line docstring convention; the engprod buildifier setup disables its argument/return docstring-completeness warnings. Keep code readable and document non-obvious intent.

Treat language validity and provider/API validity separately. A well-formed call to a nonexistent provider operation is not established as correct by a formatting/language checker. Exercise the intended command behavior through the repository's supported checks.

No additional detailed organization-wide Starlark style guide was found in the inventory. This draft does not invent one from tool defaults. Exact tooling and adoption are deferred.
