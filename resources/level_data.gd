class_name LevelData extends Resource

export (String) var name
export (String, MULTILINE) var level_string
export (String, MULTILINE) var snakes_string

var size: Vector2
var level: Array
var snakes: Array

func _init(name = "test", level_string = "", snakes_string = ""):
	self.name = name
	self.level_string = level_string
	self.snakes_string = snakes_string

func parse():
	parse_level()
	parse_snakes()

func parse_level():
	var lines = level_string.split("\n")	
	var size_data = lines[0].split(",")
	size.x = int(size_data[0])
	size.y = int(size_data[1])
	
	for x in range(size.x):
		var col = []
		for y in range(size.y):
			col.append(lines[y + 1][x])
		level.append(col)

func parse_snakes():
	var lines = snakes_string.split("\n")
	for line in lines:
		var segment_data = line.substr(1).split("-")
		var segments = []
		var color = Globals.COLORS_LETTERS[line[0]]
		for pos_line in segment_data:
			var pos_data = pos_line.split("/")
			var pos = Vector2(int(pos_data[0]), int(pos_data[1]))
			segments.append(pos)
		snakes.append(SnakeData.new(segments, color))

class SnakeData:
	var segments: Array
	var color

	func _init(segments: Array, color):
		self.segments = segments
		self.color = color