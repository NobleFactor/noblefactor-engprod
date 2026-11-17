# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github issue close: issues closed, each with its evidence or its Resolution, and its rows, in one act."""

# github-issue-close.star
#
# docs/plans/doc/589-issue-verbs.md (noblefactor-engprod#590), to section 10 of the issue data model, § Closing an
# issue. An issue whose work was done closes with its evidence; one whose work was not done closes as completed with its
# Resolution saying why, and GitHub's not_planned is not used (ruled 2026-11-03). For each issue, in this order, the
# issue closed last, so that a run that stops partway leaves it open, where the same command run again finds it:
#
#   1. Its rows: on a Schedule project, Status Closed, the row kept (section 8, question 5); on a Scenario project, a
#      comment on the Scenario issue that the item closed, then the row removed (section 9, question 7); on Triage and
#      on Backlog, the row removed.
#   2. The comment: the evidence file, or the Resolution and the reason, from templates/issue-close.md.template.
#   3. The Resolution: the issue field in an organization, the resolution: label in a user account.
#   4. The issue closed, as completed.
#
# Everything is read before the first write, so that a fault is a refusal with nothing written (#531); each write is
# read back, and noted as it is made. A Schedule or Scenario issue is refused, naming its group's close (ruled
# 2026-11-17, #595). An issue already closed is finished: any row of it the steps above would change is changed. It
# doesn't close a parent with its last open child (ruled 2026-11-17); its record names the parent then.

load("commands/access.star", "check_access")
load(
    "commands/issues.star",
    "BACKLOG",
    "RESOLUTIONS",
    "TRIAGE",
    "collection_refusal",
    "parent_of",
    "render",
    "resolution_of",
    "resolution_plan",
    "scenario_of",
    "set_resolution",
)
load("commands/model.star", "read_text", "refuse_dry_run")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "model_for", "models_for")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "close_issue",
    "comment",
    "delete_row",
    "issue",
    "issue_state",
    "option_of",
    "parse_key",
    "project_of",
    "read_row",
    "set_option",
    "today",
    "viewer",
)

_COMMAND = "star github issue close"
_STATUS = "Status"
_CLOSED = "Closed"

def _record(key, action, project = None, scenario = None, resolution = None, parent = None):
    """One flat record of what close did: closed, left, row-closed or unchanged."""
    return {"issue": key, "action": action, "project": project, "scenario": scenario, "resolution": resolution, "last_child_of": parent}

def _evidence_text(path):
    """The evidence file's text; fails, naming the path, when it is missing or empty."""
    if sh("[ -s " + quote(path) + " ] && echo yes || true").strip() != "yes":
        fail("--evidence names " + path + ", which is missing or empty: the evidence is what a comment on the issue shows")
    return read_text(path).strip()

def _with_heading(text, title):
    """The evidence as its comment, headed ## Evidence: <title> when its first line is no heading of its own."""
    lines = [line for line in text.split("\n") if line.strip()]
    if lines and lines[0].lstrip().startswith("#"):
        return text
    return "## Evidence: " + title + "\n\n" + text

def _rows(r, model):
    """What close does to each of an issue's rows, read before anything is written: (changes, refusals)."""
    changes, refused = [], []
    for row in r["rows"]:
        if row["kind"] == SCHEDULE_KIND and row["schedule"] != None:
            if row["status"] != _CLOSED:
                changes.append({"row": row, "do": "row-closed"})
        elif row["kind"] == SCENARIO_KIND and row["scenario"] != None:
            source, fault = scenario_of(r, row, model)
            if fault:
                refused.append(fault)
            else:
                changes.append({"row": row, "do": "left", "scenario": source})
        elif row["kind"] in [TRIAGE, BACKLOG]:
            changes.append({"row": row, "do": "left"})
    return changes, refused

def _change(r, change, date, login, resolution):
    """One row's change written and read back: its record."""
    row = change["row"]
    title = row["project"]["title"]
    if change["do"] == "row-closed":
        project = project_of(row["project"]["id"])
        set_option(project, row["item"], _STATUS, option_of(project, _STATUS, _CLOSED))
        back = read_row(row["item"])
        if back == None or back["status"] != _CLOSED:
            fail(r["key"] + "'s row on " + title + " reads back " + str(back) + ", not Closed")
        note("set " + r["key"] + "'s row on " + title + " Closed")
        return _record(r["key"], "row-closed", project = title)
    scenario = change.get("scenario")
    if scenario != None:
        comment(scenario["issue"], render("issue-close-scenario.md.template", {
            "issue": r["key"],
            "date": date,
            "login": login,
            "resolution": resolution or "",
        }))
        note("commented on " + scenario["key"] + " that " + r["key"] + " closed and left it")
    delete_row(row["project"]["id"], row["item"])
    if read_row(row["item"]) != None:
        fail(r["key"] + "'s row on " + title + " is still there after it was removed")
    note("took " + r["key"] + "'s row off " + title)
    return _record(r["key"], "left", project = title, scenario = scenario["key"] if scenario != None else None)

def run(_command, ctx):
    """Check the flags and gh's access, read every issue, then close each, in the order given.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the issues, and --evidence, or --resolution with --reason; ctx.dry_run, star's
        --dry-run, which close refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    issues = [i.strip() for i in (ctx.args.get("issues") or []) if i.strip()]
    if not issues:
        fail("issue close needs one issue or more, <owner>/<repository>#<number>")
    keys = [parse_key(i)["key"] for i in issues]
    if len({k: True for k in keys}) != len(keys):
        fail("an issue is named twice: " + ", ".join(keys))
    evidence = (ctx.args.get("evidence") or "").strip()
    resolution = (ctx.args.get("resolution") or "").strip()
    reason = " ".join((ctx.args.get("reason") or "").split())
    if (evidence == "") == (resolution == ""):
        fail("issue close takes one of --evidence, for work done, and --resolution, for work not done; " +
             ("neither was given" if evidence == "" else "both were given"))
    if resolution != "":
        named = [r for r in RESOLUTIONS if r.lower() == resolution.lower()]
        if not named:
            fail("--resolution is one of " + ", ".join(RESOLUTIONS) + ", not " + resolution)
        resolution = named[0]
        if reason == "":
            fail("--resolution needs --reason: the comment on the issue says why its work was not done")
    elif reason != "":
        fail("--reason goes with --resolution; with --evidence, the evidence says what was done")
    text = _evidence_text(evidence) if evidence != "" else ""
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)

    # Everything read first: each issue, its rows, each scenario it is on, its Resolution's form and its parent.
    models = models_for([parse_key(k)["owner"] for k in keys])
    work, refused = [], []
    for k in keys:
        model = model_for(models, parse_key(k)["repo"])
        r = issue(k, model)
        why = collection_refusal(r, "close")
        if why != "":
            refused.append(why)
            continue
        changes, faults = _rows(r, model)
        refused.extend(faults)
        plan = None
        if resolution != "" and r["state"] != "closed":
            plan, fault = resolution_plan(model, resolution)
            if fault != "":
                refused.append(k + ": " + fault)
        parent = parent_of(k) if r["state"] != "closed" else None
        work.append({"r": r, "model": model, "changes": changes, "plan": plan, "parent": parent})
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    login = viewer()
    date = today()
    out = []
    for w in work:
        r = w["r"]
        for change in w["changes"]:
            out.append(_change(r, change, date, login, resolution if w["plan"] != None else None))
        if r["state"] == "closed":
            if not w["changes"]:
                out.append(_record(r["key"], "unchanged"))
            continue

        if text != "":
            comment(r, _with_heading(text, r["title"]))
        else:
            comment(r, render("issue-close.md.template", {"date": date, "login": login, "resolution": resolution, "reason": reason}))
        note("commented on " + r["key"])
        if w["plan"] != None:
            set_resolution(r, w["plan"])
            if resolution_of(w["model"], r) != w["plan"]["name"]:
                fail(r["key"] + " reads back with the Resolution " + str(resolution_of(w["model"], r)) + ", not " + w["plan"]["name"])
            note("set " + r["key"] + "'s Resolution " + w["plan"]["name"])
        close_issue(r)
        state = issue_state(r)
        if state["state"] != "closed" or state["reason"] != "completed":
            fail(r["key"] + " reads back " + str(state["state"]) + ", " + str(state["reason"]) + ", not closed as completed")
        note("closed " + r["key"] + " as completed")
        last = w["parent"]["key"] if w["parent"] != None and w["parent"]["open"] == 1 else None
        out.append(_record(r["key"], "closed", resolution = w["plan"]["name"] if w["plan"] != None else None, parent = last))
    return out
