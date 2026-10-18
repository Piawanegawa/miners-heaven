## 1. Configure the Windows export

- [ ] 1.1 Add a tracked Windows Desktop x86_64 preset and update `.gitignore` to include the preset and ignore generated `build/` output.
- [ ] 1.2 Implement `scripts/build_windows.ps1` with Release/Debug selection, Godot discovery and version checks, project-root resolution, output-directory creation, and export error handling.

## 2. Document and verify the build

- [ ] 2.1 Document prerequisites, the default Release command, Debug selection, output files, and custom output directory in `README.md`.
- [ ] 2.2 Review the script and export preset against the Windows build scenarios and run a Godot export when the required Windows export templates are available.
