class_name SnakeGoal extends Goal

var color setget set_color
var last_snake

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	# print('set active')
	if active:
		# hide()
		target_color = Color.white
		#sprite.modulate = Color(4, 4, 4, 1)
	else:
		# show()
		target_color = Globals.COLOR_RGB[color]
		# sprite.modulate = Color(1, 1, 1, 1)
	if last_snake:
		last_snake.set_state(Snake.State.HAPPY if active else Snake.State.NORMAL)
	
	# if active:
	# 	anim_player.play("highlight")
	# else:
	# 	anim_player.play_backwards("highlight")

func _on_turn_updated():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is Snake:
			last_snake = obj
			now_active = obj.color == color
	set_active(now_active)
