class_name LevelData extends Resource

const SNAKE_SCENE = preload("res://scenes/snake/snake.tscn")
const SNAKE_GOAL_SCENE = preload("res://scenes/goals/snake_goal.tscn")
const SEGMENT_GOAL_SCENE = preload("res://scenes/goals/segment_goal.tscn")
const CLEAR_GOAL_SCENE = preload("res://scenes/goals/clear_goal.tscn")
const TRANSITION_GOAL_SCENE = preload("res://scenes/goals/transition_goal.tscn")
const BIOME_TRANSITION_GOAL_SCENE = preload("res://scenes/goals/biome_transition_goal.tscn")
const APPLE_SCENE = preload("res://scenes/goals/apple.tscn")
const GHOST_APPLE_SCENE = preload("res://scenes/goals/ghost_apple.tscn")

enum Biome {DUSTY, ROCKY, GRASSY, GRAVEYARD}

export (String) var name
export (Biome) var biome
export (String, MULTILINE) var level_string
export (String, MULTILINE) var snakes_string

var size: Vector2
var level: Array
var snakes: Array

func _init(name = "test", biome = Biome.DUSTY, level_string = "", snakes_string = ""):
	self.name = name
	self.biome = biome
	self.level_string = level_string
	self.snakes_string = snakes_string
	call_deferred("ready")

func ready():
	parse_level()
	parse_snakes()

func load_objects() -> LevelObjects:
	var goals = load_goals()
	var snakes_and_segments = load_snakes()
	
	return LevelObjects.new(goals, snakes_and_segments[0], snakes_and_segments[1])
	
func load_tiles() -> Array:
	var tiles = []
	for x in range(size.x):
		var col = []
		for y in range(size.y):
			var is_solid = level[x][y] == '#'
			var tile = Tile.new(Vector2(x, y), is_solid)
			col.append(tile)
		tiles.append(col)
	return tiles

func load_goals() -> Array:
	var goals = []
	for x in range(size.x):
		for y in range(size.y):
			var raw_object = level[x][y]
			var goal = parse_goal(raw_object)
			if goal:
				goal.set_pos(Vector2(x, y))
				goal.align()
				goals.append(goal)
	return goals

func parse_goal(raw_object):
	var goal = null
	if raw_object == 'x':
		goal = CLEAR_GOAL_SCENE.instance()
	elif raw_object == 'a':
		goal = APPLE_SCENE.instance()
	elif raw_object == 'A':
		goal = GHOST_APPLE_SCENE.instance()
	elif raw_object[0] == 'e':
		var level_idx = int(raw_object.substr(1))
		goal = TRANSITION_GOAL_SCENE.instance()
		goal.set_level_idx(level_idx)
	elif raw_object[0] == 'b':
		var biome_idx = int(raw_object.substr(1))
		goal = BIOME_TRANSITION_GOAL_SCENE.instance()
		goal.set_biome_idx(biome_idx)
	elif Globals.COLOR_LETTERS.keys().has(raw_object):
		var color = Globals.COLOR_LETTERS[raw_object]
		if raw_object == raw_object.to_upper():
			goal = SNAKE_GOAL_SCENE.instance()
		else:
			goal = SEGMENT_GOAL_SCENE.instance()
		goal.set_color(color)
	return goal

func load_snakes() -> Array:
	var snake_instances = []
	var segments = []
	for snake_data in snakes:
		var snake = SNAKE_SCENE.instance()
		snake.set_color(snake_data.color)
		var snake_segments = snake.setup_segments(snake_data.segments, snake_data.ghosts)
		segments.append_array(snake_segments)
		snake_instances.append(snake)
	return [snake_instances, segments]

func parse_level():
	level.clear()
	var lines = level_string.split("\n")	
	var size_data = lines[0].split(",")
	size.x = int(size_data[0])
	size.y = int(size_data[1])
	
	for x in range(size.x):
		var col = []
		for y in range(size.y):
			col.append(lines[y + 1][x])
		level.append(col)

func parse_snakes():
	snakes.clear()
	var lines = snakes_string.split("\n")
	for line in lines:
		var segment_data = line.substr(1).split("-")
		var segments = []
		var ghosts = []
		var color = Globals.COLOR_LETTERS[line[0]]
		for pos_line in segment_data:
			var pos_data = pos_line.split("/")
			if pos_data[0].is_valid_integer():
				ghosts.append(false)
			else:
				pos_data[0] = pos_data[0].substr(1)
				ghosts.append(true)
			var pos = Vector2(int(pos_data[0]), int(pos_data[1]))
			segments.append(pos)
		snakes.append(SnakeData.new(segments, ghosts, color))

class SnakeData:
	var segments: Array
	var ghosts: Array
	var color

	func _init(segments: Array, ghosts: Array, color):
		self.segments = segments
		self.ghosts = ghosts
		self.color = color

class LevelObjects:
	var goals: Array
	var snakes: Array
	var segments: Array

	func _init(goals: Array, snakes: Array, segments: Array):
		self.goals = goals
		self.snakes = snakes
		self.segments = segments
