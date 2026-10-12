# Miners Heaven

A minimal Godot 4 / GDScript 2D top-down playable foundation: continuous
eight-direction movement, collision-aware player, following camera, and a
small tile-based placeholder test area. Gameplay rules are separate from
scene presentation. No progression or content systems are included.

## Requirements

- Godot 4; tested with **Godot 4.7.2 stable** (`4.7.2.stable.official.ed1daf0bf`).
  The project uses `TileMapLayer`; use the tested version for reproducible results.
- PowerShell 7 for the validation wrapper and its tests (tested with 7.6.6).
- No third-party test framework, plugins, art, or other runtime dependencies.
- Run the commands below from the repository root. On Windows, use the Godot
  **console** executable for terminal output; bare `godot` is not available on
  PATH on the implementation machine.

## Play and controls

Open `project.godot` in Godot and press **F6** with the test-area scene open,
or **F5** to run the registered main scene, `scenes/world/test_area.tscn`.

- Hold **arrow keys** to move; two perpendicular arrows move diagonally.
- Opposing arrows cancel. Releasing the arrows stops movement.
- Diagonal speed matches cardinal speed: **200 pixels/second** by default.
  Tune `movement_speed` on the player/controller to change it.
- Walls and the central obstacle block movement; an unblocked axis permits sliding.
- The player's child `Camera2D` follows without smoothing at **2x zoom**.

The area is **18x14 tiles**, each **32x32 pixels** (576x448 overall), with
32-pixel boundary walls and a 64x64 obstacle. Graphics are embedded/generated
placeholder colors and shapes, with no external art imports.

## Movement core

`scripts/gameplay/player_movement.gd` defines `PlayerMovement`, a `RefCounted`
helper with no scene, input-device, rendering, or physics dependency:

- `normalize_direction(input_direction: Vector2) -> Vector2` returns a unit
  vector for nonzero input and exact zero for idle input. All eight directions
  are supported. Calls are stateless, so changes do not retain prior input.
- `movement_speed: float` is configurable, defaulting to **200 pixels/second**.
  The scene controller multiplies the returned direction by this speed and
  applies Godot's collision-aware movement.
- Callers provide the net input vector (right minus left, down minus up).
  Opposing inputs therefore cancel before normalization; normalization does
  not read keyboard state or apply speed itself.

## Headless validation

With Godot on PATH or the supported per-user Windows WinGet installation:

```powershell
pwsh -NoProfile -File ./scripts/validate_project.ps1
```

Executable discovery order is `-GodotPath`, the **`GODOT_BIN`** environment
variable, PATH applications `godot` / `godot4` / `godot_console`, then the newest
per-user WinGet `GodotEngine.GodotEngine_*` Godot 4 stable Windows console
executable under `%LOCALAPPDATA%/Microsoft/WinGet/Packages`. An explicitly
configured but unavailable executable fails instead of silently falling back.
The wrapper checks that the executable reports Godot 4.

Exact executable and command verified on the implementation machine:

```powershell
$Godot = 'C:\Users\user\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64_console.exe'
pwsh -NoProfile -File ./scripts/validate_project.ps1 -GodotPath $Godot
```

Alternatively, set `$env:GODOT_BIN = $Godot` and omit `-GodotPath`.
`-ProjectPath <directory>` validates another project; the default is this
repository's root regardless of the caller's working directory.

Validation runs both stages **without opening a window**:

1. `--headless --editor --path <project> --quit`: editor project-load/import check.
2. `--headless --path <project> --quit-after 5`: load the registered playable
   main scene and run five iterations.

It prints Godot output and a stage-specific failure diagnostic. Native Godot
nonzero exit codes are propagated; missing executable/project/main scene or
Godot `ERROR:` / `SCRIPT ERROR:` / `Parse Error:` output returns `1`, including
when Godot itself returns `0`. Success returns `0`. This is a loading/import
smoke check, not an interactive visual review or a replacement for behavior tests.

## Complete automated suite (headless)

Set `$Godot` to the exact path above, your installed console executable, or
`'godot'` if it is on PATH. Run all three checks, stopping on failure:

```powershell
& $Godot --headless --path . --script res://tests/test_player_movement.gd
if ($LASTEXITCODE -ne 0) { throw 'Movement/core tests failed' }
& $Godot --headless --path . --script res://tests/test_playable_scene.gd
if ($LASTEXITCODE -ne 0) { throw 'Playable scene tests failed' }
pwsh -NoProfile -File ./tests/test_validate_project.ps1 -GodotPath $Godot
if ($LASTEXITCODE -ne 0) { throw 'Validator tests failed' }
```

Each runner exits `0` on success and `1` on a failed check:

- Movement/core: **32 assertions**, covering cardinal/diagonal normalization,
  zero/opposing inputs, consecutive direction changes, and configurable speed.
- Playable scene: **27 assertions**, exercising real input/physics, tiled
  ground, player/camera setup, movement, stopping/reversal, walls, sliding,
  obstacle/corner collision, and actual camera tracking.
- Validator: **11 checks** (**12** when the Windows GUI-companion check is available),
  running the wrapper in fresh PowerShell processes against unavailable
  explicit/environment executables, missing/malformed
  projects, unregistered main scene, broken scene/script, and the real project
  via explicit/environment discovery, plus exact native nonzero exit-code
  propagation. Negative fixtures intentionally generate errors; passing output
  reports their expected nonzero exit status. Only the
  temporary fixtures created by the test are deleted.

There is no rendering/display requirement or third-party test framework. Run
headless validation separately using the command above as the final project
loading check. If invoking one runner directly, inspect `$LASTEXITCODE`.

## Structure and scope

- `project.godot`: Godot 4 configuration, main scene, 640x360 viewport,
  compatibility renderer.
- `scripts/gameplay/`: rendering-independent gameplay logic.
- `scripts/presentation/`: input/physics player controller and tile-area composition.
- `scenes/player/player.tscn`: character body, collision, placeholder, camera.
- `scenes/world/test_area.tscn`: tiled ground, collidable walls/obstacle, player.
- `scripts/validate_project.ps1`: executable discovery and headless validation.
- `tests/`: dependency-free GDScript movement/integration runners and PowerShell
  validator regression checks.
- `openspec/`: specifications, designs, and implementation plans.

Mining progression, ore tiers, upgrades, enemies, NPCs, economy, and skill
systems are outside this foundation's scope.
