# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github issue reopen: issues reopened, with their rows, their closed parents and the closed schedules they are on."""

# github-issue-reopen.star
#
# docs/plans/doc/589-issue-verbs.md (noblefactor-engprod#587), to section 10 of the issue data model, § Reopening an
# issue. For each issue, in section 10's order:
#
#   1. The issue reopened, its Resolution cleared, the issue field in an organization or each resolution: label in a
#      user account, and a comment, from templates/issue-reopen.md.template.
#   2. Its rows: a Schedule row set Open, its Worktree kept, since no one has taken it up again; a Backlog row set Open.
#      An issue that has no row on its team's Triage, Backlog, Schedule or Scenario project gets a Triage row, since the
#      Triage workflow runs only when an issue is opened.
#   3. Each closed parent, its feature and then its epic, reopened the same way, its comment naming the issue.
#   4. Each closed schedule it is a step of reopened, by what star github schedule reopen does (ending.star): the
#      Schedule issue reopened with its comment, its own row In progress, and its every-step exit criterion unticked.
#
# Everything is read before the first write, so that a fault is a refusal with nothing written (#531); each write is
# read back, and noted as it is made. A Schedule or Scenario issue is refused, naming its group's reopen (ruled
# 2026-11-17, #595). An issue already open is not reopened again, and its rows are left as they are; its closed parents
# and closed schedules are reopened. One with none is unchanged.

load("commands/access.star", "check_access")
load("commands/ending.star", "reopen_schedule", "schedule_reopening")
load(
    "commands/issues.star",
    "BACKLOG",
    "TRIAGE",
    "clear_resolution",
    "clearing_plan",
    "collection_refusal",
    "parents_of",
    "render",
    "resolution_of",
)
load("commands/model.star", "refuse_dry_run")
load("commands/scheme.star", "model_for", "models_for", "team_of")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "comment",
    "issue",
    "issue_state",
    "parse_key",
    "project_named",
    "project_of",
    "put_open",
    "read_row",
    "reopen_issue",
    "set_option",
    "today",
    "viewer",
)

_COMMAND = "star github issue reopen"
_STATUS = "Status"
_OPEN = "Open"
_KINDS = [TRIAGE, BACKLOG, SCHEDULE_KIND, SCENARIO_KIND]

def _record(key, action, project = None, resolution = None, reopened_for = None, criteria = None):
    """One flat record of what reopen did: reopened, row-opened, triaged or unchanged."""
    return {
        "issue": key,
        "action": action,
        "project": project,
        "resolution_cleared": resolution,
        "for": reopened_for,
        "criteria_unticked": criteria,
    }

def _rows(r, model, projects):
    """What reopen does to a reopened issue's rows, read before anything is written: (changes, refusals)."""
    changes, refused = [], []
    for row in r["rows"]:
        if not ((row["kind"] == SCHEDULE_KIND and row["schedule"] != None) or row["kind"] == BACKLOG) or row["status"] == _OPEN:
            continue
        project = project_of(row["project"]["id"])
        found = [o["id"] for o in project["fields"].get(_STATUS, {"options": []})["options"] if o["name"] == _OPEN]
        if not found:
            refused.append(project["title"] + "'s " + _STATUS + " field has no option " + _OPEN + ", for " + r["key"])
            continue
        changes.append({"do": "row-opened", "row": row, "project": project, "option": found[0]})
    if [row for row in r["rows"] if row["kind"] in _KINDS]:
        return changes, refused
    team = team_of(model, r["repo"])
    if team == None:
        refused.append("no team maintains " + r["repo"] + ", so " + r["key"] + " has no " + TRIAGE + " project")
        return changes, refused
    title = TRIAGE + ": " + team
    at = model["account"].lower() + "/" + title
    if at not in projects:
        projects[at] = project_named(model, title)
    if projects[at] == None:
        refused.append(model["account"] + " has no project " + title + ", for " + r["key"])
    else:
        changes.append({"do": "triaged", "project": projects[at]})
    return changes, refused

def _schedules(r, model, planned):
    """The closed schedules an issue is a step of, each read for its reopening, once a run: (plans, refusals)."""
    plans, refused = [], []
    for row in r["rows"]:
        if row["kind"] != SCHEDULE_KIND or row["schedule"] == None:
            continue
        options = project_of(row["project"]["id"])["fields"].get("Schedule", {"options": []})["options"]
        key = ([(o.get("description") or "").strip() for o in options if o["name"] == row["schedule"]] + [""])[0]
        if key == "":
            refused.append(r["key"] + " is on " + row["project"]["title"] + "'s schedule " + row["schedule"] + ", whose option names no Schedule issue")
            continue
        if key in planned:
            continue
        planned[key] = True
        plan, fault = schedule_reopening(key, model)
        if fault:
            refused.append(fault)
        elif plan["sched"]["issue"]["state"] == "closed":
            plans.append(plan)
    return plans, refused

def _reopen(r, model, plan, body):
    """An issue reopened, its Resolution cleared as plan gives it, and its comment; each read back."""
    reopen_issue(r)
    if issue_state(r)["state"] != "open":
        fail(r["key"] + " does not read back open after it was reopened")
    note("reopened " + r["key"])
    if plan != None:
        clear_resolution(r, plan)
        if resolution_of(model, r) != None:
            fail(r["key"] + " reads back with the Resolution " + str(resolution_of(model, r)) + " after it was cleared")
        note("cleared " + r["key"] + "'s Resolution " + plan["name"])
    comment(r, body)
    note("commented on " + r["key"])

def _change(r, change):
    """One row's change written and read back: its record."""
    if change["do"] == "triaged":
        put_open(change["project"], r)
        note("put " + r["key"] + " on " + change["project"]["title"])
        return _record(r["key"], "triaged", project = change["project"]["title"])
    row = change["row"]
    set_option(change["project"], row["item"], _STATUS, change["option"])
    back = read_row(row["item"])
    if back == None or back["status"] != _OPEN:
        fail(r["key"] + "'s row on " + change["project"]["title"] + " reads back " + str(back) + ", not Open")
    note("set " + r["key"] + "'s row on " + change["project"]["title"] + " Open")
    return _record(r["key"], "row-opened", project = change["project"]["title"])

def run(_command, ctx):
    """Check the flags and gh's access, read every issue, its parents and its schedules, then reopen each, in order.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the issues and --reason; ctx.dry_run, star's --dry-run, which reopen refuses
        until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    issues = [i.strip() for i in (ctx.args.get("issues") or []) if i.strip()]
    if not issues:
        fail("issue reopen needs one issue or more, <owner>/<repository>#<number>")
    keys = [parse_key(i)["key"] for i in issues]
    if len({k: True for k in keys}) != len(keys):
        fail("an issue is named twice: " + ", ".join(keys))
    reason = " ".join((ctx.args.get("reason") or "").split())
    if reason == "":
        fail("issue reopen needs --reason: it is written in the comment on each issue it reopens")
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)

    # Everything read first: each issue, its rows, its Resolution, its closed parents and its closed schedules.
    models = models_for([parse_key(k)["owner"] for k in keys])
    projects, planned, work, refused = {}, {k: True for k in keys}, [], []
    for k in keys:
        model = model_for(models, parse_key(k)["repo"])
        r = issue(k, model)
        why = collection_refusal(r, "reopen")
        if why != "":
            refused.append(why)
            continue
        w = {"r": r, "model": model, "clear": None, "changes": [], "parents": [], "schedules": []}
        if r["state"] == "closed":
            w["clear"] = clearing_plan(model, r)
            w["changes"], faults = _rows(r, model, projects)
            refused.extend(faults)
        for p in parents_of(k):
            if p["state"] != "closed" or p["key"] in planned:
                continue
            planned[p["key"]] = True
            pm = model_for(models, parse_key(p["key"])["repo"])
            pr = issue(p["key"], pm)
            w["parents"].append({"r": pr, "model": pm, "clear": clearing_plan(pm, pr)})
        w["schedules"], faults = _schedules(r, model, planned)
        refused.extend(faults)
        work.append(w)
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    date, login = today(), viewer()

    def body(cause):
        return render("issue-reopen.md.template", {"command": _COMMAND, "date": date, "login": login, "reason": reason, "cause": cause})

    out = []
    for w in work:
        r = w["r"]
        if r["state"] == "closed":
            _reopen(r, w["model"], w["clear"], body(""))
            out.append(_record(r["key"], "reopened", resolution = w["clear"]["name"] if w["clear"] != None else None))
            for change in w["changes"]:
                out.append(_change(r, change))
        for p in w["parents"]:
            _reopen(p["r"], p["model"], p["clear"], body(r["key"]))
            out.append(_record(p["r"]["key"], "reopened", resolution = p["clear"]["name"] if p["clear"] != None else None, reopened_for = r["key"]))
        for s in w["schedules"]:
            done = reopen_schedule(s, body(r["key"]))
            out.append(_record(done["issue"], "reopened", project = s["sched"]["project"]["title"], reopened_for = r["key"], criteria = done["criteria"]))
        if r["state"] != "closed" and not w["parents"] and not w["schedules"]:
            out.append(_record(r["key"], "unchanged"))
    return out
