extends Line2D

var prev: Array
var new: Array
var segment_indices: Array setget set_indices

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
	add_point(Vector2.ZERO)
	for i in range(1, len(prev)):
		add_point(new[i] + offset)
		if scale < 0.99 and prev[i] != new[i]:
			add_point(lerp(prev[i], new[i], scale) + offset)
