## Why

The project has a runnable Godot scene but no checked-in Windows export preset or repeatable build command. This makes producing a Windows executable depend on manual editor setup. A documented script will make Release and Debug exports reproducible from a clean checkout.

## What Changes

- Add a PowerShell script that exports this project for Windows x86_64 in Release or Debug mode, with Release as the default.
- Add a tracked Godot Windows Desktop export preset and keep generated build output out of version control.
- Document Godot discovery, export templates, and the build command in the project README.

## Capabilities

### New Capabilities

- `windows-game-build`: Repeatable Windows x86_64 Release and Debug exports from the command line.

### Modified Capabilities

- None. The existing playable game requirements do not change.

## Impact

- Affected files: `scripts/build_windows.ps1`, `export_presets.cfg`, `.gitignore`, and `README.md`.
- Requires Godot 4 and installed Windows export templates; no new runtime dependencies.
- Produces `build/windows/Miners Heaven.exe` and Godot's adjacent project data pack by default.
