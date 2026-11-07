---
title: "Bash standards"
status: draft
created: 2026-10-28
updated: 2026-10-29
---

# Bash standards

[Up: Coding standards](index.md)

<a id="scope"></a>

## 1. Scope

Bash scripting standards apply to maintained tooling, whether it supports the product or engineering productivity. Their further development is tracked by the existing Bash-standards issue; this consolidation does not replace that work.

Temporary scripts an agent writes solely to carry out its assigned work need not follow the maintained-tooling conventions. Generated PR scripts follow their own dedicated template, as specified below.

Product-distributed scripts may ship Declare-BashScript or embed its source, in whole or in part. Embedding the relevant source is encouraged where appropriate, as in devlore-cli’s install.sh. Product installation must not depend on the user already having an engineering-environment helper installed.

<a id="source-and-dependencies"></a>

## 2. Source and dependencies

Maintained engineering-environment Bash commands source Declare-BashScript. Product-distributed scripts may provide or embed the helper as described above. A Git hook sources nothing: it is Git configuration executed from the hooks path, not an ordinary command. Generated PR scripts are also explicitly exempt from sourcing Declare-BashScript; they must follow the dedicated [PR script standard](../../engineering/procedures/pull-request.md), including its platform-specific structure and safeguards. Project placement and dependency boundaries are defined in [Work assets](../../engineering/work-assets.md).

Declare the helper with `# shellcheck source=Declare-BashScript` directly above the source line. Use the helper's filename rather than a source-directive path. Configure the lint search path to the engprod source directory, deployed helper or pinned dependency checkout as appropriate. A missing mandatory helper must fail closed rather than allow the rest of the command to run without its error handling.

<a id="form-and-validation"></a>

## 3. Form and validation

Retain shfmt's four-space indentation and switch-case indentation, and ShellCheck following sourced files. Preserve argument boundaries and native failure results. Run repository-provided checks rather than an approximation of CI. Formatting validity does not prove intended behavior.

The current lint tool versions, flags and platform prerequisites are implementation details to inventory in the later tooling discussion. The existing template-based PR-script approach is retained. Its Bash form uses `set -euo pipefail` without sourcing Declare-BashScript. The exemption removes the helper dependency, not the requirement for correct behavior, safe execution or the dedicated template.
