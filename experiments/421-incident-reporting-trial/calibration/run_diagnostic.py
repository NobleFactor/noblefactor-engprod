#!/usr/bin/env python3
"""Run the Owner-authorized single diagnostic CLI turn, with meter snapshots."""
import datetime
import json
import pathlib
import subprocess
import sys
import tempfile
import time

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "diagnostic-output"
MODEL = "gpt-6.1-sol"


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def snapshot():
    read = subprocess.run([sys.executable, str(ROOT / "read_usage.py")],
                          capture_output=True, text=True, timeout=35, check=True)
    result = json.loads(read.stdout)
    limits = result.get("rateLimits") or {}
    windows = [w for w in (limits.get("primary"), limits.get("secondary"))
               if w and w.get("windowDurationMins") == 10080]
    if len(windows) != 1 or type(windows[0].get("usedPercent")) is not int:
        raise ValueError("weekly meter is unavailable or ambiguous")
    if windows[0].get("resetsAt") is None:
        raise ValueError("weekly reset time is unavailable")
    return {"captured_at": now(), "snapshot": result}


def save(name, data):
    (OUT / name).write_text(json.dumps(data, indent=2) + "\n")


def main():
    # Refuse any repeated attempt, including after a failure or interruption.
    OUT.mkdir(mode=0o700)
    workdir = tempfile.mkdtemp(prefix="incident-421-diagnostic-", dir="/tmp")
    metadata = {"kind": "unscored_diagnostic", "model_requested": MODEL,
                "cli_invocations": 0, "provider_request_count": "unknown",
                "prompt": "Reply with exactly OK. Do not use tools.",
                "created_at": now(), "result": "not_started"}
    save("metadata.json", metadata)
    try:
        before = snapshot()
        save("meter-before.json", before)
        limits = before["snapshot"]["rateLimits"]
        credits = limits.get("credits") or {}
        if (before["snapshot"].get("ordinaryUsageAllowed") is not True
                or credits.get("hasCredits") is not False
                or credits.get("unlimited") is not False
                or credits.get("balance") != "0"):
            raise ValueError("included usage or zero-credit state is not confirmed")
    except (subprocess.SubprocessError, ValueError, OSError) as error:
        metadata.update(result="stopped_before_model", reason=str(error), finished_at=now())
        save("metadata.json", metadata)
        return 1

    command = ["codex", "exec", "--json", "--ephemeral", "--sandbox", "read-only",
               "--model", MODEL, "--cd", workdir, "--skip-git-repo-check", metadata["prompt"]]
    metadata.update(cli_invocations=1, started_at=now(), result="attempted")
    save("metadata.json", metadata)
    started = time.monotonic()
    try:
        with (OUT / "events.jsonl").open("x") as stdout, (OUT / "stderr.txt").open("x") as stderr:
            completed = subprocess.run(command, stdout=stdout, stderr=stderr, timeout=120)
        metadata.update(exit_code=completed.returncode, result="completed_process")
    except (subprocess.SubprocessError, OSError) as error:
        metadata.update(result="process_error", reason=str(error))
    finally:
        metadata["elapsed_seconds"] = round(time.monotonic() - started, 3)
        metadata["process_finished_at"] = now()
        try:
            after = snapshot()
            save("meter-after.json", after)
            before_window = next(w for w in (before["snapshot"]["rateLimits"].get("primary"), before["snapshot"]["rateLimits"].get("secondary")) if w and w.get("windowDurationMins") == 10080)
            after_window = next(w for w in (after["snapshot"]["rateLimits"].get("primary"), after["snapshot"]["rateLimits"].get("secondary")) if w and w.get("windowDurationMins") == 10080)
            metadata["weekly_increase_points"] = after_window["usedPercent"] - before_window["usedPercent"]
            metadata["reset_unchanged"] = before_window["resetsAt"] == after_window["resetsAt"]
            metadata["stop"] = (not metadata["reset_unchanged"] or metadata["weekly_increase_points"] < 0 or metadata["weekly_increase_points"] >= 1)
        except (subprocess.SubprocessError, ValueError, OSError) as error:
            metadata.update(stop=True, meter_after_error=str(error))
        metadata["finished_at"] = now()
        save("metadata.json", metadata)
    print(json.dumps(metadata, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
