## Master class for everything related to gameplay
extends Node

export (Array, Resource) var levels
export (int) var level_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var current_level: Level
var new_level: Level

onready var animation_player = $AnimationPlayer

func _ready():
	for level in levels:
		level.parse()
	load_level(level_idx)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		level_idx = (level_idx + 1) % len(levels)
		load_level(level_idx)
	elif Input.is_action_just_pressed("ui_left"):
		level_idx -= 1
		if level_idx < 0:
			level_idx = len(levels) - 1
		load_level(level_idx)

func load_level(idx: int):
	var level_data = levels[idx]
	new_level = LEVEL_SCENE.instance()
	new_level.call_deferred("load_level", level_data)
	animation_player.play('level_open')
	add_child(new_level)
	new_level.hide()
	new_level.set_process(false)
	
func swap_level():
	if current_level:
		current_level.queue_free()
	current_level = new_level
	current_level.show()
	new_level.set_process(true)
	
func start_level():
	current_level.start()
