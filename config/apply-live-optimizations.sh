#!/usr/bin/env bash
set -euo pipefail

LIVE_CONFIG="${1:-$HOME/.openclaw/openclaw.json}"

if [ ! -f "$LIVE_CONFIG" ]; then
  echo "Live config not found: $LIVE_CONFIG" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required" >&2
  exit 1
fi

python3 - "$LIVE_CONFIG" <<'PY'
import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path

cfg_path = Path(sys.argv[1]).expanduser()
raw = json.loads(cfg_path.read_text())

backup_path = cfg_path.with_name(cfg_path.name + ".bak." + datetime.now().strftime("%Y%m%d-%H%M%S"))
shutil.copy2(cfg_path, backup_path)

raw.setdefault("meta", {})
raw["meta"]["lastTouchedVersion"] = "2026.3.7"
raw["meta"]["lastTouchedAt"] = datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")

agents = raw.setdefault("agents", {}).setdefault("defaults", {})
agents["thinkingDefault"] = "low"

entries = raw.setdefault("hooks", {}).setdefault("internal", {}).setdefault("entries", {})
entries.setdefault("session-memory", {})["enabled"] = True
entries["session-memory"]["autoWriteOnCompaction"] = True
entries.setdefault("bootstrap-extra-files", {})["enabled"] = False
entries.setdefault("boot-md", {})["enabled"] = False

# Not supported on OpenClaw 2026.3.2; ensure they are absent.
for key in ("assistantFileSettings", "contextPruning", "compaction"):
    raw.pop(key, None)

cfg_path.write_text(json.dumps(raw, indent=2) + "\n")
print(f"Applied compatible optimizations to: {cfg_path}")
print(f"Backup saved at: {backup_path}")
PY
