extends Node2D
## Compact 18x14 ground of 32px embedded placeholder tiles, no imported art.

const AREA_TILES := Vector2i(18, 14)


func _ready() -> void:
	var ground: TileMapLayer = $Ground
	for y in range(AREA_TILES.y):
		for x in range(AREA_TILES.x):
			ground.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
