## Context

The project root contains `project.godot` and uses Godot 4.7.2. It already has `scripts/validate_project.ps1`, which discovers the Godot executable from `-GodotPath`, `GODOT_BIN`, PATH, or a per-user Windows WinGet install. There is currently no `export_presets.cfg`, so Godot's command-line exporter has no project preset to use. Command-line export requires a named preset and installed export templates.

## Goals / Non-Goals

**Goals:**

- Provide a single PowerShell command to export a Windows x86_64 build.
- Let the caller choose Release or Debug, defaulting to Release.
- Make the preset and default output path work from a clean checkout and from any caller working directory.
- Fail with a useful message when Godot, the project, or export templates are unavailable.

**Non-Goals:**

- Build Godot itself, install Godot or export templates, sign the executable, create an installer, or export other operating systems.
- Change gameplay or project runtime behavior.

## Decisions

- **Use `scripts/build_windows.ps1`.** This matches the repository's existing PowerShell validation wrapper and needs no new runtime.
- **Use a `Configuration` parameter with `Release` and `Debug` values.** Map these directly to Godot's `--export-release` and `--export-debug` commands; default to Release.
- **Reuse existing executable discovery.** Support `-GodotPath`, `GODOT_BIN`, `godot` / `godot4` / `godot_console` on PATH, and the newest supported per-user WinGet Godot 4 console executable. Check that the reported version is Godot 4.
- **Track a preset named `Windows Desktop`.** Configure the Windows target for x86_64, rely on Godot's default export options, and use the regular separate project data pack. Keeping the preset makes CLI exports reproducible and keeps user secrets such as signing credentials out of the preset.
- **Write output under `build/windows/`.** The default executable name is `Miners Heaven.exe`; permit an output directory override. The script creates the target directory before export, because Godot requires it to exist.
- **Update ignore rules.** Ignore generated `build/` output and stop ignoring `export_presets.cfg`, so the shared preset can be committed.
- **Document the command and prerequisites in `README.md`.** Explain that the `.exe` uses the `.pck` beside it and requires Godot's Windows export templates.

Alternatives considered: an editor-created preset would make clean-checkout builds manual; omitting the preset is incompatible with named command-line export; embedding all project data in the executable would change Godot's regular packaging behavior without being required.

## Risks / Trade-offs

- [Missing export templates] → Detect export failure and report that matching Godot 4 Windows export templates must be installed.
- [Godot output path is project-relative] → Resolve the project root from `$PSScriptRoot` and construct the default output path from that root.
- [A Windows export includes a separate `.pck`] → Document that both files are needed for a runnable build.
- [Preset changes could leak machine-specific signing settings] → Keep signing disabled and omit credentials from the tracked preset.

## Migration Plan

No data migration is needed. Add the export preset, script, ignore rules, and README instructions. A user can roll back by removing the script and preset and restoring the ignore rules; generated files under `build/` are disposable.

## Open Questions

None. Release is the default, and Debug is explicitly selectable.
