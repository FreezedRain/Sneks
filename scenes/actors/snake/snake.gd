class_name Snake extends Actor

signal hovered(snake)
signal unhovered(snake)

const SEGMENT_SCENE = preload("res://scenes/actors/snake/snake_segment.tscn")

onready var visuals = $Visuals
onready var sprite = $Visuals/Sprite
onready var head = $Visuals/Sprite/Head

var color
var segments: Array
var line: Line2D
var target_position: Vector2

func _ready():
	pass

func _process(delta):
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	if len(segments) > 0:
		sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)
		for i in range(len(segments)):
			line.set_point_position(i + 1, segments[i].position - position - visuals.position)

func set_pos(new_pos: Vector2):
	.set_pos(new_pos)

func can_move(direction: Vector2) -> bool:
	if not grid.is_free(grid_pos + direction):
		return false
	return true

func move(direction: Vector2):
	var move_pos = grid_pos + direction

	for i in range(len(segments) - 1, 0, -1):
		segments[i].set_pos(segments[i - 1].grid_pos)
		segments[i].align_visuals()

	# Update segments
	segments[0].set_pos(grid_pos)
	segments[0].align_visuals()
	
	# Update head
	set_pos(move_pos)
	align_visuals()

func reverse_move(last_tail_pos: Vector2):
	set_pos(segments[0].grid_pos)
	align_visuals()
	
	for i in range(len(segments) - 1):
		segments[i].set_pos(segments[i + 1].grid_pos)
		segments[i].align_visuals()

	segments[len(segments) - 1].set_pos(last_tail_pos)
	segments[len(segments) - 1].align_visuals()

func setup_segments(segment_positions: Array):
	set_pos(segment_positions[0])
	align()
	line = $Visuals/Line2D
	line.add_point(Vector2.ZERO)
	var count = 0
	for pos in segment_positions:
		count += 1
		if count == 1:
			continue
		var segment = SEGMENT_SCENE.instance()
		segment.setup(grid, pos)
		segment.setup_snake(self)
		segments.append(segment)
		line.add_point(segment.position - position)

func set_color(color):
	self.color = color
	line.default_color = Globals.COLORS_RGB[self.color]

func align_visuals():
	var previous_pos = position
	align()
	visuals.position = previous_pos - position

func get_tail_pos() -> Vector2:
	return segments[len(segments) - 1].grid_pos

func set_highlight(enabled: bool):
	if enabled:
		head.show()
	else:
		head.hide()

func _on_HoverArea_mouse_entered():
	# head.show()
	# visuals.modulate = Color(0.85, 0.85, 0.85, 1)
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	# head.hide()# = Color(1, 1, 1, 1)
	emit_signal("unhovered", self)
