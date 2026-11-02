#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    Runs every PowerShell test under tests/, each in a pwsh of its own.

.DESCRIPTION
    The Windows half of make test (#312): each tests\*.ps1 runs in a pwsh of its own, and the run fails when any of
    them does, naming each. On macOS and Linux the other tests are Test-Here's. make test runs it on Windows, as do
    Test-OnHosts on each Windows host it is handed and CI's Windows job.

.EXAMPLE
    pwsh -NoProfile -File bin\Test-Here.ps1
#>

#Requires -Version 7.3

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$failed = [Collections.Generic.List[string]]::new()
$tests = Join-Path -Path $PSScriptRoot -ChildPath '..\tests'

foreach ($test in Get-ChildItem -LiteralPath $tests -Filter '*.ps1' -File) {
    & pwsh -NoProfile -NonInteractive -File $test.FullName

    if ($LASTEXITCODE -ne 0) {
        $failed.Add($test.Name)
    }
}

if ($failed.Count -ne 0) {
    throw "Failed: $($failed -join ', ')"
}
