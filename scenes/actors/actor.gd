## Any entity moving on the grid
class_name Actor extends GridObject

func can_move(direction: Vector2) -> bool:
	return false

func move(direction: Vector2):
	pass

func reverse():
	pass