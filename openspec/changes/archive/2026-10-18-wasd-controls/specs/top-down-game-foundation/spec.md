# Spec Delta

## MODIFIED Requirements

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
