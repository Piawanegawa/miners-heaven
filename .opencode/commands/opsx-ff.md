---
description: Create a change and generate all artifacts in isolated worktree (Experimental)
---

Fast-forward: create a worktree → generate all artifacts inside it → commit → return to main.

**Input**: A change name (kebab-case) or a description of the change.

### Step 1: Determine the name

Use the supplied name. If none was provided, ask with AskUserQuestion.

### Step 2: Confirm the Git repository has at least one commit

**2a. Check whether HEAD exists:**

```powershell
git rev-parse --verify HEAD
```

- Exit code 0 → go to 2c
- Non-zero exit code → go to 2b

**2b. Create the initial commit:**

```powershell
git add -A && git commit -m "chore: initial project setup"
```

Go to Step 3.

**2c. Check whether main has uncommitted changes:**

```powershell
git status --porcelain
```

- Empty output → go to Step 3
- Non-empty output → ask using the **question** tool:

  > **There are uncommitted changes on the main branch. Commit them first? (y/N)**
  >
  > - **N** → do not commit; go to Step 3
  > - **Y** →

  **2c-1. Commit the changes:**

  ```powershell
  git add -A && git commit
  ```

  **2c-2. Confirm the commit:**

  ```powershell
  git log --oneline -1
  ```

  - A new commit is shown → success; go to Step 3
  - No new commit is shown, or an error occurs → failure; retry 2c-1

### Step 3: Create an isolated worktree

Artifacts are generated on the feature branch and leave no changes on main.

**3a. Create the worktree:**

```powershell
openspec-superpowers-opencode ensure-worktree <name>
cd .worktrees/<name>
# Copy the .gitignore-excluded openspec/schemas/ and config.yaml into the worktree
New-Item -ItemType Directory -Force -Path 'openspec/schemas' | Out-Null
Copy-Item -Path '<project-root>/openspec/schemas/*' -Destination 'openspec/schemas/' -Recurse -Force
Copy-Item -LiteralPath '<project-root>/openspec/config.yaml' -Destination 'openspec/' -Force
```

**Verify the copy succeeded:**
```powershell
Test-Path -LiteralPath 'openspec/config.yaml' -PathType Leaf
Test-Path -LiteralPath 'openspec/schemas/superpowers-bridge-opencode/schema.yaml' -PathType Leaf
Test-Path -LiteralPath 'openspec/schemas/superpowers-bridge-opencode/templates/brainstorm.md' -PathType Leaf
```

- **Success** → continue
- **Failure** → repeat the copy and verify again; do not continue until it succeeds

**3b. Initialize the code index:**

```
- If the `codegraph` command is available → run `codegraph init`
```

If the command is unavailable or initialization fails, continue; this does not block the workflow.

### Step 4: Create the change inside the worktree

```powershell
openspec new change "<name>"
```

#### Step 4a: Register the change in the registry

Register the change so later opsx commands can find the active change and its worktree:

```powershell
openspec-superpowers-opencode registry add <name> .worktrees/<name>
```

- **Success (exit 0)** → continue to Step 5
- **Failure (exit 1)** →
  - Run `openspec-superpowers-opencode verify` and show its output to the user.
  - Use the `question` tool to ask the user to **Repair** or **Stop**.
  - If the user chooses **Repair**, run the repair command from the verify output; after it succeeds, resume Step 4a.
  - If the user chooses **Stop**, end the workflow.

### Step 5: Generate all artifacts

Use **TodoWrite** to track artifact progress.

Process artifacts in dependency order, starting with those whose `status` is `"ready"`:

For each artifact:

a. Get the instructions:

```powershell
openspec instructions <artifact-id> --change "<name>" --json
```

b. Read completed dependency artifacts for context.

c. Create the file using the `template` structure and `instruction` guidance.

d. Display "✓ Created <artifact-id>".

e. Repeat until every `applyRequires` field in `openspec status --change "<name>" --json` is `"done"`.

### Step 6: Commit the artifacts and return to main

```powershell
git add -A && git commit -m "change: <name>"
cd <project-root>
```

### Output

- Change: `<name>`
- Worktree: `.worktrees/<name>/`
- Branch: `feature/<name>`
- Artifacts created: `<N>`
- Next: run `/opsx-apply` to begin implementation

### Artifact Creation Guidelines

- `context` and `rules` constrain your work; they are not content to write into files.
- Always read dependency artifacts before creating a new artifact.
- If the context is unclear, prefer AskUserQuestion.
- Confirm each artifact file was written before proceeding to the next one.
