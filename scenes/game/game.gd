## Master class for everything related to gameplay
extends Node

# export (Array, Resource) var levels
export (Array, Resource) var biomes
export (LevelData.Biome) var current_biome

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var level_idx: int = 0
var loading_level: bool = false
var current_level: Level

onready var overlay = $OverlayCanvas
onready var hub_button = $UICanvas/Control/HubButton
onready var sfx_transition = $SFXTransition

func _ready():
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_transition", self, "_on_level_transition")
	Events.connect("biome_transition", self, "_on_biome_transition")
	load_level_idx(0, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		load_level_idx(clamp(level_idx + 1, 0, len(biomes[current_biome.levels])))
	elif Input.is_action_just_pressed("ui_left"):
		load_level_idx(clamp(level_idx - 1, 0, len(biomes[current_biome.levels])))

func load_level_idx(idx: int, skip_fadeout=false):
	if loading_level:
		return
	level_idx = idx
	hub_button.show()
	if idx == -1:
		hub_button.hide()
		load_level(biomes[current_biome].hub, skip_fadeout)
		return
	
	if idx == 0 and current_biome == 0:
		hub_button.hide()
	# elif current_biome == 0:
	# 	hub_button.hide()
	# print('Loading level [%d] from biome [%d] - %s' % [level_idx, current_biome, biomes[current_biome].levels[level_idx]])
	load_level(biomes[current_biome].levels[idx], skip_fadeout)

func load_level(level_data: LevelData, skip_fadeout=false):
	if loading_level:
		return
	loading_level = true
	if skip_fadeout:
		yield(get_tree(), "idle_frame")
	else:
		sfx_transition.pitch_scale = rand_range(1.0, 1.15)
		sfx_transition.play()
		yield(overlay.fade_out(0.5, 0.15), "completed")
	if current_level:
		current_level.queue_free()
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(level_data)
	add_child(current_level)
	yield(overlay.fade_in(0.5), "completed")
	current_level.start()
	loading_level = false

func _on_level_completed(level: LevelData):
	level_idx += 1
	if level_idx > len(biomes[current_biome].levels) - 1:
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
