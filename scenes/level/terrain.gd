extends Node2D

onready var dual_grid = $DualGrid

func update_tiles(grid):
	$DualGrid.update_tiles(grid)
	
	$Back.position = grid.size * grid.cell_size / 2
	$Back.scale = Vector2(grid.size.x + 1, grid.size.y + 1);
	
	$Top.position = grid.size * grid.cell_size / 2
	$Top.scale = Vector2(20, 20);
	
