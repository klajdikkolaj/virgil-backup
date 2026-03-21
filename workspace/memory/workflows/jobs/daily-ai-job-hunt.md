# Job SOP - Daily AI Remote Job Hunt

Schedule intent: weekdays at 12:00 Europe/Tirane.

This workflow is now the dispatcher for the dedicated OpenClaw project at:
`/home/clawdkbot/.openclaw/workspace/projects/job-research-agent/`

## Required reads
Read these before execution:
- `/home/clawdkbot/.openclaw/workspace/memory/contacts/klajdi.md`
- `/home/clawdkbot/.openclaw/workspace/memory/contacts/klajdi-job-profile.md`
- `/home/clawdkbot/.openclaw/workspace/projects/job-research-agent/orchestrator.md`
- every file under `/home/clawdkbot/.openclaw/workspace/projects/job-research-agent/subagents/`

## Objective
Run the job-research orchestrator exactly and produce an actionable shortlist of remote AI-focused roles posted within the last 24 hours.

## Execution rule
- Default to true orchestrator plus specialist-subagent execution
- Do not collapse the task into one generic single-agent browse pass unless subagents are unavailable
- If subagents are unavailable, emulate the same lane boundaries sequentially and report that fallback explicitly

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

## Required protocol
1. Execute the orchestrator as manager
2. Keep sourcing, enrichment, and fit review separated by lane
3. Preserve structured output and failure handling
4. Save the final report and update the titles index
5. Run the git sync defined by the orchestrator

## Output file (mandatory)
`/home/clawdkbot/virgil-vault/Jobs/Daily/YYYY-MM-DD.md`
with YAML frontmatter: `date`, `sources_used`, `query_terms`, `count`, `coverage_mode`.

Also append a compact date + title/company/link index block to:
`/home/clawdkbot/virgil-vault/Jobs/Daily/_titles-index.md`

## Completion contract
Return only short completion status:
- qualified count
- top matches count
- save path
- index updated
- git result
- coverage mode
