# windows-game-build Specification

## Purpose

Defines the supported Windows desktop build workflow for this Godot project.

## Requirements

### Requirement: Windows export preset
The project SHALL provide a tracked Godot export preset named `Windows Desktop` that targets Windows x86_64 and can be used by Godot's command-line exporter.

#### Scenario: Preset is available in a clean checkout
- **WHEN** Godot loads the project from a clean checkout
- **THEN** the `Windows Desktop` export preset is available without first creating it in the editor

### Requirement: Selectable Windows build configuration
The build script SHALL export the project as a Windows x86_64 build and SHALL allow Release or Debug configuration, defaulting to Release.

#### Scenario: Default build
- **WHEN** the user runs the build script without selecting a configuration
- **THEN** the script invokes Godot's Release export for `Windows Desktop`

#### Scenario: Debug build
- **WHEN** the user selects Debug
- **THEN** the script invokes Godot's Debug export for `Windows Desktop`

### Requirement: Godot executable discovery and validation
The build script SHALL accept an explicit Godot executable path and SHALL discover Godot using the project's configured environment variable, PATH commands, and supported per-user Windows WinGet installation. It MUST reject a missing executable or a version other than Godot 4 with an actionable error.

#### Scenario: Explicit executable is unavailable
- **WHEN** the caller supplies a path that is not an available application
- **THEN** the script exits unsuccessfully and identifies the unavailable path

#### Scenario: Godot 4 is not found
- **WHEN** no supported Godot 4 executable is available
- **THEN** the script exits unsuccessfully and explains how to configure a Godot executable

#### Scenario: Non-Godot-4 executable is selected
- **WHEN** the selected executable reports a version other than Godot 4
- **THEN** the script exits unsuccessfully and reports the detected version

### Requirement: Build output location
The build script SHALL resolve the project root independently of the caller's working directory, create the selected output directory if necessary, and export `Miners Heaven.exe` to `build/windows/` by default. Godot's accompanying project data pack SHALL be kept alongside the executable.

#### Scenario: Build from another working directory
- **WHEN** the caller starts the script outside the project root without overriding the output directory
- **THEN** the executable and data pack are written under the project's `build/windows/` directory

#### Scenario: Custom output directory
- **WHEN** the caller supplies another output directory that does not yet exist
- **THEN** the script creates that directory and exports the executable and data pack there

