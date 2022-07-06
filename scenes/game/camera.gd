extends Camera2D

func _ready():
	var MOBILE = OS.get_name() == 'Android' or OS.get_name() == 'iOS' or OS.get_name() == 'HTML5'
	var size = OS.get_screen_size() if MOBILE else get_viewport_rect().size
	position = size * 0.5
