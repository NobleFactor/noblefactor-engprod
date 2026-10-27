# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github model digest: re-sign a deliberately hand-edited model.yaml, leaving the edit in the diff; --check previews.

--check is a workaround for NobleFactor/devlore-cli#1170 (https://github.com/NobleFactor/devlore-cli/issues/1170):
star's --dry-run skips the reads a preview needs, so this command refuses it. See model.star § the preview.
"""

# gh-model-digest.star

load("commands/model.star", "default_asset", "digest_of", "preview", "read_text", "recorded_digest", "refuse_unless_on_a_branch", "sign", "write_text")

def run(_command, ctx):
    """Rewrite the asset's digest line to the digest of its content."""
    asset = ctx.args.get("asset", "") or default_asset()
    check = preview(ctx)  # --check: the workaround for devlore-cli#1170
    path = asset if check else refuse_unless_on_a_branch(asset, clean = False)
    text = read_text(path)
    old = recorded_digest(text)
    new = digest_of(text)
    if old == new:
        return "[star] " + path + ": the digest verifies, " + new
    if not check:
        write_text(path, sign(text))
    return "[star] " + path + ": " + old + " -> " + new + (" (--check, nothing written)" if check else "")
