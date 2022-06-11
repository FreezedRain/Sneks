extends Node

export (Resource) var level_data

onready var game = $Game

func _ready():
	game.load_level(level_data)