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

onready var visuals = $Visuals
onready var sprite = $Visuals/Sprite
onready var highlight = $Visuals/Sprite/Highlight
onready var line = $Visuals/SnakeLine
onready var last_tail_pos: Vector2 = get_tail_pos()

onready var sfx_move = $SFXMove

var color setget set_color
var segments: Array
var segment_holder: Node2D setget set_segment_holder
var target_position: Vector2
var lerp_value: float = 0
var state = State.NORMAL setget set_state
var move_particle: String

# Segment calculations
var prev: Array
var new: Array

func _init():
	solid = true

func _ready():
	# line.init_points(segments, position)
	line.save_prev(segments, position)
	line.save_new(segments, position)
	move_particle = Grid.biome.move_particle

func _process(delta):
	lerp_value = lerp(lerp_value, 1, delta * 16)
	visuals.position = lerp(visuals.position, Vector2.ZERO, delta * 16)
	sprite.rotation = lerp_angle(sprite.rotation, (position - segments[0].position).angle() - PI * 0.5, delta * 16)

	line.compute_segments(-position - visuals.position, lerp_value)
	# for i in range(len(segments)):
	# 	# var segment_pos = segments[i].position - position - visuals.position
	# 	# Odd segments between first and last
	# 	# if i % 2 == 1 and i < len(segments) - 1:
	# 	# print(i)
	# 	# print('pos_grid: [%s]' % (segments[i].target_position))
	# 	# print('pos_normal: [%s]' % (segments[i].position))

	# 	line.set_point_position(i * 2 + 1, segments[i].get_world_pos() - position - visuals.position)
	# 	line.set_point_position(i * 2 + 2, segments[i].position - position - visuals.position)

func set_segment_holder(value):
	segment_holder = value

func override_head_position(pos: Vector2):
	visuals.position = pos

func add_segment(ghost=false):
	var segment_scene = GHOST_SEGMENT_SCENE if ghost else SEGMENT_SCENE
	var segment = segment_scene.instance()
	# segment.set_segment_percent(1.0)
	segment.set_pos(last_tail_pos)
	segment.set_snake(self)
	segment.align()
	segments.append(segment)

	# var dir = (segment.position - line.prev[len(line.prev) - 1]).normalized()
	line.prev.append(segment.position)
	line.new.append(segment.position)
	# line.prev[len(line.prev) - 1] = segment.position
	# line.new[len(line.new) - 1] = segment.position
	segment_holder.add_child(segment)

	var ghost_start = 0
	var ghost_end = 0
	for i in range(len(segments)):
		if segments[i] is SnakeGhostSegment:
			if ghost_start == 0:
				ghost_start = i + 1
				ghost_end = i + 2
			else:
				ghost_end = i + 2
	line.set_ghost_points(ghost_start, ghost_end)
		

func remove_segment():
	var segment = segments.pop_back()
	segment.queue_free()
	line.prev.pop_back()
	line.new.pop_back()

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
	if not Grid.is_free(new_pos):
		return false
	for i in range(len(segments) + 1):
		var i_next_pos = get_next_segment_pos(i, pos, new_pos)
		for j in range(len(segments) + 1):
			if i == j:
				continue
			var j_next_pos = get_next_segment_pos(j, pos, new_pos)
			if i_next_pos == j_next_pos and is_segment_solid(i) and is_segment_solid(j):
				# print('[%d] into [%d]' % [i, j])
				return false
			# if j != i - 1 and segments[j].pos == next_pos and segments[j].solid and segments[i].solid:
			# 	print('Moving segment [%d] into [%d]' % [i, j])
			# 	return false
			# if j > 0 and segments[j].pos == new_pos and segments[j].solid:
			# 	return false
	# for j in range(1, len(segments)):
	# 	if segments[j - 1].pos == new_pos and segments[j].solid:
	# 		print('Head into solid')
	# 		return false
	return true

func move(direction: Vector2):
	var move_pos = pos + direction

	last_tail_pos = get_tail_pos()
	line.save_prev(segments, position)

	for i in range(len(segments) - 1, 0, -1):
		segments[i].set_pos(segments[i - 1].pos)
		segments[i].align()

	# Update segments
	segments[0].set_pos(pos)
	segments[0].align()
	
	# Update head
	set_pos(move_pos)
	align_visuals()

	line.save_new(segments, position)

	var dir = (line.prev[-1] - line.new[-1]).normalized()
	ParticleManager.spawn(move_particle, line.prev[-1] - dir * 16, dir.angle())

	# for i in range(len(prev) - 1):
	# 	var first_diff = new[i] - prev[i]
	# 	var next_diff = new[i + 1] - prev[i + 1]
	# 	# print('segment: [%d] [%s] -> [%s]' % [i, prev[i], new[i]])
	# 	# print('next: [%d] [%s] -> [%s]' % [i, prev[i + 1], new[i + 1]])
	# 	# var next_diff = new[i + 1] - prev[i + 1]
	# 	print('segment: [%d] first_diff: [%s], next_diff: [%s]' % [i, first_diff, next_diff])
	# 	if first_diff != next_diff:
	# 		print('corner')
	
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

	last_tail_pos = get_tail_pos()
	line.save_prev(segments, position)
	line.save_new(segments, position)

func setup_segments(segment_positions: Array) -> Array:
	set_pos(segment_positions[0])
	align()
	
	var count = 0
	for pos in segment_positions:
		count += 1
		if count == 1:
			continue
		var segment = SEGMENT_SCENE.instance()
		# segment.set_segment_percent(count/segment_positions.size())
		# var offset = Vector2(randi() % 3, randi() % 3)
		# offset.x = clamp(offset.x, 0, Grid.size.x - 1)
		# offset.y = clamp(offset.y, 0, Grid.size.y - 1)
		segment.set_pos(pos)
		segment.set_snake(self)
		segment.align()
		segments.append(segment)
		
	return segments

func _on_HoverArea_mouse_entered():
	emit_signal("hovered", self)

func _on_HoverArea_mouse_exited():
	emit_signal("unhovered", self)
