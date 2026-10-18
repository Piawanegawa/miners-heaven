# Proposal

## Why

Players need a familiar keyboard option to move through the playable test area. Adding WASD alongside the existing arrow controls makes the prototype easier to try while preserving the current controls.

## What Changes

- Add WASD as an additional movement control set for the player.
- Preserve arrow-key movement and the existing eight-direction movement behavior, including normalized diagonal speed and opposing-key cancellation.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `top-down-game-foundation`: Specify that both WASD and arrow keys control continuous eight-direction player movement.

## Impact

- Godot input mappings in `project.godot` and the player input adapter.
- Existing movement and playable-scene tests, plus the documented controls in `README.md`.
