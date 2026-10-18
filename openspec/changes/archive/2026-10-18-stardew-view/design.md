# Design

## Context

See `proposal.md` for motivation and `specs/top-down-game-foundation/spec.md` for the behavior contract. The player is currently a `CharacterBody2D` whose square collision shape and placeholder polygon are centered at the same origin. The test area draws ground, walls, one square obstacle, and the player as separate scene children. The project has no imported art assets.

## Goals / Non-Goals

**Goals:**
- Make the player and one tall mine prop read in a 3/4 view while retaining the square world grid.
- Make visual overlap depend on ground position while keeping collision independent from sprite height.
- Preserve the existing movement rules and camera behavior.

**Non-Goals:**
- Add isometric coordinates, grid movement, new mining interactions, or progression.
- Produce final character or environment art; use in-engine placeholder visuals for this slice.
- Add directional animation polish beyond what is needed to make the 3/4 player silhouette and facing readable.

## Decisions

### Keep the orthographic camera and square world coordinates
Keep the current `Camera2D`, tile dimensions, and world positions. Build depth through art composition and draw order. A diamond isometric grid would change movement and collision interpretation without helping this focused presentation prototype.

### Anchor the player at the feet
Keep `CharacterBody2D` as the moving physics root, but treat its position as the player's ground contact. Draw the player graphic upward from that point. Move the compact collision shape upward from the root so it covers the body footprint at ground level, and leave artwork height out of physics. This preserves the controller's direction normalization and collision-aware movement while making the visual pivot match its standing position.

### Sort the player and tall props together
Keep the ground and flat details in a lower layer. Add a shared Y-sorted `Node2D` for the player and tall props. Each prop's sortable root sits at its ground contact; its visible body is a child extending upward, and its `StaticBody2D` shape stays at the base. Use the existing obstacle as the tall rock fixture and add one non-blocking ore visual so the slice proves both depth and object layering.

### Verify scene behavior and rendered appearance separately
Extend the playable-scene runner to check the player ground anchor, compact collision shape, tall-prop base shape, and shared sort container, while retaining its existing movement, collision, and camera assertions. Then inspect the running scene by moving above and below the rock: headless checks cannot establish that pixel-art overlap reads clearly.

## Risks / Trade-offs

- [Sort origins drift away from the visible feet or prop base] → Keep each sortable root at the ground contact and make artwork a child offset upward; assert the scene structure in the integration runner.
- [The existing centered obstacle collider feels too large after adding a tall graphic] → Separate its ground footprint from the visible rock body and test movement through the upper artwork area.
- [Placeholder shapes communicate the perspective poorly] → Keep geometry simple but visibly show a top plane and front face; evaluate the slice in the actual 2x camera view before expanding it.

## Migration Plan

1. Update the player scene so its root is the ground contact and the visual/collision child offsets are explicit.
2. Recompose the test area with a lower ground layer and shared Y-sorted player/prop roots.
3. Update the existing playable-scene integration checks for the revised scene hierarchy and new visual/collision anchors.
4. Run the focused Godot checks and review the scene interactively from both sides of the rock. If the presentation fails review, revert the scene composition and placeholder visuals without changing the movement core.
