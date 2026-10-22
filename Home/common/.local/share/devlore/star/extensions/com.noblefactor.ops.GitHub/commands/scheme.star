# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""The NobleFactor issue classification scheme, as Get-EpicReport's jq states it."""

# scheme.star
#
# Every definition here is a line-for-line port of a jq def in devlore-cli's scripts/Get-EpicReport,
# kept in the same order under the same names so the two can be read side by side until the script
# retires (devlore-cli#797). The scheme itself is docs/issue-standards.md.

KINDS = ["epic", "feature", "task", "bug", "chore"]

def short(repo):
    """The repository's name without its owner: noblefactor-ops for NobleFactor/noblefactor-ops."""
    return repo.split("/")[-1]

def key(it):
    """owner/repo#N -- the identity a **Feature:** marker names across repositories."""
    return it["repo"] + "#" + str(it["number"])

def names(it):
    return [label["name"] for label in it["labels"]]

def tagged(it, label):
    return label in names(it)

def kinds(it):
    return [n for n in names(it) if n in KINDS]

def epic_tags(it):
    return [n for n in names(it) if n.startswith("Epic:")]

def epic_tag(it):
    tags = epic_tags(it)
    return tags[0] if tags else ""

def mark(it):
    return "~~" if it["state"] == "CLOSED" else ""

def line(it):
    return mark(it) + it["title"] + mark(it) + " [" + it["ref"] + "](" + it["url"] + ")"

def is_bug(it):
    return tagged(it, "bug")

def _first_with_prefix(it, prefix):
    for n in names(it):
        if n.startswith(prefix):
            return n
    return ""

def severity(it):
    return _first_with_prefix(it, "Severity:")

def priority(it):
    return _first_with_prefix(it, "Priority:")

def severity_rank(it):
    s = severity(it)
    return {"Severity:Critical": 0, "Severity:High": 1, "Severity:Medium": 2, "Severity:Low": 3}.get(s, 4)

# A tier-three issue -- a lane -- is a task or a bug; they are peers under a feature or a chore
# (ruled 2026-10-21, noblefactor-ops#344). One with no parent falls through to "unfiled".
def is_child(it):
    return tagged(it, "task") or is_bug(it)

# A tier-two issue is a feature or a chore: the bodies of work an epic decomposes into, mutually
# exclusive, each with its own lanes. A schedule issue is a chore by kind and a view by role, with
# no lanes of its own, so it is not a parent; nor is a thread issue.
def is_parent(it):
    return (tagged(it, "feature") or tagged(it, "chore")) and not tagged(it, "epic") and not is_view_issue(it)

# A lane's parent, stated in its body by the parent's kind: **Feature:** #123, or **Chore:**
# owner/repo#123. The marker is the closing metadata line, so the LAST match of either wins: prose
# above it may mention another parent in the same form, and the script's narrower regex happened
# never to see those.
def parent_marker(it):
    """The last parent marker in the body as (key, kind named) -- (owner/repo#N, "feature" or "chore") -- or None. A bare #N is the issue's own repository."""
    ms = regex.find_all_submatch(pattern = "(Feature|Chore):\\*\\* (?:([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+))?#([0-9]+)", text = it.get("body", "") or "", count = -1)

    # find_all_submatch returns None on no match; an optional group that did not participate is "".
    if ms == None or len(ms) == 0:
        return None
    m = ms[-1]
    return ((m[2] if m[2] else it["repo"]) + "#" + m[3], m[1].lower())

def parent(it):
    """The key of the parent the body names -- owner/repo#N -- or None."""
    pm = parent_marker(it)
    return pm[0] if pm else None

def parents_of(tag, all):
    """The tier-two issues of the epic carrying tag: its features by number, then its chores by number."""
    mine = [i for i in all if is_parent(i) and epic_tag(i) == tag]
    return by_number([i for i in mine if tagged(i, "feature")]) + by_number([i for i in mine if tagged(i, "chore") and not tagged(i, "feature")])

# A bug awaiting triage has no feature yet, so it has no epic. That is the triage queue, not a fault.
def awaiting_triage(it):
    return is_bug(it) and len(epic_tags(it)) == 0

# A thread issue is a scenario, and a scenario has no owner: it carries no Epic: label and is placed
# by its own label family. The second exception (issue-standards.md, The two exceptions).
def is_thread_issue(it):
    return tagged(it, "feature") and it["title"].startswith("Thread:") and len([n for n in names(it) if n.startswith("Thread:")]) > 0

# A schedule issue is the declared order of execution -- a view of the work, not work -- and carries
# no Epic: label either. The three slices are peers (issue-standards.md, Three ways to slice the work).
def is_schedule_issue(it):
    return tagged(it, "chore") and it["title"].startswith("Schedule:")

def is_view_issue(it):
    """A thread or schedule issue: organizes work, is not work, carries no epic."""
    return is_thread_issue(it) or is_schedule_issue(it)

def faults(it, by_key = None):
    """The classification faults of an open issue: wrong count of kind labels, wrong count of epic labels, a parent marker on tier two, and, given the issues by key, a marker naming the wrong kind."""
    if awaiting_triage(it):
        return []
    k = kinds(it)
    e = epic_tags(it)
    out = []
    if len(k) == 0:
        out.append("no kind label (epic/feature/task/bug/chore)")
    if len(k) > 1:
        out.append("multiple kind labels: " + ", ".join(k))
    if len(e) == 0 and not is_view_issue(it):
        out.append("no Epic:<Name> label")
    if len(e) > 1:
        out.append("multiple epics: " + ", ".join(e))
    pm = parent_marker(it)
    if pm != None and is_parent(it):
        out.append("tier two names a parent: **" + pm[1].capitalize() + ":** " + pm[0])
    if pm != None and is_child(it) and by_key != None and pm[0] in by_key and kind_of(by_key[pm[0]]) != pm[1]:
        out.append("names " + pm[0] + " as a " + pm[1] + "; it is a " + kind_of(by_key[pm[0]]))
    return out

def kind_of(it):
    """The one kind an issue renders as, epic first; unclassified when it carries none."""
    if tagged(it, "epic"):
        return "epic"
    if tagged(it, "feature"):
        return "feature"
    if is_bug(it):
        return "bug"
    if tagged(it, "task"):
        return "task"
    if tagged(it, "chore"):
        return "chore"
    return "unclassified"

def cell(s):
    return s.replace("|", "\\|").replace("\n", " ")

def _strip(s, prefix):
    return s[len(prefix):] if s.startswith(prefix) else s

def comment(it, placement):
    """The Comment column: kind, placement, WIP, severity, priority, and any open fault."""
    parts = [kind_of(it), placement]
    if tagged(it, "WIP"):
        parts.append("WIP")
    sev = _strip(severity(it), "Severity:")
    if sev:
        parts.append("severity " + sev)
    pri = _strip(priority(it), "Priority:")
    if pri:
        parts.append("priority " + pri)
    if it["state"] == "OPEN":
        f = "; ".join(faults(it))
        if f:
            parts.append(f)
    return "; ".join([p for p in parts if p != ""])

def row(it, placement):
    return {
        "issue": it["number"],
        "repo": it["repo"],
        "ref": it["ref"],
        "url": it["url"],
        "title": cell(it["title"]),
        "kind": kind_of(it),
        "state": it["state"],
        "done": it["state"] == "CLOSED",
        "placement": placement,
        "severity": _strip(severity(it), "Severity:"),
        "priority": _strip(priority(it), "Priority:"),
        "wip": tagged(it, "WIP"),
        "faults": faults(it) if it["state"] == "OPEN" else [],
        "comment": comment(it, placement),
    }

def task_row(it):
    done = "✅" if it["state"] == "CLOSED" else ""
    kind = "bug" if is_bug(it) else "task"
    return "| " + done + " | [" + it["ref"] + "](" + it["url"] + ") | " + mark(it) + cell(it["title"]) + mark(it) + " | " + kind + " | " + _strip(severity(it), "Severity:") + " | " + _strip(priority(it), "Priority:") + " |"

def by_number(items):
    return sorted(items, key = lambda i: (i["number"], i["repo"]))

# The rows of one epic, in tree order: the epic, then each feature and its lanes, then each chore and
# its lanes, then the unfiled.
def epic_rows(e, all):
    """The rows of one epic in tree order: the epic, each feature and each chore with its lanes, then the unfiled."""
    tag = epic_tag(e)
    parents = parents_of(tag, all)
    tasks = [i for i in all if is_child(i) and epic_tag(i) == tag]
    parent_keys = [key(f) for f in parents]
    rows = [row(e, "")]
    for f in parents:
        rows.append(row(f, "" if len(children_of(f, tasks)) > 0 else "awaiting decomposition"))
        for t in children_of(f, tasks):
            r = row(t, kind_of(f) + " " + f["ref"])
            r["feature"] = f["number"]
            r["feature_repo"] = f["repo"]
            r["parent_kind"] = kind_of(f)
            rows.append(r)
    for t in by_number([t for t in tasks if parent(t) == None or parent(t) not in parent_keys]):
        rows.append(row(t, "unfiled, no parent" if parent(t) == None else "unfiled, names " + parent(t) + ", not a feature or chore of this epic"))
    if len(parents) == 0 and len(tasks) == 0:
        rows[0]["comment"] = rows[0]["comment"] + "; awaiting plan and design"
        rows[0]["placement"] = "awaiting plan and design"
    for r in rows:
        r["epic"] = e["number"]
        r["axis"] = axis(epic_name(e))
    return rows

def table_lines(rows):
    out = ["| ID | Issue | Title | Status | Comment |", "|---|---|---|---|---|"]
    for i, r in enumerate(rows):
        out.append("| " + str(i + 1) + " | [" + r["ref"] + "](" + r["url"] + ") | " + r["title"] + " | " + ("✅" if r["done"] else "") + " | " + r["comment"] + " |")
    return out

# ── fetching ────────────────────────────────────────────────────────────────

# owner/name at the end of a remote's URL, by HTTPS or by SSH, with or without .git.
_ORIGIN = "[:/]([^/:]+/[^/]+?)(?:\\.git)?\\s*$"

# writ's layers, in their order. Each registered one is an entry under writ's data directory naming a repository's
# working tree; reading them needs nothing from writ (noblefactor-ops#253).
_LAYERS = ["base", "team", "personal"]

def _origin_repo(directory):
    """owner/name from the origin remote of a working tree."""
    r = shell.exec(command = "git -C '" + directory + "' remote get-url origin")
    m = regex.find_submatch(pattern = _ORIGIN, text = r.stdout)
    if m == None or len(m) < 2:
        fail("cannot read owner/name from the origin of " + directory + ": " + r.stdout.strip())
    return m[1]

def _current_repo():
    """owner/name of the repository the command runs in, as gh resolves it."""
    r = shell.exec(command = "gh repo view --json nameWithOwner --jq .nameWithOwner")
    return r.stdout.strip()

def layer_repos():
    """owner/name of each registered writ layer's repository, base first, each once.

    A layer's entry is ${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers/<layer>, naming a git working tree. One
    that is absent, or names nothing git can read an origin from, is skipped, as writ reads an empty directory as no
    layer. The script never fails, since shell.exec raises on a non-zero exit (devlore-cli#824).
    """
    script = ("layers=\"${XDG_DATA_HOME:-$HOME/.local/share}/devlore/writ/layers\"; for layer in " + " ".join(_LAYERS) +
              "; do if [ -e \"$layers/$layer\" ]; then git -C \"$layers/$layer\" remote get-url origin 2>/dev/null; fi; done; true")
    repos = []
    for origin in shell.exec(command = script).stdout.split("\n"):
        m = regex.find_submatch(pattern = _ORIGIN, text = origin)
        if m != None and len(m) > 1 and m[1] not in repos:
            repos.append(m[1])
    return repos

def resolve_repos(repo_flag, directory):
    """The repositories to report on: --repo, else --directory's origin, else writ's layers', else the current one."""
    if repo_flag:
        return [r.strip() for r in repo_flag.split(",") if r.strip()]
    if directory:
        return [_origin_repo(directory)]
    repos = layer_repos()
    return repos if repos else [_current_repo()]

def lane_repos(scheds):
    """Every repository a lane of the schedules names, owner/name, in lane order, each once."""
    repos = []
    for sc in scheds:
        for lane in lane_table(sc):
            if "key" in lane["spec"]:
                repo = lane["spec"]["key"].split("#")[0]
                if repo not in repos:
                    repos.append(repo)
    return repos

def fetch_issues(state, limit, repos, multi = None):
    """Every issue of each repository via gh issue list -- authoritative and immediate, unlike search -- tagged with its repository and display ref.

    Args:
      state: open, closed, or all.
      limit: the most issues to fetch from each repository.
      repos: the repositories, owner/name.
      multi: whether a ref names its repository; by default, when more than one repository is read. A report that reads
        more repositories after its first fetch passes True, so every ref is written one way.
    """

    # shell.exec raises on a non-zero exit (devlore-cli#824), so a failed gh never reaches this code;
    # there is no exit_code to check.
    if multi == None:
        multi = len(repos) > 1
    issues = []
    for repo in repos:
        r = shell.exec(command = "gh issue list -R " + repo + " --state " + state + " --limit " + str(limit) + " --json number,title,state,labels,body,url")
        batch = json.decode(data = r.stdout)
        for it in batch:
            # encoding/json decodes numbers as floats; the scheme compares and prints issue numbers as ints.
            it["number"] = int(it["number"])
            it["repo"] = repo
            it["ref"] = (short(repo) + "#" if multi else "#") + str(it["number"])
        issues.extend(batch)
    return issues

def label_space(repos):
    """Every Epic: and Thread: label per repository with its open count -- one GraphQL request, filtered here and never with labels(query:), which is a relevance search."""
    parts = []
    for i, repo in enumerate(repos):
        owner, name = repo.split("/")
        parts.append("r" + str(i) + ": repository(owner: \"" + owner + "\", name: \"" + name + "\") { nameWithOwner labels(first: 100) { nodes { name issues(states: OPEN) { totalCount } } } }")
    r = shell.exec(command = "gh api graphql -f query='{ " + " ".join(parts) + " }'")
    data = json.decode(data = r.stdout)["data"]
    out = {}
    for k in data:
        node = data[k]
        out[node["nameWithOwner"]] = {label["name"]: int(label["issues"]["totalCount"]) for label in node["labels"]["nodes"] if label["name"].startswith("Epic:") or label["name"].startswith("Thread:")}
    return out

def exempt_numbers():
    # gh.exempt in star/config.yaml. Flat, not gh.issues.exempt: the extension spec accepts a nested:
    # block but the runtime does not build it into the config struct (noblefactor-ops#140, Phase 1).
    cfg = config.get
    if not hasattr(cfg, "gh") or not hasattr(getattr(cfg, "gh"), "exempt"):
        return []
    return [int(n) for n in getattr(getattr(cfg, "gh"), "exempt")]

# ── the audit ───────────────────────────────────────────────────────────────

def audit(all, exempt):
    """The classification audit: the faulty, the exempted, the open bugs, and those awaiting triage."""
    open_ = [i for i in all if i["state"] == "OPEN"]
    by_key = {key(i): i for i in all}
    bad = by_number([i for i in open_ if i["number"] not in exempt and len(faults(i, by_key)) > 0])
    exempted = by_number([i for i in open_ if i["number"] in exempt])
    bugs = [i for i in open_ if is_bug(i)]
    untriaged = by_number([i for i in bugs if awaiting_triage(i)])
    return {"bad": bad, "exempted": exempted, "bugs": bugs, "untriaged": untriaged, "by_key": by_key}

def audit_lines(a):
    """The audit section as the script prints it."""
    out = []
    if len(a["bad"]) == 0:
        out.append("All open issues carry exactly one kind label and exactly one epic.")
    else:
        out.append("**" + str(len(a["bad"])) + " issue(s) are not properly classified.** An issue the scheme cannot place is invisible to the tree below.\n")
        for i in a["bad"]:
            out.append("- " + line(i) + " — " + "; ".join(faults(i, a["by_key"])))
    if len(a["exempted"]) > 0:
        out.append("\nDeliberately outside the scheme, by decision:\n")
        for i in a["exempted"]:
            out.append("- " + line(i))
    if len(a["untriaged"]) > 0:
        out.append("\n**" + str(len(a["untriaged"])) + " bug(s) awaiting triage** — no parent, so no epic. Not a fault; this is the queue.\n")
        for i in a["untriaged"]:
            out.append("- " + line(i))
    return out

# ── threads ─────────────────────────────────────────────────────────────────
#
# A thread is a narrative -- a use case or scenario -- carrying cross-cutting feature development
# (docs/issue-standards.md, Threads). Membership is the Thread:<Name> label; order is the beat table
# in the thread issue's body; the two must agree, and disagreement either way is a fault.

def thread_names(space):
    """Every thread across the repositories read, from the label space, sorted."""
    names = {}
    for repo in space:
        for label in space[repo]:
            if label.startswith("Thread:"):
                names[label[len("Thread:"):]] = True
    return sorted(names.keys())

def thread_issue(all, name):
    """The thread's own issue: kind feature, carrying its label, titled 'Thread:'. None when absent."""
    candidates = by_number([i for i in all if tagged(i, "feature") and tagged(i, "Thread:" + name) and i["title"].startswith("Thread:")])
    return candidates[0] if candidates else None

def beat_table(thread):
    """(beat, owner/repo#N) in document order, from rows of the thread issue's body whose first cell is a beat number."""
    beats = []
    for raw in (thread.get("body", "") or "").split("\n"):
        cells = [c.strip() for c in raw.strip().strip("|").split("|")]
        if len(cells) < 2 or not regex.match(pattern = "^[0-9]+$", text = cells[0]):
            continue
        refs = regex.find_all_submatch(pattern = "(?:([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+))?#([0-9]+)", text = raw, count = -1)
        if refs == None or len(refs) == 0:
            continue
        m = refs[0]
        beats.append((int(cells[0]), (m[1] if m[1] else thread["repo"]) + "#" + m[2]))
    return beats

def thread_rows(name, all):
    """The thread issue, then its members in beat order, then labeled members the table omits; with the agreement faults."""
    thread = thread_issue(all, name)
    members = [i for i in all if tagged(i, "Thread:" + name) and (thread == None or key(i) != key(thread))]
    by_key = {key(i): i for i in members}
    beats = beat_table(thread) if thread else []
    listed = {k: b for b, k in beats}

    rows = []
    faults = []
    if thread == None:
        faults.append("no thread issue: no feature titled 'Thread:' carries Thread:" + name)
    else:
        r = row(thread, "")
        r["thread"] = name
        r["beat"] = ""
        rows.append(r)

    for b, k in beats:
        if k in by_key:
            r = row(by_key[k], "beat " + str(b))
            r["thread"] = name
            r["beat"] = b
            r["epic_name"] = _strip(epic_tag(by_key[k]), "Epic:")
            rows.append(r)
        else:
            faults.append("beat " + str(b) + " names " + k + ", which does not carry Thread:" + name)

    for i in by_number([i for i in members if key(i) not in listed]):
        r = row(i, "labeled, not in the beat table")
        r["thread"] = name
        r["beat"] = ""
        r["epic_name"] = _strip(epic_tag(i), "Epic:")
        rows.append(r)
        faults.append(i["ref"] + " carries Thread:" + name + " and is not in the beat table")

    return {"name": name, "thread": thread, "rows": rows, "faults": faults}

def thread_table_lines(rows):
    """The thread's status table: beat, issue, title, status, owning epic, comment."""
    out = ["| Beat | Issue | Title | Status | Epic | Comment |", "|---|---|---|---|---|---|"]
    for r in rows:
        out.append("| " + str(r.get("beat", "")) + " | [" + r["ref"] + "](" + r["url"] + ") | " + r["title"] + " | " + ("✅" if r["done"] else "") + " | " + r.get("epic_name", "") + " | " + r["comment"] + " |")
    return out

# ── the scheme's semantics: axes, and what an empty level means ────────────
#
# docs/issue-standards.md: the Ops: segment marks the tooling axis; an epic with no features and no
# chores is awaiting plan and design; a feature or a chore with no lanes is awaiting decomposition; a
# lane with no parent is unfiled. The report says which, rather than rendering blank.

def axis(name):
    """tooling for a name carrying the Ops: segment, else product."""
    return "tooling" if name.startswith("Ops:") else "product"

def by_axis(items, name_of):
    """Product first, then tooling; stable within each."""
    return [i for i in items if axis(name_of(i)) == "product"] + [i for i in items if axis(name_of(i)) == "tooling"]

def epic_name(it):
    """The Name in an issue's Epic:<Name> label, or empty."""
    return _strip(epic_tag(it), "Epic:")

def children_of(f, tasks):
    """The lanes that name the feature or chore f as their parent."""
    return by_number([t for t in tasks if parent(t) == key(f)])

def feature_state(f, kids):
    """The named condition of a feature or a chore: closed; awaiting decomposition; children done; or n of m done."""
    if f["state"] == "CLOSED":
        return "closed"
    if f["title"].startswith("Thread:"):
        return "a thread; its members report under --by thread"
    if len(kids) == 0:
        return "awaiting decomposition"
    done = len([k for k in kids if k["state"] == "CLOSED"])
    if done == len(kids):
        return "children done"
    return str(done) + " of " + str(len(kids)) + " done"

def feature_rows(epics, all):
    """One row per feature or chore across the given epics, features first, with its counts and state; an epic with none contributes a row saying so."""
    rows = []
    for e in epics:
        tag = epic_tag(e)
        features = parents_of(tag, all)
        tasks = [i for i in all if is_child(i) and epic_tag(i) == tag]
        if len(features) == 0:
            rows.append({
                "epic": e["number"],
                "epic_ref": e["ref"],
                "epic_name": epic_name(e),
                "axis": axis(epic_name(e)),
                "feature": None,
                "ref": "",
                "url": e["url"],
                "title": "",
                "done": 0,
                "open": 0,
                "state": "awaiting plan and design" if len(tasks) == 0 else "awaiting plan and design; " + str(len(tasks)) + " unfiled",
            })
            continue
        for f in features:
            kids = children_of(f, tasks)
            done = len([k for k in kids if k["state"] == "CLOSED"])
            rows.append({
                "epic": e["number"],
                "epic_ref": e["ref"],
                "epic_name": epic_name(e),
                "axis": axis(epic_name(e)),
                "feature": f["number"],
                "kind": kind_of(f),
                "repo": f["repo"],
                "ref": f["ref"],
                "url": f["url"],
                "title": cell(f["title"]),
                "closed": f["state"] == "CLOSED",
                "done": done,
                "open": len(kids) - done,
                "state": feature_state(f, kids),
            })
    return rows

def feature_table_lines(rows):
    """The tier-two rollup: feature or chore, its kind, done, open, state."""
    out = ["| Feature or chore | Kind | Done | Open | State |", "|---|---|---|---|---|"]
    for r in rows:
        if r["feature"] == None:
            out.append("| _no features or chores_ |  |  |  | " + r["state"] + " |")
        else:
            out.append("| [" + r["ref"] + "](" + r["url"] + ") " + ("~~" + r["title"] + "~~" if r["closed"] else r["title"]) + " | " + r["kind"] + " | " + str(r["done"]) + " | " + str(r["open"]) + " | " + r["state"] + " |")
    return out

# ── the label set every participating repository carries ───────────────────
#
# docs/issue-standards.md, The labels a repository provides: the five kinds, Epic:Ops:Process, and
# every Thread:<Name> whose members reach it. A thread crosses repositories by design, so a thread
# label present in one configured repository is expected in all of them -- otherwise nothing there
# can join. Epic:<Name> labels are per-repository by definition and are not synced.

REQUIRED_EVERYWHERE = ["epic", "feature", "task", "bug", "chore", "Epic:Ops:Process"]

def label_inventory(repos):
    """Every label per repository with its color and description -- one GraphQL request; first 100 per repository."""
    parts = []
    for i, repo in enumerate(repos):
        owner, name = repo.split("/")
        parts.append("r" + str(i) + ": repository(owner: \"" + owner + "\", name: \"" + name + "\") { nameWithOwner labels(first: 100) { totalCount nodes { name color description } } }")
    r = shell.exec(command = "gh api graphql -f query='{ " + " ".join(parts) + " }'")
    data = json.decode(data = r.stdout)["data"]
    out = {}
    for k in data:
        node = data[k]
        if int(node["labels"]["totalCount"]) > 100:
            warn(node["nameWithOwner"] + " has more than 100 labels; only the first 100 were read")
        out[node["nameWithOwner"]] = {label["name"]: {"color": label["color"], "description": label["description"] or ""} for label in node["labels"]["nodes"]}
    return out

def canonical_labels(inv, repos):
    """The expected set and its canonical color and description: the kinds, Epic:Ops:Process, and every thread label, each as first seen in configuration order."""
    expected = {}
    names = list(REQUIRED_EVERYWHERE)
    threads = {}
    for repo in repos:
        for name in inv.get(repo, {}):
            if name.startswith("Thread:"):
                threads[name] = True
    names.extend(sorted(threads.keys()))
    for name in names:
        for repo in repos:
            if name in inv.get(repo, {}):
                expected[name] = inv[repo][name]
                break
        if name not in expected:
            expected[name] = None
    return expected

def label_faults(inv, repos):
    """Per repository: missing labels, and labels whose color or description differs from the canonical."""
    expected = canonical_labels(inv, repos)
    rows = []
    for repo in repos:
        have = inv.get(repo, {})
        for name in sorted(expected.keys()):
            want = expected[name]
            if want == None:
                rows.append({"repo": repo, "label": name, "status": "absent everywhere", "color": "", "description": ""})
            elif name not in have:
                rows.append({"repo": repo, "label": name, "status": "missing", "color": want["color"], "description": want["description"]})
            elif have[name]["color"] != want["color"] or have[name]["description"] != want["description"]:
                rows.append({"repo": repo, "label": name, "status": "divergent", "color": want["color"], "description": want["description"], "actual_color": have[name]["color"], "actual_description": have[name]["description"]})
    return rows

def label_audit_lines(rows, repos):
    """The audit as a document: one section per repository, or one line when clean."""
    out = ["# Label audit\n", "Repositories: " + ", ".join(repos) + "."]
    if len(rows) == 0:
        out.append("\nEvery repository carries the five kinds, Epic:Ops:Process, and every thread label.")
        return out
    for repo in repos:
        mine = [r for r in rows if r["repo"] == repo]
        if len(mine) == 0:
            continue
        out.append("\n## " + repo + "\n")
        out.append("| Label | Status | Canonical |")
        out.append("|---|---|---|")
        for r in mine:
            canon = ("#" + r["color"] + " " + r["description"]) if r["color"] else ""
            out.append("| `" + r["label"] + "` | " + r["status"] + " | " + cell(canon) + " |")
    return out

def _sh_quote(s):
    """Single-quote a string for sh -c."""
    return "'" + s.replace("'", "'\\''") + "'"

def label_sync(rows, dry_run):
    """Create missing labels and align divergent ones, per the audit rows; never delete. Returns what was done, or would be."""
    done = []
    for r in rows:
        if r["status"] == "missing":
            cmd = "gh label create -R " + r["repo"] + " " + _sh_quote(r["label"]) + " --color " + r["color"] + " --description " + _sh_quote(r["description"])
            action = "create"
        elif r["status"] == "divergent":
            cmd = "gh label edit -R " + r["repo"] + " " + _sh_quote(r["label"]) + " --color " + r["color"] + " --description " + _sh_quote(r["description"])
            action = "align"
        else:
            done.append({"repo": r["repo"], "label": r["label"], "action": "skip", "reason": r["status"]})
            continue
        if dry_run:
            note("would " + action + " " + r["label"] + " in " + r["repo"])
            done.append({"repo": r["repo"], "label": r["label"], "action": action, "dry_run": True})
        else:
            shell.exec(command = cmd)
            note(action + "d " + r["label"] + " in " + r["repo"])
            done.append({"repo": r["repo"], "label": r["label"], "action": action, "dry_run": False})
    return done

# ── schedules ───────────────────────────────────────────────────────────────
#
# A schedule says what we are executing, in what order, and what is next (issue-standards.md, Three
# ways to slice the work). Lane, item, next and waits-on are declared in a Schedule: issue's table;
# progress is derived here from the feature rollup. A lane names an epic or a feature.

def schedule_issues(all):
    """Every schedule issue in the set: kind chore, title beginning 'Schedule:', by number."""
    return by_number([i for i in all if is_schedule_issue(i)])

def schedule_name(sched):
    """The name after 'Schedule:' in the title."""
    return sched["title"][len("Schedule:"):].strip()

def _short_refs(text, repos):
    """owner/repo#N rendered as repo#N for the repositories read."""
    for repo in repos:
        text = text.replace(repo + "#", short(repo) + "#")
    return text

def lane_table(sched):
    """(lane, item spec, next, waits-on) per row whose first cell is a lane number. The item is the Epic:<Name> token if present, else the first issue reference."""
    lanes = []
    for raw in (sched.get("body", "") or "").split("\n"):
        cells = [c.strip() for c in raw.strip().strip("|").split("|")]
        if len(cells) < 2 or not regex.match(pattern = "^[0-9]+$", text = cells[0]):
            continue
        item = cells[1]
        epic = regex.find_submatch(pattern = "Epic:([A-Za-z0-9:_.-]+)", text = item)
        ref = regex.find_submatch(pattern = "(?:([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+))?#([0-9]+)", text = item)
        if epic != None and len(epic) > 1:
            spec = {"epic": epic[1]}
        elif ref != None and len(ref) > 2:
            spec = {"key": (ref[1] if ref[1] else sched["repo"]) + "#" + ref[2]}
        else:
            spec = {"unresolved": item}
        lanes.append({
            "lane": int(cells[0]),
            "spec": spec,
            "item_text": item,
            "next": cells[2] if len(cells) > 2 else "",
            "waits_on": cells[3] if len(cells) > 3 else "",
        })
    return lanes

def _aggregate(frows):
    """Sum a set of feature rows into done, open, feature count, and a state."""
    done = 0
    open_ = 0
    n = 0
    for r in frows:
        if r["feature"] == None:
            continue
        n += 1
        done += r["done"]
        open_ += r["open"]
    if n == 0:
        return {"done": 0, "open": 0, "features": 0, "state": "awaiting plan and design"}
    total = done + open_
    state = "no tasks filed" if total == 0 else (str(done) + " of " + str(total) + " done across " + str(n) + " feature(s)")
    return {"done": done, "open": open_, "features": n, "state": state}

def _missing(spec_key, repos, state):
    """Why a lane's issue is not in the set: its repository was not read, or the issue is not among the state's."""
    repo = spec_key.split("#")[0]
    if repo not in repos:
        return spec_key + " is in " + repo + ", which this report did not read"
    if state == "all":
        return spec_key + " was not found"
    return spec_key + " is not among the " + state + " issues"

def resolve_lane(spec, all, repos, state):
    """The issue a lane names and its live progress. An epic aggregates its features and chores; a feature or a chore rolls up its lanes; anything else reports its own state."""
    it = None
    if "epic" in spec:
        tag = "Epic:" + spec["epic"]
        epics = [i for i in all if tagged(i, "epic") and epic_tag(i) == tag]
        it = epics[0] if epics else None
        if it == None:
            return None, {"done": 0, "open": 0, "features": 0, "state": "no epic issue carries " + tag}
        return it, _aggregate(feature_rows([it], all))
    if "key" in spec:
        hits = [i for i in all if key(i) == spec["key"]]
        it = hits[0] if hits else None
        if it == None:
            return None, {"done": 0, "open": 0, "features": 0, "state": _missing(spec["key"], repos, state)}
        if tagged(it, "epic"):
            return it, _aggregate(feature_rows([it], all))
        if is_parent(it):
            tag = epic_tag(it)
            tasks = [i for i in all if is_child(i) and epic_tag(i) == tag]
            kids = children_of(it, tasks)
            done = len([k for k in kids if k["state"] == "CLOSED"])
            return it, {"done": done, "open": len(kids) - done, "features": 1, "state": feature_state(it, kids)}
        return it, {"done": 1 if it["state"] == "CLOSED" else 0, "open": 0 if it["state"] == "CLOSED" else 1, "features": 0, "state": "closed" if it["state"] == "CLOSED" else "open"}
    return None, {"done": 0, "open": 0, "features": 0, "state": "unresolved: " + spec.get("unresolved", "")}

def schedule_rows(sched, all, repos, state):
    """The lanes of one schedule, in declared order, with live progress."""
    rows = []
    for lane in lane_table(sched):
        it, prog = resolve_lane(lane["spec"], all, repos, state)
        rows.append({
            "schedule": schedule_name(sched),
            "lane": lane["lane"],
            "item_ref": it["ref"] if it else "",
            "item_url": it["url"] if it else "",
            "item_title": cell(it["title"]) if it else lane["item_text"],
            "item_kind": kind_of(it) if it else "",
            "done": prog["done"],
            "open": prog["open"],
            "features": prog["features"],
            "state": prog["state"],
            "next": _short_refs(lane["next"], repos),
            "waits_on": _short_refs(lane["waits_on"], repos),
        })
    return rows

def schedule_table_lines(rows):
    """Lane, item, progress, next, waits on."""
    out = ["| Lane | Item | Progress | Next | Waits on |", "|---|---|---|---|---|"]
    for r in rows:
        item = ("[" + r["item_ref"] + "](" + r["item_url"] + ") " if r["item_ref"] else "") + r["item_title"]
        out.append("| " + str(r["lane"]) + " | " + item + " | " + r["state"] + " | " + cell(r["next"]) + " | " + cell(r["waits_on"]) + " |")
    return out

# ── the unthreaded validation ───────────────────────────────────────────────
#
# Zero threads is the normal state of most issues, so this is not a fault and not part of the
# default audit. It is requested: every open lane carrying no Thread: label, grouped by epic and
# parent, so "should this be in a thread?" is asked once of someone who can answer it.

def unthreaded(all, epic_filter):
    """Open tasks and bugs with no Thread: label, as rows carrying their epic and parent."""
    features = {key(f): f for f in all if is_parent(f)}
    rows = []
    for it in all:
        if it["state"] != "OPEN" or not is_child(it):
            continue
        if len([n for n in names(it) if n.startswith("Thread:")]) > 0:
            continue
        if epic_filter and epic_name(it) != epic_filter:
            continue
        pf = parent(it)
        f = features.get(pf) if pf else None
        rows.append({
            "repo": it["repo"],
            "ref": it["ref"],
            "url": it["url"],
            "title": cell(it["title"]),
            "kind": kind_of(it),
            "epic_name": epic_name(it),
            "feature": f["number"] if f else None,
            "feature_ref": f["ref"] if f else "",
            "feature_title": cell(f["title"]) if f else "",
        })
    return sorted(rows, key = lambda r: (r["epic_name"], r["feature_ref"], r["ref"]))

def unthreaded_lines(rows):
    """The validation as a document, grouped by epic and parent."""
    out = ["## Not in any thread\n"]
    if len(rows) == 0:
        out.append("Every open task and bug carries a thread label.")
        return out
    out.append("_" + str(len(rows)) + " open issue(s) carry no Thread: label. Zero threads is normal; this is a question, not a fault._")
    last = None
    for r in rows:
        group = (r["epic_name"] or "no epic", r["feature_ref"])
        if group != last:
            head = "Epic: " + (r["epic_name"] or "none")
            if r["feature_ref"]:
                head += " — " + r["feature_title"] + " (" + r["feature_ref"] + ")"
            else:
                head += " — unfiled"
            out.append("\n### " + head)
            last = group
        out.append("- [" + r["ref"] + "](" + r["url"] + ") " + r["title"] + " · " + r["kind"])
    return out
