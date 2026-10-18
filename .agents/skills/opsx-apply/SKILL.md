---
name: opsx-apply
description: Apply a planned OpenSpec change in its existing worktree using this repository's OPSX procedure. Use for explicit apply requests.
---

# OPSX Apply

Codex wrapper for OpenCode's `/opsx-apply`. Invoke in Codex as `$opsx-apply <change>`.

1. Read `.opencode/commands/opsx-apply.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-apply-change/SKILL.md` when present.
2. Treat any text after `$opsx-apply` as the command's arguments. Resolve the named change and its worktree as specified by the command; do not guess when ambiguous.
3. Preserve its task scope, worktree rules, verification, review, and commit requirements. Do not perform the separate `/opsx-finish` workflow unless requested separately.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable delegation or operation succeeded. If the source requires a capability this session lacks, report the exact limitation and use a documented fallback only when the user has authorized it.
