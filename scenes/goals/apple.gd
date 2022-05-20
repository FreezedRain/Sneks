class_name Apple extends Goal

onready var apple_sprite = $Apple

func _on_set_active():
	if active:
		ParticleManager.spawn('apple_particle', position)
		hide()
	else:
		show()

var startpos
var t = 0

func _ready():
	startpos = apple_sprite.position

func _process(delta):
	t += delta
	apple_sprite.position = startpos + Vector2.UP * sin(t*2) * 3;

func update_turn_action() -> Actions.Action:
	var objects = Grid.get_tile(pos).objects
	for obj in objects:
		if obj is Snake:
			return Actions.AppleEatAction.new(obj, self)
	return null