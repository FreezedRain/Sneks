class_name SnakeGoal extends Goal

var color setget set_color
var last_snake

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	if active:
		target_color = Color.white
	else:
		target_color = Globals.COLOR_RGB[color]

	if last_snake:
		last_snake.set_state(Snake.State.HAPPY if active else Snake.State.NORMAL)

func update_turn():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is Snake:
			last_snake = obj
			now_active = obj.color == color
	set_active(now_active)
