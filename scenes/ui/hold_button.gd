class_name HoldButton extends SimpleButton

signal short_pressed
signal long_pressed

export var hold_time: float = 0.5

var hold_timer: float = hold_time

func _ready():
	material.set_shader_param("fill_color", disabled_color)

func _on_button_up():
	if hold_timer < hold_time:
		emit_signal("short_pressed")
	else:
		emit_signal("long_pressed")
	hold_timer = hold_time
	material.set_shader_param("fill", 0)

func _on_button_down():
	hold_timer = 0

func _process(delta):
	if hold_timer < hold_time:
		hold_timer += delta
		material.set_shader_param("fill", hold_timer / hold_time)
		if hold_timer > hold_time:
			hold_timer = hold_time
			material.set_shader_param("fill", hold_timer / hold_time)
			_on_button_up()
		