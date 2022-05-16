class_name Grid extends Node2D

export (Vector2) var cell_size

var size: Vector2
var bounds: Rect2

onready var terrain = $Terrain

func _ready():
	terrain.setup(self)

func load_data(level_data: LevelData):
	update_size(level_data.size)
	terrain.load_data(level_data)

func update_size(level_size: Vector2):
	print(level_size)
	size = level_size
	bounds.size = Vector2(cell_size.x * size.x, cell_size.y * size.y)
	print(bounds)
	var screen_size = get_viewport_rect().size
	print(screen_size)
	bounds.position = (screen_size - bounds.size) * 0.5
	position = bounds.position
	print(position)

func is_free(pos: Vector2) -> bool:
	return not terrain.get_tile(pos)

func in_bounds(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y

func world_to_grid(pos: Vector2) -> Vector2:
	pos -= bounds.position
	return Vector2(int(pos.x / cell_size.x), int(pos.y / cell_size.y))

func grid_to_world(pos: Vector2, topleft=false) -> Vector2:
	if topleft:
		return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y)
	return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y) + cell_size * 0.5
