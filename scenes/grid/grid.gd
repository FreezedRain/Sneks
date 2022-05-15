extends Node2D

var size = Vector2(10, 8)
var cell_size = 64

var tiles = []

export(String, MULTILINE) var level = ""

func _ready():
	
	var lines = level.split("\n")
	
	print(lines.size())
	
	size.x = int(lines[0])
	size.y = int(lines[1])
	
	for x in range(size.x):
		tiles.append([])
		for y in range(size.y):
			if lines[y+2][x] == '-':
				tiles[x].append(0)
			else:
				tiles[x].append(1)
			
		
	$DualGrid.update_tiles(self)	

func _draw():
	
	return;
	
	for i in range(0, size.x + 1):
		draw_line(Vector2(i*cell_size, 0), Vector2(i*cell_size, size.y * cell_size), Color.white);
		for j in range(0, size.y + 1):
			draw_line(Vector2(0, j*cell_size), Vector2(size.x*cell_size, j * cell_size), Color.white);

func _process(delta):
	update();

func position_to_pos(pos):
	
	pos -= Vector2(cell_size/2, cell_size/2)
	
	return Vector2(round((pos.x - position.x) / float(cell_size)), round((pos.y - position.y) / float(cell_size)))

func is_pos_in_bounds(pos):
	
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y
	
func toggle_tile(pos):
	tiles[pos.x][pos.y] = 1 - tiles[pos.x][pos.y]
	
	$DualGrid.update_tiles(self)

func _input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		var mpos = get_viewport().get_mouse_position();
		print(mpos)
		var pos = position_to_pos(mpos)
		
		if is_pos_in_bounds(pos):
			toggle_tile(pos)
		
func get_tile(pos):
	if is_pos_in_bounds(pos):
		return tiles[pos.x][pos.y]
	return 1
