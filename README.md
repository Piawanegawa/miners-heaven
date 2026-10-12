# Miners Heaven

A Godot 4 / GDScript 2D top-down game foundation. This first slice contains
only the independently testable movement core. The playable scene, input
bindings, collision, world, and following camera are added in Task 2; the
validation wrapper is added in Task 3. There is no main scene yet.

## Requirements

- Godot 4; tested with **Godot 4.7.2 stable**.
- No third-party test framework, plugins, art, or other runtime dependencies.
- Run the following commands from the repository root, with `godot` on PATH.
  On Windows, use the Godot console executable for terminal output.

## Movement core

`scripts/gameplay/player_movement.gd` defines `PlayerMovement`, a `RefCounted`
helper with no scene, input-device, rendering, or physics dependency:

- `normalize_direction(input_direction: Vector2) -> Vector2` returns a unit
  vector for nonzero input and exact zero for idle input. All eight directions
  are supported. Calls are stateless, so changes do not retain prior input.
- `movement_speed: float` is configurable, defaulting to **200 pixels/second**.
  The scene controller will multiply the returned direction by this speed and
  apply Godot's collision-aware movement.
- Callers provide the net input vector (right minus left, down minus up).
  Opposing inputs therefore cancel before normalization; normalization does
  not read keyboard state or apply speed itself.

## Automated tests

```powershell
godot --headless --path . --script res://tests/test_player_movement.gd
```

This dependency-free runner is currently the complete automated suite. It
checks cardinal directions, all four diagonal directions and unit magnitudes,
zero input, opposing-input cancellation, consecutive changes, and configurable
speed. It prints an assertion/failure summary and exits `0` on success or `1`
on a failed assertion or missing helper. No display or playable scene is needed.

If `godot` is not on PATH, the executable used on the implementation machine is:

```powershell
$Godot = 'C:\Users\user\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64_console.exe'
& $Godot --headless --path . --script res://tests/test_player_movement.gd
```

## Headless editor/import smoke check

```powershell
godot --headless --editor --path . --quit
```

This loads/imports the current project without a window. Review the output for
script/import errors: this bare editor command is not the final error-propagating
validation wrapper and does not validate a playable scene. Task 3 adds that
wrapper after Task 2 supplies a main scene.

## Structure and scope

- `project.godot`: minimal Godot 4 configuration, compatibility renderer.
- `scripts/gameplay/`: rendering-independent gameplay logic.
- `tests/`: headless automated GDScript movement/core tests.
- `openspec/`: specifications, designs, and implementation plans.

Mining progression, ore tiers, upgrades, enemies, NPCs, economy, and skill
systems are outside this foundation's scope.
