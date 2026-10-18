---
name: opsx-ff
description: Create an OpenSpec change in a new isolated Git worktree and prepare its planning artifacts for implementation.
---

# OpenSpec fast-forward workflow

Use when the user explicitly starts a new change with `$opsx-ff <name-or-description>`.

1. Derive a kebab-case change name from the request if none was supplied. Check that the main worktree is clean and that no branch or worktree already uses the name. If the main worktree has changes, leave them untouched and explain that the user should commit or otherwise resolve them first.
2. Create a branch named `codex/<change-name>` in `.worktrees/<change-name>` from the current `main` HEAD using `git worktree add -b`. Do not switch or commit in the main worktree.
3. In the new worktree, confirm `openspec list --json` sees this project and create a new change with schema `spec-driven` using `openspec new change <change-name> --schema spec-driven`.
4. Read `openspec status --change <change-name> --json`. For each ready artifact in dependency order, fetch `openspec instructions <artifact-id> --change <change-name> --json`, read all listed dependencies/context, and write the artifacts using the returned instructions. Use the repository's generated OpenSpec skills for their operation guidance. For tooling-only changes with no requirement-level behavior changes, set `skip_specs: true` in that change's `.openspec.yaml` and confirm status reports specs as skipped.
5. Recheck status and validate the change. Do not mark implementation tasks complete during planning. Leave the branch and worktree available for `$openspec-apply-change`.

Report the change name, branch, worktree path, artifacts completed, and the next Codex skill to invoke. Do not merge, push, or remove the worktree.
