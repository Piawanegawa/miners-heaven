# Game Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish a minimal, testable Godot 4/GDScript top-down playable foundation for Miners Heaven.

**Architecture:** Keep movement/core rules in focused GDScript units that can be tested without rendering, and compose them into a collision-aware player scene. A compact tile-based placeholder world supplies walls and obstacles while a player camera follows; project checks and documentation provide repeatable headless validation.

**Tech Stack:** Godot 4, GDScript, built-in 2D scene/physics/tile facilities, minimal compatible automated test setup.

**Spec:** `openspec/changes/game-foundation/specs/top-down-game-foundation/spec.md` (design: `openspec/changes/game-foundation/design.md`)

## Global Constraints

- Use Godot 4 and GDScript.
- The game is 2D top-down, inspired by Stardew Valley.
- Support continuous eight-direction movement with normalized diagonal speed.
- Detect collision against walls and obstacles.
- Keep gameplay logic separate from presentation.
- Provide automated tests for movement and core logic.
- Provide headless Godot project validation.
- Use minimal dependencies and a maintainable project structure.
- Mining progression, ore tiers, upgrades, enemies, NPCs, economy, and skill systems are out of scope.

## Review Focus

- Opposing directional inputs cancel rather than leave residual movement; test this with the movement input helper.
- Collision at diagonal corners does not permit clipping through a wall/obstacle; test representative scene/player collision behavior.
- Zero input and rapid direction changes do not retain stale movement input; test zero input and consecutive movement vectors.
- Missing/unavailable Godot executable or malformed project returns a clear nonzero headless-validation result; test the wrapper's failure path where practical.
- Test or headless validation runs do not require a display server or import of production art; run the documented commands in headless mode.

---

## File Structure

Inspect the repository before implementation and preserve existing files and the independent `endless-mining-progression` change. Add or adapt only the following responsibilities, matching repository conventions where they already exist:

- `project.godot`: project settings and main-scene registration.
- `scenes/player/player.tscn`: player body, collision shape, visual placeholder, and following camera.
- `scripts/gameplay/player_movement.gd`: rendering-independent movement input normalization and core movement values.
- `scripts/presentation/player_controller.gd`: read input and apply core movement through Godot collision-aware character movement.
- `scenes/world/test_area.tscn`: small tile-based placeholder area and collidable walls/obstacles.
- `tests/`: automated movement/core tests and any minimal runner configuration required.
- `scripts/validate_project.ps1` or repository-appropriate equivalent: documented headless editor/project validation with clear failure status.
- `README.md` or project documentation: controls, structure, test and validation commands.

### Task 1: Project and independently testable movement core

**Files:**
- Create or modify: `project.godot`
- Create: `scripts/gameplay/player_movement.gd`
- Create: `tests/` movement/core test files and minimal runner configuration as needed
- Modify: `README.md` or project documentation

**Interfaces:**
- Produces: `PlayerMovement` core helper with a typed function that accepts a `Vector2` directional input and returns a normalized `Vector2` (zero remains zero); a configurable movement-speed value. The exact helper name should follow repository conventions and be recorded in the tests before scene integration.

- [ ] **Step 1: Inspect the repository and available Godot 4 CLI/version; record chosen project paths and exact validation/test commands.** Preserve unrelated changes and existing change directories.
- [ ] **Step 2: Write failing automated tests for cardinal input, diagonal normalization (magnitude 1), zero input, opposing inputs, and consecutive direction changes.**
- [ ] **Step 3: Run the focused tests and confirm they fail for the missing movement helper/behavior.**
- [ ] **Step 4: Implement the minimal typed GDScript movement helper; normalize only nonzero input and keep speed configurable.**
- [ ] **Step 5: Run the focused tests and confirm all movement/core assertions pass.**
- [ ] **Step 6: Add minimal Godot project configuration needed to load scripts and run the selected test mechanism; avoid unrelated project scaffolding.**

### Task 2: Player scene, collision, and playable tile area

**Files:**
- Create: `scenes/player/player.tscn`
- Create: `scripts/presentation/player_controller.gd`
- Create: `scenes/world/test_area.tscn`
- Modify: `project.godot`
- Test: headless scene-loading / integration tests under `tests/`

**Interfaces:**
- Consumes: Task 1 movement helper and configurable speed.
- Produces: main playable scene with player movement, collidable world geometry, and player-following camera.

- [ ] **Step 1: Add a failing headless scene/integration check asserting the main scene loads and includes the player, camera, tile-based ground, and collidable test geometry.**
- [ ] **Step 2: Add the player character scene with collision shape, visible placeholder, and camera; set the camera to follow the player.**
- [ ] **Step 3: Implement the presentation controller to read eight-direction input, call the movement helper, apply configured speed, and use Godot's collision-aware movement.**
- [ ] **Step 4: Build the small tile-based placeholder area with walls and obstacles using the selected Godot 4-compatible built-in 2D tile/world nodes.**
- [ ] **Step 5: Register the playable scene as the main scene and make the headless scene/integration check pass, including collision and camera configuration assertions.**
- [ ] **Step 6: Run the movement tests and headless playable-scene check; confirm no display is required.**

### Task 3: Validation and maintainable handoff

**Files:**
- Create: `scripts/validate_project.ps1` or repository-appropriate validation script
- Modify: `README.md` or project documentation
- Test: validation script behavior and full automated suite

**Interfaces:**
- Consumes: completed project, test runner, and main playable scene from Tasks 1–2.
- Produces: repeatable documented commands for headless project validation and automated tests, with failures reflected in exit status.

- [ ] **Step 1: Add a failing validation-script check for unavailable Godot/malformed project inputs, requiring a clear diagnostic and nonzero exit status where practical.**
- [ ] **Step 2: Implement the headless Godot validation command (for example, editor import/project check plus headless scene load) with propagated process exit status.**
- [ ] **Step 3: Document Godot 4 requirement, controls, project structure, automated test command, and headless validation command.**
- [ ] **Step 4: Run the complete automated suite and headless project validation from a clean invocation; confirm successful exit status and no rendering dependency.**
- [ ] **Step 5: Review the final project diff for unnecessary dependencies, excluded progression/content systems, and unrelated file changes.**

## Verification Commands

Use the exact commands established from the available Godot 4 installation and chosen minimal test runner in Task 1, and record them in project documentation. The final verification must include both the automated movement/core test command and a headless Godot project/main-scene validation command; each must return a failing status when its checks fail.

## Scope Coverage

- Movement normalization, zero input, opposing input, and core tests: Task 1.
- Collision-aware movement, obstacles/walls, tile area, and camera following: Task 2.
- Headless project validation, dependency/scope review, and test handoff: Task 3.
- Logic/presentation separation: Task 1 gameplay helper and Task 2 presentation controller.
