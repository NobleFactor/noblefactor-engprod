---
title: "2. Command line — Start-Claude, today"
---

# 2. Command line — Start-Claude, today

> **Status:** built on macOS and Linux, 2026-10-15, and on Windows, as Start-Claude.ps1, 2026-10-19
> (David-Noble-at-work/personal#273). Companion: [`2-command-line.status.md`](2-command-line.status.md). Feature:
> [NobleFactor/noblefactor-ops#151](https://github.com/NobleFactor/noblefactor-ops/issues/151). Start-Claude(1) is
> the reference for every option, file and exit status.
>
> **Relationship to the neighbors.** [1. Session model](1-session-model.md) owns how a conversation and its tmux
> sessions live; this section owns the commands a person types, Start-Claude and Clear-Claude.
> [2.1](2.1-agent-schedule-commands.md) owns the commands that are to follow them.

## Its forms

One of three ways in, and the options any of them takes:

| Form | Opens |
| --- | --- |
| `Start-Claude --schedule <schedule>` | The schedule's conversation: `<owner>/<repository>#<number>`, a bare `<number>` in the startup directory's repository, or `new`, which opens a schedule titled from standard input |
| `Start-Claude --resume <conversation> [--schedule <schedule>]` | The conversation it names, as `claude --resume` takes it but its picker: its id, its background session's short id, its name, or its transcript's absolute path (personal#273's plan, question 12); on that schedule when one is given |
| `Start-Claude --continue [--schedule <schedule>]` | The conversation claude lists in the startup directory, on that schedule when one is given; with none listed, a copy of the one claude's own `--continue` picks, or, given a schedule, nothing: it refuses (NobleFactor/noblefactor-ops#322) |

- `--directory <directory>`: the startup directory, the root of a clone or of a linked worktree; the current one
  otherwise.
- `--detach`: start the conversation in claude's background, or wake it, and open no tmux session.
- `--no-remote-control`: start the background session without Remote Control; not with `--detach`.
- `--shell-width-percent <percent>`: the shell pane's width, 1 to 99, and 40 by default.
- After `--`: arguments for a conversation the launch starts, which its background session keeps.

## Its names

claude's background session carries `<owner>/<repository>#<number> | <host> | <repository> | <branch> | <title>`,
which is also its Remote Control name. Each tmux session onto it carries the schedule's repository and number and its
own tmux id, as in `devlore-cli#916 $34`, the same on psmux, which loses a session whose name carries `/` or `|` (the
plan for personal#273, question 1). A conversation on no schedule is named for its id, and the one `--continue` hands to
claude for the host, the repository and the branch; its tmux session is named for its id.

## Its store

One file per schedule, `${XDG_STATE_HOME:-~/.local/state}/agent-schedule/<owner>/<repository>/<number>`, holding the
background session's short id, with a lock beside it; [1. Session model](1-session-model.md) says how a start reads
it.

## Clear-Claude

`Clear-Claude` clears the conversation Start-Claude runs for a schedule, and removes every local record of it
(NobleFactor/noblefactor-engprod#411). Clear-Claude(1) is the reference for every option, file and exit status.

| Form | Does |
| --- | --- |
| `Clear-Claude --schedule <schedule> [--clear]` | Clears the conversation: the background session and every connection to it go on, in a new conversation with nothing of the old one to read. The default |
| `Clear-Claude --schedule <schedule> --retire` | Removes the background session too, ending every connection to it, and the schedule's store entry, so that the next start begins a new conversation |

- `<schedule>` is `<owner>/<repository>#<number>`, or a bare `<number>` in the repository of `--directory`, the root of
  a clone or of a linked worktree, or else of the current directory.
- The records are every trace of the conversation under claude's home and `/tmp/claude-<uid>`: its transcript and
  the folder beside it, its file history, its session environment, its temporary output, the memories it wrote, the
  pastes its transcript references that no other does, the job timeline's lines from before the clear, and the
  prompts typed in it, the `/clear` Clear-Claude typed among them. `--clear` empties the job folder of its scratch
  files; `--retire` removes the job folder. The run ends with a sweep: nothing left names the conversation's id or
  holds a prompt's text (#414, reopened 2026-10-27).
- It keeps the schedule, its worktrees and branches, everything on GitHub, other conversations, and the directory's
  trust. It removes nothing Anthropic holds.
- It runs on macOS and Linux, on the host claude runs on, from outside the conversation it clears. Windows has none:
  the owner, 2026-10-27, "Clear-Claude.ps1 is not in this PR."

## Where it runs

Start-Claude runs on macOS and Linux, from a terminal there or as the command of an ssh or mosh connection, and starts
nothing with no terminal unless `--detach` is given. On macOS it unlocks the login keychain from a terminal, since gh
and claude keep their logins there.

## Windows

Start-Claude.ps1 runs on psmux, a native Windows tmux, run as `tmux`, its alias (David-Noble-at-work/personal#273;
the owner's ruling of 2026-10-10). Its forms are Start-Claude's, in PowerShell's form: `-Schedule`, `-Resume`, alone
or with `-Schedule`, and `-Continue`, with `-Directory`, `-Detach`, `-NoRemoteControl` and `-ShellWidthPercent`, and
claude's arguments after the script's own, since PowerShell consumes a bare `--`. It opens from a console, Windows
Terminal at the desktop or an ssh session with a terminal; with its input redirected and no `-Detach` it starts
nothing, and inside psmux the current client switches to the new session. [1. Session model](1-session-model.md)
says where psmux differs from tmux. It narrates and refuses as PowerShell does, after Microsoft's
guidance to cmdlet authors (personal#273's plan, question 6): what it does goes to the verbose stream, a warning to the
warning stream, and a refusal is a terminating error, not one of Start-Claude's exit statuses. Both scripts return the
background session's short id, the one `claude --bg` prints, attached or detached: Start-Claude.ps1 to its output,
and Start-Claude on standard output (personal#273's plan, question 11).

