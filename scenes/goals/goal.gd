class_name Goal extends GridObject

var active: bool = false setget set_active
var target_color: Color = Color.white

onready var sprite = $Sprite
onready var overlay = $SpriteOverlay

func _init():
	solid = false

func _ready():
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

func update_turn():
	pass

func update_turn_action() -> Actions.Action:
	return null