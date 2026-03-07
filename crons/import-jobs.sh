#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${1:-crons/cron-jobs.json}"
DRY_RUN="${DRY_RUN:-0}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi
if ! command -v openclaw >/dev/null 2>&1; then
  echo "openclaw is required" >&2
  exit 1
fi
if [ ! -f "$INPUT_FILE" ]; then
  echo "Cron JSON not found: $INPUT_FILE" >&2
  exit 1
fi

python3 - "$INPUT_FILE" "$DRY_RUN" <<'PY'
import json
import shlex
import subprocess
import sys
from pathlib import Path

input_file = Path(sys.argv[1])
dry_run = sys.argv[2] == "1"

data = json.loads(input_file.read_text())

def ms_to_duration(ms: int) -> str:
    if ms == 0:
        return "0s"
    if ms % 3_600_000 == 0:
        return f"{ms // 3_600_000}h"
    if ms % 60_000 == 0:
        return f"{ms // 60_000}m"
    if ms % 1_000 == 0:
        return f"{ms // 1_000}s"
    return f"{ms}ms"

count = 0
for job in data.get("jobs", []):
    payload = job.get("payload", {})
    if payload.get("kind") != "agentTurn":
        print(f"Skipping non-agentTurn job: {job.get('name', '<unnamed>')}")
        continue

    cmd = ["openclaw", "cron", "add"]

    def add(flag, value):
        if value is None:
            return
        if isinstance(value, str) and value == "":
            return
        cmd.extend([flag, str(value)])

    add("--name", job.get("name"))
    add("--description", job.get("description"))

    if job.get("enabled", True) is False:
        cmd.append("--disabled")

    add("--agent", job.get("agentId"))
    add("--session", job.get("sessionTarget"))
    add("--session-key", job.get("sessionKey"))
    add("--wake", job.get("wakeMode"))

    schedule = job.get("schedule", {})
    kind = schedule.get("kind")
    if kind == "cron":
        add("--cron", schedule.get("expr"))
        add("--tz", schedule.get("tz"))
        stagger_ms = schedule.get("staggerMs")
        if stagger_ms is not None:
            if int(stagger_ms) == 0:
                cmd.append("--exact")
            else:
                add("--stagger", ms_to_duration(int(stagger_ms)))
    elif kind == "every":
        every_ms = schedule.get("everyMs")
        if every_ms is not None:
            add("--every", ms_to_duration(int(every_ms)))
    else:
        print(f"Skipping unsupported schedule kind '{kind}' for job: {job.get('name')}" )
        continue

    add("--message", payload.get("message"))
    add("--model", payload.get("model"))
    add("--thinking", payload.get("thinking"))
    if payload.get("timeoutSeconds") is not None:
        add("--timeout-seconds", int(payload.get("timeoutSeconds")))

    delivery = job.get("delivery", {})
    if delivery.get("mode") == "announce":
        cmd.append("--announce")
        add("--channel", delivery.get("channel"))
        add("--to", delivery.get("to"))
    else:
        cmd.append("--no-deliver")

    if dry_run:
        print("[dry-run] " + shlex.join(cmd))
    else:
        subprocess.run(cmd, check=True)

    count += 1

print(f"Imported/created {count} jobs from {input_file}")
PY
