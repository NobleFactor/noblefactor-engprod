---
title: "6. The asset and its sync"
---

# 6. The asset and its sync

The model lives in two places: in GitHub, where the owner authors it, and in one file beside the star extension, which
the extension reads and the repositories are brought to. Two commands move it between them, and every operation reads
GitHub's record before it runs. The owner, 2026-10-21: "The yaml should travel with the extension and drive its
behavior because that, I will argue, is the definitive configuration." And 2026-10-22: "Use the etag. Offer pull and
push as star gh commands."

## The asset

`model.yaml`, beside `extension.yaml` in `com.noblefactor.ops.GitHub`, so that writ deploys it with the extension and
the extension finds it by its own path. It holds four things:

```yaml
version: 1
pulled:
  at: 2026-10-22T07:40:12Z
  org: NobleFactor
  digest: sha256:9b1e…
types:
  - { name: Epic,    id: 914457658, level: 0 }
  - { name: Feature, id: 344350,    level: 1 }
  - { name: Chore,   id: 914457671, level: 1 }
  - { name: Bug,     id: 344348,    level: 2, unplanned: true }
  - { name: Task,    id: 344346,    level: 2 }
teams:
  - { name: engprod, slug: engprod, id: T_kwDO…, role: triage }
labels:
  organization:                # every participating repository
    - { name: bug, color: "d73a4a", description: "Something isn't working" }
  teams:
    engprod:                   # the repositories the team owns
      - { name: "Area:Process", color: "…", description: "…" }
  repositories:
    NobleFactor/devlore-cli:
      - { name: "Area:CLI", color: "…", description: "…" }
projects:
  - name: Schedule
    id: PVT_kwDO…
    template: true
    fields:
      - name: Lane
        id: PVTF_lADO…
        type: number
      - name: Status
        id: PVTSSF_lADO…
        type: single-select
        options:
          - { name: Triage, id: 8f2c… }
          - { name: Open, id: 1a9e… }
          - { name: Done, id: c04b… }
      - name: Next
        id: PVTF_lADO…
        type: text
```

- **`version`** is the file's own schema. The extension refuses a version it does not know.
- **`pulled`** records where the file last came from: the organization and the time. Not the ETags: those are a
  cache, below.
- **`pulled.digest`** is a SHA-256 over the file with that one line excluded, written by `pull`. The extension
  recomputes it on every load. A mismatch means the file was edited by hand since its pull: a read-only operation
  runs anyway and says so in one header line, never failing the extension's load, since star loads every command file
  with the extension and a failure there would take `pull` and `digest`, the commands that repair it, down too (built
  2026-10-24, #377), `push` refuses, and the repository's gate fails a pull request that
  carries a mismatched asset. The fix is a `pull`, which rewrites file and digest together, or a deliberate edit
  followed by `star gh model digest`, which re-signs it and leaves the edit in the diff for review. A digest, not a
  signature: the owner, 2026-10-22, "I'm not so concerned with security, just clumsy edits", and git already says
  who. What it does not catch, an edit followed by a re-digest, is the pull request's to catch.
- **`types`** is the hierarchy as data: each type's name and its level. The extension derives the rest: level 0 has
  no parent, the last level is the lanes, a parent is one level up, and the types of one level are mutually exclusive.
  The owner, 2026-10-21: "We've got a hierarchy and a level number might be sufficient. we assume mutual exclusion at
  each level in the hierarchy." Nothing in the extension names a type (noblefactor-engprod#376, 2026-10-22). Two
  things the levels do not say, so the asset does: the order of the types within a level is the order the report
  renders them in, features before chores; and `unplanned: true` marks the leaf type that is found rather than
  planned, which is what triage waits on and what Severity attaches to.
- **A type is keyed by its id, never its name,** so that the owner can rename one. The owner, 2026-10-22: "i should be
  able to rename issue types. Will I be able to do that?" GitHub's issue type has a name, a description, a color and
  an enabled flag, and nothing about hierarchy; an issue holds its type by id, so a rename made in GitHub reaches every
  issue at once. `pull` matches the same id under a new name, prints it as a rename, and rewrites the asset; the level
  survives because it hangs on the id. The extension reads a type's name only to display it. A new type made in
  GitHub arrives from `pull` with no level, and the asset refuses to load until one is written in by hand and the
  digest renewed: a type with no level is a type the hierarchy cannot place. During the transition the parent markers
  are the one text consumer, their words being type names; they retire with the markers
  ([section 5](5-from-todays-scheme.md)). Level in the type's description, or depth measured from the sub-issue graph,
  were considered; depth was set aside, since it measures what is rather than stating what should be, and the audit
  needs the rule. **The description is the convention, ruled 2026-10-22:** every issue type's description in GitHub
  begins `Level N:`, so that GitHub's own settings page states the hierarchy and a person has one place to look. The
  owner: "We must rely on the convention. My experience: you might do it wrong, but you've got just one place to look
  to see that it's wrong. In this case, the simplest way is to pull the model and take a look." `pull` reads the level
  from the description, the asset records it, and the audit reports a type whose description names no level or a
  level the asset disagrees with. A new type therefore arrives with its level when its description was written to the
  convention, and without one otherwise.
- **`teams`** is the teams that own collections or triage, with their roles ([section 4](4-storage-and-reach.md)
  § Where each part is defined). Ruled 2026-10-22: the organization first, then teams, then repositories. Nothing in
  the asset says which repositories participate: a repository is in when a schedule, a thread, a filing or `--repo`
  names it, ruled the same day.
- **`labels`** is today's labels file from NobleFactor/noblefactor-ops#320, in the GitHub API's own fields, in three
  tiers: the organization's, pushed to every participating repository; each team's, pushed to the repositories it
  owns; each repository's own. A lower tier adds and never redefines a name from above. **`projects`** is the
  Schedule, Thread and Triage projects with their fields ([section 3](3-collections.md)).
- **Ids beside names,** for every project, field and single-select option. GitHub holds a row's single-select value
  as the option's id, not its text, as it holds a label and an issue type on an issue by id: rename the option and
  every row shows the new name; delete it and every row holding it goes blank. With the ids in the asset, `pull` can
  tell a rename from a removal and a creation, print it as "renamed Todo to Triage", and list the text consumers to
  fix; without them it can only print a deletion and an addition, which is the ambiguity that makes `push` refuse a
  rename. Whether `push` may one day carry a rename itself, id in hand, is left until the write test has run. Added
  2026-10-22 on the owner's "Write it in."

## The cache

The owner, 2026-10-22: "cache is a better word and suggests an XDG location for the data model." The ETag GitHub
returns for each record is kept per machine, outside the repository, at

```
${XDG_CACHE_HOME:-~/.cache}/devlore/star/gh/model/<organization>.yaml
```

one file per organization, holding for each record what GitHub gives to detect a change by, and the time it was
read:

```yaml
issue-types: { etag: 'W/"3f9c…"', read: 2026-10-22T09:02:51Z }
teams:       { etag: 'W/"b8d4…"', read: 2026-10-22T09:02:51Z }
labels:
  NobleFactor/noblefactor-ops: { etag: 'W/"66b6…"', read: 2026-10-22T09:02:51Z }
  NobleFactor/devlore-cli:     { etag: 'W/"0c5a…"', read: 2026-10-22T09:02:51Z }
projects:
  PVT_kwDO…: { updatedAt: 2026-10-22T08:40:16Z, read: 2026-10-22T09:02:51Z }
```

| Asset record | Read from | Change detected by |
| --- | --- | --- |
| `types` | `GET /orgs/{org}/issue-types` | one ETag for the list; `updated_at` per type |
| `teams` | `GET /orgs/{org}/teams` and each team's repositories | one ETag per list |
| `labels` | `GET /repos/{owner}/{repo}/labels`, per repository | one ETag per repository; no per-label time |
| `projects` | GraphQL `projectsV2` with fields and options | `updatedAt` per project; GraphQL takes no ETag, so this read is never 304 and costs one query |

A read that sends the ETag back is answered 304 Not Modified when nothing changed, at no cost against the rate
limit; the cache is what makes the read before every operation cheap. It is a cache in the XDG sense: deleting it
costs one full read and loses nothing, and no command depends on its being there. Read on 2026-10-22: the
organization's issue types carry `updated_at`, a repository's label list returns an ETag and no per-label time, and
a project carries `updatedAt`.

What the cache is not: the record of what the asset was pulled from. That record has to travel with the asset, since
a push may run on a machine that never pulled, so the asset keeps `pulled.at` and the stale-push check below compares
GitHub's `updated_at` and `updatedAt` against it where GitHub gives one, and the record's content against the asset
where it does not, which is labels.

## Two verbs, one hub

```
star gh model pull [--org <organization>] [--asset <path>]
star gh model push [--org <organization>] [--repo <owner/repo>[,...]] [--delete] [--force] [--asset <path>]
```

Both target an organization, NobleFactor by default: the owner, 2026-10-22, "We need pull and push to target an
organization, I think. The default organization is NobleFactor." An organization's record is its issue types, its
projects with their fields, and the labels of its repositories; `--repo` names the repositories a push writes labels
to, and a repository outside any organization, personal, whose record is labels alone. A push with no `--repo`
writes the organization's types and projects and no repository's labels: which repositories are in is asked when
something names them, never kept ([section 4](4-storage-and-reach.md)). Direction is
in the verb, as in `git pull` and `git push`, because one end is always the asset. rsync and rclone put direction in
the argument order instead, and rclone splits "identical" from "add, never delete" into `sync` and `copy`; here the
split falls between the two verbs.

| Verb | From | To | Deletes | Lands as |
| --- | --- | --- | --- | --- |
| `pull` | the organization's record: issue types, projects and their fields, its repositories' labels | the asset | yes, shown first | a rewritten tracked file on a branch, reviewed as a pull request |
| `push` | the asset | the organization's record, or the named repositories' labels; personal first ([section 4](4-storage-and-reach.md)) | never by default; see Risk | changes in GitHub, reported |

- **`pull`** reads each record conditionally by its ETag, rewrites the asset where a record changed, and prints the
  diff. Exit 0 whether nothing changed or the asset was rewritten, the summary line saying which; exit 1 on a conflict
  it will not resolve, nothing written. Ruled 2026-10-23: a star command exits only 0 or 1. With `--check` it prints
  the diff and writes nothing: a workaround, since star's `--dry-run` skips every read a preview needs
  ([devlore-cli#1170](https://github.com/NobleFactor/devlore-cli/issues/1170)); `pull` refuses `--dry-run` and names
  `--check`, which retires when #1170 lands. A real pull writes only an asset in a git tree off its default branch with
  no uncommitted change to it, so the deployed asset, a link into the layer clone on develop, is pulled into through a
  worktree's with `--asset`. The owner, 2026-10-22, of its first use: "I made some changes to
  the data model on GitHub and want to sync back to the repo to ensure consistency. I will say that is the first thing
  I will do when the data model is complete."
- **`push`** replaces `star gh labels sync`: it brings the organization's record, or the named repositories' labels,
  to the asset, adding and correcting, never deleting unless told to, and `--dry-run` shows the changes. This is how
  personal participates: the owner, 2026-10-22, "Star gh offers directed syncs. Person[al] will need to sync if it
  wants to participate."
- **`star gh model audit`** replaces `star gh labels audit`: drift between the asset and any repository, reported,
  nothing written.
- `--asset` defaults to the file beside the extension, and names a worktree's asset for a real pull.
- **Every command that talks to GitHub checks gh's access first,** § Access below.

## Risk

The owner, 2026-10-22: "Push and pull are destructive so we need to think about risk mitigation." What each can
destroy, and what stands in the way:

| Verb | What it can destroy | Mitigation |
| --- | --- | --- |
| `pull` | the asset's last state, and with it any edit made to the file by hand | git. The owner, 2026-10-22: "For pull, I think we can depend on git." It runs only in a clean worktree on a branch and refuses a dirty asset; the previous state is the commit before, the diff is printed, and the pull request is the review |
| `push` of a label | a label removed strips it from every issue carrying it | deletion is off: `push` never deletes without `--delete`, which prints what each deletion strips and how many issues carry it, and `--dry-run` shows it all first. Ruled 2026-10-22: "I think we need to use a flag like --delete." The name is rsync's and rclone's for the same switch; `--force` is kept for the stale-push override below, as in git, so the two risks have two switches and neither implies the other |
| `push` of an issue type | a type removed changes every issue of that type | the same `--delete` gate |
| `push` of a project field | a field removed loses every row's value | the same gate; a field removal names the rows that hold a value |
| a single-select option changed through the API | GitHub's GraphQL updates a single-select field by taking the whole option list, and an option sent without its existing id is a new option: the old one is deleted and every row that held it goes blank. Run 2026-10-26 (#377): `ProjectV2SingleSelectFieldOptionInput` takes the option's `id`, and an update sending each option with its id renamed Todo to Not run, In Progress to Fails and Done to Passes in place, all six of project 4's rows keeping their value | `push` sends every option with the id the asset holds, and refuses an option whose id it does not have, so a rename is never sent as a replacement by accident; the test runs before `push` touches a field at all |
| a rename of a type, a label or a field | from the asset's side a rename is indistinguishable from a removal and a creation, so a push would strip the old name from everything and create an empty new one; and every consumer that names the thing by text, the markers in issue bodies, the `Epic:<Name>` labels, the extension's queries, the documents, keeps the old name | `push` refuses a rename. The rename is made in GitHub, which carries it to the issues and rows that hold the thing by id, then `pull` shows the diff so every text consumer is corrected in the same pull request. Ruled 2026-10-22: "We do not want to be surprised by blocks resulting from name changes that did not propagate." |
| a hand edit of the asset | a clumsy edit pushed into GitHub as if it were the pulled record | `pulled.digest`: `push` refuses a mismatched asset, every read says so, and CI fails the pull request; `pull` or `star gh model digest` clears it |
| a stale `push` | the asset was pulled, GitHub moved, the push writes over the move | `push` works the way `git push` works: it re-reads each record and refuses when GitHub has moved since `pulled.at`, by `updated_at` on issue types and `updatedAt` on projects, and by content for labels, as git refuses a push that is not a fast-forward of the remote; `pull` first, then `push`. `--force` overrides it, as `git push --force` does, and prints what it is overwriting. Ruled 2026-10-22: "Cite the git case and ensure that we doc that it works the way git push works." |
| the wrong organization | a push meant for one organization lands on another | the organization is one per invocation, printed in the first line, and `--dry-run` shows it |
| an agent running it | a session pushes on its own judgment | the owner runs `push`, as the owner runs every script that writes to GitHub; a session writes the command and hands it over |

Why renames need the rule even though GitHub propagates them: a label, a type, a field and a single-select option are
held by id, so renaming one in GitHub renames it on every issue and row at once; a text, number or date value has no
name to rename, it is the value. What GitHub cannot reach is everything that names it as
text, and this model has a great deal of that: the parent markers, the epic labels' `<Name>`, the queries the
extension runs, the standard and the plans. Those are the consumers that do not update, and the diff `pull` prints is
the list of them to fix.

## Recovery

The owner, 2026-10-22: "our copy of the model exists as a backup which can be used for disaster recovery. I'm thinking
about the mistakes we might make along the way." The asset in git is that backup: every state the model has been in
since its first pull is a commit, and `push --force --delete` from a chosen commit restores the organization's record
to it, the two switches being exactly the overrides a restore needs. `--dry-run` first shows what the restore would
do.

What it restores, and what it cannot:

| Mistake | Recovered by | Limit |
| --- | --- | --- |
| A type, a label, a field or an option renamed or given the wrong description or color | `push` from the last good commit | none: these are held by id, and the push corrects them in place |
| A label deleted | `push` recreates it | the issues that carried it do not get it back; GitHub stripped it on deletion. The report's last rows, or the markers, say which issues had it |
| A field or an option deleted | `push` recreates it | with a new id, so the asset's id is updated by the next `pull`, and every row's value in that field or option is gone; GitHub cleared it on deletion |
| A project deleted | `push` recreates it from the asset, template and fields | its rows are gone: the issues exist, their membership and lane numbers do not. A schedule's issue body holds its lane table until section 5's step 6 retires it, and that is the second copy until then |
| The asset itself damaged | git | a commit before the damage, or a `pull` from GitHub if GitHub is right |

The asset backs up the model, not the data the model holds: which issue has which type, which issues are rows of
which project, and each row's values live only in GitHub. A backup of those is a different thing, an export of the
issues and rows, and this design does not provide one; it is named here so that nobody mistakes the asset for it.
Until it exists, the schedule issues' lane tables and the parent markers in issue bodies are the copies of record for
membership and parents, which is one more reason section 5 retires them last.

## Access

Ruled 2026-10-26: "The extension should check for access and if the login is stale or access is denied you should
either exit with specific instructions". Every command that reads or writes GitHub, `pull` and the issues and labels
commands, checks gh's access before its first request, and when it cannot go on it fails with what is wrong and the one
thing that fixes it. It never signs in or adds a scope itself: star captures a command's output, so gh's one-time code
would never reach the user, and the sessions that run star must not change credentials. The user signs in and adds a
scope; GitHub issues the token and refuses what it cannot do. Built 2026-10-26 in `commands/access.star` (#377).

| # | Found | The command says |
| --- | --- | --- |
| 1 | gh is not signed in | You are not signed in to github.com with gh on this machine. Sign in: `gh auth login --hostname github.com`, then rerun |
| 2 | GitHub refuses the token, 401 | GitHub refused gh's token for the account; it has expired or been revoked. Renew your login: `gh auth refresh --hostname github.com`, then rerun. A token from `GH_TOKEN` or `GITHUB_TOKEN`: replace it, or unset it to use the gh login |
| 3 | the token lacks a scope the command needs | Your gh login lacks the scope the command needs, naming exactly the missing ones. Add it: `gh auth refresh --hostname github.com --scopes <missing>`, then rerun. `project` includes `read:project`, so the check never asks for both |
| 4 | the account cannot see the organization, 403 or 404, every scope held | the account cannot see the organization; no command here fixes it: an owner of the organization must grant the account access |
| 5 | the rate limit is spent | when it resets, in local time; rerun after that |

`pull` needs `read:project`, and checks the organization it reads; the issues and labels commands need gh's own scopes.
The refresh in rows 2 and 3 is interactive, a one-time code approved in a browser, so it runs in the user's own
terminal, not through a session. Under star's `--dry-run` every shell call is skipped, so nothing can be checked and
the check is skipped with it.

## Every operation reads first

The owner, 2026-10-22: "I argue that we pull before every star gh issues operation. We might optimize around some form
of change detection." So every `star gh issues` operation begins with the conditional read `pull` makes, three or four
requests sent with the cache's ETags and answered 304 when nothing moved, and runs against GitHub's record. It writes
nothing but the cache: the deployed asset is a link into the layer clone, and a read-only command must not dirty a
tracked file there. When a record is not 304 and
the asset is behind, the operation says so in one line of its header and goes on, the way the audit opens the tree
report today.

## Examples

Scenario 2, the owner adds a Priority field to the Schedule template in GitHub:

```
$ star gh model pull
[star] issue-types  W/"3f9c…"  unchanged (304)
[star] labels       W/"66b6…"  unchanged (304)
[star] projects     W/"a1d0…"  changed
--- model.yaml (pulled 2026-10-22T07:40:12Z)
+++ GitHub (NobleFactor, 2026-10-22T09:02:51Z)
@@ projects: Schedule @@
-    fields: [Lane, Status, Next]
+    fields: [Lane, Status, Next, Priority]
[star] model.yaml rewritten; 1 project changed, 0 types, 0 labels
```

`git status` then shows the asset modified on the branch, and the pull request carries that diff.

Scenario 1, personal joining:

```
$ star gh model push --repo David-Noble-at-work/personal --dry-run
[star] David-Noble-at-work/personal: 3 labels to create, 1 to align, 0 to delete (push never deletes)
  create  Epic:Ops:IssueTracking  5319e7
  create  Severity:Low            e4e669
  create  Severity:Medium         fbca04
  align   chore                   BFD4F2  "Maintenance work on the repo: build, CI, tooling, process"
```

## Participation: a repository outside the organization

The owner, 2026-10-22: "I wish to participate." A repository participates when the report places its issues, the audit
checks them, and its issues can be rows of the collections. The organization's repositories participate by being
there: GitHub's types, links and projects reach them. A repository outside the organization, personal today, has
labels and projects and nothing else, so participation is what `push` and the markers give it.

| Part of the model | In an organization repository | In personal, once it participates |
| --- | --- | --- |
| Type | GitHub's issue type | a label of the type's name, pushed from the asset's `types`; the audit reads it as the type |
| Parent | the sub-issue link | the sub-issue link too: it crosses owners, proven 2026-10-22 ([section 4](4-storage-and-reach.md)); the markers only until the old scheme retires |
| Epic | the parent's parent | the same marker chain, read up to an epic in any repository |
| Severity, Priority, Area | labels pushed from the asset | the same labels, pushed from the asset |
| A row in a Schedule, Thread or Triage project | yes | yes: a NobleFactor project held personal#259 as a row on 2026-10-20 |
| What enforces the rules | GitHub, for one type and one parent | nothing but the audit |

**Proven, not declared.** The owner, 2026-10-22: a repository that is not participating must be refused when
someone tries "to create a task for developing a feature or doing a chore to complete an epic, and put it on my
schedule", and "I might save the digest or an etag to ensure we've got reason to believe that you're really
participating and not yanking my chain." So nothing records that a repository participates; the tooling proves it at
the two moments it matters, filing an issue there and adding one of its issues as a row:

1. It reads the repository's label list, sending the ETag the cache holds. 304 means the list is what it was.
2. It compares the list with the labels the asset says that repository must carry, the organization's tier, its
   teams' and its own, and keeps a digest of the matching list in the cache beside the ETag, written only when the
   comparison passed, by a `push` or an audit.
3. A 304 against a cached digest is proof at no cost. A changed list is compared again. A list that lacks a label the
   asset requires is a refusal: "NobleFactor/foo is not participating: 3 labels missing; run star gh model push
   --repo NobleFactor/foo", and nothing is filed and no row is added.

The cache's entry for a repository therefore holds its ETag, the digest of its labels as last proven, and when:

```yaml
labels:
  NobleFactor/noblefactor-ops: { etag: 'W/"66b6…"', proven: sha256:4c1d…, read: 2026-10-22T09:02:51Z }
```

For an organization repository the types and the sub-issue link are GitHub's and need no proof; the labels are the
whole of the check. For personal the type is a label and the parent is a sub-issue link, so the check is the labels
and nothing else there either.

**Joining**, in order:

1. The repository is named where the tooling reads repositories: for a writ layer, its clone is already one of the
   layers' repositories, and `star gh` reads it; for any other, `--repo` names it.
2. `star gh model push --repo <owner/repo>`, after `--dry-run`, gives it the labels the asset defines: the type labels,
   the attributes, and the epic labels of the epics its issues serve. Nothing is deleted.
3. Its issues are filed as the standard says: one type label, the parent marker, the attributes it needs. The audit
   reports what is missing, and the Triage project takes what is unplaced ([section 1](1-hierarchy.md) § Triage).
4. Its issues join collections by being added as rows, like any other.

**Staying in**: every `push` after a `pull` carries what changed in the asset to the repository, and the audit, run
from any machine, says when it is behind. A label the repository has and the asset does not is reported, never
removed: `push` never deletes.

**What participation does not give personal**: GitHub's own enforcement, the type picker in GitHub's interface, and
the sub-issue tree in an issue's sidebar. Those come only from being an organization repository, which the owner ruled
against on 2026-10-22 in favor of the sync.

## What this changes in the task list

[Section 5](5-from-todays-scheme.md)'s step 2, tooling that reads both, begins with `pull`, not `push`: the owner
authors the model in GitHub first, pulls it into the asset, and the asset then drives the extension and the pushes.
#320's labels file becomes the asset's `labels` block, moved from `docs/architecture/issue-labels/` to the extension's
directory, with the header above added.
