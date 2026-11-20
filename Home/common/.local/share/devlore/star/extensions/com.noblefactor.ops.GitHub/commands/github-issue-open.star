# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github issue open: an issue opened in the repository of the clone it runs in, classified as it is made."""

# github-issue-open.star
#
# docs/plans/doc/589-issue-verbs.md (noblefactor-engprod#338), to section 10 of the issue data model, § Opening an
# issue: open, and create. Called with flags, or with a template, the issue's header and then its body, whose {name}
# blanks --set fills. In section 10's order:
#
#   1. The blanks filled; one left unfilled is refused.
#   2. Everything read before the first write: the clone and its repository, the account's model, the type, the parent
#      and its type, the Area, Priority and Severity options, and the type's form, from the account's .github
#      repository as it stands now.
#   3. The refusals, nothing written: no Area; a type the account doesn't have; a Schedule or Scenario issue, naming its
#      group's open; a parent at the wrong level; a body without a section the form requires, or without its Plan and
#      design documents table; a --severity on any type but Bug; a directory that is no clone; and a repository that
#      takes no part.
#   4. The issue opened in one call, GitHub's createIssue: its type, its parent, its assignee, and its Area, Priority and
#      Severity, the issue fields in an organization, the labels that stand in for them in a user account.
#   5. Its row left to the Triage workflow, which gives every issue opened its Triage row (ruled 2026-11-17).
#   6. Everything read back.
#
# open checks for no duplicate (D-014, #609): each run opens a new issue, which is what it is for. A template whose
# header names unique, which open no longer takes, is refused, as any header open doesn't take is.
#
# Priority is Medium unless given; a bug's Severity is Medium unless given, as the Triage workflow starts one, and every
# other type's N/A; no one is assigned unless --assignee names someone (each ruled 2026-11-17).

load("commands/access.star", "check_access")
load("commands/accounts.star", "ORIGIN")
load("commands/issues.star", "parent_of")
load("commands/markdown.star", "body_lines", "has_table", "has_text", "sections")
load("commands/model.star", "read_text", "refuse_dry_run")
load("commands/participation.star", "read_file")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "USER_ATTRIBUTES", "canonical_repo", "model_of", "models_for", "team_of", "type_named")
load("commands/steps.star", "issue", "issue_fields", "parse_key")

_COMMAND = "star github issue open"
_FORMS = ".github/ISSUE_TEMPLATE/"
_DOCUMENTS = "Plan and design documents"
_LEVELS = [2, 3]
_AREAS = ["Product", "Engineering"]
_MEDIUM = "Medium"
_NA = "N/A"
_BUG = "Bug"
_GROUPS = {"Schedule": "schedule", "Scenario": "scenario"}
_HEADER = ["type", "parent", "title", "area", "priority", "severity", "assignee"]
_FLAGS = ["type", "parent", "title", "body-file", "area", "priority", "severity", "assignee"]

# A blank: {name}, a letter then letters, digits, - and _; a shell's ${name} is no blank.
_BLANK = "(\\$?)\\{([A-Za-z][A-Za-z0-9_-]*)\\}"

def _a(word):
    """A word with its article: an Epic, a Task."""
    return ("an " if word[:1].lower() in "aeiou" else "a ") + word

# ── reading ─────────────────────────────────────────────────────────────────

def _call(query, variables, jq):
    """A GraphQL call, its variables sent as JSON through a pipe within the one command; the answer through jq."""
    payload = json.encode({"query": query, "variables": variables})
    return sh("printf %s " + quote(payload) + " | gh api graphql --input - --jq " + quote(jq)).strip()

def _clone(directory):
    """The repository of the clone at directory, or the one the command runs in: (owner/name, "") or (None, why)."""
    where = directory or "."
    root = sh("git -C " + quote(where) + " rev-parse --show-toplevel 2>/dev/null; true").strip()
    if root == "":
        return None, where + " is no clone: issue open opens its issue in the repository of the clone it runs in, or the one --directory names"
    origin = sh("git -C " + quote(root) + " remote get-url origin 2>/dev/null; true").strip()
    m = regex.find_submatch(pattern = ORIGIN, text = origin)
    if not m:
        return None, root + " has no origin on GitHub to name its repository: " + (origin or "none")
    return canonical_repo(m[1]), ""

def _exists(path):
    """Whether a file is there and holds something."""
    return sh("[ -s " + quote(path) + " ] && echo yes || true").strip() == "yes"

def _template(path):
    """A template's header, as a dict, and its body; fails, naming the path, on a template that has no header."""
    if not _exists(path):
        fail("--template names " + path + ", which is missing or empty")
    lines = read_text(path).replace("\r\n", "\n").split("\n")
    if not lines or lines[0].strip() != "---":
        fail(path + " has no header: a template begins with a line ---, then its header, then a line ---, then its body")
    ends = [i for i in range(1, len(lines)) if lines[i].strip() == "---"]
    if not ends:
        fail(path + "'s header has no closing line ---")
    header = yaml.decode(data = "\n".join(lines[1:ends[0]])) or {}
    if type(header) != "dict":
        fail(path + "'s header is no map of keys to values")
    braced = sorted([k for k, v in header.items() if type(v) in ["dict", "list"]])
    if braced:
        fail(path + "'s header reads " + ", ".join(braced) + " as YAML, not text: quote a blank in the header, " +
             braced[0] + ": \"{name}\"")
    return header, "\n".join(lines[ends[0] + 1:]).strip("\n") + "\n"

def _sets(value):
    """--set's name=value pairs, comma-separated, as a dict; fails, naming it, on a pair with no name."""
    out = {}

    # TODO(https://github.com/NobleFactor/noblefactor-engprod/issues/315): take --set repeated, --set <name>=<value>
    # --set <name>=<value>, once star's extension flags can repeat.
    for pair in [p.strip() for p in (value or "").split(",") if p.strip()]:
        name, eq, v = pair.partition("=")
        if eq == "" or not regex.match(pattern = "^[A-Za-z][A-Za-z0-9_-]*$", text = name.strip()):
            fail("--set takes <name>=<value>, comma-separated: " + pair)
        out[name.strip()] = v.strip()
    return out

def _fill(text, values, missing):
    """text with each {name} blank filled from values; each blank values lacks is added to missing."""
    for m in regex.find_all_submatch(pattern = _BLANK, text = text, count = -1) or []:
        if m[1] == "" and m[2] not in values:
            missing[m[2]] = True

    # Each blank becomes a slot first, then each slot its value, so that a value holding {name} is not filled again.
    names = list(values.keys())
    for i, name in enumerate(names):
        kept = "\u0001" + name + "\u0001"
        text = text.replace("${" + name + "}", kept).replace("{" + name + "}", "\u0002" + str(i) + "\u0002").replace(kept, "${" + name + "}")
    for i, name in enumerate(names):
        text = text.replace("\u0002" + str(i) + "\u0002", values[name])
    return text

def _named(names, value, what, refused):
    """The one of names that value names, in any case; None, with a refusal, when it names none."""
    found = [n for n in names if n.lower() == value.lower()]
    if not found:
        refused.append(what + " is one of " + ", ".join(names) + ", not " + value)
        return None
    return found[0]

def _required(model, kind, refused):
    """The labels of the sections the type's form requires, read from the account's .github repository now."""
    path = _FORMS + kind.lower() + ".yml"
    text = read_file(model["account"] + "/.github", path)
    if text == None:
        refused.append(model["account"] + "/.github has no " + path + ", the " + kind + " form issue open checks a body against")
        return []
    out = []
    for e in (yaml.decode(data = text) or {}).get("body") or []:
        if type(e) == "dict" and e.get("type") == "textarea" and (e.get("validations") or {}).get("required") == True:
            label = ((e.get("attributes") or {}).get("label") or "").strip()
            if label != "":
                out.append(label)
    return out

def _body_faults(body, required):
    """What a body lacks of what its form requires, each named.

    Each section the form requires, headed at level 2 or 3, with text in it; and the table of its documents, a header row
    and a delimiter row outside any code block.
    """
    lines = body_lines(body)
    out = []
    for label in required:
        found = sections(lines, label, _LEVELS)
        if not found:
            out.append("its section " + label)
        elif label.lower() != _DOCUMENTS.lower() and not has_text(lines, found[0]["first"], found[0]["end"]):
            out.append("text in its section " + label)
    docs = sections(lines, _DOCUMENTS, _LEVELS)
    if not docs:
        if _DOCUMENTS not in required:
            out.append("its section " + _DOCUMENTS)
    elif not has_table(lines, docs[0]["first"], docs[0]["end"]):
        out.append("the table of its " + _DOCUMENTS + " section")
    return out

def _family(key):
    """A user account's labels of one attribute, each label to its value's name."""
    found = [f for f in USER_ATTRIBUTES if f["key"] == key]
    return found[0]["names"] if found else {}

def _classes(model, t, values, refused):
    """How the issue is classified: its type, and its Area, Priority and Severity as issue fields or as labels."""
    if model["user"]:
        labels = [t["label"]] if t.get("label") else []
        for key in ["area", "priority", "severity"]:
            names = _family(key)
            name = _named(sorted(names.values()), values[key], "--" + key, refused)
            labels.extend([label for label in sorted(names.keys()) if names[label] == name])
        return {"fields": [], "labels": labels}
    fields = []
    for key in ["area", "priority", "severity"]:
        name = key.capitalize()
        f = [f for f in model["fields"] if f["name"] == name]
        if not f:
            refused.append(model["account"] + " has no " + name + " issue field")
            continue
        options = f[0].get("options") or []
        value = _named([o["name"] for o in options], values[key], "--" + key, refused)
        fields.extend([{"name": name, "field": f[0]["id"], "option": o["id"], "value": o["name"]} for o in options if o["name"] == value])
    return {"fields": fields, "labels": []}

def _repository(repo):
    """A repository's node ID, its issue types and its labels, each name to its node ID."""
    owner, name = repo.split("/")
    query = ("query starStepRepository { repository(owner: \"" + owner + "\", name: \"" + name + "\") { id " +
             "issueTypes(first: 25) { nodes { id name } } labels(first: 100) { nodes { id name } } } }")
    node = json.decode(data = _call(query, {}, ".data.repository") or "null")
    if node == None:
        fail("no repository " + repo)
    return {
        "id": node["id"],
        "types": {n["name"]: n["id"] for n in ((node.get("issueTypes") or {}).get("nodes") or [])},
        "labels": {n["name"]: n["id"] for n in ((node.get("labels") or {}).get("nodes") or [])},
    }

def _user(login):
    """A GitHub user's node ID, or "" when there is none."""
    return _call("query starStepUser { user(login: \"" + login + "\") { id } }", {}, ".data.user.id // \"\"")

def _given(ctx):
    """What the issue is to be, from --template and --set, or from the flags: its header's values and its body."""
    template = (ctx.args.get("template") or "").strip()
    sets = (ctx.args.get("set") or "").strip()
    flagged = [f for f in _FLAGS if ctx.args.get(f) not in [None, "", False, "false"]]
    if template == "":
        if sets != "":
            fail("--set goes with --template, and it was not given")
        for f in ["type", "title", "body-file", "area"]:
            if (ctx.args.get(f) or "").strip() == "":
                fail("issue open needs --" + f + ", or --template")
        path = ctx.args.get("body-file").strip()
        if not _exists(path):
            fail("--body-file names " + path + ", which is missing or empty")
        values = {k: (ctx.args.get(k) or "").strip() for k in _HEADER}
        return values, read_text(path).replace("\r\n", "\n")
    if flagged:
        fail("--template takes no flag but --set and --directory: " + ", ".join(["--" + f for f in flagged]) + " given")
    header, body = _template(template)
    stray = sorted([k for k in header.keys() if k not in _HEADER])
    if stray:
        fail(template + "'s header has " + ", ".join(stray) + "; a template's header takes " + ", ".join(_HEADER))
    filled = _sets(sets)
    missing = {}
    values = {}
    for k in _HEADER:
        v = header.get(k)
        values[k] = _fill(str(v).strip(), filled, missing) if v != None else ""
    body = _fill(body, filled, missing)
    if missing:
        fail("a blank is left unfilled: " + ", ".join(["{" + m + "}" for m in sorted(missing.keys())]) + "; --set fills each")
    return values, body

def run(_command, ctx):
    """Check the flags and gh's access, read everything, then open the issue, and read it back.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries --template with --set, or --type, --parent, --title, --body-file, --area,
        --priority, --severity and --assignee; and --directory; ctx.dry_run, star's --dry-run, which open
        refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    values, body = _given(ctx)
    repo, fault = _clone((ctx.args.get("directory") or "").strip())
    if fault:
        fail(fault)
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)

    # Everything read first: the model, the type, the parent, the options, the form, the repository and the assignee.
    account = repo.split("/")[0]
    model = model_of(models_for([account]), account)
    refused = []
    if model["user"] and repo not in model["repositories"]:
        refused.append(repo + " takes no part in " + model["account"] + "'s issue model: it lacks the topic issue-model")
    elif not model["user"] and team_of(model, repo) == None:
        refused.append(repo + " takes no part in " + model["account"] + "'s issue model: no team maintains it")
    named = [h["name"] for h in model["hierarchy"] + model["collections"] if h["name"].lower() == values["type"].lower()]
    t = type_named(model, named[0]) if named else None
    if t == None:
        fail(model["account"] + " has no type " + values["type"] + "; it has " + ", ".join([h["name"] for h in model["hierarchy"]]))
    kind = t["name"]
    if t.get("level") == None:
        group = _GROUPS.get(kind, kind.lower())
        fail(_a(kind) + " issue is opened by star github " + group + " open, not by issue open")
    if values["title"] == "":
        refused.append("the issue needs a title")
    if values["area"] == "":
        refused.append("the issue needs an Area: --area, or area: in a template's header, Product or Engineering")
    else:
        values["area"] = _named(_AREAS, values["area"], "--area", refused) or values["area"]
    values["priority"] = values["priority"] or _MEDIUM
    if kind == _BUG:
        values["severity"] = values["severity"] or _MEDIUM
    elif values["severity"] not in ["", _NA]:
        refused.append("--severity is for a Bug: " + _a(kind) + "'s Severity is N/A")
    else:
        values["severity"] = _NA

    parent = None
    above = [h for h in model["hierarchy"] if h["level"] == t["level"] - 1]
    if t["level"] == 0 and values["parent"] != "":
        refused.append(_a(kind) + " is at the top of the hierarchy, and has no parent")
    elif t["level"] > 0 and values["parent"] == "":
        refused.append(_a(kind) + " needs a parent, " + " or ".join([_a(h["name"]) for h in above]))
    elif values["parent"] != "":
        pk = parse_key(values["parent"])
        if pk["owner"].lower() != model["account"].lower():
            refused.append(pk["key"] + " is in another account: an issue's parent is its own account's")
        else:
            parent = issue(pk["key"], model)
            if parent["type"] not in [h["name"] for h in above]:
                refused.append(pk["key"] + " is " + ("of type " + parent["type"] if parent["type"] else "of no type") +
                               ": " + _a(kind) + "'s parent is " + " or ".join([_a(h["name"]) for h in above]))
    classes = _classes(model, t, values, refused)
    faults = _body_faults(body, _required(model, kind, refused))
    if faults:
        refused.append("the body lacks " + ", ".join(faults) + ", which the " + kind + " form asks for")
    held = _repository(repo)
    if not model["user"] and kind not in held["types"]:
        refused.append(repo + " offers no issue type " + kind)
    labels = []
    for label in classes["labels"]:
        if label not in held["labels"]:
            refused.append(repo + " has no label " + label)
        else:
            labels.append(held["labels"][label])
    assignee = ""
    if values["assignee"] != "":
        assignee = _user(values["assignee"])
        if assignee == "":
            refused.append("no GitHub user " + values["assignee"])
    if refused:
        fail("nothing was opened:\n  " + "\n  ".join(refused))

    record = {
        "title": values["title"],
        "type": kind,
        "parent": parent["key"] if parent != None else None,
        "area": values["area"],
        "priority": values["priority"],
        "severity": values["severity"],
        "assignee": values["assignee"] or None,
    }

    # The issue, in one call: its type, its parent, its assignee, and its fields or its labels.
    given = {"repositoryId": held["id"], "title": values["title"], "body": body}
    if not model["user"]:
        given["issueTypeId"] = held["types"][kind]
        given["issueFields"] = [{"fieldId": f["field"], "singleSelectOptionId": f["option"]} for f in classes["fields"]]
    if labels:
        given["labelIds"] = labels
    if parent != None:
        given["parentIssueId"] = parent["id"]
    if assignee != "":
        given["assigneeIds"] = [assignee]
    made = json.decode(data = _call(
        "mutation starStepCreate($input: CreateIssueInput!) { createIssue(input: $input) { issue { number } } }",
        {"input": given},
        ".data.createIssue.issue",
    ) or "null")
    if made == None or not made.get("number"):
        fail("GitHub opened no issue in " + repo)
    key = repo + "#" + str(int(made["number"]))
    note("opened " + key + ", " + values["title"])

    # Read back: its title, type, state, body, assignee, parent, and its fields or labels.
    back = issue(key, model)
    wrong = []
    if back["title"] != values["title"]:
        wrong.append("its title " + back["title"])
    if back["type"] != kind:
        wrong.append("its type " + str(back["type"]))
    if back["state"] != "open":
        wrong.append("its state " + back["state"])
    if back["body"].replace("\r\n", "\n").strip() != body.strip():
        wrong.append("its body")
    if values["assignee"] != "" and values["assignee"].lower() not in [a.lower() for a in back["assignees"]]:
        wrong.append("its assignees " + ", ".join(back["assignees"]))
    if parent != None and ((parent_of(key) or {}).get("key") or "").lower() != parent["key"].lower():
        wrong.append("its parent " + str((parent_of(key) or {}).get("key")))
    if model["user"]:
        wrong.extend(["no label " + label for label in classes["labels"] if label not in back["labels"]])
    else:
        have = issue_fields(back)
        wrong.extend(["its " + f["name"] + " " + str(have.get(f["name"])) for f in classes["fields"] if have.get(f["name"]) != f["value"]])
    if wrong:
        fail(key + " was opened, and reads back with " + "; ".join(wrong))
    return [dict(record, issue = key, action = "opened")]
