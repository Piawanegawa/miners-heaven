# Design

## Context

See `proposal.md` for motivation and `specs/top-down-game-foundation/spec.md` for the required player behavior. The player is a `CharacterBody2D` with a polygon visual, a feet-origin at `(0, 0)`, a compact ground collision shape, and a controller that calls `move_and_slide()`. The world Y-sorts the player by its ground contact. Movement accepts continuous eight-way input, while this change deliberately uses four visual facings.

## Goals / Non-Goals

**Goals:**
- Keep visual animation in the presentation layer and preserve the existing movement and collision contracts.
- Make sprite frame size, anchor, animation selection, and import filtering explicit and easy to tune.
- Use actual displacement so blocked movement does not keep the walk cycle playing.

**Non-Goals:**
- Add diagonal artwork, an animated idle loop, mining/tool-use animations, or a new character customization system.
- Change movement speed, input mapping, collision geometry, camera behavior, or world depth sorting.

## Decisions

- **Use a single sprite sheet and `AnimatedSprite2D`/`SpriteFrames`.** Author three rows (up, down, side), each with four walk frames. Treat each frame as 24x32 pixels and the sheet as 96x96 pixels; reuse and mirror the side row for left-facing movement. This keeps the asset compact and lets Godot handle frame timing. Separate image files would make the import and resource list larger; drawing the character from polygons would retain the placeholder look and make a coherent walk cycle harder to author.
- **Keep the sprite at the player's feet origin.** Place the visual child so its bottom-center aligns to local `(0, 0)`. Keep the existing collision shape untouched and let the current Y-sort use the same body origin. The taller artwork may overlap objects, but collision remains tied to the ground footprint.
- **Drive visual state from `get_real_velocity()` after `move_and_slide()`.** Use the dominant nonzero axis for up/down/side. For equal diagonal components, retain the previous facing to avoid flicker. Mirror the side animation only when the horizontal component is negative. When actual displacement is zero, play no walk cycle and show the first frame of the last facing direction. This covers both released input and blocked motion.
- **Use nearest-neighbor rendering.** Configure the sprite texture filter to nearest-neighbor and retain lossless texture import so the existing integer zoom keeps hard pixel edges.

## Risks / Trade-offs

- `[Art readability]` A 24x32 frame leaves limited space for tools and costume details → Keep a recognizable helmet/light silhouette, a tight palette, and test legible contrast at the game's 2x zoom.
- `[Diagonal facing]` Four visual facings cannot point precisely along diagonal travel → Use the dominant axis and retain the last facing on exact ties, as specified.
- `[Animation timing]` A four-frame cycle can look too fast or too slow → Tune one shared walk-cycle rate during in-game review without changing the movement simulation.

## Migration Plan

Replace the player polygon/face/hat nodes with the animated sprite, add the sprite-sheet texture and frame resource, and leave the existing collision and camera nodes intact. If visual or scene validation fails, restore the polygon visual and controller while retaining the worktree for revisions; no saved-game or data migration is needed.
