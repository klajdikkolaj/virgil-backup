# Virgil Restore Guide

## Placeholders to fill in
- [TELEGRAM_BOT_TOKEN] — from @BotFather
- [DISCORD_BOT_TOKEN] — from Discord Developer Portal
- [ANTHROPIC_API_KEY] — from console.anthropic.com
- [GOOGLE_API_KEY] — from console.cloud.google.com
- [GATEWAY_TOKEN] — regenerate with: openclaw gateway token
- [PHONE_NUMBER] — your WhatsApp number

## Restore steps
1. Install OpenClaw on new server
2. Clone this repo (or specific branch): `git clone -b <branch-name> <repo-url>`
3. Copy config/openclaw.json → ~/.openclaw/openclaw.json
4. Fill in all [PLACEHOLDERS] with real values
5. Copy workspace/ files to your OpenClaw workspace
6. Run: openclaw doctor --fix && openclaw gateway start
7. Recreate cron jobs from backup JSON: `bash crons/import-jobs.sh crons/cron-jobs.json`
8. Re-install skills listed in skills-index/skills.md
