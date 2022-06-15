## Master class for everything related to gameplay
extends Node

export (bool) var load_initial = true
export (LevelData.Biome) var biome_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")

var level_idx: int = 0
var loading_level: bool = false
var current_level: Level

onready var overlay = $OverlayCanvas
onready var hub_button = $UICanvas/Control/HubButton
onready var sfx_transition = $SFXTransition

func _ready():
	Globals.load_biomes($Biomes)
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("level_transition", self, "_on_level_transition")
	if load_initial:
		load_level_idx(0, true)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		load_level_idx(clamp(level_idx + 1, 0, len(Globals.BIOMES[biome_idx].levels)))
	elif Input.is_action_just_pressed("ui_left"):
		load_level_idx(clamp(level_idx - 1, 0, len(Globals.BIOMES[biome_idx].levels)))

func load_level_idx(idx: int, skip_fadeout=false):
	if loading_level:
		return
	if idx == -1:
		load_level(Globals.BIOMES[biome_idx].hub.get_id(), skip_fadeout)
		return
	load_level(Globals.BIOMES[biome_idx].levels[idx].get_id(), skip_fadeout)

func load_level(id: String, skip_fadeout=false):
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
	var level_data = Globals.LEVELS[id]
	biome_idx = level_data.biome
	level_idx = level_data.index
	current_level = LEVEL_SCENE.instance()
	current_level.load_level(Globals.LEVELS[id])
	add_child(current_level)
	yield(overlay.fade_in(0.5), "completed")
	current_level.start()
	loading_level = false

func _on_level_completed(level_id):
	level_idx += 1
	if level_idx > len(Globals.BIOMES[biome_idx].levels) - 1:
		biome_idx = clamp(biome_idx + 1, 0, len(Globals.BIOMES) - 1)
		level_idx = 0
	load_level_idx(level_idx)

func _on_level_transition(level_id):
	current_level.fsm.next_state = current_level.fsm.states.idle
	load_level(level_id)

# func _on_biome_transition(idx):
# 	biome_idx = idx
# 	level_idx = -1
# 	load_level_idx(level_idx)

func _on_HubButton_pressed():
	load_level_idx(-1)

func _on_UndoButton_pressed():
	Events.emit_signal("undo_pressed")
