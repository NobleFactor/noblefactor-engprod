#!/usr/bin/env python3
"""One Owner-directed C02 comparison, with a guarded meter around each arm."""
import datetime
import hashlib
import json
import pathlib
import subprocess
import sys
import tempfile
import time

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "run-output"
METER = ROOT.parent / "read_usage.py"
WINDOW_RESET = 1793805961
PROVIDER_CONFIG = [
    'model_provider="incident_trial"',
    'model_providers.incident_trial.name="OpenAI"',
    'model_providers.incident_trial.requires_openai_auth=true',
    'model_providers.incident_trial.request_max_retries=0',
    'model_providers.incident_trial.stream_max_retries=0',
    'model_providers.incident_trial.supports_websockets=false',
    'features.shell_tool=false', 'features.unified_exec=false',
    'web_search="disabled"', 'model_reasoning_effort="low"',
]


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def save(path, obj):
    path.write_text(json.dumps(obj, indent=2) + "\n")


def meter():
    result = subprocess.run([sys.executable, str(METER)], capture_output=True, text=True, check=True, timeout=35)
    snapshot = json.loads(result.stdout)
    limits = snapshot.get("rateLimits") or {}
    windows = [w for w in (limits.get("primary"), limits.get("secondary")) if w and w.get("windowDurationMins") == 10080]
    if len(windows) != 1 or type(windows[0].get("usedPercent")) is not int:
        raise ValueError("weekly meter unavailable or ambiguous")
    return {"captured_at": now(), "snapshot": snapshot, "weekly_window": windows[0]}


def check(snapshot):
    window = snapshot["weekly_window"]
    limits = snapshot["snapshot"]["rateLimits"]
    credits = limits.get("credits") or {}
    if window.get("resetsAt") != WINDOW_RESET or window["usedPercent"] != 3:
        raise ValueError("weekly window changed, became ambiguous, or reached the 4% stop point")
    if (snapshot["snapshot"].get("ordinaryUsageAllowed") is not True
            or credits.get("hasCredits") is not False or credits.get("unlimited") is not False
            or credits.get("balance") != "0"):
        raise ValueError("included usage or zero-credit state not confirmed")


def run():
    # A pre-existing directory is a durable guard against automatic reruns.
    OUT.mkdir(mode=0o700)
    preparation = json.loads((ROOT / "preparation.json").read_text())
    for name, digest in preparation["prompt_sha256"].items():
        if hashlib.sha256((ROOT / f"{name}-prompt.txt").read_bytes()).hexdigest() != digest:
            raise ValueError("prepared prompt changed")
    if hashlib.sha256((ROOT / "output-schema.json").read_bytes()).hexdigest() != preparation["schema_sha256"]:
        raise ValueError("prepared schema changed")
    result = {"case_id": "C02", "started_at": now(), "model_requested": "gpt-6.1-sol",
              "model_actual": "not reported by CLI event stream", "reasoning_effort": "low",
              "provider": "ChatGPT-authenticated custom OpenAI provider, HTTP streaming",
              "provider_config": PROVIDER_CONFIG, "arms": [], "stop_reason": None,
              "provider_request_count": "not observable in CLI event stream",
              "note": "No application retries; provider HTTP and stream retry settings set to zero. Other hidden retry or request behavior is not independently established."}
    save(OUT / "run.json", result)
    for arm in preparation["arm_order"]:
        record = {"arm": arm, "cli_invocations": 0}
        result["arms"].append(record)
        arm_dir = OUT / arm
        arm_dir.mkdir()
        try:
            before = meter()
            save(arm_dir / "meter-before.json", before)
            check(before)
        except (OSError, ValueError, subprocess.SubprocessError) as error:
            result["stop_reason"] = f"{arm}: before meter or credit check: {error}"
            break
        workdir = tempfile.mkdtemp(prefix=f"incident-421-{arm}-", dir="/tmp")
        cmd = ["codex", "exec", "--json", "--ephemeral", "--ignore-user-config", "--sandbox", "read-only",
               "--model", "gpt-6.1-sol", "--cd", workdir, "--skip-git-repo-check", "--output-schema", str(ROOT / "output-schema.json")]
        for setting in PROVIDER_CONFIG:
            cmd.extend(["--config", setting])
        cmd.append((ROOT / f"{arm}-prompt.txt").read_text())
        record.update(cli_invocations=1, started_at=now())
        save(OUT / "run.json", result)
        start = time.monotonic()
        try:
            with (arm_dir / "events.jsonl").open("x") as output, (arm_dir / "stderr.txt").open("x") as error_log:
                completed = subprocess.run(cmd, stdin=subprocess.DEVNULL, stdout=output, stderr=error_log, timeout=120)
            record["exit_code"] = completed.returncode
        except (OSError, subprocess.SubprocessError) as error:
            record["process_error"] = str(error)
        finally:
            record["model_seconds"] = round(time.monotonic() - start, 3)
            record["process_finished_at"] = now()
            try:
                after = meter()
                save(arm_dir / "meter-after.json", after)
                check(after)
            except (OSError, ValueError, subprocess.SubprocessError) as error:
                result["stop_reason"] = f"{arm}: after meter or credit check: {error}"
        validation_start = time.monotonic()
        try:
            events = [json.loads(line) for line in (arm_dir / "events.jsonl").read_text().splitlines()]
            completed_events = [e for e in events if e.get("type") == "turn.completed"]
            messages = [e["item"]["text"] for e in events if e.get("type") == "item.completed" and e.get("item", {}).get("type") == "agent_message"]
            tools = [e for e in events if e.get("type", "").startswith("item.") and e.get("item", {}).get("type") not in ("agent_message", "reasoning")]
            if record.get("exit_code") != 0 or len(completed_events) != 1 or len(messages) != 1 or tools:
                raise ValueError("failed process, missing/duplicate turn or message, or visible tool use")
            usage = completed_events[0].get("usage")
            answer = json.loads(messages[0])
            required_counts = ("input_tokens", "cached_input_tokens", "output_tokens", "reasoning_output_tokens")
            if (not isinstance(usage, dict) or any(type(usage.get(k)) is not int or usage[k] < 0 for k in required_counts)
                    or usage["input_tokens"] == 0 or usage["cached_input_tokens"] > usage["input_tokens"]
                    or usage["reasoning_output_tokens"] > usage["output_tokens"]):
                raise ValueError("missing or inconsistent usage")
            if (not isinstance(answer, dict) or set(answer) != {"disposition", "pattern_id", "evidence", "reason"}
                    or answer["disposition"] not in ("existing", "new", "escalate")
                    or not isinstance(answer["reason"], str) or not isinstance(answer["evidence"], list)
                    or any(not isinstance(item, str) for item in answer["evidence"])):
                raise ValueError("missing usage or invalid answer")
            allowed = set(preparation["eligible_history_ids"] if arm == "full-history" else (p["pattern_id"] for p in preparation["indexed_ranking"]))
            if (answer["disposition"] == "existing" and answer["pattern_id"] not in allowed) or (answer["disposition"] != "existing" and answer["pattern_id"] is not None):
                raise ValueError("answer refers to an unavailable pattern or violates the output contract")
            if any(item not in allowed for item in answer["evidence"]):
                raise ValueError("evidence references an unavailable pattern")
            record.update(usage=usage, answer=answer, visible_turns=1, visible_tool_items=0)
            save(arm_dir / "answer.json", answer)
        except (OSError, ValueError, KeyError, TypeError, json.JSONDecodeError) as error:
            result["stop_reason"] = result["stop_reason"] or f"{arm}: output/usage validation failed: {error}"
        record["validation_seconds"] = round(time.monotonic() - validation_start, 3)
        save(OUT / "run.json", result)
        if result["stop_reason"]:
            break
    result["finished_at"] = now()
    save(OUT / "run.json", result)
    print(json.dumps(result, indent=2))
    return 0 if len(result["arms"]) == 2 and not result["stop_reason"] else 1


if __name__ == "__main__":
    sys.exit(run())
