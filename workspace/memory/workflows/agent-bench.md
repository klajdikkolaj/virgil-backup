# Virgil Agent Bench
_Last updated: 2026-05-06_

## Purpose
Use a small, reusable specialist bench across Klajdi's recurring workflows. Virgil remains the orchestrator and final user-facing voice; specialists produce bounded artifacts, checks, and reviews.

## Operating rules
- Virgil owns routing, priority, user communication, and final synthesis.
- Specialists should have one primary role and a clear output path.
- Every delegated task should specify: scope, source files, output path, forbidden actions, and verification criteria.
- Specialists should not send external messages, apply to jobs, deploy, push, update OpenClaw, mutate Eternia, or perform destructive actions unless Virgil states Klajdi explicitly approved it.
- Use reviewer passes for substantial research, code, memory, or safety-sensitive output.

## Reusable agents

### `research-scout`
General deep-research specialist.
- Best for: frontier research, market/research scans, paper/source summaries, competitive landscape, current external developments.
- Output: sourced Markdown with facts, inference, uncertainty, and top implications.

### `briefing-analyst`
Daily/weekly signal triage.
- Best for: morning briefings, event/news synthesis, concise high-signal updates.
- Output: short briefing notes with why Klajdi should care.

### `job-opportunity-scout`
Jobs, tenders, procurement, and opportunity research.
- Best for: job hunt, public procurement, software tenders, opportunity qualification.
- Output: qualified/rejected opportunities with deadlines, fit reasoning, and links.

### `ops-maintainer`
OpenClaw and infrastructure routine operator.
- Best for: status checks, cron health, backups, QMD/index refresh, diagnostics.
- Output: compact status, exact blockers/logs, no risky changes without approval.

### `vault-librarian`
Memory and Obsidian/vault steward.
- Best for: memory consolidation, vault organization, indexing support, durable memory promotion proposals.
- Output: concise memory/vault changes and rationale.

### `code-builder`
Implementation specialist.
- Best for: scoped code/documentation changes in approved repos, test runs, patches.
- Output: files changed, verification run, known risks.

### `redteam-reviewer`
General quality/safety/security reviewer.
- Best for: critique, security/privacy review, hype detection, acceptance gates, pass/fail checks.
- Output: risks, missing evidence/tests, approve/block recommendation.

## Eternia-specific agents

### `eternia-repo-cartographer`
Read-only Eternia repo architecture analyst.

### `eternia-frontier-scout`
Eternia-focused external research scout.

### `eternia-governance-redteam`
Eternia trust-boundary, consent, authority, and safety reviewer.

See `/home/clawdkbot/.openclaw/workspace/memory/workflows/eternia-agent-team.md` for the Eternia-specific team contract.

## Suggested workflow mapping
- Eternia daily research: `eternia-repo-cartographer` + `eternia-frontier-scout` + `eternia-governance-redteam` → Virgil synthesis.
- Deep research: `research-scout` → `redteam-reviewer` → Virgil synthesis.
- Morning briefing: `briefing-analyst` → Virgil concise delivery.
- Job hunt/procurement: `job-opportunity-scout` → `redteam-reviewer` for quality/safety if needed.
- Memory consolidation: `vault-librarian` → Virgil approval for durable memory changes.
- Ops/maintenance: `ops-maintainer` for checks; Virgil asks Klajdi before risky changes.
- Coding tasks: `code-builder` → `redteam-reviewer` → Virgil final response.
