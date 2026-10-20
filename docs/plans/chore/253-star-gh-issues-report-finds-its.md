---
title: "star gh's commands find their repositories through writ's layers, a schedule report adds the repositories its lanes name, and gh.repositories goes"
issue: https://github.com/NobleFactor/noblefactor-ops/issues/253
status: active
created: 2026-10-19
updated: 2026-10-19
---

# Plan: star gh reads writ's layers, and a schedule reads its own lanes

Lane 29 of NobleFactor/devlore-cli#949. One pull request (ruled 2026-10-19: "We will deliver one pull request per
lane, unless we discover a blocking issue along the way.").

## Summary

The four commands of the base layer's `gh` extension for star (`com.noblefactor.ops.GitHub`: `star gh issues report`,
`star gh issues audit`, `star gh labels audit`, `star gh labels sync`) decide which repositories to read from
`gh.repositories` in `star/config.yaml` at the root of whichever repository they run in. So the same command gives
different answers in different directories, and a schedule's lanes in a repository the list omits read "is not in the
configured repositories". This plan makes writ's layers the default, lets a schedule report read every repository its
lanes name, and removes `gh.repositories`.

## Rulings

- 2026-10-01, on #253: the default report covers base, team and personal, and is found through the layers ("We should
  look this up through the layers.").
- 2026-10-19: `gh.repositories` is the `gh` extension's setting, planned in #140 and never in a design. Star's design
  gives a flag one chain (`docs/architecture/9-star-extensions.md` in devlore-cli, § Flag Resolution: the command
  line, `STAR_<COMMAND>_<FLAG>`, config, the default), so the setting is a second, undesigned path to `--repo`'s value.
- 2026-10-19, asked whether reports should reach beyond the three layers: the layers by default; a schedule report adds
  every repository its lanes name; `--repo` names exactly what it names. "Plan it that way."

## Current State

At `7cd982f`, `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub`:

| What | Where | Today |
| --- | --- | --- |
| The choice | `commands/scheme.star:232-239`, `resolve_repos` | `--repo`, else `--directory`'s origin, else `gh.repositories`, else the current repository |
| The setting | `extension.yaml:113-120`; `star/config.yaml:6-13` here; devlore-cli's `star/config.yaml:31-35` | three repositories here, two in devlore-cli, none anywhere else |
| A lane in another repository | `commands/scheme.star:657` | "`<ref>` is not in the configured repositories" |
| The help | `extension.yaml:43`, `:72`, `:89`, `:106` | "overrides gh.repositories in star/config.yaml" |
| The guide | `docs/guides/agent-rules.md:72` | runs the report "from `~/Workspace/NobleFactor/noblefactor-ops`, whose configuration names both repositories" |

writ's layers are links in the filesystem: `${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers/<layer>`, one for
each of `base`, `team` and `personal` that is registered, each naming a repository's working tree. The extension
already reads a working tree's repository from its `origin` remote (`_origin_repo`, `commands/scheme.star:212`).

## Goals

1. Run anywhere, the four commands read the same repositories: those of writ's registered layers.
2. A schedule report renders every lane, whichever repository holds it.
3. One way to name the repositories: `--repo`. No configuration file lists them.

## Requirements

### Requirement 1: The layers are the default

- For each of `base`, `team` and `personal`, in that order, the extension reads the layer's link under
  `${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers/`, and from the working tree it names, the `origin` remote,
  as `owner/name` (`_origin_repo`). A layer not registered is skipped. A repository two layers name is read once.
- The order of choice becomes: `--repo`; else `--directory`'s origin; else the layers' repositories; else, when no
  layer is registered, the repository the command runs in, as today.
- writ is not called: the layers are files, and reading them needs nothing from writ (ruled 2026-10-19).

### Requirement 2: A schedule report reads its lanes' repositories

- With `--by schedule` and no `--repo`, once the schedules are found in the default repositories, every repository a
  lane's item names (`owner/name#N`, as `lane_table` already parses it) that is not already read is read too, with the
  same `--state` and `--limit`, and its issues join the set before the lanes resolve.
- The report's banner names every repository read, the added ones included.
- With `--repo`, exactly the repositories named are read, as today.

### Requirement 3: A lane that resolves to nothing says why

The lane's message no longer names configuration. An item whose repository was read but whose issue is not among the
issues fetched says so, naming `--state` (`--state open` drops a closed lane's issue); one whose repository could not
be read says that.

### Requirement 4: gh.repositories goes

- `extension.yaml`'s `config` drops `repositories`, keeping `exempt`; `configured_repos` goes.
- The four `--repo` helps say the default: "Repositories to report on, owner/name, comma-separated; default: the
  repositories of writ's layers" (and the audit's and sync's alike); the report's says a schedule adds its lanes'.
  `--repo` stays one comma-separated value: ruled 2026-10-19, "For now, it is not repeatable."
- `star/config.yaml` here held `gh.repositories` and nothing else, so it goes: a file that configures nothing is
  removed (`git rm`).
- `docs/guides/agent-rules.md:72`: the report runs from anywhere.
- `docs/plans/feature/140-star-report-epics.md` and `docs/plans/chore/202-repositories-gain-personal.md` each get a
  dated note: their `gh.repositories` is retired by this plan.
- devlore-cli's `star/config.yaml` drops `gh.repositories` in that repository's next pull request: one pull request
  at a time, and this lane is this repository's. Until then the extension ignores it.

### Requirement 5: Proven by running it

The extension has no test harness here; the commands are proven by running them. The deployed copy is not touched:
each run is made from a scratch git repository with no remote, whose `star/extensions/com.noblefactor.ops.GitHub` is a
copy of this branch's. star reads project scope, `<git root>/star/extensions`, ahead of the user scope writ deploys to
(`cmd/star/extension/loader.go:318` in devlore-cli), so the branch's copy answers, and the scratch repository names no
repository of its own. A copy, not a link: with a symbolic link to the directory there, the deployed copy answered
instead (found 2026-10-19), so star does not take a linked extension directory at project scope.

- From the scratch repository: `star gh issues report --by schedule --schedule NobleFactor/devlore-cli#949`
  reads devlore-cli, noblefactor-ops and personal, then devlore.noblefactor.com and devlore-registry; lanes 4 to 6 and
  54 resolve; no lane reads "not in the configured repositories".
- The same with `--state open`: a closed lane says it is not among the open issues.
- `star gh issues report --epic Ops:Process --view table --state all` from the scratch repository reads the three
  layers' repositories, where this repository's configuration read three and devlore-cli's two.
- `star gh issues audit` and `star gh labels audit`, from the scratch repository, read the three layers.
- `--repo NobleFactor/devlore-cli` reads exactly that, and `--repo NobleFactor/devlore-cli,NobleFactor/noblefactor-ops`
  exactly those two, for each command.

The gate this repository's CI runs: `./.github/scripts/Test-Frontmatter.sh`, `codespell`, `./.github/scripts/shell-lint.sh`,
`./.github/scripts/Test-PowerShell.ps1`, and `buildifier` over every `.star` file.

## Implementation Phases

### Phase 1: Commit the plan

- [x] This plan committed on `chore/253-star-gh-issues-report-finds-its`, and reviewed with the owner: approved
      2026-10-19

### Phase 2: The layers, and the schedule's lanes (Requirements 1 to 3)

- [x] `resolve_repos` reads the layers; the schedule report adds its lanes' repositories; a lane says why it
      resolved to nothing. Requirement 5's runs pass; `buildifier` clean. Run 2026-10-19 with star
      `v0.1.0-dev.20261010200947`: the schedule report for #949 read noblefactor-ops, devlore-cli and personal from the
      layers, then devlore.noblefactor.com and devlore-registry from the lanes, and lanes 4 to 6 and 54 resolved; under
      `--state open` a closed lane read "is not among the open issues"; the epic report, the issues audit and the labels
      audit read the three layers; `--repo NobleFactor/devlore-cli,NobleFactor/noblefactor-ops` read those two, and
      lane 4 read "is in NobleFactor/devlore.noblefactor.com, which this report did not read". buildifier 8.5.1, CI's
      pin, clean on every `.star` file

### Phase 3: gh.repositories goes (Requirement 4)

- [x] The setting, the helps, this repository's `star/config.yaml` (removed), the guide, the two plans' notes. The
      gate: `Test-Frontmatter.sh` and buildifier 8.5.1 pass; codespell is not installed here and runs in the PR
      script's pre-flight and CI. Re-run 2026-10-19 after the helps were quoted (their "default:" broke the YAML,
      which star reported by skipping the extension): every run above holds. From a directory without devlore-cli's
      `star/config.yaml`, the issues audit lists devlore-cli#65, since `gh.exempt` is read from the working
      directory's configuration too (Out of Scope)

### Phase 4: Merge

- [ ] PR script written, shown, and handed over. The PR resolves #253
- [ ] After the merge and `writ deploy`, on this machine: Requirement 5's first run, from a directory outside every
      repository, against the deployed extension
- [ ] In devlore-cli's next pull request: its `star/config.yaml` drops `gh.repositories`; `configuration.md`'s Open
      questions gain the extension-flag questions and the repeatable-flag requirement, and `9-star-extensions.md` § Flag
      Resolution notes it is not built (Out of Scope)

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/scheme.star` | Modify | Requirements 1 to 4 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/commands/gh-issues-report.star` | Modify | Requirement 2 |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/extension.yaml` | Modify | Requirement 4 |
| `star/config.yaml` | Modify | Requirement 4 |
| `docs/guides/agent-rules.md` | Modify | Requirement 4 |
| `docs/plans/feature/140-star-report-epics.md`, `docs/plans/chore/202-repositories-gain-personal.md` | Modify | Requirement 4 |

## Out of Scope

- **Star's flag resolution.** Star's design resolves an extension's flag from the command line, the environment,
  configuration and its default; star takes it from the command line alone (`cmd/star/extension/command.go:68` in
  devlore-cli). The unified configuration spec (devlore-cli `docs/architecture/configuration.md`) rolls an extension's
  section up through every source, but does not say how a command's flags map to a section's keys or environment
  variables, and `9-star-extensions.md` § Flag Resolution maps them differently. Ruled 2026-10-19: "Leave those as
  design questions, to be resolved before coding on the unified configuration starts." They go into
  `configuration.md`'s Open questions, and `9-star-extensions.md` § Flag Resolution notes it is not built, in
  devlore-cli's next pull request. When they are resolved and built, `--repo` gains its environment and configuration
  rungs, its default still the layers.
- **A repeatable `--repo`.** Star's extension flags have no list type (`bool`, `string`, `int`, `glob`:
  `cmd/star/extension/extension.go:162` in devlore-cli). Ruled 2026-10-19: "Add the repeatable flag requirement to the
  unified configuration design requirements. We will design that later. For now, it is not repeatable." The
  requirement goes into `configuration.md` with the questions above; NobleFactor/devlore-cli#1062, filed for it the same
  day, is closed as not planned.
- **`gh.exempt`**, the same kind of setting, read by the audit alone.
- **Reading a layer that is not a git working tree.** writ refuses to register one.

## Decisions

- **D1. No layer registered, the current repository,** as today: a machine without writ still gets a report.
- **D2. A lane's repository is read whole,** with the report's `--state` and `--limit`, rather than its one issue:
  a lane that names an epic or a feature rolls up its children, which live in the same repository.

## Open Questions

None.
