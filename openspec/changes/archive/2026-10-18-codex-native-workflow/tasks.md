# Tasks

## 1. Canonical OpenSpec configuration

- [x] 1.1 Set the project default to the built-in `spec-driven` schema, route behavior-changing apply tasks through test-first guidance, and update `openspec-change-workflow`; verify CLI apply instructions include that guidance and active project paths are correct.
- [x] 1.2 Replace the old `opsx-apply`, `opsx-ff`, and `opsx-finish` wrappers with Codex-native skills; verify `opsx-apply` delegates to the official apply skill, the worktree workflows contain no OpenCode paths, and Git ignores the worktree root.
- [x] 1.3 Remove obsolete `.agents/skills/opsx-*` wrappers except the retained Codex-native aliases, along with `.opencode/` files, bridge schema, and `skills.lock.json`; verify the deleted paths no longer exist and official `.agents/skills/openspec-*` skills remain.

## 2. User-facing setup documentation

- [x] 2.1 Document OpenSpec CLI prerequisites, Codex initialization, common official skills, and CLI health checks in README; verify every command is consistent with the installed CLI help.
- [x] 2.2 Explain Superpowers as a separate Codex plugin marketplace setup and distinguish it from repository-local Godot/OpenSpec skills; verify there are no misleading claims that the repository installs the plugin.

## 3. Integration verification

- [x] 3.1 Run official OpenSpec validation and list commands; verify the new workflow change and existing active `endless-mining-progression` change are both preserved.
- [x] 3.2 Scan active project skills and docs for OpenCode-only references and inspect the final diff; verify remaining references are limited to historical archived records or migration explanation.
