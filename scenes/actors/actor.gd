## Any entity related to the grid
class_name Actor extends Node2D

var grid: Grid
var grid_pos: Vector2

func setup(grid: Grid):
	self.grid = grid
