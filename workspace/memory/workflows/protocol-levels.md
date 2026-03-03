# Protocol Levels (Fail-Closed Quality Controls)

Last updated: 2026-03-02
Owner: Virgil + Klajdi

## Purpose
Apply the same reliability principles everywhere, with different strictness by risk.

Core controls:
1. Fail-closed behavior
2. Mandatory preflight checklist
3. No silent method changes
4. Required synthesis order
5. Completion contract
6. Protocol check line

---

## Levels

### STRICT (high-risk / high-ambiguity)
Use for: strategy, research, security, architecture, external side-effects.

Required in every answer/run:
- **Preflight:** objective, constraints, assumptions, tool plan
- **Method lock:** if method changes, explicitly announce before doing it
- **Synthesis order:** facts → analysis → recommendation → risks → next action
- **Completion contract:** clearly state done/not done + verification evidence
- **Protocol line:** `Protocol: STRICT ✅`
- **Fail-closed:** if confidence is low or constraints conflict, pause and ask

### MEDIUM (operational / implementation)
Use for: normal ops, monitoring triage, iterative coding tasks.

Required:
- Short preflight
- Explicit method changes
- Clear recommendation + next step
- Completion status line
- `Protocol: MEDIUM ✅`

### LIGHT (low-risk retrieval)
Use for: simple lookups, status checks, lightweight Q&A.

Required:
- Quick preflight (what is being checked)
- Explicit uncertainty if any
- One-line completion status
- `Protocol: LIGHT ✅`

---

## Channel Mapping

- `#research` (`1477637773681885184`) → **STRICT**
- `#general` (`1477637736964952075`) → **MEDIUM**
- `#inbox` (`1477606618224132274`) → **MEDIUM**
- `#briefing` (`1477637792157794369`) → **MEDIUM**
- `#monitoring` (`1477637814014316586`) → **MEDIUM** (use STRICT for incident/security events)
- `#automation` (`1477637827964571780`) → **LIGHT** unless side-effects are involved, then MEDIUM/STRICT

---

## Escalation Rules

Escalate level upward when any apply:
- irreversible/external action
- security/privacy implications
- conflicting evidence or high uncertainty
- user requests deep rigor

De-escalate only after risk is clearly reduced.

---

## Task-start protocol reminder (one-liner)
Use this as the first line on substantive tasks:

- STRICT: `Protocol: STRICT ✅ (fail-closed, preflight, explicit method changes, full completion contract)`
- MEDIUM: `Protocol: MEDIUM ✅ (preflight + explicit method changes + completion status)`
- LIGHT: `Protocol: LIGHT ✅ (quick preflight + uncertainty note + completion status)`

## Completion Contract Template

- **Status:** Done / Partial / Blocked
- **What changed:**
- **Verification:**
- **Risks/unknowns:**
- **Next step:**
- **Protocol:** STRICT|MEDIUM|LIGHT ✅
