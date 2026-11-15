# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model restore: an account's backup, main's or a revision's, applied to it."""

# github-model-restore.star
#
# docs/plans/feature/437-model-diff-apply-restore.md, Requirement 5. restore reads model.yaml from the account's .github
# repository, at the revision named or main (decision 8), and applies it as apply does (apply.star), with --prune and
# --token as apply takes them. The owner runs it; a session writes the command and hands it over (ruled 2026-11-09).

load("commands/access.star", "check_access")
load("commands/apply.star", "apply_model")
load("commands/model.star", "refuse_dry_run")
load("commands/participation.star", "read_file")
load("commands/tokens.star", "check", "parse")

def run(_command, ctx):
    """Check gh's access, read the account's backup at the revision, and apply it.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the account, the revision, --prune and --token.
    """
    account = (ctx.args.get("account") or "").strip()
    revision = (ctx.args.get("revision") or "main").strip()
    if account == "":
        fail("name the account: star github model restore <account> [<revision>]")
    sources = parse(ctx.args.get("token") or "")
    refuse_dry_run(ctx.dry_run)
    check(sources)
    check_access("star github model restore", scopes = ["repo", "project", "admin:org", "workflow"], dry_run = ctx.dry_run)
    text = read_file(account + "/.github", "model.yaml", revision)
    if text == None:
        fail(account + "/.github holds no model.yaml at " + revision + ": back it up first, star github model backup " + account)
    model = yaml.decode(data = text)
    if type(model) != "dict" or model.get("account") != account:
        fail(account + "/.github's model.yaml at " + revision + " is not " + account + "'s backup")
    return apply_model(model, account, ctx.args.get("prune") in [True, "true"], sources)
