extends GridObject

var target_position: Vector2

func _ready():
	pass

func _process(delta):
	position = lerp(position, target_position, delta * 16)

func align():
	.align()
	target_position = position

func align_visuals():
	target_position = get_world_pos()