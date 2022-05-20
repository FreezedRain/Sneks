class_name LevelDataHub extends LevelData

func parse_level():
	var lines = level_string.split("\n")	
	var size_data = lines[0].split(",")
	size.x = int(size_data[0])
	size.y = int(size_data[1])

	for x in range(size.x):
		var col = []
		for y in range(size.y):
			# col.append(lines[y + 1][x])
			col.append('O')
		level.append(col)

	var count = 0
	for x in range(1, size.x):
		level[x][0] = 'e%s' % count
		count += 1

	for y in range(1, size.y):
		level[size.x - 1][y] = 'e%s' % count
		count += 1

	for x in range(1, size.x):
		level[size.x - 1 - x][size.y - 1] = 'e%s' % count
		count += 1

	for y in range(1, size.y):
		level[0][size.y - 1 - y] = 'e%s' % count
		count += 1
		# for y in range(size.y):
		# 	if x == 0 or x == size.x - 1 or y == 0 or y == size.y - 1:
		# 		# level[x][y] = '#'
		# 		level[x][y] = 'e%s' % count
		# 		count += 1
			# elif x == 1 or x == size.x - 2 or y == 1 or y == size.y - 2:
				