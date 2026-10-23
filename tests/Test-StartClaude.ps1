#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    Tests Start-Claude.ps1 against a stand-in for claude, on Windows.

.DESCRIPTION
    Runs the cases Test-StartClaude runs against Start-Claude on macOS and Linux, from the same table: every form
    -Resume takes and each of its refusals, by its error id and category; the background session's short id alone on
    the output, detached, and attached; the refusals of usage; and a refusal's exit status, run as a process
    (David-Noble-at-work/personal#273, questions 11 and 12). Then every way in, with a schedule and without, each
    checking the schedule's entry in the store, and row 2 of personal#259's plan, a conversation resumed in another
    clone that -Continue finds there (NobleFactor/noblefactor-ops#322); and a -Detach wake of a stopped session, which
    keeps the launch's name (NobleFactor/noblefactor-ops#260).

    Each case is an output object whose Result is passed, failed or skipped. A failure ends the run with a terminating
    error, so that run as a process it exits 1.

    The stand-in for claude, claude.cmd, is first on PATH, with claude's configuration, a store and a startup
    repository of the run's own, in a folder under the temporary directory that the run removes. The stand-in for gh,
    gh.cmd, answers for schedule 7 of the startup repository's origin, and for nothing else. psmux, as tmux, is the
    real one where it is installed. Where it is not, as on a CI runner, a stand-in that refuses every command takes its
    place, since Start-Claude.ps1 requires tmux and only the attached case runs it.

    The attached case needs psmux, a console, and no psmux server running: a pane finds claude on its server's PATH, so
    on a server started before the run its viewer would not be the stand-in. Otherwise it is skipped, and says why.

    With NFEP_AGENT_SCHEDULE_DETACHED_RENAME set, as for Start-Claude.ps1, a case that renames a running session through
    a viewer no client attaches takes the place of the one that leaves it be, and needs psmux and no psmux server
    running, as the attached case does (#384).

.EXAMPLE
    pwsh -NoProfile -File tests\Test-StartClaude.ps1
#>

#Requires -Version 7.3

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

###########
# Helper functions
###########

function ConvertTo-CaseResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]
        $Name,

        [string]
        $Problem,

        [switch]
        $Skipped
    )

    # A case's result: skipped, with why; passed, with nothing wrong; or failed, with each problem found.
    if ($Skipped) {
        return [pscustomobject]@{ Case = $Name; Result = 'skipped'; Detail = $Problem }
    }

    if (-not $Problem) {
        return [pscustomobject]@{ Case = $Name; Result = 'passed'; Detail = '' }
    }

    return [pscustomobject]@{ Case = $Name; Result = 'failed'; Detail = $Problem.TrimEnd('; ') }
}

function Initialize-RunFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    # The stand-in for claude, which lists one background session, abcd1234, named "probe session", whose conversation,
    # abcd1234-0000-4000-8000-000000000009, has no transcript, and the case can change it through the STAND_IN
    # variables: STAND_IN_STATE lists it stopped, and STAND_IN_LOG names a file where each claude --bg it is given is
    # written, one line each, its arguments joined by the unit separator. Its viewer stays a second, then leaves. A
    # background resume answers as claude does, its short id the conversation's first eight characters, and a new
    # conversation comes up as background session fedc4321. It writes UTF-8, as claude does. claude.cmd, on PATH, runs
    # it, since Start-Claude.ps1 runs claude as an application; the script is kept off PATH, where PowerShell would find
    # it before claude.cmd.
    $bin = Join-Path -Path $Path -ChildPath 'bin'
    $standIn = Join-Path -Path $Path -ChildPath 'stand-in'
    $null = New-Item -ItemType Directory -Path $bin, $standIn
    Set-Content -LiteralPath (Join-Path -Path $bin -ChildPath 'claude.cmd') -Encoding ascii -Value (
        '@pwsh -NoProfile -NonInteractive -File "%~dp0..\stand-in\claude.ps1" %*')
    Set-Content -LiteralPath (Join-Path -Path $standIn -ChildPath 'claude.ps1') -Encoding utf8 -Value @'
$arguments = @($args)
$standardOutput = [Console]::OpenStandardOutput()

function Write-Utf8Line {
    [CmdletBinding()]
    param([string]$Text)

    $bytes = [Text.UTF8Encoding]::new($false).GetBytes("$Text`n")
    $standardOutput.Write($bytes, 0, $bytes.Length)
}

switch ($arguments[0]) {
    'agents' {
        $state = if ($env:STAND_IN_STATE) { $env:STAND_IN_STATE } else { 'running' }
        $name = $env:STAND_IN_NAME
        $renamed = Join-Path -Path $env:STAND_IN_DIR -ChildPath 'renamed'

        if (Test-Path -LiteralPath $renamed -PathType Leaf) {
            $name = Get-Content -LiteralPath $renamed -Raw -Encoding utf8
        }

        $session = [ordered]@{
            id = $env:STAND_IN_ID; cwd = $env:STAND_IN_CWD; kind = 'background'; startedAt = 1760000000000
            sessionId = $env:STAND_IN_SESSION; name = $name; state = $state
        }
        Write-Utf8Line (ConvertTo-Json -InputObject @($session) -Compress)
        exit 0
    }
    'attach' {
        # It draws its input line and takes one line typed into it, two seconds at most, then leaves; a /rename it
        # takes renames the session, as claude does, through renamed in STAND_IN_DIR (#384).
        Write-Utf8Line ([string][char]0x276F + ' ')
        $deadline = (Get-Date).AddSeconds(2)

        try {

            while ((Get-Date) -lt $deadline) {

                if ([Console]::KeyAvailable) {
                    $line = [Console]::ReadLine()

                    if ($line) {
                        Add-Content -LiteralPath (Join-Path -Path $env:STAND_IN_DIR -ChildPath 'typed') -Encoding utf8 `
                            -Value $line
                    }

                    if ($line -and $line.StartsWith('/rename ')) {
                        Set-Content -LiteralPath (Join-Path -Path $env:STAND_IN_DIR -ChildPath 'renamed') `
                            -Encoding utf8 -NoNewline -Value $line.Substring('/rename '.Length)
                    }

                    break
                }

                Start-Sleep -Milliseconds 100
            }

        }
        catch [InvalidOperationException] {
            # No console to read keys from: it leaves after a second, as before.
            Start-Sleep -Seconds 1
        }

        exit 0
    }
    '--bg' {
        if ($env:STAND_IN_LOG) {
            Add-Content -LiteralPath $env:STAND_IN_LOG -Encoding utf8 -Value ($arguments -join [char]0x1f)
        }

        if ($arguments -contains '--continue') {
            [Console]::Error.WriteLine('stand-in claude: --bg --continue is not handled')
            exit 1
        }

        $started = 'fedc4321'
        $index = [Array]::IndexOf($arguments, '--resume')

        if ($index -ge 0) {
            $started = [String]$arguments[$index + 1]
        }

        # A flag on a wake of the listed session starts a copy, as claude does (anthropics/claude-code#104658).
        $flags = @($arguments | Select-Object -Skip ($index + 2) | Where-Object { ([String]$_).StartsWith('-') })

        if ($index -ge 0 -and $flags.Count -gt 0 -and ($started -ceq $env:STAND_IN_ID -or
                $started -ceq $env:STAND_IN_SESSION)) {
            $note = "note: background session $env:STAND_IN_ID keeps its own saved options, so the flags you passed"
            Write-Utf8Line "$note started a copy as cccc0000."
            $started = 'cccc0000'
        }

        $short = $started.Substring(0, 8)
        Write-Utf8Line ('backgrounded ' + [char]0x00B7 + " $short")
        Write-Utf8Line "  claude attach $short"
        exit 0
    }
    default {
        [Console]::Error.WriteLine("stand-in claude: not handled: $arguments")
        exit 1
    }
}
'@

    # The stand-in for gh: schedule 7 of the startup repository's origin, as Start-Claude.ps1 reads it, and nothing
    # else. gh.cmd, on PATH, runs it, as claude.cmd runs claude's.
    Set-Content -LiteralPath (Join-Path -Path $bin -ChildPath 'gh.cmd') -Encoding ascii -Value (
        '@pwsh -NoProfile -NonInteractive -File "%~dp0..\stand-in\gh.ps1" %*')
    Set-Content -LiteralPath (Join-Path -Path $standIn -ChildPath 'gh.ps1') -Encoding utf8 -Value @'
$arguments = @($args)

if ($arguments.Count -ge 5 -and $arguments[0] -ceq 'issue' -and $arguments[1] -ceq 'view' -and
    $arguments[2] -ceq '7' -and $arguments[3] -ceq '--repo' -and $arguments[4] -ceq 'example/start-claude-test') {
    $issue = '{"labels":[{"name":"chore"}],"title":"Schedule: probe",'
    $issue += '"url":"https://github.com/example/start-claude-test/issues/7"}'
    [Console]::Out.WriteLine($issue)
    exit 0
}

[Console]::Error.WriteLine("stand-in gh: not handled: $arguments")
exit 1
'@

    # Where psmux is missing, as on a CI runner, a tmux that refuses every command: Start-Claude.ps1 requires tmux, and
    # no case but the attached one runs it.
    if (-not $script:psmux) {
        Set-Content -LiteralPath (Join-Path -Path $bin -ChildPath 'tmux.cmd') -Encoding ascii -Value @(
            '@echo stand-in tmux: not handled: %* 1>&2', '@exit /b 1')
    }

    # The transcripts the cases name, each recording the names its conversation was given, the last its own.
    $projects = Join-Path -Path $Path -ChildPath 'config\projects\test-project'
    $null = New-Item -ItemType Directory -Path $projects
    $titles = [ordered]@{
        'eeee5555-0000-4000-8000-000000000002' = @('probe transcript')
        'ffff6666-0000-4000-8000-000000000003' = @('twin name')
        'ffff7777-0000-4000-8000-000000000004' = @('twin name')
        '99998888-0000-4000-8000-000000000005' = @('old name', 'new name')
    }

    foreach ($session in $titles.Keys) {
        $lines = foreach ($title in $titles[$session]) {
            ConvertTo-Json -Compress -InputObject ([ordered]@{
                    type = 'custom-title'; customTitle = $title; sessionId = $session
                })
        }

        Set-Content -LiteralPath (Join-Path -Path $projects -ChildPath "$session.jsonl") -Encoding utf8 -Value $lines
    }

    $notes = Join-Path -Path $projects -ChildPath 'notes.jsonl'
    Set-Content -LiteralPath $notes -Encoding utf8 -Value '{"type":"user"}'

    # The store, and the startup repository, with an origin, since Start-Claude.ps1 names the repository from it.
    $null = New-Item -ItemType Directory -Path (Join-Path -Path $Path -ChildPath 'state')
    $repository = Join-Path -Path $Path -ChildPath 'repository'
    $null = & git init --quiet $repository

    if ($LASTEXITCODE -ne 0) {
        throw "git init failed in $repository."
    }

    $null = & git -C $repository remote add origin 'https://github.com/example/start-claude-test.git'

    if ($LASTEXITCODE -ne 0) {
        throw "git remote add failed in $repository."
    }

    # Row 2's: a second clone of the repository, a folder claude lists nothing in, and, in the second clone's own
    # project folder, the newest transcript of all, written last, the one claude's own --continue would take.
    $clone = Join-Path -Path $Path -ChildPath 'clone'
    $null = & git init --quiet $clone

    if ($LASTEXITCODE -ne 0) {
        throw "git init failed in $clone."
    }

    $null = & git -C $clone remote add origin 'https://github.com/example/start-claude-test.git'

    if ($LASTEXITCODE -ne 0) {
        throw "git remote add failed in $clone."
    }

    $cloneProject = Join-Path -Path $Path -ChildPath 'config\projects\clone-project'
    $null = New-Item -ItemType Directory -Path (Join-Path -Path $Path -ChildPath 'elsewhere'), $cloneProject
    $newest = ConvertTo-Json -Compress -InputObject ([ordered]@{
            type = 'custom-title'; customTitle = 'newest transcript'; sessionId = 'aaaa1111-0000-4000-8000-00000000000a'
        })
    Set-Content -LiteralPath (Join-Path -Path $cloneProject -ChildPath 'aaaa1111-0000-4000-8000-00000000000a.jsonl') `
        -Encoding utf8 -Value $newest
}

# Invoke-StartClaudeCase runs Start-Claude.ps1 in this process with the parameters a case gives, and checks it.
#
# Start-Claude.ps1 runs under SilentlyContinue, then its output and its error records are checked: the id the case
# expects, alone, with no error; or, at a refusal, no output and an error record with the case's id, if it names one,
# and the category its kind of refusal takes. With CheckStore, schedule 7's entry in the store is checked as well.
#
# Parameters:
#   - `Name`: The case's name.
#   - `Expected`: The background session's short id the case expects, or a refusal: usage, data-error or not-found.
#   - `ErrorId`: The error id a refusal must carry (default: any).
#   - `Parameter`: Start-Claude.ps1's parameters, but -Directory.
#   - `Directory`: The startup directory (default: the run's startup repository).
#   - `CheckStore`: Check schedule 7's entry in the store.
#   - `Held`: With CheckStore, the id the entry must hold, or nothing when there must be no entry.
#
# Returns:
#   - PSCustomObject: the case's result, as ConvertTo-CaseResult makes it.
function Invoke-StartClaudeCase {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter(Mandatory)]
        [String]
        $Expected,

        [String]
        $ErrorId,

        [Parameter(Mandatory)]
        [Hashtable]
        $Parameter,

        [String]
        $Directory = $script:repository,

        [Switch]
        $CheckStore,

        [String]
        $Held
    )

    $category = @{ 'usage' = 'InvalidArgument'; 'data-error' = 'InvalidData'; 'not-found' = 'ObjectNotFound' }
    $caught = $null
    $output = @(& $script:startClaude @Parameter -Directory $Directory -ErrorVariable caught `
            -ErrorAction SilentlyContinue)
    $problem = ''

    if ($CheckStore) {
        $entry = Join-Path -Path $script:store -ChildPath '7'

        if ($Held) {
            $entryHeld = Get-Content -LiteralPath $entry -TotalCount 1 -ErrorAction Ignore

            if ($entryHeld -cne $Held) {
                $problem += "schedule 7's entry held '$entryHeld', not $Held; "
            }

        }
        elseif (Test-Path -LiteralPath $entry) {
            $problem += "schedule 7 has an entry, holding '$(Get-Content -LiteralPath $entry -TotalCount 1)', where "
            $problem += 'it must have none; '
        }

    }

    if (-not $category.ContainsKey($Expected)) {

        if ($caught.Count -ne 0) {
            $problem += "it refused: $($caught[0].FullyQualifiedErrorId): $($caught[0].Exception.Message); "
        }

        if ($output.Count -ne 1 -or $output[0] -cne $Expected) {
            $problem += "its output was [$($output -join '|')], not $Expected alone; "
        }

    }
    else {

        if ($output.Count -ne 0) {
            $problem += "its output was [$($output -join '|')] at a refusal; "
        }

        if ($caught.Count -eq 0) {
            $problem += 'it wrote no error record; '
        }
        else {
            $id = ($caught[0].FullyQualifiedErrorId -split ',')[0]
            $found = [string]$caught[0].CategoryInfo.Category

            if ($ErrorId -and $id -cne $ErrorId) {
                $problem += "its error id was $id, not $ErrorId; "
            }

            if ($found -cne $category[$Expected]) {
                $problem += "its category was $found, not $($category[$Expected]); "
            }

        }

    }

    return ConvertTo-CaseResult -Name $Name -Problem $problem
}

# Clear-TestStore removes every entry in the run's store, so that a case begins with no schedule's session recorded,
# and the stand-in's record of what was typed into its viewer and the name it took.
function Clear-TestStore {
    [CmdletBinding()]
    param()

    Remove-Item -LiteralPath (Join-Path -Path $env:XDG_STATE_HOME -ChildPath 'agent-schedule') -Recurse -Force `
        -ErrorAction Ignore
    Remove-Item -LiteralPath (Join-Path -Path $env:STAND_IN_DIR -ChildPath 'typed'),
        (Join-Path -Path $env:STAND_IN_DIR -ChildPath 'renamed') -Force -ErrorAction Ignore
}

# Write-TestStoreEntry records a session as schedule 7's, as Start-Claude.ps1 records one.
#
# Parameters:
#   - `Id`: The session's id: a background session's short id, or a conversation's id.
function Write-TestStoreEntry {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]
        $Id
    )

    $null = New-Item -ItemType Directory -Path $script:store -Force
    Set-Content -LiteralPath (Join-Path -Path $script:store -ChildPath '7') -Encoding ascii -Value $Id
}

# Invoke-WakeCase runs a -Detach launch of schedule 7, whose entry holds the stand-in's session, listed under a name, as
# Invoke-StartClaudeCase runs one, then checks the claude --bg it ran (#384). Listed stopped, the session is woken with
# no flag, which would start a copy, and with /rename and the launch's name, the schedule's key first and its title
# last, as the wake's first prompt when the listed name is another, or no prompt when it is the launch's. Listed
# running, it is not woken, and without NFEP_AGENT_SCHEDULE_DETACHED_RENAME nothing renames it. The first case keeps
# the launch's name, from the prompt, for the cases after it.
#
# Parameters:
#   - `Name`: The case's name.
#   - `Listed`: The name the stand-in lists the session under.
#   - `State`: The state the stand-in lists it in: stopped, or running.
#   - `Expected`: What the wake's prompt must be: rename, or none; for a running session, none.
#
# Returns:
#   - PSCustomObject: the case's result, as ConvertTo-CaseResult makes it.
function Invoke-WakeCase {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String]
        $Listed,

        [Parameter(Mandatory)]
        [ValidateSet('stopped', 'running')]
        [String]
        $State,

        [Parameter(Mandatory)]
        [ValidateSet('rename', 'none')]
        [String]
        $Expected
    )

    $log = Join-Path -Path $env:XDG_STATE_HOME -ChildPath 'claude-bg.log'
    Clear-TestStore
    Write-TestStoreEntry -Id 'abcd1234'
    Set-Content -LiteralPath $log -Encoding utf8 -Value @()
    $env:STAND_IN_STATE = $State
    $env:STAND_IN_LOG = $log
    $env:STAND_IN_NAME = $Listed

    try {
        $result = Invoke-StartClaudeCase -Name $Name -Expected 'abcd1234' -CheckStore -Held 'abcd1234' `
            -Parameter @{ Schedule = '7'; Detach = $true }
    }
    finally {
        $env:STAND_IN_STATE = $null
        $env:STAND_IN_LOG = $null
        $env:STAND_IN_NAME = 'probe session'
    }

    $problem = if ($result.Result -ceq 'failed') { "$($result.Detail); " } else { '' }
    $separator = [string][char]0x1f
    $woke = @(Get-Content -LiteralPath $log -Encoding utf8 -ErrorAction Ignore) |
        Where-Object { $_.Split($separator) -ccontains '--resume' } | Select-Object -Last 1

    if ($State -ceq 'running') {

        if ($woke) {
            $problem += "a running session was woken: $($woke.Replace($separator, ' ')); "
        }

        return ConvertTo-CaseResult -Name $Name -Problem $problem
    }

    if (-not $woke) {
        $problem += 'no claude --bg --resume woke the stopped session; '
        return ConvertTo-CaseResult -Name $Name -Problem $problem
    }

    # The stand-in's record: --bg, --resume, the conversation, then what the wake gave beyond them.
    $field = $woke.Split($separator)

    foreach ($extra in @($field | Select-Object -Skip 3 | Where-Object { $_.StartsWith('-') })) {
        $problem += "the wake carried $extra, which starts a copy; "
    }

    $prompt = if ($field.Count -gt 3) { $field[3] } else { '' }
    $keyFirst = $prompt.StartsWith('/rename example/start-claude-test#7 | ', [StringComparison]::Ordinal)
    $titleLast = $prompt.EndsWith(' | Schedule: probe', [StringComparison]::Ordinal)

    if ($Expected -ceq 'none' -and $prompt) {
        $problem += "the wake's prompt was '$prompt', where claude lists the launch's name; "
    }
    elseif ($Expected -ceq 'rename' -and -not ($keyFirst -and $titleLast)) {
        $problem += "the wake's prompt was '$prompt', not /rename with the launch's name; "
    }

    if ($Expected -ceq 'rename' -and -not $script:launchName) {
        $script:launchName = $prompt.Substring('/rename '.Length)
    }

    return ConvertTo-CaseResult -Name $Name -Problem $problem
}

function Invoke-ProcessCase {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    # A refusal, Start-Claude.ps1 run as a process: it must exit 1, and write nothing to its output.
    $output = @(& pwsh -NoProfile -NonInteractive -File $script:startClaude -Resume 'no such name' -Detach `
            -Directory $script:repository 2>$null)
    $status = $LASTEXITCODE
    $problem = ''

    if ($status -ne 1) {
        $problem += "its exit status was $status, not 1; "
    }

    if ($output.Count -ne 0) {
        $problem += "its output was [$($output -join '|')]; "
    }

    return ConvertTo-CaseResult -Name $Name -Problem $problem
}

# Invoke-DetachedRenameCase runs a -Detach launch of schedule 7 onto the stand-in's session, listed running under
# another name than the launch's, with NFEP_AGENT_SCHEDULE_DETACHED_RENAME set, then checks what was typed into the
# viewer the launch opened for it: /rename with the launch's name (#384, requirement 2). Like the attached case it needs
# psmux and no psmux server running, since a pane finds claude on its server's PATH; otherwise it is skipped, and says
# why.
#
# Parameters:
#   - `Name`: The case's name.
#
# Returns:
#   - PSCustomObject: the case's result, as ConvertTo-CaseResult makes it.
function Invoke-DetachedRenameCase {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [String]
        $Name
    )

    if (-not $script:psmux) {
        return ConvertTo-CaseResult -Name $Name -Skipped -Problem 'no psmux on this machine'
    }

    $null = & tmux list-sessions 2>$null

    if ($LASTEXITCODE -eq 0) {
        $reason = "a psmux server is running, whose panes find claude on the server's own PATH, not the stand-in: "
        $reason += 'end its sessions and run again to include this case'
        return ConvertTo-CaseResult -Name $Name -Skipped -Problem $reason
    }

    Clear-TestStore
    Write-TestStoreEntry -Id 'abcd1234'
    $result = Invoke-StartClaudeCase -Name $Name -Expected 'abcd1234' -CheckStore -Held 'abcd1234' `
        -Parameter @{ Schedule = '7'; Detach = $true }
    $problem = if ($result.Result -ceq 'failed') { "$($result.Detail); " } else { '' }
    $typedPath = Join-Path -Path $env:STAND_IN_DIR -ChildPath 'typed'
    $typed = @(Get-Content -LiteralPath $typedPath -Encoding utf8 -ErrorAction Ignore) -join '|'

    if ($typed -cne "/rename $script:launchName") {
        $problem += "'$typed' was typed into a viewer, not /rename with the launch's name; "
    }

    return ConvertTo-CaseResult -Name $Name -Problem $problem
}

function Invoke-AttachedCase {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    # Attached in this console onto the stand-in's background session: the viewer leaves after a second, and its own
    # tmux kill-session ends the psmux session; the session's short id must then be the output, alone, with no psmux
    # session left of its name.
    if (-not $script:psmux) {
        return ConvertTo-CaseResult -Name $Name -Skipped -Problem 'no psmux on this machine'
    }

    if ([Console]::IsInputRedirected) {
        return ConvertTo-CaseResult -Name $Name -Skipped -Problem 'no console: its input is redirected'
    }

    $null = & tmux list-sessions 2>$null

    if ($LASTEXITCODE -eq 0) {
        $reason = "a psmux server is running, whose panes find claude on the server's own PATH, not the stand-in: "
        $reason += 'end its sessions and run again to include this case'
        return ConvertTo-CaseResult -Name $Name -Skipped -Problem $reason
    }

    $caught = $null
    $output = @(& $script:startClaude -Resume abcd1234 -Directory $script:repository -ErrorVariable caught `
            -ErrorAction SilentlyContinue)
    $problem = ''

    if ($caught.Count -ne 0) {
        $problem += "it refused: $($caught[0].FullyQualifiedErrorId): $($caught[0].Exception.Message); "
    }

    if ($output.Count -ne 1 -or $output[0] -cne 'abcd1234') {
        $problem += "its output was [$($output -join '|')], not abcd1234 alone; "
    }

    $left = @(& tmux list-sessions -F '#{session_name}' 2>$null | Where-Object { $_ -like "$env:STAND_IN_SESSION *" })

    if ($left.Count -ne 0) {
        $problem += "psmux sessions remain: $($left -join ', '); "
    }

    return ConvertTo-CaseResult -Name $Name -Problem $problem
}

###########
# Main
###########

if (-not $IsWindows) {
    throw 'Test-StartClaude.ps1 tests Start-Claude.ps1, which runs on Windows; Test-StartClaude tests Start-Claude.'
}

$script:startClaude = Join-Path -Path $PSScriptRoot -ChildPath '..\Home\common.Windows\.local\bin\Start-Claude.ps1'
$script:psmux = [bool](Get-Command -Name 'tmux' -CommandType Application -ErrorAction Ignore)
$run = Join-Path -Path ([IO.Path]::GetTempPath()) -ChildPath "Test-StartClaude-$([guid]::NewGuid().ToString('N'))"
$script:repository = Join-Path -Path $run -ChildPath 'repository'
$script:clone = Join-Path -Path $run -ChildPath 'clone'
$script:store = Join-Path -Path $run -ChildPath 'state\agent-schedule\example\start-claude-test'

# The launch's name, as the first wake case finds it in the wake's prompt, for the cases after it.
$script:launchName = ''
$projects = Join-Path -Path $run -ChildPath 'config\projects\test-project'
$saved = @{}

foreach ($name in 'PATH', 'XDG_STATE_HOME', 'CLAUDE_CONFIG_DIR', 'STAND_IN_ID', 'STAND_IN_SESSION', 'STAND_IN_NAME',
    'STAND_IN_CWD', 'STAND_IN_STATE', 'STAND_IN_LOG', 'STAND_IN_DIR', 'TMUX') {
    $saved[$name] = [Environment]::GetEnvironmentVariable($name)
}

$results = [Collections.Generic.List[object]]::new()

try {
    $null = New-Item -ItemType Directory -Path $run
    Initialize-RunFolder -Path $run

    $env:PATH = (Join-Path -Path $run -ChildPath 'bin') + [IO.Path]::PathSeparator + $env:PATH
    $env:XDG_STATE_HOME = Join-Path -Path $run -ChildPath 'state'
    $env:CLAUDE_CONFIG_DIR = Join-Path -Path $run -ChildPath 'config'
    $env:STAND_IN_ID = 'abcd1234'
    $env:STAND_IN_SESSION = 'abcd1234-0000-4000-8000-000000000009'
    $env:STAND_IN_NAME = 'probe session'
    $env:STAND_IN_CWD = $script:repository
    $env:STAND_IN_DIR = $run
    $env:TMUX = $null

    # Every form -Resume takes, and each refusal, one line each: the case, the argument, what it must give (the id, or
    # not-found or data-error), and the error id Start-Claude.ps1 must give. Test-StartClaude holds the same table, line
    # for line. {projects} is the stand-in configuration's project folder.
    $caseTable = @'
short id | abcd1234 | abcd1234 |
full id claude lists, with no transcript | abcd1234-0000-4000-8000-000000000009 | abcd1234 |
full id in capitals | ABCD1234-0000-4000-8000-000000000009 | abcd1234 |
full id of a transcript claude does not list | eeee5555-0000-4000-8000-000000000002 | eeee5555 |
full id nothing holds | 00000000-0000-4000-8000-00000000000f | not-found | ConversationNotFound
short id claude does not list | 12345678 | not-found | BackgroundSessionNotFound
transcript path | {projects}/eeee5555-0000-4000-8000-000000000002.jsonl | eeee5555 |
transcript path with no file | {projects}/00000000-0000-4000-8000-0000000000aa.jsonl | not-found | TranscriptNotFound
transcript path not named for an id | {projects}/notes.jsonl | data-error | TranscriptNotNamedForId
name claude lists for its background session | probe session | abcd1234 |
the last name a transcript records | new name | 99998888 |
an earlier name a transcript records | old name | not-found | ConversationNotFound
name two transcripts record | twin name | data-error | ConversationNameAmbiguous
name nothing records | no such name | not-found | ConversationNotFound
'@

    foreach ($line in ($caseTable -split '\r?\n' | Where-Object { $_ })) {
        $name, $argument, $expected, $errorId = $line.Split('|') | ForEach-Object { $_.Trim() }
        $argument = $argument.Replace('{projects}', $projects).Replace('/', [IO.Path]::DirectorySeparatorChar)
        $result = Invoke-StartClaudeCase -Name "-Resume, $name" -Expected $expected -ErrorId $errorId `
            -Parameter @{ Resume = $argument; Detach = $true }
        $results.Add($result)
        $result
    }

    # Every way in, with a schedule and without (#322), on schedule 7, which the stand-in for gh answers for; -Resume
    # alone is the table's cases above. Each case begins from a store holding what it names, and checks the entry it
    # leaves. Then row 2 of personal#259's plan: the conversation -Schedule with -Directory resumes in another clone,
    # which claude then lists there, is the one -Continue finds there, and not the newest transcript in that clone's
    # project folder, the one claude's own --continue would take.
    $ways = @(
        Clear-TestStore
        Invoke-StartClaudeCase -Name '-Schedule alone, with no entry: a new conversation, its entry written' `
            -Expected 'fedc4321' -CheckStore -Held 'fedc4321' -Parameter @{ Schedule = '7'; Detach = $true }
        Clear-TestStore
        Write-TestStoreEntry -Id 'abcd1234'
        Invoke-StartClaudeCase -Name '-Schedule alone, with an entry: the conversation it holds' `
            -Expected 'abcd1234' -CheckStore -Held 'abcd1234' -Parameter @{ Schedule = '7'; Detach = $true }
        Clear-TestStore
        Invoke-StartClaudeCase -Name '-Resume with -Schedule: the conversation joins the schedule' `
            -Expected 'abcd1234' -CheckStore -Held 'abcd1234' `
            -Parameter @{ Resume = 'abcd1234'; Schedule = '7'; Detach = $true }
        Clear-TestStore
        Invoke-StartClaudeCase -Name '-Continue alone: the conversation claude lists here, on no schedule' `
            -Expected 'abcd1234' -CheckStore -Parameter @{ Continue = $true; Detach = $true }
        Invoke-StartClaudeCase -Name '-Continue with -Schedule: the conversation claude lists here joins the schedule' `
            -Expected 'abcd1234' -CheckStore -Held 'abcd1234' `
            -Parameter @{ Continue = $true; Schedule = '7'; Detach = $true }
        Clear-TestStore
    )

    $env:STAND_IN_CWD = Join-Path -Path $run -ChildPath 'elsewhere'
    $ways += Invoke-StartClaudeCase `
        -Name '-Continue with -Schedule, claude listing none here: refused, nothing started' `
        -Expected 'not-found' -ErrorId 'NoConversationToContinue' -CheckStore `
        -Parameter @{ Continue = $true; Schedule = '7'; Detach = $true }
    $env:STAND_IN_CWD = $script:repository

    Clear-TestStore
    Write-TestStoreEntry -Id 'eeee5555-0000-4000-8000-000000000002'
    $ways += Invoke-StartClaudeCase `
        -Name "row 2: -Schedule with -Directory resumes the schedule's conversation in another clone" `
        -Directory $script:clone -Expected 'eeee5555' -CheckStore -Held 'eeee5555' `
        -Parameter @{ Schedule = '7'; Detach = $true }
    $env:STAND_IN_ID = 'eeee5555'
    $env:STAND_IN_SESSION = 'eeee5555-0000-4000-8000-000000000002'
    $env:STAND_IN_CWD = $script:clone
    $ways += Invoke-StartClaudeCase -Name 'row 2: -Continue in that clone finds that conversation' `
        -Directory $script:clone -Expected 'eeee5555' -CheckStore -Held 'eeee5555' `
        -Parameter @{ Continue = $true; Detach = $true }
    $env:STAND_IN_ID = 'abcd1234'
    $env:STAND_IN_SESSION = 'abcd1234-0000-4000-8000-000000000009'
    $env:STAND_IN_CWD = $script:repository
    Clear-TestStore

    # A -Detach wake of a stopped session passes no flag, which would start a copy, and gives the launch's name as its
    # first prompt only when claude lists the session under another (#384; #260, requirement 3).
    $ways += Invoke-WakeCase `
        -Name 'a -Detach wake of a stopped session listed under another name renames it with its first prompt' `
        -Listed 'probe session' -State 'stopped' -Expected 'rename'
    $ways += Invoke-WakeCase `
        -Name "a -Detach wake of a stopped session listed under the launch's name passes no prompt" `
        -Listed $script:launchName -State 'stopped' -Expected 'none'

    # A running one is renamed with -Detach only when NFEP_AGENT_SCHEDULE_DETACHED_RENAME is set, since claude on
    # Windows takes no keys in a viewer no client attaches (anthropics/claude-code#104688): the cases follow it.
    if ($env:NFEP_AGENT_SCHEDULE_DETACHED_RENAME) {
        $ways += Invoke-DetachedRenameCase -Name ('with NFEP_AGENT_SCHEDULE_DETACHED_RENAME, a -Detach launch onto a ' +
            'running session listed under another name types /rename into a viewer')
    }
    else {
        $ways += Invoke-WakeCase `
            -Name 'a -Detach launch onto a running session listed under another name leaves it be' `
            -Listed 'probe session' -State 'running' -Expected 'none'
    }

    Clear-TestStore

    foreach ($result in $ways) {
        $results.Add($result)
        $result
    }

    # The refusals of usage, a refusal's status run as a process, and the id when the client leaves.
    $more = @(
        Invoke-StartClaudeCase -Name 'no way in' -Expected 'usage' -ErrorId 'OneWayInRequired' `
            -Parameter @{ Detach = $true }
        Invoke-StartClaudeCase -Name '-Detach with -NoRemoteControl' -Expected 'usage' `
            -ErrorId 'RemoteControlRequired' `
            -Parameter @{ Resume = 'abcd1234'; Detach = $true; NoRemoteControl = $true }
        Invoke-ProcessCase -Name 'a refusal, run as a process'
        Invoke-AttachedCase -Name 'attached, the id on the output when the viewer leaves'
    )

    foreach ($result in $more) {
        $results.Add($result)
        $result
    }
}
finally {

    foreach ($name in $saved.Keys) {
        [Environment]::SetEnvironmentVariable($name, $saved[$name])
    }

    Remove-Item -LiteralPath $run -Recurse -Force -ErrorAction Ignore
}

$failed = @($results | Where-Object { $_.Result -ceq 'failed' })

if ($failed.Count -ne 0) {
    throw "$($failed.Count) of the $($results.Count) cases failed."
}
