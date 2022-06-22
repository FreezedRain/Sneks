extends Line2D

const SHADOW_OFFSET = -8
const HIGHLIGHT_OFFSET = 16

var prev: Array
var new: Array
var segment_indices: Array setget set_indices

onready var shadow = $Shadow
onready var highlight = $ViewportContainer/Viewport/Highlight

func clear_points():
	.clear_points()
	shadow.clear_points()
	highlight.clear_points()

func add_point(position: Vector2, at_position: int = -1):
	.add_point(position, at_position)
	shadow.add_point(position + Vector2.UP * SHADOW_OFFSET)
	highlight.add_point(position + Vector2.UP * HIGHLIGHT_OFFSET)

func set_point_position(i: int, position: Vector2):
	.set_point_position(i, position)
	shadow.set_point_position(i, position + Vector2.UP * SHADOW_OFFSET)
	highlight.set_point_position(i, position + Vector2.UP * HIGHLIGHT_OFFSET)

func set_indices(value):
	segment_indices = value

func save_prev(segments: Array):
	prev.clear()
	for idx in segment_indices:
		prev.append(segments[idx])

func save_new(segments: Array):
	new.clear()
	for idx in segment_indices:
		new.append(segments[idx])

func save_prev_offset(segments: Array):
	prev.clear()
	prev.append(segments[0])
	prev.append(segments[0])
	for i in range(len(segments) - 2):
		prev.append(segments[i].target_position)

func compute_segments(offset: Vector2, scale: float):
	clear_points()
	if len(prev) == 1:
		for i in range(len(prev)):
			var new_offset = offset if new[i] != Vector2.ZERO else Vector2.ZERO
			var diff = (new[i] - prev[i])
			if diff != Vector2.ZERO:
				add_point(lerp(prev[i], new[i], scale) - diff.normalized() + new_offset)
			else:
				add_point(lerp(prev[i], new[i], scale) - Vector2(0.01, 0.01) + new_offset)
			add_point(lerp(prev[i], new[i], scale) + new_offset)
	else:
		for i in range(len(prev)):
			if segment_indices[i] == 0:
				add_point(new[i])
				continue
			if i != 0:
				add_point(new[i] + offset)
			if scale < 0.99 and prev[i] != new[i]:
				add_point(lerp(prev[i], new[i], scale) + offset)
			elif i == 0:
				add_point(new[i] + offset)
