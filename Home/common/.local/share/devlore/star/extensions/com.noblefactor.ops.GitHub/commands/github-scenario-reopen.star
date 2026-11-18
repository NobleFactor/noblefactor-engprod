# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario reopen: a closed scenario reopened, its own row Open."""

# github-scenario-reopen.star
#
# Section 9 of the issue data model, § Reopening a scenario: reopen (#595). ending.star reopens it, the Scenario issue reopened with its comment and its own row Open. The
# comment is rendered from templates/issue-reopen.md.template. An open scenario is unchanged.

load("commands/access.star", "check_access")
load("commands/ending.star", "reopen_scenario", "scenario_reopening")
load("commands/issues.star", "render")
load("commands/model.star", "refuse_dry_run")
load("commands/scheme.star", "model_of", "models_for")
load("commands/steps.star", "SCENARIO_KIND", "parse_key", "today", "viewer")

_COMMAND = "star github scenario reopen"

def run(_command, ctx):
    """Check gh's access, read the scenario, then reopen it, unless it is open, and return one record of what was done.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the scenario, its Scenario issue's key, and --reason; ctx.dry_run, star's
        --dry-run, which reopen refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("scenario") or "").strip()
    if key == "":
        fail("name the scenario: star github scenario reopen <owner>/<repository>#<number> --reason <text>")
    reason = " ".join((ctx.args.get("reason") or "").split())
    if reason == "":
        fail("scenario reopen needs --reason: it is written in the comment on the Scenario issue")
    check_access(_COMMAND, scopes = ["project"], dry_run = ctx.dry_run)
    k = parse_key(key)
    model = model_of(models_for([k["owner"]]), k["owner"])
    plan, fault = scenario_reopening(k["key"], model)
    if fault:
        fail("nothing was written: " + fault)
    own = plan["scen"]["issue"]
    if own["state"] != "closed":
        return [{"issue": own["key"], "kind": SCENARIO_KIND, "action": "unchanged", "status": None}]
    body = render("issue-reopen.md.template", {"command": _COMMAND, "date": today(), "login": viewer(), "reason": reason, "cause": ""})
    return [dict(reopen_scenario(plan, body), action = "reopened")]
