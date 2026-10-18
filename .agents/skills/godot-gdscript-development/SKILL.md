---
name: godot-gdscript-development
description: Develop or maintain the Miners Heaven Godot 4 game, GDScript logic, scenes, collisions, and project validation.
---

# Godot development for Miners Heaven

Use this skill for game-code changes in this repository.

## Project setup

- The playable Godot project is the repository root (`project.godot`). Keep game scripts in this project alongside its scenes and tests.
- The project targets Godot 4 and uses GDScript, built-in 2D scenes/physics/tile features, and no third-party runtime plugins.
- Keep rules and state in `scripts/gameplay/`; keep input, physics, and scene composition in `scripts/presentation/`.
- Read the project README before changing its documented controls, test commands, or validation behavior.

## Development and validation

- Use the Godot executable and PowerShell 7 commands documented in `README.md`.
- The project includes standalone headless GDScript runners and `scripts/validate_project.ps1`; use them when the user requests verification or when a change needs validation before reporting completion.
- Keep new behavior covered by the existing lightweight test approach. Avoid adding external frameworks or runtime dependencies without a clear requirement.
- If a tool launcher fails with an access-denied error, report the exact constraint and do not alter global installation files as a workaround.
