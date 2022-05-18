## Master class for everything related to gameplay
extends Node

export (Array, Resource) var levels
export (int) var level_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var current_level: Level

# onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var overlay = $CanvasLayer/Overlay

func _ready():
	for level in levels:
		level.parse_raw()
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
	yield(fade_out(0.5), "completed")
	if current_level:
		current_level.queue_free()
	var level_data = levels[idx]
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(levels[idx])
	current_level.connect("completed", self, "_on_level_completed")
	add_child(current_level)
	yield(fade_in(0.5), "completed")
	current_level.start()

func fade_out(duration: float):
	overlay.show()
	tween.interpolate_property(overlay, "color:a", 0.0, 1.0, duration)
	tween.start()
	yield(tween, "tween_completed")

func fade_in(duration: float):
	tween.interpolate_property(overlay, "color:a", 1.0, 0.0, duration)
	tween.start()
	yield(tween, "tween_completed")
	overlay.hide()

func _on_level_completed():
	level_idx = clamp(level_idx + 1, 0, len(levels) - 1)
	load_level(level_idx)
