## Why

Miners Heaven needs a stable, testable playable foundation before gameplay features can be developed independently. A small Godot 4 movement-and-world slice will establish core 2D controls, collision, camera, project structure, automated checks, and headless validation without coupling those foundations to progression design.

## What Changes

- Establish the Godot 4/GDScript project foundation and maintainable separation between gameplay logic and presentation.
- Add a playable top-down tile-based placeholder area with continuous normalized eight-direction movement, wall/obstacle collision, and a following camera.
- Add automated movement/core-logic tests and repeatable headless Godot project validation.
- Keep dependencies minimal and explicitly exclude game progression and content systems.

## Capabilities

### New Capabilities
- `top-down-game-foundation`: Provides the minimal playable, testable Godot 4 foundation for Miners Heaven.

### Modified Capabilities

None.

## Impact

Affects the Godot project/scenes/scripts, test setup, and project validation documentation/commands. Uses Godot 4 and GDScript; no gameplay content dependencies are intended. Does not modify the independent `endless-mining-progression` change.
