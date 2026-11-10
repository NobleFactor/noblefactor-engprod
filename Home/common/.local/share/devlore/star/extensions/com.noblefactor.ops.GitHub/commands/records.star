# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""Every issue as one flat record: read from GitHub, and placed by the model of the account that owns it."""

# records.star
#
# docs/plans/feature/436-triage-sweep.md, Requirement 2 (noblefactor-engprod#379). GraphQL returns each list wrapped in
# nodes and each issue or project field as a name and value pair; a record puts every key a person filters on at its
# top level, so that star's global --filter reaches it and a CSV column holds one value. An issue is read through its
# repository's issue list, which has no cap, or, given a search, through GitHub's search scoped to the repository,
# which stops at 1,000. Nothing here names a type or a field: the keys come from the models (scheme.star).

load(
    "commands/scheme.star",
    "HOME_KINDS",
    "TRIAGE_KIND",
    "USER_ATTRIBUTES",
    "canonical_repo",
    "key_of",
    "model_for",
    "owners_of",
    "type_of",
)

# GitHub's search returns no more than this many issues for one query.
SEARCH_CAP = 1000

# Issues to a page: each carries its labels, rows and parents, and 50 keeps a page well inside GraphQL's limits.
_PAGE = 50

# The project field types a row's values are read from; GitHub's own (title, assignees, labels, repository and the rest)
# are every project's, and the record carries them elsewhere or not at all.
_CUSTOM_FIELDS = ["SINGLE_SELECT", "TEXT", "NUMBER", "DATE", "ITERATION"]

# Under star's --dry-run every shell.exec is skipped, reads with writes, until NobleFactor/devlore-cli#1170 lands.
_DRY_RUN = "star's --dry-run skips every read until NobleFactor/devlore-cli#1170 lands, so nothing could be read from GitHub"

_FIELD_VALUE = " ".join([
    "... on IssueFieldSingleSelectValue { field { ... on IssueFieldCommon { name } } name }",
    "... on IssueFieldTextValue { field { ... on IssueFieldCommon { name } } value }",
    "... on IssueFieldNumberValue { field { ... on IssueFieldCommon { name } } value }",
    "... on IssueFieldDateValue { field { ... on IssueFieldCommon { name } } value }",
])

_ROW_VALUE = " ".join([
    "... on ProjectV2ItemFieldSingleSelectValue { field { ... on ProjectV2FieldCommon { name dataType } } name }",
    "... on ProjectV2ItemFieldTextValue { field { ... on ProjectV2FieldCommon { name dataType } } text }",
    "... on ProjectV2ItemFieldNumberValue { field { ... on ProjectV2FieldCommon { name dataType } } number }",
    "... on ProjectV2ItemFieldDateValue { field { ... on ProjectV2FieldCommon { name dataType } } date }",
    "... on ProjectV2ItemFieldIterationValue { field { ... on ProjectV2FieldCommon { name dataType } } title }",
])

# ── reading ─────────────────────────────────────────────────────────────────

def quote(s):
    """s as one single-quoted shell word."""
    return "'" + s.replace("'", "'\\''") + "'"

def sh(command):
    """A shell command's standard output; fails naming devlore-cli#1170 when star's --dry-run skipped it."""
    r = shell.exec(command = command)
    if r == None:
        fail(_DRY_RUN)
    return r.stdout

def json_lines(command):
    """The JSON value on each line a command prints, as gh's --jq '... | tojson' prints one per line."""
    return [json.decode(data = line) for line in sh(command).split("\n") if line.strip() != ""]

def _depth(models):
    """How far up an issue's parents are read: one level fewer than the deepest model read has, and at least one."""
    return max([1] + [len(models[a]["levels"]) - 1 for a in models])

def _parents(depth):
    """The parent chain's selection, nested depth deep, each with what places it: its repository, type and labels."""
    inner = ""
    for _ in range(depth):
        inner = "parent { number repository { nameWithOwner } issueType { name } labels(first: 20) { nodes { name } } " + inner + "}"
    return inner

def selection(models, with_body = False):
    """What is read of each issue: everything its record needs, its body only when asked for."""
    return " ".join([
        "id number title url state stateReason createdAt updatedAt closedAt",
        "body" if with_body else "",
        "repository { nameWithOwner } issueType { name } labels(first: 50) { nodes { name } }",
        "assignees(first: 20) { nodes { login } }",
        "blockedBy(first: 20) { nodes { number state repository { nameWithOwner } } }",
        "subIssuesSummary { total completed }",
        "issueFieldValues(first: 20) { nodes { " + _FIELD_VALUE + " } }",
        "projectItems(first: 20) { nodes { id project { id number title } fieldValues(first: 30) { nodes { " + _ROW_VALUE + " } } } }",
        _parents(_depth(models)),
    ])

def _issues(repo, open_only, with_body, models):
    """Every issue of one repository through its issue list, page by page; the open ones alone when open_only."""
    owner, name = repo.split("/")
    query = ("query starIssues($endCursor: String) { repository(owner: \"" + owner + "\", name: \"" + name + "\") { " +
             "issues(first: " + str(_PAGE) + ", after: $endCursor, orderBy: {field: CREATED_AT, direction: ASC}" +
             (", states: [OPEN]" if open_only else "") + ") { pageInfo { hasNextPage endCursor } nodes { " +
             selection(models, with_body) + " } } } }")
    return json_lines("gh api graphql --paginate -f query=" + quote(query) + " --jq " + quote(".data.repository.issues.nodes[] | tojson"))

def _search(repo, expression, with_body, models):
    """The issues of one repository that GitHub's search finds for expression, scoped by star; an error past the cap.

    The expression is GitHub's issue-search syntax with GitHub's meaning, passed unchanged inside parentheses, so that
    an OR in it binds before the scope: (<expression>) repo:<repository> is:issue.
    """
    q = "(" + expression + ") repo:" + repo + " is:issue"
    count = sh("gh api graphql -f query=" + quote("query starSearchCount($q: String!) { search(type: ISSUE_ADVANCED, query: $q, first: 1) { issueCount } }") +
               " -f q=" + quote(q) + " --jq .data.search.issueCount").strip()
    if not count.isdigit():
        fail("GitHub's search gave no count for " + q + ": " + count)
    if int(count) > SEARCH_CAP:
        fail("the search " + q + " matches " + count + " issues in " + repo + ", and GitHub's search returns no more than " +
             str(SEARCH_CAP) + ": narrow it, or read the repository whole without --search")
    query = ("query starSearch($q: String!, $endCursor: String) { search(type: ISSUE_ADVANCED, query: $q, first: " + str(_PAGE) +
             ", after: $endCursor) { pageInfo { hasNextPage endCursor } nodes { ... on Issue { " + selection(models, with_body) + " } } } }")
    return json_lines("gh api graphql --paginate -f query=" + quote(query) + " -f q=" + quote(q) + " --jq " +
                      quote(".data.search.nodes[] | select(.number != null) | tojson"))

def fetch(repos, models, search = "", open_only = False, with_body = False):
    """The issue nodes of every repository, through its issue list, or through GitHub's search when search is given.

    Args:
      repos: the repositories, owner/name.
      models: each repository owner's model, as models_for read it.
      search: GitHub's issue-search syntax; empty to read each repository whole.
      open_only: read open issues alone.
      with_body: read each issue's body too.
    """
    nodes = []
    for repo in repos:
        model_for(models, repo)
        nodes.extend(_search(repo, search, with_body, models) if search else _issues(repo, open_only, with_body, models))
    return nodes

# ── the record ──────────────────────────────────────────────────────────────

def _number(v):
    """A JSON number as an int when it is whole: encoding/json decodes every number as a float."""
    if type(v) == "float" and v == int(v):
        return int(v)
    return v

def _nodes(connection):
    """A connection's nodes, or none."""
    if type(connection) != "dict":
        return []
    return connection.get("nodes") or []

def _key(node):
    """owner/repo#N of an issue node, its repository through canonical_repo."""
    return canonical_repo(node["repository"]["nameWithOwner"]) + "#" + str(int(node["number"]))

def kind_of_project(title, owners):
    """A project's kind, Triage, Backlog, Schedule or Scenario, when its title is "<Kind>: <owner>" for one of owners; else None."""
    parts = (title or "").split(": ", 1)
    if len(parts) == 2 and parts[1] in owners:
        return parts[0]
    return None

def _row(item):
    """One project row: the project's title and number, and each of its custom fields' values, by key."""
    project = item.get("project") or {}
    row = {"project": project.get("title"), "number": int(project.get("number") or 0)}
    for v in _nodes(item.get("fieldValues")):
        f = v.get("field") if type(v) == "dict" else None
        if type(f) != "dict" or f.get("dataType") not in _CUSTOM_FIELDS:
            continue
        k = key_of(f["name"])
        if k in row:
            continue
        for attr in ["name", "text", "number", "date", "title"]:
            if attr in v:
                row[k] = _number(v[attr])
                break
    return row

def record(node, models):
    """One issue's record, every key at its top level, placed by the model of the account that owns it.

    The type is GitHub's issue type in an organization and the type label in a user account. Each level above the last
    gets a key, its type's name, holding the ancestor of that type the parent chain reaches. Each issue field the model
    names gets a key, and in a user account each family of labels that stands for one. home is the issue's rows on its
    account's Backlog, Schedule and Scenario projects: a list, never null.
    """
    repo = canonical_repo(node["repository"]["nameWithOwner"])
    model = model_for(models, repo)
    label_names = [label["name"] for label in _nodes(node.get("labels"))]
    r = {
        "issue": repo + "#" + str(int(node["number"])),
        "repository": repo,
        "type": type_of(model, node.get("issueType"), label_names),
        "title": node["title"],
        "url": node["url"],
        "state": node["state"].lower(),
        "state_reason": node["stateReason"].lower() if node.get("stateReason") else None,
        "parent": _key(node["parent"]) if node.get("parent") else None,
    }

    for k in model["ancestor_keys"]:
        r[k] = None
    cur = node.get("parent")
    for _ in range(16):
        if cur == None:
            break
        owner = canonical_repo(cur["repository"]["nameWithOwner"]).split("/")[0]
        t = type_of(models.get(owner) or model, cur.get("issueType"), [label["name"] for label in _nodes(cur.get("labels"))])
        if t != None and key_of(t) in model["ancestor_keys"] and r[key_of(t)] == None:
            r[key_of(t)] = _key(cur)
        cur = cur.get("parent")

    if model["user"]:
        for family in USER_ATTRIBUTES:
            r[family["key"]] = None
            for label in family["labels"]:
                if label in label_names:
                    r[family["key"]] = family["names"][label]
                    break
    else:
        values = {}
        for v in _nodes(node.get("issueFieldValues")):
            if type(v) != "dict" or type(v.get("field")) != "dict":
                continue
            values[v["field"].get("name")] = v["name"] if "name" in v else _number(v.get("value"))
        for f in model["fields"]:
            r[key_of(f["name"])] = values.get(f["name"])

    owners = owners_of(model)
    rows = [_row(item) for item in _nodes(node.get("projectItems"))]
    summary = node.get("subIssuesSummary") or {}
    r["home"] = [row for row in rows if kind_of_project(row["project"], owners) in HOME_KINDS]
    r["in_triage"] = len([row for row in rows if kind_of_project(row["project"], owners) == TRIAGE_KIND]) > 0
    r["sub_issues_total"] = int(summary.get("total") or 0)
    r["sub_issues_completed"] = int(summary.get("completed") or 0)
    r["labels"] = label_names
    r["assignees"] = [a["login"] for a in _nodes(node.get("assignees"))]
    r["blocked_by"] = [_key(b) for b in _nodes(node.get("blockedBy"))]
    r["projects"] = rows
    r["created_at"] = node.get("createdAt")
    r["updated_at"] = node.get("updatedAt")
    r["closed_at"] = node.get("closedAt")
    return r

def pairs(nodes, models):
    """Each issue's record with the node it came from, by repository and number, each issue once."""
    seen = {}
    out = []
    for node in nodes:
        r = record(node, models)
        if r["issue"] in seen:
            continue
        seen[r["issue"]] = True
        out.append((r, node))
    return sorted(out, key = lambda p: (p[0]["repository"], int(p[0]["issue"].split("#")[-1])))

def records(nodes, models):
    """Each issue's record, by repository and number."""
    return [p[0] for p in pairs(nodes, models)]
