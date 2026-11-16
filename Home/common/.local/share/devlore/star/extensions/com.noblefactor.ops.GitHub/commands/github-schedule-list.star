# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github schedule list: every schedule of an account or of one of its teams, one record each."""

# github-schedule-list.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 3 (noblefactor-engprod#510), to section 8 of the issue data
# model, § Reading: list, get and report. collections.star lists schedules as it lists scenarios: one record for each
# option of the Schedule field of the account's Schedule projects, or the team's, with its Schedule issue's key, title,
# state and assignee, the project, and the counts of its open and closed steps. The account is always named: no account
# is a default (section 6, ruled 2026-11-09).

load("commands/access.star", "check_access")
load("commands/collections.star", "list_collections")
load("commands/model.star", "refuse_dry_run")
load("commands/steps.star", "SCHEDULE_KIND")

def run(_command, ctx):
    """Check gh's access, then return one record for each schedule of the account named, or of the team --team names.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account and --team; ctx.dry_run, star's --dry-run, which list refuses
        until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    account = (ctx.args.get("account") or "").strip()
    if account == "":
        fail("name the account: star github schedule list <account> [--team <team>]")
    check_access("star github schedule list", scopes = ["read:project"], dry_run = ctx.dry_run)
    return list_collections(SCHEDULE_KIND, account, (ctx.args.get("team") or "").strip())
