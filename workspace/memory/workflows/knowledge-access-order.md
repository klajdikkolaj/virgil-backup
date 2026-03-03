# Knowledge Access Order (Project/Strategy Questions)

**Purpose:** Ensure answers are aligned with both workspace memory and latest Obsidian decisions.

## When to use
Use this flow for questions about:
- project direction
- architecture/orchestration decisions
- implementation status
- "what should I do next" guidance

## Access order (mandatory)
1. **Memory recall first**
   - Run `memory_search` for relevant prior decisions/preferences.
   - Use `memory_get` for exact snippets as needed.

2. **Obsidian/QMD second (latest decision docs)**
   - Check `~/virgil-vault` for matching decision memos/checklists/research notes.
   - Prefer newest dated files in `Research/`, `Projects/`, `Daily/` when relevant.

3. **Synthesize answer third**
   - Merge memory constraints + latest vault decisions.
   - If there is conflict, call it out explicitly and ask Klajdi which source should be canonical.

## Priority rules
- **Safety/preferences from MEMORY.md and workspace policies always apply.**
- **Newest explicit decision memo/checklist in Obsidian wins for execution details** unless Klajdi overrides.
- Never assume vault sync freshness; verify file dates when important.

## Output style
- Give a short action plan first.
- Add sources/paths when useful for verification.
- Keep recommendations concrete and immediately actionable.

## Quick checklist
- [ ] memory_search done
- [ ] memory_get done (if needed)
- [ ] Obsidian note(s) checked
- [ ] conflicts checked
- [ ] final answer synthesized
