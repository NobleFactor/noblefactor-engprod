# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""Create the labels the audit reports missing and align the ones that drifted; never delete."""

# gh-labels-sync.star

load("commands/access.star", "check_access")
load("commands/scheme.star", "label_faults", "label_inventory", "label_sync", "resolve_repos")

def run(_command, ctx):
    """Sync the label set across the repositories read: writ's layers', unless --repo or --directory names others; honors --dry-run."""
    check_access("star gh labels sync", dry_run = ctx.dry_run)
    repos = resolve_repos(ctx.args.get("repo", ""), ctx.args.get("directory", ""))
    rows = label_faults(label_inventory(repos), repos)
    if len(rows) == 0:
        succeed("nothing to sync: every repository carries the set")
        return []
    done = label_sync(rows, ctx.dry_run)
    n = len([d for d in done if d["action"] != "skip"])
    if ctx.dry_run:
        succeed(str(n) + " change(s) would be made")
    else:
        succeed(str(n) + " change(s) made")
    return done
