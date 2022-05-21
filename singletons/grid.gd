extends Node

const SNAKE_GOAL_SCENE = preload("res://scenes/goals/snake_goal.tscn")
const SEGMENT_GOAL_SCENE = preload("res://scenes/goals/segment_goal.tscn")
const CLEAR_GOAL_SCENE = preload("res://scenes/goals/clear_goal.tscn")

export (Vector2) var cell_size = Vector2(64, 64)

var half_cell_size = cell_size * 0.5

var size: Vector2 setget set_size
var bounds: Rect2
var tiles: Array
var biome

func load_tiles(tiles: Array, biome):
	self.tiles = tiles
	self.biome = biome
	set_size(Vector2(len(tiles), len(tiles[0])))
		
func set_size(value: Vector2):
	size = value
	bounds.size = size * cell_size
	bounds.position = (Globals.SCREEN_SIZE - bounds.size) * 0.5

func get_tile(pos: Vector2) -> Tile:
	if not in_bounds(pos):
		return null
	return tiles[pos.x][pos.y]

func is_wall(pos: Vector2) -> bool:
	if not in_bounds(pos):
		return true
	return tiles[pos.x][pos.y].solid

func is_free(pos: Vector2) -> bool:
	if is_wall(pos):
		return false
	var tile = get_tile(pos)
	for obj in tile.objects:
		# print('[%s] is solid: [%s]' % [obj.name, obj.solid])
		if obj.solid:
			return false
	return true

func in_bounds(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y

func world_to_grid(pos: Vector2) -> Vector2:
	pos -= bounds.position
	return (pos / cell_size).floor()

func grid_to_world(pos: Vector2, topleft=false) -> Vector2:
	if topleft:
		return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y)
	return bounds.position + Vector2(pos.x * cell_size.x, pos.y * cell_size.y) + half_cell_size
