extends TextureRect

export var fade_delay: float = 5
export var fade_duration: float = 0.25

onready var tween = $Tween
var fading: bool = false

func _ready():
	tween.interpolate_property(self, "modulate:a", 1, 0, fade_duration, 0, 2, fade_delay)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

func _input(event):
	if fading:
		return
	if event.is_pressed():
		tween.stop_all()
		fade()

func fade():
	fading = true
	tween.interpolate_property(self, "modulate:a", 1, 0, fade_duration)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
