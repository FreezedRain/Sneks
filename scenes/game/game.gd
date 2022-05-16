## Master class for everything related to gameplay
extends Node2D

export (Array, Resource) var levels
export (int) var level_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var current_level: Level

func _ready():
	load_level(level_idx)

func load_level(idx: int):
	if current_level:
		current_level.queue_free()
	var level_data = levels[idx]
	current_level = LEVEL_SCENE.instance()
	current_level.call_deferred("load_level", level_data)
	add_child(current_level)
