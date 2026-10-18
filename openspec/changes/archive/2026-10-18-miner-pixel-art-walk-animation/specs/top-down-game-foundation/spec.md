# Spec Delta

## MODIFIED Requirements

### Requirement: Placeholder tile-based playable test area
The project MUST provide a small playable top-down test area composed from tiles or tile-based ground and obstacles, with a 3/4-view pixel-art miner, placeholder graphics for tall world objects, and sufficient geometry to exercise player movement, collisions, depth ordering, and camera following.

#### Scenario: Test area starts playable
- **WHEN** the project launches its main playable scene
- **THEN** the player appears as a visible 3/4-view pixel-art miner in a traversable tile-based area containing placeholder ground and collidable world geometry

## ADDED Requirements

### Requirement: Player walk animation follows movement direction
The player MUST show a four-direction walking animation while moving, using up, down, and side-facing artwork, with the side-facing artwork mirrored for leftward movement.

#### Scenario: Walk in a cardinal direction
- **WHEN** the player moves up, down, or horizontally
- **THEN** the matching directional walk animation plays, with horizontal artwork mirrored when moving left

#### Scenario: Walk diagonally
- **WHEN** the player moves diagonally
- **THEN** the animation uses the cardinal direction with the larger movement component, and keeps its prior facing when both components are equal

#### Scenario: Stop moving
- **WHEN** the player's actual movement stops, including when collision blocks motion
- **THEN** the walking animation stops on an idle pose matching the last facing direction

### Requirement: Pixel-art miner preserves ground anchoring
The player MUST render a crisp pixel-art miner whose ground contact remains aligned with the existing feet anchor and whose artwork does not change the ground-level collision footprint.

#### Scenario: Tall character art overlaps a world object
- **WHEN** the miner's upper artwork overlaps a tall world object's artwork without ground-footprint overlap
- **THEN** collision behavior remains determined by the existing ground-level footprints and the miner's feet remain correctly positioned for depth sorting
