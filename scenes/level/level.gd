## Everything related to a single level
class_name Level extends Node2D

onready var tiles = $Tiles
onready var snakes = $Snakes.get_children()

# Handle player turns and environment actions
func load_level(data):
    pass