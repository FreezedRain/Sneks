class_name Goal extends GridObject

var active: bool = false setget set_active
var target_color: Color = Color.white

onready var sprite = $Sprite

func _init():
	solid = false

func _ready():
	Events.connect("turn_updated", self, "_on_turn_updated")
	_on_set_active()

func _process(delta):
	modulate = lerp(modulate, target_color, delta * 6)

func set_active(value: bool):
	if active == value:
		return
	active = value
	_on_set_active()

func _on_set_active():
	pass

func _on_turn_updated():
	pass