# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model backup: an account's model, as GitHub holds it now, checkpointed in its .github repository."""

# github-model-backup.star
#
# docs/plans/feature/426-model-pull-to-dot-github.md, Requirement 3. GitHub holds the only definitive model; a backup is
# a checkpoint of it, model.yaml on the main branch of the account's .github repository, which a restore reads
# (noblefactor-engprod#437). It follows the owner's process (ruled 2026-11-09): the model is written on a branch named
# chore/model-<date>, with no issue, and lands through a pull request, its comments the record of each step. The clone is
# ~/Workspace/<account>/.github and is left current. The model's text is what star github model get renders as YAML,
# byte for byte, since backup runs it. It merges only once every workflow run on the pull request's head commit has
# finished and every check main requires has passed: a job that needs another is not listed until that one finishes,
# so the runs, not the checks, say when the checks are all there; a backup that stops leaves its pull request open, and
# the next reuses it. For now it asks nothing (ruled 2026-11-09): devlore's TUI cannot ask yet
# (NobleFactor/devlore-cli#1219), and NobleFactor/noblefactor-engprod#470 tracks the questions it will ask.

load("commands/access.star", "check_access")
load("commands/model.star", "quote", "refuse_dry_run", "sh")

# How long the head commit's workflow runs have to start, and how often they are read until they do. Measured on
# 2026-11-10, every run a pull request started was created 3 to 4 seconds after it opened.
_RUNS_START = 60
_RUNS_START_POLL = 2

# How often the runs are read until they finish; the jobs' own timeouts bound the wait.
_RUNS_FINISH_POLL = 10

# The buckets gh pr checks puts a passing check in.
_PASSING = ["pass", "skipping"]

def _ok(command):
    """Whether a shell command exits 0, its output and errors discarded."""
    return sh("(" + command + ") >/dev/null 2>&1 && echo yes || echo no").strip() == "yes"

def _comment(repository, number, text):
    """Records one step of the backup and its outcome as a comment on the backup's pull request."""
    sh("gh pr comment " + number + " --repo " + quote(repository) + " --body " + quote(text))

def _required(repository):
    """The checks the repository's main requires, by name; none for a repository without rules."""
    names = sh("gh api " + quote("repos/" + repository + "/rules/branches/main") + " --jq " +
               quote("[.[] | select(.type == \"required_status_checks\") | .parameters.required_status_checks[].context] | unique | .[]"))
    return [n for n in names.split("\n") if n.strip() != ""]

def _runs(repository, sha, program):
    """A gh call reading the head commit's workflow runs through a jq program."""
    return "gh api " + quote("repos/" + repository + "/actions/runs?head_sha=" + sha + "&per_page=100") + " --jq " + quote(program)

def _gate(repository, number, url, sha):
    """Waits for the checks main requires, and fails, saying why on the pull request, unless every check passed.

    With no check required, there is nothing to wait for. Otherwise it waits for the head commit's workflow runs to
    start, then for every one to finish, and only then reads the checks: by then every job that will run is listed.
    """
    required = _required(repository)
    if not required:
        _comment(repository, number, "No check is required on main; merging.")
        return
    started = False
    for attempt in range(_RUNS_START // _RUNS_START_POLL + 1):
        if sh(_runs(repository, sha, ".workflow_runs | length")).strip() not in ["", "0"]:
            started = True
            break
        if attempt < _RUNS_START // _RUNS_START_POLL:
            sh("sleep " + str(_RUNS_START_POLL))
    if not started:
        text = ("No workflow run started on " + sha[:7] + " within " + str(_RUNS_START) + " seconds, and main requires " +
                ", ".join(required) + ", so the backup stops here, unmerged.")
        _comment(repository, number, text)
        fail(url + ": " + text)

    unfinished = sh("while n=$(" + _runs(repository, sha, "[.workflow_runs[] | select(.status != \"completed\")] | length") +
                    ") && [ \"$n\" != 0 ]; do sleep " + str(_RUNS_FINISH_POLL) + "; done; printf %s \"$n\"").strip()
    if unfinished != "0":
        fail(url + ": the workflow runs on " + sha[:7] + " could not be read")

    checks = json.decode(data = sh("gh pr checks " + number + " --repo " + quote(repository) + " --json name,bucket 2>/dev/null || echo '[]'"))
    listed = [c["name"] for c in checks]
    passed = [c["name"] for c in checks if c["bucket"] in _PASSING]
    problems = [c["name"] + " " + ("failed" if c["bucket"] == "fail" else "ended " + c["bucket"]) for c in checks if c["bucket"] not in _PASSING]
    problems.extend([n + " never reported" for n in required if n not in listed])
    if problems:
        text = "Checks did not pass, so the backup stops here, unmerged: " + "; ".join(problems) + "."
        _comment(repository, number, text)
        fail(url + ": " + text)
    _comment(repository, number, "Checks passed: " + ", ".join(passed) + "; merging.")

def run(_command, ctx):
    """Check gh's access, read the account's model from GitHub, and land it in the account's .github repository.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account.

    Returns:
      A record: the account, the repository, and either status "current", when main already holds the model, or
      status "merged" with the branch and the pull request that landed it.
    """
    account = (ctx.args.get("account") or "").strip()
    if account == "":
        fail("name the account: star github model backup <account>")
    refuse_dry_run(ctx.dry_run)
    check_access("star github model backup", scopes = ["repo", "read:project"], dry_run = ctx.dry_run)
    repository = account + "/.github"
    model = sh("star github model get " + quote(account) + " --output yaml --silent --no-pager").rstrip("\n") + "\n"

    if not _ok("gh repo view " + quote(repository) + " --json name"):
        # TODO(NobleFactor/devlore-cli#1219): ask before creating the repository, defaulting to yes (#470).
        sh("gh repo create " + quote(repository) + " --public --add-readme --description " +
           quote(account + "'s own repository: its default community health files and its issue model"))

    clone = sh('printf %s "$HOME/Workspace/' + account + '/.github"')
    if not _ok("git -C " + quote(clone) + " rev-parse --git-dir"):
        sh("mkdir -p " + quote(clone.rsplit("/", 1)[0]) + " && gh repo clone " + quote(repository) + " " + quote(clone) + " -- --quiet")
    if sh("git -C " + quote(clone) + " status --porcelain").strip() != "":
        fail(clone + " has uncommitted changes; commit or remove them, and back up again")
    git = "git -C " + quote(clone) + " "
    sh(git + "fetch --quiet origin && " + git + "checkout --quiet main && " + git + "merge --quiet --ff-only origin/main")

    on_main = sh(git + "show origin/main:model.yaml 2>/dev/null || true")
    if on_main.rstrip("\n") == model.rstrip("\n"):
        return {"account": account, "repository": repository, "status": "current"}

    day = sh("date +%Y-%m-%d").strip()
    branch = "chore/model-" + day
    title = "chore: " + account + "'s model as GitHub holds it, " + day
    sh(git + "checkout --quiet -B " + quote(branch) + " origin/main")
    sh("printf %s " + quote(model) + " > " + quote(clone + "/model.yaml"))
    sh(git + "add model.yaml && " + git + "commit --quiet -m " + quote(title) + " && " + git + "push --quiet --force origin " + quote(branch))
    changed = sh(git + "diff --stat origin/main " + quote(branch) + " -- model.yaml").strip()
    signer = sh(git + "config user.name").strip() + " <" + sh(git + "config user.email").strip() + ">"
    body = ("## Summary\n\n`star github model backup " + account + "`: " + account + "'s issue data model as GitHub holds it on " + day +
            ", read by `star github model get`, replacing the checkpoint on `main`.\n\n```text\n" + changed + "\n```\n\n" +
            "Signed-off-by: " + signer)
    sha = sh(git + "rev-parse " + quote(branch)).strip()
    url = sh("gh pr list --repo " + quote(repository) + " --head " + quote(branch) + " --state open --json url --jq " +
             quote(".[0].url // \"\"")).strip()
    if url != "":
        sh("gh pr edit " + url.rsplit("/", 1)[-1] + " --repo " + quote(repository) + " --body " + quote(body))
    else:
        url = sh("gh pr create --repo " + quote(repository) + " --base main --head " + quote(branch) + " --title " + quote(title) +
                 " --body " + quote(body)).strip().split("\n")[-1]
    number = url.rsplit("/", 1)[-1]
    _gate(repository, number, url, sha)

    # TODO(NobleFactor/devlore-cli#1219): ask before merging, defaulting to yes (#470).
    sh("gh pr merge " + number + " --repo " + quote(repository) + " --squash --admin --subject " + quote(title + " (#" + number + ")"))
    sh(git + "fetch --quiet origin && " + git + "checkout --quiet main && " + git + "merge --quiet --ff-only origin/main && " +
       git + "branch --quiet -D " + quote(branch) + " && (" + git + "push --quiet origin --delete " + quote(branch) + " 2>/dev/null || true)")
    head = sh(git + "rev-parse --short origin/main").strip()
    if sh(git + "show origin/main:model.yaml").rstrip("\n") != model.rstrip("\n"):
        _comment(repository, number, "Merged, but main, at " + head + ", does not read back as the model.")
        fail(url + " merged, but " + repository + "'s main does not read back as the model")
    merged = ("Merged. main, at " + head + ", reads back as the model; " + branch + " is removed, and the clone, ~/Workspace/" +
              account + "/.github, is on main.")
    _comment(repository, number, merged)
    return {"account": account, "repository": repository, "status": "merged", "branch": branch, "pull_request": url}
