# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github triage sweep: every open issue that breaks a classification rule, added to its team's Triage project."""

# github-triage-sweep.star
#
# docs/plans/feature/436-triage-sweep.md, Requirement 3 (noblefactor-engprod#436). The sweep reads every open issue of
# each account's participating repositories, checks each against the rules below, and adds each with a fault, not
# already there, to its team's Triage project with Status Open, reading the row back, and comments on it naming each
# rule it broke (ruled 2026-11-04), so that triage knows why it came. It never removes a row from any
# project: a Triage row sits beside an issue's home and never takes it off a schedule or a scenario (ruled 2026-11-08).
# Its result is its output: one flat record for each issue it added, found in Triage with a fault, or found a Triage row,
# so that star's --filter and --jq narrow it and CSV renders it as they do the report's (ruled 2026-11-08); a non-zero
# exit is an error and nothing else (ruled 2026-11-08).

load("commands/access.star", "check_access")
load("commands/accounts.star", "default_accounts")
load("commands/model.star", "refuse_dry_run")
load("commands/records.star", "fetch", "json_lines", "pairs", "quote", "sh")
load(
    "commands/scheme.star",
    "TRIAGE_KIND",
    "USER_ATTRIBUTES",
    "leaf_level",
    "models_for",
    "owners_of",
    "team_of",
    "type_named",
    "type_of",
)

# ── the rules ───────────────────────────────────────────────────────────────
#
# Ruled 2026-11-04, from #303's closing, as #436's comments record them, and the step order on 2026-11-08. Each rule is
# a ruling about a named attribute, type, label or project field, so each names what it checks, here and nowhere else.

_AREA = "area"
_SEVERITY = "severity"
_RESOLUTION = "resolution"
_NOT_APPLICABLE = "N/A"
_GOOD_FIRST_ISSUE = "good first issue"

# A task's or a bug's body ends with its Evidence of completion; a Scenario issue summarizes an end-user goal instead.
_EVIDENCE = "(?mi)^#{1,6}[ \\t]*Evidence of completion\\b"
_EVIDENCE_EXEMPT = ["Scenario"]

# A Scenario project's rows meet the two structural rules alone, until an item moves out (section 6, `projects`).
_SCENARIO_KIND = "Scenario"

# A Schedule project's row names its schedule and its step; a Triage row's Status starts Open.
_SCHEDULE = "schedule"
_STEP = "step"
_STATUS_FIELD = "Status"
_OPEN = "Open"

def _fault(rule, message):
    """One fault: the rule's fixed name, to match on, and the same fault in plain words, for a person."""
    return {"rule": rule, "message": message}

def _projects(home):
    """The projects of an issue's home rows, named, for a message."""
    return ", ".join([h["project"] for h in home])

def faults(r, node, model, by_key):
    """The rules an open issue breaks, each a fault; none when it breaks none.

    A scenario's row meets the two structural rules alone: an epic or a feature on a collection, and more than one home.
    The step order compares a step with each open issue it is blocked by on the same schedule of the same project.
    """
    out = []
    t = type_named(model, r["type"]) if r["type"] else None
    level = t.get("level") if t != None else None
    leaf = leaf_level(model)

    if len(r["home"]) > 1:
        out.append(_fault("two-homes", "more than one home: " + _projects(r["home"])))
    if len(r["home"]) > 0 and level != None and level != leaf:
        out.append(_fault("epic-on-collection", "a " + r["type"] + " is a row of " + _projects(r["home"]) +
                                                "; an epic or a feature is on no Backlog, Schedule or Scenario project"))
    if len([h for h in r["home"] if (h["project"] or "").startswith(_SCENARIO_KIND + ": ")]) > 0:
        return out

    if r.get(_AREA) == None:
        out.append(_fault("no-area", "no Area"))
    severity = r.get(_SEVERITY)
    named = r["type"] or "an issue of no type"
    if t != None and t.get("unplanned"):
        if severity == None or severity == _NOT_APPLICABLE:
            out.append(_fault("severity", "a " + r["type"] + " whose Severity is " + (severity or "blank") + "; a bug is Critical, High, Medium or Low"))
    elif severity != _NOT_APPLICABLE:
        out.append(_fault("severity", named + " whose Severity is " + (severity or "blank") + "; every issue but a bug has Severity " + _NOT_APPLICABLE))
    if r.get(_RESOLUTION) != None:
        out.append(_fault("resolution-open", "an open issue with Resolution " + r[_RESOLUTION] + "; a Resolution goes only on a closed issue"))
    if model["user"]:
        for family in USER_ATTRIBUTES:
            mine = [label for label in family["labels"] if label in r["labels"]]
            if len(mine) > 1:
                out.append(_fault("two-labels", "two " + family["key"] + ": labels: " + ", ".join(mine)))
    if _GOOD_FIRST_ISSUE in r["labels"] and level != leaf:
        out.append(_fault("good-first-issue", _GOOD_FIRST_ISSUE + " on " + named + "; it goes on tasks and bugs only"))
    if r["type"] not in _EVIDENCE_EXEMPT and not regex.match(pattern = _EVIDENCE, text = node.get("body") or ""):
        out.append(_fault("no-evidence", "no Evidence of completion section"))

    blockers = [b for b in ((node.get("blockedBy") or {}).get("nodes") or []) if b.get("state") == "OPEN"]
    for h in r["home"]:
        if h.get(_SCHEDULE) == None or h.get(_STEP) == None:
            continue
        for b in blockers:
            k = b["repository"]["nameWithOwner"] + "#" + str(int(b["number"]))
            other = by_key.get(k)
            if other == None:
                continue
            for bh in other["home"]:
                if bh["project"] == h["project"] and bh.get(_SCHEDULE) == h[_SCHEDULE] and bh.get(_STEP) != None and bh[_STEP] >= h[_STEP]:
                    out.append(_fault("step-order", "step " + str(h[_STEP]) + " waits on " + k + ", at step " + str(bh[_STEP]) + " on the same schedule"))
    return out

# ── the Triage projects ─────────────────────────────────────────────────────

def _triage_project(model, owner):
    """The project named "Triage: <owner>" in the account, with its Status field and Open option; None when there is none."""
    title = TRIAGE_KIND + ": " + owner
    kind = "user" if model["user"] else "organization"
    query = ("query starTriage { " + kind + "(login: \"" + model["account"] + "\") { projectsV2(first: 10, query: \"" + title + "\") { nodes { " +
             "id number title fields(first: 50) { nodes { ... on ProjectV2FieldCommon { id name } ... on ProjectV2SingleSelectField { options { id name } } } } } } } }")
    for p in json_lines("gh api graphql -f query=" + quote(query) + " --jq " + quote(".data." + kind + ".projectsV2.nodes[] | tojson")):
        if p["title"] != title:
            continue
        for f in (p.get("fields") or {}).get("nodes") or []:
            if f.get("name") != _STATUS_FIELD:
                continue
            for o in f.get("options") or []:
                if o["name"] == _OPEN:
                    return {"id": p["id"], "number": int(p["number"]), "title": title, "status_field": f["id"], "open_option": o["id"]}
        fail(title + " in " + model["account"] + " has no " + _STATUS_FIELD + " field with an " + _OPEN + " option")
    return None

def _triage_rows(project, model):
    """Every issue row of a Triage project: the issue as its record names it, and the row's Status."""
    query = ("query starTriageItems($endCursor: String) { node(id: \"" + project["id"] + "\") { ... on ProjectV2 { " +
             "items(first: 100, after: $endCursor) { pageInfo { hasNextPage endCursor } nodes { id " +
             "content { ... on Issue { number title url state issueType { name } labels(first: 20) { nodes { name } } " +
             "repository { nameWithOwner } } } " +
             "status: fieldValueByName(name: \"" + _STATUS_FIELD + "\") { ... on ProjectV2ItemFieldSingleSelectValue { name } } } } } } }")
    rows = []
    for item in json_lines("gh api graphql --paginate -f query=" + quote(query) + " --jq " + quote(".data.node.items.nodes[] | tojson")):
        content = item.get("content") or {}
        if not content.get("number"):
            continue
        labels = [label["name"] for label in ((content.get("labels") or {}).get("nodes") or [])]
        rows.append({
            "issue": content["repository"]["nameWithOwner"] + "#" + str(int(content["number"])),
            "type": type_of(model, content.get("issueType"), labels),
            "state": (content.get("state") or "").lower(),
            "title": content.get("title"),
            "url": content.get("url"),
            "status": (item.get("status") or {}).get("name"),
        })
    return rows

def _add(project, issue, node_id):
    """Add an issue to a Triage project with Status Open, and read the row back; fails when it does not read back so."""
    item = sh("gh api graphql -f query=" + quote("mutation starAddToTriage { addProjectV2ItemById(input: {projectId: \"" + project["id"] +
                                                 "\", contentId: \"" + node_id + "\"}) { item { id } } }") +
              " --jq .data.addProjectV2ItemById.item.id").strip()
    sh("gh api graphql -f query=" + quote("mutation starSetStatus { updateProjectV2ItemFieldValue(input: {projectId: \"" + project["id"] +
                                          "\", itemId: \"" + item + "\", fieldId: \"" + project["status_field"] + "\", value: {singleSelectOptionId: \"" +
                                          project["open_option"] + "\"}}) { projectV2Item { id } } }"))
    back = sh("gh api graphql -f query=" + quote("query starItem { node(id: \"" + item + "\") { ... on ProjectV2Item { project { id } " +
                                                 "status: fieldValueByName(name: \"" + _STATUS_FIELD + "\") { ... on ProjectV2ItemFieldSingleSelectValue { name } } } } }") +
              " --jq " + quote("\"\\(.data.node.project.id) \\(.data.node.status.name)\"")).strip()
    if back != project["id"] + " " + _OPEN:
        fail(issue + "'s row on " + project["title"] + " reads back as " + back + ", not " + project["id"] + " " + _OPEN)

def _comment(project, issue, node_id, found):
    """Comment on an issue the sweep added, naming each rule it broke, so that triage knows why it came (ruled 2026-11-04)."""
    lines = ["star github triage sweep added this issue to " + project["title"] + ", for the rule" +
             ("s" if len(found) > 1 else "") + " it breaks:", ""]
    lines.extend(["- `" + f["rule"] + "`: " + f["message"] for f in found])
    comment = sh("gh api graphql -f s=" + quote(node_id) + " -f b=" + quote("\n".join(lines)) + " -f query=" +
                 quote("mutation starComment($s: ID!, $b: String!) { addComment(input: {subjectId: $s, body: $b}) { commentEdge { node { id } } } }") +
                 " --jq .data.addComment.commentEdge.node.id").strip()
    if comment == "":
        fail("the comment on " + issue + " naming its rules was not made")

# ── the sweep ───────────────────────────────────────────────────────────────

def _record(account, project, issue, action, status, found, home):
    """One record of the result: the account, the Triage project, the issue, what the sweep did, and why.

    Every record carries every key. rules names the faults' rules in one string, comma-separated and empty when there
    are none, so that --filter and a CSV column reach them; faults carries each with its message.
    """
    return {
        "account": account,
        "project": project["title"],
        "issue": issue["issue"],
        "type": issue["type"],
        "state": issue["state"],
        "title": issue["title"],
        "url": issue["url"],
        "action": action,
        "status": status,
        "rules": ",".join([f["rule"] for f in found]),
        "faults": found,
        "home": home,
    }

def _sweep(account, models, dry_run):
    """One account's sweep: its open issues read and checked, each with a fault added to its team's Triage project.

    The records, by project and then by repository and number: each issue added, or under --dry-run to be added; each
    already in Triage with a fault; and each other row of the Triage project, with no fault.
    """
    model = models[account]
    checked = pairs(fetch(model["repositories"], models, open_only = True, with_body = True), models)
    by_key = {p[0]["issue"]: p[0] for p in checked}
    found = {}
    order = []
    for r, node in checked:
        f = faults(r, node, model, by_key)
        if f:
            found[r["issue"]] = {"record": r, "faults": f, "id": node["id"]}
            order.append(r["issue"])

    records = []
    for owner in owners_of(model):
        mine = [k for k in order if team_of(model, found[k]["record"]["repository"]) == owner]
        if not model["user"] and len([repo for repo in model["repositories"] if team_of(model, repo) == owner]) == 0:
            continue
        project = _triage_project(model, owner)
        if project == None:
            if mine:
                fail("no project named " + TRIAGE_KIND + ": " + owner + " in " + account + ", for " + str(len(mine)) + " issue(s) with faults")
            continue
        rows = _triage_rows(project, model)
        there = {row["issue"]: row for row in rows}
        for k in mine:
            r = found[k]["record"]
            if k in there:
                records.append(_record(account, project, r, "in-triage", there[k]["status"], found[k]["faults"], r["home"]))
                continue
            if not dry_run:
                _add(project, k, found[k]["id"])
                _comment(project, k, found[k]["id"], found[k]["faults"])
            records.append(_record(account, project, r, "would-add" if dry_run else "added", _OPEN, found[k]["faults"], r["home"]))
        for row in rows:
            if row["issue"] in found:
                continue
            home = by_key[row["issue"]]["home"] if row["issue"] in by_key else []
            records.append(_record(account, project, row, "row", row["status"], [], home))
    return sorted(records, key = lambda x: (x["project"], x["issue"].split("#")[0], int(x["issue"].split("#")[-1])))

def run(_command, ctx):
    """Check gh's access, read each account's record against its model, then sweep each account named, or every one with a model.

    With no account named, it sweeps the default account and the owner of each of writ's layer repositories. Each
    account's model is read from GitHub when the sweep runs (noblefactor-engprod#426).

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the accounts named; ctx.dry_run, star's --dry-run, under which nothing is added.
    """
    refuse_dry_run(ctx.dry_run)
    check_access("star github triage sweep", scopes = ["project"], dry_run = ctx.dry_run)
    accounts = [a.strip() for a in (ctx.args.get("accounts") or []) if a.strip()] or default_accounts()
    models = models_for(accounts)
    records = []
    for account in accounts:
        records.extend(_sweep(account, models, ctx.dry_run))
    return records
