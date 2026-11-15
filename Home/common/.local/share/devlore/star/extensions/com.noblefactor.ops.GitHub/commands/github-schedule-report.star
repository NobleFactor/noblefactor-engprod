# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""Every issue of the repositories named, or of writ's layers, as one flat record each."""

# github-schedule-report.star
#
# docs/plans/feature/436-triage-sweep.md, Requirement 2 (noblefactor-engprod#379). The result is the records, JSON by
# default; star's global --filter and --jq narrow them and --output renders them, and the report binds none of them
# (docs/architecture/10-command-line-interface.md in devlore-cli, §8 and §14). Its one selection of its own is
# --search, which narrows what is read. Each repository owner's model is read from GitHub when the report runs
# (noblefactor-engprod#426).

load("commands/access.star", "check_access")
load("commands/model.star", "refuse_dry_run")
load("commands/records.star", "fetch", "records")
load("commands/scheme.star", "canonical_repo", "default_repos", "models_for")

def run(_command, ctx):
    """Check gh's access, read each repository owner's model from GitHub, then return every issue's record.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the repositories named and --search.
    """
    refuse_dry_run(ctx.dry_run)
    check_access("star github schedule report", dry_run = ctx.dry_run)
    repos = [canonical_repo(r.strip()) for r in (ctx.args.get("repositories") or []) if r.strip()] or default_repos()
    models = models_for([repo.split("/")[0] for repo in repos])
    return records(fetch(repos, models, search = ctx.args.get("search", "")), models)
