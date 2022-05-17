class_name SnakeSegment extends GridObject

var snake
var target_position: Vector2

func _ready():
	pass

func setup_snake(snake):
	self.snake = snake

func _process(delta):
	position = lerp(position, target_position, delta * 16)

func align():
	.align()
	target_position = position

func align_visuals():
	target_position = get_world_pos()