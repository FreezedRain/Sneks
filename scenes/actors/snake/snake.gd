class_name Snake extends Actor

const SEGMENT_SCENE = preload("res://scenes/actors/snake/snake_segment.tscn")

var segments: Array
var segment_holder: Node2D
var line: Line2D

func _ready():
	pass

func _process(delta):
	for i in range(len(segments)):
		line.set_point_position(i, segments[i].position)

func can_move(direction: Vector2) -> bool:
	if not grid.is_free(grid_pos + direction):
		return false
	return true

func move(direction: Vector2):
	var move_pos = grid_pos + direction
	# Update segments
	for i in range(len(segments) - 1, 0, -1):
		segments[i].grid_pos = segments[i - 1].grid_pos
		segments[i].align_to_grid(grid)
	
	# Update head
	segments[0].grid_pos = move_pos
	segments[0].align_to_grid(grid)
	grid_pos = move_pos

func reverse_move(last_tail_pos: Vector2):
	for i in range(len(segments) - 1):
		segments[i].grid_pos = segments[i + 1].grid_pos
		segments[i].align_to_grid(grid)

	segments[len(segments) - 1].grid_pos = last_tail_pos
	segments[len(segments) - 1].align_to_grid(grid)

	grid_pos = segments[0].grid_pos

func setup_segments(segment_positions: Array):
	grid_pos = segment_positions[0]
	segment_holder = $Segments
	line = $Line2D
	for pos in segment_positions:
		var segment = SEGMENT_SCENE.instance()
		segment.grid_pos = pos
		segment.align_to_grid(grid, true)
		segments.append(segment)
		segment_holder.add_child(segment)
		line.add_point(segment.position)

func get_tail_pos() -> Vector2:
	return segments[len(segments) - 1].grid_pos