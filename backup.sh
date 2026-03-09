#!/bin/bash
# Virgil Backup Script
set -euo pipefail

BACKUP_DIR="$HOME/virgil-backup"
WORKSPACE="$HOME/.openclaw/workspace"
OPENCLAW="$HOME/.openclaw"
DISCORD_CHANNEL="1477637814014316586"
DATE=$(date -u +"%Y-%m-%d")
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
ERRORS=()
CAN_PUSH=1

echo "🔒 Virgil Backup — $TIMESTAMP"

mkdir -p "$BACKUP_DIR/workspace/memory"
mkdir -p "$BACKUP_DIR/crons"
mkdir -p "$BACKUP_DIR/config"
mkdir -p "$BACKUP_DIR/skills-index"

# Workspace files
for f in SOUL.md MEMORY.md AGENTS.md USER.md IDENTITY.md HEARTBEAT.md TOOLS.md; do
  [ -f "$WORKSPACE/$f" ] && cp "$WORKSPACE/$f" "$BACKUP_DIR/workspace/" || true
done

# Memory directory
[ -d "$WORKSPACE/memory" ] && cp -r "$WORKSPACE/memory/." "$BACKUP_DIR/workspace/memory/" || ERRORS+=("Missing: memory/")

# Gateway config
[ -f "$OPENCLAW/openclaw.json" ] && cp "$OPENCLAW/openclaw.json" "$BACKUP_DIR/config/openclaw.json" || ERRORS+=("Missing: openclaw.json")

# Skills list
if [ -d "$WORKSPACE/skills" ]; then
  echo "# Installed Skills — $DATE" > "$BACKUP_DIR/skills-index/skills.md"
  for skill_dir in "$WORKSPACE/skills"/*/; do
    skill=$(basename "$skill_dir")
    desc=$(grep "^description:" "$skill_dir/SKILL.md" 2>/dev/null | head -1 | sed 's/description: //' || echo "no description")
    echo "- **$skill**: $desc" >> "$BACKUP_DIR/skills-index/skills.md"
  done
fi

# Cron jobs
openclaw cron list --json 2>/dev/null > "$BACKUP_DIR/crons/cron-jobs.json" || ERRORS+=("Failed to export crons")

# Auth profiles template (never store live tokens in git backup)
AUTH_SRC="$OPENCLAW/agents/main/agent/auth-profiles.json"
if [ -f "$AUTH_SRC" ]; then
  python3 - "$AUTH_SRC" "$BACKUP_DIR/config/auth-profiles.template.json" << 'PY'
import json
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])

data = json.loads(src.read_text())
for profile in data.get("profiles", {}).values():
    if "token" in profile:
        profile["token"] = "[API_TOKEN]"
    if "access" in profile:
        profile["access"] = "[OAUTH_ACCESS_TOKEN]"
    if "refresh" in profile:
        profile["refresh"] = "[OAUTH_REFRESH_TOKEN]"
    if "accountId" in profile:
        profile["accountId"] = "[ACCOUNT_ID]"
    if "expires" in profile:
        profile["expires"] = 0
data["usageStats"] = {}

dst.write_text(json.dumps(data, indent=2) + "\n")
PY
else
  cat > "$BACKUP_DIR/config/auth-profiles.template.json" << 'JSON'
{
  "version": 1,
  "profiles": {
    "openai-codex:default": {
      "type": "oauth",
      "provider": "openai-codex",
      "access": "[OAUTH_ACCESS_TOKEN]",
      "refresh": "[OAUTH_REFRESH_TOKEN]",
      "expires": 0,
      "accountId": "[ACCOUNT_ID]"
    },
    "anthropic:default": {
      "type": "token",
      "provider": "anthropic",
      "token": "[ANTHROPIC_API_KEY]"
    }
  },
  "usageStats": {}
}
JSON
fi

echo "🔍 Scanning for secrets..."

scrub_file() {
  local file="$1"
  [ -f "$file" ] || return
  python3 - "$file" << 'PY'
import json
import re
import sys
from pathlib import Path

p = Path(sys.argv[1])
t = p.read_text(errors="ignore")

def sanitize_json(node, path=()):
    if isinstance(node, dict):
        out = {}
        for k, v in node.items():
            key_path = path + (k,)
            key = ".".join(key_path)

            if key == "channels.discord.token":
                out[k] = "[DISCORD_BOT_TOKEN]"
                continue
            if key == "channels.telegram.botToken":
                out[k] = "[TELEGRAM_BOT_TOKEN]"
                continue
            if key in {"gateway.auth.token", "gateway.remote.token"}:
                out[k] = "[GATEWAY_TOKEN]"
                continue
            if key == "env.GOG_KEYRING_PASSWORD":
                out[k] = "[GOG_KEYRING_PASSWORD]"
                continue
            if key == "env.GOG_ACCOUNT":
                out[k] = "[GOG_ACCOUNT_EMAIL]"
                continue

            # Auth profile keys
            if "profiles" in path and k == "access":
                out[k] = "[OAUTH_ACCESS_TOKEN]"
                continue
            if "profiles" in path and k == "refresh":
                out[k] = "[OAUTH_REFRESH_TOKEN]"
                continue
            if "profiles" in path and k == "token":
                out[k] = "[API_TOKEN]"
                continue
            if "profiles" in path and k == "accountId":
                out[k] = "[ACCOUNT_ID]"
                continue
            if "profiles" in path and k == "expires":
                out[k] = 0
                continue

            out[k] = sanitize_json(v, key_path)
        return out
    if isinstance(node, list):
        return [sanitize_json(v, path) for v in node]
    return node

try:
    obj = json.loads(t)
    obj = sanitize_json(obj)
    t = json.dumps(obj, indent=2) + "\n"
except Exception:
    pass

patterns = [
    (r"[0-9]{8,10}:AA[A-Za-z0-9_-]{33,}", "[TELEGRAM_BOT_TOKEN]"),
    (r"MTQ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}", "[DISCORD_BOT_TOKEN]"),
    (r"\b[A-Za-z0-9_-]{23,30}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{25,}\b", "[DISCORD_BOT_TOKEN]"),
    (r"sk-ant-[A-Za-z0-9_-]{20,}", "[ANTHROPIC_API_KEY]"),
    (r"sk-[A-Za-z0-9]{20,}", "[OPENAI_API_KEY]"),
    (r"AIza[A-Za-z0-9_-]{35}", "[GOOGLE_API_KEY]"),
    (r"ghp_[A-Za-z0-9]{36}", "[GITHUB_TOKEN]"),
    (r"\+355[0-9]{9}", "[PHONE_NUMBER]"),
    (r"\brt_[A-Za-z0-9._-]{20,}\b", "[OPENAI_REFRESH_TOKEN]"),
    (r"\beyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\b", "[OAUTH_ACCESS_TOKEN]"),
    (r"\b[a-f0-9]{40,}\b", "[GATEWAY_TOKEN]"),
]

for pat, repl in patterns:
    t = re.sub(pat, repl, t)

t = re.sub(r'("GOG_KEYRING_PASSWORD"\s*:\s*)"(.*?)"', r'\1"[GOG_KEYRING_PASSWORD]"', t)
t = re.sub(r'("GOG_ACCOUNT"\s*:\s*)"(.*?)"', r'\1"[GOG_ACCOUNT_EMAIL]"', t)

p.write_text(t)
PY
}

find "$BACKUP_DIR/workspace" "$BACKUP_DIR/config" "$BACKUP_DIR/crons" \
  -type f \( -name "*.md" -o -name "*.json" -o -name "*.yaml" \) | \
  while read -r f; do scrub_file "$f"; done

echo "🔒 Verifying scrubbed artifacts..."
if ! python3 - "$BACKUP_DIR" << 'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
patterns = [
    r"[0-9]{8,10}:AA[A-Za-z0-9_-]{33,}",                    # Telegram token
    r"MTQ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}",           # Discord bot token
    r"\b[A-Za-z0-9_-]{23,30}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{25,}\b",        # Discord-like token
    r"\brt_[A-Za-z0-9._-]{20,}\b",                                             # OAuth refresh token
    r"\beyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\b",        # JWT-like token
]

hits = []
for f in root.rglob("*"):
    if not f.is_file():
        continue
    if f.suffix.lower() not in {".md", ".json", ".yaml", ".yml"}:
        continue
    text = f.read_text(errors="ignore")
    for pat in patterns:
        if re.search(pat, text):
            hits.append((str(f), pat))
            break

if hits:
    print("Potential secrets detected after scrub:")
    for path, pat in hits[:20]:
        print(f"- {path} :: {pat}")
    sys.exit(1)
PY
then
  echo "❌ Secret scan failed after scrub. Skipping push."
  ERRORS+=("Secret scan failed")
  CAN_PUSH=0
fi

echo "✅ Secrets scrubbed"

cat > "$BACKUP_DIR/RESTORE.md" << 'RESTORE'
# Virgil Restore Guide

## Placeholders to fill in
- [TELEGRAM_BOT_TOKEN] — from @BotFather
- [DISCORD_BOT_TOKEN] — from Discord Developer Portal
- [ANTHROPIC_API_KEY] — from console.anthropic.com
- [GOOGLE_API_KEY] — from console.cloud.google.com
- [GATEWAY_TOKEN] — regenerate with: openclaw gateway token
- [GOG_KEYRING_PASSWORD] — local keyring passphrase
- [GOG_ACCOUNT_EMAIL] — Google account email for gog
- [PHONE_NUMBER] — your WhatsApp number

## Restore steps
1. Install OpenClaw on new server
2. Clone this repo (or specific branch): `git clone -b <branch-name> <repo-url>`
3. New server: copy `config/openclaw.json` → `~/.openclaw/openclaw.json`, then fill all [PLACEHOLDERS] with real values
4. Existing server: preserve live secrets and apply only optimization keys with `bash config/apply-live-optimizations.sh ~/.openclaw/openclaw.json`
5. Copy workspace/ files to your OpenClaw workspace
6. `config/auth-profiles.template.json` is reference-only. Re-auth providers on host using OpenClaw setup (`openclaw configure --section model`)
7. Run: openclaw doctor --fix && openclaw gateway start
8. Replace cron jobs from backup JSON (prevents duplicates): `bash crons/replace-jobs.sh crons/cron-jobs.json`
9. Re-install skills listed in skills-index/skills.md
RESTORE

cd "$BACKUP_DIR"
BACKUP_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
git config user.email "virgil@eternia"
git config user.name "Virgil"
git add -A

if git diff --cached --quiet; then
  SUMMARY="no changes"
else
  CHANGED=$(git diff --cached --name-only | wc -l | tr -d ' ')
  SUMMARY="$CHANGED file(s) changed"
fi

if [ "$CAN_PUSH" -eq 1 ]; then
  git commit -m "🔒 Backup $DATE — $SUMMARY" || true
  git push -u origin "$BACKUP_BRANCH"
  echo "✅ Pushed to GitHub branch: $BACKUP_BRANCH"
else
  echo "⚠️ Push skipped due secret-scan failure."
fi

if [ ${#ERRORS[@]} -eq 0 ]; then
  STATUS="✅ Daily backup complete — $SUMMARY ($TIMESTAMP)"
else
  STATUS="⚠️ Backup errors: ${ERRORS[*]} ($TIMESTAMP)"
fi

openclaw message send --channel discord --target "channel:$DISCORD_CHANNEL" --message "$STATUS" 2>/dev/null || true
echo "$STATUS"
