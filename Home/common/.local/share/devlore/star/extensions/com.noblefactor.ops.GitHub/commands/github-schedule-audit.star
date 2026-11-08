# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""Every open issue the classification scheme cannot place, with the fault."""

# gh-issues-audit.star

load("commands/access.star", "check_access")
load("commands/model.star", "read_first")
load("commands/scheme.star", "audit", "audit_lines", "exempt_numbers", "faults", "fetch_issues", "resolve_repos", "unthreaded", "unthreaded_lines")

def _run(ctx):
    """The classification audit as rows; the script's audit section with --markdown.

    Args:
      ctx: the invocation -- ctx.args carries the flags.
    """
    limit = ctx.args.get("limit", 500)
    directory = ctx.args.get("directory", "")
    repo_flag = ctx.args.get("repo", "")
    markdown = ctx.args.get("markdown", False)

    repos = resolve_repos(repo_flag, directory)
    if len(repos) > 1:
        note("repositories: " + ", ".join(repos))
    all = fetch_issues("open", limit, repos)

    # A requested validation, not a fault: which open work is in no thread, for a person to decide.
    if ctx.args.get("unthreaded", False):
        rows = unthreaded(all, ctx.args.get("epic", ""))
        if markdown:
            return "\n".join(unthreaded_lines(rows))
        return rows

    a = audit(all, exempt_numbers())

    if markdown:
        return "\n".join(["## Classification audit\n"] + audit_lines(a))

    return [{"issue": i["number"], "repo": i["repo"], "ref": i["ref"], "url": i["url"], "title": i["title"], "faults": faults(i)} for i in a["bad"]]

def run(_command, ctx):
    """Check gh's access, read GitHub's record against the asset, then run; say when the asset is behind (#378).

    The line goes first in a markdown document, where --silent cannot hide it, and to a warning otherwise.
    """
    check_access("star github schedule audit", dry_run = ctx.dry_run)
    behind = read_first(dry_run = ctx.dry_run)
    result = _run(ctx)
    if behind == "":
        return result
    if type(result) == "string":
        return "> " + behind + "\n\n" + result
    warn(behind)
    return result
