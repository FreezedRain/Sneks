class_name SegmentGoal extends Goal

var color setget set_color

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	if active:
		target_color = Color.white
	else:
		target_color = Globals.COLOR_RGB[color]

func update_turn():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is Snake or obj is SnakeSegment:
			now_active = obj.color == color
	set_active(now_active)
