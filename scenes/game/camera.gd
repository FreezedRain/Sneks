extends Camera2D

func _ready():
	# var MOBILE = OS.get_name() == 'Android' or OS.get_name() == 'iOS' or OS.get_name() == 'HTML5'
	var MOBILE = OS.has_touchscreen_ui_hint()
	# if OS.get_model_name() == 'GenericDevice':
	# 	MOBILE = false
	if not MOBILE:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2.ZERO, 1)
	var size = OS.get_screen_size() if MOBILE else get_viewport_rect().size
	position = size * 0.5
