class_name PlayerMovement
extends RefCounted
## Rendering-independent movement rules; callers apply speed and collision.

## Tunable default in pixels per second, independent of input normalization.
@export var movement_speed: float = 200.0


func normalize_direction(input_direction: Vector2) -> Vector2:
	if input_direction == Vector2.ZERO:
		return Vector2.ZERO
	return input_direction.normalized()
