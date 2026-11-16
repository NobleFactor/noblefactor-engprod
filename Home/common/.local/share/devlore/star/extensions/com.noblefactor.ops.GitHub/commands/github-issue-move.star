# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github issue move: issues moved onto, within or off a schedule or a scenario, each move recorded, in one act."""

# github-issue-move.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 2 (noblefactor-engprod#511), to section 8 of the issue data model,
# § Moving an issue, and section 9, § Moving an issue onto, within and off a scenario. Made from star github schedule add
# (#438), which it retires. Exactly one destination is given, and the issues move in the order given:
#
#   - --schedule puts them on a schedule, or with --after moves them within it. Every row then takes its place's number,
#     so the steps stay consecutive whole numbers, closed steps among them (question 5); each row gets the schedule's
#     option, its step and Status Open, placed in step order, and leaves the project it was on, in one act (ruled
#     2026-11-04).
#   - --triage and --backlog take them off their schedule to their team's Triage or Backlog project, every later step
#     moving up; --triage takes them off their scenario too.
#   - --scenario puts them on a scenario at a Beat, or sets the Beat of one already on it.
#
# A schedule's change is one amendment line in its Schedule issue, rendered from templates/amendment.md.template:
# written first, ending "(in progress)", and settled last, so that a run that stops partway leaves a record a reader
# sees is unfinished, and the same command run again finishes it. A scenario's is a comment on its Scenario issue,
# rendered from templates/scenario-comment.md.template, and a line in the item's body, both written before its row
# moves, so that a run that stops partway leaves a second comment, not a move unrecorded. The rows are read again just
# before the first write, and nothing is written if they changed; each write is read back, and noted as it is made, so
# that a run that stops partway says what it wrote. Its result is one flat record for each row it added, moved, took off
# or left, and for each issue already where it was sent.

load("commands/access.star", "check_access")
load("commands/model.star", "extension_dir", "read_text", "refuse_dry_run")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "leaf_level", "model_for", "model_of", "models_for", "owners_of", "team_of", "type_named")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "add_row",
    "amend",
    "amendment",
    "check_beat",
    "check_row",
    "closing",
    "comment",
    "delete_row",
    "issue",
    "parse_key",
    "pending_for",
    "place_after",
    "project_named",
    "project_of",
    "put",
    "put_beat",
    "put_open",
    "read_row",
    "rows",
    "scenario",
    "schedule",
    "set_step",
    "settle",
    "snapshot",
    "span",
    "today",
    "viewer",
    "walk",
    "write_line",
)

_COMMAND = "star github issue move"
_TRIAGE = "Triage"
_BACKLOG = "Backlog"
_LEAVES = [_TRIAGE, _BACKLOG]

# A key as an option's description holds it: each Schedule and Scenario option names its own issue.
_KEY = "^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+#[0-9]+$"

# ── the flags ───────────────────────────────────────────────────────────────

def _note(message):
    """One write, noted as it is made: a run that stops partway has said what it wrote."""
    note(message)

def _list(value):
    """A comma-separated flag's values, each trimmed, the empty ones dropped."""

    # TODO(https://github.com/NobleFactor/noblefactor-engprod/issues/315): take --blocked-by repeated, --blocked-by
    # <issue> --blocked-by <issue>, once star's extension flags can repeat.
    return [v.strip() for v in (value or "").split(",") if v.strip()]

def _whole(value, flag, what):
    """A flag's whole number, or None when it was not given; fails, naming the flag, on anything else."""
    v = (value or "").strip()
    if v == "":
        return None
    if not regex.match(pattern = "^[0-9]+$", text = v):
        fail(flag + " takes " + what + ", a whole number: " + v)
    return int(v)

# ── GitHub ──────────────────────────────────────────────────────────────────

def _member(account, team, login):
    """Whether a login is a member of an organization's team."""
    query = ("query starStepTeam { organization(login: \"" + account + "\") { team(slug: \"" + team + "\") { " +
             "members(query: \"" + login + "\", first: 20) { nodes { login } } } } }")
    found = sh("gh api graphql -f query=" + quote(query) + " --jq " + quote("[.data.organization.team.members.nodes[]?.login] | join(\",\")")).strip()
    return login.lower() in [m.lower() for m in found.split(",")]

def _assign(node_id, login):
    """An issue assigned to a login, which issue move reads back."""
    user = sh("gh api graphql -f query=" + quote("query starStepUser { user(login: \"" + login + "\") { id } }") + " --jq .data.user.id").strip()
    if user == "":
        fail("no GitHub user " + login)
    sh("gh api graphql -f query=" + quote("mutation starStepAssign($a: ID!, $u: ID!) { addAssigneesToAssignable(input: {assignableId: $a, assigneeIds: [$u]}) { clientMutationId } }") +
       " -f a=" + quote(node_id) + " -f u=" + quote(user))

def _block(node_id, blocker_id):
    """A blocked-by link from an issue to another."""
    sh("gh api graphql -f query=" + quote("mutation starStepBlock($i: ID!, $b: ID!) { addBlockedBy(input: {issueId: $i, blockingIssueId: $b}) { clientMutationId } }") +
       " -f i=" + quote(node_id) + " -f b=" + quote(blocker_id))

def _option_key(project, field, name):
    """The issue key an option's description holds: each Schedule and Scenario option names its own issue."""
    for o in project["fields"].get(field, {"options": []})["options"]:
        if o["name"] == name:
            return (o.get("description") or "").strip()
    return ""

def _project_for(row, sched):
    """The project a row is on, with its fields: the schedule's own when it is that one, else read."""
    return sched["project"] if row["project"]["id"] == sched["project"]["id"] else project_of(row["project"]["id"])

def _pending(model, key):
    """The key of the account's schedule whose Schedule issue holds a pending amendment naming key; "" when none does.

    A run that took key off its schedule and stopped before it settled the amendment left key on no schedule, so the
    schedule is found by its record: each option of the account's Schedule projects names its Schedule issue.
    """
    for owner in owners_of(model):
        project = project_named(model, SCHEDULE_KIND + ": " + owner)
        if project == None or SCHEDULE_KIND not in project["fields"]:
            continue
        for o in project["fields"][SCHEDULE_KIND]["options"]:
            k = (o.get("description") or "").strip()
            if regex.match(pattern = _KEY, text = k) and pending_for(issue(k, model), [key]):
                return k
    return ""

# ── what is recorded ────────────────────────────────────────────────────────

def _record(key, kind, title, action, project, schedule = None, step = None, from_step = None, scenario = None, beat = None, from_beat = None):
    """One record of the result: the issue, what the move did to its row, on which project, and where the row stands.

    Every record carries every key: the schedule and step, or the scenario and Beat, of the row it names, and None where
    the row has none.
    """
    return {
        "issue": key,
        "type": kind,
        "title": title,
        "action": action,
        "project": project,
        "schedule": schedule,
        "step": step,
        "from_step": from_step,
        "scenario": scenario,
        "beat": beat,
        "from_beat": from_beat,
    }

def _short(key, repo):
    """An issue as a body in repo names it: #N in its own repository, <owner>/<repository>#N in another (section 9)."""
    k = parse_key(key)
    return "#" + str(k["number"]) if k["repo"].lower() == repo.lower() else k["key"]

def _found(body, key, repo):
    """Whether a body says it was found walking the scenario key, in either form the Triage workflow reads (#448)."""
    k = parse_key(key)
    forms = [k["repo"].replace(".", "\\.") + "#" + str(k["number"])]
    if k["repo"].lower() == repo.lower():
        forms.append("#" + str(k["number"]))
    return regex.match(pattern = "Found while walking (?i:" + "|".join(forms) + ")([^0-9]|$)", text = body)

def _scenario_comment(data):
    """The comment on a Scenario issue, rendered from templates/scenario-comment.md.template with data, on one line."""
    content = read_text(extension_dir() + "/templates/scenario-comment.md.template")
    return " ".join(template.render_text(content = content, data = data).split())

def _where(r):
    """What the one-act check compares of an issue between its two reads: each row, with its option, step and Beat."""
    return sorted([(row["item"], row["project"]["id"], row["schedule"], row["scenario"], row["step"], row["beat"]) for row in r["rows"]])

def _unchanged(read, model):
    """Fails, naming the issue, when one of read reads otherwise now than it did: the one-act check, for its rows."""
    for r in read:
        if _where(issue(r["key"], model)) != _where(r):
            fail(r["key"] + " changed while issue move read it; nothing was written: run it again")

# ── onto and within a schedule ──────────────────────────────────────────────

def _here(r, coll):
    """The issue's row under a schedule's or a scenario's option, or None."""
    attr = coll["field"].lower()
    for row in r["rows"]:
        if row["project"]["id"] == coll["project"]["id"] and row[attr] == coll["option"]["name"]:
            return row
    return None

def _refusals(r, sched, model, account, assignee, resume, after):
    """Why an issue can't go on the schedule, each in plain words; none when it can."""
    out = []
    if parse_key(r["key"])["owner"].lower() != account.lower():
        out.append(r["key"] + " is in another account: a schedule's steps are its own account's issues")
    if r["state"] != "open":
        out.append(r["key"] + " is closed")
    t = type_named(model, r["type"]) if r["type"] else None
    if t == None or t.get("level") != leaf_level(model):
        out.append(r["key"] + " is " + ("of type " + r["type"] if r["type"] else "of no type") + ": a schedule's steps are tasks and bugs")
    here = _here(r, sched)
    if here and not resume and after == None:
        out.append(r["key"] + " is already on this schedule, at step " + str(here["step"]) + "; --after moves it within it")
    if not model["user"]:
        mine = team_of(model, r["repo"])
        theirs = team_of(model, sched["issue"]["repo"])
        if mine != theirs:
            if not assignee:
                out.append(r["key"] + " is " + str(mine) + "'s: give --assignee, a member of " + str(theirs) + ", to answer for it here")
            elif not _member(account, theirs, assignee):
                out.append(assignee + " is not a member of " + str(theirs))
    return out

def _plan(rs, keys, after, resume):
    """Each row's target step once the issues are in place: {"targets", "moves", "anchor"}.

    The rows not being moved keep their order by step; the issues go in, in the order given, after the row at step after,
    first when after is 0, or last when it is None; then every row takes its place's number, so the steps stay
    consecutive whole numbers. A run that stopped partway moved rows to their places' numbers, which keeps their order, so
    the same plan finishes it. An issue moved later within its schedule takes the step of the row it goes after, which
    moves up one, so when such a run stopped after that row moved, the row the issue goes after is the one before it.
    Fails, naming the step, when after is not one of the schedule's, or is an issue's own.
    """
    moving = {k: True for k in keys}
    others = sorted([r for r in rs if r["step"] != None and r["issue"] not in moving], key = lambda r: r["step"])
    own = [r for r in rs if r["issue"] in moving and r["step"] == after] if after else []
    held = [i for i, r in enumerate(others) if r["step"] == after] if after else []
    if after == None:
        at = len(others)
    elif after == 0:
        at = 0
    elif held:
        at = held[0] + 1
    elif own and resume:
        at = len([r for r in others if r["step"] < after])
    elif own:
        fail("nothing was written: " + own[0]["issue"] + " is step " + str(after) + ", and can't go after itself")
    else:
        steps = sorted([r["step"] for r in rs if r["step"] != None])
        fail("the schedule has no step " + str(after) + "; its steps run " + (str(steps[0]) + " to " + str(steps[-1]) if steps else "nowhere: it has none"))
    moves = []
    for i, r in enumerate(others):
        to = i + 1 + (len(keys) if i >= at else 0)
        if r["step"] != to:
            moves.append({"row": r, "from": r["step"], "to": to})
    return {"targets": {k: at + 1 + i for i, k in enumerate(keys)}, "moves": moves, "anchor": others[at - 1]["item"] if at > 0 else None}

def _shift(sched, m):
    """One row's step renumbered, as a plan moves it; its record."""
    set_step(sched["project"], m["row"]["item"], m["to"])
    _note("moved " + m["row"]["issue"] + " from step " + str(m["from"]) + " to " + str(m["to"]))
    return _record(
        m["row"]["issue"],
        m["row"]["type"],
        m["row"]["title"],
        "moved",
        sched["project"]["title"],
        schedule = sched["issue"]["key"],
        step = m["to"],
        from_step = m["from"],
    )

def _take_off(r, row, sched, model, login, date, reason):
    """An issue taken off the other schedule it is on: its later steps up one, and that Schedule issue amended.

    On the same project the row stays, and put gives it this schedule's option; on another team's project it is deleted.
    """
    other_key = _option_key(_project_for(row, sched), "Schedule", row["schedule"])
    if other_key == "":
        fail(r["key"] + " is on " + row["project"]["title"] + "'s schedule " + str(row["schedule"]) + ", whose option names no Schedule issue")
    other = schedule(other_key, model)
    moves = closing(rows(other, model), [row["item"]])
    out = [_record(r["key"], r["type"], r["title"], "taken-off", other["project"]["title"], schedule = other_key, from_step = row["step"])]
    for m in sorted(moves, key = lambda m: m["from"]):
        out.append(_shift(other, m))
    if row["project"]["id"] != sched["project"]["id"]:
        delete_row(row["project"]["id"], row["item"])
        _note("took " + r["key"] + "'s row off " + row["project"]["title"])
    amend(other["issue"], amendment({
        "date": date,
        "login": login,
        "reason": reason,
        "added": [],
        "taken": [{"step": row["step"], "type": r["type"], "issue": r["key"], "title": r["title"], "to": sched["issue"]["key"]}],
        "shifted": [],
        "moved": span(moves),
    }))
    _note("amended " + other_key)
    return out

def _record_leaving(r, row, model, to, step, where, login, date, reason):
    """An item's leaving recorded before its scenario row moves: a comment on the Scenario issue, then a line in its body.

    The comment comes first, so that a run that stops before the row moves leaves a second comment, not a move
    unrecorded (section 9, § Off a scenario). Returns the Scenario issue's key.
    """
    key = _option_key(project_of(row["project"]["id"]), "Scenario", row["scenario"])
    if key == "":
        fail(r["key"] + " is on " + row["project"]["title"] + "'s scenario " + row["scenario"] + ", whose option names no Scenario issue")
    comment(issue(key, model), _scenario_comment({
        "issue": r["key"],
        "action": "left",
        "date": date,
        "to": to,
        "step": step,
        "beat": 0,
        "had_beat": False,
        "from_beat": 0,
        "login": login,
        "reason": reason,
    }))
    _note("commented on " + key + " that " + r["key"] + " left it")
    if write_line(r, "Left " + _short(key, r["repo"]) + " on " + date + " for " + where + "."):
        _note("wrote in " + r["key"] + "'s body that it left " + key)
    return key

def _onto_schedule(sk, keys, after, blockers, assignee, reason):
    """--schedule: each issue put on the schedule, or moved within it, the steps renumbered, and the amendment written."""
    account = sk["owner"]
    elsewhere = [k for k in keys + blockers if parse_key(k)["owner"].lower() != account.lower()]
    if elsewhere:
        fail("not in " + account + ", the schedule's account: " + ", ".join(elsewhere) + "; no link or row crosses accounts")

    model = model_of(models_for([account]), account)
    sched = schedule(sk["key"], model)
    first = rows(sched, model)

    # A run of these same issues that stopped partway left its amendment pending; this run finishes it, and an issue
    # it already put on the schedule is not refused.
    resume = pending_for(sched["issue"], keys)
    read = [issue(k, model) for k in keys]
    refused = []
    for r in read:
        refused.extend(_refusals(r, sched, model, account, assignee, resume, after))
    blocking = {b: issue(b, model)["id"] for b in blockers}
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))
    plan = _plan(first, keys, after, resume)
    here = {r["key"]: _here(r, sched) for r in read}
    if not resume and not plan["moves"] and all([here[k] and here[k]["step"] == plan["targets"][k] for k in keys]):
        fail("nothing was written: " + ", ".join([k + " is step " + str(here[k]["step"]) for k in keys]) + " already")

    # One act: the rows read again just before the first write, and nothing written if they changed.
    if snapshot(rows(sched, model)) != snapshot(first):
        fail("the schedule " + sched["issue"]["key"] + " changed while issue move read it; nothing was written: run it again")

    login = viewer()
    date = today()
    title = sched["project"]["title"]
    out = []
    record = {
        "date": date,
        "login": login,
        "reason": reason,
        "added": [{"step": plan["targets"][r["key"]], "type": r["type"], "issue": r["key"], "title": r["title"]} for r in read if not here[r["key"]]],
        "taken": [],
        "shifted": [
            {"from": here[r["key"]]["step"], "step": plan["targets"][r["key"]], "type": r["type"], "issue": r["key"], "title": r["title"]}
            for r in read
            if here[r["key"]]
        ],
        "moved": span(plan["moves"]),
    }

    # The amendment first, pending: a run that stops partway leaves its record, which the same command run again finishes.
    if not resume:
        amend(sched["issue"], amendment(record, pending = True))
        _note("wrote the amendment in " + sched["issue"]["key"] + ", in progress")

    # The rows that move down first, from the highest, which keeps their order should the run stop partway.
    for m in sorted([m for m in plan["moves"] if m["to"] > m["from"]], key = lambda m: -m["from"]):
        out.append(_shift(sched, m))

    previous = plan["anchor"] or sched["own_item"]
    for r in read:
        step = plan["targets"][r["key"]]
        mine = here[r["key"]]
        on = [row for row in r["rows"] if row["project"]["id"] == sched["project"]["id"]]
        for row in [row for row in r["rows"] if row["kind"] == SCHEDULE_KIND and row["schedule"] not in [None, sched["option"]["name"]]]:
            out.extend(_take_off(r, row, sched, model, login, date, reason))
        item = on[0]["item"] if on else add_row(sched["project"], r["id"])

        # A step moved within its schedule keeps its Status; one put on the schedule is Open.
        status = mine["status"] if mine else None
        put(sched, item, step, status)
        place_after(sched["project"], item, previous)
        check_row(sched, item, step, r["key"], status)
        _note("put " + r["key"] + " on " + sched["issue"]["key"] + " at step " + str(step))
        previous = item

        for b in blockers:
            if b not in r["blocked_by"]:
                _block(r["id"], blocking[b])
                _note("linked " + r["key"] + " as blocked by " + b)
        if assignee and assignee.lower() not in [a.lower() for a in r["assignees"]]:
            _assign(r["id"], assignee)
            _note("assigned " + r["key"] + " to " + assignee)

        # An issue put on the schedule leaves the project it was on; one moved within it leaves nothing. A run that
        # stopped partway may have put an issue on the schedule before it left the project it was on.
        if not mine or resume:
            for row in r["rows"]:
                if row["kind"] in _LEAVES:
                    delete_row(row["project"]["id"], row["item"])
                    _note("took " + r["key"] + "'s row off " + row["project"]["title"])
                    out.append(_record(r["key"], r["type"], r["title"], "left", row["project"]["title"]))
                elif row["kind"] == SCENARIO_KIND and row["scenario"] != None:
                    where = sched["option"]["name"] + " (" + _short(sched["issue"]["key"], r["repo"]) + "), as its step " + str(step)
                    left = _record_leaving(r, row, model, sched["issue"]["key"], step, where, login, date, reason)
                    delete_row(row["project"]["id"], row["item"])
                    _note("took " + r["key"] + "'s row off " + row["project"]["title"])
                    out.append(_record(r["key"], r["type"], r["title"], "left", row["project"]["title"], scenario = left, beat = row["beat"]))
        out.append(_record(
            r["key"],
            r["type"],
            r["title"],
            "moved" if mine else "added",
            title,
            schedule = sched["issue"]["key"],
            step = step,
            from_step = mine["step"] if mine else None,
        ))

    # Then the rows that move up, from the lowest, which keeps their order too.
    for m in sorted([m for m in plan["moves"] if m["to"] < m["from"]], key = lambda m: m["from"]):
        out.append(_shift(sched, m))

    settle(sched["issue"], keys, amendment(record))
    _note("amended " + sched["issue"]["key"])

    # Every moved row read back at its new step.
    for m in plan["moves"]:
        back = read_row(m["row"]["item"])
        if back == None or back["step"] != m["to"]:
            fail(m["row"]["issue"] + "'s row reads back at step " + str(back["step"] if back else None) + ", not " + str(m["to"]))
    return out

# ── onto and within a scenario ──────────────────────────────────────────────

def _scenario_refusals(r, scen, model):
    """Why an issue can't go on the scenario, each in plain words; none when it can."""
    out = []
    if r["state"] != "open":
        out.append(r["key"] + " is closed")
    t = type_named(model, r["type"]) if r["type"] else None
    if t == None or t.get("level") != leaf_level(model):
        out.append(r["key"] + " is " + ("of type " + r["type"] if r["type"] else "of no type") + ": a scenario's items are tasks and bugs")
    for row in r["rows"]:
        if row["kind"] == SCENARIO_KIND and row["scenario"] != None and _here(r, scen) != row:
            out.append(r["key"] + " is on the scenario " + row["scenario"] + " of " + row["project"]["title"] +
                       ": an issue is on at most one scenario, so it goes to Triage first")
        elif row["kind"] in [_BACKLOG, SCHEDULE_KIND]:
            out.append(r["key"] + " is on " + row["project"]["title"] + ", so it has moved on from its walk")
    return out

def _beat_anchor(rs, keys, beat):
    """The row an item at beat goes after: the last of the scenario's other rows with a Beat at or before it, or None."""
    before = sorted([r for r in rs if r["issue"] not in keys and r["beat"] != None and r["beat"] <= beat], key = lambda r: r["beat"])
    return before[-1]["item"] if before else None

def _onto_scenario(ck, keys, beat, reason):
    """--scenario: each issue put on the scenario at the Beat, or its Beat set there, each with its comment and line."""
    account = ck["owner"]
    elsewhere = [k for k in keys if parse_key(k)["owner"].lower() != account.lower()]
    if elsewhere:
        fail("not in " + account + ", the scenario's account: " + ", ".join(elsewhere) + "; no row crosses accounts")

    model = model_of(models_for([account]), account)
    scen = scenario(ck["key"], model)
    last = walk(scen["issue"])
    if last != None and beat > last:
        fail("nothing was written: beat " + str(beat) + " is past the last step of " + ck["key"] + "'s walk, step " + str(last))
    first = rows(scen, model)
    read = [issue(k, model) for k in keys]
    refused = []
    for r in read:
        refused.extend(_scenario_refusals(r, scen, model))
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    # One act: the rows read again just before the first write, and nothing written if they changed.
    if snapshot(rows(scen, model)) != snapshot(first):
        fail("the scenario " + ck["key"] + " changed while issue move read it; nothing was written: run it again")
    _unchanged(read, model)

    login = viewer()
    date = today()
    title = scen["project"]["title"]
    out = []
    previous = _beat_anchor(first, keys, beat) or scen["own_item"]
    for r in read:
        mine = _here(r, scen)
        triage = [row for row in r["rows"] if row["kind"] == _TRIAGE]
        named = _found(r["body"], ck["key"], r["repo"])
        if mine and mine["beat"] == beat and named and not triage:
            out.append(_record(r["key"], r["type"], r["title"], "unchanged", title, scenario = ck["key"], beat = beat, from_beat = beat))
            continue

        # The comment first, then the body's line, then the row: a run that stops partway leaves a second comment.
        had = mine != None and mine["beat"] != None
        comment(scen["issue"], _scenario_comment({
            "issue": r["key"],
            "action": "moved" if mine else "joined",
            "date": date,
            "beat": beat,
            "had_beat": had,
            "from_beat": mine["beat"] if had else 0,
            "to": "",
            "step": 0,
            "login": login,
            "reason": reason,
        }))
        _note("commented on " + ck["key"] + " that " + r["key"] + (" is at beat " if mine else " joined it at beat ") + str(beat))
        if not named and write_line(r, "Found while walking " + _short(ck["key"], r["repo"])):
            _note("wrote in " + r["key"] + "'s body that it was found walking " + ck["key"])

        item = mine["item"] if mine else add_row(scen["project"], r["id"])
        put_beat(scen, item, beat, mine == None)
        place_after(scen["project"], item, previous)
        check_beat(scen, item, beat, r["key"], mine == None)
        _note("put " + r["key"] + " on " + ck["key"] + " at beat " + str(beat))
        previous = item
        for row in triage:
            delete_row(row["project"]["id"], row["item"])
            _note("took " + r["key"] + "'s row off " + row["project"]["title"])
            out.append(_record(r["key"], r["type"], r["title"], "left", row["project"]["title"]))
        out.append(_record(
            r["key"],
            r["type"],
            r["title"],
            "moved" if mine else "added",
            title,
            scenario = ck["key"],
            beat = beat,
            from_beat = mine["beat"] if mine else None,
        ))
    return out

# ── off a schedule or a scenario ────────────────────────────────────────────

def _group(groups, order, key, model, r, row):
    """An issue counted among those taken off the schedule key, with its row on it, None when it has none left."""
    if key not in groups:
        groups[key] = {"sched": schedule(key, model), "model": model, "keys": [], "read": {}, "rows": {}}
        order.append(key)
    g = groups[key]
    if r["key"] not in g["keys"]:
        g["keys"].append(r["key"])
        g["read"][r["key"]] = r
    if row != None:
        g["rows"][r["key"]] = row

def _off(keys, kind, reason):
    """--triage or --backlog: each issue off its schedule, or to Triage off its scenario, into its team's project of kind.

    Each schedule's later steps move up, one amendment on its Schedule issue for all its steps taken off; each scenario
    an item leaves gets its comment and the item its body line, as onto a schedule. The row on the schedule is deleted
    last, after the steps are renumbered and the issue is in its team's project, so that a run that stops partway leaves
    the issue on the schedule, where the same command run again finds it; and should it stop after the last row is
    deleted, the schedule is found by its pending amendment (_pending).
    """
    models = models_for([parse_key(k)["owner"] for k in keys])
    projects = {}
    plans = []
    groups = {}
    order = []
    refused = []
    for k in keys:
        model = model_for(models, parse_key(k)["repo"])
        r = issue(k, model)
        p = {"r": r, "model": model, "dest": None, "steps": [], "walks": [], "unchanged": False}
        plans.append(p)
        t = type_named(model, r["type"]) if r["type"] else None
        team = team_of(model, r["repo"])
        if r["state"] != "open":
            refused.append(k + " is closed")
            continue
        if t != None and t.get("level") == None:
            refused.append(k + " is a " + r["type"] + " issue: issue move moves tasks and bugs")
            continue
        if team == None:
            refused.append("no team maintains " + r["repo"] + ", so " + k + " has no " + kind + " project")
            continue
        title = kind + ": " + team
        at = model["account"].lower() + "/" + title
        if at not in projects:
            projects[at] = project_named(model, title)
        p["dest"] = projects[at]
        if p["dest"] == None:
            refused.append(model["account"] + " has no project " + title + ", for " + k)
            continue
        p["steps"] = [row for row in r["rows"] if row["kind"] == SCHEDULE_KIND and row["schedule"] != None and row["step"] != None]
        p["walks"] = [row for row in r["rows"] if row["kind"] == SCENARIO_KIND and row["scenario"] != None]
        if p["walks"] and kind == _BACKLOG:
            refused.append(k + " is on the scenario " + p["walks"][0]["scenario"] + ": an item found on a walk is classified in Triage first (ruled 2026-11-04)")
            continue
        for row in p["steps"]:
            sk = _option_key(project_of(row["project"]["id"]), "Schedule", row["schedule"])
            if sk == "":
                fail(k + " is on " + row["project"]["title"] + "'s schedule " + row["schedule"] + ", whose option names no Schedule issue")
            _group(groups, order, sk, model, r, row)
        if p["steps"] or p["walks"]:
            continue
        pending = _pending(model, k)
        if pending != "":
            _group(groups, order, pending, model, r, None)
        elif [row for row in r["rows"] if row["project"]["id"] == p["dest"]["id"]]:
            p["unchanged"] = True
        else:
            refused.append(k + " is on no schedule" + (" or scenario" if kind == _TRIAGE else "") + ", so there is nothing to take it off")
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))

    login = viewer()
    date = today()
    dests = {p["r"]["key"]: p["dest"]["title"] for p in plans}
    for key in order:
        g = groups[key]
        g["first"] = rows(g["sched"], g["model"])
        g["resume"] = pending_for(g["sched"]["issue"], g["keys"])
        g["moves"] = closing(g["first"], [row["item"] for row in g["rows"].values()])
        g["record"] = {
            "date": date,
            "login": login,
            "reason": reason,
            "added": [],
            "taken": [
                {"step": g["rows"][k]["step"], "type": g["read"][k]["type"], "issue": k, "title": g["read"][k]["title"], "to": dests[k]}
                for k in g["keys"]
                if k in g["rows"]
            ],
            "shifted": [],
            "moved": span(g["moves"]),
        }

    # One act: the rows read again just before the first write, and nothing written if they changed.
    for key in order:
        g = groups[key]
        if snapshot(rows(g["sched"], g["model"])) != snapshot(g["first"]):
            fail("the schedule " + key + " changed while issue move read it; nothing was written: run it again")
    for p in plans:
        _unchanged([p["r"]], p["model"])

    # Each amendment first, pending: a run that stops partway leaves its record, which the same command run again finishes.
    for key in order:
        if not groups[key]["resume"]:
            amend(groups[key]["sched"]["issue"], amendment(groups[key]["record"], pending = True))
            _note("wrote the amendment in " + key + ", in progress")

    out = []
    for p in plans:
        r = p["r"]
        if p["unchanged"]:
            out.append(_record(r["key"], r["type"], r["title"], "unchanged", p["dest"]["title"]))
            continue
        for row in p["walks"]:
            left = _record_leaving(r, row, p["model"], p["dest"]["title"], 0, p["dest"]["title"], login, date, reason)
            put_open(p["dest"], r)
            _note("put " + r["key"] + " on " + p["dest"]["title"])
            delete_row(row["project"]["id"], row["item"])
            _note("took " + r["key"] + "'s row off " + row["project"]["title"])
            out.append(_record(r["key"], r["type"], r["title"], "left", row["project"]["title"], scenario = left, beat = row["beat"]))
        if not p["walks"]:
            put_open(p["dest"], r)
            _note("put " + r["key"] + " on " + p["dest"]["title"])
        out.append(_record(r["key"], r["type"], r["title"], "added", p["dest"]["title"]))

    # Each schedule's later steps up, from the lowest, which keeps their order; then its rows taken off, and its
    # amendment settled.
    for key in order:
        g = groups[key]
        sched = g["sched"]
        for m in sorted(g["moves"], key = lambda m: m["from"]):
            out.append(_shift(sched, m))
        for k in g["keys"]:
            if k in g["rows"]:
                delete_row(sched["project"]["id"], g["rows"][k]["item"])
                _note("took " + k + "'s row off " + key)
                out.append(_record(
                    k,
                    g["read"][k]["type"],
                    g["read"][k]["title"],
                    "taken-off",
                    sched["project"]["title"],
                    schedule = key,
                    from_step = g["rows"][k]["step"],
                ))
        settle(sched["issue"], g["keys"], amendment(g["record"]))
        _note("amended " + key)
        for m in g["moves"]:
            back = read_row(m["row"]["item"])
            if back == None or back["step"] != m["to"]:
                fail(m["row"]["issue"] + "'s row reads back at step " + str(back["step"] if back else None) + ", not " + str(m["to"]))
    return out

# ── the command ─────────────────────────────────────────────────────────────

def run(_command, ctx):
    """Check the flags and gh's access, then move each issue to the one destination given, in the order given.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the issues; the destination, --schedule with --after, --blocked-by and
        --assignee, --scenario with --beat, --triage or --backlog; and --reason; ctx.dry_run, star's --dry-run, which
        issue move refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    reason = (ctx.args.get("reason") or "").strip()
    if reason == "":
        fail("issue move needs --reason: it is written where the move is recorded, the Schedule issue's amendment or the " +
             "comment on the Scenario issue (section 8, § Moving an issue)")
    issues = [i.strip() for i in (ctx.args.get("issues") or []) if i.strip()]
    if not issues:
        fail("issue move needs one issue or more, <owner>/<repository>#<number>")
    keys = [parse_key(i)["key"] for i in issues]
    if len({k: True for k in keys}) != len(keys):
        fail("an issue is named twice: " + ", ".join(keys))

    schedule_key = (ctx.args.get("schedule") or "").strip()
    scenario_key = (ctx.args.get("scenario") or "").strip()
    triage = ctx.args.get("triage") in [True, "true"]
    backlog = ctx.args.get("backlog") in [True, "true"]
    given = [flag for flag, on in [("--schedule", schedule_key != ""), ("--scenario", scenario_key != ""), ("--triage", triage), ("--backlog", backlog)] if on]
    if len(given) != 1:
        fail("issue move takes one destination, --schedule, --scenario, --triage or --backlog; " +
             ("none was given" if not given else " and ".join(given) + " were given"))
    after = _whole(ctx.args.get("after"), "--after", "a step")
    beat = _whole(ctx.args.get("beat"), "--beat", "a beat")
    blockers = [parse_key(b)["key"] for b in _list(ctx.args.get("blocked-by"))]
    assignee = (ctx.args.get("assignee") or "").strip()
    stray = [flag for flag, on in [("--after", after != None), ("--blocked-by", blockers != []), ("--assignee", assignee != "")] if on]
    if stray and schedule_key == "":
        fail(" and ".join(stray) + (" goes" if len(stray) == 1 else " go") + " with --schedule, and it was not given")
    if beat != None and scenario_key == "":
        fail("--beat goes with --scenario, and it was not given")
    if beat == None and scenario_key != "":
        fail("--scenario needs --beat: the step of the walk at which the item turned up, 0 before its first")
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)

    if schedule_key != "":
        return _onto_schedule(parse_key(schedule_key), keys, after, blockers, assignee, reason)
    if scenario_key != "":
        return _onto_scenario(parse_key(scenario_key), keys, beat, reason)
    return _off(keys, _TRIAGE if triage else _BACKLOG, reason)
