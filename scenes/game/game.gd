## Master class for everything related to gameplay
extends Node

export (Array, Resource) var levels
export (Resource) var level_hub
export (int) var level_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var current_level: Level

# onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var overlay = $OverlayCanvas

func _ready():
	Events.connect("level_transition", self, "_on_level_transition")
# level_hub.parse_raw()
# for level in levels:
# 	level.parse_raw()
	# if level_idx == 0:
	load_level_idx(-1)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		level_idx = (level_idx + 1) % len(levels)
		load_level_idx(level_idx)
	elif Input.is_action_just_pressed("ui_left"):
		level_idx -= 1
		if level_idx < 0:
			level_idx = len(levels) - 1
		load_level_idx(level_idx)

func load_level_idx(level_idx: int, skip_fadeout=false):
	if level_idx == -1:
		load_level(level_hub, skip_fadeout)
		return
	load_level(levels[level_idx], skip_fadeout)

func load_level(level_data: LevelData, skip_fadeout=false):
	if not skip_fadeout:
		yield(fade_out(0.5, 0.15), "completed")
	if current_level:
		current_level.queue_free()
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(level_data)
	current_level.connect("completed", self, "_on_level_completed")
	add_child(current_level)
	yield(fade_in(0.5), "completed")
	current_level.start()

func fade_out(duration: float, post_delay: float):
	overlay.show()
	tween.interpolate_property(overlay, "fade", 0.0, 1.0, duration)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(post_delay), "timeout")

func fade_in(duration: float):
	tween.interpolate_property(overlay, "fade", 1.0, 0.0, duration)
	tween.start()
	yield(tween, "tween_completed")
	overlay.hide()

func _on_level_completed():
	level_idx = clamp(level_idx + 1, 0, len(levels) - 1)
	load_level_idx(level_idx)

func _on_level_transition(idx):
	current_level.fsm.next_state = current_level.fsm.states.idle
	load_level_idx(idx)
