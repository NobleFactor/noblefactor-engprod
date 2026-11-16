# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github scenario list: every scenario of an account or of one of its teams, one record each."""

# github-scenario-list.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 3 (noblefactor-engprod#510), to section 9 of the issue data
# model, § Reading: list and get. collections.star lists scenarios as it lists schedules: one record for each option of
# the Scenario field of the account's Scenario projects, or the team's, with its Scenario issue's key, title, state and
# assignee, the project, and the counts of its open and closed rows. The account is always named: no account is a
# default (section 6, ruled 2026-11-09).

load("commands/access.star", "check_access")
load("commands/collections.star", "list_collections")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCENARIO_KIND")

def run(_command, ctx):
    """Check gh's access, then return one record for each scenario of the account named, or of the team --team names.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account and --team; ctx.dry_run, star's --dry-run, which list refuses
        until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    account = (ctx.args.get("account") or "").strip()
    if account == "":
        fail("name the account: star github scenario list <account> [--team <team>]")
    check_access("star github scenario list", scopes = ["read:project"], dry_run = ctx.dry_run)
    return list_collections(SCENARIO_KIND, account, (ctx.args.get("team") or "").strip())
