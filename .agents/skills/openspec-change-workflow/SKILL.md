---
name: openspec-change-workflow
description: Repository conventions for planning, implementing, verifying, and archiving Miners Heaven changes with OpenSpec in Codex.
---

# OpenSpec change workflow

Use the generated `openspec-*` skills for standard OpenSpec operations. `$opsx-apply` is a Codex-native alias for `$openspec-apply-change`. Use the official `openspec` CLI for status, instructions, validation, and listing. Use `opsx-ff` to start a fully planned change in an isolated worktree, and `opsx-finish` when an implemented worktree is ready for integration.

## Repository conventions

- The default OpenSpec schema is `spec-driven`. Each change can declare a schema in its `.openspec.yaml`; preserve that declaration and its artifact conventions.
- OpenSpec artifacts live under `openspec/`. Game implementation is in the repository's Godot project; use the repository's Godot and test-first skills when implementation requires them.
- Preserve other active changes. In particular, do not treat a proposal or unchecked task list as proof that behavior is implemented.
- Read `openspec status --change "<name>" --json` and the dynamic `openspec instructions <operation> --change "<name>" --json` before authoring or applying artifacts. Read all returned context files and dependencies.
- Mark a task complete only after implementing its described work and running the verification it specifies.
- Run project checks when needed to support an implementation or verification claim, and report what ran and any failures.
- Archive only when the user asks or the selected workflow explicitly includes it. Never merge, push, delete a branch, or remove a worktree without the user's selected integration action.

## CLI setup

Install the official CLI with `npm install -g @fission-ai/openspec@latest` (Node.js 20.19 or newer), then initialize Codex skills in this repository with `openspec init --tools codex`. Confirm the setup with `openspec --version`, `openspec list --json`, and `openspec validate --all --json`.
