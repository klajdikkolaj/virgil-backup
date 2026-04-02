# Workflow — File Intake Sync
_Last updated: 2026-03-31_

Purpose: make files sent in chat easy to discover from any OpenClaw session.

## Rule
When Klajdi sends an important file, register it in memory immediately.

## Steps
1. Keep original upload in inbound media path.
2. Create/update a canonical note under `memory/contacts/` or `memory/projects/` with:
   - canonical label
   - original file path
   - date/source channel
   - intended use
3. Add a pointer in `MEMORY.md` only if it is durable and reused often.
4. For CV/resume files, use canonical file: `memory/contacts/cv-klajdi.md`.

## Naming convention
- Contacts: `memory/contacts/<name>-<artifact>.md`
- Projects: `memory/projects/<project>-<artifact>.md`

## Retrieval convention
When asked for a known uploaded file, first check canonical memory note path, then resolve to original media file path.
