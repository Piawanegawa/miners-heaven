---
description: Finish an implemented change - merge worktree, cleanup, archive, PR (Experimental)
---

Finish a change after `/opsx-apply`: merge the worktree, clean up, write a retrospective, archive, or open a PR.

**Input**: Optionally specify a change name (for example, `/opsx-finish add-auth`). If omitted, detect it from the `.worktrees/` directory.

**Finish workflow**:

```
 2. Detect    → Find the worktree to finish
 3. Commit + test → Switch to the worktree → commit unfinished work → run the test suite (verify the worktree itself)
 4. Retrospective → Write retrospective.md (file operation; unrelated to code)
 5. Archive   → Run openspec archive -y (file operation; unrelated to code)
 6. Options   → Read the finishing-a-development-branch skill → show four options
 7. Execute   → Carry out the user's choice
```

---

**There are two test points**, each targeting a different problem:

| When | What to test |
|------|--------|
| Step 3 — inside the worktree | Verify the worktree implementation is sound before proceeding with existing problems |
| After rebasing in option 1 | The base has changed, so the code may conflict with the new baseline. Test again after the rebase. |

---

### Step 2: Ensure the worktree exists and select it

```powershell
openspec-superpowers-opencode ensure-worktree <name>
```

If multiple worktrees exist, enter the one matching the user's requested name with `cd .worktrees/<name>`.

If no worktree exists, `ensure-worktree` will fail and exit. Without a worktree, there is no branch to finish.

### Step 3: Switch to the worktree, commit unfinished work, and run tests

```powershell
cd .worktrees/<name>
```

**3a. Commit uncommitted changes:**

**3a-1. Check the status**

```powershell
git status --porcelain
```

- Empty output → the worktree is clean; go to 3b

**3a-2. Commit the changes**

```powershell
git add -A && git commit
```

**3a-3. Confirm the commit**

```powershell
git log --oneline -1
```

- A new commit is shown → success; go to 3b  
- No new commit is shown, or an error occurs → failure; retry 3a-2

**3b. Run the test suite (detect the project type automatically):**

```
- If package.json exists → check whether it defines a test script; run `npm test` if it does, otherwise report WARNING "No test script; skipping" and continue
- If Cargo.toml exists → `cargo test`
- If requirements.txt or pyproject.toml exists → `pytest`
- If go.mod exists → `go test ./...`
- Otherwise → infer the test command from the Makefile / CI configuration or use AskUserQuestion
```

**If tests fail** → STOP, tell the user what failed, fix it, then run `/opsx-finish` again.

> This test point verifies the worktree implementation itself before proceeding with existing problems.
> It does not replace the post-rebase test: Step 3 tests the worktree itself, and the later test checks the changed baseline.

### Step 4: Write the retrospective

The current directory should already be the worktree (Step 3 ran `cd .worktrees/<name>`), but execution can end up on main. Switch again to be sure:

```powershell
cd .worktrees/<name>
```

Read the retrospective artifact instructions:

```powershell
openspec instructions retrospective --change "<name>"
```

Follow the instructions to write retrospective.md.

### Step 5: Archive the change

The current directory should be the worktree. Switch again to be sure:

```powershell
cd .worktrees/<name>
openspec archive <name> -y
```

This operation will:
- Sync the delta specs in `openspec/changes/<name>/specs/` into `openspec/specs/`.
- Move the change directory to `openspec/changes/archive/YYYY-MM-DD-<name>/`.

### Step 5a: Commit the archived change

```powershell
git add -A && git commit -m "<name>: archive change"
```

### Step 5b: Confirm the commit

```powershell
git log --oneline -1
```

- A new commit is shown → success; go to Step 6
- No new commit is shown, or an error occurs → retry Step 5a
- If Git reports "nothing to commit" (already up to date) → go directly to Step 6

### Step 6: Read the finishing-a-development-branch skill

Read:
  C:\Users\user\.cache\opencode\npm\git-superpowers-0958a5557860\1791633134726\node_modules\superpowers\skills\finishing-a-development-branch/SKILL.md

Follow the skill instructions:

**Step 6a: Determine the base branch** (usually main or master)

**Step 6b: Show the user four options:**

```
Implementation is complete. What would you like to do next?

1. Merge into the base branch locally
2. Push and create a pull request
3. Keep the branch for later
4. Discard this change

Choose an option:
```

**Do not add extra explanation** — keep the options concise.

### Step 7: Carry out the user's choice

#### Option 1: Merge locally (rebase)

> The worktree branch has not been pushed, so rebasing will not rewrite public history.
> Each task commit is a **meaningful logical boundary**; keeping them is more useful for `git blame` / `git bisect` than squashing them into one commit.
>
> **Two test points**:
> - Step 3 verified the worktree implementation itself.
> - Test again after rebase: the base changed, so the code may conflict with the new baseline.

**Clean up the registry** (before Git operations; independent of worktree state):
R1. `openspec-superpowers-opencode registry remove <name>`
R2. `openspec-superpowers-opencode registry list`
R3. Check whether the output contains `<name>`; if it does, return to R1.

```powershell
git checkout <feature-branch>
git rebase <base-branch>            # Rebase onto the latest base branch
<test command>                       # Run tests based on the detected project type
git checkout <base-branch>
git merge <feature-branch>          # Fast-forward
git worktree remove .worktrees/<name>  # Remove the worktree
git branch -d <feature-branch>
```

#### Option 2: Push and create a PR

```powershell
git push -u origin <feature-branch>
gh pr create --title "<title>" --body "## Summary\n..."
```

After creating the PR, the change has been pushed but not merged. Keep the worktree and registry entry.
After the PR is merged, the user may clean up manually (remove the registry entry before deleting Git resources):
- Remove the registry entry: `openspec-superpowers-opencode registry remove <name>` (retry if it fails).
- **Verify**: run `openspec-superpowers-opencode registry list` and confirm the output no longer contains `<name>`; if it does, retry the previous step.
- Remove the worktree: `git worktree remove .worktrees/<name>`.
- Delete the branch: `git branch -d <feature-branch>`.

#### Option 3: Keep the branch

Tell the user the branch and worktree paths. Do not clean anything up.

#### Option 4: Discard

Proceed only after the user types **'discard'** to confirm.

**Clean up the registry** (before Git operations; independent of worktree state):
R1. `openspec-superpowers-opencode registry remove <name>`
R2. `openspec-superpowers-opencode registry list`
R3. Check whether the output contains `<name>`; if it does, return to R1.

```powershell
git checkout <base-branch>
git worktree remove .worktrees/<name>
git branch -D <feature-branch>
```

---

**If no worktree exists**: if the user runs `/opsx-finish` after the corresponding worktree was manually removed,
check whether its branch remains and recommend that the user handle it manually.

**Idempotency**: skip the retrospective if retrospective.md already exists; skip archiving if the change is already archived.
