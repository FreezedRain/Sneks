## Everything related to a single level
class_name Level extends Node2D

signal completed

onready var fsm = StateMachine.new(self, $States, $States/idle, false)
onready var terrain = $Terrain

onready var snake_holder = $Snakes
onready var segment_holder = $Segments
onready var goal_holder = $Goals

onready var decorations = $Decorations

# Data
var level_data: LevelData
var snakes: Array
var hovered_snake

# Input
var mouse_pos: Vector2
var mouse_grid_pos: Vector2

func _ready():
	pass

func _process(delta):
	process_input()
	fsm.process(delta)

func process_input():
	mouse_pos = get_viewport().get_mouse_position()
	mouse_grid_pos = Grid.world_to_grid(mouse_pos)

func start():
	fsm.next_state = fsm.states.turn

func load_level(data: LevelData):
	level_data = data
	Grid.load_tiles(data.load_tiles())

	yield(self, "ready")
	terrain.update_tiles()

	var level_objects = data.load_objects()
	for snake in level_objects.snakes:
		snake.connect("hovered", self, "_on_snake_hovered")
		snake.connect("unhovered", self, "_on_snake_unhovered")
		snake_holder.add_child(snake)
	
	for segment in level_objects.segments:
		segment_holder.add_child(segment)
	
	for goal in level_objects.goals:
		goal_holder.add_child(goal)
	
	decorations.setup()
	

func _on_snake_hovered(snake):
	hovered_snake = snake

func _on_snake_unhovered(snake):
	if hovered_snake == snake:
		hovered_snake = null
