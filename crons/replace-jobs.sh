#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${1:-crons/cron-jobs.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if ! command -v openclaw >/dev/null 2>&1; then
  echo "openclaw is required" >&2
  exit 1
fi

echo "Fetching existing cron jobs..."
existing_ids=$(openclaw cron list --json | jq -r '.jobs[]?.id')

if [ -n "$existing_ids" ]; then
  echo "Removing existing cron jobs..."
  while IFS= read -r id; do
    [ -z "$id" ] && continue
    openclaw cron rm "$id" >/dev/null
    echo "Removed: $id"
  done <<< "$existing_ids"
else
  echo "No existing cron jobs to remove."
fi

echo "Importing replacement cron jobs from $INPUT_FILE"
bash crons/import-jobs.sh "$INPUT_FILE"

echo "Done."
