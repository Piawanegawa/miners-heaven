---
name: opsx-continue
description: Continue an OpenSpec change by creating its next artifact with this repository's OPSX procedure. Use for explicit continue requests.
---

# OPSX Continue

Codex wrapper for OpenCode's `/opsx-continue`. Invoke in Codex as `$opsx-continue <change>`.

1. Read `.opencode/commands/opsx-continue.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-continue-change/SKILL.md` when present.
2. Treat any text after `$opsx-continue` as the command's arguments. Resolve the change and inspect its artifact status; do not guess when ambiguous.
3. Create only the next artifact allowed by the active schema and the command. Preserve its planning-only boundary; do not implement code as part of continuing.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
