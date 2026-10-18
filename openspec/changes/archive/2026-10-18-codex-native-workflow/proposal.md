# Proposal

## Why

The global OpenSpec launcher was a stale shim pointing at a missing integration package, and the project’s active workflow skills still depended on OpenCode command files and tool names. This caused routine OpenSpec operations, including archival, to fail in Codex.

## What Changes

- Use the official OpenSpec CLI and its generated Codex skills as the canonical OpenSpec interface.
- Select OpenSpec’s built-in `spec-driven` schema as the project default and preserve the active mining progression change.
- Replace project workflow guidance that assumes OpenCode with concise Codex-specific guidance using the official CLI and available skills. Retain Codex-native fast-forward, apply-alias, and finish workflows because they preserve familiar entry points and manage the repository's worktree convention.
- Remove obsolete OpenCode command/skill copies, the OpenCode-only schema, and the unused integration lock file.
- Document setup, supported Codex skill names, and command-line health checks.

## Capabilities

### New Capabilities

None. This change updates developer tooling and workflow configuration without changing game behavior.

### Modified Capabilities

None.

## Impact

This affects `openspec/config.yaml`, the project’s `.agents/skills/` instructions, generated Codex OpenSpec skills, workflow documentation, and obsolete `.opencode/` and custom schema files. It does not alter Godot runtime code or the active mining progression requirements.
