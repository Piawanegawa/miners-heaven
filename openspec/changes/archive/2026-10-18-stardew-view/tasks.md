# Tasks

## 1. Player Ground Anchor

- [x] 1.1 Add failing playable-scene assertions for a foot-anchored player visual and compact ground-level collision footprint; run the focused Godot integration runner and confirm the new assertions fail for the expected missing setup.
- [x] 1.2 Replace the centered square player placeholder with an in-engine 3/4-view placeholder rooted at the feet, and place the collision shape over the ground footprint; verify the focused assertions pass and existing movement, collision, and camera assertions remain green.
- [x] 1.3 Update the README's player and scene descriptions to reflect the new placeholder presentation and ground anchor; verify the documented controls and validation commands still match the project.

## 2. Tall Object Depth Sorting

- [x] 2.1 Add failing playable-scene assertions for a shared Y-sorted entity container, a tall rock with a base collision footprint, and a non-blocking ore visual; run the focused runner and confirm the new assertions fail for the expected missing setup.
- [x] 2.2 Move the player and tall mine props into a shared Y-sorted container, separate the rock's visible body from its base collider, and add the ore visual; verify the focused assertions pass and the existing obstacle collision checks still pass.
- [x] 2.3 Update the README's test-area description to name the tall rock and ore fixtures; verify the documented scene composition matches the playable test area.

## 3. Integrated Presentation Review

- [x] 3.1 Run the documented movement and playable-scene runners plus headless project validation; verify all complete successfully with the new scene hierarchy.
- [x] 3.2 Run the scene at the current camera zoom and walk above and below the rock; verify the player renders behind it from above, in front from below, and can overlap upper artwork when outside the ground collision footprint.
