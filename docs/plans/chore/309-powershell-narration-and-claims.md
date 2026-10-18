---
title: "The PowerShell style guide narrates as Microsoft's guidance does, and agent-rules requires labeled claims"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/309
status: active
created: 2026-10-17
updated: 2026-10-18
---

# Plan: The PowerShell style guide narrates as Microsoft's guidance does, and agent-rules requires labeled claims

## Issue 309

Lane 14 of NobleFactor/noblefactor-ops#301 (schedule), ahead of the rest of lane 10, its own pull request, under
feature NobleFactor/noblefactor-ops#266. Found 2026-10-17, working lane 10, David-Noble-at-work/personal#273:
Start-Claude.ps1 wrote Declare-BashScript's markers to standard error, read what gh printed in the console's code
page, and the house had no written standard for how a PowerShell script talks to its caller. The owner's rulings, the
same day, in the plan for #273, question 6:

- Of the encoding: "Avoid code page changes entirely." Of the console's wide-character interface: "I need a
  compelling argument to be using win32 apis. VERY compelling."
- Of the messages: "You are going off the rails. Powershell has its own way of narrating. We distinguish in bash
  because we must. Powershell distinguishes using its own methods."
- After a survey of Microsoft's guidance to cmdlet authors and of the module world: "We should follow microsoft's
  guidelines and I think that means we honor all defaults and use Write-Error, Write-Warning, and Write-Verbose;
  staying away from Write-Information and Write-Progress without a compelling reason. I can think of one compelling
  reason for Write-Progress: long running operations like Download where I can compute a progress bar. I can think of
  no reason for Write-Information in light of Microsoft guideance." Three amendments, agreed ("I agree with your
  [amendments] 1, 2, and 3"): `Write-Debug` beside them; a result as an output object; `Write-Progress` for a long
  operation, as the guideline has it.
- Of a refusal: "a refusal is a terminating error, as the guidance has it."
- Of the common parameters: "we must pass all our preference variables down to all powershell cmdlets and scripts
  that we call", and "I expect the latter applies to all common parameters, not just preference variables."
- Of the documents: "We will update the style guide as required to match all our powershell scripts to a common
  standard. We'll update our own guidance and include references to Microsoft's guidance, bring Start-Claude.ps1 into
  agreement with our new standards, and fix other scripts later."
- Where: "file the noblefactor-ops process work now as a lane of NobleFactor/noblefactopr-ops#301, ahead of the rest
  of lane 10."

And for agent-rules, the owner's rule on claims: "I'm taking action based on what you say. Understand that when you
fail to identify certain from uncertain messages that I am taking action with the assumption that what you say is
fact." (2026-10-05), and "I expect probability statements, not statements of fact when there is uncertainty."
(2026-10-06). Broken twice on 2026-10-17: anthropics/claude-code#103060 and anthropics/claude-code#103075. Broken a
third time the same day, during phase 2: anthropics/claude-code#103117.

## Summary

`docs/guides/powershell-style-guidelines.md` gains a section on how a script reports to its caller. A result is an
output object; what the script does goes to the verbose stream, a warning to the warning stream and a diagnostic to
the debug stream; progress is shown only for a long operation the script can measure; nothing goes to the information
stream or the host; a refusal is a terminating error; every preference's default is honored; the common parameters
are passed on where PowerShell does not pass them; and a native program's output is read as UTF-8 without the
console's code page being changed. Each rule cites Microsoft's guidance to cmdlet authors, or says why the house goes
further. `docs/guides/agent-rules.md` gains rule 14: a claim says how it is known. Lane 10 then brings Start-Claude.ps1
into line, and the house's other scripts follow later.

## Goals

1. One written standard for a PowerShell script's messages and failures, Microsoft's, cited.
2. A rule of record that an agent labels every claim.
3. A standard for lane 10 to bring Start-Claude.ps1 to.

## Current State

Read 2026-10-17 at develop.

| What | Today |
| --- | --- |
| `docs/guides/powershell-style-guidelines.md` | Ten sections; none says how a script narrates. Section 6 says to set `$ErrorActionPreference = 'Stop'` when a script requires fail-fast behavior, and to throw an actionable message |
| `docs/guides/agent-rules.md` | Thirteen rules, last updated 2026-10-03; none on labeling a claim |
| The house's scripts | `.github/scripts/Test-PowerShell.ps1` and `Home/common.Windows/.local/bin/Remove-BrokenLinks.ps1` narrate with `Write-Information -InformationAction Continue`; personal's Start-Claude.ps1 writes Declare-BashScript's markers to standard error |
| The analyzer | `Home/common/.config/PSScriptAnalyzer/PSScriptAnalyzerSettings.psd1` runs every rule, `ExcludeRules = @()`, PSAvoidUsingWriteHost among them |
| #262 | Plans a PowerShell counterpart to Declare-BashScript: its statuses, its message form, and the platform requirements |

## Requirements

### Requirement 1: the style guide's section on messages and failure

Section 7, "Messages and failure", after section 6, "Error Handling", sections 7 to 10 renumbered 8 to 11 (question
1), states each rule with its source:

1. **A result is an output object,** written to the success stream. Microsoft, of `WriteObject`: "We recommend that
   you call this method instead of the System.Console.WriteLine or
   System.Management.Automation.Host.PSHostUserInterface.WriteLine methods." ([Types of cmdlet output][output])
2. **What the script does goes to the verbose stream,** `Write-Verbose`, shown when the caller asks with `-Verbose`.
   Microsoft: "A cmdlet should call the WriteVerbose method when the user requires some detail about what the cmdlet
   is doing." ([Strongly encouraged development guidelines][guide])
3. **A warning goes to the warning stream,** `Write-Warning`, when the script "is about to perform an operation that
   might have an unintended result". ([guide])
4. **A diagnostic goes to the debug stream,** `Write-Debug`, for when "a developer or product support engineer must
   understand what has corrupted the cmdlet operation". ([guide])
5. **Progress is shown only for a long operation whose progress can be computed,** as a download's, with
   `Write-Progress`. Microsoft: "Cmdlet operations that take a long time to complete and that cannot run in the
   background should support progress reporting". ([guide]) The PowerShell Committee ruled against progress for
   Test-Connection, whose replies show as they come (PowerShell/PowerShell#6768, 2019-05-08).
6. **Nothing goes to the information stream or the host.** Microsoft's guidance to cmdlet authors never names the
   information stream, and no cmdlet that ships with PowerShell narrates there: one that did, Test-Connection in
   PowerShell 6, was called "quite literally unprecedented" (PowerShell/PowerShell#6768). Microsoft: "Unless a cmdlet
   is specifically designed to generate a graphical user interface (GUI), it should not bypass the host". ([guide])
   The analyzer already refuses `Write-Host`.
7. **A script catches every error, stops, and lets the caller decide what the error does to them** (question 2). Its
   work sits inside `try` and `catch`: one around the whole body, or one in each of `begin`, `process` and `end`,
   because a `try` cannot span blocks. On any error, its own refusals included, the script stops. It reports the error
   as a cmdlet would, with `$PSCmdlet.WriteError` under the caller's error action, so the caller sees the script's
   name and the error's own category, and exits 1. A caller who continues on error continues, one who silences errors
   hears nothing, and one who stops on error stops. Microsoft: "When a non-terminating error occurs, the cmdlet calls
   the ... WriteError method to send an error record to the error data stream." ([output]) A refusal is an error
   record of the script's own, with an id and a category, thrown inside the caught work (proposed, phase 2): the
   `catch` reports it like any other error, and the caller sees the script's name, `RequiresWindows` and
   `InvalidOperation`, where a thrown string shows "Exception:" with its message for an id.
   `$PSCmdlet.ThrowTerminatingError` is not the way: it skips the script's own `catch`, so the error never reaches the
   caller under their error action and the script never exits 1 (all seen 2026-10-17, each in a fresh session).
8. **The defaults are the caller's.** A script sets none of `$VerbosePreference`, `$WarningPreference`,
   `$InformationPreference`, `$DebugPreference` or `$ProgressPreference`, and turns no stream on by force. The one
   preference it sets is section 6's `$ErrorActionPreference = 'Stop'`, for its own work, and it puts the caller's
   back before it reports an error (item 7).
9. **The common parameters are passed on where PowerShell does not pass them.** The eight that work through a
   preference variable, `-Verbose`, `-Debug`, `-ErrorAction`, `-WarningAction`, `-InformationAction`,
   `-ProgressAction`, `-WhatIf` and `-Confirm`, reach the scripts and compiled cmdlets a script calls, and not a
   script module's functions, which see only global settings (PowerShell/PowerShell#4568), nor jobs and other
   runspaces. A script passes them to those, as `-WhatIf:$WhatIfPreference`. The other six, the `-*Variable`
   parameters, `-OutBuffer` and `-PipelineVariable`, belong to the one command they are given to
   (about_CommonParameters). Seen 2026-10-17 with samples: a module function, called without it, would have made a
   change the user ran with `-WhatIf`.
10. **A native program's output is read as UTF-8,** through .NET's `Process` with `StandardOutputEncoding` and
    `StandardErrorEncoding` set, since PowerShell reads it in the console's code page: an em dash in a GitHub title
    reached claude as three other characters (seen 2026-10-17, code page 437). The console's code page is never
    changed, and no Win32 call is made.

The section names its references: the two Microsoft pages above, about_CommonParameters, about_Preference_Variables,
about_Output_Streams, PowerShell/PowerShell#6768 and PowerShell/PowerShell#4568.

### Requirement 2: agent-rules' rule 14, "A claim says how it is known"

In the document's form. **The rule:** every claim is marked verified, saying how and when; certain, from the agent's
own action; or a probability; and a summary is no stronger than its source. **The breakage:** 2026-10-17, twice: a
stored value reported correct from a check whose two decoding errors canceled out (anthropics/claude-code#103060),
and a cited issue's claim turned into a false absolute by dropping its stated exception
(anthropics/claude-code#103075), with the owner's words of 2026-10-05 and 2026-10-06; and the third time that day,
during phase 2 (question 6): a refusal's form reported verified from an exit status left over from a loop's earlier
cases (anthropics/claude-code#103117). **Compliance:** name the command behind every "verified"; check an encoding by
its code points, not its glyphs; quote a source with its exceptions; and read each case's result from a run of its
own, a fresh session or its state reset first (question 6). The document's `updated:` is the day it lands.

### Requirement 3: what this settles elsewhere

- The plan for personal#273 cites the section for Start-Claude.ps1, lane 10.
- #262 is closed as superseded by this issue, and lane 56 of NobleFactor/devlore-cli#916 with it (question 3).
- The house's other scripts follow later, as the owner ruled, one issue in each repository:
  NobleFactor/noblefactor-ops#310, NobleFactor/devlore-cli#1043 and David-Noble-at-work/personal#283 (question 4).

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on the branch as a draft in d0e441f, reviewed with the owner, and its five open questions
  ruled, 2026-10-17. Approved the same day: "Commit the rulings and let's move on with the task at hand".

### Phase 2: The style guide

- [x] Requirement 1, with its references: section 7, "Messages and Failure", sections 7 to 10 renumbered 8 to 11,
  section 1's script configuration and section 6's first and fourth bullets brought to it, 2026-10-17. Its two examples
  were run on this Mac as printed: the error example in fresh sessions, the caller under `Continue` (shown, exit
  status 1), `SilentlyContinue` (recorded only) and `Stop` (caught), and as a process (exit 1); the process example
  read gh's output, exit code 0. Reviewed by the owner: "Let's commit."

### Phase 3: agent-rules

- [x] Requirement 2: rule 14, "A claim says how it is known", with the three breaches of 2026-10-17 (question 6),
  and the document's `updated:` set to 2026-10-18. Reviewed by the owner the same day: "Commit these changes".

### Phase 4: The gates and closure

- [ ] `make check`; the pull request, closing #309, and lane 14's row on #301 set to it.

## Files

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/chore/309-powershell-narration-and-claims.md` | Create | This plan |
| `docs/guides/powershell-style-guidelines.md` | Modify | Requirement 1 |
| `docs/guides/agent-rules.md` | Modify | Requirement 2 |

## Out of Scope

- Start-Claude.ps1: lane 10, personal#273.
- `Test-PowerShell.ps1`, `Remove-BrokenLinks.ps1` and every other script: later, as ruled, in #310,
  NobleFactor/devlore-cli#1043 and David-Noble-at-work/personal#283.
- Declare-BashScript and the bash style guide, #267.

## Open Questions

1. **Where the section goes.** Proposed: section 7, "Messages and failure", after section 6, "Error Handling", with
   sections 7 to 10 renumbered 8 to 11. Or: section 11, at the end, nothing renumbered. No document cites sections 7
   to 10 (searched 2026-10-17: base, team and personal cite sections 1, 2, 3 and 6). **Ruled 2026-10-17:** "[Use]
   Section 7 as the new section number".
2. **Section 6's `$ErrorActionPreference = 'Stop'`,** where "honor all defaults" meets it. A script's own `Stop`
   overrides a caller's `-ErrorAction` for the script's cmdlets, and leaves the caller's preference as it was (seen
   2026-10-17). **Ruled 2026-10-17:** "A cmdlet that produces an error causes processing to stop, but the script's
   error action honors the caller's preference. Downstream from our script the caller might continue following an
   error in our script, but we stop processing following an error." And: "I'm talking about error handling. We catch
   all errors. What we do on error depends on the ErrorActionPreference." So `Stop` stays for the script's own work,
   and the caller's error action decides what the script's error does to the caller. The idiom (proposed): note the
   caller's error action, set `Stop`, and in the `catch` around the work, put the caller's action back, report the
   error with `$PSCmdlet.WriteError`, and exit 1. Seen to work on 2026-10-17: under the caller's `Continue`, the error
   shows and the caller runs on, with `$LASTEXITCODE` 1; under `SilentlyContinue`, it is recorded in `$Error` and not
   shown; under `Stop`, the caller's `try` catches it; and run as a process, the script exits 1. `Write-Error` does the
   same, but the caller sees "Write-Error:" where `$PSCmdlet.WriteError` shows the script's name, and its `-Message`
   form loses the error's category and leaves a second record in `$Error` (seen the same day). **Ruled 2026-10-17:**
   "It seems that $PSCmdlet.WriteError is the one we want."
3. **#262,** whose message form and statuses this settles; its platform requirements stand. Proposed: retitle it to
   the platform requirements alone. Then, once section 7's error handling was ruled, offered: close it as superseded,
   since a platform requirement is one check at the start of a script's caught work (1), or retitle it to the platform
   requirements alone, as a helper scripts dot-source (2). **Ruled 2026-10-17:** "1". Closed the same day with a
   comment, and lane 56 of NobleFactor/devlore-cli#916 marked to match.
4. **The house's other scripts.** An issue for each now, or when their turn comes. A first screen on 2026-10-17
   found 19 of the 48 `.ps1` in base, team and personal writing to the information stream or the host, or exiting
   with a status of their own; Start-Claude.ps1 is one, and lane 10's. **Ruled 2026-10-17:** "File one issue in each
   repos for the lot." Filed the same day, each a chore under #266 that waits on this issue, unscheduled:
   NobleFactor/noblefactor-ops#310, NobleFactor/devlore-cli#1043 and David-Noble-at-work/personal#283.
5. **#266's title** names bash alone: "Scripting standards: every bash script follows one written pattern". Proposed:
   "Scripting standards: every script follows one written pattern". **Ruled 2026-10-17:** "Retitle". Retitled the
   same day, and #309's Feature line with it.
6. **Rule 14's third breach.** anthropics/claude-code#103117 came during phase 2, after the plan was approved with
   two. Asked whether rule 14 lists it too; recommended yes, with one compliance line, each case's result read from a
   fresh run of its own. **Ruled 2026-10-18:** "List all three". The compliance line is taken as part of the
   recommendation the ruling accepted (proposed).
7. **A rule for the day's breach.** anthropics/claude-code#103299, found 2026-10-18 preparing this pull request: six
   issues filed from 2026-10-15 to 2026-10-17 without the "Plan and design documents" table that
   development-process.md requires of every issue the day it is filed, #309 among them; the tables were added the
   same day. The global instructions say of agent-rules: "Add one there the day you break one." Proposed: rule 15 in
   this pull request, "An issue is checked against the standards before it is filed": its breakage that one, and its
   compliance a filing script that refuses a body without the table or the marker that places the issue. Or: a lane
   of its own, after this one.

[guide]: https://learn.microsoft.com/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines
[output]: https://learn.microsoft.com/powershell/scripting/developer/cmdlet/types-of-cmdlet-output
