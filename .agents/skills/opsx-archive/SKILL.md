---
name: opsx-archive
description: Archive a completed OpenSpec change using this repository's OPSX procedure. Use for explicit archive requests.
---

# OPSX Archive

Codex wrapper for OpenCode's `/opsx-archive`. Invoke in Codex as `$opsx-archive <change>`.

1. Read `.opencode/commands/opsx-archive.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-archive-change/SKILL.md` when present.
2. Treat any text after `$opsx-archive` as the command's arguments. Resolve the named change and planning root as specified; do not guess when ambiguous.
3. Preserve the command's validation, spec-sync, archive, and confirmation boundaries. Do not merge or remove worktrees unless that workflow and the user's selected option authorize it.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
