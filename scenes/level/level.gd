## Everything related to a single level
class_name Level extends Node2D

onready var tiles = $Tiles

var snakes

func load_level(data):
	# Load level from string
	# ...   
	# Setup objects
	snakes = $Snakes.get_children()
	for snake in snakes:
		snake.setup(tiles)

