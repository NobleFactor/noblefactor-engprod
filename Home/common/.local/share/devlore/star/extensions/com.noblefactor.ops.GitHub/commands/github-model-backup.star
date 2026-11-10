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
# byte for byte, since backup runs it. For now it asks nothing (ruled 2026-11-09): devlore's TUI cannot ask yet
# (NobleFactor/devlore-cli#1219), and NobleFactor/noblefactor-engprod#470 tracks the questions it will ask.

load("commands/access.star", "check_access")
load("commands/model.star", "quote", "refuse_dry_run", "sh")

def _ok(command):
    """Whether a shell command exits 0, its output and errors discarded."""
    return sh("(" + command + ") >/dev/null 2>&1 && echo yes || echo no").strip() == "yes"

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

    day = sh("date -u +%Y-%m-%d").strip()
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
    url = sh("gh pr create --repo " + quote(repository) + " --base main --head " + quote(branch) + " --title " + quote(title) +
             " --body " + quote(body)).strip().split("\n")[-1]
    number = url.rsplit("/", 1)[-1]
    if not _ok("gh pr checks " + number + " --repo " + quote(repository) + " --watch"):
        report = sh("gh pr checks " + number + " --repo " + quote(repository) + " 2>&1 || true")
        if "no checks reported" not in report:
            fail(url + ": its checks did not pass:\n" + report)

    # TODO(NobleFactor/devlore-cli#1219): ask before merging, defaulting to yes (#470).
    sh("gh pr merge " + number + " --repo " + quote(repository) + " --squash --admin --subject " + quote(title + " (#" + number + ")"))
    sh(git + "fetch --quiet origin && " + git + "checkout --quiet main && " + git + "merge --quiet --ff-only origin/main && " +
       git + "branch --quiet -D " + quote(branch) + " && (" + git + "push --quiet origin --delete " + quote(branch) + " 2>/dev/null || true)")
    if sh(git + "show origin/main:model.yaml").rstrip("\n") != model.rstrip("\n"):
        fail(url + " merged, but " + repository + "'s main does not read back as the model")
    return {"account": account, "repository": repository, "status": "merged", "branch": branch, "pull_request": url}
