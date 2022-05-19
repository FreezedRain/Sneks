class_name ClearGoal extends Goal

func _on_set_active():
	if active:
		$Sprite.modulate = Color.white
	else:
		$Sprite.modulate = Color.red
	pass

func _ready():
	active = true
	_on_set_active()

func _on_turn_updated():
	set_active(Grid.is_free(pos))
