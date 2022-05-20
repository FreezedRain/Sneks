class_name ClearGoal extends Goal

func _ready():
	set_active(true)

func _on_set_active():
	if active:
		target_color = Color.white
	else:
		target_color = Color.red

func _on_turn_updated():
	set_active(Grid.is_free(pos))
