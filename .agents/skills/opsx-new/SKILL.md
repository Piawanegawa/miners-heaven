---
name: opsx-new
description: Start an OpenSpec change with this repository's experimental OPSX artifact workflow. Use for explicit new-change requests.
---

# OPSX New

Codex wrapper for OpenCode's `/opsx-new`. Invoke in Codex as `$opsx-new <name-or-description>`.

1. Read `.opencode/commands/opsx-new.md` completely and follow it as the source of truth.
2. Treat any text after `$opsx-new` as the change name or description. Understand the requested outcome before creating a change; derive a kebab-case name only when appropriate.
3. Use the configured default schema unless the user asks for another one. Create planning artifacts only; do not implement the change in the same workflow.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
