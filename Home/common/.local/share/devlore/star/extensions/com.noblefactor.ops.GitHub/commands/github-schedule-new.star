# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule new: a schedule made, its Schedule issue filed from the account's form, its option and its row."""

# github-schedule-new.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 4 (noblefactor-engprod#509), to section 8 of the issue data
# model, § Making a schedule: new. making.star makes a schedule as it makes a scenario; the Schedule issue's body is the
# account's Schedule form's sections, filled from --deliverable, --exit-criteria and --evidence, then its Steps line and
# an empty Amendments section. It replaces Start-Claude's --schedule new (section 8, question 7).

load("commands/access.star", "check_access")
load("commands/making.star", "make_collection")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCHEDULE_KIND")

def run(_command, ctx):
    """Check gh's access, then make the schedule named in the repository named, and return one record of what was made.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the repository, the name, --area, --deliverable, --exit-criteria,
        --evidence, --priority and --assignee; ctx.dry_run, star's --dry-run, which new refuses until
        NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    repository = (ctx.args.get("repository") or "").strip()
    name = (ctx.args.get("name") or "").strip()
    if repository == "" or name == "":
        fail("name the repository and the schedule: star github schedule new <repository> <name> --area Product|Engineering " +
             "--deliverable <text> --exit-criteria <text> --evidence <text>")
    check_access("star github schedule new", scopes = ["project"], dry_run = ctx.dry_run)
    given = {flag: ctx.args.get(flag) or "" for flag in ["area", "deliverable", "exit-criteria", "evidence", "priority", "assignee"]}
    return [make_collection(SCHEDULE_KIND, repository, name, given)]
