#!/usr/bin/env python3
"""Export the observed C02 CLI turn data without additional model calls."""
import csv
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "run-output"
run = json.loads((OUT / "run.json").read_text())
prep = json.loads((ROOT / "preparation.json").read_text())


def write(name, fields, rows):
    with (ROOT / name).open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


results, usage_rows = [], []
for row in run["arms"]:
    arm = row["arm"]
    folder = OUT / arm
    before = json.loads((folder / "meter-before.json").read_text())
    after = json.loads((folder / "meter-after.json").read_text())
    events = [json.loads(line) for line in (folder / "events.jsonl").read_text().splitlines()]
    thread_id = next(e["thread_id"] for e in events if e["type"] == "thread.started")
    answer, usage = row["answer"], row["usage"]
    results.append({"case_id": "C02", "arm": arm, "thread_id": thread_id,
                    "disposition": answer["disposition"], "pattern_id": answer["pattern_id"],
                    "evidence": ";".join(answer["evidence"]), "reason": answer["reason"],
                    "matches_owner_accepted_grouping": answer["disposition"] == "existing" and answer["pattern_id"] == "P006",
                    "cli_elapsed_seconds": row["model_seconds"],
                    "retrieval_computation_seconds": prep["retrieval_seconds"] if arm == "indexed" else "",
                    "validation_seconds_rounded": row["validation_seconds"],
                    "recording_seconds": "", "manual_review_seconds": ""})
    usage_rows.append({"case_id": "C02", "arm": arm, "thread_id": thread_id,
                       "model_requested": run["model_requested"], "model_served": "",
                       "input_tokens": usage["input_tokens"], "cached_input_tokens": usage["cached_input_tokens"],
                       "cache_write_input_tokens": usage.get("cache_write_input_tokens", ""),
                       "output_tokens": usage["output_tokens"], "reasoning_output_tokens": usage["reasoning_output_tokens"],
                       "weekly_before_percent": before["weekly_window"]["usedPercent"],
                       "weekly_after_percent": after["weekly_window"]["usedPercent"],
                       "window_resets_at": before["weekly_window"]["resetsAt"],
                       "actual_incremental_usd": "", "calculated_usd": "",
                       "cost_status": "Subscription; per-turn cash charge and applicable rate not established",
                       "provider_requests": "unknown"})

write("results.csv", ["case_id", "arm", "thread_id", "disposition", "pattern_id", "evidence", "reason", "matches_owner_accepted_grouping", "cli_elapsed_seconds", "retrieval_computation_seconds", "validation_seconds_rounded", "recording_seconds", "manual_review_seconds"], results)
write("usage.csv", ["case_id", "arm", "thread_id", "model_requested", "model_served", "input_tokens", "cached_input_tokens", "cache_write_input_tokens", "output_tokens", "reasoning_output_tokens", "weekly_before_percent", "weekly_after_percent", "window_resets_at", "actual_incremental_usd", "calculated_usd", "cost_status", "provider_requests"], usage_rows)
