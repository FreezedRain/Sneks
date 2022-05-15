## Everything related to a single level
class_name Level extends Node2D

onready var grid = $Grid

var snakes: Array

func load_level(data: LevelData):
	# Load level from string
	
	$Grid.setup(data.level_string)
		
	

