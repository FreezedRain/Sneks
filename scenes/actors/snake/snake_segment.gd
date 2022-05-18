class_name SnakeSegment extends GridObject

var snake setget set_snake
var target_position: Vector2
var color

var segment_percent

func _init():
	solid = true

func _ready():
	pass

func set_snake(value):
	snake = value
	color = snake.color

func _process(delta):
	position = lerp(position, target_position, delta * (16 - segment_percent * 8))

func align():
	.align()
	target_position = position

func align_visuals():
	target_position = get_world_pos()

func set_segment_percent(percent):
	segment_percent = percent
