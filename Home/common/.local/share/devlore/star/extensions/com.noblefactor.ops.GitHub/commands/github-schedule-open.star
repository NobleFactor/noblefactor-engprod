# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule open, and create: a schedule opened, its Schedule issue, its option and its own row."""

# github-schedule-open.star
#
# Section 8 of the issue data model, § Opening a schedule: open, and create (#509, #595). making.star opens a schedule as
# it opens a scenario. The Schedule issue's body is the account's Schedule form's sections, filled from --deliverable,
# --exit-criteria and --evidence, then its Steps line and an empty Amendments section. create is the same command, a
# second manifest entry until NobleFactor/devlore-cli#1235 lets an extension command name an alias.

load("commands/access.star", "check_access")
load("commands/making.star", "make_collection")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCHEDULE_KIND")

def run(_command, ctx):
    """Check gh's access, then open the schedule named in the repository named, and return one record of what was made.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the repository, the name, --area, --deliverable, --exit-criteria,
        --evidence, --priority and --assignee; ctx.dry_run, star's --dry-run, which open refuses until
        NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    repository = (ctx.args.get("repository") or "").strip()
    name = (ctx.args.get("name") or "").strip()
    if repository == "" or name == "":
        fail("name the repository and the schedule: star github schedule open <repository> <name> --area Product|Engineering " +
             "--deliverable <text> --exit-criteria <text> --evidence <text>")
    check_access("star github schedule open", scopes = ["project"], dry_run = ctx.dry_run)
    given = {flag: ctx.args.get(flag) or "" for flag in ["area", "deliverable", "exit-criteria", "evidence", "priority", "assignee"]}
    return [make_collection(SCHEDULE_KIND, repository, name, given)]
