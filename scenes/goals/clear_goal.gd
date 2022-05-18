class_name ClearGoal extends Goal

func _on_turn_updated():
	var tile_objects = Grid.get_tile(pos).objects
	set_active(tile_objects.size() == 0)