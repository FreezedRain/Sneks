extends Node2D

const halftileh = Vector2(0.5, 0)
const halftilev = Vector2(0, 0.5)

var grid: Grid
var tiles: Array

onready var tilemap = $Tilemap

func setup(grid: Grid):
	self.grid = grid

func load_data(level_data: LevelData):
	for x in range(level_data.size.x):
		var column = []
		for y in range(level_data.size.y):
			var tile = level_data.level[x][y] == '#'
			column.append(tile)
		tiles.append(column)
	update_tiles()

func set_tile(pos: Vector2, value: bool) -> bool:
	if not grid.in_bounds(pos):
		return false
	tiles[pos.x][pos.y] = value
	update_tiles()
	return true

func get_tile(pos: Vector2) -> bool:
	if grid.in_bounds(pos):
		return tiles[pos.x][pos.y]
	return true

func update_tiles():
	for i in range(0, grid.size.x + 1):
		for j in range(0, grid.size.y + 1):
			var pos = Vector2(i - 0.5, j - 0.5)
			
			var n = false
			var s = false
			var e = false
			var w = false
			var ne = false
			var se = false
			var sw = false
			var nw = false
			
			if get_tile(pos + halftilev + halftileh) or get_tile(pos + halftilev - halftileh):
				s = true
			if get_tile(pos - halftilev + halftileh) or get_tile(pos - halftilev - halftileh):
				n = true
			if get_tile(pos + halftileh + halftilev) or get_tile(pos + halftileh - halftilev):
				e = true
			if get_tile(pos - halftileh + halftilev) or get_tile(pos - halftileh - halftilev):
				w = true
			if get_tile(pos + halftileh + halftilev):
				se = true
			if get_tile(pos - halftileh + halftilev):
				sw = true
			if get_tile(pos + halftileh - halftilev):
				ne = true
			if get_tile(pos - halftileh - halftilev):
				nw = true
				
			#FULL
			if (n and s and w and e and nw and ne and sw and se): tilemap.set_cell(i, j, 14)
			
			#FLATS
			elif (n and s and !w and e): tilemap.set_cell(i, j, 13)
			elif (n and s and w and !e): tilemap.set_cell(i, j, 3)
			elif (!n and s and w and e): tilemap.set_cell(i, j, 11)
			elif (n and !s and w and e): tilemap.set_cell(i, j, 5)
			
			#CORNERS
			elif (n and !s and !w and e): tilemap.set_cell(i, j, 4)
			elif (!n and s and !w and e): tilemap.set_cell(i, j, 9)
			elif (n and !s and w and !e): tilemap.set_cell(i, j, 7)
			elif (!n and s and w and !e): tilemap.set_cell(i, j, 12)
			
			#ANTICORNERS
			elif (n and s and w and e and se and ne and nw and !sw): tilemap.set_cell(i, j, 2)
			elif (n and s and w and e and se and ne and !nw and sw): tilemap.set_cell(i, j, 17)
			elif (n and s and w and e and !se and ne and nw and sw): tilemap.set_cell(i, j, 15)
			elif (n and s and w and e and se and !ne and nw and sw): tilemap.set_cell(i, j, 10)
			
			#WEIRDS
			elif (n and s and w and e and se and !ne and nw and !sw): tilemap.set_cell(i, j, 16)
			elif (n and s and w and e and !se and ne and !nw and sw): tilemap.set_cell(i, j, 6)
			
			else: tilemap.set_cell(i, j, 8)

# func update_tiles(grid):
# 	dual_grid.update_tiles(grid)
	
# 	$Back.position = grid.size * grid.cell_size / 2
# 	$Back.scale = Vector2(grid.size.x + 1, grid.size.y + 1);
	
# 	$Top.position = grid.size * grid.cell_size / 2
	
