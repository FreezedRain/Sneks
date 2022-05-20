class_name Apple extends Goal

func _on_set_active():
	if active:
		ParticleManager.spawn('apple_particle', position)
		hide()
	else:
		show()