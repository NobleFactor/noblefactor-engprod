---
title: "Go standards — retained detail"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Go standards — retained detail

[Up: Coding standards](index.md)

Imported detailed requirements for review; no substantive style changes have been approved. The shared coding index defines applicability; approved scope changes are incorporated explicitly.

# Go Style Guidelines

## 1. File Layout (MANDATORY)

Every Go file, in exact order:

1. **Copyright header** — `// SPDX-License-Identifier: Apache-2.0` + `// Copyright (c) 2025-2026 Noble Factor. All rights reserved.`
2. **Package declaration** — optional package-level doc comment (as in `helpers.go`: `// Package file provides...`)
3. **Imports** — stdlib block, blank line, internal packages block
4. **`init()`** — if present (e.g., registering constructors)
5. **Interface guards** — `var _ io.Reader = (*Reader)(nil)` with `// Interface Guard:` comment
6. **Package-level vars** — grouped `var ()` blocks with doc comments
7. **Main struct** — with doc comment and annotations
8. **Main struct methods** — exported first, then unexported (see Method Region Hierarchy)
9. **Supporting types** — `region SUPPORTING TYPES` at the end of the file (see [Supporting Types Region](#supporting-types-region))
10. **Helper functions** — `region HELPER FUNCTIONS` at the end of the file (see [Helper Functions Region](#helper-functions-region))

<a id="supporting-types-region"></a>

### 1.1 Supporting Types Region

Types whose purpose is to support the operation of the file's main type (e.g., `decoder` supports `Parser`) live in a `region SUPPORTING TYPES` at the end of the file, after all main-struct methods.

- A supporting struct keeps its own methods with it, inside the region, following the same exported-then-unexported method ordering.
- Generally-useful types that are **not** tied to the main type belong in their **own files**, not in `SUPPORTING TYPES`.
- Visibility follows usage: a supporting type referenced **outside** the main type's package is **exported**; otherwise **unexported**.

<a id="helper-functions-region"></a>

### 1.2 Helper Functions Region

Unexported free functions whose purpose is to support the operation of the file's main type live in a `region HELPER FUNCTIONS` at the end of the file — the function analog of the [Supporting Types Region](#supporting-types-region).

- A free function used in more than one file in the package belongs in `helpers.go` (see §10), not in a `HELPER FUNCTIONS` region.
- Exported free functions that form part of the package's public API use a `region EXPORTED FUNCTIONS`, not `HELPER FUNCTIONS`.

## 2. Method Region Hierarchy

Every struct's methods use a two-level region hierarchy. Top-level regions are **ALL CAPS**; sub-regions are **Sentence case**. Empty sub-regions are omitted.

```go
// region EXPORTED METHODS

// region State management
// (getters, setters — methods that read or write struct state)
// endregion

// region Behaviors
// (everything else — operations, queries, transformations)
// endregion

// endregion

// region UNEXPORTED METHODS

// region State management
// endregion

// region Behaviors
// endregion

// endregion
```

## 3. Delineators Within Behaviors

Within a `Behaviors` sub-region, plain comment lines (not regions) group methods by kind. An example of this kind of grouping follows:

| Delineator            | Meaning                                                   | Signature pattern                            |
| --------------------- | --------------------------------------------------------- | -------------------------------------------- |
| `// Fallible actions` | Operations that can fail                                  | Returns `error` (alone or with other values) |
| `// Actions`          | Infallible operations — pure computation or thin wrappers | No `error` in return                         |

Not every struct needs both. A struct where all methods are of one kind needs no delineators at all.

Within each delineator group, methods are **alphabetical**.

<a id="sort-order-summary"></a>

### 3.3 Sort Order Summary

1. **State management** before **Behaviors**
2. Within Behaviors: **Fallible** → **Actions**
3. Within each group: **alphabetical**
4. **Exported** before **Unexported** (same sub-structure in both)

## 4. Doc Comment Format

Every exported method (and unexported helpers):

```go
// Name <present-tense verb phrase>.
//
// Optional extended description.
//
// Parameters:
//   - paramName: Description (default: value)
//
// Returns:
//   - type: description
```

- The first line is the summary: it begins with the identifier name, then a present-tense verb phrase (`Instance returns …`, `Copy copies …`), on **one line**, filled to column 120. Never a bare imperative — Go's `golint` requires the leading name.
- The optional extended description is **zero or more paragraphs**, each filled to column 120 and separated by a blank `//` line.
- Include `Parameters:` only when the function or method has parameters; include `Returns:` only when it returns values. Omit empty sections.
- Default values documented inline
- Unexported helpers also get full doc comments, with `Parameters:` and `Returns:` sections when applicable.

## 5. Struct Design

Document fields beside their declarations rather than listing them in the type’s documentation comment:

```go
// Record identifies an item and its recorded digest.
type Record struct {
    Name   string // stable item name
    Digest string // digest recorded for comparison
}
```

Product-specific embedding, field visibility, constructors and resource lifecycles belong to the product’s conventions, not this shared style guide.

## 6. Naming Conventions

| Category                  | Pattern                                 | Examples                           |
| ------------------------- | --------------------------------------- | ---------------------------------- |
| Exported action methods   | Verb or VerbNoun                        | `Backup`, `Copy`, `WriteBytes`     |
| Query methods             | `Is`/`Exists` returning `(bool, error)` | `Exists`, `IsDir`, `IsFile`        |
| Utility methods           | Short noun/verb, return `string`        | `Join`, `Name`, `Parent`           |
| Unexported methods        | camelCase verbs                         | `compensateWrite`, `prepareWrite`  |
| Unexported free functions | camelCase verbs                         | `isDirAndNotEmpty`, `checksumFile` |

## 7. Error Handling

- Return **zero-value structs** on error: `return Record{}, err`
- Check errors **immediately** after the producing call
- Use `errors.Is(err, os.ErrNotExist)` for specific discrimination
- Graceful degradation annotated with `//nolint:nilerr // reason`
- **Fix every issue as discovered** — never pass by warnings or errors

## 8. Code Formatting

- **Source-code line width**: wrap at column 120, including documentation comments. Function signatures may exceed 120 when breaking would hurt readability. Markdown prose follows the [documentation source-layout rule](../documentation.md#prose-source-layout).
- **Blank line after function signature** before the body
- **No blank line before `return`** in short functions
- **Blank lines** separate logical blocks within a function
- **`defer f.Close()`** immediately after the open call
- **Octal literals** use `0o` prefix: `0o644`, `0o750`
- **Greenfield scope** — apply the [DevLore greenfield product policy](index.md#greenfield-product-policy). In other repositories, pause affected work and obtain an Owner decision on compatibility rather than assuming a requirement.
- **No unnecessary comments, docstrings, or type annotations** on unchanged code

## 9. Test Style

- **Helper function** at top with `t.Helper()`
- **Section separators**: `// --- ActionName ---`
- **Test naming**: `TestAction_ScenarioDescription`
- **Setup**: `t.TempDir()`, `t.Cleanup()` — no manual temp dir management
- **Assertions**: direct `if` checks with `t.Fatalf` / `t.Errorf` — no assertion library
- **Test after each change** to verify fixes
- **Use `make test`** — never bare `go test`

## 10. Helpers File

- Separate `helpers.go` for **unexported free functions** (not methods)
- Each has full doc comments, with `Parameters:` and `Returns:` sections when applicable.
- No region markers — the file itself is the organizational unit
- Package doc comment can live here on the `package` line

---

## 11. Product-specific conventions

DevLore’s resource, provider and receipt structures, compensation pairs, behavior ordering and generator directives are defined in its [Go guide](https://github.com/NobleFactor/devlore-cli/blob/develop/docs/guides/go-style-guidelines.md) and [provider-development guide](https://github.com/NobleFactor/devlore-cli/blob/develop/docs/guides/provider-development.md). They are not requirements for unrelated Go repositories.

The existing product Go guide identifies itself as a mirror of the former shared guide. Its ownership statement and shared-style references need reconciliation in DevLore’s own documentation work. This separation does not authorize changes in another worker’s worktree or establish that the product guide already reflects every newly approved shared convention.
