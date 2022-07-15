extends Camera2D

func _ready():
	if Globals.INITIAL_RESOLUTION == Vector2.ZERO:
		Globals.INITIAL_RESOLUTION = get_viewport().size
	position = Globals.INITIAL_RESOLUTION * 0.5