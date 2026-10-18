# Windows Build Script Implementation Plan

> **For Codex:** Follow the `release-script` OpenSpec tasks in this worktree.

**Goal:** Add a repeatable Godot Windows x86_64 build command that can export Release or Debug builds.

**Architecture:** A PowerShell 7 wrapper locates and validates the Godot executable, resolves paths from its own location, prepares the output directory, and calls the Godot command-line exporter with a tracked `Windows Desktop` preset. The project README explains setup and output files; generated builds remain ignored.

**Tech Stack:** Godot 4.7.2, PowerShell 7, Godot CLI export presets.

---

## Task 1: Add the Windows export preset and ignore rules

**Files:**
- Create: `export_presets.cfg`
- Modify: `.gitignore`

**Steps:**
1. Add a `Windows Desktop` preset for the Windows Desktop platform with x86_64 architecture, normal external PCK output, and code signing disabled.
2. Remove `export_presets.cfg` from the ignore rules so Git tracks the shared preset.
3. Add `build/` to `.gitignore` for generated exports.
4. Review the preset keys against the repository's Godot 4 version and keep signing credentials out of the file.

## Task 2: Implement the PowerShell exporter

**Files:**
- Create: `scripts/build_windows.ps1`
- Create: `tests/test_build_windows.ps1`
- Reference: `scripts/validate_project.ps1`

**Steps:**
1. Add focused PowerShell scenarios for Release/Debug selection, project-root and output paths, Godot discovery/version checks, reported export errors, and native failures; run them first to establish the missing behavior.
2. Define `-GodotPath`, `-Configuration` (`Release` or `Debug`, default `Release`), `-OutputDirectory` (default `build/windows`), and `-ProjectPath` (default the repository root from `$PSScriptRoot`).
3. Reuse executable discovery order: explicit path, `GODOT_BIN`, PATH names `godot`, `godot4`, `godot_console`, then the supported per-user WinGet console executable.
4. Validate that the executable exists and reports Godot 4; print an actionable error for missing or unsupported installations.
5. Verify `project.godot`, resolve the output directory against the project root, and create it when missing.
6. Invoke Godot headlessly with the `Windows Desktop` preset, selecting `--export-release` or `--export-debug` from `-Configuration`, and export to `Miners Heaven.exe` in the output directory.
7. Propagate Godot's nonzero exit code, reject Godot error output even when it returns zero, and verify that both executable and adjacent `.pck` were produced.

## Task 3: Document and verify the build

**Files:**
- Modify: `README.md`
- Review: `export_presets.cfg`, `scripts/build_windows.ps1`, and `openspec/changes/release-script/specs/windows-game-build/spec.md`

**Steps:**
1. Add a Windows build section listing Godot 4 and Windows export templates as prerequisites.
2. Document the default Release invocation and the Debug and custom-output examples.
3. Explain that the `.pck` must stay beside the `.exe` for the default separate-pack preset.
4. Run PowerShell syntax/help checks and review invalid executable, invalid Godot version, Release, Debug, and custom output handling.
5. If the matching Windows export templates are installed, run the build script and confirm both output files exist; otherwise record the missing-template limitation without claiming an export passed.
