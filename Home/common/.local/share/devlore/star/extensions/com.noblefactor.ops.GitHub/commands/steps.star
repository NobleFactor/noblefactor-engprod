# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A schedule's steps and a scenario's rows: read, renumbered and written, and each change recorded where it is kept."""

# steps.star
#
# docs/plans/feature/438-schedule-add.md, Phase 2 (noblefactor-engprod#438), to section 8 of the issue data model, the
# schedule commands. A schedule is an option of its team's Schedule project's Schedule field, named for its Schedule
# issue, whose own row carries the option and no step (ruled 2026-11-03). Every change to its steps is one act: the
# rows, the links and the amendment written together, the rows read before anything is written and again just before
# the first write, and every write read back, since GitHub promises no stability for the features the model is built on
# (section 8, question 3). Closed steps move with the open ones (question 5), and each change writes one amendment line,
# rendered from templates/amendment.md.template, naming the date, who ran the command and why (question 4).
#
# A scenario is read the same way, an option of its team's Scenario project's Scenario field, whose rows carry a Beat
# (section 9); its changes are recorded in a comment on its Scenario issue and a line in the item's body, which this
# module writes too. star github issue move uses it (#511), made from `add` (#438).

load("commands/markdown.star", "body_lines", "line_end", "numbered", "sections")
load("commands/model.star", "extension_dir", "read_text")
load("commands/records.star", "json_lines", "kind_of_project", "quote", "sh")
load("commands/scheme.star", "canonical_repo", "owners_of", "type_of")

SCHEDULE_KIND = "Schedule"
SCENARIO_KIND = "Scenario"

_SCHEDULE_FIELD = "Schedule"
_SCENARIO_FIELD = "Scenario"
_STEP_FIELD = "Step"
_BEAT_FIELD = "Beat"
_STATUS_FIELD = "Status"
_OPEN = "Open"
_AMENDMENTS = "## Amendments"
_WIDTH = 120

# The headings a body line is placed and a walk is read by, at level 2 or 3: a form writes ###, the API ##. A line goes
# above the Plan and design documents heading, since star github plan link replaces that section to its end (#557).
_DOCUMENTS = "Plan and design documents"
_WALK = "How to walk through it"
_LEVELS = [2, 3]

# ── keys and calls ──────────────────────────────────────────────────────────

def parse_key(key):
    """owner, repository and number of an issue written <owner>/<repository>#<number>; fails, naming it, otherwise."""
    m = regex.find_submatch(pattern = "^([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)#([0-9]+)$", text = key.strip())
    if not m:
        fail("an issue is written <owner>/<repository>#<number>: " + key)
    repo = canonical_repo(m[1] + "/" + m[2])
    return {"key": repo + "#" + m[3], "repo": repo, "owner": repo.split("/")[0], "name": repo.split("/")[1], "number": int(m[3])}

def _call(query, variables = {}, jq = "."):
    """A GraphQL call's result through gh, each variable passed apart from the query.

    A string goes with -f, and a number with -F, which gh sends as a JSON number.
    """
    args = " ".join([("-F " if type(v) == "int" else "-f ") + quote(k + "=" + str(v)) for k, v in variables.items()])
    return sh("gh api graphql -f query=" + quote(query) + (" " + args if args else "") + " --jq " + quote(jq)).strip()

def _value(item, name, attr):
    """A row's value of one field, from the fieldValues of a project item, or None."""
    for v in ((item.get("fieldValues") or {}).get("nodes") or []):
        if type(v) == "dict" and type(v.get("field")) == "dict" and v["field"].get("name") == name and attr in v:
            return v[attr]
    return None

def _int(v):
    """A step as a whole number; GitHub's number fields are floats."""
    return int(v) if v != None else None

def viewer():
    """The login gh runs as: who ran the command, as the amendment names them."""
    return _call("query starViewer { viewer { login } }", jq = ".data.viewer.login")

def today():
    """Today's date in UTC, YYYY-MM-DD, as the amendment dates its line."""
    return sh("date -u +%Y-%m-%d").strip()

# ── an issue ────────────────────────────────────────────────────────────────

_ROW_VALUES = ("fieldValues(first: 20) { nodes { " +
               "... on ProjectV2ItemFieldSingleSelectValue { name optionId field { ... on ProjectV2FieldCommon { name } } } " +
               "... on ProjectV2ItemFieldNumberValue { number field { ... on ProjectV2FieldCommon { name } } } } }")

def issue(key, model):
    """An issue as issue move reads it: its node ID, type, state, title and body, its assignees and blockers, and its rows.

    Each row names its project, the project's kind for the account's owners (Triage, Backlog, Schedule, Scenario, or None
    for a project of no kind, such as a closed per-schedule project of 2026-11-01), its Schedule or Scenario option, its
    Status, its step and its Beat.
    """
    k = parse_key(key)
    query = ("query starStepIssue { repository(owner: \"" + k["owner"] + "\", name: \"" + k["name"] + "\") { " +
             "issue(number: " + str(k["number"]) + ") { id number title state body url issueType { name } " +
             "labels(first: 50) { nodes { name } } assignees(first: 20) { nodes { login } } " +
             "blockedBy(first: 50) { nodes { id number repository { nameWithOwner } } } " +
             "projectItems(first: 20) { nodes { id project { id title number closed } " + _ROW_VALUES + " } } } } }")
    node = json.decode(data = _call(query, jq = ".data.repository.issue"))
    if node == None:
        fail("no issue " + k["key"])
    owners = owners_of(model)
    rows = []
    for item in ((node.get("projectItems") or {}).get("nodes") or []):
        project = item.get("project") or {}
        rows.append({
            "item": item["id"],
            "project": {"id": project.get("id"), "title": project.get("title"), "number": project.get("number")},
            "kind": None if project.get("closed") else kind_of_project(project.get("title"), owners),
            "schedule": _value(item, _SCHEDULE_FIELD, "name"),
            "scenario": _value(item, _SCENARIO_FIELD, "name"),
            "status": _value(item, _STATUS_FIELD, "name"),
            "step": _int(_value(item, _STEP_FIELD, "number")),
            "beat": _int(_value(item, _BEAT_FIELD, "number")),
        })
    labels = [label["name"] for label in ((node.get("labels") or {}).get("nodes") or [])]
    return {
        "key": k["key"],
        "repo": k["repo"],
        "id": node["id"],
        "title": node["title"],
        "state": node["state"].lower(),
        "body": node.get("body") or "",
        "type": type_of(model, node.get("issueType"), labels),
        "labels": labels,
        "assignees": [a["login"] for a in ((node.get("assignees") or {}).get("nodes") or [])],
        "blocked_by": [canonical_repo(b["repository"]["nameWithOwner"]) + "#" + str(int(b["number"])) for b in ((node.get("blockedBy") or {}).get("nodes") or [])],
        "rows": rows,
    }

# ── a schedule and a scenario ───────────────────────────────────────────────

def _collection(key, model, kind, number, closed):
    """A schedule or a scenario: its own issue, its team's project of kind with its fields, and its option.

    kind names the project, the field and the issue's type alike; number is the field that orders the rows, Step or Beat.
    The option is the one the issue's own row carries; fails, naming why, when the issue is not an open issue of kind or
    has no such row, closed saying what a closed one takes no more of.
    """
    own = issue(key, model)
    if own["type"] != kind:
        fail(own["key"] + " is not a " + kind + " issue: its type is " + (own["type"] or "none"))
    if own["state"] != "open":
        fail(own["key"] + " is closed: " + closed)
    attr = kind.lower()
    rows = [r for r in own["rows"] if r["kind"] == kind and r[attr] != None]
    if len(rows) != 1:
        fail(own["key"] + " has " + str(len(rows)) + " rows with a " + kind + " option on its account's " + kind + " projects, not one")
    project = project_of(rows[0]["project"]["id"])
    for name in [kind, number, _STATUS_FIELD]:
        if name not in project["fields"]:
            fail(project["title"] + " has no " + name + " field")
    option = [o for o in project["fields"][kind]["options"] if o["name"] == rows[0][attr]]
    if len(option) != 1:
        fail(project["title"] + " has no " + kind + " option named " + rows[0][attr])
    return {"issue": own, "project": project, "option": option[0], "own_item": rows[0]["item"], "field": kind}

def schedule(key, model):
    """A schedule: its Schedule issue, its team's Schedule project with its fields, and its option.

    The option is the one the Schedule issue's own row carries; fails, naming why, when the issue is not an open Schedule
    issue or has no such row.
    """
    return _collection(key, model, _SCHEDULE_FIELD, _STEP_FIELD, "a closed schedule takes no step")

def scenario(key, model):
    """A scenario: its Scenario issue, its team's Scenario project with its fields, and its option.

    The option is the one the Scenario issue's own row carries; fails, naming why, when the issue is not an open Scenario
    issue or has no such row. A scenario that is retired is closed, and takes no item.
    """
    return _collection(key, model, _SCENARIO_FIELD, _BEAT_FIELD, "a retired scenario takes no item")

def walk(own):
    """How many steps a Scenario issue's walk numbers under its How to walk through it heading; None when it numbers none.

    Beat N is step N of the walk (ruled 2026-11-15), so a Beat past the last is refused only when the walk is numbered.
    """
    lines = body_lines(own["body"])
    found = sections(lines, _WALK, _LEVELS)
    if not found:
        return None
    return numbered(lines, found[0]) or None

def project_named(model, title):
    """The account's open project titled title, with its fields, as project_of reads it; None when it has none."""
    kind = "user" if model["user"] else "organization"
    query = ("query starStepFind { " + kind + "(login: \"" + model["account"] + "\") { projectsV2(first: 20, query: \"" + title +
             "\") { nodes { id title closed } } } }")
    for p in json.decode(data = _call(query, jq = ".data." + kind + ".projectsV2.nodes") or "[]") or []:
        if p.get("title") == title and not p.get("closed"):
            return project_of(p["id"])
    return None

def project_of(project_id):
    """A project's ID, title, and fields by name, a single-select field with its options."""
    query = ("query starStepProject { node(id: \"" + project_id + "\") { ... on ProjectV2 { id title number " +
             "fields(first: 50) { nodes { ... on ProjectV2FieldCommon { id name dataType } " +
             "... on ProjectV2SingleSelectField { options { id name description } } } } } } }")
    node = json.decode(data = _call(query, jq = ".data.node"))
    fields = {}
    for f in ((node.get("fields") or {}).get("nodes") or []):
        if f.get("name"):
            fields[f["name"]] = {"id": f["id"], "options": f.get("options") or []}
    return {"id": node["id"], "title": node["title"], "number": int(node["number"]), "fields": fields}

def option_of(project, field, name):
    """The ID of a single-select field's option by name; fails, naming the project, when there is none."""
    for o in project["fields"][field]["options"]:
        if o["name"] == name:
            return o["id"]
    fail(project["title"] + "'s " + field + " field has no option " + name)

def rows(sched, model):
    """Every row under a schedule's or a scenario's option, in the project's order.

    Each row is its item, issue, type, state, title, step and Beat.
    """
    query = ("query starStepRows($endCursor: String) { node(id: \"" + sched["project"]["id"] + "\") { ... on ProjectV2 { " +
             "items(first: 100, after: $endCursor) { pageInfo { hasNextPage endCursor } nodes { id " +
             "content { ... on Issue { id number title state issueType { name } labels(first: 20) { nodes { name } } " +
             "repository { nameWithOwner } } } " + _ROW_VALUES + " } } } } }")
    out = []
    for item in json_lines("gh api graphql --paginate -f query=" + quote(query) + " --jq " + quote(".data.node.items.nodes[] | tojson")):
        if _value(item, sched["field"], "name") != sched["option"]["name"]:
            continue
        content = item.get("content") or {}
        if not content.get("number"):
            continue
        labels = [label["name"] for label in ((content.get("labels") or {}).get("nodes") or [])]
        out.append({
            "item": item["id"],
            "issue": canonical_repo(content["repository"]["nameWithOwner"]) + "#" + str(int(content["number"])),
            "id": content["id"],
            "type": type_of(model, content.get("issueType"), labels),
            "title": content.get("title"),
            "state": (content.get("state") or "").lower(),
            "step": _int(_value(item, _STEP_FIELD, "number")),
            "beat": _int(_value(item, _BEAT_FIELD, "number")),
        })
    return out

def snapshot(rs):
    """What the one-act check compares between its two reads: each row's item, step, Beat and state, in order."""
    return [(r["item"], r["step"], r["beat"], r["state"]) for r in rs]

# ── the steps ───────────────────────────────────────────────────────────────

def closing(rs, taken_items):
    """The rows that move when steps are taken off: every other row, in step order, numbered from 1 on.

    The steps are consecutive whole numbers, so each row after one taken off moves up one for each, closed or open.
    Numbering by place rather than by subtracting means a run that stopped partway, run again, moves nothing twice.
    """
    others = sorted([r for r in rs if r["step"] != None and r["item"] not in taken_items], key = lambda r: r["step"])
    return [{"row": r, "from": r["step"], "to": i + 1} for i, r in enumerate(others) if r["step"] != i + 1]

def span(moves):
    """The amendment's account of rows that moved: {"first", "last", "by", "direction", "to_first", "to_last"}, or None."""
    if not moves:
        return None
    starts = sorted([m["from"] for m in moves])
    ends = sorted([m["to"] for m in moves])
    shifts = {m["to"] - m["from"]: True for m in moves}.keys()
    by = shifts[0] if len(shifts) == 1 else 0
    return {"first": starts[0], "last": starts[-1], "by": abs(by), "direction": "down" if by > 0 else "up", "to_first": ends[0], "to_last": ends[-1]}

# ── writing rows ────────────────────────────────────────────────────────────

def add_row(project, content_id):
    """A new row on a project for an issue, by its node ID; the row's item ID."""
    item = _call(
        "mutation starStepAddRow($p: ID!, $c: ID!) { addProjectV2ItemById(input: {projectId: $p, contentId: $c}) { item { id } } }",
        {"p": project["id"], "c": content_id},
        ".data.addProjectV2ItemById.item.id",
    )
    if item == "":
        fail("no row was made on " + project["title"])
    return item

def delete_row(project_id, item):
    """A row taken off a project."""
    _call(
        "mutation starStepDeleteRow($p: ID!, $i: ID!) { deleteProjectV2Item(input: {projectId: $p, itemId: $i}) { deletedItemId } }",
        {"p": project_id, "i": item},
    )

def set_option(project, item, field, option_id):
    """A row's single-select field set to an option."""
    _call(
        "mutation starStepSetOption($p: ID!, $i: ID!, $f: ID!, $o: String!) { updateProjectV2ItemFieldValue(input: " +
        "{projectId: $p, itemId: $i, fieldId: $f, value: {singleSelectOptionId: $o}}) { projectV2Item { id } } }",
        {"p": project["id"], "i": item, "f": project["fields"][field]["id"], "o": option_id},
    )

def set_step(project, item, step):
    """A row's Step set; GitHub takes a number field's value as a float."""
    _call(
        "mutation starStepSetStep($p: ID!, $i: ID!, $f: ID!, $v: Float!) { updateProjectV2ItemFieldValue(input: " +
        "{projectId: $p, itemId: $i, fieldId: $f, value: {number: $v}}) { projectV2Item { id } } }",
        {"p": project["id"], "i": item, "f": project["fields"][_STEP_FIELD]["id"], "v": step},
    )

def set_beat(project, item, beat):
    """A row's Beat set; GitHub takes a number field's value as a float."""
    _call(
        "mutation starStepSetBeat($p: ID!, $i: ID!, $f: ID!, $v: Float!) { updateProjectV2ItemFieldValue(input: " +
        "{projectId: $p, itemId: $i, fieldId: $f, value: {number: $v}}) { projectV2Item { id } } }",
        {"p": project["id"], "i": item, "f": project["fields"][_BEAT_FIELD]["id"], "v": beat},
    )

def place_after(project, item, after_item):
    """A row placed just after another in the project's order, as section 3 keeps the rows: by Step within each option."""
    _call(
        "mutation starStepPlace($p: ID!, $i: ID!, $a: ID!) { updateProjectV2ItemPosition(input: {projectId: $p, itemId: $i, afterId: $a}) { clientMutationId } }",
        {"p": project["id"], "i": item, "a": after_item},
    )

def put(sched, item, step, status = None):
    """A row given the schedule's option, its step, and its Status: status when given, else Open.

    A step moved within its schedule keeps the Status it has; a step put on a schedule is Open.
    """
    project = sched["project"]
    set_option(project, item, _SCHEDULE_FIELD, sched["option"]["id"])
    set_option(project, item, _STATUS_FIELD, option_of(project, _STATUS_FIELD, status or _OPEN))
    set_step(project, item, step)

def put_open(project, r):
    """An issue's row on a Triage or Backlog project, made when it has none, with Status Open, read back; the row's item."""
    item = add_row(project, r["id"])
    set_option(project, item, _STATUS_FIELD, option_of(project, _STATUS_FIELD, _OPEN))
    reads_back(item, {"project": project["id"], "status": _OPEN}, r["key"])
    return item

def put_beat(scen, item, beat, joining):
    """A row given the scenario's Beat; joining, its option and Status Open too, as a row put on a scenario has."""
    project = scen["project"]
    if joining:
        set_option(project, item, _SCENARIO_FIELD, scen["option"]["id"])
        set_option(project, item, _STATUS_FIELD, option_of(project, _STATUS_FIELD, _OPEN))
    set_beat(project, item, beat)

def read_row(item):
    """A row as GitHub holds it now: its project's ID, its Schedule or Scenario option, its Status, its step and its Beat."""
    node = json.decode(data = _call(
        "query starStepReadRow { node(id: \"" + item + "\") { ... on ProjectV2Item { project { id } " + _ROW_VALUES + " } } }",
        jq = ".data.node",
    ))
    if node == None:
        return None
    return {
        "project": (node.get("project") or {}).get("id"),
        "schedule": _value(node, _SCHEDULE_FIELD, "name"),
        "scenario": _value(node, _SCENARIO_FIELD, "name"),
        "status": _value(node, _STATUS_FIELD, "name"),
        "step": _int(_value(node, _STEP_FIELD, "number")),
        "beat": _int(_value(node, _BEAT_FIELD, "number")),
    }

def reads_back(item, want, what):
    """Fails, naming what, unless the row reads back holding each value want names, as read_row reads them."""
    back = read_row(item)
    got = {k: back.get(k) for k in want} if back != None else None
    if got != want:
        fail(what + "'s row reads back as " + str(got) + ", not " + str(want))

def check_row(sched, item, step, what, status = None):
    """Fails, naming what, unless the row reads back on the schedule's project with its option, step and Status.

    The Status is status when given, else Open, as put gives it.
    """
    reads_back(item, {"project": sched["project"]["id"], "schedule": sched["option"]["name"], "status": status or _OPEN, "step": step}, what)

def check_beat(scen, item, beat, what, joining):
    """Fails, naming what, unless the row reads back on the scenario's project with its option and Beat; joining, Open."""
    want = {"project": scen["project"]["id"], "scenario": scen["option"]["name"], "beat": beat}
    if joining:
        want["status"] = _OPEN
    reads_back(item, want, what)

# ── the amendment ───────────────────────────────────────────────────────────

def _wrap(text):
    """One amendment line, wrapped at 120 columns with a two-space hang, as the Schedule issues' amendments are."""
    lines = []
    line = ""
    for word in text.split(" "):
        if line and len(line) + 1 + len(word) > _WIDTH:
            lines.append(line)
            line = "  " + word
        else:
            line = (line + " " + word) if line else word
    if line:
        lines.append(line)
    return "\n".join(lines)

_PENDING = "(in progress)"

def amendment(data, pending = False):
    """The amendment line, rendered from templates/amendment.md.template with data, then wrapped.

    Pending, it ends "(in progress)": the line a change writes before its first row, so that a run that stops partway
    leaves its record, which the same command run again finishes, and which a reader sees is unfinished.
    """
    content = read_text(extension_dir() + "/templates/amendment.md.template")
    line = " ".join(template.render_text(content = content, data = data).split())
    return _wrap(line + (" " + _PENDING if pending else ""))

def _section(body):
    """A Schedule issue's body as lines, and the span of its Amendments section's lines: (lines, first, end)."""
    lines = body.replace("\r\n", "\n").rstrip("\n").split("\n")
    at = [i for i, line in enumerate(lines) if line.strip() == _AMENDMENTS]
    if len(at) != 1:
        fail("the Schedule issue has " + str(len(at)) + " " + _AMENDMENTS + " sections, not one")
    end = len(lines)
    for i in range(at[0] + 1, len(lines)):
        if lines[i].startswith("## "):
            end = i
            break
    return lines, at[0] + 1, end

def _entries(body):
    """The Amendments section's entries, each a "- " line and the lines that continue it: [(first, end, text)]."""
    lines, first, end = _section(body)
    out = []
    for i in range(first, end):
        if lines[i].startswith("- "):
            out.append([i, i + 1])
        elif out and lines[i].startswith("  ") and out[-1][1] == i:
            out[-1][1] = i + 1
    return [(e[0], e[1], " ".join([line.strip() for line in lines[e[0]:e[1]]])) for e in out]

def pending_for(own, keys):
    """Whether the Schedule issue holds a pending amendment naming every one of keys: a run of them that stopped.

    A body with no Amendments section, or with two, holds none; amend refuses to write in one.
    """
    if len([line for line in own["body"].replace("\r\n", "\n").split("\n") if line.strip() == _AMENDMENTS]) != 1:
        return False
    for _, _, entry in _entries(own["body"]):
        if entry.endswith(_PENDING) and _names(entry, keys):
            return True
    return False

def _write_body(own, body, check, what = "its amendment"):
    """An issue's body written and read back; fails, naming what, unless check holds of what reads back."""
    _call("mutation starStepAmend($i: ID!, $b: String!) { updateIssue(input: {id: $i, body: $b}) { issue { id } } }", {"i": own["id"], "b": body})
    back = _call("query starStepBody { node(id: \"" + own["id"] + "\") { ... on Issue { body } } }", jq = ".data.node.body").replace("\r\n", "\n")
    if not check(back):
        fail(own["key"] + "'s body does not read back with " + what)
    own["body"] = back

def amend(own, line):
    """The line written at the end of the Schedule issue's Amendments section, unless it is there; read back."""
    if line in own["body"].replace("\r\n", "\n"):
        return
    lines, first, end = _section(own["body"])
    for _ in range(end - first):
        if lines[end - 1].strip() != "":
            break
        end -= 1
    body = "\n".join(lines[:end] + ([""] if end == first else []) + line.split("\n") + lines[end:]) + "\n"
    _write_body(own, body, lambda back: line in back)

def settle(own, keys, line):
    """The pending amendment naming keys made final, its marker dropped; or the line written when none is pending.

    The pending entry is the change's record as it was planned before its first write, so a run that finishes one an
    earlier run began keeps it, the steps that run moved among it, rather than writing what is left to do.
    """
    lines, _, _ = _section(own["body"])
    for first, end, entry in _entries(own["body"]):
        if entry.endswith(_PENDING) and _names(entry, keys):
            final = _wrap(entry[:-len(_PENDING)].rstrip())
            body = "\n".join(lines[:first] + final.split("\n") + lines[end:]) + "\n"
            _write_body(own, body, lambda back: final in back and not pending_for({"body": back}, keys))
            return
    amend(own, line)

def _names(entry, keys):
    """Whether an amendment entry names every one of keys."""
    return all([regex.match(pattern = "(^|[^0-9A-Za-z/])" + k.replace(".", "\\.") + "([^0-9]|$)", text = entry) for k in keys])

# ── a scenario's records: the comment and the body line ─────────────────────

def comment(own, body):
    """A comment on an issue, by its node ID; fails, naming the issue, unless GitHub answers with the comment's ID."""
    made = _call(
        "mutation starStepComment($s: ID!, $b: String!) { addComment(input: {subjectId: $s, body: $b}) { commentEdge { node { id } } } }",
        {"s": own["id"], "b": body},
        ".data.addComment.commentEdge.node.id",
    )
    if made == "" or made == "null":
        fail("the comment on " + own["key"] + " was not made")

def with_line(body, line):
    """A body with line written just above its Plan and design documents heading, or at its end, a blank line around it.

    The heading is the first at level 2 or 3, as star github plan link finds it. The body's line ends are kept.
    """
    lines = body_lines(body)
    eol = line_end(body)
    found = sections(lines, _DOCUMENTS, _LEVELS)
    if not found:
        kept = body.rstrip("\r\n")
        return (kept + eol + eol if kept else "") + line + eol
    at = lines[found[0]["first"]]["start"]
    head = body[:at]
    gap = "" if head == "" or head.endswith(eol + eol) or head == eol else eol
    return head + gap + line + eol + eol + body[at:]

def write_line(own, line):
    """A line written into an issue's body, as with_line places it, unless a line of the body is it already; read back.

    Returns whether it was written.
    """
    if line in [text.strip() for text in own["body"].replace("\r\n", "\n").split("\n")]:
        return False
    _write_body(own, with_line(own["body"], line), lambda back: line in back.split("\n"), "the line " + line)
    return True
