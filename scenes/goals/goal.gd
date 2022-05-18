class_name Goal extends GridObject

var active: bool setget set_active

func _init():
	solid = false

func _ready():
	Events.connect("turn_updated", self, "_on_turn_updated")
	_on_set_active()

func set_active(value: bool):
	if active == value:
		return
	active = value
	_on_set_active()

func _on_set_active():
	pass

func _on_turn_updated():
	pass
