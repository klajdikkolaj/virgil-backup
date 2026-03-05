# Eternia — Project Memory
_Last distilled: 2026-03-04_

## Project definition
Eternia is a long-term evolving AI ecosystem combining learning, exploration, and symbolic worldbuilding.

## Authority and governance
- Human authority: Klajdi
- Assistant role: steward/operator, never autonomous project owner
- Execution must preserve governance clarity and safety constraints

## Source of truth
- Repository: `Eternakk/eternia`
- Access: SSH confirmed
- Base implementation branch: `seriously`
- Key strategy branch previously analyzed: `coklajdi/deep-research-continuation-plan`

## Non-negotiable sequencing rule
**Do not progress to embodied movement or production multi-agent scale before trust-boundary hardening is complete.**

## Phase map (canonical)
1. Trust-boundary hardening (**active priority / P0**)
2. Conversation hub + consented data capture
3. Executable symbolic governance (laws runtime)
4. Embodied movement + governor veto
5. Export + anomaly analytics
6. Production multi-agent development loop

## Current status
- No phase is marked complete.
- Strategic focus remains Phase 1 hardening.

## Technical stack memory (working model)
- Backend: Python 3.12, FastAPI, WebSocket, PostgreSQL
- Frontend: React/Vite
- Infrastructure/ops: Docker, Prometheus, Grafana, Terraform

## Important module map
- `world_builder.py` — simulation core
- `alignment_governor.py` — safety/governance enforcement
- `services/api/` — REST + WebSocket surfaces
- `modules/` — governor, monitoring, RL loop components

## Execution governance references
- Routing and lane ownership: `memory/workflows/channel-routing.md`
- Protocol strictness by risk: `memory/workflows/protocol-levels.md`
- Required synthesis order: `memory/workflows/knowledge-access-order.md`

## Open strategic debts
- Convert Phase 1 hardening from principle into tracked verification checklist with explicit pass/fail gates.
- Reconfirm lane-level validation/testing cadence after model-routing changes.
