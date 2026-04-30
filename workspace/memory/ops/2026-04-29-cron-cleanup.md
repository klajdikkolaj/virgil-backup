# Cron cleanup — 2026-04-29

Requested by Klajdi in Discord #general: cleanup/fix failing jobs.

## Actions taken

- Backed up cron store before changes:
  - `/home/clawdkbot/.openclaw/workspace/memory/ops/cron-backups/jobs-20260429T110000Z.json`
- Inspected cron scheduler and job run history.
- Confirmed active/enabled jobs had no current consecutive errors.
- Added explicit `timeoutSeconds: 300` to active maintenance-style jobs:
  - `maintenance-batch`
  - `vault-qmd-reindex`
- Removed obsolete/unsafe disabled jobs that were creating stale failure noise or risk:
  - `monitoring-digest` — disabled, stale failures from retired `virgil-haiku` runtime mismatch/gateway restart interruption; superseded by daily usage observability.
  - `nightly-ai-remote-job-hunt` — disabled legacy job hunt; repeated timeout failures; superseded by newer job-search workflows.
  - `ado-pr-review-watch-johan-enis` — disabled Azure DevOps PR watcher containing plaintext PAT in cron payload; removed to reduce secret exposure.
  - `gateway-watchdog` — disabled and already merged into `maintenance-batch`.

## Verification

Post-cleanup cron store check:
- total jobs: 14
- enabled jobs: 12
- failing enabled jobs: 0
- failing jobs overall: 0

## Notes

- The cron list preview still labels `mode:none` jobs as `none -> last`; their recorded last delivery status is `not-requested`, so this is preview noise, not a failing delivery path.
- The Azure DevOps PAT that was in the removed disabled job should be considered exposed historically if it was real/current; rotate it before any future ADO automation.
