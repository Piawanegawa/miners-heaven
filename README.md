# Miners Heaven

A minimal Godot 4 / GDScript 2D top-down playable foundation: continuous
eight-direction movement, a 3/4-view pixel-art miner with directional walking,
ground-level collision,
a following camera, and a small tile-based mine test area. Gameplay rules are
separate from scene presentation. No progression or content systems are included.

## Requirements

- Godot 4; tested with **Godot 4.7.2 stable** (`4.7.2.stable.official.ed1daf0bf`).
  The project uses `TileMapLayer`; use the tested version for reproducible results.
- PowerShell 7 for the validation wrapper and its tests (tested with 7.6.6).
- No third-party test framework, plugins, art, or other runtime dependencies.
- Run the commands below from the repository root. On Windows, use the Godot
  **console** executable for terminal output; bare `godot` is not available on
  PATH on the implementation machine.

## Windows build

Install Godot 4.7.2 and its matching Windows export templates. The tracked
`Windows Desktop` preset exports x86_64 builds without editor setup. From the
repository root, create the default Release build with:

```powershell
pwsh -NoProfile -File ./scripts/build_windows.ps1
```

Select Debug or a different output directory with:

```powershell
pwsh -NoProfile -File ./scripts/build_windows.ps1 -Configuration Debug
pwsh -NoProfile -File ./scripts/build_windows.ps1 -OutputDirectory dist/windows
```

The default output is `build/windows/Miners Heaven.exe` and its adjacent
`Miners Heaven.pck`; keep both files together when running or sharing the game.
The script discovers Godot through `-GodotPath`, `GODOT_BIN`, PATH, or the
supported per-user WinGet installation. `-OutputDirectory` may be absolute or
relative to the project root.

## Play and controls

Open `project.godot` in Godot and press **F6** with the test-area scene open,
or **F5** to run the registered main scene, `scenes/world/test_area.tscn`.

- Hold **arrow keys** or **WASD** to move; two perpendicular movement keys move diagonally.
- Opposing movement keys cancel. Releasing all movement keys stops movement.
- The miner has up, down, and side walking cycles; the side view mirrors when moving left. Diagonal movement uses the axis with the larger component and keeps the previous facing on equal components.
- When movement stops or a collision blocks it, the walk cycle stops on the last-facing idle pose.
- Diagonal speed matches cardinal speed: **200 pixels/second** by default.
  Tune `movement_speed` on the player/controller to change it.
- The player scene origin is at the feet. Its pixel-art visual extends upward,
  while its compact collision shape stays at the ground footprint.
- Walls and the rock's ground-level footprint block movement; the player can overlap its tall artwork outside that footprint.
- The player's child `Camera2D` follows without smoothing at **2x zoom**.

The area is **18x14 tiles**, each **32x32 pixels** (576x448 overall), with
32-pixel boundary walls, a tall rock with a **64x16** ground footprint, and a
non-colliding ore visual. The miner uses a transparent **96x96** pixel-art
sprite sheet with **24x32** frames; the ground and tall props retain generated
placeholder colors and shapes.

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
`'godot'` if it is on PATH. Run all four checks, stopping on failure:

```powershell
& $Godot --headless --path . --script res://tests/test_player_movement.gd
if ($LASTEXITCODE -ne 0) { throw 'Movement/core tests failed' }
& $Godot --headless --path . --script res://tests/test_playable_scene.gd
if ($LASTEXITCODE -ne 0) { throw 'Playable scene tests failed' }
pwsh -NoProfile -File ./tests/test_validate_project.ps1 -GodotPath $Godot
if ($LASTEXITCODE -ne 0) { throw 'Validator tests failed' }
pwsh -NoProfile -File ./tests/test_build_windows.ps1
if ($LASTEXITCODE -ne 0) { throw 'Windows build script tests failed' }
```

Each runner exits `0` on success and `1` on a failed check:

- Movement/core: **32 assertions**, covering cardinal/diagonal normalization,
  zero/opposing inputs, consecutive direction changes, and configurable speed.
- Playable scene: **51 assertions**, exercising real input/physics, tiled
  ground, player ground anchor and camera, movement, stopping/reversal, walls,
  sliding, rock-base/corner collision, and actual camera tracking.
- Validator: **11 checks** (**12** when the Windows GUI-companion check is available),
  running the wrapper in fresh PowerShell processes against unavailable
  explicit/environment executables, missing/malformed
  projects, unregistered main scene, broken scene/script, and the real project
  via explicit/environment discovery, plus exact native nonzero exit-code
  propagation. Negative fixtures intentionally generate errors; passing output
  reports their expected nonzero exit status. Only the
  temporary fixtures created by the test are deleted.
- Windows build script: **9 scenarios**, covering Release and Debug exports,
  caller-independent project-root resolution, custom output directories,
  `GODOT_BIN` and PATH discovery, Godot version failures, and export error handling.

There is no rendering/display requirement or third-party test framework. Run
headless validation separately using the command above as the final project
loading check. If invoking one runner directly, inspect `$LASTEXITCODE`.

## OpenSpec and Codex workflow

OpenSpec planning uses the official CLI and repository-local Codex skills. It
requires Node.js 20.19 or newer. Install the CLI and initialize its Codex skills
from the repository root:

```powershell
npm install -g @fission-ai/openspec@latest
openspec init --tools codex
```

The generated skills include `$openspec-propose`, `$openspec-new-change`,
`$openspec-continue-change`, `$openspec-apply-change`, `$openspec-verify-change`,
`$openspec-sync-specs`, `$openspec-update-change`, and
`$openspec-archive-change`. Use `$openspec-explore` for planning-only
exploration. This repository also provides `$opsx-ff` and `$opsx-finish` for
its isolated worktree lifecycle, plus `$opsx-apply` as a short alias for
`$openspec-apply-change`. The project default schema is `spec-driven`;
individual changes can declare a different schema in `.openspec.yaml`.
During apply, changes to observable gameplay behavior are routed through the
repository test-first skill and Superpowers' `$test-driven-development` skill.
Docs and configuration-only tasks skip that cycle.

Check the CLI and project artifacts with:

```powershell
openspec --version
openspec list --json
openspec validate --all --json
```

Superpowers and OpenSpec are separate. The Superpowers skills such as
`$brainstorming`, `$writing-plans`, `$test-driven-development`, and
`$subagent-driven-development` are installed at the Codex user level, so they
are not copied into this repository. If those skills are not available in a
Codex installation, install **Superpowers** by **obra** from the Codex Plugins
marketplace. OpenSpec remains usable through its generated skills without
Superpowers; the repository's Godot-specific skills are also separate.

## Structure and scope

- `project.godot`: Godot 4 configuration, main scene, 640x360 viewport,
  compatibility renderer.
- `scripts/gameplay/`: rendering-independent gameplay logic.
- `scripts/presentation/`: input/physics player controller and tile-area composition.
- `scenes/player/player.tscn`: character body with a foot-anchored animated
  3/4-view pixel-art miner,
  ground-level collision shape, and camera.
- `scenes/world/test_area.tscn`: tiled ground, collidable walls, Y-sorted player
  and tall rock, plus non-blocking ore placeholder.
- `scripts/validate_project.ps1`: executable discovery and headless validation.
- `scripts/build_windows.ps1`: Release or Debug Windows x86_64 export.
- `tests/`: dependency-free GDScript movement/integration runners and PowerShell
  validator and build-script regression checks.
- `openspec/`: specifications, designs, and implementation plans.

Mining progression, ore tiers, upgrades, enemies, NPCs, economy, and skill
systems are outside this foundation's scope.
