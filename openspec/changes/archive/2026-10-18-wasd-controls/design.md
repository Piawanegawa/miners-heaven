# Design

## Context

The player controller reads the four built-in directional actions and passes their net direction to the existing normalization helper. See proposal.md for motivation and specs/top-down-game-foundation/spec.md for the behavior contract.

## Goals / Non-Goals

**Goals:**
- Make WASD feed the same directional actions already used by arrow keys.
- Keep diagonal normalization, cancellation, movement speed, and collision behavior shared by both control sets.

**Non-Goals:**
- Add remapping UI, controller support, or change the existing arrow-key controls.

## Decisions

- Add W/A/S/D as physical key events to the existing ui_up, ui_left, ui_down, and ui_right actions in the project Input Map. This reuses the controller's current input path and avoids maintaining a second set of movement actions. A separate WASD action set would require combining two input vectors and would duplicate unnecessary logic.
- Keep gameplay behavior and presentation responsibilities in their current layers. Verify both key sets and mixed/opposing inputs through the existing movement and playable-scene test approach, and update README controls.

## Risks / Trade-offs

- **WASD also activates the built-in UI actions in other scenes** → The project currently has one playable scene and no separate menu flow; keep this change scoped to movement mappings and revisit action separation if menus later need independent navigation.

## Migration Plan

No save-data or content migration is needed. To roll back, remove the added WASD events from the four input actions; arrow-key behavior remains available.
