extends Camera2D

func _ready():
	# var MOBILE = OS.get_name() == 'Android' or OS.get_name() == 'iOS' or OS.get_name() == 'HTML5'
	if OS.get_name() == 'HTML5':
		OS.set_window_maximized(true)
	print(OS.get_name())
	print(OS.has_touchscreen_ui_hint())
	var MOBILE = OS.has_touchscreen_ui_hint()
	# if OS.get_model_name() == 'GenericDevice':
	# 	MOBILE = false

	yield(get_tree(), "idle_frame")
	
	# if not MOBILE:
	# 	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,  SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, Vector2.ZERO, 1)
	# var size = OS.get_screen_size() if MOBILE else get_viewport_rect().size
	# position = size * 0.5
	get_tree().get_root().connect("size_changed", self, "_on_size_changed")
	_on_size_changed()
	# position = get_viewport_rect().size * 0.5

func _on_size_changed():
	print(get_viewport_rect().size)
	# position = get_viewport_rect().size * 0.5