# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario retire: a scenario the product no longer has, closed with its reason, its row Closed."""

# github-scenario-retire.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 5 (noblefactor-engprod#512), to section 9 of the issue data
# model, § Removing a scenario: retire. ending.star retires a scenario as it closes a schedule; retire refuses while an
# open item is a row of the scenario, and closes its Scenario issue as completed with no Resolution, since nothing was
# left undone, its comment, rendered from templates/retire.md.template, giving the reason. The option is kept.

load("commands/access.star", "check_access")
load("commands/ending.star", "retire_scenario")
load("commands/model.star", "refuse_dry_run")

def run(_command, ctx):
    """Check gh's access, then retire the scenario named, and return one record of what was done.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the scenario, its Scenario issue's key, and --reason; ctx.dry_run, star's
        --dry-run, which retire refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("scenario") or "").strip()
    if key == "":
        fail("name the scenario: star github scenario retire <owner>/<repository>#<number> --reason <text>")
    check_access("star github scenario retire", scopes = ["project"], dry_run = ctx.dry_run)
    return [retire_scenario(key, ctx.args.get("reason") or "")]
