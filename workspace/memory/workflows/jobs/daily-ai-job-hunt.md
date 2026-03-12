# Job SOP - Daily AI Remote Job Hunt

Schedule intent: weekdays at 12:00 Europe/Tirane.

## Objective
Find remote AI-focused roles posted within last 24h and produce actionable shortlist.

## Priority role themes
1. AI Trainer / AI Manager / AI Product / AI Program / Agentic Orchestration
2. LLM app/platform/tooling roles (Next.js/Node/TS + OpenAI/Anthropic)

## Query bias (explicit)
Always include these search seeds first before broader AI terms:
- "AI Trainer"
- "AI Training Specialist"
- "LLM Trainer"
- "AI Manager"
- "AI Program Manager"
- "AI Product Manager"

If results are sparse, then expand to adjacent terms (AI Ops, AI Enablement, Agent Ops) while keeping hard filters.

## Source priority
RemoteOK, WeWorkRemotely, Wellfound, Remotive, Hugging Face Jobs, company ATS (Greenhouse/Lever), then verified web fallback.

## Hard filters
- Collect 10 unique jobs max (dedupe by company+title+canonical URL)
- Keep only remote roles open worldwide/Europe/EMEA or no Albania exclusion
- Reject explicit Albania/Balkans exclusions
- Reject scam/unverifiable postings

## Required fields per job
- Title, Company, Posted time/date, Remote region, Contract type, Link
- Requirements (5-12 bullets)
- Why match (2-4 bullets)
- Open questions (1-3 bullets)
- Fit score (0-100)

## Output file (mandatory)
`/home/clawdkbot/virgil-vault/Jobs/Daily/YYYY-MM-DD.md`
with YAML frontmatter: `date`, `sources_used`, `query_terms`, `count`.

Also append compact index to:
`/home/clawdkbot/virgil-vault/Jobs/Daily/_titles-index.md`
with date + 10 title/company/link lines.

## Git sync (mandatory)
1. `cd /home/clawdkbot/virgil-vault`
2. `git pull --rebase`
3. `git add Jobs/Daily/*.md`
4. If staged: commit `chore(jobs): daily AI jobs $(date +%F)` then push
5. If no changes: report "no changes to sync"

Return only short completion status: count + file path + index updated + git result.
