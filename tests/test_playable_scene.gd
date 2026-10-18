extends SceneTree
## Real scene/input/physics integration; no display, mocks, or test-only controller API.

var _assertions: int = 0
var _failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	# Missing main-scene registration must fail cleanly before loading resources.
	var main_path: String = ProjectSettings.get_setting("application/run/main_scene", "")
	if main_path.is_empty() or not ResourceLoader.exists(main_path):
		print("FAIL: playable main scene is not registered or does not exist")
		quit(1)
		return
	var packed = load(main_path)
	if not packed is PackedScene:
		print("FAIL: main scene cannot load as PackedScene")
		quit(1)
		return
	var world = packed.instantiate()
	root.add_child(world)
	await _ticks(2)
	var depth_sort = world.get_node_or_null("DepthSort")
	_expect(depth_sort is Node2D and depth_sort.y_sort_enabled, "world has a shared Y-sorted entity container")
	var player = world.get_node_or_null("Player")
	if player == null and depth_sort is Node2D:
		player = depth_sort.get_node_or_null("Player")
	var ground = world.get_node_or_null("Ground")
	_expect(player is CharacterBody2D, "main scene includes a collision-aware player")
	_expect(ground is TileMapLayer, "world uses native tile-based ground")
	if not player is CharacterBody2D or not ground is TileMapLayer:
		world.free()
		_finish()
		return
	_expect(player.get_parent() == depth_sort, "player is sorted with tall world props")
	_expect(not ground.get_used_cells().is_empty(), "ground contains playable tiles")
	_expect(ground.tile_set != null and ground.tile_set.get_source_count() > 0, "ground has placeholder tile graphics")
	var shape = player.get_node_or_null("CollisionShape2D")
	_expect(shape is CollisionShape2D and shape.shape != null and not shape.disabled, "player has enabled collision shape")
	if shape is CollisionShape2D and shape.shape is RectangleShape2D:
		var collision_size: Vector2 = shape.shape.size
		_expect(collision_size.x <= 16.0 and collision_size.y <= 16.0, "player collision footprint is compact")
		_expect(absf(shape.position.y + collision_size.y * 0.5) < 0.01, "player collision footprint ends at the ground anchor")
	else:
		_expect(false, "player collision footprint is a compact rectangle at the ground anchor")
	var visual = player.get_node_or_null("Visual")
	_expect(visual is AnimatedSprite2D and visual.visible, "player has a visible animated pixel-art sprite")
	await _test_visual_animations(player)
	var camera = player.get_node_or_null("Camera2D")
	_expect(camera is Camera2D, "player includes following camera")
	if camera is Camera2D:
		_expect(camera.enabled and camera.is_current(), "player camera is active")
		_expect(not camera.top_level and not camera.position_smoothing_enabled, "camera follows predictably without independent transform or smoothing")
	_expect(world.get_node_or_null("Walls/Left") is StaticBody2D, "area includes collidable boundary wall")
	var rock = world.get_node_or_null("DepthSort/Rock")
	_expect(rock is StaticBody2D, "area includes a collidable tall rock")
	var rock_collision = rock.get_node_or_null("CollisionShape2D") if rock is StaticBody2D else null
	_expect(rock_collision is CollisionShape2D and rock_collision.shape is RectangleShape2D, "rock has a rectangular base collision footprint")
	if rock_collision is CollisionShape2D and rock_collision.shape is RectangleShape2D:
		_expect(rock_collision.shape.size.y <= 16.0 and absf(rock_collision.position.y + rock_collision.shape.size.y * 0.5) < 0.01, "rock collision footprint ends at its ground anchor")
	var rock_visual = rock.get_node_or_null("Visual") if rock is StaticBody2D else null
	_expect(rock_visual is Polygon2D and rock_visual.visible, "rock has visible tall placeholder artwork")
	if rock_visual is Polygon2D:
		var rock_top := 0.0
		var rock_bottom := 0.0
		for point in rock_visual.polygon:
			rock_top = minf(rock_top, point.y)
			rock_bottom = maxf(rock_bottom, point.y)
		_expect(rock_top <= -32.0 and absf(rock_bottom) < 0.01, "rock artwork rises from its ground anchor")
	var ore = world.get_node_or_null("DepthSort/Ore")
	_expect(ore is Node2D and not ore is CollisionObject2D, "ore visual is non-blocking")
	await _test_input_movement(player)
	await _test_wasd_input_movement(player)
	await _test_collisions(player)
	if camera is Camera2D:
		camera.force_update_scroll()
		_expect(camera.global_position.distance_to(player.global_position) < 0.01, "camera transform tracks moved player")
		_expect(camera.get_screen_center_position().distance_to(player.global_position) < 0.1, "camera view tracks moved player")
	world.free()
	_finish()


func _test_input_movement(player: CharacterBody2D) -> void:
	# Missing input, normalization, configured speed, or stale velocity breaks these.
	player.position = Vector2(96, 96)
	var start: Vector2 = player.position
	Input.action_press("ui_right")
	await _ticks(3)
	_expect(player.position.x > start.x and is_equal_approx(player.position.y, start.y), "cardinal input moves the body continuously")
	_expect(absf(player.velocity.x - 200.0) < 0.01, "controller consumes default core speed")
	Input.action_press("ui_down")
	await _ticks(2)
	_expect(player.velocity.distance_to(Vector2(141.421356, 141.421356)) < 0.01, "diagonal input is normalized before applying speed")
	Input.action_press("ui_left")
	Input.action_press("ui_up")
	await _ticks(2)
	_expect(player.velocity == Vector2.ZERO, "opposing inputs cancel in controller")
	_release_input()
	Input.action_press("ui_left")
	await _ticks(2)
	_expect(player.velocity.distance_to(Vector2(-200, 0)) < 0.01, "rapid reversal does not retain stale direction")
	_release_input()
	await _ticks(2)
	start = player.position
	await _ticks(2)
	_expect(player.velocity == Vector2.ZERO and player.position.distance_to(start) < 0.01, "released input stops velocity and movement")
	player.movement_speed = 120.0
	Input.action_press("ui_down")
	await _ticks(2)
	_expect(player.velocity.distance_to(Vector2(0, 120)) < 0.01, "controller applies tunable speed")
	_release_input()
	player.movement_speed = 200.0
	await _ticks(2)


func _test_wasd_input_movement(player: CharacterBody2D) -> void:
	_expect(_action_has_key("ui_up", KEY_W), "W is mapped to up")
	_expect(_action_has_key("ui_left", KEY_A), "A is mapped to left")
	_expect(_action_has_key("ui_down", KEY_S), "S is mapped to down")
	_expect(_action_has_key("ui_right", KEY_D), "D is mapped to right")
	_expect(_action_has_key("ui_up", KEY_UP), "arrow up remains mapped")
	_expect(_action_has_key("ui_left", KEY_LEFT), "arrow left remains mapped")
	_expect(_action_has_key("ui_down", KEY_DOWN), "arrow down remains mapped")
	_expect(_action_has_key("ui_right", KEY_RIGHT), "arrow right remains mapped")

	player.position = Vector2(96, 96)
	var start: Vector2 = player.position
	_press_physical_key(KEY_D, true)
	await _ticks(3)
	_expect(Input.is_action_pressed("ui_right"), "D activates right movement")
	_expect(player.velocity.distance_to(Vector2(200, 0)) < 0.01, "WASD cardinal movement uses configured speed")
	_expect(player.position.x > start.x, "WASD cardinal input moves the player")
	_press_physical_key(KEY_D, false)
	await _ticks(2)

	_press_physical_key(KEY_W, true)
	_press_physical_key(KEY_D, true)
	await _ticks(2)
	_expect(player.velocity.distance_to(Vector2(141.421356, -141.421356)) < 0.01, "WASD diagonal movement is normalized")
	_press_physical_key(KEY_W, false)
	_press_physical_key(KEY_D, false)
	await _ticks(2)

	_press_physical_key(KEY_W, true)
	_press_physical_key(KEY_RIGHT, true)
	await _ticks(2)
	_expect(player.velocity.distance_to(Vector2(141.421356, -141.421356)) < 0.01, "mixed WASD and arrow input is normalized")
	_press_physical_key(KEY_W, false)
	_press_physical_key(KEY_RIGHT, false)
	await _ticks(2)

	_press_physical_key(KEY_D, true)
	_press_physical_key(KEY_LEFT, true)
	await _ticks(2)
	_expect(player.velocity == Vector2.ZERO, "opposing WASD and arrow inputs cancel")
	_press_physical_key(KEY_D, false)
	_press_physical_key(KEY_LEFT, false)
	await _ticks(2)


func _test_visual_animations(player: CharacterBody2D) -> void:
	var sprite = player.get_node_or_null("Visual")
	if not sprite is AnimatedSprite2D:
		return
	var frames: SpriteFrames = sprite.sprite_frames
	_expect(frames != null, "player sprite has animation frames")
	if frames == null:
		return
	for animation_name in [&"walk_up", &"walk_down", &"walk_side"]:
		_expect(frames.has_animation(animation_name), "%s animation exists" % animation_name)
		if frames.has_animation(animation_name):
			_expect(frames.get_frame_count(animation_name) == 4, "%s has four walk frames" % animation_name)
	_expect(sprite.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST, "miner sprite uses nearest-neighbor filtering")
	_expect(is_equal_approx(sprite.position.x, 0.0) and is_equal_approx(sprite.position.y, -16.0), "sprite's bottom-center aligns with the feet origin")
	_expect(sprite.animation == &"walk_down" and not sprite.is_playing() and sprite.frame == 0, "player starts on the down-facing idle pose")

	player.position = Vector2(96, 96)
	Input.action_press("ui_right")
	await _ticks(2)
	_expect(sprite.animation == &"walk_side" and sprite.is_playing() and not sprite.flip_h, "rightward movement plays the side cycle facing right")
	_release_input()
	Input.action_press("ui_left")
	await _ticks(2)
	_expect(sprite.animation == &"walk_side" and sprite.is_playing() and sprite.flip_h, "leftward movement mirrors the side cycle")
	_release_input()
	Input.action_press("ui_up")
	await _ticks(2)
	_expect(sprite.animation == &"walk_up" and sprite.is_playing(), "upward movement plays the up cycle")
	_release_input()
	Input.action_press("ui_down")
	await _ticks(2)
	_expect(sprite.animation == &"walk_down" and sprite.is_playing(), "downward movement plays the down cycle")
	Input.action_press("ui_right")
	await _ticks(2)
	_expect(sprite.animation == &"walk_down", "equal diagonal movement preserves the previous facing")
	_release_input()
	await _ticks(2)
	_expect(not sprite.is_playing() and sprite.animation == &"walk_down" and sprite.frame == 0, "stopping returns to the last-facing idle pose")

	player.position = Vector2(50, 96)
	Input.action_press("ui_left")
	await _ticks(10)
	_expect(not sprite.is_playing(), "blocked movement does not play a walk cycle")
	_expect(sprite.animation == &"walk_side" and sprite.flip_h, "blocked movement preserves the last left-facing pose")
	_expect(player.get_slide_collision_count() > 0, "blocked animation check reached the wall through collision")
	_release_input()
	await _ticks(2)


func _action_has_key(action: StringName, keycode: int) -> bool:
	for input_event in InputMap.action_get_events(action):
		if input_event is InputEventKey:
			if input_event.keycode == keycode or input_event.physical_keycode == keycode:
				return true
	return false


func _press_physical_key(keycode: int, pressed: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	Input.parse_input_event(event)


func _test_collisions(player: CharacterBody2D) -> void:
	# Fixtures: 32px boundary wall; rock art is tall, with a base footprint at x=256..320, y=240..256.
	player.position = Vector2(64, 96)
	Input.action_press("ui_left")
	await _ticks(30)
	_expect(player.position.x >= 39.9 and player.position.x < 45, "player cannot cross left wall")
	_expect(player.get_slide_collision_count() > 0, "wall blocks using real physics collision")
	Input.action_press("ui_down")
	var start_y: float = player.position.y
	await _ticks(15)
	_expect(player.position.x >= 39.9 and player.position.y > start_y + 20, "diagonal movement slides along blocked wall")
	_release_input()
	player.position = Vector2(224, 248)
	Input.action_press("ui_right")
	await _ticks(30)
	_expect(player.position.x <= 248.1 and player.position.x > 240, "player cannot cross obstacle")
	_expect(player.get_slide_collision_count() > 0, "obstacle blocks using real physics collision")
	_release_input()
	# Approach the collider corner with the player's ground contact, not its former body center.
	player.position = Vector2(240, 232)
	Input.action_press("ui_right")
	Input.action_press("ui_down")
	await _ticks(12)
	_expect(not Rect2(256, 240, 64, 16).has_point(player.position), "diagonal approach does not clip through rock base corner")
	_expect(player.get_slide_collision_count() > 0, "diagonal corner approach registers collision")
	_release_input()
	await _ticks(2)


func _ticks(count: int) -> void:
	for _index in range(count):
		await physics_frame
		await process_frame


func _release_input() -> void:
	for action in ["ui_left", "ui_right", "ui_up", "ui_down"]:
		Input.action_release(action)


func _expect(condition: bool, label: String) -> void:
	_assertions += 1
	if not condition:
		_failures += 1
		print("FAIL: ", label)


func _finish() -> void:
	print("Playable scene: %d assertions, %d failures" % [_assertions, _failures])
	quit(0 if _failures == 0 else 1)
