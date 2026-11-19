# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario close: a scenario the product no longer has, closed with its reason, its row Closed."""

# github-scenario-close.star
#
# Section 9 of the issue data model, § Closing a scenario: close (#512, #595). ending.star closes a scenario as it closes
# a schedule. close refuses while an open item is a row of the scenario, then closes the Scenario issue as completed with
# no Resolution, since nothing was left undone, its comment, rendered from templates/scenario-close.md.template, giving
# the reason. The option is kept.

load("commands/access.star", "check_access")
load("commands/ending.star", "close_scenario")
load("commands/model.star", "refuse_dry_run")

def run(_command, ctx):
    """Check gh's access, then close the scenario named, and return one record of what was done.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the scenario, its Scenario issue's key, and --reason; ctx.dry_run, star's
        --dry-run, which close refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("scenario") or "").strip()
    if key == "":
        fail("name the scenario: star github scenario close <owner>/<repository>#<number> --reason <text>")
    check_access("star github scenario close", scopes = ["project"], dry_run = ctx.dry_run)
    return [close_scenario(key, ctx.args.get("reason") or "")]
