# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The model asset's sync: read GitHub's record conditionally, merge it into model.yaml, render, sign, and cache.

docs/architecture/issue-data-model/6-the-asset-and-its-sync.md. Loaded by gh-model-pull.star and gh-model-digest.star,
never by scheme.star, and it never loads scheme.star: scheme.star fails when the asset's digest does not verify, and
these two commands are how a damaged asset is repaired (noblefactor-engprod#377).
"""

# model.star

EXTENSION = "com.noblefactor.ops.GitHub"
MODEL_VERSION = 1

# The hub repository, whose labels are the organization's record of them.
HUB = "noblefactor-engprod"

DIGEST_PREFIX = "  digest: "
AT_PREFIX = "  at: "

# The project field types the asset records; GitHub's own (title, assignees, labels, linked pull requests, milestone,
# repository, reviewers, parent issue, sub-issue progress, tracks) are every project's and say nothing of the model.
FIELD_TYPES = {"SINGLE_SELECT": "single-select", "TEXT": "text", "NUMBER": "number", "DATE": "date", "ITERATION": "iteration"}

HEADER = """# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 Noble Factor. All rights reserved.

# The issue data model as GitHub holds it: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md. Written by
# star github model pull; edit it by hand only deliberately, then run star github model digest. The digest is a SHA-256 over this
# file with its own line excluded. A type is keyed by its id and takes its level from its description's "Level N:".
# Within a level the types' order is the render order. Labels are in three tiers: the organization's, which every
# participating repository carries; each team's; each repository's own.

"""

# ── the preview: a workaround ───────────────────────────────────────────────

# WORKAROUND for NobleFactor/devlore-cli#1170 (https://github.com/NobleFactor/devlore-cli/issues/1170): star's global
# --dry-run skips every shell.exec, reads included, so a command that must read GitHub and the asset to say what it
# would change sees nothing. Until star runs the provider methods that declare themselves non-mutating, these commands
# preview with their own --check, which reads and writes nothing, and refuse --dry-run. When #1170 lands, --check
# retires and --dry-run takes its meaning.
DRY_RUN_REFUSAL = ("star's --dry-run skips every read, so this command cannot preview under it " +
                   "(NobleFactor/devlore-cli#1170); use --check, which reads and writes nothing")

def preview(ctx):
    """Whether this run previews: --check, the workaround for devlore-cli#1170; fails under the global --dry-run."""
    if ctx.dry_run:
        fail(DRY_RUN_REFUSAL)
    return bool(ctx.args.get("check", False))

# ── the shell ───────────────────────────────────────────────────────────────

def sh(command):
    """The standard output of a shell command, which must exit 0: shell.exec raises otherwise (devlore-cli#824)."""
    return shell.exec(command = command).stdout

def quote(s):
    """s as one single-quoted shell word."""
    return "'" + s.replace("'", "'\\''") + "'"

def now():
    """The time in UTC, to the second, as GitHub writes it."""
    return sh("date -u +%Y-%m-%dT%H:%M:%SZ").strip()

def default_asset():
    """The deployed asset: ${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/<extension>/model.yaml."""
    return sh('printf %s "${XDG_DATA_HOME:-$HOME/.local/share}/devlore/star/extensions/' + EXTENSION + '/model.yaml"')

def cache_path(org):
    """The organization's cache: ${XDG_CACHE_HOME:-$HOME/.cache}/devlore/star/gh/model/<org>.yaml."""
    return sh('printf %s "${XDG_CACHE_HOME:-$HOME/.cache}/devlore/star/gh/model/' + org + '.yaml"')

def exists(path):
    """Whether a file is there."""
    return sh("test -f " + quote(path) + " && echo yes || echo no").strip() == "yes"

def read_text(path):
    """A file's text."""
    return sh("cat " + quote(path))

def write_text(path, text):
    """Write text to a file, making its directory."""
    sh("mkdir -p \"$(dirname " + quote(path) + ")\" && printf '%s' " + quote(text) + " > " + quote(path))

def unified_diff(old, new, old_label, new_label):
    """diff -u of two texts, empty when they are the same."""
    return sh("d=$(mktemp -d) && printf '%s' " + quote(old) + " > \"$d/a\" && printf '%s' " + quote(new) + " > \"$d/b\" && " +
              "(diff -u --label " + quote(old_label) + " --label " + quote(new_label) + " \"$d/a\" \"$d/b\" || true); rm -rf \"$d\"")

# ── the digest ──────────────────────────────────────────────────────────────

def digest_of(text):
    """The SHA-256 over text with its digest line excluded, the rule scheme.star checks on load."""
    return "sha256:" + sh("printf '%s' " + quote(text) + " | sed '/^" + DIGEST_PREFIX + "/d' | (sha256sum 2>/dev/null || shasum -a 256) | cut -d' ' -f1").strip()

def recorded_digest(text):
    """The digest line's value, or empty."""
    for line in text.split("\n"):
        if line.startswith(DIGEST_PREFIX):
            return line[len(DIGEST_PREFIX):].strip()
    return ""

def recorded_at(text):
    """The at line's value as written, or empty: read from the text, since a YAML decoder makes it a time."""
    for line in text.split("\n"):
        if line.startswith(AT_PREFIX):
            return line[len(AT_PREFIX):].strip()
    return ""

def sign(text):
    """text with its digest line rewritten to its own digest."""
    d = digest_of(text)
    return "\n".join([DIGEST_PREFIX + d if line.startswith(DIGEST_PREFIX) else line for line in text.split("\n")])

def without_stamp(text):
    """text without its at and digest lines: what a pull compares, so that only a change in the record rewrites the asset."""
    return "\n".join([line for line in text.split("\n") if not line.startswith(DIGEST_PREFIX) and not line.startswith(AT_PREFIX)])

# ── reading GitHub ──────────────────────────────────────────────────────────

def conditional_get(path, etag):
    """GET a REST path, sending etag as If-None-Match when there is one: {"status", "etag", "body"}; body is None on 304."""
    header = ("-H " + quote("If-None-Match: " + etag) + " ") if etag else ""

    # gh exits 1 on a 304, and prints its headers on standard output with -i either way.
    out = sh("gh api -i " + header + quote(path) + " 2>/dev/null; true").replace("\r", "")
    cut = out.find("\n\n")
    head = out[:cut] if cut >= 0 else out
    body = out[cut + 2:] if cut >= 0 else ""
    lines = head.split("\n")
    parts = lines[0].split(" ")
    if len(parts) < 2 or not parts[1].isdigit():
        fail("gh api " + path + ": no HTTP status in its answer: " + lines[0])
    status = int(parts[1])
    new_etag = etag
    for line in lines[1:]:
        if line.lower().startswith("etag:"):
            new_etag = line[len("etag:"):].strip()
    if status == 304:
        return {"status": 304, "etag": etag, "body": None}
    if status != 200:
        fail("gh api " + path + ": HTTP " + str(status) + ": " + body.strip())
    return {"status": 200, "etag": new_etag, "body": json.decode(data = body)}

def read_projects(org):
    """The organization's projects with their fields and options, or None when the token cannot read projects."""
    query = ("{ organization(login: \"" + org + "\") { projectsV2(first: 50) { nodes { id number title template closed " +
             "fields(first: 50) { nodes { ... on ProjectV2FieldCommon { id name dataType } " +
             "... on ProjectV2SingleSelectField { options { id name } } } } } } } }")
    out = sh("gh api graphql -f query=" + quote(query) + " 2>/dev/null; true")
    if not out.strip().startswith("{"):
        return None
    data = json.decode(data = out)
    if data.get("errors") or not data.get("data") or not data["data"].get("organization"):
        return None
    projects = []
    for node in data["data"]["organization"]["projectsV2"]["nodes"]:
        if node.get("closed"):
            continue
        fields = []
        for f in node["fields"]["nodes"]:
            kind = FIELD_TYPES.get(f.get("dataType", ""))
            if kind == None:
                continue
            field = {"name": f["name"], "id": f["id"], "type": kind}
            if kind == "single-select":
                field["options"] = [{"name": o["name"], "id": o["id"]} for o in f.get("options", [])]
            fields.append(field)
        projects.append({"name": node["title"], "id": node["id"], "number": int(node["number"]), "template": bool(node["template"]), "fields": fields})
    return sorted(projects, key = lambda p: p["number"])

def level_of(description):
    """The N of a description that begins "Level N:", or None."""
    d = (description or "").strip()
    if not d.startswith("Level "):
        return None
    rest = d[len("Level "):]
    colon = rest.find(":")
    if colon <= 0 or not rest[:colon].isdigit():
        return None
    return int(rest[:colon])

# ── merging ─────────────────────────────────────────────────────────────────

def labels_of(model):
    """The asset's labels as three tiers, whatever shape it holds them in; a flat list, the hand pull's, is the hub's own."""
    labels = model.get("labels")
    if labels == None:
        return {"organization": [], "teams": {}, "repositories": {}}
    if type(labels) == "list":
        return {"organization": [], "teams": {}, "repositories": {model["pulled"]["org"] + "/" + HUB: labels}}
    return {
        "organization": labels.get("organization") or [],
        "teams": labels.get("teams") or {},
        "repositories": labels.get("repositories") or {},
    }

def merge_types(old, github, notes, conflicts):
    """The asset's types brought to GitHub's, matched by id: renames kept as renames, levels from the descriptions."""
    by_id = {int(t["id"]): t for t in old}
    seen = {}
    merged = {}
    for g in github:
        if not g.get("is_enabled", True):
            continue
        tid = int(g["id"])
        seen[tid] = True
        level = level_of(g.get("description"))
        o = by_id.get(tid)
        if level == None:
            conflicts.append("type " + g["name"] + " (" + str(tid) + "): its description does not begin \"Level N:\": " + str(g.get("description")))
            continue
        if o != None and int(o["level"]) != level:
            conflicts.append("type " + g["name"] + " (" + str(tid) + "): its description says level " + str(level) + "; the asset says " + str(o["level"]))
            continue
        t = {"name": g["name"], "id": tid, "level": level, "color": g.get("color") or "", "description": g.get("description") or ""}
        if o != None and o.get("unplanned"):
            t["unplanned"] = True
        if o == None:
            notes.append("type " + g["name"] + " added, level " + str(level))
        elif o["name"] != g["name"]:
            notes.append("type renamed " + o["name"] + " to " + g["name"] + ", id " + str(tid) + ", level " + str(level) + " kept")
        merged[tid] = t
    out = [merged[int(t["id"])] for t in old if int(t["id"]) in merged]
    out.extend([merged[int(g["id"])] for g in github if int(g["id"]) in merged and int(g["id"]) not in by_id])
    for t in old:
        if int(t["id"]) not in seen:
            notes.append("type " + t["name"] + " removed, id " + str(t["id"]))
    return out

def label_entry(g):
    """A GitHub label in the asset's three fields."""
    return {"name": g["name"], "color": g.get("color") or "", "description": g.get("description") or ""}

def merge_labels(old, hub_repo, hub, notes):
    """The tiers with the hub's labels: a name in the organization tier updates there, any other is the hub's own."""
    org_names = {lab["name"]: True for lab in old["organization"]}
    by_name = {g["name"]: label_entry(g) for g in hub}
    organization = []
    for lab in old["organization"]:
        if lab["name"] in by_name:
            organization.append(by_name[lab["name"]])
        else:
            organization.append(lab)
            notes.append("label " + lab["name"] + ": in the organization tier, not in " + hub_repo + "; kept")
    own = sorted([by_name[n] for n in by_name if n not in org_names], key = lambda lab: lab["name"].lower())
    repositories = dict(old["repositories"])
    before = {lab["name"]: lab for lab in repositories.get(hub_repo, [])}
    for lab in own:
        if lab["name"] not in before:
            notes.append("label " + lab["name"] + " added to " + hub_repo)
    for n in before:
        if n not in by_name and n not in org_names:
            notes.append("label " + n + " removed from " + hub_repo)
    repositories[hub_repo] = own
    return {"organization": organization, "teams": old["teams"], "repositories": repositories}

def hub_labels_from(tiers, hub_repo):
    """The hub's labels as the asset holds them: what a 304 says GitHub still has."""
    return list(tiers["organization"]) + list(tiers["repositories"].get(hub_repo, []))

def note_project_renames(old, new, notes):
    """Name every project, field and option whose id stayed and whose name changed, and every one added or removed."""
    old_by = {p["id"]: p for p in old}
    new_by = {p["id"]: p for p in new}
    for p in new:
        o = old_by.get(p["id"])
        if o == None:
            notes.append("project " + p["name"] + " added")
            continue
        if o["name"] != p["name"]:
            notes.append("project renamed " + o["name"] + " to " + p["name"] + ", id " + p["id"])
        of = {f["id"]: f for f in o.get("fields", [])}
        for f in p["fields"]:
            g = of.get(f["id"])
            if g == None:
                notes.append("field " + f["name"] + " added to " + p["name"])
                continue
            if g["name"] != f["name"]:
                notes.append("field renamed " + g["name"] + " to " + f["name"] + " in " + p["name"] + ", id " + f["id"])
            oo = {x["id"]: x for x in g.get("options", [])}
            for x in f.get("options", []):
                y = oo.get(x["id"])
                if y == None:
                    notes.append("option " + x["name"] + " added to " + f["name"] + " in " + p["name"])
                elif y["name"] != x["name"]:
                    notes.append("option renamed " + y["name"] + " to " + x["name"] + " in " + f["name"] + ", " + p["name"] + ", id " + x["id"])
            nn = {x["id"]: True for x in f.get("options", [])}
            for x in g.get("options", []):
                if x["id"] not in nn:
                    notes.append("option " + x["name"] + " removed from " + f["name"] + " in " + p["name"])
        nf = {f["id"]: True for f in p["fields"]}
        for g in o.get("fields", []):
            if g["id"] not in nf:
                notes.append("field " + g["name"] + " removed from " + p["name"])
    for p in old:
        if p["id"] not in new_by:
            notes.append("project " + p["name"] + " removed")

# ── rendering ───────────────────────────────────────────────────────────────

def s(v):
    """A YAML double-quoted scalar: JSON's string form is one."""
    return json.encode(v)

def render_labels(lines, indent, labels):
    """A list of labels in block form."""
    if len(labels) == 0:
        lines[-1] = lines[-1] + " []"
        return
    for lab in labels:
        lines.append(indent + "- name: " + s(lab["name"]))
        lines.append(indent + "  color: " + s(lab["color"]))
        lines.append(indent + "  description: " + s(lab["description"]))

def render(model):
    """The asset's text in its fixed layout, its digest line unsigned: an unchanged record renders byte for byte the same."""
    lines = []
    lines.append("version: " + str(MODEL_VERSION))
    lines.append("pulled:")
    lines.append(AT_PREFIX + model["pulled"]["at"])
    lines.append("  org: " + model["pulled"]["org"])
    lines.append(DIGEST_PREFIX + "sha256:")
    lines.append("types:")
    for t in model["types"]:
        lines.append("  - name: " + s(t["name"]))
        lines.append("    id: " + str(t["id"]))
        lines.append("    level: " + str(t["level"]))
        if t.get("unplanned"):
            lines.append("    unplanned: true")
        lines.append("    color: " + s(t["color"]))
        lines.append("    description: " + s(t["description"]))
    tiers = model["labels"]
    lines.append("labels:")
    lines.append("  organization:")
    render_labels(lines, "    ", tiers["organization"])
    lines.append("  teams:" + ("" if tiers["teams"] else " {}"))
    for team in sorted(tiers["teams"].keys()):
        lines.append("    " + s(team) + ":")
        render_labels(lines, "      ", tiers["teams"][team])
    lines.append("  repositories:" + ("" if tiers["repositories"] else " {}"))
    for repo in sorted(tiers["repositories"].keys()):
        lines.append("    " + s(repo) + ":")
        render_labels(lines, "      ", tiers["repositories"][repo])
    lines.append("projects:" + ("" if model["projects"] else " []"))
    for p in model["projects"]:
        lines.append("  - name: " + s(p["name"]))
        lines.append("    id: " + s(p["id"]))
        lines.append("    number: " + str(p["number"]))
        lines.append("    template: " + ("true" if p["template"] else "false"))
        lines.append("    fields:" + ("" if p["fields"] else " []"))
        for f in p["fields"]:
            lines.append("      - name: " + s(f["name"]))
            lines.append("        id: " + s(f["id"]))
            lines.append("        type: " + f["type"])
            if "options" in f:
                lines.append("        options:" + ("" if f["options"] else " []"))
                for o in f["options"]:
                    lines.append("          - { name: " + s(o["name"]) + ", id: " + s(o["id"]) + " }")
    return HEADER + "\n".join(lines) + "\n"

# ── the cache ───────────────────────────────────────────────────────────────

def read_cache(org):
    """The organization's cache, or an empty one: deleting it costs one full read and loses nothing."""
    path = cache_path(org)
    if not exists(path):
        return {}
    c = yaml.decode(data = read_text(path))
    return c if type(c) == "dict" else {}

def write_cache(org, asset_digest, types_etag, hub_repo, labels_etag, projects_read, read_at):
    """The cache, keyed to the digest of the asset that holds what the ETags vouch for."""
    lines = [
        "# star github model pull's cache: docs/architecture/issue-data-model/6-the-asset-and-its-sync.md § The cache.",
        "asset: " + s(asset_digest),
        "issue-types: { etag: " + s(types_etag) + ", read: " + s(read_at) + " }",
        "labels:",
        "  " + s(hub_repo) + ": { etag: " + s(labels_etag) + ", read: " + s(read_at) + " }",
    ]
    if projects_read:
        lines.append("projects: { read: " + s(read_at) + " }")
    write_text(cache_path(org), "\n".join(lines) + "\n")

# ── the guard ───────────────────────────────────────────────────────────────

def refuse_unless_on_a_branch(path, clean = True):
    """The asset's real path; fails unless it is in a git tree off its default branch and, when clean, has no uncommitted change."""
    real = sh("f=" + quote(path) + "; while [ -L \"$f\" ]; do t=$(readlink \"$f\"); case $t in /*) f=$t;; *) f=$(dirname \"$f\")/$t;; esac; done; " +
              "cd \"$(dirname \"$f\")\" && printf '%s/%s' \"$(pwd -P)\" \"$(basename \"$f\")\"")
    where = sh("dirname " + quote(real)).strip()
    branch = sh("git -C " + quote(where) + " rev-parse --abbrev-ref HEAD 2>/dev/null || true").strip()
    if branch == "":
        fail(real + " is not in a git tree; a pull writes only an asset a pull request can carry")
    default = sh("git -C " + quote(where) + " symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || true").strip()
    default = default[len("origin/"):] if default.startswith("origin/") else default
    if branch == default or branch == "HEAD":
        fail(real + " is on " + branch + "; pull into a worktree's asset with --asset, on a branch, or use --dry-run")
    if not clean:
        return real
    dirty = sh("git -C " + quote(where) + " status --porcelain -- " + quote(real) + " 2>/dev/null || true").strip()
    if dirty != "":
        fail(real + " has uncommitted changes; commit or revert them first: a pull's diff must be its own")
    return real

# ── reading GitHub's record against the asset ───────────────────────────────

def without_comments(text):
    """text without its comment lines and its at and digest lines: the records alone, what read_first compares."""
    return "\n".join([line for line in without_stamp(text).split("\n") if not line.startswith("#")])

def compare(org, old_text):
    """Read the organization's record conditionally and merge it into the asset's: what pull and read_first share.

    Args:
      org: the organization.
      old_text: the asset's text.

    Returns:
      A dict: reads, one line per record read; notes, what moved; conflicts, what a pull will not resolve; new_text, the
      asset as a pull would write it; recorded, the asset's digest; and the ETags and time a cache write needs.
    """
    old = yaml.decode(data = old_text)
    if type(old) != "dict" or old.get("version") != MODEL_VERSION:
        fail("the asset is not a version " + str(MODEL_VERSION) + " asset")
    pulled = old.get("pulled") or {}
    if pulled.get("org", org) != org:
        fail("the asset holds " + pulled["org"] + "'s model; this reads " + org)

    recorded = recorded_digest(old_text)
    verified = recorded == digest_of(old_text)
    cache = read_cache(org)
    use_cache = verified and cache.get("asset") == recorded
    hub_repo = org + "/" + HUB
    tiers = labels_of(old)
    reads = []
    if not verified:
        reads.append("the asset's digest does not verify: edited since its pull; every record is read in full")

    # The organization's issue types, by ETag; a 304 means the asset's types are GitHub's.
    etag = (cache.get("issue-types") or {}).get("etag", "") if use_cache else ""
    got = conditional_get("orgs/" + org + "/issue-types", etag)
    github_types = (old.get("types") or []) if got["status"] == 304 else got["body"]
    types_etag = got["etag"]
    reads.append("issue-types  " + ("unchanged (304)" if got["status"] == 304 else "read (200)"))

    # The hub's labels, by ETag.
    etag = ((cache.get("labels") or {}).get(hub_repo) or {}).get("etag", "") if use_cache else ""
    got = conditional_get("repos/" + hub_repo + "/labels?per_page=100", etag)
    hub = hub_labels_from(tiers, hub_repo) if got["status"] == 304 else got["body"]
    labels_etag = got["etag"]
    reads.append("labels       " + ("unchanged (304)" if got["status"] == 304 else "read (200)") + ", " + hub_repo)

    # The projects: GraphQL takes no ETag, so this read is always made.
    projects = read_projects(org)
    old_projects = old.get("projects") or []
    if projects == None:
        projects = old_projects
        reads.append("projects     not read: the token lacks read:project; the asset's are kept")
    else:
        reads.append("projects     read, " + str(len(projects)))

    notes = []
    conflicts = []
    types = merge_types(old.get("types") or [], github_types, notes, conflicts)
    labels = merge_labels(tiers, hub_repo, hub, notes)
    note_project_renames(old_projects, projects, notes)
    read_at = now()
    new_text = sign(render({"pulled": {"at": read_at, "org": org}, "types": types, "labels": labels, "projects": projects}))
    return {
        "reads": reads,
        "notes": notes,
        "conflicts": conflicts,
        "new_text": new_text,
        "recorded": recorded,
        "hub_repo": hub_repo,
        "types_etag": types_etag,
        "labels_etag": labels_etag,
        "read_at": read_at,
    }

def read_first(dry_run = False):
    """Read GitHub's record against the deployed asset before an operation: the line to show when the asset is behind, or "".

    Writes nothing but the cache, and the cache only when what was read is what the asset holds, so that a 304 never
    vouches for content the asset lacks (section 6, § Every operation reads first). Each read is a note, shown unless
    --silent; the returned line is the caller's to put where --silent cannot hide it.
    """
    if dry_run:
        return ""
    path = default_asset()
    old_text = read_text(path)
    pulled = (yaml.decode(data = old_text) or {}).get("pulled") or {}
    org = pulled.get("org", "NobleFactor")
    c = compare(org, old_text)
    for line in c["reads"]:
        note("model " + line)
    if not c["conflicts"] and without_comments(c["new_text"]) == without_comments(old_text):
        write_cache(org, c["recorded"], c["types_etag"], c["hub_repo"], c["labels_etag"], True, c["read_at"])
        return ""
    moved = c["notes"] + c["conflicts"]
    return ("The asset is behind GitHub: " + (moved[0] if len(moved) == 1 else str(len(moved)) + " changes, " + moved[0] + " among them") +
            ", since its pull at " + recorded_at(old_text) + ". Run star github model pull in a worktree.")
