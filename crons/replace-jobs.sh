#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${1:-crons/cron-jobs.json}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi
if ! command -v openclaw >/dev/null 2>&1; then
  echo "openclaw is required" >&2
  exit 1
fi

echo "Fetching existing cron jobs..."
python3 - <<'PY'
import json
import subprocess

out = subprocess.check_output(["openclaw", "cron", "list", "--json"], text=True)
jobs = json.loads(out).get("jobs", [])
if jobs:
    print("Removing existing cron jobs...")
    for job in jobs:
        jid = job.get("id")
        if not jid:
            continue
        subprocess.run(["openclaw", "cron", "rm", jid], check=True, stdout=subprocess.DEVNULL)
        print(f"Removed: {jid}")
else:
    print("No existing cron jobs to remove.")
PY

echo "Importing replacement cron jobs from $INPUT_FILE"
bash crons/import-jobs.sh "$INPUT_FILE"

echo "Done."
