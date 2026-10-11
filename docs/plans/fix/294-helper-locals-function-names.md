---
title: "Declare-BashScript's names follow the house's rules, and one Set-Environment serves scripts and prompts"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/294
status: active
created: 2026-10-10
updated: 2026-10-11
---

# Plan: Declare-BashScript's names, and one Set-Environment

## Summary

Lane 93 of NobleFactor/devlore-cli#916, with lane 66 folded in: #294 and #291 in one pull request, merged before
personal's Start-Claude pull request (lanes 48, 49, 51, 53 and 59), whose CI otherwise fails. The helper's names follow
the house's rules: `require_command`'s indexed array becomes `missing_list`, so shellcheck reads no script's scalar
`missing` as it, and the helper's other names are renamed or removed as ruled. Set-Environment becomes one function,
`Home/common/.local/share/shell/functions/Set-Environment` in this base layer, which Declare-BashScript sources and a
prompt loads. It keeps its variables local, works without `--whitelist` and without arguments, and expands its values
with `eval`, as the prompt's copy always has, escaped so that a value runs nothing but its `$(...)`.

## Issue 294

shellcheck reads a script and the helper it sources as one program, and does not keep a function's `local` apart from
other variables of the same name: across a source line, and within one file between two functions. When one is an
indexed array and the other a scalar, it warns (SC2178, SC2128), and the gate, at warning severity, fails on correct
code. Measured 2026-10-10, feeding shellcheck from stdin: a consumer's `local missing=0` at the top of its function
draws both warnings against `require_command`'s `local missing=()`, and same-kind names draw nothing. Today personal's
Install-JetBrainsToolbox, unchanged and the same as main, fails personal's shell gate against the helper on
`develop`, and main's Start-Claude does too.

## Issue 291

Measured 2026-10-09 (its body): without `--whitelist`, Set-Environment stops at `whitelist: unbound variable` under the
helper's own `nounset`; with no arguments, at `$1: unbound variable`; and it writes `line`, `trimmed_line`, `name` and
`value` into its caller's variables. Its one caller, personal's New-LocationConfig, passes `--whitelist`, so meets only
the third.

## Rulings

- #291, 2026-10-09, the owner: "log and address the Set-Environment tweak in the next pr."
- #294, 2026-10-10. Offered renaming the helper's array (a) or each consumer's variable (b): "a, and use
  require_command in Start-Claude. we have require_command." Shown that shellcheck keeps no scope apart, and offered
  `<function>_<name>` for the helper's locals: "(i) rename all eight in #294. shellcheck keeps the gate (a)."
- The fold, 2026-10-10, offered taking #291 into this pull request: "yes, fold #291 into #294".
- Names by kind, 2026-10-10, the house's rule since (NobleFactor/noblefactor-ops#267): "I would use these suffixes:
  scalar => no suffix, indexed array => <singular-noun>_list, associative array => <singular-noun>_dict."; then "yes,
  adopt it and apply the three renames, dropping the <function-name>_ prefix. we will live with the false negatives on
  SC2034 (appears unused)." The eight `<function>_<name>` renames are withdrawn: a name that carries its kind cannot
  clash in kind, so only the helper's one indexed array changes.
- The helper's other names, 2026-10-10: "We should complete the full set of renames in Declare-BashScript. there is
  no reason to postpone that." Then: "envFile => env_file. we'll have to discuss names the for others."; "The oddly
  capitalized variables should probably be SNAKE_CASE."; and, told that no script uses them, "nuke b, n, u, and u_".
  Offered `HEAVY_BALLOT` and `HEAVY_CHECK_MARK`, `status` for `error`'s `rc`, and `synopsis_text` for `usage`'s
  `_synopsis`, which cannot be `synopsis` because bash refuses a local named for the caller's readonly `synopsis`
  (1), or other names (2): "1".
- Set-Environment, 2026-10-10: "We should go ahead and fix Set-Environment"; then "What I will say about
  Set-Environment is that it has been around for a long, long time and has treated me well. We need to discuss the
  fix with me. I want to know exactly what you propose to do."; then "we should only have one Set-Environment
  function."; then, of the copy a script uses and the copy a prompt uses, "The implementations should be identical,
  BTW." Asked whether values are expanded: "i say we do the eval so that we can get the expansion behavior. I used
  that capability to do things like expand environment variables that include expressions like this: $(hostname) or
  whatever." Shown the implementation that expands a value with `eval` as a double-quoted word, then `envsubst` as
  the alternative, which runs no command and so leaves `$(hostname)` as written, and offered `eval` (1) or
  `envsubst` (2): "go with 1." Told that a value with a backslash before a quote broke out of the quotes and ran what
  followed, and offered escaping a value's backslashes and then its double quotes before `eval` (1), or leaving it
  as first proposed (2): "go with 1". Asked what it prints for each variable, offered the name only (1), the name and
  the value as both versions print today (2), or nothing (3): "2, with the expectation that one may redirect the
  output to hide the output. echo that back to me." Told it would print on standard error, so that hiding it hides
  its warnings too, and offered printing nothing when `SILENT` is set, as the helper's notes do: "yes, honor SILENT".
- Where Set-Environment lives, 2026-10-10: "we might want to change the location to an XDG location. what do you
  think? Where would that be?" Offered `~/.local/share/functions/` (1), `~/.local/share/noblefactor/functions/` (2), or
  keeping `~/.functions` (3): "go with 1".
- The plan, 2026-10-10, offered approving it, committed with phase 1 ticked (1), or changes first (2): "go with 1. next
  question". It was offered as "chartered", a status the frontmatter gate refuses; a reviewed plan's status is
  `approved` (development-process.md § Plans).
- zsh in CI, 2026-10-11. Requirement 3 runs its cases in bash and in zsh, and CI's runner, `ubuntu-26.04`, lists no
  zsh among its packages (actions/runner-images, `images/ubuntu/Ubuntu2604-Readme.md`, read 2026-10-11). Offered CI's
  Tools step installing zsh beside shellcheck, with `.github/workflows/ci.yaml` in the files table (1), or the test
  running its zsh cases only where zsh is on PATH, so CI tests bash alone (2): "go with 1. next question".
- Where the helper finds Set-Environment, 2026-10-11. Asked whether the helper's exit 72, in its code since phase 3
  and in neither requirement 2 nor the man page, should be stated with exactly where the helper looks in requirement
  2 and the man page (1), in requirement 2 alone (2), or dropped with its check (3): "go with 1. next question." Then:
  "I change my mind on the answer to Q 2 of 4. we use ${XDG_DATA_HOME:-~/.local/share}/functions to locate
  Set-Environment." The code writes it `${XDG_DATA_HOME:-$HOME/.local/share}`: inside double quotes, bash and zsh
  leave a `~` as written (measured 2026-10-11).
- The refusal, 2026-10-11. Asked whether, with the new lookup, the helper still stops with 72 when Set-Environment is
  not there, requirement 2 and the man page saying so with the new path (1), or drops its check, a missing file
  ending the script with `source`'s own error and status 1 (2): "go with 1. next question."
- Cases for the lookup, 2026-10-11. Offered three bash cases, none needing a temporary directory, for Set-Environment
  found through `XDG_DATA_HOME`, found through `HOME` with `XDG_DATA_HOME` unset, and not found (1), or none (2): "go
  with 1. next question."
- Requirement 3's list, 2026-10-11. Shown that it leaves out three behaviors requirement 2 states, `--whitelist`
  exporting only the names it lists, the `export NAME="value"` line on standard error, and nothing printed under
  `SILENT`, and offered adding the three, in bash and in zsh (1), or keeping the list as written (2): "Yes".
- Set-Environment's split, 2026-10-11. Shown that zsh feeds its here-string through a temporary file and that bash's
  `read` drops a value's trailing `=`, and offered splitting each line with parameter expansion (1) or keeping the
  here-string (2); asked what the here-string's loss would be and how the two differ, and answered: "make the change
  to parameter expansion".
- The functions directory, 2026-10-11: "I want to move the functions directory from ~/.local/share/functions to
  ~/.local/share/shell/functions. This means updating bash/zsh rc files, and Declare-BashScript. Can we do that on the
  next PR?" Offered this pull request, before anything is deployed at the old path, with personal#269 taking the new
  path for the rc files (1), or the pull request after it (2): "go with 1. next question."

## Goals

1. No script that sources the helper is warned about one of the helper's variables.
2. Every name in the helper follows the house's rules.
3. One Set-Environment, the same file for a script and for a prompt, doing what requirement 2 says.

## Current State

Read 2026-10-10 on `develop` at c942f54, `Home/common/.local/bin/Declare-BashScript`:

| Where | Name | Kind | Becomes |
| --- | --- | --- | --- |
| `require_command` | `missing` | indexed array | `missing_list` |
| Set-Environment | `envFile` | scalar | `env_file` |
| Set-Environment | `line`, `trimmed_line`, `name`, `value` | scalars, not declared: written into the caller | `local` |
| `error` | `rc` | scalar | `status` |
| `usage` | `_synopsis` | scalar | `synopsis_text` |
| the helper | `Heavy_ballot`, `Heavy_check_mark` | readonly scalars | `HEAVY_BALLOT`, `HEAVY_CHECK_MARK` |
| the helper | `b`, `n`, `u`, `u_` | readonly scalars that nothing uses | removed |

The helper's other names keep theirs: `status` and `event` in `on_error_or_interrupt`, `name` in `require_command`,
`whitelist` in Set-Environment, the `EX_*` codes, and the `script_*` variables, which consumers read.

Set-Environment has two implementations, measured 2026-10-10:

- The helper's, which scripts use. It keeps values as written, takes `--whitelist` and the `export` prefix, strips
  one pair of quotes, and notes each export. Under the helper's options it stops on a value with an apostrophe
  (`xargs`: unmatched single quote), turns `c:\temp` into `c:temp`, drops a last line that has no newline, and prints
  each value.
- David-Noble-at-work/personal's `Home/common.Unix/.functions/Set-Environment`, which a prompt uses. It puts each line
  through `eval echo`, so `$HOME` and `$(...)` in a value expand, and anything after a `;` runs too: `A=x; echo RAN`
  ran `echo RAN`. zsh refuses its `export A=1`, and it has no `--whitelist`. A bash prompt sources it from
  `~/.functions` at startup; zsh autoloads it from `~/.functions.zwc`, which personal's Install-UnixUserConfiguration
  compiled on 2026-02-10.

## Requirements

### Requirement 1: the helper's names (#294)

`require_command`'s indexed array is `missing_list`, and Set-Environment's `envFile` is `env_file`. `b`, `n`, `u` and
`u_`, which nothing uses, are gone. `Heavy_ballot` and `Heavy_check_mark` are `HEAVY_BALLOT` and `HEAVY_CHECK_MARK`;
`error`'s `rc` is `status`; and `usage`'s `_synopsis` is `synopsis_text`. devlore-cli's copies of the helper's
functions (`install.sh`, `scripts/Test-InstallScript.sh`, `packaging/macports/generate-portfile.sh`, and two in
writ's test data) keep the names of c942f54, which they say they copy.

### Requirement 2: Set-Environment (#291)

One file in this base layer, `Home/common/.local/share/shell/functions/Set-Environment`, which writ deploys to
`~/.local/share/shell/functions/`, under XDG's data directory. Declare-BashScript sources it from
`${XDG_DATA_HOME:-$HOME/.local/share}/shell/functions`, where a prompt loads it too, so a script and a prompt run the
one deployed file. A test of a checkout sets `XDG_DATA_HOME` to the checkout's `Home/common/.local/share`, so that it
runs the file under review with nothing deployed. When the file is not there, the helper stops with 72, `EX_OSFILE`,
naming the path it looked for.

One implementation, the same for a script and for a prompt, in bash and in zsh. Every variable it assigns is `local`.
With no argument it returns 0 and changes nothing. Without `--whitelist` it exports every assignment its files make,
and with it only the names listed. It reads `$1` and its whitelist so that `nounset` never stops it. It reads a last
line that has no newline, and takes `NAME=value` or `export NAME=value`, split at its first `=` with parameter
expansion, in memory and alike in bash and zsh, so a value keeps every `=` after that one. A line whose name the shell
cannot take is skipped, and said so. A value in single quotes is kept as written; any other value, its double quotes
removed, is expanded with `eval` as a double-quoted word, so `$NAME` and `$(command)` are replaced. Before `eval`, the
value's backslashes and then its double quotes are escaped, so a quote or a backslash in it cannot end the word and
run what follows, as the first proposal let it (anthropics/claude-code#101183). So a literal `$` needs single quotes
around the value, and a command in a value quotes its arguments with single quotes: `$(date '+%Y')`. For each
variable it exports, it prints `export NAME="value"`, the value as expanded, on standard error, at a prompt and in a
script; redirecting standard error hides it, and its warnings with it. Like the helper's notes, it prints nothing
when `SILENT` is set. Its documentation, in the form ruled on #267, and its entry in Declare-BashScript's man page say
all of this.

### Requirement 3: the tests

`tests/Test-DeclareBashScript` gains a case for each of #291's three: no argument, no `--whitelist`, and a caller's
variables untouched after a call. And one for each behavior of requirement 2, in bash and in zsh: a last line with no
newline; the `export` prefix; a name the shell cannot take; a value in single quotes; `$HOME` and `$(hostname)`
expanded; `$(date '+%Y')`; the values that must run nothing, `x; echo RAN`, `\"; echo RAN; \"`, and one ending in a
backslash; values with `=` in them, `A=b=c` and `K=dGVzdDE=`, kept whole; `--whitelist` exporting only the names it
lists; each export printed on standard error as `export NAME="value"`; and nothing printed when `SILENT` is set. And
three in bash for the helper's lookup, none needing a temporary directory: Set-Environment found through
`XDG_DATA_HOME`, set to the checkout's `Home/common/.local/share`; found through `HOME`, set to the checkout's
`Home/common`, with `XDG_DATA_HOME` unset; and not found, with `XDG_DATA_HOME` set to a directory that has no
`shell/functions`, where the helper stops with 72 and names the path. Every case that passes today still passes. CI's
Tools step installs zsh beside shellcheck, so the zsh cases run in CI as they do on a Mac.

### Requirement 4: the consumers

Shellcheck, at the gate's settings and pointed at this branch's helper, passes personal's whole shell gate,
Install-JetBrainsToolbox included, and base's own, following the helper's `source` of Set-Environment; `make check`
passes here. The helper, Set-Environment and the helper's test pass shfmt, `bash -n` and shellcheck, in that order:
the owner, 2026-10-10, "I suggest that we run the check in this order: shfmt, bash -n, shellcheck."

### Requirement 5: plan 289's two boxes

Plan 289 left its phase 6 CI box and its phase 7 box to "the next noblefactor-ops pull request, lane 66's (#291)",
which is this one. They are ticked here, from NobleFactor/noblefactor-ops#293's record.

## Implementation Phases

### Phase 1: The plan

- [x] This plan, committed on `fix/294-helper-locals-function-names` and reviewed with the owner.

### Phase 2: The names (Requirement 1)

- [x] `missing_list`, `env_file`, `HEAVY_BALLOT`, `HEAVY_CHECK_MARK`, `status` and `synopsis_text`; `b`, `n`, `u` and
  `u_` removed. 2026-10-10: `make check` clean, and personal's whole shell gate passes against this branch's helper,
  Install-JetBrainsToolbox included: 123 files in its main clone, 129 in Start-Claude's worktree.
- [x] The man page's entry for `b`, `n`, `u` and `u_`, which phase 2's commit left in place, removed
  (anthropics/claude-code#101310). 2026-10-11: mandoc clean at warning level.

### Phase 3: Set-Environment (Requirement 2)

- [x] `Home/common/.local/share/functions/Set-Environment`, the one implementation, sourced by the helper, and its
  entry in the helper's man page. 2026-10-10: shfmt, `bash -n` and shellcheck clean on both files, `zsh -n` on the
  function file, and mandoc clean at warning level, the page's unparsable date and the entry's lost quotes fixed with
  it. A script sourcing the helper expanded `$HOME` and `$(hostname)`, kept `\"; echo RAN; \"` as written and ran
  nothing, left out a name `--whitelist` did not list, and printed nothing under `SILENT`.
- [x] Set-Environment splits each line with parameter expansion, ruled 2026-10-11. 2026-10-11: phase 4's cases pass in
  bash and in zsh, values ending in `=` among them.
- [x] The helper sources Set-Environment from `${XDG_DATA_HOME:-$HOME/.local/share}/functions` and stops with 72 when
  it is not there, both ruled 2026-10-11; its comment, Set-Environment's header and the man page's entry say so.
  2026-10-11: shfmt, `bash -n` and shellcheck clean on the helper and Set-Environment, `zsh -n` on Set-Environment,
  mandoc clean at warning level, and phase 4's three cases for the lookup pass.
- [x] Set-Environment moved with `git mv` to `Home/common/.local/share/shell/functions`, and the helper sourcing it
  from `${XDG_DATA_HOME:-$HOME/.local/share}/shell/functions`, ruled 2026-10-11; the helper's test, its comment,
  Set-Environment's header and the man page's entry follow. 2026-10-11: moved by the owner's run of `git mv`; shfmt,
  `bash -n`, `zsh -n` and shellcheck clean, mandoc clean, all 49 of the test's cases passing, and again with `TMPDIR`
  and `TMPPREFIX` pointed at a missing directory; `make check` clean.

### Phase 4: The tests (Requirement 3)

- [x] Requirement 3's cases in the helper's test, in bash and in zsh, and every case passing. 2026-10-11, on this Mac
  with bash 5.3.20 and zsh 5.9: all 49 cases pass, and pass again with `TMPDIR` and `TMPPREFIX` pointed at a missing
  directory, so neither shell needed a temporary file; shfmt, `bash -n` and shellcheck clean on the test, and
  `make check` clean. CI's run, with zsh installed, is phase 5's.

### Phase 5: Verification (Requirement 4)

- [ ] `make check` clean on this Mac, and CI green on the pull request.
- [x] Personal's whole shell gate against this branch's helper: Install-JetBrainsToolbox clean, and every file as
  before. 2026-10-11, after the move: 123 files in personal's main clone and 129 in Start-Claude's worktree, none
  failing, Install-JetBrainsToolbox among them; shellcheck follows the helper into Set-Environment, reporting no
  SC1091.

### Phase 6: Plan 289 (Requirement 5)

- [x] Its phase 6 CI box and phase 7 box ticked from #293's record. 2026-10-11: both ticked, from the record read the
  same day, and its status set to `complete`.

### Phase 7: Acceptance and closure

- [ ] The pull request, the merge and `git close-branch`; lanes 66 and 93 marked on NobleFactor/devlore-cli#916, #291
  and #294 closed, and their plan rows pointed at `develop`.
- [ ] writ's deploy, run on this Mac once the merged helper is in the main clone and before any script sources it,
  so that `~/.local/share/shell/functions/Set-Environment` resolves: until then every script that sources the helper,
  `git open-branch` and `git close-branch` among them, stops (agent-rules rule 5).

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/bin/Declare-BashScript` | Modify | Requirements 1 and 2: the names, and sourcing Set-Environment |
| `Home/common/.local/share/shell/functions/Set-Environment` | Create | Requirement 2 |
| `Home/common/.local/share/man/man1/Declare-BashScript.1` | Modify | Requirements 1 and 2: two entries |
| `tests/Test-DeclareBashScript` | Modify | Requirement 3 |
| `.github/workflows/ci.yaml` | Modify | Requirement 3: zsh, for the zsh cases |
| `docs/plans/chore/289-set-traps-optional-cleanup.md` | Modify | Requirement 5 |
| `docs/plans/fix/294-helper-locals-function-names.md` | Create | This plan |

## Out of Scope

- A prompt's Set-Environment: personal's loaders (`.bashrc`, `.zshrc`, `.zprofile`, and Install-UnixUserConfiguration's
  `zcompile`) look in `${XDG_DATA_HOME:-$HOME/.local/share}/shell/functions`, and personal's own copy is deleted. That
  is David-Noble-at-work/personal#269, lane 95 of NobleFactor/devlore-cli#916, after this merges; until it lands, a
  prompt keeps personal's copy.
- The PowerShell Set-Environment in personal's `Home/common/.config/powershell/profile.ps1`: another language, and
  whether it should behave as this one does is to be raised on its own.
- devlore-cli's copies of the helper's functions, which keep c942f54's names (requirement 1).
- The other scripts' variables, renamed by kind: the standards lanes under #266, the bash style guide (#267) first.
- The gate itself: shellcheck stays, ruled (a).

## Related Documents

- NobleFactor/devlore-cli#916, lanes 66 and 93
- NobleFactor/noblefactor-ops#267, the bash style guide, which records the rule
- `docs/plans/chore/289-set-traps-optional-cleanup.md`, whose `require_command` this changes
- David-Noble-at-work/personal's Start-Claude plan, `docs/plans/chore/259-start-claude-documents-claude.md`, rulings
  40 and 42

## Open Questions

1. **pushup and up.** The owner, 2026-10-11: "we have two functions that are still installed to ~/.functions. they
   should be moved such that they install to ~/.local/share/shell/functions"; "we should do that on the same PR"; and
   "the up and pushup functions are for interactive sessions only." They are personal's, `Home/common.Unix/.functions/`,
   and this pull request changes only noblefactor-ops. (1) They join Set-Environment in this layer's
   `Home/common/.local/share/shell/functions`, written to the house's rules and passing its gate, and personal#269
   deletes personal's copies; or (2) they move within personal, to `Home/common.Unix/.local/share/shell/functions`, in
   personal#269's pull request with the rc files that load them. Proposed: (1).
