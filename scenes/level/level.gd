## Everything related to a single level
class_name Level extends Node2D

onready var grid = $Grid

# Data
var snakes: Array

# Turn
var snake_idx: int
var waiting_for_turn: bool
var making_turn: bool

# Input
var mouse_pos: Vector2
var mouse_grid_pos: Vector2

func _process(delta):
    process_input()
    if waiting_for_turn:
        process_turns()

func process_input():
    mouse_pos = get_viewport().get_mouse_position()
    mouse_grid_pos = mouse_pos# grid.world_to_grid(mouse_pos)

func process_turns():
    if Input.is_action_just_pressed("click"):
        making_turn = true
    if making_turn:
        if Input.is_action_just_released("click"):
            # Commit turn
            pass
        var direction = (snakes[snake_idx].grid_pos)

func load_level(data: LevelData):
	# Load level from string
	
	$Grid.setup(data.level_string)
		
	

func start_turn():
    waiting_for_turn = true

func end_turn():
    snake_idx = (snake_idx + 1) % len(snakes)