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
#   2. Its rows: each row on its team's Triage, Backlog, Schedule or Scenario project set Open, a Schedule row's
#      Worktree kept, since no one has taken it up again.
#      An issue that has no row on its team's Triage, Backlog, Schedule or Scenario project gets a Triage row, since the
#      Triage workflow runs only when an issue is opened.
#   3. Each closed parent, its feature and then its epic, reopened the same way, its comment naming the issue, and its
#      rows as the issue's are: one with no row, as close leaves a feature or an epic it took off the Backlog, gets a
#      Triage row.
#   4. Each closed schedule it is a step of reopened, by what star github schedule reopen does (ending.star): the
#      Schedule issue reopened with its comment, its own row In progress, and its every-step exit criterion unticked.
#
# Everything is read before the first write, so that a fault is a refusal with nothing written (#531); each write is
# read back, and noted as it is made. A Schedule or Scenario issue is refused, naming its group's reopen (ruled
# 2026-11-17, #595).
#
# reopen is idempotent (D-013, #609): run again, it ends where one complete run would have ended. It chooses its work
# from each issue's records, not its history: an issue, a parent or a schedule that is open but still holds a
# Resolution, a Closed row, a row without a Status, no row, a ticked every-step criterion, or no reopening's comment
# since it last closed gets only what is missing. So a run that stopped partway is finished, and so is an issue
# reopened on GitHub's page. An issue that has never closed gets no comment. One with nothing left is unchanged.

load("commands/access.star", "check_access")
load("commands/ending.star", "reopen_schedule", "schedule_reopening", "schedule_unfinished")
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
    "current",
    "issue",
    "issue_state",
    "lifecycle",
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
_CLOSED = "Closed"
_KINDS = [TRIAGE, BACKLOG, SCHEDULE_KIND, SCENARIO_KIND]

# The opening words of a reopening's comment, by which a second run knows the issue's current reopening has one (#609).
_REOPENED = "Reopened by `star github "

def _record(key, action, project = None, resolution = None, reopened_for = None, criteria = None, already = None):
    """One flat record of what reopen did: reopened, row-opened, triaged or unchanged; already, on an issue already open."""
    return {
        "issue": key,
        "action": action,
        "project": project,
        "resolution_cleared": resolution,
        "for": reopened_for,
        "criteria_unticked": criteria,
        "already": already,
    }

def _needs_comment(r, events):
    """Whether an issue's reopening still needs its comment (#609).

    It does when the issue is closed, or has closed before, as a close or a reopen event in its history says, and its
    history since it last closed holds no reopening's comment. An issue that has never closed gets none, whatever else
    reopen sets right on it.
    """
    if r["state"] != "closed" and not [e for e in events if e["kind"] in ["closed", "reopened"]]:
        return False
    return not [e for e in current(events, "closed") if e["kind"] == "comment" and e["body"].startswith(_REOPENED)]

def _unfinished(r, model, projects):
    """What reopen still has to write on an issue, read before anything is written: (its work or None, refusals).

    reopen chooses its work from the issue's records, not its history (#609): the issue reopened when it is closed, its
    Resolution cleared when it has one, its comment when _needs_comment says so, and its rows as _rows has them. An issue
    with none of these is None.
    """
    events = lifecycle(r)
    changes, refused = _rows(r, model, projects)
    w = {
        "r": r,
        "model": model,
        "clear": clearing_plan(model, r),
        "comment": _needs_comment(r, events),
        "changes": changes,
    }
    if r["state"] != "closed" and w["clear"] == None and not w["comment"] and not changes:
        return None, refused
    return w, refused

def _rows(r, model, projects):
    """What reopen does to a reopened issue's rows, read before anything is written: (changes, refusals)."""
    changes, refused = [], []
    for row in r["rows"]:
        # Only a Closed row, which only close sets, or one without a Status, which a stopped run leaves, is set Open; an
        # Open or In progress row is right as it is (#609).
        if row["kind"] not in _KINDS or row["status"] not in [_CLOSED, None, ""]:
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
    elif not [o for o in projects[at]["fields"].get(_STATUS, {"options": []})["options"] if o["name"] == _OPEN]:
        refused.append(title + "'s " + _STATUS + " field has no option " + _OPEN + ", for " + r["key"])
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
        elif schedule_unfinished(plan):
            plans.append(plan)
    return plans, refused

def _reopen(w, body):
    """An issue reopened, unless it is open; its Resolution cleared, if it has one; and its comment, if it needs one.

    Each is read back. w is the issue's work, as _unfinished read it (#609).
    """
    r, model, plan = w["r"], w["model"], w["clear"]
    if r["state"] == "closed":
        reopen_issue(r)
        if issue_state(r)["state"] != "open":
            fail(r["key"] + " does not read back open after it was reopened")
        note("reopened " + r["key"])
    if plan != None:
        clear_resolution(r, plan)
        if resolution_of(model, r) != None:
            fail(r["key"] + " reads back with the Resolution " + str(resolution_of(model, r)) + " after it was cleared")
        note("cleared " + r["key"] + "'s Resolution " + plan["name"])
    if w["comment"]:
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

    # GitHub names an account and a repository in any case, so a key is compared in lower case.
    if len({k.lower(): True for k in keys}) != len(keys):
        fail("an issue is named twice: " + ", ".join(keys))
    reason = " ".join((ctx.args.get("reason") or "").split())
    if reason == "":
        fail("issue reopen needs --reason: it is written in the comment on each issue it reopens")
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)

    # Everything read first: each issue, its history, its rows and its Resolution; each parent it reaches; and each
    # schedule it is a step of. Each is chosen by what its reopening still has to write, not by whether it is closed, so
    # that a run that stopped partway, and an issue reopened on GitHub's page, are finished (#609).
    models = models_for([parse_key(k)["owner"] for k in keys])
    projects, planned, work, refused = {}, {k.lower(): True for k in keys}, [], []
    for k in keys:
        model = model_for(models, parse_key(k)["repo"])
        r = issue(k, model)
        why = collection_refusal(r, "reopen")
        if why != "":
            refused.append(why)
            continue
        own, faults = _unfinished(r, model, projects)
        refused.extend(faults)
        w = {"r": r, "own": own, "parents": [], "schedules": []}
        for p in parents_of(k):
            if p["key"].lower() in planned:
                continue
            planned[p["key"].lower()] = True
            pm = model_for(models, parse_key(p["key"])["repo"])
            parent, faults = _unfinished(issue(p["key"], pm), pm, projects)
            refused.extend(faults)
            if parent != None:
                w["parents"].append(parent)
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
        r, own = w["r"], w["own"]
        if own != None:
            _reopen(own, body(""))
            already = True if r["state"] != "closed" else None
            out.append(_record(r["key"], "reopened", resolution = own["clear"]["name"] if own["clear"] != None else None, already = already))
            for change in own["changes"]:
                out.append(_change(r, change))
        for p in w["parents"]:
            _reopen(p, body(r["key"]))
            already = True if p["r"]["state"] != "closed" else None
            cleared = p["clear"]["name"] if p["clear"] != None else None
            out.append(_record(p["r"]["key"], "reopened", resolution = cleared, reopened_for = r["key"], already = already))
            for change in p["changes"]:
                out.append(_change(p["r"], change))
        for s in w["schedules"]:
            done = reopen_schedule(s, body(r["key"]))
            already = True if s["sched"]["issue"]["state"] != "closed" else None
            out.append(_record(done["issue"], "reopened", project = s["sched"]["project"]["title"], reopened_for = r["key"], criteria = done["criteria"], already = already))
        if own == None and not w["parents"] and not w["schedules"]:
            out.append(_record(r["key"], "unchanged"))
    return out
