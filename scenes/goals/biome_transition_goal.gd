extends Goal

var biome_idx: int setget set_biome_idx

func set_biome_idx(value: int):
	biome_idx = value
	target_color = Globals.BIOME_RESOURCES[value].color_top
	# $Label.text = str(value)

func update_turn():
	var tile_objects = Grid.get_tile(pos).objects
	for obj in tile_objects:
		if obj is Snake:
			Events.emit_signal("biome_transition", biome_idx)
