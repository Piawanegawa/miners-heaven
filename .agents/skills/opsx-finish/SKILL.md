---
name: opsx-finish
description: Finish an implemented OpenSpec change using this repository's OPSX finish workflow, including its user-selected integration options. Use for explicit finish requests.
---

# OPSX Finish

Codex wrapper for OpenCode's `/opsx-finish`. Invoke in Codex as `$opsx-finish <change>`.

1. Read `.opencode/commands/opsx-finish.md` completely and follow it as the source of truth, including any referenced finishing skill.
2. Treat any text after `$opsx-finish` as the command's arguments. Resolve the matching worktree; do not guess when ambiguous.
3. Complete its in-worktree verification and retrospective steps, then present the available integration choices as specified. A `$opsx-finish` invocation alone does not choose among merge, rebase, PR, or cleanup options.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
