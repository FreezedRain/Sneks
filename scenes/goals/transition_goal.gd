class_name TransitionGoal extends Goal

onready var completion_sprite = $CompletionSprite
var level_id: String setget set_level_id

func _ready():
	set_active(true)

func set_level_id(value: String):
	level_id = value
	$CompletionSprite.visible = SaveManager.is_level_complete(value)
	# set_active(SaveManager.is_level_complete(value))
	# if not active:
	# 	var level = Globals.LEVELS[value]
	# 	var previous_level = Globals.BIOMES[level.biome].get_level(level.index - 1)
	# 	set_active(SaveManager.is_level_complete(previous_level.get_id()))
	$Label.text = str(Globals.LEVELS[value].index + 1)

# func _on_set_active():
# 	if active:
# 		target_color = Color.white
# 	else:
# 		target_color = Color.gray

func update_turn():
	if not active:
		return
	var tile_objects = Grid.get_tile(pos).objects
	for obj in tile_objects:
		if obj is Snake:
			Events.emit_signal("level_transition", level_id)
