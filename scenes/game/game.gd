## Master class for everything related to gameplay
extends Node

export (Array, Resource) var levels
export (int) var level_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var current_level: Level
var new_level: Level

onready var animation_player = $AnimationPlayer

func _ready():
	load_level(level_idx)

func load_level(idx: int):
	var level_data = levels[idx]
	new_level = LEVEL_SCENE.instance()
	new_level.call_deferred("load_level", level_data)
	animation_player.play('level_open')
	add_child(new_level)
	new_level.hide()
	
func swap_level():
	if current_level:
		current_level.queue_free()
	current_level = new_level
	current_level.show()
	
func start_level():
	current_level.start()
