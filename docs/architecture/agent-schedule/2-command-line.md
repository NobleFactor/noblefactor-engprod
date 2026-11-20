---
title: "Start-Claude command interface"
status: draft
updated: 2026-11-19
---

<a id="2-command-line--start-claude-today"></a>

# Start-Claude command interface

[Up: Agent schedules](index.md)

Start-Claude selects a Claude conversation, starts or wakes its native background session, and opens a viewer with a companion shell. `--detach` performs the session operation without opening a view. [Session lifecycle](1-session-model.md) defines identity, locking and connection behavior.

<a id="its-forms"></a>

## 1. Select a conversation

| Form | Meaning |
| --- | --- |
| `Start-Claude --schedule <schedule>` | Reuse the schedule's bound session, or create its first conversation |
| `Start-Claude --resume <conversation> [--schedule <schedule>]` | Resolve and resume the selected conversation; associate it with the supplied schedule when permitted |
| `Start-Claude --continue [--schedule <schedule>]` | Select the conversation listed for the startup directory; optionally associate it with the supplied schedule |

A schedule is `<owner>/<repository>#<number>`, or a bare issue number resolved against the startup directory's repository. Create schedules with `star github schedule open <repository> <name>`; `--schedule new` is refused.

The resume selector accepts a conversation ID, background-session short ID, name or absolute transcript path. It does not open the native interactive resume picker.

With no conversation listed for the directory, `--continue` without a schedule delegates selection to Claude's native continuation path, which may create a copy. With a schedule, the launcher refuses that ambiguous case. It also refuses a conflicting existing schedule binding rather than silently replace it; the binding-conflict exit status is 73.

## 2. Launch options

| Option | Meaning |
| --- | --- |
| `--directory <directory>` | Use the specified clone or linked worktree; otherwise use the current directory |
| `--detach` | Ensure the background session exists or is awake, then return without tmux |
| `--no-remote-control` | Disable Remote Control for the background launch; incompatible with `--detach` |
| `--shell-width-percent <percent>` | Set the companion shell width from 1 through 99; default 40 |
| `-- <arguments>` | Pass arguments to a conversation created by this launch; they remain with that background session |

An attached invocation requires a terminal. On macOS, the launcher unlocks the login keychain from that terminal when needed for the stored GitHub and Claude credentials. A launch without a terminal must use `--detach` and still satisfy the credential requirements.

<a id="its-names"></a>
<a id="its-store"></a>

## 3. Names, storage and output

The [session model](1-session-model.md#4-names-and-viewer-input) defines background and tmux names. Its [binding](1-session-model.md#2-components) stores a background-session short ID under the repository-qualified schedule key, with a neighboring lock.

Both attached and detached forms return that short ID. The Unix command writes it to standard output and sends diagnostics to standard error. [Start-Claude(1)](../../../Home/common.Unix/.local/share/man/man1/Start-Claude.1) is the complete reference for options, files, environment variables and exit statuses.

<a id="where-it-runs"></a>
<a id="windows"></a>

## 4. Platform interfaces

The Unix command runs in a local terminal or through SSH or mosh. The Windows command, Start-Claude.ps1, uses psmux through its `tmux` alias and supports a console, Windows Terminal or an SSH terminal.

| Unix | PowerShell |
| --- | --- |
| `--schedule` | `-Schedule` |
| `--resume` | `-Resume` |
| `--continue` | `-Continue` |
| `--directory` | `-Directory` |
| `--detach` | `-Detach` |
| `--no-remote-control` | `-NoRemoteControl` |
| `--shell-width-percent` | `-ShellWidthPercent` |

PowerShell consumes a bare `--`; native Claude arguments follow the script's parameters using its supported parameter handling. PowerShell returns the short ID on the success stream, sends narration to the verbose stream and warnings to the warning stream, and reports refusals as terminating errors with the corresponding error category.

## 5. Decisions and related interfaces

The [command decision record](2-command-line.decisions.md) explains schedule creation, native selection and structured output boundaries. The [assignment interface proposal](2.1-agent-schedule-commands.md) describes the broader command family without making those proposed names part of Start-Claude's interface.

<a id="clear-claude"></a>

## 6. Delivery references

Implementation and deployment evidence is linked from the [delivery references](2-command-line.status.md). The [pre-rewrite source](../../engineering/review/sources/rewrite-2026-11-19/2-command-line.md.txt) retains the earlier document; [Clear-Claude removal](../../plans/refactor/529-remove-clear-claude.md) records that separate transition.
