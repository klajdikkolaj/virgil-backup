#!/usr/bin/env bash
set -euo pipefail

LIVE_CONFIG="${1:-$HOME/.openclaw/openclaw.json}"

if [ ! -f "$LIVE_CONFIG" ]; then
  echo "Live config not found: $LIVE_CONFIG" >&2
  exit 1
fi

backup_path="${LIVE_CONFIG}.bak.$(date +%Y%m%d-%H%M%S)"
cp "$LIVE_CONFIG" "$backup_path"

tmp=$(mktemp)
jq '
  .meta.lastTouchedVersion = "2026.3.7" |
  .meta.lastTouchedAt = "2026-03-07T12:00:00.000Z" |
  .agents.defaults.thinkingDefault = "low" |
  .hooks.internal.entries["bootstrap-extra-files"].enabled = false |
  .hooks.internal.entries["boot-md"].enabled = false |
  .hooks.internal.entries["session-memory"].enabled = true |
  .hooks.internal.entries["session-memory"].autoWriteOnCompaction = true |
  .assistantFileSettings = {
    bootstrapMaxChars: 5000,
    bootstrapTotalMaxChars: 20000
  } |
  .contextPruning = {
    enabled: true,
    maxHistoryMessages: 120,
    strategy: "summary",
    minMessagesBeforePrune: 80,
    preserveSystemMessages: true
  } |
  .compaction = {
    enabled: true,
    targetPromptTokens: 35000,
    reserveOutputTokens: 6000,
    triggerEveryTurns: 12,
    triggerOnEstimatedPromptTokens: 70000,
    summaryStyle: "structured",
    includeToolCallDigest: true,
    persistPath: "memory/compactions"
  }
' "$LIVE_CONFIG" > "$tmp"

mv "$tmp" "$LIVE_CONFIG"

jq empty "$LIVE_CONFIG"

echo "Applied optimizations to: $LIVE_CONFIG"
echo "Backup saved at: $backup_path"
