extends CanvasLayer

onready var overlay = $Overlay2

var fade: float = 1.0 setget set_fade

func set_fade(value: float):
	fade = value
	# overlay.color.a = fade
	overlay.material.set_shader_param("progress", fade)

func show():
	overlay.show()

func hide():
	overlay.hide()
