---
name: opsx-propose
description: Propose an OpenSpec change by creating and completing its planning artifacts under this repository's OPSX procedure. Use for explicit propose requests.
---

# OPSX Propose

Codex wrapper for OpenCode's `/opsx-propose`. Invoke in Codex as `$opsx-propose <name-or-description>`.

1. Read `.opencode/commands/opsx-propose.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-propose/SKILL.md` when present.
2. Treat any text after `$opsx-propose` as the change name or description. Resolve project context and schema as the source workflow requires; stop if the OpenSpec root is missing or invalid.
3. Create or complete planning artifacts only. Do not modify implementation code or start apply after proposal, even if the initial request also asks for implementation.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
