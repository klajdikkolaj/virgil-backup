#!/usr/bin/env python3
import argparse
import json
import subprocess
from datetime import datetime, timezone


def run_json(cmd):
    out = subprocess.check_output(cmd, text=True)
    return json.loads(out)


def main():
    ap = argparse.ArgumentParser(description="Disable failing OpenClaw cron jobs after N consecutive errors.")
    ap.add_argument("--threshold", type=int, default=3, help="Consecutive error threshold")
    ap.add_argument("--apply", action="store_true", help="Actually disable jobs (default is dry-run)")
    args = ap.parse_args()

    data = run_json(["openclaw", "cron", "list", "--json"])
    jobs = data.get("jobs", [])

    candidates = []
    for job in jobs:
        if not job.get("enabled", True):
            continue
        state = job.get("state", {}) or {}
        errors = state.get("consecutiveErrors")
        if isinstance(errors, int) and errors >= args.threshold:
            candidates.append(
                {
                    "id": job.get("id"),
                    "name": job.get("name"),
                    "consecutiveErrors": errors,
                    "lastStatus": state.get("lastStatus"),
                }
            )

    disabled = []
    if args.apply:
        for c in candidates:
            if c.get("id"):
                subprocess.run(["openclaw", "cron", "disable", c["id"]], check=True)
                disabled.append(c)

    summary = {
        "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "threshold": args.threshold,
        "apply": args.apply,
        "totalJobs": len(jobs),
        "candidates": candidates,
        "disabled": disabled,
        "status": "disabled" if args.apply and disabled else ("dry-run" if not args.apply else "no-action"),
    }

    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
