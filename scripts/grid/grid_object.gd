## Any object existing on the grid
class_name GridObject extends Node2D

var pos: Vector2 setget set_pos
var solid: bool = false

func set_pos(value: Vector2):
	Grid.get_tile(pos).remove_object(self)
	pos = value
	Grid.get_tile(pos).add_object(self)

func align():
	position = Grid.grid_to_world(pos)

func get_world_pos() -> Vector2:
	return Grid.grid_to_world(pos)

func _exit_tree():
	var tile = Grid.get_tile(pos)
	if tile:
		tile.remove_object(self)
