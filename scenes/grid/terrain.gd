extends Node2D

const halftileh = Vector2(0.5, 0)
const halftilev = Vector2(0, 0.5)

onready var tilemap = $Tilemap

func update_tiles():
	position = Grid.bounds.position
	for i in range(0, Grid.size.x + 1):
		for j in range(0, Grid.size.y + 1):
			var pos = Vector2(i - 0.5, j - 0.5)
			
			var n = false
			var s = false
			var e = false
			var w = false
			var ne = false
			var se = false
			var sw = false
			var nw = false
			
			if Grid.is_solid(pos + halftilev + halftileh) or Grid.is_solid(pos + halftilev - halftileh):
				s = true
			if Grid.is_solid(pos - halftilev + halftileh) or Grid.is_solid(pos - halftilev - halftileh):
				n = true
			if Grid.is_solid(pos + halftileh + halftilev) or Grid.is_solid(pos + halftileh - halftilev):
				e = true
			if Grid.is_solid(pos - halftileh + halftilev) or Grid.is_solid(pos - halftileh - halftilev):
				w = true
			if Grid.is_solid(pos + halftileh + halftilev):
				se = true
			if Grid.is_solid(pos - halftileh + halftilev):
				sw = true
			if Grid.is_solid(pos + halftileh - halftilev):
				ne = true
			if Grid.is_solid(pos - halftileh - halftilev):
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
			
	$Back.position = Grid.bounds.size * 0.5
	$Back.scale = Vector2(Grid.size.x + 1, Grid.size.y + 1);
	
	$Top.position = Grid.bounds.size * 0.5
	$Top.scale = Vector2(20, 20);
			
	

## func update_tiles(Grid):
# 	dual_Grid.update_tiles(Grid)
#
# 	$Back.position = Grid.size * Grid.cell_size / 2
# 	$Back.scale = Vector2(Grid.size.x + 1, Grid.size.y + 1);
#
# 	$Top.position = Grid.size * Grid.cell_size / 2
	
