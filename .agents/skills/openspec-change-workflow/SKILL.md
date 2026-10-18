---
name: openspec-change-workflow
description: Plan, specify, implement, verify, or archive a Miners Heaven change using this repository's OpenSpec artifacts and conventions.
---

# OpenSpec change workflow

Use this skill when the user asks to shape or implement a project change, or to review its OpenSpec artifacts.

## Repository context

- OpenSpec artifacts are under `openspec/`; the selected schema is `superpowers-bridge-opencode`.
- The root repository is the planning/configuration repo. The current Godot implementation lives in `.worktrees/game-foundation/`.
- Preserve other active changes. Do not treat a proposal or task checklist as proof that its behavior is implemented.
- OpenCode's `/opsx-*` commands are not Codex slash commands. In Codex, use this skill and the `openspec` CLI when it runs successfully.

## Workflow

1. Identify the named or clearly implied change. If multiple active changes fit and none is clear, list them with `openspec list --json` and ask which to use.
2. Check status and dynamic instructions with `openspec status --change "<name>" --json` and `openspec instructions <operation> --change "<name>" --json`. Read every returned context file before acting.
3. Follow the active schema and its artifacts. Keep proposal, specification, design, tasks, verification, and retrospective content in the existing OpenSpec structure.
4. For implementation, work through the listed tasks in order, make each change focused, and mark a task complete only after its specified behavior is fully implemented.
5. Verify with the project's documented checks when requested or needed to substantiate a claim. Report what ran and any failures.
6. Archive only when the user asks or the workflow explicitly calls for it.

If the CLI fails because its launcher cannot access or repair files outside the workspace, do not retry commands that mutate that installation. Continue with read-only inspection of the relevant OpenSpec files and explain that CLI execution is blocked by the current environment.
