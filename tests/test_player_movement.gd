extends SceneTree
## Dependency-free movement/core suite. Run with --headless --script.
## API contract: PlayerMovement.normalize_direction(Vector2) -> Vector2,
## plus a configurable movement_speed (pixels per second).

const MOVEMENT_SCRIPT_PATH: String = "res://scripts/gameplay/player_movement.gd"
const TOLERANCE: float = 0.00001

var _assertions: int = 0
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	# A missing helper is a deliberate test failure, not a preload/parse error.
	if not FileAccess.file_exists(MOVEMENT_SCRIPT_PATH):
		print("FAIL: PlayerMovement helper is missing: ", MOVEMENT_SCRIPT_PATH)
		quit(1)
		return
	var movement_script = load(MOVEMENT_SCRIPT_PATH)
	if movement_script == null or not movement_script.can_instantiate():
		print("FAIL: PlayerMovement helper cannot be loaded/instantiated")
		quit(1)
		return
	var movement = movement_script.new()
	_test_cardinal_directions(movement)
	_test_diagonal_directions(movement)
	_test_zero_input(movement)
	_test_opposing_inputs(movement)
	_test_consecutive_direction_changes(movement)
	_test_configurable_speed(movement)
	print("Movement/core: %d assertions, %d failures" % [_assertions, _failures])
	quit(0 if _failures == 0 else 1)


func _test_cardinal_directions(movement) -> void:
	# Catches reversed axes, scaling, or loss of a cardinal direction.
	for direction in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		_expect_vector(movement.normalize_direction(direction), direction, "cardinal %s" % direction)
		_expect_vector(movement.normalize_direction(direction * 3.0), direction, "scaled cardinal %s" % direction)


func _test_diagonal_directions(movement) -> void:
	# Literal hand-derived expectations catch missing normalization or lost signs.
	var cases: Array = [
		[Vector2(-1, -1), Vector2(-0.70710678, -0.70710678)],
		[Vector2(1, -1), Vector2(0.70710678, -0.70710678)],
		[Vector2(-1, 1), Vector2(-0.70710678, 0.70710678)],
		[Vector2(1, 1), Vector2(0.70710678, 0.70710678)],
	]
	for entry in cases:
		var actual: Vector2 = movement.normalize_direction(entry[0])
		_expect_vector(actual, entry[1], "diagonal %s" % entry[0])
		_expect_float(actual.length(), 1.0, "diagonal magnitude %s" % entry[0])


func _test_zero_input(movement) -> void:
	# Catches fallback directions or residual movement for idle input.
	_expect_vector(movement.normalize_direction(Vector2.ZERO), Vector2.ZERO, "zero input")


func _test_opposing_inputs(movement) -> void:
	# The presentation layer supplies a net vector; opposites must cancel.
	_expect_vector(movement.normalize_direction(Vector2.LEFT + Vector2.RIGHT), Vector2.ZERO, "left + right cancel")
	_expect_vector(movement.normalize_direction(Vector2.UP + Vector2.DOWN), Vector2.ZERO, "up + down cancel")
	_expect_vector(movement.normalize_direction(Vector2.LEFT + Vector2.RIGHT + Vector2.UP + Vector2.DOWN), Vector2.ZERO, "all directions cancel")
	_expect_vector(movement.normalize_direction(Vector2.LEFT + Vector2.RIGHT + Vector2.UP), Vector2.UP, "cancelled horizontal preserves up")


func _test_consecutive_direction_changes(movement) -> void:
	# Reusing one helper catches cached/stale direction across successive calls.
	var cases: Array = [
		[Vector2.RIGHT, Vector2.RIGHT],
		[Vector2(-1, -1), Vector2(-0.70710678, -0.70710678)],
		[Vector2.LEFT, Vector2.LEFT],
		[Vector2.ZERO, Vector2.ZERO],
		[Vector2.DOWN, Vector2.DOWN],
		[Vector2.UP, Vector2.UP],
		[Vector2.ZERO, Vector2.ZERO],
	]
	for entry in cases:
		_expect_vector(movement.normalize_direction(entry[0]), entry[1], "consecutive input %s" % entry[0])


func _test_configurable_speed(movement) -> void:
	# Catches speed leaking into direction normalization; callers apply speed.
	movement.movement_speed = 320.0
	_expect_float(movement.normalize_direction(Vector2.RIGHT).length() * movement.movement_speed, 320.0, "configured cardinal speed")
	_expect_float(movement.normalize_direction(Vector2(1, 1)).length() * movement.movement_speed, 320.0, "configured diagonal speed")
	movement.movement_speed = 80.0
	_expect_float(movement.normalize_direction(Vector2.LEFT).length() * movement.movement_speed, 80.0, "changed configured speed")
	_expect_vector(movement.normalize_direction(Vector2.ZERO) * movement.movement_speed, Vector2.ZERO, "configured speed remains idle")


func _expect_vector(actual: Vector2, expected: Vector2, label: String) -> void:
	_assertions += 1
	if actual.distance_to(expected) > TOLERANCE:
		_failures += 1
		print("FAIL: %s: expected %s, got %s" % [label, expected, actual])


func _expect_float(actual: float, expected: float, label: String) -> void:
	_assertions += 1
	# Vector2 uses single-precision components; scale tolerance for pixel speeds.
	if absf(actual - expected) > TOLERANCE * maxf(1.0, absf(expected)):
		_failures += 1
		print("FAIL: %s: expected %s, got %s" % [label, expected, actual])
