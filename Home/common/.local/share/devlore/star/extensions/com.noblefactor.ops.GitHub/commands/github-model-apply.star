# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model apply: a model made an account's, every difference diff finds made in GitHub."""

# github-model-apply.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, Requirement 4. The model is a file, the form get returns, another
# account's, a backup, or a reference named by its path; the account is always named. apply reconciles (apply.star): it
# creates what is missing and changes what differs, and deletes only with --prune. The owner runs it; a session writes
# the command and hands it over (ruled 2026-11-09). Afterward, star github model backup records the account's new model.

load("commands/access.star", "check_access")
load("commands/apply.star", "apply_model")
load("commands/model.star", "refuse_dry_run")

def run(_command, ctx):
    """Check gh's access, then make the model the account's and return what was done about each difference.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the model, the account, --prune and --token.
    """
    model = (ctx.args.get("model") or "").strip()
    account = (ctx.args.get("account") or "").strip()
    if model == "" or account == "":
        fail("name the model and the account: star github model apply <model> <account>")
    refuse_dry_run(ctx.dry_run)
    check_access("star github model apply", scopes = ["repo", "project", "admin:org"], dry_run = ctx.dry_run)
    return apply_model(model, account, ctx.args.get("prune") in [True, "true"])
