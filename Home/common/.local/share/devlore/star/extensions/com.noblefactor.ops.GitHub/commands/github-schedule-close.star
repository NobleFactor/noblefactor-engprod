# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule close: a finished schedule closed, with its evidence comment, its row Closed and its option kept."""

# github-schedule-close.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 5 (noblefactor-engprod#512), to section 8 of the issue data
# model, § Ending a schedule: close. ending.star ends a schedule as it retires a scenario; close refuses while a step is
# open or an exit criterion's box is unticked, and its comment, rendered from templates/evidence.md.template, shows
# what merged and when, and how each step no merged pull request closed did.

load("commands/access.star", "check_access")
load("commands/ending.star", "close_schedule")
load("commands/model.star", "refuse_dry_run")

def run(_command, ctx):
    """Check gh's access, then close the schedule named, and return one record of what was done.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the schedule, its Schedule issue's key; ctx.dry_run, star's --dry-run, which
        close refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("schedule") or "").strip()
    if key == "":
        fail("name the schedule: star github schedule close <owner>/<repository>#<number>")
    check_access("star github schedule close", scopes = ["project"], dry_run = ctx.dry_run)
    return [close_schedule(key)]
