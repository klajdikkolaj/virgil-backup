#!/usr/bin/env bash
set -euo pipefail

INPUT_FILE="${1:-crons/cron-jobs.json}"
DRY_RUN="${DRY_RUN:-0}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
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

ms_to_duration() {
  local ms="$1"
  if [ "$ms" -eq 0 ]; then
    echo "0s"
  elif [ $((ms % 3600000)) -eq 0 ]; then
    echo "$((ms / 3600000))h"
  elif [ $((ms % 60000)) -eq 0 ]; then
    echo "$((ms / 60000))m"
  elif [ $((ms % 1000)) -eq 0 ]; then
    echo "$((ms / 1000))s"
  else
    echo "${ms}ms"
  fi
}

run_cmd() {
  if [ "$DRY_RUN" = "1" ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

count=0

while IFS= read -r row; do
  job_json=$(printf '%s' "$row" | base64 --decode)

  kind=$(jq -r '.payload.kind // ""' <<<"$job_json")
  if [ "$kind" != "agentTurn" ]; then
    echo "Skipping non-agentTurn job: $(jq -r '.name' <<<"$job_json")"
    continue
  fi

  cmd=(openclaw cron add)

  name=$(jq -r '.name // empty' <<<"$job_json")
  [ -n "$name" ] && cmd+=(--name "$name")

  description=$(jq -r '.description // empty' <<<"$job_json")
  [ -n "$description" ] && cmd+=(--description "$description")

  enabled=$(jq -r 'if has("enabled") then (.enabled | tostring) else "true" end' <<<"$job_json")
  [ "$enabled" = "false" ] && cmd+=(--disabled)

  agent_id=$(jq -r '.agentId // empty' <<<"$job_json")
  [ -n "$agent_id" ] && cmd+=(--agent "$agent_id")

  session_target=$(jq -r '.sessionTarget // empty' <<<"$job_json")
  [ -n "$session_target" ] && cmd+=(--session "$session_target")

  session_key=$(jq -r '.sessionKey // empty' <<<"$job_json")
  [ -n "$session_key" ] && cmd+=(--session-key "$session_key")

  wake_mode=$(jq -r '.wakeMode // empty' <<<"$job_json")
  [ -n "$wake_mode" ] && cmd+=(--wake "$wake_mode")

  schedule_kind=$(jq -r '.schedule.kind // ""' <<<"$job_json")
  case "$schedule_kind" in
    cron)
      cron_expr=$(jq -r '.schedule.expr // empty' <<<"$job_json")
      [ -n "$cron_expr" ] && cmd+=(--cron "$cron_expr")
      tz=$(jq -r '.schedule.tz // empty' <<<"$job_json")
      [ -n "$tz" ] && cmd+=(--tz "$tz")
      stagger_ms=$(jq -r '.schedule.staggerMs // empty' <<<"$job_json")
      if [ -n "$stagger_ms" ] && [ "$stagger_ms" != "null" ]; then
        if [ "$stagger_ms" = "0" ]; then
          cmd+=(--exact)
        else
          cmd+=(--stagger "$(ms_to_duration "$stagger_ms")")
        fi
      fi
      ;;
    every)
      every_ms=$(jq -r '.schedule.everyMs // empty' <<<"$job_json")
      [ -n "$every_ms" ] && [ "$every_ms" != "null" ] && cmd+=(--every "$(ms_to_duration "$every_ms")")
      ;;
    *)
      echo "Skipping unsupported schedule kind '$schedule_kind' for job: $name"
      continue
      ;;
  esac

  message=$(jq -r '.payload.message // empty' <<<"$job_json")
  [ -n "$message" ] && cmd+=(--message "$message")

  model=$(jq -r '.payload.model // empty' <<<"$job_json")
  [ -n "$model" ] && cmd+=(--model "$model")

  thinking=$(jq -r '.payload.thinking // empty' <<<"$job_json")
  [ -n "$thinking" ] && cmd+=(--thinking "$thinking")

  timeout_seconds=$(jq -r '.payload.timeoutSeconds // empty' <<<"$job_json")
  [ -n "$timeout_seconds" ] && [ "$timeout_seconds" != "null" ] && cmd+=(--timeout-seconds "$timeout_seconds")

  delivery_mode=$(jq -r '.delivery.mode // empty' <<<"$job_json")
  if [ "$delivery_mode" = "announce" ]; then
    cmd+=(--announce)
    channel=$(jq -r '.delivery.channel // empty' <<<"$job_json")
    [ -n "$channel" ] && cmd+=(--channel "$channel")
    to=$(jq -r '.delivery.to // empty' <<<"$job_json")
    [ -n "$to" ] && cmd+=(--to "$to")
  else
    cmd+=(--no-deliver)
  fi

  run_cmd "${cmd[@]}"
  count=$((count + 1))
done < <(jq -r '.jobs[] | @base64' "$INPUT_FILE")

echo "Imported/created $count jobs from $INPUT_FILE"
