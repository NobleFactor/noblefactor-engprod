# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The issue data model as GitHub holds it for each account, and the label set the labels commands keep."""

# scheme.star
#
# docs/architecture/issue-data-model/6-the-asset-and-its-sync.md. One model per account, and GitHub holds it (ruled
# 2026-11-09, #426): a command that needs an account's model reads it from GitHub when it runs, through model.star's
# read_model, once for each account it touches (models_for), and passes it on. Nothing is read when the module loads, so
# --help and every command that needs no model touch no network; a model that does not fit stops the command that read
# it, its fault named. Nothing below names a type or a field: the hierarchy, the collection types and each record's keys
# are derived from the models (noblefactor-engprod#376, and the part of #426 the report and the sweep need, #436). star
# hands a command no path to its extension, so the deployed path is resolved as writ's layers are, through the shell.

load(
    "commands/accounts.star",
    "ORIGIN",
    _canonical_repo = "canonical_repo",
    _default_account = "default_account",
    _layer_repos = "layer_repos",
)
load("commands/model.star", "read_model")

_EXTENSION = "com.noblefactor.ops.GitHub"
_MODEL_VERSION = 1

# A collection type's description begins with this, and a collection has no level (section 6, `types`).
_COLLECTION = "Collection:"

# accounts.star's, bound here so that the commands that load them from this module still find them.
default_account = _default_account
canonical_repo = _canonical_repo
layer_repos = _layer_repos

# The project kinds each team, and each user account, has four of, named "<Kind>: <team>" in an organization and
# "<Kind>: <account>" in a user account (section 6, `teams`). An issue's home is its row on one of the last three;
# its Triage row sits beside its home (ruled 2026-11-08).
TRIAGE_KIND = "Triage"
HOME_KINDS = ["Backlog", "Schedule", "Scenario"]

# The keys every record carries, whatever its account's model says; a model whose type or field would give a record
# one of these keys a second time is refused.
FIXED_KEYS = [
    "issue",
    "repository",
    "type",
    "title",
    "url",
    "state",
    "state_reason",
    "parent",
    "home",
    "in_triage",
    "sub_issues_total",
    "sub_issues_completed",
    "labels",
    "assignees",
    "blocked_by",
    "projects",
    "created_at",
    "updated_at",
    "closed_at",
]

# ── the models ──────────────────────────────────────────────────────────────

def _sh(command):
    """A shell command's standard output; shell.exec raises on a non-zero exit (devlore-cli#824)."""
    return shell.exec(command = command).stdout

def _quote(s):
    """s as one single-quoted shell word."""
    return "'" + s.replace("'", "'\\''") + "'"

def _extension_dir():
    """The deployed extension's directory: ${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/<extension>."""
    return _sh('printf %s "${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/' + _EXTENSION + '"').strip()

def key_of(name):
    """A record key from a model's name: lower case, each run of other characters one underscore; Target date is target_date."""
    out = ""
    for c in name.lower().elems():
        if c.isalnum():
            out += c
        elif not out.endswith("_"):
            out += "_"
    return out.strip("_")

def _user_attributes():
    """The labels that stand in for an organization's single-select fields in a user account, family by family.

    Read from reference/user.yaml, the user account's reference model (section 6, § Reference models): each list whose
    entries carry a label of the form <family>:<option> is a family, its key the family, each label's value the name
    the reference gives it, so that area:product reads Product, as NobleFactor's Area field does.
    """
    ref = yaml.decode(data = _sh("cat " + _quote(_extension_dir() + "/reference/user.yaml"))) or {}
    families = []
    for section in ref:
        entries = ref[section]
        if type(entries) != "list" or len(entries) == 0:
            continue
        labeled = [e for e in entries if type(e) == "dict" and ":" in str(e.get("label", ""))]
        if len(labeled) != len(entries):
            continue
        families.append({
            "key": key_of(labeled[0]["label"].split(":")[0]),
            "labels": [e["label"] for e in labeled],
            "names": {e["label"]: e["name"] for e in labeled},
        })
    return families

USER_ATTRIBUTES = _user_attributes()

def derive(model):
    """One model checked, with what the hierarchy means and each record's keys derived from it.

    Every type is of the hierarchy, with a level, or a collection, its description beginning "Collection:"; a type that
    is neither is refused, named. A user account's types carry the label that stands for each.
    """
    account = model.get("account") or ""
    name = account + "'s model"
    if model.get("version") != _MODEL_VERSION:
        fail(name + ": version " + str(model.get("version")) + " is not " + str(_MODEL_VERSION) + "; this extension reads version " + str(_MODEL_VERSION))

    hierarchy = []
    collections = []
    for t in model.get("types") or []:
        if type(t) != "dict" or "name" not in t:
            fail(name + ": a type with no name: " + str(t))
        if t.get("level") != None:
            hierarchy.append(dict(t, level = int(t["level"])))
        elif str(t.get("description") or "").startswith(_COLLECTION):
            collections.append(dict(t))
        else:
            fail(name + ": type " + t["name"] + " has no level and is no collection; a type of the hierarchy has the level its description's \"Level N:\" gives, and a collection's description begins \"Collection:\"")
    if len(hierarchy) == 0:
        fail(name + ": no type of the hierarchy")
    levels = sorted({t["level"]: True for t in hierarchy}.keys())
    user = len([t for t in hierarchy + collections if t.get("label")]) > 0
    teams = model.get("teams") or []
    fields = model.get("fields") or []
    labels = model.get("labels") or {}

    if user:
        repositories = sorted(((labels.get("repositories") if type(labels) == "dict" else None) or {}).keys())
        attribute_keys = [f["key"] for f in USER_ATTRIBUTES]
    else:
        repositories = sorted({r: True for t in teams for r in (t.get("repositories") or [])}.keys())
        attribute_keys = [key_of(f["name"]) for f in fields]

    # A key for each level above the last, named for its types: the record names the ancestor of each.
    ancestor_keys = []
    for t in hierarchy:
        k = key_of(t["name"])
        if t["level"] != levels[-1] and k not in ancestor_keys:
            ancestor_keys.append(k)
    seen = {k: "a record's own key" for k in FIXED_KEYS}
    for k in ancestor_keys + attribute_keys:
        if k in seen:
            fail(name + ": the record key " + k + " would be given twice: once as " + seen[k] + ", and again by the model")
        seen[k] = "the model's"

    return {
        "account": account,
        "user": user,
        "hierarchy": hierarchy,
        "collections": collections,
        "levels": levels,
        "fields": fields,
        "teams": teams,
        "repositories": repositories,
        "ancestor_keys": ancestor_keys,
        "attribute_keys": attribute_keys,
    }

def models_for(accounts):
    """Each account's model, read from GitHub now and derived, by account: one read for each account named, once."""
    models = {}
    for account in accounts:
        if account not in models:
            models[account] = derive(read_model(account))
    return models

def model_of(models, account):
    """The account's model among those read; fails, naming the account, when it was not read."""
    if account not in models:
        fail("no model was read for " + account)
    return models[account]

def model_for(models, repo):
    """The model of the account that owns repo, owner/name, among those read."""
    return model_of(models, repo.split("/")[0])

def leaf_level(model):
    """The last level of the model's hierarchy: a schedule's steps are drawn from it."""
    return model["levels"][-1]

def type_named(model, name):
    """The model's type of that name, of the hierarchy or a collection, or None."""
    for t in model["hierarchy"] + model["collections"]:
        if t["name"] == name:
            return t
    return None

def type_of(model, issue_type, label_names):
    """The name of an issue's type: GitHub's issue type in an organization, its type label in a user account; None when it has none the model knows."""
    if model["user"]:
        for t in model["hierarchy"] + model["collections"]:
            if t.get("label") in label_names:
                return t["name"]
        return None
    if type(issue_type) == "dict" and issue_type.get("name") and type_named(model, issue_type["name"]) != None:
        return issue_type["name"]
    return None

def owners_of(model):
    """What the account's project names end with: each team's slug in an organization, the account in a user account."""
    if model["user"]:
        return [model["account"]]
    return [t["slug"] for t in model["teams"]]

def team_of(model, repo):
    """The team that owns repo, by the maintain role, as its slug; the account itself in a user account; None when none does."""
    if model["user"]:
        return model["account"]
    for t in model["teams"]:
        if repo in (t.get("repositories") or []):
            return t["slug"]
    return None

# ── repositories ────────────────────────────────────────────────────────────
#
# canonical_repo and layer_repos are accounts.star's, bound above.

def short(repo):
    """The repository's name without its owner: noblefactor-engprod for NobleFactor/noblefactor-engprod."""
    return repo.split("/")[-1]

def cell(s):
    """A markdown table cell's text: its pipes escaped and its lines joined."""
    return s.replace("|", "\\|").replace("\n", " ")

def _origin_repo(directory):
    """owner/name from the origin remote of a working tree."""
    r = shell.exec(command = "git -C '" + directory + "' remote get-url origin")
    m = regex.find_submatch(pattern = ORIGIN, text = r.stdout)
    if m == None or len(m) < 2:
        fail("cannot read owner/name from the origin of " + directory + ": " + r.stdout.strip())
    return m[1]

def _current_repo():
    """owner/name of the repository the command runs in, as gh resolves it."""
    r = shell.exec(command = "gh repo view --json nameWithOwner --jq .nameWithOwner")
    return r.stdout.strip()

def default_repos():
    """The repositories of writ's layers, or the one the command runs in when no layer is registered."""
    repos = layer_repos()
    return repos if repos else [_current_repo()]

def resolve_repos(repo_flag, directory):
    """The labels commands' repositories: --repo, else --directory's origin, else writ's layers', else the current one."""
    if repo_flag:
        return [canonical_repo(r.strip()) for r in repo_flag.split(",") if r.strip()]
    if directory:
        return [_origin_repo(directory)]
    return default_repos()

# ── the label set every participating repository carries ───────────────────
#
# The labels commands, out of scope for #436, are as they were: they expect the hierarchy's type names, lower-cased, as
# labels, and Epic:Ops:Process, in every repository. Their kinds are the default account's hierarchy types.

def required_everywhere():
    """The labels every participating repository carries.

    The default account's hierarchy types, lower-cased, read from GitHub now, and Epic:Ops:Process.
    """
    account = default_account()
    return [t["name"].lower() for t in models_for([account])[account]["hierarchy"]] + ["Epic:Ops:Process"]

def label_inventory(repos):
    """Every label per repository with its color and description -- one GraphQL request; first 100 per repository."""
    parts = []
    for i, repo in enumerate(repos):
        owner, name = repo.split("/")
        parts.append("r" + str(i) + ": repository(owner: \"" + owner + "\", name: \"" + name + "\") { nameWithOwner labels(first: 100) { totalCount nodes { name color description } } }")
    r = shell.exec(command = "gh api graphql -f query='{ " + " ".join(parts) + " }'")
    data = json.decode(data = r.stdout)["data"]
    out = {}
    for k in data:
        node = data[k]
        if int(node["labels"]["totalCount"]) > 100:
            warn(node["nameWithOwner"] + " has more than 100 labels; only the first 100 were read")
        out[node["nameWithOwner"]] = {label["name"]: {"color": label["color"], "description": label["description"] or ""} for label in node["labels"]["nodes"]}
    return out

def canonical_labels(inv, repos):
    """The expected set and its canonical color and description: the kinds, Epic:Ops:Process, and every thread label, each as first seen in configuration order."""
    expected = {}
    names = required_everywhere()
    threads = {}
    for repo in repos:
        for name in inv.get(repo, {}):
            if name.startswith("Thread:"):
                threads[name] = True
    names.extend(sorted(threads.keys()))
    for name in names:
        for repo in repos:
            if name in inv.get(repo, {}):
                expected[name] = inv[repo][name]
                break
        if name not in expected:
            expected[name] = None
    return expected

def label_faults(inv, repos):
    """Per repository: missing labels, and labels whose color or description differs from the canonical."""
    expected = canonical_labels(inv, repos)
    rows = []
    for repo in repos:
        have = inv.get(repo, {})
        for name in sorted(expected.keys()):
            want = expected[name]
            if want == None:
                rows.append({"repo": repo, "label": name, "status": "absent everywhere", "color": "", "description": ""})
            elif name not in have:
                rows.append({"repo": repo, "label": name, "status": "missing", "color": want["color"], "description": want["description"]})
            elif have[name]["color"] != want["color"] or have[name]["description"] != want["description"]:
                rows.append({"repo": repo, "label": name, "status": "divergent", "color": want["color"], "description": want["description"], "actual_color": have[name]["color"], "actual_description": have[name]["description"]})
    return rows

def label_audit_lines(rows, repos):
    """The audit as a document: one section per repository, or one line when clean."""
    out = ["# Label audit\n", "Repositories: " + ", ".join(repos) + "."]
    if len(rows) == 0:
        out.append("\nEvery repository carries the five kinds, Epic:Ops:Process, and every thread label.")
        return out
    for repo in repos:
        mine = [r for r in rows if r["repo"] == repo]
        if len(mine) == 0:
            continue
        out.append("\n## " + repo + "\n")
        out.append("| Label | Status | Canonical |")
        out.append("|---|---|---|")
        for r in mine:
            canon = ("#" + r["color"] + " " + r["description"]) if r["color"] else ""
            out.append("| `" + r["label"] + "` | " + r["status"] + " | " + cell(canon) + " |")
    return out

def _sh_quote(s):
    """Single-quote a string for sh -c."""
    return "'" + s.replace("'", "'\\''") + "'"

def label_sync(rows, dry_run):
    """Create missing labels and align divergent ones, per the audit rows; never delete. Returns what was done, or would be."""
    done = []
    for r in rows:
        if r["status"] == "missing":
            cmd = "gh label create -R " + r["repo"] + " " + _sh_quote(r["label"]) + " --color " + r["color"] + " --description " + _sh_quote(r["description"])
            action = "create"
        elif r["status"] == "divergent":
            cmd = "gh label edit -R " + r["repo"] + " " + _sh_quote(r["label"]) + " --color " + r["color"] + " --description " + _sh_quote(r["description"])
            action = "align"
        else:
            done.append({"repo": r["repo"], "label": r["label"], "action": "skip", "reason": r["status"]})
            continue
        if dry_run:
            note("would " + action + " " + r["label"] + " in " + r["repo"])
            done.append({"repo": r["repo"], "label": r["label"], "action": action, "dry_run": True})
        else:
            shell.exec(command = cmd)
            note(action + "d " + r["label"] + " in " + r["repo"])
            done.append({"repo": r["repo"], "label": r["label"], "action": action, "dry_run": False})
    return done
