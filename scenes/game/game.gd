## Master class for everything related to gameplay
extends Node

# export (Array, Resource) var levels
export (Array, Resource) var biomes
export (LevelData.Biome) var current_biome

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var level_idx = 0
var loading_level: bool = false
var current_level: Level

# onready var animation_player = $AnimationPlayer
onready var tween = $Tween
onready var overlay = $OverlayCanvas
onready var hub_button = $UICanvas/Control/HubButton
onready var sfx_transition = $SFXTransition

func _ready():
	Events.connect("level_transition", self, "_on_level_transition")
	Events.connect("biome_transition", self, "_on_biome_transition")
	load_level_idx(0, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		_on_level_completed()
	elif Input.is_action_just_pressed("ui_left"):
		level_idx -= 1
		if level_idx < 0:
			level_idx = len(biomes[current_biome].levels) - 1
		load_level_idx(level_idx)

func load_level_idx(level_idx: int, skip_fadeout=false):
	if level_idx == -1:
		# print(biomes[current_biome])
		load_level(biomes[current_biome].hub, skip_fadeout)
		return

	if level_idx > 0:
		hub_button.show()
	else:
		hub_button.hide()
	# print('Loading level [%d] from biome [%d] - %s' % [level_idx, current_biome, biomes[current_biome].levels[level_idx]])
	load_level(biomes[current_biome].levels[level_idx], skip_fadeout)

func load_level(level_data: LevelData, skip_fadeout=false):
	if loading_level:
		return
	loading_level = true
	if not skip_fadeout:
		sfx_transition.play()
		yield(fade_out(0.5, 0.15), "completed")
	else:
		yield(get_tree(), "idle_frame")
	if current_level:
		current_level.queue_free()
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(level_data)
	current_level.connect("completed", self, "_on_level_completed")
	add_child(current_level)
	yield(fade_in(0.5), "completed")
	current_level.start()
	loading_level = false

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
	level_idx += 1
	if level_idx > len(biomes[current_biome].levels) - 1:
		# biomes[current_biome].hub_unlocked = true
		current_biome = clamp(current_biome + 1, 0, len(biomes) - 1)
		level_idx = 0
	load_level_idx(level_idx)

func _on_level_transition(idx):
	current_level.fsm.next_state = current_level.fsm.states.idle
	level_idx = idx
	load_level_idx(idx)

func _on_biome_transition(idx):
	current_biome = idx
	level_idx = -1
	load_level_idx(level_idx)

func _on_HubButton_pressed():
	load_level_idx(-1)

func _on_UndoButton_pressed():
	Events.emit_signal("undo_pressed")
