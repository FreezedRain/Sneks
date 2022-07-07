class_name Snake extends Actor

signal hovered(snake)
signal unhovered(snake)

enum State {NORMAL, TIRED, HAPPY}
const STATE_TEXTURES = {
	State.NORMAL: preload("res://sprites/snake/eyes.png"),
	State.TIRED: preload("res://sprites/snake/eyes_tired.png"),
	State.HAPPY: preload("res://sprites/snake/eyes_happy.png")
}

const SEGMENT_SCENE = preload("res://scenes/snake/snake_segment.tscn")
const GHOST_SEGMENT_SCENE = preload("res://scenes/snake/snake_ghost_segment.tscn")
const LINE_SCENE = preload("res://scenes/snake/snake_line.tscn")

onready var visuals = $Visuals
onready var line_visuals = $Visuals/Lines
onready var sprite = $Visuals/Sprite
onready var highlight = $Visuals/Sprite/Highlight
onready var base_line = $Visuals/SnakeGhostLine
onready var last_tail_pos: Vector2 = get_tail_pos()
onready var before_last_tail_pos: Vector2 = last_tail_pos

onready var sfx_move = $SFXMove

var color setget set_color
var segments: Array
var segment_holder: Node2D setget set_segment_holder
var target_position: Vector2
var lerp_value: float = 0
var state = State.NORMAL setget set_state
var move_particle: String

var lines: Array

func _init():
	solid = true

func _ready():
	setup_lines()
	save_prev()
	save_new()
	move_particle = Grid.biome.move_particle
	set_highlight(false)

func setup_lines():
	var segment_indices = [0]
	for i in range(len(segments)):
		if not segments[i] is SnakeGhostSegment:
			segment_indices.append(i + 1)
		if segments[i] is SnakeGhostSegment or i == len(segments) - 1:
			if len(segment_indices) > 0:
				var line = LINE_SCENE.instance()
				line.set_indices(segment_indices.duplicate())
				segment_indices.clear()
				line_visuals.add_child(line)
				lines.append(line)
	segment_indices.clear()
	for i in range(len(segments) + 1):
		segment_indices.append(i)
	base_line.set_indices(segment_indices.duplicate())

func _process(delta):
	lerp_value = lerp(lerp_value, 1, delta * 16)
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)
	base_line.compute_segments(-position - visuals.position, lerp_value)
	for line in lines:
		line.compute_segments(-position - visuals.position, lerp_value)

func can_turn_corner(head_direction, turn_direction):
	var new_pos = pos + head_direction + turn_direction
	return Grid.is_free(new_pos)

func get_direction():
	return (position - segments[0].position).normalized()

func set_segment_holder(value):
	segment_holder = value

func save_prev():
	var segment_pos = [Vector2.ZERO]
	for segment in segments:
		segment_pos.append(segment.target_position)
	base_line.save_prev(segment_pos)
	for line in lines:
		line.save_prev(segment_pos)

func save_new():
	var segment_pos = [Vector2.ZERO]
	for segment in segments:
		segment_pos.append(segment.target_position)
	base_line.save_new(segment_pos)
	for line in lines:
		line.save_new(segment_pos)

func add_segment(ghost=false):
	var segment_scene = GHOST_SEGMENT_SCENE if ghost else SEGMENT_SCENE
	var segment = segment_scene.instance()
	segment.set_pos(last_tail_pos)
	segment.set_snake(self)
	segment.align()
	segments.append(segment)

	base_line.segment_indices.append(len(segments))
	base_line.prev.append(segment.position)
	base_line.new.append(segment.position)

	if not ghost:
		var last_line = lines[-1]
		if last_line.segment_indices.has(len(segments) - 1):
			last_line.segment_indices.append(len(segments))
			last_line.prev.append(segment.position)
			last_line.new.append(segment.position)
		else:
			# Create a new line
			var line = LINE_SCENE.instance()
			line.default_color = Globals.COLOR_RGB[self.color]
			line.set_indices([len(segments)])
			line.prev.append(Grid.grid_to_world(before_last_tail_pos))
			line.new.append(segment.position)
			line_visuals.add_child(line)
			lines.append(line)

func remove_segment():
	var segment = segments.pop_back()
	base_line.segment_indices.pop_back()
	base_line.prev.pop_back()
	base_line.new.pop_back()
	if not segment is SnakeGhostSegment:
		var last_line = lines[-1]
		if len(last_line.segment_indices) > 1:
			last_line.segment_indices.pop_back()
			last_line.prev.pop_back()
			last_line.new.pop_back()
		else:
			last_line.queue_free()
			lines.pop_back()
		
	segment.queue_free()
	segment._exit_tree()

func align_visuals():
	var previous_pos = position
	align()
	visuals.position = previous_pos - position
	lerp_value = 0

func set_highlight(enabled: bool):
	if enabled:
		# set_state(State.TIRED)
		highlight.show()
	else:
		# set_state(State.NORMAL)
		highlight.hide()

func set_state(value):
	state = value
	if not sprite:
		yield(self, "ready")
	sprite.texture = STATE_TEXTURES[state]

func set_color(value):
	color = value
	if not base_line:
		yield(self, "ready")
	for line in lines:
		line.default_color = Globals.COLOR_RGB[self.color]

func get_tail_pos() -> Vector2:
	return segments[len(segments) - 1].pos

func get_next_segment_pos(idx: int, pos: Vector2, new_pos: Vector2):
	if idx == 0:
		return new_pos
	if idx == 1:
		return pos
	return segments[idx - 2].pos

func is_segment_solid(idx: int):
	if idx == 0:
		return true
	return segments[idx - 1].solid

func can_move(direction: Vector2) -> bool:
	var new_pos = pos + direction
	if new_pos == segments[0].pos:
		return false
	if not Grid.is_free(new_pos):
		return false
	for i in range(len(segments) + 1):
		var i_next_pos = get_next_segment_pos(i, pos, new_pos)
		if is_segment_solid(i):
			for obj in Grid.get_tile(i_next_pos).objects:
				if obj.solid and not segments.has(obj) and obj != self:
					return false
		for j in range(len(segments) + 1):
			if i == j:
				continue
			var j_next_pos = get_next_segment_pos(j, pos, new_pos)
			if i_next_pos == j_next_pos and is_segment_solid(i) and is_segment_solid(j):
				return false
	
	return true

func move(direction: Vector2):
	var move_pos = pos + direction

	var new_tail_pos = get_tail_pos()
	if new_tail_pos != last_tail_pos:
		before_last_tail_pos = last_tail_pos
	last_tail_pos = new_tail_pos
	save_prev()

	for i in range(len(segments) - 1, 0, -1):
		segments[i].set_pos(segments[i - 1].pos)
		segments[i].align()

	# Update segments
	segments[0].set_pos(pos)
	segments[0].align()
	
	# Update head
	set_pos(move_pos)
	align_visuals()

	save_new()


	var dir = (base_line.prev[-1] - base_line.new[-1]).normalized()
	ParticleManager.spawn(move_particle, base_line.prev[-1] - dir * 16, dir.angle())
	
	if direction == Vector2.UP:
		sfx_move.pitch_scale = 0.9
	if direction == Vector2.RIGHT:
		sfx_move.pitch_scale = 0.8
	if direction == Vector2.LEFT:
		sfx_move.pitch_scale = 0.7
	if direction == Vector2.DOWN:
		sfx_move.pitch_scale = 0.6
	sfx_move.play()

func reverse_move(last_tail_pos: Vector2):
	set_pos(segments[0].pos)
	align_visuals()
	
	for i in range(len(segments) - 1):
		segments[i].set_pos(segments[i + 1].pos)
		segments[i].align()

	segments[len(segments) - 1].set_pos(last_tail_pos)
	segments[len(segments) - 1].align()

	before_last_tail_pos = last_tail_pos
	last_tail_pos = get_tail_pos()
	save_prev()
	save_new()
	lerp_value = 1.0

func setup_segments(segment_positions: Array, segment_ghosts: Array) -> Array:
	set_pos(segment_positions[0])
	align()
	
	for i in range(len(segment_positions)):
		if i == 0:
			continue
		var segment_scene = GHOST_SEGMENT_SCENE if segment_ghosts[i] else SEGMENT_SCENE
		var segment = segment_scene.instance()
		segment.set_pos(segment_positions[i])
		segment.set_snake(self)
		segment.align()
		segments.append(segment)
		
	return segments

func _on_HoverArea_mouse_entered():
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	emit_signal("unhovered", self)
