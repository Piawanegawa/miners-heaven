# Proposal

## Why

The current playable foundation reads as a strict top-down scene and does not yet establish the spatial depth needed for the game's Stardew Valley-inspired presentation. A small visual slice can establish that look while keeping the existing square movement grid and camera behavior.

## What Changes

- Replace the placeholder-only presentation requirement with a 3/4-view visual presentation for the player and tall mine objects.
- Sort the player and tall objects by their ground contact point so the player can pass visibly in front of or behind an object.
- Keep the existing square grid, continuous eight-direction movement, collision behavior, and following camera.
- Use the existing mine test area to prove the presentation with a player, a tall rock, and an ore object.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `top-down-game-foundation`: define the expected 3/4 presentation and ground-point depth sorting for the playable test area.

## Impact

- Affects the player and test-area presentation scenes and their scene composition.
- Adds scene-level verification for sorting anchors and collision footprint, plus visual review in the running Godot scene.
- Does not change movement rules or introduce mining progression, economy, combat, or other gameplay systems.
