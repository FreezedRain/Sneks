extends Camera2D

func _ready():
	yield(get_tree(), "idle_frame")
	position = get_viewport_rect().size * 0.5