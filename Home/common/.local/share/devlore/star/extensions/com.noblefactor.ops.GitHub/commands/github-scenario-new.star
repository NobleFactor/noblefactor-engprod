# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario new: a scenario made, its Scenario issue filed from the account's form, its option and its row."""

# github-scenario-new.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 4 (noblefactor-engprod#509), to section 9 of the issue data
# model, § Making a scenario: new. making.star makes a scenario as it makes a schedule; the Scenario issue's body is the
# account's Scenario form's sections, filled from --wants, --walk and --features, with its beats line just above its
# Plan and design documents section. --walk must number its steps: Beat N is step N of the walk.

load("commands/access.star", "check_access")
load("commands/making.star", "make_collection")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCENARIO_KIND")

def run(_command, ctx):
    """Check gh's access, then make the scenario named in the repository named, and return one record of what was made.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the repository, the name, --area, --wants, --walk, --features, --priority
        and --assignee; ctx.dry_run, star's --dry-run, which new refuses until NobleFactor/devlore-cli#1170 lets a dry
        run read.
    """
    refuse_dry_run(ctx.dry_run)
    repository = (ctx.args.get("repository") or "").strip()
    name = (ctx.args.get("name") or "").strip()
    if repository == "" or name == "":
        fail("name the repository and the scenario: star github scenario new <repository> <name> --area Product|Engineering " +
             "--wants <text> --walk <text> --features <text>")
    check_access("star github scenario new", scopes = ["project"], dry_run = ctx.dry_run)
    given = {flag: ctx.args.get(flag) or "" for flag in ["area", "wants", "walk", "features", "priority", "assignee"]}
    return [make_collection(SCENARIO_KIND, repository, name, given)]
