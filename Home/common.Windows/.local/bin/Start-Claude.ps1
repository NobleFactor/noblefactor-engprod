#!/usr/bin/env pwsh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

<#
.SYNOPSIS
    Opens a schedule's Claude Code conversation, run in claude's background, in a psmux session beside a shell.

.DESCRIPTION
    Every conversation runs in claude's background service, and each start opens a new psmux session onto it:
    claude's viewer, claude attach, on the left, and a shell on the right. psmux is run as tmux, its alias. Leaving
    the viewer ends the psmux session, as detaching does, and claude runs the conversation on until claude stop.
    Start-Claude is its counterpart on macOS and Linux, on tmux.

    The session works a schedule: a GitHub issue of kind chore whose title begins "Schedule:", its lane table
    listing the work. claude's background session is named "<owner>/<repository>#<number> | <host> | <repository> |
    <branch> | <title>", which is also its Remote Control name. Each psmux session onto it is named
    "<repository>#<number> $<id>", the schedule's repository and number and psmux's own id, since psmux loses a
    session whose name carries "/" or "|". A conversation on no schedule names it for its id.

    The store holds each schedule's background session, and a conversation joins a schedule only through the store,
    never through its name. A start reads the schedule's entry under its lock and meets the session where claude
    lists it: a background session, running or stopped, is opened; a conversation a claude runs in the foreground is
    refused; one running nowhere is resumed in claude's background under its own id. With no entry, claude --bg
    starts a new conversation in the startup directory, carrying the schedule and its link, NFEP_AGENT_SCHEDULE and
    NFEP_AGENT_SCHEDULE_URL, through --settings; the shell pane gets them too. claude checks its own trust in the
    folder: what it refuses is passed through in its words, and nothing opens.

    -Schedule with -Title, and -Resume and -Continue, each alone or with -Schedule, are three parameter sets, so
    exactly one of them is given. The schedule is the only positional parameter and the title the only one taken from
    the pipeline, so every argument after the script's own goes to claude as it is; PowerShell itself consumes a bare
    --.

    It starts in -Directory, or else the current directory, which must be the root of a repository clone or of a
    linked worktree; otherwise it stops before anything is named or started.

    It opens the psmux session from a console: Windows Terminal at the desktop, or an ssh session with a terminal.
    With its input redirected, as from a pipe or an ssh command with no terminal, and no -Detach, it starts nothing.
    Inside psmux already, the current client switches to the new session.

    It runs on Windows only, and elsewhere refuses to run.

.PARAMETER Schedule
    The schedule the session works: <owner>/<repository>#<number>, a bare <number> in the startup directory's
    repository, or new. The only positional parameter. It is read with gh from its own repository, never the
    caller's, and an issue that is not a schedule is refused. With new, a schedule opens in the startup directory's
    repository, titled "Schedule: <title>" from -Title, with an empty lane table. Requires gh. Given with -Resume or
    -Continue, it is the schedule the conversation joins, when the schedule has none or the conversation is already
    its own; a schedule another conversation works, and a conversation on another schedule, are refused.

.PARAMETER Title
    The schedule's title without its "Schedule: " prefix, by name or from the pipeline. With -Schedule new it titles
    the new schedule and is required: when it is not given, the prompt "Schedule title:" asks for it, and an empty
    title opens nothing. With any other schedule it is optional; given, it retitles the issue when its title differs.

.PARAMETER Resume
    The conversation to resume, as claude --resume takes it but its picker: its id, a UUID, found in any project
    folder; its background session's short id, as claude lists it; its name, matched whole against the names claude
    lists for its background sessions and the last name each transcript records; or its transcript's absolute path.
    Alone, it is on the schedule whose entry holds it, or else on none; with -Schedule, on that schedule. An id claude
    lists nowhere and no transcript holds, a short id claude lists nowhere, and a name no conversation carries, or
    several do, are refused.

.PARAMETER Continue
    The conversation claude lists in the startup directory, the one claude's own --continue would pick; with none
    there, claude's own --continue, in its background, which starts a copy of the conversation it picks. With
    -Schedule, the conversation it opens joins that schedule, and with none there it refuses and starts nothing:
    claude's own pick goes by transcript, and can be another conversation.

.PARAMETER ShellWidthPercent
    The shell pane's width, as a percentage of the window's, 1 to 99, 40 by default.

.PARAMETER Directory
    The directory to start in, defaulting to the current one: the root of a repository clone or of a linked
    worktree. It is resolved to its physical path, since Claude Code files a conversation under the path it is handed.
    Everything the session is named for is read from it, gh included, claude's background session starts there, and
    the psmux session opens there, so a session can be opened for another clone without leaving this one.

.PARAMETER NoRemoteControl
    Start the background session without Claude Code's Remote Control, which is otherwise on, named the same as the
    session. Not with -Detach, which leaves the session for Remote Control.

.PARAMETER Detach
    Start the conversation in claude's background, or wake it under its name, and open no psmux session: for Remote
    Control. A schedule's session that claude lists under a name other than the launch's is renamed to it with
    /rename when it is woken. A running one keeps its name until a launch opens it in a console, where the rename is
    typed into its viewer, unless NFEP_AGENT_SCHEDULE_DETACHED_RENAME is set.

.PARAMETER ClaudeArgument
    The arguments after the script's own, passed to claude as they are. A conversation a launch starts keeps them; a
    background session that already exists keeps the options it was started with.

.EXAMPLE
    Start-Claude 916

    Opens schedule 916 of the current repository in a psmux session, starting its conversation in claude's
    background when the schedule has none.

.EXAMPLE
    Start-Claude NobleFactor/devlore-cli#916 -ShellWidthPercent 30 --model opus

    Opens a schedule in another repository, its shell pane at thirty percent of the window's width; a conversation the
    launch starts is passed --model opus.

.EXAMPLE
    Start-Claude -Directory ..\noblefactor-engprod NobleFactor/devlore-cli#916

    Opens a session for another clone without leaving this one.

.EXAMPLE
    'Release checklist' | Start-Claude new

    Opens a new, empty schedule in the current repository, titled "Schedule: Release checklist", and a conversation
    on it. Start-Claude new -Title 'Release checklist' does the same, and with no title the prompt asks for one.

.EXAMPLE
    Start-Claude 916 -Title 'writ lifecycle management'

    Retitles schedule 916 to "Schedule: writ lifecycle management", then opens it.

.EXAMPLE
    Start-Claude -Resume 2ee3ba2e-2687-412d-8a4f-eabc597824ac

    Opens that conversation, resumed in claude's background: on its schedule when the store holds it, and otherwise on
    none.

.EXAMPLE
    Start-Claude -Resume 2ee3ba2e-2687-412d-8a4f-eabc597824ac -Schedule 916

    Puts a conversation started elsewhere on schedule 916, which has none, and opens it there.

.EXAMPLE
    Start-Claude -Continue -Schedule 916

    Puts the conversation claude lists in the current directory on schedule 916, which has none, and opens it there.

.EXAMPLE
    Start-Claude -Continue

    Opens the conversation claude lists in the current directory.

.EXAMPLE
    Start-Claude 916 -Detach

    Starts schedule 916's conversation in claude's background, or wakes it, and opens nothing.

.OUTPUTS
    System.String. The background session's short id, the one claude --bg prints and claude attach takes: at once
    with -Detach, and otherwise when the psmux session ends.

.NOTES
    CLAUDE_CONFIG_DIR, when it is set, is where Claude Code keeps its configuration and its transcripts; unset, it is
    ~/.claude. The script reads claude's own list of its sessions, claude agents --json --all, and the projects
    directory only for whether a conversation's transcript is there.

    The store, under XDG_STATE_HOME, or else ~/.local/state, keeps one entry per schedule,
    agent-schedule\<owner>\<repository>\<number>, holding on its one line the background session's short id, as
    Start-Claude keeps it. From reading the entry until the background session exists, the script holds the
    schedule's lock, agent-schedule\<owner>\<repository>\<number>.lock, which the operating system releases if the
    shell dies: a second launch waits 10 seconds, then stops, naming this one.

    It requires claude, git, psmux as tmux, and gh for a schedule. What it does goes to the verbose stream, shown
    with -Verbose. Each refusal is a terminating error that says why: the caller's error action decides what it does
    there, and run as a process the script exits 1. Its category follows the status Start-Claude gives the same
    refusal: InvalidArgument for usage, InvalidData for data it cannot use, ObjectNotFound for something missing,
    NotInstalled or ResourceUnavailable for a program that is missing or failed or a console that is missing,
    WriteError for something it cannot create or give, ReadError for an entry it cannot read, ResourceBusy for a
    session or lock held elsewhere, and InvalidOperation for a platform that is not Windows.
#>

#Requires -Version 7.3

# -Schedule with -Title, and -Resume and -Continue, each alone or with -Schedule, are three parameter sets, so
# PowerShell refuses any other two together (requirement 7; #322). -Schedule is the only positional parameter and
# -Title the only one taken from the pipeline, so every argument after the script's own is left for Claude.
[CmdletBinding(DefaultParameterSetName = 'Schedule', PositionalBinding = $false)]
param(
    [Parameter(ParameterSetName = 'Schedule', Position = 0)]
    [Parameter(ParameterSetName = 'Resume')]
    [Parameter(ParameterSetName = 'Continue')]
    [string]
    $Schedule,

    [Parameter(ParameterSetName = 'Schedule', ValueFromPipeline)]
    [string]
    $Title,

    [Parameter(ParameterSetName = 'Resume', Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Resume,

    [Parameter(ParameterSetName = 'Continue', Mandatory)]
    [switch]
    $Continue,

    [ValidateRange(1, 99)]
    [int]
    $ShellWidthPercent = 40,

    [ValidateNotNullOrEmpty()]
    [string]
    $Directory,

    [switch]
    $NoRemoteControl,

    [switch]
    $Detach,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]
    $ClaudeArgument
)

begin {
    # The caller's error action is noted before the script's own Stop, and end's catch puts it back to report an error
    # (section 7 of the PowerShell style guide).
    $callerErrorAction = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

    ###########
    # Helper functions
    ###########

    ## Messages and statuses

    function Exit-Launch {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $ErrorId,

            [Parameter(Mandatory)]
            [System.Management.Automation.ErrorCategory]
            $Category,

            [Parameter(Mandatory)]
            [string]
            $Message
        )

        # A refusal is a terminating error (section 7 of the PowerShell style guide): end's catch reports it under the
        # script's name and the caller's error action, and the script exits 1. Its id names what it found, and its
        # category follows the status Start-Claude gives the same refusal (personal#273's question 10).
        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message), $ErrorId, $Category, $null)
    }

    function Require-Command {
        # Require- is the house verb for a prerequisite (powershell-style-guidelines.md section 3); the analyzer's
        # approved list has no equivalent, and Assert- would name a test rather than a requirement.
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '',
            Justification = 'Require- is the house verb for a prerequisite: style guide section 3.')]
        [CmdletBinding()]
        param([string]$Name)

        if (-not (Get-Command $Name -ErrorAction Ignore)) {
            $message = "$Name is required but was not found in PATH."
            Exit-Launch -ErrorId 'CommandNotFound' -Category NotInstalled -Message $message
        }
    }

    function Require-Windows {
        # Require- is the house verb for a prerequisite, as for Require-Command.
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '',
            Justification = 'Require- is the house verb for a prerequisite: style guide section 3.')]
        [CmdletBinding()]
        param()

        # As Declare-BashScript's require_darwin, require_linux and require_nix name the platform a script requires.
        if (-not $IsWindows) {
            Exit-Launch -ErrorId 'RequiresWindows' -Category InvalidOperation -Message 'This script requires Windows.'
        }
    }

    ## Programs

    function Invoke-Program {
        [CmdletBinding()]
        [OutputType([pscustomobject])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Name,

            [string[]]
            $Argument
        )

        # A program run to its end in PowerShell's location, its standard input closed so that nothing reaches it there,
        # and what it writes read through UTF-8 decoders of its own, a line to an item. gh, claude, git and psmux write
        # UTF-8, which PowerShell reads in the console's code page: an em dash in a schedule's title reached claude as
        # three other characters, and claude stored the session's name so (seen 2026-10-17). The code page is never
        # changed (the owner, 2026-10-17: "Avoid code page changes entirely.").
        $program = Get-Command -Name $Name -CommandType Application -ErrorAction Ignore | Select-Object -First 1

        if (-not $program) {
            $message = "$Name is required but was not found in PATH."
            Exit-Launch -ErrorId 'CommandNotFound' -Category NotInstalled -Message $message
        }

        $start = [Diagnostics.ProcessStartInfo]::new($program.Source)

        foreach ($item in $Argument) {
            $start.ArgumentList.Add($item)
        }

        $start.WorkingDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
        $start.UseShellExecute = $false
        $start.RedirectStandardInput = $true
        $start.RedirectStandardOutput = $true
        $start.RedirectStandardError = $true
        $start.StandardOutputEncoding = [Text.UTF8Encoding]::new($false)
        $start.StandardErrorEncoding = [Text.UTF8Encoding]::new($false)

        try {
            $process = [Diagnostics.Process]::Start($start)
        }
        catch {
            $message = "$Name could not be started: $($_.Exception.GetBaseException().Message)"
            Exit-Launch -ErrorId 'ProgramNotStarted' -Category ResourceUnavailable -Message $message
        }

        # Standard error is read while standard output is, so that neither pipe fills and stalls the program.
        $process.StandardInput.Close()
        $errorRead = $process.StandardError.ReadToEndAsync()
        $outputText = $process.StandardOutput.ReadToEnd()
        $process.WaitForExit()
        $errorText = $errorRead.GetAwaiter().GetResult()

        return [pscustomobject]@{
            ExitCode = $process.ExitCode
            Output   = @($outputText -split '\r?\n' | Where-Object { $_.Length -gt 0 })
            Error    = @($errorText -split '\r?\n' | Where-Object { $_.Length -gt 0 })
        }
    }

    ## The startup directory and its repository

    function Resolve-StartupDirectory {
        [CmdletBinding()]
        [OutputType([string])]
        param([string]$Directory)

        if (-not $Directory) {
            $Directory = (Get-Location).ProviderPath
        }

        $resolved = Resolve-Path -LiteralPath $Directory -ErrorAction Ignore

        if (-not $resolved -or -not (Test-Path -LiteralPath $resolved.ProviderPath -PathType Container)) {
            Exit-Launch -ErrorId 'DirectoryNotFound' -Category ObjectNotFound -Message "No such directory: $Directory"
        }

        return Get-PhysicalPath -Path $resolved.ProviderPath
    }

    function Get-PhysicalPath {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Path
        )

        # Claude Code files a conversation under the path it is handed, so a junction or a symbolic link anywhere in the
        # path would split one repository across two project folders. Each component is replaced by its final target.
        $logical = [IO.Path]::GetFullPath($Path)
        $root = [IO.Path]::GetPathRoot($logical)
        $physical = $root
        $separators = [char[]]@([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        $components = $logical.Substring($root.Length).Split($separators, [StringSplitOptions]::RemoveEmptyEntries)

        foreach ($component in $components) {
            $physical = Join-Path -Path $physical -ChildPath $component
            $target = [IO.Directory]::ResolveLinkTarget($physical, $true)

            if ($target) {
                $physical = $target.FullName
            }

        }

        return $physical
    }

    function Test-RepositoryRoot {
        [CmdletBinding()]
        [OutputType([bool])]
        param([string]$Directory)

        # The root of a repository clone, or of a linked worktree, which git answers the same way.
        $toplevel = Invoke-Git -Directory $Directory -Argument @('rev-parse', '--show-toplevel')

        if (-not $toplevel) {
            return $false
        }

        return ([IO.Path]::GetFullPath($toplevel) -eq [IO.Path]::GetFullPath($Directory))
    }

    function Get-RepositoryName {
        [CmdletBinding()]
        param([string]$Directory)

        $url = Invoke-Git -Directory $Directory -Argument @('config', '--get', 'remote.origin.url')

        if ($url) {
            return ([IO.Path]::GetFileNameWithoutExtension($url.TrimEnd('/')))
        }

        $root = Invoke-Git -Directory $Directory -Argument @('rev-parse', '--show-toplevel')

        if ($root) {
            return Split-Path $root -Leaf
        }

        return Split-Path $Directory -Leaf
    }

    function Get-RepositorySlug {
        [CmdletBinding()]
        [OutputType([string])]
        param([string]$Directory)

        # The repository as GitHub names it, <owner>/<repository>, read from the directory's origin. A bare -Schedule
        # number means the startup directory's repository, and -Schedule new opens the schedule there.
        $url = Invoke-Git -Directory $Directory -Argument @('config', '--get', 'remote.origin.url')

        if ($url -and $url -match 'github\.com[:/]([^/]+/[^/]+?)(\.git)?$') {
            return $Matches[1]
        }

        return $null
    }

    function Invoke-Git {
        [CmdletBinding()]
        param(
            [string]
            $Directory,

            [string[]]
            $Argument
        )

        $result = Invoke-Program -Name 'git' -Argument (@('-C', $Directory) + $Argument)

        if ($result.ExitCode -ne 0) {
            return $null
        }

        return ($result.Output -join "`n").Trim()
    }

    ## The schedule, on GitHub

    function Get-ScheduleIssue {
        [CmdletBinding()]
        param(
            [string]
            $Slug,

            [string]
            $Number
        )

        # The issue's title, link and labels, read from its own repository and never from the caller's.
        $result = Invoke-Gh -Argument @('issue', 'view', $Number, '--repo', $Slug, '--json', 'title,url,labels')

        if ($result.ExitCode -ne 0 -or -not $result.Output) {
            $message = "The issue cannot be read: $Slug#$Number. gh: $($result.Reason)"
            Exit-Launch -ErrorId 'ScheduleNotRead' -Category ObjectNotFound -Message $message
        }

        return $result.Output | ConvertFrom-Json
    }

    function Open-Schedule {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [string]
            $Slug,

            [string]
            $Title
        )

        # It opens empty: a deliverable to state, and a lane table the report reads, with no rows yet.
        $body = @(
            '## Deliverable',
            '',
            'To be stated: what the owner has today, and what they will have when the last lane closes.',
            '',
            '## Lanes',
            '',
            '| Lane | Item | Next | Waits on |',
            '| --- | --- | --- | --- |'
        ) -join "`n"

        $argument = @(
            'issue', 'create', '--repo', $Slug, '--title', "Schedule: $Title", '--label', 'chore', '--body', $body
        )
        $result = Invoke-Gh -Argument $argument

        if ($result.ExitCode -ne 0 -or -not $result.Output) {
            $message = "The schedule could not be opened in $Slug. gh: $($result.Reason)"
            Exit-Launch -ErrorId 'ScheduleNotOpened' -Category WriteError -Message $message
        }

        return $result.Output
    }

    function Set-ScheduleTitle {
        [CmdletBinding(SupportsShouldProcess)]
        [OutputType([bool])]
        param(
            [string]
            $Slug,

            [string]
            $Number,

            [string]
            $Title
        )

        # A title given with an existing schedule is an edit to its issue: "That will cause an edit to existing issues."
        if (-not $PSCmdlet.ShouldProcess("$Slug#$Number", "Retitle to $Title")) {
            return $false
        }

        $result = Invoke-Gh -Argument @('issue', 'edit', $Number, '--repo', $Slug, '--title', $Title)

        if ($result.ExitCode -ne 0) {
            $message = "The schedule could not be retitled: $Slug#$Number. gh: $($result.Reason)"
            Exit-Launch -ErrorId 'ScheduleNotRetitled' -Category WriteError -Message $message
        }

        return $true
    }

    function Invoke-Gh {
        [CmdletBinding()]
        [OutputType([pscustomobject])]
        param(
            [Parameter(Mandatory)]
            [string[]]
            $Argument
        )

        # gh says why it failed on its standard error, which is kept so the caller can wrap it in a message of its own.
        $result = Invoke-Program -Name 'gh' -Argument $Argument
        $reason = @($result.Error | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join '; '

        if (-not $reason) {
            $reason = "exit code $($result.ExitCode)"
        }

        return [pscustomobject]@{
            ExitCode = $result.ExitCode
            Output   = ($result.Output -join "`n").Trim()
            Reason   = $reason
        }
    }

    ## claude's records

    function Get-ClaudeConfigDirectory {
        [CmdletBinding()]
        [OutputType([string])]
        param()

        # CLAUDE_CONFIG_DIR names where Claude Code keeps its configuration, transcripts and session records when it
        # is set; its own default is ~/.claude.
        if ($env:CLAUDE_CONFIG_DIR) {
            return $env:CLAUDE_CONFIG_DIR
        }

        return Join-Path -Path $HOME -ChildPath '.claude'
    }

    function Get-TranscriptPath {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Conversation
        )

        # The path of a conversation's transcript, in whichever project folder holds it.
        $projects = Join-Path -Path (Get-ClaudeConfigDirectory) -ChildPath 'projects'
        $found = Get-ChildItem -LiteralPath $projects -Filter "$Conversation.jsonl" -File -Recurse -Depth 1 `
            -ErrorAction Ignore | Select-Object -First 1

        if ($found) {
            return $found.FullName
        }
    }

    function Get-ClaudeInstance {
        [CmdletBinding()]
        [OutputType([object[]])]
        param(
            [Parameter(Mandatory)]
            [string]
            $ClaudeBinary
        )

        # Every session claude lists, stopped and finished ones too, since a stopped background session is still its
        # schedule's and claude attach starts it again: each with its conversation's id, its kind, background or
        # interactive, the short id of a background one or the process id of an interactive one, its directory and its
        # state.
        $listed = Invoke-Program -Name $ClaudeBinary -Argument @('agents', '--json', '--all')

        if ($listed.ExitCode -ne 0) {
            $message = 'claude cannot list its sessions: claude agents --json --all failed.'
            Exit-Launch -ErrorId 'SessionsNotListed' -Category ResourceUnavailable -Message $message
        }

        try {
            return @(($listed.Output -join "`n") | ConvertFrom-Json -ErrorAction Stop)
        }
        catch {
            $message = "claude's list of sessions is not the JSON this script reads: claude agents --json --all."
            Exit-Launch -ErrorId 'SessionListUnreadable' -Category InvalidData -Message $message
        }
    }

    function Get-SessionPlace {
        [CmdletBinding()]
        [OutputType([pscustomobject])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Id,

            [object[]]
            $Instance
        )

        # Where claude lists a session: in its background, running or stopped, by the background session's short id or
        # its conversation's id; or in the foreground, by the conversation's id and the process that runs it. Nothing
        # when claude lists it nowhere.
        $background = $Instance | Where-Object {
            $_.kind -ceq 'background' -and ($_.id -ceq $Id -or $_.sessionId -ceq $Id)
        } | Select-Object -First 1

        if ($background) {
            return [pscustomobject]@{
                Kind    = 'background'
                Id      = [string]$background.id
                State   = [string]$background.state
                Session = [string]$background.sessionId
                Name    = [string]$background.name
            }
        }

        $foreground = $Instance | Where-Object { $_.kind -cne 'background' -and $_.sessionId -ceq $Id } |
            Select-Object -First 1

        if ($foreground) {
            return [pscustomobject]@{ Kind = 'interactive'; ProcessId = [int]$foreground.pid }
        }

        return $null
    }

    function Resolve-ResumeArgument {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Argument,

            [object[]]
            $Instance,

            [Parameter(Mandatory)]
            [string]
            $Projects
        )

        # The conversation -Resume names, as claude --resume takes it but its picker (personal#273's question 12): a
        # conversation's id, a UUID; a background session's short id, as claude lists it; the absolute path to a
        # conversation's transcript; or a name, matched whole against the names claude lists for its background
        # sessions and the last name each transcript records.
        $uuidPattern = '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
        $lowered = $Argument.ToLowerInvariant()

        # A conversation's id: a session claude lists, or a transcript on this machine. A background session no prompt
        # has reached has no transcript yet, and claude --resume takes its id all the same (seen 2026-10-19).
        if ($lowered -cmatch $uuidPattern) {
            $listed = $Instance | Where-Object { ([string]$_.sessionId).ToLowerInvariant() -ceq $lowered } |
                Select-Object -First 1

            if (-not $listed -and -not (Get-TranscriptPath -Conversation $lowered)) {
                $message = "No conversation ${lowered}: claude lists no session by that id, and there is no "
                $message += "$lowered.jsonl under $Projects"
                Exit-Launch -ErrorId 'ConversationNotFound' -Category ObjectNotFound -Message $message
            }

            return $lowered
        }

        if ($lowered -cmatch '^[0-9a-f]{8}$') {
            $background = $Instance | Where-Object { $_.kind -ceq 'background' -and $_.id -ceq $lowered } |
                Select-Object -First 1

            if (-not $background) {
                $message = "No background session ${lowered}: claude agents --json --all lists none."
                Exit-Launch -ErrorId 'BackgroundSessionNotFound' -Category ObjectNotFound -Message $message
            }

            return ([string]$background.sessionId).ToLowerInvariant()
        }

        if ([IO.Path]::IsPathFullyQualified($Argument) -and
            $Argument.EndsWith('.jsonl', [StringComparison]::OrdinalIgnoreCase)) {

            if (-not (Test-Path -LiteralPath $Argument -PathType Leaf)) {
                Exit-Launch -ErrorId 'TranscriptNotFound' -Category ObjectNotFound -Message "No transcript: $Argument"
            }

            $file = [IO.Path]::GetFileNameWithoutExtension($Argument).ToLowerInvariant()

            if ($file -cnotmatch $uuidPattern) {
                $message = "A transcript is named for its conversation's id, a UUID: $Argument"
                Exit-Launch -ErrorId 'TranscriptNotNamedForId' -Category InvalidData -Message $message
            }

            return $file
        }

        # A name, matched whole: claude's names for its background sessions, since a session no prompt has reached has
        # no transcript yet, and the last name each transcript records, since a name can change.
        $matchList = [Collections.Generic.List[string]]::new()

        foreach ($session in @($Instance | Where-Object { $_.kind -ceq 'background' -and $_.name -ceq $Argument })) {
            $matchList.Add(([string]$session.sessionId).ToLowerInvariant())
        }

        $needle = '"customTitle":' + (ConvertTo-Json -InputObject $Argument -Compress)
        $candidateList = @(Get-ChildItem -LiteralPath $Projects -Filter '*.jsonl' -Recurse -File -ErrorAction Ignore |
            Select-String -Pattern $needle -SimpleMatch -List -Encoding utf8 | ForEach-Object Path)

        foreach ($path in $candidateList) {
            $titleLine = Select-String -LiteralPath $path -Pattern '"type":"custom-title"' -SimpleMatch -Encoding utf8 |
                Select-Object -Last 1

            if ($titleLine -and ($titleLine.Line | ConvertFrom-Json).customTitle -ceq $Argument) {
                $matchList.Add([IO.Path]::GetFileNameWithoutExtension($path).ToLowerInvariant())
            }
        }

        # A session claude lists and its transcript are one conversation.
        $uniqueList = @($matchList | Sort-Object -Unique)

        if ($uniqueList.Count -eq 1) {
            return $uniqueList[0]
        }

        if ($uniqueList.Count -eq 0) {
            $message = "No conversation named ${Argument}: claude lists no background session by that name, and no "
            $message += "transcript under $Projects records it."
            Exit-Launch -ErrorId 'ConversationNotFound' -Category ObjectNotFound -Message $message
        }

        $message = "Several conversations are named ${Argument}: $($uniqueList -join ' '). Give one's id."
        Exit-Launch -ErrorId 'ConversationNameAmbiguous' -Category InvalidData -Message $message
    }

    function Resolve-BackgroundSession {
        [CmdletBinding()]
        [OutputType([pscustomobject])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Id,

            [object[]]
            $Instance
        )

        # A session met where claude lists it: its background session, running or stopped, becomes the launch's; a
        # conversation a claude runs in the foreground is refused, unless that claude's process is gone, as when it was
        # killed and left its record behind; nothing when claude runs it nowhere.
        $place = Get-SessionPlace -Id $Id -Instance $Instance

        if (-not $place) {
            return $null
        }

        if ($place.Kind -ceq 'background') {
            return $place
        }

        $process = Get-Process -Id $place.ProcessId -ErrorAction Ignore

        if (-not $process) {
            return $null
        }

        $message = "Conversation $Id runs in claude's process $($place.ProcessId) on $hostName, started "
        $message += "$($process.StartTime), in the foreground, where $scriptName cannot open it. Exit it there with "
        $message += "/exit, or end it with: Stop-Process -Id $($place.ProcessId). Then run the same command again: it "
        $message += "resumes the conversation in claude's background under its own id. /bg would move it under a new "
        $message += 'id, which the store does not hold.'
        Exit-Launch -ErrorId 'ConversationInForeground' -Category ResourceBusy -Message $message
    }

    function Get-ConversationRunningIn {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Directory,

            [object[]]
            $Instance
        )

        # The conversation claude lists in a directory, in its background or in the foreground: of several, the one
        # whose transcript was written last, which claude's own --continue would pick. A conversation with a transcript
        # outranks one with none yet.
        $newest = $null
        $newestWritten = $null

        foreach ($listed in $Instance) {

            if (-not $listed.sessionId -or -not $listed.cwd) {
                continue
            }

            try {
                $listedDirectory = Get-PhysicalPath -Path $listed.cwd
            }
            catch {
                continue
            }

            if ($listedDirectory -ne $Directory) {
                continue
            }

            $transcript = Get-TranscriptPath -Conversation $listed.sessionId
            $written = $null

            if ($transcript) {
                $written = (Get-Item -LiteralPath $transcript).LastWriteTimeUtc
            }

            if (-not $newest -or ($written -and (-not $newestWritten -or $written -gt $newestWritten))) {
                $newest = [string]$listed.sessionId
                $newestWritten = $written
            }

        }

        return $newest
    }

    ## The store

    function Get-ScheduleHolding {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Id,

            [Parameter(Mandatory)]
            [string]
            $Root,

            [Parameter(Mandatory)]
            [string]
            $Entry,

            [object[]]
            $Instance
        )

        # The key of a schedule other than this launch's whose entry holds the session: one schedule per session
        # (rule 4). Ids compare as the background session each comes to.
        $wanted = Get-BackgroundId -Id $Id -Instance $Instance

        foreach ($other in Get-StoreEntry -Root $Root) {

            if ($other.FullName -eq $Entry) {
                continue
            }

            $held = Read-StoreEntry -Path $other.FullName

            if ($held -and (Get-BackgroundId -Id $held -Instance $Instance) -ceq $wanted) {
                return Get-StoreKey -Root $Root -Path $other.FullName
            }

        }

        return $null
    }

    function Get-ScheduleRecording {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Id,

            [Parameter(Mandatory)]
            [string]
            $Root,

            [object[]]
            $Instance
        )

        # The key of the schedule whose entry holds a session; nothing when no entry does, and the session is on no
        # schedule (requirement 7). No conversation's name is read.
        $wanted = Get-BackgroundId -Id $Id -Instance $Instance

        foreach ($entry in Get-StoreEntry -Root $Root) {
            $held = Read-StoreEntry -Path $entry.FullName

            if ($held -and (Get-BackgroundId -Id $held -Instance $Instance) -ceq $wanted) {
                return Get-StoreKey -Root $Root -Path $entry.FullName
            }

        }

        return $null
    }

    function Get-StoreEntry {
        [CmdletBinding()]
        [OutputType([IO.FileInfo])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Root
        )

        # Every entry in the store, <owner>\<repository>\<number>: an entry is named for its schedule's number alone,
        # so a lock, a temporary file or anything else beside it is not one.
        Get-ChildItem -LiteralPath $Root -File -Recurse -Depth 2 -ErrorAction Ignore |
            Where-Object { $_.Name -match '^[0-9]+$' }
    }

    function Get-StoreKey {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Root,

            [Parameter(Mandatory)]
            [string]
            $Path
        )

        # The key of the schedule an entry's path names, <owner>/<repository>#<number>.
        $relative = [IO.Path]::GetRelativePath($Root, $Path)
        $owner, $repository, $number = $relative.Split([IO.Path]::DirectorySeparatorChar)
        return "$owner/$repository#$number"
    }

    function Read-StoreEntry {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Path
        )

        # The id an entry holds on its one line: a background session's short id, or a conversation's id. An entry that
        # cannot be read, or holds neither, holds nothing.
        try {
            $id = Get-Content -LiteralPath $Path -TotalCount 1 -ErrorAction Stop
        }
        catch {
            return $null
        }

        if ("$id" -cmatch '^[0-9a-f]{8}((-[0-9a-f]{4}){3}-[0-9a-f]{12})?$') {
            return "$id"
        }

        return $null
    }

    function Get-BackgroundId {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Id,

            [object[]]
            $Instance
        )

        # The short id a session's id comes to, so that two ids of one session compare equal: a background session's
        # own id as it is, and a conversation's id as the background session claude runs it in, or else as its first
        # eight characters, the id a start in claude's background gives it.
        if ($Id -cmatch '^[0-9a-f]{8}$') {
            return $Id
        }

        $running = $Instance | Where-Object { $_.kind -ceq 'background' -and $_.sessionId -ceq $Id } |
            Select-Object -First 1

        if ($running) {
            return [string]$running.id
        }

        return $Id.Substring(0, 8)
    }

    function Lock-Store {
        [CmdletBinding()]
        [OutputType([IO.FileStream])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Path
        )

        # A file opened for writing, with others allowed to read the holder's process id. The operating system
        # releases it when the process holding it ends, so it is never stale, and the clean block closes it. A launch
        # waits up to 10 seconds for it.
        $deadline = (Get-Date).AddSeconds(10)

        while ($true) {

            try {
                $stream = [IO.File]::Open($Path, 'OpenOrCreate', 'ReadWrite', 'Read')
                $stream.SetLength(0)
                $holder = [Text.Encoding]::UTF8.GetBytes("$PID")
                $stream.Write($holder, 0, $holder.Length)
                $stream.Flush()
                return $stream
            }
            catch {
                $failure = $_.Exception.GetBaseException()

                # Only a sharing or a lock violation, 32 or 33, means another launch holds the lock. Anything else, a
                # directory that cannot be made or a file that cannot be opened, means the store cannot be written.
                if ($failure -isnot [IO.IOException] -or ($failure.HResult -band 0xFFFF) -notin 32, 33) {
                    $message = "The store cannot be written: $Path. $($failure.Message)"
                    Exit-Launch -ErrorId 'StoreNotWritable' -Category WriteError -Message $message
                }

                if ((Get-Date) -ge $deadline) {
                    $reader = [IO.StreamReader]::new([IO.File]::Open($Path, 'Open', 'Read', 'ReadWrite'))
                    $holder = $reader.ReadToEnd()
                    $reader.Dispose()
                    $message = "Another launch or session holds ${Path}: process $holder."
                    Exit-Launch -ErrorId 'StoreLockHeld' -Category ResourceBusy -Message $message
                }

                Start-Sleep -Milliseconds 200
            }

        }
    }

    function Write-StoreEntry {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $Path,

            [Parameter(Mandatory)]
            [string]
            $Temporary,

            [Parameter(Mandatory)]
            [ValidatePattern('^[0-9a-f]{8}((-[0-9a-f]{4}){3}-[0-9a-f]{12})?$', Options = 'None')]
            [string]
            $Id
        )

        # The entry holds the schedule's session on its one line, as Start-Claude writes it, and is written whole to a
        # temporary file and renamed over the old one, so it is never read half written.
        try {
            [IO.File]::WriteAllText($Temporary, "$Id`n")
            Move-Item -LiteralPath $Temporary -Destination $Path -Force
        }
        catch {
            $message = "The store cannot be written: $Path. $($_.Exception.Message)"
            Exit-Launch -ErrorId 'StoreNotWritable' -Category WriteError -Message $message
        }
    }

    ## claude's background

    function Open-BackgroundSession {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $ClaudeBinary,

            [string[]]
            $What,

            [Parameter(Mandatory)]
            [string]
            $Name,

            [string]
            $Settings,

            [switch]
            $RemoteControl,

            [string[]]
            $PassThrough
        )

        # claude --bg starts a conversation in its background, named for the launch, with Remote Control when asked,
        # the schedule's variables through --settings, and the arguments passed through, which the session keeps; it
        # prints the background session's short id. What claude refuses, as a start in a folder it does not trust, is
        # passed through in its own words, and nothing opens; a note it prints, a line that begins "note:", as when it
        # starts a copy of a conversation rather than the conversation itself, is passed through too. Its two streams
        # arrive apart, and its standard error is read first.
        $argumentList = @('--bg') + $What + @('--name', $Name)

        # --remote-control takes an optional value, so it is given one: left bare, it would absorb the first argument
        # passed through that does not begin with a dash.
        if ($RemoteControl) {
            $argumentList += @('--remote-control', $Name)
        }

        if ($Settings) {
            $argumentList += @('--settings', $Settings)
        }

        if ($PassThrough) {
            $argumentList += $PassThrough
        }

        $result = Invoke-Program -Name $ClaudeBinary -Argument $argumentList
        $output = @($result.Error) + @($result.Output)

        if ($result.ExitCode -ne 0) {
            $message = "claude started nothing: $($output -join ' ')"
            Exit-Launch -ErrorId 'BackgroundNotStarted' -Category ResourceUnavailable -Message $message
        }

        foreach ($line in $output) {

            if ($line.StartsWith('note:', [StringComparison]::Ordinal)) {
                Write-Verbose "claude: $line"
            }

        }

        $attach = $output | Select-String -Pattern '^\s+claude attach ([0-9a-f]{8})(\s.*)?$' -CaseSensitive |
            Select-Object -First 1

        if (-not $attach) {
            $message = "claude's words name no background session this script reads: $($output -join ' ')"
            Exit-Launch -ErrorId 'BackgroundNotNamed' -Category InvalidData -Message $message
        }

        return $attach.Matches[0].Groups[1].Value
    }

    function Resume-BackgroundSession {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $ClaudeBinary,

            [Parameter(Mandatory)]
            [string]
            $Id,

            [Parameter(Mandatory)]
            [string]
            $Session,

            [string]
            $Rename
        )

        # A stopped background session is started again, for -Detach, under its own id and with the options it was
        # started with, its name among them: claude --bg --resume of its conversation's full id wakes it. It is given
        # no flag: given one, --name included, claude starts a copy under a new id, which fails, and the session stays
        # stopped (NobleFactor/noblefactor-engprod#384; anthropics/claude-code#104658). A name the session must take
        # goes as its first prompt, /rename <name>, which claude runs in the session it wakes (seen 2026-10-23).
        # Without -Detach, the viewer's claude attach starts it.
        $argumentList = @('--bg', '--resume', $Session)

        if ($Rename) {
            $argumentList += $Rename
        }

        $result = Invoke-Program -Name $ClaudeBinary -Argument $argumentList
        $output = @($result.Error) + @($result.Output)

        if ($result.ExitCode -ne 0) {
            $message = "claude did not start background session $Id again: $($output -join ' ')"
            Exit-Launch -ErrorId 'BackgroundNotWoken' -Category ResourceUnavailable -Message $message
        }

        # claude's word that the session runs again, the line that begins "backgrounded", comes after a line of its own
        # when claude starts its background service first, "Starting background service" (seen 2026-10-16).
        $said = $output | Where-Object { $_.StartsWith('backgrounded', [StringComparison]::Ordinal) } |
            Select-Object -First 1

        if (-not $said) {
            $said = $output | Select-Object -First 1
        }

        Write-Verbose "claude: $said"
    }

    ## The session's name

    function Get-BackgroundName {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $ClaudeBinary,

            [Parameter(Mandatory)]
            [string]
            $Id
        )

        # The name claude lists for a background session now, read from claude's list afresh; empty when it lists none.
        $listed = Get-ClaudeInstance -ClaudeBinary $ClaudeBinary |
            Where-Object { $_.kind -ceq 'background' -and $_.id -ceq $Id } | Select-Object -First 1

        return [string]$listed.name
    }

    function Wait-ViewerInput {
        [CmdletBinding()]
        [OutputType([bool])]
        param(
            [Parameter(Mandatory)]
            [string]
            $Target
        )

        # The viewer in a psmux pane takes keys once it has drawn its input line, which begins with U+276F: within a
        # second of claude attach starting (seen 2026-10-23). It waits 30 seconds at most.
        $prompt = [string][char]0x276F
        $deadline = (Get-Date).AddSeconds(30)

        while ((Get-Date) -lt $deadline) {
            $screen = Invoke-Program -Name 'tmux' -Argument @('capture-pane', '-p', '-t', $Target)

            if ($screen.ExitCode -eq 0 -and @($screen.Output | Where-Object { $_.StartsWith($prompt) }).Count -gt 0) {
                return $true
            }

            Start-Sleep -Milliseconds 100
        }

        return $false
    }

    function Rename-RunningSession {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $ClaudeBinary,

            [Parameter(Mandatory)]
            [string]
            $Id,

            [Parameter(Mandatory)]
            [string]
            $Rename,

            [Parameter(Mandatory)]
            [string]
            $Name
        )

        # For -Detach, a running session claude lists under another name than the launch's gets /rename typed into a
        # viewer of the launch's own, a psmux session no client attaches, which ends once claude lists the name (#384,
        # requirement 2). claude on Windows takes no keys in a viewer no client attaches
        # (anthropics/claude-code#104688), so the launch does this only when NFEP_AGENT_SCHEDULE_DETACHED_RENAME is set.
        $opened = Invoke-Program -Name 'tmux' -Argument @(
            'new-session', '-d', '-P', '-F', '#{session_id}', '--',
            'pwsh', '-NoProfile', '-Command', "claude attach $Id")
        $viewer = [string]($opened.Output | Select-Object -First 1)

        if ($opened.ExitCode -ne 0 -or $viewer -notmatch '^\$[0-9]+$') {
            Write-Verbose "Background session $Id keeps its name: psmux opened no viewer to rename it in."
            return
        }

        if (Wait-ViewerInput -Target $viewer) {
            $null = Invoke-Program -Name 'tmux' -Argument @('send-keys', '-t', $viewer, $Rename, 'Enter')
            $deadline = (Get-Date).AddSeconds(10)

            while ((Get-Date) -lt $deadline -and (Get-BackgroundName -ClaudeBinary $ClaudeBinary -Id $Id) -cne $Name) {
                Start-Sleep -Milliseconds 200
            }

        }

        $null = Invoke-Program -Name 'tmux' -Argument @('kill-session', '-t', $viewer)

        if ((Get-BackgroundName -ClaudeBinary $ClaudeBinary -Id $Id) -ceq $Name) {
            Write-Verbose "Renamed background session $Id to $Name"
        }
        else {
            Write-Verbose "Background session $Id keeps its name: claude did not take $Rename in a viewer."
        }
    }

    function Send-WorkspaceRename {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $Session,

            [Parameter(Mandatory)]
            [string]
            $Rename
        )

        # Typed into the viewer of the psmux session a console has attached to: with a client attached, claude's viewer
        # on Windows takes the keys (seen 2026-10-23). The viewer is the session's first pane, named with its session,
        # since psmux looks a bare pane id up in another session.
        $panes = Invoke-Program -Name 'tmux' -Argument @('list-panes', '-t', $Session, '-F', '#{pane_index}')
        $target = "${Session}:.$($panes.Output | Select-Object -First 1)"

        if ($panes.ExitCode -eq 0 -and (Wait-ViewerInput -Target $target)) {
            $null = Invoke-Program -Name 'tmux' -Argument @('send-keys', '-t', $target, $Rename, 'Enter')
        }

    }

    ## The workspace, on psmux

    function Invoke-Psmux {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string[]]
            $Argument
        )

        # psmux, run as tmux, its alias. A command it fails stops the launch, naming the command and what psmux said.
        $result = Invoke-Program -Name 'tmux' -Argument $Argument

        if ($result.ExitCode -ne 0) {
            $said = (@($result.Error) + @($result.Output)) -join ' '
            $message = "psmux failed: tmux $($Argument -join ' '): $said"
            Exit-Launch -ErrorId 'PsmuxFailed' -Category ResourceUnavailable -Message $message
        }

        return ($result.Output -join "`n").Trim()
    }

    function Open-Workspace {
        [CmdletBinding()]
        [OutputType([string])]
        param(
            [Parameter(Mandatory)]
            [string]
            $BackgroundId,

            [Parameter(Mandatory)]
            [string]
            $Label,

            [Parameter(Mandatory)]
            [string]
            $Directory,

            [Parameter(Mandatory)]
            [int]
            $ShellWidthPercent,

            [string[]]
            $Environment
        )

        # A new psmux session onto the background session: the viewer, claude attach, beside a shell that carries the
        # schedule's variables. It is made under a name psmux picks, then given its own, which carries its id, known
        # only once it exists. psmux loses a session whose name carries "/" or "|", and looks a bare pane id up in
        # another session, so every pane is named with its session (personal#273's plan, requirement 4).
        #
        # Leaving the viewer ends the session through the viewer's own command, since psmux never runs the pane-died
        # hook Start-Claude sets on tmux; the shell exiting on its own leaves the session standing.
        $viewer = "claude attach $BackgroundId; tmux kill-session"
        $session = Invoke-Psmux -Argument @(
            'new-session', '-d', '-P', '-F', '#{session_id}', '-c', $Directory, '--', 'pwsh', '-NoProfile', '-Command',
            $viewer
        )

        if ($session -notmatch '^\$[0-9]+$') {
            $message = "psmux named no session it opened: $session"
            Exit-Launch -ErrorId 'PsmuxSessionUnnamed' -Category InvalidData -Message $message
        }

        $script:madeSession = $session
        $null = Invoke-Psmux -Argument @('rename-session', '-t', $session, "$Label $session")
        $viewerIndex = (Invoke-Psmux -Argument @('list-panes', '-t', $session, '-F', '#{pane_index}')).Split("`n")[0]

        # The pane runs the default shell, which is what split-window starts when handed no command.
        $split = @('split-window', '-h', '-l', "$ShellWidthPercent%", '-t', $session, '-c', $Directory)

        foreach ($pair in $Environment) {
            $split += @('-e', $pair)
        }

        $null = Invoke-Psmux -Argument $split
        $null = Invoke-Psmux -Argument @('select-pane', '-t', "${session}:.$viewerIndex")

        # destroy-unattached is set before the attach: psmux runs no command chained after attach-session, and keeps a
        # session so set until a client comes, where tmux would end it at once.
        $null = Invoke-Psmux -Argument @('set-option', '-t', $session, 'destroy-unattached', 'on')
        return $session
    }

    function Enter-Workspace {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [string]
            $Session,

            [string]
            $Rename
        )

        # From inside psmux the current client switches to the session; otherwise the console attaches to it, through a
        # process of its own that has the console, so that a caller who keeps the script's output, its id, never takes
        # psmux's in its place. A session claude lists under another name is renamed in its viewer once a client is
        # there (#384, requirement 2).
        if ($env:TMUX) {
            $null = & tmux switch-client -t $Session
            $status = $LASTEXITCODE

            if ($Rename -and $status -eq 0) {
                Send-WorkspaceRename -Session $Session -Rename $Rename
            }

        }
        else {
            # It waits for psmux's client alone: Start-Process -Wait waits for every process the client leaves behind
            # too. The process's handle is taken first, so that its exit code is still there to read.
            $attach = Start-Process -FilePath 'tmux' -ArgumentList @('attach-session', '-t', $Session) -NoNewWindow `
                -PassThru
            $null = $attach.Handle

            if ($Rename) {
                Send-WorkspaceRename -Session $Session -Rename $Rename
            }

            $attach.WaitForExit()
            $status = $attach.ExitCode
        }

        if ($status -ne 0) {
            $message = "psmux ended with status ${status}: tmux attach-session -t $Session"
            Exit-Launch -ErrorId 'PsmuxAttachFailed' -Category ResourceUnavailable -Message $message
        }
    }

    function Complete-Launch {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [pscustomobject]
            $Background,

            [Parameter(Mandatory)]
            [string]
            $Label,

            [string[]]
            $Environment
        )

        # The launch ends at its background session: with -Detach, the session runs, started again when it was stopped,
        # and nothing more opens; otherwise a new psmux session opens onto it. The store's lock is released first.
        # Either way the launch returns the session's short id, as claude --bg prints it (personal#273's question 11).
        #
        # A schedule's session carries the launch's name (#260, requirement 3). One claude lists under another name is
        # renamed with /rename, never with a flag on the wake (#384): as the wake's first prompt when it is stopped, and
        # typed into the viewer a console attaches to when it runs. With -Detach a running one keeps its name, unless
        # NFEP_AGENT_SCHEDULE_DETACHED_RENAME is set (anthropics/claude-code#104688). A session this launch started has
        # the name already, and one on no schedule keeps its own.
        $rename = $null

        if ($scheduleKey -and $Background.State -and $Background.Name -cne $sessionName) {
            $rename = "/rename $sessionName"
        }

        if ($Detach) {

            if ($Background.State -ceq 'stopped') {
                Resume-BackgroundSession -ClaudeBinary $claudeBinary -Id $Background.Id -Session $Background.Session `
                    -Rename $rename
            }
            elseif ($rename -and $env:NFEP_AGENT_SCHEDULE_DETACHED_RENAME) {
                Rename-RunningSession -ClaudeBinary $claudeBinary -Id $Background.Id -Rename $rename -Name $sessionName
            }
            elseif ($rename) {
                $message = "Background session $($Background.Id) keeps its name until a launch opens it in a console: "
                $message += 'claude on Windows takes no keys in a viewer no client attaches.'
                Write-Verbose $message
            }

            Unlock-Store
            $message = "Detached: claude runs background session $($Background.Id), which Remote Control lists as "
            $message += "$sessionName. To open it in a console, run the same command without -Detach."
            Write-Verbose $message
            return $Background.Id
        }

        Write-Verbose "Opening $sessionName onto claude's background session $($Background.Id)"
        $session = Open-Workspace -BackgroundId $Background.Id -Label $Label -Directory $startupDirectory `
            -ShellWidthPercent $ShellWidthPercent -Environment $Environment

        # The session exists, and is handed over: the clean block leaves it.
        $script:madeSession = $null
        Unlock-Store
        Enter-Workspace -Session $session -Rename $rename
        return $Background.Id
    }

    function Unlock-Store {
        [CmdletBinding()]
        param()

        # The store's lock ends when its file closes: before the launch attaches, or leaves the session detached.
        if ($script:storeLock) {
            $script:storeLock.Dispose()
            $script:storeLock = $null
        }
    }

    ###########
    # Script state
    ###########

    $scriptName = [IO.Path]::GetFileNameWithoutExtension($PSCommandPath)

    # The titles the process block keeps: the one given by name, or one for each object piped.
    $titles = [System.Collections.Generic.List[string]]::new()

    # What the clean block undoes if the launch never hands it over: a temporary store file and a psmux session never
    # attached; and what it releases or puts back: the store's lock and the caller's location.
    $storeLock = $null
    $storeTemporary = $null
    $madeSession = $null
    $pushed = $false
}

process {

    if ($PSBoundParameters.ContainsKey('Title')) {
        $titles.Add($Title)
    }

}

end {
    ###########
    # Main
    ###########

    # Every error is caught (section 7 of the PowerShell style guide): the caller's error action is put back, the error
    # is reported under the script's name, and the script exits 1. The clean block runs after, as it does on exit.
    try {
        Require-Windows
        Require-Command 'git'
        Require-Command 'claude'
        Require-Command 'tmux'

        # One of the three ways in, or -Resume or -Continue with -Schedule (requirement 7; #322): the parameter sets
        # refuse any other two together, and the default set, -Schedule's, stands for none of them when -Schedule is
        # missing. With none given, an argument meant for claude binds to -Schedule, the only positional parameter, so
        # one that begins with a dash means none was given.
        if ($PSCmdlet.ParameterSetName -ceq 'Schedule' -and (-not $Schedule -or $Schedule.StartsWith('-'))) {
            $message = 'Give one of -Schedule, -Resume and -Continue, or -Resume or -Continue with -Schedule.'
            Exit-Launch -ErrorId 'OneWayInRequired' -Category InvalidArgument -Message $message
        }

        if ($Schedule -and $Schedule -cne 'new' -and
            $Schedule -notmatch '^([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+#)?[0-9]+$') {
            $message = "-Schedule takes <owner>/<repository>#<number>, a bare <number>, or new: $Schedule"
            Exit-Launch -ErrorId 'ScheduleMalformed' -Category InvalidArgument -Message $message
        }

        # A session left detached is reached through Remote Control, which -NoRemoteControl turns off, as Start-Claude
        # refuses --detach with --no-remote-control.
        if ($Detach -and $NoRemoteControl) {
            $message = '-Detach leaves the session for Remote Control, which -NoRemoteControl turns off: give one '
            $message += 'or the other.'
            Exit-Launch -ErrorId 'RemoteControlRequired' -Category InvalidArgument -Message $message
        }

        # From a console (requirement 5): Windows Terminal at the desktop, or an ssh session with a terminal. With its
        # input redirected, as from a pipe or an ssh command with no terminal, and no -Detach, nothing starts; inside
        # psmux the current client switches to the new session instead.
        if (-not $Detach -and -not $env:TMUX -and [Console]::IsInputRedirected) {
            $message = 'No console to attach the session to; nothing was started. Run the same command with -Detach '
            $message += 'to start the conversation for Remote Control, or run it from a console: Windows Terminal, or '
            $message += 'an ssh session with a terminal.'
            Exit-Launch -ErrorId 'ConsoleRequired' -Category ResourceUnavailable -Message $message
        }

        $startupDirectory = Resolve-StartupDirectory -Directory $Directory

        if (-not (Test-RepositoryRoot -Directory $startupDirectory)) {
            $message = "Not the root of a repository clone: $startupDirectory"
            Exit-Launch -ErrorId 'NotRepositoryRoot' -Category ObjectNotFound -Message $message
        }

        # Everything the session is named for is read from the startup directory, and claude starts there. The clean
        # block puts the caller's location back.
        Push-Location -LiteralPath $startupDirectory
        $pushed = $true

        $claudeBinary = (Get-Command 'claude').Source
        $configDirectory = Get-ClaudeConfigDirectory
        $projects = Join-Path -Path $configDirectory -ChildPath 'projects'

        # The store: one entry per schedule holds the background session that works it, as Start-Claude keeps it
        # (requirement 3), under XDG_STATE_HOME, or else ~/.local/state.
        $stateHome = $env:XDG_STATE_HOME

        if (-not $stateHome) {
            $stateHome = Join-Path -Path $HOME -ChildPath '.local\state'
        }

        $storeRoot = Join-Path -Path $stateHome -ChildPath 'agent-schedule'

        # Where the session runs, computed and never stored. The host follows the schedule in the session's name, for
        # remote sessions: a conversation lives on the box whose transcripts hold it, and Remote Control lists every
        # box's sessions together. Its domain is dropped, so the name never carries a ".".
        $repository = Get-RepositoryName -Directory $startupDirectory
        $branch = Invoke-Git -Directory $startupDirectory -Argument @('branch', '--show-current')

        if (-not $branch) {
            $branch = 'detached'
        }

        $hostName = ([System.Net.Dns]::GetHostName() -split '\.')[0]

        # What runs: claude's own list, read once.
        $instances = Get-ClaudeInstance -ClaudeBinary $claudeBinary

        # The conversation -Resume names, as claude --resume takes it (personal#273's question 12), or the one -Continue
        # finds running here, and its schedule: -Continue's is the one claude lists in the startup directory, met where
        # it runs.
        $chosen = $null
        $scheduleArgument = $Schedule

        if ($Resume) {
            $chosen = Resolve-ResumeArgument -Argument $Resume -Instance $instances -Projects $projects
        }
        elseif ($Continue) {
            $chosen = Get-ConversationRunningIn -Directory $startupDirectory -Instance $instances

            # With -Schedule and none listed here it refuses and starts nothing: claude's own --continue picks by
            # transcript, which can be another conversation (#322; the owner, 2026-10-21: "Yes, refuse and start
            # nothing.").
            if (-not $chosen -and $Schedule) {
                $message = "claude lists no conversation in $startupDirectory to put on $Schedule; nothing was started."
                Exit-Launch -ErrorId 'NoConversationToContinue' -Category ObjectNotFound -Message $message
            }
        }

        # Given with -Resume or -Continue, -Schedule is the schedule the conversation joins; alone, the conversation's
        # is the schedule whose entry holds it, or else none.
        if ($chosen -and -not $Schedule) {
            $scheduleArgument = Get-ScheduleRecording -Id $chosen -Root $storeRoot -Instance $instances
        }

        # A conversation on no schedule: -Resume of a conversation no entry holds, or -Continue of one claude lists
        # here, names the session for its id; -Continue with none hands the startup directory to claude's own
        # --continue, which in claude's background starts a copy of the conversation it picks, and the session is named
        # for where it runs. Nothing is stored either way.
        if (-not $scheduleArgument) {

            if ($chosen) {
                $sessionName = $chosen
            }
            else {
                $sessionName = "$hostName | $repository | $branch"
            }

            $background = $null

            if ($chosen) {
                $background = Resolve-BackgroundSession -Id $chosen -Instance $instances
            }

            if ($background) {

                if ($ClaudeArgument) {
                    $message = "Background session $($background.Id) keeps the options it was started with: the "
                    $message += "arguments after the script's own go only to a conversation a launch starts."
                    Write-Verbose $message
                }

            }
            elseif ($chosen) {
                Write-Verbose 'This conversation is on no schedule.'
                Write-Verbose "Resuming conversation $chosen in claude's background"
                $id = Open-BackgroundSession -ClaudeBinary $claudeBinary -What @('--resume', $chosen) `
                    -Name $sessionName -RemoteControl:(-not $NoRemoteControl) -PassThrough $ClaudeArgument
                $background = [pscustomobject]@{ Kind = 'background'; Id = $id; State = ''; Session = $chosen }
            }
            else {
                Write-Verbose "Continuing the conversation claude picks in $startupDirectory, in its background"
                $id = Open-BackgroundSession -ClaudeBinary $claudeBinary -What @('--continue') -Name $sessionName `
                    -RemoteControl:(-not $NoRemoteControl) -PassThrough $ClaudeArgument
                $background = [pscustomobject]@{ Kind = 'background'; Id = $id; State = ''; Session = '' }
            }

            $label = $background.Id

            if ($chosen) {
                $label = $chosen
            }

            Complete-Launch -Background $background -Label $label
            return
        }

        Require-Command 'gh'

        # The schedule: <owner>/<repository>#<number>, a bare <number> in the startup directory's repository, or new.
        if ($scheduleArgument -ceq 'new' -or $scheduleArgument -match '^[0-9]+$') {
            $scheduleSlug = Get-RepositorySlug -Directory $startupDirectory

            if (-not $scheduleSlug) {
                $message = "The startup directory's origin is not on GitHub: $startupDirectory"
                Exit-Launch -ErrorId 'OriginNotOnGitHub' -Category ObjectNotFound -Message $message
            }

        }

        # A title comes by name or from the pipeline, and the process block keeps each. Of several piped, the first is
        # the title, as the first line is on macOS and Linux. A new schedule must have one, and the prompt asks when
        # none is given; with any other schedule it is optional, and given, it retitles the issue.
        $titleGiven = $titles.Count -gt 0
        $givenTitle = $null

        if ($titleGiven) {
            $givenTitle = $titles[0]
        }

        if ($scheduleArgument -ceq 'new') {
            $answer = $givenTitle

            if (-not $titleGiven) {
                $answer = Read-Host -Prompt 'Schedule title'
            }

            $answer = "$answer".Trim()

            if (-not $answer) {
                $message = 'No schedule title was given; nothing is opened.'
                Exit-Launch -ErrorId 'TitleMissing' -Category InvalidData -Message $message
            }

            $scheduleUrl = Open-Schedule -Slug $scheduleSlug -Title $answer
            $scheduleNumber = $scheduleUrl.Split('/')[-1]
            $scheduleTitle = "Schedule: $answer"
            Write-Verbose "Opened $scheduleUrl"
        }
        else {

            if ($scheduleArgument -match '^[0-9]+$') {
                $scheduleNumber = $scheduleArgument
            }
            else {
                $scheduleSlug, $scheduleNumber = $scheduleArgument.Split('#')
            }

            $issue = Get-ScheduleIssue -Slug $scheduleSlug -Number $scheduleNumber

            # issue-standards.md, Schedules: a schedule is of kind chore, and its title begins "Schedule:".
            if (-not ($issue.title.StartsWith('Schedule:') -and @($issue.labels.name) -contains 'chore')) {
                $message = "$scheduleSlug#$scheduleNumber is not a schedule: a schedule is of kind chore and its title"
                Exit-Launch -ErrorId 'NotASchedule' -Category InvalidData -Message "$message begins ""Schedule:""."
            }

            $scheduleTitle = $issue.title
            $scheduleUrl = $issue.url

            if ($titleGiven) {
                $answer = "$givenTitle".Trim()

                if (-not $answer) {
                    $message = "No title was given; $scheduleSlug#$scheduleNumber keeps its own."
                    Exit-Launch -ErrorId 'TitleEmpty' -Category InvalidData -Message $message
                }

                $retitled = "Schedule: $answer"

                if ($retitled -cne $scheduleTitle -and
                    (Set-ScheduleTitle -Slug $scheduleSlug -Number $scheduleNumber -Title $retitled)) {
                    Write-Verbose "Retitled $scheduleSlug#$scheduleNumber to $retitled"
                    $scheduleTitle = $retitled
                }

            }

        }

        # The key is written as GitHub writes it, so names compare exactly. Rule 8: a schedule moved to another
        # repository answers from there, its key follows it, and an entry under the old key is reported, not carried
        # over.
        if ($scheduleUrl -match 'github\.com/([^/]+/[^/]+)/issues/([0-9]+)$') {
            $urlSlug = $Matches[1]
            $urlNumber = $Matches[2]

            if ("$urlSlug#$urlNumber" -ne "$scheduleSlug#$scheduleNumber") {
                $movedEntry = Join-Path -Path $storeRoot -ChildPath "$scheduleSlug\$scheduleNumber"
                Write-Verbose "$scheduleSlug#$scheduleNumber moved to $urlSlug#$urlNumber."

                if (Test-Path -LiteralPath $movedEntry -PathType Leaf) {
                    Write-Verbose "Its entry under the old key, $movedEntry, is not carried over."
                }

            }

            $scheduleSlug = $urlSlug
            $scheduleNumber = $urlNumber
        }

        # The name claude carries, and the one each psmux session onto it carries with its own id: the schedule's
        # repository and number, the same on tmux, since psmux loses a session whose name carries "/" or "|".
        $scheduleKey = "$scheduleSlug#$scheduleNumber"
        $sessionName = "$scheduleKey | $hostName | $repository | $branch | $scheduleTitle"
        $label = "$($scheduleSlug.Split('/')[-1])#$scheduleNumber"

        # The entry's path is made whole, its separators the platform's, so it compares equal to the path a listing of
        # the store gives. New-Item -Force makes nothing, and says nothing, when a folder above is a file;
        # CreateDirectory throws.
        $storeEntry = [IO.Path]::GetFullPath((Join-Path -Path $storeRoot -ChildPath "$scheduleSlug\$scheduleNumber"))
        $storeDirectory = Split-Path -Path $storeEntry -Parent

        try {
            $null = [IO.Directory]::CreateDirectory($storeDirectory)
        }
        catch {
            $message = "The store cannot be written: $storeDirectory. $($_.Exception.GetBaseException().Message)"
            Exit-Launch -ErrorId 'StoreNotWritable' -Category WriteError -Message $message
        }

        # From reading the schedule's entry until its background session exists, this launch holds the store's lock: a
        # second launch of the schedule waits, then finds the first's background session and opens a psmux session of
        # its own onto it.
        $storeLock = Lock-Store -Path "$storeEntry.lock"

        # The schedule's session: the store's, or the one -Resume names, or else a new conversation.
        $conversation = $chosen

        if (Test-Path -LiteralPath $storeEntry -PathType Leaf) {
            $storedId = Read-StoreEntry -Path $storeEntry

            if (-not $storedId) {
                $message = "The store's entry cannot be read: $storeEntry"
                Exit-Launch -ErrorId 'StoreEntryUnreadable' -Category ReadError -Message $message
            }

            # Rule 1: a session claude lists nowhere, and with no transcript, is set aside, and the schedule has none: a
            # running conversation may have no transcript yet, and a background session's short id names none. Rule 2:
            # one whose transcript is in another project folder is resumed all the same.
            $listed = Get-SessionPlace -Id $storedId -Instance $instances
            $storedBackground = Get-BackgroundId -Id $storedId -Instance $instances

            if (-not $listed -and -not (Get-TranscriptPath -Conversation $storedId)) {
                $message = "Session $storedId is set aside: claude lists it nowhere, and there is no "
                $message += "$storedId.jsonl under "
                Write-Verbose "$message$projects."
            }
            elseif (-not $chosen) {
                $conversation = $storedId
            }
            elseif ($storedBackground -cne (Get-BackgroundId -Id $chosen -Instance $instances)) {
                $message = "$scheduleKey is worked by $storedId. To give it $chosen, remove $storeEntry and run again."
                Exit-Launch -ErrorId 'ScheduleWorkedElsewhere' -Category WriteError -Message $message
            }

        }

        # Rule 4: one schedule per session. It is asked before the session is met where claude lists it, so that a
        # session on another schedule is never opened.
        if ($conversation) {
            $other = Get-ScheduleHolding -Id $conversation -Root $storeRoot -Entry $storeEntry -Instance $instances

            if ($other) {
                $message = "Session $conversation is already the session of $other; one schedule per session."
                Exit-Launch -ErrorId 'SessionOnAnotherSchedule' -Category WriteError -Message $message
            }

        }

        # The schedule's variables reach a background session this launch starts through --settings: claude's background
        # service starts a session without this launch's environment. The shell pane gets them through psmux.
        $settings = @{ env = @{ NFEP_AGENT_SCHEDULE = $scheduleKey; NFEP_AGENT_SCHEDULE_URL = $scheduleUrl } } |
            ConvertTo-Json -Compress
        $environment = @("NFEP_AGENT_SCHEDULE=$scheduleKey", "NFEP_AGENT_SCHEDULE_URL=$scheduleUrl")

        # Met where claude lists it: its background session, running or stopped, or refused in the foreground. Running
        # nowhere, it is resumed in claude's background under its own id; with none, a new conversation starts there.
        $background = $null

        if ($conversation) {
            $background = Resolve-BackgroundSession -Id $conversation -Instance $instances
        }

        if ($background) {

            if ($ClaudeArgument) {
                $message = "Background session $($background.Id) keeps the options it was started with: the arguments "
                $message += "after the script's own go only to a conversation a launch starts."
                Write-Verbose $message
            }

        }
        elseif ($conversation) {
            Write-Verbose "Resuming conversation $conversation in claude's background"
            $id = Open-BackgroundSession -ClaudeBinary $claudeBinary -What @('--resume', $conversation) `
                -Name $sessionName -Settings $settings -RemoteControl:(-not $NoRemoteControl) `
                -PassThrough $ClaudeArgument
            $background = [pscustomobject]@{ Kind = 'background'; Id = $id; State = ''; Session = $conversation }
        }
        else {
            Write-Verbose "Starting a new conversation in claude's background as $sessionName"
            $id = Open-BackgroundSession -ClaudeBinary $claudeBinary -What @() -Name $sessionName -Settings $settings `
                -RemoteControl:(-not $NoRemoteControl) -PassThrough $ClaudeArgument
            $background = [pscustomobject]@{ Kind = 'background'; Id = $id; State = ''; Session = '' }
        }

        $storeTemporary = "$storeEntry.$PID.tmp"
        Write-StoreEntry -Path $storeEntry -Temporary $storeTemporary -Id $background.Id
        $storeTemporary = $null

        Complete-Launch -Background $background -Label $label -Environment $environment
    }
    catch {
        $caught = $_
        $ErrorActionPreference = $callerErrorAction
        $PSCmdlet.WriteError($caught)
        exit 1
    }
}

clean {

    # It runs last, whether end finished, failed, called exit or was stopped, as Ctrl+C stops it. It undoes what the
    # launch changed and never handed over: a temporary store file, and a psmux session never attached. It releases the
    # store's lock and puts back the caller's location.
    if ($storeTemporary) {
        Remove-Item -LiteralPath $storeTemporary -Force -ErrorAction Ignore
    }

    if ($madeSession) {
        & tmux kill-session -t $madeSession 2>$null
    }

    if ($storeLock) {
        $storeLock.Dispose()
    }

    if ($pushed) {
        Pop-Location
    }

}
