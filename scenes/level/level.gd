## Everything related to a single level
class_name Level extends Node2D

const SNAKE_SCENE = preload("res://scenes/actors/snake/snake.tscn")

onready var fsm = StateMachine.new(self, $States, $States/idle, false)
onready var grid = $Grid
onready var snake_holder = $Snakes

# Data
var level_data: LevelData
var snakes: Array
var hovered_snake: Snake

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
	mouse_grid_pos = grid.world_to_grid(mouse_pos)

func load_level(level_data: LevelData):
	level_data.parse()
	self.level_data = level_data

	grid.load_data(level_data)

	for snake_segments in level_data.snakes:
		var snake = SNAKE_SCENE.instance()
		snake.setup(grid)
		snake.setup_segments(snake_segments)
		snake.connect("hovered", self, "_on_snake_hovered")
		snake.connect("unhovered", self, "_on_snake_unhovered")
		snakes.append(snake)

func _on_snake_hovered(snake):
	hovered_snake = snake

func _on_snake_unhovered(snake):
	hovered_snake = null