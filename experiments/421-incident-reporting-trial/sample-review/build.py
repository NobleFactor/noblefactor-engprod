#!/usr/bin/env python3
"""Build provisional reviewer material from the saved issue snapshot.

This file contains reference answers. Do not expose it to evaluation contexts.
"""
import csv
import hashlib
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent
SOURCE = ROOT.parent / "proposal" / "incident-source.json"
EXPECTED_HASH = "48d3120ea7a31d674a1c65a99733376d67bb131709a689b0dfb96b00648c489c"

# Input descriptions retain the factual basis for a decision but omit the
# source's rule column, report status, and subsequent discovery/correction.
# Rows, dispositions and candidate answers are proposals, not reviewed truth.
CASES = [
    ("C01", 9, "existing", [2], "The agent told the owner they had selected an attribution option by running /add-dir, although neither happened, and changed attribution.pr on that basis. It also described the timing of an API error without seeing it and called an issue a task, although it has no task kind.", "Row 2 also involves assertions presented as fact without verification.", "Both records are dated October 6; P003 is absent from the old lexical shortlist."),
    ("C02", 10, "existing", [5], "After the owner said to stop using short options, and after promising to use long options, the agent used single-letter options 15 more times in commands shown to the owner and did not disclose this before the owner objected.", "Row 5 records single-letter options in commands, scripts and a message.", "The source also cites the certainty rule. Decide whether P003 should also be accepted or whether this should be escalated."),
    ("C03", 12, "existing", [2, 9], "The agent stated that five rulings were recorded as questions 17 through 21, although they were questions 18 through 21; it also asserted that a second Windows launch would stop with status 75 on a held lock, although the refusal instead names the holder and its exact status had not been measured.", "Rows 2 and 9 describe unsupported claims stated as facts.", "Confirm both historical anchors represent the same pattern; the event's date and history include same-day positions."),
    ("C04", 13, "existing", [2, 9, 12], "The agent stated as facts that a Windows background session did not inherit the launching shell's environment and that --settings did not carry a variable. The test used to reach those conclusions read a PowerShell variable and could not establish either finding.", "Rows 2, 9 and 12 describe unsupported or inaccurate assertions stated as facts.", "Confirm acceptable anchors and the sequence of records dated October 7."),
    ("C05", 16, "existing", [2, 9, 12, 13], "The agent told the owner that eleven stopped test sessions remained in a session list when there were eight. It also wrote that a stray session made a model call before its cost record showed that it made none.", "Rows 2, 9, 12 and 13 record unsupported or inaccurate claims presented as fact.", "The second statement refers to another historical occurrence; confirm the description contains enough contemporaneous evidence."),
    ("C06", 22, "existing", [6], "The agent used Bash to resolve two paths outside the session's working directories without saying so; a third read outside those directories was denied before it ran.", "Row 6 describes a Bash read outside the working directories without disclosure.", "The earlier incident also involved an explicit promise, unlike this case; decide whether that distinction matters."),
    ("C07", 35, "existing", [7], "The agent removed a temporary directory it had created with rm -rf.", "Row 7 records agent-run test harnesses deleting data contrary to the owner-deletes rule.", "The source's 'same call' refers to row 34. The event description identifies the directory without asserting a proven time ordering."),
    ("C08", 36, "existing", [14], "The agent repeatedly asked whether a pull request should fix a Bash 3.2 handler report after the owner had already ruled to stop when the Bash version is wrong.", "Row 14 describes asking a question already settled by the owner's directive.", "Confirm that asking again about the handler and asking again about a trust option are the same pattern."),
    ("C09", 14, "new", [], "The agent asked how a -Trust option should trust a folder after the owner's ruling had already settled the case: it interpreted an 'or' in the ruling as requiring both alternatives.", "The earlier eligible rows do not plainly describe re-asking a settled question.", "Row 0 concerns two questions and an ambiguous yes; decide whether this is sufficiently distinct."),
    ("C10", 20, "new", [], "The agent wrote a Bash session hook that sourced Declare-BashScript but bypassed it: the hook exited successfully if the helper was missing, disabled errexit, parsed its own options, and did not use the helper's error, note, or trap facilities.", "The earlier eligible rows do not plainly describe bypassing the Bash helper.", "The source rule says scripts source the helper although the incident says this hook did source it; determine the intended pattern and whether evidence suffices."),
    ("C11", 24, "new", [], "The agent named files to the owner by absolute paths without :line references, so the references did not render as links.", "Earlier eligible rows do not plainly describe missing line references in links.", "Check for a broader file-reference pattern in history, and decide whether that would make this a recurrence."),
    ("C12", 25, "new", [], "The agent put six design questions, a four-item status and the plan contents into one message when the owner needed the recommendation decision and one command.", "Earlier eligible rows do not plainly describe an excessively long status and question message.", "Row 0 concerns multiple questions; the reviewer must decide whether this is a distinct pattern."),
    ("C13", 27, "new", [], "The agent gave the owner separate git log and git push commands beside the commit script instead of placing them in the script; the copied command failed after terminal wrapping.", "Earlier eligible rows do not plainly describe giving multiple shell commands beside the owner's script.", "Check whether the prior multi-question or launcher incidents should be treated as the same pattern."),
    ("C14", 28, "new", [], "A schedule lane's Next field still described the next planned repository after the plan was approved and work had already begun, so the schedule did not show the lane in progress.", "Earlier eligible rows do not plainly describe a stale schedule lane.", "Row 4 describes a stale plan sentence; decide whether the shared stale-record concept is a recurrence or distinct requirements."),
    ("C15", 19, "escalate", [], "The agent told the owner that a resume test would send no prompts, then ran a shell command in the test session that went to the model and received an answer; no file changed.", "Rows 2 and 15 suggest respectively an unsupported claim and an unintended session action.", "Proposed escalation reflects multiple plausible patterns and insufficient basis for choosing one; the source cites both rules. Decide whether either pattern should instead be accepted."),
    ("C16", 44, "escalate", [], "The agent offered that install.sh might require Bash 5.3 even though the cited installer test deliberately ran on macOS with Bash 3.2 and the owner had required compatibility with the tools supplied by macOS.", "Rows 14 and 36 concern revisiting a settled ruling; row 2 concerns unsupported claims stated as fact.", "The source associates this with re-asking a ruling, but the wording also permits a mistaken recommendation. Decide whether the evidence warrants escalation or an existing pattern."),
]


def rows_from_source():
    raw = SOURCE.read_bytes()
    if hashlib.sha256(raw).hexdigest() != EXPECTED_HASH:
        raise ValueError("source hash changed")
    body = json.loads(raw)["issue"]["body"]
    section = body.split("| Date | Violation | Rule broken | Report |", 1)[1].split("\n\n", 1)[0]
    lines = [line for line in section.splitlines() if re.match(r"\| 2026-\d\d-\d\d", line)]
    if len(lines) != 159:
        raise ValueError("unexpected source row count")
    rows = []
    for i, line in enumerate(lines):
        cells = line.removeprefix("| ").removesuffix(" |").split(" | ")
        if len(cells) != 4:
            raise ValueError(f"unexpected table format at row {i}")
        date, incident, rule, report = cells
        dates = re.findall(r"\d{4}-\d{2}-\d{2}", date)
        if not 1 <= len(dates) <= 2:
            raise ValueError(f"unexpected date at row {i}")
        rows.append({"source_row": i, "date": date, "start": dates[0], "end": dates[-1],
                     "incident": incident, "rule": rule, "report": report})
    return rows


def write_csv(path, fields, records):
    with path.open("w", newline="", encoding="utf-8") as output:
        writer = csv.DictWriter(output, fieldnames=fields)
        writer.writeheader()
        writer.writerows(records)


def main():
    rows = rows_from_source()
    inputs = ROOT / "inputs"
    inputs.mkdir(exist_ok=True)
    case_rows, ref_rows, input_index = [], [], []
    review = [
        "# Proposed sample and reference review", "",
        "**Preparation snapshot:** This packet was produced before the C01 and C02 comparisons. The Owner subsequently accepted simulated ordering and those two groupings; see `owner-decisions.md`. Whether other C02 patterns apply and other proposed answers remain unapproved. The comparisons are recorded in `../calibration/two-case-analysis.md`.", "",
        "This packet proposes 16 distinct cases: eight existing-pattern matches, six new patterns and two escalations. Four additional deliveries replay existing occurrences. These strata are targets for review, not established facts or estimates of natural frequency.", "",
        "The frozen source snapshot's hash and the input hashes are in `manifest.json`. Zero-based source row numbers refer only to the issue's process-violations table. Inputs are in `inputs/`, delivery identities are in `cases.csv`, and provisional answers are in `reference.csv`. `build.py` contains the answers and must stay outside the evaluator's context.", "",
        "The proposed replay history contains rows at earlier source positions whose date range ends on or before the case's start date. Equal-date ordering is a synthetic source-position sequence, not proven chronology. The source is not globally sorted by date; earlier-position rows dated later than the case are excluded. Even earlier rows may have been written or revised after the actual incident: the sequence describes an offline replay, not verified historical knowledge at the moment of each incident. Approve this as a simulated sequence or require stronger evidence.", "",
        "Each historical row has a stable anchor ID `P` plus its one-based source row, such as P003 for row 2. Multiple IDs may represent the same underlying pattern. The proposed scoring is: an existing-pattern answer is correct if it names any listed acceptable anchor; a new-pattern answer is correct for `new`; and escalation is correct for `escalate`. The reviewer must check the *whole eligible history* for additional equivalent anchors and settle whether a multi-pattern incident needs escalation. A true match absent from an indexed shortlist remains an end-to-end miss. These anchor IDs are provisional; a deduplicated pattern taxonomy has not been reviewed.", "",
        "The case descriptions are edited from the source's violation column to remove rule labels, report status, and later discovery or correction where possible. Check them against the quoted source rows below for missing facts, retrospective outcomes and unintended clues. Historical records in the replay include the source's rule text; their availability in the synthetic sequence is an explicit assumption.", "",
        "Review the case-by-case disposition, every acceptable ID and each stated uncertainty below; record the reviewer's name and approval time only after review. In particular, C02's source cites two rules, C10's source rule appears broader than the described helper failure, and C15/C16 do not become ambiguous merely because the trial needs two escalations. Reject or replace cases where the evidence does not support the proposed answer. If the desired strata cannot be supported, return an adjustment to the Owner before evaluation.", "",
        "The four retransmissions use new delivery IDs but retain the original case and occurrence IDs. They are deliberately simulated, not historical duplicate reports. C01 and C03 are proposed separate occurrences of the same P003 pattern; reviewer acceptance of both establishes the intended recurrence/duplicate distinction. No retransmission should invoke a model or create another occurrence, report or charge.", "",
    ]
    for case_id, source_row, disposition, anchors, incident, basis, concern in CASES:
        target = rows[source_row]
        eligible = [r for r in rows[:source_row] if r["end"] <= target["start"]]
        eligible_ids = {r["source_row"] for r in eligible}
        if not set(anchors) <= eligible_ids:
            raise ValueError(f"ineligible reference anchor for {case_id}")
        history = [{"pattern_id": f"P{r['source_row'] + 1:03}", "source_row": r["source_row"],
                    "date": r["date"], "incident": r["incident"], "rule": r["rule"]} for r in eligible]
        record = {"case_id": case_id, "incident": incident,
                  "history_policy": "earlier source position and date interval ending no later than incident start date; same-day ordering is synthetic",
                  "history": history}
        file = inputs / f"{case_id}.json"
        file.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        input_index.append({"case_id": case_id, "file": f"inputs/{case_id}.json",
                            "sha256": hashlib.sha256(file.read_bytes()).hexdigest(), "history_count": len(history)})
        case_rows.append({"case_id": case_id, "event_id": f"E{case_id[1:]}",
                          "occurrence_id": f"O{case_id[1:]}", "source_row": source_row,
                          "source_date": target["date"], "history_count": len(history),
                          "input_path": f"inputs/{case_id}.json", "retransmission_of": ""})
        ref_rows.append({"case_id": case_id, "proposed_disposition": disposition,
                         "acceptable_pattern_anchors": ";".join(f"P{x + 1:03}" for x in anchors),
                         "basis": basis, "review_issue": concern, "reviewer": "", "approved_at": ""})
        review.extend([f"## {case_id} — source row {source_row} ({target['date']})", "",
                       f"**Proposed:** {disposition}; acceptable anchors: " + (", ".join(f"P{x + 1:03}" for x in anchors) or "none") + f". **Eligible history:** {len(history)} rows.", "",
                       f"**Evaluator incident:** {incident}", "",
                       f"**Source violation:** {target['incident']}", "",
                       f"**Source rule:** {target['rule']}", "",
                       f"**Basis:** {basis}", "", f"**Review:** {concern}", ""])
        for anchor in anchors:
            r = rows[anchor]
            review.extend([f"**P{anchor + 1:03}, source row {anchor} ({r['date']}):** {r['incident']} Rule: {r['rule']}", ""])
    for n, original in enumerate(("C01", "C02", "C07", "C14"), start=1):
        source = next(row for row in case_rows if row["case_id"] == original)
        case_rows.append(dict(source, event_id=f"R{n:02}", retransmission_of=source["event_id"]))
    write_csv(ROOT / "cases.csv", ["case_id", "event_id", "occurrence_id", "source_row", "source_date", "history_count", "input_path", "retransmission_of"], case_rows)
    write_csv(ROOT / "reference.csv", ["case_id", "proposed_disposition", "acceptable_pattern_anchors", "basis", "review_issue", "reviewer", "approved_at"], ref_rows)
    manifest = {"status": "provisional_not_approved", "source_sha256": EXPECTED_HASH,
                "source_issue": "https://github.com/NobleFactor/noblefactor-engprod/issues/317",
                "history_rule": "Earlier source position; source date range ends no later than case start date. Equal-date positions are synthetic and not proven historical order.",
                "pattern_id_rule": "P plus one-based source row: each is a historical anchor, not a deduplicated equivalence class.",
                "distinct_cases": len(CASES), "retransmissions": 4, "model_evaluations": 0,
                "inputs": input_index}
    (ROOT / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (ROOT / "review.md").write_text("\n".join(review), encoding="utf-8")


if __name__ == "__main__":
    main()
