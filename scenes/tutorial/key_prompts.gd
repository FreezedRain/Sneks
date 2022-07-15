extends TextureRect

export var fade_delay: float = 5
export var fade_duration: float = 0.25

onready var tween = $Tween
var fading: bool = false

func fade():
	fading = true
	tween.interpolate_property(self, "modulate:a", 1, 0, fade_duration)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
