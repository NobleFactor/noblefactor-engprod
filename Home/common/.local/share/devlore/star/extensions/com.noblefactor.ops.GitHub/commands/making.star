# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A schedule or a scenario made: its issue filed from its account's form, its option, and its own row."""

# making.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 4 (noblefactor-engprod#509), to section 8 of the issue data
# model, § Making a schedule: new, and section 9, § Making a scenario: new. One implementation serves star github
# schedule open and star github scenario open, and their create; what differs is the kind, its form, its flags and its body's template. In
# order, each write read back (section 8, question 3): the team that maintains the repository, and its project of the
# kind; the issue, titled "<kind>: <name>", its body the sections of the account's form in the form's order, rendered
# from templates/schedule.md.template or scenario.md.template; the option <name>, added last to the project's field,
# its description the issue's key; and the issue's own row, with the option and Status Open. Nothing is written until
# every refusal has been checked. A run that stops partway is run again to finish: it finds the open issue by its
# title, then the option, then the row, and makes only what is missing (#487 is the bug this avoids).
#
# The Triage workflow leaves a Schedule or Scenario issue out of Triage (#573), so new makes the issue's only row.

load("commands/markdown.star", "body_lines", "numbered")
load("commands/model.star", "escape", "extension_dir", "read_text")
load("commands/participation.star", "project_url", "read_file")
load("commands/scheme.star", "USER_ATTRIBUTES", "canonical_repo", "model_of", "models_for", "team_of", "type_named")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "add_option",
    "add_row",
    "file_issue",
    "issue",
    "issue_fields",
    "open_titled",
    "option_of",
    "place_after",
    "project_named",
    "project_rows",
    "reads_back",
    "set_issue_field",
    "set_option",
    "viewer",
)

# What differs between the kinds: the account's form, by its file under .github/ISSUE_TEMPLATE in the account's .github
# repository; which flag fills each of its textareas, by the textarea's id; and the template the body is rendered from.
_KINDS = {
    SCHEDULE_KIND: {
        "form": "schedule.yml",
        "flags": {"what": "deliverable", "exit": "exit-criteria", "evidence": "evidence"},
        "template": "schedule.md.template",
    },
    SCENARIO_KIND: {
        "form": "scenario.yml",
        "flags": {"goal": "wants", "walk": "walk", "features": "features"},
        "template": "scenario.md.template",
    },
}

_FORMS = ".github/ISSUE_TEMPLATE/"

# The form's section that takes the form's own default, the table star github plan link writes later (#557).
_DOCUMENTS = "Plan and design documents"

# What GitHub writes for a form's optional section left empty.
_NO_RESPONSE = "_No response_"

# The Area and Priority every issue of either kind carries: issue fields in an organization, label families in a user
# account (section 8, § How each command runs in each account). A schedule's Priority is Medium unless --priority
# names another.
_AREA = "Area"
_PRIORITY = "Priority"
_AREAS = ["Product", "Engineering"]
_DEFAULT_PRIORITY = "Medium"

_STATUS_FIELD = "Status"
_OPEN = "Open"

# ── what is filed ───────────────────────────────────────────────────────────

def _sections(model, kind, texts, refused):
    """The body's sections, in the form's order: each textarea's label, its text, and whether it is the documents one.

    Each textarea a flag fills takes the flag's text; the Plan and design documents textarea, and any other the flags
    do not fill, the form's own default. The Area dropdown is set as the issue's Area and is no section. A required
    section no flag fills, and a flag that fills no section, are refused, each added to refused.
    """
    path = _FORMS + _KINDS[kind]["form"]
    text = read_file(model["account"] + "/.github", path)
    if text == None:
        fail(model["account"] + "/.github has no " + path + ": " + kind.lower() + " new files its issue from the account's form")
    flags = _KINDS[kind]["flags"]
    out = []
    used = {}
    for e in (yaml.decode(data = text) or {}).get("body") or []:
        if type(e) != "dict" or e.get("type") != "textarea":
            continue
        attributes = e.get("attributes") or {}
        label = (attributes.get("label") or "").strip()
        required = (e.get("validations") or {}).get("required") == True
        flag = flags.get(e.get("id"))
        if flag != None:
            used[flag] = True
            value = (texts.get(flag) or "").strip()
            if value == "" and required:
                refused.append("--" + flag + " is missing: it fills the form's section " + label)
        else:
            value = (attributes.get("value") or "").strip()
            if value == "" and required:
                refused.append("the form's section " + label + " is required, and no flag fills it")
        out.append({"heading": label, "text": value or _NO_RESPONSE, "documents": label.lower() == _DOCUMENTS.lower()})
    for flag in sorted(texts.keys()):
        if flag not in used and (texts[flag] or "").strip():
            refused.append("--" + flag + " fills no section of " + model["account"] + "/.github's " + path)
    return out

def _named(names, value, what, refused):
    """The one of names that value names, in any case; None, with a refusal, when it names none."""
    found = [n for n in names if n.lower() == value.lower()]
    if not found:
        refused.append(what + " is " + ", ".join(names) + ": " + value)
        return None
    return found[0]

def _attributes(model, kind, area, priority, refused):
    """How the issue is classified: its type, Area and Priority as GitHub's REST call and the issue fields take them.

    In an organization, the issue type by name, and the Area and Priority issue fields' IDs and their options'; in a
    user account, which has no issue types or issue fields, the type's label and the area: and priority: labels. An
    area or priority that is None, already refused, is passed by.
    """
    t = type_named(model, kind)
    if t == None:
        refused.append(model["account"] + "'s model has no type " + kind)
        return {"type": None, "labels": [], "fields": []}
    if model["user"]:
        labels = [t["label"]]
        for key, value in [("area", area), ("priority", priority)]:
            if value == None:
                continue
            family = [f for f in USER_ATTRIBUTES if f["key"] == key]
            names = family[0]["names"] if family else {}
            name = _named([names[label] for label in sorted(names.keys())], value, "--" + key, refused)
            labels.extend([label for label in sorted(names.keys()) if names[label] == name])
        return {"type": None, "labels": labels, "fields": []}
    fields = []
    for field, value in [(_AREA, area), (_PRIORITY, priority)]:
        if value == None:
            continue
        f = [f for f in model["fields"] if f["name"] == field]
        if not f:
            refused.append(model["account"] + " has no " + field + " issue field")
            continue
        options = f[0].get("options") or []
        name = _named([o["name"] for o in options], value, "--" + field.lower(), refused)
        fields.extend([{"name": field, "field": f[0]["id"], "option": o["id"], "value": o["name"]} for o in options if o["name"] == name])
    return {"type": kind, "labels": [], "fields": fields}

def _link(model, project, kind, name):
    """The project's view 2, filtered to the option, as each Schedule and Scenario issue links it.

    The query's spaces are written +, and the rest percent-encoded, as #346's is: schedule%3A%22issue+tracking%2C+...
    """
    base = project_url("user" if model["user"] else "organization", model["account"], project["number"])
    return base + "/views/2?filterQuery=" + kind.lower() + "%3A%22" + "+".join([escape(w) for w in name.split(" ")]) + "%22"

def _body(kind, sections, project, link, name):
    """The issue's body, rendered from the kind's template with the form's sections and the line linking view 2."""
    content = read_text(extension_dir() + "/templates/" + _KINDS[kind]["template"])
    return template.render_text(content = content, data = {
        "sections": sections,
        "has_documents": len([s for s in sections if s["documents"]]) > 0,
        "project": project["title"],
        "link": link,
        "name": name,
    })

# ── new ─────────────────────────────────────────────────────────────────────

def make_collection(kind, repository, name, given):
    """A schedule or a scenario made in repository, named name, from given: its flags, by name; one record of what it did.

    Refuses, writing nothing: a repository that takes no part, a team with no project of the kind, an --area that is
    not Product or Engineering, a form's section left unfilled, a scenario's --walk that numbers no step, and a name
    that is already an option of the field, unless the option names the open issue an earlier run filed under the
    name, whose run this one finishes. A name whose issue, option and row are all there is refused too.
    """
    repo = canonical_repo(repository.strip())
    if not regex.match(pattern = "^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", text = repo):
        fail("a repository is written <owner>/<name>: " + repository)
    name = name.strip()
    if name == "":
        fail(kind.lower() + " new needs the " + kind.lower() + "'s name")
    account = repo.split("/")[0]
    model = model_of(models_for([account]), account)
    attr = kind.lower()
    refused = []

    # The repository takes part, and its team, or the user account, has its project of the kind.
    if model["user"] and repo not in model["repositories"]:
        fail(repo + " takes no part in " + model["account"] + "'s issue model: it lacks the topic issue-model")
    owner = team_of(model, repo)
    if owner == None:
        fail(repo + " takes no part in " + model["account"] + "'s issue model: no team maintains it")
    title = kind + ": " + owner
    project = project_named(model, title)
    if project == None:
        fail(model["account"] + " has no open project " + title + ", for " + repo + "'s " + attr + "s")
    for field in [kind, _STATUS_FIELD]:
        if field not in project["fields"]:
            fail(title + " has no " + field + " field")

    # What is filed: the form's sections, the classification, and, for a scenario, a walk whose steps are numbered.
    texts = {flag: given.get(flag) or "" for flag in _KINDS[kind]["flags"].values()}
    sections = _sections(model, kind, texts, refused)
    area = (given.get("area") or "").strip()
    if area == "":
        refused.append("--area is missing: Product or Engineering")
        area = None
    else:
        area = _named(_AREAS, area, "--area", refused)
    classes = _attributes(model, kind, area, (given.get("priority") or "").strip() or _DEFAULT_PRIORITY, refused)
    if kind == SCENARIO_KIND and texts["walk"].strip():
        lines = body_lines(texts["walk"])
        if numbered(lines, {"first": -1, "end": len(lines)}) == 0:
            refused.append("--walk numbers no step: Beat N is step N of the walk, so each step needs its number")

    # What is there already: an earlier run's open issue, by its title; the option; and the issue's own row.
    issue_title = kind + ": " + name
    number = open_titled(repo, issue_title)
    own = issue(repo + "#" + str(number), model) if number != None else None
    options = [o for o in project["fields"][kind]["options"] if o["name"] == name]
    if own != None and own["type"] != kind:
        refused.append(own["key"] + " is an open issue titled " + issue_title + ", but not a " + kind + " issue")
    if options:
        described = (options[0].get("description") or "").strip()
        if own == None or described != own["key"]:
            refused.append(name + " is already an option of " + title + "'s " + kind + " field, " +
                           (described + "'s" if described else "naming no issue"))
    row = [r for r in own["rows"] if r["project"]["id"] == project["id"]] if own != None else []
    if own != None and options and row and row[0][attr] == name:
        refused.append(own["key"] + " is already the " + attr + " " + name + ": its issue, its option and its row are all there")
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    login = viewer()
    assignee = (given.get("assignee") or "").strip() or login
    link = _link(model, project, kind, name)
    actions = {"issue": "found", "option": "found", "row": "found"}

    # The issue, read back: its title, type, assignee, labels and body.
    if own == None:
        body = _body(kind, sections, project, link, name)
        fields = {"title": issue_title, "body": body, "assignees": [assignee]}
        if classes["type"]:
            fields["type"] = classes["type"]
        if classes["labels"]:
            fields["labels"] = classes["labels"]
        key = repo + "#" + str(file_issue(repo, fields))
        note("filed " + key + ", " + issue_title)
        own = issue(key, model)
        if (own["title"] != issue_title or own["type"] != kind or own["state"] != "open" or
            assignee.lower() not in [a.lower() for a in own["assignees"]] or
            [label for label in classes["labels"] if label not in own["labels"]] or
            own["body"].replace("\r\n", "\n") != body):
            fail(key + " does not read back as it was filed: " + str({k: own[k] for k in ["title", "type", "state", "assignees", "labels"]}))
        actions["issue"] = "made"
    key = own["key"]

    # Its Area and Priority, in an organization, set where it has none, and read back.
    if classes["fields"]:
        have = issue_fields(own)
        for f in classes["fields"]:
            if have.get(f["name"]) == None:
                set_issue_field(own, f["field"], f["option"])
                note("set " + key + "'s " + f["name"] + " to " + f["value"])
        have = issue_fields(own)
        missing = [f["name"] for f in classes["fields"] if have.get(f["name"]) == None]
        if missing:
            fail(key + "'s " + " and ".join(missing) + " read back as unset")

    # The option, added last, its description the issue's key, read back.
    if not options:
        project = add_option(project, kind, name, key)
        back = [o for o in project["fields"][kind]["options"] if o["name"] == name]
        if len(back) != 1 or (back[0].get("description") or "").strip() != key:
            fail(title + "'s " + kind + " field does not read back with the option " + name + ", naming " + key)
        note("added the option " + name + " to " + title + "'s " + kind + " field, naming " + key)
        actions["option"] = "made"

    # The issue's own row: Status Open, no step or Beat, placed after the last row with an option, as section 3 keeps a
    # project's rows in its field's order; then the option, last, so that a row carrying it is finished, and a run run
    # again finishes one that does not. Read back.
    if not row or row[0][attr] != name:
        item = row[0]["item"] if row else add_row(project, own["id"])
        set_option(project, item, _STATUS_FIELD, option_of(project, _STATUS_FIELD, _OPEN))
        placed = [r for r in project_rows(project, model) if r["item"] != item and r[attr] != None]
        place_after(project, item, placed[-1]["item"] if placed else None)
        set_option(project, item, kind, option_of(project, kind, name))
        reads_back(item, {"project": project["id"], attr: name, "status": _OPEN, "step": None, "beat": None}, key)
        note("put " + key + "'s own row on " + title + " under " + name)
        actions["row"] = "made"

    return {
        "kind": kind,
        "issue": key,
        "title": issue_title,
        "project": title,
        "option": name,
        "issue_action": actions["issue"],
        "option_action": actions["option"],
        "row_action": actions["row"],
    }
