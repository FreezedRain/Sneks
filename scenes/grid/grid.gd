class_name Grid extends Node2D

const SNAKE_GOAL_SCENE = preload("res://scenes/goals/snake_goal.tscn")

export (Vector2) var cell_size

var size: Vector2
var tiles: Array
var objects: Array
var bounds: Rect2

onready var object_holder = $Objects
onready var terrain = $Terrain

func _ready():
	terrain.setup(self)

func load_data(level_data: LevelData):
	update_size(level_data.size)
	load_tiles(level_data.level)
	load_objects(level_data.level)
	terrain.update_tiles()

func update_size(level_size: Vector2):
	size = level_size
	bounds.size = Vector2(cell_size.x * size.x, cell_size.y * size.y)
	var screen_size = get_viewport_rect().size
	bounds.position = (screen_size - bounds.size) * 0.5
	position = bounds.position
	object_holder.position = -position

func load_tiles(raw_tiles: Array):
	for x in range(size.x):
		var col = []
		for y in range(size.y):
			var is_solid = raw_tiles[x][y] == '#'
			var tile = Tile.new(self, Vector2(x, y), is_solid)
			col.append(tile)
		tiles.append(col)

func load_objects(raw_tiles: Array):
	for x in range(size.x):
		for y in range(size.y):
			var raw_object = raw_tiles[x][y]
			if Globals.COLORS_LETTERS.keys().has(raw_object):
				var goal = SNAKE_GOAL_SCENE.instance()
				goal.setup(self, Vector2(x, y))
				goal.set_color(Globals.COLORS_LETTERS[raw_object])

func add_object(object: GridObject):
	tiles[object.grid_pos.x][object.grid_pos.y].add_object(object)
	objects.append(object)
	object_holder.add_child(object)

func get_tile(pos: Vector2) -> Tile:
	return tiles[pos.x][pos.y]

func is_free(pos: Vector2) -> bool:
	if is_solid(pos):
		return false
	var tile = get_tile(pos)
	for obj in tile.objects:
		if obj is SnakeSegment:
			return false
	return true

func is_solid(pos: Vector2) -> bool:
	if not in_bounds(pos):
		return true
	return tiles[pos.x][pos.y].solid

func in_bounds(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y

func world_to_grid(pos: Vector2) -> Vector2:
	pos -= bounds.position
	return Vector2(int(pos.x / cell_size.x), int(pos.y / cell_size.y))

func grid_to_world(pos: Vector2, topleft=false) -> Vector2:
	if topleft:
		return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y)
	return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y) + cell_size * 0.5
