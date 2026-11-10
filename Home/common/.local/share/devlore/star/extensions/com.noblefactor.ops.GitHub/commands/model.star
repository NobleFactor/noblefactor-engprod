# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""An account's data model, read from GitHub: the only definitive model there is (ruled 2026-11-09, #426).

docs/architecture/issue-data-model/6-the-asset-and-its-sync.md. read_model enumerates what GitHub holds for an account,
piece by piece, when a command needs it: an organization's issue types, issue fields, teams with the repositories each
maintains, the hub's labels and its projects; a user account's type labels and the labels of the repositories it owns
that carry the topic issue-model, and its projects. star github model get returns it; scheme.star derives from it what
the report and the sweep place issues by. Nothing here keeps a copy. The pieces are read one at a time; reading them in
parallel, through a graph, is a follow-up of its own. This module loads nothing, and nothing it reads is a file but the
extension's reference models.
"""

# model.star

EXTENSION = "com.noblefactor.ops.GitHub"
MODEL_VERSION = 1

# The hub repository, whose labels are an organization's record of them.
HUB = "noblefactor-engprod"

# A user account's repository takes part in the model when it carries this topic (section 6, § Reference models).
TOPIC = "issue-model"

# A collection type's description begins with this, and a collection has no level (section 6, `types`).
COLLECTION = "Collection:"

# The project field types the model records; GitHub's own (title, assignees, labels, linked pull requests, milestone,
# repository, reviewers, parent issue, sub-issue progress, tracks) are every project's and say nothing of the model.
FIELD_TYPES = {"SINGLE_SELECT": "single-select", "TEXT": "text", "NUMBER": "number", "DATE": "date", "ITERATION": "iteration"}

# The issue field types the model records.
ISSUE_FIELD_TYPES = {"SINGLE_SELECT": "single-select", "TEXT": "text", "NUMBER": "number", "DATE": "date"}

# ── the shell ───────────────────────────────────────────────────────────────

# star's --dry-run skips every shell.exec, reads with writes, until NobleFactor/devlore-cli#1170 lands, and a skipped read
# answers empty, not None: so a command that reads the model refuses --dry-run before it reads (refuse_dry_run).
_DRY_RUN = "star's --dry-run skips every read until NobleFactor/devlore-cli#1170 lands, so the model cannot be read from GitHub under it"

def refuse_dry_run(dry_run):
    """Fails, naming devlore-cli#1170, when star's --dry-run is on: no read of the model can run under it yet."""

    # TODO(NobleFactor/devlore-cli#1170): remove once a dry run runs the reads; the model is then read, and nothing written.
    if dry_run:
        fail(_DRY_RUN)

def sh(command):
    """A shell command's standard output.

    shell.exec raises on a non-zero exit (devlore-cli#824); this fails naming devlore-cli#1170 when star's --dry-run
    skipped the command.
    """
    r = shell.exec(command = command)
    if r == None:
        fail(_DRY_RUN)
    return r.stdout

def quote(s):
    """s as one single-quoted shell word."""
    return "'" + s.replace("'", "'\\''") + "'"

def extension_dir():
    """The deployed extension's directory: ${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/<extension>."""
    return sh('printf %s "${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/' + EXTENSION + '"')

def read_text(path):
    """A file's text."""
    return sh("cat " + quote(path))

# ── reading GitHub ──────────────────────────────────────────────────────────

def conditional_get(path, etag):
    """GET a REST path, sending etag as If-None-Match when there is one: {"status", "etag", "body"}; body is None on 304."""
    header = ("-H " + quote("If-None-Match: " + etag) + " ") if etag else ""

    # gh exits 1 on a 304, and prints its headers on standard output with -i either way.
    out = sh("gh api -i " + header + quote(path) + " 2>/dev/null; true").replace("\r", "")
    cut = out.find("\n\n")
    head = out[:cut] if cut >= 0 else out
    body = out[cut + 2:] if cut >= 0 else ""
    lines = head.split("\n")
    parts = lines[0].split(" ")
    if len(parts) < 2 or not parts[1].isdigit():
        fail("gh api " + path + ": no HTTP status in its answer: " + lines[0])
    status = int(parts[1])
    new_etag = etag
    for line in lines[1:]:
        if line.lower().startswith("etag:"):
            new_etag = line[len("etag:"):].strip()
    if status == 304:
        return {"status": 304, "etag": etag, "body": None}
    if status != 200:
        fail("gh api " + path + ": HTTP " + str(status) + ": " + body.strip())
    return {"status": 200, "etag": new_etag, "body": json.decode(data = body)}

def graphql(query):
    """A GraphQL query's data, failing on GitHub's errors."""
    out = json.decode(data = sh("gh api graphql -f query=" + quote(query)))
    if out.get("errors"):
        fail("GitHub refused a query: " + json.encode(out["errors"]))
    return out.get("data") or {}

def owner_kind(login):
    """Whether an account is an organization or a user, as GitHub answers for it: "organization" or "user"."""
    t = sh("gh api graphql -f query=" + quote("query starOwner { repositoryOwner(login: \"" + login + "\") { __typename login } }") +
           " --jq .data.repositoryOwner.__typename").strip()
    if t == "Organization":
        return "organization"
    if t == "User":
        return "user"
    fail(login + " is neither an organization nor a user on GitHub: " + t)

def read_projects(login, kind):
    """The account's projects with their fields and options, or None when the token cannot read projects."""
    query = ("query starProjects { " + kind + "(login: \"" + login + "\") { projectsV2(first: 50) { nodes { id number title template closed " +
             "fields(first: 50) { nodes { ... on ProjectV2FieldCommon { id name dataType } " +
             "... on ProjectV2SingleSelectField { options { id name } } } } } } } }")
    out = sh("gh api graphql -f query=" + quote(query) + " 2>/dev/null; true")
    if not out.strip().startswith("{"):
        return None
    data = json.decode(data = out)
    if data.get("errors") or not data.get("data") or not data["data"].get(kind):
        return None
    projects = []
    for node in data["data"][kind]["projectsV2"]["nodes"]:
        if node.get("closed"):
            continue
        fields = []
        for f in node["fields"]["nodes"]:
            field_type = FIELD_TYPES.get(f.get("dataType", ""))
            if field_type == None:
                continue
            field = {"name": f["name"], "id": f["id"], "type": field_type}
            if field_type == "single-select":
                field["options"] = [{"name": o["name"], "id": o["id"]} for o in f.get("options", [])]
            fields.append(field)
        projects.append({"name": node["title"], "id": node["id"], "number": int(node["number"]), "template": bool(node["template"]), "fields": fields})
    return sorted(projects, key = lambda p: p["number"])

def read_organization(org):
    """An organization's issue fields, each with its options, and its teams, each with the repositories it maintains."""
    query = ("query starOrganizationModel { organization(login: \"" + org + "\") { " +
             "issueFields(first: 50) { nodes { __typename ... on IssueFieldCommon { name dataType } " +
             "... on IssueFieldSingleSelect { id options { id name } } ... on IssueFieldText { id } " +
             "... on IssueFieldNumber { id } ... on IssueFieldDate { id } } } " +
             "teams(first: 100) { nodes { name slug id repositories(first: 100) { edges { permission node { nameWithOwner } } } } } } }")
    node = graphql(query).get("organization") or {}
    fields = []
    for f in (node.get("issueFields") or {}).get("nodes") or []:
        field_type = ISSUE_FIELD_TYPES.get(f.get("dataType", ""))
        if field_type == None:
            continue
        field = {"name": f["name"], "id": f["id"], "type": field_type}
        if field_type == "single-select":
            field["options"] = [{"name": o["name"], "id": o["id"]} for o in f.get("options") or []]
        fields.append(field)
    teams = []
    for t in (node.get("teams") or {}).get("nodes") or []:
        maintained = [e["node"]["nameWithOwner"] for e in (t.get("repositories") or {}).get("edges") or [] if e.get("permission") == "MAINTAIN"]
        teams.append({"name": t["name"], "slug": t["slug"], "id": t["id"], "repositories": sorted(maintained)})
    return fields, sorted(teams, key = lambda t: t["slug"])

def _reference_types():
    """The reference model's types for a user account, by label: each one's name and whether it is the unplanned one."""
    ref = yaml.decode(data = read_text(extension_dir() + "/reference/user.yaml")) or {}
    out = {}
    for i, t in enumerate(ref.get("types") or []):
        if type(t) == "dict" and t.get("label"):
            out[t["label"]] = {"name": t["name"], "unplanned": bool(t.get("unplanned")), "order": i}
    return out

def _unplanned_names():
    """The organization reference model's unplanned types, by name.

    GitHub's issue types carry no such mark, so the reference says which type is the one found rather than planned, as
    the user reference does by label.
    """
    ref = yaml.decode(data = read_text(extension_dir() + "/reference/organization.yaml")) or {}
    return [t["name"] for t in (ref.get("types") or []) if type(t) == "dict" and t.get("unplanned")]

def read_user(login):
    """A user account's type labels, as types, and the labels of each repository it owns that carries the topic issue-model.

    A type label is one whose description begins "Level N:" or "Collection:", the convention an organization's types
    follow; each is named as the user account's reference model names it, and the first repository's, in name order,
    stands for a label several carry.
    """
    query = ("query starUserModel { user(login: \"" + login + "\") { repositories(first: 100, ownerAffiliations: OWNER) { nodes { " +
             "nameWithOwner repositoryTopics(first: 20) { nodes { topic { name } } } labels(first: 100) { nodes { id name color description } } } } } }")
    node = graphql(query).get("user") or {}
    repos = []
    for r in (node.get("repositories") or {}).get("nodes") or []:
        if TOPIC in [t["topic"]["name"] for t in (r.get("repositoryTopics") or {}).get("nodes") or []]:
            repos.append(r)
    repos = sorted(repos, key = lambda r: r["nameWithOwner"])
    reference = _reference_types()
    types = []
    seen = {}
    for r in repos:
        for label in (r.get("labels") or {}).get("nodes") or []:
            description = label.get("description") or ""
            if label["name"] in seen or (level_of(description) == None and not description.startswith(COLLECTION)):
                continue
            seen[label["name"]] = True
            ref = reference.get(label["name"]) or {"name": label["name"], "unplanned": False, "order": 1000}
            types.append({
                "id": label["id"],
                "name": ref["name"],
                "label": label["name"],
                "color": label.get("color") or "",
                "description": description,
                "unplanned": ref["unplanned"],
                "order": ref["order"],
            })
    repositories = {}
    for r in repos:
        repositories[r["nameWithOwner"]] = sorted([label_entry(g) for g in (r.get("labels") or {}).get("nodes") or []], key = lambda g: g["name"].lower())
    labels = {"organization": [], "teams": {}, "repositories": repositories}
    return sorted(types, key = lambda t: t["order"]), labels

def level_of(description):
    """The N of a description that begins "Level N:", or None."""
    d = (description or "").strip()
    if not d.startswith("Level "):
        return None
    rest = d[len("Level "):]
    colon = rest.find(":")
    if colon <= 0 or not rest[:colon].isdigit():
        return None
    return int(rest[:colon])

def _id(v):
    """A type's id as the asset holds it: a whole number as an int, since encoding/json decodes every number as a float."""
    if type(v) == "float":
        return int(v)
    return v

def merge_types(old, github, notes, conflicts):
    """A model's types brought to GitHub's, matched by id: renames kept as renames, levels from the descriptions.

    A type whose description begins "Level N:" is of the hierarchy, at that level; one whose description begins
    "Collection:" is a collection, with no level; any other is a conflict, and read_model stops, naming it.
    """
    by_id = {str(_id(t["id"])): t for t in old}
    seen = {}
    merged = {}
    for g in github:
        if not g.get("is_enabled", True):
            continue
        tid = str(_id(g["id"]))
        seen[tid] = True
        description = g.get("description") or ""
        level = level_of(description)
        o = by_id.get(tid)
        if level == None and not description.startswith(COLLECTION):
            conflicts.append("type " + g["name"] + " (" + tid + "): its description begins neither \"Level N:\" nor \"" + COLLECTION + "\": " + description)
            continue
        if o != None and o.get("level") != None and level != None and int(o["level"]) != level:
            conflicts.append("type " + g["name"] + " (" + tid + "): its description says level " + str(level) + "; the asset says " + str(o["level"]))
            continue
        t = {"name": g["name"], "id": _id(g["id"])}
        if g.get("label"):
            t["label"] = g["label"]
        if level != None:
            t["level"] = level
        if (o != None and o.get("unplanned")) or g.get("unplanned"):
            t["unplanned"] = True
        t["color"] = g.get("color") or ""
        t["description"] = description
        what = "level " + str(level) if level != None else "a collection"
        if o == None:
            notes.append("type " + g["name"] + " added, " + what)
        elif o["name"] != g["name"]:
            notes.append("type renamed " + o["name"] + " to " + g["name"] + ", id " + tid + ", " + what + " kept")
        merged[tid] = t
    out = [merged[str(_id(t["id"]))] for t in old if str(_id(t["id"])) in merged]
    out.extend([merged[str(_id(g["id"]))] for g in github if str(_id(g["id"])) in merged and str(_id(g["id"])) not in by_id])
    for t in old:
        if str(_id(t["id"])) not in seen:
            notes.append("type " + t["name"] + " removed, id " + str(_id(t["id"])))
    return out

def label_entry(g):
    """A GitHub label in the asset's three fields."""
    return {"name": g["name"], "color": g.get("color") or "", "description": g.get("description") or ""}

# ── the model ───────────────────────────────────────────────────────────────

def read_model(account):
    """The account's data model as GitHub holds it now.

    Its version, its account, its types and labels, its projects, and in an organization its issue fields and teams.

    A type whose description begins neither "Level N:" nor "Collection:" fits no model, and stops the read, named; so does
    a token that cannot read projects, since a model without them would be no backup of the account.
    """
    kind = owner_kind(account)
    model = {"version": MODEL_VERSION, "account": account}
    conflicts = []
    if kind == "organization":
        hub_repo = account + "/" + HUB
        github_types = conditional_get("orgs/" + account + "/issue-types", "")["body"]
        hub = conditional_get("repos/" + hub_repo + "/labels?per_page=100", "")["body"]
        labels = {"organization": [], "teams": {}, "repositories": {hub_repo: sorted([label_entry(g) for g in hub], key = lambda g: g["name"].lower())}}
        fields, teams = read_organization(account)
        model["fields"] = fields
        model["teams"] = teams
    else:
        github_types, labels = read_user(account)
    types = merge_types([], github_types, [], conflicts)
    if conflicts:
        fail(account + "'s model, read from GitHub, does not fit: " + "; ".join(conflicts))
    if kind == "organization":
        unplanned = _unplanned_names()
        types = [dict(t, unplanned = True) if t["name"] in unplanned else t for t in types]
    projects = read_projects(account, kind)
    if projects == None:
        fail(account + "'s projects cannot be read: the token lacks read:project; run gh auth refresh -s read:project")
    model["types"] = types
    model["labels"] = labels
    model["projects"] = projects
    return model
