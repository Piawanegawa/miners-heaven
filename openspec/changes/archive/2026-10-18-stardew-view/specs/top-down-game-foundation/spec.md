# Spec Delta

## MODIFIED Requirements

### Requirement: Placeholder tile-based playable test area
The project MUST provide a small playable top-down test area composed from tiles or tile-based ground and obstacles, with 3/4-view placeholder graphics for the player and tall world objects, sufficient to exercise player movement, collisions, depth ordering, and camera following.

#### Scenario: Test area starts playable
- **WHEN** the player launches the main playable scene
- **THEN** the player appears in a traversable tile-based area containing visible placeholder ground, the player, and collidable world geometry

## ADDED Requirements

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
