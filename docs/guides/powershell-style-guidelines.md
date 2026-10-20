---
title: "PowerShell Style Guidelines"
type: Guide
status: Approved
---

# PowerShell Style Guidelines

These guidelines define the NobleFactor style for PowerShell scripts and modules. They parallel the Go Style
Guidelines while following PowerShell's command, parameter, and pipeline model.

## 1. File Layout (MANDATORY)

Every PowerShell script, in exact order:

0. **Shebang** — `#!/usr/bin/env pwsh`, alone on line 1, with no byte-order mark ahead of it
1. **Copyright header** — SPDX identifier and copyright notice
2. **Comment-based help** — the script's own, in the form of section 10
3. **`#Requires` declarations** — PowerShell 7.0 or later and required modules
4. **Script-level `[CmdletBinding()]` and `param()`** — before executable statements
5. **Script configuration** — the caller's error action noted, `$ErrorActionPreference = 'Stop'` set (section 7),
   and constants
6. **Helper functions** — in a `Helper functions` region immediately after `$ErrorActionPreference`, each documented
   as section 10 says
7. **Main operation** — the executable workflow, after all helper definitions

**The shebang is on every `.ps1`,** dot-sourced profiles and fragments included, so the rule has no exception to
state or enforce (ruled 2026-09-21). On macOS and Linux an executable `.ps1` with it runs directly, `./Script.ps1`,
from any shell. From bash, Git Bash included, a file without it is parsed as shell and fails at the first `<#` or
`[CmdletBinding()]`. A script that's run is also executable: `chmod +x`, or `git update-index --chmod=+x` on Windows.
A file that's only dot-sourced is not.

A script's main operation should read as an orchestration of named actions. Move implementation detail into a helper
function when doing so makes the main operation easier to follow. Functions are defined before the main operation so
that every helper is available when the script begins executing.

PowerShell 7 or later is the default supported runtime. PowerShell 5.1 is not supported. A script that deliberately
supports PowerShell 5.1 must state that support explicitly in its comment-based help and use a corresponding
`#Requires -Version 5.1` declaration.

## 2. Cmdlet Binding

Every function definition uses `[CmdletBinding()]`, including parameterless functions:

```powershell
function Get-RepositoryName {
    [CmdletBinding()]
    param()

    ...
}
```

The `[CmdletBinding()]` attribute is the first statement in the function body and is followed immediately by its
`param()` block. Use advanced-function behavior consistently rather than making some functions advanced and others
not.

The script itself also uses `[CmdletBinding()]` before its `param()` block.

## 3. Function Organization

Functions are grouped by responsibility and placed before the main operation. Helper functions are ordered so that
higher-level operations appear before the primitives they use when that improves reading order; otherwise use
alphabetical order within a responsibility group.

Function names use approved PowerShell verb-noun pairs. Use `Get-` for queries, `Test-` for predicates, `ConvertTo-`
for transformations, `Invoke-` for operations, and `Require-` for required prerequisites.

Functions should have one responsibility. Prefer a named function over duplicated command sequences or an inline
scriptblock whose behavior is not obvious at the call site.

## 4. Control Structures and Braces

Use BSD brace style. The opening brace is on the statement line, and `else`, `elseif`, `catch`, and `finally` begin
on the next line with their opening brace on the same line:

```powershell
if ($condition) {
    ...
}
else {
    ...
}
```

Do not use one-line `if` expressions or one-line control structures. Always use a block, even when it contains one
statement:

```powershell
if ($value) {
    return $value
}
```

Put one blank line before and one blank line after every control structure. An `if`/`elseif`/`else` chain is one
control structure, so there is no blank line between its branches:

```powershell
$branch = Get-Branch

if (-not $branch) {
    $branch = 'detached'
}

if ($Issue) {
    $title = Get-IssueTitle $Issue
}
else {
    $title = Get-PlanTitle $branch
}

$sessionName = "$repository | $branch"
```

Apply the same spacing to `foreach`, `for`, `while`, `do`, `switch`, `try`, and `trap`. Do not introduce multiple
consecutive blank lines. A scriptblock used as a pipeline callback follows the same BSD brace placement, but blank
lines should separate the surrounding pipeline logically rather than interrupting a short callback.

## 5. Parameters and Naming

- Use approved PowerShell verb-noun names for functions.
- Use PascalCase for function and parameter names.
- Use descriptive names; do not use one-letter variables except for conventional short-lived indexes.
- Use `[Parameter()]` and validation attributes when the contract requires them.
- Put each significant parameter on its own declaration when attributes or defaults make the contract clearer.
- Use `ValueFromRemainingArguments` only for intentional pass-through arguments.
- Preserve native command argument boundaries with arrays rather than building unquoted command strings.

## 6. Error Handling

- Set `$ErrorActionPreference = 'Stop'` for the script's own work, having noted the caller's: a cmdlet that fails stops
  the script, and section 7 says how the error reaches the caller.
- Check the result of an external command immediately after invocation.
- Check `$LASTEXITCODE` immediately after native commands that expose it.
- Refuse with an actionable message that identifies the failed operation and relevant input, raised as section 7
  says.
- When absence is an expected branch, use `-ErrorAction Ignore` and handle that branch explicitly. Not
  `SilentlyContinue`: it hides the error from the screen but still records it in `$Error`, so a profile that probes
  for absent things leaves `$Error` full on every load.
- Return `$null` only when absence is part of the function contract; do not silently discard unexpected failures.
- Validate user input at the parameter boundary with validation attributes or immediately after parsing it.

## 7. Messages and Failure

A script speaks to its caller as a cmdlet does, through PowerShell's own streams, after Microsoft's guidance to cmdlet
authors ([Strongly encouraged development guidelines][ms-guide], [Types of cmdlet output][ms-output]). Each stream
has one use, and the caller decides what is shown: every preference keeps the default PowerShell gives it, or the one
the caller sets.

- **A result is an output object** on the success stream, never text written to the console or the host. Microsoft
  recommends `WriteObject` "instead of the System.Console.WriteLine or
  System.Management.Automation.Host.PSHostUserInterface.WriteLine methods."
- **What the script is doing goes to the verbose stream,** with `Write-Verbose`, Microsoft's place for "some detail
  about what the cmdlet is doing". The caller sees it with `-Verbose`.
- **A warning goes to the warning stream,** with `Write-Warning`, when the script "is about to perform an operation
  that might have an unintended result". The caller sees it unless they say otherwise.
- **A diagnostic goes to the debug stream,** with `Write-Debug`, for when "a developer or product support engineer
  must understand what has corrupted the cmdlet operation".
- **Progress is shown only for a long operation whose progress the script can compute,** as a download's, with
  `Write-Progress`. Microsoft asks it of "Cmdlet operations that take a long time to complete and that cannot run in
  the background". A command whose results show as they arrive needs none: the PowerShell Committee ruled so for
  Test-Connection, 2019-05-08 ([PowerShell/PowerShell#6768][test-connection]).
- **Nothing goes to the information stream or the host.** Microsoft's guidance to cmdlet authors never names the
  information stream, and no cmdlet that ships with PowerShell narrates there. When Test-Connection did, in
  PowerShell 6, the PowerShell Committee ruled that it emit an object for each reply instead. A cmdlet "should not
  bypass the host" unless it draws a graphical interface, and the analyzer refuses `Write-Host`.
- **The defaults are the caller's.** A script sets none of `$VerbosePreference`, `$WarningPreference`,
  `$InformationPreference`, `$DebugPreference` or `$ProgressPreference`, and turns no stream on by force with its
  common parameter. The one preference it sets is `$ErrorActionPreference`, below.

### Errors

A script catches every error, stops, and lets its caller decide what the error does to them. It notes its caller's
error action, sets `Stop` for its own work, and runs that work inside `try` and `catch`. In the `catch` it puts its
caller's error action back, reports the error with `$PSCmdlet.WriteError`, and exits 1. A caller who continues on
error continues; one who silences errors hears nothing, though `$Error` keeps the record; one who stops on error
stops, and their own `try` catches it. Run as a process, the script exits 1.

```powershell
[CmdletBinding()]
param()

$callerErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

try {
    if (-not $IsWindows) {
        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('This script requires Windows.'),
            'RequiresWindows',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $null)
    }

    # The script's work.
}
catch {
    $caught = $_
    $ErrorActionPreference = $callerErrorAction
    $PSCmdlet.WriteError($caught)
    exit 1
}
```

- **`$PSCmdlet.WriteError`, not `Write-Error`.** Both honor the caller's error action, but `Write-Error` shows the
  caller "Write-Error:" where `$PSCmdlet.WriteError` shows the script's name, and `Write-Error -Message` also trades
  the error's own category for a generic one and leaves a second record in `$Error`.
- **A refusal is an error record of the script's own,** with an id and a category, thrown inside the caught work, so
  the `catch` reports it like any other error: the caller sees the script's name, the record's id and its category. A
  thrown string reaches the caller as "Exception:", its message standing in for an id. Not
  `$PSCmdlet.ThrowTerminatingError`: it skips the script's own `catch`, so the error never reaches the caller under
  their error action, and the script never exits 1.
- **A script with `begin`, `process` and `end` catches in each block,** since a `try` cannot span them. It checks its
  requirements first, in `begin`, before any input is processed; an `exit` there skips `process` and `end`.

### Common parameters

The common parameters that work through a preference variable, `-Verbose`, `-Debug`, `-ErrorAction`,
`-WarningAction`, `-InformationAction`, `-ProgressAction`, `-WhatIf` and `-Confirm`, reach the scripts and compiled
cmdlets a script calls on their own. They do not reach a script module's functions, which see only global settings
([PowerShell/PowerShell#4568][preferences-in-modules]), nor jobs and other runspaces. A script passes them to those
itself, as `-WhatIf:$WhatIfPreference`: without it, a module function makes the change a user ran with `-WhatIf`.
The other common parameters, the `-*Variable` ones, `-OutBuffer` and `-PipelineVariable`, belong to the one command
they are given to ([about_CommonParameters][parameters]).

### Native programs

PowerShell reads what a native program writes in the console's code page, the OEM one at a Windows console, so text
beyond ASCII is lost: an em dash arrives as three other characters. A script that reads a program's output reads it
through .NET's `Process`, with `StandardOutputEncoding` and `StandardErrorEncoding` set to UTF-8 and the program's
standard input closed. It never changes the console's code page, and calls no Win32 API to write to the console.

```powershell
$start = [System.Diagnostics.ProcessStartInfo]::new((Get-Command -Name gh -CommandType Application).Source)
$start.ArgumentList.Add('--version')
$start.WorkingDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
$start.UseShellExecute = $false
$start.RedirectStandardInput = $true
$start.RedirectStandardOutput = $true
$start.RedirectStandardError = $true
$start.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
$start.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)

$process = [System.Diagnostics.Process]::Start($start)
$process.StandardInput.Close()
$errorRead = $process.StandardError.ReadToEndAsync()
$output = $process.StandardOutput.ReadToEnd()
$process.WaitForExit()
$errorText = $errorRead.GetAwaiter().GetResult()
$exitCode = $process.ExitCode
```

### References

Microsoft's [Strongly encouraged development guidelines][ms-guide], [Types of cmdlet output][ms-output],
[about_CommonParameters][parameters], [about_Preference_Variables][preferences] and
[about_Output_Streams][output-streams]; [PowerShell/PowerShell#6768][test-connection], the PowerShell Committee's
ruling on Test-Connection; [PowerShell/PowerShell#4568][preferences-in-modules], a script module's functions and their
callers' preferences.

## 8. External Commands and Working Directories

Prefer PowerShell APIs and cmdlets for filesystem and process operations. External dependencies must be explicit and
minimal. Keep working-directory changes local to the operation that requires them.

A launcher that invokes Bash must not acquire general Bash dependencies. Bash dependencies are limited to commands whose
names begin with `git-`; PowerShell launchers should use native PowerShell and Windows commands instead.

## 9. Formatting

- Use four spaces for indentation.
- Use BSD braces consistently.
- Keep lines at or below 120 columns when practical; break long pipelines at natural command boundaries.
- Put a blank line after a function's `param()` block before its body.
- Use blank lines to separate logical blocks, with exactly one blank line around control structures.
- Do not add a blank line before a short function's final `return`.
- Comments take the form of section 10.
- Avoid one-line expressions when a block makes control flow clearer.
- Preserve argument quoting and array structure; do not use `Invoke-Expression` for command construction.

## 10. Comments and Help

Every comment is in the form of the Go Style Guidelines, section 4, except the help of what an end user runs. Ruled
2026-10-20: "Use Go-style format for comments, including function documentation headers. Use PowerShell help format
for the main entry point to a script or any function intended for use by end users," and "If you source a file, it
should document the functions using PowerShell help format. Otherwise, document functions like you would for Go."

| What | Documented with |
| --- | --- |
| A script's entry point | Comment-based help, where section 1 puts it |
| Every function of a file that is dot-sourced: a profile, or a library a session loads | Comment-based help |
| Every other function: the helpers of a script that is run | A Go-style documentation header |

### Comment-based help

`.SYNOPSIS`, `.DESCRIPTION`, a `.PARAMETER` for each parameter, `.EXAMPLE` when one helps, and `.OUTPUTS` when the
command writes output. A function's help sits in a `<# #>` block immediately above its `function` line, so
`Get-Help` finds it:

```powershell
<#
.SYNOPSIS
    Opens a terminal at a repository.

.DESCRIPTION
    Opens a new Windows Terminal tab whose working directory is the repository's root.

.PARAMETER Name
    The repository's directory name under the workspace.

.EXAMPLE
    Open-Repository devlore-cli
#>
function Open-Repository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Name
    )

    ...
}
```

### Documentation headers

A function that is not an end user's carries a header of `#` line comments immediately above its `function` line,
in the Go form:

- The first line is the function's name and a present-tense verb phrase.
- An extended description follows a blank `#` line when the name and phrase do not say enough.
- `Parameters:` lists each parameter, a backticked name without `$` and its description, a default stated inline.
- `Returns:` names what the function writes to the output stream, by type, and what it is.

Each section is written only when it has an item, as the Go code writes them: a function that takes nothing has no
`Parameters:`, and one that writes nothing has no `Returns:`.

```powershell
# Find-OnPath finds the first copy of an installed file on the PATH a new terminal searches.
#
# The folders are searched in the order Windows searches them, with Get-ChildItem -LiteralPath, so a folder named
# with brackets is searched as named.
#
# Parameters:
#   - `Installed`: The full path of the installed file.
#   - `MachinePath`: The machine PATH (default: the registry's, expanded).
#   - `UserPath`: The user PATH (default: the registry's, expanded).
#
# Returns:
#   - pscustomobject: `State`, one of OnPath, Shadowed or NotOnPath, and `Found`, the first copy's full path.
function Find-OnPath {
    ...
}
```

### Every other comment

Every other comment is `#` line comments, full sentences, filled to column 120. `<# #>` is for comment-based help
alone. A comment explains why the code has a non-obvious shape, especially when it works around native command
parsing, Windows Terminal behavior, transcript naming, or path semantics; it does not narrate the statement it
precedes.

## 11. Validation

Every change is followed by a focused check before further edits:

- Parse the script with PowerShell's language parser.
- Check the first line: it is exactly `#!/usr/bin/env pwsh`, and the file's first two bytes are `#!`. A UTF-8 BOM
  ahead of the shebang still parses, but it hides the shebang from the loader.
- Verify every function has `[CmdletBinding()]` and an immediate `param()` block.
- Verify every function is documented in the form section 10 gives it: comment-based help in a file that is
  dot-sourced, and for a script's entry point; a Go-style header for every other function.
- Check brace placement and blank-line rules when formatting changes are involved.
- Run the narrowest available behavior check without launching interactive workflows unnecessarily.
- Fix every parser, lint, or validation issue as discovered; do not pass by warnings or errors.

A launcher should be validated without invoking its external interactive session unless the test specifically
requires it.

[ms-guide]: https://learn.microsoft.com/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines
[ms-output]: https://learn.microsoft.com/powershell/scripting/developer/cmdlet/types-of-cmdlet-output
[parameters]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters
[preferences]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables
[output-streams]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_output_streams
[test-connection]: https://github.com/PowerShell/PowerShell/issues/6768
[preferences-in-modules]: https://github.com/PowerShell/PowerShell/issues/4568
