# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule reopen: a closed schedule reopened, its own row In progress and its every-step criterion unticked."""

# github-schedule-reopen.star
#
# Section 8 of the issue data model, § Reopening a schedule: reopen (#595). ending.star reopens it, as star github issue reopen reopens the closed schedule a reopened step is on: the Schedule issue
# reopened with its comment, its own row In progress, and each ticked exit criterion beginning "Every step" or "Every
# other step" unticked. The
# comment is rendered from templates/issue-reopen.md.template. An open schedule is unchanged.

load("commands/access.star", "check_access")
load("commands/ending.star", "reopen_schedule", "schedule_reopening")
load("commands/issues.star", "render")
load("commands/model.star", "refuse_dry_run")
load("commands/scheme.star", "model_of", "models_for")
load("commands/steps.star", "SCHEDULE_KIND", "parse_key", "today", "viewer")

_COMMAND = "star github schedule reopen"

def run(_command, ctx):
    """Check gh's access, read the schedule, then reopen it, unless it is open, and return one record of what was done.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the schedule, its Schedule issue's key, and --reason; ctx.dry_run, star's
        --dry-run, which reopen refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("schedule") or "").strip()
    if key == "":
        fail("name the schedule: star github schedule reopen <owner>/<repository>#<number> --reason <text>")
    reason = " ".join((ctx.args.get("reason") or "").split())
    if reason == "":
        fail("schedule reopen needs --reason: it is written in the comment on the Schedule issue")
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)
    k = parse_key(key)
    model = model_of(models_for([k["owner"]]), k["owner"])
    plan, fault = schedule_reopening(k["key"], model)
    if fault:
        fail("nothing was written: " + fault)
    own = plan["sched"]["issue"]
    if own["state"] != "closed":
        return [{"issue": own["key"], "kind": SCHEDULE_KIND, "action": "unchanged", "status": None, "criteria": []}]
    body = render("issue-reopen.md.template", {"command": _COMMAND, "date": today(), "login": viewer(), "reason": reason, "cause": ""})
    return [dict(reopen_schedule(plan, body), action = "reopened")]
