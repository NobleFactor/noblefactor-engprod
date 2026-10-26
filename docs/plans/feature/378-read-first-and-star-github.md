---
title: "Every star github schedule operation reads the organization's record first, and star gh becomes star github, issues becoming schedule"
issue: https://github.com/NobleFactor/noblefactor-engprod/issues/378
status: approved
created: 2026-10-27
updated: 2026-10-27
---

# Plan: read first, and `star github`

## Summary

Task 3 of iteration 1 of the issue data model's sweep ([303-issue-data-model.md](../chore/303-issue-data-model.md)),
lane 16 of #346: every operation that reads issues begins with the conditional read `pull` makes and says when the
asset is behind. #377 built the read, the cache, and the access check half of this task. Joined to it on 2026-10-27,
"while we are here": the command group is renamed. The owner: "The command is now called `star gh schedule`", then "I
would like to spell out github", and "We need to update the skills. They need new names and updated content, help,
completions."

## Goals

1. **`star github schedule report` and `star github schedule audit`** read GitHub's record first, by ETag, and say in
   one header line when the asset is behind.
2. **The extension's commands are `star github ...`:** `star gh issues` becomes `star github schedule`, and `star gh
   model` and `star gh labels` become `star github model` and `star github labels`.
3. **Nothing a session runs today breaks:** the old names keep working, each saying its new one, until the skills and
   documents have moved.

## Current State

- `star gh issues report` and `star gh issues audit`, `star gh labels audit` and `sync`, `star gh model pull` and
  `digest`: the manifest names each `gh.<group>.<verb>`. Star has no command aliases: an old name stays working only
  as a second manifest entry with the same implementation.
- The configuration's key is `gh` (`path: gh`); no repository's `star/config.yaml` uses it.
- The skills `star-gh-progress` and `star-gh-assignment` are in `Home/common/.claude/skills`; the first calls `star gh
  issues report`. Both names appear in `docs/issue-standards.md`, sections 3 and 5 of the data model, and the agent
  schedule's session model.
- `star gh issues` appears in the process documents, the README, sections 5 to 7 of the data model, and devlore-cli's
  star reference, `docs/cli/star/gh/issues*.md`; twelve plans here and six there name it, and stay as written.
- writ leaves the link of a removed source in place (devlore-cli#960), so a renamed skill's old directory stays on each
  machine until it is removed by hand.

## Requirements

### Requirement 1: the read first

Before it reads issues, `star github schedule report` and `audit` make `pull`'s conditional read of the organization's
issue types, the hub's labels and its projects, through `model.star`, with the cache's ETags. They write nothing but
the cache, and the cache only where what was read matches the asset, so a 304 never vouches for content the asset lacks.
When what was read differs from the asset, the output's first line says so: `The asset is behind GitHub: types, labels
or projects changed since <pulled.at>. Run star github model pull in a worktree.` The operation goes on against the
asset. With `--verbose`, each read's 304 or 200 is shown.

### Requirement 2: `star github`, `schedule`

| # | Old | New |
| --- | --- | --- |
| 1 | `star gh issues report` | `star github schedule report` |
| 2 | `star gh issues audit` | `star github schedule audit` |
| 3 | `star gh labels audit`, `sync` | `star github labels audit`, `sync` |
| 4 | `star gh model pull`, `digest` | `star github model pull`, `digest` |
| 5 | configuration key `gh` | `github` |

The command files are renamed to match, `gh-schedule-report.star` and the rest by the new group, by `git mv`. Each old
name stays as a manifest entry with the same implementation, its help beginning `Renamed: star github ...`; they are
removed by a later task once no skill, document or session names them. The access check's messages and every help text
name the new commands. Completions are star's own, built from the manifest: checked, not written.

### Requirement 3: the skills

`star-gh-progress` becomes `star-github-schedule-progress`, and `star-gh-assignment` becomes
`star-github-schedule-assignment`, by `git mv`, each with its `name:` and its content following: every command it
names is the new one. The documents that name them follow.

### Requirement 4: the documents

The process documents (`docs/guides/agent-rules.md`, `development-process.md`, `pr-script-template.md`),
`docs/issue-standards.md`, the README, sections 3 and 5 to 7 of the data model and their status pages, and the agent
schedule's session model name the new commands and skills. A quotation of the owner keeps its words; where it names an
old command, a note says what it is now. Plans stay as written.

### Requirement 5: after the merge

On each machine, after the pull: `writ deploy`, since the command files and skills are new paths, and the two old skill
directories under `~/.claude/skills` removed (devlore-cli#960). devlore-cli's star reference is regenerated in its own
pull request, under its own issue, filed here.

## Implementation Phases

### Phase 1: the plan

- [x] This plan committed on `feature/378-every-star-gh-issues-operation`, reviewed with the owner, status `approved`

### Phase 2: the rename

- [ ] Requirement 2: the manifest, the files, the configuration key, the old names kept; `make check` passes
- [ ] Requirement 3: the skills renamed and rewritten
- [ ] Requirement 4: the documents
- [ ] `star github schedule report --by schedule` renders byte-identical to `star gh issues report` before the rename,
  and the old name still runs; star's completion offers `github`

### Phase 3: the read first

- [ ] Requirement 1 built; a report run twice shows the second's reads as 304 with `--verbose`
- [ ] A label added in GitHub between two runs makes the second's first line say the asset is behind, and the report
  still renders; the label removed after

### Phase 4: the pull request

- [ ] devlore-cli's issue for its star reference filed
- [ ] The pull request; status `complete` in its last commit

## Files to Create/Modify

| File | Action | Purpose |
| --- | --- | --- |
| `Home/common/.local/share/devlore/star/extensions/com.noblefactor.ops.GitHub/extension.yaml` | Modify | the new names, the old kept, the configuration key |
| `.../commands/gh-*.star` | Move | to the new group's names |
| `.../commands/scheme.star`, `model.star`, `access.star` | Modify | the read first; the new names in messages |
| `Home/common/.claude/skills/star-gh-progress`, `star-gh-assignment` | Move | to the new names, rewritten |
| the documents of Requirement 4 | Modify | the new names |
| `docs/plans/feature/378-read-first-and-star-github.md` | Create | this plan |

## Related Documents

- [Section 6, the asset and its sync](../../architecture/issue-data-model/6-the-asset-and-its-sync.md), § Every
  operation reads first, § Access
- #377, which built the read, the cache and the access check; #408 and #409, the schedule, thread and triage commands
  this group will hold

## Open Questions

None.
