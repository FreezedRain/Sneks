extends Line2D

var prev: Array
var new: Array
var segment_indices: Array setget set_indices


func set_indices(value):
	segment_indices = value

# func get_segment_pos(segments: Array, i: int, snake_pos: Vector2):
# 	if i >= 0:
# 		return segments[i].position - snake_pos
# 	return Vector2.ZERO

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
		# var prev_dir = prev[i] - prev[i - 1]
		# var new_dir = new[i] - new[i - 1]
		if scale < 0.99 and prev[i] != new[i]:
			add_point(lerp(prev[i], new[i], scale) + offset)
			# if prev[i] != new[i] and prev_dir != new_dir:
			# 	add_point(lerp(prev[i], new[i], scale) + offset)
			# elif i == len(prev) - 1 or i == 1:
			# 	add_point(lerp(prev[i], new[i], scale) + offset)

	# material.set_shader_param("segment_count", get_point_count())
		# var new_pos
		# if i == len(prev) - 1:
		# 	new_pos = lerp(prev[i], new[i], scale)
		# 	if (new_pos - prev_pos).length() > 0:
				
		# 		add_point(new_pos + offset)
		# 		prev_pos = new_pos
		# else:
		# 	# var last_fixed = i == len(prev) - 2 and (new[i + 1] - prev[i + 1]) == Vector2.ZERO
		# 	if (new[i + 1] - prev[i + 1]) != Vector2.ZERO and (new[i] - prev[i]) != (new[i + 1] - prev[i + 1]):
		# 		print('corner %d' % i)
		# 		new_pos = prev[i]
		# 		if (new_pos - prev_pos).length() > 0:
		# 			add_point(new_pos + offset)
		# 			prev_pos = new_pos
			
	# print('Drawing [%d] points.' % get_point_count())

# func compute_segments(prev: Array, new: Array, offset: Vector2, scale: float):
# 	clear_points()

# 	add_point(Vector2.ZERO)
# 	var step = float(1) / len(prev)
	
# 	for i in range(len(prev)):
# 		var perc = float(i) * step
# 		# var adjusted_scale = clamp((scale - perc) / step, 0, 1)#
# 		var adjusted_scale = scale#clamp(scale * (1.1 - i / len(prev) * 0.1), 0, 1)
# 		# print(adjusted_scale)
# 		# print('scale for [%d]: [%s]' % [i, adjusted_scale])#
# 		if i > 0:
# 			# lerp(prev[i], new[i])
# 			add_point(lerp(prev[i], new[i], adjusted_scale) + offset)
# 		if scale < 0.99 and i < len(prev) - 1:
# 			var first_diff = new[i] - prev[i]
# 			var next_diff = new[i + 1] - prev[i + 1]
# 			if first_diff != next_diff:
# 				add_point(prev[i] + offset)
		
		# print('segment: [%d] [%s] -> [%s]' % [i, prev[i], new[i]])
		# print('next: [%d] [%s] -> [%s]' % [i, prev[i + 1], new[i + 1]])
		# var next_diff = new[i + 1] - prev[i + 1]
		# print('segment: [%d] first_diff: [%s], next_diff: [%s]' % [i, first_diff, next_diff])
		
			# print('corner %d' % i)
		# 	if i > 0:
		# 		add_point(lerp(prev[i], new[i], scale) + offset)
		# 	add_point(prev[i] + offset)
		# 	# add_point(lerp(new[i], new[i + 1], scale) + offset)
		# else:
		# 	# print('corner')
		# 	if i > 0:
		# 		add_point(lerp(prev[i], new[i], scale) + offset)

	

	# print(segments)
	# # Add corner segments
	# for i in range(len(segments)):
	# 	print('Added extra segment between [%s] and [%s]' % [get_segment_pos(segments, i, snake_pos), get_segment_pos(segments, i - 1, snake_pos)])
	# 	add_point(0.5 * (get_segment_pos(segments, i, snake_pos) + get_segment_pos(segments, i - 1, snake_pos)))
