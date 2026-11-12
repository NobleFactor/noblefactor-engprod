# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule add: issues put on a schedule, each with its step, its links and the amendment, in one act."""

# github-schedule-add.star
#
# docs/plans/feature/438-schedule-add.md, Phase 3 (noblefactor-engprod#438), to section 8 of the issue data model, § add.
# Each issue takes the next step, or the steps after --after, the later steps moving down, closed or open, so the
# steps stay consecutive whole numbers. Each row gets the schedule's option, Status Open and its step, placed in step
# order, and the issue leaves the project it was on, in one act (ruled 2026-11-04). The amendment, rendered from
# templates/amendment.md.template, is written last: it is the record that the change was made, so an issue on the
# schedule with no amendment naming it is one a run that stopped partway left, and the same command run again finishes
# it; one with an amendment is already on the schedule, and refused. Each write is noted as it is made, so that a run
# that stops partway says what it wrote. Its result is one flat record for each row it added, moved or took off.

load("commands/access.star", "check_access")
load("commands/model.star", "refuse_dry_run")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "leaf_level", "model_of", "models_for", "team_of", "type_named")
load(
    "commands/steps.star",
    "SCENARIO_KIND",
    "SCHEDULE_KIND",
    "add_row",
    "amend",
    "amendment",
    "check_row",
    "closing",
    "delete_row",
    "issue",
    "parse_key",
    "pending_for",
    "place_after",
    "project_of",
    "put",
    "read_row",
    "rows",
    "schedule",
    "set_step",
    "settle",
    "snapshot",
    "span",
    "today",
    "viewer",
)

_LEAVES = ["Triage", "Backlog"]

def _note(message):
    """One write, noted as it is made: a run that stops partway has said what it wrote."""
    note(message)

def _list(value):
    """A comma-separated flag's values, each trimmed, the empty ones dropped."""
    return [v.strip() for v in (value or "").split(",") if v.strip()]

def _after(value):
    """--after as a whole number, or None when it was not given; fails on anything else."""
    v = (value or "").strip()
    if v == "":
        return None
    if not regex.match(pattern = "^[0-9]+$", text = v):
        fail("--after takes a step, a whole number: " + v)
    return int(v)

def _member(account, team, login):
    """Whether a login is a member of an organization's team."""
    query = ("query starStepTeam { organization(login: \"" + account + "\") { team(slug: \"" + team + "\") { " +
             "members(query: \"" + login + "\", first: 20) { nodes { login } } } } }")
    found = sh("gh api graphql -f query=" + quote(query) + " --jq " + quote("[.data.organization.team.members.nodes[]?.login] | join(\",\")")).strip()
    return login.lower() in [m.lower() for m in found.split(",")]

def _assign(node_id, login):
    """An issue assigned to a login, which add reads back."""
    user = sh("gh api graphql -f query=" + quote("query starStepUser { user(login: \"" + login + "\") { id } }") + " --jq .data.user.id").strip()
    if user == "":
        fail("no GitHub user " + login)
    sh("gh api graphql -f query=" + quote("mutation starStepAssign($a: ID!, $u: ID!) { addAssigneesToAssignable(input: {assignableId: $a, assigneeIds: [$u]}) { clientMutationId } }") +
       " -f a=" + quote(node_id) + " -f u=" + quote(user))

def _block(node_id, blocker_id):
    """A blocked-by link from an issue to another."""
    sh("gh api graphql -f query=" + quote("mutation starStepBlock($i: ID!, $b: ID!) { addBlockedBy(input: {issueId: $i, blockingIssueId: $b}) { clientMutationId } }") +
       " -f i=" + quote(node_id) + " -f b=" + quote(blocker_id))

def _comment(node_id, body):
    """A comment on an issue: the Scenario issue an item left."""
    sh("gh api graphql -f query=" + quote("mutation starComment($s: ID!, $b: String!) { addComment(input: {subjectId: $s, body: $b}) { commentEdge { node { id } } } }") +
       " -f s=" + quote(node_id) + " -f b=" + quote(body))

def _option_key(project, field, name):
    """The issue key an option's description holds: each Schedule and Scenario option names its own issue."""
    for o in project["fields"].get(field, {"options": []})["options"]:
        if o["name"] == name:
            return (o.get("description") or "").strip()
    return ""

def _project_for(row, sched):
    """The project a row is on, with its fields: the schedule's own when it is that one, else read."""
    return sched["project"] if row["project"]["id"] == sched["project"]["id"] else project_of(row["project"]["id"])

def _refusals(r, sched, model, account, assignee, resume):
    """Why an issue can't go on the schedule, each in plain words; none when it can."""
    out = []
    if parse_key(r["key"])["owner"].lower() != account.lower():
        out.append(r["key"] + " is in another account: a schedule's steps are its own account's issues")
    if r["state"] != "open":
        out.append(r["key"] + " is closed")
    t = type_named(model, r["type"]) if r["type"] else None
    if t == None or t.get("level") != leaf_level(model):
        out.append(r["key"] + " is " + ("of type " + r["type"] if r["type"] else "of no type") + ": a schedule's steps are tasks and bugs")
    here = [row for row in r["rows"] if row["project"]["id"] == sched["project"]["id"] and row["schedule"] == sched["option"]["name"]]
    if here and not resume:
        out.append(r["key"] + " is already on this schedule, at step " + str(here[0]["step"]))
    if not model["user"]:
        mine = team_of(model, r["repo"])
        theirs = team_of(model, sched["issue"]["repo"])
        if mine != theirs:
            if not assignee:
                out.append(r["key"] + " is " + str(mine) + "'s: give --assignee, a member of " + str(theirs) + ", to answer for it here")
            elif not _member(account, theirs, assignee):
                out.append(assignee + " is not a member of " + str(theirs))
    return out

def _plan(rs, new_keys, after):
    """Each row's target step: the new issues after the anchor, then every later row, consecutive whole numbers.

    The rows not being added are taken in their current step order. Those at or before after keep their steps; the new
    issues take the steps after it, or after the last when after is None; every later row follows, numbered on. A run that
    stopped partway moved the later rows from the highest down, which kept their order, so the same plan finishes it.
    Fails, naming the step, when after is not one of the schedule's.
    """
    existing = sorted([r for r in rs if r["step"] != None and r["issue"] not in new_keys], key = lambda r: r["step"])
    if after != None and after != 0 and after not in [r["step"] for r in existing]:
        steps = [r["step"] for r in existing]
        fail("the schedule has no step " + str(after) + "; its steps run " + (str(steps[0]) + " to " + str(steps[-1]) if steps else "nowhere: it has none"))
    base = after if after != None else (existing[-1]["step"] if existing else 0)
    before = [r for r in existing if r["step"] <= base]
    later = [r for r in existing if r["step"] > base]
    targets = {k: base + 1 + i for i, k in enumerate(new_keys)}
    moves = []
    for i, r in enumerate(later):
        to = base + len(new_keys) + 1 + i
        if r["step"] != to:
            moves.append({"row": r, "from": r["step"], "to": to})
    return {"targets": targets, "moves": moves, "anchor": before[-1]["item"] if before else None}

def _record(sched, key, kind, title, action, step, from_step, project):
    """One record of the result: the schedule, the issue, what add did to its row, and where."""
    return {
        "schedule": sched["issue"]["key"],
        "issue": key,
        "type": kind,
        "title": title,
        "action": action,
        "step": step,
        "from_step": from_step,
        "project": project,
    }

def _take_off(r, row, sched, model, login, date, reason):
    """An issue taken off the other schedule it is on: its later steps up one, and that Schedule issue amended.

    On the same project the row stays, and put gives it this schedule's option; on another team's project it is deleted.
    """
    other_key = _option_key(_project_for(row, sched), "Schedule", row["schedule"])
    if other_key == "":
        fail(r["key"] + " is on " + row["project"]["title"] + "'s schedule " + str(row["schedule"]) + ", whose option names no Schedule issue")
    other = schedule(other_key, model)
    moves = closing(rows(other, model), row["item"])
    for m in sorted(moves, key = lambda m: m["from"]):
        set_step(other["project"], m["row"]["item"], m["to"])
        _note("moved " + m["row"]["issue"] + " on " + other["issue"]["key"] + " from step " + str(m["from"]) + " to " + str(m["to"]))
    if row["project"]["id"] != sched["project"]["id"]:
        delete_row(row["project"]["id"], row["item"])
        _note("took " + r["key"] + "'s row off " + row["project"]["title"])
    amend(other["issue"], amendment({
        "date": date,
        "login": login,
        "reason": reason,
        "added": [],
        "taken": [{"step": row["step"], "type": r["type"], "issue": r["key"], "title": r["title"], "to": sched["issue"]["key"]}],
        "moved": span(moves),
    }))
    _note("amended " + other["issue"]["key"])
    return [_record(other, r["key"], r["type"], r["title"], "taken-off", None, row["step"], other["project"]["title"])] + [
        _record(other, m["row"]["issue"], m["row"]["type"], m["row"]["title"], "moved", m["to"], m["from"], other["project"]["title"])
        for m in moves
    ]

def run(_command, ctx):
    """Check gh's access, read the schedule and each issue, refuse what can't go on it, then put each on it, in one act.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the schedule, the issues, --after, --blocked-by, --assignee and --reason;
        ctx.dry_run, star's --dry-run, which add refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    reason = (ctx.args.get("reason") or "").strip()
    if reason == "":
        fail("add needs --reason: the amendment it writes says why the schedule changed (section 8, question 4)")
    issues = [i.strip() for i in (ctx.args.get("issues") or []) if i.strip()]
    if not issues:
        fail("add needs one issue or more, <owner>/<repository>#<number>")
    after = _after(ctx.args.get("after"))
    assignee = (ctx.args.get("assignee") or "").strip()
    check_access("star github schedule add", scopes = ["project"], dry_run = ctx.dry_run)

    sk = parse_key(ctx.args.get("schedule") or "")
    account = sk["owner"]
    keys = [parse_key(i)["key"] for i in issues]
    if len({k: True for k in keys}) != len(keys):
        fail("an issue is named twice: " + ", ".join(keys))
    blockers = [parse_key(b)["key"] for b in _list(ctx.args.get("blocked-by"))]
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
        refused.extend(_refusals(r, sched, model, account, assignee, resume))
    blocking = {b: issue(b, model)["id"] for b in blockers}
    if refused:
        fail("nothing was written:\n  " + "\n  ".join(refused))
    plan = _plan(first, keys, after)

    # One act: the rows read again just before the first write, and nothing written if they changed.
    if snapshot(rows(sched, model)) != snapshot(first):
        fail("the schedule " + sched["issue"]["key"] + " changed while add read it; nothing was written: run it again")

    login = viewer()
    date = today()
    title = sched["project"]["title"]
    out = []
    record = {
        "date": date,
        "login": login,
        "reason": reason,
        "added": [{"step": plan["targets"][r["key"]], "type": r["type"], "issue": r["key"], "title": r["title"]} for r in read],
        "taken": [],
        "moved": span(plan["moves"]),
    }

    # The amendment first, pending: a run that stops partway leaves its record, which the same command run again finishes.
    if not resume:
        amend(sched["issue"], amendment(record, pending = True))
        _note("wrote the amendment in " + sched["issue"]["key"] + ", in progress")

    # The later rows first, from the highest down, which keeps their order should the run stop partway.
    for m in sorted(plan["moves"], key = lambda m: -m["from"]):
        set_step(sched["project"], m["row"]["item"], m["to"])
        _note("moved " + m["row"]["issue"] + " from step " + str(m["from"]) + " to " + str(m["to"]))
        out.append(_record(sched, m["row"]["issue"], m["row"]["type"], m["row"]["title"], "moved", m["to"], m["from"], title))

    previous = plan["anchor"] or sched["own_item"]
    for r in read:
        step = plan["targets"][r["key"]]
        here = [row for row in r["rows"] if row["project"]["id"] == sched["project"]["id"]]
        for row in [row for row in r["rows"] if row["kind"] == SCHEDULE_KIND and row["schedule"] not in [None, sched["option"]["name"]]]:
            out.extend(_take_off(r, row, sched, model, login, date, reason))
        item = here[0]["item"] if here else add_row(sched["project"], r["id"])
        put(sched, item, step)
        place_after(sched["project"], item, previous)
        check_row(sched, item, step, r["key"])
        _note("put " + r["key"] + " on " + sched["issue"]["key"] + " at step " + str(step))
        previous = item

        for b in blockers:
            if b not in r["blocked_by"]:
                _block(r["id"], blocking[b])
                _note("linked " + r["key"] + " as blocked by " + b)
        if assignee and assignee.lower() not in [a.lower() for a in r["assignees"]]:
            _assign(r["id"], assignee)
            _note("assigned " + r["key"] + " to " + assignee)

        for row in r["rows"]:
            if row["kind"] in _LEAVES:
                delete_row(row["project"]["id"], row["item"])
                _note("took " + r["key"] + "'s row off " + row["project"]["title"])
                out.append(_record(sched, r["key"], r["type"], r["title"], "left", None, None, row["project"]["title"]))
            elif row["kind"] == SCENARIO_KIND and row["scenario"] != None:
                _leave_scenario(r, row, sched, model, step, login, date, reason)
                out.append(_record(sched, r["key"], r["type"], r["title"], "left", None, None, row["project"]["title"]))
        out.append(_record(sched, r["key"], r["type"], r["title"], "added", step, None, title))

    settle(sched["issue"], keys, amendment(record))
    _note("amended " + sched["issue"]["key"])

    # Every moved row read back at its new step.
    for m in plan["moves"]:
        back = read_row(m["row"]["item"])
        if back == None or back["step"] != m["to"]:
            fail(m["row"]["issue"] + "'s row reads back at step " + str(back["step"] if back else None) + ", not " + str(m["to"]))
    return out

def _leave_scenario(r, row, sched, model, step, login, date, reason):
    """An item leaving the scenario it was found walking: a comment on the Scenario issue first, then its row deleted.

    The comment comes first, so that a run that stops between the two leaves a second comment, not a move unrecorded.
    """
    key = _option_key(project_of(row["project"]["id"]), "Scenario", row["scenario"])
    if key == "":
        fail(r["key"] + " is on " + row["project"]["title"] + "'s scenario " + row["scenario"] + ", whose option names no Scenario issue")
    scenario = issue(key, model)
    _comment(scenario["id"], r["key"] + " left this scenario on " + date + " for " + sched["issue"]["key"] + ", as its step " + str(step) +
                             ", by `star github schedule add`, run by " + login + ": " + reason)
    _note("commented on " + key + " that " + r["key"] + " left it")
    delete_row(row["project"]["id"], row["item"])
    _note("took " + r["key"] + "'s row off " + row["project"]["title"])
