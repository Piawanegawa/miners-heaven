---
name: opsx-verify
description: Verify an OpenSpec implementation against its change artifacts before archiving using this repository's OPSX procedure.
---

# OPSX Verify

Codex wrapper for OpenCode's `/opsx-verify`. Invoke in Codex as `$opsx-verify <change>`.

1. Read `.opencode/commands/opsx-verify.md` completely and follow it as the source of truth. Also read `.opencode/skills/openspec-verify-change/SKILL.md` when present.
2. Treat any text after `$opsx-verify` as the command's arguments. Resolve artifacts from OpenSpec status and load all available planning context before reviewing implementation.
3. Check task completeness, requirement and scenario coverage, correctness, and design coherence. Report evidence and distinguish verified facts from uncertainty; verification does not itself archive the change.
4. Translate OpenCode-only tool calls to tools available in this Codex session. Never claim an unavailable operation succeeded; report exact limitations and use only a documented, authorized fallback.
