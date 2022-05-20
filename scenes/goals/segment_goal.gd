class_name SegmentGoal extends Goal

var color setget set_color

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	if active:
		target_color = Color.white
		#sprite.modulate = Color(4, 4, 4, 1)
	else:
		# show()
		target_color = Globals.COLOR_RGB[color]

func _on_turn_updated():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is SnakeSegment:
			now_active = obj.color == color
	set_active(now_active)
