# Deep Research Workflow

**Trigger:** When Klajdi says "deep research on [TOPIC]" or "do a deep research about [TOPIC]"

## Process

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

## Final Synthesis Sections
1. Executive summary (current state of [TOPIC])
2. Key themes and patterns
3. Common pain points people mention
4. What's being done well vs. what's missing
5. Opportunities (angles nobody has covered)
6. All source links organized by platform

## Output
Save to Obsidian vault: `~/virgil-vault/Research/YYYY-MM-DD-[topic-slug].md`
