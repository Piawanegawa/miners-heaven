# Design

## Context

See `proposal.md` for the motivation and scope. The official OpenSpec CLI generated Codex skills under `.agents/skills/openspec-*`. Older project workflows remain beside them and assume OpenCode command files, including a custom schema that delegates to OpenCode tool names. The project has one active gameplay change that must continue to use its own declared schema.

## Goals / Non-Goals

**Goals:** Make the repository's default OpenSpec workflow discoverable and executable in Codex using the official CLI and generated skills. Keep project-specific guidance for Godot development and preserve the active gameplay change.

**Non-Goals:** Install or manage the Superpowers Codex plugin from repository scripts; change global Codex settings; migrate archived change records; alter game behavior.

## Decisions

- Use the official OpenSpec-generated skills for proposal, apply, continue, explore, sync, update, verify, and archive. Retain concise Codex-native `opsx-apply` as an alias to the official apply skill, plus `opsx-ff` and `opsx-finish` for this repository's isolated worktree lifecycle. Remove all OpenCode command/skill copies.
- Set `openspec/config.yaml` to the built-in `spec-driven` schema. Existing active changes retain their explicit schema metadata and are not rewritten.
- Retain `openspec-change-workflow` as a short repository-specific guide. It will point users to the generated skills and official CLI, explain the repository's preservation and validation conventions, and avoid duplicating OpenSpec's operation instructions.
- Add OpenSpec apply guidance that routes observable gameplay behavior changes through the repository test-first skill and the user-level Superpowers TDD skill, while leaving docs/config-only work out of that cycle.
- Ignore `.worktrees/` in Git so the isolated worktrees used by the project remain local working state.
- Remove the custom `superpowers-bridge-opencode` schema and `skills.lock.json`; neither is used by the official Codex integration. Treat Superpowers as a separate Codex app plugin installed from its plugin marketplace. Keep repository-owned Godot and test-first skills independent from plugin installation.
- Document prerequisites, initialization, common `$openspec-*` skills, and CLI validation in README. Do not add a project-local shim for the CLI; the supported executable is the official OpenSpec install.

Alternatives considered: Keeping every old wrapper would preserve familiar names but continue maintaining duplicate instructions; dropping the three retained aliases would break familiar entry points or remove the worktree lifecycle; translating the custom schema would preserve its OpenCode coupling; making Superpowers a repository dependency would conflate a Codex app plugin with project files.

## Risks / Trade-offs

- Existing users may have memorized `$opsx-*` names → README documents the official `$openspec-*` names and maps the change to the official skill workflows.
- A machine-local command shim can shadow the official CLI → document checking `openspec --version` and use a direct official launcher only as a local setup repair; don't recreate the shim in this repository.
- The global Superpowers plugin might not be installed on every Codex host → repository workflows remain usable with native OpenSpec skills; README explains that plugin installation is a separate Codex setup step.

## Migration Plan

1. Update the project default schema and repository-specific skill documentation.
2. Remove obsolete OpenCode skills, commands, backup, bridge schema, and package lock.
3. Add Codex/OpenSpec/Superpowers setup guidance to README.
4. Validate OpenSpec artifacts, confirm the active change remains listed, and scan active repository instructions for OpenCode-only references. Rollback by reverting this isolated change; no runtime data migration is required.
