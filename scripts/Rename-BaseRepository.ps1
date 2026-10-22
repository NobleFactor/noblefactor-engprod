#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    The base layer's clone follows its repository's new name on this machine.

.DESCRIPTION
    The Windows half of docs/plans/chore/304-rename-engprod.md, Requirement 2, run once on each machine after the
    repository is renamed on GitHub. Reads the base layer's root from writ's registration, never from an assumed
    path, and in order: renames the root so writ's project name follows; re-points origin; repairs every worktree of
    the clone; re-registers the layer with writ; moves the Workspace link and Start-Claude's store; deploys; and
    checks that a deployed link resolves into the renamed root and that writ reconcile reports every entry linked.
    Refuses a dirty root. With -DryRun, narrates every step and changes nothing. The narration is on the verbose
    stream, as the style guide's section 7 says, so run with -Verbose to read it; the result is one object naming the
    renamed root, origin and the worktrees repaired.

.PARAMETER To
    The repository's new name. Default: noblefactor-engprod.

.PARAMETER Url
    origin's new URL. Default: git@github.com:<organization>/<To>.git, the organization read from origin today.

.PARAMETER DryRun
    Print every step and change nothing.

.EXAMPLE
    C:/Users/<you>/Workspace/NobleFactor/noblefactor-ops/scripts/Rename-BaseRepository.ps1 -DryRun -Verbose
#>

#Requires -Version 7.0

[CmdletBinding()]
param(
    [string]
    $To = 'noblefactor-engprod',

    [string]
    $Url = '',

    [switch]
    $DryRun
)

$callerErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

###########
# Helper functions
###########

# Say narrates one step on the verbose stream, where the style guide's section 7 puts what a script is doing.
function Say {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Message
    )

    Write-Verbose "[Rename-BaseRepository] $Message"
}

# Assert-NativeSuccess throws when the last native command failed, which $ErrorActionPreference does not cover.
function Assert-NativeSuccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Operation
    )

    if ($LASTEXITCODE -ne 0) {
        throw "$Operation failed with exit code $LASTEXITCODE."
    }
}

# Invoke-Step narrates a step and runs it, or only narrates it under -DryRun.
function Invoke-Step {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Description,

        [Parameter(Mandatory)]
        [scriptblock]
        $Action
    )

    if ($DryRun) {
        Say "would: $Description"
    }
    else {
        Say $Description
        & $Action
    }
}

###########
# Main
###########

try {

foreach ($tool in 'writ', 'git') {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "$tool is not on PATH."
    }
}

$registrations = writ repo list -o json | ConvertFrom-Json
Assert-NativeSuccess 'writ repo list'
$base = $registrations | Where-Object { $_.layer -eq 'base' } | Select-Object -First 1

if (-not $base -or -not (Test-Path -LiteralPath $base.root -PathType Container)) {
    throw 'writ registers no base layer with a root on this machine.'
}

$root = $base.root
$oldName = Split-Path -Path $root -Leaf
$reposHome = Split-Path -Path $root -Parent
$newRoot = Join-Path -Path $reposHome -ChildPath $To
$origin = git -C $root remote get-url origin
Assert-NativeSuccess 'git remote get-url'
$org = ($origin -replace '\.git$', '') -replace '^.*[:/]([^/]+)/[^/]+$', '$1'

if (-not $Url) {
    $Url = "git@github.com:$org/$To.git"
}

$workspace = Join-Path -Path $HOME -ChildPath 'Workspace' -AdditionalChildPath $org
$stateHome = $env:XDG_STATE_HOME

if (-not $stateHome) {
    $stateHome = Join-Path -Path $HOME -ChildPath '.local' -AdditionalChildPath 'state'
}

$store = Join-Path -Path $stateHome -ChildPath 'agent-schedule' -AdditionalChildPath $org

Say "base layer root: $root (origin $origin)"
Say "renaming $oldName to $To; origin to $Url"

if ($oldName -eq $To) {
    Say "the root is already named $To; nothing to do"
    return
}

if (Test-Path -LiteralPath $newRoot) {
    throw "$newRoot already exists; refusing."
}

$dirty = git -C $root status --porcelain
Assert-NativeSuccess 'git status'

if ($dirty) {
    throw "the root has uncommitted changes; refusing:`n$($dirty -join "`n")"
}

# The worktrees of the clone, whose .git files point into the root and need repairing after the move.
$worktrees = @(git -C $root worktree list --porcelain | Where-Object { $_ -like 'worktree *' } | Select-Object -Skip 1 | ForEach-Object { $_.Substring(9) })
Assert-NativeSuccess 'git worktree list'

# 1. The root, so writ's project name follows.
Invoke-Step "Move-Item $root $newRoot" { Move-Item -LiteralPath $root -Destination $newRoot }

# 2. origin.
Invoke-Step "git -C $newRoot remote set-url origin $Url" {
    git -C $newRoot remote set-url origin $Url
    Assert-NativeSuccess 'git remote set-url'
}

# 3. The worktrees.
if ($worktrees.Count -gt 0) {
    Invoke-Step "git -C $newRoot worktree repair $($worktrees -join ' ')" {
        git -C $newRoot worktree repair @worktrees
        Assert-NativeSuccess 'git worktree repair'
    }
}

# 4. writ's registration.
Invoke-Step "writ repo set base $newRoot" {
    writ repo set base $newRoot
    Assert-NativeSuccess 'writ repo set'
}

# 5. The Workspace link.
$oldLink = Join-Path -Path $workspace -ChildPath $oldName
$newLink = Join-Path -Path $workspace -ChildPath $To

if ((Test-Path -LiteralPath $oldLink) -and (Get-Item -LiteralPath $oldLink).LinkType) {
    Invoke-Step "Remove-Item $oldLink" { Remove-Item -LiteralPath $oldLink }
}

Invoke-Step "New-Item -ItemType SymbolicLink $newLink -> $newRoot" {
    New-Item -ItemType SymbolicLink -Path $newLink -Target $newRoot | Out-Null
}

# 6. Start-Claude's store, keyed by the repository's name.
$oldStore = Join-Path -Path $store -ChildPath $oldName
$newStore = Join-Path -Path $store -ChildPath $To

if (Test-Path -LiteralPath $oldStore -PathType Container) {
    Invoke-Step "Move-Item $oldStore $newStore" { Move-Item -LiteralPath $oldStore -Destination $newStore }
}

# 7. Deploy, then rule 5's checks.
Invoke-Step 'writ deploy' {
    writ deploy
    Assert-NativeSuccess 'writ deploy'
}

if ($DryRun) {
    Say 'dry run: nothing changed; the checks run on a real run'
    return
}

$link = Join-Path -Path $HOME -ChildPath '.local' -AdditionalChildPath 'bin', 'git-open-branch'
$resolved = (Get-Item -LiteralPath $link).Target

if (-not $resolved -or -not $resolved.StartsWith($newRoot)) {
    throw "$link resolves to '$resolved', not into $newRoot."
}

Say "$link resolves into $newRoot"

$entries = (writ reconcile -o json | ConvertFrom-Json).entries
Assert-NativeSuccess 'writ reconcile'
$notLinked = @($entries | Where-Object { $_.state -ne 'linked' }).Count

if ($notLinked -ne 0) {
    throw "writ reconcile reports $notLinked entries not linked."
}

Say 'writ reconcile: every entry linked'

[PSCustomObject]@{
    Root      = $newRoot
    Origin    = $Url
    Worktrees = $worktrees.Count
}

}
catch {
    $ErrorActionPreference = $callerErrorAction
    $PSCmdlet.WriteError($_)
    exit 1
}
