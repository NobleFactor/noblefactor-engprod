# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The issue verbs' shared reads and writes: what star github issue close and reopen do to one issue."""

# issues.star
#
# docs/plans/doc/589-issue-verbs.md (noblefactor-engprod#590, #587), to section 10 of the issue data model. The issue
# verbs open, close and reopen every type but Schedule and Scenario, which their groups' verbs open, close and reopen
# (ruled 2026-11-17, #595). What they share is here: the refusal of a collection's own issue, an issue's Resolution in
# each account, the scenario an item is on, an issue's parent, and a comment rendered from a template. Every read is
# made before a command's first write, so that a fault is a refusal with nothing written (#531).

load("commands/model.star", "extension_dir", "read_text", "rest")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "USER_ATTRIBUTES")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "clear_issue_field",
    "issue",
    "issue_fields",
    "parse_key",
    "project_of",
    "set_issue_field",
)

TRIAGE = "Triage"
BACKLOG = "Backlog"
RESOLUTIONS = ["Declined", "Duplicate", "Invalid"]

_RESOLUTION = "Resolution"
_RESOLUTION_FAMILY = "resolution"
_GROUPS = {SCHEDULE_KIND: "schedule", SCENARIO_KIND: "scenario"}

# ── a collection's own issue ────────────────────────────────────────────────

def collection_refusal(r, verb):
    """Why an issue verb refuses r, a Schedule or Scenario issue, naming its group's verb; "" for any other type."""
    group = _GROUPS.get(r["type"] or "")
    if group == None:
        return ""
    return r["key"] + " is a " + r["type"] + " issue: star github " + group + " " + verb + " " + verb + "s it"

# ── a Resolution, in each account ───────────────────────────────────────────

def _family():
    """The user account's resolution: labels, each label to its Resolution's name."""
    family = [f for f in USER_ATTRIBUTES if f["key"] == _RESOLUTION_FAMILY]
    return family[0]["names"] if family else {}

def resolution_plan(model, name):
    """How a Resolution is written in the account, read from its model: ({field, option, name} or {label, name}, "").

    In an organization it is the Resolution issue field's option; in a user account, which has no issue fields, the
    resolution: label that stands in for it. A name the account doesn't have is (None, why).
    """
    if model["user"]:
        names = _family()
        labels = [label for label in sorted(names.keys()) if names[label].lower() == name.lower()]
        if not labels:
            return None, model["account"] + " has no resolution: label for " + name + "; it has " + ", ".join(sorted(names.keys()))
        return {"label": labels[0], "name": names[labels[0]]}, ""
    field = [f for f in model["fields"] if f["name"] == _RESOLUTION]
    if not field:
        return None, model["account"] + " has no " + _RESOLUTION + " issue field"
    options = field[0].get("options") or []
    found = [o for o in options if o["name"].lower() == name.lower()]
    if not found:
        return None, model["account"] + "'s " + _RESOLUTION + " field has no option " + name + "; it has " + ", ".join([o["name"] for o in options])
    return {"field": field[0]["id"], "option": found[0]["id"], "name": found[0]["name"]}, ""

def resolution_of(model, r):
    """An issue's Resolution, by name, as GitHub holds it now: its issue field, or its resolution: label; None."""
    if model["user"]:
        names = _family()
        found = [names[label] for label in issue(r["key"], model)["labels"] if label in names]
        return found[0] if found else None
    return issue_fields(r).get(_RESOLUTION)

def set_resolution(r, plan):
    """An issue's Resolution set as plan gives it: the issue field's option, or the resolution: label added."""
    if "label" in plan:
        k = parse_key(r["key"])
        rest("POST", "repos/" + k["repo"] + "/issues/" + str(k["number"]) + "/labels", {"labels": [plan["label"]]})
    else:
        set_issue_field(r, plan["field"], plan["option"])

def clearing_plan(model, r):
    """How an issue's Resolution is cleared, read before any write: {name, field} or {name, labels}; None for none.

    In an organization it is the Resolution issue field, cleared; in a user account, each resolution: label it carries,
    removed.
    """
    if model["user"]:
        names = _family()
        labels = [label for label in r["labels"] if label in names]
        return {"name": names[labels[0]], "labels": labels} if labels else None
    name = issue_fields(r).get(_RESOLUTION)
    if name == None:
        return None
    field = [f for f in model["fields"] if f["name"] == _RESOLUTION]
    if not field:
        fail(r["key"] + " has the Resolution " + name + ", and " + model["account"] + "'s model has no " + _RESOLUTION + " field")
    return {"name": name, "field": field[0]["id"]}

def clear_resolution(r, plan):
    """An issue's Resolution cleared as plan gives it: the issue field cleared, or each resolution: label removed."""
    if "labels" in plan:
        k = parse_key(r["key"])
        for label in plan["labels"]:
            rest("DELETE", "repos/" + k["repo"] + "/issues/" + str(k["number"]) + "/labels/" + label.replace(":", "%3A"))
    else:
        clear_issue_field(r, plan["field"])

# ── the scenario an item is on ──────────────────────────────────────────────

def scenario_of(r, row, model):
    """The scenario an item's row is under, read before anything is written: ({key, issue}, "") or (None, why not).

    Its Scenario issue is the one its option's description names, as every Scenario option's does.
    """
    project = project_of(row["project"]["id"])
    key = ""
    for o in project["fields"].get("Scenario", {"options": []})["options"]:
        if o["name"] == row["scenario"]:
            key = (o.get("description") or "").strip()
    if key == "":
        return None, r["key"] + " is on " + row["project"]["title"] + "'s scenario " + str(row["scenario"]) + ", whose option names no Scenario issue"
    return {"key": key, "issue": issue(key, model)}, ""

# ── an issue's parent ───────────────────────────────────────────────────────

def parent_of(key):
    """An issue's sub-issue parent, its state, and how many of its children are open: {key, state, open}, or None."""
    k = parse_key(key)
    query = ("query starStepParent { repository(owner: \"" + k["owner"] + "\", name: \"" + k["name"] + "\") { issue(number: " +
             str(k["number"]) + ") { parent { number state repository { nameWithOwner } subIssues(first: 100) { nodes { state } } } } } }")
    node = json.decode(data = sh("gh api graphql -f query=" + quote(query) + " --jq .data.repository.issue.parent") or "null")
    if node == None:
        return None
    states = [(c.get("state") or "").lower() for c in ((node.get("subIssues") or {}).get("nodes") or [])]
    return {
        "key": node["repository"]["nameWithOwner"] + "#" + str(int(node["number"])),
        "state": (node.get("state") or "").lower(),
        "open": len([s for s in states if s == "open"]),
    }

def parents_of(key):
    """An issue's sub-issue parents, nearest first, up to the one with none: its feature, then its epic."""
    out = []
    p = parent_of(key)
    for _ in range(10):
        if p == None:
            break
        out.append(p)
        p = parent_of(p["key"])
    return out

# ── a comment, from a template ──────────────────────────────────────────────

def render(name, data):
    """A comment rendered from templates/<name> with data, its whitespace folded to single spaces."""
    content = read_text(extension_dir() + "/templates/" + name)
    return " ".join(template.render_text(content = content, data = data).split())
