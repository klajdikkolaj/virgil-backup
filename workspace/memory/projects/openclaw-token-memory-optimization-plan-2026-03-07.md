# OpenClaw Optimization Plan - Token Efficiency + Durable Memory
Date: 2026-03-07
Scope: `config/openclaw.json` + `crons/cron-jobs.json` + workspace memory/workflow files

## 1) Objective
Design OpenClaw to run with minimum always-on token burn and maximum burst intelligence when needed.

Primary intent:
- Spend tokens aggressively only on high-value work (deep research, complex coding, high-risk decisions)
- Keep maintenance, heartbeat, and routine automation ultra-lean
- Preserve long-term memory quality without stuffing live context

## 2) Baseline Diagnosis (Current State)

### Observed from your config/workspace
- `agents.defaults.thinkingDefault` is `medium` globally.
- 10 cron jobs are enabled; 3 jobs run every 3h (`heartbeat`, `qmd-light-refresh`, `gateway-watchdog`).
- Two jobs are currently failing repeatedly:
  - `daily-backup` (4 consecutive errors)
  - `daily-ai-remote-job-hunt` (2 consecutive errors; very long runtime)
- Long cron prompts:
  - Morning briefing message: 1549 chars
  - Job hunt message: 2691 chars
- `BOOTSTRAP.md` still exists even though `AGENTS.md` says it should be deleted after first run.
- `hooks.internal.entries.boot-md` and `bootstrap-extra-files` are enabled.
- Memory search uses remote Gemini embeddings despite local QMD skill/indexing flows already present.
- All major Discord channels have `requireMention: false` (can increase accidental turn volume).

### Token pressure estimate (rough)
- Bootstrap context chars (AGENTS+SOUL+USER+TOOLS+IDENTITY+HEARTBEAT+today+yesterday): ~16,700 chars (~4,175 tokens)
- Plus `MEMORY.md` in main sessions: ~19,592 chars (~4,898 tokens)
- Cron run count/day (excluding every-3-days job): ~30 runs/day
- Estimated fixed context overhead/day from cron runs alone: ~125k tokens/day before actual work

## 3) External Best-Practice Anchors (OpenClaw docs)

Use these as hard constraints:
- Keep assistant/bootstrap files concise; OpenClaw injects these into context and supports size caps (`bootstrapMaxChars`, `bootstrapTotalMaxChars`).
- Use `contextPruning` and `compaction` to avoid context bloat.
- Compaction can flush session memory to disk when `session-memory` hook supports `autoWriteOnCompaction`.
- Use heartbeat with `activeHours` and short status behavior for low-noise periodic checks.
- Prefer cron for precise isolated jobs; prefer heartbeat for batched periodic checks.
- Thinking levels should be task-scoped; cache keys include thinking level and instruction shape, so stable lanes improve cache reuse.
- Skill overhead scales with number/length of skill descriptions; keep frequently loaded skill manifests short.

## 4) Neuroscience/Human Memory Design Mapping

Translate human memory science into agent memory policy:
- Encoding selectivity: only high-salience facts should enter long-term memory.
- Consolidation: daily notes -> weekly synthesis -> monthly doctrine updates.
- Retrieval practice: prefer search/retrieval over keeping everything in working memory.
- Forgetting by design: decay stale low-value notes from hot context.
- Chunking: store memory as compact decision chunks (decision, rationale, constraints, expiry).

Resulting memory model:
- Hot memory (working): today + yesterday + active tasks only.
- Warm memory (episodic): last 7-30 day summaries and project status snapshots.
- Cold memory (semantic): curated durable principles and major decisions.

## 5) Target Architecture (Policy-Driven)

### Lane policy (token-aware)
- `Maintenance lane` (heartbeat, sync, indexing checks): cheap model + `thinking=low`
- `Execution lane` (coding/refactor/debug): codex + `thinking=medium/high` only when complexity gate triggers
- `Research lane` (deep synthesis): premium model + `thinking=high/xhigh`, explicit scope and output contract
- `Memory lane` (consolidation): cheap model for extraction, medium/high only for conflict resolution

### Complexity gate for raising thinking
Raise to `high/xhigh` only if at least one is true:
- High ambiguity with multiple conflicting sources
- Significant blast radius (security, production, external communication)
- Multi-step code change with uncertain side effects
- Explicit user request for deep rigor

Otherwise stay `low/medium`.

## 6) Concrete Changes (Implementation Plan)

## Phase A - Immediate Cost Cuts (Day 1)
1. Remove bootstrap drag:
- Delete `workspace/BOOTSTRAP.md` (already obsolete).
- Shorten `workspace/AGENTS.md` and `workspace/IDENTITY.md` into compact operational versions.
- Keep long philosophy/process docs in `workspace/memory/workflows/` and reference on-demand.

2. Add bootstrap caps in config:
- Set per-file and total bootstrap caps to prevent silent context explosions.

3. Set default thinking to low:
- Change `agents.defaults.thinkingDefault` from `medium` -> `low`.
- Keep targeted high/xhigh only via lane-specific prompts/jobs.

4. Stop known token leaks:
- Add circuit-breaker behavior for failing jobs (`daily-backup`, `daily-ai-remote-job-hunt`): auto-pause after N failures.
- Re-enable only after manual review.

## Phase B - Context and Memory Controls (Day 1-2)
1. Enable session pruning (summary strategy).
2. Enable compaction with token trigger thresholds.
3. Enable memory flush on compaction.
4. Move memory search to local QMD-first (remote fallback only if needed).
5. Add explicit `additionalPaths` to limit retrieval scope to high-value repositories only.

Recommended config overlay (adapt key names to current OpenClaw version):

```json
{
  "agents": {
    "defaults": {
      "thinkingDefault": "low",
      "memorySearch": {
        "provider": "qmd",
        "qmd": {
          "roots": [
            "~/virgil-vault",
            "~/.openclaw/workspace"
          ],
          "scope": "session",
          "maxHits": 8,
          "rerank": "rrf",
          "build": {
            "enabled": true,
            "onStart": true,
            "watch": false
          }
        }
      }
    }
  },
  "contextPruning": {
    "enabled": true,
    "maxHistoryMessages": 120,
    "strategy": "summary",
    "minMessagesBeforePrune": 80,
    "preserveSystemMessages": true
  },
  "compaction": {
    "enabled": true,
    "targetPromptTokens": 35000,
    "reserveOutputTokens": 6000,
    "triggerEveryTurns": 12,
    "triggerOnEstimatedPromptTokens": 70000,
    "summaryStyle": "structured",
    "includeToolCallDigest": true,
    "persistPath": "memory/compactions"
  },
  "hooks": {
    "internal": {
      "entries": {
        "session-memory": {
          "enabled": true,
          "autoWriteOnCompaction": true
        }
      }
    }
  },
  "assistantFileSettings": {
    "bootstrapMaxChars": 5000,
    "bootstrapTotalMaxChars": 20000
  }
}
```

## Phase C - Cron/Heartbeat Rationalization (Day 2)
1. Merge duplicate periodic maintenance:
- Replace separate `qmd-light-refresh` + `gateway-watchdog` with one maintenance heartbeat workflow.

2. Heartbeat tuning:
- Use `activeHours` to avoid off-hour runs.
- Keep quick no-op responses (`HEARTBEAT_OK`) for no-change cycles.

3. Precision vs batch split:
- Keep exact-time tasks on cron (briefing, backup).
- Move non-time-critical checks under heartbeat batching.

4. Prompt minimization:
- Move long cron prompts to file-based SOPs.
- Cron payload should be one-line dispatcher:
  - `Execute workflow: memory/workflows/jobs/daily-job-hunt.md and return compact status.`

Expected token reduction: 30-60% just from prompt compression and run-count consolidation.

## Phase D - Model and Routing Strategy (Day 2-3)
1. Assign model lanes by task economics:
- Heartbeat/maintenance: smallest capable model
- Coding implementation: codex medium default
- Deep research: premium/high only

2. Fallback order by cost-risk:
- Cheap -> medium -> premium for low-risk flows
- Premium first only for explicitly strategic lanes

3. Stabilize prompt shapes for cache reuse:
- Keep recurring job prompts fixed and templated
- Avoid constant wording drift in scheduled tasks

## Phase E - Memory Growth Loop (Week 1 onward)
1. Daily:
- Append raw events to `memory/YYYY-MM-DD.md` (short bullets).

2. Weekly consolidation (new cron, low/medium thinking):
- Merge past 7 daily files into one compact `weekly-summary` note.
- Extract only durable decisions and recurring patterns.

3. Monthly doctrine refresh (medium/high thinking):
- Update `MEMORY.md`, `preferences.md`, and workflow docs based on repeated evidence.
- Archive outdated constraints.

4. Promotion rule (for long-term memory):
Promote only if at least 2 are true:
- Reused >= 3 times in 14 days
- High consequence if forgotten
- Stable for >= 7 days
- Explicitly confirmed by user

## 7) Better Config Schema (Proposed Super-Schema)

Use a policy file that compiles into OpenClaw native config + cron JSON.
This separates intent from low-level knobs and makes evolution safer.

```json
{
  "schemaVersion": "openclaw.policy.v2",
  "profile": "virgil",
  "goals": {
    "latency": "balanced",
    "cost": "aggressive-optimization",
    "quality": "burst-on-demand"
  },
  "budgets": {
    "dailyTokenBudget": 250000,
    "backgroundTokenBudget": 40000,
    "maxPromptTokensByLane": {
      "maintenance": 6000,
      "execution": 22000,
      "research": 70000
    }
  },
  "lanes": {
    "maintenance": {
      "model": "cheap",
      "thinking": "low",
      "allowedActions": ["read", "status", "notify"]
    },
    "execution": {
      "model": "codex",
      "thinking": "medium",
      "escalation": "high-on-complexity"
    },
    "research": {
      "model": "premium",
      "thinking": "high",
      "escalation": "xhigh-on-conflict"
    }
  },
  "memory": {
    "tiers": ["hot", "warm", "cold"],
    "pruning": "summary",
    "compaction": "enabled",
    "promotionPolicy": "evidence-weighted"
  },
  "automation": {
    "heartbeat": {
      "activeHours": "07:00-23:00",
      "batchChecks": true
    },
    "jobs": {
      "retry": "bounded",
      "circuitBreaker": true,
      "stagger": true
    }
  },
  "observability": {
    "track": [
      "tokens_in",
      "tokens_out",
      "cache_hit_rate",
      "job_failure_rate",
      "memory_hit_rate"
    ],
    "report": "daily"
  }
}
```

## 8) Agent Orchestration Schema (Proposed)

Flow:
1. Intake + classify (intent, risk, complexity, urgency)
2. Route to lane
3. Execute with bounded context
4. Verify output + confidence
5. Store memory artifact at correct tier
6. Emit compact completion summary

Minimal state machine:
- `INTAKE -> ROUTE -> EXECUTE -> VERIFY -> MEMORIZE -> DONE`
- Fail path: `EXECUTE -> FAIL -> RETRY_OR_PAUSE -> REPORT`

Handoff contract (always):
- Objective
- Constraints
- Known facts
- Unknowns
- Output format
- Cost cap

## 9) Skills You Have vs Skills You Still Need

### Strong already installed
- Multi-agent orchestration (`agent-team-orchestration`, `agent-orchestration-multi-agent-optimize`)
- Memory/search substrate (`opencortex`, `qmd`, `memory-guard`)
- Security stack (`security-*` skills)

### Missing skills to add (priority order)
1. `token-observability`
- Capture per-job token/cost/latency and daily budget burn.

2. `prompt-compiler`
- Convert long operational prompts into compact templates + variable slots.

3. `cron-optimizer`
- Detect duplicated periodic jobs, recommend merge/batching, enforce activeHours/backoff.

4. `memory-consolidator`
- Daily->weekly->monthly compaction/promotion pipeline with decay rules.

5. `router-governor`
- Formal complexity/risk scoring to auto-pick lane/model/thinking level.

6. `retrieval-quality-evaluator`
- Measure memory_search precision/recall and tune `maxHits/rerank/scope`.

7. `automation-circuit-breaker`
- Auto-pause noisy failing jobs and produce remediation checklist.

8. `research-source-verifier`
- Reliability scoring and de-duplication for news/research briefings.

9. `workspace-schema-migrator`
- Safely migrate policy schema versions with rollback snapshots.

## 10) Rollout Sequence (No-Risk First)

1. Baseline metrics capture (2-3 days)
- Collect actual token and latency per job/turn.

2. Apply low-risk reductions
- Delete obsolete bootstrap file, shorten always-loaded files, prompt compression.

3. Enable pruning + compaction
- Validate no quality regressions over 3 days.

4. Consolidate cron/heartbeat topology
- Merge maintenance loops, add active hours and backoff.

5. Deploy policy schema + router rules
- Start in shadow mode (report-only), then enforce.

6. Monthly optimization cadence
- Re-score jobs by value/cost; retire low-value automations.

## 11) Success Metrics

Targets after full rollout:
- 60-85% reduction in background token burn
- >= 50% reduction in repeated cron failures
- < 10s median latency for maintenance tasks
- No loss in deep research/coding quality
- Memory hit-rate increase with lower prompt footprint

## 12) Immediate Next Implementation Pack (When you say go)

I will implement in this order:
1. Compact always-loaded files + remove bootstrap residue
2. Add pruning/compaction config safely
3. Refactor cron prompts into SOP files + shorten payload messages
4. Merge periodic maintenance jobs and tune heartbeat active hours
5. Add basic token/job observability report
6. Ship and verify with rollback points after each step
