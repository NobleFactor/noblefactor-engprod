# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model diff: what differs between a model and an account's, as GitHub holds it now."""

# github-model-diff.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, Requirement 3. The model is a file, the form get returns, another
# account's, a backup, or a reference named by its path; the account is always named. diff reads the account from
# GitHub, compares, and returns one record for each difference; it writes nothing, and it exits 0 whether there are
# differences or none (reconcile.star).

load("commands/access.star", "check_access")
load("commands/model.star", "refuse_dry_run")
load("commands/reconcile.star", "differences")

def run(_command, ctx):
    """Check gh's access, then compare the model with the account's and return the differences.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the model and the account.
    """
    model = (ctx.args.get("model") or "").strip()
    account = (ctx.args.get("account") or "").strip()
    if model == "" or account == "":
        fail("name the model and the account: star github model diff <model> <account>")
    refuse_dry_run(ctx.dry_run)
    check_access("star github model diff", scopes = ["read:project"], dry_run = ctx.dry_run)
    return differences(model, account)
