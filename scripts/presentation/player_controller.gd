extends CharacterBody2D
## Input/physics adapter. Direction rules remain in the rendering-free helper.

const Movement = preload("res://scripts/gameplay/player_movement.gd")

@export var movement_speed: float = Movement.new().movement_speed

var _movement = Movement.new()


func _physics_process(_delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	velocity = _movement.normalize_direction(input_direction) * movement_speed
	move_and_slide()
