## Context

Miners Heaven needs a reliable, small playable base before gameplay systems are layered on. This change establishes a Godot 4 project using GDScript, presented as a 2D top-down game. The initial slice is a movement-and-world proof, not a progression loop.

## Goals / Non-Goals

**Goals:**
- Continuous eight-direction player movement with normalized diagonal speed.
- Collision against walls and obstacles, and a camera that follows the player.
- A small playable tile-based test area rendered with placeholder graphics.
- Clear separation between gameplay rules and presentation.
- Automated tests for movement and core logic.
- Headless Godot project validation and a maintainable structure with minimal dependencies.

**Non-Goals:**
- Mining progression, ore tiers, upgrades, enemies, NPCs, economy, or skill systems.
- Production art, a large world, or a complete game loop.
- A custom physics/collision framework or unnecessary third-party dependencies.

## Decisions

- Use Godot 4 native 2D scenes, nodes, and physics with GDScript; avoid adding dependencies unless the chosen test setup requires one.
- Normalize nonzero directional input before applying movement so diagonal movement does not exceed cardinal speed. Leave the exact speed as a documented, tunable implementation default.
- Use the engine's collision-aware character movement for player/world interaction; represent walls and obstacles with collision geometry in the test area.
- Give the player a camera-following camera node, configured to follow smoothly only if this can be done without compromising clear, predictable tests.
- Keep input/movement/core rules in focused gameplay scripts and scene visuals/camera/world composition in presentation scenes; expose narrow interfaces so rules can be tested without rendering.
- Build a compact tile-based area from simple placeholder colors/shapes or generated placeholder tiles, avoiding external art assets.
- Add automated tests for cardinal and diagonal movement normalization, zero input, core movement behavior, and representative collision/world behavior where feasible. Provide a repeatable headless editor/project validation command and document test invocation.
- Keep project structure small and responsibility-oriented; implementation should inspect the existing repository before choosing exact paths and preserve unrelated changes.

## Migration Plan

- Create and validate the foundation in the isolated `feature/game-foundation` worktree.
- No migration of existing gameplay systems is planned; preserve the independent `endless-mining-progression` change.
- Implementation remains in the worktree until separately reviewed and explicitly finished; this planning task does not merge or push.

## Open Questions

- Confirm available Godot 4 minor version and CLI path during implementation.
- Choose the smallest maintainable automated GDScript test runner or dependency-free harness during implementation.
- Set exact movement speed, tile dimensions, and test-area layout as documented tunable defaults.

## Risks / Trade-offs

- Godot CLI availability/version may differ between developer environments; document the required Godot 4 command and fail validation clearly when unavailable.
- Headless test execution can have rendering/scene limitations; keep core gameplay rules independently testable and exercise scene/project loading in a separate headless validation step.
- TileMap APIs vary across Godot 4 minor versions; target the installed/project-selected Godot 4 version and avoid unnecessary version-specific features.
- Adding a test framework improves ergonomics but adds a dependency; prefer a lightweight compatible runner or dependency-free harness unless test coverage cannot be maintained otherwise.
