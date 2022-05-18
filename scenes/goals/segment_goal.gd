class_name SegmentGoal extends Goal

var color setget set_color

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_turn_updated():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is SnakeSegment:
			now_active = obj.color == color
	set_active(now_active)
