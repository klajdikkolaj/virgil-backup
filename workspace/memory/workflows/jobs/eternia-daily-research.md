# Job SOP - Eternia Daily Research

## Objective
Produce a daily Eternia research report that combines:
1. current understanding of the Eternia repo (read-only)
2. frontier external research relevant to improving Eternia
3. critical analysis and recommendations
4. multi-lane synthesis using the standing Eternia research team structure

## Hard rules
- Do not modify the Eternia repo.
- Save report to `/home/clawdkbot/virgil-vault/Research/Eternia/Daily/YYYY-MM-DD-eternia-research.md`
- At the top of the report, include a generated timestamp with date and hour, e.g. `Generated: YYYY-MM-DD HH:mm Europe/Tirane (UTC: YYYY-MM-DD HH:mm)`.
- If rewriting an existing same-day report, the generated datetime and current repo snapshot must be at the very top of the file, not appended below an older date-only/stale-branch header.
- Keep repo facts, external facts, inference, and opinion clearly separated.
- Keep safety / consent / trust-boundary analysis first-class.
- Prefer a reviewer/synthesis step over naive aggregation.
- Prefer Chromium/browser + `web_fetch` for external research when possible.
- Treat Brave API-backed `web_search` as optional only; do not depend on it.

## Standing team structure for the daily run
Treat the daily report as the output of these lanes:
1. Repo Architecture Lead
2. Agentic Simulation Lead
3. Memory & Neuro-symbolic Lead
4. Companion & Social AI Lead
5. Governance, Consent & Safety Lead
6. Neurotech / BCI / Interface Futures Lead
7. Biology / Biotechnology Analogy Lead
8. Critical Reviewer / Red-Team Editor
9. Strategic Synthesis Lead

The daily run does not need to spawn all lanes every time if signal is sparse, but it must explicitly reason through these lenses and preserve reviewer/synthesis discipline.

## Research domains
Always consider these domains when relevant:
- AI architectures and agent systems
- virtual worlds and simulations
- neuroscience
- biotechnology / biology (only where conceptually relevant to Eternia)
- brain-computer interfaces
- social/companion AI
- governance, consent, and safety for intimate persistent systems

## Daily method
1. Re-read persistent anchors:
   - `memory/projects/eternia.md`
   - `memory/projects/eternia-research-program.md`
   - `virgil-vault/Research/Eternia/eternia-core-understanding.md`
   - `virgil-vault/Research/Eternia/eternia-research-watchlist.md`
   - `virgil-vault/Research/Eternia/eternia-research-team-charter.md`
2. Review the Eternia repo in read-only mode for meaningful understanding delta.
3. Review frontier external developments when tools/data allow.
   - Primary path: `browser` (Chromium) for discovery and page navigation.
   - Secondary path: `web_fetch` for extracting readable content from selected URLs.
   - Optional path: `web_search` only if a search API key is configured and working.
4. Run an explicit critique pass:
   - what is hype?
   - what is weak evidence?
   - what is dangerous misinterpretation?
5. Run an explicit synthesis pass:
   - what matters for Eternia now?
   - what changes priorities?
   - what should be promoted into durable memory?

## Required sections
0. Metadata header with generated datetime/date+hour and repo/source snapshot notes
1. Executive summary
2. Repo understanding (what Eternia appears to be now)
3. Repo delta / new understanding today
4. External developments worth attention
5. What matters specifically for Eternia
6. Critical view / risks / false trails
7. Virgil opinion
8. Research watchlist updates
9. Next questions
10. Team-lens notes (brief bullets by lane when useful)

## Git sync
1. `cd /home/clawdkbot/virgil-vault`
2. `git pull --rebase --autostash`
3. `git add Research/Eternia/**/*.md Research/Eternia/*.md`
4. If staged changes exist:
   - `git commit -m "chore(eternia-research): daily report $(date +%F)"`
   - `git push origin HEAD`
5. If no staged changes exist: report `no changes to sync`

## Completion contract
Return concise status only:
- saved file path
- git sync result
- top 3 themes from the report
