# OpenClaw Implementation Plan (Post-Audit)
Date: 2026-03-08
Branch target: `coklajdi/openclaw-optimize-v1`
Runtime target: OpenClaw `2026.3.7`

## Execution Status (Branch)
- Status date: 2026-03-08
- Implemented in branch:
  - Phase 1 (credential hygiene + secret-safe backup/restore)
  - Phase 2 (bootstrap caps + contextPruning + compaction in config)
  - Phase 3 (heartbeat dedupe + cron timezone normalization)
  - Phase 4 (retrieval-first startup in `AGENTS.md`)
  - Phase 5 (lane enforcement via per-agent tool profiles)
  - Phase 6 (observability + circuit-breaker jobs and SOPs)
- Remaining only on live host:
  - Pull/apply/restart
  - Re-auth providers
  - Rotate historically exposed secrets/tokens

## 1) Agreement With The Audit
I agree with most of the audit direction.

Strongly agree:
- Security first (credential leakage risk is real and urgent).
- Keep baseline token burn low; spend tokens on research/coding only.
- Lane-based orchestration (maintenance/coding/research/memory) with strict routing.
- SOP-driven cron prompts (stable prompt shape, lower token overhead).
- Retrieval-first memory design (do not inflate always-on context).

Corrections to apply vs current repo state:
- The audit analyzed an older branch tip; current branch now differs.
- In current repo, `contextPruning` and `compaction` are not present in `config/openclaw.json`.
- Current repo still contains sensitive auth material in `config/auth-profiles.json` and gateway/env secrets in `config/openclaw.json`.

## 2) Current Gaps To Close (Verified)
1. `config/auth-profiles.json` has live OAuth credentials.
2. `config/openclaw.json` includes live gateway tokens and env secrets.
3. No `.gitignore` exists yet to block runtime credential files.
4. Duplicate heartbeat topology exists:
- built-in agent heartbeat (`virgil-haiku.heartbeat.every: 1h`), and
- cron heartbeat job (`heartbeat-klajdi`).
5. `opencortex-memory-review` cron is missing `schedule.tz`.
6. `workspace/AGENTS.md` still enforces reading today+yesterday logs every session.

## 3) Implementation Objectives
- Eliminate credential leakage from repo backups.
- Enable 2026.3.7-compatible context controls:
- `agents.defaults.bootstrapMaxChars`
- `agents.defaults.bootstrapTotalMaxChars`
- `agents.defaults.contextPruning`
- `agents.defaults.compaction` (+ memoryFlush)
- Keep low-cost defaults and only escalate reasoning on complexity/risk gates.

## 4) Phase-by-Phase Implementation

## Phase 0 - Safety Snapshot (Mandatory)
1. Create backup branch and tag before changes.
2. Export current live config and crons.
3. Record current status and gateway health.

Commands:
```bash
git checkout coklajdi/openclaw-optimize-v1
git pull --rebase
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.pre-impl-$(date +%F-%H%M%S)
openclaw cron list --json > /tmp/openclaw-crons.pre-impl.json
openclaw status --json > /tmp/openclaw-status.pre-impl.json
```

## Phase 1 - Credential Hygiene (Highest Priority)
1. Add `.gitignore` entries:
- `config/auth-profiles.json`
- `**/auth-profiles.json`
- `**/.openclaw/credentials/**`
- `.env`
- any local secret files used by backup/restore

2. Replace tracked auth file with template:
- keep `config/auth-profiles.template.json`
- stop tracking `config/auth-profiles.json`

3. Remove/placeholder gateway/env secrets in tracked `config/openclaw.json`.

4. Update `backup.sh` scrub patterns for:
- JWT-like access tokens
- `rt_` refresh tokens
- long hex gateway tokens
- known env secret fields

5. Rotate secrets immediately after cleanup:
- gateway tokens
- OAuth refresh/session tokens (re-auth)
- any provider keys exposed historically

## Phase 2 - Enable 2026.3.7 Context Controls
Apply on live host (CLI), then validate.

```bash
openclaw config set agents.defaults.bootstrapMaxChars 5000 --strict-json
openclaw config set agents.defaults.bootstrapTotalMaxChars 20000 --strict-json

openclaw config set agents.defaults.contextPruning '{"mode":"cache-ttl","ttl":"1h","keepLastAssistants":3,"softTrimRatio":0.3,"hardClearRatio":0.5,"minPrunableToolChars":50000,"softTrim":{"maxChars":4000,"headChars":1500,"tailChars":1500},"hardClear":{"enabled":true,"placeholder":"[Old tool result content cleared]"},"tools":{"deny":["browser","canvas"]}}' --strict-json

openclaw config set agents.defaults.compaction '{"mode":"safeguard","reserveTokensFloor":24000,"memoryFlush":{"enabled":true,"softThresholdTokens":6000,"systemPrompt":"Session nearing compaction. Store durable memories now.","prompt":"Write durable notes to memory/YYYY-MM-DD.md. Reply NO_REPLY if nothing to store."}}' --strict-json

openclaw config validate
openclaw gateway restart
```

## Phase 3 - Heartbeat + Cron Topology Cleanup
Choose one heartbeat mechanism only.
Recommended:
- Keep cron heartbeat (`heartbeat-klajdi`).
- Disable built-in agent heartbeat block under `virgil-haiku`.

Also:
- Add `tz: Europe/Tirane` to `opencortex-memory-review` job.

After edits:
```bash
bash crons/replace-jobs.sh crons/cron-jobs.json
openclaw cron list --json
```

## Phase 4 - Retrieval-First Memory Startup
Update `workspace/AGENTS.md` startup protocol:
- remove mandatory read of today+yesterday logs every run.
- replace with:
  1) read `SOUL.md` and `USER.md`
  2) run memory retrieval (`memory_search`) for relevant context
  3) read only specific memory files when needed
  4) main session may read `MEMORY.md`

This preserves long-term memory while reducing fixed per-turn token cost.

## Phase 5 - Lane Enforcement (Policy -> Runtime)
Implement lanes as actual agent/runtime policy (not just docs):
- Maintenance lane: low-cost model, low thinking, minimal tools.
- Coding lane: codex model, coding tool profile.
- Research lane: premium model escalation only on gate.
- Memory lane: cheap consolidation path.

Enforcement knobs:
- per-agent model/fallbacks
- per-agent tool profile and allow/deny
- channel bindings aligned to lanes

## Phase 6 - Observability and Guardrails
1. Daily metrics capture:
- gateway usage-cost
- cron run durations + failures
- % runs that escalate thinking
- heartbeat no-op ratio

2. Circuit-breaker policy:
- if job has >=3 consecutive failures, auto-disable and alert.

3. Weekly optimization review:
- prune low-value automations
- adjust schedule frequency and thinking levels

## 5) Validation Checklist
All must be true:
- `openclaw config validate` returns valid.
- `openclaw status --json` healthy.
- `openclaw gateway status` healthy.
- `openclaw cron list --json` shows expected jobs + timezones.
- No tracked files contain live secrets.
- One heartbeat mechanism only.
- Baseline prompt/context size reduced vs pre-impl snapshot.

## 6) Rollback Plan
If any regression:
1. restore `~/.openclaw/openclaw.json.pre-impl-*`
2. restore crons from `/tmp/openclaw-crons.pre-impl.json`
3. restart gateway
4. compare status snapshots pre/post rollback

## 7) Decision Log (Recommended)
When implementation completes, append a short run-log entry:
- what changed
- what was validated
- what remains as follow-up
- final risk status
