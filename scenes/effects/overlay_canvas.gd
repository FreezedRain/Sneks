extends CanvasLayer

export (NodePath) onready var overlay_rect = get_node(overlay_rect) as ColorRect

onready var tween = $Tween

var fade: float = 1.0 setget set_fade

func fade_out(duration: float, post_delay: float):
	show()
	tween.interpolate_property(self, "fade", 0.0, 1.0, duration)
	tween.start()
	yield(tween, "tween_completed")
	yield(get_tree().create_timer(post_delay), "timeout")

func fade_in(duration: float):
	tween.interpolate_property(self, "fade", 1.0, 0.0, duration)
	tween.start()
	yield(tween, "tween_completed")
	hide()

func set_fade(value: float):
	fade = value
	overlay_rect.material.set_shader_param("progress", fade)

func show():
	overlay_rect.show()

func hide():
	overlay_rect.hide()
