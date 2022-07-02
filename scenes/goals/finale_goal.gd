extends Goal

onready var sfx_pop = $SFXPop

func update_turn():
	var tile_objects = Grid.get_tile(pos).objects
	for obj in tile_objects:
		if obj is Snake:
			Events.emit_signal("game_completed")
			ParticleManager.spawn('apple_particle', position)
			sfx_pop.play()
			# hide()