---
name: opsx-sync
description: Sync a change's delta specifications into the main OpenSpec specifications using this repository's OPSX procedure. Use for explicit sync requests.
---

# OPSX Sync

Codex wrapper for OpenCode's `/opsx-sync`. Invoke in Codex as `$opsx-sync <change>`.

1. Read `.opencode/commands/opsx-sync.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-sync-specs/SKILL.md` when present.
2. Treat any text after `$opsx-sync` as the command's arguments. Resolve the planning root and delta spec paths from OpenSpec status; never infer or widen the set of specs to sync.
3. Read both delta and existing main specs before edits. Preserve unrelated requirements, honor command confirmation boundaries, and validate the resulting main specs.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
