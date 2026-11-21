# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github token make: an account's issue-tracking token made, or adopted, and stored in Azure Key Vault."""

# github-token-make.star
#
# docs/plans/feature/451-credentials.md, § 5.4 (noblefactor-engprod#451). Every account identifies its token, and
# where GitHub lets star make or store it, star does: an organization's GitHub App from a manifest, its ID and private
# key stored in Key Vault; a user account's classic token, which GitHub offers no way to make from a script, checked and
# stored once you make it. Each value goes into Key Vault named <account>--<SECRET>, its underscores made hyphens.
#
# It asks nothing at a prompt: an extension's commands get no standard input until NobleFactor/devlore-cli#1136, so a
# manifest's code and a classic token come from a source named on the command line, env:<NAME> or file:<path>, as
# --token takes one. It runs the same with or without a terminal. Each run reports what exists and the next command;
# nothing is ever rolled back or deleted: an app, a key and a vault secret stay, and a run again finishes what is left.
#
# An organization, in three runs: the first writes the app's manifest, its permissions from
# templates/automation-app.json, and a local page whose form posts it to GitHub, and opens the page; you confirm, and
# GitHub sends the browser to the organization's page with code and state in its address, good for one hour. The second,
# given that address or its code, checks the state, exchanges the code for the app's ID, slug and private key (POST
# /app-manifests/{code}/conversions), writes the key to a file only you can read before anything else, stores both
# values in the vault, checks each by hash, deletes the file only once both are stored, and opens the app's install
# page. The third, once you've installed it, finds the app installed on the organization and prints the token record. A
# user account, in two runs: the first opens GitHub's new-token page with its note and scopes filled in; the second
# checks the token's login and scopes, reads its expiry, and stores it.
#
# A working token already in the vault under those names is adopted: verified, and its record printed. --replace makes
# new values as new versions of the same vault secrets, leaving GitHub's secrets as they are until apply runs.

load("commands/access.star", "check_access")
load("commands/credentials.star", "KIND", "installed")
load("commands/model.star", "extension_dir", "owner_kind", "quote", "read_text", "refuse_dry_run", "sh")
load("commands/participation.star", "TEMPLATE", "read_file", "secrets_of")
load("commands/tokens.star", "CLEAN", "parse", "problem", "reader")

# The scopes a user account's classic token needs: repo for private repositories, project for its projects.
_SCOPES = ["repo", "project"]

# The hash both sides of a stored value are compared by.
_SHA = "{ sha256sum 2>/dev/null || shasum -a 256; } | cut -c1-64"

def _ok(command):
    """Whether a shell command exits 0, its output discarded."""
    return sh("(" + command + ") >/dev/null 2>&1 && echo yes || echo no").strip() == "yes"

def _state(account):
    """The directory a run keeps what the next one needs in, which only you can read.

    It is ~/.local/state/star/token-make/<account>, or under $XDG_STATE_HOME when that is set.
    """
    path = sh("printf %s \"${XDG_STATE_HOME:-$HOME/.local/state}/star/token-make/" + account + "\"")
    sh("mkdir -p " + quote(path) + " && chmod 700 " + quote(path))
    return path

def _open(target):
    """Opens a page or a file in the browser, where there is one to open it with; the record names it either way."""
    sh("{ command -v open >/dev/null 2>&1 && open " + quote(target) + "; } || " +
       "{ command -v xdg-open >/dev/null 2>&1 && xdg-open " + quote(target) + "; } || true")

def _names(kind):
    """The secrets the account's Triage workflow signs in with, from the reference's files_from account's template."""
    reference = yaml.decode(data = read_text(extension_dir() + "/reference/" + kind + ".yaml"))
    source = reference.get("files_from")
    template = read_file(source + "/.github", TEMPLATE) if source else None
    if template == None:
        fail("the " + kind + " reference names no account whose .github repository holds the Triage workflow template")
    return secrets_of(template)

def _locator(vault, account, name):
    """A secret's vault name and its source: (<account>--<NAME>, vault:<vault>/<account>--<NAME>)."""
    held = account + "--" + name.replace("_", "-")
    return held, "vault:" + vault + "/" + held

def _has(vault, name):
    """Whether the vault holds a secret az can read, its value never read."""
    return _ok("az keyvault secret show --vault-name " + quote(vault) + " --name " + quote(name) + " --query id -o tsv")

def _tag(vault, name, tag):
    """A tag of a vault secret, which holds no secret, or ""."""
    return sh("az keyvault secret show --vault-name " + quote(vault) + " --name " + quote(name) + " --query " +
              quote("tags.\"" + tag + "\"") + " -o tsv 2>/dev/null || true").strip()

def _store(vault, name, value, tags, expires = None):
    """Stores the value a shell command writes in the vault, and checks the vault's copy by hash.

    The value stays in the shell, in a file only its owner reads for the moment it takes, and never enters Starlark.
    """
    tagged = " ".join([quote(k + "=" + v) for k, v in tags.items() if v])
    when = (" --expires " + quote(expires)) if expires else ""
    script = ("umask 077; f=\"$(mktemp)\" || exit 1; r=stored; " +
              value + " | " + CLEAN + " >\"$f\"; " +
              "if [ ! -s \"$f\" ]; then r=empty; " +
              "elif ! az keyvault secret set --vault-name " + quote(vault) + " --name " + quote(name) +
              " --file \"$f\" " +
              "--encoding utf-8 --tags " + tagged + when + " -o none >/dev/null 2>&1; then r=refused; " +
              "else a=\"$(az keyvault secret show --vault-name " + quote(vault) + " --name " + quote(name) +
              " --query value -o tsv | " + CLEAN + " | " + _SHA + ")\"; b=\"$(cat \"$f\" | " + _SHA + ")\"; " +
              "[ \"$a\" = \"$b\" ] || r=different; fi; rm -f \"$f\"; echo \"$r\"")
    result = sh(script).strip()
    why = {
        "empty": "its source gave no value",
        "refused": "az refused to store it",
        "different": "the vault's copy doesn't match the value",
    }
    if result != "stored":
        fail("nothing more was done: " + vault + "/" + name + " was not stored: " + why.get(result, result))

def _record(account, kind, action, step, vault, names, extra = {}):
    """What a run returns: what it did, the next step, and the token record once the token is complete."""
    out = {"account": account, "kind": KIND[kind], "action": action, "next": step}
    if action in ["adopted", "stored"]:
        out["token"] = {"kind": KIND[kind], "secrets": {n: _locator(vault, account, n)[1] for n in names}}
    return dict(out, **extra)

def _manifest(account):
    """The app's manifest as GitHub's manifest flow takes it, its permissions from the extension's template."""
    template = json.decode(data = read_text(extension_dir() + "/templates/automation-app.json"))
    home = "https://github.com/" + account
    return dict(
        template,
        name = account.lower() + "-automation",
        url = home,
        redirect_url = home,
        hook_attributes = {"url": home, "active": False},
    )

def _start_app(account, vault, names):
    """The first run for an organization: the manifest, and a local page that posts it to GitHub, opened."""
    folder = _state(account)
    state = sh("od -An -N16 -tx1 /dev/urandom | tr -d ' \\n'").strip()
    sh("printf %s " + quote(state) + " > " + quote(folder + "/state"))
    manifest = json.encode(_manifest(account))
    action = "https://github.com/organizations/" + account + "/settings/apps/new?state=" + state
    page = ("<!doctype html><meta charset=\"utf-8\"><title>" + account + "'s automation app</title>" +
            "<form id=\"f\" method=\"post\" action=\"" + action + "\">" +
            "<input type=\"hidden\" name=\"manifest\" value=\"" +
            manifest.replace("&", "&amp;").replace("\"", "&quot;") + "\"><button>Create " + account +
            "'s automation app on GitHub</button></form><script>document.getElementById(\"f\").submit()</script>")
    path = folder + "/manifest.html"
    sh("printf %s " + quote(page) + " > " + quote(path))
    _open(path)
    return _record(account, "organization", "started", (
        "confirm on GitHub, which then shows " + account + "'s page with code= in its address, good for one hour; " +
        "put that address in a variable, read -rs CODE && export CODE, and run: star github token make " + account +
        " --vault " + vault + " --code env:CODE"
    ), vault, names, {"page": path})

def _exchange(account, vault, names, code):
    """The second run for an organization: the code exchanged, the app's values stored, its install page opened."""
    folder = _state(account)
    app_id, key = names
    id_file, key_file = folder + "/" + app_id, folder + "/" + key + ".pem"
    if _ok("[ -s " + quote(key_file) + " ]"):
        fail(key_file + " holds a key a run stored no copy of: store it with star github token make " + account +
             " --vault " + vault + " --from file:" + key_file + ", or remove the file to start again")
    script = (
        "umask 077; v=\"$(" + reader(code) + " | " + CLEAN + ")\"; " +
        "case \"$v\" in *code=*) code=\"$(printf %s \"$v\" | sed -n 's/.*[?&]code=\\([^&#]*\\).*/\\1/p')\"; " +
        "state=\"$(printf %s \"$v\" | sed -n 's/.*[?&]state=\\([^&#]*\\).*/\\1/p')\" ;; " +
        "*) code=\"$v\" state=\"\" ;; esac; " +
        "if [ -n \"$state\" ] && [ \"$state\" != \"$(cat " + quote(folder + "/state") + " 2>/dev/null)\" ]; " +
        "then echo state; exit 0; fi; " +
        "gh api -X POST \"app-manifests/$code/conversions\" > " + quote(folder + "/conversion.json") +
        " 2>/dev/null || { echo refused; exit 0; }; " +
        "jq -j .pem " + quote(folder + "/conversion.json") + " > " + quote(key_file) + " && " +
        "jq -j .id " + quote(folder + "/conversion.json") + " > " + quote(id_file) + " && " +
        "jq -r '.slug' " + quote(folder + "/conversion.json") + " && rm -f " + quote(folder + "/conversion.json")
    )
    slug = sh(script).strip()
    if slug == "state":
        fail("nothing was done: the address's state isn't the one the first run made; start again with star github " +
             "token make " + account + " --vault " + vault)
    if slug == "refused" or slug == "":
        fail("nothing was done: GitHub refused the code; a code is good once, for an hour. Start again with star " +
             "github token make " + account + " --vault " + vault)
    tags = {"github-account": account, "app-slug": slug}
    for name, path in [(app_id, id_file), (key, key_file)]:
        held, _ = _locator(vault, account, name)
        _store(vault, held, "cat " + quote(path), dict(tags, secret = name))
    sh("rm -f " + quote(id_file) + " " + quote(key_file))
    install = "https://github.com/apps/" + slug + "/installations/new"
    _open(install)
    return _record(account, "organization", "created", (
        "install the app on all of " + account + "'s repositories, then run: star github token make " + account +
        " --vault " + vault
    ), vault, names, {"app": slug, "install": install})

def _installed(account, vault, app_id):
    """Whether the app whose ID the vault holds is installed on the organization, the ID kept in the shell."""
    return installed(account, _locator(vault, account, app_id)[1])

def _organization(account, vault, names, code, source, replace):
    """An organization's token: made from a manifest, its key stored from a source, or adopted."""
    if len(names) != 2 or not names[0].endswith("_ID") or not names[1].endswith("_PRIVATE_KEY"):
        fail("the organization's Triage workflow template signs in with " + ", ".join(names) +
             ", not an app's ID and private key")
    app_id, key = names
    if code:
        return _exchange(account, vault, names, code)
    have = [n for n in names if _has(vault, _locator(vault, account, n)[0])]
    if source:
        if app_id not in have:
            fail("nothing was done: the vault holds no app ID for " + account + "; start with star github token make " +
                 account + " --vault " + vault)
        held, _ = _locator(vault, account, key)
        _store(vault, held, reader(source), {
            "github-account": account,
            "secret": key,
            "app-slug": _tag(vault, _locator(vault, account, app_id)[0], "app-slug"),
        })
        have = names
    if len(have) == 2 and not replace:
        slug = _tag(vault, _locator(vault, account, app_id)[0], "app-slug")
        if not _installed(account, vault, app_id):
            install = ("https://github.com/apps/" + slug + "/installations/new") if slug else "the app's page on GitHub"
            return _record(account, "organization", "not-installed", (
                "install the app on all of " + account + "'s repositories, at " + install + ", then run this again"
            ), vault, names, {"app": slug})
        return _record(account, "organization", "adopted" if not source else "stored", (
            "put the token record in " + account + "'s model, or name it with --token, and run star github model apply"
        ), vault, names, {"app": slug})
    if len(have) == 1 and not replace:
        lost = [n for n in names if n not in have][0]
        step = ("generate a new private key on the app's page, then run: star github token make " + account +
                " --vault " +
                vault + " --from file:<key>.pem") if lost == key else ("the vault holds the key and no app ID; store " +
                                                                       "the ID by hand, or start again with --replace")
        return _record(account, "organization", "incomplete", step, vault, names, {"missing": lost})
    return _start_app(account, vault, names)

def _inspect(value):
    """What GitHub says of a classic token: its login, its scopes and its expiry; the token kept in the shell."""
    out = sh("GH_TOKEN=\"$(" + value + " | " + CLEAN + ")\" gh api -i user 2>/dev/null | tr -d '\\r' || true")
    cut = out.find("\n\n")
    head, body = (out[:cut], out[cut + 2:]) if cut >= 0 else (out, "")
    headers = {}
    for line in head.split("\n")[1:]:
        if ":" in line:
            k, v = line.split(":", 1)
            headers[k.strip().lower()] = v.strip()
    record = json.decode(data = body) if body.strip().startswith("{") else {}
    return {
        "login": record.get("login"),
        "scopes": [s.strip() for s in (headers.get("x-oauth-scopes") or "").split(",") if s.strip()],
        "expires": headers.get("github-authentication-token-expiration"),
    }

def _iso(expires):
    """GitHub's token expiry, 2026-12-20 06:00:00 UTC, as Key Vault takes one, 2026-12-20T06:00:00Z; None if not so."""
    parts = (expires or "").split(" ")
    if len(parts) == 3 and parts[2] == "UTC" and len(parts[0]) == 10 and len(parts[1]) == 8:
        return parts[0] + "T" + parts[1] + "Z"
    return None

def _user(account, vault, names, source, replace):
    """A user account's token: checked and stored from a source, adopted from the vault, or its page opened."""
    if len(names) != 1:
        fail("the user account's Triage workflow template signs in with " + ", ".join(names) + ", not one token")
    name = names[0]
    held, located = _locator(vault, account, name)
    value = reader(source) if source else (reader(located) if _has(vault, held) and not replace else None)
    if value == None:
        page = ("https://github.com/settings/tokens/new?scopes=" + ",".join(_SCOPES) + "&description=" +
                (name + " for " + account + "'s Triage workflow").replace(" ", "%20").replace("'", "%27"))
        _open(page)
        return _record(account, "user", "started", (
            "signed in to GitHub as " + account + ", generate the token, put it in a variable, " +
            "read -rs TOKEN && export " +
            "TOKEN, and run: star github token make " + account + " --vault " + vault + " --from env:TOKEN"
        ), vault, names, {"page": page})
    seen = _inspect(value)
    if seen["login"] != account:
        fail("nothing was stored: the token belongs to " + str(seen["login"]) + ", not " + account +
             "; make it signed in as " + account)
    short = [s for s in _SCOPES if s not in seen["scopes"]]
    if short:
        scopes = " and ".join(short) + " scope" + ("s" if len(short) > 1 else "")
        fail("nothing was stored: the token lacks the " + scopes +
             "; it has " + (", ".join(seen["scopes"]) or "none"))
    if source:
        tags = {"github-account": account, "secret": name, "expires": seen["expires"]}
        _store(vault, held, value, tags, _iso(seen["expires"]))
    return _record(account, "user", "stored" if source else "adopted", (
        "put the token record in " + account + "'s model, or name it with --token, and run star github model apply"
    ), vault, names, {"expires": seen["expires"]})

def run(_command, ctx):
    """Make, store or adopt the account's issue-tracking token, and return what was done and the next step.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account, --vault, --code, --from and --replace.
    """
    account = (ctx.args.get("account") or "").strip()
    vault = (ctx.args.get("vault") or "").strip()
    if account == "" or vault == "":
        fail("name the account and the vault: star github token make <account> --vault <vault>")
    refuse_dry_run(ctx.dry_run)
    sources = {}
    for flag in ["code", "from"]:
        named = parse(ctx.args.get(flag) or "")
        if len(named) > 1 or (named and named[0][0] != ""):
            fail("--" + flag + " takes one source, env:<NAME> or file:<path>, and no secret's name")
        if named:
            if named[0][1].startswith("vault:"):
                fail("--" + flag + " takes env:<NAME> or file:<path>: the value is going into the vault")
            found = problem(named[0][1])
            if found:
                fail("--" + flag + " " + found)
            sources[flag] = named[0][1]
    if not _ok("az account show -o none"):
        fail("az is not signed in to Azure; run az login")
    kind = owner_kind(account)
    scopes = ["admin:org"] if kind == "organization" else ["repo"]
    check_access("star github token make", scopes = scopes, dry_run = ctx.dry_run)
    names = _names(kind)
    replace = ctx.args.get("replace") in [True, "true"]
    if kind == "organization":
        return [_organization(account, vault, names, sources.get("code"), sources.get("from"), replace)]
    if sources.get("code"):
        fail("--code is an organization's: a user account's token comes with --from")
    return [_user(account, vault, names, sources.get("from"), replace)]
