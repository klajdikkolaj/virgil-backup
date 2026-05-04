# Job SOP - OpenClaw Update Availability + Manual Safe Update

## Objective
Keep OpenClaw update checks useful without letting cron restart the gateway that is running the cron job.

## Why this exists
This host has no swap and may have large active sessions. If an OpenClaw cron job runs `openclaw update` and the updater restarts the gateway while model/tool work is active, restart recovery can resume old runs and create an overload/restart loop.

## Cron-safe behavior
The scheduled job must **not** apply updates.

Cron should only:
1. `openclaw --version`
2. `openclaw update status --json`
3. `openclaw status --json` when available
4. If no update is available and health is normal: return exactly `NO_REPLY`.
5. If an update is available or health is degraded: report current version, latest version, channel, and a short health note.

## Manual safe update pattern
Use this only when Klajdi explicitly asks for an update or approves maintenance downtime.

1. Quiesce active work:
   - `openclaw tasks list --status running --json`
   - Cancel stale/interrupted resume runs if present: `openclaw tasks cancel <task-id>`
   - Avoid starting large model/tool runs until update is done.
2. Capture precheck:
   - `openclaw --version`
   - `openclaw update status --json`
   - `openclaw gateway status`
   - confirm `/home/clawdkbot/openclaw` worktree is clean.
3. Stop the gateway cleanly:
   - Preferred when available: first-class gateway restart/stop tool.
   - CLI fallback only with explicit user approval: `systemctl --user stop openclaw-gateway.service`.
4. Apply update while gateway is stopped:
   - `openclaw update --yes --no-restart --json`
5. Start the gateway:
   - CLI fallback only with explicit user approval: `systemctl --user start openclaw-gateway.service`.
6. Wait before opening UI / triggering sessions:
   - wait at least 60s after service start.
7. Post-check:
   - `openclaw --version`
   - `openclaw gateway status`
   - `openclaw status --json`
   - `openclaw doctor 2>&1 | head -80`
8. Report:
   - pre-version -> post-version
   - update outcome
   - health summary
   - warnings/errors
   - use ✅/⚠️/❌ markers

## Hard rules
- Do not run `openclaw update` from the scheduled cron job.
- Do not restart the gateway from inside a normal cron agent turn.
- Do not chain `openclaw gateway stop` and `openclaw gateway start` as a restart substitute.
- Prefer status-only automation plus manual explicit maintenance for dev-channel updates.
- If a step fails, include exact failed command and likely cause.
