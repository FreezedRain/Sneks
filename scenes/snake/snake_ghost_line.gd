extends Line2D

var prev: Array
var new: Array
var indices: Array setget set_indices

onready var shadow = $Shadow
onready var highlight = $ViewportContainer/Viewport/Highlight

# func clear_points():
# 	.clear_points()
# 	shadow.clear_points()
# 	highlight.clear_points()

# func add_point(position: Vector2, at_position: int = -1):
# 	.add_point(position, at_position)
# 	shadow.add_point(position + Vector2.UP * SHADOW_OFFSET)
# 	highlight.add_point(position + Vector2.UP * HIGHLIGHT_OFFSET)

# func set_point_position(i: int, position: Vector2):
# 	.set_point_position(i, position)
# 	shadow.set_point_position(i, position + Vector2.UP * SHADOW_OFFSET)
# 	highlight.set_point_position(i, position + Vector2.UP * HIGHLIGHT_OFFSET)

func set_indices(value: Array):
	indices = value

func save_prev(segments: Array):#, head_pos: Vector2):
	prev.clear()
	for idx in indices:
		prev.append(segments[idx].target_position)

func copy_prev(main_prev: Array, offset: int = 1):#, head_pos: Vector2):
	prev.clear()
	for idx in indices:
		prev.append(main_prev[idx + offset])

func copy_prev_single(main_prev: Array):#, head_pos: Vector2):
	var prev_pos = prev[0]
	prev.clear()
	for idx in indices:
		prev.append(prev_pos)

func save_new(segments: Array):#, head_pos: Vector2):
	new.clear()
	for idx in indices:
		new.append(segments[idx].target_position)

# func save_prev_offset(segments: Array, head_pos: Vector2):
# 	prev.clear()
# 	prev.append(head_pos)
# 	prev.append(head_pos)
# 	for i in range(len(segments) - 1):
# 		prev.append(segments[i].target_position)
	

# func init_points(segments: Array, snake_pos: Vector2):
# 	add_point(Vector2.ZERO)

# 	var prev_pos = Vector2.ZERO

# 	for i in range(len(segments)):
# 		var segment_pos = segments[i].position - snake_pos
# 		# print('Added segment at [%s].' % (0.5 * (segment_pos + prev_pos)))
# 		add_point(0.5 * (segment_pos + prev_pos))
# 		# print('Added segment at [%s].' % segment_pos)
# 		add_point(segment_pos)
		
# 		prev_pos = segment_pos

func compute_segments(offset: Vector2, scale: float):
	clear_points()
	# add_point(Vector2.ZERO)
	# if len(prev) == 1:
	# 	var grid_offset = (new[0] - prev[0]) 
	# 	add_point(new[0] + grid_offset + offset)
	# 	add_point(prev[0] + grid_offset + offset)
	# 	return

	for i in range(len(prev)):
		# print('hello')
		if i == len(prev) - 1:
			if len(prev) == 1:
				# print(new[i], prev[i])
				var diff = (new[i] - prev[i])
				if diff != Vector2.ZERO:
					add_point(lerp(prev[i], new[i], scale) - diff.normalized() + offset)
				else:
					add_point(lerp(prev[i], new[i], scale) - Vector2(0.01, 0.01) + offset)
				add_point(lerp(prev[i], new[i], scale) + offset)
			else:
				add_point(new[i] + offset)
				if scale < 0.99 and prev[i] != new[i]:
					add_point(lerp(prev[i], new[i], scale) + offset)
		elif i == 0:
			# if len(prev) == 1:
			# 	add_point(new[i] - (new[i] - prev[i]).normalized() + offset)
			add_point(lerp(prev[i], new[i], scale) + offset)
		else:
			add_point(new[i] + offset)
			if scale < 0.99 and prev[i] != new[i]:
				add_point(lerp(prev[i], new[i], scale) + offset)
		# if scale < 0.99 and prev[i] != new[i]:
		# 	add_point(lerp(prev[i], new[i], scale) + offset)
		# elif len(prev) == 1:
		# 	add_point(new[i] - (new[i] - prev[i]).normalized() + offset)
		# elif len(prev) == 1:
		# 	add_point(prev[i] + (new[i] - prev[i]) * 0.5 + offset)

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