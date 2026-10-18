---
name: opsx-ff
description: Fast-forward an OpenSpec change into a new worktree and generate its planning artifacts using this repository's OPSX procedure. Use for explicit fast-forward requests.
---

# OPSX Fast-Forward

Codex wrapper for OpenCode's `/opsx-ff`. Invoke in Codex as `$opsx-ff <name-or-description>`.

1. Read `.opencode/commands/opsx-ff.md` completely and follow it as the source of truth.
2. Treat any text after `$opsx-ff` as the command's name or change description. Preserve its main-worktree checks, worktree isolation, artifact generation, and commit boundaries.
3. Do not overwrite, reset, stash, or broadly stage existing user changes. Do not merge or push unless the command and the user's selected option authorize it.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
