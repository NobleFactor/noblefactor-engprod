# SPDX-License-Identifier: Apache-2.0
# Copyright Noble Factor. All rights reserved.

"""A body's lines, its ATX headings and thematic breaks, its sections, numbered items and task lists, read by its lines."""

# markdown.star
#
# docs/plans/doc/507-scenario-commands.md, Requirement 2 (noblefactor-engprod#511). What star github plan link read of a
# body to find its Plan and design documents section (#557), moved here so that star github issue move finds the same
# heading the same way: it writes an item's "Found while walking" line just above that heading, where plan link leaves
# it, and counts the steps under a Scenario issue's How to walk through it heading. star github schedule close reads the
# boxes of a Schedule issue's exit criteria the same way (#512). Until star has a Markdown provider
# (NobleFactor/devlore-cli#1100), a body is read by its lines, as CommonMark reads them.

# A thematic break: ---, *** or ___, or a longer run of one of them, alone on its line. A table's delimiter row holds a
# pipe, and is none.
_BREAK = "^ {0,3}(-{3,}|\\*{3,}|_{3,})[ \\t]*$"

# An ordered list's item, its number one to nine digits, then . or ), then a space, a tab or the end of the line. An
# item indented three spaces or more sits under the one before it, as GitHub renders a list, and is not counted.
_ITEM = "^ {0,2}[0-9]{1,9}[.)]([ \\t]|$)"

# A task list's item, at any depth: a bullet, -, * or +, then its box, [ ] or [x], then a space, a tab or the end of the
# line. The second group is the box's mark, and the third its text.
_BOX = "^[ \\t]*[-*+][ \\t]+\\[( |x|X)\\]([ \\t]+(.*))?$"

def body_lines(text):
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

def line_end(text):
    """The line end a text uses, \\r\\n or \\n, by its first; \\n when it has none."""
    at = text.find("\n")
    return "\r\n" if at > 0 and text[at - 1] == "\r" else "\n"

def _fenced(lines):
    """The index of every line that opens, closes or sits inside a fenced code block, by its backticks or tildes."""
    out = {}
    fence = None
    for i, line in enumerate(lines):
        t = line["text"]
        if fence != None:
            out[i] = True
            if regex.match(pattern = "^ {0,3}" + fence + "[ \\t]*$", text = t):
                fence = None
            continue
        m = regex.find_submatch(pattern = "^ {0,3}(```+|~~~+)", text = t)
        if m:
            out[i] = True
            fence = m[1][0] + "{" + str(len(m[1])) + ",}"
    return out

def marks(lines):
    """Each ATX heading and thematic break outside a fenced code block: {"index", "break", "level", "title"}.

    A heading's title is without its closing sequence; a break has no level or title. The body's lines are read one by
    one, a fence opening and closing by its backticks or tildes, as CommonMark does.
    """

    # TODO(https://github.com/NobleFactor/devlore-cli/issues/1100): read the body's sections as values through star's
    # Markdown provider once it exists, in place of finding the headings and breaks by the body's lines.
    out = []
    fenced = _fenced(lines)
    for i, line in enumerate(lines):
        if i in fenced:
            continue
        t = line["text"]
        if regex.match(pattern = _BREAK, text = t):
            out.append({"index": i, "break": True, "level": None, "title": None})
            continue
        m = regex.find_submatch(pattern = "^ {0,3}(#{1,6})(?:[ \\t]+(.*?))?[ \\t]*$", text = t)
        if not m:
            continue
        title = regex.replace(pattern = "(^|[ \\t]+)#+$", text = m[2] or "", replacement = "").strip()
        out.append({"index": i, "break": False, "level": len(m[1]), "title": title})
    return out

def headings(lines):
    """Each ATX heading outside a fenced code block: {"index", "break", "level", "title"}, as marks reads them."""
    return [m for m in marks(lines) if not m["break"]]

def sections(lines, title, levels):
    """The sections headed title, without regard to case, at one of levels: [{"level", "first", "end"}], end exclusive.

    A section runs from its heading to the next heading at its level or above, or to the next thematic break, whichever
    comes first (ruled 2026-11-15), or to the end of the body; the break and everything after it are not the section's.
    """
    found = marks(lines)
    out = []
    for h in found:
        if h["break"] or h["level"] not in levels or h["title"].lower() != title.lower():
            continue
        end = len(lines)
        for g in found:
            if g["index"] > h["index"] and (g["break"] or g["level"] <= h["level"]):
                end = g["index"]
                break
        out.append({"level": h["level"], "first": h["index"], "end": end})
    return out

def numbered(lines, section):
    """How many items of an ordered list a section holds at its top level, outside a fenced code block; 0 when none."""
    fenced = _fenced(lines)
    return len([i for i in range(section["first"] + 1, section["end"]) if i not in fenced and regex.match(pattern = _ITEM, text = lines[i]["text"])])

def boxes(lines, section):
    """The task list items a section holds, at any depth, outside a fenced code block: [{"ticked", "text", "line"}], in order.

    line is the item's index in lines, so that a box can be ticked or unticked where it stands.
    """
    fenced = _fenced(lines)
    out = []
    for i in range(section["first"] + 1, section["end"]):
        if i in fenced:
            continue
        m = regex.find_submatch(pattern = _BOX, text = lines[i]["text"])
        if m:
            out.append({"ticked": m[1] != " ", "text": (m[3] or "").strip(), "line": i})
    return out
