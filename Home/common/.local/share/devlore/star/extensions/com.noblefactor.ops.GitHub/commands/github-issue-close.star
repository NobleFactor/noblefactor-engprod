# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github issue close: issues closed, each with its evidence or its Resolution, and its rows, in one act."""

# github-issue-close.star
#
# docs/plans/doc/589-issue-verbs.md (noblefactor-engprod#590), to section 10 of the issue data model, § Closing an
# issue. An issue whose work was done closes with its evidence; one whose work was not done closes as completed with its
# Resolution saying why, and GitHub's not_planned is not used (ruled 2026-11-03). For each issue, in section 10's order
# (ruled 2026-11-17, kept as approved):
#
#   1. The comment: the evidence file, or the Resolution and the reason, from templates/issue-close.md.template.
#   2. The Resolution: the issue field in an organization, the resolution: label in a user account.
#   3. The issue closed, as completed.
#   4. Its rows: on a Schedule project, Status Closed, the row kept (section 8, question 5); on a Scenario project, a
#      comment on the Scenario issue that the item closed, then the row removed (section 9, question 7); on Triage and
#      on Backlog, the row removed.
#
# Everything is read before the first write, so that a fault is a refusal with nothing written (#531); each write is
# read back, and noted as it is made. A Schedule or Scenario issue is refused, naming its group's close (ruled
# 2026-11-17, #595). It doesn't close a parent with its last open child (ruled 2026-11-17); its record names the parent
# then.
#
# close is idempotent (D-013, #609): run again, it ends where one complete run would have ended. On an issue already
# closed, it writes only what one complete run would have written and the earlier run didn't: its closing comment, its
# Resolution, and its rows. A change of Resolution gets no comment of its own: GitHub's history records it (Codex's
# review of PR #612, H-F02). A comment is written only if the issue's history since it last reopened holds none of its
# kind, so a second run writes no second one; the comment on a Scenario issue counts only for the child it names. An
# issue with nothing left to do is unchanged, and nothing is written.

load("commands/access.star", "check_access")
load(
    "commands/issues.star",
    "BACKLOG",
    "RESOLUTIONS",
    "TRIAGE",
    "clear_resolution",
    "clearing_plan",
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
    "current",
    "delete_row",
    "issue",
    "issue_state",
    "last_at",
    "lifecycle",
    "parse_key",
    "project_of",
    "read_row",
    "row_items",
    "set_option",
    "today",
    "viewer",
)

_COMMAND = "star github issue close"
_STATUS = "Status"
_CLOSED = "Closed"

# The opening words of close's comments, by which a second run knows them (#609).
_CLOSING = "Closed by `star github issue close`"

def _record(key, action, project = None, scenario = None, resolution = None, parent = None, already = None):
    """One flat record of what close did: closed, left, row-closed or unchanged; already, on an issue already closed."""
    return {
        "issue": key,
        "action": action,
        "project": project,
        "scenario": scenario,
        "resolution": resolution,
        "last_child_of": parent,
        "already": already,
    }

def _closing_found(events, evidence):
    """Whether an issue's current close holds close's closing comment: one beginning _CLOSING, or the evidence comment."""
    for e in current(events, "reopened"):
        if e["kind"] != "comment":
            continue
        if e["body"].startswith(_CLOSING) or (evidence != "" and e["body"].strip() == evidence.strip()):
            return True
    return False

def _resolution_writes(model, r, plan):
    """What close writes of an issue's Resolution, read before any write: (the plan to set or None, the labels to remove).

    It sets the Resolution asked for when the issue doesn't hold it, and writes no comment of its own on the change:
    GitHub's history records it (#609, Codex's review of PR #612, H-F02). In a user account it removes every other
    resolution: label whether or not the one asked for needs adding, and keeps the issue's other labels (H-F01).
    """
    if "label" in plan:
        held = clearing_plan(model, r)
        others = [label for label in (held["labels"] if held != None else []) if label != plan["label"]]
        return (plan if plan["label"] not in r["labels"] else None), others
    return (plan if resolution_of(model, r) != plan["name"] else None), []

def _evidence_text(path):
    """The evidence file's text; fails, naming the path, when it is missing or empty."""
    if sh("[ -s " + quote(path) + " ] && echo yes || true").strip() != "yes":
        fail("--evidence names " + path + ", which is missing or empty: the evidence is what a comment on the issue shows")
    text = read_text(path).strip()
    if text == "":
        fail("--evidence names " + path + ", which holds only blank space: the evidence is what a comment on the issue shows")
    return text

def _with_heading(text, title):
    """The evidence as its comment, headed ## Evidence: <title> when its first line is no heading of its own."""
    lines = [line for line in text.split("\n") if line.strip()]
    if lines and lines[0].lstrip().startswith("#"):
        return text
    return "## Evidence: " + title + "\n\n" + text

def _rows(r, model):
    """What close does to each of an issue's rows, read before anything is written: (changes, refusals).

    A row on a Schedule project is set Closed, its project's Closed option read now; a row on a Scenario project leaves
    the scenario, its Scenario issue told when its option names one; a Triage or Backlog row is removed. A row of one of
    those projects with no option is changed all the same, as the project's kind has it.
    """
    changes, refused = [], []
    for row in r["rows"]:
        if row["kind"] == SCHEDULE_KIND:
            if row["status"] != _CLOSED:
                project = project_of(row["project"]["id"])
                found = [o["id"] for o in project["fields"].get(_STATUS, {"options": []})["options"] if o["name"] == _CLOSED]
                if not found:
                    refused.append(project["title"] + "'s " + _STATUS + " field has no option " + _CLOSED + ", for " + r["key"])
                else:
                    changes.append({"row": row, "do": "row-closed", "project": project, "option": found[0]})
        elif row["kind"] == SCENARIO_KIND and row["scenario"] != None:
            source, fault = scenario_of(r, row, model)
            if fault:
                refused.append(fault)
            else:
                changes.append({"row": row, "do": "left", "scenario": source, "history": lifecycle(source["issue"])})
        elif row["kind"] in [TRIAGE, BACKLOG, SCENARIO_KIND]:
            changes.append({"row": row, "do": "left"})
    return changes, refused

def _change(r, change, date, login, resolution, since):
    """One row's change written and read back: its record.

    The comment on a Scenario issue is written only if its history since since, when the item last reopened, holds
    none that begins with the item's key: one child's comment never stands in for another's (#609).
    """
    row = change["row"]
    title = row["project"]["title"]
    if change["do"] == "row-closed":
        set_option(change["project"], row["item"], _STATUS, change["option"])
        back = read_row(row["item"])
        if back == None or back["status"] != _CLOSED:
            fail(r["key"] + "'s row on " + title + " reads back " + str(back) + ", not Closed")
        note("set " + r["key"] + "'s row on " + title + " Closed")
        return _record(r["key"], "row-closed", project = title)
    scenario = change.get("scenario")
    if scenario != None:
        told = [
            e
            for e in change["history"]
            if e["kind"] == "comment" and e["at"] >= since and e["body"].startswith(r["key"] + " closed on ")
        ]
        if not told:
            comment(scenario["issue"], render("issue-close-scenario.md.template", {
                "issue": r["key"],
                "date": date,
                "login": login,
                "resolution": resolution or "",
            }))
            note("commented on " + scenario["key"] + " that " + r["key"] + " closed and left it")
    delete_row(row["project"]["id"], row["item"])
    if row["item"] in row_items(r):
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

    # GitHub names an account and a repository in any case, so a key is compared in lower case.
    if len({k.lower(): True for k in keys}) != len(keys):
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

    # Everything read first: each issue, its history, its rows, each scenario it is on and that scenario's history, its
    # Resolution's form and what close does to it, and its parent. An issue already closed is read the same way, since
    # close writes on it what one complete run would have written and the earlier run didn't (#609).
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
        if resolution != "":
            plan, fault = resolution_plan(model, resolution)
            if fault != "":
                refused.append(k + ": " + fault)
        events = lifecycle(r)
        evidence_comment = _with_heading(text, r["title"]) if text != "" else ""
        setting, others = None, []
        if plan != None:
            setting, others = _resolution_writes(model, r, plan)
        work.append({
            "r": r,
            "model": model,
            "changes": changes,
            "plan": plan,
            "set": setting,
            "others": others,
            "events": events,
            "evidence": evidence_comment,
            "commented": _closing_found(events, evidence_comment),
            "parent": parent_of(k) if r["state"] != "closed" else None,
        })
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    login = viewer()
    date = today()
    out = []

    # Each parent's open children, as read before the first write, less those this run has closed.
    closed_under = {}
    for w in work:
        r = w["r"]
        was_closed = r["state"] == "closed"
        wrote = False

        # 1. The closing comment, unless the issue's current close holds it.
        if not w["commented"]:
            if w["evidence"] != "":
                comment(r, w["evidence"])
            else:
                comment(r, render("issue-close.md.template", {"date": date, "login": login, "resolution": resolution, "reason": reason}))
            note("commented on " + r["key"])
            wrote = True

        # 2. The Resolution: in a user account each other resolution: label removed first, then the one asked for added;
        # read back as the one asked for alone. No comment is written on the change; GitHub's history records it.
        if w["set"] != None or w["others"]:
            if w["others"]:
                clear_resolution(r, {"name": "", "labels": w["others"]})
                note("removed " + r["key"] + "'s " + ", ".join(w["others"]))
            if w["set"] != None:
                set_resolution(r, w["set"])
                note("set " + r["key"] + "'s Resolution " + w["set"]["name"])
            back = issue(r["key"], w["model"])
            held = clearing_plan(w["model"], back) if "label" in w["plan"] else None
            if resolution_of(w["model"], back) != w["plan"]["name"] or (held != None and held["labels"] != [w["plan"]["label"]]):
                fail(r["key"] + " reads back with the Resolution " + str(resolution_of(w["model"], back)) + ", not " + w["plan"]["name"] + " alone")
            wrote = True

        # 3. The issue closed, unless it is.
        if not was_closed:
            close_issue(r)
            state = issue_state(r)
            if state["state"] != "closed" or state["reason"] != "completed":
                fail(r["key"] + " reads back " + str(state["state"]) + ", " + str(state["reason"]) + ", not closed as completed")
            note("closed " + r["key"] + " as completed")

        # 4. Its rows.
        since = last_at(w["events"], "reopened")
        rows = [_change(r, change, date, login, resolution if w["plan"] != None else None, since) for change in w["changes"]]
        if was_closed and not wrote and not rows:
            out.append(_record(r["key"], "unchanged"))
            continue
        last = None
        if w["parent"] != None:
            at = w["parent"]["key"].lower()
            closed_under[at] = closed_under.get(at, 0) + 1
            if w["parent"]["open"] - closed_under[at] == 0:
                last = w["parent"]["key"]
        named = w["plan"]["name"] if w["plan"] != None else None
        out.append(_record(r["key"], "closed", resolution = named, parent = last, already = True if was_closed else None))
        out.extend(rows)
    return out
