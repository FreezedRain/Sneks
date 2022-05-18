class_name SnakeGoal extends Goal

# onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var color setget set_color

func set_color(value):
	color = value
	modulate = Globals.COLOR_RGB[color]

func _on_set_active():
	if active:
		sprite.modulate = Color(4, 4, 4, 1)
	else:
		sprite.modulate = Color(1, 1, 1, 1)
	# if active:
	# 	anim_player.play("highlight")
	# else:
	# 	anim_player.play_backwards("highlight")

func _on_turn_updated():
	var tile_objects = Grid.get_tile(pos).objects
	var now_active = false
	for obj in tile_objects:
		if obj is Snake:
			now_active = obj.color == color
	set_active(now_active)
