---
description: Implement an existing OpenSpec change in its worktree using Superpowers v7 (experimental)
---

# Apply an OpenSpec change — Superpowers v7

This command is explicitly invoked by the user. Its invocation authorizes the internal implementation workflow; do not ask the user to invoke `/opsx-apply` again. It does **not** authorize merges, pushes, publishing, deleting worktrees, or other irreversible/external operations. `/opsx-finish` is a separate user-invoked command.

**Input:** Optional change name, e.g. `/opsx-apply hello-world`. If omitted, infer only when unambiguous; otherwise ask the user to choose.

**Scope:** Implement an already planned OpenSpec change **inside its existing worktree**, run tests and reviews, update task tracking, and commit implementation changes. Do not merge, archive, or remove the worktree. Treat the OpenSpec spec as the requirements authority and Superpowers v7's installed skills as the implementation-process authority.

## 1. Resolve the change and worktree

- Confirm the current directory belongs to an oso-initialized Git/OpenSpec project. If not, stop with a useful error.
- Resolve the change name from the argument, context, or active changes (`openspec list --json`). If ambiguous, ask; do not guess.
- Run `oso verify` (or `openspec-superpowers-opencode verify` if `oso` is unavailable). If it fails, show the diagnostics and ask before attempting repairs.
- Use `oso ensure-worktree <name>` only as documented. Confirm the returned/expected worktree belongs to this repository and change. Never create or modify a worktree for a different change.
- Work in `.worktrees/<name>/` (resolve the actual path); verify its Git branch, status, and repository root before edits. If existing unrelated changes are present, stop and ask rather than overwrite, reset, stash, or include them in commits.
- Announce `Using change: <name>` and the resolved worktree path.

## 2. Read the OpenSpec contract

From the change worktree, run:

```sh
openspec instructions apply --change "<name>" --json
```

Read the referenced schema's `apply` instructions and all relevant change artifacts, especially the spec, `design.md`, `tasks.md`, and `plan.md`. Paths may differ by schema; locate them instead of assuming a fixed layout. If a plan or binding spec is absent, stop and explain what is missing; do not improvise a full implementation plan.

Resolve contradictions by following the spec over the plan. Record material decisions in the Superpowers ledger, as prescribed by the skill. Do not silently change user requirements (for example, do not replace `unittest` with `pytest` if the spec mandates `unittest`).

## 3. Superpowers v7 preflight — mandatory

- Locate the installed Superpowers skill root through OpenCode's available skill discovery or the actual installation directory. Do not use a hard-coded user-specific cache path. Read `../package.json` relative to the skill root and verify that its **major version is 7**. If another version is installed, stop: this command was written for v7.
- Read the **complete** `subagent-driven-development/SKILL.md`, not just its first screen or a summary, along with `implementer-prompt.md`, `task-reviewer-prompt.md`, `re-review-prompt.md`, `test-driven-development/SKILL.md`, and `requesting-code-review/code-reviewer.md`. Check that `scripts/sdd-workspace`, `scripts/task-brief`, and `scripts/review-package` exist. Follow their usage as described in the installed skill; do not assume v5/v6 behavior or invent script flags.
- Check the required toolchain and tests specified by the plan. Before installing/building, ensure `.gitignore` excludes generated artifacts (e.g. `__pycache__/`, `*.pyc`, `.venv/`, `node_modules/`, `dist/`, `target/`). Avoid broad staging of generated files.
- **OpenCode 2.0.27 integration:** The built-in `general` agent is registered as a subagent, and the primary `build` agent has `subagent: allow`. A real `General Subagent` invocation has already succeeded in this environment. Do not mistake the absence of legacy agent-delegation conventions for lack of subagent support.
- Use **OpenCode's native subagent delegation tool** to invoke `general` for implementer and reviewer roles. Let OpenCode supply the actual tool name and argument schema; do not invent a tool invocation. Explicitly instruct the orchestrating agent to delegate rather than perform the work itself. Confirm an actual subagent invocation before claiming delegation succeeded.
- Dispatch a **fresh `general` subagent invocation per implementation task** and a **separate fresh `general` invocation for review**. The same named agent type is acceptable; isolation comes from separate invocations and narrowly scoped prompts. Never let the implementer approve its own work in place of the independent review.
- Use the `general` subagent for the final whole-branch review as well, with the installed v7 reviewer instructions. The read-only `explore` agent may assist with discovery but must not implement changes.
- Each delegated prompt must include the **absolute worktree path**, change name, task number, relevant artifact paths, role-specific Superpowers prompt, applicable TDD instructions, and explicit scope. Instruct the subagent to verify its working directory and operate only in the change worktree. Do not assume a subagent inherits the orchestrator's current directory or conversational context.
- Before starting implementation, perform one small **read-only** native `general` delegation to verify tool availability if this session has not yet demonstrated a successful call. If that call fails, report the exact tool error and ask whether the user wants the documented Superpowers `executing-plans` inline alternative. Do not silently fall back or conclude failure merely from tool-name introspection.

## 4. Delegate execution to the installed v7 skill

Follow the installed `subagent-driven-development/SKILL.md` as the source of truth, including any steps beyond this summary:

1. Establish or resume the **plan-specific** workspace using `scripts/sdd-workspace` as directed by the skill. Read its `progress.md` ledger before dispatching work. Never reset another plan's ledger or redo tasks already recorded complete.
2. Read the entire plan and binding spec. Perform the skill's task/interface conflict scan and record the findings and any rulings in the ledger.
3. For each unfinished task, prepare the task brief using the v7 procedure, dispatch a fresh **native OpenCode `general` subagent** as implementer with the installed `implementer-prompt.md`, and supply the relevant plan/spec/absolute-worktree context plus the installed TDD instructions. Confirm the delegation tool was actually called. Require RED → GREEN → REFACTOR, test execution, and an implementation commit as the skill prescribes.
4. Generate a review package using the installed v7 procedure and dispatch a **separate native OpenCode `general` subagent** as task reviewer using `task-reviewer-prompt.md`. The reviewer must not be the same invocation as the implementer. Review both spec compliance and code quality. For findings, follow v7's bounded fix/re-review loop using `re-review-prompt.md`; record decisions and results in the ledger. Do not mark an OpenSpec task complete merely because code was written.
5. After all tasks, delegate the **whole-branch review** required by v7 to a fresh native `general` subagent using `requesting-code-review/code-reviewer.md`; handle findings as the installed skill directs. Respect its stop conditions for destructive, security-sensitive, external, or fundamentally unresolvable work.
6. Mark completed items in the OpenSpec `tasks.md` only when corresponding work is implemented, tested, and reviewed. Preserve existing completed tasks and the ledger's resumability.

The installed v7 skill takes precedence over this outline for its internal execution mechanics. However, this command's boundaries remain mandatory: stay inside the change worktree and do not merge, push, publish, archive, or delete it. If the skill's final step suggests `finishing-a-development-branch`, **stop before performing branch-finalization actions**; those belong to `/opsx-finish`.

## 5. Verify and commit

In the change worktree:

```sh
openspec status --change "<name>" --json
```

Run the project's actual test suite and any verification commands specified by the plan. Check task checkboxes against implemented behavior, inspect `git status`, and confirm the ledger/review state. OpenSpec artifact completion alone does **not** prove implementation correctness.

Commit only relevant tracked changes and intentionally added source/test/spec files; do not blindly run `git add -A` over unrelated files. If no changes remain, do not create an empty commit. If verification fails, report the failure and leave the worktree available for repair/resumption.

## 6. Report

Report the change name, worktree, branch, completed vs remaining tasks, test commands and results, reviews performed, and commit IDs. State explicitly whether genuine native `general` subagents were used, including how many implementer and reviewer invocations succeeded. Do not treat a verbal claim of delegation as evidence of a tool call. If successful, say that `/opsx-finish <name>` is the **next user-invoked** step; do not execute it automatically.

**Resume behavior:** Re-running `/opsx-apply <name>` must consult the existing worktree, Git history, OpenSpec tasks, and the plan-specific Superpowers ledger. Never reset, discard, or repeat completed work merely because a previous session ended.
