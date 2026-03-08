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
