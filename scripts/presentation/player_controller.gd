extends CharacterBody2D
## Input/physics adapter. Direction rules remain in the rendering-free helper.

const Movement = preload("res://scripts/gameplay/player_movement.gd")

@export var movement_speed: float = Movement.new().movement_speed

var _movement = Movement.new()
var _last_facing: Vector2 = Vector2.DOWN

@onready var _visual: AnimatedSprite2D = $Visual


func _physics_process(_delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = _movement.normalize_direction(input_direction) * movement_speed
	move_and_slide()
	_update_visual(get_real_velocity())


func _update_visual(actual_velocity: Vector2) -> void:
	if actual_velocity.length_squared() < 0.01 or actual_velocity.dot(velocity) <= 0.0:
		_visual.animation = _animation_for_facing(_last_facing)
		_visual.flip_h = _last_facing == Vector2.LEFT
		_visual.stop()
		_visual.frame = 0
		return

	var horizontal_speed := absf(actual_velocity.x)
	var vertical_speed := absf(actual_velocity.y)
	if not is_equal_approx(horizontal_speed, vertical_speed):
		if horizontal_speed > vertical_speed:
			_last_facing = Vector2.LEFT if actual_velocity.x < 0.0 else Vector2.RIGHT
		else:
			_last_facing = Vector2.UP if actual_velocity.y < 0.0 else Vector2.DOWN

	_visual.animation = _animation_for_facing(_last_facing)
	_visual.flip_h = _last_facing == Vector2.LEFT
	_visual.play()


func _animation_for_facing(facing: Vector2) -> StringName:
	if facing == Vector2.UP:
		return &"walk_up"
	if facing == Vector2.DOWN:
		return &"walk_down"
	return &"walk_side"
