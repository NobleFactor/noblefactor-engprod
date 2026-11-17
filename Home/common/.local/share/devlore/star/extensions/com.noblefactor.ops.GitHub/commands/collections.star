# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A schedule's or a scenario's rows, and an account's schedules or scenarios, read: get and list of both groups."""

# collections.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 3 (noblefactor-engprod#510), to section 8 of the issue data
# model, § Reading: list, get and report, and section 9, § Reading: list and get. A schedule and a scenario are read the
# same way, each an option of its team's project of its kind, titled "<kind>: <team>" in an organization and
# "<kind>: <account>" in a user account (section 3), so one implementation serves star github schedule get and list and
# star github scenario get and list. What differs is the field that numbers a row, Step or Beat, and what a row's record
# carries besides. Nothing is written. Each command returns one flat record for each row or option it read, every record
# of a command carrying the same keys, None where a row has none; star's --filter, --jq and --output narrow and render
# them, and none is bound here (section 8, § The commands).

load("commands/scheme.star", "model_of", "models_for", "owners_of")
load("commands/steps.star", "SCENARIO_KIND", "SCHEDULE_KIND", "parse_key", "project_named", "project_rows", "rows", "scenario", "schedule")

# What each kind's records carry: the key that numbers a row; what a row's record carries besides its number and its
# issue's key, type, title and state; and the keys of an option's counts of its open and closed rows.
_KINDS = {
    SCHEDULE_KIND: {"number": "step", "carries": ["status", "worktree", "iteration", "blocked_by"], "open": "open_steps", "closed": "closed_steps"},
    SCENARIO_KIND: {"number": "beat", "carries": ["status"], "open": "open_rows", "closed": "closed_rows"},
}

# A key as an option's description holds it: each Schedule and Scenario option names its own issue.
_KEY = "^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+#[0-9]+$"

# ── get ─────────────────────────────────────────────────────────────────────

def _row(kind, r):
    """One row's record: its step or Beat, its issue's key, type, title and state, and what its kind's rows carry."""
    number = _KINDS[kind]["number"]
    out = {number: r[number], "issue": r["issue"], "type": r["type"], "title": r["title"], "state": r["state"]}
    for k in _KINDS[kind]["carries"]:
        out[k] = r[k]
    return out

def get_collection(kind, key):
    """One schedule's or scenario's rows, a record each, its own issue's row first.

    Its other rows follow in the order their step or Beat gives, then any row with none, in the project's order. A
    closed schedule or a retired scenario is read too. Fails, naming why, when key names no issue, or no issue of kind
    with its own row on its account's project of kind.
    """
    k = parse_key(key)
    model = model_of(models_for([k["owner"]]), k["owner"])
    coll = (schedule if kind == SCHEDULE_KIND else scenario)(k["key"], model, reading = True)
    number = _KINDS[kind]["number"]
    rs = rows(coll, model)
    own = [r for r in rs if r["item"] == coll["own_item"]]
    others = [r for r in rs if r["item"] != coll["own_item"]]
    ordered = own + sorted([r for r in others if r[number] != None], key = lambda r: r[number]) + [r for r in others if r[number] == None]
    return [_row(kind, r) for r in ordered]

# ── list ────────────────────────────────────────────────────────────────────

def _option(kind, project, option, rs):
    """One option's record: its name, its issue's key, title, state and assignee, the project, and its rows' counts.

    The issue is the one the option's description names; its own row on the project gives its title, state and
    assignees, and is not counted. An option whose description names no issue has None for each of the issue's values.
    """
    description = (option.get("description") or "").strip()
    key = parse_key(description)["key"] if regex.match(pattern = _KEY, text = description) else None
    mine = [r for r in rs if r[kind.lower()] == option["name"]]
    own = [r for r in mine if r["issue"] == key]
    counted = [r for r in mine if r["issue"] != key]
    out = {
        kind.lower(): option["name"],
        "issue": key,
        "title": own[0]["title"] if own else None,
        "state": own[0]["state"] if own else None,
        "assignee": (", ".join(own[0]["assignees"]) or None) if own else None,
        "project": project["title"],
    }
    out[_KINDS[kind]["open"]] = len([r for r in counted if r["state"] == "open"])
    out[_KINDS[kind]["closed"]] = len([r for r in counted if r["state"] == "closed"])
    return out

def list_collections(kind, account, team):
    """Every schedule or scenario of an account, or of one of its teams: one record for each option of its projects' field.

    In an organization the project read for each team is the one titled "<kind>: <team>", and a team with none is passed
    by; in a user account, it is the one titled "<kind>: <account>". A template, or a user account's copy of one, is
    titled "<kind>" alone and is never read. team narrows an organization's to one team's, whose project must exist;
    in a user account, which has no teams, it is refused.
    """
    model = model_of(models_for([account]), account)
    owners = owners_of(model)
    if team != "":
        if model["user"]:
            fail("--team narrows an organization's " + kind.lower() + "s to a team's: " + model["account"] + " is a user account, which has no teams")
        if team not in owners:
            fail(model["account"] + " has no team " + team + "; its teams are " + ", ".join(owners))
        owners = [team]
    out = []
    for owner in owners:
        title = kind + ": " + owner
        project = project_named(model, title)
        if project == None:
            if team != "":
                fail(model["account"] + " has no open project " + title)
            continue
        if kind not in project["fields"]:
            fail(title + " has no " + kind + " field")
        rs = project_rows(project, model)
        for o in project["fields"][kind]["options"]:
            out.append(_option(kind, project, o, rs))
    return out
