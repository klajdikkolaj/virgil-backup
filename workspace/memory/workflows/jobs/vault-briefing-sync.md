# Job SOP - Vault Briefing Sync

## Objective
Sync morning briefing markdown to GitHub with minimal side effects.

## Steps
1. `cd /home/clawdkbot/virgil-vault`
2. `git pull --rebase --autostash`
3. `git add Daily/*-briefing.md`
4. If no staged changes: return `No briefing changes to sync.`
5. If staged changes:
- `git commit -m "chore(briefing): sync daily briefing $(date +%F)"`
- `git push origin HEAD`

## Safety
- Do not modify unrelated files.
- On rebase/merge conflict: stop and report failure.

## Output
Return one line: `synced` / `no-changes` / `failed` + reason.
