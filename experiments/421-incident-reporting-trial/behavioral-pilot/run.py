#!/usr/bin/env python3
"""Run the Owner-authorized behavioral pair once within the weekly stop point."""
import argparse
import datetime
import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "run-output"
PREVIOUS = ROOT.parent / "calibration/c02-comparison/run.py"


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def save(path, value):
    path.write_text(json.dumps(value, indent=2) + "\n")


def load_frozen():
    frozen = json.loads((ROOT / "frozen-inputs.json").read_text())
    contents = {}
    for name, digest in frozen["files"].items():
        contents[name] = (ROOT / name).read_bytes()
        if hashlib.sha256(contents[name]).hexdigest() != digest:
            raise ValueError(f"Frozen input changed: {name}")
    return frozen, contents


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--execute", action="store_true", help="Execute the Owner-authorized pair; uses subscription allowance.")
    args = parser.parse_args()
    if not args.execute:
        parser.error("No evaluation started. Use --execute only after the revised phase is authorized.")

    all_started = time.monotonic()
    frozen, contents = load_frozen()
    if OUT.exists():
        raise FileExistsError("Existing run-output prevents automatic replay; inspect it before proceeding.")
    sys.dont_write_bytecode = True
    spec = importlib.util.spec_from_file_location("calibration_runner", PREVIOUS)
    previous = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(previous)
    settings = [setting for setting in previous.PROVIDER_CONFIG if not setting.startswith(("features.shell_tool=", "features.unified_exec="))]
    settings.extend(["features.shell_tool=true", "features.unified_exec=true"])
    if settings != frozen["settings"]:
        raise ValueError("Requested settings differ from the frozen comparison")
    # A startup failure before any evaluator invocation must not masquerade as
    # a behavioral run or require deleting the durable no-replay guard.
    initial = None
    try:
        initial = previous.meter()
        previous.check(initial)
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        attempts = ROOT / "execution-attempts"
        attempts.mkdir(exist_ok=True)
        report = {"captured_at": now(), "status": "execution_boundary",
                  "stage": "live_meter_before_any_evaluator", "cli_evaluator_invocations": 0,
                  "initial_meter": initial,
                  "error": str(error), "stderr": getattr(error, "stderr", None),
                  "observed_seconds": time.monotonic() - all_started}
        destination = attempts / (now().replace(":", "") + ".json")
        save(destination, report)
        print(json.dumps(report, indent=2))
        return 1
    # Existing output is a persistent guard against automatic replay.
    OUT.mkdir(mode=0o700)
    run = {"started_at": now(), "status": "running", "model_requested": "gpt-6.1-sol",
           "reasoning_effort": "low", "config": settings, "arm_order": ["usual", "lesson-assisted"],
           "frozen_manifest_sha256": hashlib.sha256((ROOT / "frozen-inputs.json").read_bytes()).hexdigest(),
           "input_sha256": frozen["files"], "initial_meter": initial,
           "weekly_baseline": 3, "stop_percent": 4, "window_reset": previous.WINDOW_RESET,
           "arms": [], "stop_reason": None,
           "limits": "Supplied-lesson behavior test, not autonomous retrieval or production compliance. Provider requests/retries and actual served model are not independently observed. Human active time is not inferred from elapsed time."}
    save(OUT / "run.json", run)
    # Prepare both independent starting copies before either model runs.
    for arm in run["arm_order"]:
        arm_dir = OUT / arm
        workspace = arm_dir / "workspace"
        workspace.mkdir(parents=True)
        (workspace / "install.ps1").write_bytes(contents["fixture/install.ps1"])
        prompt = contents["task.md"].decode()
        if arm == "lesson-assisted":
            prompt += "\n\n" + contents["lesson.md"].decode()
        (arm_dir / "prompt.txt").write_text(prompt)
    for arm in run["arm_order"]:
        arm_dir = OUT / arm
        workspace = arm_dir / "workspace"
        prompt = (arm_dir / "prompt.txt").read_text()
        record = {"arm": arm, "cli_invocations": 0, "status": "prepared"}
        run["arms"].append(record)
        save(OUT / "run.json", run)
        arm_started = time.monotonic()
        try:
            load_frozen()
            if (workspace / "install.ps1").read_bytes() != contents["fixture/install.ps1"]:
                raise ValueError("Starting fixture changed before evaluator invocation")
            expected_prompt = contents["task.md"].decode()
            if arm == "lesson-assisted":
                expected_prompt += "\n\n" + contents["lesson.md"].decode()
            if prompt != expected_prompt:
                raise ValueError("Prepared prompt differs from frozen matched inputs")
            before = previous.meter()
            save(arm_dir / "meter-before.json", before)
            previous.check(before)
        except (OSError, ValueError, subprocess.SubprocessError) as error:
            run["stop_reason"] = f"{arm}: execution/budget boundary before invocation: {error}"
            break

        cmd = ["codex", "exec", "--json", "--ephemeral", "--ignore-user-config",
               "--sandbox", "workspace-write", "--model", "gpt-6.1-sol", "--cd", str(workspace),
               "--skip-git-repo-check", "--config", 'approval_policy="never"']
        for setting in settings:
            cmd.extend(["--config", setting])
        cmd.append("-")
        record.update(cli_invocations=1, started_at=now(), status="attempted")
        save(OUT / "run.json", run)
        model_started = time.monotonic()
        try:
            with (arm_dir / "events.jsonl").open("x") as output, (arm_dir / "stderr.txt").open("x") as errors:
                completed = subprocess.run(cmd, input=prompt, text=True, stdout=output, stderr=errors, timeout=120)
            record["exit_code"] = completed.returncode
            if completed.returncode:
                run["stop_reason"] = f"{arm}: CLI failed; preserve attempt, do not retry"
        except (OSError, subprocess.SubprocessError) as error:
            record["process_error"] = str(error)
            run["stop_reason"] = f"{arm}: CLI execution failed; preserve attempt, do not retry"
        finally:
            record["cli_elapsed_seconds"] = time.monotonic() - model_started
            try:
                after = previous.meter()
                save(arm_dir / "meter-after.json", after)
                previous.check(after)
            except (OSError, ValueError, subprocess.SubprocessError) as error:
                run["stop_reason"] = f"{arm}: execution/budget boundary after invocation: {error}"

        events = []
        try:
            for line in (arm_dir / "events.jsonl").read_text().splitlines():
                events.append(json.loads(line))
        except (OSError, ValueError) as error:
            record["telemetry_error"] = str(error)
        turns = [e for e in events if e.get("type") == "turn.completed"]
        items = [e.get("item", {}) for e in events if e.get("type") == "item.completed"]
        record["visible_completed_turns"] = len(turns)
        record["reported_usage_events"] = [e.get("usage") for e in turns]
        record["completed_item_types"] = [item.get("type") for item in items]
        final = "\n\n".join(item.get("text", "") for item in items if item.get("type") == "agent_message")
        (arm_dir / "final-response.md").write_text(final)
        record["usage_attribution"] = "one observed CLI invocation; inspect raw events before summing or inferring provider calls"
        try:
            check = subprocess.run(["pwsh", "-NoLogo", "-NoProfile", "-NonInteractive", "-File",
                                    str(ROOT / "check-syntax.ps1"), "-Path", str(workspace / "install.ps1")],
                                   capture_output=True, text=True, timeout=20)
            record["artifact_check"] = {"exit_code": check.returncode, "stdout": check.stdout, "stderr": check.stderr}
        except (OSError, subprocess.SubprocessError) as error:
            record["artifact_check"] = {"error": str(error)}
        record["execution_marker_present"] = (workspace / "installer-executed.txt").exists()
        record["trace_review"] = "pending: inspect attempted execution, commands outside task, and support for final claims; marker absence is not sufficient"
        record["status"] = "captured"
        record["observed_elapsed_seconds"] = time.monotonic() - arm_started
        save(OUT / "run.json", run)
        if run["stop_reason"]:
            break
    run.update(finished_at=now(), observed_total_seconds=time.monotonic() - all_started,
               status="stopped" if run["stop_reason"] else "captured_pending_review")
    save(OUT / "run.json", run)
    print(json.dumps(run, indent=2))
    return 1 if run["stop_reason"] else 0


if __name__ == "__main__":
    sys.exit(main())
