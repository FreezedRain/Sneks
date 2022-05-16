extends Node2D

export (Resource) var level_data

onready var grid = $Grid

func _ready():
	level_data.parse()
	grid.load_data(level_data)

func _process(delta):
	var grid_pos = grid.world_to_grid(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("click"):
		grid.terrain.set_tile(grid_pos, !grid.terrain.get_tile(grid_pos))