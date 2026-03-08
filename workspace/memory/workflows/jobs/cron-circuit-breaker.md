# Job SOP - Cron Circuit Breaker

## Objective
Prevent runaway token/cost burn from repeatedly failing cron jobs.

## Rule
If an enabled cron job has `consecutiveErrors >= 3`, disable it and report.

## Steps
1. Run:
`python3 /home/clawdkbot/virgil-backup/crons/circuit-breaker.py --threshold 3 --apply`
2. Parse summary output.
3. If any jobs were disabled, report job name + id + error count.
4. If none were disabled, report `no-action`.

## Output
Return concise status:
- disabled_count
- affected job names
- next action (manual investigate + re-enable after fix)
