# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model get: an account's issue data model as GitHub holds it now, as one record."""

# github-model-get.star
#
# docs/plans/feature/426-model-pull-to-dot-github.md, Requirement 1. GitHub holds the only definitive model (ruled
# 2026-11-09): get enumerates it, piece by piece, and returns it, JSON by default; star's --output renders it, and
# -o yaml gives the form star github model backup keeps in the account's .github repository. The account is always
# named: no account is a default. When the account's .github repository holds a Triage workflow template, the model ends
# with its token record: each secret the template signs in with that GitHub holds everywhere a workflow reads it, as
# held or by the source the account's current backup records (credentials.star, #451).

load("commands/access.star", "check_access")
load("commands/credentials.star", "read_token")
load("commands/model.star", "read_model", "refuse_dry_run")

def run(_command, ctx):
    """Check gh's access, then read the account's model from GitHub and return it.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account.
    """
    account = (ctx.args.get("account") or "").strip()
    if account == "":
        fail("name the account: star github model get <account>")
    refuse_dry_run(ctx.dry_run)
    check_access("star github model get", scopes = ["read:project"], dry_run = ctx.dry_run)
    model = read_model(account)
    kind = "organization" if "teams" in model else "user"
    repositories = sorted(((model.get("labels") or {}).get("repositories") or {}).keys())
    token = read_token(account, kind, repositories)
    if token != None:
        model["token"] = token
    return model
