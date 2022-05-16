## Any entity related to the grid
class_name Actor extends Node2D

var grid: Grid
var grid_pos: Vector2

func setup(grid: Grid):
	self.grid = grid

func can_move(direction: Vector2) -> bool:
	return false

func move(direction: Vector2):
	pass

func reverse():
	pass