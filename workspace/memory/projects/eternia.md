# Eternia — Project Memory
_Last distilled: 2026-03-09_

## Project definition
Eternia is a long-term evolving AI ecosystem combining learning, exploration, and symbolic worldbuilding.

## Authority and governance
- Human authority: Klajdi
- Assistant role: steward/operator, never autonomous project owner
- Execution must preserve governance clarity, consent boundaries, and safety constraints

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

## Operating expectations for project work
- Prefer rigorous sequencing and evidence over speed.
- Use explicit protocol gates for high-risk/research work.
- Keep reporting transparent about effective lane/model execution and fallback outcomes.
- Preserve theory-grounded guidance (theory → protocol → action) for practical recommendations.

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
- Deep research contract: `memory/workflows/deep-research.md`

## Open strategic debts
- Fill `memory/projects/eternia-phase1-trust-gates.md` with concrete evidence pointers and move gates from `UNKNOWN` to explicit PASS/FAIL.
- Reconfirm lane-level validation/testing cadence after routing and fallback changes.
- If requested, package findings into a theory-based playbook artifact for repeatable execution.

## Research watchlist (requested)
- Track **b-dLDS** for possible integration into Eternia’s long-term neuro-symbolic research map.
- Track **CODEC** for possible integration into Eternia’s interpretability research map.
- Track the new persistent Eternia research program at `virgil-vault/Research/Eternia/`.
- Highest-value external domains currently judged most relevant:
  - agentic simulation and world models
  - memory architectures for social agents
  - neuro-symbolic reasoning and constraint-based cognition
  - companion/social AI
  - safety, consent, governance, and dependency risks in persistent AI systems
  - BCI / neural interfaces as future interface research, not near-term product magic
- Current repo-understanding view to preserve:
  - Eternia is a hybrid simulation/governance platform, not just a chatbot backend
  - the real runtime center of gravity is `EternaWorld` in `world_builder_modules/`
  - `world_builder.py` is now largely a compatibility shim
  - `modules/governor.py` / the alignment governor is one of the strongest concrete parts of the codebase
  - trust-boundary hardening remains the non-negotiable sequencing rule before higher-autonomy expansion
- Current critique to keep alive in daily review:
  - strategic imagination is ahead of enforcement/runtime rigor
  - symbolic-law rhetoric still outruns executable semantics
  - UI/product direction shows some drift from the repo’s core ontology
  - scope pressure is high and needs disciplined sequencing
- Next step when requested: disambiguate exact paper/project references for b-dLDS and CODEC, then produce fit/risk/effort scoring against Eternia phase map.
