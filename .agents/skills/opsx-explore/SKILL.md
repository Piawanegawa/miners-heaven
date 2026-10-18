---
name: opsx-explore
description: Explore an idea or problem in this repository using the planning-only OPSX explore mode. Use for explicit explore requests.
---

# OPSX Explore

Codex wrapper for OpenCode's `/opsx-explore`. Invoke in Codex as `$opsx-explore <topic>`.

1. Read `.opencode/commands/opsx-explore.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-explore/SKILL.md` when present.
2. Treat any text after `$opsx-explore` as the topic or arguments. Inspect relevant repository context before asking for facts that can be verified locally.
3. Keep exploration read-only except for OpenSpec planning artifacts explicitly allowed by the source workflow. Before any write that the source requires confirmation for, obtain that confirmation.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
