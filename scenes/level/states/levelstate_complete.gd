extends State

func enter(from_state: State):
	Events.emit_signal("level_completed", object.level_data)

func exit(to_state: State):
	pass

func process(delta):
	pass
	# if Input.is_action_just_pressed("click"):
	# 	object.emit_signal("completed")
