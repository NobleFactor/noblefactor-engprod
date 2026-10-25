# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star gh model pull: the organization's record into model.yaml, read conditionally, with the diff; --check previews.

--check is a workaround for NobleFactor/devlore-cli#1170 (https://github.com/NobleFactor/devlore-cli/issues/1170):
star's --dry-run skips the reads a preview needs, so this command refuses it. See model.star § the preview.
"""

# gh-model-pull.star

load(
    "commands/model.star",
    "HUB",
    "MODEL_VERSION",
    "conditional_get",
    "default_asset",
    "digest_of",
    "hub_labels_from",
    "labels_of",
    "merge_labels",
    "merge_types",
    "note_project_renames",
    "now",
    "preview",
    "read_cache",
    "read_projects",
    "read_text",
    "recorded_at",
    "recorded_digest",
    "refuse_unless_on_a_branch",
    "render",
    "sign",
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
    path = asset if check else refuse_unless_on_a_branch(asset)

    old_text = read_text(path)
    old = yaml.decode(data = old_text)
    if type(old) != "dict" or old.get("version") != MODEL_VERSION:
        fail(path + ": not a version " + str(MODEL_VERSION) + " asset")
    pulled = old.get("pulled") or {}
    if pulled.get("org", org) != org:
        fail(path + " holds " + pulled["org"] + "'s model; this pull reads " + org)

    recorded = recorded_digest(old_text)
    verified = recorded == digest_of(old_text)
    cache = read_cache(org)
    use_cache = verified and cache.get("asset") == recorded
    hub_repo = org + "/" + HUB
    tiers = labels_of(old)
    read_at = now()

    report = ["[star] " + org + " into " + path + (" (--check: nothing written)" if check else "")]
    if not verified:
        report.append("[star] the asset's digest does not verify: edited since its pull; every record is read in full")

    # The organization's issue types, by ETag; a 304 means the asset's types are GitHub's.
    etag = (cache.get("issue-types") or {}).get("etag", "") if use_cache else ""
    got = conditional_get("orgs/" + org + "/issue-types", etag)
    github_types = (old.get("types") or []) if got["status"] == 304 else got["body"]
    types_etag = got["etag"]
    report.append("[star] issue-types  " + ("unchanged (304)" if got["status"] == 304 else "read (200)"))

    # The hub's labels, by ETag.
    etag = ((cache.get("labels") or {}).get(hub_repo) or {}).get("etag", "") if use_cache else ""
    got = conditional_get("repos/" + hub_repo + "/labels?per_page=100", etag)
    hub = hub_labels_from(tiers, hub_repo) if got["status"] == 304 else got["body"]
    labels_etag = got["etag"]
    report.append("[star] labels       " + ("unchanged (304)" if got["status"] == 304 else "read (200)") + ", " + hub_repo)

    # The projects: GraphQL takes no ETag, so this read is always made.
    projects = read_projects(org)
    old_projects = old.get("projects") or []
    if projects == None:
        projects = old_projects
        report.append("[star] projects     not read: the token lacks read:project; the asset's are kept")
    else:
        report.append("[star] projects     read, " + str(len(projects)))

    notes = []
    conflicts = []
    types = merge_types(old.get("types") or [], github_types, notes, conflicts)
    if conflicts:
        fail("nothing written; fix these in GitHub's settings and pull again:\n  " + "\n  ".join(conflicts))
    labels = merge_labels(tiers, hub_repo, hub, notes)
    note_project_renames(old_projects, projects, notes)

    new_text = sign(render({"pulled": {"at": read_at, "org": org}, "types": types, "labels": labels, "projects": projects}))
    report.extend(["[star] " + n for n in notes])

    if without_stamp(new_text) == without_stamp(old_text):
        write_cache(org, recorded, types_etag, hub_repo, labels_etag, True, read_at)
        report.append("[star] model.yaml unchanged")
        return "\n".join(report)

    diff = unified_diff(old_text, new_text, "model.yaml (pulled " + recorded_at(old_text) + ")", "GitHub (" + org + ", " + read_at + ")")
    if check:
        report.append("[star] model.yaml would be rewritten; --check wrote nothing")
    else:
        write_text(path, new_text)
        write_cache(org, recorded_digest(new_text), types_etag, hub_repo, labels_etag, True, read_at)
        report.append("[star] model.yaml rewritten")
    return "\n".join(report) + "\n" + diff
