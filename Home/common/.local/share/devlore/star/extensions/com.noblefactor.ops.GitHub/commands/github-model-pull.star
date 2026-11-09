# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model pull: an account's record into its model file, read conditionally, with the diff; --check previews.

--check is a workaround for NobleFactor/devlore-cli#1170 (https://github.com/NobleFactor/devlore-cli/issues/1170):
star's --dry-run skips the reads a preview needs, so this command refuses it. See model.star § the preview.
"""

# github-model-pull.star

load("commands/access.star", "check_access")
load(
    "commands/model.star",
    "compare",
    "default_account",
    "default_asset",
    "exists",
    "fresh_text",
    "kept_on_github",
    "model_copy",
    "model_source",
    "owner_kind",
    "preview",
    "read_text",
    "recorded_at",
    "recorded_digest",
    "refuse_unless_on_a_branch",
    "unified_diff",
    "without_stamp",
    "write_cache",
    "write_text",
)

def run(_command, ctx):
    """Pull an account's model, an organization's or a user's, into its model file; return what moved and the diff.

    --account names the account; with none, star configuration's github.account, and then NobleFactor. The model file is
    --asset. With none, it is model.<account>.yaml beside the extension; an account whose model is kept on GitHub, in its
    .github repository (#431), has no such file, so a pull that would write refuses, and --check compares GitHub with
    the model star read, its copy, named as <account>/.github/model.yaml.
    """
    account = ctx.args.get("account", "") or default_account()
    check = preview(ctx)  # --check: the workaround for devlore-cli#1170
    asset = ctx.args.get("asset", "")
    shown = ""
    if asset == "" and check and kept_on_github(account):
        asset = model_copy(account)
        shown = model_source(account)
    elif asset == "":
        asset = default_asset(account)
    check_access("star github model pull", scopes = ["read:project"])
    kind = owner_kind(account)
    if kind == "organization":
        check_access("star github model pull", org = account, scopes = ["read:project"])

    # An account with no model file yet gets one: the pull compares with an empty model of it, and the file need only
    # be on a branch, there being no uncommitted change of its own to guard.
    fresh = not exists(asset)
    path = asset if check else refuse_unless_on_a_branch(asset, clean = not fresh)

    old_text = fresh_text(account) if fresh else read_text(path)
    c = compare(account, old_text, kind = kind)
    if c["conflicts"]:
        fail("nothing written; fix these in GitHub's settings and pull again:\n  " + "\n  ".join(c["conflicts"]))
    new_text = c["new_text"]
    recorded = c["recorded"]
    read_at = c["read_at"]
    name = (shown or path).split("/")[-1]
    report = ["[star] " + account + " (" + kind + ") into " + (shown or path) + (" (--check: nothing written)" if check else "")]
    report.extend(["[star] " + line for line in c["reads"]])
    report.extend(["[star] " + n for n in c["notes"]])

    if without_stamp(new_text) == without_stamp(old_text):
        write_cache(account, recorded, c["types_etag"], c["hub_repo"], c["labels_etag"], True, read_at)
        report.append("[star] " + name + " unchanged")
        return "\n".join(report)

    diff = unified_diff(old_text, new_text, name + " (pulled " + recorded_at(old_text) + ")", "GitHub (" + account + ", " + read_at + ")")
    done = "written, the account's first" if fresh else "rewritten"
    if check:
        report.append("[star] " + name + " would be " + done + "; --check wrote nothing")
    else:
        write_text(path, new_text)
        write_cache(account, recorded_digest(new_text), c["types_etag"], c["hub_repo"], c["labels_etag"], True, read_at)
        report.append("[star] " + name + " " + done)
    return "\n".join(report) + "\n" + diff
