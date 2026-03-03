# Deep Research Workflow

**Trigger:** When Klajdi says "deep research on [TOPIC]" or "do a deep research about [TOPIC]"

## Core Rule

It must be **impossible to skip this workflow**, but still allow decision freedom.

- First read this file.
- Then decide execution mode based on evidence quality.
- Freedom is allowed only after explicit comparison against baseline method.

## Execution Modes

### Mode A — Baseline (default)
Parallel sub-agent lanes and fixed synthesis format.

### Mode B — Adaptive (allowed)
Alternative method is allowed **only if** it is justified as better on:
1. Information correctness
2. Truth/reliability
3. Richness/depth

If Mode B is used, include a short justification block before findings.

## Mandatory Decision Gate (before research starts)

Write this gate in the run log/report:

- `Workflow read: YES`
- `Chosen mode: A (Baseline) or B (Adaptive)`
- `Why this mode is better for this topic`
- `Expected tradeoff`

If this gate is missing, the run is invalid.

## Preflight Checklist (must pass before research starts)

1. Confirm topic scope and intended outcome.
2. Confirm lane coverage plan (all required source lanes below).
3. Confirm tools available for each lane.
4. Confirm output target path and naming.
5. If any item fails: send blocker report + options; wait for go/no-go.

## Baseline Process (Mode A)

Launch parallel sub-agents to cover these sources simultaneously:
1. **Twitter/X** — search for tweets, threads, discussions about [TOPIC] from last 2 weeks
2. **Reddit** — search relevant subreddits for posts, comments, discussions
3. **Hacker News** — search for stories and comment threads
4. **YouTube** — find recent videos, note angles, view counts, comments
5. **Web/blogs** — search for blog posts, articles, documentation

## Sub-agent Output Format
Each sub-agent produces:
- Key findings and insights
- Notable opinions (positive and negative)
- Links to sources
- Patterns or trends across multiple sources
- Gaps — things nobody is talking about yet

## Final Synthesis Sections (required order)
1. Executive summary (current state of [TOPIC])
2. Key themes and patterns
3. Common pain points people mention
4. What's being done well vs. what's missing
5. Opportunities (angles nobody has covered)
6. All source links organized by platform

## Completion Contract

Every deep research run must end with:
1. Per-source findings (all lanes covered, or explained deviations)
2. Final synthesis in required section order
3. Saved file path confirmation
4. Git commit + push confirmation
5. Protocol check line:
   - `Protocol check: ✅ followed`
   - or `Protocol check: ⚠️ adaptive deviation (justified)`
   - or `Protocol check: ❌ violation`

## Output

**Always, automatically — no exceptions:**
1. Write full synthesis to `~/virgil-vault/Research/YYYY-MM-DD-[topic-slug].md`
2. Commit and push immediately:
   ```
   cd ~/virgil-vault && git add Research/ && git commit -m "Research: [topic-slug]" && git pull --rebase && git push
   ```
3. Confirm to Klajdi: "Saved to vault → `Research/YYYY-MM-DD-[topic-slug].md`"

Do not wait to be asked. Save, commit, push as part of every research run.