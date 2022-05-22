extends VideoPlayer

onready var game = get_parent().get_parent()
var hover_snake

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_prev"):
		if is_playing():
			
			hide()
			stop()
		else:
			show()
			play()

	if game.current_level != null and game.current_level.snake_holder.get_child_count() > 0:
		# hover_snake = game.current_level.hovered_snake.sprite
		rect_position = game.current_level.snake_holder.get_child(0).sprite.global_position - rect_size * 0.5
	# if is_instance_valid(hover_snake):
	# 	rect_position = hover_snake.global_position - rect_size * 0.5
