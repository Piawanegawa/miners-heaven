---
name: opsx-finish
description: Verify and prepare an implemented OpenSpec worktree for integration, then carry out the user's selected integration option.
---

# Finish an OpenSpec worktree

Use when the user explicitly asks to finish an implemented change, for example `$opsx-finish release-script`.

1. Resolve the requested change to exactly one existing worktree and branch. If there is no match or multiple matches, report the candidates and ask which to finish. Never create a replacement worktree implicitly.
2. Inspect `git status`, OpenSpec status, and the change tasks in that worktree. Preserve uncommitted work; do not stage or commit unrelated files. If the implementation tasks are unfinished, explain what remains and stop before archiving.
3. Run only the verification required by the change artifacts or explicitly requested by the user. Report every command and result. If verification fails, stop and summarize the failure.
4. Complete the OpenSpec verify and archive workflows using `$openspec-verify-change` and `$openspec-archive-change` when the artifacts call for them. Read and follow their current generated skill instructions. Preserve the worktree branch after archiving.
5. Present the integration choices and wait for an explicit selection before performing one:
   - Merge the branch into its base branch locally.
   - Push the branch and create a pull request, if a remote and GitHub CLI are configured.
   - Keep the branch and worktree.
   - Discard the branch and worktree (require the user to explicitly confirm the word `discard`).
6. Carry out only the selected action. Do not push, merge, delete branches, or remove worktrees before the selection. After local merge, report the resulting commit and whether cleanup completed.
