---
title: "A --detach wake restarts the stopped session itself, and Start-Claude renames a session, running or stopped, with /rename"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/384
status: draft
created: 2026-10-23
updated: 2026-10-23
---

# Plan: A --detach wake restarts the stopped session itself, and Start-Claude renames a session, running or stopped, with /rename

## Issue 384

Lane 17 of NobleFactor/noblefactor-engprod#301, worked before lane 16 (NobleFactor/noblefactor-engprod#341), which
changes the same wake, and lane 5's acceptance waits on it. The owner, 2026-10-23: "It should be in your schedule."
Then, asked to add it so: "Yes". Recorded on #301 the same day.

## Summary

Since NobleFactor/noblefactor-engprod#375, a `--detach` wake of a stopped session runs
`claude --bg --resume <id> --name <name>`. Given any flag there, claude starts a copy under a new id, the copy fails,
and the stopped session stays stopped. Reported to Anthropic as anthropics/claude-code#104658. The wake drops the flag
and passes the name as its first prompt instead, `/rename <name>`, which restarts the session itself and renames it.
A running session, which claude gives a script no way to reach with a slash command, gets `/rename` typed into a viewer
through tmux. Both happen only when claude lists the session under another name, and both in Start-Claude.ps1 too,
through psmux. The owner, 2026-10-23, of the two routes: "Reasonable." Then: "Do the same for start-claude.ps1. We
don't need two bugs. Just the one in the current tree."

## Goals

1. **The wake restarts the session itself,** under its own id, and no copy is started.
2. **The name holds everywhere,** running and stopped, without a flag on the wake: #260's requirement 3, kept by
   another route.
3. **No interaction.** Both renames run from the script, with or without a terminal.

## Current State

| Part | Today |
| --- | --- |
| The wake | `Start-Claude:808`, `wake_background`: `claude --bg --resume "$background_session" --name "$session_name"`; `Start-Claude.ps1:1208`, `Resume-BackgroundSession`, the same |
| When it runs | Only with `--detach`, when claude lists the schedule's session `stopped` (`Start-Claude:876`); without `--detach`, the viewer's `claude attach` restarts it |
| A running session | Never renamed: a launch that meets one opens a viewer onto it, or with `--detach` leaves it as it is |
| The stand-ins | The test scripts' claude wakes whatever `--bg --resume` names, flags or none, so the wake case passes against the defect |
| The design | [1. Session model](../../architecture/agent-schedule/1-session-model.md), item 3 of a start: the wake "is given the launch's name"; its status companion ticks it |

What claude 2.1.309 does, seen on Danoble-MBP-A on 2026-10-23 with throwaway sessions in devlore-cli's clone, each case
on a session of its own:

| Command, on a session claude lists `stopped` unless said | What claude did |
| --- | --- |
| `claude --bg --resume <id> --name <its own name>` | "note: background session d9035663 keeps its own saved options, so the flags you passed started a copy as 73eee0cf. Without flags, the same command continues d9035663 itself." The copy failed; the session stayed stopped |
| `claude --bg --resume <id>` | "note: woke session 16410483 with its saved options (--name, --model)." Its own id, its name |
| `claude --bg --resume <id> "/rename test-rename-new"` | Woke it under its own id, renamed; the name held after a stop and a bare wake |
| `claude --resume <id> "/rename <name>"`, running, in a terminal | "Your prompt was not sent to it: a prompt starting with / would run as a command there." Exit 1 |
| `claude --bg --resume <id> "/rename <name>"`, running | "session 923b6ada is already running in the background, so this started a copy as 976a667a." The copy failed |
| `/rename <name>` typed into `claude attach` through `tmux send-keys`, running | Renamed within a second, idle and mid-turn, with the viewer kept open and with it killed at once; the name held after a stop and a bare wake |

The viewer is ready for keys once its input line, `❯`, is drawn: 0.2 to 1 second after `claude attach` starts.

## Requirements

### Requirement 1: the wake

`wake_background` and `Resume-BackgroundSession` wake a stopped session with no flags. When claude lists it under a
name other than the launch's, the name goes as the first prompt; otherwise the wake passes nothing, and the session
keeps the name it saved:

```bash
# Start-Claude:808, wake_background; $1 is "/rename $session_name", or empty when the names match
"$claude_binary" --bg --resume "$background_session" ${1:+"$1"} </dev/null 2>&1 9>&-
```

```powershell
# Start-Claude.ps1:1208, Resume-BackgroundSession; $Rename is "/rename $Name", or empty when the names match
$argument = @('--bg', '--resume', $Session) + @($Rename | Where-Object { $_ })
$result = Invoke-Program -Name $ClaudeBinary -Argument $argument
```

The name claude lists reaches the launch as a sixth field of claude's list, and `arrive` decides:

```bash
# running_conversations, Start-Claude:336
listed="$(jq --raw-output '.[] | [.sessionId, .kind, (if .kind == "background" then .id else "\(.pid)" end),
    .cwd // "", .state // "", .name // ""] | @tsv' <<<"$listing")"
# place_of and meet_running pass it on as background_name

# arrive, Start-Claude:874
function arrive {
    local rename=""
    [[ $background_name == "$session_name" ]] || rename="/rename $session_name"

    if ((detach)); then
        if [[ $background_state == stopped ]]; then
            wake_background "$rename"
        elif [[ $rename ]]; then
            rename_running "$rename"      # requirement 2
        fi
        leave_detached
    fi

    open_workspace "$rename"              # requirement 2, its own viewer pane
}
```

Its note passes on claude's words as today.

### Requirement 2: a running session

When claude lists the schedule's session running under a name other than the launch's, the launch types
`/rename <name>` into a viewer onto it:

```bash
tmux new-session -d -s "$r" "$claude_binary attach $background_id"     # or, without --detach, the workspace's own viewer pane
until tmux capture-pane -p -t "$r" | grep -q '^❯'; do :; done          # with a timeout: on it, a note, and no rename
tmux send-keys -t "$r" "/rename $session_name" Enter
tmux kill-session -t "$r"                                                # a viewer it made for this alone
```

```powershell
# Start-Claude.ps1, through Invoke-Psmux; psmux loses a bare pane id, so every target is the session's id
$viewer = Invoke-Psmux -Argument @('new-session', '-d', '-P', '-F', '#{session_id}', '--',
    'pwsh', '-NoProfile', '-Command', "claude attach $BackgroundId")
# until (Invoke-Psmux -Argument @('capture-pane', '-p', '-t', $viewer)) -match '(?m)^❯', with a timeout
Invoke-Psmux -Argument @('send-keys', '-t', $viewer, "/rename $Name", 'Enter')
Invoke-Psmux -Argument @('kill-session', '-t', $viewer)
```

Without `--detach` or `-Detach`, the keys go to the viewer pane of the tmux or psmux session the launch opens anyway,
so nothing extra opens.

On Windows, a running session is renamed only when a terminal is attached, that is, without `-Detach`: with no client
attached to its psmux session, claude's viewer takes no keys from `send-keys`, though a pwsh prompt, a raw console
reader and node in raw mode there all do (anthropics/claude-code#104688, seen on danoble-wd11-3 2026-10-23). A
`-Detach` launch leaves a running session's name to its next wake. The owner, 2026-10-23: "Yes, rename only when a
terminal is attached."

### Requirement 3: the cases

In `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1`. The stand-in claude starts a copy when a wake carries a
flag, as claude does, takes a first prompt, and its `attach` draws `❯` and records the lines typed into it:

- a `--detach` wake of a stopped session carries no flag and the prompt `/rename <the launch's name>`, and wakes the
  session itself;
- a running session listed under another name gets `/rename <the launch's name>` typed, with `--detach` and without;
- a running session listed under the launch's name gets nothing typed.

### Requirement 4: the words

Start-Claude(1), Start-Claude.ps1's help, [1. Session model](../../architecture/agent-schedule/1-session-model.md),
item 3, and its status companion say how the name reaches a stopped and a running session. Item 3's "is given the
launch's name" becomes the prompt. #260's plan, requirement 3, says its wake now goes by `/rename`, from this plan.

### Requirement 5: acceptance

On Danoble-MBP-A, after the merge and its deploy, the owner runs the commands the pull request's script prints:

1. `Start-Claude --schedule <n> --detach`, then `claude stop <id>`, then `Start-Claude --schedule <n> --detach` again.
   `claude agents` lists the session running under its own id and the launch's name, and no copy.
2. A schedule's session renamed by hand, running: the next `Start-Claude --schedule <n> --detach` names it again.

Then #260's requirement 4, lane 5's acceptance, runs again.

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on its branch as bcfc25f on 2026-10-23, and reviewed with the owner the same day, one
  question at a time. Asked whether to start phase 2, the owner: "Yes".

### Phase 2: The code and the cases

- [x] psmux's `capture-pane` and `send-keys`, proved on danoble-wd11-3 with a throwaway session before Start-Claude.ps1
  uses them. If they fail, the work stops here for a replan with the owner. Done 2026-10-23: `capture-pane` works, and
  `send-keys` reaches claude's viewer only with a client attached, so the work stopped and was replanned: requirement
  2's Windows paragraph. Filed as anthropics/claude-code#104688.
- [ ] Open question 4, checked again: a session mid-turn whose viewer is killed right after the keys, watched until
  its turn ends. A bug is filed if it still reads `working` long after its twin finishes.
- [ ] Requirements 1 to 3: `make check`, and every test on Danoble-MBP-A, danoble-ud24-1 and danoble-wd11-3 through
  `make test HOSTS="..."`, in a script the owner runs. The tests run git, `git init` among it, so the run is asked for
  by name (agent-rules.md, rule 17).

### Phase 3: The words

- [ ] Requirement 4.

### Phase 4: Closure

- [ ] The pull request, closing #384 and with it lane 17 of #301 once recorded. Each host takes the merge in the script
  that merges it: Danoble-MBP-A and danoble-ud24-1 there, danoble-wd11-3 over HTTPS. The plan stays `active` until
  phase 5, which follows the deploy.

### Phase 5: Acceptance

- [ ] Requirement 5, after the merge and its deploy.

## Migration Path

None: a session named before this keeps its name, and one whose name has drifted, as #301's own, which still carries
noblefactor-ops, is renamed by its next launch.

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `docs/plans/fix/384-waking-a-stopped-session-with.md` | Create | this plan |
| `Home/common.Unix/.local/bin/Start-Claude` | Modify | the wake's prompt, and the rename of a running session |
| `Home/common.Windows/.local/bin/Start-Claude.ps1` | Modify | the same, and its help |
| `Home/common.Unix/.local/share/man/man1/Start-Claude.1` | Modify | the wake and the rename |
| `tests/Test-StartClaude` and `tests/Test-StartClaude.ps1` | Modify | requirement 3's stand-ins and cases |
| `docs/architecture/agent-schedule/1-session-model.md` and its status companion | Modify | item 3 |
| `docs/plans/chore/260-schedule-from-environment.md` | Modify | requirement 3's wake |

## Related Documents

- NobleFactor/noblefactor-engprod#384; NobleFactor/noblefactor-engprod#301 (schedule), lane 17 as proposed
- NobleFactor/noblefactor-engprod#260, lane 5, whose requirement 3 the wake keeps; NobleFactor/noblefactor-engprod#375,
  which added the flag
- NobleFactor/noblefactor-engprod#341, lane 16: a wake after `/clear`, the same wake
- anthropics/claude-code#104658: a flag on `claude --bg --resume` of a stopped session starts a copy, which fails
- anthropics/claude-code#104688: on Windows, `claude attach` in a psmux pane with no client attached takes no keys
- [1. Session model](../../architecture/agent-schedule/1-session-model.md), item 3 of a start

## Open Questions

1. **Rename only when the name differs?** Ruled 2026-10-23: yes, by requirement 1's `arrive`. Shown the code, the
   owner: "Go for it".
2. **Which issue holds the rename of a running session?** Ruled 2026-10-23: #384. The owner: "We don't need two bugs.
   Just the one in the current tree."
3. **Start-Claude.ps1.** Ruled 2026-10-23: it does the same, through psmux. The owner: "Do the same for
   start-claude.ps1." Phase 2 then found that claude's viewer on Windows takes keys only with a client attached.
   Ruled the same day: on Windows, a running session is renamed only when a terminal is attached. The owner: "Yes,
   rename only when a terminal is attached."
4. **A session that read `working` for two minutes.** In the test whose viewer was killed right after the keys, the
   session still read `working` 120 seconds later, when its twin, viewer kept open, finished the same turn in 20.
   Unexplained. Ruled 2026-10-23: phase 2 checks it again, and a bug is filed if it repeats. The owner: "Yes".
