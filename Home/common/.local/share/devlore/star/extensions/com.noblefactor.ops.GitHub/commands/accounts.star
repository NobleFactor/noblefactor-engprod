# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The accounts star works with, and the repositories it reads when none is named.

docs/architecture/issue-data-model/6-the-asset-and-its-sync.md. The default account is star configuration's
github.account, and then NobleFactor. With no account named, the sweep works with the default account and the owner of
each of writ's layer repositories, the repositories the report reads when none is named (noblefactor-engprod#441); no
configuration names them. Each account's model is read from GitHub when a command needs it (#426). This module loads
nothing.
"""

# accounts.star

# The account a command reads when none is named: star configuration's github.account, and then this one.
DEFAULT_ACCOUNT_FALLBACK = "NobleFactor"

# A repository renamed on GitHub keeps its old name as a redirect, and the record keeps it as text. Every owner/repo
# the extension parses goes through canonical_repo, so the old name reads as the new. noblefactor-ops became
# noblefactor-engprod on 2026-10-22 (noblefactor-ops#304).
RENAMED = {"NobleFactor/noblefactor-ops": "NobleFactor/noblefactor-engprod"}

# owner/name at the end of a remote's URL, by HTTPS or by SSH, with or without .git.
ORIGIN = "[:/]([^/:]+/[^/]+?)(?:\\.git)?\\s*$"

# writ's layers, in their order. Each registered one is an entry under writ's data directory naming a repository's
# working tree; reading them needs nothing from writ (noblefactor-ops#253).
_LAYERS = ["base", "team", "personal"]

def default_account():
    """star configuration's github.account, or NobleFactor when it names none."""
    cfg = config.get
    if hasattr(cfg, "github") and hasattr(getattr(cfg, "github"), "account") and getattr(getattr(cfg, "github"), "account"):
        return getattr(getattr(cfg, "github"), "account")
    return DEFAULT_ACCOUNT_FALLBACK

def canonical_repo(name):
    """owner/repo as it is named today: a renamed repository's old name maps to its new one, anything else is itself."""
    return RENAMED.get(name, name)

def layer_repos():
    """owner/name of each registered writ layer's repository, base first, each once.

    A layer's entry is ${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers/<layer>, naming a git working tree. One
    that is absent, or names nothing git can read an origin from, is skipped, as writ reads an empty directory as no
    layer. The script never fails, since shell.exec raises on a non-zero exit (devlore-cli#824).
    """
    script = ("layers=\"${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers\"; for layer in " + " ".join(_LAYERS) +
              "; do if [ -e \"$layers/$layer\" ]; then git -C \"$layers/$layer\" remote get-url origin 2>/dev/null; fi; done; true")
    repos = []
    for origin in shell.exec(command = script).stdout.split("\n"):
        m = regex.find_submatch(pattern = ORIGIN, text = origin)
        if m != None and len(m) > 1 and canonical_repo(m[1]) not in repos:
            repos.append(canonical_repo(m[1]))
    return repos

def default_accounts():
    """The accounts star works with when none is named: the default account, then each writ layer repository's owner, each once."""
    accounts = [default_account()]
    for repo in layer_repos():
        owner = repo.split("/")[0]
        if owner not in accounts:
            accounts.append(owner)
    return accounts
