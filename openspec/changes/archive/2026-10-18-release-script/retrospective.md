# Retrospective: release-script

> Written: 2026-10-18 (after implementation verification)
> Commit range: `cd67f6d0bf739de4fd1be28d38abdaa82cddcbd8..c8f18f3afcbe76a4dd1bd3407c62d4d874d4a242`
> Worktree: `C:\projects\miners-heaven\.worktrees\release-script`

---

## 0. Evidence

- **Commit range**: `cd67f6d..c8f18f3` (2 commits)
- **Diff size**: 12 files changed, 553 insertions, 3 deletions
- **Tasks done**: 4/4 (`tasks.md`)
- **Active hours**: n/a; work spanned multiple turns with idle gaps
- **Subagent dispatches**: 0 native OpenCode `general` invocations
- **New external dependencies**: none
- **Bugs encountered post-merge**: n/a; the branch has not been merged
- **OpenSpec validate state at archive**: PASS in the apply run (`release-script` valid; unrelated warnings elsewhere); unavailable during finish because the installed OpenSpec npm package is missing
- **Test coverage signal**: 80 automated checks passed (9 build-script scenarios, 12 validator checks, 32 movement assertions, 27 playable-scene assertions)

Commit chain (chronological order):

```
16a0303 change: release-script
c8f18f3 feat: add Windows build script
```

## 1. Wins

- The tracked Windows Desktop x86_64 preset and PowerShell build script provide Release by default and selectable Debug builds with documented output paths (`export_presets.cfg`, `scripts/build_windows.ps1`, `README.md`).
- The build script's 9 scenarios passed, including configuration selection, executable discovery, output creation, and failure reporting (`tests/test_build_windows.ps1`).
- The full Godot validation and gameplay test set passed: 12 validator checks, 32 movement assertions, and 27 playable-scene assertions (`tests/test_validate_project.ps1`, `tests/test_player_movement.gd`, `tests/test_playable_scene.gd`).

## 2. Misses

- 🟡 [painful | Godot reported missing `windows_debug_x86_64.exe` and `windows_release_x86_64.exe` under the 4.7.2 template directory] The real Windows export could not produce an executable because matching Godot export templates are not installed. The build script reports this prerequisite; the user must install the matching templates before exporting.
- 🟡 [painful | `openspec` reported a missing `@fission-ai/openspec` module and the `openspec-superpowers-opencode` command was unavailable] The documented retrospective-instructions and archive commands could not run in this environment. The repository template and documented archive effects are used as the fallback; the CLI limitation is reported with the finish result.
- 📌 [nit | the Godot executable under AppData was denied to the normal sandbox invocation] Tests passed after the Godot verification command received approved elevated access.
- 📌 [nit | native OpenCode implementer/reviewer delegation was unavailable] The user chose the inline workflow after this limitation was explained; implementation and review evidence is therefore inline.

## 3. Plan deviations

| Plan task | What changed | Why |
|-----------|--------------|-----|
| Apply execution workflow | Native per-task implementer/reviewer dispatches were not used; implementation and review proceeded inline. | The Codex session lacked the OpenCode `general` delegation tool, and the user selected the inline alternative. |
| Task 2.2 real export | Preset loading and the build-script error path were verified, but no executable was produced. | The matching Godot 4.7.2 Windows export templates were not installed. |
| Finish retrospective/archive commands | The OpenSpec CLI instructions/archive commands could not execute; the retrospective template is used and archive file effects are prepared as a documented fallback. | The OpenSpec npm package referenced by the installed shim is missing from AppData, and the wrapper cannot self-repair in this environment. |

## 4. Skill / workflow compliance

| Skill | Used |
|---|---|
| superpowers:brainstorming | ✓ |
| superpowers:writing-plans | ✓ |
| superpowers:using-git-worktrees | ✓ |
| superpowers:subagent-driven-development | ✗ |
| (transitive) superpowers:test-driven-development | ✗ (a failing test before implementation is not evidenced in the commit history) |
| (transitive) superpowers:requesting-code-review | ✗ (no dedicated reviewer invocation) |
| superpowers:finishing-a-development-branch | ✓ (verification and retrospective completed; integration choice remains with the user) |

### Deliberately Skipped Skills

- **`superpowers:subagent-driven-development`**
  - **What was skipped**: Native per-task implementer/reviewer dispatches and a native whole-branch reviewer.
  - **Why this cycle**: The Codex session exposed no native OpenCode `general` delegation tool. The user selected the inline alternative when asked.
  - **How to prevent recurrence**: `scope-judgment rule` — check native delegation before applying; when unavailable, explain the limitation and get the user's choice before implementation.
- **`superpowers:test-driven-development`**
  - **What was skipped**: A recorded RED → GREEN → REFACTOR sequence.
  - **Why this cycle**: The test and implementation commits do not show a failing test before implementation.
  - **How to prevent recurrence**: `skill description tightening` — record a failing test before implementation so test-first compliance can be audited.
- **`superpowers:requesting-code-review`**
  - **What was skipped**: A separate reviewer invocation.
  - **Why this cycle**: No dedicated reviewer tool was available, and the user authorized inline execution after the limitation was explained.
  - **How to prevent recurrence**: `scope-judgment rule` — identify the lack of a reviewer tool and ask before substituting inline review.

## 5. Surprises

- Godot recognized the `Windows Desktop` preset but could not export until its exact 4.7.2 templates are installed; this was the remaining machine prerequisite rather than a preset error.
- The Godot binary and OpenSpec npm package both sit outside the workspace boundary, so verification and archive tooling were affected by sandbox access and local installation state.

## 6. Promote candidates → long-term learning

- [ ] 🟡 **Record inline fallback limits before OPSX apply begins** → **Promote to skill** (`.agents/skills/opsx-apply/SKILL.md`)
  > **Why**: Native implementer and reviewer delegation was unavailable again, and the user had to choose inline work after the limitation appeared.
  > **How to apply**: Before OPSX apply, check native delegation and state the documented inline fallback if it is unavailable.
- [ ] 📌 **Keep evidence of the TDD red phase** → **Promote to one-off**
  > **Why**: Test and implementation commits do not establish the order in which they were created.
  > **How to apply**: In future apply cycles, record the failing test before changing implementation.
