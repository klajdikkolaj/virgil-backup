# Eternia — Phase 1 Trust-Boundary Verification Gates
_Last updated: 2026-03-07_

Purpose: convert the Phase 1 hardening priority into explicit, auditable pass/fail gates.

Status convention:
- `UNKNOWN` = not yet validated
- `IN PROGRESS` = work started, validation incomplete
- `PASS` = evidence verified
- `FAIL` = gate not met; must block downstream phase progression

---

## Gate 1 — Identity & Access Boundary
**Status:** UNKNOWN

Pass criteria:
- Service-to-service auth paths are documented.
- Privileged actions require explicit scoped credentials.
- Secret handling and rotation policy exists and is testable.

Evidence pointers:
- _TBD_

---

## Gate 2 — Input Trust Boundary
**Status:** UNKNOWN

Pass criteria:
- External content is treated as untrusted by default.
- Prompt-injection/jailbreak resistance controls are defined for critical paths.
- Tool/action requests include provenance and policy checks before execution.

Evidence pointers:
- _TBD_

---

## Gate 3 — Consent & Data Boundary
**Status:** UNKNOWN

Pass criteria:
- Data collection boundaries are explicit and consent-aware.
- Retention/deletion expectations are documented.
- Sensitive data classes and handling policy are clearly defined.

Evidence pointers:
- _TBD_

---

## Gate 4 — Action Safety Boundary
**Status:** UNKNOWN

Pass criteria:
- High-risk/destructive/external actions require explicit approval.
- Reversible-first execution is default where possible.
- Failure paths and rollback procedures are documented.

Evidence pointers:
- _TBD_

---

## Gate 5 — Observability & Incident Boundary
**Status:** UNKNOWN

Pass criteria:
- Security-relevant actions are logged with sufficient audit detail.
- Health/alert checks exist for critical services.
- Incident response steps are documented and runnable.

Evidence pointers:
- _TBD_

---

## Gate 6 — Verification Pack (Blocker Gate)
**Status:** UNKNOWN

Pass criteria:
- A repeatable validation checklist exists for Gates 1–5.
- At least one adversarial test pass is recorded.
- Regression checks are defined before phase transition.

Evidence pointers:
- _TBD_

---

## Promotion Rule
Phase 2+ work may be scoped, but **phase progression remains blocked** until Gate 6 is `PASS` and no earlier gate is `FAIL`.
