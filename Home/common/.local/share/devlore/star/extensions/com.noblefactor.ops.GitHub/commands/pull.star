# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A change landed in a repository through a pull request: committed, gated on the checks its branch requires, merged."""

# pull.star
#
# docs/plans/feature/426-model-pull-to-dot-github.md and docs/plans/feature/437-model-diff-apply-restore.md. backup lands
# a model this way, and apply a .github repository's files and each repository's Triage workflow. A pull request is
# opened from a branch, or the one open on it reused; the head commit's workflow runs are waited for, and every check
# the base branch requires must have passed; then it is merged, each step a comment on it. apply commits through
# GitHub's git data API, so that no clone of the owner's is touched; backup commits in its own clone of the .github
# repository (#426).

load("commands/model.star", "escape", "quote", "rest", "sh")

# How long the head commit's workflow runs have to start, and how often they are read until they do. Measured on
# 2026-11-10, every run a pull request started was created 3 to 4 seconds after it opened.
_RUNS_START = 60
_RUNS_START_POLL = 2

# How often the runs are read until they finish; the jobs' own timeouts bound the wait.
_RUNS_FINISH_POLL = 10

# The buckets gh pr checks puts a passing check in.
_PASSING = ["pass", "skipping"]

def comment(repository, number, text):
    """Records one step and its outcome as a comment on the pull request."""
    sh("gh pr comment " + number + " --repo " + quote(repository) + " --body " + quote(text))

def default_branch(repository):
    """The repository's default branch, which a pull request merges into and GitHub runs an issue's workflow from."""
    return sh("gh api " + quote("repos/" + repository) + " --jq .default_branch").strip()

def _required(repository, branch):
    """The checks the branch requires, by name; none for a branch without rules."""
    names = sh("gh api " + quote("repos/" + repository + "/rules/branches/" + escape(branch)) + " --jq " +
               quote("[.[] | select(.type == \"required_status_checks\") | .parameters.required_status_checks[].context] | unique | .[]"))
    return [n for n in names.split("\n") if n.strip() != ""]

def _runs(repository, sha, program):
    """A gh call reading the head commit's workflow runs through a jq program."""
    return "gh api " + quote("repos/" + repository + "/actions/runs?head_sha=" + sha + "&per_page=100") + " --jq " + quote(program)

def _gate(repository, number, url, sha, base, what):
    """Waits for the checks the base branch requires, and fails, saying why on the pull request, unless every one passed.

    With no check required, there is nothing to wait for. Otherwise it waits for the head commit's workflow runs to
    start, then for every one to finish, and only then reads the checks: by then every job that will run is listed.
    """
    required = _required(repository, base)
    if not required:
        comment(repository, number, "No check is required on " + base + "; merging.")
        return
    started = False
    for attempt in range(_RUNS_START // _RUNS_START_POLL + 1):
        if sh(_runs(repository, sha, ".workflow_runs | length")).strip() not in ["", "0"]:
            started = True
            break
        if attempt < _RUNS_START // _RUNS_START_POLL:
            sh("sleep " + str(_RUNS_START_POLL))
    if not started:
        text = ("No workflow run started on " + sha[:7] + " within " + str(_RUNS_START) + " seconds, and " + base + " requires " +
                ", ".join(required) + ", so " + what + " stops here, unmerged.")
        comment(repository, number, text)
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
        text = "Checks did not pass, so " + what + " stops here, unmerged: " + "; ".join(problems) + "."
        comment(repository, number, text)
        fail(url + ": " + text)
    comment(repository, number, "Checks passed: " + ", ".join(passed) + "; merging.")

def signer():
    """The Signed-off-by line's name and address: git's identity, as a commit would carry it."""
    return sh("git config user.name").strip() + " <" + sh("git config user.email").strip() + ">"

def land(repository, base, branch, title, body, sha, what):
    """Opens a pull request from branch into base, or updates the one open on it, gates it on its checks, and merges it.

    Args:
      repository: owner/name.
      base: the branch it merges into.
      branch: the branch holding the change, already pushed.
      title: the pull request's title, and the squash commit's subject with its number.
      body: its description.
      sha: the branch's head commit, whose workflow runs are the checks.
      what: what the comments call the change when it stops: "the backup", "the change".

    Returns:
      (url, number): the pull request's.
    """
    url = sh("gh pr list --repo " + quote(repository) + " --head " + quote(branch) + " --state open --json url --jq " +
             quote(".[0].url // \"\"")).strip()
    if url != "":
        sh("gh pr edit " + url.rsplit("/", 1)[-1] + " --repo " + quote(repository) + " --body " + quote(body))
    else:
        url = sh("gh pr create --repo " + quote(repository) + " --base " + quote(base) + " --head " + quote(branch) + " --title " +
                 quote(title) + " --body " + quote(body)).strip().split("\n")[-1]
    number = url.rsplit("/", 1)[-1]
    _gate(repository, number, url, sha, base, what)

    # TODO(NobleFactor/devlore-cli#1219): ask before merging, defaulting to yes (#470).
    sh("gh pr merge " + number + " --repo " + quote(repository) + " --squash --admin --subject " + quote(title + " (#" + number + ")"))
    return url, number

def commit_files(repository, base, branch, files, message):
    """Commits files on a branch made from base, through GitHub's git data API, and returns the commit.

    Args:
      repository: owner/name.
      base: the branch the commit's parent is the head of.
      branch: the branch made, or moved, to the commit.
      files: {path: text}, each written whole.
      message: the commit's message.
    """
    parent = sh("gh api " + quote("repos/" + repository + "/git/ref/heads/" + base) + " --jq .object.sha").strip()
    tree = sh("gh api " + quote("repos/" + repository + "/git/commits/" + parent) + " --jq .tree.sha").strip()
    entries = [{"path": p, "mode": "100644", "type": "blob", "content": files[p]} for p in sorted(files)]
    made = rest("POST", "repos/" + repository + "/git/trees", {"base_tree": tree, "tree": entries})
    commit = rest("POST", "repos/" + repository + "/git/commits", {"message": message, "tree": made["sha"], "parents": [parent]})
    exists = sh("gh api " + quote("repos/" + repository + "/git/ref/heads/" + branch) + " --jq .object.sha 2>/dev/null || true").strip()
    if exists.startswith("{") or exists == "":
        rest("POST", "repos/" + repository + "/git/refs", {"ref": "refs/heads/" + branch, "sha": commit["sha"]})
    else:
        rest("PATCH", "repos/" + repository + "/git/refs/heads/" + branch, {"sha": commit["sha"], "force": True})
    return commit["sha"]
