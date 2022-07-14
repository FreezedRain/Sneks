## Master class for everything related to gameplay
extends Node

export (bool) var load_initial = true
export (String) var override_level_id = ""
export (LevelData.Biome) var biome_idx

const LEVEL_SCENE = preload("res://scenes/level/level.tscn")
const FINALE_SCENE = preload("res://scenes/extra/finale.tscn")

var level_idx: int = 0
var loading_level: bool = false
var current_level
var keyboard_controls: bool = false

onready var overlay = $OverlayCanvas
onready var undo_label = $UICanvas/Control/UndoButton/Label
onready var undo_button = $UICanvas/Control/UndoButton
onready var hub_button = $UICanvas/Control/HubButton
onready var sfx_transition = $SFXTransition

func _ready():
	if not CmgIntegration.is_valid():
		get_tree().quit()
		return
	
	Globals.load_biomes($Biomes)
	Events.connect("game_completed", self, "_on_game_completed")
	Events.connect("return_to_game", self, "return_to_game")
	Events.connect("level_completed", self, "_on_level_completed")
	Events.connect("undo_remaining", self, "_on_undo_remaining")
	Events.connect("level_transition", self, "_on_level_transition")
	if load_initial:
		if override_level_id != "":
			load_level(Globals.LEVELS[override_level_id])
		else:
			load_level(Globals.LEVELS[SaveManager.get_last_level()])

	CmgIntegration.game_start();

func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
		if not keyboard_controls:
			keyboard_controls = true
			update_controls()
	elif event is InputEventMouseButton and event.pressed:
		if keyboard_controls:
			keyboard_controls = false
			update_controls()

func _process(delta):
	if loading_level:
		return
	if Input.is_action_just_pressed("restart"):
		load_level_idx(level_idx, false, true)
	elif Input.is_action_just_pressed("home"):
		if hub_button.active:
			_on_HubButton_pressed()
	if keyboard_controls:
		if Input.is_action_just_pressed("undo"):
			if not undo_button.disabled:
				undo_button._on_button_down()
	if Input.is_action_just_released("undo"):
		if not undo_button.disabled:
			undo_button._on_button_up()

	# if Input.is_action_just_pressed("ui_right"):
	# 	load_level_idx(clamp(level_idx + 1, 0, len(Globals.BIOMES[biome_idx].levels)))
	# elif Input.is_action_just_pressed("ui_left"):
	# 	load_level_idx(clamp(level_idx - 1, 0, len(Globals.BIOMES[biome_idx].levels)))

func load_level_idx(idx: int, skip_fadeout=false, restart=false):
	if loading_level:
		return
	if idx == -1:
		hub_button.set_active(false)
		load_level(Globals.BIOMES[biome_idx].hub, skip_fadeout, restart)
		return
	
	load_level(Globals.BIOMES[biome_idx].levels[idx], skip_fadeout, restart)

func load_level(level_data: LevelData, skip_fadeout=false, restart=false):
	if loading_level:
		return
	loading_level = true
	if skip_fadeout:
		yield(get_tree(), "idle_frame")
	else:
		play_transition_sfx()
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
	update_controls()
	yield(overlay.fade_in(0.5), "completed")
	current_level.start()
	loading_level = false
	
	if level_idx != -1:
		if restart:
			CmgIntegration.level_restart(level_data.numeric_id)
		else:
			CmgIntegration.level_start(level_data.numeric_id)

func return_to_game():
	loading_level = true
	play_transition_sfx()
	yield(overlay.fade_out(0.5, 0.15), "completed")
	hub_button.show()
	undo_button.show()
	loading_level = false
	load_level_idx(-1, true)

func update_controls():
	Events.emit_signal("controls_changed", keyboard_controls)

func play_transition_sfx():
	sfx_transition.pitch_scale = rand_range(1.0, 1.15)
	sfx_transition.play()

func _on_game_completed():
	loading_level = true
	SaveManager.complete_level(Globals.BIOMES[biome_idx].hub.get_id())
	play_transition_sfx()
	yield(overlay.fade_out(0.5, 0.15), "completed")
	current_level.queue_free()
	current_level = FINALE_SCENE.instance()
	add_child(current_level)
	hub_button.hide()
	undo_button.hide()
	yield(overlay.fade_in(0.5), "completed")

func _on_level_completed(level_id):
	level_idx += 1
	if level_idx > len(Globals.BIOMES[biome_idx].levels) - 1:
		level_idx = -1
	load_level_idx(level_idx)

func _on_level_transition(level_id):
	current_level.fsm.next_state = current_level.fsm.states.idle
	load_level(Globals.LEVELS[level_id])

func _on_HubButton_pressed():
	load_level_idx(-1)

func _on_undo_remaining(remaining):
	undo_button.set_active(remaining > 0)
	undo_label.text = str(remaining)

func _on_UndoButton_short_pressed():
	Events.emit_signal("undo_pressed")

func _on_UndoButton_long_pressed():
	load_level_idx(level_idx, false, true)
