# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The check of gh's access that every command talking to GitHub makes first, failing with the one fix it finds.

Ruled 2026-10-26 (noblefactor-engprod#377): the extension checks access, and when the login is missing or stale or
access is denied, it exits with specific instructions. It never signs in itself: star captures a command's output, so
gh's one-time code would never reach the user, and the sessions that run star must not change credentials. The user
signs in and adds a scope; GitHub issues the token and refuses what it cannot do. Loads nothing, so that model.star
can load it without scheme.star.

#621: a failed check is diagnosed from what actually stopped it. gh prints "The token in keyring is invalid" for a login
it couldn't check, even when no request reached GitHub, so that line decides nothing; the login's "- Error:" line, or a
call's own output, does. A connection failure, DNS, a timeout, a refused or reset connection, or TLS, is named as one
and recommends no change to any credential. Only a 401 or "Bad credentials" is a rejected token. Anything else is
quoted, with no fix claimed. Every call after the login's stops the same way when its exit status isn't 0.
"""

# access.star

# What a connection failure says, as gh and Go's network stack word it, in lower case.
_CONNECTION = [
    "no such host",
    "i/o timeout",
    "timeout",
    "timed out",
    "connection refused",
    "connection reset",
    "network is unreachable",
    "no route to host",
    "tls:",
    "x509:",
    "certificate",
    "eof",
]

# What a rejected credential says.
_REJECTED = ["401", "bad credentials"]

# The prefixes GitHub gives its tokens, scrubbed from any line a message quotes, and the characters a token holds.
_TOKEN_PREFIXES = ["ghp_", "gho_", "ghu_", "ghs_", "ghr_", "github_pat_"]
_TOKEN_CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"

def _run(command):
    """A shell command's exit status and its output, standard error with it: (status, output)."""
    out = shell.exec(command = "{ " + command + "; } 2>&1; echo \"__star_exit=$?\"").stdout
    cut = out.rfind("__star_exit=")
    if cut < 0:
        return 1, out
    code = out[cut + len("__star_exit="):].strip()
    return (int(code) if code.isdigit() else 1), out[:cut]

def _scrub(line):
    """A line of gh's with anything shaped like a GitHub token replaced by <token>, so that a message can quote it.

    A token is one of GitHub's prefixes, wherever it starts, and every token character after it: inside an assignment,
    quotes, a URL's credentials or anything else, the text around it kept (#621).
    """
    out = ""
    rest = line
    for _ in range(len(line) + 1):
        at = -1
        prefix = ""
        for p in _TOKEN_PREFIXES:
            i = rest.find(p)
            if i >= 0 and (at < 0 or i < at):
                at = i
                prefix = p
        if at < 0:
            break
        end = at + len(prefix)
        for c in rest[end:].elems():
            if c not in _TOKEN_CHARACTERS:
                break
            end += 1
        out += rest[:at] + "<token>"
        rest = rest[end:]
    return out + rest

def _diagnose(text):
    """What a failure's text says stopped it: ("connection", line), ("rejected", line), or ("unknown", line).

    The text's error lines decide: gh's "- Error: ..." in auth status, or a call's output. They are read scrubbed, so
    that a token's characters never read as a word, and a line is quoted scrubbed.
    """
    lines = [x.strip() for x in text.replace("\r", "").split("\n") if x.strip() != ""]
    errors = [x for x in lines if x.lstrip("- ").lower().startswith("error")] or lines
    line = _scrub(errors[-1].lstrip("- ")) if errors else "no answer"
    said = _scrub(" ".join(errors)).lower()
    for s in _CONNECTION:
        if s in said:
            return "connection", line
    for s in _REJECTED:
        if s in said:
            return "rejected", line
    return "unknown", line

def _active_login(status):
    """The block of gh auth status's output for the login in use, or None when there is none.

    It is {ok, account, source, scopes, error}, error the block's "- Error:" line, or "" when there is none.
    """
    for block in status.replace("\r", "").split("\n\n"):
        lines = [line.strip() for line in block.split("\n") if line.strip() != ""]
        if not [line for line in lines if line == "- Active account: true"]:
            continue
        head = [line for line in lines if line.startswith("✓ ") or line.startswith("X ")]
        if not head:
            continue
        login = {"ok": head[0].startswith("✓ "), "account": "", "source": "", "scopes": [], "error": ""}
        if " account " in head[0]:
            login["account"] = head[0].split(" account ", 1)[1].split(" (", 1)[0]
        if "(" in head[0]:
            login["source"] = head[0].rsplit("(", 1)[1].rstrip(")")
        for line in lines:
            if line.startswith("- Token scopes:"):
                login["scopes"] = [s.strip().strip("'") for s in line[len("- Token scopes:"):].split(",") if s.strip()]
            if line.startswith("- Error:"):
                login["error"] = line
        return login
    return None

def _holds(scopes, scope):
    """Whether the token's scopes give scope: project includes read:project, and GitHub then lists only project."""
    return scope in scopes or (scope == "read:project" and "project" in scopes)

def _unreachable(command, line, rerun):
    """The failure for GitHub not reached: what gh said, and the network to check; no credential is at fault."""
    fail("GitHub can't be reached from this machine, so " + command + " can't use it: " + line + "\n" +
         "No credential is at fault: check the network, a proxy (HTTPS_PROXY) or a VPN, " + rerun)

def _rejected(login, rerun):
    """The failure for a token GitHub refused: replace the variable's, or renew gh's login."""
    source = login["source"]
    if source == "GH_TOKEN" or source == "GITHUB_TOKEN":
        fail("GitHub refused the token in " + source + " (401: bad credentials); it has expired or been revoked.\n" +
             "Replace it, or unset " + source + " to use your gh login, " + rerun)
    fail("GitHub refused gh's token" + (" for " + login["account"] if login["account"] else "") +
         " (401: bad credentials); it has expired or been revoked.\n" +
         "Renew your login:  gh auth refresh --hostname github.com\n" + rerun)

def _stopped(command, login, what, text, rerun):
    """The failure for a call that stopped: a connection failure, a rejected token, or gh's own words."""
    kind, line = _diagnose(text)
    if kind == "connection":
        _unreachable(command, line, rerun)
    if kind == "rejected":
        _rejected(login, rerun)
    fail("gh couldn't " + what + ": " + line + "\nNo fix is known for that answer; " + rerun)

def check_access(command, org = "", scopes = [], dry_run = False):
    """Fail with the one fix when gh cannot do what command needs.

    It checks, in order: gh is there, signed in, with a live token, the scopes, GitHub's rate limit, and the
    organization. A check that can't reach GitHub stops the command, named as a connection failure (#621).

    Args:
      command: the command as the user typed it, star github <...>, named in every message.
      org: the organization the command reads, checked when given.
      scopes: the token scopes the command needs beyond gh's own.
      dry_run: under star's --dry-run every shell.exec is skipped, so nothing can be checked and nothing is.
    """
    if dry_run:
        return
    rerun = "then rerun " + command + "."

    _, found = _run("command -v gh >/dev/null && echo yes || echo no")
    if found.strip() != "yes":
        fail("gh is not on PATH on this machine.\nInstall it: https://cli.github.com/\n" + rerun)

    _, status = _run("gh auth status --hostname github.com")
    login = _active_login(status)
    if login == None:
        fail("You are not signed in to github.com with gh on this machine.\n" +
             "Sign in:  gh auth login --hostname github.com\n" + rerun)

    if not login["ok"]:
        if login["error"] == "":
            _rejected(login, rerun)
        what = "check its login" + (" for " + login["account"] if login["account"] else "")
        _stopped(command, login, what, login["error"], rerun)

    account = login["account"] or "this login"
    missing = [s for s in scopes if not _holds(login["scopes"], s)]
    if missing:
        fail("Your gh login as " + account + " lacks the scope " + command + " needs: " + ", ".join(missing) + ".\n" +
             "Add it:  gh auth refresh --hostname github.com --scopes " + ",".join(missing) + "\n" + rerun)

    code, rate = _run("gh api rate_limit --jq '.resources.core | \"\\(.remaining) \\(.reset)\"'")
    if code != 0:
        _stopped(command, login, "read GitHub's rate limit", rate, rerun)
    rate = rate.strip().split(" ")
    if len(rate) == 2 and rate[0] == "0" and rate[1].isdigit():
        _, at = _run("date -d @" + rate[1] + " '+%Y-%m-%d %H:%M %Z' 2>/dev/null || " +
                     "date -r " + rate[1] + " '+%Y-%m-%d %H:%M %Z'")
        fail("GitHub's rate limit for " + account + " is spent; it resets at " + at.strip() + ".\n" +
             "Rerun " + command + " after that.")

    if org:
        code, answer = _run("gh api -i orgs/" + org)
        head = answer.replace("\r", "").split("\n")[0].strip()
        if not head.startswith("HTTP"):
            if code != 0:
                _stopped(command, login, "read the organization " + org, answer, rerun)
            return
        if " 401 " in head + " ":
            _rejected(login, rerun)
        if " 404 " in head + " " or " 403 " in head + " ":
            fail(account + " cannot see the organization " + org + " (GitHub answered " + head.split(" ", 1)[-1] +
                 "), though the token holds every scope " + command + " needs.\n" +
                 "No command here fixes this: an owner of " + org + " must grant " + account + " access to it.")

        # Any other failed answer, a server error among them, proves nothing about the token, and stops the command.
        if code != 0:
            fail("gh couldn't read the organization " + org + ": GitHub answered " + _scrub(head.split(" ", 1)[-1]) +
                 ".\nNo fix is known for that answer; " + rerun)
