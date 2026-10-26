# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The check of gh's access that every command talking to GitHub makes first, failing with the one fix for what it finds.

Ruled 2026-10-26 (noblefactor-engprod#377): the extension checks access, and when the login is missing or stale or
access is denied, it exits with specific instructions. It never signs in itself: star captures a command's output, so
gh's one-time code would never reach the user, and the sessions that run star must not change credentials. The user
signs in and adds a scope; GitHub issues the token and refuses what it cannot do. Loads nothing, so that model.star
can load it without scheme.star.
"""

# access.star

def _run(command):
    """A shell command's output, standard error with it, whatever its exit: gh's refusals are what is being read."""
    return shell.exec(command = command + " 2>&1; true").stdout

def _active_login(status):
    """The block of gh auth status's output for the login in use: {ok, account, source, scopes}, or None when there is none."""
    for block in status.replace("\r", "").split("\n\n"):
        lines = [line.strip() for line in block.split("\n") if line.strip() != ""]
        if not [line for line in lines if line == "- Active account: true"]:
            continue
        head = [line for line in lines if line.startswith("✓ ") or line.startswith("X ")]
        if not head:
            continue
        login = {"ok": head[0].startswith("✓ "), "account": "", "source": "", "scopes": []}
        if " account " in head[0]:
            login["account"] = head[0].split(" account ", 1)[1].split(" (", 1)[0]
        if "(" in head[0]:
            login["source"] = head[0].rsplit("(", 1)[1].rstrip(")")
        for line in lines:
            if line.startswith("- Token scopes:"):
                login["scopes"] = [s.strip().strip("'") for s in line[len("- Token scopes:"):].split(",") if s.strip()]
        return login
    return None

def _holds(scopes, scope):
    """Whether the token's scopes give scope: project includes read:project, and GitHub then lists only project."""
    return scope in scopes or (scope == "read:project" and "project" in scopes)

def check_access(command, org = "", scopes = [], dry_run = False):
    """Fail with the one fix when gh cannot do what command needs: signed in, a live token, the scopes, the organization, and rate.

    Args:
      command: the command as the user typed it, star gh <...>, named in every message.
      org: the organization the command reads, checked when given.
      scopes: the token scopes the command needs beyond gh's own.
      dry_run: under star's --dry-run every shell.exec is skipped, so nothing can be checked and nothing is.
    """
    if dry_run:
        return
    rerun = "then rerun " + command + "."

    if _run("command -v gh >/dev/null && echo yes || echo no").strip() != "yes":
        fail("gh is not on PATH on this machine.\nInstall it: https://cli.github.com/\n" + rerun)

    login = _active_login(_run("gh auth status --hostname github.com"))
    if login == None:
        fail("You are not signed in to github.com with gh on this machine.\n" +
             "Sign in:  gh auth login --hostname github.com\n" + rerun)

    if not login["ok"]:
        if login["source"] == "GH_TOKEN" or login["source"] == "GITHUB_TOKEN":
            fail("GitHub refused the token in " + login["source"] + " (401: bad credentials); it has expired or been revoked.\n" +
                 "Replace it, or unset " + login["source"] + " to use your gh login, " + rerun)
        fail("GitHub refused gh's token" + (" for " + login["account"] if login["account"] else "") +
             " (401: bad credentials); it has expired or been revoked.\n" +
             "Renew your login:  gh auth refresh --hostname github.com\n" + rerun)

    account = login["account"] or "this login"
    missing = [s for s in scopes if not _holds(login["scopes"], s)]
    if missing:
        fail("Your gh login as " + account + " lacks the scope " + command + " needs: " + ", ".join(missing) + ".\n" +
             "Add it:  gh auth refresh --hostname github.com --scopes " + ",".join(missing) + "\n" + rerun)

    rate = _run("gh api rate_limit --jq '.resources.core | \"\\(.remaining) \\(.reset)\"'").strip().split(" ")
    if len(rate) == 2 and rate[0] == "0" and rate[1].isdigit():
        at = _run("date -d @" + rate[1] + " '+%Y-%m-%d %H:%M %Z' 2>/dev/null || date -r " + rate[1] + " '+%Y-%m-%d %H:%M %Z'").strip()
        fail("GitHub's rate limit for " + account + " is spent; it resets at " + at + ".\nRerun " + command + " after that.")

    if org:
        head = _run("gh api -i orgs/" + org + " 2>/dev/null | head -1").strip()
        if " 401 " in head + " ":
            fail("GitHub refused gh's token for " + account + " (401: bad credentials); it has expired or been revoked.\n" +
                 "Renew your login:  gh auth refresh --hostname github.com\n" + rerun)
        if " 404 " in head + " " or " 403 " in head + " ":
            fail(account + " cannot see the organization " + org + " (GitHub answered " + head.split(" ", 1)[-1] + "), though the token holds every scope " +
                 command + " needs.\nNo command here fixes this: an owner of " + org + " must grant " + account + " access to it.")
