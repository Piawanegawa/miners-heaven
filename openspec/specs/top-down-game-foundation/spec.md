# top-down-game-foundation Specification

## Purpose
TBD - created by archiving change game-foundation. Update Purpose after archive.

## Requirements

### Requirement: Project structure separates gameplay logic from presentation
The project MUST organize gameplay rules and input/movement logic separately from scene presentation, visuals, and camera composition, using focused and maintainable GDScript and scene boundaries.

#### Scenario: Core movement rules are testable without rendering
- **WHEN** automated tests exercise movement/core logic
- **THEN** those rules can be evaluated without requiring the playable scene to render

### Requirement: Continuous eight-direction player movement
The game MUST support continuous player movement in eight directions from both arrow keys and WASD, and normalize nonzero diagonal input so diagonal speed does not exceed cardinal speed.

#### Scenario: Cardinal movement
- **WHEN** the player holds a single arrow key or WASD key
- **THEN** the player moves continuously in that direction at the configured movement speed

#### Scenario: Diagonal movement is normalized
- **WHEN** the player holds two perpendicular movement keys from either control set, or a combination of the two sets
- **THEN** the player moves diagonally at the same configured speed magnitude as cardinal movement

#### Scenario: No movement input
- **WHEN** no arrow or WASD movement key is active
- **THEN** movement input is zero and the player does not receive movement velocity from controls

#### Scenario: Opposing movement keys cancel
- **WHEN** the player holds opposing keys for the same movement axis, including keys from different control sets
- **THEN** those inputs cancel on that axis

### Requirement: Player collision with world obstacles
The playable world MUST prevent the player from passing through walls and configured obstacles using collision-aware movement.

#### Scenario: Player reaches a wall
- **WHEN** the player moves toward a collidable wall
- **THEN** the player is blocked from crossing the wall while remaining able to move along an unblocked axis where space permits

#### Scenario: Player reaches an obstacle
- **WHEN** the player moves into a collidable obstacle in the test area
- **THEN** the player does not pass through the obstacle

### Requirement: Following player camera
The playable scene MUST include a camera that follows the player as the player moves through the test area.

#### Scenario: Player moves through the area
- **WHEN** the player changes position in the playable scene
- **THEN** the camera view tracks the player

### Requirement: Placeholder tile-based playable test area
The project MUST provide a small playable top-down test area composed from tiles or tile-based ground and obstacles, with a 3/4-view pixel-art miner, placeholder graphics for tall world objects, and sufficient geometry to exercise player movement, collisions, depth ordering, and camera following.

#### Scenario: Test area starts playable
- **WHEN** the project launches its main playable scene
- **THEN** the player appears as a visible 3/4-view pixel-art miner in a traversable tile-based area containing placeholder ground and collidable world geometry

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

### Requirement: Tall world objects are sorted by ground contact
The playable scene MUST draw the player and tall world objects in depth order determined by their ground contact positions.

#### Scenario: Player passes behind a tall object
- **WHEN** the player's ground contact is above a tall object's ground contact
- **THEN** the player sprite appears behind the object's visible body

#### Scenario: Player passes in front of a tall object
- **WHEN** the player's ground contact is below a tall object's ground contact
- **THEN** the player sprite appears in front of the object's visible body

### Requirement: Tall sprite artwork does not determine collision footprint
The playable scene MUST keep player and tall-object collision footprints at ground level, independent of artwork height.

#### Scenario: Tall artwork extends beyond its collision footprint
- **WHEN** the player overlaps the upper artwork of a tall object without overlapping its ground-level collision footprint
- **THEN** movement is determined by the configured ground-level collision footprint rather than the artwork bounds

### Requirement: Automated tests cover movement and core logic
The project MUST provide repeatable automated tests for movement normalization and core gameplay logic without requiring interactive rendering.

#### Scenario: Movement and core tests run
- **WHEN** the documented automated test command is run
- **THEN** movement cardinal/diagonal/zero-input behavior and selected core logic are checked and failures return a nonzero result

### Requirement: Headless project validation
The project MUST document and support headless Godot validation that detects project/scene loading or import errors without opening an interactive window.

#### Scenario: Headless validation succeeds
- **WHEN** the documented headless validation command runs against a correctly configured Godot 4 project
- **THEN** Godot completes project validation successfully and returns a successful exit status

#### Scenario: Headless validation reports project errors
- **WHEN** the project contains a project-load or scene/import error detected by the validation command
- **THEN** the command reports the failure and returns a nonzero exit status

### Requirement: Minimal dependencies and maintainable foundation scope
The foundation MUST use Godot 4 and GDScript with a small, responsibility-oriented project structure and no unnecessary dependencies; it MUST NOT introduce mining progression, ore tiers, upgrades, enemies, NPCs, economy, or skill systems.

#### Scenario: Foundation stays within scope
- **WHEN** the foundation slice is implemented
- **THEN** it provides the movement/world/testing foundation without introducing the excluded progression or content systems
