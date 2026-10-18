# Tasks

## 1. Pixel-art asset and animation frames

- [x] 1.1 Create a transparent 96x96 pixel-art miner sheet with three 24x32 directional rows (up, down, side), four walk frames per row, and verify the silhouette and frame alignment at the game's 2x display scale.
- [x] 1.2 Add the sheet and configure its Godot `SpriteFrames` walk animations with nearest-neighbor filtering; verify each row imports and plays as a coherent four-frame loop.

## 2. Player scene and movement presentation

- [x] 2.1 Replace the polygon player visual with the animated sprite, align the sprite bottom-center to the existing feet origin, and verify the collision shape and camera nodes retain their current settings.
- [x] 2.2 Update the player presentation controller to select up/down/side animation from actual post-collision movement, mirror the side view for left, preserve facing on equal diagonal input, and display the matching idle frame at zero movement; verify cardinal, diagonal, idle, and blocked-motion behavior in the playable scene.

## 3. Integration review

- [x] 3.1 Update the README for the pixel-art miner and four-direction walk visuals, run the documented headless project validation, inspect the atlas at the game's 2x scale, and use the playable-scene integration runner to verify loading, animation, idle, depth sorting, and ground collision.
