# Agent Orchestration Schema v2

## State Machine
`INTAKE -> ROUTE -> EXECUTE -> VERIFY -> MEMORIZE -> DONE`

Failure branch:
`EXECUTE -> FAIL -> RETRY_OR_PAUSE -> REPORT`

## Intake Contract
Every task starts with:
- objective
- constraints
- risk level
- urgency
- expected artifact

## Routing Rules
1. Maintenance lane:
- periodic checks, sync, indexing, status tasks
- low thinking, cheapest capable model

2. Execution lane:
- coding, debugging, command-heavy implementation
- medium thinking default, high on complexity gate

3. Research lane:
- ambiguous synthesis, strategic tradeoffs, high uncertainty
- high/xhigh only when gate triggers

4. Memory lane:
- consolidation, cleanup, durable retention updates
- low thinking extraction; medium for conflict resolution

## Handoff Packet (required)
- objective
- constraints
- known facts
- unknowns
- output format
- cost cap

## Verify Stage
Must include:
- completion status (done/partial/blocked)
- evidence (tests/logs/paths)
- risks/unknowns
- rollback or next step

## Memory Write Policy
- Hot: volatile operational notes
- Warm: weekly summaries + project snapshots
- Cold: stable durable constraints

Only promote to cold if promotion rule is satisfied.
