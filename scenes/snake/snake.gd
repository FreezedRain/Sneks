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
const GHOST_LINE_SCENE = preload("res://scenes/snake/snake_ghost_line.tscn")

onready var visuals = $Visuals
onready var sprite = $Visuals/Sprite
onready var highlight = $Visuals/Sprite/Highlight
onready var line = $Visuals/SnakeLine
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

var ghost_lines: Array # line: indices

func _init():
	solid = true

func _ready():
	line.save_prev(segments, position)
	line.save_new(segments, position)
	move_particle = Grid.biome.move_particle
	setup_ghost_segments()
	if len(ghost_lines) > 0:
		z_index = 0

func _process(delta):
	lerp_value = lerp(lerp_value, 1, delta * 16)
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)

	line.compute_segments(-position - visuals.position, lerp_value)
	for ghost_line in ghost_lines:
		ghost_line.compute_segments(-position - visuals.position, lerp_value)

func set_segment_holder(value):
	segment_holder = value

func override_head_position(pos: Vector2):
	visuals.position = pos

func save_prev():
	line.save_prev(segments, position)
	for ghost_line in ghost_lines:
		ghost_line.save_prev(segments)

func save_new():
	line.save_new(segments, position)
	for ghost_line in ghost_lines:
		ghost_line.save_new(segments)

func setup_ghost_segments():
	var ghost_indices = []
	for i in range(len(segments)):
		if segments[i] is SnakeGhostSegment:
			ghost_indices.append(i)
		if not (segments[i] is SnakeGhostSegment) or i == len(segments) - 1:
			if len(ghost_indices) > 0:
				# print('Adding line with indices: [%s]' % ghost_indices)
				var ghost_line = GHOST_LINE_SCENE.instance()
				ghost_line.set_indices(ghost_indices.duplicate())
				visuals.add_child(ghost_line)
				ghost_lines.append(ghost_line)
				ghost_indices.clear()
	for ghost_line in ghost_lines:
		ghost_line.copy_prev(line.prev)
		ghost_line.save_new(segments)

func add_segment(ghost=false):
	var segment_scene = GHOST_SEGMENT_SCENE if ghost else SEGMENT_SCENE
	var segment = segment_scene.instance()
	segment.set_pos(last_tail_pos)
	segment.set_snake(self)
	segment.align()
	segments.append(segment)

	# var dir = (segment.position - line.prev[len(line.prev) - 1]).normalized()
	if ghost:
		line.prev.append(Grid.grid_to_world(before_last_tail_pos))
	else:
		line.prev.append(segment.position)
	line.new.append(segment.position)
	# line.prev[len(line.prev) - 1] = segment.position
	# line.new[len(line.new) - 1] = segment.position
	segment_holder.add_child(segment)

	# S S S G G
	# 0 1 2 3 4
	# ghost lines - 1
	# ghost indices [3, 4]

	for ghost_line in ghost_lines:
		ghost_line.queue_free()
	ghost_lines.clear()

	setup_ghost_segments()

	if len(ghost_lines) > 0:
		z_index = 0

func remove_segment():
	var segment = segments.pop_back()
	if segment is SnakeGhostSegment and len(ghost_lines) > 0:
		var last_line = ghost_lines[-1]
		last_line.indices.pop_back()
		last_line.prev.pop_back()
		last_line.new.pop_back()
		if len(last_line.indices) == 0:
			last_line.queue_free()
			ghost_lines.pop_back()
	segment.queue_free()
	line.prev.pop_back()
	line.new.pop_back()

	if len(ghost_lines) == 0:
		z_index = 1

func align_visuals():
	var previous_pos = position
	align()
	visuals.position = previous_pos - position
	lerp_value = 0

func set_highlight(enabled: bool):
	if enabled:
		highlight.show()
	else:
		highlight.hide()

func set_state(value):
	state = value
	if not sprite:
		yield(self, "ready")
	sprite.texture = STATE_TEXTURES[state]

func set_color(value):
	color = value
	if not line:
		yield(self, "ready")
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

	var dir = (line.prev[-1] - line.new[-1]).normalized()
	ParticleManager.spawn(move_particle, line.prev[-1] - dir * 16, dir.angle())
	
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

	# line.save_prev(segments, position)
	# for ghost_line in ghost_lines:
	# 	if len(ghost_line.indices) == 1:
	# 		ghost_line.copy_prev(line.prev, 0)
	# 	else:
	# 		ghost_line.save_prev(segments)
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
		# segment.set_segment_percent(count/segment_positions.size())
		# var offset = Vector2(randi() % 3, randi() % 3)
		# offset.x = clamp(offset.x, 0, Grid.size.x - 1)
		# offset.y = clamp(offset.y, 0, Grid.size.y - 1)
		segment.set_pos(segment_positions[i])
		segment.set_snake(self)
		segment.align()
		segments.append(segment)
		
	return segments

func _on_HoverArea_mouse_entered():
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	emit_signal("unhovered", self)
