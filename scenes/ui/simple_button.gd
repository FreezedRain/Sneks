extends TextureButton

var active setget set_active
var hovered = false

export (Color) var disabled_color
export (float) var duration = 0.1
export (float) var target_scale = 1.1
export (float) var target_rotation = 0
onready var tween = $Tween
onready var key_prompt = $KeyPrompt

func _ready():
	Events.connect("controls_changed", self, "_on_controls_changed")

func set_active(value):
	active = value
	if hovered and not active:
		_on_mouse_exited()
	disabled = not active
	modulate = Color.white if active else disabled_color

func _on_mouse_exited():
	if disabled:
		return
	hovered = false
	tween.stop_all()
	tween.interpolate_property(self, "rect_rotation", target_rotation, 0, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale", Vector2.ONE * target_scale, Vector2.ONE, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _on_mouse_entered():
	if disabled:
		return
	hovered = true
	tween.stop_all()
	tween.interpolate_property(self, "rect_rotation", 0, target_rotation, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "rect_scale", Vector2.ONE, Vector2.ONE * target_scale, duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _on_controls_changed(keyboard):
	if key_prompt != null:
		key_prompt.visible = keyboard