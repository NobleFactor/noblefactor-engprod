# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario get: one scenario's rows, its Scenario issue's own row first, then its rows in Beat order."""

# github-scenario-get.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 3 (noblefactor-engprod#510), to section 9 of the issue data
# model, § Reading: list and get. collections.star reads a scenario as it reads a schedule; each record is a row's Beat,
# its issue's key, type, title and state, and its Status.

load("commands/access.star", "check_access")
load("commands/collections.star", "get_collection")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCENARIO_KIND")

def run(_command, ctx):
    """Check gh's access, then return one record for each row of the scenario named.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the scenario, its Scenario issue's key; ctx.dry_run, star's --dry-run, which
        get refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("scenario") or "").strip()
    if key == "":
        fail("name the scenario: star github scenario get <owner>/<repository>#<number>")
    check_access("star github scenario get", scopes = ["read:project"], dry_run = ctx.dry_run)
    return get_collection(SCENARIO_KIND, key)
