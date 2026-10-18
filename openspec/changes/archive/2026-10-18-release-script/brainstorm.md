## Design Summary

Add a PowerShell build script that exports the Godot project as a Windows x86_64 release or debug build. Release is the default. The script will use the existing Godot executable discovery conventions, allow an explicit executable path, and write output to `build/windows/` by default. A tracked Windows Desktop export preset will make the command reproducible. Godot's normal Windows export creates an executable and its adjacent project data pack; both belong in the output directory.

## Alternatives Considered

### Option A: PowerShell build script with a tracked Windows export preset
- **Approach**: Add a script with a Release/Debug selector, use Godot's command line exporter, and commit the Windows Desktop preset.
- **Pros**: One repeatable command, works from any current directory, and needs no manual editor setup for each checkout.
- **Cons**: Requires Godot 4 Windows export templates to be installed.
- **Why not chosen**: Chosen; it meets the requested one-command build and can export both configurations.

### Option B: Script that depends on a preset created in the editor
- **Approach**: Add only a script and assume every user has created an identically named Windows preset.
- **Pros**: Keeps editor-managed export options out of version control.
- **Cons**: A clean checkout cannot export until the preset is created manually, and builds can differ across machines.
- **Why not chosen**: The project currently has no export preset, so this would not work immediately.

### Option C: Export directly without a named preset
- **Approach**: Use Godot's platform export commands without `export_presets.cfg`.
- **Pros**: Avoids committing a preset file.
- **Cons**: Godot's command-line export requires a named preset; platform and release settings would be unclear.
- **Why not chosen**: It does not provide a supported, self-contained command-line export path.

## Agreed Approach

Use Option A. Add a PowerShell 7 script that accepts a `Release` or `Debug` configuration, defaults to Release, discovers Godot using the conventions in `scripts/validate_project.ps1`, checks the Godot 4 version and project location, creates the output directory, then invokes `--export-release` or `--export-debug` with the `Windows Desktop` preset. Add a Windows x86_64 export preset and document the command and export-template prerequisite. Exclude generated `build/` output from version control and allow the tracked `export_presets.cfg` file through `.gitignore`.

## Key Decisions

- Use the current repository root as the Godot project root.
- Use PowerShell 7 and `scripts/build_windows.ps1`.
- Make Release the default; allow Debug through a configuration parameter.
- Default the executable destination to `build/windows/Miners Heaven.exe`; permit a custom output directory.
- Track the preset in source control so the script works from a clean checkout.
- Keep Godot's normal adjacent `.pck` output with the `.exe`.
- Require Godot 4 and its matching Windows export templates; do not download tools automatically.

## Open Questions

- None. The user selected a build that can choose Release or Debug.
