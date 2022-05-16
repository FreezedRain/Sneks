class_name Snake extends Actor

signal hovered(snake)
signal unhovered(snake)

const SEGMENT_SCENE = preload("res://scenes/actors/snake/snake_segment.tscn")

onready var visuals = $Visuals
onready var sprite = $Visuals/Sprite

var segments: Array
# var segment_holder: Node2D
var line: Line2D
var target_position: Vector2

func _ready():
	pass

func _process(delta):
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)
	# line.set_point_position(0, visuals.position)
	for i in range(len(segments)):
		line.set_point_position(i + 1, segments[i].position - position - visuals.position)

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
	for i in range(len(segments) - 1):
		segments[i].set_pos(segments[i + 1].grid_pos)
		segments[i].align_visuals()

	segments[len(segments) - 1].set_pos(last_tail_pos)
	segments[len(segments) - 1].align_visuals()

	align_visuals()

func setup_segments(segment_positions: Array):
	set_pos(segment_positions[0])
	align()
	line = $Visuals/Line2D
	line.add_point(Vector2.ZERO)
	# segment_holder = $Segments
	
	segment_positions.pop_front()
	for pos in segment_positions:
		var segment = SEGMENT_SCENE.instance()
		segment.setup(grid, pos)
		segments.append(segment)
		# segment_holder.add_child(segment)
		line.add_point(segment.position - position)

func align_visuals():
	var previous_pos = position
	align()
	visuals.position = previous_pos - position

func get_tail_pos() -> Vector2:
	return segments[len(segments) - 1].grid_pos

func _on_HoverArea_mouse_entered():
	sprite.modulate = Color(0.75, 0.75, 0.75, 1)
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	sprite.modulate = Color(1, 1, 1, 1)
	emit_signal("unhovered", self)
