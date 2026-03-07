# Job SOP - OpenClaw Update + Postcheck

## Objective
Run controlled OpenClaw update cycle and post concise health report.

## Steps
1. Precheck:
- `openclaw --version`
- `openclaw status`
2. Update:
- `openclaw update --yes --json 2>&1`
- Do NOT run `systemctl --user restart openclaw-gateway.service` in this job.
3. Post-check:
- `openclaw --version`
- `openclaw status`
- `openclaw doctor 2>&1 | head -40`
4. Report:
- pre-version -> post-version
- update outcome
- health summary
- warnings/errors
- use ✅/⚠️/❌ markers

If any step fails, include exact failed command and likely cause.
