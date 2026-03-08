# Job SOP - Daily Usage Observability

## Objective
Capture daily token/cost and cron reliability metrics in one compact report.

## Steps
1. Collect usage cost snapshot:
- `openclaw gateway usage-cost`
2. Collect scheduler snapshot:
- `openclaw cron list --json`
3. Derive metrics:
- total jobs
- enabled jobs
- failing jobs (`consecutiveErrors > 0`)
- high-risk jobs (`consecutiveErrors >= 3`)
4. Write markdown report to:
- `/home/clawdkbot/.openclaw/workspace/memory/ops/YYYY-MM-DD-usage.md`

## Report sections
1. Usage Cost Snapshot
2. Cron Health Summary
3. Jobs At Risk
4. Recommended Actions (max 3 bullets)

## Output
Return one-line status with saved report path and at-risk count.
