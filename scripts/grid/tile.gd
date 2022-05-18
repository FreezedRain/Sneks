## Stores information about the tile
class_name Tile extends Object

var pos: Vector2
var solid: bool
var objects: Array

func _init(pos: Vector2, solid: bool):
	self.pos = pos
	self.solid = solid

func add_object(object: GridObject):
	objects.append(object)

func remove_object(object: GridObject):
	objects.erase(object)
