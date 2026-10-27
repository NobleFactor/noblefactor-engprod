# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model pull: the organization's record into model.yaml, read conditionally, with the diff; --check previews.

--check is a workaround for NobleFactor/devlore-cli#1170 (https://github.com/NobleFactor/devlore-cli/issues/1170):
star's --dry-run skips the reads a preview needs, so this command refuses it. See model.star § the preview.
"""

# gh-model-pull.star

load("commands/access.star", "check_access")
load(
    "commands/model.star",
    "compare",
    "default_asset",
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
    """Pull the organization's types, the hub's labels and the projects into the asset; return what moved and the diff."""
    org = ctx.args.get("org", "") or "NobleFactor"
    asset = ctx.args.get("asset", "") or default_asset()
    check = preview(ctx)  # --check: the workaround for devlore-cli#1170
    check_access("star github model pull", org = org, scopes = ["read:project"])
    path = asset if check else refuse_unless_on_a_branch(asset)

    old_text = read_text(path)
    c = compare(org, old_text)
    if c["conflicts"]:
        fail("nothing written; fix these in GitHub's settings and pull again:\n  " + "\n  ".join(c["conflicts"]))
    new_text = c["new_text"]
    recorded = c["recorded"]
    read_at = c["read_at"]
    report = ["[star] " + org + " into " + path + (" (--check: nothing written)" if check else "")]
    report.extend(["[star] " + line for line in c["reads"]])
    report.extend(["[star] " + n for n in c["notes"]])

    if without_stamp(new_text) == without_stamp(old_text):
        write_cache(org, recorded, c["types_etag"], c["hub_repo"], c["labels_etag"], True, read_at)
        report.append("[star] model.yaml unchanged")
        return "\n".join(report)

    diff = unified_diff(old_text, new_text, "model.yaml (pulled " + recorded_at(old_text) + ")", "GitHub (" + org + ", " + read_at + ")")
    if check:
        report.append("[star] model.yaml would be rewritten; --check wrote nothing")
    else:
        write_text(path, new_text)
        write_cache(org, recorded_digest(new_text), c["types_etag"], c["hub_repo"], c["labels_etag"], True, read_at)
        report.append("[star] model.yaml rewritten")
    return "\n".join(report) + "\n" + diff
