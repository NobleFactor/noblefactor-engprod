# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model apply's writes: each difference diff finds, made in GitHub."""

# apply.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, Requirement 4. apply makes the differences reconcile.star finds,
# in the order its records come in, which keeps every reference whole: issue types, issue fields and their options,
# labels, the templates, each team's projects of a kind, and teams; then what the account needs beyond its model, its
# .github files and each participating repository's Triage workflow, variable and secrets (participation.star, decision
# 12), the variable naming a Triage project made first. It reconciles; it never deletes something to make it again
# (ruled 2026-11-09). On the same account a rename is made in place, by ID; an option list is sent whole, each
# option with its ID, so that no issue or row loses its value. Nothing of the account's is deleted without --prune, and
# with it each deletion first counts what it touches; a team, its roles, a project and a template are never deleted
# (the owner, 2026-11-10). A project apply has itself just made holds nothing of the account's, only what GitHub gives
# every new project, so apply brings it to its template exactly, with or without --prune (ruled 2026-11-11): a template
# just made loses GitHub's Status options and its View 1 where the model names neither, and it and every project just
# copied from a template lose GitHub's built-in workflows, which no project has (ruled 2026-11-03). What GitHub's API
# cannot write, a type's pinned fields, a view's grouping and sort, is a step by hand, named in the record; the steps
# for the parts of a template or project just made are on its own record.
#
# Issue types and issue fields are written through GitHub's REST calls, which take the database IDs get records; the
# rest through GraphQL, each mutation's input written as literals, so that every value is in the call star narrates.

load("commands/model.star", "escape", "graphql", "owner_id", "quote", "read_project", "rest", "sh", "templates_of")
load("commands/participation.star", "TEMPLATE", "token_records", participation_apply = "apply")
load("commands/reconcile.star", "differs", "every_difference", "match", "own_options", "prepare", "template_renames")
load("commands/tokens.star", "for_secrets")

# GitHub's spellings, where its REST calls and GraphQL name a thing differently from the record.
_REST_VISIBILITY = {"ORG_ONLY": "organization_members_only", "ALL": "all"}
_REST_DATA_TYPE = {"single-select": "single_select", "date": "date", "text": "text", "number": "number"}
_GRAPHQL_DATA_TYPE = {"single-select": "SINGLE_SELECT", "date": "DATE", "text": "TEXT", "number": "NUMBER", "iteration": "ITERATION"}
_GRAPHQL_LAYOUT = {"table": "TABLE_LAYOUT", "board": "BOARD_LAYOUT", "roadmap": "ROADMAP_LAYOUT"}
_REST_PERMISSION = {"read": "pull", "triage": "triage", "write": "push", "maintain": "maintain", "admin": "admin"}
_RANK = {"read": 1, "triage": 2, "write": 3, "maintain": 4, "admin": 5}

# The kinds a template's parts and a project's parts are recorded as.
_TEMPLATE_KINDS = ("template-field", "template-option", "template-view")
_PROJECT_KINDS = ("project-field", "project-option", "project-view")

# ── writing ─────────────────────────────────────────────────────────────────

def _s(v):
    """A GraphQL string literal: JSON's is one."""
    return json.encode(v)

def _first(data, key):
    """The first value under key anywhere in an answer: the ID a mutation's payload carries."""
    stack = [data]
    for _ in range(10000):
        if not stack:
            break
        v = stack.pop()
        if type(v) == "dict":
            if type(v.get(key)) in ["string", "int"]:
                return v[key]
            stack.extend(v.values())
        elif type(v) == "list":
            stack.extend(v)
    return None

def mutate(query):
    """Runs a GraphQL mutation, failing on GitHub's errors; returns the ID its payload carries."""
    return _first(graphql(query), "id")

def _count(search):
    """How many issues GitHub's search finds; None when it cannot say."""
    out = sh("gh api graphql -f query=" + quote("query starCount($q: String!) { search(type: ISSUE_ADVANCED, query: $q, first: 1) { issueCount } }") +
             " -f q=" + quote(search) + " --jq .data.search.issueCount 2>/dev/null || true").strip()
    return int(out) if out.isdigit() else None

def _done(done, kind, path, action, extra = {}):
    """Records what apply did about one difference."""
    done[kind + " " + path] = (action, extra)

# ── issue types ─────────────────────────────────────────────────────────────

def _type_body(t):
    """An issue type as GitHub's REST call takes it."""
    return {"name": t["name"], "is_enabled": t.get("enabled") != False, "description": t.get("description"), "color": t.get("color")}

def _pinned(m, g):
    """The step by hand a type's pinned fields need, when they differ: GitHub's API cannot pin a field to a type."""
    want = (m or {}).get("pinned_fields") or []
    have = (g or {}).get("pinned_fields") or []
    if sorted(want) == sorted(have):
        return []
    return ["pin " + (", ".join(want) if want else "no field") + " to the " + m["name"] +
            " type in the organization's settings: GitHub's API cannot pin a field to a type"]

def _types(c, records, done):
    """Each issue type: created, changed or renamed in place, and with --prune deleted."""
    if c["kind"] != "organization":
        return
    org = c["account"]
    for r in [r for r in records if r["kind"] == "issue-type"]:
        m, g = r["model"], r["github"]
        if r["change"] == "missing":
            rest("POST", "orgs/" + org + "/issue-types", _type_body(m))
            _done(done, "issue-type", r["path"], "created", {"steps": _pinned(m, None)} if _pinned(m, None) else {})
        elif r["change"] in ["different", "renamed"]:
            steps = _pinned(m, g)
            if _type_body(m) != _type_body(g):
                rest("PUT", "orgs/" + org + "/issue-types/" + str(g["id"]), _type_body(m))
                _done(done, "issue-type", r["path"], "renamed" if r["change"] == "renamed" else "changed", {"steps": steps} if steps else {})
            else:
                _done(done, "issue-type", r["path"], "by-hand", {"steps": steps})
        elif c["prune"]:
            touches = _count("org:" + org + " type:\"" + g["name"] + "\"")

            # TODO(NobleFactor/devlore-cli#1219): ask before each deletion, naming what it touches (#470).
            rest("DELETE", "orgs/" + org + "/issue-types/" + str(g["id"]))
            _done(done, "issue-type", r["path"], "deleted", {"touches": touches})

# ── issue fields ────────────────────────────────────────────────────────────

def _rest_option(o, priority, database_id = None):
    """An issue field's option as GitHub's REST call takes it: an existing one with its ID, so that it is kept."""
    out = {"name": o["name"], "description": o.get("description") or None, "color": (o.get("color") or "GRAY").lower(), "priority": priority}
    if database_id != None:
        out["id"] = database_id
    return out

def _fields(c, records, done):
    """Each issue field: created, changed or renamed, its options sent whole with their IDs; with --prune, deleted."""
    if c["kind"] != "organization":
        return
    org = c["account"]
    mine = [r for r in records if r["kind"] in ["issue-field", "issue-field-option"]]
    names = []
    for r in mine:
        name = r["path"].split("/")[0]
        if name not in names:
            names.append(name)
    gfields = {f["name"]: f for f in c["github"].get("fields") or []}
    mfields = {f["name"]: f for f in c["model"].get("fields") or []}
    for name in names:
        field = [r for r in mine if r["kind"] == "issue-field" and r["path"] == name]
        field = field[0] if field else None
        options = [r for r in mine if r["kind"] == "issue-field-option" and r["path"].split("/")[0] == name]
        if field != None and field["change"] == "missing":
            m = mfields[field["model"]["name"]]
            body = {
                "name": m["name"],
                "description": m.get("description") or None,
                "data_type": _REST_DATA_TYPE.get(m.get("type"), m.get("type")),
                "visibility": _REST_VISIBILITY.get(m.get("visibility") or "ORG_ONLY", "organization_members_only"),
            }
            if m.get("options"):
                body["options"] = [_rest_option(o, i + 1) for i, o in enumerate(m["options"])]
            made = rest("POST", "orgs/" + org + "/issue-fields", body) or {}
            if made.get("node_id"):
                c["issue_field_ids"][m["name"]] = made["node_id"]
            _done(done, "issue-field", name, "created")
            continue
        if field != None and field["change"] == "extra":
            if c["prune"]:
                # TODO(NobleFactor/devlore-cli#1219): ask before each deletion, naming what it touches (#470).
                rest("DELETE", "orgs/" + org + "/issue-fields/" + str(gfields[name]["database_id"]))
                _done(done, "issue-field", name, "deleted", {"touches": None})
            continue
        g = gfields[name]
        m = mfields.get(field["model"]["name"] if field != None else name) or mfields.get(name)
        if m == None:
            continue
        body = {}
        if field != None:
            body = {
                "name": m["name"],
                "description": m.get("description") or None,
                "visibility": _REST_VISIBILITY.get(m.get("visibility") or "ORG_ONLY", "organization_members_only"),
            }
        marks = {}
        if [r for r in options if r["change"] != "extra" or c["prune"]]:
            final = []
            for mo, go in match(m.get("options") or [], g.get("options") or [], c["same"]):
                if mo != None:
                    final.append((mo, go))
                elif not c["prune"]:
                    final.append((go, go))
            body["options"] = [_rest_option(o, i + 1, go["database_id"] if go != None else None) for i, (o, go) in enumerate(final)]
            for r in options:
                marks[r["path"]] = {"missing": "created", "different": "changed", "renamed": "renamed", "extra": "deleted"}[r["change"]]
        if body:
            rest("PATCH", "orgs/" + org + "/issue-fields/" + str(g["database_id"]), body)
            if field != None:
                _done(done, "issue-field", name, "renamed" if field["change"] == "renamed" else "changed")
        for path, action in marks.items():
            _done(done, "issue-field-option", path, action, {"touches": None} if action == "deleted" else {})

# ── labels ──────────────────────────────────────────────────────────────────

def _labels(c, records, done):
    """Each label: created, changed or renamed, and with --prune deleted, its issues counted first."""
    for r in [r for r in records if r["kind"] == "label"]:
        repo = "/".join(r["path"].split("/")[:2])
        m, g = r["model"], r["github"]
        if r["change"] == "missing":
            rest("POST", "repos/" + repo + "/labels", {"name": m["name"], "color": m.get("color") or "ededed", "description": m.get("description") or ""})
            _done(done, "label", r["path"], "created")
        elif r["change"] in ["different", "renamed"]:
            body = {"color": m.get("color") or "ededed", "description": m.get("description") or ""}
            if r["change"] == "renamed":
                body["new_name"] = m["name"]
            rest("PATCH", "repos/" + repo + "/labels/" + escape(g["name"]), body)
            _done(done, "label", r["path"], "renamed" if r["change"] == "renamed" else "changed")
        elif c["prune"]:
            touches = _count("repo:" + repo + " label:\"" + g["name"] + "\"")

            # TODO(NobleFactor/devlore-cli#1219): ask before each deletion, naming what it touches (#470).
            rest("DELETE", "repos/" + repo + "/labels/" + escape(g["name"]))
            _done(done, "label", r["path"], "deleted", {"touches": touches})

# ── a project brought to its template ───────────────────────────────────────

def _option_literal(o):
    """A project option as GraphQL's input takes it, with its ID when it has one."""
    parts = []
    if o.get("id"):
        parts.append("id: " + _s(o["id"]))
    parts.append("name: " + _s(o["name"]))
    parts.append("color: " + (o.get("color") or "GRAY"))
    parts.append("description: " + _s(o.get("description") or ""))
    return "{" + ", ".join(parts) + "}"

def _create_field(c, project_id, mf):
    """A field the project lacks, made: an issue field put on it, or a field of its own."""
    if mf.get("issue_field"):
        field_id = c["issue_field_ids"].get(mf["name"])
        if not field_id:
            return None
        return mutate("mutation starAddIssueField { r: createProjectV2IssueField(input: {projectId: " + _s(project_id) +
                      ", issueFieldId: " + _s(field_id) + "}) { projectV2Field { ... on ProjectV2FieldCommon { id } } } }")
    kind = mf.get("type")
    extra = ""
    if kind == "single-select":
        # A field whose options are each project's own is made with one, a placeholder, as GitHub needs at least one.
        options = mf.get("options") or [{"name": "placeholder", "color": "GRAY", "description": ""}]
        extra = ", singleSelectOptions: [" + ", ".join([_option_literal(dict(o, id = None)) for o in options]) + "]"
    elif kind == "iteration":
        configuration = mf.get("configuration") or {}
        extra = (", iterationConfiguration: {startDate: " + _s(sh("date +%Y-%m-%d").strip()) + ", duration: " +
                 str(configuration.get("duration") or 14) + ", iterations: []}")
    return mutate("mutation starCreateField { r: createProjectV2Field(input: {projectId: " + _s(project_id) + ", dataType: " +
                  _GRAPHQL_DATA_TYPE.get(kind, "TEXT") + ", name: " + _s(mf["name"]) + extra + "}) { projectV2Field { " +
                  "... on ProjectV2FieldCommon { id } } } }")

def _options(c, gf, mf, path, kind, renames, by_id, done):
    """A single-select field's options brought to the model's, sent whole, each kept option with its ID."""
    gopts = gf.get("options") or []
    final = []
    marks = {}
    renamed_from = {}
    pairs = match(mf.get("options") or [], gopts, by_id)
    for mo, go in pairs:
        if mo == None:
            continue
        if go == None:
            # An option renamed on the template is renamed on the copy, under its old name.
            old = [g for g in gopts if renames.get(g["name"]) == mo["name"]]
            if old:
                final.append(dict(mo, id = old[0]["id"]))
                marks[path + "/" + old[0]["name"]] = "renamed"
                renamed_from[old[0]["name"]] = True
            else:
                final.append(dict(mo, id = None))
                marks[path + "/" + mo["name"]] = "created"
            continue
        final.append(dict(mo, id = go["id"]))
        if go["name"] != mo["name"]:
            marks[path + "/" + go["name"]] = "renamed"
        elif differs(mo, go, ["color", "description"]):
            marks[path + "/" + go["name"]] = "changed"
    for mo, go in pairs:
        if mo != None or go["name"] in renamed_from:
            continue
        if c["prune"]:
            marks[path + "/" + go["name"]] = "deleted"
        else:
            final.append(go)
    if [a for a in marks.values() if a != "kept"]:
        # TODO(NobleFactor/devlore-cli#1219): ask before each deletion, naming the rows it blanks (#470).
        mutate("mutation starUpdateOptions { r: updateProjectV2Field(input: {fieldId: " + _s(gf["id"]) + ", singleSelectOptions: [" +
               ", ".join([_option_literal(o) for o in final]) + "]}) { projectV2Field { ... on ProjectV2FieldCommon { id } } } }")
    for path, action in marks.items():
        _done(done, kind, path, action, {"touches": None} if action == "deleted" else {})

def _view_steps(mv, gv, path):
    """The steps by hand a view's grouping and sort need, when they differ: GitHub's API cannot write them."""
    steps = []
    for a in ["group_by", "vertical_group_by", "sort_by"]:
        want = mv.get(a) or []
        if want != ((gv or {}).get(a) or []):
            steps.append("set the " + path + " view's " + a.replace("_", " ") + " to " + json.encode(want) + " in GitHub: its API cannot")
    return steps

def _visible(field_ids, mv, path, steps):
    """The IDs of the fields a view shows, by name; a name the project has no field for is a step by hand."""
    ids = []
    for name in mv.get("fields") or []:
        if field_ids.get(name):
            ids.append(_s(field_ids[name]))
        else:
            steps.append("show " + name + " in the " + path + " view: the project has no field of that name")
    return "configuration: {visibleFieldIds: [" + ", ".join(ids) + "]}"

def converge(c, project_id, gp, mt, prefix, kinds, renames, done, copy = False):
    """Brings one project, a template or a project of a kind, to its template in the model.

    Its fields, their options and its views are brought to the template's; a field's options that are each project's own
    are left alone.
    """
    field_kind, option_kind, view_kind = kinds
    by_id = c["same"] and not copy
    field_ids = dict(gp.get("_field_ids") or {})
    for mf, gf in match(mt.get("fields") or [], gp.get("fields") or [], by_id):
        name = (gf or mf)["name"]
        path = prefix + "/" + name
        if gf == None:
            field_id = _create_field(c, project_id, mf)
            if field_id:
                field_ids[mf["name"]] = field_id
                _done(done, field_kind, path, "created")
            else:
                _done(done, field_kind, path, "by-hand", {"steps": ["put the " + mf["name"] + " issue field on " + prefix + ": the account has none"]})
            continue
        if mf == None:
            if c["prune"]:
                # TODO(NobleFactor/devlore-cli#1219): ask before each deletion, naming the rows it blanks (#470).
                mutate("mutation starDeleteField { r: deleteProjectV2Field(input: {fieldId: " + _s(gf["id"]) + "}) { projectV2Field { " +
                       "... on ProjectV2FieldCommon { id } } } }")
                _done(done, field_kind, path, "deleted", {"touches": None})
            continue
        steps = []
        if mf.get("type") != gf.get("type"):
            steps.append("make " + path + " a " + str(mf.get("type")) + " field by hand: GitHub cannot change a field's type")
        if (mf.get("issue_field") or False) != (gf.get("issue_field") or False):
            steps.append("make " + path + (" the " if mf.get("issue_field") else " not the ") + "issue field of its name by hand")
        if mf.get("configuration") and mf.get("configuration") != gf.get("configuration"):
            steps.append("set " + path + "'s iterations to " + json.encode(mf["configuration"]) + " in GitHub")
        if steps:
            _done(done, field_kind, path, "by-hand", {"steps": steps})
        if gf.get("type") == "single-select" and not c["own"].get(mt["name"] + "/" + name):
            _options(c, gf, mf, path, option_kind, renames.get(name) or {}, by_id, done)
    for mv, gv in match(mt.get("views") or [], gp.get("views") or [], False):
        name = (gv or mv)["name"]
        path = prefix + "/" + name
        if gv == None:
            steps = []
            configuration = _visible(field_ids, mv, path, steps)
            view_id = mutate("mutation starCreateView { r: createProjectV2View(input: {projectId: " + _s(project_id) + ", name: " +
                             _s(mv["name"]) + ", layout: " + _GRAPHQL_LAYOUT.get(mv.get("layout") or "table", "TABLE_LAYOUT") +
                             ", " + configuration + "}) { projectV2View { id } } }")
            if mv.get("filter"):
                mutate("mutation starUpdateView { r: updateProjectV2View(input: {viewId: " + _s(view_id) + ", filter: " + _s(mv["filter"]) +
                       "}) { projectV2View { id } } }")
            steps.extend(_view_steps(mv, None, path))
            _done(done, view_kind, path, "created", {"steps": steps} if steps else {})
            continue
        view_id = (gp.get("_view_ids") or {}).get(name)
        if mv == None:
            if c["prune"] and view_id:
                mutate("mutation starDeleteView { r: deleteProjectV2View(input: {viewId: " + _s(view_id) + "}) { projectV2View { id } } }")
                _done(done, view_kind, path, "deleted", {"touches": None})
            continue
        steps = _view_steps(mv, gv, path)
        if differs(mv, gv, ["layout", "filter", "fields"]) and view_id:
            configuration = _visible(field_ids, mv, path, steps)
            mutate("mutation starUpdateView { r: updateProjectV2View(input: {viewId: " + _s(view_id) + ", layout: " +
                   _GRAPHQL_LAYOUT.get(mv.get("layout") or "table", "TABLE_LAYOUT") + ", filter: " + _s(mv.get("filter") or "") +
                   ", " + configuration + "}) { projectV2View { id } } }")
            _done(done, view_kind, path, "changed", {"steps": steps} if steps else {})
        elif steps:
            _done(done, view_kind, path, "by-hand", {"steps": steps})

def _attributes(project_id, mt, gp):
    """A project's own attributes, its name, short description, README and public flag, brought to the template's."""
    parts = []
    if gp != None and mt["name"] != gp.get("name"):
        parts.append("title: " + _s(mt["name"]))
    for attribute, field in [("short_description", "shortDescription"), ("readme", "readme")]:
        if mt.get(attribute) != None and mt.get(attribute) != (gp or {}).get(attribute):
            parts.append(field + ": " + _s(mt[attribute]))
    if mt.get("public") != None and bool(mt["public"]) != bool((gp or {}).get("public")):
        parts.append("public: " + ("true" if mt["public"] else "false"))
    if not parts:
        return False
    mutate("mutation starUpdateProject { r: updateProjectV2(input: {projectId: " + _s(project_id) + ", " + ", ".join(parts) +
           "}) { projectV2 { id } } }")
    return True

def _steps(done, kinds, prefix):
    """The steps by hand recorded for the parts of a project just made, which its own record carries: it has no other."""
    steps = []
    for key, value in done.items():
        kind, _, path = key.partition(" ")
        if kind in kinds and path.startswith(prefix + "/"):
            steps.extend(value[1].get("steps") or [])
    return steps

def _no_workflows(project_id):
    """Deletes the built-in workflows GitHub gives a project just made or copied: no project has one (ruled 2026-11-03)."""
    data = graphql("query starWorkflows { node(id: " + _s(project_id) + ") { ... on ProjectV2 { workflows(first: 50) { nodes { id } } } } }")
    for w in ((data.get("node") or {}).get("workflows") or {}).get("nodes") or []:
        mutate("mutation starDeleteWorkflow { r: deleteProjectV2Workflow(input: {workflowId: " + _s(w["id"]) + "}) { deletedWorkflowId } }")

# ── templates, and each team's projects of a kind ───────────────────────────

def _templates(c, records, done):
    """Each template: made when the account lacks it, then brought to the model; never deleted.

    One made here is brought to the model exactly, GitHub's own options, view and workflows gone: nothing in it is the
    account's.
    """
    existing = [p for p in templates_of(c["projects"], c["kind"])]
    renamed = {r["path"]: True for r in records if r["kind"] == "template" and r["change"] == "renamed"}
    for mt, gt in match(c["model"].get("projects") or [], existing, c["same"]):
        if mt == None:
            c["template_ids"][gt["name"]] = gt["id"]
            continue
        if gt == None:
            project_id = mutate("mutation starCreateProject { r: createProjectV2(input: {ownerId: " + _s(c["owner"]) + ", title: " +
                                _s(mt["name"]) + "}) { projectV2 { id } } }")
            project = read_project(project_id)
            _attributes(project_id, mt, project)

            # It holds nothing of the account's yet, only what GitHub gives every new project, so it is brought to the
            # model exactly: GitHub's Status options and View 1 go where the model names neither, and its workflows.
            converge(dict(c, prune = True), project_id, project, mt, mt["name"], _TEMPLATE_KINDS, {}, done)
            _no_workflows(project_id)
            if c["kind"] == "organization":
                mutate("mutation starMarkTemplate { r: markProjectV2AsTemplate(input: {projectId: " + _s(project_id) + "}) { projectV2 { id } } }")
            c["template_ids"][mt["name"]] = project_id
            steps = _steps(done, _TEMPLATE_KINDS, mt["name"])
            _done(done, "template", mt["name"], "created", {"steps": steps} if steps else {})
            continue
        c["template_ids"][mt["name"]] = gt["id"]
        name = gt["name"]
        if _attributes(gt["id"], mt, gt):
            _done(done, "template", name, "renamed" if name in renamed else "changed")
        if [r for r in records if r["kind"] in _TEMPLATE_KINDS and r["path"].startswith(name + "/")]:
            converge(c, gt["id"], gt, mt, name, _TEMPLATE_KINDS, {}, done)

def _kind_projects(c, records, done):
    """Each team's projects of a kind, or a user account's, held to their templates.

    A missing one is copied from its template and linked to its team with the team's write role, and loses the built-in
    workflows GitHub gives it; a drifted one is brought back; none is ever deleted.
    """
    templates = {t["name"]: t for t in c["model"].get("projects") or []}
    teams = {t["slug"]: t for t in c["github"].get("teams") or []}
    renames = template_renames(records)
    for r in [r for r in records if r["kind"] == "project" and r["change"] == "missing"]:
        template = r["model"]["template"]
        template_id = c["template_ids"].get(template)
        if not template_id or template not in templates:
            _done(done, "project", r["path"], "by-hand", {"steps": ["make the " + template + " template first"]})
            continue
        project_id = mutate("mutation starCopyProject { r: copyProjectV2(input: {projectId: " + _s(template_id) + ", ownerId: " +
                            _s(c["owner"]) + ", title: " + _s(r["path"]) + ", includeDraftIssues: false}) { projectV2 { id } } }")
        team = teams.get(r["model"]["owner"])
        if c["kind"] == "organization" and team != None:
            mutate("mutation starLinkTeam { r: linkProjectV2ToTeam(input: {projectId: " + _s(project_id) + ", teamId: " + _s(team["id"]) +
                   "}) { team { id } } }")
            mutate("mutation starTeamRole { r: updateProjectV2Collaborators(input: {projectId: " + _s(project_id) +
                   ", collaborators: [{teamId: " + _s(team["id"]) + ", role: WRITER}]}) { collaborators { totalCount } } }")
        made = read_project(project_id)
        c["made"][r["path"]] = made["number"]
        converge(c, project_id, made, templates[template], r["path"], _PROJECT_KINDS, {}, done, copy = True)
        _no_workflows(project_id)
        steps = _steps(done, _PROJECT_KINDS, r["path"])
        _done(done, "project", r["path"], "created", {"steps": steps} if steps else {})
    by_name = {p["name"]: p for p in c["projects"] if not p.get("template")}
    drifted = []
    for r in records:
        if r["kind"] in _PROJECT_KINDS:
            name = r["path"].split("/")[0]
            if name not in drifted:
                drifted.append(name)
    for name in drifted:
        template = name.split(": ")[0]
        project = by_name.get(name)
        if project == None or template not in templates:
            continue
        converge(c, project["id"], project, templates[template], name, _PROJECT_KINDS, renames.get(template) or {}, done, copy = True)

# ── teams ───────────────────────────────────────────────────────────────────

def _teams(c, records, done):
    """Each team, from the account's own backup alone: its attributes set, its roles added or raised.

    A team is never deleted, and its role on a repository never removed or lowered (the owner, 2026-11-10).
    """
    if not c["same"] or c["kind"] != "organization":
        return
    org = c["account"]
    for r in [r for r in records if r["kind"] == "team"]:
        if r["change"] == "extra":
            _done(done, "team", r["path"], "kept")
            continue
        m = r["model"]
        g = r["github"] or {}
        body = {}
        for attribute in ["name", "description", "privacy", "notification_setting"]:
            if m.get(attribute) != None and m.get(attribute) != g.get(attribute):
                body[attribute] = m[attribute]
        if m.get("parent") and m.get("parent") != g.get("parent"):
            body["parent_team_id"] = int(sh("gh api " + quote("orgs/" + org + "/teams/" + m["parent"]) + " --jq .id").strip())
        slug = m["slug"]
        wrote = False
        if r["change"] == "missing":
            rest("POST", "orgs/" + org + "/teams", body)
            wrote = True
        elif body:
            rest("PATCH", "orgs/" + org + "/teams/" + slug, body)
            wrote = True
        for repo, role in sorted((m.get("roles") or {}).items()):
            have = (g.get("roles") or {}).get(repo)
            if have == None or _RANK.get(role, 0) > _RANK.get(have, 0):
                rest("PUT", "orgs/" + org + "/teams/" + slug + "/repos/" + repo, {"permission": _REST_PERMISSION.get(role, role)})
                wrote = True
        _done(done, "team", r["path"], ("created" if r["change"] == "missing" else "changed") if wrote else "kept")

# ── apply ───────────────────────────────────────────────────────────────────

def apply_model(source, account, prune, sources = []):
    """What star github model apply and restore return: each difference, with what apply did about it.

    Args:
      source: the model's file, the form get returns, another account's, a backup, or a reference; or the model itself.
      account: the account, an organization or a user.
      prune: delete what the model lacks, a team, its roles, a project and a template excepted.
      sources: where --token says each secret comes from, parsed and checked (tokens.star).
    """
    model, github, projects, kind, state = prepare(source, account)
    records = every_difference(model, github, projects, kind, state)
    names = (state or {}).get("secrets") or []
    where = ((state or {}).get("source") or "the model's account") + "/.github's " + TEMPLATE
    if sources and (state == None or state["template"] == None):
        fail("--token names a secret, but " + where + " is not there to sign in with one")
    c = {
        "account": account,
        "kind": kind,
        "owner": owner_id(account),
        "same": model.get("account") == github["account"] and not model.get("reference"),
        "prune": prune,
        "model": model,
        "github": github,
        "projects": projects,
        "own": own_options(),
        "template_ids": {},
        "issue_field_ids": {f["name"]: f["id"] for f in github.get("fields") or []},
        "made": {},
        "tokens": for_secrets(sources, names, where),
    }
    records = records + token_records(c, state, records)

    # TODO(NobleFactor/devlore-cli#1219): ask before applying, showing what will change, defaulting to yes (#470).
    done = {}
    _types(c, records, done)
    _fields(c, records, done)
    _labels(c, records, done)
    _templates(c, records, done)
    _kind_projects(c, records, done)
    _teams(c, records, done)
    participation_apply(c, state, records, done)
    out = []
    for r in records:
        action, extra = done.get(r["kind"] + " " + r["path"]) or (("by-hand" if r.get("by_hand") else "kept"), {})
        out.append(dict(r, action = action, **extra))
    return out
