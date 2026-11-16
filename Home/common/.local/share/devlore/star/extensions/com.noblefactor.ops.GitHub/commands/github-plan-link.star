# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""star github plan link: each issue's Plan and design documents section written from the plans that serve it."""

# github-plan-link.star
#
# docs/plans/feature/557-plan-row.md (noblefactor-engprod#557), to section 8 of the issue data model, § Linking plans:
# plan link. The plans are the authority (ruled 2026-11-15): a plan names the issues it serves, the one it is named for
# in its issue: line and each other in an `## Issue NNN` heading, and the design documents it bears on in its
# frontmatter's documents:. An issue's section is written from every plan that serves it, a Plan row for each, then each
# plan's documents; the section is found by its heading and replaced whole, reading none of its rows, and every byte
# outside it is kept. An issue no plan serves is not touched, and nothing here writes a plan. Each link points by the
# issue's state (ruled 2026-11-15): at the merge commit of the pull request whose merge closed it, or else on the
# default branch (_place).
#
# What GitHub is asked, and how often, for R repositories, P plans on their default branches and I issues:
#
#   - each repository's name now and its default branch, REST repos/<repository>: R calls, one more for each other
#     name an issue: line spells a repository by, such as noblefactor-ops;
#   - each default branch's tree, REST git/trees/<branch>?recursive=1: R calls, which list the plans and say which
#     paths a plan's documents may name;
#   - the plans' text, GraphQL, 50 blobs to a query: P / 50 calls, rounded up, for each repository;
#   - the issues, GraphQL issueOrPullRequest, 50 to a query, each with its last ClosedEvent's closer: I / 50 calls for
#     each repository they are in;
#   - the files each merge commit that closed an issue must hold, GraphQL, 50 to a query: one call for each 50 of them;
#   - each issue written, one updateIssue and one read back: 2 calls each, and none under --check.
#
# The result is one flat record for each issue, and one for each plan that serves no issue it can be read for; refused
# and dropped are findings, and the command exits non-zero only on an error (section 8, § The commands).

load("commands/access.star", "check_access")
load("commands/accounts.star", "ORIGIN")
load("commands/model.star", "refuse_dry_run")
load("commands/records.star", "quote", "sh")
load("commands/scheme.star", "USER_ATTRIBUTES", "canonical_repo", "key_of", "layer_repos", "model_of", "models_for", "type_of")

_PLANS = "docs/plans/"

# The template plans are written from, under docs/plans but no plan: it names no issue, and serves none.
_TEMPLATE = "docs/plans/TEMPLATE.md"

# The type directories under docs/plans whose plans are named for their issues, <issue>-<name>.md: the branch
# ruleset's types, chore, which holds the plans filed before it was retired, and devlore-cli's task (ruled 2026-11-15).
_TYPES = ["doc", "feature", "fix", "hotfix", "refactor", "release", "chore", "task"]

# The section's heading, matched without regard to case, at level 2 or 3; a form writes ###, the API ##.
_TITLE = "Plan and design documents"
_LEVELS = [2, 3]

# The record key of the attribute a record carries beside its type: an organization's Area field, a user's area: label.
_AREA = "area"

_HEADER = "| Kind | Document |"
_DELIMITER = "| --- | --- |"

# Blobs or issues to one GraphQL query: each alias is one field, and 50 keeps a query well inside GraphQL's limits.
_BATCH = 50

# ── the shell and GitHub ────────────────────────────────────────────────────

def _json(command, what):
    """A command's standard output as JSON, its exit ignored: gh exits 1 on a GraphQL error and still prints the answer.

    Fails, naming what, when the output is no JSON: gh could not reach GitHub, or the login cannot read it.
    """
    out = sh(command + " 2>/dev/null; true").strip()
    if not out.startswith("{"):
        fail("star github plan link cannot read " + what + ": gh answered " + (out[:200] or "nothing"))
    return json.decode(data = out)

def _graphql_string(s):
    """s as a GraphQL string literal's contents."""
    return s.replace("\\", "\\\\").replace("\"", "\\\"")

def _batches(items):
    """items in lists of _BATCH."""
    return [items[i:i + _BATCH] for i in range(0, len(items), _BATCH)]

def _repository(name, cache):
    """A repository as GitHub names it now, with its default branch: {"name", "branch"}, read once for each name.

    GitHub answers a repository's old name with its new one, so a link through noblefactor-ops goes to
    noblefactor-engprod.
    """
    key = name.lower()
    if key not in cache:
        answer = _json("gh api " + quote("repos/" + canonical_repo(name)), "the repository " + name)
        if not answer.get("full_name") or not answer.get("default_branch"):
            fail("star github plan link cannot read the repository " + name + ": GitHub answered " + json.encode(answer)[:200])
        cache[key] = {"name": answer["full_name"], "branch": answer["default_branch"]}
    return cache[key]

def _tree(repo):
    """Every file's path on a repository's default branch, a dict of path to True; fails when GitHub cuts it short."""
    answer = _json("gh api " + quote("repos/" + repo["name"] + "/git/trees/" + repo["branch"] + "?recursive=1"), repo["name"] + "'s tree")
    if answer.get("truncated"):
        fail(repo["name"] + "'s tree on " + repo["branch"] + " is more than GitHub lists in one answer")
    return {e["path"]: True for e in (answer.get("tree") or []) if e.get("type") == "blob"}

def _objects(repo, expressions, selection, operation, what):
    """Each object expression's answer in a repository, <revision>:<path>, 50 to a query; None where there is none."""
    owner, name = repo["name"].split("/")
    out = {}
    for batch in _batches(expressions):
        fields = " ".join([
            "f" + str(i) + ": object(expression: \"" + _graphql_string(e) + "\") { " + selection + " }"
            for i, e in enumerate(batch)
        ])
        query = "query " + operation + " { repository(owner: \"" + owner + "\", name: \"" + name + "\") { " + fields + " } }"
        answer = _json("gh api graphql -f query=" + quote(query), what + " of " + repo["name"])
        if answer.get("errors"):
            fail("GitHub refused to read " + what + " of " + repo["name"] + ": " + json.encode(answer["errors"])[:400])
        node = (answer.get("data") or {}).get("repository") or {}
        for i, e in enumerate(batch):
            v = node.get("f" + str(i))
            out[e] = v if type(v) == "dict" else None
    return out

def _blobs(repo, paths):
    """Each path's text on the repository's default branch, by path, read 50 to a query."""
    found = _objects(repo, [repo["branch"] + ":" + p for p in paths], "... on Blob { text isTruncated }", "starPlanBlobs", "the plans")
    out = {}
    for p in paths:
        blob = found[repo["branch"] + ":" + p]
        if blob == None or blob.get("text") == None or blob.get("isTruncated"):
            fail("star github plan link cannot read " + repo["name"] + ":" + p + " on " + repo["branch"])
        out[p] = blob["text"]
    return out

def _present(repo, refs):
    """Whether each (commit, path) is a file of the repository at that commit, by (commit, path), 50 to a query."""
    found = _objects(repo, [oid + ":" + path for oid, path in refs], "__typename", "starPlanAt", "the files at merge commits")
    return {(oid, path): (found[oid + ":" + path] or {}).get("__typename") == "Blob" for oid, path in refs}

# What an issue's last ClosedEvent says closed it: a pull request, or a commit with the pull requests it is part of.
_CLOSER_PR = "number mergedAt mergeCommit { oid } repository { nameWithOwner }"
_CLOSER = ("timelineItems(itemTypes: [CLOSED_EVENT], last: 1) { nodes { ... on ClosedEvent { closer { __typename " +
           "... on PullRequest { " + _CLOSER_PR + " } ... on Commit { oid associatedPullRequests(first: 5) { nodes { " + _CLOSER_PR +
           " } } } } } } }")

def _closing(v):
    """The merged pull request whose merge closed an issue, {"repo", "number", "oid"}, its merge commit's; or None.

    GitHub records what closed an issue in its last ClosedEvent's closer: the pull request, when its merge closed the
    issue, or the commit that did, a squash merge's, whose pull request is the one among the commit's with that merge
    commit. closedByPullRequestsReferences lists every pull request that would close the issue and cannot say which one
    did, so the closer tells, and an issue more than one would close needs no other rule. An issue open, closed as not
    planned or a duplicate, closed by hand, with no closer, or closed by anything but a merged pull request, has none.
    """
    if v.get("state") != "CLOSED" or v.get("stateReason") in ["NOT_PLANNED", "DUPLICATE"]:
        return None
    events = (v.get("timelineItems") or {}).get("nodes") or []
    closer = (events[-1].get("closer") if events and type(events[-1]) == "dict" else None) or {}
    if closer.get("__typename") == "PullRequest":
        candidates = [closer]
    elif closer.get("__typename") == "Commit":
        candidates = [p for p in ((closer.get("associatedPullRequests") or {}).get("nodes") or []) if (p.get("mergeCommit") or {}).get("oid") == closer.get("oid")]
    else:
        candidates = []
    for p in candidates:
        oid = (p.get("mergeCommit") or {}).get("oid")
        if p.get("mergedAt") and oid:
            return {"repo": canonical_repo(p["repository"]["nameWithOwner"]), "number": int(p["number"]), "oid": oid}
    return None

# What classifies an issue: its issue type and labels, and its single-select issue fields' values, Area among them.
_CLASS = ("issueType { name } labels(first: 50) { nodes { name } } issueFieldValues(first: 20) { nodes { " +
          "... on IssueFieldSingleSelectValue { field { ... on IssueFieldCommon { name } } name } } }")

def _issues(repo, numbers):
    """Each number's issue in a repository: {"kind", "id", "url", "body", "open", "closed_by", ...}; None for neither.

    kind is Issue or PullRequest; closed_by is the merged pull request whose merge closed the issue, _closing's; and
    issue_type, labels and fields, by name, are what _classify reads. GitHub answers a number with no issue or pull
    request with null and a NOT_FOUND error, which is a finding; any other error is one the command cannot read past.
    """
    owner, name = repo["name"].split("/")
    out = {}
    for batch in _batches(sorted(numbers)):
        fields = " ".join([
            "i" + str(n) + ": issueOrPullRequest(number: " + str(n) + ") { __typename ... on Issue { id url body state stateReason " + _CLOSER +
            " " + _CLASS + " } ... on PullRequest { url } }"
            for n in batch
        ])
        query = "query starPlanIssues { repository(owner: \"" + owner + "\", name: \"" + name + "\") { " + fields + " } }"
        answer = _json("gh api graphql -f query=" + quote(query), "the issues of " + repo["name"])
        for e in answer.get("errors") or []:
            if e.get("type") != "NOT_FOUND" or len(e.get("path") or []) != 2:
                fail("GitHub refused to read the issues of " + repo["name"] + ": " + json.encode(e)[:400])
        node = (answer.get("data") or {}).get("repository")
        if type(node) != "dict":
            fail("star github plan link cannot read the issues of " + repo["name"] + ": GitHub has no such repository")
        for n in batch:
            v = node.get("i" + str(n))
            if type(v) != "dict":
                out[n] = None
                continue
            out[n] = {
                "kind": v.get("__typename"),
                "id": v.get("id"),
                "url": v.get("url"),
                "body": v.get("body") or "",
                "open": v.get("state") == "OPEN",
                "closed_by": _closing(v) if v.get("__typename") == "Issue" else None,
                "issue_type": v.get("issueType"),
                "labels": [label["name"] for label in ((v.get("labels") or {}).get("nodes") or [])],
                "fields": {
                    f["field"]["name"]: f.get("name")
                    for f in ((v.get("issueFieldValues") or {}).get("nodes") or [])
                    if type(f) == "dict" and type(f.get("field")) == "dict" and f["field"].get("name")
                },
            }
    return out

def _classify(node, model):
    """An issue's Area and type by its account's model, (area, type), each None where the issue has none.

    Ruled 2026-11-15: a record carries them, as the report's do, so that --filter area=Engineering selects; a plan is
    classified through its issue alone. In an organization they are its Area issue field and its issue type; in a user
    account its area: label, named as the user reference names it, and its type label.
    """
    kind = type_of(model, node["issue_type"], node["labels"])
    area = None
    if model["user"]:
        for family in USER_ATTRIBUTES:
            if family["key"] != _AREA:
                continue
            for label in family["labels"]:
                if label in node["labels"]:
                    area = family["names"][label]
                    break
    else:
        for f in model["fields"]:
            if key_of(f["name"]) == _AREA:
                area = node["fields"].get(f["name"])
    return area, kind

def _write(issue, body):
    """An issue's body written, and read back: the body GitHub then holds, or None when it refused the write.

    A refused write is an error the run reports after every other issue, so its exit is read rather than raised.
    """
    status = sh("gh api graphql -f query=" + quote("mutation starPlanWrite($i: ID!, $b: String!) { updateIssue(input: {id: $i, body: $b}) { issue { id } } }") +
                " -f i=" + quote(issue["id"]) + " -f b=" + quote(body) + " >/dev/null 2>&1; echo $?").strip()
    if status != "0":
        return None
    answer = _json("gh api graphql -f query=" + quote("query starPlanBody { node(id: \"" + issue["id"] + "\") { ... on Issue { body } } }"), issue["key"] + "'s body")
    return (((answer.get("data") or {}).get("node")) or {}).get("body") or ""

# ── a body's lines and its section ──────────────────────────────────────────

def _lines(text):
    """A text's lines, each {"start", "end", "text", "text_end"}: its offsets with and without its \\r\\n or \\n."""
    out = []
    at = 0
    parts = text.split("\n")
    for i, part in enumerate(parts):
        last = i == len(parts) - 1
        if last and part == "":
            break
        bare = part[:-1] if part.endswith("\r") else part
        end = at + len(part) + (0 if last else 1)
        out.append({"start": at, "end": end, "text": bare, "text_end": at + len(bare)})
        at = end
    return out

def _eol(text):
    """The line end a text uses, \\r\\n or \\n, by its first; \\n when it has none."""
    at = text.find("\n")
    return "\r\n" if at > 0 and text[at - 1] == "\r" else "\n"

# A thematic break: ---, *** or ___, or a longer run of one of them, alone on its line. A table's delimiter row holds a
# pipe, and is none.
_BREAK = "^ {0,3}(-{3,}|\\*{3,}|_{3,})[ \\t]*$"

def _marks(lines):
    """Each ATX heading and thematic break outside a fenced code block: {"index", "break", "level", "title"}.

    A heading's title is without its closing sequence; a break has no level or title. The body's lines are read one by
    one, a fence opening and closing by its backticks or tildes, as CommonMark does.
    """

    # TODO(https://github.com/NobleFactor/devlore-cli/issues/1100): read the body's sections as values through star's
    # Markdown provider once it exists, in place of finding the headings and breaks by the body's lines.
    out = []
    fence = None
    for i, line in enumerate(lines):
        t = line["text"]
        if fence != None:
            if regex.match(pattern = "^ {0,3}" + fence + "[ \\t]*$", text = t):
                fence = None
            continue
        m = regex.find_submatch(pattern = "^ {0,3}(```+|~~~+)", text = t)
        if m:
            fence = m[1][0] + "{" + str(len(m[1])) + ",}"
            continue
        if regex.match(pattern = _BREAK, text = t):
            out.append({"index": i, "break": True, "level": None, "title": None})
            continue
        m = regex.find_submatch(pattern = "^ {0,3}(#{1,6})(?:[ \\t]+(.*?))?[ \\t]*$", text = t)
        if not m:
            continue
        title = regex.replace(pattern = "(^|[ \\t]+)#+$", text = m[2] or "", replacement = "").strip()
        out.append({"index": i, "break": False, "level": len(m[1]), "title": title})
    return out

def _headings(lines):
    """Each ATX heading outside a fenced code block: {"index", "break", "level", "title"}, as _marks reads them."""
    return [m for m in _marks(lines) if not m["break"]]

def _find(body):
    """The Plan and design documents sections of a body: [{"level", "first", "end"}], line indices, end exclusive.

    A section runs from its heading to the next heading at its level or above, or to the next thematic break, whichever
    comes first (ruled 2026-11-15), or to the end of the body; the break and everything after it are not the section's.
    """
    lines = _lines(body)
    marks = _marks(lines)
    out = []
    for h in marks:
        if h["break"] or h["level"] not in _LEVELS or h["title"].lower() != _TITLE.lower():
            continue
        end = len(lines)
        for g in marks:
            if g["index"] > h["index"] and (g["break"] or g["level"] <= h["level"]):
                end = g["index"]
                break
        out.append({"level": h["level"], "first": h["index"], "end": end})
    return lines, out

def _span(lines, section):
    """A section's offsets in the body: its start, the end of its last line that is not blank, and its end."""
    start = lines[section["first"]]["start"]
    end = lines[section["end"] - 1]["end"]
    last = section["first"]
    for i in range(section["first"], section["end"]):
        if lines[i]["text"].strip() != "":
            last = i
    return start, lines[last]["text_end"], end

def _content(level, rows, eol):
    """The section the plans give, without its last line end: its heading at level, the table's header, and its rows."""
    return eol.join(["#" * level + " " + _TITLE, "", _HEADER, _DELIMITER] + rows)

def _delimiter(text):
    """Whether a line is a table's delimiter row, which says nothing of any document; a rule, ---, is no such row."""
    return "|" in text and regex.match(pattern = "^\\|?[ \\t]*:?-+:?[ \\t]*(\\|[ \\t]*:?-+:?[ \\t]*)*\\|?[ \\t]*$", text = text)

def _dropped(lines, section, content):
    """The section's lines, after its heading, that the section the plans give does not hold: each once, trimmed."""
    keep = {line.strip(): True for line in content.replace("\r", "").split("\n")}
    out = []
    for i in range(section["first"] + 1, section["end"]):
        t = lines[i]["text"].strip()
        if t == "" or t in keep or _delimiter(t) or t in out:
            continue
        out.append(t)
    return out

def _plan(issue, rows):
    """What the command does to one issue: its action, its body after, the section before and after, and what it drops.

    One section: replaced, its lines ending as the body's do and its trailing line ends kept, so that a run that changes
    nothing leaves every byte; written, or unchanged when it already is the section. None: added at the end, after a
    blank line, appended. Two or more: refused, and nothing written.
    """
    body = issue["body"]
    eol = _eol(body)
    lines, sections = _find(body)
    if len(sections) > 1:
        content = _content(sections[0]["level"], rows, eol)
        return {
            "action": "refused",
            "reason": issue["key"] + " has " + str(len(sections)) + " " + _TITLE + " sections; star github plan link writes one",
            "before": None,
            "after": content + eol,
            "content": content,
            "dropped": [],
            "body": None,
        }
    if not sections:
        content = _content(2, rows, eol)

        # After a blank line: as many line ends as the body lacks of one, and none in an empty body.
        if body == "" or body.endswith("\n\n") or body.endswith("\n\r\n"):
            gap = ""
        elif body.endswith("\n"):
            gap = eol
        else:
            gap = eol + eol
        return {
            "action": "appended",
            "reason": None,
            "before": None,
            "after": content + eol,
            "content": content,
            "dropped": [],
            "body": body + gap + content + eol,
        }
    section = sections[0]
    start, last, end = _span(lines, section)
    content = _content(section["level"], rows, eol)
    tail = body[last:end]

    # A table followed by a heading or a break is separated from it by a blank line.
    if section["end"] < len(lines) and tail.count("\n") < 2:
        tail = eol + eol
    after = content + tail
    before = body[start:end]
    return {
        "action": "unchanged" if after == before else "written",
        "reason": None,
        "before": before,
        "after": after,
        "content": content,
        "dropped": _dropped(lines, section, content),
        "body": body[:start] + after + body[end:],
    }

def _reads_back(back, content):
    """Whether a body read back holds one section whose lines, to its last that is not blank, are content's."""
    lines, sections = _find(back)
    if len(sections) != 1:
        return False
    start, last, _ = _span(lines, sections[0])
    return back[start:last] == content

# ── a plan ──────────────────────────────────────────────────────────────────

def _frontmatter(text):
    """A plan's frontmatter, its lines between the --- that opens the file and the one that closes it; or None."""
    lines = [line.rstrip("\r") for line in text.split("\n")]
    if not lines or lines[0].strip() != "---":
        return None
    for i in range(1, len(lines)):
        if lines[i].strip() in ["---", "..."]:
            return lines[1:i]
    return None

def _value(front, name):
    """One top-level key of a frontmatter, decoded by star's YAML decoder; None when it is absent.

    The key's own lines are decoded, its line and each line that continues it, and not the whole frontmatter: a plan
    whose title carries an unquoted colon is no YAML, and star's decoder stops a command on it, while the keys this one
    reads are sound.
    """
    for i, line in enumerate(front):
        if not line.startswith(name + ":"):
            continue
        text = [line]
        for more in front[i + 1:]:
            if more == "" or more[0] in " \t#" or more == "-" or more.startswith("- "):
                text.append(more)
            else:
                break
        return (yaml.decode(data = "\n".join(text) + "\n") or {}).get(name)
    return None

def _named_issue(value, repo):
    """The issue a plan's issue: line names, owner/name#N, or None, and what the line says when it names none.

    By its URL; or by a bare number or #N, an issue of the plan's own repository.
    """
    if value == None:
        return None, "its issue: line is missing or empty"
    if type(value) in ["int", "float"]:
        return repo + "#" + str(int(value)), None
    s = str(value).strip()
    m = regex.find_submatch(pattern = "^#?([0-9]+)$", text = s)
    if m:
        return repo + "#" + str(int(m[1])), None
    m = regex.find_submatch(pattern = "^https://github\\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/issues/([0-9]+)/?(#.*)?$", text = s)
    if m:
        return m[1] + "/" + m[2] + "#" + str(int(m[3])), None
    return None, "its issue: line reads " + json.encode(s) + ", which names no issue"

def _documents(value, plan):
    """A plan's documents: entries, each {"kind", "path" or "url", "text"}, and the faults that refuse the plan.

    Where a path must be is the issue's to say, so _place checks it for each issue the plan serves.
    """
    if value == None:
        return [], []
    if type(value) != "list":
        return [], [plan["id"] + "'s documents: is not a list"]
    out = []
    faults = []
    for i, d in enumerate(value):
        where = plan["id"] + "'s documents: entry " + str(i + 1)
        if type(d) != "dict":
            faults.append(where + " is not a kind with a path or a url")
            continue
        kind = str(d.get("kind") or "").strip()
        path = str(d.get("path") or "").strip()
        url = str(d.get("url") or "").strip()
        text = str(d.get("text") or "").strip()
        if kind == "":
            faults.append(where + " has no kind")
        if (path == "") == (url == ""):
            faults.append(where + " names " + ("both a path and a url" if path else "neither a path nor a url"))
        out.append({"kind": kind, "path": path, "url": url, "text": text})
    return out, faults

def _read_plan(plan, cache):
    """A plan as the command reads it: the issues it serves, its documents, and the faults that refuse it.

    The plan is {"repo", "branch", "tree", "path", "text", "id"}; the issues come from its issue: line and each
    `## Issue NNN` heading, the number alone, as development-process.md § Plans writes it, outside a fenced code block.
    """
    front = _frontmatter(plan["text"])
    faults = []
    issues = []
    named = None
    documents = []
    if front == None:
        faults.append(plan["id"] + " has no frontmatter, so names no issue")
    else:
        named, why = _named_issue(_value(front, "issue"), plan["repo"])
        if named == None:
            faults.append(plan["id"] + " names no issue: " + why)
        else:
            issues.append(named)
        documents, more = _documents(_value(front, "documents"), plan)
        faults.extend(more)

    # The number a plan's file name begins with is its issue's only directly in a type directory, docs/plans/<type>/, as
    # development-process.md § Plans names a plan for its issue (ruled 2026-11-15); a subject directory's files, and any
    # nested deeper, are named otherwise.
    parts = plan["path"].split("/")
    m = regex.find_submatch(pattern = "^([0-9]+)-", text = parts[-1]) if len(parts) == 4 and parts[2] in _TYPES else None
    if m and named != None and int(m[1]) != int(named.split("#")[1]):
        faults.append(plan["id"] + "'s file name says " + str(int(m[1])) + ", but its issue: line names " + named)
    lines = _lines(plan["text"])
    for h in _headings(lines):
        n = regex.find_submatch(pattern = "^Issue ([0-9]+)$", text = h["title"]) if h["level"] == 2 else None
        if n:
            key = plan["repo"] + "#" + str(int(n[1]))
            if key not in issues:
                issues.append(key)

    # Every issue under the repository's name now: an issue: line through an old name serves the same issue.
    resolved = []
    for key in issues:
        repo, number = key.split("#")
        key = _repository(repo, cache)["name"] + "#" + number
        if key not in resolved:
            resolved.append(key)
    return dict(plan, issues = resolved, documents = documents, faults = faults)

def _link(repo, revision, path):
    """A file's link in a repository at a revision: its default branch, or a commit."""
    return "https://github.com/" + repo + "/blob/" + revision + "/" + path

def _cell(text):
    """Text as one table cell: a pipe escaped, a line end a space."""
    return text.replace("\r", "").replace("\n", " ").replace("|", "\\|")

def _place(plan, path, document, context):
    """Where one link of an issue's section points, by the issue's state: (link, note, fault), the link None on a fault.

    Ruled 2026-11-15 (#557), in place of a link always to the default branch. An issue closed by a merged pull request
    links each file at that pull request's merge commit, a record that cannot break; any other issue, open or closed
    without one, links the default branch. A file the merge commit lacks, moved after the merge, or a file of another
    repository than the pull request's, is linked on the default branch, and the note says so: a finding, not a refusal.
    A document must be where its link points: on the default branch, or, for an open issue in <plan> mode, in the
    clone's working tree, where it lands with the merge as the plan's own link does; else the fault refuses the issue. A
    plan's own path is where it was read.

    Args:
      plan: the plan the link is of, its repository's.
      path: the file's path in the plan's repository.
      document: True for a documents: entry, which must be where its link points; False for the plan itself.
      context: {"closed_by", "open", "at", "clone"}: the issue's closing pull request, or None; whether it is open; each
        (commit, path) checked at a merge commit, _present's; and the clone of <plan> mode, or None.
    """
    repo = plan["repo"]
    branch = plan["branch"]
    note = None
    by = context["closed_by"]
    if by != None:
        pull = by["repo"] + "#" + str(by["number"])
        if repo.lower() != by["repo"].lower():
            note = repo + ":" + path + " is not in " + by["repo"] + ", where " + pull + " merged: linked on " + branch
        elif context["at"].get((by["oid"], path)):
            return _link(repo, by["oid"], path), None, None
        else:
            note = path + " is not in " + repo + " at " + by["oid"][:7] + ", where " + pull + " merged: linked on " + branch
    if not document or plan["tree"].get(path) or (context["open"] and _in_clone(context["clone"], repo, path)):
        return _link(repo, branch, path), note, None
    return None, None, plan["id"] + "'s document path " + path + " is not on " + repo + "'s " + branch + (
        " or in " + context["clone"]["root"] if context["open"] and context["clone"] != None and context["clone"]["name"] == repo else ""
    )

def _in_clone(clone, repo, path):
    """Whether a file of a repository is in the working tree of <plan> mode's clone of it; False with no such clone."""
    if clone == None or clone["name"] != repo:
        return False
    if path not in clone["seen"]:
        clone["seen"][path] = sh("test -f " + quote(clone["root"] + "/" + path) + " && echo yes || echo no").strip() == "yes"
    return clone["seen"][path]

def _rows(plans, context):
    """The section's rows from the plans that serve an issue, each link placed by _place: (rows, notes, faults).

    A Plan row for each plan, by path; then each plan's documents, in the order it lists them, a document two plans name
    once. A document by url keeps its url as given.
    """
    ordered = sorted(plans, key = lambda p: (p["path"], p["repo"]))
    rows = []
    notes = []
    faults = []
    for p in ordered:
        link, note, _ = _place(p, p["path"], False, context)
        rows.append("| Plan | [" + _cell(p["path"]) + "](" + link + ") |")
        if note:
            notes.append(note)
    seen = {}
    for p in ordered:
        for d in p["documents"]:
            link = d["url"]
            if not link:
                link, note, fault = _place(p, d["path"], True, context)
                if fault:
                    faults.append(fault)
                    continue
                if note and note not in notes:
                    notes.append(note)
            if link in seen:
                continue
            seen[link] = True
            rows.append("| " + _cell(d["kind"]) + " | [" + _cell(d["text"] or d["path"] or d["url"]) + "](" + link + ") |")
    return rows, notes, faults

# ── where the plans are ─────────────────────────────────────────────────────

def _list(value):
    """A comma-separated flag's values, each trimmed, the empty ones dropped."""

    # TODO(https://github.com/NobleFactor/noblefactor-engprod/issues/315): take --repository repeated, --repository
    # <owner/name> --repository <owner/name>, once star's extension flags can repeat.
    return [v.strip() for v in (value or "").split(",") if v.strip()]

def _clone():
    """The clone or worktree the command runs in, its repository from its origin; fails outside one."""
    root = sh("git rev-parse --show-toplevel 2>/dev/null; true").strip()
    if root == "":
        fail("star github plan link <plan>... runs in a clone or worktree, each plan its path relative to its docs/plans")
    origin = sh("git -C " + quote(root) + " remote get-url origin 2>/dev/null; true").strip()
    m = regex.find_submatch(pattern = ORIGIN, text = origin)
    if not m:
        fail(root + " has no origin on GitHub to name its repository: " + (origin or "none"))

    # name is the repository as GitHub names it now, set once it is read; seen, the paths _in_clone has looked for.
    return {"root": root, "repo": canonical_repo(m[1]), "name": None, "seen": {}}

def _inside(path):
    """docs/plans/<path> when path, relative to docs/plans, stays inside it; None otherwise."""
    if path.startswith("/") or path.startswith("\\"):
        return None
    parts = []
    for part in path.replace("\\", "/").split("/"):
        if part in ["", "."]:
            continue
        if part == "..":
            if not parts:
                return None
            parts.pop()
            continue
        parts.append(part)
    return _PLANS + "/".join(parts) if parts else None

def _default_plans(repos, cache):
    """Every plan under docs/plans on each repository's default branch, read through GitHub, never a working tree."""
    plans = []
    trees = {}
    for name in repos:
        repo = _repository(name, cache)
        if repo["name"] in trees:
            continue
        tree = _tree(repo)
        trees[repo["name"]] = tree
        paths = sorted([p for p in tree if p.startswith(_PLANS) and p.endswith(".md") and p != _TEMPLATE])
        for path, text in sorted(_blobs(repo, paths).items()):
            plans.append({"repo": repo["name"], "branch": repo["branch"], "tree": tree, "path": path, "text": text, "id": repo["name"] + ":" + path})
    return plans, trees

# ── the records ─────────────────────────────────────────────────────────────

def _record(key, url, action, plans, reason, before, after, dropped, area = None, kind = None):
    """One record of the result: an issue, or a plan that serves none it can be read for, and what was done.

    area and type are the issue's, _classify's; None for a plan's record, a pull request's, or an issue with none.
    """
    return {
        "issue": key,
        "repository": key.split("#")[0] if key else None,
        "area": area,
        "type": kind,
        "url": url,
        "action": action,
        "plans": sorted([p["id"] for p in plans]),
        "reason": reason,
        "before": before,
        "after": after,
        "dropped": dropped,
    }

def run(_command, ctx):
    """Read the plans and the issues they serve, then write each issue's section from its plans, or say what would be.

    Args:
      _command: the command as star names it.
      ctx: the invocation: ctx.args carries the plans, each relative to docs/plans, --all, --repository and --check;
        ctx.dry_run, star's --dry-run, refused until NobleFactor/devlore-cli#1170 lets a dry run read.
    """
    refuse_dry_run(ctx.dry_run)
    named = [p.strip() for p in (ctx.args.get("plans") or []) if p.strip()]
    every = ctx.args.get("all") == True
    check = ctx.args.get("check") == True
    if every and named:
        fail("star github plan link takes plans or --all, not both: " + " ".join(named))
    if not every and not named:
        fail("star github plan link needs a plan, its path relative to docs/plans, or --all")
    check_access("star github plan link", dry_run = ctx.dry_run)

    cache = {}
    records = []
    clone = None
    repos = _list(ctx.args.get("repository"))
    if every:
        repos = repos or layer_repos() or [_clone()["repo"]]
    else:
        clone = _clone()
        repos = layer_repos() + repos + [clone["repo"]]
    plans, trees = _default_plans(repos, cache)

    # The plans named, from the working tree: the first script runs the command before they merge.
    targets = None
    if clone != None:
        own = _repository(clone["repo"], cache)
        clone["name"] = own["name"]
        if own["name"] not in trees:
            trees[own["name"]] = _tree(own)
        mine = []
        for p in named:
            path = _inside(p)
            if path == None:
                records.append(_record(None, None, "refused", [{"id": clone["repo"] + ":" + p}], p + " is not a plan under docs/plans", None, None, []))
                continue
            full = clone["root"] + "/" + path
            if sh("test -f " + quote(full) + " && echo yes || echo no").strip() != "yes":
                fail("no plan " + path + " in " + clone["root"])
            mine.append({"repo": own["name"], "branch": own["branch"], "tree": trees[own["name"]], "path": path, "text": sh("cat " + quote(full)), "id": own["name"] + ":" + path})
        ids = {p["id"]: True for p in mine}
        plans = [p for p in plans if p["id"] not in ids] + mine
        targets = ids

    plans = [_read_plan(p, cache) for p in plans]
    serving = {}
    for p in plans:
        for key in p["issues"]:
            serving.setdefault(key, []).append(p)

    # The issues to write: every one a plan serves under --all; else every one the plans named serve.
    if targets == None:
        keys = sorted(serving.keys())
        considered = plans
    else:
        keys = sorted({k: True for p in plans if p["id"] in targets for k in p["issues"]}.keys())
        considered = [p for p in plans if p["id"] in targets or [k for k in p["issues"] if k in keys]]

    # Each issue a considered plan names is read, so that a plan naming a pull request or no issue at all is refused.
    wanted = {}
    for p in considered:
        for key in p["issues"]:
            repo, number = key.split("#")
            wanted.setdefault(repo, {})[int(number)] = True
    read = {}
    for repo in sorted(wanted.keys()):
        for n, node in _issues(_repository(repo, cache), list(wanted[repo].keys())).items():
            read[repo + "#" + str(n)] = node
    for p in considered:
        for key in p["issues"]:
            node = read.get(key)
            if node == None:
                p["faults"].append(p["id"] + " names " + key + ", which GitHub has no issue or pull request for")
            elif node["kind"] != "Issue":
                p["faults"].append(p["id"] + " names " + key + ", a pull request")

    # The files each merge commit that closed an issue must hold: the paths of every plan of the pull request's
    # repository that serves it, and of their documents, read 50 to a query before anything is written.
    refs = {}
    for key in keys:
        node = read.get(key)
        by = node["closed_by"] if node != None and node["kind"] == "Issue" else None
        if by == None:
            continue
        for p in serving.get(key) or []:
            if p["repo"].lower() != by["repo"].lower():
                continue
            files = refs.setdefault(p["repo"], {})
            files[(by["oid"], p["path"])] = True
            for d in p["documents"]:
                if d["path"]:
                    files[(by["oid"], d["path"])] = True
    at = {}
    for repo in sorted(refs.keys()):
        at.update(_present(_repository(repo, cache), sorted(refs[repo].keys())))

    # Each account's model, read once for every account an issue is in, which classifies its issues (_classify).
    models = models_for(sorted({k.split("/")[0]: True for k in keys if read.get(k) != None and read[k]["kind"] == "Issue"}.keys()))

    errors = []
    covered = {}
    for key in keys:
        node = read.get(key)
        mine = serving.get(key) or []
        for p in mine:
            covered[p["id"]] = True
        if node == None or node["kind"] != "Issue":
            reason = key + " is " + ("a pull request" if node else "no issue or pull request GitHub has") + ": no section is written for it"
            records.append(_record(key, node["url"] if node else None, "refused", mine, reason, None, None, []))
            continue
        issue = dict(node, key = key)
        area, kind = _classify(node, model_of(models, key.split("/")[0]))
        rows, notes, placed = _rows(mine, {"closed_by": node["closed_by"], "open": node["open"], "at": at, "clone": clone})
        faults = [f for p in mine for f in p["faults"]] + placed
        if faults:
            records.append(_record(key, node["url"], "refused", mine, "; ".join(faults), None, None, [], area, kind))
            continue
        done = _plan(issue, rows)
        done["reason"] = "; ".join([r for r in [done["reason"]] + notes if r]) or None
        if done["action"] in ["written", "appended"] and not check:
            back = _write(issue, done["body"])
            if back == None:
                errors.append("GitHub refused to write " + key + "'s body")
            else:
                note("wrote " + key + "'s " + _TITLE + " section, " + done["action"])
                if not _reads_back(back, done["content"]):
                    errors.append(key + "'s " + _TITLE + " section does not read back as written")
        records.append(_record(key, node["url"], done["action"], mine, done["reason"], done["before"], done["after"], done["dropped"], area, kind))

    # A plan that serves no issue it can be read for has a record of its own, so that its fault is seen.
    for p in plans:
        if p["id"] in covered or (targets != None and p["id"] not in targets):
            continue
        if p["faults"] or not p["issues"]:
            records.append(_record(None, None, "refused", [p], "; ".join(p["faults"]) or p["id"] + " names no issue", None, None, []))

    # Ruled 2026-11-15: an error on one issue stops no other; the run fails after every one, naming each error and each
    # issue's outcome, since star prints no records for a command that fails. A --check run after it gives the records.
    if errors:
        fail(str(len(errors)) + " error(s), after every other issue was done:\n  " + "\n  ".join(errors) +
             "\nEach issue's outcome; star github plan link --all --check gives the records:\n  " +
             "\n  ".join([str(r["issue"] or r["plans"]) + " " + r["action"] for r in records]))
    return sorted(records, key = lambda r: (r["issue"] == None, r["repository"] or "", int(r["issue"].split("#")[1]) if r["issue"] else 0, r["plans"]))
