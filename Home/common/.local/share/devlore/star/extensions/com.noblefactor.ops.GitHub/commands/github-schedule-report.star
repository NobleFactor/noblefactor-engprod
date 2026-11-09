# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""Every issue of the repositories named, or of writ's layers, as one flat record each."""

# github-schedule-report.star
#
# docs/plans/feature/436-triage-sweep.md, Requirement 2 (noblefactor-engprod#379). The result is the records, JSON by
# default; star's global --filter and --jq narrow them and --output renders them, and the report binds none of them
# (docs/architecture/10-command-line-interface.md in devlore-cli, §8 and §14). Its one selection of its own is
# --search, which narrows what is read.

load("commands/access.star", "check_access")
load("commands/model.star", "read_first")
load("commands/records.star", "fetch", "records")
load("commands/scheme.star", "MODEL_DIGEST_FAULTS", "canonical_repo", "default_repos", "model_for")

def run(_command, ctx):
    """Check gh's access, read each account's record against its model, then return every issue's record.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the repositories named and --search.
    """
    check_access("star github schedule report", dry_run = ctx.dry_run)
    repos = [canonical_repo(r.strip()) for r in (ctx.args.get("repositories") or []) if r.strip()] or default_repos()
    accounts = []
    for repo in repos:
        account = model_for(repo)["account"]
        if account not in accounts:
            accounts.append(account)
    for fault in MODEL_DIGEST_FAULTS:
        warn(fault)
    for account in accounts:
        behind = read_first(account = account, dry_run = ctx.dry_run)
        if behind:
            warn(behind)
    return records(fetch(repos, search = ctx.args.get("search", "")))
