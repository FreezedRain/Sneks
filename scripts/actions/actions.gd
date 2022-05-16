class_name Actions extends Object

# Base class for all actions
class Action:
	func execute():
		pass

	func undo():
		pass

# Action that moves an actor towards a direction
class MoveAction extends Action:
	var actor: Object
	var direction: Vector2

	func _init(actor, direction):
		self.actor = actor
		self.direction = direction

	func execute():
		actor.move()