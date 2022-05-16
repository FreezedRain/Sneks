## Stores information about the tile
class_name Tile extends Object

var grid
var pos: Vector2
var solid: bool
var objects: Array

func _init(grid, pos: Vector2, solid: bool):
	self.grid = grid
	self.pos = pos
	self.solid = solid

func add_object(object: GridObject):
	objects.append(object)

func remove_object(object: GridObject):
	objects.erase(object)
