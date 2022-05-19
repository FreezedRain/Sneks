extends Node

export (Resource) var level_data

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var level: Level

func _ready():
	level_data.parse_raw()
	load_level()

func load_level():
	if level:
		level.queue_free()
	level = LEVEL_SCENE.instance()
	level.load_level(level_data)
	level.connect("completed", self, "_on_level_completed")
	add_child(level)
	level.start()

func _on_level_completed():
	load_level()