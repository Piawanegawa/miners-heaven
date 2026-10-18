---
name: miners-heaven-test-first
description: Use a test-first cycle for behavior changes in the Miners Heaven Godot project.
---

# Test-driven development

For a behavior change with a clear observable result:

1. Locate the relevant runner under `.worktrees/game-foundation/tests/` and add a focused failing assertion for the requested behavior.
2. Run the focused headless Godot or PowerShell check and confirm it fails for the expected reason.
3. Implement the smallest change that satisfies the requirement.
4. Rerun the focused check, then run the broader documented suite when requested or when the change may affect adjacent behavior.
5. Report the checks actually run and their results. Do not claim a check passed if the tool could not run.

Follow the existing test style and avoid introducing a test framework for this project.

