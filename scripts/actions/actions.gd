class_name Actions extends Object

# Base class for all actions
class Action:
	func is_allowed() -> bool:
		return true

	func execute():
		pass

	func undo():
		pass

# Action that moves an actor towards a direction
class MoveAction extends Action:
	var actor: Actor
	var direction: Vector2

	func _init(actor, direction):
		self.actor = actor
		self.direction = direction

	func is_allowed() -> bool:
		return direction != Vector2.ZERO and actor.can_move(direction)

	func execute():
		actor.move(direction)

	func undo():
		actor.move(-direction)

class SnakeMoveAction extends Action:
	var snake: Snake
	var direction: Vector2
	var tail_pos: Vector2

	func _init(snake, direction):
		self.snake = snake
		self.direction = direction
		self.tail_pos = snake.get_tail_pos()

	func is_allowed() -> bool:
		return direction != Vector2.ZERO and snake.can_move(direction)

	func execute():
		snake.move(direction)

	func undo():
		snake.reverse_move(tail_pos)
