extends Goal

var level_id: String setget set_level_id

func set_level_id(value: String):
	level_id = value
	set_active(SaveManager.is_level_complete(value))
	$Label.text = str(Globals.LEVELS[value].index + 1)

func _on_set_active():
	if active:
		target_color = Color.white
	else:
		target_color = Color.gray

func update_turn():
	if not active:
		return
	var tile_objects = Grid.get_tile(pos).objects
	for obj in tile_objects:
		if obj is Snake:
			Events.emit_signal("level_transition", level_id)
