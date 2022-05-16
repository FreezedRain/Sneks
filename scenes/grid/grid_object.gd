## Any object existing on the grid
class_name GridObject extends Node2D

var grid
var grid_pos: Vector2

func setup(grid, grid_pos: Vector2 = Vector2.ZERO):
	self.grid = grid
	self.grid_pos = grid_pos
	align()
	grid.add_object(self)

func set_pos(new_pos: Vector2):
	grid.get_tile(grid_pos).remove_object(self)
	grid_pos = new_pos
	grid.get_tile(grid_pos).add_object(self)

func align():
	position = grid.grid_to_world(grid_pos)

func get_world_pos() -> Vector2:
	return grid.grid_to_world(grid_pos)
