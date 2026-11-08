#!/usr/bin/env python3
"""Read the Codex account's rate-limit snapshot without starting a model turn."""
import json
import selectors
import subprocess
import sys
import time


def main():
    process = subprocess.Popen(
        ["codex", "app-server", "--listen", "stdio://"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
        text=True, bufsize=1,
    )
    selector = selectors.DefaultSelector()
    selector.register(process.stdout, selectors.EVENT_READ)

    def send(message):
        process.stdin.write(json.dumps(message) + "\n")
        process.stdin.flush()

    def receive(request_id):
        deadline = time.monotonic() + 20
        while time.monotonic() < deadline:
            if not selector.select(max(0, deadline - time.monotonic())):
                break
            line = process.stdout.readline()
            if not line:
                raise RuntimeError("app server exited before responding")
            message = json.loads(line)
            if message.get("id") == request_id:
                if "error" in message:
                    raise RuntimeError("app server returned an error: " + str(message["error"]))
                return message["result"]
        raise RuntimeError("app server response timed out")

    try:
        send({"id": 1, "method": "initialize", "params": {"clientInfo": {"name": "incident-421-meter", "version": "1"}}})
        receive(1)
        send({"method": "initialized"})
        send({"id": 2, "method": "account/rateLimits/read"})
        result = receive(2)
        # Do not persist account identifiers or other unrelated account details.
        print(json.dumps({key: result.get(key) for key in ("rateLimits", "rateLimitsByLimitId", "ordinaryUsageAllowed")}, indent=2))
    finally:
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, BrokenPipeError, OSError, json.JSONDecodeError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
