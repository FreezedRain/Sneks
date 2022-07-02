class_name BiomeTransitionGoal extends Goal

var biome_idx: int setget set_biome_idx
# onready var sprite_overlay = $SpriteOverlay

func set_biome_idx(value: int):
	biome_idx = value
	var biome = Globals.BIOMES[value]
	set_active(SaveManager.is_level_complete(biome.hub.get_id()))
	if not sprite:
		yield(self, "ready")
	sprite.texture = biome.icon
	overlay.texture = biome.icon

func show_unlock_progress():
	if biome_idx == 0:
		return
	var previous_biome = Globals.BIOMES[biome_idx - 1]
	$Label.show()
	$Label.text = "%d/%d" % [previous_biome.total_levels_complete(), previous_biome.next_levels_required]
	# target_color = Globals.BIOME_RESOURCES[value].color_top
	# $Label.text = str(value)

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
			Events.emit_signal("level_transition", Globals.BIOMES[biome_idx].hub.get_id())
