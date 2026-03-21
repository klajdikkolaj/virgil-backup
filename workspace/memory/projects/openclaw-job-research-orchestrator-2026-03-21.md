# OpenClaw Job Research Orchestrator - Notes
Date: 2026-03-21
Source: user-provided transcript summary of `OpenClaw Doesn't Work Until You Do This`

## Transcript takeaways distilled
- Single-agent runs degrade when one agent is asked to do multiple distinct jobs.
- The fix is architectural, not prompt-only.
- Use one orchestrator plus specialist subagents.
- Keep each agent in its own Markdown prompt file.
- Require structured outputs and explicit boundaries.
- Handle partial failure without dropping the whole workflow.
- Use lighter models for simple lanes and stronger models only when needed.

## Repo mapping
- Added a dedicated OpenClaw project:
  - `workspace/projects/job-research-agent/orchestrator.md`
  - `workspace/projects/job-research-agent/subagents/*.md`
- Added a dedicated job-profile memory file:
  - `workspace/memory/contacts/klajdi-job-profile.md`
- Converted the existing daily job hunt SOP into a dispatcher that loads the project and runs it.
- Extended the cron timeout and completion contract to fit orchestrated execution.
