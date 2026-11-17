# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule get: one schedule's rows, its Schedule issue's own row first, then its steps in step order."""

# github-schedule-get.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 3 (noblefactor-engprod#510), to section 8 of the issue data
# model, § Reading: list, get and report. collections.star reads a schedule as it reads a scenario; each record is a
# row's step, its issue's key, type, title and state, its Status, Worktree and Iteration, and the keys of the issues
# that block it: its open blockers alone, since a closed issue blocks nothing, as GitHub's is:blocked counts only open
# ones.

load("commands/access.star", "check_access")
load("commands/collections.star", "get_collection")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCHEDULE_KIND")

def run(_command, ctx):
    """Check gh's access, then return one record for each row of the schedule named.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the schedule, its Schedule issue's key; ctx.dry_run, star's --dry-run, which
        get refuses until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    key = (ctx.args.get("schedule") or "").strip()
    if key == "":
        fail("name the schedule: star github schedule get <owner>/<repository>#<number>")
    check_access("star github schedule get", scopes = ["read:project"], dry_run = ctx.dry_run)
    return get_collection(SCHEDULE_KIND, key)
