# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A schedule closed with its evidence comment, or a scenario retired with its reason: its issue closed, its row Closed."""

# ending.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 5 (noblefactor-engprod#512), to section 8 of the issue data
# model, § Ending a schedule: close, and section 9, § Removing a scenario: retire. The two end a collection the same
# way, _end: its own row set Closed, its comment written, its issue closed as completed, each read back; and its option
# kept, the record of which collection each past row belonged to (ruled 2026-11-11). What differs is what each refuses
# and what its comment says, each rendered from a template in templates/: close's the evidence every Schedule issue asks
# for (question 6, ruled 2026-11-12), retire's the reason the product no longer has the scenario (question 6, ruled
# 2026-11-15). Nothing is written until every refusal has been checked.

load("commands/markdown.star", "body_lines", "boxes", "sections")
load("commands/model.star", "extension_dir", "read_text")
load("commands/scheme.star", "USER_ATTRIBUTES", "canonical_repo", "model_of", "models_for")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "close_issue",
    "closing_of",
    "comment",
    "issue",
    "issue_fields",
    "issue_state",
    "option_of",
    "parse_key",
    "project_of",
    "read_schedule",
    "reads_back",
    "reopen_issue",
    "rows",
    "scenario",
    "schedule",
    "set_option",
    "today",
    "viewer",
    "write_body",
)

_STATUS_FIELD = "Status"
_CLOSED = "Closed"

# A closed issue's Resolution: an issue field in an organization, the resolution: label family in a user account.
_RESOLUTION = "Resolution"
_RESOLUTION_FAMILY = "resolution"

# The sections a schedule's exit criteria are the boxes of, at level 2 or 3: Exit criteria, or, when the Schedule issue
# has none, Evidence of completion, since a schedule's exit criteria are its evidence of completion (section 3).
_CRITERIA = ["Exit criteria", "Evidence of completion"]
_LEVELS = [2, 3]

# A schedule reopened: its own row In progress, since a step of it is open again, and the exit criterion that says every
# step is closed unticked, found by its words (section 10, § Reopening an issue): the boxes of the schedules so far say
# "Every step closed" and "Every other step closed".
_IN_PROGRESS = "In progress"
_EVERY_STEP = "^[Ee]very (other )?steps? "

# GitHub's reasons an issue closed, as a step's How it closed names them when it has no Resolution.
_REASONS = {"completed": "Completed", "not_planned": "Not planned", "duplicate": "Duplicate"}

# ── what the comments name ──────────────────────────────────────────────────

def _short(key, repo):
    """An issue or pull request as the comment names it: #N in the schedule's repository, <owner>/<repository>#N in another."""
    k = parse_key(key)
    return "#" + str(k["number"]) if k["repo"].lower() == repo.lower() else k["key"]

def _cell(text):
    """Text as one cell of a Markdown table: its pipes escaped, and its lines joined."""
    return " ".join((text or "").replace("|", "\\|").split())

def _label(r, repo):
    """A step as the comment names it: "<step>, <type> <key>", or "no step, ..." for a row with none."""
    return (str(r["step"]) if r["step"] != None else "no step") + ", " + (r["type"] or "Issue") + " " + _short(r["issue"], repo)

def _pull_key(p):
    """A pull request's key, <owner>/<repository>#<number>."""
    return canonical_repo(p["repository"]["nameWithOwner"]) + "#" + str(int(p["number"]))

def _pull(closing):
    """The merged pull request that closed a step, or None.

    It is the merged one GitHub records as closing the step's issue, closedByPullRequestsReferences: when more than one
    merged, the one that closed it, as its last ClosedEvent's closer names it, else the first to merge. When none is,
    it is the merged one whose commit closed the issue, as that closer names the commit, its merge commit's first. No
    other link counts: a pull request that only mentions an issue may not be its work (section 8, § Ending a schedule).
    """
    closer = closing["closer"]
    merged = sorted([p for p in closing["references"] if p.get("merged") and p.get("mergedAt")], key = lambda p: p["mergedAt"])
    if merged:
        mine = [p for p in merged if closer.get("__typename") == "PullRequest" and _pull_key(p) == _pull_key(closer)]
        return (mine or merged)[0]
    if closer.get("__typename") != "Commit":
        return None
    pulls = [p for p in ((closer.get("associatedPullRequests") or {}).get("nodes") or []) if p.get("merged") and p.get("mergedAt")]
    pulls = [p for p in pulls if (p.get("mergeCommit") or {}).get("oid") == closer.get("oid")] + pulls
    return pulls[0] if pulls else None

def _resolution(model, fields, labels):
    """An issue's Resolution, by name: its issue field in an organization, its resolution: label in a user account; None."""
    if not model["user"]:
        return fields.get(_RESOLUTION)
    family = [f for f in USER_ATTRIBUTES if f["key"] == _RESOLUTION_FAMILY]
    names = family[0]["names"] if family else {}
    found = [names[label] for label in labels if label in names]
    return found[0] if found else None

def _how(model, closing):
    """How a step closed: its Resolution where it has one, else GitHub's reason, then the day it closed."""
    reason = closing["reason"] or "closed"
    how = _resolution(model, closing["fields"], closing["labels"]) or _REASONS.get(reason, reason.replace("_", " ").capitalize())
    return how + (", " + closing["closed_at"][:10] if closing["closed_at"] else "")

def _render(name, data):
    """A comment rendered from templates/<name> with data, its line ends kept and its ends trimmed."""
    return template.render_text(content = read_text(extension_dir() + "/templates/" + name), data = data).strip()

# ── ending ──────────────────────────────────────────────────────────────────

def _end(coll, body):
    """A collection ended: its own row Closed, its comment written, its issue closed as completed, each read back.

    The row goes first and the issue last, so that a run that stops partway leaves the issue open, where the same
    command run again finds it, and the issue's state is the record that the collection ended. The option is kept, and
    read back. Returns {"comment", "state", "status"}: the comment's ID, and the issue's state and its row's Status after.
    """
    own = coll["issue"]
    project = coll["project"]
    attr = coll["field"].lower()
    name = coll["option"]["name"]
    set_option(project, coll["own_item"], _STATUS_FIELD, option_of(project, _STATUS_FIELD, _CLOSED))
    reads_back(coll["own_item"], {"project": project["id"], attr: name, "status": _CLOSED}, own["key"])
    note("set " + own["key"] + "'s own row on " + project["title"] + " Closed")
    made = comment(own, body)
    note("commented on " + own["key"])
    close_issue(own)
    state = issue_state(own)
    if state["state"] != "closed" or state["reason"] != "completed":
        fail(own["key"] + " reads back " + str(state["state"]) + ", " + str(state["reason"]) + ", not closed as completed")
    note("closed " + own["key"] + " as completed")
    if len([o for o in project_of(project["id"])["fields"][coll["field"]]["options"] if o["name"] == name]) != 1:
        fail(project["title"] + "'s " + coll["field"] + " field no longer has the option " + name + ", which is kept")
    return {"comment": made, "state": state["state"], "status": _CLOSED}

def close_schedule(key):
    """A finished schedule closed, with its evidence comment: one record of what was done.

    Refuses, writing nothing, while a step is open or an exit criterion's box is unticked. The steps are every row under
    the schedule's option but the Schedule issue's own; the exit criteria, the boxes of its Exit criteria section, or
    of its Evidence of completion section when it has none.
    """
    k = parse_key(key)
    model = model_of(models_for([k["owner"]]), k["owner"])
    sched = schedule(k["key"], model)
    own = sched["issue"]
    repo = own["repo"]
    steps = [r for r in rows(sched, model) if r["item"] != sched["own_item"]]
    steps = sorted([r for r in steps if r["step"] != None], key = lambda r: r["step"]) + [r for r in steps if r["step"] == None]
    lines = body_lines(own["body"])
    found = [s for title in _CRITERIA for s in sections(lines, title, _LEVELS)][:1]
    criteria = boxes(lines, found[0]) if found else []

    refused = []
    still = [_label(r, repo) for r in steps if r["state"] != "closed"]
    if still:
        refused.append("not every step is closed: " + "; ".join(still) + (" is" if len(still) == 1 else " are") + " open")
    unticked = [c["text"] for c in criteria if not c["ticked"]]
    if unticked:
        refused.append("not every exit criterion is ticked: " + "; ".join(unticked))
    if refused:
        fail("nothing was written: " + own["key"] + " is not finished:\n  " + "\n  ".join(refused))

    # Each step under the merged pull request that closed it, or else with how it closed.
    pulls = {}
    unmerged = []
    for r in steps:
        closing = closing_of(r["issue"])
        p = _pull(closing)
        if p == None:
            unmerged.append({"step": _label(r, repo), "how": _how(model, closing)})
            continue
        pulls.setdefault(_pull_key(p), {"pull": p, "steps": []})["steps"].append(r)
    merged = sorted(pulls.values(), key = lambda g: (g["pull"]["mergedAt"], _pull_key(g["pull"])))
    body = _render("evidence.md.template", {
        "date": today(),
        "login": viewer(),
        "name": sched["option"]["name"],
        "steps": len(steps),
        "criteria": len(criteria),
        "merged": [
            {
                "date": g["pull"]["mergedAt"][:10],
                "pull": _short(_pull_key(g["pull"]), repo),
                "title": _cell(g["pull"].get("title")),
                "steps": "; ".join([_label(r, repo) for r in g["steps"]]),
            }
            for g in merged
        ],
        "unmerged": unmerged,
    })
    ended = _end(sched, body)
    return {
        "issue": own["key"],
        "kind": SCHEDULE_KIND,
        "comment": ended["comment"],
        "state": ended["state"],
        "status": ended["status"],
        "steps_merged": len([r for g in merged for r in g["steps"]]),
        "steps_with_no_pull_request": len(unmerged),
    }

def schedule_reopening(key, model):
    """A closed schedule's reopening, read before anything is written: ({sched, body, criteria}, "") or (None, why).

    body is the Schedule issue's body with every ticked exit criterion that says every step is closed unticked, or None
    when no ticked criterion says so; criteria are those criteria's words. star github issue reopen reads the schedule
    of each step it reopens this way, and star github schedule reopen (#595) the schedule it is given.
    """
    sched, fault = read_schedule(key, model, reading = True)
    if fault:
        return None, fault
    project = sched["project"]
    if not [o for o in project["fields"][_STATUS_FIELD]["options"] if o["name"] == _IN_PROGRESS]:
        return None, project["title"] + "'s " + _STATUS_FIELD + " field has no option " + _IN_PROGRESS + ", for " + key + "'s own row"
    own = sched["issue"]
    lines = body_lines(own["body"])
    found = [s for title in _CRITERIA for s in sections(lines, title, _LEVELS)][:1]
    every = [c for c in (boxes(lines, found[0]) if found else []) if c["ticked"] and regex.match(pattern = _EVERY_STEP, text = c["text"])]
    body = None
    if every:
        body = own["body"]
        for c in reversed(every):
            line = lines[c["line"]]
            text = line["text"]
            at = text.find("[")
            body = body[:line["start"]] + text[:at] + "[ ]" + text[at + 3:] + body[line["text_end"]:]
    return {"sched": sched, "body": body, "criteria": [c["text"] for c in every]}, ""

def reopen_schedule(plan, body):
    """A closed schedule reopened as schedule_reopening read it, with its comment, each write read back: its record.

    In section 10's order: the Schedule issue reopened with its comment, its own row In progress, and its every-step
    criterion unticked. The option was never removed, so the schedule's past rows are under it still.
    """
    sched = plan["sched"]
    own = sched["issue"]
    project = sched["project"]
    reopen_issue(own)
    if issue_state(own)["state"] != "open":
        fail(own["key"] + " does not read back open after it was reopened")
    note("reopened " + own["key"])
    comment(own, body)
    note("commented on " + own["key"])
    set_option(project, sched["own_item"], _STATUS_FIELD, option_of(project, _STATUS_FIELD, _IN_PROGRESS))
    reads_back(sched["own_item"], {"project": project["id"], "schedule": sched["option"]["name"], "status": _IN_PROGRESS}, own["key"])
    note("set " + own["key"] + "'s own row on " + project["title"] + " " + _IN_PROGRESS)
    if plan["body"] != None:
        write_body(own, plan["body"], "its exit criteria unticked")
        note("unticked " + own["key"] + "'s exit criterion: " + "; ".join(plan["criteria"]))
    return {"issue": own["key"], "kind": SCHEDULE_KIND, "status": _IN_PROGRESS, "criteria": plan["criteria"]}

def retire_scenario(key, reason):
    """A scenario the product no longer has retired, with its reason: one record of what was done.

    Refuses, writing nothing, while an open issue is a row under the scenario's option, and while its Scenario issue has
    a Resolution, which a retired scenario has none of: nothing was left undone (section 9, § Removing a scenario).
    """
    if reason.strip() == "":
        fail("retire needs --reason: the comment on the Scenario issue says why the product no longer has the scenario")
    k = parse_key(key)
    model = model_of(models_for([k["owner"]]), k["owner"])
    scen = scenario(k["key"], model)
    own = scen["issue"]

    refused = []
    still = [
        r["issue"] + (" at beat " + str(r["beat"]) if r["beat"] != None else "")
        for r in rows(scen, model)
        if r["item"] != scen["own_item"] and r["state"] != "closed"
    ]
    if still:
        refused.append("not every item has moved on: " + ", ".join(still) + (" is" if len(still) == 1 else " are") +
                       " open on it; star github issue move --triage moves each on")
    resolution = _resolution(model, {} if model["user"] else issue_fields(own), own["labels"])
    if resolution != None:
        refused.append("its issue has the Resolution " + resolution + ", and a retired scenario has none")
    if refused:
        fail("nothing was written: " + own["key"] + " cannot be retired:\n  " + "\n  ".join(refused))

    body = _render("retire.md.template", {"date": today(), "login": viewer(), "reason": " ".join(reason.split())})
    ended = _end(scen, body)
    back = issue(own["key"], model)
    if _resolution(model, {} if model["user"] else issue_fields(back), back["labels"]) != None:
        fail(own["key"] + " reads back with a Resolution, which a retired scenario has none of")
    return {"issue": own["key"], "kind": SCENARIO_KIND, "comment": ended["comment"], "state": ended["state"], "status": ended["status"]}
