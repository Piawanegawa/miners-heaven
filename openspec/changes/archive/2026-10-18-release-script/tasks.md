## 1. Configure the Windows export

- [x] 1.1 Add a tracked Windows Desktop x86_64 preset and update `.gitignore` to include the preset and ignore generated `build/` output.
- [x] 1.2 Add `tests/test_build_windows.ps1` and implement `scripts/build_windows.ps1` with Release/Debug selection, Godot discovery and version checks, project-root resolution, output-directory creation, and export error handling.

## 2. Document and verify the build

- [x] 2.1 Document prerequisites, the default Release command, Debug selection, output files, and custom output directory in `README.md`.
- [x] 2.2 Review the script and export preset against the Windows build scenarios and run a Godot export when the required Windows export templates are available.

Verification note: Godot 4.7.2 loaded the `Windows Desktop` preset without preset configuration errors, but the real export could not proceed because matching `windows_debug_x86_64.exe` and `windows_release_x86_64.exe` templates are not installed. The build script reports this requirement and exits with Godot's failure code.
