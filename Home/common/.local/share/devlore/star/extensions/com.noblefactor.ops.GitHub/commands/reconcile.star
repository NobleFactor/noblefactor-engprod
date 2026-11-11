# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A model compared with an account's: what star github model diff reports, and apply and restore make."""

# reconcile.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, Requirement 3. A model is read from a file, the form get returns
# or a reference; a reference is brought to the form get returns first: its label families become labels on each
# repository that takes part, and its templates are reference/templates.yaml's with its kind's additions (decision 14).
# The account's model is read from GitHub with the code get reads it with, leniently, so that a type that fits no model
# is a difference rather than a stop, with every open project of the account, to hold each project of a kind to its
# template (decision 7).
#
# On the same account a thing matches by its ID, so a rename is a rename; across accounts, and against a reference,
# which holds no IDs, by name. Every attribute is compared, whether the model names it or not: a value the model lacks is
# drift against one GitHub holds (the owner, 2026-11-10), so a reference names every attribute.
# A field whose options are each project's own, marked own_options in the common templates, is compared without them.
#
# One record for each difference: kind, path, change (missing: the model has it and GitHub does not; different;
# renamed; extra: GitHub has it and the model does not), what GitHub holds, what the model holds, and by_hand when
# GitHub's API cannot make the change, a view's grouping or sort, or a team.

load("commands/model.star", "extension_dir", "read_account", "read_text")

# The order the records come in, which is the order apply makes them in: each kind after what it depends on.
KINDS = [
    "issue-type",
    "issue-field",
    "issue-field-option",
    "label",
    "template",
    "template-field",
    "template-option",
    "template-view",
    "project",
    "project-field",
    "project-option",
    "project-view",
    "team",
]

# What is compared of each thing, and what of it GitHub's API cannot write.
_TYPE = ["description", "color", "enabled"]
_FIELD = ["type", "description", "visibility"]
_OPTION = ["color", "description", "priority"]
_LABEL = ["color", "description"]
_PROJECT_FIELD = ["type", "issue_field", "configuration"]
_PROJECT_OPTION = ["color", "description"]
_VIEW = ["layout", "filter", "fields"]
_VIEW_BY_HAND = ["group_by", "vertical_group_by", "sort_by"]

# A model on standard input waits on the command provider, which gives an extension's commands standard input.
_STDIN = ("a model on standard input waits on NobleFactor/devlore-cli#1136: star's shell provider gives an extension's " +
          "commands no standard input; name a file")

# ── the model ───────────────────────────────────────────────────────────────

def read_model_file(path):
    """The model a file holds, as a dict: the form get returns, or a reference's."""
    if path == "-":
        # TODO(NobleFactor/devlore-cli#1136): read the model from standard input once the command provider passes it.
        fail(_STDIN)
    m = yaml.decode(data = read_text(path))
    if type(m) != "dict":
        fail(path + " holds no model")
    return m

def is_reference(m):
    """Whether a model is a reference: one holding templates, where the form get returns holds projects."""
    return "templates" in m and "projects" not in m

def _reference(name):
    """One of the extension's reference files, decoded."""
    return yaml.decode(data = read_text(extension_dir() + "/reference/" + name + ".yaml")) or {}

def templates_for(additions):
    """The common templates, reference/templates.yaml's, with a kind's additions.

    A kind adds fields, and views, a view of the same name replacing the common one.
    """
    added = {t["name"]: t for t in additions or [] if type(t) == "dict"}
    out = []
    for t in _reference("templates").get("templates") or []:
        a = added.get(t["name"]) or {}
        views = {}
        order = []
        for v in list(t.get("views") or []) + list(a.get("views") or []):
            if v["name"] not in views:
                order.append(v["name"])
            views[v["name"]] = v
        out.append({
            "name": t["name"],
            "fields": list(t.get("fields") or []) + list(a.get("fields") or []),
            "views": [views[n] for n in order],
        })
    return out

def _own_options():
    """The fields whose options are each project's own, by template and field name, from the common templates."""
    out = {}
    for t in _reference("templates").get("templates") or []:
        for f in t.get("fields") or []:
            if f.get("own_options"):
                out[t["name"] + "/" + f["name"]] = True
    return out

def _label_families(ref):
    """A user reference's labels: each type's, and each of its families', the lists whose entries carry a label.

    A label holds what its entry names; a color or description the reference leaves out is compared as none, and drift.
    """
    out = []
    entries = [t for t in ref.get("types") or [] if type(t) == "dict" and t.get("label")]
    for key in ref:
        if key == "types" or type(ref[key]) != "list":
            continue
        family = [e for e in ref[key] if type(e) == "dict" and e.get("label")]
        if family and len(family) == len(ref[key]):
            entries.extend(family)
    for e in entries:
        label = {"name": e["label"]}
        for a in ["color", "description"]:
            if a in e:
                label[a] = e[a]
        out.append(label)
    return out

def from_reference(ref, github):
    """A reference brought to the form get returns against the account it is compared with.

    Its labels go on each repository of the account that takes part; its templates are the common set with its kind's
    additions.
    """
    user = ref.get("account") == "user"
    m = {"version": ref.get("version") or 1, "reference": True, "files_from": ref.get("files_from")}
    keep = ["name", "label", "level", "unplanned", "color", "description"]
    m["types"] = [{k: t[k] for k in keep if k in t} for t in ref.get("types") or [] if type(t) == "dict"]
    if not user:
        m["fields"] = []
        for f in ref.get("fields") or []:
            field = {k: f[k] for k in ["name", "type", "description", "visibility"] if k in f}
            if "options" in f:
                field["options"] = [{k: o[k] for k in ["name", "color", "description", "priority"] if k in o} for o in f["options"]]
            m["fields"].append(field)
    wanted = _label_families(ref) if user else []
    m["labels"] = {"repositories": {r: wanted for r in sorted((github.get("labels") or {}).get("repositories") or {})}}
    m["label_kinds"] = _label_kinds(wanted)
    m["projects"] = [dict(t, template = not user) for t in templates_for(ref.get("templates"))]
    return m

def _label_kinds(labels):
    """The kinds of label a reference names: each label's prefix up to its colon, and each label with none."""
    out = {}
    for label in labels:
        name = label["name"]
        out[(name.split(":")[0] + ":") if ":" in name else name] = True
    return out

def _of_kind(name, kinds):
    """Whether a label is of a kind a reference names."""
    return name in kinds or ((name.split(":")[0] + ":") in kinds if ":" in name else False)

# ── matching ────────────────────────────────────────────────────────────────

def _key(v):
    """An ID as text, whether GitHub gave it as a number or a string."""
    if type(v) == "float":
        v = int(v)
    return str(v)

def match(model_items, github_items, by_id, key = "name"):
    """Pairs of (model's, GitHub's), either None when the other has no match: by ID first when by_id, then by key."""
    used = {}
    pairs = []
    for m in model_items:
        found = None
        if by_id and m.get("id") != None:
            for i, g in enumerate(github_items):
                if i not in used and g.get("id") != None and _key(g["id"]) == _key(m["id"]):
                    found = i
                    break
        if found == None:
            for i, g in enumerate(github_items):
                if i not in used and g.get(key) == m.get(key):
                    found = i
                    break
        if found != None:
            used[found] = True
            pairs.append((m, github_items[found]))
        else:
            pairs.append((m, None))
    for i, g in enumerate(github_items):
        if i not in used:
            pairs.append((None, g))
    return pairs

def _same(a, b):
    """Whether two values are one: equal, or both empty, so that an absent description is an empty one."""
    if a == b:
        return True
    empty = [None, "", [], {}]
    return a in empty and b in empty

def differs(m, g, attributes):
    """Every attribute whose value differs between the model and GitHub, whether the model names it or not.

    A value the model lacks is drift against one GitHub holds (the owner, 2026-11-10: if the color changed, it drifted).
    """
    return [a for a in attributes if not _same(m.get(a), g.get(a))]

def _slim(v, drop):
    """A thing without the lists a record need not repeat."""
    if v == None:
        return None
    return {k: v[k] for k in v if k not in drop}

def record(kind, path, change, github, model, by_hand = False, drop = []):
    """One difference."""
    return {
        "kind": kind,
        "path": path,
        "change": change,
        "github": _slim(github, drop),
        "model": _slim(model, drop),
        "by_hand": by_hand,
    }

def _compare(out, kind, path, m, g, attributes, by_id, hand = [], drop = []):
    """The record a matched pair makes, if any: renamed when matched by ID under another name, else different."""
    if m == None:
        out.append(record(kind, path, "extra", g, None, drop = drop))
        return
    if g == None:
        out.append(record(kind, path, "missing", None, m, drop = drop))
        return
    if by_id and m.get("id") != None and g.get("id") != None and _key(m["id"]) == _key(g["id"]) and m.get("name") != g.get("name"):
        out.append(record(kind, path, "renamed", g, m, drop = drop))
        return
    writable = differs(m, g, attributes)
    manual = differs(m, g, hand)
    if writable or manual:
        out.append(record(kind, path, "different", g, m, by_hand = not writable, drop = drop))

# ── the comparison ──────────────────────────────────────────────────────────

def _repositories(model, github, same):
    """Pairs of (the model's repository, the account's) for labels: by full name on the same account, else by name."""
    held = (github.get("labels") or {}).get("repositories") or {}
    out = []
    for r in sorted((model.get("labels") or {}).get("repositories") or {}):
        if r in held:
            out.append((r, r))
        elif not same:
            for h in sorted(held):
                if h.split("/")[-1] == r.split("/")[-1]:
                    out.append((r, h))
                    break
    return out

def _options(out, kind, path, mf, gf, by_id, own, renames):
    """The options of a field matched in a template or a project; none when the field's options are each project's own."""
    if own:
        return
    moptions = mf.get("options") or []
    goptions = [dict(o) for o in gf.get("options") or []]
    for o in goptions:
        new = renames.get(o["name"])
        if new != None:
            o["renamed_to"] = new
    pairs = match(moptions, goptions, by_id)
    for mo, go in pairs:
        if mo != None and go == None:
            # An option renamed on the template is renamed on the copy, under its old name.
            old = [g for g in goptions if g.get("renamed_to") == mo["name"]]
            if old:
                out.append(record(kind, path + "/" + old[0]["name"], "renamed", old[0], mo))
                continue
        if mo == None and go != None and go.get("renamed_to") != None:
            continue
        name = (go or mo)["name"]
        _compare(out, kind, path + "/" + name, mo, go, _OPTION if kind == "issue-field-option" else _PROJECT_OPTION, by_id)

def _project(out, prefix, mt, gp, by_id, own, renames, kinds):
    """A template, or a project held to one: its fields, their options, and its views."""
    field_kind, option_kind, view_kind = kinds
    for mf, gf in match(mt.get("fields") or [], gp.get("fields") or [], by_id):
        name = (gf or mf)["name"]
        _compare(out, field_kind, prefix + "/" + name, mf, gf, _PROJECT_FIELD, by_id, drop = ["options"])
        if mf != None and gf != None:
            field_renames = {}
            if mt.get("name") in renames:
                field_renames = renames[mt["name"]].get(name) or {}
            _options(out, option_kind, prefix + "/" + name, mf, gf, by_id, own.get(mt["name"] + "/" + name), field_renames)
    for mv, gv in match(mt.get("views") or [], gp.get("views") or [], False):
        name = (gv or mv)["name"]
        _compare(out, view_kind, prefix + "/" + name, mv, gv, _VIEW, False, hand = _VIEW_BY_HAND)

def _template_renames(out):
    """The options renamed on each template, by template and field: {template: {field: {old: new}}}."""
    renames = {}
    for r in out:
        if r["kind"] == "template-option" and r["change"] == "renamed":
            template, field, _ = r["path"].split("/", 2)
            renames.setdefault(template, {}).setdefault(field, {})[r["github"]["name"]] = r["model"]["name"]
    return renames

def compare(model, github, projects, kind):
    """The records of every difference between a model, in the form get returns, and the account's.

    Args:
      model: the model, a reference brought to the form get returns first.
      github: the account's model as GitHub holds it.
      projects: every open project of the account.
      kind: "organization" or "user".
    """
    same = (model.get("account") == github["account"]) and not model.get("reference")
    out = []

    if kind == "organization":
        for mt, gt in match(model.get("types") or [], github.get("types") or [], same):
            _compare(out, "issue-type", (gt or mt)["name"], mt, gt, _TYPE, same)
        for mf, gf in match(model.get("fields") or [], github.get("fields") or [], same):
            name = (gf or mf)["name"]
            _compare(out, "issue-field", name, mf, gf, _FIELD, same, drop = ["options"])
            if mf != None and gf != None:
                _options(out, "issue-field-option", name, mf, gf, same, False, {})

    kinds = model.get("label_kinds")
    for mr, gr in _repositories(model, github, same):
        mlabels = model["labels"]["repositories"][mr]
        glabels = github["labels"]["repositories"][gr]
        for ml, gl in match(mlabels, glabels, same):
            if ml == None and kinds != None and not _of_kind(gl["name"], kinds):
                continue
            _compare(out, "label", gr + "/" + (gl or ml)["name"], ml, gl, _LABEL, same)

    own = _own_options()
    templates = model.get("projects") or []
    for mt, gt in match(templates, github.get("projects") or [], same):
        name = (gt or mt)["name"]
        _compare(out, "template", name, mt, gt, [], same, drop = ["fields", "views"])
        if mt != None and gt != None:
            _project(out, name, mt, gt, same, own, {}, ("template-field", "template-option", "template-view"))

    renames = _template_renames(out)

    # A team owns projects of each kind when it maintains a repository: a repository takes part when a team maintains
    # it, and its issues reach that team's projects (ruled 2026-11-03). A team that maintains none, an organization's
    # owners, owns none.
    owners = [t["slug"] for t in github.get("teams") or [] if t.get("repositories")] if kind == "organization" else [github["account"]]
    by_name = {p["name"]: p for p in projects if not p.get("template")}
    for mt in templates:
        for owner in owners:
            name = mt["name"] + ": " + owner
            gp = by_name.get(name)
            if gp == None:
                out.append(record("project", name, "missing", None, {"name": name, "template": mt["name"], "owner": owner}))
                continue
            _project(out, name, mt, gp, False, own, renames, ("project-field", "project-option", "project-view"))

    if kind == "organization" and not model.get("reference") and "teams" in model:
        for mt, gt in match(model.get("teams") or [], github.get("teams") or [], same, key = "slug"):
            name = (gt or mt)["slug"]
            change = "missing" if gt == None else ("extra" if mt == None else "different")
            if change != "different" or sorted(mt.get("repositories") or []) != sorted(gt.get("repositories") or []):
                out.append(record("team", name, change, gt, mt, by_hand = True))

    order = {k: i for i, k in enumerate(KINDS)}
    return sorted(out, key = lambda r: (order.get(r["kind"], len(KINDS)), r["path"]))

def differences(path, account):
    """What star github model diff returns.

    The records of every difference between the model a file holds and the account's, read from GitHub now.
    """
    model = read_model_file(path)
    github, projects, kind = read_account(account, strict = False)
    if is_reference(model):
        model = from_reference(model, github)
    return compare(model, github, projects, kind)
