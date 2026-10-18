---
name: opsx-update
description: Revise existing OpenSpec planning artifacts and keep a change coherent using this repository's OPSX procedure. Never edits implementation code.
---

# OPSX Update

Codex wrapper for OpenCode's `/opsx-update`. Invoke in Codex as `$opsx-update <change>`.

1. Read `.opencode/commands/opsx-update.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-update-change/SKILL.md` when present.
2. Treat any text after `$opsx-update` as the command's arguments. Resolve artifact paths from OpenSpec status and revise only existing artifacts permitted by the workflow.
3. Keep changes coherent across the plan, specs, and other existing artifacts. Never edit implementation code or create the next artifact as part of an update.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
