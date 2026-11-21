# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""What an account needs beyond its model: its .github files, and each participating repository's Triage workflow."""

# participation.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, decision 12, revised 2026-11-10. The files come from the account
# the model comes from, as its .github repository stands: a reference's files_from, or a backup's own account. Every
# file but model.yaml, the account's own, and the Triage workflow, which each participating repository holds as the
# source's template; the source account's name in them becomes the account's, as a reference's {account} does. On the
# account they come from, there is nothing to compare. A participating repository is one a team maintains, or in a user
# account one carrying the topic issue-model: its .github/workflows/triage.yml is the source's
# workflow-templates/triage.yml, its TRIAGE_PROJECT_URL names its team's Triage project, and the secrets the template
# signs in with are set, on the repository or, in an organization, on the organization. Each participating repository
# squash-merges with the pull request's title and description, so that a merge in GitHub carries the description's
# Signed-off-by: and Assisted-by: lines into the commit that lands (#605). diff reports what is missing or different;
# apply lands files through pull requests, and sets the variable, the squash-merge setting and the secrets.

load("commands/model.star", "escape", "quote", "rest", "sh")
load("commands/pull.star", "comment", "commit_files", "default_branch", "disclose", "land", "signer")
load("commands/tokens.star", "fingerprint", "set_secret")

# Where a repository's Triage workflow lives, the template it is copied from, and the variable naming its project.
WORKFLOW = ".github/workflows/triage.yml"
TEMPLATE = "workflow-templates/triage.yml"
VARIABLE = "TRIAGE_PROJECT_URL"

# The squash-merge setting every participating repository has: the pull request's title and description (#605).
SQUASH = {"title": "PR_TITLE", "message": "PR_BODY"}

# The source's files that are not copied: its model, and its own Triage workflow, which WORKFLOW's comparison covers.
_NOT_COPIED = ["model.yaml", WORKFLOW]

# The branches apply lands its changes from, named as NobleFactor's ruleset allows: doc/ for the .github files, feature/
# for a workflow, which is a capability (the owner, 2026-11-10; chore/ retired on 2026-11-03).
_FILES_BRANCH = "doc/issue-model-files"
_WORKFLOW_BRANCH = "feature/triage-workflow"

# ── reading ─────────────────────────────────────────────────────────────────

def _get(path):
    """GET a REST path, a file's contents raw: (status, body), the body byte for byte."""
    out = sh("gh api -i -H " + quote("Accept: application/vnd.github.raw") + " " + quote(path) + " 2>/dev/null; true")
    cut, skip = out.find("\r\n\r\n"), 4
    if cut < 0:
        cut, skip = out.find("\n\n"), 2
    head = out[:cut] if cut >= 0 else out
    parts = head.split("\n")[0].split(" ")
    if len(parts) < 2 or not parts[1].isdigit():
        fail("gh api " + path + ": no HTTP status in its answer: " + head.split("\n")[0])
    return int(parts[1]), (out[cut + skip:] if cut >= 0 else "")

def _read(path):
    """A REST path's body, or None when GitHub has nothing there."""
    status, body = _get(path)
    if status == 404:
        return None
    if status != 200:
        fail("gh api " + path + ": HTTP " + str(status) + ": " + body.strip())
    return body

def read_file(repository, path, ref = None):
    """A file's text in a repository, on ref or its default branch, or None when it holds none."""
    return _read("repos/" + repository + "/contents/" + "/".join([escape(s) for s in path.split("/")]) +
                 (("?ref=" + escape(ref)) if ref else ""))

def _paths(repository, branch):
    """Every file a branch holds, by path."""
    out = sh("gh api " + quote("repos/" + repository + "/git/trees/" + branch + "?recursive=1") + " --jq " +
             quote(".tree[] | select(.type == \"blob\") | .path"))
    return [p for p in out.split("\n") if p != ""]

def secrets_of(template):
    """The secrets a workflow signs in with: each secrets.NAME it names, GitHub's own GITHUB_TOKEN aside."""
    names = []
    for piece in template.split("secrets.")[1:]:
        name = ""
        for c in piece.elems():
            if not (c.isalnum() or c == "_"):
                break
            name += c
        if name != "" and name != "GITHUB_TOKEN" and name not in names:
            names.append(name)
    return names

def _variable(repository):
    """A repository's TRIAGE_PROJECT_URL, or None when it has none."""
    body = _read("repos/" + repository + "/actions/variables/" + VARIABLE)
    return None if body == None else json.decode(data = body).get("value")

def _squash(repository):
    """A repository's squash-merge setting, {title, message}, and whether the token may change it, as admin."""
    body = _read("repos/" + repository)
    record = json.decode(data = body) if body != None else {}
    return {
        "title": record.get("squash_merge_commit_title"),
        "message": record.get("squash_merge_commit_message"),
        "admin": (record.get("permissions") or {}).get("admin") == True,
    }

# What a listing answers in place of its output when GitHub refuses it (#451).
_UNREADABLE = "__star_listing_refused__"

def _listing(command):
    """A listing's output, or None when GitHub refuses it: the signed-in account can't administer what it lists (#451).

    A refused listing is told from an empty one, since a secret missing and a secret that can't be seen are different
    faults with different remedies.
    """
    out = sh("{ " + command + "; } 2>/dev/null || echo " + _UNREADABLE)
    return None if out.strip().endswith(_UNREADABLE) else out

def _repository_secrets(repository):
    """The names of a repository's own secrets, or None when GitHub refuses the listing."""
    out = _listing("gh secret list --repo " + quote(repository) + " --json name --jq " + quote(".[].name"))
    return None if out == None else [n for n in out.split("\n") if n != ""]

def _organization_secrets(organization):
    """An organization's secrets, {name: visibility}, or None when GitHub refuses the listing."""
    out = _listing("gh secret list --org " + quote(organization) + " --json name,visibility")
    if out == None:
        return None
    return {s["name"]: (s.get("visibility") or "").lower() for s in json.decode(data = out or "[]")}

def _reaching(repository):
    """The names of the organization secrets a repository's workflows can read, or None when GitHub refuses the listing.

    An organization secret whose visibility is not all reaches only the repositories it is shared with (#451).
    """
    out = _listing("gh api --paginate " + quote("repos/" + repository + "/actions/organization-secrets") + " --jq " +
                   quote(".secrets[].name"))
    return None if out == None else [n for n in out.split("\n") if n != ""]

def secrets_held(kind, account, repositories, names):
    """What GitHub holds of the secrets a template signs in with, read for every place a workflow reads one (#451).

    Args:
      kind: "organization" or "user".
      account: the account.
      repositories: the participating repositories.
      names: the secrets the template signs in with.

    Returns:
      {repositories: {repo: {secrets: [name] or None, reaching: [name] or None, read only when needed}},
      organization_secrets: {name: visibility} or None, in an organization}.
    """
    out = {"repositories": {r: {"secrets": _repository_secrets(r)} for r in repositories}, "organization_secrets": {}}
    if kind != "organization":
        return out
    held = _organization_secrets(account)
    out["organization_secrets"] = held
    if held != None and any([n in held and held[n] != "all" for n in names]):
        for r in repositories:
            out["repositories"][r]["reaching"] = _reaching(r)
    return out

def bindings(state, kind, account, name):
    """Each place a workflow reads a secret, and whether GitHub holds it there: [(path, "held", "missing" or "unreadable")].

    In a user account, a place is each participating repository's own secret. In an organization, it is the organization
    secret, which must reach each participating repository, or that repository's own secret of the same name; with no
    participating repository, it is the organization secret alone (#451).
    """
    repositories = state.get("repositories") or {}
    if kind != "organization":
        out = []
        for r in sorted(repositories):
            own = repositories[r].get("secrets")
            out.append((r + "/" + name, "unreadable" if own == None else ("held" if name in own else "missing")))
        return out
    held = state.get("organization_secrets")
    if not repositories:
        return [(account + "/" + name, "unreadable" if held == None else ("held" if name in held else "missing"))]
    out = []
    for r in sorted(repositories):
        own = repositories[r].get("secrets")
        path = r + "/" + name
        if own != None and name in own:
            out.append((path, "held"))
        elif held == None:
            out.append((path, "unreadable"))
        elif name not in held:
            out.append((path, "unreadable" if own == None else "missing"))
        elif held[name] == "all":
            out.append((path, "held"))
        else:
            reaching = repositories[r].get("reaching")
            out.append((path, "unreadable" if reaching == None else ("held" if name in reaching else "missing")))
    return out

def project_url(kind, account, number):
    """A project's link, as a workflow's project-url takes it."""
    return "https://github.com/" + ("orgs" if kind == "organization" else "users") + "/" + account + "/projects/" + str(number)

def _owner_of(repository, github, kind):
    """The team that maintains a repository, or the user account: whose Triage project its new issues go to."""
    if kind != "organization":
        return github["account"]
    for t in github.get("teams") or []:
        if repository in (t.get("repositories") or []):
            return t["slug"]
    return None

def read(model, github, projects, kind):
    """What the account holds of what it needs beyond its model, and what it should hold, or None with no source.

    Returns:
      {source, files: {path: text}, held: {path: text or None}, template, secrets: [name], repositories: {repo:
      {workflow, variable, project, url, secrets: [name], squash: {title, message, admin}}}, organization_secrets:
      {name: visibility}}.
    """
    account = github["account"]
    source = model.get("files_from") or model.get("account")
    if not source:
        return None
    origin = source + "/.github"
    if _read("repos/" + origin) == None:
        if model.get("files_from"):
            fail(origin + ", which the reference names for its files, cannot be read: a reference's .github files and Triage " +
                 "workflow template come from it")

        # Another account's model, from an account with no .github repository: nothing to hold this one's to.
        return None
    branch = default_branch(origin)
    paths = _paths(origin, branch)
    out = {"source": source, "files": {}, "held": {}, "template": None, "secrets": [], "repositories": {}, "organization_secrets": {}}
    if source != account:
        target = account + "/.github"
        present = _read("repos/" + target) != None
        for p in paths:
            if p in _NOT_COPIED:
                continue
            out["files"][p] = read_file(origin, p, branch).replace(source, account)
            out["held"][p] = read_file(target, p) if present else None
    if TEMPLATE not in paths:
        return out
    out["template"] = read_file(origin, TEMPLATE, branch)
    out["secrets"] = secrets_of(out["template"])
    by_name = {p["name"]: p for p in projects if not p.get("template")}
    for r in sorted((github.get("labels") or {}).get("repositories") or {}):
        owner = _owner_of(r, github, kind)
        project = ("Triage: " + owner) if owner else None
        number = (by_name.get(project) or {}).get("number")
        out["repositories"][r] = {
            "workflow": read_file(r, WORKFLOW),
            "variable": _variable(r),
            "project": project,
            "url": project_url(kind, account, number) if number != None else None,
            "squash": _squash(r),
        }
    held = secrets_held(kind, account, sorted(out["repositories"]), out["secrets"])
    for r, h in held["repositories"].items():
        out["repositories"][r].update(h)
    out["organization_secrets"] = held["organization_secrets"]
    return out

# ── comparing ───────────────────────────────────────────────────────────────

def _text(text, source = None):
    """A file as a record shows it: its size, and where it comes from; never its text, which the file holds."""
    out = {"bytes": len(text)}
    if source:
        out["source"] = source
    return out

def _record(kind, path, github, model, change = None, by_hand = False):
    """One difference, as reconcile.star records one: missing when GitHub holds nothing, else different."""
    return {
        "kind": kind,
        "path": path,
        "change": change or ("missing" if github == None else "different"),
        "github": github,
        "model": model,
        "by_hand": by_hand,
    }

def compare(state, kind, account):
    """One record for each thing participation needs that the account lacks, or holds differently.

    The things are its files, and each participating repository's workflow, variable, squash-merge setting and secrets.
    """
    out = []
    if state == None:
        return out
    origin = state["source"] + "/.github"
    for p in sorted(state["files"]):
        want, have = state["files"][p], state["held"][p]
        if have != want:
            out.append(_record("file", account + "/.github/" + p, _text(have) if have != None else None, _text(want, origin + "/" + p)))
    template = state["template"]
    if template == None:
        return out
    for r in sorted(state["repositories"]):
        held = state["repositories"][r]
        if held["workflow"] != template:
            have = dict(_text(held["workflow"]), path = WORKFLOW) if held["workflow"] != None else None
            out.append(_record("workflow", r, have, dict(_text(template, origin + "/" + TEMPLATE), path = WORKFLOW)))
        if held["url"] == None or held["variable"] != held["url"]:
            have = {"name": VARIABLE, "value": held["variable"]} if held["variable"] != None else None
            want = {"name": VARIABLE, "value": held["url"], "project": held["project"]}
            out.append(_record("variable", r + "/" + VARIABLE, have, want, by_hand = held["project"] == None))
        have = {"title": held["squash"]["title"], "message": held["squash"]["message"]}
        if have != SQUASH:
            out.append(_record("squash", r, have, dict(SQUASH), by_hand = not held["squash"]["admin"]))
    if kind == "organization":
        held = state["organization_secrets"]
        for name in state["secrets"]:
            places = [s for _, s in bindings(state, kind, account, name)]
            want = {"name": name, "visibility": "all"}
            if all([s == "held" for s in places]):
                continue
            if "unreadable" in places:
                out.append(_record("secret", account + "/" + name, None, want, change = "unreadable"))
            elif name in held:
                out.append(_record("secret", account + "/" + name, {"name": name, "visibility": held[name]}, want))
            else:
                out.append(_record("secret", account + "/" + name, None, want))
        return out
    for name in state["secrets"]:
        for path, s in bindings(state, kind, account, name):
            if s != "held":
                out.append(_record("secret", path, None, {"name": name}, change = "unreadable" if s == "unreadable" else None))
    return out

# ── applying ────────────────────────────────────────────────────────────────

def _land(repository, base, branch, files, title, summary, done, records):
    """Commits files on a branch, lands them through a pull request, removes the branch, and records each record's action."""
    sha = commit_files(repository, base, branch, files, title)
    body = disclose("## Summary\n\n" + summary, signer())
    url, number = land(repository, base, branch, title, body, sha, "the change")
    rest("DELETE", "repos/" + repository + "/git/refs/heads/" + branch)
    comment(repository, number, "Merged; " + branch + " is removed.")
    for r in records:
        done[r["kind"] + " " + r["path"]] = ("created" if r["change"] == "missing" else "changed", {"pull_request": url})

def _files(c, state, records, done):
    """The .github repository's files the account lacks or holds differently, landed through one pull request."""
    mine = [r for r in records if r["kind"] == "file"]
    if not mine:
        return
    account = c["account"]
    target = account + "/.github"
    origin = state["source"] + "/.github"
    if _read("repos/" + target) == None:
        # TODO(NobleFactor/devlore-cli#1219): ask before creating the repository, defaulting to yes (#470).
        sh("gh repo create " + quote(target) + " --public --add-readme --description " +
           quote(account + "'s own repository: its default community health files and its issue model"))
    prefix = target + "/"
    files = {r["path"][len(prefix):]: state["files"][r["path"][len(prefix):]] for r in mine}
    title = "chore: " + account + "'s .github files, from " + origin
    summary = ("`star github model apply`: the files " + account + " needs from " + origin + ", as it stands, " + state["source"] +
               "'s name in them " + account + "'s; its own files are kept.\n\n" + "\n".join(["- `" + p + "`" for p in sorted(files)]))
    _land(target, default_branch(target), _FILES_BRANCH, files, title, summary, done, mine)

def _workflows(state, records, done):
    """Each repository's Triage workflow, the source's template, landed through a pull request on its default branch."""
    origin = state["source"] + "/.github"
    for r in [r for r in records if r["kind"] == "workflow"]:
        title = "chore: the Triage workflow, from " + origin + "'s template"
        summary = ("`star github model apply`: `" + WORKFLOW + "`, " + origin + "'s `" + TEMPLATE + "` as it stands, which adds each new " +
                   "issue to its team's Triage project, named by the `" + VARIABLE + "` variable.")
        _land(r["path"], default_branch(r["path"]), _WORKFLOW_BRANCH, {WORKFLOW: state["template"]}, title, summary, done, [r])

def _variables(c, records, done):
    """Each repository's TRIAGE_PROJECT_URL, set to its team's Triage project, one apply has just made included."""
    for r in [r for r in records if r["kind"] == "variable"]:
        repository = r["path"][:-len("/" + VARIABLE)]
        value = r["model"]["value"]
        if value == None and r["model"]["project"] != None:
            number = c["made"].get(r["model"]["project"])
            value = project_url(c["kind"], c["account"], number) if number != None else None
        if value == None:
            if r["model"]["project"] != None:
                step = "make the " + r["model"]["project"] + " project, then set " + VARIABLE + " on " + repository
            else:
                step = "give " + repository + " a team with the maintain role, whose Triage project " + VARIABLE + " names"
            done["variable " + r["path"]] = ("by-hand", {"steps": [step]})
            continue
        if r["change"] == "missing":
            rest("POST", "repos/" + repository + "/actions/variables", {"name": VARIABLE, "value": value})
        else:
            rest("PATCH", "repos/" + repository + "/actions/variables/" + VARIABLE, {"name": VARIABLE, "value": value})
        done["variable " + r["path"]] = ("created" if r["change"] == "missing" else "changed", {"value": value})

def _squash_merges(records, done):
    """Each repository's squash-merge setting, set to the pull request's title and description, and read back.

    A repository the token can't change, since the setting needs admin, is left to its admin, its record by hand.
    """
    for r in [r for r in records if r["kind"] == "squash"]:
        if r["by_hand"]:
            done["squash " + r["path"]] = ("by-hand", {"steps": [
                "a repository admin sets " + r["path"] + "'s squash merges to the pull request's title and description",
            ]})
            continue
        rest("PATCH", "repos/" + r["path"], {"squash_merge_commit_title": SQUASH["title"], "squash_merge_commit_message": SQUASH["message"]})
        back = _squash(r["path"])
        if {"title": back["title"], "message": back["message"]} != SQUASH:
            fail(r["path"] + "'s squash-merge setting reads back as " + str(back["title"]) + " and " + str(back["message"]) +
                 ", not " + SQUASH["title"] + " and " + SQUASH["message"])
        done["squash " + r["path"]] = ("changed", {"value": dict(SQUASH)})

def token_records(c, state, records):
    """A record for each secret --token sets that the account already holds: diff finds no difference in it, apply replaces it."""
    out = []
    listed = {r["path"]: True for r in records if r["kind"] == "secret"}
    for name in sorted(c["tokens"]):
        if c["kind"] == "organization":
            paths = [c["account"] + "/" + name]
        else:
            paths = [r + "/" + name for r in sorted(state["repositories"])]
        for path in paths:
            if path not in listed:
                out.append(_record("secret", path, {"name": name}, {"name": name, "from": "--token"}))
    return out

def _secrets(c, records, done):
    """Each secret the template signs in with, set from its source: --token's, or the one the model's token record names.

    The preflight has refused an account whose token is not identified, so every secret a record names has a source;
    one recorded as held needs no write, and the preflight has proved it held everywhere (#451).
    """
    for r in [r for r in records if r["kind"] == "secret"]:
        name = r["model"]["name"]
        where = r["path"][:-len("/" + name)]
        source = c["tokens"].get(name) or c["recorded"].get(name)
        if source in [None, "held"]:
            fail(r["path"] + " needs a write, and its token record names no source to write it from")
        if c["kind"] == "organization":
            set_secret(name, source, organization = where)
        else:
            set_secret(name, source, repository = where)
        done["secret " + r["path"]] = ("created" if r["change"] == "missing" else "changed", {"fingerprint": fingerprint(source)})

def apply(c, state, records, done):
    """What apply writes beyond the model, in the order each needs the last.

    The order is the files, the workflows, the variables, the squash-merge settings, the secrets.
    """
    if state == None:
        return
    _files(c, state, records, done)
    _workflows(state, records, done)
    _variables(c, records, done)
    _squash_merges(records, done)
    _secrets(c, records, done)
