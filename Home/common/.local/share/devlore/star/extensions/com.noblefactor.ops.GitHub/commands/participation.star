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
# signs in with are set, on the repository or, in an organization, on the organization. diff reports what is missing or
# different; apply lands files through pull requests, and sets the variable and the secrets.

load("commands/model.star", "escape", "quote", "rest", "sh")
load("commands/pull.star", "comment", "commit_files", "default_branch", "land", "signer")
load("commands/tokens.star", "fingerprint", "set_secret")

# Where a repository's Triage workflow lives, the template it is copied from, and the variable naming its project.
WORKFLOW = ".github/workflows/triage.yml"
TEMPLATE = "workflow-templates/triage.yml"
VARIABLE = "TRIAGE_PROJECT_URL"

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

def _secrets_of(template):
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

def _repository_secrets(repository):
    """The names of a repository's own secrets."""
    out = sh("gh secret list --repo " + quote(repository) + " --json name --jq " + quote(".[].name"))
    return [n for n in out.split("\n") if n != ""]

def _organization_secrets(organization):
    """An organization's secrets: {name: visibility}."""
    out = sh("gh secret list --org " + quote(organization) + " --json name,visibility")
    return {s["name"]: (s.get("visibility") or "").lower() for s in json.decode(data = out or "[]")}

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
      {workflow, variable, project, url, secrets: [name]}}, organization_secrets: {name: visibility}}.
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
    out["secrets"] = _secrets_of(out["template"])
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
            "secrets": _repository_secrets(r),
        }
    if kind == "organization":
        out["organization_secrets"] = _organization_secrets(account)
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
    """One record for each file, workflow, variable and secret the account lacks, or holds differently."""
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
    if kind == "organization":
        held = state["organization_secrets"]
        for name in state["secrets"]:
            everywhere = state["repositories"] and all([name in h["secrets"] for h in state["repositories"].values()])
            want = {"name": name, "visibility": "all"}
            if name in held and held[name] != "all":
                out.append(_record("secret", account + "/" + name, {"name": name, "visibility": held[name]}, want))
            elif name not in held and not everywhere:
                out.append(_record("secret", account + "/" + name, None, want))
        return out
    for r in sorted(state["repositories"]):
        for name in state["secrets"]:
            if name not in state["repositories"][r]["secrets"]:
                out.append(_record("secret", r + "/" + name, None, {"name": name}))
    return out

# ── applying ────────────────────────────────────────────────────────────────

def _land(repository, base, branch, files, title, summary, done, records):
    """Commits files on a branch, lands them through a pull request, removes the branch, and records each record's action."""
    sha = commit_files(repository, base, branch, files, title)
    body = "## Summary\n\n" + summary + "\n\nSigned-off-by: " + signer()
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
    """Each secret the template signs in with: set from --token, or named as a step by hand."""
    for r in [r for r in records if r["kind"] == "secret"]:
        name = r["model"]["name"]
        where = r["path"][:-len("/" + name)]
        source = c["tokens"].get(name)
        if source == None:
            scope = ("--org " + where + " --visibility all") if c["kind"] == "organization" else ("--repo " + where)
            command = "gh secret set " + name + " " + scope
            done["secret " + r["path"]] = ("by-hand", {"steps": ["set the secret " + name + ", which the Triage workflow signs in " +
                                                                 "with, from a source only you can read: " + command]})
            continue
        if c["kind"] == "organization":
            set_secret(name, source, organization = where)
        else:
            set_secret(name, source, repository = where)
        done["secret " + r["path"]] = ("created" if r["change"] == "missing" else "changed", {"fingerprint": fingerprint(source)})

def apply(c, state, records, done):
    """What apply writes beyond the model, in the order each needs the last: the files, the workflows, the variables, the secrets."""
    if state == None:
        return
    _files(c, state, records, done)
    _workflows(state, records, done)
    _variables(c, records, done)
    _secrets(c, records, done)
