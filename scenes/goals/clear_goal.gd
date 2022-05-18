class_name ClearGoal extends Goal

func _on_set_active():
	if active:
		show()
	else:
		hide()

func _ready():
	_on_set_active()

func _on_turn_updated():
	set_active(Grid.is_free(pos))