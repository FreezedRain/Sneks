class_name SnakeGoal extends Goal

# onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var color setget set_color
var last_snake

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	if active:
		hide()
		#sprite.modulate = Color(4, 4, 4, 1)
	else:
		show()
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
