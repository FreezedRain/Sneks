class_name Snake extends Actor

signal hovered(snake)
signal unhovered(snake)

const SEGMENT_SCENE = preload("res://scenes/actors/snake/snake_segment.tscn")

onready var visuals = $Visuals
onready var sprite = $Visuals/Sprite
onready var highlight = $Visuals/Sprite/Highlight

var color setget set_color
var line: Line2D
var line_highlight: Line2D
var line_shadow: Line2D
var segments: Array
var target_position: Vector2

func _init():
	solid = true

func _ready():
	pass

func _process(delta):
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	if len(segments) > 0:
		sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)
		for i in range(len(segments)):
			line.set_point_position(i + 1, segments[i].position - position - visuals.position)
			line_shadow.set_point_position(i + 1, segments[i].position - position - visuals.position + Vector2.DOWN * 8)
			line_highlight.set_point_position(i + 1, segments[i].position - position - visuals.position + Vector2.UP * 16)


func align_visuals():
	var previous_pos = position
	align()
	visuals.position = previous_pos - position

func set_highlight(enabled: bool):
	if enabled:
		highlight.show()
	else:
		highlight.hide()

func set_color(value):
	color = value
	line.default_color = Globals.COLOR_RGB[self.color]

func get_tail_pos() -> Vector2:
	return segments[len(segments) - 1].pos

func can_move(direction: Vector2) -> bool:
	if not Grid.is_free(pos + direction):
		return false
	return true

func move(direction: Vector2):
	var move_pos = pos + direction

	for i in range(len(segments) - 1, 0, -1):
		segments[i].set_pos(segments[i - 1].pos)
		segments[i].align_visuals()

	# Update segments
	segments[0].set_pos(pos)
	segments[0].align_visuals()
	
	# Update head
	set_pos(move_pos)
	align_visuals()

func reverse_move(last_tail_pos: Vector2):
	set_pos(segments[0].pos)
	align_visuals()
	
	for i in range(len(segments) - 1):
		segments[i].set_pos(segments[i + 1].pos)
		segments[i].align_visuals()

	segments[len(segments) - 1].set_pos(last_tail_pos)
	segments[len(segments) - 1].align_visuals()

func setup_segments(segment_positions: Array) -> Array:
	set_pos(segment_positions[0])
	align()
	line = $Visuals/Line2D
	line_highlight = $Visuals/Line2Dhighlight
	line_shadow = $Visuals/Line2Dshadow
	
	line.add_point(Vector2.ZERO)
	line_shadow.add_point(Vector2.ZERO + Vector2.DOWN * 8)
	line_highlight.add_point(Vector2.ZERO + Vector2.UP * 16)
	var count = 0
	for pos in segment_positions:
		count += 1
		if count == 1:
			continue
		var segment = SEGMENT_SCENE.instance()
		segment.set_segment_percent(count/segment_positions.size())
		segment.set_pos(pos)
		segment.set_snake(self)
		segment.align()
		segments.append(segment)
		line.add_point(segment.position - position)
		line_shadow.add_point(segment.position - position + Vector2.DOWN * 8)
		line_highlight.add_point(segment.position - position + Vector2.UP * 16)
		
	return segments

func _on_HoverArea_mouse_entered():
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	emit_signal("unhovered", self)
