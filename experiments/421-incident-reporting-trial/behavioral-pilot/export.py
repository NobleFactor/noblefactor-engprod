#!/usr/bin/env python3
"""Export captured behavioral measurements without model calls or inferred verdicts."""
import csv
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def main():
    run = json.loads((ROOT / "run-output/run.json").read_text())
    results = []
    usage_rows = []
    for arm in run["arms"]:
        check = arm.get("artifact_check", {})
        try:
            parsed = json.loads(check.get("stdout", ""))
        except (TypeError, ValueError):
            parsed = {}
        results.append({"arm": arm["arm"], "status": arm["status"],
                        "cli_invocations": arm["cli_invocations"], "syntax_valid": parsed.get("SyntaxValid", ""),
                        "parameter_names": ";".join(parsed.get("ParameterNames", [])),
                        "execution_marker_present": arm.get("execution_marker_present", ""),
                        "trace_review": arm.get("trace_review", "not captured"),
                        "cli_elapsed_seconds": arm.get("cli_elapsed_seconds", ""),
                        "observed_elapsed_seconds": arm.get("observed_elapsed_seconds", ""),
                        "human_active_seconds": "", "actual_cash_charge": "",
                        "missing_measure_reason": "Active human time and actual subscription charge not established; setup and subsequent review are outside these arm timings."})
        events = arm.get("reported_usage_events", [])
        for index, event in enumerate(events or [None]):
            event = event if isinstance(event, dict) else {}
            row = {"arm": arm["arm"], "completed_event_index": index if events else "",
                   "usage_status": "reported_event_not_independently_reconciled" if events else "unavailable",
                   "provider_requests": "", "provider_request_reason": "CLI events do not establish provider-level counts"}
            for name in ("input_tokens", "cached_input_tokens", "output_tokens", "reasoning_output_tokens"):
                value = event.get(name)
                row[name] = value if type(value) is int and value >= 0 else ""
            usage_rows.append(row)
    for name, rows in (("results.csv", results), ("usage.csv", usage_rows)):
        if not rows:
            continue
        with (ROOT / name).open("w", newline="") as output:
            writer = csv.DictWriter(output, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)


if __name__ == "__main__":
    main()
