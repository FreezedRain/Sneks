## Master class for everything related to gameplay
extends Node

export (bool) var load_initial = true
export (LevelData.Biome) var biome_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var level_idx: int = 0
var loading_level: bool = false
var current_level: Level

onready var overlay = $OverlayCanvas
onready var undo_label = $UICanvas/Control/UndoButton/Label
onready var undo_button = $UICanvas/Control/UndoButton
onready var hub_button = $UICanvas/Control/HubButton
onready var sfx_transition = $SFXTransition

func _ready():
	Globals.load_biomes($Biomes)
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("undo_remaining", self, "_on_undo_remaining")
	Events.connect("level_transition", self, "_on_level_transition")
	if load_initial:
		load_level(Globals.LEVELS[SaveManager.get_last_level()])

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		load_level_idx(clamp(level_idx + 1, 0, len(Globals.BIOMES[biome_idx].levels)))
	elif Input.is_action_just_pressed("ui_left"):
		load_level_idx(clamp(level_idx - 1, 0, len(Globals.BIOMES[biome_idx].levels)))

func load_level_idx(idx: int, skip_fadeout=false):
	if loading_level:
		return
	if idx == -1:
		hub_button.set_active(false)
		load_level(Globals.BIOMES[biome_idx].hub, skip_fadeout)
		return
	
	load_level(Globals.BIOMES[biome_idx].levels[idx], skip_fadeout)

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
	SaveManager.set_last_level(level_data.get_id())
	biome_idx = level_data.biome
	SaveManager.complete_level(Globals.BIOMES[biome_idx].hub.get_id())
	level_idx = level_data.index
	hub_button.set_active(level_idx != -1)
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(level_data)
	add_child(current_level)
	yield(overlay.fade_in(0.5), "completed")
	current_level.start()
	loading_level = false

func _on_level_completed(level_id):
	level_idx += 1
	if level_idx > len(Globals.BIOMES[biome_idx].levels) - 1:
		biome_idx = clamp(biome_idx + 1, 0, len(Globals.BIOMES) - 1)
		level_idx = -1
	load_level_idx(level_idx)

func _on_level_transition(level_id):
	current_level.fsm.next_state = current_level.fsm.states.idle
	load_level(Globals.LEVELS[level_id])

func _on_HubButton_pressed():
	load_level_idx(-1)

func _on_UndoButton_pressed():
	Events.emit_signal("undo_pressed")

func _on_undo_remaining(remaining):
	undo_button.set_active(remaining > 0)
	undo_label.text = str(remaining)
	# if remaining > 0:
	# 	undo_label.show()
		
